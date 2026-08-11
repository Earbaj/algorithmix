import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class PermutationsStep {
  final int startIndex;
  final int swapIndex;
  final List<int> currentNums;
  final List<List<int>> allPermutations;
  final String decision; // 'init', 'swap_forward', 'base_case', 'swap_backtrack'
  final int activeLine;
  final String actionEn;
  final String actionBn;
  final String reasonEn;
  final String reasonBn;
  final int callStackDepth;

  const PermutationsStep({
    required this.startIndex,
    required this.swapIndex,
    required this.currentNums,
    required this.allPermutations,
    required this.decision,
    required this.activeLine,
    required this.actionEn,
    required this.actionBn,
    required this.reasonEn,
    required this.reasonBn,
    required this.callStackDepth,
  });
}

class PermutationsDetailScreen extends StatefulWidget {
  const PermutationsDetailScreen({super.key});

  @override
  State<PermutationsDetailScreen> createState() => _PermutationsDetailScreenState();
}

class _PermutationsDetailScreenState extends State<PermutationsDetailScreen>
    with SingleTickerProviderStateMixin {
  bool _isEnglish = true;
  late TabController _tabController;

  // Custom Input State
  final TextEditingController _inputController = TextEditingController(text: "1, 2, 3");
  List<int> _nums = [1, 2, 3];
  List<PermutationsStep> _steps = [];

  // Playback Control
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  // Code Language Selector
  String _selectedCodeLang = "C++";

  // Tab 2 Animation Model Selector (0: Step Flowcard, 1: Swap Canvas, 2: Factorial Counter)
  int _animationModelIndex = 0;
  int _flowStepIndex = 0;

  // Practice Mode State
  int _practiceStart = 0;
  List<int> _practiceCurrentNums = [1, 2, 3];
  List<List<int>> _practiceResults = [];
  List<String> _practiceHistory = [];
  String _userFeedbackEn = "Tap elements to swap with active index to form permutations!";
  String _userFeedbackBn = "অ্যাক্টিভ ইনডেক্সের সাথে অন্যান্য উপাদান অদলবদল (swap) করে বিন্যাস তৈরি করুন!";
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
      if (parsed.isEmpty) parsed = [1, 2, 3];
      if (parsed.length > 4) parsed = parsed.sublist(0, 4); // Limit for clean step visualization
      _nums = parsed;
    } catch (_) {
      _nums = [1, 2, 3];
    }

    _steps = _generateSteps(_nums);

    // Reset practice mode
    _practiceStart = 0;
    _practiceCurrentNums = List.from(_nums);
    _practiceResults = [];
    _practiceHistory = [];
    _practiceSolved = false;
    _userFeedbackEn = "Tap elements to swap with active index to form permutations!";
    _userFeedbackBn = "অ্যাক্টিভ ইনডেক্সের সাথে অন্যান্য উপাদান অদলবদল (swap) করে বিন্যাস তৈরি করুন!";
  }

  List<PermutationsStep> _generateSteps(List<int> inputNums) {
    List<PermutationsStep> steps = [];
    List<List<int>> results = [];
    List<int> arr = List.from(inputNums);

    // Step 0: Init
    steps.add(PermutationsStep(
      startIndex: 0,
      swapIndex: 0,
      currentNums: List.from(arr),
      allPermutations: [],
      decision: "init",
      activeLine: 1,
      actionEn: "Line 1: Initialize backtracking swap for array [${arr.join(', ')}].",
      actionBn: "লাইন ১: অ্যাররে [${arr.join(', ')}] এর জন্য ব্যাকট্র্যাক সোয়াপ শুরু।",
      reasonEn: "We will swap start index with every element i >= start to explore all n! permutations.",
      reasonBn: "সমস্ত n! বিন্যাস অনুসন্ধানে start ইনডেক্সকে প্রতিটি উপাদান i এর সাথে অদলবদল করা হবে।",
      callStackDepth: 0,
    ));

    void swap(int i, int j) {
      int temp = arr[i];
      arr[i] = arr[j];
      arr[j] = temp;
    }

    void backtrack(int start, int depth) {
      if (start == arr.length) {
        results.add(List.from(arr));
        steps.add(PermutationsStep(
          startIndex: start - 1,
          swapIndex: start - 1,
          currentNums: List.from(arr),
          allPermutations: List.from(results),
          decision: "base_case",
          activeLine: 3,
          actionEn: "🎉 Line 3: Base Case Reached! Saved valid permutation [${arr.join(', ')}].",
          actionBn: "🎉 লাইন ৩: বেস কেস অর্জিত! বিন্যাস [${arr.join(', ')}] সংরক্ষিত।",
          reasonEn: "start == nums.size(). A full valid permutation formed.",
          reasonBn: "start == nums.size()। একটি সম্পূর্ণ সঠিক বিন্যাস তৈরি সম্পন্ন।",
          callStackDepth: depth,
        ));
        return;
      }

      for (int i = start; i < arr.length; i++) {
        // Swap forward
        swap(start, i);
        steps.add(PermutationsStep(
          startIndex: start,
          swapIndex: i,
          currentNums: List.from(arr),
          allPermutations: List.from(results),
          decision: "swap_forward",
          activeLine: 7,
          actionEn: "Line 7: Swap index $start with index $i ➔ Array = [${arr.join(', ')}].",
          actionBn: "লাইন ৭: ইনডেক্স $start এর সাথে ইনডেক্স $i সোয়াপ ➔ Array = [${arr.join(', ')}]।",
          reasonEn: "Fix element at index $start and recurse for remaining subproblem start + 1.",
          reasonBn: "ইনডেক্স $start এর উপাদান নির্ধারণ করে পরবর্তী subproblem start + 1 এ রিকার্সন চালাও।",
          callStackDepth: depth + 1,
        ));

        backtrack(start + 1, depth + 1);

        // Swap back (Backtrack)
        swap(start, i);
        steps.add(PermutationsStep(
          startIndex: start,
          swapIndex: i,
          currentNums: List.from(arr),
          allPermutations: List.from(results),
          decision: "swap_backtrack",
          activeLine: 9,
          actionEn: "Line 9: Backtrack ↩️ Swap back index $start & $i ➔ Restored [${arr.join(', ')}].",
          actionBn: "লাইন ৯: ব্যাকট্র্যাক ↩️ ইনডেক্স $start ও $i সোয়াপ ব্যাক ➔ পুনর্বহাল [${arr.join(', ')}]।",
          reasonEn: "Restore original order so next iteration can make clean swaps.",
          reasonBn: "পূর্বের অবস্থা পুনর্বহাল করো যাতে পরবর্তী ইটারেশন সঠিক সোয়াপ করতে পারে।",
          callStackDepth: depth,
        ));
      }
    }

    backtrack(0, 0);

    // Final Step
    steps.add(PermutationsStep(
      startIndex: arr.length - 1,
      swapIndex: arr.length - 1,
      currentNums: List.from(arr),
      allPermutations: List.from(results),
      decision: "base_case",
      activeLine: 11,
      actionEn: "🎉 Line 11: Backtracking Complete! Generated total ${results.length} permutations!",
      actionBn: "🎉 লাইন ১১: ব্যাকট্র্যাকিং সম্পূর্ণ! মোট ${results.length} টি বিন্যাস জেনারেট সম্পন্ন!",
      reasonEn: "All factorial permutation branches fully traversed.",
      reasonBn: "সমস্ত ফ্যাক্টরিয়াল পারমিউটেশন ডালপালা পরীক্ষা সম্পন্ন হয়েছে।",
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

  int _factorial(int n) {
    if (n <= 1) return 1;
    int res = 1;
    for (int i = 2; i <= n; i++) res *= i;
    return res;
  }

  void _handlePracticeSwap(int targetIndex) {
    if (_practiceSolved || _practiceStart >= _practiceCurrentNums.length) return;

    final totalPerms = _factorial(_nums.length);

    setState(() {
      // Swap elements in practice array
      int temp = _practiceCurrentNums[_practiceStart];
      _practiceCurrentNums[_practiceStart] = _practiceCurrentNums[targetIndex];
      _practiceCurrentNums[targetIndex] = temp;

      _practiceHistory.add("SWAP ($_practiceStart, $targetIndex)");
      _practiceStart++;

      if (_practiceStart == _practiceCurrentNums.length) {
        List<int> perm = List.from(_practiceCurrentNums);
        bool exists = _practiceResults.any((p) => p.join(',') == perm.join(','));

        if (!exists) {
          _practiceResults.add(perm);
          _userFeedbackEn = "🎉 Permutation [${perm.join(', ')}] Saved! (${_practiceResults.length} / $totalPerms)";
          _userFeedbackBn = "🎉 বিন্যাস [${perm.join(', ')}] সংরক্ষিত! (${_practiceResults.length} / $totalPerms)";
        } else {
          _userFeedbackEn = "ℹ️ Permutation [${perm.join(', ')}] was already collected. Try another swap!";
          _userFeedbackBn = "ℹ️ বিন্যাস [${perm.join(', ')}] ইতিমধ্যেই সংগৃহীত হয়েছে। অন্য সোয়াপ চেষ্টা করুন!";
        }

        // Reset for next permutation
        _practiceStart = 0;
        _practiceCurrentNums = List.from(_nums);

        if (_practiceResults.length >= totalPerms) {
          _practiceSolved = true;
          _userFeedbackEn = "🏆 MASTERED! You generated all $totalPerms permutations!";
          _userFeedbackBn = "🏆 দারুণ! আপনি সবকটি $totalPerms টি বিন্যাস বানিয়ে ফেলেছেন!";
        }
      } else {
        _userFeedbackEn = "✅ Swapped! Next: Select swap for start index $_practiceStart.";
        _userFeedbackBn = "✅ সোয়াপ সম্পন্ন! পরবর্তী: ইনডেক্স $_practiceStart এর জন্য উপাদান বেছে নিন।";
      }
    });
  }

  void _undoPracticeMove() {
    if (_practiceHistory.isNotEmpty && _practiceStart > 0) {
      setState(() {
        _practiceHistory.removeLast();
        _practiceStart--;
        _practiceCurrentNums = List.from(_nums);
        _userFeedbackEn = "↩️ Undid last swap move. Array = [${_practiceCurrentNums.join(', ')}].";
        _userFeedbackBn = "↩️ পূর্ববর্তী সোয়াপ ধাপ বাতিল করা হলো। Array = [${_practiceCurrentNums.join(', ')}]।";
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
          '46. Permutations',
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
                    "46. Permutations",
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
                        ? "Given an array nums of distinct integers, return all the possible permutations. You can return the answer in any order."
                        : "বিভিন্ন পূর্ণসংখ্যার একটি অ্যাররে nums দেওয়া আছে। সমস্ত সম্ভাব্য বিন্যাস (Permutations) রিটার্ন করুন।",
                    style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Examples
            Text(_isEnglish ? "Examples" : "উদাহরণসমূহ", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            _buildExampleCard("Example 1", "nums = [1,2,3]", "Output: [[1,2,3],[1,3,2],[2,1,3],[2,3,1],[3,1,2],[3,2,1]]"),
            _buildExampleCard("Example 2", "nums = [0,1]", "Output: [[0,1],[1,0]]"),
            _buildExampleCard("Example 3", "nums = [1]", "Output: [[1]]"),
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
                        _isEnglish ? "Key Intuition (In-Place Swap & Backtrack)" : "মূল আইডিয়া (ইন-প্লেস সোয়াপ ও ব্যাকট্র্যাক)",
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isEnglish
                        ? "At position start, swap nums[start] with every index i >= start. Recurse for start + 1. Then swap back (swap(nums[start], nums[i])) to restore array state for the next candidate!"
                        : "start পজিশনে, nums[start] কে প্রতিটি ইনডেক্স i >= start এর সাথে অদলবদল (swap) করুন। start + 1 এ রিকার্সন শেষে পুনরায় swap ব্যাক করে পূর্বের অবস্হা নিশ্চিত করুন!",
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
              _isEnglish ? "Permutations Visual Models (Concept Explanations)" : "পারমিউটেশন ভিজ্যুয়াল মডেলসমূহ (কোডহীন গাইড)",
              style: TextStyle(fontSize: Responsive.sp(context, 18), fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 6),
            Text(
              _isEnglish
                  ? "Explore 3 interactive models for nums = [1, 2, 3]."
                  : "nums = [1, 2, 3] এর জন্য ৩টি ইন্টারঅ্যাক্টিভ ভিজ্যুয়াল মডেল পর্যবেক্ষণ করুন।",
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 16),

            // Model Switcher Segmented Control
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildAnimationModelChip(0, _isEnglish ? "1. 🪜 Step Flowcard" : "১. 🪜 স্টেপ-বাই-স্টেপ ফ্লো-কার্ড"),
                  _buildAnimationModelChip(1, _isEnglish ? "2. 🔄 In-Place Swap" : "২. 🔄 ইন-প্লেস সোয়াপ ক্যানভাস"),
                  _buildAnimationModelChip(2, _isEnglish ? "3. ❗️ Factorial (n!)" : "৩. ❗️ ফ্যাক্টোরিয়াল (n!) গণনা"),
                ],
              ),
            ),
            const SizedBox(height: 20),

            if (_animationModelIndex == 0) _buildStepFlowcardModel(),
            if (_animationModelIndex == 1) _buildInPlaceSwapModel(),
            if (_animationModelIndex == 2) _buildFactorialModel(),

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
        "arr": [1, 2, 3],
        "start": 0,
        "i": 0,
        "badge": "INIT",
        "badgeColor": AppTheme.accentNeonCyan,
        "titleEn": "Step 1: Start at index 0 (Array = [1, 2, 3])",
        "titleBn": "ধাপ ১: ইনডেক্স ০ দিয়ে শুরু (Array = [1, 2, 3])",
        "descEn": "Initial array [1, 2, 3]. Start index = 0. First swap index 0 with 0.",
        "descBn": "প্রাথমিক অ্যাররে [1, 2, 3]। Start = 0। প্রথমে ইনডেক্স 0 এর সাথে 0 সোয়াপ।",
      },
      {
        "step": 2,
        "arr": [1, 2, 3],
        "start": 1,
        "i": 1,
        "badge": "🔄 SWAP (0, 0)",
        "badgeColor": AppTheme.accentAmber,
        "titleEn": "Step 2: Swap (0, 0) ➔ Move to start = 1",
        "titleBn": "ধাপ ২: সোয়াপ (0, 0) ➔ start = 1 এ স্থানান্তরিত",
        "descEn": "Array stays [1, 2, 3]. Now swap index 1 with index 1.",
        "descBn": "Array একই [1, 2, 3]। এখন ইনডেক্স 1 এর সাথে 1 সোয়াপ।",
      },
      {
        "step": 3,
        "arr": [1, 2, 3],
        "start": 3,
        "i": 2,
        "badge": "🎉 SAVED [1, 2, 3]",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 3: Base Case Reached! Saved [1, 2, 3]",
        "titleBn": "ধাপ ৩: বেস কেস অর্জিত! [1, 2, 3] সংরক্ষিত",
        "descEn": "start == 3 (nums.size()). Saved first valid permutation [1, 2, 3]!",
        "descBn": "start == 3 (nums.size())। প্রথম বিন্যাস [1, 2, 3] সংরক্ষিত!",
      },
      {
        "step": 4,
        "arr": [1, 3, 2],
        "start": 1,
        "i": 2,
        "badge": "🔄 SWAP (1, 2)",
        "badgeColor": AppTheme.accentPurple,
        "titleEn": "Step 4: Swap index 1 with 2 ➔ Array = [1, 3, 2]",
        "titleBn": "ধাপ ৪: ইনডেক্স 1 এর সাথে 2 সোয়াপ ➔ Array = [1, 3, 2]",
        "descEn": "Swapped 2 and 3. Array becomes [1, 3, 2]. Saved second permutation [1, 3, 2]!",
        "descBn": "2 ও 3 সোয়াপ। Array হলো [1, 3, 2]। দ্বিতীয় বিন্যাস [1, 3, 2] সংরক্ষিত!",
      },
      {
        "step": 5,
        "arr": [1, 2, 3],
        "start": 1,
        "i": 2,
        "badge": "↩️ BACKTRACK",
        "badgeColor": AppTheme.accentAmber,
        "titleEn": "Step 5: Backtrack ↩️ Swap back (1, 2) ➔ Reverted to [1, 2, 3]",
        "titleBn": "ধাপ ৫: ব্যাকট্র্যাক ↩️ সোয়াপ ব্যাক (1, 2) ➔ পুনর্বহাল [1, 2, 3]",
        "descEn": "Restored array to [1, 2, 3]. Now explore swapping start 0 with index 1.",
        "descBn": "অ্যাররে পুনর্বহাল [1, 2, 3]। এখন start 0 এর সাথে ইনডেক্স 1 সোয়াপ করো।",
      },
      {
        "step": 6,
        "arr": [2, 1, 3],
        "start": 0,
        "i": 1,
        "badge": "🔄 SWAP (0, 1)",
        "badgeColor": AppTheme.accentPurple,
        "titleEn": "Step 6: Swap index 0 with 1 ➔ Array = [2, 1, 3]",
        "titleBn": "ধাপ ৬: ইনডেক্স 0 এর সাথে 1 সোয়াপ ➔ Array = [2, 1, 3]",
        "descEn": "Swapped 1 and 2. Array becomes [2, 1, 3]. Saved third permutation [2, 1, 3]!",
        "descBn": "1 ও 2 সোয়াপ। Array হলো [2, 1, 3]। তৃতীয় বিন্যাস [2, 1, 3] সংরক্ষিত!",
      },
      {
        "step": 7,
        "arr": [3, 2, 1],
        "start": 0,
        "i": 2,
        "badge": "🎉 SAVED [3, 2, 1]",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 7: Swap index 0 with 2 ➔ Saved [3, 2, 1]",
        "titleBn": "ধাপ ৭: ইনডেক্স 0 এর সাথে 2 সোয়াপ ➔ [3, 2, 1] সংরক্ষিত",
        "descEn": "Saved fifth permutation [3, 2, 1]!",
        "descBn": "পঞ্চম বিন্যাস [3, 2, 1] সংরক্ষিত!",
      },
      {
        "step": 8,
        "arr": [1, 2, 3],
        "start": 0,
        "i": 0,
        "badge": "🏆 FINISHED",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 8: Traversal Finished! Total 6 Permutations",
        "titleBn": "ধাপ ৮: ব্যাকট্র্যাকিং সম্পন্ন! মোট ৬টি বিন্যাস",
        "descEn": "Generated total 3! = 6 unique permutations!",
        "descBn": "মোট 3! = 6 টি অনন্য বিন্যাস তৈরি সম্পন্ন!",
      },
    ];

    final currentStep = stepFlowData[_flowStepIndex.clamp(0, stepFlowData.length - 1)];
    final List<int> currentArr = (currentStep["arr"] as List).cast<int>();
    final int startIdx = currentStep["start"] as int;
    final int iIdx = currentStep["i"] as int;
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
                _isEnglish ? "1. Step-by-Step Permutations Flowcard" : "১. স্টেপ-বাই-স্টেপ পারমিউটেশন ফ্লো-কার্ড",
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
                ? "Watch how elements are swapped in-place and backtracked step-by-step."
                : "উপাদানগুলো কীভাবে ইন-প্লেস সোয়াপ ও ব্যাকট্র্যাক হয় তা ধাপে ধাপে পর্যবেক্ষণ করুন।",
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

                // Active Swap Pointer & Array Box
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Swap Pair: ($startIdx, $iIdx)", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
                    Text("Start Index = $startIdx", style: const TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 12)),
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
                    "[ ${currentArr.join(' , ')} ]",
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

  // MODEL 2: In-Place Swap Canvas
  Widget _buildInPlaceSwapModel() {
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
            _isEnglish ? "2. In-Place Array Swap Canvas" : "২. ইন-প্লেস অ্যাররে সোয়াপ ক্যানভাস",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            _isEnglish
                ? "Elements at start index and i index swap positions in memory without extra space O(1)."
                : "বাড়তি কোনো মেমরি O(1) ছাড়াই start এবং i ইনডেক্সের উপাদান অদলবদল হয়।",
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 16),

          // Swap Animation Graphic Box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.accentPurple),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSwapNodeCard("1", "idx: 0", AppTheme.accentAmber),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Icon(Icons.swap_horiz, color: AppTheme.accentNeonCyan, size: 32),
                    ),
                    _buildSwapNodeCard("2", "idx: 1", AppTheme.accentPurple),
                  ],
                ),
                const SizedBox(height: 12),
                const Text("swap(nums[0], nums[1]) ➔ Replaces [1, 2, 3] with [2, 1, 3]", style: TextStyle(color: Colors.white, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwapNodeCard(String val, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 2),
      ),
      child: Column(
        children: [
          Text(val, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
        ],
      ),
    );
  }

  // MODEL 3: Factorial Permutation Counter
  Widget _buildFactorialModel() {
    int total = _factorial(_nums.length);

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
            _isEnglish ? "3. Factorial Permutation Count (n!)" : "৩. ফ্যাক্টোরিয়াল বিন্যাস সংখ্যা (n!)",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            _isEnglish
                ? "For n distinct elements, the total number of unique permutations is given by n! = n × (n-1) × ... × 1."
                : "n টি বিভিন্ন উপাদানের জন্য মোট বিন্যাস সংখ্যা n! সূত্র দ্বারা নির্ধারিত হয়।",
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
              "Array Length n = ${_nums.length} ➔ ${_nums.length}! = $total Unique Permutations 🎉",
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
                          labelText: _isEnglish ? "Custom Array (e.g. 1, 2, 3)" : "কাস্টম অ্যাররে (যেমন 1, 2, 3)",
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
                      _buildPresetChip("1, 2"),
                      _buildPresetChip("1, 2, 3"),
                      _buildPresetChip("1, 2, 3, 4"),
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
                  _buildPermutationsCanvas(step),
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildCodeHighlightBox(step.activeLine)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildPermutationsCanvas(step)),
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
    final totalPerms = _factorial(_nums.length);

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
                  ? "Build all $totalPerms permutations for array [${_nums.join(', ')}] by choosing swap elements!"
                  : "অ্যাররে [${_nums.join(', ')}] এর জন্য সবকটি $totalPerms টি বিন্যাস তৈরি করতে সোয়াপ উপাদান বেছে নিন!",
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
                        _isEnglish ? "Discovered: ${_practiceResults.length} / $totalPerms Permutations" : "সংগৃহীত: ${_practiceResults.length} / $totalPerms টি বিন্যাস",
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      Text(
                        "${((_practiceResults.length / totalPerms) * 100).clamp(0, 100).toInt()}%",
                        style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: totalPerms == 0 ? 0.0 : (_practiceResults.length / totalPerms).clamp(0.0, 1.0),
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

            // Current Array Box
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
                      Text("Active Start Index: $_practiceStart / ${_nums.length}", style: const TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 12)),
                      Text("Array Size = ${_nums.length}", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "[ ${_practiceCurrentNums.join(' , ')} ]",
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

            // Swap Buttons
            if (!_practiceSolved && _practiceStart < _practiceCurrentNums.length) ...[
              Text(
                _isEnglish
                    ? "Select index i >= $_practiceStart to swap with start index $_practiceStart:"
                    : "ইনডেক্স $_practiceStart এর সাথে সোয়াপ করতে i >= $_practiceStart নির্বাচন করুন:",
                style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: List.generate(_practiceCurrentNums.length - _practiceStart, (offset) {
                  int targetIdx = _practiceStart + offset;
                  int val = _practiceCurrentNums[targetIdx];
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accentPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    ),
                    onPressed: () => _handlePracticeSwap(targetIdx),
                    child: Text("Swap with [$val] (idx: $targetIdx)", style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
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

            // Discovered Permutations List
            Text(
              _isEnglish
                  ? "Collected Permutations (${_practiceResults.length} / $totalPerms):"
                  : "সংগৃহীত বিন্যাসসমূহ (${_practiceResults.length} / $totalPerms):",
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
                ? const Text("[ No Permutations Collected Yet ]", style: TextStyle(color: AppTheme.textMuted, fontSize: 12))
                : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _practiceResults.map((perm) {
                      return Chip(
                        backgroundColor: AppTheme.surfaceDark,
                        avatar: const Icon(Icons.check_circle, color: AppTheme.accentGreen, size: 16),
                        label: Text(
                          "[ ${perm.join(', ')} ]",
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
      "void backtrack(int start, vector<int>& nums, vector<vector<int>>& res) {",
      "    if (start == nums.size()) {",
      "        res.push_back(nums); // Save valid permutation",
      "        return;",
      "    }",
      "    for (int i = start; i < nums.size(); i++) {",
      "        swap(nums[start], nums[i]);",
      "        backtrack(start + 1, nums, res);",
      "        swap(nums[start], nums[i]); // Backtrack swap back",
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

  Widget _buildPermutationsCanvas(PermutationsStep step) {
    Color decisionColor = AppTheme.accentPurple;
    String decisionLabel = "INIT";

    if (step.decision == "swap_forward") {
      decisionColor = AppTheme.accentAmber;
      decisionLabel = "🔄 SWAP (${step.startIndex}, ${step.swapIndex})";
    } else if (step.decision == "swap_backtrack") {
      decisionColor = AppTheme.accentPurple;
      decisionLabel = "↩️ SWAP BACK";
    } else if (step.decision == "base_case") {
      decisionColor = AppTheme.accentGreen;
      decisionLabel = "🎉 PERMUTATION SAVED";
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
              Text("Start Index: [${step.startIndex}]", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13)),
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

          // Current Array Canvas Box
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Swap Pointers: (${step.startIndex}, ${step.swapIndex})", style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
              Text("Array Size: ${step.currentNums.length}", style: const TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 12)),
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
              "[ ${step.currentNums.join(' , ')} ]",
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

          // Saved Permutations List
          const Text("Saved Permutations:", style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
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
            child: step.allPermutations.isEmpty
                ? const Center(child: Text("[ No Permutations Saved Yet ]", style: TextStyle(color: AppTheme.textMuted, fontSize: 12)))
                : SingleChildScrollView(
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: step.allPermutations.map((perm) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppTheme.accentGreen.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppTheme.accentGreen),
                          ),
                          child: Text(
                            "[ ${perm.join(', ')} ]",
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
    void backtrack(int start, vector<int>& nums, vector<vector<int>>& res) {
        if (start == nums.size()) {
            res.push_back(nums);
            return;
        }
        for (int i = start; i < nums.size(); i++) {
            swap(nums[start], nums[i]);
            backtrack(start + 1, nums, res);
            swap(nums[start], nums[i]); // Backtrack swap back
        }
    }

    vector<vector<int>> permute(vector<int>& nums) {
        vector<vector<int>> res;
        backtrack(0, nums, res);
        return res;
    }
};""";
    } else if (lang == "Java") {
      code = """
class Solution {
    public List<List<Integer>> permute(int[] nums) {
        List<List<Integer>> res = new ArrayList<>();
        backtrack(0, nums, res);
        return res;
    }

    private void backtrack(int start, int[] nums, List<List<Integer>> res) {
        if (start == nums.length) {
            List<Integer> list = new ArrayList<>();
            for (int n : nums) list.add(n);
            res.add(list);
            return;
        }
        for (int i = start; i < nums.length; i++) {
            swap(nums, start, i);
            backtrack(start + 1, nums, res);
            swap(nums, start, i);
        }
    }

    private void swap(int[] nums, int i, int j) {
        int temp = nums[i];
        nums[i] = nums[j];
        nums[j] = temp;
    }
}""";
    } else {
      code = """
class Solution:
    def permute(self, nums: List[int]) -> List[List[int]]:
        res = []

        def backtrack(start):
            if start == len(nums):
                res.append(nums[:])
                return
            for i in range(start, len(nums)):
                nums[start], nums[i] = nums[i], nums[start]
                backtrack(start + 1)
                nums[start], nums[i] = nums[i], nums[start]

        backtrack(0)
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
