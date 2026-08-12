import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class MinSizeSubarraySumStep {
  final int left;
  final int right;
  final List<int> windowSub;
  final int currentSum;
  final int target;
  final int minLength;
  final List<int> minSubarray;
  final String decision; // 'init', 'expand', 'shrink_left', 'min_updated', 'finished'
  final int activeLine;
  final String actionEn;
  final String actionBn;
  final String reasonEn;
  final String reasonBn;

  const MinSizeSubarraySumStep({
    required this.left,
    required this.right,
    required this.windowSub,
    required this.currentSum,
    required this.target,
    required this.minLength,
    required this.minSubarray,
    required this.decision,
    required this.activeLine,
    required this.actionEn,
    required this.actionBn,
    required this.reasonEn,
    required this.reasonBn,
  });
}

class MinSizeSubarraySumDetailScreen extends StatefulWidget {
  const MinSizeSubarraySumDetailScreen({super.key});

  @override
  State<MinSizeSubarraySumDetailScreen> createState() =>
      _MinSizeSubarraySumDetailScreenState();
}

class _MinSizeSubarraySumDetailScreenState
    extends State<MinSizeSubarraySumDetailScreen>
    with SingleTickerProviderStateMixin {
  bool _isEnglish = true;
  late TabController _tabController;

  // Custom Input State
  final TextEditingController _numsController = TextEditingController(text: "2, 3, 1, 2, 4, 3");
  final TextEditingController _targetController = TextEditingController(text: "7");
  List<int> _nums = [2, 3, 1, 2, 4, 3];
  int _target = 7;
  List<MinSizeSubarraySumStep> _steps = [];

  // Playback Control
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  // Code Language Selector
  String _selectedCodeLang = "C++";

  // Tab 2 Animation Model Selector (0: Step Flowcard, 1: Shrinking Rule, 2: Complexity Calculator)
  int _animationModelIndex = 0;
  int _flowStepIndex = 0;

  // Practice Mode State
  int _practiceRight = 0;
  int _practiceLeft = 0;
  int _practiceMinLen = 999999;
  String _userFeedbackEn = "Expand right pointer to increase sum >= target, then shrink left to minimize length!";
  String _userFeedbackBn = "sum >= target না হওয়া পর্যন্ত ডান পয়েন্টার বাড়ান, তারপর বাম পয়েন্টার কমিয়ে মিনিমাম দৈর্ঘ্য বের করুন!";
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
    _numsController.dispose();
    _targetController.dispose();
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

    try {
      List<int> parsed = _numsController.text
          .split(',')
          .map((e) => int.parse(e.trim()))
          .toList();
      int tVal = int.parse(_targetController.text.trim());
      if (parsed.isEmpty) parsed = [2, 3, 1, 2, 4, 3];
      if (tVal <= 0) tVal = 7;
      _nums = parsed;
      _target = tVal;
    } catch (_) {
      _nums = [2, 3, 1, 2, 4, 3];
      _target = 7;
    }

    _steps = _generateSteps(_nums, _target);

    // Reset practice mode
    _resetPractice();
  }

  void _resetPractice() {
    _practiceLeft = 0;
    _practiceRight = 0;
    _practiceMinLen = 999999;
    _practiceSolved = false;
    _userFeedbackEn = "Inspect element at right = 0 (${_nums.isNotEmpty ? _nums[0] : 0}) with target = $_target!";
    _userFeedbackBn = "target = $_target সহ ইনডেক্স right = 0 (${_nums.isNotEmpty ? _nums[0] : 0}) এর উপাদান পরীক্ষা করুন!";
  }

  List<MinSizeSubarraySumStep> _generateSteps(List<int> numbers, int targetVal) {
    List<MinSizeSubarraySumStep> steps = [];
    int n = numbers.length;

    // Step 0: Init
    steps.add(MinSizeSubarraySumStep(
      left: 0,
      right: 0,
      windowSub: n > 0 ? [numbers[0]] : [],
      currentSum: 0,
      target: targetVal,
      minLength: 0,
      minSubarray: [],
      decision: "init",
      activeLine: 1,
      actionEn: "Line 1: Initialize Sliding Window for nums = [${numbers.join(', ')}], target = $targetVal.",
      actionBn: "লাইন ১: nums = [${numbers.join(', ')}], target = $targetVal এর জন্য স্লাইডিং উইন্ডো শুরু।",
      reasonEn: "We expand right pointer until currentSum >= target, then shrink left pointer to find minimum length.",
      reasonBn: "আমরা currentSum >= target না হওয়া পর্যন্ত ডান পয়েন্টার বাড়াব, তারপর বাম পয়েন্টার কমিয়ে মিনিমাম দৈর্ঘ্য বের করব।",
    ));

    if (n == 0) {
      steps.add(const MinSizeSubarraySumStep(
        left: 0,
        right: 0,
        windowSub: [],
        currentSum: 0,
        target: 0,
        minLength: 0,
        minSubarray: [],
        decision: "finished",
        activeLine: 2,
        actionEn: "🏁 Line 2: Empty array! Return Minimal Length = 0.",
        actionBn: "🏁 লাইন ২: খালি অ্যারে! সর্বমোট দৈর্ঘ্য = 0।",
        reasonEn: "Empty array has no sub-arrays.",
        reasonBn: "খালি অ্যারের কোনো সাব-অ্যারে নেই।",
      ));
      return steps;
    }

    int l = 0;
    int sum = 0;
    int minLen = 999999;
    List<int> minSubarray = [];

    for (int r = 0; r < n; r++) {
      sum += numbers[r];

      steps.add(MinSizeSubarraySumStep(
        left: l,
        right: r,
        windowSub: numbers.sublist(l, r + 1),
        currentSum: sum,
        target: targetVal,
        minLength: minLen == 999999 ? 0 : minLen,
        minSubarray: List.from(minSubarray),
        decision: "expand",
        activeLine: 5,
        actionEn: "➡️ Line 5: Expand right to $r (${numbers[r]}) ➔ Window [${l}..${r}] [${numbers.sublist(l, r + 1).join(', ')}] (Sum = $sum, Target = $targetVal).",
        actionBn: "➡️ লাইন ৫: ডান পয়েন্টার $r (${numbers[r]}) এ বাড়ানো হলো ➔ উইন্ডো [${l}..${r}] [${numbers.sublist(l, r + 1).join(', ')}] (যোগফল = $sum, টার্গেট = $targetVal)।",
        reasonEn: "Add nums[$r] to current window sum.",
        reasonBn: "বর্তমান উইন্ডো যোগফলে nums[$r] যোগ করা হলো।",
      ));

      while (sum >= targetVal) {
        int windowLen = r - l + 1;
        bool isNewMin = windowLen < minLen;

        if (isNewMin) {
          minLen = windowLen;
          minSubarray = numbers.sublist(l, r + 1);
          steps.add(MinSizeSubarraySumStep(
            left: l,
            right: r,
            windowSub: numbers.sublist(l, r + 1),
            currentSum: sum,
            target: targetVal,
            minLength: minLen,
            minSubarray: List.from(minSubarray),
            decision: "min_updated",
            activeLine: 7,
            actionEn: "🎉 Line 7: NEW Minimal Valid Subarray! Window [${l}..${r}] [${minSubarray.join(', ')}] ➔ Sum = $sum >= $targetVal (Length = $minLen)!",
            actionBn: "🎉 লাইন ৭: নতুন সর্বনিম্ন বৈধ্য সাব-অ্যারে! উইন্ডো [${l}..${r}] [${minSubarray.join(', ')}] ➔ যোগফল = $sum >= $targetVal (দৈর্ঘ্য = $minLen)!",
            reasonEn: "Current valid window length $windowLen is smaller than previous minimum length. Update minLen!",
            reasonBn: "বর্তমান বৈধ্য উইন্ডোর দৈর্ঘ্য $windowLen পূর্বের মিনিমাম দৈর্ঘ্যের চেয়ে ছোট। minLen আপডেট করুন!",
          ));
        }

        steps.add(MinSizeSubarraySumStep(
          left: l,
          right: r,
          windowSub: numbers.sublist(l, r + 1),
          currentSum: sum,
          target: targetVal,
          minLength: minLen,
          minSubarray: List.from(minSubarray),
          decision: "shrink_left",
          activeLine: 8,
          actionEn: "⬅️ Line 8: Valid Sum ($sum >= $targetVal)! Subtract nums[$l] (${numbers[l]}) and shrink left pointer to ${l + 1}.",
          actionBn: "⬅️ লাইন ৮: বৈধ্য যোগফল ($sum >= $targetVal)! nums[$l] (${numbers[l]}) বিয়োগ করে বাম পয়েন্টার বাড়িয়ে ${l + 1} এ আনা হলো।",
          reasonEn: "Shrink left pointer to find if a smaller window length can also satisfy sum >= $targetVal.",
          reasonBn: "ক্ষুদ্রতর উইন্ডো দৈর্ঘ্যও sum >= $targetVal পূরণ করতে পারে কিনা দেখতে বাম পয়েন্টার কমানো হলো।",
        ));

        sum -= numbers[l];
        l++;
      }
    }

    int resultLen = minLen == 999999 ? 0 : minLen;

    steps.add(MinSizeSubarraySumStep(
      left: l < n ? l : n - 1,
      right: n - 1,
      windowSub: l < n ? numbers.sublist(l) : [],
      currentSum: sum,
      target: targetVal,
      minLength: resultLen,
      minSubarray: List.from(minSubarray),
      decision: "finished",
      activeLine: 11,
      actionEn: resultLen > 0
          ? "🏁 Line 11: Traversal Complete! Minimal Size Subarray Sum = $resultLen (Subarray [${minSubarray.join(', ')}])."
          : "🏁 Line 11: Traversal Complete! No subarray sum >= $targetVal exists. Minimal Length = 0.",
      actionBn: resultLen > 0
          ? "🏁 লাইন ১১: স্ক্যান সম্পূর্ণ! সর্বনিম্ন সাইজের সাব-অ্যারে দৈর্ঘ্য = $resultLen (সাব-অ্যারে [${minSubarray.join(', ')}])।"
          : "🏁 লাইন ১১: স্ক্যান সম্পূর্ণ! sum >= $targetVal এর কোনো সাব-অ্যারে নেই। সর্বমোট দৈর্ঘ্য = 0।",
      reasonEn: "Evaluated all window subarrays in O(N) linear time.",
      reasonBn: "O(N) লিনিয়ার সময়ে সমস্ত উইন্ডো সাব-অ্যারের মূল্যায়ন সম্পন্ন।",
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

  int _minSubArrayLen(int targetVal, List<int> numbers) {
    int l = 0, sum = 0, minL = 999999;
    for (int r = 0; r < numbers.length; r++) {
      sum += numbers[r];
      while (sum >= targetVal) {
        minL = min(minL, r - l + 1);
        sum -= numbers[l++];
      }
    }
    return minL == 999999 ? 0 : minL;
  }

  void _handlePracticeAction(String actionType) {
    if (_practiceSolved || _practiceRight >= _nums.length) return;

    int l = 0, sum = 0, minL = 999999;
    bool expectedShrink = false;
    bool expectedMin = false;

    for (int r = 0; r <= _practiceRight; r++) {
      sum += _nums[r];
      while (sum >= target) {
        if (r == _practiceRight) expectedShrink = true;
        int len = r - l + 1;
        if (len < minL) {
          if (r == _practiceRight) expectedMin = true;
          minL = len;
        }
        sum -= _nums[l++];
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

        if (_practiceRight >= _nums.length) {
          _practiceSolved = true;
          int finalMin = minL == 999999 ? 0 : minL;
          _userFeedbackEn = "🏆 MASTERED! You correctly tracked window sum and shrinking logic! Minimal Length = $finalMin!";
          _userFeedbackBn = "🏆 দারুণ! আপনি উইন্ডোর যোগফল এবং শৃঙ্কিং লজিক সঠিকভাবে ট্র্যাক করেছেন! সর্বনিম্ন দৈর্ঘ্য = $finalMin!";
        } else {
          _userFeedbackEn = "Correct! Inspecting index $_practiceRight (${_nums[_practiceRight]}). Select next step action!";
          _userFeedbackBn = "সঠিক! ইনডেক্স $_practiceRight (${_nums[_practiceRight]}) পরীক্ষা করা হচ্ছে। পরের পদক্ষেপ নির্বাচন করুন!";
        }
      } else {
        _userFeedbackEn = "Incorrect! Index ${_practiceRight} (${_nums[_practiceRight]}) requires action: $expectedAction. Try again!";
        _userFeedbackBn = "ভুল উত্তর! ইনডেক্স ${_practiceRight} (${_nums[_practiceRight]}) এর জন্য সঠিক অ্যাকশন হলো: $expectedAction। আবার চেষ্টা করুন!";
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
          '209. Minimum Size Subarray Sum',
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
                    "209. Minimum Size Subarray Sum",
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
                        ? "Given an array of positive integers nums and a positive integer target, return the minimal length of a contiguous subarray of which the sum >= target. If there is no such subarray, return 0 instead."
                        : "ধনাত্মক পূর্ণসংখ্যার একটি অ্যারে nums এবং একটি সংখ্যা target দেওয়া আছে। যে সাব-অ্যারের যোগফল sum >= target হবে, এমন সর্বনিম্ন দৈর্ঘ্যের সাব-অ্যারের দৈর্ঘ্য রিটার্ন করুন। এমন কোনো সাব-অ্যারে না থাকলে 0 রিটার্ন করুন।",
                    style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Examples
            Text(_isEnglish ? "Examples" : "উদাহরণসমূহ", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            _buildExampleCard("Example 1", "target = 7, nums = [2, 3, 1, 2, 4, 3]", "Output: 2 (Subarray [4, 3] has sum 7)"),
            _buildExampleCard("Example 2", "target = 4, nums = [1, 4, 4]", "Output: 1 (Subarray [4])"),
            _buildExampleCard("Example 3", "target = 11, nums = [1, 1, 1, 1, 1, 1, 1, 1]", "Output: 0"),
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
                        _isEnglish ? "Key Intuition (Dynamic Variable Window - Min Length)" : "মূল আইডিয়া (ডাইনামিক ভ্যারিয়েবল উইন্ডো - মিনিমাম লেংথ)",
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isEnglish
                        ? "1. Expand right pointer to accumulate currentSum until currentSum >= target.\n2. Once valid (currentSum >= target), shrink left pointer to minimize window length while keeping currentSum >= target.\n3. Each element enters and exits window at most once ➔ O(N) linear time & O(1) space complexity!"
                        : "১. currentSum >= target না হওয়া পর্যন্ত ডান পয়েন্টার বাড়ান।\n২. শর্ত পূরণ হলেই (currentSum >= target) বাম পয়েন্টার কমিয়ে উইন্ডো ছোট করার চেষ্টা করুন।\n৩. প্রতিটি উপাদান উইন্ডোতে সর্বোচ্চ ১ বার আসে ও ১ বার বের হয় ➔ O(N) লিনিয়ার সময় ও O(1) স্পেস!",
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
              _isEnglish ? "Min Size Subarray Sum Visual Models" : "মিন সাইজ সাব-অ্যারে সাম ভিজ্যুয়াল মডেলসমূহ (কোডহীন গাইড)",
              style: TextStyle(fontSize: Responsive.sp(context, 18), fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 6),
            Text(
              _isEnglish
                  ? "Explore 3 interactive models for target = 7, nums = [2, 3, 1, 2, 4, 3]."
                  : "target = 7, nums = [2, 3, 1, 2, 4, 3] এর জন্য ৩টি ইন্টারঅ্যাক্টিভ ভিজ্যুয়াল মডেল পর্যবেক্ষণ করুন।",
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 16),

            // Model Switcher Segmented Control
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildAnimationModelChip(0, _isEnglish ? "1. 🪜 Step Flowcard" : "১. 🪜 স্টেপ-বাই-স্টেপ ফ্লো-কার্ড"),
                  _buildAnimationModelChip(1, _isEnglish ? "2. 📏 Shrinking Rule" : "২. 📏 উইন্ডো কমানোর নীতি"),
                  _buildAnimationModelChip(2, _isEnglish ? "3. 📊 Complexity Calculator" : "৩. 📊 টাইমিং ক্যালকুলেটর"),
                ],
              ),
            ),
            const SizedBox(height: 20),

            if (_animationModelIndex == 0) _buildStepFlowcardModel(),
            if (_animationModelIndex == 1) _buildShrinkingRuleModel(),
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
        "window": "[2, 3, 1, 2]",
        "sum": 8,
        "minLen": 4,
        "badge": "🎉 VALID WINDOW (LEN=4)",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 1: Expand [0..3] [2, 3, 1, 2] ➔ Sum = 8 >= 7! Min Len = 4",
        "titleBn": "ধাপ ১: প্রসার [0..3] [2, 3, 1, 2] ➔ যোগফল = ৮ >= ৭! সর্বনিম্ন দৈর্ঘ্য = ৪",
        "descEn": "Sum 8 exceeds target 7. Recorded initial valid window length = 4.",
        "descBn": "যোগফল ৮ টার্গেট ৭ কে অতিক্রম করেছে। প্রাথমিক বৈধ্য দৈর্ঘ্য ৪ রেকর্ড করা হলো।",
      },
      {
        "step": 2,
        "window": "[3, 1, 2, 4]",
        "sum": 10,
        "minLen": 3,
        "badge": "⬅️ SHRINK & MIN UPDATED",
        "badgeColor": AppTheme.accentAmber,
        "titleEn": "Step 2: Shrink Left & Expand ➔ [1, 2, 4] Sum = 7 >= 7! NEW Min Len = 3!",
        "titleBn": "ধাপ ২: বাম কমান ও প্রসার ➔ [1, 2, 4] যোগফল = ৭ >= ৭! নতুন সর্বনিম্ন দৈর্ঘ্য = ৩!",
        "descEn": "[1, 2, 4] gives valid sum 7 with smaller length 3!",
        "descBn": "[1, 2, 4] সাব-অ্যারে ক্ষুদ্রতর ৩ দৈর্ঘ্যে বৈধ্য যোগফল ৭ প্রদান করে!",
      },
      {
        "step": 3,
        "window": "[4, 3]",
        "sum": 7,
        "minLen": 2,
        "badge": "🎉 NEW MINIMAL LENGTH = 2",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 3: Expand & Shrink to [4, 3] ➔ Sum = 7 >= 7! NEW Min Len = 2! 🎉",
        "titleBn": "ধাপ ৩: স্লাইড করে [4, 3] ➔ যোগফল = ৭ >= ৭! নতুন সর্বনিম্ন দৈর্ঘ্য = ২! 🎉",
        "descEn": "Subarray [4, 3] gives sum 7 with minimal length 2!",
        "descBn": "সাব-অ্যারে [4, 3] সর্বনিম্ন ২ দৈর্ঘ্যে যোগফল ৭ প্রদান করে!",
      },
      {
        "step": 4,
        "window": "[4, 3]",
        "sum": 7,
        "minLen": 2,
        "badge": "🏁 COMPLETE",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 4: All Subarrays Evaluated! Minimal Size Subarray Sum = 2",
        "titleBn": "ধাপ ৪: সমস্ত সাব-অ্যারে মূল্যায়ন সম্পন্ন! সর্বনিম্ন সাইজের সাব-অ্যারে দৈর্ঘ্য = ২",
        "descEn": "Minimal Subarray [4, 3] of length 2 gives sum >= target 7!",
        "descBn": "সর্বনিম্ন ২ দৈর্ঘ্যের সাব-অ্যারে [4, 3] যোগফল >= টার্গেট ৭ প্রদান করে!",
      },
    ];

    final currentStep = stepFlowData[_flowStepIndex.clamp(0, stepFlowData.length - 1)];
    final String window = currentStep["window"] as String;
    final int sumVal = currentStep["sum"] as int;
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
                _isEnglish ? "1. Step-by-Step Subarray Shrinking Flowcard" : "১. স্টেপ-বাই-স্টেপ সাব-অ্যারে শৃঙ্কিং ফ্লো-কার্ড",
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
                ? "Watch right pointer expansion and left pointer shrinking when sum >= target."
                : "যোগফল sum >= target হলে ডান প্রসার ও বাম কমানোর দৃশ্যপট দেখুন।",
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
                    Text("Subarray = $window (Sum = $sumVal)", style: TextStyle(color: badgeColor, fontWeight: FontWeight.bold, fontSize: 12)),
                    Text("Minimal Length = $minLenVal", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
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
                    "Minimal Valid Subarray Length = $minLenVal",
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

  // MODEL 2: Shrinking Rule
  Widget _buildShrinkingRuleModel() {
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
            _isEnglish ? "2. Minimal Length Subarray Shrinking Rule" : "২. সর্বনিম্ন দৈর্ঘ্যের উইন্ডো কমানোর নীতি",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            _isEnglish
                ? "While sum >= target, record minLen = min(minLen, right - left + 1) and shrink left: sum -= nums[left++]."
                : "sum >= target থাকা পর্যন্ত minLen = min(minLen, right - left + 1) রেকর্ড করুন এবং বাম কমান: sum -= nums[left++]।",
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
              "while (sum >= target) { minLen = min(minLen, r - l + 1); sum -= nums[l++]; } 📏",
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
                ? "Brute force checks all O(N^2) subarrays in O(N^2) time.\nSliding Window enters and exits each element at most once in O(N) time with O(1) auxiliary space!"
                : "ব্রুট ফোর্স O(N^2) সময়ে সমস্ত সাব-অ্যারে পরীক্ষা করে।\nস্লাইডিং উইন্ডোতে প্রতিটি উপাদান সর্বোচ্চ ১ বার ঢোকে ও ১ বার বের হয় ➔ O(N) টাইম ও O(1) স্পেস!",
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
                      flex: 2,
                      child: TextField(
                        controller: _numsController,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          labelText: _isEnglish ? "Nums Array (e.g. 2, 3, 1, 2, 4, 3)" : "অ্যারে (যেমন 2, 3, 1, 2, 4, 3)",
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
                        controller: _targetController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          labelText: _isEnglish ? "Target Sum" : "টার্গেট যোগফল",
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
                      _buildPresetChip("2, 3, 1, 2, 4, 3", "7"),
                      _buildPresetChip("1, 4, 4", "4"),
                      _buildPresetChip("1, 1, 1, 1, 1, 1, 1, 1", "11"),
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
                  _buildMinSizeCanvas(step),
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildCodeHighlightBox(step.activeLine)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildMinSizeCanvas(step)),
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
    final targetMinLen = _minSubArrayLen(_target, _nums);

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
                  ? "Track window expansion and decide next step action at each element!"
                  : "প্রতিটি উপাদানের জন্য উইন্ডো প্রসারিত করুন এবং পরবর্তী অ্যাকশন নির্বাচন করুন!",
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
            if (!_practiceSolved && _practiceRight < _nums.length)
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
                        Text("Current Index: right = $_practiceRight (${_nums[_practiceRight]})", style: const TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 12)),
                        Text("Minimal Length Target: $targetMinLen", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Window: [$_practiceLeft .. $_practiceRight] = [${_nums.sublist(_practiceLeft, _practiceRight + 1).join(', ')}]",
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
                          label: Text(_isEnglish ? "EXPAND (sum < target)" : "EXPAND (যোগফল কম)"),
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
  Widget _buildPresetChip(String nVal, String tVal) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ActionChip(
        backgroundColor: const Color(0xFF090D16),
        label: Text("[$nVal], target=$tVal", style: const TextStyle(color: AppTheme.accentNeonCyan, fontSize: 11)),
        onPressed: () {
          _numsController.text = nVal;
          _targetController.text = tVal;
          _rebuildSteps();
        },
      ),
    );
  }

  Widget _buildCodeHighlightBox(int activeLine) {
    final codeLines = [
      "int minSubArrayLen(int target, vector<int>& nums) {",
      "    int left = 0, sum = 0, minLength = INT_MAX;",
      "    for (int right = 0; right < nums.size(); right++) {",
      "        sum += nums[right];",
      "        while (sum >= target) {",
      "            minLength = min(minLength, right - left + 1);",
      "            sum -= nums[left++];",
      "        }",
      "    }",
      "    return minLength == INT_MAX ? 0 : minLength;",
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

  Widget _buildMinSizeCanvas(MinSizeSubarraySumStep step) {
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
      decisionLabel = "🎉 MIN LEN UPDATED";
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
              Text("Window: [L:${step.left} .. R:${step.right}] (Target = ${step.target})", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13)),
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
              Text("Current Sum = ${step.currentSum} / target=${step.target}", style: TextStyle(color: step.currentSum >= step.target ? AppTheme.accentGreen : AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 12)),
              Text("Min Length = ${step.minLength}", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
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
                  "Minimal Valid Subarray Length = ${step.minLength}",
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
                  "Min Subarray: [${step.minSubarray.join(', ')}]",
                  style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Visual Array Sequence Canvas with Pointers L and R
          const Text("Nums Array Sequence Canvas:", style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_nums.length, (idx) {
                bool inWindow = idx >= step.left && idx <= step.right;
                bool isL = idx == step.left;
                bool isR = idx == step.right;

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
                      Text(
                        "${_nums[idx]}",
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
    int minSubArrayLen(int target, vector<int>& nums) {
        int left = 0, sum = 0, minLength = INT_MAX;
        for (int right = 0; right < nums.size(); right++) {
            sum += nums[right];
            while (sum >= target) {
                minLength = min(minLength, right - left + 1);
                sum -= nums[left++];
            }
        }
        return minLength == INT_MAX ? 0 : minLength;
    }
};""";
    } else if (lang == "Java") {
      code = """
class Solution {
    public int minSubArrayLen(int target, int[] nums) {
        int left = 0, sum = 0, minLength = Integer.MAX_VALUE;
        for (int right = 0; right < nums.length; right++) {
            sum += nums[right];
            while (sum >= target) {
                minLength = Math.min(minLength, right - left + 1);
                sum -= nums[left++];
            }
        }
        return minLength == Integer.MAX_VALUE ? 0 : minLength;
    }
}""";
    } else {
      code = """
class Solution:
    def minSubArrayLen(self, target: int, nums: List[int]) -> int:
        left = 0
        current_sum = 0
        min_len = float('inf')

        for right in range(len(nums)):
            current_sum += nums[right]
            while current_sum >= target:
                min_len = min(min_len, right - left + 1)
                current_sum -= nums[left]
                left += 1

        return min_len if min_len != float('inf') else 0""";
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
