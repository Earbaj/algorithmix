import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class PermutationsIIStep {
  final int startIndex;
  final int swapIndex;
  final List<int> currentNums;
  final Set<int> visitedAtLevel;
  final List<List<int>> allPermutations;
  final String decision; // 'init', 'swap_forward', 'skip_duplicate_swap', 'base_case', 'swap_backtrack'
  final int activeLine;
  final String actionEn;
  final String actionBn;
  final String reasonEn;
  final String reasonBn;
  final int callStackDepth;

  const PermutationsIIStep({
    required this.startIndex,
    required this.swapIndex,
    required this.currentNums,
    required this.visitedAtLevel,
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

class PermutationsIIDetailScreen extends StatefulWidget {
  const PermutationsIIDetailScreen({super.key});

  @override
  State<PermutationsIIDetailScreen> createState() => _PermutationsIIDetailScreenState();
}

class _PermutationsIIDetailScreenState extends State<PermutationsIIDetailScreen>
    with SingleTickerProviderStateMixin {
  bool _isEnglish = true;
  late TabController _tabController;

  // Custom Input State
  final TextEditingController _inputController = TextEditingController(text: "1, 1, 2");
  List<int> _nums = [1, 1, 2];
  List<PermutationsIIStep> _steps = [];

  // Playback Control
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  // Code Language Selector
  String _selectedCodeLang = "C++";

  // Tab 2 Animation Model Selector (0: Step Flowcard, 1: Level Visited Set, 2: Permutations Count)
  int _animationModelIndex = 0;
  int _flowStepIndex = 0;

  // Practice Mode State
  int _practiceStart = 0;
  List<int> _practiceCurrentNums = [1, 1, 2];
  List<List<int>> _practiceResults = [];
  List<String> _practiceHistory = [];
  String _userFeedbackEn = "Select unique swap elements at active index to form unique permutations!";
  String _userFeedbackBn = "অনন্য বিন্যাস তৈরি করতে অ্যাক্টিভ ইনডেক্সে অনন্য উপাদান সোয়াপ করুন!";
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
      if (parsed.isEmpty) parsed = [1, 1, 2];
      if (parsed.length > 4) parsed = parsed.sublist(0, 4); // Limit for clean visualization
      _nums = parsed;
    } catch (_) {
      _nums = [1, 1, 2];
    }

    _steps = _generateSteps(_nums);

    // Reset practice mode
    _practiceStart = 0;
    _practiceCurrentNums = List.from(_nums);
    _practiceResults = [];
    _practiceHistory = [];
    _practiceSolved = false;
    _userFeedbackEn = "Select unique swap elements at active index to form unique permutations!";
    _userFeedbackBn = "অনন্য বিন্যাস তৈরি করতে অ্যাক্টিভ ইনডেক্সে অনন্য উপাদান সোয়াপ করুন!";
  }

  List<PermutationsIIStep> _generateSteps(List<int> inputNums) {
    List<PermutationsIIStep> steps = [];
    List<List<int>> results = [];
    List<int> arr = List.from(inputNums);

    // Step 0: Init
    steps.add(PermutationsIIStep(
      startIndex: 0,
      swapIndex: 0,
      currentNums: List.from(arr),
      visitedAtLevel: {},
      allPermutations: [],
      decision: "init",
      activeLine: 1,
      actionEn: "Line 1: Initialize Permutations II for array [${arr.join(', ')}].",
      actionBn: "লাইন ১: অ্যাররে [${arr.join(', ')}] এর জন্য Permutations II ব্যাকট্র্যাক শুরু।",
      reasonEn: "We will use a level-wise visited hash set to prevent swapping identical values at position start.",
      reasonBn: "লেভেল-ভিত্তিক ভিজিটেড হ্যাশ সেট ব্যবহার করে পজিশন start এ একই উপাদানের সোয়াপ এড়ানো হবে।",
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
        steps.add(PermutationsIIStep(
          startIndex: start - 1,
          swapIndex: start - 1,
          currentNums: List.from(arr),
          visitedAtLevel: {},
          allPermutations: List.from(results),
          decision: "base_case",
          activeLine: 3,
          actionEn: "🎉 Line 3: Base Case Reached! Saved unique permutation [${arr.join(', ')}].",
          actionBn: "🎉 লাইন ৩: বেস কেস অর্জিত! অনন্য বিন্যাস [${arr.join(', ')}] সংরক্ষিত।",
          reasonEn: "start == nums.size(). A full unique permutation formed.",
          reasonBn: "start == nums.size()। একটি সম্পূর্ণ অনন্য বিন্যাস তৈরি সম্পন্ন।",
          callStackDepth: depth,
        ));
        return;
      }

      Set<int> visitedAtLevel = {};

      for (int i = start; i < arr.length; i++) {
        int val = arr[i];

        // Check level visited set
        if (visitedAtLevel.contains(val)) {
          steps.add(PermutationsIIStep(
            startIndex: start,
            swapIndex: i,
            currentNums: List.from(arr),
            visitedAtLevel: Set.from(visitedAtLevel),
            allPermutations: List.from(results),
            decision: "skip_duplicate_swap",
            activeLine: 7,
            actionEn: "🛑 Line 7: Skip Duplicate Swap of value '$val' at index $i! Already in visited {$visitedAtLevel}.",
            actionBn: "🛑 লাইন ৭: ইনডেক্স $i এর মান '$val' এর ডুপ্লিকেট সোয়াপ বাদ দেওয়া হলো! এটি ইতিমধ্যেই ভিজিটেড।",
            reasonEn: "Value '$val' was already placed at position $start in an earlier loop iteration.",
            reasonBn: "মান '$val' পূর্ববর্তী ইটারেশনে পজিশন $start এ ইতিমধ্যেই বসানো হয়েছে।",
            callStackDepth: depth,
          ));
          continue;
        }

        visitedAtLevel.add(val);

        // Swap forward
        swap(start, i);
        steps.add(PermutationsIIStep(
          startIndex: start,
          swapIndex: i,
          currentNums: List.from(arr),
          visitedAtLevel: Set.from(visitedAtLevel),
          allPermutations: List.from(results),
          decision: "swap_forward",
          activeLine: 9,
          actionEn: "Line 9: Swap index $start with $i ('$val') ➔ Array = [${arr.join(', ')}]. Added '$val' to visited.",
          actionBn: "লাইন ৯: ইনডেক্স $start এর সাথে $i ('$val') সোয়াপ ➔ Array = [${arr.join(', ')}]।",
          reasonEn: "Fix value '$val' at position $start and recurse for start + 1.",
          reasonBn: "পজিশন $start এ মান '$val' নির্ধারণ করে start + 1 এ রিকার্সন চালাও।",
          callStackDepth: depth + 1,
        ));

        backtrack(start + 1, depth + 1);

        // Swap back
        swap(start, i);
        steps.add(PermutationsIIStep(
          startIndex: start,
          swapIndex: i,
          currentNums: List.from(arr),
          visitedAtLevel: Set.from(visitedAtLevel),
          allPermutations: List.from(results),
          decision: "swap_backtrack",
          activeLine: 11,
          actionEn: "Line 11: Backtrack ↩️ Swap back index $start & $i ➔ Restored [${arr.join(', ')}].",
          actionBn: "লাইন ১১: ব্যাকট্র্যাক ↩️ ইনডেক্স $start ও $i সোয়াপ ব্যাক ➔ পুনর্বহাল [${arr.join(', ')}]।",
          reasonEn: "Restore original order for next iteration.",
          reasonBn: "পরবর্তী ইটারেশনের জন্য অবস্হা পুনর্বহাল করো।",
          callStackDepth: depth,
        ));
      }
    }

    backtrack(0, 0);

    // Final Step
    steps.add(PermutationsIIStep(
      startIndex: arr.length - 1,
      swapIndex: arr.length - 1,
      currentNums: List.from(arr),
      visitedAtLevel: {},
      allPermutations: List.from(results),
      decision: "base_case",
      activeLine: 13,
      actionEn: "🎉 Line 13: Backtracking Complete! Generated total ${results.length} unique permutations!",
      actionBn: "🎉 লাইন ১৩: ব্যাকট্র্যাকিং সম্পূর্ণ! মোট ${results.length} টি অনন্য বিন্যাস তৈরি সম্পন্ন!",
      reasonEn: "All unique permutation branches fully traversed.",
      reasonBn: "সমস্ত অনন্য বিন্যাস ডালপালা অনুসন্ধান সম্পন্ন হয়েছে।",
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

  int _calculateUniquePermutationsCount(List<int> inputNums) {
    Set<String> unique = {};

    void swap(List<int> arr, int i, int j) {
      int t = arr[i]; arr[i] = arr[j]; arr[j] = t;
    }

    void bt(List<int> arr, int start) {
      if (start == arr.length) {
        unique.add(arr.join(','));
        return;
      }
      Set<int> vis = {};
      for (int i = start; i < arr.length; i++) {
        if (vis.contains(arr[i])) continue;
        vis.add(arr[i]);
        swap(arr, start, i);
        bt(arr, start + 1);
        swap(arr, start, i);
      }
    }

    bt(List.from(inputNums), 0);
    return unique.length;
  }

  void _handlePracticeSwap(int targetIndex) {
    if (_practiceSolved || _practiceStart >= _practiceCurrentNums.length) return;

    final totalPerms = _calculateUniquePermutationsCount(_nums);

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
          _userFeedbackEn = "🎉 Unique Permutation [${perm.join(', ')}] Saved! (${_practiceResults.length} / $totalPerms)";
          _userFeedbackBn = "🎉 অনন্য বিন্যাস [${perm.join(', ')}] সংরক্ষিত! (${_practiceResults.length} / $totalPerms)";
        } else {
          _userFeedbackEn = "ℹ️ Permutation [${perm.join(', ')}] was already collected. Try another swap!";
          _userFeedbackBn = "ℹ️ বিন্যাস [${perm.join(', ')}] ইতিমধ্যেই সংগৃহীত হয়েছে। অন্য সোয়াপ চেষ্টা করুন!";
        }

        // Reset for next permutation
        _practiceStart = 0;
        _practiceCurrentNums = List.from(_nums);

        if (_practiceResults.length >= totalPerms) {
          _practiceSolved = true;
          _userFeedbackEn = "🏆 MASTERED! You generated all $totalPerms unique permutations for array [${_nums.join(', ')}]!";
          _userFeedbackBn = "🏆 দারুণ! আপনি অ্যাররে [${_nums.join(', ')}] এর সবকটি $totalPerms টি অনন্য বিন্যাস বানিয়ে ফেলেছেন!";
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
          '47. Permutations II',
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
                    "47. Permutations II",
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
                        ? "Given a collection of numbers, nums, that might contain duplicates, return all possible unique permutations in any order."
                        : "ডুপ্লিকেট সংখ্যা ধারণকারী একটি সংগ্রহের অ্যাররে nums দেওয়া আছে। সমস্ত সম্ভাব্য অনন্য বিন্যাস (Unique Permutations) রিটার্ন করুন।",
                    style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Examples
            Text(_isEnglish ? "Examples" : "উদাহরণসমূহ", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            _buildExampleCard("Example 1", "nums = [1,1,2]", "Output: [[1,1,2],[1,2,1],[2,1,1]]"),
            _buildExampleCard("Example 2", "nums = [1,2,3]", "Output: [[1,2,3],[1,3,2],[2,1,3],[2,3,1],[3,1,2],[3,2,1]]"),
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
                        _isEnglish ? "Key Intuition (Level-Set Visited Swap Pruning)" : "মূল আইডিয়া (লেভেল-সেট ভিজিটেড সোয়াপ ছাঁটাই)",
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isEnglish
                        ? "At position start, maintain a visited set for the current loop level. If nums[i] was already swapped at position start (visited.count(nums[i]) > 0), skip it! This guarantees unique output."
                        : "পজিশন start এ, বর্তমান রিকার্সন লেভেলের জন্য একটি ভিজিটেড সেট বজায় রাখুন। পূর্ববর্তী ইটারেশনে পজিশন start এ nums[i] ইতিমধ্যেই বসানো থাকলে তা স্কিপ করুন!",
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
              _isEnglish ? "Permutations II Visual Models (Concept Explanations)" : "পারমিউটেশন II ভিজ্যুয়াল মডেলসমূহ (কোডহীন গাইড)",
              style: TextStyle(fontSize: Responsive.sp(context, 18), fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 6),
            Text(
              _isEnglish
                  ? "Explore 3 interactive models for array nums = [1, 1, 2]."
                  : "অ্যাররে nums = [1, 1, 2] এর জন্য ৩টি ইন্টারঅ্যাক্টিভ ভিজ্যুয়াল মডেল পর্যবেক্ষণ করুন।",
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 16),

            // Model Switcher Segmented Control
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildAnimationModelChip(0, _isEnglish ? "1. 🪜 Step Flowcard" : "১. 🪜 স্টেপ-বাই-স্টেপ ফ্লো-কার্ড"),
                  _buildAnimationModelChip(1, _isEnglish ? "2. 🛑 Level Visited Set" : "২. 🛑 লেভেল ভিজিটেড সেট ক্যানভাস"),
                  _buildAnimationModelChip(2, _isEnglish ? "3. 📊 Unique Permutations Count" : "৩. 📊 অনন্য বিন্যাস সংখ্যা"),
                ],
              ),
            ),
            const SizedBox(height: 20),

            if (_animationModelIndex == 0) _buildStepFlowcardModel(),
            if (_animationModelIndex == 1) _buildLevelVisitedModel(),
            if (_animationModelIndex == 2) _buildPermutationsCountModel(),

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
        "arr": [1, 1, 2],
        "start": 0,
        "i": 0,
        "visited": [1],
        "badge": "INIT & SWAP (0, 0)",
        "badgeColor": AppTheme.accentNeonCyan,
        "titleEn": "Step 1: Start at index 0 (Array = [1, 1, 2]) ➔ Visited = {1}",
        "titleBn": "ধাপ ১: ইনডেক্স ০ দিয়ে শুরু (Array = [1, 1, 2]) ➔ Visited = {1}",
        "descEn": "Swap index 0 with 0 (value 1). Added 1 to level visited set.",
        "descBn": "ইনডেক্স 0 এর সাথে 0 (মান 1) সোয়াপ। লেভেল ভিজিটেড সেটে 1 যুক্ত।",
      },
      {
        "step": 2,
        "arr": [1, 1, 2],
        "start": 2,
        "i": 2,
        "visited": [1, 2],
        "badge": "🎉 SAVED [1, 1, 2]",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 2: Base Case Reached! Saved [1, 1, 2]",
        "titleBn": "ধাপ ২: বেস কেস অর্জিত! [1, 1, 2] সংরক্ষিত",
        "descEn": "Saved first unique permutation [1, 1, 2]!",
        "descBn": "প্রথম অনন্য বিন্যাস [1, 1, 2] সংরক্ষিত!",
      },
      {
        "step": 3,
        "arr": [1, 2, 1],
        "start": 1,
        "i": 2,
        "visited": [1, 2],
        "badge": "🎉 SAVED [1, 2, 1]",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 3: Swap (1, 2) ➔ Saved [1, 2, 1]",
        "titleBn": "ধাপ ৩: সোয়াপ (1, 2) ➔ [1, 2, 1] সংরক্ষিত",
        "descEn": "Saved second unique permutation [1, 2, 1]!",
        "descBn": "দ্বিতীয় অনন্য বিন্যাস [1, 2, 1] সংরক্ষিত!",
      },
      {
        "step": 4,
        "arr": [1, 1, 2],
        "start": 0,
        "i": 1,
        "visited": [1],
        "badge": "🛑 SKIP DUPLICATE SWAP",
        "badgeColor": AppTheme.accentPink,
        "titleEn": "Step 4: Skip Swap at index 1 (value '1')!",
        "titleBn": "ধাপ ৪: ইনডেক্স ১ এর মান '1' এর ডুপ্লিকেট সোয়াপ বাদ!",
        "descEn": "Value '1' is already in level Visited set {1}. Skipped duplicate permutation!",
        "descBn": "মান '1' লেভেল ভিজিটেড সেটে {1} ইতিমধ্যেই বিদ্যমান। ডুপ্লিকেট সোয়াপ ছাঁটাই!",
      },
      {
        "step": 5,
        "arr": [2, 1, 1],
        "start": 0,
        "i": 2,
        "visited": [1, 2],
        "badge": "🎉 SAVED [2, 1, 1]",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 5: Swap (0, 2) ➔ Saved [2, 1, 1]",
        "titleBn": "ধাপ ৫: সোয়াপ (0, 2) ➔ [2, 1, 1] সংরক্ষিত",
        "descEn": "Saved third unique permutation [2, 1, 1]!",
        "descBn": "তৃতীয় অনন্য বিন্যাস [2, 1, 1] সংরক্ষিত!",
      },
      {
        "step": 6,
        "arr": [1, 1, 2],
        "start": 0,
        "i": 0,
        "visited": [1, 2],
        "badge": "🏆 FINISHED",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 6: Traversal Complete! Total 3 Unique Permutations",
        "titleBn": "ধাপ ৬: ব্যাকট্র্যাকিং সম্পূর্ণ! মোট ৩টি অনন্য বিন্যাস",
        "descEn": "Generated 3 unique permutations: [[1, 1, 2], [1, 2, 1], [2, 1, 1]]!",
        "descBn": "মোট ৩টি অনন্য বিন্যাস তৈরি সম্পন্ন: [[1, 1, 2], [1, 2, 1], [2, 1, 1]]!",
      },
    ];

    final currentStep = stepFlowData[_flowStepIndex.clamp(0, stepFlowData.length - 1)];
    final List<int> currentArr = (currentStep["arr"] as List).cast<int>();
    final int startIdx = currentStep["start"] as int;
    final int iIdx = currentStep["i"] as int;
    final List<int> visList = (currentStep["visited"] as List).cast<int>();
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
                _isEnglish ? "1. Step-by-Step Permutations II Flowcard" : "১. স্টেপ-বাই-স্টেপ পারমিউটেশন II ফ্লো-কার্ড",
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
                ? "Watch how duplicate element swaps are pruned using a level visited set."
                : "লেভেল ভিজিটেড সেটের সাহায্যে ডুপ্লিকেট উপাদান সোয়াপ কীভাবে ছাঁটাই হয় তা দেখুন।",
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

                // Active Pointer & Visited Set Display
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Swap: ($startIdx, $iIdx)", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
                    Text("Level Visited: {${visList.join(', ')}}", style: const TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 12)),
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

  // MODEL 2: Level Visited Set Canvas
  Widget _buildLevelVisitedModel() {
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
            _isEnglish ? "2. Level Visited Hash Set Canvas (unordered_set<int> visited)" : "২. লেভেল ভিজিটেড হ্যাশ সেট ক্যানভাস (unordered_set<int> visited)",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            _isEnglish
                ? "At depth level start, unordered_set<int> visited prevents swapping identical values twice."
                : "ডিপথ লেভেল start এ, unordered_set<int> visited একই উপাদান একাধিকবার সোয়াপ করা প্রতিরোধ করে।",
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
              "if (visited.count(nums[i])) continue; // Prune duplicate swap! 🛑",
              style: TextStyle(fontFamily: 'monospace', fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.accentPink),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  // MODEL 3: Permutations Count
  Widget _buildPermutationsCountModel() {
    int totalUnique = _calculateUniquePermutationsCount(_nums);

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
            _isEnglish ? "3. Standard Factorial (n!) vs Unique Permutations Count" : "৩. সাধারণ ফ্যাক্টোরিয়াল (n!) বনাম অনন্য বিন্যাস সংখ্যা",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            _isEnglish
                ? "Standard n! for n=3 is 6 permutations, but due to duplicate '1's, total unique permutations = 3."
                : "n=3 এর জন্য 3! = 6 টি বিন্যাস পাওয়ার কথা, কিন্তু ডুপ্লিকেট '1' এর কারণে মোট অনন্য বিন্যাস = 3।",
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
              "Array [1, 1, 2] ➔ Total $totalUnique Unique Permutations 🎉",
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
                          labelText: _isEnglish ? "Custom Array with Duplicates (e.g. 1, 1, 2)" : "ডুপ্লিকেটসহ কাস্টম অ্যাররে (যেমন 1, 1, 2)",
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
                      _buildPresetChip("1, 1, 2"),
                      _buildPresetChip("2, 2, 1"),
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
                  _buildPermutationsIICanvas(step),
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildCodeHighlightBox(step.activeLine)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildPermutationsIICanvas(step)),
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
    final totalPerms = _calculateUniquePermutationsCount(_nums);

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
                  ? "Build all $totalPerms unique permutations for array [${_nums.join(', ')}] by choosing swap elements!"
                  : "অ্যাররে [${_nums.join(', ')}] এর জন্য সবকটি $totalPerms টি অনন্য বিন্যাস তৈরি করতে সোয়াপ উপাদান বেছে নিন!",
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
                        _isEnglish ? "Discovered: ${_practiceResults.length} / $totalPerms Unique Permutations" : "সংগৃহীত: ${_practiceResults.length} / $totalPerms টি অনন্য বিন্যাস",
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

            // Swap Choice Buttons
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
                  ? "Collected Unique Permutations (${_practiceResults.length} / $totalPerms):"
                  : "সংগৃহীত অনন্য বিন্যাসসমূহ (${_practiceResults.length} / $totalPerms):",
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
                ? const Text("[ No Unique Permutations Collected Yet ]", style: TextStyle(color: AppTheme.textMuted, fontSize: 12))
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
      "        res.push_back(nums); // Save unique permutation",
      "        return;",
      "    }",
      "    unordered_set<int> visited; // Level visited set",
      "    for (int i = start; i < nums.size(); i++) {",
      "        if (visited.count(nums[i])) continue; // Skip duplicate swap!",
      "        visited.insert(nums[i]);",
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

  Widget _buildPermutationsIICanvas(PermutationsIIStep step) {
    Color decisionColor = AppTheme.accentPurple;
    String decisionLabel = "INIT";

    if (step.decision == "swap_forward") {
      decisionColor = AppTheme.accentAmber;
      decisionLabel = "🔄 SWAP (${step.startIndex}, ${step.swapIndex})";
    } else if (step.decision == "skip_duplicate_swap") {
      decisionColor = AppTheme.accentPink;
      decisionLabel = "🛑 SKIP DUPLICATE SWAP";
    } else if (step.decision == "base_case") {
      decisionColor = AppTheme.accentGreen;
      decisionLabel = "🎉 PERMUTATION SAVED";
    } else if (step.decision == "swap_backtrack") {
      decisionColor = AppTheme.accentAmber;
      decisionLabel = "↩️ SWAP BACK";
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
              Text("Start: [${step.startIndex}], i: [${step.swapIndex}]", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13)),
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

          // Current Array & Level Visited Set Display
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Level Visited Set: {${step.visitedAtLevel.join(', ')}}", style: const TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 12)),
              Text("Depth: ${step.callStackDepth}", style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
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

          // Saved Unique Permutations List
          const Text("Saved Unique Permutations:", style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
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
        unordered_set<int> visited; // Level visited set
        for (int i = start; i < nums.size(); i++) {
            if (visited.count(nums[i])) continue; // Skip duplicate swap!
            visited.insert(nums[i]);
            swap(nums[start], nums[i]);
            backtrack(start + 1, nums, res);
            swap(nums[start], nums[i]);
        }
    }

    vector<vector<int>> permuteUnique(vector<int>& nums) {
        vector<vector<int>> res;
        backtrack(0, nums, res);
        return res;
    }
};""";
    } else if (lang == "Java") {
      code = """
class Solution {
    public List<List<Integer>> permuteUnique(int[] nums) {
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
        Set<Integer> visited = new HashSet<>();
        for (int i = start; i < nums.length; i++) {
            if (visited.contains(nums[i])) continue;
            visited.add(nums[i]);
            swap(nums, start, i);
            backtrack(start + 1, nums, res);
            swap(nums, start, i);
        }
    }

    private void swap(int[] nums, int i, int j) {
        int temp = nums[i]; nums[i] = nums[j]; nums[j] = temp;
    }
}""";
    } else {
      code = """
class Solution:
    def permuteUnique(self, nums: List[int]) -> List[List[int]]:
        res = []

        def backtrack(start):
            if start == len(nums):
                res.append(nums[:])
                return
            visited = set()
            for i in range(start, len(nums)):
                if nums[i] in visited:
                    continue
                visited.add(nums[i])
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
