import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class SubsetsIIStep {
  final int startIndex;
  final int currentIndex;
  final List<int> currentSubset;
  final List<List<int>> allSubsets;
  final String decision; // 'init', 'include_elem', 'skip_duplicate', 'save_subset', 'backtrack'
  final int activeLine;
  final String actionEn;
  final String actionBn;
  final String reasonEn;
  final String reasonBn;
  final int callStackDepth;

  const SubsetsIIStep({
    required this.startIndex,
    required this.currentIndex,
    required this.currentSubset,
    required this.allSubsets,
    required this.decision,
    required this.activeLine,
    required this.actionEn,
    required this.actionBn,
    required this.reasonEn,
    required this.reasonBn,
    required this.callStackDepth,
  });
}

class SubsetsIIDetailScreen extends StatefulWidget {
  const SubsetsIIDetailScreen({super.key});

  @override
  State<SubsetsIIDetailScreen> createState() => _SubsetsIIDetailScreenState();
}

class _SubsetsIIDetailScreenState extends State<SubsetsIIDetailScreen>
    with SingleTickerProviderStateMixin {
  bool _isEnglish = true;
  late TabController _tabController;

  // Custom Input State
  final TextEditingController _inputController = TextEditingController(text: "1, 2, 2");
  List<int> _nums = [1, 2, 2];
  List<SubsetsIIStep> _steps = [];

  // Playback Control
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  // Code Language Selector
  String _selectedCodeLang = "C++";

  // Tab 2 Animation Model Selector (0: Step Flowcard, 1: Duplicate Pruning Rule, 2: Subsets Count)
  int _animationModelIndex = 0;
  int _flowStepIndex = 0;

  // Practice Mode State
  int _practiceStart = 0;
  List<int> _practiceCurrentSubset = [];
  List<List<int>> _practiceResults = [];
  List<String> _practiceHistory = [];
  String _userFeedbackEn = "Choose whether to INCLUDE or SKIP DUPLICATE elements to build unique subsets!";
  String _userFeedbackBn = "অনন্য সাবসেট তৈরি করতে উপাদানINCLUDE বা SKIP DUPLICATE করবেন তা সিদ্ধান্ত নিন!";
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
    _inputController.dispose();
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

    // Parse nums
    try {
      List<int> parsed = _inputController.text
          .split(',')
          .map((e) => int.parse(e.trim()))
          .toList();
      if (parsed.isEmpty) parsed = [1, 2, 2];
      if (parsed.length > 4) parsed = parsed.sublist(0, 4); // Limit for clean visualization
      parsed.sort(); // Sorting required for Subsets II!
      _nums = parsed;
    } catch (_) {
      _nums = [1, 2, 2];
    }

    _steps = _generateSteps(_nums);

    // Reset practice mode
    _practiceStart = 0;
    _practiceCurrentSubset = [];
    _practiceResults = [];
    _practiceHistory = [];
    _practiceSolved = false;
    _userFeedbackEn = "Choose whether to INCLUDE or SKIP DUPLICATE elements to build unique subsets!";
    _userFeedbackBn = "অনন্য সাবসেট তৈরি করতে উপাদান INCLUDE বা SKIP DUPLICATE করবেন তা সিদ্ধান্ত নিন!";
  }

  List<SubsetsIIStep> _generateSteps(List<int> inputNums) {
    List<SubsetsIIStep> steps = [];
    List<List<int>> results = [];
    List<int> subset = [];

    // Step 0: Init & Sort
    steps.add(SubsetsIIStep(
      startIndex: 0,
      currentIndex: 0,
      currentSubset: [],
      allSubsets: [],
      decision: "init",
      activeLine: 1,
      actionEn: "Line 1: Sort array [${inputNums.join(', ')}] & Start Subsets II backtracking.",
      actionBn: "লাইন ১: অ্যাররে [${inputNums.join(', ')}] সর্ট এবং Subsets II ব্যাকট্র্যাক শুরু।",
      reasonEn: "Sorting groups identical elements together so we can skip duplicates cleanly.",
      reasonBn: "সর্টিং একই সংখ্যাগুলোকে পাশাপাশি রাখে যাতে ডুপ্লিকেট সহজে স্কিপ করা যায়।",
      callStackDepth: 0,
    ));

    void backtrack(int start, int depth) {
      results.add(List.from(subset));
      steps.add(SubsetsIIStep(
        startIndex: start,
        currentIndex: start,
        currentSubset: List.from(subset),
        allSubsets: List.from(results),
        decision: "save_subset",
        activeLine: 2,
        actionEn: "🎉 Line 2: Saved Unique Subset [${subset.join(', ')}].",
        actionBn: "🎉 লাইন ২: অনন্য সাবসেট [${subset.join(', ')}] সংরক্ষিত।",
        reasonEn: "Every recursion state represents a valid unique subset.",
        reasonBn: "প্রতিটি রিকার্সন অবস্হা একটি অনন্য সাবসেট নির্দেশ করে।",
        callStackDepth: depth,
      ));

      for (int i = start; i < inputNums.length; i++) {
        // Check duplicate rule: if (i > start && nums[i] == nums[i-1]) continue;
        if (i > start && inputNums[i] == inputNums[i - 1]) {
          steps.add(SubsetsIIStep(
            startIndex: start,
            currentIndex: i,
            currentSubset: List.from(subset),
            allSubsets: List.from(results),
            decision: "skip_duplicate",
            activeLine: 6,
            actionEn: "🛑 Line 6: Skip Duplicate '${inputNums[i]}' at index $i (i > start && nums[i] == nums[i-1]).",
            actionBn: "🛑 লাইন ৬: ইনডেক্স $i এ ডুপ্লিকেট '${inputNums[i]}' বাদ দেওয়া হলো।",
            reasonEn: "Element '${inputNums[i]}' was already processed at index ${i - 1} at this recursion level.",
            reasonBn: "এই রিকার্সন লেভেলে ইনডেক্স ${i - 1} এ '${inputNums[i]}' ইতিমধ্যেই প্রসেস করা হয়েছে।",
            callStackDepth: depth,
          ));
          continue;
        }

        subset.add(inputNums[i]);
        steps.add(SubsetsIIStep(
          startIndex: start,
          currentIndex: i,
          currentSubset: List.from(subset),
          allSubsets: List.from(results),
          decision: "include_elem",
          activeLine: 7,
          actionEn: "Line 7: Include '${inputNums[i]}' at index $i ➔ Subset = [${subset.join(', ')}].",
          actionBn: "লাইন ৭: ইনডেক্স $i এর '${inputNums[i]}' গ্রহণ ➔ Subset = [${subset.join(', ')}]।",
          reasonEn: "Valid unique element choice. Recurse to next index ${i + 1}.",
          reasonBn: "বৈধ অনন্য উপাদান নির্বাচন। পরবর্তী ইনডেক্স ${i + 1} এ রিকার্সন চালাও।",
          callStackDepth: depth + 1,
        ));

        backtrack(i + 1, depth + 1);

        // Backtrack
        subset.removeLast();
        steps.add(SubsetsIIStep(
          startIndex: start,
          currentIndex: i,
          currentSubset: List.from(subset),
          allSubsets: List.from(results),
          decision: "backtrack",
          activeLine: 9,
          actionEn: "Line 9: Backtrack ↩️ Pop last element ➔ Reverted to [${subset.join(', ')}].",
          actionBn: "লাইন ৯: ব্যাকট্র্যাক ↩️ শেষ উপাদান বাদ ➔ পুনর্বহাল [${subset.join(', ')}]।",
          reasonEn: "Restore state for next iteration.",
          reasonBn: "পরবর্তী ইটারেশনের জন্য অবস্হা পুনর্বহাল করো।",
          callStackDepth: depth,
        ));
      }
    }

    backtrack(0, 0);

    // Final Step
    steps.add(SubsetsIIStep(
      startIndex: inputNums.length,
      currentIndex: inputNums.length,
      currentSubset: [],
      allSubsets: List.from(results),
      decision: "save_subset",
      activeLine: 11,
      actionEn: "🎉 Line 11: Backtracking Finished! Generated total ${results.length} unique subsets!",
      actionBn: "🎉 লাইন ১১: ব্যাকট্র্যাকিং সম্পূর্ণ! মোট ${results.length} টি অনন্য সাবসেট তৈরি সম্পন্ন!",
      reasonEn: "All unique subset paths fully explored.",
      reasonBn: "সমস্ত অনন্য সাবসেট ডালপালা অনুসন্ধান সম্পন্ন হয়েছে।",
      callStackDepth: 0,
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

  int _calculateUniqueSubsetsCount(List<int> nums) {
    Set<String> unique = {};
    int n = nums.length;
    int total = 1 << n;

    for (int mask = 0; mask < total; mask++) {
      List<int> sub = [];
      for (int i = 0; i < n; i++) {
        if ((mask & (1 << i)) != 0) sub.add(nums[i]);
      }
      sub.sort();
      unique.add(sub.join(','));
    }
    return unique.length;
  }

  void _handlePracticeChoice(String choice, int elemVal, int elemIdx) {
    if (_practiceSolved) return;

    final targetTotal = _calculateUniqueSubsetsCount(_nums);

    setState(() {
      if (choice == "include") {
        _practiceCurrentSubset.add(elemVal);
        _practiceHistory.add("INCLUDE $elemVal");
        _userFeedbackEn = "✅ Included $elemVal! Subset = [${_practiceCurrentSubset.join(', ')}].";
        _userFeedbackBn = "✅ $elemVal গ্রহণ করা হলো! Subset = [${_practiceCurrentSubset.join(', ')}]।";
      } else if (choice == "skip") {
        _practiceHistory.add("SKIP DUPLICATE $elemVal");
        _userFeedbackEn = "🛑 Skipped Duplicate $elemVal! Maintained unique subsets.";
        _userFeedbackBn = "🛑 ডুপ্লিকেট $elemVal স্কিপ করা হলো! অনন্য সাবসেট বজায় থাকলো।";
      }

      // Check if current subset is new unique
      List<int> copy = List.from(_practiceCurrentSubset);
      copy.sort();
      bool exists = _practiceResults.any((s) => s.join(',') == copy.join(','));

      if (!exists) {
        _practiceResults.add(copy);
        _userFeedbackEn = "🎉 Unique Subset [${copy.join(', ')}] Saved! (${_practiceResults.length} / $targetTotal)";
        _userFeedbackBn = "🎉 অনন্য সাবসেট [${copy.join(', ')}] সংরক্ষিত! (${_practiceResults.length} / $targetTotal)";
      }

      if (_practiceResults.length >= targetTotal) {
        _practiceSolved = true;
        _userFeedbackEn = "🏆 MASTERED! You generated all $targetTotal unique subsets for array [${_nums.join(', ')}]!";
        _userFeedbackBn = "🏆 দারুণ! আপনি অ্যাররে [${_nums.join(', ')}] এর সবকটি $targetTotal টি অনন্য সাবসেট বানিয়ে ফেলেছেন!";
      }
    });
  }

  void _undoPracticeMove() {
    if (_practiceHistory.isNotEmpty) {
      setState(() {
        final lastMove = _practiceHistory.removeLast();
        if (lastMove.startsWith("INCLUDE") && _practiceCurrentSubset.isNotEmpty) {
          _practiceCurrentSubset.removeLast();
        }
        _userFeedbackEn = "↩️ Undid last move. Current Subset = [${_practiceCurrentSubset.join(', ')}].";
        _userFeedbackBn = "↩️ পূর্ববর্তী ধাপ বাতিল করা হলো। Current Subset = [${_practiceCurrentSubset.join(', ')}]।";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final hPadding = Responsive.horizontalPadding(context);

    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      appBar: AppBar(
        title: Text(
          '90. Subsets II',
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
                    "90. Subsets II",
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
              children: ["Meta", "Amazon", "Microsoft", "Google", "Apple", "Uber"].map((company) {
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
                        ? "Given an integer array nums that may contain duplicates, return all possible subsets (the power set). The solution set must not contain duplicate subsets. Return the solution in any order."
                        : "ডুপ্লিকেট সংখ্যা ধারণকারী একটি পূর্ণসংখ্যার অ্যাররে nums দেওয়া আছে। সমস্ত অনন্য সাবসেট (Power Set) রিটার্ন করুন। সমাধান সেটে কোনো ডুপ্লিকেট সাবসেট থাকা যাবে না।",
                    style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Examples
            Text(_isEnglish ? "Examples" : "উদাহরণসমূহ", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            _buildExampleCard("Example 1", "nums = [1,2,2]", "Output: [[],[1],[1,2],[1,2,2],[2],[2,2]]"),
            _buildExampleCard("Example 2", "nums = [0]", "Output: [[],[0]]"),
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
                        _isEnglish ? "Key Intuition (Sort + Duplicate Skipping Rule)" : "মূল আইডিয়া (সর্টিং + ডুপ্লিকেট স্কিপিং নিয়ম)",
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isEnglish
                        ? "1. Sort the input array first so duplicate elements become adjacent ([1, 2, 2]).\n2. At the same recursion depth, skip repeated elements: if (i > start && nums[i] == nums[i-1]) continue;."
                        : "১. অ্যাররে প্রথমে সর্ট করুন যাতে একই সংখ্যাগুলো পাশাপাশি থাকে ([1, 2, 2])।\n২. একই রিকার্সন লেভেলে পুনরাবৃত্ত উপাদান বাদ দিন: if (i > start && nums[i] == nums[i-1]) continue।",
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
              _isEnglish ? "Subsets II Visual Models (Concept Explanations)" : "সাবসেট II ভিজ্যুয়াল মডেলসমূহ (কোডহীন গাইড)",
              style: TextStyle(fontSize: Responsive.sp(context, 18), fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 6),
            Text(
              _isEnglish
                  ? "Explore 3 interactive models for array nums = [1, 2, 2]."
                  : "অ্যাররে nums = [1, 2, 2] এর জন্য ৩টি ইন্টারঅ্যাক্টিভ ভিজ্যুয়াল মডেল পর্যবেক্ষণ করুন।",
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 16),

            // Model Switcher Segmented Control
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildAnimationModelChip(0, _isEnglish ? "1. 🪜 Step Flowcard" : "১. 🪜 স্টেপ-বাই-স্টেপ ফ্লো-কার্ড"),
                  _buildAnimationModelChip(1, _isEnglish ? "2. 🛑 Duplicate Pruning Rule" : "২. 🛑 ডুপ্লিকেট স্কিপিং নিয়ম"),
                  _buildAnimationModelChip(2, _isEnglish ? "3. 📊 Unique Subsets Count" : "৩. 📊 অনন্য সাবসেট সংখ্যা"),
                ],
              ),
            ),
            const SizedBox(height: 20),

            if (_animationModelIndex == 0) _buildStepFlowcardModel(),
            if (_animationModelIndex == 1) _buildDuplicatePruningModel(),
            if (_animationModelIndex == 2) _buildSubsetsCountModel(),

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
        "subset": [],
        "idx": 0,
        "badge": "INIT & SAVE []",
        "badgeColor": AppTheme.accentNeonCyan,
        "titleEn": "Step 1: Start at index 0 ➔ Save Empty Subset []",
        "titleBn": "ধাপ ১: ইনডেক্স ০ দিয়ে শুরু ➔ ফাঁকা সাবসেট [] সংরক্ষিত",
        "descEn": "Sorted array [1, 2, 2]. Empty subset [] saved. Next: Include '1'.",
        "descBn": "সর্টেড অ্যাররে [1, 2, 2]। ফাঁকা সাবসেট [] সংরক্ষিত। পরবর্তী: '1' গ্রহণ।",
      },
      {
        "step": 2,
        "subset": [1],
        "idx": 0,
        "badge": "INCLUDE '1'",
        "badgeColor": AppTheme.accentAmber,
        "titleEn": "Step 2: Include '1' at index 0 ➔ Saved [1]",
        "titleBn": "ধাপ ২: ইনডেক্স ০ এর '1' গ্রহণ ➔ [1] সংরক্ষিত",
        "descEn": "Subset becomes [1]. Saved [1]. Next: Include first '2' at index 1.",
        "descBn": "Subset হলো [1]। [1] সংরক্ষিত। পরবর্তী: প্রথম '2' গ্রহণ।",
      },
      {
        "step": 3,
        "subset": [1, 2],
        "idx": 1,
        "badge": "INCLUDE '2'",
        "badgeColor": AppTheme.accentAmber,
        "titleEn": "Step 3: Include first '2' at index 1 ➔ Saved [1, 2]",
        "titleBn": "ধাপ ৩: প্রথম '2' গ্রহণ ➔ [1, 2] সংরক্ষিত",
        "descEn": "Subset = [1, 2]. Saved [1, 2]. Next: Include second '2' at index 2.",
        "descBn": "Subset = [1, 2]। [1, 2] সংরক্ষিত। পরবর্তী: দ্বিতীয় '2' গ্রহণ।",
      },
      {
        "step": 4,
        "subset": [1, 2, 2],
        "idx": 2,
        "badge": "INCLUDE '2'",
        "badgeColor": AppTheme.accentAmber,
        "titleEn": "Step 4: Include second '2' at index 2 ➔ Saved [1, 2, 2]",
        "titleBn": "ধাপ ৪: দ্বিতীয় '2' গ্রহণ ➔ [1, 2, 2] সংরক্ষিত",
        "descEn": "Subset = [1, 2, 2]. Saved [1, 2, 2]. End of branch.",
        "descBn": "Subset = [1, 2, 2]। [1, 2, 2] সংরক্ষিত। ডালের শেষ প্রান্ত।",
      },
      {
        "step": 5,
        "subset": [2],
        "idx": 1,
        "badge": "INCLUDE '2'",
        "badgeColor": AppTheme.accentPurple,
        "titleEn": "Step 5: Backtrack & Include first '2' at index 1 ➔ Saved [2]",
        "titleBn": "ধাপ ৫: ব্যাকট্র্যাক ও প্রথম '2' গ্রহণ ➔ [2] সংরক্ষিত",
        "descEn": "Subset = [2]. Saved [2]. Next: Check index 2 (second '2').",
        "descBn": "Subset = [2]। [2] সংরক্ষিত। পরবর্তী: ইনডেক্স ২ চেক।",
      },
      {
        "step": 6,
        "subset": [2],
        "idx": 2,
        "badge": "🛑 SKIP DUPLICATE",
        "badgeColor": AppTheme.accentPink,
        "titleEn": "Step 6: Skip Duplicate '2' at index 2!",
        "titleBn": "ধাপ ৬: ইনডেক্স ২ এ ডুপ্লিকেট '2' বাদ দেওয়া হলো!",
        "descEn": "i > start && nums[2] == nums[1] ('2' == '2'). Skipped duplicate [2] branch!",
        "descBn": "i > start এবং nums[2] == nums[1]। ডুপ্লিকেট [2] ব্রাঞ্চ বাদ দেওয়া হলো!",
      },
      {
        "step": 7,
        "subset": [],
        "idx": 3,
        "badge": "🏆 FINISHED",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 7: Traversal Complete! Total 6 Unique Subsets",
        "titleBn": "ধাপ ৭: ব্যাকট্র্যাকিং সম্পূর্ণ! মোট ৬টি অনন্য সাবসেট",
        "descEn": "Generated 6 unique subsets: [[], [1], [1, 2], [1, 2, 2], [2], [2, 2]]!",
        "descBn": "মোট ৬টি অনন্য সাবসেট তৈরি সম্পন্ন: [[], [1], [1, 2], [1, 2, 2], [2], [2, 2]]!",
      },
    ];

    final currentStep = stepFlowData[_flowStepIndex.clamp(0, stepFlowData.length - 1)];
    final List<int> currentSubset = (currentStep["subset"] as List).cast<int>();
    final int currentIdx = currentStep["idx"] as int;
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
                _isEnglish ? "1. Step-by-Step Subsets II Flowcard" : "১. স্টেপ-বাই-স্টেপ সাবসেট II ফ্লো-কার্ড",
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
                ? "Watch how duplicate subsets are pruned at the same recursion depth."
                : "একই রিকার্সন লেভেলে কীভাবে ডুপ্লিকেট সাবসেট ছাঁটাই হয় তা দেখুন।",
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

                // Active Index & Subset Canvas Box
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Index: $currentIdx", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
                    Text("Subset Size: ${currentSubset.length}", style: const TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 12)),
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
                    "[ ${currentSubset.join(' , ')} ]",
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

  // MODEL 2: Duplicate Pruning Rule
  Widget _buildDuplicatePruningModel() {
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
            _isEnglish ? "2. Duplicate Pruning Condition (i > start && nums[i] == nums[i-1])" : "২. ডুপ্লিকেট স্কিপিং কন্ডিশন (i > start && nums[i] == nums[i-1])",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            _isEnglish
                ? "At the same loop level, if an element equals its predecessor, skip it to prevent duplicate subsets."
                : "একই লুপ লেভেলে যদি একটি উপাদান পূর্বের উপাদানের সমান হয়, ডুপ্লিকেট এড়াতে তা বাদ দিন।",
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.accentPink),
            ),
            child: const Text(
              "if (i > start && nums[i] == nums[i-1]) continue; 🛑",
              style: TextStyle(fontFamily: 'monospace', fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.accentPink),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  // MODEL 3: Unique Subsets Count
  Widget _buildSubsetsCountModel() {
    int totalUnique = _calculateUniqueSubsetsCount(_nums);

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
            _isEnglish ? "3. Standard Power Set (2^n) vs Unique Subsets Count" : "৩. সাধারণ পাওয়ার সেট (2^n) বনাম অনন্য সাবসেট সংখ্যা",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            _isEnglish
                ? "Standard 2^n for n=3 is 8 subsets, but due to duplicate '2's, total unique subsets = 6."
                : "n=3 এর জন্য 2^n = 8 টি সাবসেট পাওয়ার কথা, কিন্তু ডুপ্লিকেটের কারণে মোট অনন্য সাবসেট = 6।",
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
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
            child: Text(
              "Array [1, 2, 2] ➔ Total $totalUnique Unique Subsets 🎉",
              style: const TextStyle(fontFamily: 'monospace', fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.accentGreen),
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
                      child: TextField(
                        controller: _inputController,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          labelText: _isEnglish ? "Custom Array with Duplicates (e.g. 1, 2, 2)" : "ডুপ্লিকেটসহ কাস্টম অ্যাররে (যেমন 1, 2, 2)",
                          labelStyle: const TextStyle(color: AppTheme.accentNeonCyan, fontSize: 12),
                          filled: true,
                          fillColor: const Color(0xFF090D16),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentNeonCyan,
                        foregroundColor: AppTheme.primaryDark,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                      _buildPresetChip("1, 2, 2"),
                      _buildPresetChip("2, 2, 2"),
                      _buildPresetChip("1, 2, 3"),
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
                  _buildSubsetsIICanvas(step),
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildCodeHighlightBox(step.activeLine)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildSubsetsIICanvas(step)),
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
    final targetTotal = _calculateUniqueSubsetsCount(_nums);

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
                  ? "Build all $targetTotal unique subsets for array [${_nums.join(', ')}] by deciding to INCLUDE or SKIP elements!"
                  : "অ্যাররে [${_nums.join(', ')}] এর জন্য সবকটি $targetTotal টি অনন্য সাবসেট তৈরি করতে উপাদানINCLUDE বা SKIP করুন!",
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 16),

            // Progress Score Bar
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.accentNeonCyan.withOpacity(0.4)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _isEnglish ? "Discovered: ${_practiceResults.length} / $targetTotal Subsets" : "সংগৃহীত: ${_practiceResults.length} / $targetTotal টি সাবসেট",
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      Text(
                        "${((_practiceResults.length / targetTotal) * 100).clamp(0, 100).toInt()}%",
                        style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: targetTotal == 0 ? 0.0 : (_practiceResults.length / targetTotal).clamp(0.0, 1.0),
                      backgroundColor: AppTheme.primaryDark,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.accentGreen),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
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

            // Current Subset Box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
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
                      const Text("Active Subset:", style: TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 12)),
                      Text("Array = [${_nums.join(', ')}]", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "[ ${_practiceCurrentSubset.join(' , ')} ]",
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.accentNeonCyan,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Action Choice Buttons
            if (!_practiceSolved) ...[
              Text(
                _isEnglish ? "Choose action for next element in array:" : "অ্যাররের পরবর্তী উপাদানের জন্য অ্যাকশন বেছে নিন:",
                style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: List.generate(_nums.length, (idx) {
                  int val = _nums[idx];
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.accentGreen,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        ),
                        onPressed: () => _handlePracticeChoice("include", val, idx),
                        child: Text("Include '$val'", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 4),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.accentPink,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        ),
                        onPressed: () => _handlePracticeChoice("skip", val, idx),
                        child: Text("Skip '$val'", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  );
                }),
              ),
              const SizedBox(height: 10),
              if (_practiceHistory.isNotEmpty)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    icon: const Icon(Icons.undo, size: 16, color: AppTheme.accentAmber),
                    label: Text(_isEnglish ? "Undo Move" : "ধাপ বাতিল", style: const TextStyle(color: AppTheme.accentAmber, fontSize: 12)),
                    onPressed: _undoPracticeMove,
                  ),
                ),
            ],

            const SizedBox(height: 20),

            // Discovered Subsets List
            Text(
              _isEnglish
                  ? "Collected Unique Subsets (${_practiceResults.length} / $targetTotal):"
                  : "সংগৃহীত অনন্য সাবসেটসমূহ (${_practiceResults.length} / $targetTotal):",
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF090D16),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF1E293B)),
              ),
              child: _practiceResults.isEmpty
                ? const Text("[ No Unique Subsets Collected Yet ]", style: TextStyle(color: AppTheme.textMuted, fontSize: 12))
                : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _practiceResults.map((sub) {
                      return Chip(
                        backgroundColor: AppTheme.surfaceDark,
                        avatar: const Icon(Icons.check_circle, color: AppTheme.accentGreen, size: 16),
                        label: Text(
                          "[ ${sub.join(', ')} ]",
                          style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      );
                    }).toList(),
                  ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // Helper Widgets
  Widget _buildPresetChip(String val) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ActionChip(
        backgroundColor: const Color(0xFF090D16),
        label: Text("[$val]", style: const TextStyle(color: AppTheme.accentNeonCyan, fontSize: 11)),
        onPressed: () {
          _inputController.text = val;
          _rebuildSteps();
        },
      ),
    );
  }

  Widget _buildCodeHighlightBox(int activeLine) {
    final codeLines = [
      "void backtrack(int start, vector<int>& nums, vector<int>& subset, vector<vector<int>>& res) {",
      "    res.push_back(subset); // Save every state",
      "    for (int i = start; i < nums.size(); i++) {",
      "        // Skip duplicate elements at same recursion depth",
      "        if (i > start && nums[i] == nums[i-1]) continue;",
      "        subset.push_back(nums[i]);",
      "        backtrack(i + 1, nums, subset, res);",
      "        subset.pop_back(); // Backtrack",
      "    }",
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

  Widget _buildSubsetsIICanvas(SubsetsIIStep step) {
    Color decisionColor = AppTheme.accentPurple;
    String decisionLabel = "INIT";

    if (step.decision == "include_elem") {
      decisionColor = AppTheme.accentAmber;
      decisionLabel = "➕ INCLUDE";
    } else if (step.decision == "skip_duplicate") {
      decisionColor = AppTheme.accentPink;
      decisionLabel = "🛑 SKIP DUPLICATE";
    } else if (step.decision == "save_subset") {
      decisionColor = AppTheme.accentGreen;
      decisionLabel = "🎉 SUBSET SAVED";
    } else if (step.decision == "backtrack") {
      decisionColor = AppTheme.accentAmber;
      decisionLabel = "↩️ BACKTRACK";
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
              Text("start = [${step.startIndex}], i = [${step.currentIndex}]", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13)),
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

          // Current Subset Display Box
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Sorted nums: [${_nums.join(', ')}]", style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
              Text("Subset Size: ${step.currentSubset.length}", style: const TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 12)),
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
            child: Text(
              "[ ${step.currentSubset.join(' , ')} ]",
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: decisionColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),

          // Saved Unique Subsets List
          const Text("Saved Unique Subsets:", style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 80, maxHeight: 180),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF1E293B)),
            ),
            child: step.allSubsets.isEmpty
                ? const Center(child: Text("[ No Subsets Saved Yet ]", style: TextStyle(color: AppTheme.textMuted, fontSize: 12)))
                : SingleChildScrollView(
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: step.allSubsets.map((sub) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppTheme.accentGreen.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppTheme.accentGreen),
                          ),
                          child: Text(
                            "[ ${sub.join(', ')} ]",
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        );
                      }).toList(),
                    ),
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
    void backtrack(int start, vector<int>& nums, vector<int>& subset, vector<vector<int>>& res) {
        res.push_back(subset);
        for (int i = start; i < nums.size(); i++) {
            if (i > start && nums[i] == nums[i - 1]) continue; // Skip duplicate
            subset.push_back(nums[i]);
            backtrack(i + 1, nums, subset, res);
            subset.pop_back();
        }
    }

    vector<vector<int>> subsetsWithDup(vector<int>& nums) {
        sort(nums.begin(), nums.end()); // Sort first!
        vector<vector<int>> res;
        vector<int> subset;
        backtrack(0, nums, subset, res);
        return res;
    }
};""";
    } else if (lang == "Java") {
      code = """
class Solution {
    public List<List<Integer>> subsetsWithDup(int[] nums) {
        Arrays.sort(nums); // Sort first!
        List<List<Integer>> res = new ArrayList<>();
        backtrack(0, nums, new ArrayList<>(), res);
        return res;
    }

    private void backtrack(int start, int[] nums, List<Integer> subset, List<List<Integer>> res) {
        res.add(new ArrayList<>(subset));
        for (int i = start; i < nums.length; i++) {
            if (i > start && nums[i] == nums[i - 1]) continue;
            subset.add(nums[i]);
            backtrack(i + 1, nums, subset, res);
            subset.remove(subset.size() - 1);
        }
    }
}""";
    } else {
      code = """
class Solution:
    def subsetsWithDup(self, nums: List[int]) -> List[List[int]]:
        nums.sort() # Sort first!
        res = []

        def backtrack(start, subset):
            res.append(list(subset))
            for i in range(start, len(nums)):
                if i > start and nums[i] == nums[i - 1]:
                    continue
                subset.append(nums[i])
                backtrack(i + 1, subset)
                subset.pop()

        backtrack(0, [])
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
