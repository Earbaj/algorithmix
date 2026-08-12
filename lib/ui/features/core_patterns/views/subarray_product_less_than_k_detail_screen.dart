import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class SubarrayProductLessThanKStep {
  final int left;
  final int right;
  final List<int> windowSub;
  final int currentProduct;
  final int k;
  final int addedCount;
  final int totalCount;
  final String decision; // 'init', 'expand', 'shrink_left', 'count_updated', 'finished'
  final int activeLine;
  final String actionEn;
  final String actionBn;
  final String reasonEn;
  final String reasonBn;

  const SubarrayProductLessThanKStep({
    required this.left,
    required this.right,
    required this.windowSub,
    required this.currentProduct,
    required this.k,
    required this.addedCount,
    required this.totalCount,
    required this.decision,
    required this.activeLine,
    required this.actionEn,
    required this.actionBn,
    required this.reasonEn,
    required this.reasonBn,
  });
}

class SubarrayProductLessThanKDetailScreen extends StatefulWidget {
  const SubarrayProductLessThanKDetailScreen({super.key});

  @override
  State<SubarrayProductLessThanKDetailScreen> createState() =>
      _SubarrayProductLessThanKDetailScreenState();
}

class _SubarrayProductLessThanKDetailScreenState
    extends State<SubarrayProductLessThanKDetailScreen>
    with SingleTickerProviderStateMixin {
  bool _isEnglish = true;
  late TabController _tabController;

  // Custom Input State
  final TextEditingController _numsController = TextEditingController(text: "10, 5, 2, 6");
  final TextEditingController _kController = TextEditingController(text: "100");
  List<int> _nums = [10, 5, 2, 6];
  int _k = 100;
  List<SubarrayProductLessThanKStep> _steps = [];

  // Playback Control
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  // Code Language Selector
  String _selectedCodeLang = "C++";

  // Tab 2 Animation Model Selector (0: Step Flowcard, 1: Ending Pointer Formula, 2: Complexity Calculator)
  int _animationModelIndex = 0;
  int _flowStepIndex = 0;

  // Practice Mode State
  int _practiceRight = 0;
  int _practiceLeft = 0;
  int _practiceTotalCount = 0;
  String _userFeedbackEn = "Multiply right element to product and shrink left when product >= k!";
  String _userFeedbackBn = "ডান উপাদান যোগফলে গুণ করুন এবং গুণফল >= k হলে বাম কমান!";
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
      if (parsed.isEmpty) parsed = [10, 5, 2, 6];
      if (kVal < 0) kVal = 100;
      _nums = parsed;
      _k = kVal;
    } catch (_) {
      _nums = [10, 5, 2, 6];
      _k = 100;
    }

    _steps = _generateSteps(_nums, _k);

    // Reset practice mode
    _resetPractice();
  }

  void _resetPractice() {
    _practiceLeft = 0;
    _practiceRight = 0;
    _practiceTotalCount = 0;
    _practiceSolved = false;
    _userFeedbackEn = "Inspect element at right = 0 (${_nums.isNotEmpty ? _nums[0] : 0}) with k = $_k!";
    _userFeedbackBn = "k = $_k সহ ইনডেক্স right = 0 (${_nums.isNotEmpty ? _nums[0] : 0}) এর উপাদান পরীক্ষা করুন!";
  }

  List<SubarrayProductLessThanKStep> _generateSteps(List<int> numbers, int kVal) {
    List<SubarrayProductLessThanKStep> steps = [];
    int n = numbers.length;

    // Step 0: Init
    steps.add(SubarrayProductLessThanKStep(
      left: 0,
      right: 0,
      windowSub: n > 0 ? [numbers[0]] : [],
      currentProduct: 1,
      k: kVal,
      addedCount: 0,
      totalCount: 0,
      decision: "init",
      activeLine: 1,
      actionEn: "Line 1: Initialize Subarray Product Less Than K for nums = [${numbers.join(', ')}], k = $kVal.",
      actionBn: "লাইন ১: nums = [${numbers.join(', ')}], k = $kVal এর জন্য সাব-অ্যারে প্রোডাক্ট গণনা শুরু।",
      reasonEn: "If k <= 1, no product of positive integers can be strictly less than k.",
      reasonBn: "k <= 1 হলে ধনাত্মক সংখ্যার গুণফল k এর চেয়ে কম হতে পারে না।",
    ));

    if (kVal <= 1 || n == 0) {
      steps.add(SubarrayProductLessThanKStep(
        left: 0,
        right: 0,
        windowSub: [],
        currentProduct: 0,
        k: kVal,
        addedCount: 0,
        totalCount: 0,
        decision: "finished",
        activeLine: 2,
        actionEn: "🏁 Line 2: k <= 1 or empty array! Return 0 subarrays.",
        actionBn: "🏁 লাইন ২: k <= 1 অথবা খালি অ্যারে! ০ সাব-অ্যারে রিটার্ন করুন।",
        reasonEn: "All positive integer products are >= 1.",
        reasonBn: "সমস্ত ধনাত্মক পূর্ণসংখ্যার গুণফল >= ১।",
      ));
      return steps;
    }

    int l = 0;
    int prod = 1;
    int total = 0;

    for (int r = 0; r < n; r++) {
      prod *= numbers[r];

      while (prod >= kVal && l <= r) {
        prod ~/= numbers[l];
        l++;

        steps.add(SubarrayProductLessThanKStep(
          left: l,
          right: r,
          windowSub: numbers.sublist(l, r + 1),
          currentProduct: prod,
          k: kVal,
          addedCount: 0,
          totalCount: total,
          decision: "shrink_left",
          activeLine: 7,
          actionEn: "⬅️ Line 7: Product ($prod) >= k ($kVal)! Shrink left pointer to $l.",
          actionBn: "⬅️ লাইন ৭: গুণফল ($prod) >= k ($kVal)! বাম পয়েন্টার বাড়িয়ে $l এ আনা হলো।",
          reasonEn: "Product exceeded threshold k. Divide out nums[left] to reduce product < $kVal.",
          reasonBn: "গুণফল টার্গেট k ছাড়িয়ে গেছে। গুণফল < $kVal করতে বাম পয়েন্টার দ্বারা ভাগ করা হলো।",
        ));
      }

      int added = r - l + 1;
      total += added;

      steps.add(SubarrayProductLessThanKStep(
        left: l,
        right: r,
        windowSub: numbers.sublist(l, r + 1),
        currentProduct: prod,
        k: kVal,
        addedCount: added,
        totalCount: total,
        decision: "count_updated",
        activeLine: 9,
        actionEn: "🎉 Line 9: Window [${l}..${r}] [${numbers.sublist(l, r + 1).join(', ')}] (Prod = $prod < $kVal) ➔ Added $added Subarrays! (Total = $total)",
        actionBn: "🎉 লাইন ৯: উইন্ডো [${l}..${r}] [${numbers.sublist(l, r + 1).join(', ')}] (গুণফল = $prod < $kVal) ➔ $added টি সাব-অ্যারে যুক্ত হলো! (সর্বমোট = $total)",
        reasonEn: "Number of contiguous subarrays ending at index $r is (right - left + 1) = $added.",
        reasonBn: "ইনডেক্স $r এ শেষ হওয়া মোট সংলগ্ন সাব-অ্যারে সংখ্যা (right - left + 1) = $added।",
      ));
    }

    steps.add(SubarrayProductLessThanKStep(
      left: l < n ? l : n - 1,
      right: n - 1,
      windowSub: l < n ? numbers.sublist(l) : [],
      currentProduct: prod,
      k: kVal,
      addedCount: 0,
      totalCount: total,
      decision: "finished",
      activeLine: 11,
      actionEn: "🏁 Line 11: Traversal Complete! Total Subarrays Product Less Than $kVal = $total.",
      actionBn: "🏁 লাইন ১১: স্ক্যান সম্পূর্ণ! $kVal এর চেয়ে কম গুণফলের মোট সাব-অ্যারে = $total টি।",
      reasonEn: "Evaluated all subarrays in O(N) linear time.",
      reasonBn: "O(N) লিনিয়ার সময়ে সমস্ত সাব-অ্যারের মূল্যায়ন সম্পন্ন।",
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

  int _numSubarrayProductLessThanK(List<int> numbers, int kVal) {
    if (kVal <= 1) return 0;
    int l = 0, prod = 1, count = 0;
    for (int r = 0; r < numbers.length; r++) {
      prod *= numbers[r];
      while (prod >= kVal && l <= r) {
        prod ~/= numbers[l++];
      }
      count += (r - l + 1);
    }
    return count;
  }

  void _handlePracticeAction(String actionType) {
    if (_practiceSolved || _practiceRight >= _nums.length) return;

    if (_k <= 1) {
      setState(() {
        _practiceSolved = true;
        _userFeedbackEn = "k <= 1 yields 0 subarrays!";
        _userFeedbackBn = "k <= 1 হলে ০ টি সাব-অ্যারে পাওয়া যায়!";
      });
      return;
    }

    int l = 0, prod = 1, total = 0;
    bool expectedShrink = false;
    bool expectedCount = false;

    for (int r = 0; r <= _practiceRight; r++) {
      prod *= _nums[r];
      while (prod >= _k && l <= r) {
        if (r == _practiceRight) expectedShrink = true;
        prod ~/= _nums[l++];
      }
      if (r == _practiceRight) expectedCount = true;
      total += (r - l + 1);
    }

    String expectedAction = "EXPAND";
    if (expectedShrink) expectedAction = "SHRINK";
    if (expectedCount && !expectedShrink) expectedAction = "COUNT_UPDATED";

    setState(() {
      if (actionType == expectedAction || (actionType == "EXPAND" && expectedAction == "EXPAND")) {
        _practiceLeft = l;
        _practiceTotalCount = total;
        _practiceRight++;

        if (_practiceRight >= _nums.length) {
          _practiceSolved = true;
          _userFeedbackEn = "🏆 MASTERED! You correctly counted contiguous subarrays ending at each pointer! Total = $total!";
          _userFeedbackBn = "🏆 দারুণ! আপনি প্রতিটি ইনডেক্সে শেষ হওয়া সংলগ্ন সাব-অ্যারে সংখ্যা সঠিকভাবে বের করেছেন! সর্বমোট = $total!";
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
          '713. Subarray Product Less Than K',
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
                    "713. Subarray Product Less Than K",
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
              children: ["Meta", "Amazon"].map((company) {
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
                        ? "Given an array of positive integers nums and an integer k, return the number of contiguous subarrays where the product of all the elements in the subarray is strictly less than k."
                        : "ধনাত্মক পূর্ণসংখ্যার একটি অ্যারে nums এবং একটি সংখ্যা k দেওয়া আছে। যে সমস্ত সাব-অ্যারের উপাদানগুলোর গুণফল k এর চেয়ে কম (product < k), এমন সাব-অ্যারের সর্বমোট সংখ্যা নির্ণয় করুন।",
                    style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Examples
            Text(_isEnglish ? "Examples" : "উদাহরণসমূহ", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            _buildExampleCard("Example 1", "nums = [10, 5, 2, 6], k = 100", "Output: 8 (Subarrays: [10], [5], [2], [6], [10, 5], [5, 2], [2, 6], [5, 2, 6])"),
            _buildExampleCard("Example 2", "nums = [1, 2, 3], k = 0", "Output: 0"),
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
                        _isEnglish ? "Key Intuition (Subarray Counting via Ending Pointer)" : "মূল আইডিয়া (এন্ডিং পয়েন্টার দ্বারা সাব-অ্যারে গণনা)",
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isEnglish
                        ? "1. Expand right pointer and multiply currentProduct.\n2. While currentProduct >= k, shrink left (left++) and divide currentProduct /= nums[left].\n3. Every valid window [left..right] contributes (right - left + 1) valid contiguous subarrays ending at index right!\n4. Achieves O(N) linear time complexity and O(1) space complexity!"
                        : "১. ডান পয়েন্টার বাড়ান এবং currentProduct এ গুণফল রাখুন।\n২. currentProduct >= k থাকা পর্যন্ত বাম পয়েন্টার কমিয়ে (left++) গুণফল ভাগ করুন।\n৩. প্রতিটি বৈধ্য উইন্ডো [left..right] ডান ইনডেক্স right এ শেষ হওয়া (right - left + 1) টি বৈধ্য সাব-অ্যারে উপহার দেয়!\n৪. O(N) লিনিয়ার সময় ও O(1) স্পেস কমপ্লেক্সিটি।",
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
              _isEnglish ? "Subarray Product Visual Models" : "সাব-অ্যারে প্রোডাক্ট ভিজ্যুয়াল মডেলসমূহ (কোডহীন গাইড)",
              style: TextStyle(fontSize: Responsive.sp(context, 18), fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 6),
            Text(
              _isEnglish
                  ? "Explore 3 interactive models for nums = [10, 5, 2, 6], k = 100."
                  : "nums = [10, 5, 2, 6], k = 100 এর জন্য ৩টি ইন্টারঅ্যাক্টিভ ভিজ্যুয়াল মডেল পর্যবেক্ষণ করুন।",
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 16),

            // Model Switcher Segmented Control
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildAnimationModelChip(0, _isEnglish ? "1. 🪜 Step Flowcard" : "১. 🪜 স্টেপ-বাই-স্টেপ ফ্লো-কার্ড"),
                  _buildAnimationModelChip(1, _isEnglish ? "2. 📏 Ending Pointer Formula" : "২. 📏 এন্ডিং পয়েন্টার ফর্মুলা"),
                  _buildAnimationModelChip(2, _isEnglish ? "3. 📊 Complexity Calculator" : "৩. 📊 টাইমিং ক্যালকুলেটর"),
                ],
              ),
            ),
            const SizedBox(height: 20),

            if (_animationModelIndex == 0) _buildStepFlowcardModel(),
            if (_animationModelIndex == 1) _buildEndingPointerFormulaModel(),
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
        "window": "[10]",
        "prod": 10,
        "added": 1,
        "total": 1,
        "badge": "🎉 ADDED 1 SUBARRAY",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 1: r = 0 [10] ➔ Prod = 10 < 100! Added 1 ([10]). Total = 1",
        "titleBn": "ধাপ ১: r = 0 [10] ➔ গুণফল = ১০ < ১০০! যুক্ত হলো ১ টি ([10])। সর্বমোট = ১",
        "descEn": "[10] has product 10 < 100.",
        "descBn": "[10] এর গুণফল ১০ < ১০০।",
      },
      {
        "step": 2,
        "window": "[10, 5]",
        "prod": 50,
        "added": 2,
        "total": 3,
        "badge": "🎉 ADDED 2 SUBARRAYS",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 2: r = 1 [10, 5] ➔ Prod = 50 < 100! Added 2 ([5], [10, 5]). Total = 3",
        "titleBn": "ধাপ ২: r = 1 [10, 5] ➔ গুণফল = ৫০ < ১০০! যুক্ত হলো ২ টি ([5], [10, 5])। সর্বমোট = ৩",
        "descEn": "[5] and [10, 5] both have product < 100.",
        "descBn": "[5] এবং [10, 5] উভয় সাব-অ্যারের গুণফল < ১০০।",
      },
      {
        "step": 3,
        "window": "[5, 2]",
        "prod": 10,
        "added": 2,
        "total": 5,
        "badge": "⬅️ SHRINK & ADDED 2",
        "badgeColor": AppTheme.accentAmber,
        "titleEn": "Step 3: r = 2 [10, 5, 2] Prod=100 >= 100! Shrink Left ➔ [5, 2] Added 2! Total = 5",
        "titleBn": "ধাপ ৩: r = 2 [10, 5, 2] গুণফল=১০০ >= ১০০! বাম কমান ➔ [5, 2] যুক্ত হলো ২ টি! সর্বমোট = ৫",
        "descEn": "Shrunk left pointer. Added [2] and [5, 2].",
        "descBn": "বাম পয়েন্টার কমানো হলো। [2] এবং [5, 2] যুক্ত হলো।",
      },
      {
        "step": 4,
        "window": "[5, 2, 6]",
        "prod": 60,
        "added": 3,
        "total": 8,
        "badge": "🎉 ADDED 3 SUBARRAYS",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 4: r = 3 [5, 2, 6] ➔ Prod = 60 < 100! Added 3! Total = 8 🎉",
        "titleBn": "ধাপ ৪: r = 3 [5, 2, 6] ➔ গুণফল = ৬০ < ১০০! যুক্ত হলো ৩ টি! সর্বমোট = ৮ 🎉",
        "descEn": "Added [6], [2, 6], and [5, 2, 6]. Total valid subarrays = 8!",
        "descBn": "[6], [2, 6], এবং [5, 2, 6] যুক্ত হলো। মোট বৈধ্য সাব-অ্যারে = ৮ টি!",
      },
    ];

    final currentStep = stepFlowData[_flowStepIndex.clamp(0, stepFlowData.length - 1)];
    final String window = currentStep["window"] as String;
    final int prodVal = currentStep["prod"] as int;
    final int addedVal = currentStep["added"] as int;
    final int totalVal = currentStep["total"] as int;
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
                _isEnglish ? "1. Step-by-Step Subarray Product Counting Flowcard" : "১. স্টেপ-বাই-স্টেপ সাব-অ্যারে প্রোডাক্ট কাউন্টিং ফ্লো-কার্ড",
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
                ? "Watch right pointer expansion and ending pointer count addition."
                : "ডান পয়েন্টার বিস্তার এবং এন্ডিং পয়েন্টার সাব-অ্যারে যোগ দেখুন।",
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
                    Text("Subarray = $window (Prod = $prodVal)", style: TextStyle(color: badgeColor, fontWeight: FontWeight.bold, fontSize: 12)),
                    Text("Added = +$addedVal", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
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
                    "Total Subarrays Count = $totalVal 🔢",
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

  // MODEL 2: Ending Pointer Formula
  Widget _buildEndingPointerFormulaModel() {
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
            _isEnglish ? "2. Ending Pointer Subarray Count Formula" : "২. এন্ডিং পয়েন্টার সাব-অ্যারে গণনা ফর্মুলা",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            _isEnglish
                ? "Every valid window [left..right] ending at right contains exactly (right - left + 1) valid contiguous subarrays."
                : "right ইনডেক্সে শেষ হওয়া প্রতিটি বৈধ্য উইন্ডো [left..right] ঠিক (right - left + 1) টি সংলগ্ন বৈধ্য সাব-অ্যারে ধারণ করে।",
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
              "count += (right - left + 1); 📏",
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
                ? "Brute force checks product of all O(N^2) subarrays in O(N^2) time.\nSliding Window processes each element at most twice in O(N) time with O(1) space!"
                : "ব্রুট ফোর্স O(N^2) সময়ে সমস্ত সাব-অ্যারের গুণফল পরীক্ষা করে।\nস্লাইডিং উইন্ডো প্রতিটি উপাদানকে সর্বোচ্চ ২ বার প্রসেস করে O(N) টাইম ও O(1) স্পেসে!",
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
                          labelText: _isEnglish ? "Nums Array (e.g. 10, 5, 2, 6)" : "অ্যারে (যেমন 10, 5, 2, 6)",
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
                          labelText: _isEnglish ? "k (Threshold)" : "k (সীমা)",
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
                      _buildPresetChip("10, 5, 2, 6", "100"),
                      _buildPresetChip("1, 2, 3", "0"),
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
                  _buildSubarrayProductCanvas(step),
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildCodeHighlightBox(step.activeLine)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildSubarrayProductCanvas(step)),
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
    final targetTotalCount = _numSubarrayProductLessThanK(_nums, _k);

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
                  ? "Track window expansion and count contiguous subarrays ending at each pointer!"
                  : "প্রতিটি উপাদানের জন্য উইন্ডো প্রসারিত করুন এবং সংলগ্ন সাব-অ্যারে সংখ্যা হিসাব করুন!",
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
                        Text("Total Target Count: $targetTotalCount", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
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
                          icon: const Icon(Icons.plus_one),
                          label: Text(_isEnglish ? "COUNT UPDATED" : "COUNT UPDATED"),
                          onPressed: () => _handlePracticeAction("COUNT_UPDATED"),
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
      "int numSubarrayProductLessThanK(vector<int>& nums, int k) {",
      "    if (k <= 1) return 0;",
      "    int left = 0, product = 1, totalCount = 0;",
      "    for (int right = 0; right < nums.size(); right++) {",
      "        product *= nums[right];",
      "        while (product >= k && left <= right) {",
      "            product /= nums[left++];",
      "        }",
      "        totalCount += (right - left + 1);",
      "    }",
      "    return totalCount;",
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

  Widget _buildSubarrayProductCanvas(SubarrayProductLessThanKStep step) {
    Color decisionColor = AppTheme.accentPurple;
    String decisionLabel = "INIT";

    if (step.decision == "expand") {
      decisionColor = AppTheme.accentNeonCyan;
      decisionLabel = "➡️ EXPAND RIGHT";
    } else if (step.decision == "shrink_left") {
      decisionColor = AppTheme.accentAmber;
      decisionLabel = "⬅️ SHRINK LEFT";
    } else if (step.decision == "count_updated") {
      decisionColor = AppTheme.accentGreen;
      decisionLabel = "🎉 COUNT UPDATED";
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
              Text("Current Prod = ${step.currentProduct} / k=${step.k}", style: TextStyle(color: step.currentProduct < step.k ? AppTheme.accentGreen : AppTheme.accentPink, fontWeight: FontWeight.bold, fontSize: 12)),
              Text("Subarrays Added = +${step.addedCount}", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
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
                  "Total Valid Subarrays = ${step.totalCount} 🔢",
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
                  "Subarray Window: [${step.windowSub.join(', ')}]",
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
    int numSubarrayProductLessThanK(vector<int>& nums, int k) {
        if (k <= 1) return 0;
        int left = 0, product = 1, totalCount = 0;
        for (int right = 0; right < nums.size(); right++) {
            product *= nums[right];
            while (product >= k && left <= right) {
                product /= nums[left++];
            }
            totalCount += (right - left + 1);
        }
        return totalCount;
    }
};""";
    } else if (lang == "Java") {
      code = """
class Solution {
    public int numSubarrayProductLessThanK(int[] nums, int k) {
        if (k <= 1) return 0;
        int left = 0, product = 1, totalCount = 0;
        for (int right = 0; right < nums.length; right++) {
            product *= nums[right];
            while (product >= k && left <= right) {
                product /= nums[left++];
            }
            totalCount += (right - left + 1);
        }
        return totalCount;
    }
}""";
    } else {
      code = """
class Solution:
    def numSubarrayProductLessThanK(self, nums: List[int], k: int) -> int:
        if k <= 1:
            return 0
        left = 0
        product = 1
        total_count = 0

        for right in range(len(nums)):
            product *= nums[right]
            while product >= k and left <= right:
                product //= nums[left]
                left += 1
            total_count += (right - left + 1)

        return total_count""";
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
