import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';

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

        _buildPointerStateCanvas(step),
        const SizedBox(height: 16),

        _buildVariableWatchPanel(step),
        const SizedBox(height: 16),

        _buildControls(),
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

  Widget _buildPointerStateCanvas(DebuggerStepData step) {
    return Container(
      width: double.infinity,
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
            widget.isEnglish ? "Cycle Detection Pointer Canvas" : "সাইকেল ডিটেকশন পয়েন্টার ক্যানভাস",
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...List.generate(_initialNodes.length, (idx) {
                  final val = _initialNodes[idx];
                  final isSlow = step.slowVal == val;
                  final isFast = step.fastVal == val;

                  return Row(
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                              if (isSlow) _buildBadge("slow", AppTheme.accentGreen),
                              if (isFast) _buildBadge("fast", Colors.purpleAccent),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: isSlow
                                  ? AppTheme.accentGreen.withOpacity(0.3)
                                  : (isFast ? Colors.purpleAccent.withOpacity(0.2) : const Color(0xFF1E293B)),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSlow
                                    ? AppTheme.accentGreen
                                    : (isFast ? Colors.purpleAccent : const Color(0xFF334155)),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "$val",
                                style: TextStyle(
                                  color: isSlow ? AppTheme.accentGreen : Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (idx < _initialNodes.length - 1)
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6),
                          child: Icon(Icons.arrow_forward, color: AppTheme.textMuted, size: 18),
                        )
                      else
                        const Padding(
                          padding: EdgeInsets.only(left: 4),
                          child: Icon(Icons.replay_circle_filled_outlined, color: Colors.redAccent, size: 20),
                        ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(4), border: Border.all(color: color)),
      child: Text(label, style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildVariableWatchPanel(DebuggerStepData step) {
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
            children: [
              const Icon(Icons.bug_report, color: AppTheme.accentPink, size: 18),
              const SizedBox(width: 8),
              Text(
                widget.isEnglish ? "Pointer Watch Inspector" : "পয়েন্টার ওয়াচ ইন্সপেক্টর",
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 10,
            children: [
              _buildVariableBadge("slow ptr", "Node ${step.slowVal}", AppTheme.accentGreen),
              _buildVariableBadge("fast ptr", "Node ${step.fastVal}", Colors.purpleAccent),
            ],
          ),
          if (step.conditionText != null) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.accentGreen),
              ),
              child: Text(
                "Execution: ${step.conditionText}",
                style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.bold, fontSize: 12, color: AppTheme.accentGreen),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildVariableBadge(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.replay, color: Colors.white70),
            onPressed: _reset,
            tooltip: widget.isEnglish ? "Reset" : "রিসেট",
          ),
          IconButton(
            icon: const Icon(Icons.skip_previous, color: Colors.white),
            onPressed: _currentStepIndex > 0 ? _prevStep : null,
            tooltip: widget.isEnglish ? "Previous Line" : "আগের লাইন",
          ),
          ElevatedButton.icon(
            onPressed: _togglePlay,
            icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
            label: Text(_isPlaying
                ? (widget.isEnglish ? "Pause" : "পজ করুন")
                : (widget.isEnglish ? "Auto Debug" : "অটো ডিবাগ")),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentPink,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.skip_next, color: Colors.white),
            onPressed: _currentStepIndex < _steps.length - 1 ? _nextStep : null,
            tooltip: widget.isEnglish ? "Next Line" : "পরের লাইন",
          ),
          Text(
            "${_currentStepIndex + 1}/${_steps.length}",
            style: const TextStyle(color: AppTheme.accentPink, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
