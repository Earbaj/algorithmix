import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class FindAnagramsStep {
  final int left;
  final int right;
  final String windowSub;
  final bool isAnagram;
  final List<int> resultIndices;
  final String decision; // 'init', 'build_first_window', 'slide_window', 'anagram_found', 'finished'
  final int activeLine;
  final String actionEn;
  final String actionBn;
  final String reasonEn;
  final String reasonBn;

  const FindAnagramsStep({
    required this.left,
    required this.right,
    required this.windowSub,
    required this.isAnagram,
    required this.resultIndices,
    required this.decision,
    required this.activeLine,
    required this.actionEn,
    required this.actionBn,
    required this.reasonEn,
    required this.reasonBn,
  });
}

class FindAnagramsDetailScreen extends StatefulWidget {
  const FindAnagramsDetailScreen({super.key});

  @override
  State<FindAnagramsDetailScreen> createState() => _FindAnagramsDetailScreenState();
}

class _FindAnagramsDetailScreenState extends State<FindAnagramsDetailScreen>
    with SingleTickerProviderStateMixin {
  bool _isEnglish = true;
  late TabController _tabController;

  // Custom Input State
  final TextEditingController _sController = TextEditingController(text: "cbaebabacd");
  final TextEditingController _pController = TextEditingController(text: "abc");
  String _s = "cbaebabacd";
  String _p = "abc";
  List<FindAnagramsStep> _steps = [];

  // Playback Control
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  // Code Language Selector
  String _selectedCodeLang = "C++";

  // Tab 2 Animation Model Selector (0: Step Flowcard, 1: Frequency Matcher Rule, 2: Complexity Calculator)
  int _animationModelIndex = 0;
  int _flowStepIndex = 0;

  // Practice Mode State
  int _practiceLeft = 0;
  List<int> _userFoundIndices = [];
  String _userFeedbackEn = "Slide window of size |p| across string s and identify anagram start indices!";
  String _userFeedbackBn = "অ্যানাগ্রামের শুরুর ইনডেক্স চিহ্নিত করতে s স্ট্রিং জুড়ে |p| সাইজের উইন্ডো স্লাইড করুন!";
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
    _pController.dispose();
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

    String textS = _sController.text.trim().toLowerCase();
    String textP = _pController.text.trim().toLowerCase();
    if (textS.isEmpty) textS = "cbaebabacd";
    if (textP.isEmpty) textP = "abc";
    _s = textS;
    _p = textP;

    _steps = _generateSteps(_s, _p);

    // Reset practice mode
    _resetPractice();
  }

  void _resetPractice() {
    _practiceLeft = 0;
    _userFoundIndices = [];
    _practiceSolved = false;
    _userFeedbackEn = "Inspect window at index $_practiceLeft of string s!";
    _userFeedbackBn = "স্ট্রিং s এর ইনডেক্স $_practiceLeft এর উইন্ডো পরীক্ষা করুন!";
  }

  List<FindAnagramsStep> _generateSteps(String sStr, String pStr) {
    List<FindAnagramsStep> steps = [];
    int sLen = sStr.length;
    int pLen = pStr.length;
    List<int> results = [];

    // Step 0: Init
    steps.add(FindAnagramsStep(
      left: 0,
      right: pLen - 1,
      windowSub: "",
      isAnagram: false,
      resultIndices: [],
      decision: "init",
      activeLine: 1,
      actionEn: "Line 1: Initialize Frequency Matching Window for s = '$sStr', p = '$pStr'.",
      actionBn: "লাইন ১: s = '$sStr', p = '$pStr' এর জন্য ফ্রিকোয়েন্সি ম্যাচিং উইন্ডো শুরু।",
      reasonEn: "Maintain 26-char frequency counts for p and current window of s of length ${pStr.length}.",
      reasonBn: "p এবং s এর ${pStr.length} দৈর্ঘ্যের বর্তমান উইন্ডোর জন্য ২৬-অক্ষরের ফ্রিকোয়েন্সি মেইনটেইন করা হবে।",
    ));

    if (sLen < pLen) {
      steps.add(FindAnagramsStep(
        left: 0,
        right: 0,
        windowSub: sStr,
        isAnagram: false,
        resultIndices: [],
        decision: "finished",
        activeLine: 2,
        actionEn: "🏁 Line 2: String s length ($sLen) < p length ($pLen). Return empty list [].",
        actionBn: "🏁 লাইন ২: স্ট্রিং s এর দৈর্ঘ্য ($sLen) < p এর দৈর্ঘ্য ($pLen)। ফাঁকা তালিকা [] রিটার্ন করুন।",
        reasonEn: "s is shorter than target pattern p.",
        reasonBn: "s এর দৈর্ঘ্য টার্গেট প্যাটার্ন p এর চেয়ে ছোট।",
      ));
      return steps;
    }

    List<int> pFreq = List.filled(26, 0);
    List<int> sFreq = List.filled(26, 0);

    for (int i = 0; i < pLen; i++) {
      pFreq[pStr.codeUnitAt(i) - 97]++;
      sFreq[sStr.codeUnitAt(i) - 97]++;
    }

    bool isFirstMatch = _areFreqsEqual(pFreq, sFreq);
    if (isFirstMatch) results.add(0);

    steps.add(FindAnagramsStep(
      left: 0,
      right: pLen - 1,
      windowSub: sStr.substring(0, pLen),
      isAnagram: isFirstMatch,
      resultIndices: List.from(results),
      decision: isFirstMatch ? "anagram_found" : "build_first_window",
      activeLine: 4,
      actionEn: isFirstMatch
          ? "🎉 Line 4: First Window [0..${pLen - 1}] '${sStr.substring(0, pLen)}' IS AN ANAGRAM of '$pStr'! Result = [${results.join(', ')}]."
          : "🪟 Line 4: First Window [0..${pLen - 1}] '${sStr.substring(0, pLen)}' ➔ Frequency mismatch.",
      actionBn: isFirstMatch
          ? "🎉 লাইন ৪: প্রথম উইন্ডো [0..${pLen - 1}] '${sStr.substring(0, pLen)}' হলো '$pStr' এর একটি অ্যানাগ্রাম! ফলাফল = [${results.join(', ')}]।"
          : "🪟 লাইন ৪: প্রথম উইন্ডো [0..${pLen - 1}] '${sStr.substring(0, pLen)}' ➔ ফ্রিকোয়েন্সি মেলেনি।",
      reasonEn: isFirstMatch
          ? "All character frequencies match pattern p perfectly."
          : "Character frequencies do not match pattern p.",
      reasonBn: isFirstMatch
          ? "সমস্ত অক্ষরের ফ্রিকোয়েন্সি প্যাটার্ন p এর সাথে মিলে গেছে।"
          : "অক্ষরের ফ্রিকোয়েন্সি প্যাটার্ন p এর সাথে মেলেনি।",
    ));

    // Slide window right
    for (int i = pLen; i < sLen; i++) {
      int l = i - pLen + 1;
      int r = i;

      sFreq[sStr.codeUnitAt(r) - 97]++;
      sFreq[sStr.codeUnitAt(l - 1) - 97]--;

      bool isMatch = _areFreqsEqual(pFreq, sFreq);
      if (isMatch) results.add(l);

      steps.add(FindAnagramsStep(
        left: l,
        right: r,
        windowSub: sStr.substring(l, r + 1),
        isAnagram: isMatch,
        resultIndices: List.from(results),
        decision: isMatch ? "anagram_found" : "slide_window",
        activeLine: isMatch ? 8 : 7,
        actionEn: isMatch
            ? "🎉 Line 8: Window [${l}..${r}] '${sStr.substring(l, r + 1)}' IS AN ANAGRAM! Added start index $l ➔ Result = [${results.join(', ')}]."
            : "➡️ Line 7: Slide Window [${l}..${r}] '${sStr.substring(l, r + 1)}' ➔ Mismatch.",
        actionBn: isMatch
            ? "🎉 লাইন ৮: উইন্ডো [${l}..${r}] '${sStr.substring(l, r + 1)}' হলো একটি অ্যানাগ্রাম! শুরুর ইনডেক্স $l যুক্ত ➔ ফলাফল = [${results.join(', ')}]।"
            : "➡️ লাইন ৭: উইন্ডো স্লাইড [${l}..${r}] '${sStr.substring(l, r + 1)}' ➔ ফ্রিকোয়েন্সি মেলেনি।",
        reasonEn: isMatch
            ? "Frequency array matches pattern p! Record start index $l."
            : "Window substring is not an anagram of p.",
        reasonBn: isMatch
            ? "ফ্রিকোয়েন্সি অ্যারে প্যাটার্ন p এর সাথে মিলেছে! শুরুর ইনডেক্স $l রেকর্ড করুন।"
            : "উইন্ডো সাব-স্ট্রিংটি p এর অ্যানাগ্রাম নয়।",
      ));
    }

    steps.add(FindAnagramsStep(
      left: sLen - pLen,
      right: sLen - 1,
      windowSub: sStr.substring(sLen - pLen),
      isAnagram: false,
      resultIndices: List.from(results),
      decision: "finished",
      activeLine: 10,
      actionEn: "🏁 Line 10: Sliding Window Search Complete! All Anagram Start Indices = [${results.join(', ')}].",
      actionBn: "🏁 লাইন ১০: স্লাইডিং উইন্ডো অনুসন্ধান সম্পন্ন! সমস্ত অ্যানাগ্রামের শুরুর ইনডেক্স = [${results.join(', ')}]।",
      reasonEn: "All substrings of length |p| evaluated in O(N) linear time.",
      reasonBn: "O(N) লিনিয়ার সময়ে |p| দৈর্ঘ্যের সমস্ত সাব-স্ট্রিং মূল্যায়ন সম্পন্ন।",
    ));

    return steps;
  }

  bool _areFreqsEqual(List<int> f1, List<int> f2) {
    for (int i = 0; i < 26; i++) {
      if (f1[i] != f2[i]) return false;
    }
    return true;
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

  List<int> _solveFindAnagrams(String sStr, String pStr) {
    List<int> res = [];
    if (sStr.length < pStr.length) return res;

    List<int> pFreq = List.filled(26, 0);
    List<int> sFreq = List.filled(26, 0);
    int pLen = pStr.length;

    for (int i = 0; i < pLen; i++) {
      pFreq[pStr.codeUnitAt(i) - 97]++;
      sFreq[sStr.codeUnitAt(i) - 97]++;
    }

    if (_areFreqsEqual(pFreq, sFreq)) res.add(0);

    for (int i = pLen; i < sStr.length; i++) {
      sFreq[sStr.codeUnitAt(i) - 97]++;
      sFreq[sStr.codeUnitAt(i - pLen) - 97]--;
      if (_areFreqsEqual(pFreq, sFreq)) res.add(i - pLen + 1);
    }
    return res;
  }

  void _handlePracticeCheckWindow(bool userClaimAnagram) {
    if (_practiceSolved || _practiceLeft + _p.length > _s.length) return;
    List<int> expectedIndices = _solveFindAnagrams(_s, _p);
    bool actualIsAnagram = expectedIndices.contains(_practiceLeft);

    setState(() {
      if (userClaimAnagram == actualIsAnagram) {
        if (actualIsAnagram) _userFoundIndices.add(_practiceLeft);

        _practiceLeft++;
        if (_practiceLeft + _p.length > _s.length) {
          _practiceSolved = true;
          _userFeedbackEn = "🏆 MASTERED! You found all anagram start indices: [${_userFoundIndices.join(', ')}]!";
          _userFeedbackBn = "🏆 দারুণ! আপনি সমস্ত অ্যানাগ্রামের শুরুর ইনডেক্স খুঁজে পেয়েছেন: [${_userFoundIndices.join(', ')}]!";
        } else {
          _userFeedbackEn = "Correct! Substring starting at ${_practiceLeft - 1} is ${actualIsAnagram ? 'AN ANAGRAM' : 'NOT an anagram'}. Next: Inspect index $_practiceLeft.";
          _userFeedbackBn = "সঠিক! ${_practiceLeft - 1} ইনডেক্সের সাব-স্ট্রিংটি হলো ${actualIsAnagram ? 'একটি অ্যানাগ্রাম' : 'অ্যানাগ্রাম নয়'}। পরের: ইনডেক্স $_practiceLeft পরীক্ষা করুন।";
        }
      } else {
        _userFeedbackEn = "Incorrect! Window '${_s.substring(_practiceLeft, _practiceLeft + _p.length)}' is ${actualIsAnagram ? 'AN ANAGRAM of ' + _p : 'NOT an anagram'}. Try again!";
        _userFeedbackBn = "ভুল উত্তর! উইন্ডো '${_s.substring(_practiceLeft, _practiceLeft + _p.length)}' হলো ${actualIsAnagram ? _p + ' এর একটি অ্যানাগ্রাম' : 'অ্যানাগ্রাম নয়'}। আবার চেষ্টা করুন!";
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
          '438. Find All Anagrams in a String',
          style: TextStyle(fontSize: Responsive.sp(context, 17), fontWeight: FontWeight.bold),
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
                    "438. Find All Anagrams in a String",
                    style: TextStyle(fontSize: Responsive.sp(context, 20), fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.accentAmber.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.accentAmber),
                  ),
                  child: const Text("Medium", style: TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              children: ["Meta", "Amazon", "Microsoft"].map((company) {
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
                        ? "Given two strings s and p, return an array of all the start indices of p's anagrams in s. An Anagram is a word or phrase formed by rearranging the letters of a different word or phrase."
                        : "দুটি স্ট্রিং s এবং p দেওয়া আছে। s স্ট্রিংয়ের ভেতরে p এর অ্যানাগ্রামসমূহের সমস্ত শুরুর ইনডেক্স খুঁজে বের করে রিটার্ন করুন।",
                    style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Examples
            Text(_isEnglish ? "Examples" : "উদাহরণসমূহ", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            _buildExampleCard("Example 1", "s = \"cbaebabacd\", p = \"abc\"", "Output: [0, 6] (Substrings \"cba\" at 0 and \"bac\" at 6)"),
            _buildExampleCard("Example 2", "s = \"abab\", p = \"ab\"", "Output: [0, 1, 2]"),
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
                        _isEnglish ? "Key Intuition (26-Char Frequency Matcher)" : "মূল আইডিয়া (২৬-অক্ষরের ফ্রিকোয়েন্সি ম্যাচিং)",
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isEnglish
                        ? "1. Maintain 26-size frequency arrays for p and window of s of length |p|.\n2. Slide window 1 step right: increment sFreq[s[i]], decrement sFreq[s[i - |p|]].\n3. Record start index whenever sFreq == pFreq in O(N * 26) = O(N) linear time."
                        : "১. প্যাটার্ন p এবং |p| সাইজের s এর উইন্ডোর জন্য ২৬ আকারের ফ্রিকোয়েন্সি অ্যারে মেইনটেইন করুন।\n২. উইন্ডো স্লাইড করার সময় sFreq[s[i]]++ এবং sFreq[s[i - |p|]]-- করুন।\n৩. sFreq == pFreq হলে শুরুর ইনডেক্স রেকর্ড করুন। O(N * 26) = O(N) লিনিয়ার সময়।",
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
              _isEnglish ? "Find All Anagrams Visual Models" : "সমস্ত অ্যানাগ্রাম খোঁজার ভিজ্যুয়াল মডেলসমূহ (কোডহীন গাইড)",
              style: TextStyle(fontSize: Responsive.sp(context, 18), fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 6),
            Text(
              _isEnglish
                  ? "Explore 3 interactive models for s = \"cbaebabacd\", p = \"abc\"."
                  : "s = \"cbaebabacd\", p = \"abc\" এর জন্য ৩টি ইন্টারঅ্যাক্টিভ ভিজ্যুয়াল মডেল পর্যবেক্ষণ করুন।",
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 16),

            // Model Switcher Segmented Control
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildAnimationModelChip(0, _isEnglish ? "1. 🪜 Step Flowcard" : "১. 🪜 স্টেপ-বাই-স্টেপ ফ্লো-কার্ড"),
                  _buildAnimationModelChip(1, _isEnglish ? "2. 📊 Frequency Matcher Rule" : "২. 📊 ফ্রিকোয়েন্সি ম্যাচিং নীতি"),
                  _buildAnimationModelChip(2, _isEnglish ? "3. 📊 Complexity Calculator" : "৩. 📊 টাইমিং ক্যালকুলেটর"),
                ],
              ),
            ),
            const SizedBox(height: 20),

            if (_animationModelIndex == 0) _buildStepFlowcardModel(),
            if (_animationModelIndex == 1) _buildFrequencyMatcherRuleModel(),
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
        "window": "\"cba\"",
        "isAnagram": true,
        "results": "[0]",
        "badge": "🎉 ANAGRAM AT INDEX 0",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 1: First Window [0..2] = \"cba\" ➔ Match! Anagram found at index 0!",
        "titleBn": "ধাপ ১: প্রথম উইন্ডো [0..2] = \"cba\" ➔ মিলেছে! ইনডেক্স ০ এ অ্যানাগ্রাম পাওয়া গেছে!",
        "descEn": "'cba' has exact same frequencies as 'abc'. Recorded index 0.",
        "descBn": "'cba' এর অক্ষরের ফ্রিকোয়েন্সি 'abc' এর হুবহু সমান। ইনডেক্স 0 রেকর্ড করা হলো।",
      },
      {
        "step": 2,
        "window": "\"bae\"",
        "isAnagram": false,
        "results": "[0]",
        "badge": "➡️ SLIDE RIGHT",
        "badgeColor": AppTheme.accentAmber,
        "titleEn": "Step 2: Slide Right (+e, -c) ➔ Window [1..3] = \"bae\" (Mismatch)",
        "titleBn": "ধাপ ২: ডানে স্লাইড (+e, -c) ➔ উইন্ডো [1..3] = \"bae\" (মেলেনি)",
        "descEn": "'e' is not in pattern 'abc'.",
        "descBn": "'e' অক্ষরটি প্যাটার্ন 'abc' তে নেই।",
      },
      {
        "step": 3,
        "window": "\"bac\"",
        "isAnagram": true,
        "results": "[0, 6]",
        "badge": "🎉 ANAGRAM AT INDEX 6",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 3: Slide to Window [6..8] = \"bac\" ➔ Match! Anagram found at index 6!",
        "titleBn": "ধাপ ৩: স্লাইড করে উইন্ডো [6..8] = \"bac\" ➔ মিলেছে! ইনডেক্স ৬ এ অ্যানাগ্রাম পাওয়া গেছে!",
        "descEn": "'bac' is a valid anagram of 'abc'. Recorded index 6.",
        "descBn": "'bac' হলো 'abc' এর একটি বৈধ্য অ্যানাগ্রাম। ইনডেক্স 6 রেকর্ড করা হলো।",
      },
      {
        "step": 4,
        "window": "\"acd\"",
        "isAnagram": false,
        "results": "[0, 6]",
        "badge": "🏁 COMPLETE",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 4: All Windows Evaluated! Final Anagram Indices = [0, 6]",
        "titleBn": "ধাপ ৪: সমস্ত উইন্ডো মূল্যায়ন সম্পন্ন! চূড়ান্ত অ্যানাগ্রাম ইনডেক্স = [0, 6]",
        "descEn": "O(N) sliding window frequency search finished! 🎉",
        "descBn": "O(N) স্লাইডিং উইন্ডো ফ্রিকোয়েন্সি অনুসন্ধান সম্পন্ন! 🎉",
      },
    ];

    final currentStep = stepFlowData[_flowStepIndex.clamp(0, stepFlowData.length - 1)];
    final String window = currentStep["window"] as String;
    final String resultsStr = currentStep["results"] as String;
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
                _isEnglish ? "1. Step-by-Step Anagram Flowcard" : "১. স্টেপ-বাই-স্টেপ অ্যানাগ্রাম ফ্লো-কার্ড",
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
                ? "Watch fixed window sliding and anagram start index recording."
                : "ফিক্সড উইন্ডো স্লাইডিং এবং অ্যানাগ্রামের শুরুর ইনডেক্স রেকর্ডিং দেখুন।",
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
                    Text("Window = $window", style: TextStyle(color: badgeColor, fontWeight: FontWeight.bold, fontSize: 12)),
                    Text("Found Indices = $resultsStr", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
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
                    "Result List: $resultsStr",
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 18,
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

  // MODEL 2: Frequency Matcher Rule
  Widget _buildFrequencyMatcherRuleModel() {
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
            _isEnglish ? "2. 26-Character Frequency Array Comparison" : "২. ২৬-অক্ষরের ফ্রিকোয়েন্সি অ্যারে তুলনা নীতি",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            _isEnglish
                ? "Instead of sorting, maintain frequency counters for 'a' through 'z':\nsFreq[s[i]-'a']++ and sFreq[s[i-|p|]-'a']--"
                : "সর্টিং এর বদলে 'a' থেকে 'z' এর ফ্রিকোয়েন্সি কাউন্টার বজায় রাখুন:\nsFreq[s[i]-'a']++ এবং sFreq[s[i-|p|]-'a']--",
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
              "if (sFreq == pFreq) result.push_back(left); 📊",
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
            _isEnglish ? "3. O(N * 26) = O(N) Time vs O(1) Space" : "৩. O(N * 26) = O(N) টাইম বনাম O(1) স্পেস",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            _isEnglish
                ? "Comparing two 26-size frequency arrays takes 26 operations = O(1).\nIterating across length N string takes O(N * 26) = O(N) total time."
                : "২৬ সাইজের দুটি ফ্রিকোয়েন্সি অ্যারে মেলাতে মাত্র ২৬ টি কাজ লাগে = O(1)।\nN দৈর্ঘ্যের স্ট্রিং স্ক্যান করতে সর্বমোট O(N * 26) = O(N) সময় লাগে।",
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
              "Time Complexity: O(N)\nSpace Complexity: O(1) (26 counters) 🎉",
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
                          labelText: _isEnglish ? "String s (e.g. cbaebabacd)" : "স্ট্রিং s (যেমন cbaebabacd)",
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
                        controller: _pController,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          labelText: _isEnglish ? "Pattern p" : "প্যাটার্ন p",
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
                      _buildPresetChip("cbaebabacd", "abc"),
                      _buildPresetChip("abab", "ab"),
                      _buildPresetChip("afdgzyxksldfm", "k"),
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
                  _buildAnagramCanvas(step),
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildCodeHighlightBox(step.activeLine)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildAnagramCanvas(step)),
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
    final expectedIndices = _solveFindAnagrams(_s, _p);

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
                  ? "Inspect window of size |p| = ${_p.length} and decide if it is an anagram of '$_p'!"
                  : "স্ট্রিং s এ |p| = ${_p.length} সাইজের উইন্ডো দেখে '$_p' এর অ্যানাগ্রাম কিনা সিদ্ধান্ত নিন!",
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

            // Active Practice Window Box
            if (!_practiceSolved && _practiceLeft + _p.length <= _s.length)
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
                        Text("Inspecting Start Index: [$_practiceLeft]", style: const TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 12)),
                        Text("Expected Indices: [${expectedIndices.join(', ')}]", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Window: \"${_s.substring(_practiceLeft, _practiceLeft + _p.length)}\" (Pattern: \"$_p\")",
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accentGreen,
                            foregroundColor: AppTheme.primaryDark,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          ),
                          icon: const Icon(Icons.check_circle),
                          label: Text(_isEnglish ? "ANAGRAM (Match)" : "অ্যানাগ্রাম (মিলেছে)"),
                          onPressed: () => _handlePracticeCheckWindow(true),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accentPink,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          ),
                          icon: const Icon(Icons.cancel),
                          label: Text(_isEnglish ? "NOT Anagram" : "অ্যানাগ্রাম নয়"),
                          onPressed: () => _handlePracticeCheckWindow(false),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 12),
            if (_practiceLeft > 0 || _practiceSolved)
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
  Widget _buildPresetChip(String sVal, String pVal) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ActionChip(
        backgroundColor: const Color(0xFF090D16),
        label: Text("s='$sVal', p='$pVal'", style: const TextStyle(color: AppTheme.accentNeonCyan, fontSize: 11)),
        onPressed: () {
          _sController.text = sVal;
          _pController.text = pVal;
          _rebuildSteps();
        },
      ),
    );
  }

  Widget _buildCodeHighlightBox(int activeLine) {
    final codeLines = [
      "vector<int> findAnagrams(string s, string p) {",
      "    vector<int> res; int sLen = s.size(), pLen = p.size();",
      "    if (sLen < pLen) return res;",
      "    vector<int> pFreq(26, 0), sFreq(26, 0);",
      "    for (int i = 0; i < pLen; i++) { pFreq[p[i]-'a']++; sFreq[s[i]-'a']++; }",
      "    if (pFreq == sFreq) res.push_back(0);",
      "    for (int i = pLen; i < sLen; i++) {",
      "        sFreq[s[i]-'a']++; sFreq[s[i-pLen]-'a']--;",
      "        if (pFreq == sFreq) res.push_back(i - pLen + 1);",
      "    }",
      "    return res;",
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

  Widget _buildAnagramCanvas(FindAnagramsStep step) {
    Color decisionColor = AppTheme.accentPurple;
    String decisionLabel = "INIT";

    if (step.decision == "build_first_window") {
      decisionColor = AppTheme.accentNeonCyan;
      decisionLabel = "🪟 BUILD WINDOW";
    } else if (step.decision == "slide_window") {
      decisionColor = AppTheme.accentAmber;
      decisionLabel = "➡️ SLIDE WINDOW";
    } else if (step.decision == "anagram_found") {
      decisionColor = AppTheme.accentGreen;
      decisionLabel = "🎉 ANAGRAM FOUND";
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
              Text("Window: [${step.left}..${step.right}] (|p| = ${_p.length})", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13)),
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

          // Substring & Anagram Indices Box
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Window Substring = \"${step.windowSub}\"", style: TextStyle(color: decisionColor, fontWeight: FontWeight.bold, fontSize: 12)),
              Text("Pattern p = \"$_p\"", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
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
                  "Anagram Start Indices = [ ${step.resultIndices.join(', ')} ]",
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
                  "Sub-window: \"${step.windowSub}\"",
                  style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Visual String Canvas
          const Text("String s Sequence Canvas:", style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_s.length, (idx) {
                bool inWindow = idx >= step.left && idx <= step.right;

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: inWindow ? decisionColor.withOpacity(0.3) : AppTheme.surfaceDark,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: inWindow ? decisionColor : const Color(0xFF334155),
                      width: inWindow ? 2.0 : 1.0,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        _s[idx],
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: inWindow ? Colors.white : const Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "[$idx]",
                        style: const TextStyle(fontSize: 9, color: Color(0xFF64748B)),
                      ),
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
    vector<int> findAnagrams(string s, string p) {
        vector<int> res;
        int sLen = s.size(), pLen = p.size();
        if (sLen < pLen) return res;

        vector<int> pFreq(26, 0), sFreq(26, 0);
        for (int i = 0; i < pLen; i++) {
            pFreq[p[i] - 'a']++;
            sFreq[s[i] - 'a']++;
        }

        if (pFreq == sFreq) res.push_back(0);

        for (int i = pLen; i < sLen; i++) {
            sFreq[s[i] - 'a']++;
            sFreq[s[i - pLen] - 'a']--;
            if (pFreq == sFreq) {
                res.push_back(i - pLen + 1);
            }
        }
        return res;
    }
};""";
    } else if (lang == "Java") {
      code = """
class Solution {
    public List<Integer> findAnagrams(String s, String p) {
        List<Integer> res = new ArrayList<>();
        if (s.length() < p.length()) return res;

        int[] pFreq = new int[26];
        int[] sFreq = new int[26];
        int pLen = p.length();

        for (int i = 0; i < pLen; i++) {
            pFreq[p.charAt(i) - 'a']++;
            sFreq[s.charAt(i) - 'a']++;
        }

        if (Arrays.equals(pFreq, sFreq)) res.add(0);

        for (int i = pLen; i < s.length(); i++) {
            sFreq[s.charAt(i) - 'a']++;
            sFreq[s.charAt(i - pLen) - 'a']--;
            if (Arrays.equals(pFreq, sFreq)) {
                res.add(i - pLen + 1);
            }
        }
        return res;
    }
}""";
    } else {
      code = """
class Solution:
    def findAnagrams(self, s: str, p: str) -> List[int]:
        if len(s) < len(p):
            return []
        
        p_count = Counter(p)
        s_count = Counter(s[:len(p)-1])
        res = []

        for i in range(len(p) - 1, len(s)):
            s_count[s[i]] += 1
            if s_count == p_count:
                res.append(i - len(p) + 1)
            s_count[s[i - len(p) + 1]] -= 1
            if s_count[s[i - len(p) + 1]] == 0:
                del s_count[s[i - len(p) + 1]]

        return res""";
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
