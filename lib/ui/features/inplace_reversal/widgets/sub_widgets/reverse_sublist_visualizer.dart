import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import 'reverse_entire_list_visualizer.dart';

class ReverseSublistVisualizer extends StatefulWidget {
  final bool isEnglish;

  const ReverseSublistVisualizer({super.key, required this.isEnglish});

  @override
  State<ReverseSublistVisualizer> createState() => _ReverseSublistVisualizerState();
}

class _ReverseSublistVisualizerState extends State<ReverseSublistVisualizer> {
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  final List<String> _codeLines = const [
    "ListNode* reverseBetween(ListNode* head, int left, int right) {",
    "    ListNode dummy(0); dummy.next = head;",
    "    ListNode* prev = &dummy;",
    "    for (int i = 0; i < left - 1; i++) prev = prev->next;",
    "    ListNode* curr = prev->next;",
    "    for (int i = 0; i < right - left; i++) {",
    "        ListNode* nextTemp = curr->next;",
    "        curr->next = nextTemp->next; nextTemp->next = prev->next; prev->next = nextTemp;",
    "    }",
    "    return dummy.next;",
    "}",
  ];

  final List<ReversalStep> _steps = const [
    ReversalStep(
      prevIdx: 0,
      currIdx: 1,
      nextIdx: 2,
      activeLineIndex: 3,
      nodeValues: [1, 2, 3, 4, 5],
      isFlipped: [false, false, false, false, false],
      explanationEn: "Line 4: Sub-list range [left = 2, right = 4]. Move prev to Node 1, curr to Node 2.",
      explanationBn: "লাইন ৪: সাব-লিস্ট সীমানা [2 থেকে 4]। prev কে নোড 1 এবং curr কে নোড 2 এ নেওয়া হলো।",
    ),
    ReversalStep(
      prevIdx: 0,
      currIdx: 1,
      nextIdx: 3,
      activeLineIndex: 6,
      nodeValues: [1, 4, 3, 2, 5],
      isFlipped: [false, true, true, true, false],
      explanationEn: "Line 7: Reversed middle sub-list [2, 3, 4] -> Reconnected as [1, 4, 3, 2, 5]!",
      explanationBn: "লাইন ৭: মাঝের সাব-লিস্ট [2, 3, 4] রিভার্স হয়ে ডামি পয়েন্টারে [1, 4, 3, 2, 5] যুক্ত হলো!",
    ),
    ReversalStep(
      prevIdx: 0,
      currIdx: 4,
      nextIdx: -1,
      activeLineIndex: 8,
      nodeValues: [1, 4, 3, 2, 5],
      isFlipped: [false, true, true, true, false],
      explanationEn: "🎉 Line 9: Sub-list Reversal Complete! Return dummy.next (Node 1)!",
      explanationBn: "🎉 লাইন ৯: নির্দিষ্ট সীমানায় সাব-লিস্ট রিভার্স সম্পন্ন! dummy.next রিটার্ন করা হলো!",
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
              Text("Sub-list Left: [2]", style: const TextStyle(color: AppTheme.accentPurple, fontWeight: FontWeight.bold, fontSize: 13)),
              Text("Sub-list Right: [4]", style: const TextStyle(color: AppTheme.accentPink, fontWeight: FontWeight.bold, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 16),
          const Text("Sub-list Reversal & Boundary Reconnection:", style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(step.nodeValues.length, (i) {
                final isSub = i >= 1 && i <= 3;

                final Color color = isSub ? AppTheme.accentPurple : AppTheme.surfaceDark;

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
                          color: isSub ? Colors.white : const Color(0xFF1E293B),
                          width: isSub ? 2.5 : 1,
                        ),
                        boxShadow: isSub ? [BoxShadow(color: color.withOpacity(0.6), blurRadius: 8)] : [],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${step.nodeValues[i]}",
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: isSub ? AppTheme.primaryDark : Colors.white),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isSub ? "SUB" : "[$i]",
                            style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: isSub ? AppTheme.primaryDark : AppTheme.textMuted),
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
