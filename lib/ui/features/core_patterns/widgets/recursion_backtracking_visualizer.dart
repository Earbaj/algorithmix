import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class RecursionStep {
  final int activeLineIndex;
  final int depth;
  final List<int> currentPath;
  final List<List<int>> totalResults;
  final String actionType; // "CHOICE", "RECURSE", "BASE_CASE", "BACKTRACK"
  final String explanationEn;
  final String explanationBn;

  const RecursionStep({
    required this.activeLineIndex,
    required this.depth,
    required this.currentPath,
    required this.totalResults,
    required this.actionType,
    required this.explanationEn,
    required this.explanationBn,
  });
}

class RecursionBacktrackingVisualizer extends StatefulWidget {
  final bool isEnglish;

  const RecursionBacktrackingVisualizer({super.key, required this.isEnglish});

  @override
  State<RecursionBacktrackingVisualizer> createState() => _RecursionBacktrackingVisualizerState();
}

class _RecursionBacktrackingVisualizerState extends State<RecursionBacktrackingVisualizer> {
  int _selectedTemplateIndex = 0;
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  final List<List<String>> _codeTemplates = const [
    // Template 1: Subsets (Take / Skip Pattern)
    [
      "void generateSubsets(vector<int>& nums, int idx, vector<int>& path) {",
      "    if (idx == nums.size()) {",
      "        result.push_back(path);",
      "        return;",
      "    }",
      "    // Choice 1: Include nums[idx] (TAKE)",
      "    path.push_back(nums[idx]);",
      "    generateSubsets(nums, idx + 1, path);",
      "    // Backtrack (UN-CHOOSE)",
      "    path.pop_back();",
      "    // Choice 2: Exclude nums[idx] (SKIP)",
      "    generateSubsets(nums, idx + 1, path);",
      "}",
    ],
    // Template 2: Permutations (In-place Swap Pattern)
    [
      "void permute(vector<int>& nums, int start) {",
      "    if (start == nums.size()) {",
      "        result.push_back(nums);",
      "        return;",
      "    }",
      "    for (int i = start; i < nums.size(); i++) {",
      "        swap(nums[start], nums[i]);",
      "        permute(nums, start + 1);",
      "        swap(nums[start], nums[i]); // Backtrack",
      "    }",
      "}",
    ],
    // Template 3: Grid / Constraint Backtracking (Choose-Recurse-Unchoose)
    [
      "bool solveGrid(int row, int col) {",
      "    if (row == R && col == C) return true; // Base Case",
      "    grid[row][col] = '#'; // Mark Visited (CHOOSE)",
      "    for (auto& dir : directions) {",
      "        if (isValid(r + dr, c + dc) && solveGrid(r + dr, c + dc)) return true;",
      "    }",
      "    grid[row][col] = '.'; // Backtrack (UN-CHOOSE)",
      "    return false;",
      "}",
    ],
  ];

