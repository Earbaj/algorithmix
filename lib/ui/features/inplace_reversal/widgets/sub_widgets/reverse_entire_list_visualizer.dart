import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class ReversalStep {
  final int prevIdx;
  final int currIdx;
  final int nextIdx;
  final int activeLineIndex;
  final List<int> nodeValues;
  final List<bool> isFlipped;
  final String explanationEn;
  final String explanationBn;

  const ReversalStep({
    required this.prevIdx,
    required this.currIdx,
    required this.nextIdx,
    required this.activeLineIndex,
    required this.nodeValues,
    required this.isFlipped,
    required this.explanationEn,
    required this.explanationBn,
  });
}

class ReverseEntireListVisualizer extends StatefulWidget {
  final bool isEnglish;

  const ReverseEntireListVisualizer({super.key, required this.isEnglish});

  @override
  State<ReverseEntireListVisualizer> createState() => _ReverseEntireListVisualizerState();
}

class _ReverseEntireListVisualizerState extends State<ReverseEntireListVisualizer> {
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  final List<String> _codeLines = const [
    "ListNode* reverseList(ListNode* head) {",
    "    ListNode *prev = nullptr, *curr = head;",
    "    while (curr != nullptr) {",
    "        ListNode* nextTemp = curr->next; // Backup next",
    "        curr->next = prev;             // Flip link!",
    "        prev = curr;                   // Advance prev",
    "        curr = nextTemp;               // Advance curr",
    "    }",
    "    return prev; // New Head!",
    "}",
  ];

