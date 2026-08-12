import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class GrumpyBookstoreStep {
  final int left;
  final int right;
  final int baseSatisfied;
  final int currentWindowGain;
  final int maxGain;
  final int totalSatisfied;
  final String decision; // 'init', 'calc_base', 'build_first_window', 'slide_window', 'max_updated', 'finished'
  final int activeLine;
  final String actionEn;
  final String actionBn;
  final String reasonEn;
  final String reasonBn;

  const GrumpyBookstoreStep({
    required this.left,
    required this.right,
    required this.baseSatisfied,
    required this.currentWindowGain,
    required this.maxGain,
    required this.totalSatisfied,
    required this.decision,
    required this.activeLine,
    required this.actionEn,
    required this.actionBn,
    required this.reasonEn,
    required this.reasonBn,
  });
}

class GrumpyBookstoreOwnerDetailScreen extends StatefulWidget {
  const GrumpyBookstoreOwnerDetailScreen({super.key});

  @override
  State<GrumpyBookstoreOwnerDetailScreen> createState() => _GrumpyBookstoreOwnerDetailScreenState();
}

class _GrumpyBookstoreOwnerDetailScreenState extends State<GrumpyBookstoreOwnerDetailScreen>
    with SingleTickerProviderStateMixin {
  bool _isEnglish = true;
  late TabController _tabController;

  // Custom Input State
  final TextEditingController _customersController = TextEditingController(text: "1, 0, 1, 2, 1, 1, 7, 5");
  final TextEditingController _grumpyController = TextEditingController(text: "0, 1, 0, 1, 0, 1, 0, 1");
  final TextEditingController _minutesController = TextEditingController(text: "3");

  List<int> _customers = [1, 0, 1, 2, 1, 1, 7, 5];
  List<int> _grumpy = [0, 1, 0, 1, 0, 1, 0, 1];
  int _minutes = 3;
  List<GrumpyBookstoreStep> _steps = [];

  // Playback Control
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  // Code Language Selector
  String _selectedCodeLang = "C++";

  // Tab 2 Animation Model Selector (0: Step Flowcard, 1: Grumpy Filter Rule, 2: Complexity Calculator)
  int _animationModelIndex = 0;
  int _flowStepIndex = 0;

  // Practice Mode State
  int _practiceLeft = 0;
  String _userFeedbackEn = "Slide secret technique window of size X minutes to maximize satisfied customers!";
  String _userFeedbackBn = "সর্বোচ্চ সন্তুষ্ট কাস্টমার পেতে X মিনিটের উইন্ডো ডানে-বামে স্লাইড করুন!";
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
    _customersController.dispose();
    _grumpyController.dispose();
    _minutesController.dispose();
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
      List<int> cust = _customersController.text
          .split(',')
          .map((e) => int.parse(e.trim()))
          .toList();
      List<int> grump = _grumpyController.text
          .split(',')
          .map((e) => int.parse(e.trim()))
          .toList();
      int minVal = int.parse(_minutesController.text.trim());

      if (cust.isEmpty) cust = [1, 0, 1, 2, 1, 1, 7, 5];
      if (grump.length != cust.length) {
        grump = List.filled(cust.length, 0);
      }
      if (minVal <= 0) minVal = 1;
      if (minVal > cust.length) minVal = cust.length;

      _customers = cust;
      _grumpy = grump;
      _minutes = minVal;
    } catch (_) {
      _customers = [1, 0, 1, 2, 1, 1, 7, 5];
      _grumpy = [0, 1, 0, 1, 0, 1, 0, 1];
      _minutes = 3;
    }

    _steps = _generateSteps(_customers, _grumpy, _minutes);

    // Reset practice mode
    _resetPractice();
  }

  void _resetPractice() {
    _practiceLeft = 0;
    _practiceSolved = false;
    _userFeedbackEn = "Slide secret technique window of size X = $_minutes minutes to maximize total satisfied customers!";
    _userFeedbackBn = "সর্বোচ্চ মোট সন্তুষ্ট কাস্টমার পেতে X = $_minutes মিনিটের উইন্ডো স্লাইড করুন!";
  }

  List<GrumpyBookstoreStep> _generateSteps(List<int> cust, List<int> grump, int minVal) {
    List<GrumpyBookstoreStep> steps = [];
    int n = cust.length;

    // Step 0: Init
    steps.add(GrumpyBookstoreStep(
      left: 0,
      right: minVal - 1,
      baseSatisfied: 0,
      currentWindowGain: 0,
      maxGain: 0,
      totalSatisfied: 0,
      decision: "init",
      activeLine: 1,
      actionEn: "Line 1: Initialize Bookstore Owner Sliding Window for minutes = $minVal.",
      actionBn: "লাইন ১: $minVal মিনিটের জন্য বুকস্টোর ওনার স্লাইডিং উইন্ডো শুরু।",
      reasonEn: "We calculate base satisfied customers and find the window of size $minVal that maximizes extra gain.",
      reasonBn: "আমরা স্বাভাবিক সন্তুষ্ট কাস্টমার হিসাব করব এবং $minVal সাইজের উইন্ডোতে সর্বোচ্চ বাড়তি কাস্টমার লাভ খুঁজব।",
    ));

    // Calculate base satisfied
    int baseSatisfied = 0;
    for (int i = 0; i < n; i++) {
      if (grump[i] == 0) baseSatisfied += cust[i];
    }

    steps.add(GrumpyBookstoreStep(
      left: 0,
      right: minVal - 1,
      baseSatisfied: baseSatisfied,
      currentWindowGain: 0,
      maxGain: 0,
      totalSatisfied: baseSatisfied,
      decision: "calc_base",
      activeLine: 3,
      actionEn: "😊 Line 3: Calculated naturally satisfied customers (grumpy == 0) ➔ Base Satisfied = $baseSatisfied.",
      actionBn: "😊 লাইন ৩: স্বাভাবিকভাবে সন্তুষ্ট কাস্টমার (grumpy == 0) গণনা ➔ Base Satisfied = $baseSatisfied।",
      reasonEn: "Customers when owner is not grumpy are always satisfied regardless of secret technique.",
      reasonBn: "মালিক খিটখিটে না থাকলে কাস্টমাররা কৌশল ছাড়াও সবসময় সন্তুষ্ট থাকেন।",
    ));

    // First window 0..minVal-1
    int currentGain = 0;
    for (int i = 0; i < minVal; i++) {
      if (grump[i] == 1) currentGain += cust[i];
    }
    int maxGain = currentGain;

    steps.add(GrumpyBookstoreStep(
      left: 0,
      right: minVal - 1,
      baseSatisfied: baseSatisfied,
      currentWindowGain: currentGain,
      maxGain: maxGain,
      totalSatisfied: baseSatisfied + maxGain,
      decision: "build_first_window",
      activeLine: 6,
      actionEn: "🪟 Line 6: Build first technique window [0..${minVal - 1}] ➔ Additional Gain = $currentGain, Total = ${baseSatisfied + maxGain}.",
      actionBn: "🪟 লাইন ৬: প্রথম টেকনিক উইন্ডো [0..${minVal - 1}] তৈরি ➔ বাড়তি লাভ = $currentGain, সর্বমোট = ${baseSatisfied + maxGain}।",
      reasonEn: "Gain of converting grumpy minutes to non-grumpy in first window.",
      reasonBn: "প্রথম উইন্ডোতে খিটখিটে মিনিটগুলোকে শান্ত ব্লকে রূপান্তরের বাড়তি লাভ।",
    ));

    // Slide window right
    for (int r = minVal; r < n; r++) {
      int l = r - minVal + 1;

      if (grump[r] == 1) currentGain += cust[r];
      if (grump[l - 1] == 1) currentGain -= cust[l - 1];

      bool isUpdated = currentGain > maxGain;
      if (isUpdated) maxGain = currentGain;

      steps.add(GrumpyBookstoreStep(
        left: l,
        right: r,
        baseSatisfied: baseSatisfied,
        currentWindowGain: currentGain,
        maxGain: maxGain,
        totalSatisfied: baseSatisfied + maxGain,
        decision: isUpdated ? "max_updated" : "slide_window",
        activeLine: isUpdated ? 10 : 8,
        actionEn: isUpdated
            ? "🎉 Line 10: Slide Window [${l}..${r}] ➔ NEW Max Gain = $maxGain! NEW Total Satisfied = ${baseSatisfied + maxGain}!"
            : "➡️ Line 8: Slide Window [${l}..${r}] ➔ Gain = $currentGain (Max Gain = $maxGain, Total = ${baseSatisfied + maxGain}).",
        actionBn: isUpdated
            ? "🎉 লাইন ১০: উইন্ডো স্লাইড [${l}..${r}] ➔ নতুন Max Gain = $maxGain! নতুন মোট সন্তুষ্ট = ${baseSatisfied + maxGain}!"
            : "➡️ লাইন ৮: উইন্ডো স্লাইড [${l}..${r}] ➔ লাভ = $currentGain (Max Gain = $maxGain, মোট = ${baseSatisfied + maxGain})।",
        reasonEn: isUpdated
            ? "Current technique window gain $currentGain exceeds previous max gain. Update maxGain!"
            : "Current technique gain $currentGain is <= maxGain $maxGain.",
        reasonBn: isUpdated
            ? "বর্তমান উইন্ডো টেকনিকের লাভ $currentGain পূর্বের সর্বোচ্চ লাভ ছাড়িয়ে গেছে। maxGain আপডেট করুন!"
            : "বর্তমান উইন্ডো টেকনিকের লাভ $currentGain সর্বোচ্চ লাভ $maxGain এর চেয়ে বড় নয়।",
      ));
    }

    steps.add(GrumpyBookstoreStep(
      left: n - minVal,
      right: n - 1,
      baseSatisfied: baseSatisfied,
      currentWindowGain: currentGain,
      maxGain: maxGain,
      totalSatisfied: baseSatisfied + maxGain,
      decision: "finished",
      activeLine: 12,
      actionEn: "🏁 Line 12: Traversal Complete! Maximum Satisfied Customers = ${baseSatisfied + maxGain} (Base $baseSatisfied + Gain $maxGain).",
      actionBn: "🏁 লাইন ১২: স্ক্যান সম্পূর্ণ! সর্বোচ্চ সন্তুষ্ট কাস্টমার = ${baseSatisfied + maxGain} (মুল $baseSatisfied + লাভ $maxGain)।",
      reasonEn: "All technique windows of size $minVal evaluated in O(N) linear time.",
      reasonBn: "O(N) লিনিয়ার সময়ে $minVal সাইজের সমস্ত টেকনিক উইন্ডো মূল্যায়ন সম্পন্ন।",
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

  int _maxSatisfied(List<int> cust, List<int> grump, int minVal) {
    int base = 0;
    int n = cust.length;
    for (int i = 0; i < n; i++) {
      if (grump[i] == 0) base += cust[i];
    }

    int gain = 0;
    for (int i = 0; i < minVal; i++) {
      if (grump[i] == 1) gain += cust[i];
    }
    int maxG = gain;

    for (int i = minVal; i < n; i++) {
      if (grump[i] == 1) gain += cust[i];
      if (grump[i - minVal] == 1) gain -= cust[i - minVal];
      if (gain > maxG) maxG = gain;
    }
    return base + maxG;
  }

  void _handlePracticeSlide(int direction) {
    if (_practiceSolved) return;
    final maxTotalTarget = _maxSatisfied(_customers, _grumpy, _minutes);

    int base = 0;
    for (int i = 0; i < _customers.length; i++) {
      if (_grumpy[i] == 0) base += _customers[i];
    }

    setState(() {
      if (direction > 0 && _practiceLeft + _minutes < _customers.length) {
        _practiceLeft++;
      } else if (direction < 0 && _practiceLeft > 0) {
        _practiceLeft--;
      }

      int gain = 0;
      for (int i = _practiceLeft; i < _practiceLeft + _minutes; i++) {
        if (_grumpy[i] == 1) gain += _customers[i];
      }
      int total = base + gain;

      if (total == maxTotalTarget) {
        _practiceSolved = true;
        _userFeedbackEn = "🏆 MASTERED! You placed the secret technique window at [${_practiceLeft}..${_practiceLeft + _minutes - 1}] to reach Maximum Satisfied Customers = $total!";
        _userFeedbackBn = "🏆 দারুণ! আপনি ইনডেক্স [${_practiceLeft}..${_practiceLeft + _minutes - 1}] এ টেকনিক উইন্ডো বসিয়ে সর্বোচ্চ সন্তুষ্ট কাস্টমার $total অর্জনে সফল হয়েছেন!";
      } else {
        _userFeedbackEn = "Technique window [${_practiceLeft}..${_practiceLeft + _minutes - 1}] gives Total Satisfied = $total. Slide window to reach maximum target ($maxTotalTarget)!";
        _userFeedbackBn = "টেকনিক উইন্ডো [${_practiceLeft}..${_practiceLeft + _minutes - 1}] মোট সন্তুষ্ট = $total দেয়। সর্বোচ্চ লক্ষ্যমাত্রায় ($maxTotalTarget) পৌঁছাতে উইন্ডো স্লাইড করুন!";
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
          '1052. Grumpy Bookstore Owner',
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
                    "1052. Grumpy Bookstore Owner",
                    style: TextStyle(fontSize: Responsive.sp(context, 22), fontWeight: FontWeight.bold, color: Colors.white),
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
                        ? "There is a bookstore owner that has a store open for n minutes. Every minute, customers[i] enter. If grumpy[i] == 1, owner is grumpy and customers are unsatisfied. The owner can use a secret technique to not be grumpy for minutes consecutive minutes. Return the maximum number of satisfied customers throughout the day."
                        : "একটি বইয়ের দোকানের মালিক n মিনিটের জন্য দোকান খোলা রাখে। প্রতি মিনিটে customers[i] কাস্টমার আসে। grumpy[i] == 1 হলে মালিক খিটখিটে থাকেন এবং কাস্টমাররা অসন্তুষ্ট হয়। মালিক minutes পর পর মিনিটের জন্য খিটখিটে না থাকার কৌশল প্রয়োগ করতে পারেন। সারাদিনে সর্বোচ্চ কতজন কাস্টমারকে সন্তুষ্ট করা সম্ভব তা বের করুন।",
                    style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Examples
            Text(_isEnglish ? "Examples" : "উদাহরণসমূহ", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            _buildExampleCard("Example 1", "customers = [1,0,1,2,1,1,7,5], grumpy = [0,1,0,1,0,1,0,1], minutes = 3", "Output: 16 (Base = 10, Max Gain = 6 at window [5..7])"),
            _buildExampleCard("Example 2", "customers = [1], grumpy = [0], minutes = 1", "Output: 1"),
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
                        _isEnglish ? "Key Intuition (Fixed Window Additional Gain Maximizer)" : "মূল আইডিয়া (ফিক্সড উইন্ডো বাড়তি লাভ ম্যাক্সিমাইজার)",
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isEnglish
                        ? "1. Base satisfied customers = sum of customers[i] where grumpy[i] == 0 (always satisfied).\n2. The secret technique window of size X ONLY converts grumpy[i] == 1 minutes into satisfied.\n3. Find the window of length X minutes that yields MAXIMUM additional gain of grumpy customers in O(N) linear time."
                        : "১. স্বাভাবিক সন্তুষ্ট কাস্টমার = grumpy[i] == 0 হলের মোট যোগফল (সবসময় সন্তুষ্ট)।\n২. X সাইজের সিক্রেট টেকনিক উইন্ডো কেবল খিটখিটে (grumpy[i] == 1) মিনিটগুলোকে সন্তুষ্ট ব্লকে রূপান্তর করে।\n৩. O(N) লিনিয়ার সময়ে X সাইজের উইন্ডোতে সর্বোচ্চ বাড়তি লাভ বের করুন।",
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
              _isEnglish ? "Grumpy Bookstore Owner Visual Models" : "গ্রাম্পি বুকস্টোর ওনার ভিজ্যুয়াল মডেলসমূহ (কোডহীন গাইড)",
              style: TextStyle(fontSize: Responsive.sp(context, 18), fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 6),
            Text(
              _isEnglish
                  ? "Explore 3 interactive models for customers = [1,0,1,2,1,1,7,5], minutes = 3."
                  : "customers = [1,0,1,2,1,1,7,5], minutes = 3 এর জন্য ৩টি ইন্টারঅ্যাক্টিভ ভিজ্যুয়াল মডেল পর্যবেক্ষণ করুন।",
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 16),

            // Model Switcher Segmented Control
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildAnimationModelChip(0, _isEnglish ? "1. 🪜 Step Flowcard" : "১. 🪜 স্টেপ-বাই-স্টেপ ফ্লো-কার্ড"),
                  _buildAnimationModelChip(1, _isEnglish ? "2. 🏪 Grumpy vs Happy Rule" : "২. 🏪 গ্রাম্পি বনাম হ্যাপি নীতি"),
                  _buildAnimationModelChip(2, _isEnglish ? "3. 📊 Complexity Calculator" : "৩. 📊 টাইমিং ক্যালকুলেটর"),
                ],
              ),
            ),
            const SizedBox(height: 20),

            if (_animationModelIndex == 0) _buildStepFlowcardModel(),
            if (_animationModelIndex == 1) _buildGrumpyFilterRuleModel(),
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
        "window": "[0..2]",
        "base": 10,
        "gain": 0,
        "total": 10,
        "badge": "😊 BASE SATISFIED",
        "badgeColor": AppTheme.accentNeonCyan,
        "titleEn": "Step 1: Base Satisfied Customers = 10",
        "titleBn": "ধাপ ১: স্বাভাবিক সন্তুষ্ট কাস্টমার = ১০",
        "descEn": "Sum of customers when grumpy == 0: 1 + 1 + 1 + 7 = 10.",
        "descBn": "grumpy == 0 হলে কাস্টমারের যোগফল: 1 + 1 + 1 + 7 = 10।",
      },
      {
        "step": 2,
        "window": "[3..5]",
        "base": 10,
        "gain": 3,
        "total": 13,
        "badge": "➡️ SLIDE WINDOW",
        "badgeColor": AppTheme.accentAmber,
        "titleEn": "Step 2: Slide Window [3..5] ➔ Technique Gain = 3 (Total 13)",
        "titleBn": "ধাপ ২: উইন্ডো স্লাইড [3..5] ➔ টেকনিক লাভ = ৩ (মোট ১৩)",
        "descEn": "Gained 2 + 1 = 3 extra customers from grumpy minutes 3 and 5.",
        "descBn": "খিটখিটে মিনিট ৩ ও ৫ থেকে ২ + ১ = ৩ জন অতিরিক্ত কাস্টমার লাভ।",
      },
      {
        "step": 3,
        "window": "[5..7]",
        "base": 10,
        "gain": 6,
        "total": 16,
        "badge": "🎉 MAX GAIN UPDATED",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 3: Slide Window [5..7] ➔ Technique Gain = 6! (Total 16) 🎉",
        "titleBn": "ধাপ ৩: উইন্ডো স্লাইড [5..7] ➔ টেকনিক লাভ = ৬! (মোট ১৬) 🎉",
        "descEn": "Gained 1 + 5 = 6 extra customers! NEW Max Gain = 6!",
        "descBn": "১ + ৫ = ৬ জন অতিরিক্ত কাস্টমার লাভ! নতুন সর্বোচ্চ লাভ = ৬!",
      },
      {
        "step": 4,
        "window": "[5..7]",
        "base": 10,
        "gain": 6,
        "total": 16,
        "badge": "🏁 COMPLETE",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 4: All Windows Evaluated! Maximum Satisfied = 16",
        "titleBn": "ধাপ ৪: সমস্ত উইন্ডো মূল্যায়ন সম্পন্ন! সর্বোচ্চ সন্তুষ্ট = ১৬",
        "descEn": "Base 10 + Max Technique Gain 6 = 16 Total Satisfied Customers!",
        "descBn": "মূল ১০ + সর্বোচ্চ টেকনিক লাভ ৬ = সর্বমোট ১৬ জন সন্তুষ্ট কাস্টমার!",
      },
    ];

    final currentStep = stepFlowData[_flowStepIndex.clamp(0, stepFlowData.length - 1)];
    final int baseVal = currentStep["base"] as int;
    final int gainVal = currentStep["gain"] as int;
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
                _isEnglish ? "1. Step-by-Step Bookstore Gain Flowcard" : "১. স্টেপ-বাই-স্টেপ বুকস্টোর গেইন ফ্লো-কার্ড",
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
                ? "Watch base customer calculation and technique gain sliding window."
                : "স্বাভাবিক কাস্টমার গণনা এবং টেকনিক উইন্ডো স্লাইডিং দেখুন।",
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
                    Text("Base = $baseVal, Gain = $gainVal", style: TextStyle(color: badgeColor, fontWeight: FontWeight.bold, fontSize: 12)),
                    Text("Total Satisfied = $totalVal", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
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
                    "Total = Base ($baseVal) + Max Gain ($gainVal) = $totalVal",
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

  // MODEL 2: Grumpy Filter Rule
  Widget _buildGrumpyFilterRuleModel() {
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
            _isEnglish ? "2. Grumpy vs Satisfied Customer Formula" : "২. গ্রাম্পি বনাম সন্তুষ্ট কাস্টমার নীতি",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            _isEnglish
                ? "Base Satisfied = sum(customers[i]) where grumpy[i] == 0.\nWindow Gain = sum(customers[i]) where grumpy[i] == 1 in window X."
                : "স্বাভাবিক সন্তুষ্ট = grumpy[i] == 0 হলের মোট যোগফল।\nউইন্ডো লাভ = X সাইজের উইন্ডোতে কেবল grumpy[i] == 1 হলের মোট যোগফল।",
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
              "Total Satisfied = Base + maxGain(Sliding Window X); 🏪",
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
            _isEnglish ? "3. O(N) Linear Time & O(1) Space Complexity" : "৩. O(N) লিনিয়ার টাইম এবং O(1) স্পেস কমপ্লেক্সিটি",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            _isEnglish
                ? "Calculating base takes 1 pass = O(N).\nSliding technique window of size X takes 1 pass = O(N).\nTotal time = O(N) with O(1) space complexity!"
                : "স্বাভাবিক হিসাব করতে ১বার লুপ = O(N)।\nX সাইজের স্লাইডিং উইন্ডোতে ১বার লুপ = O(N)।\nসর্বমোট ও(এন) লিনিয়ার সময় এবং ও(১) স্পেস!",
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
                        controller: _customersController,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          labelText: _isEnglish ? "Customers (e.g. 1, 0, 1, 2, 1, 1, 7, 5)" : "কাস্টমার (যেমন 1, 0, 1, 2, 1, 1, 7, 5)",
                          labelStyle: const TextStyle(color: AppTheme.accentNeonCyan, fontSize: 12),
                          filled: true,
                          fillColor: const Color(0xFF090D16),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: _grumpyController,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          labelText: _isEnglish ? "Grumpy (0 or 1)" : "গ্রাম্পি (0 বা 1)",
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
                        controller: _minutesController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          labelText: _isEnglish ? "Minutes" : "মিনিট",
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
                      _buildPresetChip("1, 0, 1, 2, 1, 1, 7, 5", "0, 1, 0, 1, 0, 1, 0, 1", "3"),
                      _buildPresetChip("1", "0", "1"),
                      _buildPresetChip("4, 10, 10", "1, 1, 0", "2"),
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
                  _buildBookstoreCanvas(step),
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildCodeHighlightBox(step.activeLine)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildBookstoreCanvas(step)),
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
    final maxTotalTarget = _maxSatisfied(_customers, _grumpy, _minutes);

    int base = 0;
    for (int i = 0; i < _customers.length; i++) {
      if (_grumpy[i] == 0) base += _customers[i];
    }

    int currentGain = 0;
    for (int i = _practiceLeft; i < _practiceLeft + _minutes && i < _customers.length; i++) {
      if (_grumpy[i] == 1) currentGain += _customers[i];
    }
    int currentTotal = base + currentGain;

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
                  ? "Slide secret technique window of size X = $_minutes minutes to reach maximum satisfied customers!"
                  : "সর্বোচ্চ সন্তুষ্ট কাস্টমার পেতে X = $_minutes মিনিটের টেকনিক উইন্ডো ডানে-বামে স্লাইড করুন!",
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

            // Interactive Minutes Timeline Canvas with Window Frame
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
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
                        Text("Base Satisfied: $base", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
                        Text("Current Total: $currentTotal / $maxTotalTarget", style: const TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(_customers.length, (idx) {
                          bool inWindow = idx >= _practiceLeft && idx < _practiceLeft + _minutes;
                          bool isGrumpy = _grumpy[idx] == 1;

                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            decoration: BoxDecoration(
                              color: inWindow
                                  ? AppTheme.accentPurple.withOpacity(0.35)
                                  : (isGrumpy ? AppTheme.accentPink.withOpacity(0.15) : AppTheme.accentGreen.withOpacity(0.15)),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: inWindow ? AppTheme.accentNeonCyan : (isGrumpy ? AppTheme.accentPink : AppTheme.accentGreen),
                                width: inWindow ? 2.5 : 1.0,
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  "${_customers[idx]}",
                                  style: const TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  isGrumpy ? "😡" : "😊",
                                  style: const TextStyle(fontSize: 12),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "m$idx",
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
                    onPressed: _practiceLeft + _minutes < _customers.length ? () => _handlePracticeSlide(1) : null,
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

  // Helper Widgets
  Widget _buildPresetChip(String cVal, String gVal, String mVal) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ActionChip(
        backgroundColor: const Color(0xFF090D16),
        label: Text("[$cVal], M=$mVal", style: const TextStyle(color: AppTheme.accentNeonCyan, fontSize: 11)),
        onPressed: () {
          _customersController.text = cVal;
          _grumpyController.text = gVal;
          _minutesController.text = mVal;
          _rebuildSteps();
        },
      ),
    );
  }

  Widget _buildCodeHighlightBox(int activeLine) {
    final codeLines = [
      "int maxSatisfied(vector<int>& customers, vector<int>& grumpy, int minutes) {",
      "    int baseSatisfied = 0, n = customers.size();",
      "    for (int i = 0; i < n; i++) if (grumpy[i] == 0) baseSatisfied += customers[i];",
      "    int currentGain = 0;",
      "    for (int i = 0; i < minutes; i++) if (grumpy[i] == 1) currentGain += customers[i];",
      "    int maxGain = currentGain;",
      "    for (int i = minutes; i < n; i++) {",
      "        if (grumpy[i] == 1) currentGain += customers[i];",
      "        if (grumpy[i - minutes] == 1) currentGain -= customers[i - minutes];",
      "        maxGain = max(maxGain, currentGain);",
      "    }",
      "    return baseSatisfied + maxGain;",
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

  Widget _buildBookstoreCanvas(GrumpyBookstoreStep step) {
    Color decisionColor = AppTheme.accentPurple;
    String decisionLabel = "INIT";

    if (step.decision == "calc_base") {
      decisionColor = AppTheme.accentNeonCyan;
      decisionLabel = "😊 BASE SATISFACTION";
    } else if (step.decision == "build_first_window") {
      decisionColor = AppTheme.accentNeonCyan;
      decisionLabel = "🪟 BUILD WINDOW";
    } else if (step.decision == "slide_window") {
      decisionColor = AppTheme.accentAmber;
      decisionLabel = "➡️ SLIDE WINDOW";
    } else if (step.decision == "max_updated") {
      decisionColor = AppTheme.accentGreen;
      decisionLabel = "🎉 MAX GAIN UPDATED";
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
              Text("Window: [${step.left}..${step.right}] (X = $_minutes mins)", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13)),
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

          // Base + Gain + Total Meter
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Base = ${step.baseSatisfied}, Window Gain = ${step.currentWindowGain}", style: TextStyle(color: decisionColor, fontWeight: FontWeight.bold, fontSize: 12)),
              Text("Max Gain = ${step.maxGain}", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
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
                  "Total Satisfied = ${step.totalSatisfied}",
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
                  "Calculation: Base (${step.baseSatisfied}) + Max Gain (${step.maxGain}) = ${step.totalSatisfied}",
                  style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Visual Minutes Canvas
          const Text("Bookstore Timeline Canvas:", style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_customers.length, (idx) {
                bool inWindow = idx >= step.left && idx <= step.right;
                bool isGrumpy = _grumpy[idx] == 1;

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: inWindow
                        ? decisionColor.withOpacity(0.35)
                        : (isGrumpy ? AppTheme.accentPink.withOpacity(0.15) : AppTheme.accentGreen.withOpacity(0.15)),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: inWindow ? decisionColor : (isGrumpy ? AppTheme.accentPink : AppTheme.accentGreen),
                      width: inWindow ? 2.0 : 1.0,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "${_customers[idx]}",
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: inWindow ? Colors.white : const Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isGrumpy ? "😡" : "😊",
                        style: const TextStyle(fontSize: 11),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "m$idx",
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
    int maxSatisfied(vector<int>& customers, vector<int>& grumpy, int minutes) {
        int baseSatisfied = 0, n = customers.size();
        for (int i = 0; i < n; i++) {
            if (grumpy[i] == 0) baseSatisfied += customers[i];
        }
        int currentGain = 0;
        for (int i = 0; i < minutes; i++) {
            if (grumpy[i] == 1) currentGain += customers[i];
        }
        int maxGain = currentGain;
        for (int i = minutes; i < n; i++) {
            if (grumpy[i] == 1) currentGain += customers[i];
            if (grumpy[i - minutes] == 1) currentGain -= customers[i - minutes];
            maxGain = max(maxGain, currentGain);
        }
        return baseSatisfied + maxGain;
    }
};""";
    } else if (lang == "Java") {
      code = """
class Solution {
    public int maxSatisfied(int[] customers, int[] grumpy, int minutes) {
        int baseSatisfied = 0, n = customers.length;
        for (int i = 0; i < n; i++) {
            if (grumpy[i] == 0) baseSatisfied += customers[i];
        }
        int currentGain = 0;
        for (int i = 0; i < minutes; i++) {
            if (grumpy[i] == 1) currentGain += customers[i];
        }
        int maxGain = currentGain;
        for (int i = minutes; i < n; i++) {
            if (grumpy[i] == 1) currentGain += customers[i];
            if (grumpy[i - minutes] == 1) currentGain -= customers[i - minutes];
            maxGain = Math.max(maxGain, currentGain);
        }
        return baseSatisfied + maxGain;
    }
}""";
    } else {
      code = """
class Solution:
    def maxSatisfied(self, customers: List[int], grumpy: List[int], minutes: int) -> int:
        base_satisfied = sum(c for c, g in zip(customers, grumpy) if g == 0)
        current_gain = sum(c for c, g in zip(customers[:minutes], grumpy[:minutes]) if g == 1)
        max_gain = current_gain

        for i in range(minutes, len(customers)):
            if grumpy[i] == 1:
                current_gain += customers[i]
            if grumpy[i - minutes] == 1:
                current_gain -= customers[i - minutes]
            max_gain = max(max_gain, current_gain)

        return base_satisfied + max_gain""";
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
