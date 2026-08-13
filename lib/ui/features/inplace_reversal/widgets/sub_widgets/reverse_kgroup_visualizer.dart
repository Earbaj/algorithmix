import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import 'reverse_entire_list_visualizer.dart';

class ReverseKGroupVisualizer extends StatefulWidget {
  final bool isEnglish;

  const ReverseKGroupVisualizer({super.key, required this.isEnglish});

  @override
  State<ReverseKGroupVisualizer> createState() => _ReverseKGroupVisualizerState();
}

class _ReverseKGroupVisualizerState extends State<ReverseKGroupVisualizer> {
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  final List<String> _codeLines = const [
    "ListNode* reverseKGroup(ListNode* head, int k) {",
    "    ListNode* curr = head; int count = 0;",
    "    while (curr && count < k) { curr = curr->next; count++; }",
    "    if (count == k) {",
    "        ListNode *prev = nullptr, *node = head;",
    "        for (int i = 0; i < k; i++) {",
    "            ListNode* nextTemp = node->next; node->next = prev; prev = node; node = nextTemp;",
    "        }",
    "        head->next = reverseKGroup(node, k); return prev;",
    "    }",
    "    return head;",
    "}",
  ];

  final List<ReversalStep> _steps = const [
    ReversalStep(
      prevIdx: 0,
      currIdx: 1,
      nextIdx: 2,
      activeLineIndex: 2,
      nodeValues: [1, 2, 3, 4, 5],
      isFlipped: [false, false, false, false, false],
      explanationEn: "Line 3: k = 2. Group 1 = [1, 2], Group 2 = [3, 4], Remaining = [5].",
      explanationBn: "লাইন ৩: k = 2। গ্রুপ ১ = [1, 2], গ্রুপ ২ = [3, 4], অবশিষ্ট = [5]।",
    ),
    ReversalStep(
      prevIdx: 1,
      currIdx: 0,
      nextIdx: 3,
      activeLineIndex: 6,
      nodeValues: [2, 1, 4, 3, 5],
      isFlipped: [true, false, true, false, false],
      explanationEn: "Line 7: Reversed Group 1 -> [2, 1]. Reversed Group 2 -> [4, 3]. Group 3 has 1 node < K (remains [5]).",
      explanationBn: "লাইন ৭: গ্রুপ ১ রিভার্স -> [2, 1]। গ্রুপ ২ রিভার্স -> [4, 3]। গ্রুপ ৩ এর ১টি নোড < K (অপরিবর্তিত [5])।",
    ),
    ReversalStep(
      prevIdx: 0,
      currIdx: 4,
      nextIdx: -1,
      activeLineIndex: 8,
      nodeValues: [2, 1, 4, 3, 5],
      isFlipped: [true, false, true, false, false],
      explanationEn: "🎉 Line 9: Reverse K-Group Complete! Result = [2, 1, 4, 3, 5]!",
      explanationBn: "🎉 লাইন ৯: K-Group রিভার্স সম্পন্ন! ফলাফল = [2, 1, 4, 3, 5]!",
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
            color: step.currIdx == 4 ? AppTheme.accentGreen.withOpacity(0.15) : AppTheme.accentNeonCyan.withOpacity(0.15),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: step.currIdx == 4 ? AppTheme.accentGreen : AppTheme.accentNeonCyan),
          ),
          child: Text(
            widget.isEnglish ? step.explanationEn : step.explanationBn,
            style: TextStyle(
              color: step.currIdx == 4 ? AppTheme.accentGreen : AppTheme.accentNeonCyan,
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
              _buildReversalCanvas(step),
            ],
          )
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildCodeSnippetWithHighlight(_codeLines, step.activeLineIndex)),
              const SizedBox(width: 16),
              Expanded(child: _buildReversalCanvas(step)),
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

  Widget _buildReversalCanvas(ReversalStep step) {
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
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("Group Size k: [2]", style: const TextStyle(color: AppTheme.accentPurple, fontWeight: FontWeight.bold, fontSize: 13)),
              Text("Reversed Groups: [2]", style: const TextStyle(color: AppTheme.accentPink, fontWeight: FontWeight.bold, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 16),
          const Text("K-Group Linked List Nodes:", style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(step.nodeValues.length, (i) {
                final isGroup1 = i == 0 || i == 1;
                final isGroup2 = i == 2 || i == 3;

                final Color color = isGroup1
                    ? AppTheme.accentPurple
                    : (isGroup2 ? AppTheme.accentNeonCyan : AppTheme.surfaceDark);

                return Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 55,
                      height: 60,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: (isGroup1 || isGroup2) ? Colors.white : const Color(0xFF1E293B),
                          width: (isGroup1 || isGroup2) ? 2.5 : 1,
                        ),
                        boxShadow: (isGroup1 || isGroup2) ? [BoxShadow(color: color.withOpacity(0.6), blurRadius: 8)] : [],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${step.nodeValues[i]}",
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: (isGroup1 || isGroup2) ? AppTheme.primaryDark : Colors.white),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isGroup1 ? "G1" : (isGroup2 ? "G2" : "REM"),
                            style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: (isGroup1 || isGroup2) ? AppTheme.primaryDark : AppTheme.textMuted),
                          ),
                        ],
                      ),
                    ),
                    if (i < step.nodeValues.length - 1)
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(Icons.arrow_right_alt, color: AppTheme.accentPink, size: 20),
                      ),
                  ],
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
