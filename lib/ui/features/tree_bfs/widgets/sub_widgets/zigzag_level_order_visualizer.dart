import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import 'standard_level_order_visualizer.dart';

class ZigzagLevelOrderVisualizer extends StatefulWidget {
  final bool isEnglish;

  const ZigzagLevelOrderVisualizer({super.key, required this.isEnglish});

  @override
  State<ZigzagLevelOrderVisualizer> createState() => _ZigzagLevelOrderVisualizerState();
}

class _ZigzagLevelOrderVisualizerState extends State<ZigzagLevelOrderVisualizer> {
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  final List<String> _codeLines = const [
    "vector<vector<int>> zigzagLevelOrder(TreeNode* root) {",
    "    vector<vector<int>> res; if (!root) return res;",
    "    queue<TreeNode*> q; q.push(root); bool leftToRight = true;",
    "    while (!q.empty()) {",
    "        int size = q.size(); vector<int> level(size);",
    "        for (int i = 0; i < size; i++) {",
    "            TreeNode* curr = q.front(); q.pop();",
    "            int index = leftToRight ? i : (size - 1 - i);",
    "            level[index] = curr->val;",
    "            if (curr->left) q.push(curr->left); if (curr->right) q.push(curr->right);",
    "        }",
    "        leftToRight = !leftToRight; res.push_back(level);",
    "    }",
    "    return res;",
    "}",
  ];

  final List<BfsStep> _steps = const [
    BfsStep(
      activeNodeVal: 3,
      currentLevelIndex: 0,
      activeLineIndex: 2,
      queueState: [3],
      resultState: [],
      explanationEn: "Line 3: Zigzag BFS initialized. leftToRight = true.",
      explanationBn: "লাইন ৩: জিগজ্যাগ BFS শুরু। leftToRight = true।",
    ),
    BfsStep(
      activeNodeVal: 20,
      currentLevelIndex: 1,
      activeLineIndex: 8,
      queueState: [15, 7],
      resultState: [[3], [20, 9]],
      explanationEn: "Line 9: Level 1: leftToRight = false -> Flip level vector into [20, 9]!",
      explanationBn: "লাইন ৯: লেভেল ১: leftToRight = false -> লেভেল ভেক্টর উল্টে [20, 9] তৈরি হলো!",
    ),
    BfsStep(
      activeNodeVal: 7,
      currentLevelIndex: 2,
      activeLineIndex: 11,
      queueState: [],
      resultState: [[3], [20, 9], [15, 7]],
      explanationEn: "🎉 Line 12: Zigzag Level Order Complete! Result = [[3], [20, 9], [15, 7]]!",
      explanationBn: "🎉 লাইন ১২: জিগজ্যাগ লেভেল অর্ডার ট্রাভার্সাল সম্পন্ন! রেজাল্ট = [[3], [20, 9], [15, 7]]!",
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
            color: step.queueState.isEmpty ? AppTheme.accentGreen.withOpacity(0.15) : AppTheme.accentNeonCyan.withOpacity(0.15),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: step.queueState.isEmpty ? AppTheme.accentGreen : AppTheme.accentNeonCyan),
          ),
          child: Text(
            widget.isEnglish ? step.explanationEn : step.explanationBn,
            style: TextStyle(
              color: step.queueState.isEmpty ? AppTheme.accentGreen : AppTheme.accentNeonCyan,
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
              _buildBfsCanvas(step),
            ],
          )
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildCodeSnippetWithHighlight(_codeLines, step.activeLineIndex)),
              const SizedBox(width: 16),
              Expanded(child: _buildBfsCanvas(step)),
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

  Widget _buildBfsCanvas(BfsStep step) {
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
              Text("Zigzag Level: [${step.currentLevelIndex}]", style: const TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 16),
          const Text("Zigzag Queue & Direction Vector:", style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          const SizedBox(height: 8),
          Column(
            children: List.generate(step.resultState.length, (lvlIdx) {
              final levelVals = step.resultState[lvlIdx];
              return Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceDark,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.accentPurple.withOpacity(0.4)),
                ),
                child: Row(
                  children: [
                    Text("Level $lvlIdx: ", style: const TextStyle(color: AppTheme.accentPurple, fontWeight: FontWeight.bold, fontSize: 12)),
                    Text("[${levelVals.join(', ')}]", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                  ],
                ),
              );
            }),
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
