import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';

class ReverseDoublyLinkedListExecutionDebugger extends StatefulWidget {
  final bool isEnglish;

  const ReverseDoublyLinkedListExecutionDebugger({
    super.key,
    required this.isEnglish,
  });

  @override
  State<ReverseDoublyLinkedListExecutionDebugger> createState() =>
      _ReverseDoublyLinkedListExecutionDebuggerState();
}

class DebuggerStepData {
  final int activeLineIndex;
  final int? currVal;
  final int? tempVal;
  final String? conditionText;
  final String explanationEn;
  final String explanationBn;

  const DebuggerStepData({
    required this.activeLineIndex,
    this.currVal,
    this.tempVal,
    this.conditionText,
    required this.explanationEn,
    required this.explanationBn,
  });
}

class _ReverseDoublyLinkedListExecutionDebuggerState
    extends State<ReverseDoublyLinkedListExecutionDebugger> {
  final List<String> _codeLines = const [
    "Node* reverseDLL(Node* head) {",
    "    Node *temp = nullptr, *curr = head;",
    "    while (curr != nullptr) {",
    "        temp = curr->prev;",
    "        curr->prev = curr->next;",
    "        curr->next = temp;",
    "        curr = curr->prev;",
    "    }",
    "    return temp ? temp->prev : head;",
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
        explanationEn: "Line 1: Entry into reverseDLL(head). Head points to Node 1.",
        explanationBn: "লাইন ১: reverseDLL(head) ফাংশনে প্রবেশ। হেড Node 1 নির্দেশ করছে।",
      ),
      DebuggerStepData(
        activeLineIndex: 1,
        currVal: 1,
        tempVal: -1,
        conditionText: "temp = nullptr, curr = 1",
        explanationEn: "Line 2: Initialize temp = nullptr, curr = head (Node 1).",
        explanationBn: "লাইন ২: temp = nullptr এবং curr = Node 1 সূচনা করা হলো।",
      ),
      DebuggerStepData(
        activeLineIndex: 2,
        currVal: 1,
        tempVal: -1,
        conditionText: "curr (1) != nullptr -> TRUE",
        explanationEn: "Line 3: Condition check: curr (1) != nullptr is TRUE.",
        explanationBn: "লাইন ৩: লুপ চেক: curr (1) != nullptr শর্ত সত্য (TRUE)।",
      ),
      DebuggerStepData(
        activeLineIndex: 3,
        currVal: 1,
        tempVal: -1,
        conditionText: "temp = 1->prev (nullptr)",
        explanationEn: "Line 4: Store temp = curr->prev (nullptr).",
        explanationBn: "লাইন ৪: temp = curr->prev (nullptr) সেভ করা হলো।",
      ),
      DebuggerStepData(
        activeLineIndex: 4,
        currVal: 1,
        tempVal: -1,
        conditionText: "1->prev = 1->next (Node 2)",
        explanationEn: "Line 5: Swap prev pointer: curr->prev = curr->next (Node 2).",
        explanationBn: "লাইন ৫: 1->prev পয়েন্টারে Node 2 এর এড্রেস বসানো হলো।",
      ),
      DebuggerStepData(
        activeLineIndex: 5,
        currVal: 1,
        tempVal: -1,
        conditionText: "1->next = temp (nullptr)",
        explanationEn: "Line 6: Swap next pointer: curr->next = temp (nullptr).",
        explanationBn: "লাইন ৬: 1->next পয়েন্টারে temp (nullptr) বসানো হলো।",
      ),
      DebuggerStepData(
        activeLineIndex: 6,
        currVal: 2,
        tempVal: 1,
        conditionText: "curr = curr->prev (Node 2)",
        explanationEn: "Line 7: Advance curr = curr->prev (Node 2, because prev was swapped with next!).",
        explanationBn: "লাইন ৭: curr পয়েন্টার আগের next (বর্তমানে prev) অর্থাৎ Node 2 এ এগোয়!",
      ),
      DebuggerStepData(
        activeLineIndex: 2,
        currVal: -1,
        tempVal: 3,
        conditionText: "curr == nullptr -> FALSE (Exit loop)",
        explanationEn: "Line 3: Loop check: curr == nullptr is FALSE! Exit loop.",
        explanationBn: "লাইন ৩: curr == nullptr হওয়ায় লুপ শেষ হলো!",
      ),
      DebuggerStepData(
        activeLineIndex: 8,
        currVal: -1,
        tempVal: 3,
        conditionText: "Return temp->prev (Node 4)",
        explanationEn: "Line 9: Return temp->prev (Node 4) as the new Head of reversed DLL 🎉",
        explanationBn: "লাইন ৯: নতুন উল্টানো DLL এর হেড Node 4 (temp->prev) রিটার্ন করা হলো 🎉",
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
            widget.isEnglish ? "Doubly Linked List Pointer Canvas" : "দ্বিমুখী লিঙ্কড লিস্ট পয়েন্টার ক্যানভাস",
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
                  final isCurr = step.currVal == val;
                  final isTemp = step.tempVal == val;

                  return Row(
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                              if (isCurr) _buildBadge("curr", AppTheme.accentNeonCyan),
                              if (isTemp) _buildBadge("temp", AppTheme.accentPink),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: isCurr
                                  ? AppTheme.accentNeonCyan.withOpacity(0.3)
                                  : (isTemp ? AppTheme.accentPink.withOpacity(0.2) : const Color(0xFF1E293B)),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isCurr
                                    ? AppTheme.accentNeonCyan
                                    : (isTemp ? AppTheme.accentPink : const Color(0xFF334155)),
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
                          child: Icon(Icons.compare_arrows, color: AppTheme.accentGreen, size: 18),
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
              _buildVariableBadge("curr ptr", step.currVal == -1 ? "NULL" : (step.currVal != null ? "Node ${step.currVal}" : "-"), AppTheme.accentNeonCyan),
              _buildVariableBadge("temp ptr", step.tempVal == -1 ? "NULL" : (step.tempVal != null ? "Node ${step.tempVal}" : "-"), AppTheme.accentPink),
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