  final List<ReversalStep> _steps = const [
    ReversalStep(
      prevIdx: -1,
      currIdx: 0,
      nextIdx: 1,
      activeLineIndex: 1,
      nodeValues: [1, 2, 3, 4, 5],
      isFlipped: [false, false, false, false, false],
      explanationEn: "Line 2: Set prev = null, curr = head (Node 1). Next node = Node 2.",
      explanationBn: "লাইন ২: prev = null এবং curr = head (নোড 1) ডিক্লেয়ার। পরবর্তী নোড = নোড 2।",
    ),
    ReversalStep(
      prevIdx: -1,
      currIdx: 0,
      nextIdx: 1,
      activeLineIndex: 3,
      nodeValues: [1, 2, 3, 4, 5],
      isFlipped: [false, false, false, false, false],
      explanationEn: "Line 4: Backup next pointer: nextTemp = node (val 2).",
      explanationBn: "লাইন ৪: পরবর্তী পয়েন্টার ব্যাকআপ: nextTemp = node (মান 2)।",
    ),
    ReversalStep(
      prevIdx: -1,
      currIdx: 0,
      nextIdx: 1,
      activeLineIndex: 4,
      nodeValues: [1, 2, 3, 4, 5],
      isFlipped: [true, false, false, false, false],
      explanationEn: "Line 5: Flip link! Node 1 next now points to prev (null).",
      explanationBn: "লাইন ৫: লিঙ্ক উল্টানো! নোড 1 এর পয়েন্টার এখন prev (null) কে দেখাচ্ছে।",
    ),
    ReversalStep(
      prevIdx: 0,
      currIdx: 1,
      nextIdx: 2,
      activeLineIndex: 5,
      nodeValues: [1, 2, 3, 4, 5],
      isFlipped: [true, false, false, false, false],
      explanationEn: "Line 6 & 7: Advance pointers: prev = Node 1, curr = Node 2.",
      explanationBn: "লাইন ৬ ও ৭: পয়েন্টার আগানো: prev = Node 1, curr = Node 2।",
    ),
    ReversalStep(
      prevIdx: 0,
      currIdx: 1,
      nextIdx: 2,
      activeLineIndex: 4,
      nodeValues: [1, 2, 3, 4, 5],
      isFlipped: [true, true, false, false, false],
      explanationEn: "Line 5: Flip link! Node 2 next now points back to Node 1.",
      explanationBn: "লাইন ৫: লিঙ্ক উল্টানো! নোড 2 এর পয়েন্টার নোড 1 কে দেখাচ্ছে।",
    ),
    ReversalStep(
      prevIdx: 1,
      currIdx: 2,
      nextIdx: 3,
      activeLineIndex: 5,
      nodeValues: [1, 2, 3, 4, 5],
      isFlipped: [true, true, false, false, false],
      explanationEn: "Line 6 & 7: Advance pointers: prev = Node 2, curr = Node 3.",
      explanationBn: "লাইন ৬ ও ৭: পয়েন্টার আগানো: prev = Node 2, curr = Node 3।",
    ),
    ReversalStep(
      prevIdx: 3,
      currIdx: 4,
      nextIdx: -1,
      activeLineIndex: 4,
      nodeValues: [1, 2, 3, 4, 5],
      isFlipped: [true, true, true, true, true],
      explanationEn: "Line 5: Flip link! Node 5 next now points back to Node 4.",
      explanationBn: "লাইন ৫: লিঙ্ক উল্টানো! নোড 5 এখন নোড 4 কে পয়েন্ট করছে।",
    ),
    ReversalStep(
      prevIdx: 4,
      currIdx: -1,
      nextIdx: -1,
      activeLineIndex: 8,
      nodeValues: [5, 4, 3, 2, 1],
      isFlipped: [true, true, true, true, true],
      explanationEn: "🎉 Line 9: Reversal Complete! Return prev = Node 5 as the new Head!",
      explanationBn: "🎉 লাইন ৯: লিঙ্কড লিস্ট রিভার্স সম্পন্ন! নতুন হেড হিসেবে prev (নোড 5) রিটার্ন করা হলো!",
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
        // Status Log Banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: step.currIdx == -1 ? AppTheme.accentGreen.withOpacity(0.15) : AppTheme.accentNeonCyan.withOpacity(0.15),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: step.currIdx == -1 ? AppTheme.accentGreen : AppTheme.accentNeonCyan),
          ),
          child: Text(
            widget.isEnglish ? step.explanationEn : step.explanationBn,
            style: TextStyle(
              color: step.currIdx == -1 ? AppTheme.accentGreen : AppTheme.accentNeonCyan,
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
              Text("prev: [${step.prevIdx >= 0 ? step.nodeValues[step.prevIdx] : 'NULL'}]", style: const TextStyle(color: AppTheme.accentPurple, fontWeight: FontWeight.bold, fontSize: 13)),
              Text("curr: [${step.currIdx >= 0 ? step.nodeValues[step.currIdx] : 'NULL'}]", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13)),
              Text("next: [${step.nextIdx >= 0 ? step.nodeValues[step.nextIdx] : 'NULL'}]", style: const TextStyle(color: AppTheme.accentPink, fontWeight: FontWeight.bold, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 16),
          const Text("Linked List Nodes & Pointer Orientation:", style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(step.nodeValues.length, (i) {
                final isPrev = i == step.prevIdx;
                final isCurr = i == step.currIdx;
                final isNext = i == step.nextIdx;

                final Color color = isCurr
                    ? AppTheme.accentNeonCyan
                    : (isPrev ? AppTheme.accentPurple : (isNext ? AppTheme.accentPink : AppTheme.surfaceDark));

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
                          color: (isCurr || isPrev || isNext) ? Colors.white : const Color(0xFF1E293B),
                          width: (isCurr || isPrev || isNext) ? 2.5 : 1,
                        ),
                        boxShadow: (isCurr || isPrev || isNext) ? [BoxShadow(color: color.withOpacity(0.6), blurRadius: 8)] : [],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${step.nodeValues[i]}",
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: (isCurr || isPrev || isNext) ? AppTheme.primaryDark : Colors.white),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isCurr ? "CURR" : (isPrev ? "PREV" : (isNext ? "NEXT" : "[$i]")),
                            style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: (isCurr || isPrev || isNext) ? AppTheme.primaryDark : AppTheme.textMuted),
                          ),
                        ],
                      ),
                    ),
                    if (i < step.nodeValues.length - 1)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(
                          step.isFlipped[i] ? Icons.arrow_back : Icons.arrow_forward,
                          color: step.isFlipped[i] ? AppTheme.accentGreen : AppTheme.accentPink,
                          size: 20,
                        ),
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