  final List<RecursionStep> _template1Steps = const [
    RecursionStep(
      activeLineIndex: 0,
      depth: 0,
      currentPath: [],
      totalResults: [],
      actionType: "RECURSE",
      explanationEn: "Line 1: Enter generateSubsets(idx = 0, path = []). Input nums = [1, 2].",
      explanationBn: "লাইন ১: generateSubsets(idx = 0, path = []) রিকার্সন শুরু। ইনপুট = [1, 2]।",
    ),
    RecursionStep(
      activeLineIndex: 6,
      depth: 0,
      currentPath: [1],
      totalResults: [],
      actionType: "CHOICE",
      explanationEn: "Line 7: Choice 1: TAKE nums[0] (1) -> path.push_back(1). path = [1].",
      explanationBn: "লাইন ৭: চয়েস ১: TAKE 1 -> path এ ১ যোগ করা হলো। path = [1]।",
    ),
    RecursionStep(
      activeLineIndex: 7,
      depth: 1,
      currentPath: [1],
      totalResults: [],
      actionType: "RECURSE",
      explanationEn: "Line 8: Recurse into depth 1: generateSubsets(idx = 1, path = [1]).",
      explanationBn: "লাইন ৮: ডেপথ ১ এ রিকার্সন: generateSubsets(idx = 1, path = [1])।",
    ),
    RecursionStep(
      activeLineIndex: 6,
      depth: 1,
      currentPath: [1, 2],
      totalResults: [],
      actionType: "CHOICE",
      explanationEn: "Line 7: Choice 1: TAKE nums[1] (2) -> path.push_back(2). path = [1, 2].",
      explanationBn: "লাইন ৭: চয়েস ১: TAKE 2 -> path এ ২ যোগ করা হলো। path = [1, 2]।",
    ),
    RecursionStep(
      activeLineIndex: 1,
      depth: 2,
      currentPath: [1, 2],
      totalResults: [[1, 2]],
      actionType: "BASE_CASE",
      explanationEn: "🎉 Line 2: Base Case (idx == 2) REACHED! Saved Subset [1, 2] to Result!",
      explanationBn: "🎉 লাইন ২: বেস কেস (idx == 2) মিলেছে! রেজাল্টে সাবসেট [1, 2] সেভ করা হলো!",
    ),
    RecursionStep(
      activeLineIndex: 9,
      depth: 1,
      currentPath: [1],
      totalResults: [[1, 2]],
      actionType: "BACKTRACK",
      explanationEn: "⚡ Line 10: BACKTRACK! Execute path.pop_back() -> Removed 2. path = [1].",
      explanationBn: "⚡ লাইন ১০: ব্যাকট্র্যাক! path.pop_back() এক্সিকিউট -> ২ স সরানো হলো। path = [1]।",
    ),
    RecursionStep(
      activeLineIndex: 11,
      depth: 1,
      currentPath: [1],
      totalResults: [[1, 2]],
      actionType: "CHOICE",
      explanationEn: "Line 12: Choice 2: SKIP nums[1] (2) -> Recurse generateSubsets(idx = 2, path = [1]).",
      explanationBn: "লাইন ১২: চয়েস ২: SKIP 2 -> রিকার্সন কল দেওয়া হলো।",
    ),
    RecursionStep(
      activeLineIndex: 1,
      depth: 2,
      currentPath: [1],
      totalResults: [[1, 2], [1]],
      actionType: "BASE_CASE",
      explanationEn: "🎉 Line 2: Base Case (idx == 2) REACHED! Saved Subset [1] to Result!",
      explanationBn: "🎉 লাইন ২: বেস কেস মিলেছে! রেজাল্টে সাবসেট [1] সেভ করা হলো!",
    ),
    RecursionStep(
      activeLineIndex: 9,
      depth: 0,
      currentPath: [],
      totalResults: [[1, 2], [1]],
      actionType: "BACKTRACK",
      explanationEn: "⚡ Line 10: BACKTRACK to root! Execute path.pop_back() -> Removed 1. path = [].",
      explanationBn: "⚡ লাইন ১০: মেইন রুটে ব্যাকট্র্যাক! ১ সরানো হলো। path = []।",
    ),
    RecursionStep(
      activeLineIndex: 11,
      depth: 0,
      currentPath: [],
      totalResults: [[1, 2], [1]],
      actionType: "CHOICE",
      explanationEn: "Line 12: Choice 2 at Root: SKIP nums[0] (1) -> Recurse generateSubsets(idx = 1, path = []).",
      explanationBn: "লাইন ১২: রুটে চয়েস ২: SKIP 1 -> রিকার্সন কল।",
    ),
    RecursionStep(
      activeLineIndex: 6,
      depth: 1,
      currentPath: [2],
      totalResults: [[1, 2], [1]],
      actionType: "CHOICE",
      explanationEn: "Line 7: Choice 1: TAKE nums[1] (2) -> path = [2].",
      explanationBn: "লাইন ৭: চয়েস ১: TAKE 2 -> path = [2]।",
    ),
    RecursionStep(
      activeLineIndex: 1,
      depth: 2,
      currentPath: [2],
      totalResults: [[1, 2], [1], [2]],
      actionType: "BASE_CASE",
      explanationEn: "🎉 Line 2: Base Case (idx == 2) REACHED! Saved Subset [2] to Result!",
      explanationBn: "🎉 লাইন ২: বেস কেস মিলেছে! রেজাল্টে সাবসেট [2] সেভ করা হলো!",
    ),
    RecursionStep(
      activeLineIndex: 9,
      depth: 1,
      currentPath: [],
      totalResults: [[1, 2], [1], [2]],
      actionType: "BACKTRACK",
      explanationEn: "⚡ Line 10: BACKTRACK! Execute path.pop_back() -> Removed 2. path = [].",
      explanationBn: "⚡ লাইন ১০: ব্যাকট্র্যাক! ২ সরানো হলো। path = []।",
    ),
    RecursionStep(
      activeLineIndex: 1,
      depth: 2,
      currentPath: [],
      totalResults: [[1, 2], [1], [2], []],
      actionType: "BASE_CASE",
      explanationEn: "🎉 Line 2: Base Case REACHED! Saved Empty Subset [] to Result! All 2²=4 Subsets Complete!",
      explanationBn: "🎉 লাইন ২: বেস কেস মিলেছে! খালি সাবসেট [] সেভ করা হলো! ৪টি সাবসেট সম্পূর্ণ!",
    ),
  ];

