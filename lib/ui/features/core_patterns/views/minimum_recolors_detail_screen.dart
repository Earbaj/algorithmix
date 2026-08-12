import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class MinimumRecolorsStep {
  final int left;
  final int right;
  final int currentWhiteCount;
  final int minRecolors;
  final String windowSubstring;
  final String decision; // 'init', 'build_first_window', 'slide_window', 'min_updated', 'finished'
  final int activeLine;
  final String actionEn;
  final String actionBn;
  final String reasonEn;
  final String reasonBn;

  const MinimumRecolorsStep({
    required this.left,
    required this.right,
    required this.currentWhiteCount,
    required this.minRecolors,
    required this.windowSubstring,
    required this.decision,
    required this.activeLine,
    required this.actionEn,
    required this.actionBn,
    required this.reasonEn,
    required this.reasonBn,
  });
}

class MinimumRecolorsDetailScreen extends StatefulWidget {
  const MinimumRecolorsDetailScreen({super.key});

  @override
  State<MinimumRecolorsDetailScreen> createState() => _MinimumRecolorsDetailScreenState();
}

class _MinimumRecolorsDetailScreenState extends State<MinimumRecolorsDetailScreen>
    with SingleTickerProviderStateMixin {
  bool _isEnglish = true;
  late TabController _tabController;

  // Custom Input State
  final TextEditingController _blocksController = TextEditingController(text: "WBBWWBBWBW");
  final TextEditingController _kController = TextEditingController(text: "7");
  String _blocks = "WBBWWBBWBW";
  int _k = 7;
  List<MinimumRecolorsStep> _steps = [];

  // Playback Control
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  // Code Language Selector
  String _selectedCodeLang = "C++";

  // Tab 2 Animation Model Selector (0: Step Flowcard, 1: Block Converter Rule, 2: Complexity Calculator)
  int _animationModelIndex = 0;
  int _flowStepIndex = 0;

  // Practice Mode State
  int _practiceLeft = 0;
  String _userFeedbackEn = "Slide window of size K to find the minimum number of white 'W' blocks to recolor!";
  String _userFeedbackBn = "সর্বনিম্ন সাদা 'W' ব্লক খুঁজতে K সাইজের উইন্ডো স্লাইড করুন!";
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
    _blocksController.dispose();
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

    String text = _blocksController.text.trim().toUpperCase();
    if (text.isEmpty) text = "WBBWWBBWBW";
    _blocks = text;

    try {
      int kVal = int.parse(_kController.text.trim());
      if (kVal <= 0) kVal = 1;
      if (kVal > _blocks.length) kVal = _blocks.length;
      _k = kVal;
    } catch (_) {
      _k = 7;
    }

    _steps = _generateSteps(_blocks, _k);

    // Reset practice mode
    _resetPractice();
  }

  void _resetPractice() {
    _practiceLeft = 0;
    _practiceSolved = false;
    _userFeedbackEn = "Slide window of size K = $_k to find minimum 'W' blocks!";
    _userFeedbackBn = "সর্বনিম্ন 'W' ব্লক খুঁজতে K = $_k সাইজের উইন্ডো স্লাইড করুন!";
  }

  List<MinimumRecolorsStep> _generateSteps(String inputBlocks, int windowK) {
    List<MinimumRecolorsStep> steps = [];

    // Step 0: Init
    steps.add(MinimumRecolorsStep(
      left: 0,
      right: windowK - 1,
      currentWhiteCount: 0,
      minRecolors: 0,
      windowSubstring: "",
      decision: "init",
      activeLine: 1,
      actionEn: "Line 1: Initialize Sliding Window for blocks = '$inputBlocks', K = $windowK.",
      actionBn: "লাইন ১: অ্যাররে blocks = '$inputBlocks', K = $windowK এর জন্য স্লাইডিং উইন্ডো শুরু।",
      reasonEn: "We count 'W' characters in a fixed window of size K to find min recolors.",
      reasonBn: "সর্বনিম্ন রিকালার বের করতে K সাইজের ফিক্সড উইন্ডোতে 'W' অক্ষরের গণনা ট্র্যাক করা হবে।",
    ));

    // First window 0..K-1
    int whiteCount = 0;
    for (int i = 0; i < windowK; i++) {
      if (inputBlocks[i] == 'W') whiteCount++;
    }
    int minRecolors = whiteCount;

    steps.add(MinimumRecolorsStep(
      left: 0,
      right: windowK - 1,
      currentWhiteCount: whiteCount,
      minRecolors: minRecolors,
      windowSubstring: inputBlocks.substring(0, windowK),
      decision: "build_first_window",
      activeLine: 3,
      actionEn: "🪟 Line 3: Build first window [0..${windowK - 1}] '${inputBlocks.substring(0, windowK)}' ➔ White 'W' Count = $whiteCount.",
      actionBn: "🪟 লাইন ৩: প্রথম উইন্ডো [0..${windowK - 1}] '${inputBlocks.substring(0, windowK)}' তৈরি ➔ সাদা 'W' গণনা = $whiteCount।",
      reasonEn: "Count of 'W's in first K elements forms the baseline minimum recolors.",
      reasonBn: "প্রথম K উপাদানে 'W' এর সংখ্যা থেকে প্রাথমিক রিকালার হিসেব তৈরি হয়।",
    ));

    // Slide window right
    for (int r = windowK; r < inputBlocks.length; r++) {
      int l = r - windowK + 1;
      bool addedW = inputBlocks[r] == 'W';
      bool removedW = inputBlocks[l - 1] == 'W';

      if (addedW) whiteCount++;
      if (removedW) whiteCount--;

      bool isUpdated = whiteCount < minRecolors;
      if (isUpdated) minRecolors = whiteCount;

      steps.add(MinimumRecolorsStep(
        left: l,
        right: r,
        currentWhiteCount: whiteCount,
        minRecolors: minRecolors,
        windowSubstring: inputBlocks.substring(l, r + 1),
        decision: isUpdated ? "min_updated" : "slide_window",
        activeLine: isUpdated ? 7 : 6,
        actionEn: isUpdated
            ? "🎉 Line 7: Slide Window [${l}..${r}] '${inputBlocks.substring(l, r + 1)}' ➔ NEW Min Recolors = $minRecolors!"
            : "➡️ Line 6: Slide Window [${l}..${r}] '${inputBlocks.substring(l, r + 1)}' ➔ 'W' Count = $whiteCount (Min = $minRecolors).",
        actionBn: isUpdated
            ? "🎉 লাইন ৭: উইন্ডো স্লাইড [${l}..${r}] '${inputBlocks.substring(l, r + 1)}' ➔ নতুন Min Recolors = $minRecolors!"
            : "➡️ লাইন ৬: উইন্ডো স্লাইড [${l}..${r}] '${inputBlocks.substring(l, r + 1)}' ➔ 'W' গণনা = $whiteCount (Min = $minRecolors)।",
        reasonEn: isUpdated
            ? "Current 'W' count $whiteCount is smaller than previous minimum. Update minRecolors!"
            : "Current 'W' count $whiteCount is >= minimum $minRecolors.",
        reasonBn: isUpdated
            ? "বর্তমান 'W' গণনা $whiteCount পূর্বের মিনিমাম থেকে ছোট। minRecolors আপডেট করুন!"
            : "বর্তমান 'W' গণনা $whiteCount মিনিমাম $minRecolors এর চেয়ে ছোট নয়।",
      ));
    }

    steps.add(MinimumRecolorsStep(
      left: inputBlocks.length - windowK,
      right: inputBlocks.length - 1,
      currentWhiteCount: whiteCount,
      minRecolors: minRecolors,
      windowSubstring: inputBlocks.substring(inputBlocks.length - windowK),
      decision: "finished",
      activeLine: 9,
      actionEn: "🏁 Line 9: Sliding Window Complete! Minimum Recolors Required = $minRecolors.",
      actionBn: "🏁 লাইন ৯: স্লাইডিং উইন্ডো সম্পূর্ণ! সর্বনিম্ন রিকালার প্রয়োজন = $minRecolors।",
      reasonEn: "Evaluated all K-sized windows in O(N) linear time.",
      reasonBn: "O(N) লিনিয়ার সময়ে সমস্ত K সাইজের উইন্ডো মূল্যায়ন সম্পন্ন।",
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

  int _calculateMinRecolors(String blocksStr, int kVal) {
    int wCount = 0;
    for (int i = 0; i < kVal; i++) {
      if (blocksStr[i] == 'W') wCount++;
    }
    int minW = wCount;
    for (int i = kVal; i < blocksStr.length; i++) {
      if (blocksStr[i] == 'W') wCount++;
      if (blocksStr[i - kVal] == 'W') wCount--;
      if (wCount < minW) minW = wCount;
    }
    return minW;
  }

  void _handlePracticeSlide(int direction) {
    if (_practiceSolved) return;
    final targetMin = _calculateMinRecolors(_blocks, _k);

    setState(() {
      if (direction > 0 && _practiceLeft + _k < _blocks.length) {
        _practiceLeft++;
      } else if (direction < 0 && _practiceLeft > 0) {
        _practiceLeft--;
      }

      int wCount = 0;
      for (int i = _practiceLeft; i < _practiceLeft + _k; i++) {
        if (_blocks[i] == 'W') wCount++;
      }

      if (wCount == targetMin) {
        _practiceSolved = true;
        _userFeedbackEn = "🏆 PERFECT! You found the optimal window [${_practiceLeft}..${_practiceLeft + _k - 1}] with Minimum Recolors = $wCount!";
        _userFeedbackBn = "🏆 দারুণ! আপনি সেরা উইন্ডো [${_practiceLeft}..${_practiceLeft + _k - 1}] নির্বাচন করে সর্বনিম্ন রিকালার $wCount খুঁজে পেয়েছেন!";
      } else {
        _userFeedbackEn = "Window [${_practiceLeft}..${_practiceLeft + _k - 1}] has $wCount 'W' blocks. Slide window further to reach minimum target ($targetMin)!";
        _userFeedbackBn = "উইন্ডো [${_practiceLeft}..${_practiceLeft + _k - 1}] এ $wCount টি 'W' ব্লক আছে। সর্বনিম্ন লক্ষ্যমাত্রায় ($targetMin) পৌঁছাতে আরও স্লাইড করুন!";
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
          '2379. Minimum Recolors to Get K Consecutive Black Blocks',
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
                    "2379. Minimum Recolors to Get K Consecutive Black Blocks",
                    style: TextStyle(fontSize: Responsive.sp(context, 20), fontWeight: FontWeight.bold, color: Colors.white),
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
                        ? "You are given a string blocks where blocks[i] is either 'W' or 'B', and an integer k. Return the minimum number of operations to recolor 'W' to 'B' such that there is at least one occurrence of k consecutive black blocks."
                        : "একটি স্ট্রিং blocks এবং একটি পূর্ণসংখ্যা k দেওয়া আছে। k টি পর পর কালো ব্লক ('B') পেতে সর্বনিম্ন কতটি সাদা ব্লক ('W') পুনঃরঙ (recolor) করতে হবে তা বের করুন।",
                    style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Examples
            Text(_isEnglish ? "Examples" : "উদাহরণসমূহ", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            _buildExampleCard("Example 1", "blocks = \"WBBWWBBWBW\", k = 7", "Output: 3 (Window \"WBBWWBB\" has 3 'W's)"),
            _buildExampleCard("Example 2", "blocks = \"WBWBBBW\", k = 2", "Output: 0 (Window \"BB\" has 0 'W's)"),
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
                        _isEnglish ? "Key Intuition (Fixed Window 'W' Counter)" : "মূল আইডিয়া (ফিক্সড উইন্ডো 'W' কাউন্টার)",
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isEnglish
                        ? "1. Maintain a fixed window of size K.\n2. Count number of 'W' blocks inside current window.\n3. Slide window: add 1 if right block is 'W', subtract 1 if left block is 'W'.\n4. Track minimum 'W' count in O(N) time."
                        : "১. K সাইজের একটি ফিক্সড উইন্ডো বজায় রাখুন।\n২. উইন্ডোর ভেতরের সাদা 'W' ব্লকের সংখ্যা গুনুন।\n৩. স্লাইড করার সময়: ডান ব্লক 'W' হলে +১, বাম ব্লক 'W' হলে -১।\n৪. O(N) সময়ে সর্বনিম্ন 'W' সংখ্যা বের করুন।",
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
              _isEnglish ? "Minimum Recolors Visual Models" : "মিনিমাম রিকালার ভিজ্যুয়াল মডেলসমূহ (কোডহীন গাইড)",
              style: TextStyle(fontSize: Responsive.sp(context, 18), fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 6),
            Text(
              _isEnglish
                  ? "Explore 3 interactive models for blocks = \"WBBWWBBWBW\", K = 7."
                  : "blocks = \"WBBWWBBWBW\", K = 7 এর জন্য ৩টি ইন্টারঅ্যাক্টিভ ভিজ্যুয়াল মডেল পর্যবেক্ষণ করুন।",
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 16),

            // Model Switcher Segmented Control
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildAnimationModelChip(0, _isEnglish ? "1. 🪜 Step Flowcard" : "১. 🪜 স্টেপ-বাই-স্টেপ ফ্লো-কার্ড"),
                  _buildAnimationModelChip(1, _isEnglish ? "2. 🧱 Block Converter Rule" : "২. 🧱 ব্লক কনভার্টার নীতি"),
                  _buildAnimationModelChip(2, _isEnglish ? "3. 📊 Complexity Calculator" : "৩. 📊 টাইমিং ক্যালকুলেটর"),
                ],
              ),
            ),
            const SizedBox(height: 20),

            if (_animationModelIndex == 0) _buildStepFlowcardModel(),
            if (_animationModelIndex == 1) _buildBlockConverterRuleModel(),
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
        "window": "\"WBBWWBB\"",
        "count": 3,
        "min": 3,
        "badge": "🪟 FIRST WINDOW",
        "badgeColor": AppTheme.accentNeonCyan,
        "titleEn": "Step 1: First Window [0..6] = \"WBBWWBB\"",
        "titleBn": "ধাপ ১: প্রথম উইন্ডো [0..6] = \"WBBWWBB\"",
        "descEn": "3 'W' blocks inside. Baseline minRecolors = 3.",
        "descBn": "ভেতরে ৩টি 'W' ব্লক। প্রাথমিক মিনিমাম রিকালার = ৩।",
      },
      {
        "step": 2,
        "window": "\"BBWWBBW\"",
        "count": 3,
        "min": 3,
        "badge": "➡️ SLIDE RIGHT",
        "badgeColor": AppTheme.accentAmber,
        "titleEn": "Step 2: Slide Right (+W, -W) ➔ Window [1..7] = \"BBWWBBW\"",
        "titleBn": "ধাপ ২: ডানে স্লাইড (+W, -W) ➔ উইন্ডো [1..7] = \"BBWWBBW\"",
        "descEn": "3 'W' blocks inside. Keep minRecolors = 3.",
        "descBn": "ভেতরে ৩টি 'W' ব্লক। মিনিমাম রিকালার = ৩ থাকবে।",
      },
      {
        "step": 3,
        "window": "\"BWWBBWB\"",
        "count": 4,
        "min": 3,
        "badge": "➡️ SLIDE RIGHT",
        "badgeColor": AppTheme.accentAmber,
        "titleEn": "Step 3: Slide Right (+B, -B) ➔ Window [2..8] = \"BWWBBWB\"",
        "titleBn": "ধাপ ৩: ডানে স্লাইড (+B, -B) ➔ উইন্ডো [2..8] = \"BWWBBWB\"",
        "descEn": "4 'W' blocks inside. Keep minRecolors = 3.",
        "descBn": "ভেতরে ৪টি 'W' ব্লক। মিনিমাম রিকালার = ৩ থাকবে।",
      },
      {
        "step": 4,
        "window": "\"WWBBWBW\"",
        "count": 4,
        "min": 3,
        "badge": "🏁 COMPLETE",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 4: All Windows Evaluated! Minimum Recolors = 3",
        "titleBn": "ধাপ ৪: সমস্ত উইন্ডো মূল্যায়ন সম্পন্ন! সর্বনিম্ন রিকালার = ৩",
        "descEn": "Minimum 3 recolors needed to get 7 consecutive 'B' blocks! 🎉",
        "descBn": "৭টি পর পর 'B' ব্লক পেতে সর্বনিম্ন ৩টি পুনঃরঙ প্রয়োজন! 🎉",
      },
    ];

    final currentStep = stepFlowData[_flowStepIndex.clamp(0, stepFlowData.length - 1)];
    final String window = currentStep["window"] as String;
    final int count = currentStep["count"] as int;
    final int minVal = currentStep["min"] as int;
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
                _isEnglish ? "1. Step-by-Step 'W' Counter Flowcard" : "১. স্টেপ-বাই-স্টেপ 'W' কাউন্টার ফ্লো-কার্ড",
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
                ? "Watch fixed window sliding and 'W' block count tracking."
                : "ফিক্সড উইন্ডো স্লাইডিং এবং 'W' ব্লক গণনার ট্র্যাকিং দেখুন।",
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
                    Text("Window 'W' Count = $count", style: TextStyle(color: badgeColor, fontWeight: FontWeight.bold, fontSize: 12)),
                    Text("Min Recolors = $minVal", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
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
                    "Window = $window",
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

  // MODEL 2: Block Converter Rule
  Widget _buildBlockConverterRuleModel() {
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
            _isEnglish ? "2. Block Sliding Update Rule" : "২. ব্লক স্লাইডিং আপডেট নীতি",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            _isEnglish
                ? "When sliding 1 step right:\n- If incoming right block == 'W' ➔ whiteCount++\n- If outgoing left block == 'W' ➔ whiteCount--"
                : "১ ঘর ডানে স্লাইড করার সময়:\n- ডানের নতুন ব্লক 'W' হলে ➔ whiteCount++\n- বামের বাদ পড়া ব্লক 'W' হলে ➔ whiteCount--",
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
              "if (blocks[i] == 'W') w++;\nif (blocks[i - k] == 'W') w--; 🧱",
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
            _isEnglish ? "3. O(N * K) Brute Force vs O(N) Sliding Window" : "৩. O(N * K) ব্রুট ফোর্স বনাম O(N) স্লাইডিং উইন্ডো",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            _isEnglish
                ? "Brute force re-counts 'W's for every window of size K ➔ O(N * K).\nSliding Window updates 'W' count in O(1) per step ➔ O(N) total."
                : "ব্রুট ফোর্স প্রতি K উইন্ডোতে নতুন করে 'W' গণনা করে ➔ O(N * K)।\nস্লাইডিং উইন্ডো O(1) এ সংখ্যা আপডেট করে ➔ সর্বমোট O(N)।",
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
                        controller: _blocksController,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          labelText: _isEnglish ? "Blocks (e.g. WBBWWBBWBW)" : "ব্লকস (যেমন WBBWWBBWBW)",
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
                      _buildPresetChip("WBBWWBBWBW", "7"),
                      _buildPresetChip("WBWBBBW", "2"),
                      _buildPresetChip("WWWWBBBB", "4"),
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
                  _buildBlockCanvas(step),
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildCodeHighlightBox(step.activeLine)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildBlockCanvas(step)),
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
    final targetMin = _calculateMinRecolors(_blocks, _k);

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
                  ? "Slide window K = $_k left and right to find the window with minimum white 'W' blocks!"
                  : "সর্বনিম্ন সাদা 'W' ব্লকের উইন্ডো পেতে K = $_k সাইজের উইন্ডো ডানে-বামে স্লাইড করুন!",
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

            // Interactive Blocks Canvas with Window Frame
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
                    children: List.generate(_blocks.length, (idx) {
                      bool inWindow = idx >= _practiceLeft && idx < _practiceLeft + _k;
                      bool isWhite = _blocks[idx] == 'W';

                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: isWhite
                              ? (inWindow ? Colors.white.withOpacity(0.9) : const Color(0xFFE2E8F0))
                              : (inWindow ? AppTheme.primaryDark : const Color(0xFF0F172A)),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: inWindow ? AppTheme.accentNeonCyan : const Color(0xFF334155),
                            width: inWindow ? 2.5 : 1.0,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              _blocks[idx],
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isWhite ? Colors.black : Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "[$idx]",
                              style: TextStyle(fontSize: 10, color: isWhite ? Colors.black87 : const Color(0xFF64748B)),
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
                    onPressed: _practiceLeft + _k < _blocks.length ? () => _handlePracticeSlide(1) : null,
                  ),
                ],
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
  Widget _buildPresetChip(String numVal, String kVal) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ActionChip(
        backgroundColor: const Color(0xFF090D16),
        label: Text("'$numVal', K=$kVal", style: const TextStyle(color: AppTheme.accentNeonCyan, fontSize: 11)),
        onPressed: () {
          _blocksController.text = numVal;
          _kController.text = kVal;
          _rebuildSteps();
        },
      ),
    );
  }

  Widget _buildCodeHighlightBox(int activeLine) {
    final codeLines = [
      "int minimumRecolors(string blocks, int k) {",
      "    int whiteCount = 0;",
      "    for (int i = 0; i < k; i++) if (blocks[i] == 'W') whiteCount++;",
      "    int minRecolors = whiteCount;",
      "    for (int i = k; i < blocks.length(); i++) {",
      "        if (blocks[i] == 'W') whiteCount++;",
      "        if (blocks[i - k] == 'W') whiteCount--;",
      "        minRecolors = min(minRecolors, whiteCount);",
      "    }",
      "    return minRecolors;",
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

  Widget _buildBlockCanvas(MinimumRecolorsStep step) {
    Color decisionColor = AppTheme.accentPurple;
    String decisionLabel = "INIT";

    if (step.decision == "build_first_window") {
      decisionColor = AppTheme.accentNeonCyan;
      decisionLabel = "🪟 FIRST WINDOW";
    } else if (step.decision == "slide_window") {
      decisionColor = AppTheme.accentAmber;
      decisionLabel = "➡️ SLIDE RIGHT";
    } else if (step.decision == "min_updated") {
      decisionColor = AppTheme.accentGreen;
      decisionLabel = "🎉 MIN UPDATED";
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

          // 'W' Count & Min Recolors Box
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Current 'W' Count = ${step.currentWhiteCount}", style: TextStyle(color: decisionColor, fontWeight: FontWeight.bold, fontSize: 12)),
              Text("Min Recolors = ${step.minRecolors}", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
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
                  "Min Recolors Required = ${step.minRecolors}",
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
                  "Sub-block Window: \"${step.windowSubstring}\"",
                  style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Visual Blocks Canvas
          const Text("Blocks Sequence Canvas:", style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_blocks.length, (idx) {
                bool inWindow = idx >= step.left && idx <= step.right;
                bool isWhite = _blocks[idx] == 'W';

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: isWhite
                        ? (inWindow ? Colors.white.withOpacity(0.9) : const Color(0xFFCBD5E1))
                        : (inWindow ? AppTheme.primaryDark : const Color(0xFF0F172A)),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: inWindow ? decisionColor : const Color(0xFF334155),
                      width: inWindow ? 2.0 : 1.0,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        _blocks[idx],
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isWhite ? Colors.black : Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "[$idx]",
                        style: TextStyle(fontSize: 9, color: isWhite ? Colors.black87 : const Color(0xFF64748B)),
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
    int minimumRecolors(string blocks, int k) {
        int whiteCount = 0;
        for (int i = 0; i < k; i++) {
            if (blocks[i] == 'W') whiteCount++;
        }
        int minRecolors = whiteCount;
        for (int i = k; i < blocks.length(); i++) {
            if (blocks[i] == 'W') whiteCount++;
            if (blocks[i - k] == 'W') whiteCount--;
            minRecolors = min(minRecolors, whiteCount);
        }
        return minRecolors;
    }
};""";
    } else if (lang == "Java") {
      code = """
class Solution {
    public int minimumRecolors(String blocks, int k) {
        int whiteCount = 0;
        for (int i = 0; i < k; i++) {
            if (blocks.charAt(i) == 'W') whiteCount++;
        }
        int minRecolors = whiteCount;
        for (int i = k; i < blocks.length(); i++) {
            if (blocks.charAt(i) == 'W') whiteCount++;
            if (blocks.charAt(i - k) == 'W') whiteCount--;
            minRecolors = Math.min(minRecolors, whiteCount);
        }
        return minRecolors;
    }
}""";
    } else {
      code = """
class Solution:
    def minimumRecolors(self, blocks: str, k: int) -> int:
        white_count = blocks[:k].count('W')
        min_recolors = white_count

        for i in range(k, len(blocks)):
            if blocks[i] == 'W':
                white_count += 1
            if blocks[i - k] == 'W':
                white_count -= 1
            min_recolors = min(min_recolors, white_count)

        return min_recolors""";
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
