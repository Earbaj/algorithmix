import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class MinimumWindowSubstringStep {
  final int left;
  final int right;
  final String sSub;
  final Map<String, int> windowMap;
  final Map<String, int> targetMap;
  final int formedCount;
  final int requiredCount;
  final int minLen;
  final String minWindowStr;
  final String decision; // 'init', 'expand', 'shrink_left', 'min_updated', 'finished'
  final int activeLine;
  final String actionEn;
  final String actionBn;
  final String reasonEn;
  final String reasonBn;

  const MinimumWindowSubstringStep({
    required this.left,
    required this.right,
    required this.sSub,
    required this.windowMap,
    required this.targetMap,
    required this.formedCount,
    required this.requiredCount,
    required this.minLen,
    required this.minWindowStr,
    required this.decision,
    required this.activeLine,
    required this.actionEn,
    required this.actionBn,
    required this.reasonEn,
    required this.reasonBn,
  });
}

class MinimumWindowSubstringDetailScreen extends StatefulWidget {
  const MinimumWindowSubstringDetailScreen({super.key});

  @override
  State<MinimumWindowSubstringDetailScreen> createState() =>
      _MinimumWindowSubstringDetailScreenState();
}

class _MinimumWindowSubstringDetailScreenState
    extends State<MinimumWindowSubstringDetailScreen>
    with SingleTickerProviderStateMixin {
  bool _isEnglish = true;
  late TabController _tabController;

  // Custom Input State
  final TextEditingController _sController = TextEditingController(text: "ADOBECODEBANC");
  final TextEditingController _tController = TextEditingController(text: "ABC");
  String _s = "ADOBECODEBANC";
  String _t = "ABC";
  List<MinimumWindowSubstringStep> _steps = [];

  // Playback Control
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  // Code Language Selector
  String _selectedCodeLang = "C++";

  // Tab 2 Animation Model Selector (0: Step Flowcard, 1: Formed Matches Rule, 2: Complexity Calculator)
  int _animationModelIndex = 0;
  int _flowStepIndex = 0;

  // Practice Mode State
  int _practiceRight = 0;
  int _practiceLeft = 0;
  int _practiceMinLen = 999999;
  String _userFeedbackEn = "Expand right pointer to match all characters in t, then shrink left to minimize window!";
  String _userFeedbackBn = "t এর সমস্ত ক্যারেক্টার না মেলা পর্যন্ত ডান বাড়ান, তারপর বাম থেকে কমিয়ে শর্টেস্ট বের করুন!";
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
    _tController.dispose();
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
    String tVal = _tController.text.trim();

    if (sVal.isEmpty || tVal.isEmpty) {
      sVal = "ADOBECODEBANC";
      tVal = "ABC";
    }

    _s = sVal;
    _t = tVal;

    _steps = _generateSteps(_s, _t);

    // Reset practice mode
    _resetPractice();
  }

  void _resetPractice() {
    _practiceLeft = 0;
    _practiceRight = 0;
    _practiceMinLen = 999999;
    _practiceSolved = false;
    _userFeedbackEn = "Inspect element at right = 0 ('${_s.isNotEmpty ? _s[0] : ''}') for target t = \"$_t\"!";
    _userFeedbackBn = "টার্গেট t = \"$_t\" এর জন্য ইনডেক্স right = 0 ('${_s.isNotEmpty ? _s[0] : ''}') পরীক্ষা করুন!";
  }

  List<MinimumWindowSubstringStep> _generateSteps(String sStr, String tStr) {
    List<MinimumWindowSubstringStep> steps = [];
    int m = sStr.length;
    int n = tStr.length;

    Map<String, int> targetMap = {};
    for (int i = 0; i < n; i++) {
      String ch = tStr[i];
      targetMap[ch] = (targetMap[ch] ?? 0) + 1;
    }
    int requiredCount = targetMap.length;

    // Step 0: Init
    steps.add(MinimumWindowSubstringStep(
      left: 0,
      right: 0,
      sSub: m > 0 ? sStr[0] : "",
      windowMap: {},
      targetMap: Map.from(targetMap),
      formedCount: 0,
      requiredCount: requiredCount,
      minLen: 0,
      minWindowStr: "",
      decision: "init",
      activeLine: 1,
      actionEn: "Line 1: Initialize Minimum Window Substring for s = \"$sStr\", t = \"$tStr\". Target map = $targetMap.",
      actionBn: "লাইন ১: s = \"$sStr\", t = \"$tStr\" এর জন্য মিনিমাম উইন্ডো সার্চ শুরু। টার্গেট ম্যাপ = $targetMap।",
      reasonEn: "We expand right pointer until formedCount == requiredCount ($requiredCount), then shrink left pointer greedily.",
      reasonBn: "আমরা formedCount == requiredCount ($requiredCount) না হওয়া পর্যন্ত ডান পয়েন্টার বাড়াব, তারপর বাম পয়েন্টার কমিয়ে মিনিমাম উইন্ডো বের করব।",
    ));

    if (m < n || m == 0 || n == 0) {
      steps.add(MinimumWindowSubstringStep(
        left: 0,
        right: 0,
        sSub: "",
        windowMap: {},
        targetMap: Map.from(targetMap),
        formedCount: 0,
        requiredCount: requiredCount,
        minLen: 0,
        minWindowStr: "",
        decision: "finished",
        activeLine: 2,
        actionEn: "🏁 Line 2: String s is shorter than t or empty! Return \"\".",
        actionBn: "🏁 লাইন ২: s এর দৈর্ঘ্য t এর চেয়ে ছোট অথবা খালি! \"\" রিটার্ন করুন।",
        reasonEn: "Impossible to contain all characters of t.",
        reasonBn: "t এর সমস্ত ক্যারেক্টার ধারণ করা অসম্ভব।",
      ));
      return steps;
    }

    int l = 0;
    int formed = 0;
    int minLen = 999999;
    String minWindowStr = "";
    Map<String, int> windowMap = {};

    for (int r = 0; r < m; r++) {
      String ch = sStr[r];
      windowMap[ch] = (windowMap[ch] ?? 0) + 1;

      if (targetMap.containsKey(ch) && windowMap[ch] == targetMap[ch]) {
        formed++;
      }

      while (formed == requiredCount && l <= r) {
        int windowLen = r - l + 1;
        bool isNewMin = windowLen < minLen;

        if (isNewMin) {
          minLen = windowLen;
          minWindowStr = sStr.substring(l, r + 1);
          steps.add(MinimumWindowSubstringStep(
            left: l,
            right: r,
            sSub: sStr.substring(l, r + 1),
            windowMap: Map.from(windowMap),
            targetMap: Map.from(targetMap),
            formedCount: formed,
            requiredCount: requiredCount,
            minLen: minLen,
            minWindowStr: minWindowStr,
            decision: "min_updated",
            activeLine: 8,
            actionEn: "🎉 Line 8: NEW Minimal Valid Window Substring! Window [${l}..${r}] \"$minWindowStr\" (Length = $minLen)!",
            actionBn: "🎉 লাইন ৮: নতুন সর্বনিম্ন বৈধ্য উইন্ডো সাব-স্ট্রিং! উইন্ডো [${l}..${r}] \"$minWindowStr\" (দৈর্ঘ্য = $minLen)!",
            reasonEn: "All $requiredCount character frequencies in t are satisfied with smaller window size $windowLen!",
            reasonBn: "t এর সমস্ত $requiredCount টি ক্যারেক্টারের ফ্রিকোয়েন্সি ক্ষুদ্রতর উইন্ডো সাইজ $windowLen এ পাওয়া গেছে!",
          ));
        }

        steps.add(MinimumWindowSubstringStep(
          left: l,
          right: r,
          sSub: sStr.substring(l, r + 1),
          windowMap: Map.from(windowMap),
          targetMap: Map.from(targetMap),
          formedCount: formed,
          requiredCount: requiredCount,
          minLen: minLen,
          minWindowStr: minWindowStr,
          decision: "shrink_left",
          activeLine: 9,
          actionEn: "⬅️ Line 9: Valid Window (\"${sStr.substring(l, r + 1)}\")! Remove s[$l] ('${sStr[l]}') and shrink left pointer to ${l + 1}.",
          actionBn: "⬅️ লাইন ৯: বৈধ্য উইন্ডো (\"${sStr.substring(l, r + 1)}\")! s[$l] ('${sStr[l]}') রিমুভ করে বাম পয়েন্টার বাড়িয়ে ${l + 1} এ আনা হলো।",
          reasonEn: "Shrink left pointer to find if a smaller window can also satisfy all characters in t.",
          reasonBn: "ক্ষুদ্রতর উইন্ডোও t এর সব ক্যারেক্টার ধারণ করতে পারে কিনা দেখতে বাম পয়েন্টার কমানো হলো।",
        ));

        String leftChar = sStr[l];
        windowMap[leftChar] = windowMap[leftChar]! - 1;
        if (targetMap.containsKey(leftChar) && windowMap[leftChar]! < targetMap[leftChar]!) {
          formed--;
        }
        l++;
      }

      steps.add(MinimumWindowSubstringStep(
        left: l,
        right: r,
        sSub: l <= r ? sStr.substring(l, r + 1) : "",
        windowMap: Map.from(windowMap),
        targetMap: Map.from(targetMap),
        formedCount: formed,
        requiredCount: requiredCount,
        minLen: minLen == 999999 ? 0 : minLen,
        minWindowStr: minWindowStr,
        decision: "expand",
        activeLine: 5,
        actionEn: "➡️ Line 5: Expand right to $r ('${sStr[r]}') ➔ Window [${l}..${r}] (Formed = $formed / $requiredCount, Min = ${minLen == 999999 ? 0 : minLen}).",
        actionBn: "➡️ লাইন ৫: ডান পয়েন্টার $r ('${sStr[r]}') এ বাড়ানো হলো ➔ উইন্ডো [${l}..${r}] (মিলেছে = $formed / $requiredCount, সর্বমোট = ${minLen == 999999 ? 0 : minLen})।",
        reasonEn: "Add s[$r] ('${sStr[r]}') to active window frequency map.",
        reasonBn: "সক্রিয় উইন্ডো ফ্রিকোয়েন্সি ম্যাপে s[$r] ('${sStr[r]}') যোগ করা হলো।",
      ));
    }

    int resultLen = minLen == 999999 ? 0 : minLen;

    steps.add(MinimumWindowSubstringStep(
      left: l < m ? l : m - 1,
      right: m - 1,
      sSub: l < m ? sStr.substring(l) : "",
      windowMap: Map.from(windowMap),
      targetMap: Map.from(targetMap),
      formedCount: formed,
      requiredCount: requiredCount,
      minLen: resultLen,
      minWindowStr: minWindowStr,
      decision: "finished",
      activeLine: 13,
      actionEn: resultLen > 0
          ? "🏁 Line 13: Traversal Complete! Minimum Window Substring = \"$minWindowStr\" (Length = $resultLen)."
          : "🏁 Line 13: Traversal Complete! No valid window substring contains all characters of t. Return \"\".",
      actionBn: resultLen > 0
          ? "🏁 লাইন ১৩: স্ক্যান সম্পূর্ণ! মিনিমাম উইন্ডো সাব-স্ট্রিং = \"$minWindowStr\" (দৈর্ঘ্য = $resultLen)।"
          : "🏁 লাইন ১৩: স্ক্যান সম্পূর্ণ! t এর সব ক্যারেক্টার ধারণকারী কোনো বৈধ্য উইন্ডো পাওয়া যায়নি। \"\" রিটার্ন করুন।",
      reasonEn: "Evaluated string s of length $m in O(M + N) linear time.",
      reasonBn: "O(M + N) লিনিয়ার সময়ে $m দৈর্ঘ্যের স্ট্রিং s এর মূল্যায়ন সম্পন্ন।",
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

  String _minWindow(String sStr, String tStr) {
    if (sStr.isEmpty || tStr.isEmpty || sStr.length < tStr.length) return "";
    Map<String, int> targetMap = {};
    for (int i = 0; i < tStr.length; i++) {
      targetMap[tStr[i]] = (targetMap[tStr[i]] ?? 0) + 1;
    }
    int required = targetMap.length;
    int l = 0, formed = 0, minL = 999999, minStart = 0;
    Map<String, int> windowMap = {};

    for (int r = 0; r < sStr.length; r++) {
      String ch = sStr[r];
      windowMap[ch] = (windowMap[ch] ?? 0) + 1;
      if (targetMap.containsKey(ch) && windowMap[ch] == targetMap[ch]) {
        formed++;
      }
      while (formed == required && l <= r) {
        if (r - l + 1 < minL) {
          minL = r - l + 1;
          minStart = l;
        }
        String leftChar = sStr[l];
        windowMap[leftChar] = windowMap[leftChar]! - 1;
        if (targetMap.containsKey(leftChar) && windowMap[leftChar]! < targetMap[leftChar]!) {
          formed--;
        }
        l++;
      }
    }
    return minL == 999999 ? "" : sStr.substring(minStart, minStart + minL);
  }

  void _handlePracticeAction(String actionType) {
    if (_practiceSolved || _practiceRight >= _s.length) return;

    Map<String, int> targetMap = {};
    for (int i = 0; i < _t.length; i++) {
      targetMap[_t[i]] = (targetMap[_t[i]] ?? 0) + 1;
    }
    int required = targetMap.length;
    int l = 0, formed = 0, minL = 999999;
    Map<String, int> windowMap = {};
    bool expectedShrink = false;
    bool expectedMin = false;

    for (int r = 0; r <= _practiceRight; r++) {
      String ch = _s[r];
      windowMap[ch] = (windowMap[ch] ?? 0) + 1;
      if (targetMap.containsKey(ch) && windowMap[ch] == targetMap[ch]) {
        formed++;
      }
      while (formed == required && l <= r) {
        if (r == _practiceRight) expectedShrink = true;
        int len = r - l + 1;
        if (len < minL) {
          if (r == _practiceRight) expectedMin = true;
          minL = len;
        }
        String leftChar = _s[l];
        windowMap[leftChar] = windowMap[leftChar]! - 1;
        if (targetMap.containsKey(leftChar) && windowMap[leftChar]! < targetMap[leftChar]!) {
          formed--;
        }
        l++;
      }
    }

    String expectedAction = "EXPAND";
    if (expectedShrink) expectedAction = "SHRINK";
    if (expectedMin) expectedAction = "MIN_UPDATED";

    setState(() {
      if (actionType == expectedAction || (actionType == "EXPAND" && expectedAction == "EXPAND")) {
        _practiceLeft = l;
        _practiceMinLen = minL;
        _practiceRight++;

        if (_practiceRight >= _s.length) {
          _practiceSolved = true;
          String res = _minWindow(_s, _t);
          _userFeedbackEn = "🏆 MASTERED! You correctly executed Minimum Window Substring! Shortest Window = \"$res\"!";
          _userFeedbackBn = "🏆 দারুণ! আপনি মিনিমাম উইন্ডো সাব-স্ট্রিং অ্যালগরিদম সফলভাবে সম্পন্ন করেছেন! সর্বনিম্ন উইন্ডো = \"$res\"!";
        } else {
          _userFeedbackEn = "Correct! Inspecting index $_practiceRight ('${_s[_practiceRight]}'). Select next step action!";
          _userFeedbackBn = "সঠিক! ইনডেক্স $_practiceRight ('${_s[_practiceRight]}') পরীক্ষা করা হচ্ছে। পরের পদক্ষেপ নির্বাচন করুন!";
        }
      } else {
        _userFeedbackEn = "Incorrect! Index ${_practiceRight} ('${_s[_practiceRight]}') requires action: $expectedAction. Try again!";
        _userFeedbackBn = "ভুল উত্তর! ইনডেক্স ${_practiceRight} ('${_s[_practiceRight]}') এর জন্য সঠিক অ্যাকশন হলো: $expectedAction। আবার চেষ্টা করুন!";
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
          '76. Minimum Window Substring',
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
                    "76. Minimum Window Substring",
                    style: TextStyle(fontSize: Responsive.sp(context, 20), fontWeight: FontWeight.bold, color: Colors.white),
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
              children: ["Meta", "Amazon", "Google", "Uber"].map((company) {
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
                        ? "Given two strings s and t of lengths m and n respectively, return the minimum window substring of s such that every character in t (including duplicates) is included in the window. If there is no such substring, return the empty string \"\"."
                        : "m এবং n দৈর্ঘ্যের দুটি স্ট্রিং s এবং t দেওয়া আছে। s এর এমন একটি সর্বনিম্ন দৈর্ঘ্যের সাব-স্ট্রিং খুঁজে বের করুন যার মধ্যে t এর প্রতিটি ক্যারেক্টার (পুনরাবৃত্ত সহ) বিদ্যমান। এমন কোনো সাব-স্ট্রিং না থাকলে খালি স্ট্রিং \"\" রিটার্ন করুন।",
                    style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Examples
            Text(_isEnglish ? "Examples" : "উদাহরণসমূহ", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            _buildExampleCard("Example 1", "s = \"ADOBECODEBANC\", t = \"ABC\"", "Output: \"BANC\" (Substrings with A,B,C: \"ADOBEC\", \"CODEBA\", \"BANC\" len 4)"),
            _buildExampleCard("Example 2", "s = \"a\", t = \"a\"", "Output: \"a\""),
            _buildExampleCard("Example 3", "s = \"a\", t = \"aa\"", "Output: \"\""),
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
                        _isEnglish ? "Key Intuition (Dynamic Min Window + Frequency Matcher)" : "মূল আইডিয়া (ডাইনামিক মিনিমাম উইন্ডো ও ফ্রিকোয়েন্সি ম্যাচিং)",
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isEnglish
                        ? "1. Expand right pointer and update windowMap. Increment formedCount when character frequency meets targetMap.\n2. Once valid (formedCount == requiredCount), shrink left pointer (left++) greedily to find the absolute smallest valid window substring!\n3. Achieves O(M + N) linear time complexity and O(128) = O(1) space complexity!"
                        : "১. ডান পয়েন্টার বাড়ান এবং windowMap এ ক্যারেক্টার ফ্রিকোয়েন্সি রাখুন। ক্যারেক্টার মিললে formedCount বাড়ান।\n২. শর্ত পূরণ হলেই (formedCount == requiredCount) বাম পয়েন্টার কমিয়ে (left++) ক্ষুদ্রতম বৈধ্য উইন্ডো নির্বাচন করুন।\n৩. O(M + N) লিনিয়ার সময় ও O(1) স্পেস কমপ্লেক্সিটি।",
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
              _isEnglish ? "Minimum Window Visual Models" : "মিনিমাম উইন্ডো ভিজ্যুয়াল মডেলসমূহ (কোডহীন গাইড)",
              style: TextStyle(fontSize: Responsive.sp(context, 18), fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 6),
            Text(
              _isEnglish
                  ? "Explore 3 interactive models for s = \"ADOBECODEBANC\", t = \"ABC\"."
                  : "s = \"ADOBECODEBANC\", t = \"ABC\" এর জন্য ৩টি ইন্টারঅ্যাক্টিভ ভিজ্যুয়াল মডেল পর্যবেক্ষণ করুন।",
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 16),

            // Model Switcher Segmented Control
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildAnimationModelChip(0, _isEnglish ? "1. 🪜 Step Flowcard" : "১. 🪜 স্টেপ-বাই-স্টেপ ফ্লো-কার্ড"),
                  _buildAnimationModelChip(1, _isEnglish ? "2. 📏 Formed Matches Rule" : "২. 📏 ক্যারেক্টার ম্যাচ নীতি"),
                  _buildAnimationModelChip(2, _isEnglish ? "3. 📊 Complexity Calculator" : "৩. 📊 টাইমিং ক্যালকুলেটর"),
                ],
              ),
            ),
            const SizedBox(height: 20),

            if (_animationModelIndex == 0) _buildStepFlowcardModel(),
            if (_animationModelIndex == 1) _buildFormedMatchesRuleModel(),
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
        "window": "ADOBEC",
        "formed": "3/3",
        "minWin": "ADOBEC",
        "minLen": 6,
        "badge": "🎉 VALID WINDOW (LEN=6)",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 1: Expand to index 5 \"ADOBEC\" ➔ Formed 3/3 matches! Min Len = 6 (\"ADOBEC\")",
        "titleBn": "ধাপ ১: ইনডেক্স ৫ এ প্রসার \"ADOBEC\" ➔ ৩/৩ টি ক্যারেক্টার মিলেছে! মিনিমাম দৈর্ঘ্য = ৬ (\"ADOBEC\")",
        "descEn": "Contains all characters of t ('A','B','C'). Recorded initial valid window.",
        "descBn": "t এর সব ক্যারেক্টার ('A','B','C') বিদ্যমান। প্রাথমিক বৈধ্য উইন্ডো সিভ করা হলো।",
      },
      {
        "step": 2,
        "window": "CODEBA",
        "formed": "3/3",
        "minWin": "ADOBEC",
        "minLen": 6,
        "badge": "⬅️ SHRINK & EXPAND",
        "badgeColor": AppTheme.accentAmber,
        "titleEn": "Step 2: Shrink Left & Expand to index 10 \"CODEBA\" ➔ Formed 3/3 matches!",
        "titleBn": "ধাপ ২: বাম কমান ও ইনডেক্স ১০ এ প্রসার \"CODEBA\" ➔ ৩/৩ টি ক্যারেক্টার মিলেছে!",
        "descEn": "\"CODEBA\" is another valid window of length 6.",
        "descBn": "\"CODEBA\" ৬ দৈর্ঘ্যের আরেকটি বৈধ্য উইন্ডো।",
      },
      {
        "step": 3,
        "window": "BANC",
        "formed": "3/3",
        "minWin": "BANC",
        "minLen": 4,
        "badge": "🎉 NEW MIN WINDOW = \"BANC\"",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 3: Expand to 12 & Shrink to \"BANC\" [9..12] ➔ NEW Min Window = \"BANC\" (Len=4)! 🎉",
        "titleBn": "ধাপ ৩: ১২ এ প্রসার ও কমিয়ে \"BANC\" [9..12] ➔ নতুন মিনিমাম উইন্ডো = \"BANC\" (দৈর্ঘ্য=৪)! 🎉",
        "descEn": "Sub-string \"BANC\" has all target characters with absolute minimal length 4!",
        "descBn": "\"BANC\" সর্বমোট ৪ সর্বনিম্ন দৈর্ঘ্যে t এর সব ক্যারেক্টার ধারণ করে!",
      },
      {
        "step": 4,
        "window": "BANC",
        "formed": "3/3",
        "minWin": "BANC",
        "minLen": 4,
        "badge": "🏁 COMPLETE",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 4: All Characters Processed! Minimum Window Substring = \"BANC\"",
        "titleBn": "ধাপ ৪: সমস্ত ক্যারেক্টার প্রসেস সম্পন্ন! মিনিমাম উইন্ডো সাব-স্ট্রিং = \"BANC\"",
        "descEn": "Minimum window substring containing \"ABC\" = \"BANC\"!",
        "descBn": "\"ABC\" ধারণকারী সর্বনিম্ন উইন্ডো সাব-স্ট্রিং = \"BANC\"!",
      },
    ];

    final currentStep = stepFlowData[_flowStepIndex.clamp(0, stepFlowData.length - 1)];
    final String window = currentStep["window"] as String;
    final String formedVal = currentStep["formed"] as String;
    final String minWinVal = currentStep["minWin"] as String;
    final int minLenVal = currentStep["minLen"] as int;
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
                _isEnglish ? "1. Step-by-Step Minimum Window Flowcard" : "১. স্টেপ-বাই-স্টেপ মিনিমাম উইন্ডো ফ্লো-কার্ড",
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
                ? "Watch right pointer expansion and greedy left pointer shrinking."
                : "ডান পয়েন্টার বিস্তার এবং গ্রিডি বাম কমানো দেখুন।",
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
                    Text("Window = \"$window\" (Matches: $formedVal)", style: TextStyle(color: badgeColor, fontWeight: FontWeight.bold, fontSize: 12)),
                    Text("Min Length = $minLenVal", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
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
                    "Min Window = \"$minWinVal\" (Len: $minLenVal) 🏆",
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

  // MODEL 2: Formed Matches Rule
  Widget _buildFormedMatchesRuleModel() {
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
            _isEnglish ? "2. Formed Matches vs Required Rule" : "২. ক্যারেক্টার ম্যাচিং নীতি",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            _isEnglish
                ? "While formed == required, record minWindow substring and shrink left: windowMap[s[left]]--, if (windowMap[s[left]] < targetMap[s[left]]) formed--; left++."
                : "formed == required থাকা পর্যন্ত minWindow রেকর্ড করুন এবং বাম কমান: windowMap[s[left]]--, ক্যারেক্টার না মিললে formed-- এবং left++।",
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
              "while (formed == required) { updateMinWindow(); windowMap[s[left]]--; left++; } 📏",
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
            _isEnglish ? "3. O(M + N) Time & O(128) Space Complexity" : "৩. O(M + N) টাইম এবং O(128) স্পেস কমপ্লেক্সিটি",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            _isEnglish
                ? "Brute force checks all substrings in O(M * N^2) time.\nSliding Window advances left and right pointers at most M times total in O(M + N) time with O(128) = O(1) space!"
                : "ব্রুট ফোর্স O(M * N^2) সময়ে সমস্ত সাব-স্ট্রিং পরীক্ষা করে।\nস্লাইডিং উইন্ডো বাম ও ডান পয়েন্টার সর্বমোট M বার সরিয়ে O(M + N) টাইম ও O(1) স্পেসে সমাধান করে!",
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
              "Time Complexity: O(M + N)\nSpace Complexity: O(128) = O(1) 🎉",
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
                          labelText: _isEnglish ? "String s (e.g. ADOBECODEBANC)" : "স্ট্রিং s (যেমন ADOBECODEBANC)",
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
                        controller: _tController,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          labelText: _isEnglish ? "Target t (e.g. ABC)" : "টার্গেট t (যেমন ABC)",
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
                      _buildPresetChip("ADOBECODEBANC", "ABC"),
                      _buildPresetChip("a", "a"),
                      _buildPresetChip("a", "aa"),
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
                  _buildMinWindowCanvas(step),
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildCodeHighlightBox(step.activeLine)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildMinWindowCanvas(step)),
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
    final targetMinWindowStr = _minWindow(_s, _t);

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
                  ? "Track window expansion and find the minimum window containing all characters of t!"
                  : "প্রতিটি ক্যারেক্টারের জন্য উইন্ডো প্রসারিত করুন এবং t এর সব ক্যারেক্টার সহ মিনিমাম উইন্ডো বের করুন!",
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
                        Text("Current Index: right = $_practiceRight ('${_s[_practiceRight]}')", style: const TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 12)),
                        Text("Min Window Target: \"$targetMinWindowStr\"", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Window: [$_practiceLeft .. $_practiceRight] = \"${_s.substring(_practiceLeft, _practiceRight + 1)}\"",
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
                          label: Text(_isEnglish ? "EXPAND (Valid)" : "EXPAND (বৈধ্য)"),
                          onPressed: () => _handlePracticeAction("EXPAND"),
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accentAmber,
                            foregroundColor: AppTheme.primaryDark,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          ),
                          icon: const Icon(Icons.arrow_back),
                          label: Text(_isEnglish ? "SHRINK LEFT" : "SHRINK LEFT"),
                          onPressed: () => _handlePracticeAction("SHRINK"),
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accentGreen,
                            foregroundColor: AppTheme.primaryDark,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          ),
                          icon: const Icon(Icons.star),
                          label: Text(_isEnglish ? "MIN UPDATED" : "MIN UPDATED"),
                          onPressed: () => _handlePracticeAction("MIN_UPDATED"),
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
  Widget _buildPresetChip(String sVal, String tVal) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ActionChip(
        backgroundColor: const Color(0xFF090D16),
        label: Text("s:\"$sVal\", t:\"$tVal\"", style: const TextStyle(color: AppTheme.accentNeonCyan, fontSize: 11)),
        onPressed: () {
          _sController.text = sVal;
          _tController.text = tVal;
          _rebuildSteps();
        },
      ),
    );
  }

  Widget _buildCodeHighlightBox(int activeLine) {
    final codeLines = [
      "string minWindow(string s, string t) {",
      "    unordered_map<char, int> targetMap, windowMap;",
      "    for (char c : t) targetMap[c]++;",
      "    int left = 0, formed = 0, required = targetMap.size();",
      "    int minLen = INT_MAX, minStart = 0;",
      "    for (int right = 0; right < s.length(); right++) {",
      "        char c = s[right];",
      "        windowMap[c]++;",
      "        if (targetMap.count(c) && windowMap[c] == targetMap[c]) formed++;",
      "        while (formed == required) {",
      "            if (right - left + 1 < minLen) { minLen = right - left + 1; minStart = left; }",
      "            char leftChar = s[left];",
      "            windowMap[leftChar]--;",
      "            if (targetMap.count(leftChar) && windowMap[leftChar] < targetMap[leftChar]) formed--;",
      "            left++;",
      "        }",
      "    }",
      "    return minLen == INT_MAX ? \"\" : s.substr(minStart, minLen);",
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

  Widget _buildMinWindowCanvas(MinimumWindowSubstringStep step) {
    Color decisionColor = AppTheme.accentPurple;
    String decisionLabel = "INIT";

    if (step.decision == "expand") {
      decisionColor = AppTheme.accentNeonCyan;
      decisionLabel = "➡️ EXPAND RIGHT";
    } else if (step.decision == "shrink_left") {
      decisionColor = AppTheme.accentAmber;
      decisionLabel = "⬅️ SHRINK LEFT";
    } else if (step.decision == "min_updated") {
      decisionColor = AppTheme.accentGreen;
      decisionLabel = "🎉 MIN WINDOW UPDATED";
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
              Text("Window: [L:${step.left} .. R:${step.right}]", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13)),
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
              Text("Matches = ${step.formedCount} / ${step.requiredCount}", style: TextStyle(color: step.formedCount == step.requiredCount ? AppTheme.accentGreen : AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 12)),
              Text("Min Window Len = ${step.minLen}", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
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
                  "Min Window Substring = \"${step.minWindowStr}\" 🏆",
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
                  "Target Frequency Map: ${step.targetMap}",
                  style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Visual String Sequence Canvas with Pointers L and R
          const Text("String s Sequence Canvas:", style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_s.length, (idx) {
                bool inWindow = idx >= step.left && idx <= step.right;
                bool isL = idx == step.left;
                bool isR = idx == step.right;
                String ch = _s[idx];
                bool isTargetChar = _t.contains(ch);

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: inWindow
                        ? (isTargetChar ? AppTheme.accentGreen.withOpacity(0.35) : decisionColor.withOpacity(0.35))
                        : AppTheme.surfaceDark,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: inWindow ? (isTargetChar ? AppTheme.accentGreen : decisionColor) : const Color(0xFF334155),
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
                        ch,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isTargetChar ? AppTheme.accentGreen : (inWindow ? Colors.white : const Color(0xFF64748B)),
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
    string minWindow(string s, string t) {
        unordered_map<char, int> targetMap, windowMap;
        for (char c : t) targetMap[c]++;
        
        int left = 0, formed = 0, required = targetMap.size();
        int minLen = INT_MAX, minStart = 0;
        
        for (int right = 0; right < s.length(); right++) {
            char c = s[right];
            windowMap[c]++;
            if (targetMap.count(c) && windowMap[c] == targetMap[c]) {
                formed++;
            }
            while (formed == required) {
                if (right - left + 1 < minLen) {
                    minLen = right - left + 1;
                    minStart = left;
                }
                char leftChar = s[left];
                windowMap[leftChar]--;
                if (targetMap.count(leftChar) && windowMap[leftChar] < targetMap[leftChar]) {
                    formed--;
                }
                left++;
            }
        }
        return minLen == INT_MAX ? "" : s.substr(minStart, minLen);
    }
};""";
    } else if (lang == "Java") {
      code = """
class Solution {
    public String minWindow(String s, String t) {
        if (s.length() < t.length()) return "";
        Map<Character, Integer> targetMap = new HashMap<>();
        for (char c : t.toCharArray()) targetMap.put(c, targetMap.getOrDefault(c, 0) + 1);
        
        int left = 0, formed = 0, required = targetMap.size();
        int minLen = Integer.MAX_VALUE, minStart = 0;
        Map<Character, Integer> windowMap = new HashMap<>();
        
        for (int right = 0; right < s.length(); right++) {
            char c = s.charAt(right);
            windowMap.put(c, windowMap.getOrDefault(c, 0) + 1);
            if (targetMap.containsKey(c) && windowMap.get(c).equals(targetMap.get(c))) {
                formed++;
            }
            while (formed == required) {
                if (right - left + 1 < minLen) {
                    minLen = right - left + 1;
                    minStart = left;
                }
                char leftChar = s.charAt(left);
                windowMap.put(leftChar, windowMap.get(leftChar) - 1);
                if (targetMap.containsKey(leftChar) && windowMap.get(leftChar) < targetMap.get(leftChar)) {
                    formed--;
                }
                left++;
            }
        }
        return minLen == Integer.MAX_VALUE ? "" : s.substring(minStart, minStart + minLen);
    }
}""";
    } else {
      code = """
class Solution:
    def minWindow(self, s: str, t: str) -> str:
        if not s or not t:
            return ""
        
        target_map = Counter(t)
        required = len(target_map)
        left = 0
        formed = 0
        window_map = {}
        min_len = float('inf')
        min_start = 0
        
        for right in range(len(s)):
            ch = s[right]
            window_map[ch] = window_map.get(ch, 0) + 1
            if ch in target_map and window_map[ch] == target_map[ch]:
                formed += 1
                
            while formed == required:
                if right - left + 1 < min_len:
                    min_len = right - left + 1
                    min_start = left
                    
                left_char = s[left]
                window_map[left_char] -= 1
                if left_char in target_map and window_map[left_char] < target_map[left_char]:
                    formed -= 1
                left += 1
                
        return "" if min_len == float('inf') else s[min_start : min_start + min_len]""";
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
