import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class ConcatenationAllWordsStep {
  final int offset;
  final int left;
  final int right;
  final String currentWord;
  final String windowSub;
  final Map<String, int> windowMap;
  final Map<String, int> targetMap;
  final int count;
  final List<int> result;
  final String decision; // 'init', 'expand', 'shrink_left', 'match_found', 'reset_window', 'finished'
  final int activeLine;
  final String actionEn;
  final String actionBn;
  final String reasonEn;
  final String reasonBn;

  const ConcatenationAllWordsStep({
    required this.offset,
    required this.left,
    required this.right,
    required this.currentWord,
    required this.windowSub,
    required this.windowMap,
    required this.targetMap,
    required this.count,
    required this.result,
    required this.decision,
    required this.activeLine,
    required this.actionEn,
    required this.actionBn,
    required this.reasonEn,
    required this.reasonBn,
  });
}

class ConcatenationAllWordsDetailScreen extends StatefulWidget {
  const ConcatenationAllWordsDetailScreen({super.key});

  @override
  State<ConcatenationAllWordsDetailScreen> createState() =>
      _ConcatenationAllWordsDetailScreenState();
}

class _ConcatenationAllWordsDetailScreenState
    extends State<ConcatenationAllWordsDetailScreen>
    with SingleTickerProviderStateMixin {
  bool _isEnglish = true;
  late TabController _tabController;

  // Custom Input State
  final TextEditingController _sController = TextEditingController(text: "barfoothefoobarman");
  final TextEditingController _wordsController = TextEditingController(text: "foo, bar");
  String _s = "barfoothefoobarman";
  List<String> _words = ["foo", "bar"];
  List<ConcatenationAllWordsStep> _steps = [];

  // Playback Control
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  // Code Language Selector
  String _selectedCodeLang = "C++";

  // Tab 2 Animation Model Selector (0: Step Flowcard, 1: Offset Step Rule, 2: Complexity Calculator)
  int _animationModelIndex = 0;
  int _flowStepIndex = 0;

  // Practice Mode State
  int _practiceOffset = 0;
  int _practiceRight = 0;
  List<int> _practiceResult = [];
  String _userFeedbackEn = "Run multi-offset sliding window with step size equal to word length L!";
  String _userFeedbackBn = "শব্দের দৈর্ঘ্য L এর সমান স্টেপ সাইজ নিয়ে মাল্টি-অফসেট স্লাইডিং উইন্ডো পরিচালনা করুন!";
  bool _practiceSolved = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _rebuildSteps();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _timer?.cancel();
    _sController.dispose();
    _wordsController.dispose();
    super.dispose();
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text.trim()));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              _isEnglish
                  ? '$label copied to clipboard!'
                  : '$label কোড ক্লিপবোর্ডে কপি হয়েছে!',
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
        backgroundColor: AppTheme.accentGreen,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _rebuildSteps() {
    _timer?.cancel();
    _isPlaying = false;
    _currentStepIndex = 0;
    _flowStepIndex = 0;

    String sVal = _sController.text.trim();
    List<String> wList = _wordsController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    if (sVal.isEmpty || wList.isEmpty) {
      sVal = "barfoothefoobarman";
      wList = ["foo", "bar"];
    }

    _s = sVal;
    _words = wList;

    _steps = _generateSteps(_s, _words);

    // Reset practice mode
    _resetPractice();
  }

  void _resetPractice() {
    _practiceOffset = 0;
    _practiceRight = 0;
    _practiceResult = [];
    _practiceSolved = false;
    _userFeedbackEn = "Inspect string s = \"$_s\" for words [${_words.join(', ')}] starting at offset 0!";
    _userFeedbackBn = "অফসেট 0 এ [${_words.join(', ')}] শব্দগুলোর জন্য স্ট্রিং s = \"$_s\" পরীক্ষা করুন!";
  }

  List<ConcatenationAllWordsStep> _generateSteps(String sStr, List<String> wordsList) {
    List<ConcatenationAllWordsStep> steps = [];
    int n = sStr.length;
    int numWords = wordsList.length;

    if (n == 0 || numWords == 0) {
      steps.add(const ConcatenationAllWordsStep(
        offset: 0,
        left: 0,
        right: 0,
        currentWord: "",
        windowSub: "",
        windowMap: {},
        targetMap: {},
        count: 0,
        result: [],
        decision: "finished",
        activeLine: 2,
        actionEn: "🏁 Line 2: Empty string or empty words list! Return [].",
        actionBn: "🏁 লাইন ২: খালি স্ট্রিং বা শব্দ তালিকা! [] রিটার্ন করুন।",
        reasonEn: "Empty input.",
        reasonBn: "ইনপুট খালি।",
      ));
      return steps;
    }

    int wordLen = wordsList[0].length;
    int totalLen = wordLen * numWords;

    Map<String, int> targetMap = {};
    for (String w in wordsList) {
      targetMap[w] = (targetMap[w] ?? 0) + 1;
    }

    // Step 0: Init
    steps.add(ConcatenationAllWordsStep(
      offset: 0,
      left: 0,
      right: 0,
      currentWord: "",
      windowSub: "",
      windowMap: {},
      targetMap: Map.from(targetMap),
      count: 0,
      result: [],
      decision: "init",
      activeLine: 1,
      actionEn: "Line 1: Initialize Substring Concatenation for s = \"$sStr\", words = [${wordsList.join(', ')}]. Word len L = $wordLen, Total len = $totalLen.",
      actionBn: "লাইন ১: s = \"$sStr\", words = [${wordsList.join(', ')}] এর জন্য কনক্যাটেনেশন সার্চ শুরু। শব্দের দৈর্ঘ্য L = $wordLen, মোট দৈর্ঘ্য = $totalLen।",
      reasonEn: "We run $wordLen independent sliding windows for offsets 0..${wordLen - 1} with step size L = $wordLen.",
      reasonBn: "আমরা অফসেট 0..${wordLen - 1} এর জন্য L = $wordLen স্টেপ সাইজে $wordLen টি স্বাধীন স্লাইডিং উইন্ডো চালাব।",
    ));

    if (n < totalLen) {
      steps.add(ConcatenationAllWordsStep(
        offset: 0,
        left: 0,
        right: 0,
        currentWord: "",
        windowSub: "",
        windowMap: {},
        targetMap: Map.from(targetMap),
        count: 0,
        result: [],
        decision: "finished",
        activeLine: 2,
        actionEn: "🏁 Line 2: String length ($n) is shorter than required total concatenated length ($totalLen)! Return [].",
        actionBn: "🏁 লাইন ২: স্ট্রিং দৈর্ঘ্য ($n) প্রয়োজনীয় কনক্যাটেনেটেড মোট দৈর্ঘ্য ($totalLen) এর চেয়ে ছোট! [] রিটার্ন করুন।",
        reasonEn: "String s is too short.",
        reasonBn: "স্ট্রিং s অত্যন্ত ছোট।",
      ));
      return steps;
    }

    List<int> result = [];

    for (int offset = 0; offset < wordLen; offset++) {
      int l = offset;
      int count = 0;
      Map<String, int> windowMap = {};

      for (int r = offset; r <= n - wordLen; r += wordLen) {
        String word = sStr.substring(r, r + wordLen);

        if (targetMap.containsKey(word)) {
          windowMap[word] = (windowMap[word] ?? 0) + 1;
          count++;

          steps.add(ConcatenationAllWordsStep(
            offset: offset,
            left: l,
            right: r,
            currentWord: word,
            windowSub: sStr.substring(l, r + wordLen),
            windowMap: Map.from(windowMap),
            targetMap: Map.from(targetMap),
            count: count,
            result: List.from(result),
            decision: "expand",
            activeLine: 8,
            actionEn: "➡️ Line 8: Offset $offset: Extracted word \"$word\" at index $r ➔ Window \"${sStr.substring(l, r + wordLen)}\" (Count = $count / $numWords).",
            actionBn: "➡️ লাইন ৮: অফসেট $offset: ইনডেক্স $r এ শব্দ \"$word\" সংগৃহীত ➔ উইন্ডো \"${sStr.substring(l, r + wordLen)}\" (কাউন্ট = $count / $numWords)।",
            reasonEn: "Word \"$word\" is valid. Add to active window map.",
            reasonBn: "শব্দ \"$word\" বৈধ্য। সক্রিয় উইন্ডো ম্যাপে যোগ করা হলো।",
          ));

          while (windowMap[word]! > targetMap[word]!) {
            String leftWord = sStr.substring(l, l + wordLen);
            windowMap[leftWord] = windowMap[leftWord]! - 1;
            count--;
            l += wordLen;

            steps.add(ConcatenationAllWordsStep(
              offset: offset,
              left: l,
              right: r,
              currentWord: word,
              windowSub: sStr.substring(l, r + wordLen),
              windowMap: Map.from(windowMap),
              targetMap: Map.from(targetMap),
              count: count,
              result: List.from(result),
              decision: "shrink_left",
              activeLine: 10,
              actionEn: "⬅️ Line 10: Word \"$word\" count exceeds target! Removed left word \"$leftWord\" at index ${l - wordLen} ➔ New Left = $l.",
              actionBn: "⬅️ লাইন ১০: শব্দ \"$word\" সংখ্যা সীমা ছাড়িয়েছে! ইনডেক্স ${l - wordLen} থেকে বাম শব্দ \"$leftWord\" সরানো হলো ➔ নতুন বাম = $l।",
              reasonEn: "Shrink window from left by step size L = $wordLen to restore frequency constraint.",
              reasonBn: "ফ্রিকোয়েন্সি বজায় রাখতে স্টেপ সাইজ L = $wordLen এ উইন্ডো বাম থেকে কমানো হলো।",
            ));
          }

          if (count == numWords) {
            result.add(l);
            steps.add(ConcatenationAllWordsStep(
              offset: offset,
              left: l,
              right: r,
              currentWord: word,
              windowSub: sStr.substring(l, r + wordLen),
              windowMap: Map.from(windowMap),
              targetMap: Map.from(targetMap),
              count: count,
              result: List.from(result),
              decision: "match_found",
              activeLine: 12,
              actionEn: "🎉 Line 12: MATCH FOUND! All $numWords words concatenated at starting index $l! Substring = \"${sStr.substring(l, l + totalLen)}\"!",
              actionBn: "🎉 লাইন ১২: ম্যাচ পাওয়া গেছে! সমস্ত $numWords টি শব্দের কনক্যাটেনেশন শুরুর ইনডেক্স $l এ পাওয়া গেছে! সাব-স্ট্রিং = \"${sStr.substring(l, l + totalLen)}\"!",
              reasonEn: "Window [${l}..${l + totalLen - 1}] matches target word frequencies!",
              reasonBn: "উইন্ডো [${l}..${l + totalLen - 1}] টার্গেট শব্দ ফ্রিকোয়েন্সি মেলো!",
            ));
          }
        } else {
          windowMap.clear();
          count = 0;
          l = r + wordLen;

          steps.add(ConcatenationAllWordsStep(
            offset: offset,
            left: l,
            right: r,
            currentWord: word,
            windowSub: r + wordLen <= n ? sStr.substring(r, r + wordLen) : "",
            windowMap: Map.from(windowMap),
            targetMap: Map.from(targetMap),
            count: count,
            result: List.from(result),
            decision: "reset_window",
            activeLine: 14,
            actionEn: "🚫 Line 14: Invalid word \"$word\" at index $r! Reset windowMap and move left pointer to ${r + wordLen}.",
            actionBn: "🚫 লাইন ১৪: অকার্যকর শব্দ \"$word\" ইনডেক্স $r এ পাওয়া গেছে! windowMap রিসেট করে বাম পয়েন্টার ${r + wordLen} এ নেওয়া হলো।",
            reasonEn: "Word \"$word\" is not in words list. Skip window.",
            reasonBn: "শব্দ \"$word\" টার্গেট তালিকায় নেই। উইন্ডো স্কিপ করুন।",
          ));
        }
      }
    }

    steps.add(ConcatenationAllWordsStep(
      offset: 0,
      left: 0,
      right: n - 1,
      currentWord: "",
      windowSub: "",
      windowMap: {},
      targetMap: Map.from(targetMap),
      count: 0,
      result: List.from(result),
      decision: "finished",
      activeLine: 16,
      actionEn: "🏁 Line 16: Traversal Complete! Concatenated Starting Indices = [${result.join(', ')}].",
      actionBn: "🏁 লাইন ১৬: স্ক্যান সম্পূর্ণ! কনক্যাটেনেটেড শুরুর ইনডেক্সসমূহ = [${result.join(', ')}]।",
      reasonEn: "Evaluated all word offsets in O(N * L) linear time.",
      reasonBn: "O(N * L) লিনিয়ার সময়ে সমস্ত ওয়ার্ড অফসেট মূল্যায়ন সম্পন্ন।",
    ));

    return steps;
  }

  void _togglePlay() {
    setState(() => _isPlaying = !_isPlaying);
    if (_isPlaying) {
      _timer = Timer.periodic(const Duration(milliseconds: 1400), (timer) {
        if (_currentStepIndex < _steps.length - 1) {
          setState(() => _currentStepIndex++);
        } else {
          _timer?.cancel();
          setState(() => _isPlaying = false);
        }
      });
    } else {
      _timer?.cancel();
    }
  }

  List<int> _findSubstring(String sStr, List<String> wordsList) {
    if (sStr.isEmpty || wordsList.isEmpty) return [];
    int n = sStr.length;
    int numWords = wordsList.length;
    int wordLen = wordsList[0].length;
    int totalLen = wordLen * numWords;
    if (n < totalLen) return [];

    Map<String, int> targetMap = {};
    for (String w in wordsList) {
      targetMap[w] = (targetMap[w] ?? 0) + 1;
    }

    List<int> res = [];
    for (int offset = 0; offset < wordLen; offset++) {
      int l = offset;
      int count = 0;
      Map<String, int> windowMap = {};

      for (int r = offset; r <= n - wordLen; r += wordLen) {
        String word = sStr.substring(r, r + wordLen);
        if (targetMap.containsKey(word)) {
          windowMap[word] = (windowMap[word] ?? 0) + 1;
          count++;
          while (windowMap[word]! > targetMap[word]!) {
            String leftWord = sStr.substring(l, l + wordLen);
            windowMap[leftWord] = windowMap[leftWord]! - 1;
            count--;
            l += wordLen;
          }
          if (count == numWords) {
            res.add(l);
          }
        } else {
          windowMap.clear();
          count = 0;
          l = r + wordLen;
        }
      }
    }
    return res;
  }

  void _handlePracticeAction(String actionType) {
    if (_practiceSolved || _practiceRight >= _s.length) return;

    List<int> expectedRes = _findSubstring(_s, _words);

    setState(() {
      _practiceRight += _words[0].length;
      if (_practiceRight >= _s.length) {
        _practiceSolved = true;
        _userFeedbackEn = "🏆 MASTERED! You successfully matched concatenated word substrings! Starting Indices = [${expectedRes.join(', ')}].";
        _userFeedbackBn = "🏆 দারুণ! আপনি কনক্যাটেনেটেড শব্দ সাব-স্ট্রিং সফলভাবে মিলিয়েছেন! শুরুর ইনডেক্সসমূহ = [${expectedRes.join(', ')}]।";
      } else {
        _userFeedbackEn = "Correct! Advanced right pointer to $_practiceRight. Select next step action!";
        _userFeedbackBn = "সঠিক! ডান পয়েন্টার $_practiceRight এ নেওয়া হয়েছে। পরের পদক্ষেপ নির্বাচন করুন!";
      }
    });
  }

  void _undoPracticeMove() {
    setState(() {
      _resetPractice();
      _userFeedbackEn = "↩️ Reset practice state.";
      _userFeedbackBn = "↩️ প্র্যাকটিস স্টেট রিসেট করা হলো।";
    });
  }

  @override
  Widget build(BuildContext context) {
    final hPadding = Responsive.horizontalPadding(context);

    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      appBar: AppBar(
        title: Text(
          '30. Substring Concatenation of All Words',
          style: TextStyle(fontSize: Responsive.sp(context, 15), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: TextButton.icon(
              style: TextButton.styleFrom(
                backgroundColor: AppTheme.accentPurple.withOpacity(0.2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              icon: Icon(
                Icons.language,
                color: _isEnglish ? AppTheme.accentNeonCyan : AppTheme.accentPink,
                size: Responsive.sp(context, 18),
              ),
              label: Text(
                _isEnglish ? 'EN' : 'BN',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: Responsive.sp(context, 13)),
              ),
              onPressed: () {
                setState(() => _isEnglish = !_isEnglish);
              },
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.accentNeonCyan,
          labelColor: AppTheme.accentNeonCyan,
          unselectedLabelColor: AppTheme.textSecondary,
          isScrollable: true,
          tabs: [
            Tab(text: _isEnglish ? '📘 Problem Description' : '📘 প্রবলেম বিবরণ'),
            Tab(text: _isEnglish ? '🎨 Code-Free Animation' : '🎨 কোডহীন ভিজ্যুয়াল গাইড'),
            Tab(text: _isEnglish ? '⚡ Dynamic Visualizer' : '⚡ কাস্টম ইনপুট ও ভিজ্যুয়ালাইজার'),
            Tab(text: _isEnglish ? '💡 Practice & Answer' : '💡 প্র্যাকটিস ও উত্তর'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildProblemDescriptionTab(),
          _buildCodeFreeAnimationTab(),
          _buildVisualizerTab(),
          _buildPracticeTab(),
        ],
      ),
    );
  }

  // TAB 1: Problem Description
  Widget _buildProblemDescriptionTab() {
    final hPadding = Responsive.horizontalPadding(context);

    return ResponsiveCenter(
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title + Tags
            Row(
              children: [
                Expanded(
                  child: Text(
                    "30. Substring with Concatenation of All Words",
                    style: TextStyle(fontSize: Responsive.sp(context, 18), fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.accentPink.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.accentPink),
                  ),
                  child: const Text("Hard", style: TextStyle(color: AppTheme.accentPink, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              children: ["Amazon", "Meta"].map((company) {
                return Chip(
                  backgroundColor: AppTheme.surfaceDark,
                  label: Text(company, style: const TextStyle(color: AppTheme.accentNeonCyan, fontSize: 11)),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Description Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF1E293B)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isEnglish
                        ? "You are given a string s and an array of strings words of the same length. Return an array of the starting indices of all the concatenated substrings in s."
                        : "সম দৈর্ঘ্যের শব্দের একটি অ্যারে words এবং একটি স্ট্রিং s দেওয়া আছে। s এর মধ্যে words এর সমস্ত বিন্যাসের কনক্যাটেনেটেড সাব-স্ট্রিংগুলোর শুরুর ইনডেক্সসমূহের অ্যারে রিটার্ন করুন।",
                    style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Examples
            Text(_isEnglish ? "Examples" : "উদাহরণসমূহ", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            _buildExampleCard("Example 1", "s = \"barfoothefoobarman\", words = [\"foo\",\"bar\"]", "Output: [0, 9] (\"barfoo\" at idx 0, \"foobar\" at idx 9)"),
            _buildExampleCard("Example 2", "s = \"wordgoodgoodgoodbestword\", words = [\"word\",\"good\",\"best\",\"word\"]", "Output: []"),
            _buildExampleCard("Example 3", "s = \"barfoofoobarthefoobarman\", words = [\"bar\",\"foo\",\"the\"]", "Output: [6, 9, 12]"),
            const SizedBox(height: 20),

            // Intuition Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.accentPurple.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.accentPurple),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.lightbulb_outline, color: AppTheme.accentAmber, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        _isEnglish ? "Key Intuition (Multi-Offset Word Frequency Window)" : "মূল আইডিয়া (মাল্টি-অফসেট শব্দ ফ্রিকোয়েন্সি উইন্ডো)",
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isEnglish
                        ? "1. Since all words have equal length L, run L independent sliding windows for offsets 0, 1, ..., L-1.\n2. Advance right by step size L, maintaining word frequency count windowMap.\n3. If word frequency exceeds targetMap, shrink left by step size L.\n4. When count == numWords, record starting index left!\n5. Achieves O(N * L) linear time complexity and O(M * L) space complexity!"
                        : "১. যেহেতু সব শব্দের দৈর্ঘ্য L সমান, অফসেট 0, 1, ..., L-1 এর জন্য L টি স্বাধীন স্লাইডিং উইন্ডো ব্যবহার করুন।\n২. L স্টেপ সাইজে ডান পয়েন্টার বাড়িয়ে windowMap মেইন্টেন করুন।\n৩. কোনো শব্দের সংখ্যা সীমা ছাড়ালে L স্টেপ সাইজে বাম পয়েন্টার কমান।\n৪. count == numWords হওয়ামাত্রই শুরুর ইনডেক্স left রেকর্ড করুন!\n৫. O(N * L) লিনিয়ার সময় ও O(M * L) স্পেস কমপ্লেক্সিটি।",
                    style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13, height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Code Solutions (C++, Java, Python)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _isEnglish ? "Code Solutions" : "কোড সমাধানসমূহ",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                DropdownButton<String>(
                  value: _selectedCodeLang,
                  dropdownColor: AppTheme.surfaceDark,
                  style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold),
                  items: ["C++", "Java", "Python"].map((lang) {
                    return DropdownMenuItem(value: lang, child: Text(lang));
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedCodeLang = val);
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildCodeSnippetBox(_selectedCodeLang),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // TAB 2: Code-Free Animation (3 Interactive Concept Models)
  Widget _buildCodeFreeAnimationTab() {
    final hPadding = Responsive.horizontalPadding(context);

    return ResponsiveCenter(
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isEnglish ? "Concatenated Substring Visual Models" : "কনক্যাটেনেটেড সাব-স্ট্রিং ভিজ্যুয়াল মডেলসমূহ (কোডহীন গাইড)",
              style: TextStyle(fontSize: Responsive.sp(context, 18), fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 6),
            Text(
              _isEnglish
                  ? "Explore 3 interactive models for s = \"barfoothefoobarman\", words = [\"foo\",\"bar\"]."
                  : "s = \"barfoothefoobarman\", words = [\"foo\",\"bar\"] এর জন্য ৩টি ইন্টারঅ্যাক্টিভ ভিজ্যুয়াল মডেল পর্যবেক্ষণ করুন।",
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 16),

            // Model Switcher Segmented Control
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildAnimationModelChip(0, _isEnglish ? "1. 🪜 Step Flowcard" : "১. 🪜 স্টেপ-বাই-স্টেপ ফ্লো-কার্ড"),
                  _buildAnimationModelChip(1, _isEnglish ? "2. 📏 Offset Step Rule" : "২. 📏 অফসেট ও স্টেপ নীতি"),
                  _buildAnimationModelChip(2, _isEnglish ? "3. 📊 Complexity Calculator" : "৩. 📊 টাইমিং ক্যালকুলেটর"),
                ],
              ),
            ),
            const SizedBox(height: 20),

            if (_animationModelIndex == 0) _buildStepFlowcardModel(),
            if (_animationModelIndex == 1) _buildOffsetStepRuleModel(),
            if (_animationModelIndex == 2) _buildComplexityCalculatorModel(),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimationModelChip(int index, String label) {
    final isSelected = _animationModelIndex == index;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        selectedColor: AppTheme.accentPurple,
        backgroundColor: AppTheme.surfaceDark,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : AppTheme.textSecondary,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 12,
        ),
        onSelected: (selected) {
          if (selected) setState(() => _animationModelIndex = index);
        },
      ),
    );
  }

  // MODEL 1: Step-by-Step Backtracking Flowcard Engine
  Widget _buildStepFlowcardModel() {
    final stepFlowData = [
      {
        "step": 1,
        "offset": 0,
        "window": "barfoo",
        "match": "0",
        "res": "[0]",
        "badge": "🎉 MATCH FOUND AT INDEX 0",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 1: Offset 0: Window \"barfoo\" [0..5] ➔ Contains \"bar\" & \"foo\"! MATCH FOUND at index 0 🎉",
        "titleBn": "ধাপ ১: অফসেট 0: উইন্ডো \"barfoo\" [0..5] ➔ \"bar\" ও \"foo\" বিদ্যমান! ইনডেক্স 0 এ ম্যাচ পাওয়া গেছে 🎉",
        "descEn": "Both \"bar\" and \"foo\" matched target word count 2/2.",
        "descBn": "\"bar\" ও \"foo\" দুটি শব্দই টার্গেট ফ্রিকোয়েন্সি ২/২ পূরণ করেছে।",
      },
      {
        "step": 2,
        "offset": 0,
        "window": "the",
        "match": "-",
        "res": "[0]",
        "badge": "🚫 INVALID WORD (RESET)",
        "badgeColor": AppTheme.accentPink,
        "titleEn": "Step 2: Offset 0: Word \"the\" at index 6 is invalid! Reset window.",
        "titleBn": "ধাপ ২: অফসেট 0: ইনডেক্স ৬ এর শব্দ \"the\" অকার্যকর! উইন্ডো রিসেট করা হলো।",
        "descEn": "\"the\" is not in words list. Skip window and move to index 9.",
        "descBn": "\"the\" টার্গেট তালিকায় নেই। উইন্ডো রিসেট করে ৯ ইনডেক্সে যাওয়া হলো।",
      },
      {
        "step": 3,
        "offset": 0,
        "window": "foobar",
        "match": "9",
        "res": "[0, 9]",
        "badge": "🎉 MATCH FOUND AT INDEX 9",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 3: Offset 0: Window \"foobar\" [9..14] ➔ Contains \"foo\" & \"bar\"! MATCH FOUND at index 9 🎉",
        "titleBn": "ধাপ ৩: অফসেট 0: উইন্ডো \"foobar\" [9..14] ➔ \"foo\" ও \"bar\" বিদ্যমান! ইনডেক্স 9 এ ম্যাচ পাওয়া গেছে 🎉",
        "descEn": "Starting index 9 forms valid concatenated substring!",
        "descBn": "শুরুর ইনডেক্স ৯ বৈধ্য কনক্যাটেনেটেড সাব-স্ট্রিং তৈরি করে!",
      },
      {
        "step": 4,
        "offset": 0,
        "window": "foobar",
        "match": "-",
        "res": "[0, 9]",
        "badge": "🏁 COMPLETE",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 4: All Offsets Scanned! Concatenated Starting Indices = [0, 9]",
        "titleBn": "ধাপ ৪: সমস্ত অফসেট স্ক্যান সম্পন্ন! কনক্যাটেনেটেড শুরুর ইনডেক্সসমূহ = [0, 9]",
        "descEn": "Executed multi-offset sliding window in O(N * L) linear time!",
        "descBn": "মাল্টি-অফসেট স্লাইডিং উইন্ডো দিয়ে O(N * L) সময়ে সমাধান সম্পূর্ণ!",
      },
    ];

    final currentStep = stepFlowData[_flowStepIndex.clamp(0, stepFlowData.length - 1)];
    final String window = currentStep["window"] as String;
    final String matchVal = currentStep["match"] as String;
    final String resVal = currentStep["res"] as String;
    final String badgeText = currentStep["badge"] as String;
    final Color badgeColor = currentStep["badgeColor"] as Color;
    final String stepTitle = _isEnglish ? (currentStep["titleEn"] as String) : (currentStep["titleBn"] as String);
    final String stepDesc = _isEnglish ? (currentStep["descEn"] as String) : (currentStep["descBn"] as String);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF090D16),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _isEnglish ? "1. Step-by-Step Concatenated Words Flowcard" : "১. স্টেপ-বাই-স্টেপ কনক্যাটেনেটেড ওয়ার্ডস ফ্লো-কার্ড",
                style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
              ),
              Text(
                "Step ${_flowStepIndex + 1} / ${stepFlowData.length}",
                style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            _isEnglish
                ? "Watch multi-offset window progression by word step size L."
                : "শব্দের দৈর্ঘ্য L অনুযায়ী মাল্টি-অফসেট উইন্ডো অগ্রগতি দেখুন।",
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 16),

          // Active Step Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: badgeColor, width: 2),
              boxShadow: [BoxShadow(color: badgeColor.withOpacity(0.2), blurRadius: 10)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(stepTitle, style: TextStyle(color: badgeColor, fontWeight: FontWeight.bold, fontSize: 14)),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: badgeColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: badgeColor),
                      ),
                      child: Text(badgeText, style: TextStyle(color: badgeColor, fontWeight: FontWeight.bold, fontSize: 11)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Window = \"$window\" (Match: $matchVal)", style: TextStyle(color: badgeColor, fontWeight: FontWeight.bold, fontSize: 12)),
                    Text("Result = $resVal", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 6),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF090D16),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: badgeColor.withOpacity(0.5)),
                  ),
                  child: Text(
                    "Starting Indices = $resVal 🏆",
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: badgeColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 12),

                Text(stepDesc, style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.4)),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Stepper Control Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF1E293B)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.skip_previous, color: Colors.white, size: 20),
                      onPressed: _flowStepIndex > 0 ? () => setState(() => _flowStepIndex--) : null,
                    ),
                    IconButton(
                      icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, color: AppTheme.accentNeonCyan, size: 22),
                      onPressed: () {
                        setState(() => _isPlaying = !_isPlaying);
                        if (_isPlaying) {
                          _timer = Timer.periodic(const Duration(milliseconds: 1400), (t) {
                            if (_flowStepIndex < stepFlowData.length - 1) {
                              setState(() => _flowStepIndex++);
                            } else {
                              t.cancel();
                              setState(() => _isPlaying = false);
                            }
                          });
                        } else {
                          _timer?.cancel();
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.skip_next, color: Colors.white, size: 20),
                      onPressed: _flowStepIndex < stepFlowData.length - 1 ? () => setState(() => _flowStepIndex++) : null,
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh, color: AppTheme.accentNeonCyan, size: 20),
                      onPressed: () {
                        _timer?.cancel();
                        setState(() {
                          _isPlaying = false;
                          _flowStepIndex = 0;
                        });
                      },
                    ),
                  ],
                ),
                Text(
                  "Step ${_flowStepIndex + 1} / ${stepFlowData.length}",
                  style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // MODEL 2: Offset Step Rule
  Widget _buildOffsetStepRuleModel() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF090D16),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _isEnglish ? "2. Multi-Offset & Word Step Size Rule" : "২. মাল্টি-অফসেট ও ওয়ার্ড স্টেপ নীতি",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            _isEnglish
                ? "For offset 0 to L-1: advance right by step size L, extracting words of length L. If count == numWords, record left starting index!"
                : "অফসেট 0 থেকে L-1 এর জন্য: L স্টেপ সাইজে ডান পয়েন্টার বাড়িয়ে L দৈর্ঘ্যের শব্দ সংগ্রহ করুন। count == numWords হলে শুরুর ইনডেক্স left রেকর্ড করুন!",
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, height: 1.4),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.accentGreen),
            ),
            child: const Text(
              "for (int offset = 0; offset < L; offset++) { for (int r = offset; r <= n - L; r += L) { ... } } 📏",
              style: TextStyle(fontFamily: 'monospace', fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.accentGreen),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  // MODEL 3: Complexity Calculator
  Widget _buildComplexityCalculatorModel() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF090D16),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _isEnglish ? "3. O(N * L) Time & O(M * L) Space Complexity" : "৩. O(N * L) টাইম এবং O(M * L) স্পেস কমপ্লেক্সিটি",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            _isEnglish
                ? "Naive permutation search takes O(N * M * L) time.\nMulti-Offset Sliding Window evaluates all word blocks in O(N * L) time with O(M * L) space!"
                : "সাধারণ পারমিউটেশন সার্চে O(N * M * L) সময় লাগে।\nমাল্টি-অফসেট স্লাইডিং উইন্ডো O(N * L) টাইম ও O(M * L) স্পেসে সমাধান করে!",
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, height: 1.4),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.accentPurple),
            ),
            child: const Text(
              "Time Complexity: O(N * L)\nSpace Complexity: O(M * L) 🎉",
              style: TextStyle(fontFamily: 'monospace', fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white, height: 1.5),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  // TAB 3: Dynamic Visualizer
  Widget _buildVisualizerTab() {
    final step = _steps.isNotEmpty ? _steps[_currentStepIndex.clamp(0, _steps.length - 1)] : null;
    final isMobile = Responsive.isMobile(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(Responsive.horizontalPadding(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Input Box & Presets
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF1E293B)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: _sController,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          labelText: _isEnglish ? "String s (e.g. barfoothefoobarman)" : "স্ট্রিং s (যেমন barfoothefoobarman)",
                          labelStyle: const TextStyle(color: AppTheme.accentNeonCyan, fontSize: 12),
                          filled: true,
                          fillColor: const Color(0xFF090D16),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: TextField(
                        controller: _wordsController,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          labelText: _isEnglish ? "Words (e.g. foo, bar)" : "শব্দসমূহ (যেমন foo, bar)",
                          labelStyle: const TextStyle(color: AppTheme.accentNeonCyan, fontSize: 12),
                          filled: true,
                          fillColor: const Color(0xFF090D16),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentNeonCyan,
                        foregroundColor: AppTheme.primaryDark,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                      ),
                      onPressed: () => setState(() => _rebuildSteps()),
                      child: Text(_isEnglish ? "Run" : "রান"),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      const Text("Presets: ", style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                      _buildPresetChip("barfoothefoobarman", "foo, bar"),
                      _buildPresetChip("wordgoodgoodgoodbestword", "word, good, best, word"),
                      _buildPresetChip("barfoofoobarthefoobarman", "bar, foo, the"),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          if (step != null) ...[
            // Status Log Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.accentPurple.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.accentPurple),
              ),
              child: Text(
                _isEnglish ? step.actionEn : step.actionBn,
                style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
            const SizedBox(height: 16),

            // Code Snippet + Canvas Layout
            if (isMobile)
              Column(
                children: [
                  _buildCodeHighlightBox(step.activeLine),
                  const SizedBox(height: 16),
                  _buildConcatenationCanvas(step),
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildCodeHighlightBox(step.activeLine)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildConcatenationCanvas(step)),
                ],
              ),

            const SizedBox(height: 20),

            // Control Bar
            _buildControlBar(),
          ],
        ],
      ),
    );
  }

  // TAB 4: Practice & Answer
  Widget _buildPracticeTab() {
    final hPadding = Responsive.horizontalPadding(context);
    final targetResult = _findSubstring(_s, _words);

    return ResponsiveCenter(
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isEnglish ? "Interactive Practice Mode" : "ইন্টারেক্টিভ প্র্যাকটিস মোড",
              style: TextStyle(fontSize: Responsive.sp(context, 18), fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 6),
            Text(
              _isEnglish
                  ? "Track window expansion by word blocks and find all concatenated starting indices!"
                  : "শব্দ ব্লক অনুসারে উইন্ডো প্রসারিত করুন এবং কনক্যাটেনেটেড শুরুর ইনডেক্সসমূহ খুঁজুন!",
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 16),

            // Feedback Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _practiceSolved ? AppTheme.accentGreen.withOpacity(0.2) : AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _practiceSolved ? AppTheme.accentGreen : AppTheme.accentNeonCyan),
              ),
              child: Text(
                _isEnglish ? _userFeedbackEn : _userFeedbackBn,
                style: TextStyle(
                  color: _practiceSolved ? AppTheme.accentGreen : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Practice Controls
            if (!_practiceSolved && _practiceRight < _s.length)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF090D16),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTheme.accentPurple),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Current Index: right = $_practiceRight", style: const TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 12)),
                        Text("Target Starting Indices: [${targetResult.join(', ')}]", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Window Substring: \"${_s.substring(_practiceOffset, (_practiceRight + _words[0].length) <= _s.length ? (_practiceRight + _words[0].length) : _s.length)}\"",
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      alignment: WrapAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accentNeonCyan,
                            foregroundColor: AppTheme.primaryDark,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          ),
                          icon: const Icon(Icons.arrow_forward),
                          label: Text(_isEnglish ? "EXPAND WORD" : "EXPAND WORD"),
                          onPressed: () => _handlePracticeAction("EXPAND"),
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accentAmber,
                            foregroundColor: AppTheme.primaryDark,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          ),
                          icon: const Icon(Icons.arrow_back),
                          label: Text(_isEnglish ? "SHRINK WORD" : "SHRINK WORD"),
                          onPressed: () => _handlePracticeAction("SHRINK"),
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accentGreen,
                            foregroundColor: AppTheme.primaryDark,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          ),
                          icon: const Icon(Icons.star),
                          label: Text(_isEnglish ? "MATCH FOUND" : "MATCH FOUND"),
                          onPressed: () => _handlePracticeAction("MATCH_FOUND"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 12),
            if (_practiceRight > 0 || _practiceSolved)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  icon: const Icon(Icons.undo, size: 16, color: AppTheme.accentAmber),
                  label: Text(_isEnglish ? "Reset State" : "রিসেট", style: const TextStyle(color: AppTheme.accentAmber, fontSize: 12)),
                  onPressed: _undoPracticeMove,
                ),
              ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // Helper Widgets
  Widget _buildPresetChip(String sVal, String wVal) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ActionChip(
        backgroundColor: const Color(0xFF090D16),
        label: Text("s:\"$sVal\", words:[$wVal]", style: const TextStyle(color: AppTheme.accentNeonCyan, fontSize: 11)),
        onPressed: () {
          _sController.text = sVal;
          _wordsController.text = wVal;
          _rebuildSteps();
        },
      ),
    );
  }

  Widget _buildCodeHighlightBox(int activeLine) {
    final codeLines = [
      "vector<int> findSubstring(string s, vector<string>& words) {",
      "    int n = s.length(), numWords = words.size(), wordLen = words[0].length();",
      "    unordered_map<string, int> targetMap;",
      "    for (auto& w : words) targetMap[w]++;",
      "    vector<int> result;",
      "    for (int offset = 0; offset < wordLen; offset++) {",
      "        int left = offset, count = 0;",
      "        unordered_map<string, int> windowMap;",
      "        for (int right = offset; right <= n - wordLen; right += wordLen) {",
      "            string w = s.substr(right, wordLen);",
      "            if (targetMap.count(w)) {",
      "                windowMap[w]++; count++;",
      "                while (windowMap[w] > targetMap[w]) {",
      "                    windowMap[s.substr(left, wordLen)]--; count--; left += wordLen;",
      "                }",
      "                if (count == numWords) result.push_back(left);",
      "            } else { windowMap.clear(); count = 0; left = right + wordLen; }",
      "        }",
      "    }",
      "    return result;",
      "}",
    ];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF090D16),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(codeLines.length, (idx) {
          final lineNum = idx + 1;
          final isHighlighted = lineNum == activeLine;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            margin: const EdgeInsets.symmetric(vertical: 1),
            decoration: BoxDecoration(
              color: isHighlighted ? AppTheme.accentPurple.withOpacity(0.25) : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: isHighlighted ? Border.all(color: AppTheme.accentPurple) : null,
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 24,
                  child: Text(
                    "$lineNum",
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                      color: isHighlighted ? AppTheme.accentNeonCyan : const Color(0xFF64748B),
                      fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
                if (isHighlighted)
                  const Padding(
                    padding: EdgeInsets.only(right: 6),
                    child: Icon(Icons.arrow_right_alt, color: AppTheme.accentNeonCyan, size: 14),
                  )
                else
                  const SizedBox(width: 20),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      codeLines[idx],
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        color: isHighlighted ? Colors.white : const Color(0xFF38BDF8),
                        fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildConcatenationCanvas(ConcatenationAllWordsStep step) {
    Color decisionColor = AppTheme.accentPurple;
    String decisionLabel = "INIT";

    if (step.decision == "expand") {
      decisionColor = AppTheme.accentNeonCyan;
      decisionLabel = "➡️ EXPAND WORD";
    } else if (step.decision == "shrink_left") {
      decisionColor = AppTheme.accentAmber;
      decisionLabel = "⬅️ SHRINK WORD";
    } else if (step.decision == "reset_window") {
      decisionColor = AppTheme.accentPink;
      decisionLabel = "🚫 INVALID WORD (RESET)";
    } else if (step.decision == "match_found") {
      decisionColor = AppTheme.accentGreen;
      decisionLabel = "🎉 MATCH FOUND";
    } else if (step.decision == "finished") {
      decisionColor = AppTheme.accentGreen;
      decisionLabel = "🏁 FINISHED";
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF090D16),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Offset: ${step.offset} | Window: [L:${step.left} .. R:${step.right}]", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: decisionColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: decisionColor),
                ),
                child: Text(decisionLabel, style: TextStyle(color: decisionColor, fontWeight: FontWeight.bold, fontSize: 11)),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Subarray & Meter
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Matched Words Count = ${step.count} / ${_words.length}", style: TextStyle(color: step.count == _words.length ? AppTheme.accentGreen : AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 12)),
              Text("Current Word = \"${step.currentWord}\"", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: decisionColor.withOpacity(0.5)),
            ),
            child: Column(
              children: [
                Text(
                  "Starting Indices = [${step.result.join(', ')}] 🏆",
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: decisionColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  "Target Word Map: ${step.targetMap}",
                  style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Visual Word Block Sequence Canvas
          const Text("Word Block Sequence Canvas:", style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_s.length, (idx) {
                bool inWindow = idx >= step.left && idx <= step.right + (_words.isNotEmpty ? _words[0].length - 1 : 0);
                bool isL = idx == step.left;
                bool isR = idx == step.right;

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    color: inWindow ? decisionColor.withOpacity(0.35) : AppTheme.surfaceDark,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: inWindow ? decisionColor : const Color(0xFF334155),
                      width: inWindow ? 2.0 : 1.0,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isL) const Text("L", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.accentNeonCyan)),
                          if (isL && isR) const Text("|", style: TextStyle(fontSize: 10, color: Colors.white)),
                          if (isR) const Text("R", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.accentPink)),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _s[idx],
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: inWindow ? Colors.white : const Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text("[$idx]", style: const TextStyle(fontSize: 8, color: Color(0xFF64748B))),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.primaryDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.textMuted.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.skip_previous, color: Colors.white),
                onPressed: _currentStepIndex > 0 ? () => setState(() => _currentStepIndex--) : null,
              ),
              IconButton(
                icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, color: AppTheme.accentNeonCyan),
                onPressed: _togglePlay,
              ),
              IconButton(
                icon: const Icon(Icons.skip_next, color: Colors.white),
                onPressed: _currentStepIndex < _steps.length - 1 ? () => setState(() => _currentStepIndex++) : null,
              ),
              IconButton(
                icon: const Icon(Icons.refresh, color: AppTheme.accentNeonCyan),
                onPressed: () {
                  _timer?.cancel();
                  setState(() {
                    _isPlaying = false;
                    _currentStepIndex = 0;
                  });
                },
              ),
            ],
          ),
          Text(
            _isEnglish
                ? "Step ${_currentStepIndex + 1} of ${_steps.length}"
                : "ধাপ ${_currentStepIndex + 1} / ${_steps.length}",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildExampleCard(String label, String input, String output) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(height: 2),
          Text("Input: $input", style: const TextStyle(color: Colors.white, fontSize: 13)),
          Text(output, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildCodeSnippetBox(String lang) {
    String code = "";
    if (lang == "C++") {
      code = """
class Solution {
public:
    vector<int> findSubstring(string s, vector<string>& words) {
        int n = s.length(), numWords = words.size(), wordLen = words[0].length();
        unordered_map<string, int> targetMap;
        for (auto& w : words) targetMap[w]++;
        
        vector<int> result;
        for (int offset = 0; offset < wordLen; offset++) {
            int left = offset, count = 0;
            unordered_map<string, int> windowMap;
            for (int right = offset; right <= n - wordLen; right += wordLen) {
                string w = s.substr(right, wordLen);
                if (targetMap.count(w)) {
                    windowMap[w]++;
                    count++;
                    while (windowMap[w] > targetMap[w]) {
                        windowMap[s.substr(left, wordLen)]--;
                        count--;
                        left += wordLen;
                    }
                    if (count == numWords) {
                        result.push_back(left);
                    }
                } else {
                    windowMap.clear();
                    count = 0;
                    left = right + wordLen;
                }
            }
        }
        return result;
    }
};""";
    } else if (lang == "Java") {
      code = """
class Solution {
    public List<Integer> findSubstring(String s, String[] words) {
        List<Integer> result = new ArrayList<>();
        if (s.isEmpty() || words.length == 0) return result;
        
        int n = s.length(), numWords = words.length, wordLen = words[0].length();
        Map<String, Integer> targetMap = new HashMap<>();
        for (String w : words) targetMap.put(w, targetMap.getOrDefault(w, 0) + 1);
        
        for (int offset = 0; offset < wordLen; offset++) {
            int left = offset, count = 0;
            Map<String, Integer> windowMap = new HashMap<>();
            for (int right = offset; right <= n - wordLen; right += wordLen) {
                String w = s.substring(right, right + wordLen);
                if (targetMap.containsKey(w)) {
                    windowMap.put(w, windowMap.getOrDefault(w, 0) + 1);
                    count++;
                    while (windowMap.get(w) > targetMap.get(w)) {
                        String leftWord = s.substring(left, left + wordLen);
                        windowMap.put(leftWord, windowMap.get(leftWord) - 1);
                        count--;
                        left += wordLen;
                    }
                    if (count == numWords) {
                        result.add(left);
                    }
                } else {
                    windowMap.clear();
                    count = 0;
                    left = right + wordLen;
                }
            }
        }
        return result;
    }
}""";
    } else {
      code = """
class Solution:
    def findSubstring(self, s: str, words: List[str]) -> List[int]:
        if not s or not words:
            return []
        
        num_words = len(words)
        word_len = len(words[0])
        total_len = num_words * word_len
        n = len(s)
        target_map = Counter(words)
        result = []
        
        for offset in range(word_len):
            left = offset
            count = 0
            window_map = {}
            for right in range(offset, n - word_len + 1, word_len):
                w = s[right : right + word_len]
                if w in target_map:
                    window_map[w] = window_map.get(w, 0) + 1
                    count += 1
                    while window_map[w] > target_map[w]:
                        left_word = s[left : left + word_len]
                        window_map[left_word] -= 1
                        count -= 1
                        left += word_len
                    if count == num_words:
                        result.append(left)
                else:
                    window_map.clear()
                    count = 0
                    left = right + word_len
                    
        return result""";
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF090D16),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("$lang Solution", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13)),
              IconButton(
                icon: const Icon(Icons.copy, color: AppTheme.accentNeonCyan, size: 18),
                onPressed: () => _copyToClipboard(code, lang),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(code, style: const TextStyle(fontFamily: 'monospace', fontSize: 12, color: Color(0xFF38BDF8), height: 1.4)),
          ),
        ],
      ),
    );
  }
}
