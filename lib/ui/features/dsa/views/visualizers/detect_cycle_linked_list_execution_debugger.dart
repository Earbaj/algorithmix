import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'floyds_cycle_detection/floyds_cycle_canvas_widget.dart';
import 'floyds_cycle_detection/floyds_cycle_controls_widget.dart';
import 'floyds_cycle_detection/floyds_debugger_watch_widget.dart';

class DetectCycleLinkedListExecutionDebugger extends StatefulWidget {
  final bool isEnglish;

  const DetectCycleLinkedListExecutionDebugger({
    super.key,
    required this.isEnglish,
  });

  @override
  State<DetectCycleLinkedListExecutionDebugger> createState() =>
      _DetectCycleLinkedListExecutionDebuggerState();
}

class DebuggerStepData {
  final int activeLineIndex;
  final int slowVal;
  final int fastVal;
  final String? conditionText;
  final String explanationEn;
  final String explanationBn;

  const DebuggerStepData({
    required this.activeLineIndex,
    required this.slowVal,
    required this.fastVal,
    this.conditionText,
    required this.explanationEn,
    required this.explanationBn,
  });
}

class _DetectCycleLinkedListExecutionDebuggerState
    extends State<DetectCycleLinkedListExecutionDebugger> {
  final List<String> _codeLines = const [
    "bool hasCycle(ListNode *head) {",
    "    ListNode *slow = head, *fast = head;",
    "    while (fast != nullptr && fast->next != nullptr) {",
    "        slow = slow->next;",
    "        fast = fast->next->next;",
    "        if (slow == fast) return true;",
    "    }",
    "    return false;",
    "}",
  ];

  final List<int> _initialNodes = const [1, 2, 3, 4];

  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  late final List<DebuggerStepData> _steps;

  @override
  void initState() {
    super.initState();
    _steps = const [
      DebuggerStepData(
        activeLineIndex: 0,
        slowVal: 1,
        fastVal: 1,
        explanationEn: "Line 1: Entry into hasCycle(head). List has cycle: Node 4 -> Node 2.",
        explanationBn: "লাইন ১: hasCycle(head) ফাংশনে প্রবেশ। লিস্টে Node 4 -> Node 2 সাইকেল আছে।",
      ),
      DebuggerStepData(
        activeLineIndex: 1,
        slowVal: 1,
        fastVal: 1,
        conditionText: "slow = Node 1, fast = Node 1",
        explanationEn: "Line 2: Initialize slow = head (1), fast = head (1).",
        explanationBn: "লাইন ২: slow = Node 1 এবং fast = Node 1 সূচনা করা হলো।",
      ),
      DebuggerStepData(
        activeLineIndex: 2,
        slowVal: 1,
        fastVal: 1,
        conditionText: "fast (1) != nullptr && fast->next (2) != nullptr -> TRUE",
        explanationEn: "Line 3: Check while condition: fast and fast->next are non-null.",
        explanationBn: "লাইন ৩: fast এবং fast->next দুটিই নন-নাল, লুপ চলবে।",
      ),
      DebuggerStepData(
        activeLineIndex: 3,
        slowVal: 2,
        fastVal: 1,
        conditionText: "slow = slow->next (Node 2)",
        explanationEn: "Line 4: Move slow 1 step forward -> slow = Node 2.",
        explanationBn: "লাইন ৪: slow পয়েন্টার ১ ধাপ এগিয়ে Node 2 এ গেল।",
      ),
      DebuggerStepData(
        activeLineIndex: 4,
        slowVal: 2,
        fastVal: 3,
        conditionText: "fast = fast->next->next (Node 3)",
        explanationEn: "Line 5: Move fast 2 steps forward -> fast = Node 3.",
        explanationBn: "লাইন ৫: fast পয়েন্টার ২ ধাপ এগিয়ে Node 3 এ গেল।",
      ),
      DebuggerStepData(
        activeLineIndex: 5,
        slowVal: 2,
        fastVal: 3,
        conditionText: "slow (2) == fast (3) -> FALSE",
        explanationEn: "Line 6: Check slow == fast: (2 == 3) is FALSE. Continue loop.",
        explanationBn: "লাইন ৬: (2 == 3) মিথ্যা, তাই লুপ অব্যাহত থাকবে।",
      ),
      DebuggerStepData(
        activeLineIndex: 3,
        slowVal: 3,
        fastVal: 3,
        conditionText: "slow = Node 3, fast = Node 2",
        explanationEn: "Lines 4-5: Iteration 2: slow moves to Node 3. fast wraps around cycle to Node 2.",
        explanationBn: "লাইন ৪-৫: ধাপ ২: slow গেল Node 3 এ, fast সাইকেল ঘুরে এলো Node 2 এ।",
      ),
      DebuggerStepData(
        activeLineIndex: 5,
        slowVal: 4,
        fastVal: 4,
        conditionText: "slow (4) == fast (4) -> TRUE 🎉",
        explanationEn: "Line 6: Iteration 3: Both slow and fast meet at Node 4! (slow == fast) is TRUE! Return true!",
        explanationBn: "লাইন ৬: ধাপ ৩: slow ও fast একই নোডে (Node 4) মিলল (slow == fast)! রিটার্ন true! 🎉",
      ),
    ];
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
  Widget build(BuildContext context) {
    final step = _steps[_currentStepIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.isEnglish
              ? "Line-by-Line Execution Debugger & Canvas"
              : "লাইন-বাই-লাইন এক্সিকিউশন ডিবাগার ও ক্যানভাস",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.accentNeonCyan),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.accentNeonCyan.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.accentNeonCyan.withOpacity(0.4)),
          ),
          child: Text(
            widget.isEnglish ? step.explanationEn : step.explanationBn,
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
        const SizedBox(height: 14),

        _buildCodeHighlightBox(step.activeLineIndex),
        const SizedBox(height: 16),

        FloydsCycleCanvasWidget(
          isEnglish: widget.isEnglish,
          nodes: _initialNodes,
          slowVal: step.slowVal,
          fastVal: step.fastVal,
          isCycleDetected: step.slowVal == step.fastVal && step.activeLineIndex == 5,
        ),
        const SizedBox(height: 16),

        FloydsDebuggerWatchWidget(
          isEnglish: widget.isEnglish,
          slowVal: step.slowVal,
          fastVal: step.fastVal,
          conditionText: step.conditionText,
        ),
        const SizedBox(height: 16),

        FloydsCycleControlsWidget(
          isEnglish: widget.isEnglish,
          currentStepIndex: _currentStepIndex,
          totalSteps: _steps.length,
          isPlaying: _isPlaying,
          onReset: _reset,
          onPrev: _currentStepIndex > 0 ? _prevStep : null,
          onTogglePlay: _togglePlay,
          onNext: _currentStepIndex < _steps.length - 1 ? _nextStep : null,
        ),
      ],
    );
  }

  Widget _buildCodeHighlightBox(int activeIndex) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF090D16),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(_codeLines.length, (idx) {
          final isHighlighted = idx == activeIndex;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            margin: const EdgeInsets.symmetric(vertical: 2),
            decoration: BoxDecoration(
              color: isHighlighted ? AppTheme.accentNeonCyan.withOpacity(0.2) : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: isHighlighted ? Border.all(color: AppTheme.accentNeonCyan.withOpacity(0.6)) : null,
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 24,
                  child: Text(
                    "${idx + 1}",
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      color: isHighlighted ? AppTheme.accentNeonCyan : const Color(0xFF64748B),
                      fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
                if (isHighlighted)
                  const Padding(
                    padding: EdgeInsets.only(right: 6),
                    child: Icon(Icons.arrow_right_alt, color: AppTheme.accentNeonCyan, size: 16),
                  )
                else
                  const SizedBox(width: 22),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      _codeLines[idx],
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 13,
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
}
