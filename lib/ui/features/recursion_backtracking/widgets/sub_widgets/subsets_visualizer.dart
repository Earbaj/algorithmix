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

class SubsetsVisualizer extends StatefulWidget {
  final bool isEnglish;

  const SubsetsVisualizer({super.key, required this.isEnglish});

  @override
  State<SubsetsVisualizer> createState() => _SubsetsVisualizerState();
}

class _SubsetsVisualizerState extends State<SubsetsVisualizer> {
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  final List<String> _codeLines = const [
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
  ];

  final List<RecursionStep> _steps = const [
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
      explanationBn: "⚡ লাইন ১০: ব্যাকট্র্যাক! path.pop_back() এক্সিকিউট -> ২ সরানো হলো। path = [1]।",
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
      explanationEn: "⚡ Line 10: BACKTRACK! path.pop_back() -> path = [].",
      explanationBn: "⚡ লাইন ১০: ব্যাকট্র্যাক! path = []।",
    ),
    RecursionStep(
      activeLineIndex: 1,
      depth: 2,
      currentPath: [],
      totalResults: [[1, 2], [1], [2], []],
      actionType: "BASE_CASE",
      explanationEn: "🎉 Line 2: Base Case REACHED! Saved Empty Subset [] to Result! Complete!",
      explanationBn: "🎉 লাইন ২: বেস কেস মিলেছে! খালি সাবসেট [] সেভ করা হলো! সম্পূর্ণ!",
    ),
  ];

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

  void _nextStep() {
    if (_currentStepIndex < _steps.length - 1) {
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
    final step = _steps[_currentStepIndex];
    final isMobile = Responsive.isMobile(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: step.actionType == "BASE_CASE"
                ? AppTheme.accentGreen.withOpacity(0.15)
                : (step.actionType == "BACKTRACK"
                    ? AppTheme.accentPink.withOpacity(0.15)
                    : AppTheme.accentNeonCyan.withOpacity(0.15)),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: step.actionType == "BASE_CASE"
                  ? AppTheme.accentGreen
                  : (step.actionType == "BACKTRACK" ? AppTheme.accentPink : AppTheme.accentNeonCyan),
            ),
          ),
          child: Text(
            widget.isEnglish ? step.explanationEn : step.explanationBn,
            style: TextStyle(
              color: step.actionType == "BASE_CASE"
                  ? AppTheme.accentGreen
                  : (step.actionType == "BACKTRACK" ? AppTheme.accentPink : AppTheme.accentNeonCyan),
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(height: 16),

        if (isMobile)
          Column(
            children: [
              _buildCodeSnippetWithHighlight(_codeLines, step.activeLineIndex),
              const SizedBox(height: 16),
              _buildCanvas(step),
            ],
          )
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildCodeSnippetWithHighlight(_codeLines, step.activeLineIndex)),
              const SizedBox(width: 16),
              Expanded(child: _buildCanvas(step)),
            ],
          ),

        const SizedBox(height: 20),
        _buildControlBar(),
      ],
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

  Widget _buildCanvas(RecursionStep step) {
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
              Text("Call Depth: [${step.depth}]", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13)),
              Text("Subsets: ${step.totalResults.length}", style: const TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 16),

          // Current Path Array
          const Text("Current Recursion Path:", style: TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.accentPurple.withOpacity(0.5)),
            ),
            child: Text(
              step.currentPath.isEmpty ? "[] (empty)" : step.currentPath.toString(),
              style: const TextStyle(color: AppTheme.accentPurple, fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          const SizedBox(height: 16),

          // Results List
          const Text("Saved Subsets Result:", style: TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: step.totalResults.map((sub) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.accentGreen.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppTheme.accentGreen),
                ),
                child: Text(
                  sub.isEmpty ? "[]" : sub.toString(),
                  style: const TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              );
            }).toList(),
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
                onPressed: _currentStepIndex < _steps.length - 1 ? _nextStep : null,
              ),
              IconButton(
                icon: const Icon(Icons.refresh, color: AppTheme.accentNeonCyan),
                onPressed: _reset,
              ),
            ],
          ),
          Text(
            widget.isEnglish
                ? "Step ${_currentStepIndex + 1} of ${_steps.length}"
                : "ধাপ ${_currentStepIndex + 1} / ${_steps.length}",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
