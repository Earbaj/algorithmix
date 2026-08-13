import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class DfsStep {
  final int activeNodeVal;
  final int activeLineIndex;
  final List<int> callStackState;
  final List<int> visitedValues;
  final String explanationEn;
  final String explanationBn;

  const DfsStep({
    required this.activeNodeVal,
    required this.activeLineIndex,
    required this.callStackState,
    required this.visitedValues,
    required this.explanationEn,
    required this.explanationBn,
  });
}

class PreorderTraversalVisualizer extends StatefulWidget {
  final bool isEnglish;

  const PreorderTraversalVisualizer({super.key, required this.isEnglish});

  @override
  State<PreorderTraversalVisualizer> createState() => _PreorderTraversalVisualizerState();
}

class _PreorderTraversalVisualizerState extends State<PreorderTraversalVisualizer> {
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  final List<String> _codeLines = const [
    "void preorder(TreeNode* root, vector<int>& res) {",
    "    if (!root) return; // Base Case",
    "    res.push_back(root->val); // 1. Process Root",
    "    preorder(root->left, res);  // 2. Visit Left Subtree",
    "    preorder(root->right, res); // 3. Visit Right Subtree",
    "}",
  ];

  final List<DfsStep> _steps = const [
    DfsStep(
      activeNodeVal: 1,
      activeLineIndex: 1,
      callStackState: [1],
      visitedValues: [],
      explanationEn: "Line 2: Call preorder(root 1). Stack = [1].",
      explanationBn: "লাইন ২: preorder(root 1) রিকার্সিভ কল। স্ট্যাক = [1]।",
    ),
    DfsStep(
      activeNodeVal: 1,
      activeLineIndex: 2,
      callStackState: [1],
      visitedValues: [1],
      explanationEn: "Line 3: Preorder: Process Root 1 first! Add 1 to result. Result = [1].",
      explanationBn: "লাইন ৩: প্রি-অর্ডার: প্রথমে রুট 1 প্রসেস করা হলো! রেজাল্ট = [1]।",
    ),
    DfsStep(
      activeNodeVal: 2,
      activeLineIndex: 3,
      callStackState: [1, 2],
      visitedValues: [1],
      explanationEn: "Line 4: Recurse Left -> Call preorder(node 2). Stack = [1, 2].",
      explanationBn: "লাইন ৪: বামে রিকার্স কল -> preorder(node 2)। স্ট্যাক = [1, 2]।",
    ),
    DfsStep(
      activeNodeVal: 2,
      activeLineIndex: 2,
      callStackState: [1, 2],
      visitedValues: [1, 2],
      explanationEn: "Line 3: Process Root 2! Add 2 to result. Result = [1, 2].",
      explanationBn: "লাইন ৩: রুট 2 প্রসেস করা হলো! রেজাল্ট = [1, 2]।",
    ),
    DfsStep(
      activeNodeVal: 4,
      activeLineIndex: 3,
      callStackState: [1, 2, 4],
      visitedValues: [1, 2, 4],
      explanationEn: "Line 4: Recurse Left -> Call preorder(node 4). Add 4 to result. Result = [1, 2, 4].",
      explanationBn: "লাইন ৪: বামে রিকার্স কল -> 4 প্রসেস করা হলো। রেজাল্ট = [1, 2, 4]।",
    ),
    DfsStep(
      activeNodeVal: 5,
      activeLineIndex: 4,
      callStackState: [1, 2, 5],
      visitedValues: [1, 2, 4, 5],
      explanationEn: "Line 5: Backtrack to 2, Recurse Right -> Call preorder(node 5). Result = [1, 2, 4, 5].",
      explanationBn: "লাইন ৫: 2 এ ব্যাকট্র্যাক করে ডানে রিকার্স কল -> 5 প্রসেস করা হলো। রেজাল্ট = [1, 2, 4, 5]।",
    ),
    DfsStep(
      activeNodeVal: 3,
      activeLineIndex: 4,
      callStackState: [1, 3],
      visitedValues: [1, 2, 4, 5, 3],
      explanationEn: "Line 5: Backtrack to root 1, Recurse Right -> Call preorder(node 3). Result = [1, 2, 4, 5, 3].",
      explanationBn: "লাইন ৫: রুট 1 এ ব্যাকট্র্যাক করে ডানে রিকার্স কল -> 3 প্রসেস করা হলো।",
    ),
    DfsStep(
      activeNodeVal: 3,
      activeLineIndex: 5,
      callStackState: [],
      visitedValues: [1, 2, 4, 5, 3],
      explanationEn: "🎉 Line 6: Preorder Traversal Complete! Result = [1, 2, 4, 5, 3]!",
      explanationBn: "🎉 লাইন ৬: প্রি-অর্ডার ট্রাভার্সাল সম্পন্ন! রেজাল্ট = [1, 2, 4, 5, 3]!",
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
            color: step.callStackState.isEmpty ? AppTheme.accentGreen.withOpacity(0.15) : AppTheme.accentNeonCyan.withOpacity(0.15),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: step.callStackState.isEmpty ? AppTheme.accentGreen : AppTheme.accentNeonCyan),
          ),
          child: Text(
            widget.isEnglish ? step.explanationEn : step.explanationBn,
            style: TextStyle(
              color: step.callStackState.isEmpty ? AppTheme.accentGreen : AppTheme.accentNeonCyan,
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
              _buildDfsCanvas(step),
            ],
          )
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildCodeSnippetWithHighlight(_codeLines, step.activeLineIndex)),
              const SizedBox(width: 16),
              Expanded(child: _buildDfsCanvas(step)),
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

  Widget _buildDfsCanvas(DfsStep step) {
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
              Text("Active Node: [${step.activeNodeVal}]", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13)),
              Text("Call Stack Depth: [${step.callStackState.length}]", style: const TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 16),
          const Text("Recursion Call Stack (LIFO):", style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.accentPurple.withOpacity(0.4)),
            ),
            child: Row(
              children: [
                const Icon(Icons.layers, color: AppTheme.accentPurple, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: step.callStackState.isEmpty
                      ? const Text("Call Stack Empty (Returned to Main)", style: TextStyle(color: AppTheme.textMuted, fontSize: 12, fontStyle: FontStyle.italic))
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: step.callStackState.map((val) {
                              return Container(
                                margin: const EdgeInsets.only(right: 6),
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppTheme.accentPurple.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: AppTheme.accentPurple),
                                ),
                                child: Text("dfs($val)", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                              );
                            }).toList(),
                          ),
                        ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text("Visited Order Result Vector:", style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.accentNeonCyan.withOpacity(0.4)),
            ),
            child: Text(
              "[${step.visitedValues.join(', ')}]",
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
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