  final List<RecursionStep> _template2Steps = const [
    RecursionStep(
      activeLineIndex: 0,
      depth: 0,
      currentPath: [1, 2, 3],
      totalResults: [],
      actionType: "RECURSE",
      explanationEn: "Line 1: Enter permute(nums = [1, 2, 3], start = 0).",
      explanationBn: "লাইন ১: permute(nums = [1, 2, 3], start = 0) রিকার্সন শুরু।",
    ),
    RecursionStep(
      activeLineIndex: 6,
      depth: 0,
      currentPath: [1, 2, 3],
      totalResults: [],
      actionType: "CHOICE",
      explanationEn: "Line 7: i = 0: Swap nums[0] (1) with nums[0] (1). nums = [1, 2, 3].",
      explanationBn: "লাইন ৭: i = 0: 1 এর সাথে 1 সোয়াপ। nums = [1, 2, 3]।",
    ),
    RecursionStep(
      activeLineIndex: 7,
      depth: 1,
      currentPath: [1, 2, 3],
      totalResults: [],
      actionType: "RECURSE",
      explanationEn: "Line 8: Recurse permute(start = 1). Next position.",
      explanationBn: "লাইন ৮: পরবর্তী পজিশনে রিকার্সন permute(start = 1)।",
    ),
    RecursionStep(
      activeLineIndex: 6,
      depth: 1,
      currentPath: [1, 3, 2],
      totalResults: [],
      actionType: "CHOICE",
      explanationEn: "Line 7: i = 2: Swap nums[1] (2) with nums[2] (3). nums = [1, 3, 2].",
      explanationBn: "লাইন ৭: i = 2: 2 এর সাথে 3 সোয়াপ। nums = [1, 3, 2]।",
    ),
    RecursionStep(
      activeLineIndex: 1,
      depth: 3,
      currentPath: [1, 3, 2],
      totalResults: [[1, 2, 3], [1, 3, 2]],
      actionType: "BASE_CASE",
      explanationEn: "🎉 Line 2: Base Case (start == 3) REACHED! Added Permutation [1, 3, 2]!",
      explanationBn: "🎉 লাইন ২: বেস কেস মিলেছে! পারমিউটেশন [1, 3, 2] সেভ করা হলো!",
    ),
    RecursionStep(
      activeLineIndex: 8,
      depth: 1,
      currentPath: [1, 2, 3],
      totalResults: [[1, 2, 3], [1, 3, 2]],
      actionType: "BACKTRACK",
      explanationEn: "⚡ Line 9: BACKTRACK SWAP! Undo swap(nums[1], nums[2]) -> nums restored to [1, 2, 3].",
      explanationBn: "⚡ লাইন ৯: ব্যাকট্র্যাক সোয়াপ! অরিজিনাল স্টেট [1, 2, 3] ফেরত আনা হলো।",
    ),
  ];

