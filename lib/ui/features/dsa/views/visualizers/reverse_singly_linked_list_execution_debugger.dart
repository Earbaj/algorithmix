import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';

class ReverseSinglyLinkedListExecutionDebugger extends StatefulWidget {
  final bool isEnglish;

  const ReverseSinglyLinkedListExecutionDebugger({
    super.key,
    required this.isEnglish,
  });

  @override
  State<ReverseSinglyLinkedListExecutionDebugger> createState() =>
      _ReverseSinglyLinkedListExecutionDebuggerState();
}

class DebuggerStepData {
  final int activeLineIndex;
  final int? prevVal;
  final int? currVal;
  final int? nextTempVal;
  final String? conditionText;
  final String explanationEn;
  final String explanationBn;

  const DebuggerStepData({
    required this.activeLineIndex,
    this.prevVal,
    this.currVal,
    this.nextTempVal,
    this.conditionText,
    required this.explanationEn,
    required this.explanationBn,
  });
}

class _ReverseSinglyLinkedListExecutionDebuggerState
    extends State<ReverseSinglyLinkedListExecutionDebugger> {
  final List<String> _codeLines = const [
    "ListNode* reverseList(ListNode* head) {",
    "    ListNode *prev = nullptr, *curr = head;",
    "    while (curr != nullptr) {",
    "        ListNode* nextTemp = curr->next;",
    "        curr->next = prev;",
    "        prev = curr;",
    "        curr = nextTemp;",
    "    }",
    "    return prev;",
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
        currVal: 1,
        explanationEn: "Line 1: Entry into reverseList(head). Head points to Node 1.",
        explanationBn: "লাইন ১: reverseList(head) ফাংশনে প্রবেশ। হেড Node 1 নির্দেশ করছে।",
      ),
      DebuggerStepData(
        activeLineIndex: 1,
        prevVal: -1,
        currVal: 1,
        conditionText: "prev = NULL, curr = 1",
        explanationEn: "Line 2: Initialize prev = nullptr, curr = head (Node 1).",
        explanationBn: "লাইন ২: prev = nullptr এবং curr = Node 1 সূচনা করা হলো।",
      ),
      DebuggerStepData(
        activeLineIndex: 2,
        prevVal: -1,
        currVal: 1,
        conditionText: "curr != nullptr -> TRUE",
        explanationEn: "Line 3: Loop condition check: curr (1) != nullptr is TRUE.",
        explanationBn: "লাইন ৩: লুপ চেক: curr (1) != nullptr শর্ত সত্য (TRUE)।",
      ),
      DebuggerStepData(
        activeLineIndex: 3,
        prevVal: -1,
        currVal: 1,
        nextTempVal: 2,
        conditionText: "nextTemp = 2",
        explanationEn: "Line 4: Store nextTemp = curr->next (Node 2).",
        explanationBn: "লাইন ৪: nextTemp = curr->next (Node 2) মেমোরিতে সেভ।",
      ),
      DebuggerStepData(
        activeLineIndex: 4,
        prevVal: -1,
        currVal: 1,
        nextTempVal: 2,
        conditionText: "1->next = NULL",
        explanationEn: "Line 5: Flip pointer: curr->next = prev (nullptr).",
        explanationBn: "লাইন ৫: পয়েন্টার রিভার্স: 1->next = prev (nullptr)।",
      ),
      DebuggerStepData(
        activeLineIndex: 5,
        prevVal: 1,
        currVal: 1,
        nextTempVal: 2,
        conditionText: "prev = 1",
        explanationEn: "Line 6: Advance prev = curr (Node 1).",
        explanationBn: "লাইন ৬: prev = Node 1 হিসেবে আপডেট।",
      ),
      DebuggerStepData(
        activeLineIndex: 6,
        prevVal: 1,
        currVal: 2,
        nextTempVal: 2,
        conditionText: "curr = 2",
        explanationEn: "Line 7: Advance curr = nextTemp (Node 2). Loop iteration 1 complete!",
        explanationBn: "লাইন ৭: curr = Node 2 এগিয়ে গেল। প্রথম লুপ ধাপ শেষ!",
      ),
      DebuggerStepData(
        activeLineIndex: 4,
        prevVal: 2,
        currVal: 3,
        nextTempVal: 4,
        conditionText: "3->next = 2",
        explanationEn: "Lines 4-7: Iteration 2: Flip Node 3 -> Node 2. Advance prev = 3, curr = 4.",
        explanationBn: "লাইন ৪-৭: ধাপ ২: Node 3 পয়েন্টার রিভার্স করে 2 এর দিকে ঘুরল।",
      ),
      DebuggerStepData(
        activeLineIndex: 2,
        prevVal: 4,
        currVal: -1,
        conditionText: "curr == nullptr -> FALSE (Exit loop)",
        explanationEn: "Line 3: Loop check: curr == nullptr is FALSE! Exit while loop.",
        explanationBn: "লাইন ৩: curr == nullptr সত্য হওয়ায় লুপ শেষ হলো!",
      ),
      DebuggerStepData(
        activeLineIndex: 8,
        prevVal: 4,
        currVal: -1,
        conditionText: "Return prev (Node 4)",
        explanationEn: "Line 9: Return prev (Node 4) as the new Head of reversed Singly Linked List 🎉",
        explanationBn: "লাইন ৯: নতুন হেড Node 4 রিটার্ন করা হলো 🎉",
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
              ? "Line-by-Line Execution Debugger & Memory Canvas"
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
            widget.isEnglish ? "Linked List Node Pointer Canvas" : "লিঙ্কড লিস্ট নোড পয়েন্টার ক্যানভাস",
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
                  final isPrev = step.prevVal == val;
                  final isCurr = step.currVal == val;
                  final isNextTemp = step.nextTempVal == val;

                  return Row(
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                              if (isPrev) _buildBadge("prev", AppTheme.accentAmber),
                              if (isCurr) _buildBadge("curr", AppTheme.accentNeonCyan),
                              if (isNextTemp) _buildBadge("nextTemp", AppTheme.accentPink),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: isCurr
                                  ? AppTheme.accentNeonCyan.withOpacity(0.3)
                                  : (isPrev ? AppTheme.accentAmber.withOpacity(0.2) : const Color(0xFF1E293B)),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isCurr
                                    ? AppTheme.accentNeonCyan
                                    : (isPrev ? AppTheme.accentAmber : const Color(0xFF334155)),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "$val",
                                style: TextStyle(
                                  color: isCurr ? AppTheme.accentNeonCyan : Colors.white,
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
              _buildVariableBadge("prev", step.prevVal == -1 ? "NULL" : (step.prevVal != null ? "Node ${step.prevVal}" : "-"), AppTheme.accentAmber),
              _buildVariableBadge("curr", step.currVal == -1 ? "NULL" : (step.currVal != null ? "Node ${step.currVal}" : "-"), AppTheme.accentNeonCyan),
              _buildVariableBadge("nextTemp", step.nextTempVal == -1 ? "NULL" : (step.nextTempVal != null ? "Node ${step.nextTempVal}" : "-"), AppTheme.accentPink),
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
          IconButton(
            icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
            onPressed: _togglePlay,
            tooltip: _isPlaying
                ? (widget.isEnglish ? "Pause" : "পজ করুন")
                : (widget.isEnglish ? "Auto Debug" : "অটো ডিবাগ"),
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
