import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class MaxConsecutiveOnesIIIStep {
  final int left;
  final int right;
  final List<int> windowSub;
  final int zeroCount;
  final int k;
  final int maxLength;
  final List<int> maxSubarray;
  final String decision; // 'init', 'expand', 'shrink_left', 'max_updated', 'finished'
  final int activeLine;
  final String actionEn;
  final String actionBn;
  final String reasonEn;
  final String reasonBn;

  const MaxConsecutiveOnesIIIStep({
    required this.left,
    required this.right,
    required this.windowSub,
    required this.zeroCount,
    required this.k,
    required this.maxLength,
    required this.maxSubarray,
    required this.decision,
    required this.activeLine,
    required this.actionEn,
    required this.actionBn,
    required this.reasonEn,
    required this.reasonBn,
  });
}

class MaxConsecutiveOnesIIIDetailScreen extends StatefulWidget {
  const MaxConsecutiveOnesIIIDetailScreen({super.key});

  @override
  State<MaxConsecutiveOnesIIIDetailScreen> createState() =>
      _MaxConsecutiveOnesIIIDetailScreenState();
}

class _MaxConsecutiveOnesIIIDetailScreenState
    extends State<MaxConsecutiveOnesIIIDetailScreen>
    with SingleTickerProviderStateMixin {
  bool _isEnglish = true;
  late TabController _tabController;

  // Custom Input State
  final TextEditingController _numsController = TextEditingController(text: "1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 0");
  final TextEditingController _kController = TextEditingController(text: "2");
  List<int> _nums = [1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 0];
  int _k = 2;
  List<MaxConsecutiveOnesIIIStep> _steps = [];

  // Playback Control
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  // Code Language Selector
  String _selectedCodeLang = "C++";

  // Tab 2 Animation Model Selector (0: Step Flowcard, 1: Zero Counter Rule, 2: Complexity Calculator)
  int _animationModelIndex = 0;
  int _flowStepIndex = 0;

  // Practice Mode State
  int _practiceRight = 0;
  int _practiceLeft = 0;
  int _practiceMaxLen = 0;
  String _userFeedbackEn = "Expand right pointer and shrink left when zero count exceeds k!";
  String _userFeedbackBn = "ডান পয়েন্টার বাড়ান এবং শূন্যের সংখ্যা k এর বেশি হলে বাম কমান!";
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
    _kController.dispose();
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
      int kVal = int.parse(_kController.text.trim());
      if (parsed.isEmpty) parsed = [1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 0];
      if (kVal < 0) kVal = 0;
      _nums = parsed;
      _k = kVal;
    } catch (_) {
      _nums = [1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 0];
      _k = 2;
    }

    _steps = _generateSteps(_nums, _k);

    // Reset practice mode
    _resetPractice();
  }

  void _resetPractice() {
    _practiceLeft = 0;
    _practiceRight = 0;
    _practiceMaxLen = 0;
    _practiceSolved = false;
    _userFeedbackEn = "Inspect element at right = 0 (${_nums.isNotEmpty ? _nums[0] : 0}) with k = $_k!";
    _userFeedbackBn = "k = $_k সহ ইনডেক্স right = 0 (${_nums.isNotEmpty ? _nums[0] : 0}) এর উপাদান পরীক্ষা করুন!";
  }

  List<MaxConsecutiveOnesIIIStep> _generateSteps(List<int> numbers, int kVal) {
    List<MaxConsecutiveOnesIIIStep> steps = [];
    int n = numbers.length;

    // Step 0: Init
    steps.add(MaxConsecutiveOnesIIIStep(
      left: 0,
      right: 0,
      windowSub: n > 0 ? [numbers[0]] : [],
      zeroCount: 0,
      k: kVal,
      maxLength: 0,
      maxSubarray: [],
      decision: "init",
      activeLine: 1,
      actionEn: "Line 1: Initialize Sliding Window for nums = [${numbers.join(', ')}], k = $kVal.",
      actionBn: "লাইন ১: nums = [${numbers.join(', ')}], k = $kVal এর জন্য স্লাইডিং উইন্ডো শুরু।",
      reasonEn: "We maintain left pointer, zero counter, and track max consecutive 1s with at most $kVal flips.",
      reasonBn: "আমরা বাম পয়েন্টার, জিরো কাউন্টার এবং সর্বোচ্চ $kVal টি ফিপ সহ ১ এর সর্বোচ্চ সংখ্যা ট্র্যাক করব।",
    ));

    if (n == 0) {
      steps.add(const MaxConsecutiveOnesIIIStep(
        left: 0,
        right: 0,
        windowSub: [],
        zeroCount: 0,
        k: 0,
        maxLength: 0,
        maxSubarray: [],
        decision: "finished",
        activeLine: 2,
        actionEn: "🏁 Line 2: Empty array! Return 0.",
        actionBn: "🏁 লাইন ২: খালি অ্যারে! 0 রিটার্ন করুন।",
        reasonEn: "Empty array has length 0.",
        reasonBn: "খালি অ্যারের দৈর্ঘ্য ০।",
      ));
      return steps;
    }

    int l = 0;
    int zeroCount = 0;
    int maxLen = 0;
    List<int> maxSubarray = [];

    for (int r = 0; r < n; r++) {
      if (numbers[r] == 0) zeroCount++;

      if (zeroCount > kVal) {
        if (numbers[l] == 0) zeroCount--;
        l++;

        steps.add(MaxConsecutiveOnesIIIStep(
          left: l,
          right: r,
          windowSub: numbers.sublist(l, r + 1),
          zeroCount: zeroCount,
          k: kVal,
          maxLength: maxLen,
          maxSubarray: List.from(maxSubarray),
          decision: "shrink_left",
          activeLine: 7,
          actionEn: "⬅️ Line 7: Zero count ($zeroCount) > k ($kVal)! Shrink left pointer to $l.",
          actionBn: "⬅️ লাইন ৭: শূন্যের সংখ্যা ($zeroCount) > k ($kVal)! বাম পয়েন্টার বাড়িয়ে $l এ আনা হলো।",
          reasonEn: "Window contains too many zeros. Increment left pointer to restore zeroCount <= $kVal.",
          reasonBn: "উইন্ডোতে খুব বেশি শূন্য রয়েছে। zeroCount <= $kVal নিশ্চিত করতে বাম পয়েন্টার বাড়ানো হলো।",
        ));
      } else {
        int windowLen = r - l + 1;
        if (windowLen > maxLen) {
          maxLen = windowLen;
          maxSubarray = numbers.sublist(l, r + 1);
          steps.add(MaxConsecutiveOnesIIIStep(
            left: l,
            right: r,
            windowSub: numbers.sublist(l, r + 1),
            zeroCount: zeroCount,
            k: kVal,
            maxLength: maxLen,
            maxSubarray: List.from(maxSubarray),
            decision: "max_updated",
            activeLine: 9,
            actionEn: "🎉 Line 9: NEW Max Valid Subarray! Window [${l}..${r}] [${maxSubarray.join(', ')}] ➔ Length = $maxLen!",
            actionBn: "🎉 লাইন ৯: নতুন সর্বোচ্চ বৈধ্য সাব-অ্যারে! উইন্ডো [${l}..${r}] [${maxSubarray.join(', ')}] ➔ দৈর্ঘ্য = $maxLen!",
            reasonEn: "Current valid window length $windowLen exceeds max length. Update maxLen!",
            reasonBn: "বর্তমান বৈধ্য উইন্ডোর দৈর্ঘ্য $windowLen সর্বমোট দৈর্ঘ্য ছাড়িয়ে গেছে। maxLen আপডেট করুন!",
          ));
        } else {
          steps.add(MaxConsecutiveOnesIIIStep(
            left: l,
            right: r,
            windowSub: numbers.sublist(l, r + 1),
            zeroCount: zeroCount,
            k: kVal,
            maxLength: maxLen,
            maxSubarray: List.from(maxSubarray),
            decision: "expand",
            activeLine: 8,
            actionEn: "➡️ Line 8: Expand right to $r (${numbers[r]}) ➔ Window [${l}..${r}] [${numbers.sublist(l, r + 1).join(', ')}] (Zeros = $zeroCount, Max = $maxLen).",
            actionBn: "➡️ লাইন ৮: ডান পয়েন্টার $r (${numbers[r]}) এ বাড়ানো হলো ➔ উইন্ডো [${l}..${r}] [${numbers.sublist(l, r + 1).join(', ')}] (শূন্য = $zeroCount, সর্বমোট = $maxLen)।",
            reasonEn: "Valid window with zeroCount ($zeroCount) <= k ($kVal).",
            reasonBn: "$zeroCount টি শূন্য সহ বৈধ্য উইন্ডো <= k ($kVal)।",
          ));
        }
      }
    }

    steps.add(MaxConsecutiveOnesIIIStep(
      left: l < n ? l : n - 1,
      right: n - 1,
      windowSub: l < n ? numbers.sublist(l) : [],
      zeroCount: zeroCount,
      k: kVal,
      maxLength: maxLen,
      maxSubarray: List.from(maxSubarray),
      decision: "finished",
      activeLine: 11,
      actionEn: "🏁 Line 11: Traversal Complete! Maximum Consecutive Ones = $maxLen (Subarray [${maxSubarray.join(', ')}]).",
      actionBn: "🏁 লাইন ১১: স্ক্যান সম্পূর্ণ! সর্বোচ্চ ১ এর পর পর সংখ্যা (দৈর্ঘ্য) = $maxLen (সাব-অ্যারে [${maxSubarray.join(', ')}])।",
      reasonEn: "Evaluated binary array nums of length $n in O(N) linear time.",
      reasonBn: "O(N) লিনিয়ার সময়ে $n দৈর্ঘ্যের বাইনারি অ্যারে nums এর মূল্যায়ন সম্পন্ন।",
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

  int _longestOnes(List<int> numbers, int kVal) {
    int l = 0, zeros = 0, maxL = 0;
    for (int r = 0; r < numbers.length; r++) {
      if (numbers[r] == 0) zeros++;
      if (zeros > kVal) {
        if (numbers[l] == 0) zeros--;
        l++;
      }
      maxL = max(maxL, r - l + 1);
    }
    return maxL;
  }

  void _handlePracticeAction(String actionType) {
    if (_practiceSolved || _practiceRight >= _nums.length) return;

    int l = 0, zeros = 0, maxL = 0;
    bool expectedShrink = false;
    bool expectedMax = false;

    for (int r = 0; r <= _practiceRight; r++) {
      if (_nums[r] == 0) zeros++;
      if (zeros > _k) {
        if (r == _practiceRight) expectedShrink = true;
        if (_nums[l] == 0) zeros--;
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

        if (_practiceRight >= _nums.length) {
          _practiceSolved = true;
          _userFeedbackEn = "🏆 MASTERED! You correctly evaluated zero count condition! Max Length = $maxL!";
          _userFeedbackBn = "🏆 দারুণ! আপনি শূন্যের সংখ্যা শর্ত সঠিকভাবে মূল্যায়ন করেছেন! সর্বমোট দৈর্ঘ্য = $maxL!";
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
          '1004. Max Consecutive Ones III',
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
                    "1004. Max Consecutive Ones III",
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
              children: ["Meta", "Google", "Amazon"].map((company) {
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
                        ? "Given a binary array nums and an integer k, return the maximum number of consecutive 1s in the array if you can flip at most k 0s."
                        : "একটি বাইনারি অ্যারে nums এবং একটি সংখ্যা k দেওয়া আছে। সর্বোচ্চ k টি 0 কে 1 এ রূপান্তর করার পর পরপর পাওয়া যেতে পারে এমন সর্বোচ্চ সংখ্যক 1 এর সংখ্যা (দৈর্ঘ্য) কত তা নির্ণয় করুন।",
                    style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Examples
            Text(_isEnglish ? "Examples" : "উদাহরণসমূহ", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            _buildExampleCard("Example 1", "nums = [1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 0], k = 2", "Output: 6 (Subarray [0, 0, 1, 1, 1, 1] from index 4 to 9 has two 0s)"),
            _buildExampleCard("Example 2", "nums = [0, 0, 1, 1, 0, 0, 1, 1, 1, 0, 1, 1, 0, 0, 0, 1, 1, 1, 1], k = 3", "Output: 10"),
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
                        _isEnglish ? "Key Intuition (Dynamic Window with Zero Counter)" : "মূল আইডিয়া (ডাইনামিক উইন্ডো ও জিরো কাউন্টার)",
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isEnglish
                        ? "1. Expand right pointer and count zeros inside window zeroCount.\n2. Valid condition: zeroCount <= k.\n3. When zeroCount > k, shrink window from left (left++) until zeroCount <= k.\n4. Achieves O(N) linear time complexity and O(1) space complexity!"
                        : "১. ডান পয়েন্টার বাড়ান এবং উইন্ডোর ভেতরে থাকা ০ এর সংখ্যা zeroCount গণনা করুন।\n২. বৈধ্য শর্ত: zeroCount <= k।\n۳. zeroCount > k হলে বাম পয়েন্টার কমিয়ে (left++) zeroCount <= k নিশ্চিত করুন।\n৪. O(N) লিনিয়ার সময় ও O(1) স্পেস কমপ্লেক্সিটি।",
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
              _isEnglish ? "Max Consecutive Ones Visual Models" : "ম্যাক্স কনসিকিউটিভ ওয়ানস ভিজ্যুয়াল মডেলসমূহ (কোডহীন গাইড)",
              style: TextStyle(fontSize: Responsive.sp(context, 18), fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 6),
            Text(
              _isEnglish
                  ? "Explore 3 interactive models for nums = [1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 0], k = 2."
                  : "nums = [1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 0], k = 2 এর জন্য ৩টি ইন্টারঅ্যাক্টিভ ভিজ্যুয়াল মডেল পর্যবেক্ষণ করুন।",
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 16),

            // Model Switcher Segmented Control
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildAnimationModelChip(0, _isEnglish ? "1. 🪜 Step Flowcard" : "১. 🪜 স্টেপ-বাই-স্টেপ ফ্লো-কার্ড"),
                  _buildAnimationModelChip(1, _isEnglish ? "2. 📏 Zero Counter Rule" : "২. 📏 জিরো কাউন্টার নীতি"),
                  _buildAnimationModelChip(2, _isEnglish ? "3. 📊 Complexity Calculator" : "৩. 📊 টাইমিং ক্যালকুলেটর"),
                ],
              ),
            ),
            const SizedBox(height: 20),

            if (_animationModelIndex == 0) _buildStepFlowcardModel(),
            if (_animationModelIndex == 1) _buildZeroCounterRuleModel(),
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
        "window": "[1, 1, 1, 0, 0]",
        "zeros": 2,
        "max": 5,
        "badge": "🎉 VALID WINDOW (LEN=5)",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 1: Expand [0..4] [1, 1, 1, 0, 0] ➔ Zeros = 2 <= 2! Length = 5",
        "titleBn": "ধাপ ১: প্রসার [0..4] [1, 1, 1, 0, 0] ➔ শূন্য = ২ <= ২! দৈর্ঘ্য = ৫",
        "descEn": "Flipping two 0s gives 5 consecutive ones!",
        "descBn": "২টি ০ কে ১ বানালে পরপর ৫টি ১ পাওয়া যায়!",
      },
      {
        "step": 2,
        "window": "[1, 1, 0, 0, 0]",
        "zeros": 3,
        "max": 5,
        "badge": "⬅️ SHRINK LEFT",
        "badgeColor": AppTheme.accentAmber,
        "titleEn": "Step 2: Expand to index 5 ➔ Zeros = 3 > 2! Shrink Left to index 1",
        "titleBn": "ধাপ ২: ইনডেক্স ৫ এ প্রসার ➔ শূন্য = ৩ > ২! বাম কমান ইনডেক্স ১ এ",
        "descEn": "Too many zeros (3 > 2). Increment left pointer to reduce zero count.",
        "descBn": "খুব বেশি শূন্য (৩ > ২)। শূন্যের সংখ্যা কমাতে বাম পয়েন্টার বাড়ান।",
      },
      {
        "step": 3,
        "window": "[0, 0, 1, 1, 1, 1]",
        "zeros": 2,
        "max": 6,
        "badge": "🎉 NEW MAX LENGTH = 6",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 3: Expand to index 9 [0, 0, 1, 1, 1, 1] ➔ Zeros = 2 <= 2! NEW Max = 6! 🎉",
        "titleBn": "ধাপ ৩: ইনডেক্স ৯ এ প্রসার [0, 0, 1, 1, 1, 1] ➔ শূন্য = ২ <= ২! নতুন Max = ৬! 🎉",
        "descEn": "Subarray from index 4 to 9 has length 6 with two 0s!",
        "descBn": "ইনডেক্স ৪ থেকে ৯ এর সাব-অ্যারে ২টি ০ সহ ৬ দৈর্ঘ্যের ১ তৈরি করে!",
      },
      {
        "step": 4,
        "window": "[0, 0, 1, 1, 1, 1]",
        "zeros": 2,
        "max": 6,
        "badge": "🏁 COMPLETE",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 4: All Elements Evaluated! Maximum Consecutive Ones = 6",
        "titleBn": "ধাপ ৪: সমস্ত উপাদান মূল্যায়ন সম্পন্ন! সর্বোচ্চ ১ এর সংখ্যা = ৬",
        "descEn": "Maximum consecutive ones with at most 2 flips = 6!",
        "descBn": "সর্বোচ্চ ২ টি ফিপ সহ পরপর সর্বোচ্চ ১ এর সংখ্যা = ৬!",
      },
    ];

    final currentStep = stepFlowData[_flowStepIndex.clamp(0, stepFlowData.length - 1)];
    final String window = currentStep["window"] as String;
    final int zeroVal = currentStep["zeros"] as int;
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
                _isEnglish ? "1. Step-by-Step Consecutive Ones Flowcard" : "১. স্টেপ-বাই-স্টেপ কনসিকিউটিভ ওয়ানস ফ্লো-কার্ড",
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
                ? "Watch right pointer expansion and zero count evaluation."
                : "ডান পয়েন্টার বিস্তার এবং জিরো কাউন্ট মূল্যায়ন দেখুন।",
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
                    Text("Subarray = $window (Zeros = $zeroVal)", style: TextStyle(color: badgeColor, fontWeight: FontWeight.bold, fontSize: 12)),
                    Text("Max Consecutive = $maxVal", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
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
                    "Max Consecutive Ones Length = $maxVal",
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

  // MODEL 2: Zero Counter Rule
  Widget _buildZeroCounterRuleModel() {
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
            _isEnglish ? "2. Zero Counter Condition Rule" : "২. জিরো কাউন্টার শর্ত নীতি",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            _isEnglish
                ? "If nums[right] == 0, zeroCount++.\nIf zeroCount > k, shrink left: if (nums[left++] == 0) zeroCount--."
                : "nums[right] == 0 হলে zeroCount++।\nzeroCount > k হলে বাম কমান: nums[left++] == 0 হলে zeroCount--।",
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
              "if (zeroCount > k) { if (nums[left++] == 0) zeroCount--; } 📏",
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
                ? "Brute force checks all subarrays in O(N^2) time.\nSliding Window moves left and right pointers at most N times total in O(N) time with O(1) space!"
                : "ব্রুট ফোর্স O(N^2) সময়ে সমস্ত সাব-অ্যারে পরীক্ষা করে।\nস্লাইডিং উইন্ডো বাম ও ডান পয়েন্টার সর্বমোট N বার সরিয়ে O(N) টাইম ও O(1) স্পেসে সমাধান করে!",
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
                          labelText: _isEnglish ? "Binary Nums (e.g. 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 0)" : "বাইনারি অ্যারে (যেমন 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 0)",
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
                        controller: _kController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          labelText: _isEnglish ? "k (Flips)" : "k (ফিপস)",
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
                      _buildPresetChip("1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 0", "2"),
                      _buildPresetChip("0, 0, 1, 1, 0, 0, 1, 1, 1, 0, 1, 1", "3"),
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
                  _buildMaxConsecutiveCanvas(step),
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildCodeHighlightBox(step.activeLine)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildMaxConsecutiveCanvas(step)),
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
    final targetMaxLen = _longestOnes(_nums, _k);

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
                        Text("Max Consecutive Target: $targetMaxLen", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
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
  Widget _buildPresetChip(String nVal, String kVal) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ActionChip(
        backgroundColor: const Color(0xFF090D16),
        label: Text("[$nVal], k=$kVal", style: const TextStyle(color: AppTheme.accentNeonCyan, fontSize: 11)),
        onPressed: () {
          _numsController.text = nVal;
          _kController.text = kVal;
          _rebuildSteps();
        },
      ),
    );
  }

  Widget _buildCodeHighlightBox(int activeLine) {
    final codeLines = [
      "int longestOnes(vector<int>& nums, int k) {",
      "    int left = 0, zeroCount = 0, maxLength = 0;",
      "    for (int right = 0; right < nums.size(); right++) {",
      "        if (nums[right] == 0) zeroCount++;",
      "        if (zeroCount > k) {",
      "            if (nums[left] == 0) zeroCount--;",
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

  Widget _buildMaxConsecutiveCanvas(MaxConsecutiveOnesIIIStep step) {
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
              Text("Window: [L:${step.left} .. R:${step.right}] (k = ${step.k})", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13)),
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
              Text("Zero Count = ${step.zeroCount} / k=${step.k}", style: TextStyle(color: step.zeroCount <= step.k ? AppTheme.accentGreen : AppTheme.accentPink, fontWeight: FontWeight.bold, fontSize: 12)),
              Text("Max Consecutive Ones = ${step.maxLength}", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
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
                  "Max Consecutive Ones Length = ${step.maxLength}",
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
                  "Max Subarray: [${step.maxSubarray.join(', ')}]",
                  style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Visual Array Sequence Canvas with Pointers L and R
          const Text("Binary Nums Array Canvas:", style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_nums.length, (idx) {
                bool inWindow = idx >= step.left && idx <= step.right;
                bool isL = idx == step.left;
                bool isR = idx == step.right;
                bool isZero = _nums[idx] == 0;

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: inWindow
                        ? decisionColor.withOpacity(0.35)
                        : (isZero ? AppTheme.accentPink.withOpacity(0.15) : AppTheme.surfaceDark),
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
                          color: isZero ? AppTheme.accentPink : (inWindow ? Colors.white : const Color(0xFF64748B)),
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
    int longestOnes(vector<int>& nums, int k) {
        int left = 0, zeroCount = 0, maxLength = 0;
        for (int right = 0; right < nums.size(); right++) {
            if (nums[right] == 0) zeroCount++;
            if (zeroCount > k) {
                if (nums[left] == 0) zeroCount--;
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
    public int longestOnes(int[] nums, int k) {
        int left = 0, zeroCount = 0, maxLength = 0;
        for (int right = 0; right < nums.length; right++) {
            if (nums[right] == 0) zeroCount++;
            if (zeroCount > k) {
                if (nums[left] == 0) zeroCount--;
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
    def longestOnes(self, nums: List[int], k: int) -> int:
        left = 0
        zero_count = 0
        max_len = 0

        for right in range(len(nums)):
            if nums[right] == 0:
                zero_count += 1
            if zero_count > k:
                if nums[left] == 0:
                    zero_count -= 1
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