  final List<RecursionStep> _template3Steps = const [
    RecursionStep(
      activeLineIndex: 0,
      depth: 0,
      currentPath: [0, 0],
      totalResults: [],
      actionType: "RECURSE",
      explanationEn: "Line 1: Enter solveGrid(row = 0, col = 0). Start cell (0, 0).",
      explanationBn: "লাইন ১: solveGrid(row = 0, col = 0) গ্রিড রিকার্সন শুরু।",
    ),
    RecursionStep(
      activeLineIndex: 2,
      depth: 0,
      currentPath: [0, 0],
      totalResults: [],
      actionType: "CHOICE",
      explanationEn: "Line 3: CHOOSE: Mark cell (0, 0) as visited '#'.",
      explanationBn: "লাইন ৩: CHOOSE: গ্রিড সেল (0, 0) ভিজিটেড '#' চিহ্নিত করা হলো।",
    ),
    RecursionStep(
      activeLineIndex: 4,
      depth: 1,
      currentPath: [0, 1],
      totalResults: [],
      actionType: "RECURSE",
      explanationEn: "Line 5: Move RIGHT -> Recurse into cell (0, 1).",
      explanationBn: "লাইন ৫: ডান দিকে মুভ -> সেল (0, 1) এ রিকার্সন।",
    ),
    RecursionStep(
      activeLineIndex: 6,
      depth: 0,
      currentPath: [0, 0],
      totalResults: [],
      actionType: "BACKTRACK",
      explanationEn: "⚡ Line 7: BACKTRACK (UN-CHOOSE)! Restore grid[0][1] = '.' if obstacle reached.",
      explanationBn: "⚡ লাইন ৭: ব্যাকট্র্যাক (UN-CHOOSE)! ইনভ্যালিড পাথে সেল '.' রিসেট করা হলো।",
    ),
  ];

  List<RecursionStep> get _currentSteps {
    if (_selectedTemplateIndex == 1) return _template2Steps;
    if (_selectedTemplateIndex == 2) return _template3Steps;
    return _template1Steps;
  }

  List<String> get _currentCodeLines {
    return _codeTemplates[_selectedTemplateIndex];
  }

  void _togglePlay() {
    setState(() => _isPlaying = !_isPlaying);
    if (_isPlaying) {
      _timer = Timer.periodic(const Duration(milliseconds: 1400), (timer) {
        if (_currentStepIndex < _currentSteps.length - 1) {
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

  void _nextStep() {
    if (_currentStepIndex < _currentSteps.length - 1) {
      setState(() => _currentStepIndex++);
    }
  }

  void _prevStep() {
    if (_currentStepIndex > 0) {
      setState(() => _currentStepIndex--);
    }
  }

  void _reset() {
    _timer?.cancel();
    setState(() {
      _isPlaying = false;
      _currentStepIndex = 0;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final step = _currentSteps[_currentStepIndex];
    final isMobile = Responsive.isMobile(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Template Selector Buttons
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildTemplateChip(0, widget.isEnglish ? "Subsets (Take/Skip)" : "সাবসেট (Take/Skip)"),
              _buildTemplateChip(1, widget.isEnglish ? "Permutations (Swap)" : "পারমিউটেশন (Swap)"),
              _buildTemplateChip(2, widget.isEnglish ? "Grid / Constraint" : "গ্রিড ব্যাকট্র্যাকিং"),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Status Banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: step.actionType == "BACKTRACK"
                ? AppTheme.accentPink.withOpacity(0.15)
                : (step.actionType == "BASE_CASE" ? AppTheme.accentGreen.withOpacity(0.15) : AppTheme.accentPurple.withOpacity(0.15)),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: step.actionType == "BACKTRACK"
                  ? AppTheme.accentPink
                  : (step.actionType == "BASE_CASE" ? AppTheme.accentGreen : AppTheme.accentPurple),
            ),
          ),
          child: Text(
            widget.isEnglish ? step.explanationEn : step.explanationBn,
            style: TextStyle(
              color: step.actionType == "BACKTRACK"
                  ? AppTheme.accentPink
                  : (step.actionType == "BASE_CASE" ? AppTheme.accentGreen : AppTheme.accentNeonCyan),
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Code Snippet + Recursion Call Stack Visualizer Box Layout
        if (isMobile)
          Column(
            children: [
              _buildCodeSnippetWithHighlight(_currentCodeLines, step.activeLineIndex),
              const SizedBox(height: 16),
              _buildRecursionCanvas(step),
            ],
          )
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildCodeSnippetWithHighlight(_currentCodeLines, step.activeLineIndex)),
              const SizedBox(width: 16),
              Expanded(child: _buildRecursionCanvas(step)),
            ],
          ),

        const SizedBox(height: 20),

        // Controls Bar
        _buildControlBar(),
      ],
    );
  }

  Widget _buildTemplateChip(int index, String label) {
    final isSelected = _selectedTemplateIndex == index;
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
        ),
        onSelected: (selected) {
          if (selected) {
            _timer?.cancel();
            setState(() {
              _selectedTemplateIndex = index;
              _currentStepIndex = 0;
              _isPlaying = false;
            });
          }
        },
      ),
    );
  }

