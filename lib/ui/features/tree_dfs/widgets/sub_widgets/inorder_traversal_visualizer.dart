import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import 'preorder_traversal_visualizer.dart';

class InorderTraversalVisualizer extends StatefulWidget {
  final bool isEnglish;

  const InorderTraversalVisualizer({super.key, required this.isEnglish});

  @override
  State<InorderTraversalVisualizer> createState() => _InorderTraversalVisualizerState();
}

class _InorderTraversalVisualizerState extends State<InorderTraversalVisualizer> {
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  final List<String> _codeLines = const [
    "void inorder(TreeNode* root, vector<int>& res) {",
    "    if (!root) return; // Base Case",
    "    inorder(root->left, res);  // 1. Visit Left Subtree",
    "    res.push_back(root->val); // 2. Process Root (Sorted in BST!)",
    "    inorder(root->right, res); // 3. Visit Right Subtree",
    "}",
  ];

  final List<DfsStep> _steps = const [
    DfsStep(
      activeNodeVal: 4,
      activeLineIndex: 2,
      callStackState: [1, 2, 4],
      visitedValues: [],
      explanationEn: "Line 3: Inorder: Go left first until null -> Reached leftmost leaf node 4.",
      explanationBn: "লাইন ৩: ইন-অর্ডার: বামের সর্বনিম্ন লিফ নোড 4 এ পৌঁছানো হলো।",
    ),
    DfsStep(
      activeNodeVal: 4,
      activeLineIndex: 3,
      callStackState: [1, 2, 4],
      visitedValues: [4],
      explanationEn: "Line 4: Process Node 4! Add 4 to result. Result = [4].",
      explanationBn: "লাইন ৪: নোড 4 প্রসেস করা হলো! রেজাল্ট = [4]।",
    ),
    DfsStep(
      activeNodeVal: 2,
      activeLineIndex: 3,
      callStackState: [1, 2],
      visitedValues: [4, 2],
      explanationEn: "Line 4: Backtrack to parent Node 2. Process Node 2! Result = [4, 2].",
      explanationBn: "লাইন ৪: ব্যাকট্র্যাক করে নোড 2 এ প্রসেস করা হলো! রেজাল্ট = [4, 2]।",
    ),
    DfsStep(
      activeNodeVal: 5,
      activeLineIndex: 3,
      callStackState: [1, 5],
      visitedValues: [4, 2, 5],
      explanationEn: "Line 4: Visit right node 5. Process Node 5! Result = [4, 2, 5].",
      explanationBn: "লাইন ৪: ডানের নোড 5 এ প্রসেস করা হলো! রেজাল্ট = [4, 2, 5]।",
    ),
    DfsStep(
      activeNodeVal: 1,
      activeLineIndex: 3,
      callStackState: [1],
      visitedValues: [4, 2, 5, 1],
      explanationEn: "Line 4: Backtrack to Root 1. Process Root 1! Result = [4, 2, 5, 1].",
      explanationBn: "লাইন ৪: রুটে ব্যাকট্র্যাক করে 1 প্রসেস করা হলো! রেজাল্ট = [4, 2, 5, 1]।",
    ),
    DfsStep(
      activeNodeVal: 3,
      activeLineIndex: 3,
      callStackState: [],
      visitedValues: [4, 2, 5, 1, 3],
      explanationEn: "🎉 Line 4: Inorder Traversal Complete! Output is sorted in BST: [4, 2, 5, 1, 3]!",
      explanationBn: "🎉 লাইন ৪: ইন-অর্ডার ট্রাভার্সাল সম্পন্ন! রেজাল্ট = [4, 2, 5, 1, 3]!",
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
