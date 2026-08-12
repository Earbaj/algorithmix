import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class GetEqualSubstringsStep {
  final int left;
  final int right;
  final String sSub;
  final String tSub;
  final List<int> diffList;
  final int currentCost;
  final int maxCost;
  final int maxLength;
  final String maxSSub;
  final String decision; // 'init', 'expand', 'shrink_left', 'max_updated', 'finished'
  final int activeLine;
  final String actionEn;
  final String actionBn;
  final String reasonEn;
  final String reasonBn;

  const GetEqualSubstringsStep({
    required this.left,
    required this.right,
    required this.sSub,
    required this.tSub,
    required this.diffList,
    required this.currentCost,
    required this.maxCost,
    required this.maxLength,
    required this.maxSSub,
    required this.decision,
    required this.activeLine,
    required this.actionEn,
    required this.actionBn,
    required this.reasonEn,
    required this.reasonBn,
  });
}

class GetEqualSubstringsWithinBudgetDetailScreen extends StatefulWidget {
  const GetEqualSubstringsWithinBudgetDetailScreen({super.key});

  @override
  State<GetEqualSubstringsWithinBudgetDetailScreen> createState() =>
      _GetEqualSubstringsWithinBudgetDetailScreenState();
}

class _GetEqualSubstringsWithinBudgetDetailScreenState
    extends State<GetEqualSubstringsWithinBudgetDetailScreen>
    with SingleTickerProviderStateMixin {
  bool _isEnglish = true;
  late TabController _tabController;

  // Custom Input State
  final TextEditingController _sController = TextEditingController(text: "abcd");
  final TextEditingController _tController = TextEditingController(text: "bcdf");
  final TextEditingController _maxCostController = TextEditingController(text: "3");
  String _s = "abcd";
  String _t = "bcdf";
  int _maxCost = 3;
  List<GetEqualSubstringsStep> _steps = [];

  // Playback Control
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  // Code Language Selector
  String _selectedCodeLang = "C++";

  // Tab 2 Animation Model Selector (0: Step Flowcard, 1: ASCII Cost Rule, 2: Complexity Calculator)
  int _animationModelIndex = 0;
  int _flowStepIndex = 0;

  // Practice Mode State
  int _practiceRight = 0;
  int _practiceLeft = 0;
  int _practiceMaxLen = 0;
  String _userFeedbackEn = "Expand right pointer and calculate ASCII difference cost <= maxCost!";
  String _userFeedbackBn = "ডান পয়েন্টার বাড়ান এবং ASCII পার্থক্য খরচ <= maxCost হিসাব করুন!";
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
    _maxCostController.dispose();
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
    int cVal = int.tryParse(_maxCostController.text.trim()) ?? 3;

    if (sVal.isEmpty || tVal.isEmpty || sVal.length != tVal.length) {
      sVal = "abcd";
      tVal = "bcdf";
    }
    if (cVal < 0) cVal = 3;

    _s = sVal;
    _t = tVal;
    _maxCost = cVal;

    _steps = _generateSteps(_s, _t, _maxCost);

    // Reset practice mode
    _resetPractice();
  }

  void _resetPractice() {
    _practiceLeft = 0;
    _practiceRight = 0;
    _practiceMaxLen = 0;
    _practiceSolved = false;
    _userFeedbackEn = "Inspect char pair at right = 0 ('${_s.isNotEmpty ? _s[0] : ''}' vs '${_t.isNotEmpty ? _t[0] : ''}') with maxCost = $_maxCost!";
    _userFeedbackBn = "maxCost = $_maxCost সহ ইনডেক্স right = 0 ('${_s.isNotEmpty ? _s[0] : ''}' বনাম '${_t.isNotEmpty ? _t[0] : ''}') এর ক্যারেক্টার পরীক্ষা করুন!";
  }

  List<GetEqualSubstringsStep> _generateSteps(String sStr, String tStr, int costLimit) {
    List<GetEqualSubstringsStep> steps = [];
    int n = sStr.length;

    // Step 0: Init
    steps.add(GetEqualSubstringsStep(
      left: 0,
      right: 0,
      sSub: n > 0 ? sStr[0] : "",
      tSub: n > 0 ? tStr[0] : "",
      diffList: n > 0 ? [(sStr.codeUnitAt(0) - tStr.codeUnitAt(0)).abs()] : [],
      currentCost: 0,
      maxCost: costLimit,
      maxLength: 0,
      maxSSub: "",
      decision: "init",
      activeLine: 1,
      actionEn: "Line 1: Initialize Sliding Window for s = \"$sStr\", t = \"$tStr\", maxCost = $costLimit.",
      actionBn: "লাইন ১: s = \"$sStr\", t = \"$tStr\", maxCost = $costLimit এর জন্য স্লাইডিং উইন্ডো শুরু।",
      reasonEn: "We calculate ASCII difference |s[i] - t[i]| and slide window keeping totalCost <= maxCost.",
      reasonBn: "আমরা ASCII পার্থক্য |s[i] - t[i]| হিসাব করব এবং totalCost <= maxCost বজায় রেখে উইন্ডো স্লাইড করব।",
    ));

    if (n == 0) {
      steps.add(const GetEqualSubstringsStep(
        left: 0,
        right: 0,
        sSub: "",
        tSub: "",
        diffList: [],
        currentCost: 0,
        maxCost: 0,
        maxLength: 0,
        maxSSub: "",
        decision: "finished",
        activeLine: 2,
        actionEn: "🏁 Line 2: Empty string! Return 0.",
        actionBn: "🏁 লাইন ২: খালি স্ট্রিং! 0 রিটার্ন করুন।",
        reasonEn: "Empty string has length 0.",
        reasonBn: "খালি স্ট্রিংয়ের দৈর্ঘ্য ০।",
      ));
      return steps;
    }

    int l = 0;
    int curCost = 0;
    int maxLen = 0;
    String maxSSub = "";

    for (int r = 0; r < n; r++) {
      int cost = (sStr.codeUnitAt(r) - tStr.codeUnitAt(r)).abs();
      curCost += cost;

      List<int> diffList = [];
      for (int i = l; i <= r; i++) {
        diffList.add((sStr.codeUnitAt(i) - tStr.codeUnitAt(i)).abs());
      }

      while (curCost > costLimit && l <= r) {
        int leftCost = (sStr.codeUnitAt(l) - tStr.codeUnitAt(l)).abs();
        curCost -= leftCost;
        l++;

        List<int> updatedDiffList = [];
        for (int i = l; i <= r; i++) {
          updatedDiffList.add((sStr.codeUnitAt(i) - tStr.codeUnitAt(i)).abs());
        }

        steps.add(GetEqualSubstringsStep(
          left: l,
          right: r,
          sSub: l <= r ? sStr.substring(l, r + 1) : "",
          tSub: l <= r ? tStr.substring(l, r + 1) : "",
          diffList: updatedDiffList,
          currentCost: curCost,
          maxCost: costLimit,
          maxLength: maxLen,
          maxSSub: maxSSub,
          decision: "shrink_left",
          activeLine: 7,
          actionEn: "⬅️ Line 7: Current cost ($curCost + $leftCost = ${curCost + leftCost}) > maxCost ($costLimit)! Shrink left pointer to $l.",
          actionBn: "⬅️ লাইন ৭: বর্তমান খরচ ($curCost + $leftCost = ${curCost + leftCost}) > maxCost ($costLimit)! বাম পয়েন্টার বাড়িয়ে $l এ আনা হলো।",
          reasonEn: "Subarray cost exceeded budget $costLimit. Subtract left character difference |s[$l] - t[$l]|.",
          reasonBn: "সাব-অ্যারে খরচ বাজেট $costLimit ছাড়িয়ে গেছে। বাম ক্যারেক্টারের পার্থক্য |s[$l] - t[$l]| বিয়োগ করা হলো।",
        ));
      }

      int windowLen = r - l + 1;
      if (windowLen > maxLen) {
        maxLen = windowLen;
        maxSSub = sStr.substring(l, r + 1);
        steps.add(GetEqualSubstringsStep(
          left: l,
          right: r,
          sSub: sStr.substring(l, r + 1),
          tSub: tStr.substring(l, r + 1),
          diffList: diffList,
          currentCost: curCost,
          maxCost: costLimit,
          maxLength: maxLen,
          maxSSub: maxSSub,
          decision: "max_updated",
          activeLine: 9,
          actionEn: "🎉 Line 9: NEW Max Equal Substring! Window [${l}..${r}] s=\"$maxSSub\" ➔ Cost = $curCost <= $costLimit (Length = $maxLen)!",
          actionBn: "🎉 লাইন ৯: নতুন সর্বোচ্চ সমমানের সাব-স্ট্রিং! উইন্ডো [${l}..${r}] s=\"$maxSSub\" ➔ খরচ = $curCost <= $costLimit (দৈর্ঘ্য = $maxLen)!",
          reasonEn: "Current valid window length $windowLen exceeds max length. Update maxLen!",
          reasonBn: "বর্তমান বৈধ্য উইন্ডোর দৈর্ঘ্য $windowLen পূর্বের সর্বমোট দৈর্ঘ্য ছাড়িয়ে গেছে। maxLen আপডেট করুন!",
        ));
      } else {
        steps.add(GetEqualSubstringsStep(
          left: l,
          right: r,
          sSub: sStr.substring(l, r + 1),
          tSub: tStr.substring(l, r + 1),
          diffList: diffList,
          currentCost: curCost,
          maxCost: costLimit,
          maxLength: maxLen,
          maxSSub: maxSSub,
          decision: "expand",
          activeLine: 8,
          actionEn: "➡️ Line 8: Expand right to $r ('${sStr[r]}' vs '${tStr[r]}', cost=$cost) ➔ Cost = $curCost <= $costLimit (Max = $maxLen).",
          actionBn: "➡️ লাইন ৮: ডান পয়েন্টার $r এ বাড়ানো হলো ('${sStr[r]}' বনাম '${tStr[r]}', খরচ=$cost) ➔ খরচ = $curCost <= $costLimit (সর্বমোট = $maxLen)।",
          reasonEn: "Valid window with total cost $curCost <= maxCost ($costLimit).",
          reasonBn: "সর্বমোট খরচ $curCost <= maxCost ($costLimit) সহ বৈধ্য উইন্ডো।",
        ));
      }
    }

    steps.add(GetEqualSubstringsStep(
      left: l < n ? l : n - 1,
      right: n - 1,
      sSub: l < n ? sStr.substring(l) : "",
      tSub: l < n ? tStr.substring(l) : "",
      diffList: [],
      currentCost: curCost,
      maxCost: costLimit,
      maxLength: maxLen,
      maxSSub: maxSSub,
      decision: "finished",
      activeLine: 11,
      actionEn: "🏁 Line 11: Traversal Complete! Maximum Equal Substring Length = $maxLen (Sub-string \"$maxSSub\").",
      actionBn: "🏁 লাইন ১১: স্ক্যান সম্পূর্ণ! সর্বোচ্চ সমমানের সাব-স্ট্রিং দৈর্ঘ্য = $maxLen (সাব-স্ট্রিং \"$maxSSub\")।",
      reasonEn: "Evaluated strings of length $n in O(N) linear time.",
      reasonBn: "O(N) লিনিয়ার সময়ে $n দৈর্ঘ্যের স্ট্রিং মূল্যায়ন সম্পূর্ণ।",
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

  int _equalSubstring(String sStr, String tStr, int maxC) {
    int l = 0, curCost = 0, maxL = 0;
    for (int r = 0; r < sStr.length; r++) {
      curCost += (sStr.codeUnitAt(r) - tStr.codeUnitAt(r)).abs();
      while (curCost > maxC && l <= r) {
        curCost -= (sStr.codeUnitAt(l) - tStr.codeUnitAt(l)).abs();
        l++;
      }
      maxL = max(maxL, r - l + 1);
    }
    return maxL;
  }

  void _handlePracticeAction(String actionType) {
    if (_practiceSolved || _practiceRight >= _s.length) return;

    int l = 0, curCost = 0, maxL = 0;
    bool expectedShrink = false;
    bool expectedMax = false;

    for (int r = 0; r <= _practiceRight; r++) {
      curCost += (_s.codeUnitAt(r) - _t.codeUnitAt(r)).abs();
      while (curCost > _maxCost && l <= r) {
        if (r == _practiceRight) expectedShrink = true;
        curCost -= (_s.codeUnitAt(l) - _t.codeUnitAt(l)).abs();
        l++;
      }
      int curLen = r - l + 1;
      if (curLen > maxL) {
        if (r == _practiceRight) expectedMax = true;
        maxL = curLen;
      }
    }

    String expectedAction = "EXPAND";
    if (expectedShrink) expectedAction = "SHRINK";
    if (expectedMax) expectedAction = "MAX_UPDATED";

    setState(() {
      if (actionType == expectedAction || (actionType == "EXPAND" && expectedAction == "EXPAND")) {
        _practiceLeft = l;
        _practiceMaxLen = maxL;
        _practiceRight++;

        if (_practiceRight >= _s.length) {
          _practiceSolved = true;
          _userFeedbackEn = "🏆 MASTERED! You correctly balanced ASCII difference cost within maxCost budget! Max Length = $maxL!";
          _userFeedbackBn = "🏆 দারুণ! আপনি maxCost বাজেটের মধ্যে ASCII পার্থক্য খরচ সঠিকভাবে বজায় রেখেছেন! সর্বমোট দৈর্ঘ্য = $maxL!";
        } else {
          _userFeedbackEn = "Correct! Inspecting index $_practiceRight ('${_s[_practiceRight]}' vs '${_t[_practiceRight]}'). Select next step action!";
          _userFeedbackBn = "সঠিক! ইনডেক্স $_practiceRight ('${_s[_practiceRight]}' বনাম '${_t[_practiceRight]}') পরীক্ষা করা হচ্ছে। পরের পদক্ষেপ নির্বাচন করুন!";
        }
      } else {
        _userFeedbackEn = "Incorrect! Index ${_practiceRight} ('${_s[_practiceRight]}' vs '${_t[_practiceRight]}') requires action: $expectedAction. Try again!";
        _userFeedbackBn = "ভুল উত্তর! ইনডেক্স ${_practiceRight} ('${_s[_practiceRight]}' বনাম '${_t[_practiceRight]}') এর জন্য সঠিক অ্যাকশন হলো: $expectedAction। আবার চেষ্টা করুন!";
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
          '1208. Get Equal Substrings Within Budget',
          style: TextStyle(fontSize: Responsive.sp(context, 16), fontWeight: FontWeight.bold),
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
                    "1208. Get Equal Substrings Within Budget",
                    style: TextStyle(fontSize: Responsive.sp(context, 19), fontWeight: FontWeight.bold, color: Colors.white),
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
              children: ["Meta", "Google"].map((company) {
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
                        ? "You are given two strings s and t of the same length and an integer maxCost. Changing s[i] to t[i] costs |s[i] - t[i]|. Return the maximum length of a substring of s that can be changed to be the same as the corresponding substring of t with a total cost <= maxCost."
                        : "সম দৈর্ঘ্যের দুটি স্ট্রিং s ও t এবং একটি বাজেট maxCost দেওয়া আছে। s[i] কে t[i] তে পরিবর্তন করতে খরচ হয় |s[i] - t[i]|। সর্বোচ্চ maxCost খরচের মধ্যে s এর সবচেয়ে দীর্ঘ সাব-স্ট্রিং এর দৈর্ঘ্য নির্ণয় করুন যা t এর সাথে হুবহু মেলানো যায়।",
                    style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Examples
            Text(_isEnglish ? "Examples" : "উদাহরণসমূহ", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            _buildExampleCard("Example 1", "s = \"abcd\", t = \"bcdf\", maxCost = 3", "Output: 3 (Substrings \"abc\" & \"bcd\", diffs [1, 1, 1], cost = 3 <= 3)"),
            _buildExampleCard("Example 2", "s = \"abcd\", t = \"cdef\", maxCost = 3", "Output: 1"),
            _buildExampleCard("Example 3", "s = \"abcd\", t = \"acde\", maxCost = 0", "Output: 1"),
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
                        _isEnglish ? "Key Intuition (ASCII Difference Dynamic Window)" : "মূল আইডিয়া (ASCII পার্থক্য ডাইনামিক উইন্ডো)",
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isEnglish
                        ? "1. Calculate character-by-character ASCII difference |s[i] - t[i]|.\n2. Expand right pointer and accumulate currentCost.\n3. When currentCost > maxCost, shrink left pointer (left++) to restore currentCost <= maxCost.\n4. Achieves O(N) linear time complexity and O(1) space complexity!"
                        : "১. প্রতিটি ক্যারেক্টারের ASCII পার্থক্য |s[i] - t[i]| হিসাব করুন।\n২. ডান পয়েন্টার বাড়ান এবং currentCost এ পার্থক্য যোগ করুন।\n৩. currentCost > maxCost হলে বাম পয়েন্টার বাড়িয়ে (left++) খরচ maxCost এর নিচে আনুন।\n৪. O(N) লিনিয়ার সময় ও O(1) স্পেস কমপ্লেক্সিটি।",
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
              _isEnglish ? "Get Equal Substrings Visual Models" : "গেট ইকুয়াল সাব-স্ট্রিংস ভিজ্যুয়াল মডেলসমূহ (কোডহীন গাইড)",
              style: TextStyle(fontSize: Responsive.sp(context, 18), fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 6),
            Text(
              _isEnglish
                  ? "Explore 3 interactive models for s = \"abcd\", t = \"bcdf\", maxCost = 3."
                  : "s = \"abcd\", t = \"bcdf\", maxCost = 3 এর জন্য ৩টি ইন্টারঅ্যাক্টিভ ভিজ্যুয়াল মডেল পর্যবেক্ষণ করুন।",
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 16),

            // Model Switcher Segmented Control
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildAnimationModelChip(0, _isEnglish ? "1. 🪜 Step Flowcard" : "১. 🪜 স্টেপ-বাই-স্টেপ ফ্লো-কার্ড"),
                  _buildAnimationModelChip(1, _isEnglish ? "2. 📏 ASCII Cost Rule" : "২. 📏 ASCII খরচ নীতি"),
                  _buildAnimationModelChip(2, _isEnglish ? "3. 📊 Complexity Calculator" : "৩. 📊 টাইমিং ক্যালকুলেটর"),
                ],
              ),
            ),
            const SizedBox(height: 20),

            if (_animationModelIndex == 0) _buildStepFlowcardModel(),
            if (_animationModelIndex == 1) _buildAsciiCostRuleModel(),
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
        "sSub": "a",
        "tSub": "b",
        "cost": 1,
        "max": 1,
        "badge": "🎉 VALID WINDOW (COST=1)",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 1: Expand [0..0] ('a' vs 'b') ➔ Cost = 1 <= 3! Length = 1",
        "titleBn": "ধাপ ১: প্রসার [0..0] ('a' বনাম 'b') ➔ খরচ = ১ <= ৩! দৈর্ঘ্য = ১",
        "descEn": "|97 - 98| = 1 cost. Fits within budget 3.",
        "descBn": "|97 - 98| = ১ খরচ। ৩ বাজেটের মধ্যে বৈধ্য।",
      },
      {
        "step": 2,
        "sSub": "abc",
        "tSub": "bcd",
        "cost": 3,
        "max": 3,
        "badge": "🎉 NEW MAX LEN = 3",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 2: Expand to index 2 \"abc\" vs \"bcd\" ➔ Cost = 1+1+1 = 3 <= 3! NEW Max = 3! 🎉",
        "titleBn": "ধাপ ২: ইনডেক্স ২ এ প্রসার \"abc\" বনাম \"bcd\" ➔ খরচ = ১+১+১ = ৩ <= ৩! নতুন Max = ৩! 🎉",
        "descEn": "Differences [1, 1, 1] sum to 3 <= 3. Valid substring length 3!",
        "descBn": "পার্থক্য [১, ১, ১] এর যোগফল ৩ <= ৩। বৈধ্য সাব-স্ট্রিং দৈর্ঘ্য ৩!",
      },
      {
        "step": 3,
        "sSub": "cd",
        "tSub": "df",
        "cost": 3,
        "max": 3,
        "badge": "⬅️ SHRINK LEFT",
        "badgeColor": AppTheme.accentAmber,
        "titleEn": "Step 3: Expand to index 3 ('d' vs 'f', cost=2) ➔ Total Cost = 5 > 3! Shrink Left to index 2",
        "titleBn": "ধাপ ৩: ইনডেক্স ৩ এ প্রসার ('d' বনাম 'f', খরচ=২) ➔ মোট খরচ = ৫ > ৩! বাম কমান ইনডেক্স ২ এ",
        "descEn": "Cost 5 exceeded maxCost 3. Increment left pointer until cost <= 3.",
        "descBn": "খরচ ৫ maxCost ৩ ছাড়িয়ে গেছে। খরচ <= ৩ না হওয়া পর্যন্ত বাম কমান।",
      },
      {
        "step": 4,
        "sSub": "cd",
        "tSub": "df",
        "cost": 3,
        "max": 3,
        "badge": "🏁 COMPLETE",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 4: Traversal Complete! Maximum Equal Substring Length = 3",
        "titleBn": "ধাপ ৪: স্ক্যান সম্পূর্ণ! সর্বোচ্চ সমমানের সাব-স্ট্রিং দৈর্ঘ্য = ৩",
        "descEn": "Maximum substring length with cost <= 3 is 3!",
        "descBn": "খরচ <= ৩ সহ সর্বোচ্চ সাব-স্ট্রিং দৈর্ঘ্য ৩!",
      },
    ];

    final currentStep = stepFlowData[_flowStepIndex.clamp(0, stepFlowData.length - 1)];
    final String sSubVal = currentStep["sSub"] as String;
    final String tSubVal = currentStep["tSub"] as String;
    final int costVal = currentStep["cost"] as int;
    final int maxVal = currentStep["max"] as int;
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
                _isEnglish ? "1. Step-by-Step ASCII Budget Flowcard" : "১. স্টেপ-বাই-স্টেপ ASCII বাজেট ফ্লো-কার্ড",
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
                ? "Watch right pointer expansion and ASCII difference cost check."
                : "ডান পয়েন্টার বিস্তার এবং ASCII পার্থক্য খরচ পরীক্ষা দেখুন।",
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
                    Text("s: \"$sSubVal\" vs t: \"$tSubVal\" (Cost = $costVal)", style: TextStyle(color: badgeColor, fontWeight: FontWeight.bold, fontSize: 12)),
                    Text("Max Len = $maxVal", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
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
                    "Max Equal Substring Length = $maxVal 📏",
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

  // MODEL 2: ASCII Cost Rule
  Widget _buildAsciiCostRuleModel() {
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
            _isEnglish ? "2. ASCII Cost Threshold Rule" : "২. ASCII খরচ সীমা নীতি",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            _isEnglish
                ? "While currentCost > maxCost, subtract cost at left pointer: currentCost -= abs(s[left] - t[left]) and increment left++."
                : "currentCost > maxCost থাকা পর্যন্ত বাম ক্যারেক্টারের খরচ বিয়োগ করুন: currentCost -= abs(s[left] - t[left]) এবং বাম কমান।",
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
              "while (currentCost > maxCost) { currentCost -= abs(s[left] - t[left]); left++; } 📏",
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
            _isEnglish ? "3. O(N) Time & O(1) Space Complexity" : "৩. O(N) টাইম এবং O(1) স্পেস কমপ্লেক্সিটি",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            _isEnglish
                ? "Brute force checks all substrings in O(N^2) time.\nSliding Window moves left and right pointers at most N times total in O(N) time with O(1) space!"
                : "ব্রুট ফোর্স O(N^2) সময়ে সমস্ত সাব-স্ট্রিং পরীক্ষা করে।\nস্লাইডিং উইন্ডো বাম ও ডান পয়েন্টার সর্বমোট N বার সরিয়ে O(N) টাইম ও O(1) স্পেসে সমাধান করে!",
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
              "Time Complexity: O(N)\nSpace Complexity: O(1) 🎉",
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
                      flex: 1,
                      child: TextField(
                        controller: _sController,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          labelText: _isEnglish ? "String s (e.g. abcd)" : "স্ট্রিং s (যেমন abcd)",
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
                          labelText: _isEnglish ? "String t (e.g. bcdf)" : "স্ট্রিং t (যেমন bcdf)",
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
                        controller: _maxCostController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          labelText: _isEnglish ? "maxCost" : "বাজেট maxCost",
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
                      _buildPresetChip("abcd", "bcdf", "3"),
                      _buildPresetChip("abcd", "cdef", "3"),
                      _buildPresetChip("abcd", "acde", "0"),
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
                  _buildEqualSubstringsCanvas(step),
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildCodeHighlightBox(step.activeLine)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildEqualSubstringsCanvas(step)),
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
    final targetMaxLen = _equalSubstring(_s, _t, _maxCost);

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
                  ? "Track window expansion and decide next step action at each character pair!"
                  : "প্রতিটি ক্যারেক্টার পেয়ারের জন্য উইন্ডো প্রসারিত করুন এবং পরবর্তী অ্যাকশন নির্বাচন করুন!",
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
                        Text("Current Index: right = $_practiceRight ('${_s[_practiceRight]}' vs '${_t[_practiceRight]}')", style: const TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 12)),
                        Text("Max Equal Target: $targetMaxLen", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Window s: \"${_s.substring(_practiceLeft, _practiceRight + 1)}\" vs t: \"${_t.substring(_practiceLeft, _practiceRight + 1)}\"",
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 16,
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
                          label: Text(_isEnglish ? "MAX UPDATED" : "MAX UPDATED"),
                          onPressed: () => _handlePracticeAction("MAX_UPDATED"),
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
  Widget _buildPresetChip(String sVal, String tVal, String cVal) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ActionChip(
        backgroundColor: const Color(0xFF090D16),
        label: Text("s:\"$sVal\", t:\"$tVal\", cost=$cVal", style: const TextStyle(color: AppTheme.accentNeonCyan, fontSize: 11)),
        onPressed: () {
          _sController.text = sVal;
          _tController.text = tVal;
          _maxCostController.text = cVal;
          _rebuildSteps();
        },
      ),
    );
  }

  Widget _buildCodeHighlightBox(int activeLine) {
    final codeLines = [
      "int equalSubstring(string s, string t, int maxCost) {",
      "    int left = 0, currentCost = 0, maxLength = 0;",
      "    for (int right = 0; right < s.length(); right++) {",
      "        currentCost += abs(s[right] - t[right]);",
      "        while (currentCost > maxCost) {",
      "            currentCost -= abs(s[left] - t[left]);",
      "            left++;",
      "        }",
      "        maxLength = max(maxLength, right - left + 1);",
      "    }",
      "    return maxLength;",
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

  Widget _buildEqualSubstringsCanvas(GetEqualSubstringsStep step) {
    Color decisionColor = AppTheme.accentPurple;
    String decisionLabel = "INIT";

    if (step.decision == "expand") {
      decisionColor = AppTheme.accentNeonCyan;
      decisionLabel = "➡️ EXPAND RIGHT";
    } else if (step.decision == "shrink_left") {
      decisionColor = AppTheme.accentAmber;
      decisionLabel = "⬅️ SHRINK LEFT";
    } else if (step.decision == "max_updated") {
      decisionColor = AppTheme.accentGreen;
      decisionLabel = "🎉 MAX LEN UPDATED";
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
              Text("Window: [L:${step.left} .. R:${step.right}] (maxCost = ${step.maxCost})", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13)),
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
              Text("Current Cost = ${step.currentCost} / maxCost=${step.maxCost}", style: TextStyle(color: step.currentCost <= step.maxCost ? AppTheme.accentGreen : AppTheme.accentPink, fontWeight: FontWeight.bold, fontSize: 12)),
              Text("Max Equal Length = ${step.maxLength}", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
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
                  "Max Equal Substring Length = ${step.maxLength} 📏",
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
                  "Max s Substring: \"${step.maxSSub}\"",
                  style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Visual Alignment Canvas
          const Text("Character Alignment Canvas (s vs t):", style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_s.length, (idx) {
                bool inWindow = idx >= step.left && idx <= step.right;
                bool isL = idx == step.left;
                bool isR = idx == step.right;
                int diffCost = (_s.codeUnitAt(idx) - _t.codeUnitAt(idx)).abs();

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: inWindow ? decisionColor.withOpacity(0.35) : AppTheme.surfaceDark,
                    borderRadius: BorderRadius.circular(8),
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
                      Text("s: '${_s[idx]}'", style: TextStyle(fontFamily: 'monospace', fontSize: 12, fontWeight: FontWeight.bold, color: inWindow ? Colors.white : const Color(0xFF64748B))),
                      Text("t: '${_t[idx]}'", style: TextStyle(fontFamily: 'monospace', fontSize: 12, fontWeight: FontWeight.bold, color: inWindow ? AppTheme.accentNeonCyan : const Color(0xFF64748B))),
                      const SizedBox(height: 2),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                        decoration: BoxDecoration(
                          color: AppTheme.accentAmber.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text("+$diffCost", style: const TextStyle(fontSize: 10, color: AppTheme.accentAmber, fontWeight: FontWeight.bold)),
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
    int equalSubstring(string s, string t, int maxCost) {
        int left = 0, currentCost = 0, maxLength = 0;
        for (int right = 0; right < s.length(); right++) {
            currentCost += abs(s[right] - t[right]);
            while (currentCost > maxCost) {
                currentCost -= abs(s[left] - t[left]);
                left++;
            }
            maxLength = max(maxLength, right - left + 1);
        }
        return maxLength;
    }
};""";
    } else if (lang == "Java") {
      code = """
class Solution {
    public int equalSubstring(String s, String t, int maxCost) {
        int left = 0, currentCost = 0, maxLength = 0;
        for (int right = 0; right < s.length(); right++) {
            currentCost += Math.abs(s.charAt(right) - t.charAt(right));
            while (currentCost > maxCost) {
                currentCost -= Math.abs(s.charAt(left) - t.charAt(left));
                left++;
            }
            maxLength = Math.max(maxLength, right - left + 1);
        }
        return maxLength;
    }
}""";
    } else {
      code = """
class Solution:
    def equalSubstring(self, s: str, t: str, maxCost: int) -> int:
        left = 0
        current_cost = 0
        max_len = 0

        for right in range(len(s)):
            current_cost += abs(ord(s[right]) - ord(t[right]))
            while current_cost > maxCost:
                current_cost -= abs(ord(s[left]) - ord(t[left]))
                left += 1
            max_len = max(max_len, right - left + 1)

        return max_len""";
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