  Widget _buildCodeSnippetWithHighlight(List<String> codeLines, int activeIndex) {
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
          final isHighlighted = idx == activeIndex;
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
                    "${idx + 1}",
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

  Widget _buildRecursionCanvas(RecursionStep step) {
    return Container(
      padding: const EdgeInsets.all(18),
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
                "Recursion Depth: Level ${step.depth}",
                style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: step.actionType == "BACKTRACK"
                      ? AppTheme.accentPink.withOpacity(0.2)
                      : (step.actionType == "BASE_CASE" ? AppTheme.accentGreen.withOpacity(0.2) : AppTheme.accentPurple.withOpacity(0.2)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  step.actionType,
                  style: TextStyle(
                    color: step.actionType == "BACKTRACK"
                        ? AppTheme.accentPink
                        : (step.actionType == "BASE_CASE" ? AppTheme.accentGreen : AppTheme.accentPurple),
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Active Path State Box
          const Text("Active Path Container (Recursion Choice State):", style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.accentPurple.withOpacity(0.5)),
            ),
            child: step.currentPath.isEmpty
                ? Text(widget.isEnglish ? "[ Empty Path [] ]" : "[ খালি পাথ [] ]", style: const TextStyle(color: AppTheme.textMuted, fontSize: 13))
                : Row(
                    children: step.currentPath.map((val) {
                      return Container(
                        margin: const EdgeInsets.only(right: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.accentPurple,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text("$val", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                      );
                    }).toList(),
                  ),
          ),
          const SizedBox(height: 16),

          // Generated Result Subsets / Permutations Collector
          const Text("Generated Results (Base Case Collector):", style: TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.accentGreen.withOpacity(0.5)),
            ),
            child: step.totalResults.isEmpty
                ? Text(widget.isEnglish ? "[ No Base Case Output Yet ]" : "[ এখনো কোনো আউটপুট সেভ হয়নি ]", style: const TextStyle(color: AppTheme.textMuted, fontSize: 12))
                : Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: step.totalResults.map((resList) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.accentGreen.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppTheme.accentGreen),
                        ),
                        child: Text(
                          resList.toString(),
                          style: const TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      );
                    }).toList(),
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
                onPressed: _currentStepIndex > 0 ? _prevStep : null,
              ),
              IconButton(
                icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, color: AppTheme.accentNeonCyan),
                onPressed: _togglePlay,
              ),
              IconButton(
                icon: const Icon(Icons.skip_next, color: Colors.white),
                onPressed: _currentStepIndex < _currentSteps.length - 1 ? _nextStep : null,
              ),
              IconButton(
                icon: const Icon(Icons.refresh, color: AppTheme.accentNeonCyan),
                onPressed: _reset,
              ),
            ],
          ),
          Text(
            widget.isEnglish
                ? "Step ${_currentStepIndex + 1} of ${_currentSteps.length}"
                : "ধাপ ${_currentStepIndex + 1} / ${_currentSteps.length}",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
