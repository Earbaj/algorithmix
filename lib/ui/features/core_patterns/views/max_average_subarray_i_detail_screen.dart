import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class MaxAverageSubarrayIStep {
  final int left;
  final int right;
  final int windowSum;
  final int maxSum;
  final double currentAvg;
  final double maxAvg;
  final List<int> windowElements;
  final String decision; // 'init', 'build_first_window', 'slide_window', 'max_updated', 'finished'
  final int activeLine;
  final String actionEn;
  final String actionBn;
  final String reasonEn;
  final String reasonBn;

  const MaxAverageSubarrayIStep({
    required this.left,
    required this.right,
    required this.windowSum,
    required this.maxSum,
    required this.currentAvg,
    required this.maxAvg,
    required this.windowElements,
    required this.decision,
    required this.activeLine,
    required this.actionEn,
    required this.actionBn,
    required this.reasonEn,
    required this.reasonBn,
  });
}

class MaxAverageSubarrayIDetailScreen extends StatefulWidget {
  const MaxAverageSubarrayIDetailScreen({super.key});

  @override
  State<MaxAverageSubarrayIDetailScreen> createState() => _MaxAverageSubarrayIDetailScreenState();
}

class _MaxAverageSubarrayIDetailScreenState extends State<MaxAverageSubarrayIDetailScreen>
    with SingleTickerProviderStateMixin {
  bool _isEnglish = true;
  late TabController _tabController;

  // Custom Input State
  final TextEditingController _numsController = TextEditingController(text: "1, 12, -5, -6, 50, 3");
  final TextEditingController _kController = TextEditingController(text: "4");
  List<int> _nums = [1, 12, -5, -6, 50, 3];
  int _k = 4;
  List<MaxAverageSubarrayIStep> _steps = [];

  // Playback Control
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  // Code Language Selector
  String _selectedCodeLang = "C++";

  // Tab 2 Animation Model Selector (0: Step Flowcard, 1: Fixed Window Sliding Mechanism, 2: Efficiency Calculator)
  int _animationModelIndex = 0;
  int _flowStepIndex = 0;

  // Practice Mode State
  int _practiceLeft = 0;
  double _userSelectedMaxAvg = 0.0;
  List<double> _practiceUserSubmits = [];
  String _userFeedbackEn = "Slide window across array and find the maximum average of K elements!";
  String _userFeedbackBn = "অ্যারে জুড়ে উইন্ডো স্লাইড করে K টি উপাদানের সর্বোচ্চ গড় বের করুন!";
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
      if (parsed.isEmpty) parsed = [1, 12, -5, -6, 50, 3];
      _nums = parsed;

      int kVal = int.parse(_kController.text.trim());
      if (kVal <= 0) kVal = 1;
      if (kVal > _nums.length) kVal = _nums.length;
      _k = kVal;
    } catch (_) {
      _nums = [1, 12, -5, -6, 50, 3];
      _k = 4;
    }

    _steps = _generateSteps(_nums, _k);

    // Reset practice mode
    _resetPractice();
  }

  void _resetPractice() {
    _practiceLeft = 0;
    _userSelectedMaxAvg = 0.0;
    _practiceUserSubmits = [];
    _practiceSolved = false;
    _userFeedbackEn = "Slide fixed window of size K = $_k and find maximum average!";
    _userFeedbackBn = "K = $_k আকারের স্লাইডিং উইন্ডো চালিয়ে সর্বোচ্চ গড় খুঁজুন!";
  }

  List<MaxAverageSubarrayIStep> _generateSteps(List<int> inputNums, int windowK) {
    List<MaxAverageSubarrayIStep> steps = [];

    // Step 0: Init
    steps.add(MaxAverageSubarrayIStep(
      left: 0,
      right: windowK - 1,
      windowSum: 0,
      maxSum: 0,
      currentAvg: 0.0,
      maxAvg: 0.0,
      windowElements: [],
      decision: "init",
      activeLine: 1,
      actionEn: "Line 1: Initialize Sliding Window for nums = [${inputNums.join(', ')}], K = $windowK.",
      actionBn: "লাইন ১: অ্যাররে nums = [${inputNums.join(', ')}], K = $windowK এর জন্য স্লাইডিং উইন্ডো শুরু।",
      reasonEn: "We maintain a fixed-size window of K elements to find max sum in O(N) time.",
      reasonBn: "O(N) সময়ে সর্বোচ্চ সাম পেতে K উপাদানের ফিক্সড উইন্ডো বজায় রাখা হবে।",
    ));

    // Step 1: Build first window 0 to K-1
    int sum = 0;
    for (int i = 0; i < windowK; i++) {
      sum += inputNums[i];
    }
    int maxSum = sum;
    double currentAvg = sum / windowK;
    double maxAvg = currentAvg;

    steps.add(MaxAverageSubarrayIStep(
      left: 0,
      right: windowK - 1,
      windowSum: sum,
      maxSum: maxSum,
      currentAvg: currentAvg,
      maxAvg: maxAvg,
      windowElements: inputNums.sublist(0, windowK),
      decision: "build_first_window",
      activeLine: 3,
      actionEn: "🪟 Line 3: Build first window [0..${windowK - 1}] ➔ Window Sum = $sum, Average = ${currentAvg.toStringAsFixed(4)}.",
      actionBn: "🪟 লাইন ৩: প্রথম উইন্ডো [0..${windowK - 1}] তৈরি ➔ Window Sum = $sum, গড় = ${currentAvg.toStringAsFixed(4)}।",
      reasonEn: "Sum of first K elements forms the baseline window sum.",
      reasonBn: "প্রথম K উপাদানের যোগফল থেকে প্রাথমিক উইন্ডো সাম তৈরি হয়।",
    ));

    // Step 2: Slide window right
    for (int r = windowK; r < inputNums.length; r++) {
      int l = r - windowK + 1;
      int oldSum = sum;
      int addVal = inputNums[r];
      int subVal = inputNums[l - 1];

      sum = sum + addVal - subVal;
      currentAvg = sum / windowK;
      bool isUpdated = sum > maxSum;

      if (isUpdated) {
        maxSum = sum;
        maxAvg = currentAvg;
      }

      steps.add(MaxAverageSubarrayIStep(
        left: l,
        right: r,
        windowSum: sum,
        maxSum: maxSum,
        currentAvg: currentAvg,
        maxAvg: maxAvg,
        windowElements: inputNums.sublist(l, r + 1),
        decision: isUpdated ? "max_updated" : "slide_window",
        activeLine: isUpdated ? 7 : 6,
        actionEn: isUpdated
            ? "🎉 Line 7: Slide Window [${l}..${r}] ➔ Added $addVal, Subtracted $subVal. NEW Max Sum = $sum, Max Average = ${maxAvg.toStringAsFixed(4)}!"
            : "➡️ Line 6: Slide Window [${l}..${r}] ➔ Added $addVal, Subtracted $subVal. Window Sum = $sum (Avg = ${currentAvg.toStringAsFixed(4)}).",
        actionBn: isUpdated
            ? "🎉 লাইন ৭: উইন্ডো স্লাইড [${l}..${r}] ➔ যোগ $addVal, বিয়োগ $subVal। নতুন Max Sum = $sum, Max Average = ${maxAvg.toStringAsFixed(4)}!"
            : "➡️ লাইন ৬: উইন্ডো স্লাইড [${l}..${r}] ➔ যোগ $addVal, বিয়োগ $subVal। Window Sum = $sum (Avg = ${currentAvg.toStringAsFixed(4)})।",
        reasonEn: isUpdated
            ? "New window sum $sum exceeds previous max sum. Update max average!"
            : "Window sum $sum is <= max sum $maxSum. Keep current max average.",
        reasonBn: isUpdated
            ? "নতুন উইন্ডো সাম $sum পূর্বের ম্যাক্স সাম ছাড়িয়ে গেছে। সর্বোচ্চ গড় আপডেট করুন!"
            : "উইন্ডো সাম $sum বর্তমান ম্যাক্স সাম $maxSum এর সমান বা কম।",
      ));
    }

    // Final Step
    steps.add(MaxAverageSubarrayIStep(
      left: inputNums.length - windowK,
      right: inputNums.length - 1,
      windowSum: sum,
      maxSum: maxSum,
      currentAvg: currentAvg,
      maxAvg: maxAvg,
      windowElements: inputNums.sublist(inputNums.length - windowK),
      decision: "finished",
      activeLine: 9,
      actionEn: "🏁 Line 9: Sliding Window Complete! Maximum Average = ${maxAvg.toStringAsFixed(5)}.",
      actionBn: "🏁 লাইন ৯: স্লাইডিং উইন্ডো সম্পূর্ণ! সর্বোচ্চ গড় = ${maxAvg.toStringAsFixed(5)}।",
      reasonEn: "All contiguous subarrays of length K evaluated in O(N) linear time.",
      reasonBn: "O(N) লিনিয়ার সময়ে K দৈর্ঘ্যের সমস্ত কন্টিনিউয়াস সাব-অ্যালাই মূল্যায়ন সম্পন্ন।",
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

  double _calculateMaxAverage(List<int> inputNums, int kVal) {
    int sum = 0;
    for (int i = 0; i < kVal; i++) {
      sum += inputNums[i];
    }
    int maxSum = sum;
    for (int i = kVal; i < inputNums.length; i++) {
      sum += inputNums[i] - inputNums[i - kVal];
      if (sum > maxSum) maxSum = sum;
    }
    return maxSum / kVal;
  }

  void _handlePracticeSlide(int direction) {
    if (_practiceSolved) return;
    final maxTargetAvg = _calculateMaxAverage(_nums, _k);

    setState(() {
      if (direction > 0 && _practiceLeft + _k < _nums.length) {
        _practiceLeft++;
      } else if (direction < 0 && _practiceLeft > 0) {
        _practiceLeft--;
      }

      int sum = 0;
      for (int i = _practiceLeft; i < _practiceLeft + _k; i++) {
        sum += _nums[i];
      }
      double currentAvg = sum / _k;

      if ((currentAvg - maxTargetAvg).abs() < 1e-5) {
        _practiceSolved = true;
        _userFeedbackEn = "🏆 MASTERED! You found the optimal window [${_practiceLeft}..${_practiceLeft + _k - 1}] with Max Average = ${currentAvg.toStringAsFixed(4)}!";
        _userFeedbackBn = "🏆 দারুণ! আপনি সেরা উইন্ডো [${_practiceLeft}..${_practiceLeft + _k - 1}] নির্বাচন করে সর্বোচ্চ গড় ${currentAvg.toStringAsFixed(4)} খুঁজে পেয়েছেন!";
      } else {
        _userFeedbackEn = "Window [${_practiceLeft}..${_practiceLeft + _k - 1}] Avg = ${currentAvg.toStringAsFixed(4)}. Slide window further to find maximum average!";
        _userFeedbackBn = "উইন্ডো [${_practiceLeft}..${_practiceLeft + _k - 1}] গড় = ${currentAvg.toStringAsFixed(4)}। সর্বোচ্চ গড় পেতে উইন্ডো স্লাইড করুন!";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final hPadding = Responsive.horizontalPadding(context);

    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      appBar: AppBar(
        title: Text(
          '643. Maximum Average Subarray I',
          style: TextStyle(fontSize: Responsive.sp(context, 18), fontWeight: FontWeight.bold),
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
                    "643. Maximum Average Subarray I",
                    style: TextStyle(fontSize: Responsive.sp(context, 22), fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.accentGreen.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.accentGreen),
                  ),
                  child: const Text("Easy", style: TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 12)),
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
                        ? "You are given an integer array nums consisting of n elements, and an integer k. Find a contiguous subarray whose length is equal to k that has the maximum average value and return this value. Any answer with a calculation error less than 10^-5 will be accepted."
                        : "একটি পূর্ণসংখ্যার অ্যাররে nums এবং একটি পূর্ণসংখ্যা k দেওয়া আছে। k দৈর্ঘ্যের এমন একটি কন্টিনিউয়াস সাব-অ্যারে খুঁজুন যার গড় মান (Average) সর্বোচ্চ এবং সেই মানটি রিটার্ন করুন।",
                    style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Examples
            Text(_isEnglish ? "Examples" : "উদাহরণসমূহ", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            _buildExampleCard("Example 1", "nums = [1,12,-5,-6,50,3], k = 4", "Output: 12.75000 (Subarray [12, -5, -6, 50], sum = 51)"),
            _buildExampleCard("Example 2", "nums = [5], k = 1", "Output: 5.00000"),
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
                        _isEnglish ? "Key Intuition (Fixed Size K Sliding Window)" : "মূল আইডিয়া (ফিক্সড সাইজ K স্লাইডিং উইন্ডো)",
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isEnglish
                        ? "1. Calculate sum of first K elements as baseline window sum.\n2. Slide window from i = K to N-1: windowSum += nums[i] - nums[i - K].\n3. Track maximum sum found and return (double) maxSum / K in O(N) time."
                        : "১. প্রথম K উপাদানের যোগফলকে প্রাথমিক উইন্ডো সাম হিসেব করুন।\n২. i = K থেকে N-1 পর্যন্ত স্লাইড করুন: windowSum += nums[i] - nums[i - K]।\n৩. সর্বোচ্চ সাম ট্র্যাক করে O(N) টাইমে (double) maxSum / K রিটার্ন করুন।",
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
              _isEnglish ? "Max Average Subarray Visual Models" : "ম্যাক্স এভারেজ সাব-অ্যারে ভিজ্যুয়াল মডেলসমূহ (কোডহীন গাইড)",
              style: TextStyle(fontSize: Responsive.sp(context, 18), fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 6),
            Text(
              _isEnglish
                  ? "Explore 3 interactive models for nums = [1, 12, -5, -6, 50, 3], K = 4."
                  : "nums = [1, 12, -5, -6, 50, 3], K = 4 এর জন্য ৩টি ইন্টারঅ্যাক্টিভ ভিজ্যুয়াল মডেল পর্যবেক্ষণ করুন।",
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 16),

            // Model Switcher Segmented Control
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildAnimationModelChip(0, _isEnglish ? "1. 🪜 Step Flowcard" : "১. 🪜 স্টেপ-বাই-স্টেপ ফ্লো-কার্ড"),
                  _buildAnimationModelChip(1, _isEnglish ? "2. 🪟 Sliding Mechanism" : "২. 🪟 স্লাইডিং মেকানিজম"),
                  _buildAnimationModelChip(2, _isEnglish ? "3. 📊 O(N*K) vs O(N) Calculator" : "৩. 📊 O(N*K) বনাম O(N) ক্যালকুলেটর"),
                ],
              ),
            ),
            const SizedBox(height: 20),

            if (_animationModelIndex == 0) _buildStepFlowcardModel(),
            if (_animationModelIndex == 1) _buildSlidingMechanismModel(),
            if (_animationModelIndex == 2) _buildEfficiencyCalculatorModel(),

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

  // MODEL 1: Step-by-Step Fixed Window Flowcard Engine
  Widget _buildStepFlowcardModel() {
    final stepFlowData = [
      {
        "step": 1,
        "window": "[1, 12, -5, -6]",
        "sum": 2,
        "avg": 0.5,
        "badge": "🪟 FIRST WINDOW",
        "badgeColor": AppTheme.accentNeonCyan,
        "titleEn": "Step 1: First Window [0..3] = [1, 12, -5, -6]",
        "titleBn": "ধাপ ১: প্রথম উইন্ডো [0..3] = [1, 12, -5, -6]",
        "descEn": "Sum = 1 + 12 - 5 - 6 = 2. Baseline Avg = 0.5.",
        "descBn": "যোগফল = 1 + 12 - 5 - 6 = 2। প্রাথমিক গড় = 0.5।",
      },
      {
        "step": 2,
        "window": "[12, -5, -6, 50]",
        "sum": 51,
        "avg": 12.75,
        "badge": "🎉 MAX AVG UPDATED",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 2: Slide Right (+50, -1) ➔ Window [1..4] = [12, -5, -6, 50]",
        "titleBn": "ধাপ ২: ডানে স্লাইড (+50, -1) ➔ উইন্ডো [1..4] = [12, -5, -6, 50]",
        "descEn": "Sum = 2 + 50 - 1 = 51. NEW Max Avg = 51 / 4 = 12.75! 🎉",
        "descBn": "যোগফল = 2 + 50 - 1 = 51। নতুন সর্বোচ্চ গড় = 51 / 4 = 12.75! 🎉",
      },
      {
        "step": 3,
        "window": "[-5, -6, 50, 3]",
        "sum": 42,
        "avg": 10.5,
        "badge": "➡️ SLIDE RIGHT",
        "badgeColor": AppTheme.accentAmber,
        "titleEn": "Step 3: Slide Right (+3, -12) ➔ Window [2..5] = [-5, -6, 50, 3]",
        "titleBn": "ধাপ ৩: ডানে স্লাইড (+3, -12) ➔ উইন্ডো [2..5] = [-5, -6, 50, 3]",
        "descEn": "Sum = 51 + 3 - 12 = 42. Avg = 10.5 (Keep Max Avg 12.75).",
        "descBn": "যোগফল = 51 + 3 - 12 = 42। গড় = 10.5 (সর্বোচ্চ গড় 12.75 থাকবে)।",
      },
      {
        "step": 4,
        "window": "[12, -5, -6, 50]",
        "sum": 51,
        "avg": 12.75,
        "badge": "🏁 COMPLETE",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 4: All Windows Evaluated! Max Average = 12.75000",
        "titleBn": "ধাপ ৪: সমস্ত উইন্ডো মূল্যায়ন সম্পন্ন! সর্বোচ্চ গড় = 12.75000",
        "descEn": "O(N) Sliding Window search complete!",
        "descBn": "O(N) স্লাইডিং উইন্ডো অনুসন্ধান সম্পন্ন!",
      },
    ];

    final currentStep = stepFlowData[_flowStepIndex.clamp(0, stepFlowData.length - 1)];
    final String window = currentStep["window"] as String;
    final int sum = currentStep["sum"] as int;
    final double avg = (currentStep["avg"] as num).toDouble();
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
                _isEnglish ? "1. Step-by-Step Fixed Window Flowcard" : "১. স্টেপ-বাই-স্টেপ ফিক্সড উইন্ডো ফ্লো-কার্ড",
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
                ? "Watch fixed window sum updates and maximum average tracking."
                : "ফিক্সড উইন্ডো সাম আপডেট এবং সর্বোচ্চ গড় ট্র্যাকিং দেখুন।",
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
                    Text("Window Sum = $sum", style: TextStyle(color: badgeColor, fontWeight: FontWeight.bold, fontSize: 12)),
                    Text("Avg = ${avg.toStringAsFixed(2)}", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
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
                    window,
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

  // MODEL 2: Sliding Mechanism
  Widget _buildSlidingMechanismModel() {
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
            _isEnglish ? "2. Fixed Window Sliding Formula" : "২. ফিক্সড উইন্ডো স্লাইডিং সূত্র",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            _isEnglish
                ? "When sliding window 1 step to right:\nnewSum = oldSum + nums[right] - nums[left - 1]"
                : "উইন্ডো ১ ঘর ডানে স্লাইড করার সময়:\nnewSum = oldSum + nums[right] - nums[left - 1]",
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
              "windowSum += nums[i] - nums[i - K]; 🪟",
              style: TextStyle(fontFamily: 'monospace', fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.accentGreen),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  // MODEL 3: Efficiency Calculator
  Widget _buildEfficiencyCalculatorModel() {
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
            _isEnglish ? "3. O(N*K) Brute Force vs O(N) Sliding Window" : "৩. O(N*K) ব্রুট ফোর্স বনাম O(N) স্লাইডিং উইন্ডো",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            _isEnglish
                ? "Brute Force re-calculates sum of K elements at each index ➔ O(N * K).\nSliding Window reuses previous sum in O(1) per step ➔ O(N) total."
                : "ব্রুট ফোর্স প্রতি ঘরে K উপাদানের যোগফল নতুন করে বের করে ➔ O(N * K)।\nস্লাইডিং উইন্ডো আগের সাম ব্যবহার করে O(1) এ উত্তর দেয় ➔ সর্বমোট O(N)।",
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
                          labelText: _isEnglish ? "Nums (e.g. 1, 12, -5, -6, 50, 3)" : "অ্যাররে (যেমন 1, 12, -5, -6, 50, 3)",
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
                          labelText: _isEnglish ? "K" : "K",
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
                      _buildPresetChip("1, 12, -5, -6, 50, 3", "4"),
                      _buildPresetChip("5", "1"),
                      _buildPresetChip("0, 4, 0, 3, 2", "2"),
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
                  _buildWindowCanvas(step),
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildCodeHighlightBox(step.activeLine)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildWindowCanvas(step)),
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
    final maxTargetAvg = _calculateMaxAverage(_nums, _k);

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
                  ? "Slide the fixed window K = $_k left and right to discover the maximum average subarray!"
                  : "K = $_k আকারের ফিক্সড উইন্ডো ডানে-বামে স্লাইড করে সর্বোচ্চ গড় সাব-অ্যারে খুঁজে বের করুন!",
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

            // Interactive Array with Sliding Window Frame
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
                decoration: BoxDecoration(
                  color: const Color(0xFF090D16),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTheme.accentPurple),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(_nums.length, (idx) {
                      bool inWindow = idx >= _practiceLeft && idx < _practiceLeft + _k;

                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: inWindow ? AppTheme.accentNeonCyan.withOpacity(0.3) : AppTheme.surfaceDark,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: inWindow ? AppTheme.accentNeonCyan : const Color(0xFF334155),
                            width: inWindow ? 2.0 : 1.0,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              "${_nums[idx]}",
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: inWindow ? Colors.white : AppTheme.textMuted,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "[$idx]",
                              style: const TextStyle(fontSize: 10, color: Color(0xFF64748B)),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Slide Control Buttons (Left / Right)
            if (!_practiceSolved)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.surfaceDark,
                      foregroundColor: AppTheme.accentNeonCyan,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    icon: const Icon(Icons.arrow_back),
                    label: Text(_isEnglish ? "Slide Left" : "বামে স্লাইড"),
                    onPressed: _practiceLeft > 0 ? () => _handlePracticeSlide(-1) : null,
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accentNeonCyan,
                      foregroundColor: AppTheme.primaryDark,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    icon: const Icon(Icons.arrow_forward),
                    label: Text(_isEnglish ? "Slide Right" : "ডানে স্লাইড"),
                    onPressed: _practiceLeft + _k < _nums.length ? () => _handlePracticeSlide(1) : null,
                  ),
                ],
              ),

            const SizedBox(height: 12),
            if (_practiceLeft > 0 || _practiceSolved)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  icon: const Icon(Icons.undo, size: 16, color: AppTheme.accentAmber),
                  label: Text(_isEnglish ? "Reset Window" : "উইন্ডো রিসেট", style: const TextStyle(color: AppTheme.accentAmber, fontSize: 12)),
                  onPressed: _undoPracticeMove,
                ),
              ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _undoPracticeMove() {
    setState(() {
      _resetPractice();
      _userFeedbackEn = "↩️ Reset window position.";
      _userFeedbackBn = "↩️ উইন্ডো অবস্থান রিসেট করা হলো।";
    });
  }

  // Helper Widgets
  Widget _buildPresetChip(String numVal, String kVal) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ActionChip(
        backgroundColor: const Color(0xFF090D16),
        label: Text("[$numVal], K=$kVal", style: const TextStyle(color: AppTheme.accentNeonCyan, fontSize: 11)),
        onPressed: () {
          _numsController.text = numVal;
          _kController.text = kVal;
          _rebuildSteps();
        },
      ),
    );
  }

  Widget _buildCodeHighlightBox(int activeLine) {
    final codeLines = [
      "double findMaxAverage(vector<int>& nums, int k) {",
      "    int windowSum = 0;",
      "    for (int i = 0; i < k; i++) windowSum += nums[i];",
      "    int maxSum = windowSum;",
      "    for (int i = k; i < nums.size(); i++) {",
      "        windowSum += nums[i] - nums[i - k];",
      "        if (windowSum > maxSum) maxSum = windowSum;",
      "    }",
      "    return (double)maxSum / k;",
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

  Widget _buildWindowCanvas(MaxAverageSubarrayIStep step) {
    Color decisionColor = AppTheme.accentPurple;
    String decisionLabel = "INIT";

    if (step.decision == "build_first_window") {
      decisionColor = AppTheme.accentNeonCyan;
      decisionLabel = "🪟 FIRST WINDOW";
    } else if (step.decision == "slide_window") {
      decisionColor = AppTheme.accentAmber;
      decisionLabel = "➡️ SLIDE RIGHT";
    } else if (step.decision == "max_updated") {
      decisionColor = AppTheme.accentGreen;
      decisionLabel = "🎉 MAX UPDATED";
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
              Text("Window: [${step.left}..${step.right}] (K = $_k)", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13)),
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

          // Window Sum & Average Meter
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Window Sum = ${step.windowSum}", style: TextStyle(color: decisionColor, fontWeight: FontWeight.bold, fontSize: 12)),
              Text("Current Avg = ${step.currentAvg.toStringAsFixed(2)}", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
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
                  "Max Average = ${step.maxAvg.toStringAsFixed(5)}",
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
                  "Subarray: [${step.windowElements.join(', ')}]",
                  style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Visual Array Canvas
          const Text("Live Sliding Window Array Canvas:", style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_nums.length, (idx) {
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
    double findMaxAverage(vector<int>& nums, int k) {
        int windowSum = 0;
        for (int i = 0; i < k; i++) {
            windowSum += nums[i];
        }
        int maxSum = windowSum;
        for (int i = k; i < nums.size(); i++) {
            windowSum += nums[i] - nums[i - k];
            if (windowSum > maxSum) maxSum = windowSum;
        }
        return (double)maxSum / k;
    }
};""";
    } else if (lang == "Java") {
      code = """
class Solution {
    public double findMaxAverage(int[] nums, int k) {
        int windowSum = 0;
        for (int i = 0; i < k; i++) {
            windowSum += nums[i];
        }
        int maxSum = windowSum;
        for (int i = k; i < nums.length; i++) {
            windowSum += nums[i] - nums[i - k];
            if (windowSum > maxSum) maxSum = windowSum;
        }
        return (double) maxSum / k;
    }
}""";
    } else {
      code = """
class Solution:
    def findMaxAverage(self, nums: List[int], k: int) -> float:
        window_sum = sum(nums[:k])
        max_sum = window_sum

        for i in range(k, len(nums)):
            window_sum += nums[i] - nums[i - k]
            if window_sum > max_sum:
                max_sum = window_sum

        return max_sum / k""";
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
