import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';

class MergeKListsExecutionDebugger extends StatefulWidget {
  final bool isEnglish;

  const MergeKListsExecutionDebugger({
    super.key,
    required this.isEnglish,
  });

  @override
  State<MergeKListsExecutionDebugger> createState() =>
      _MergeKListsExecutionDebuggerState();
}

class DebuggerStepData {
  final int activeLineIndex;
  final String topNodeValStr;
  final String mergedListStr;
  final String explanationEn;
  final String explanationBn;

  const DebuggerStepData({
    required this.activeLineIndex,
    required this.topNodeValStr,
    required this.mergedListStr,
    required this.explanationEn,
    required this.explanationBn,
  });
}

class _MergeKListsExecutionDebuggerState
    extends State<MergeKListsExecutionDebugger> {
  final List<String> _codeLines = const [
    "ListNode* mergeKLists(vector<ListNode*>& lists) {",
    "    auto comp = [](ListNode* a, ListNode* b) { return a->val > b->val; };",
    "    priority_queue<ListNode*, vector<ListNode*>, decltype(comp)> minHeap(comp);",
    "    for (auto l : lists) if (l) minHeap.push(l);",
    "    while (!minHeap.empty()) {",
    "        ListNode* topNode = minHeap.top(); minHeap.pop();",
    "        tail->next = topNode; tail = tail->next;",
    "        if (topNode->next) minHeap.push(topNode->next);",
    "    }",
    "    return dummy.next;",
    "}",
  ];

  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  late final List<DebuggerStepData> _steps;

  @override
  void initState() {
    super.initState();
    _steps = const [
      DebuggerStepData(
        activeLineIndex: 3,
        topNodeValStr: "1",
        mergedListStr: "[]",
        explanationEn: "Line 4: Push initial head nodes of K lists into Min-Heap.",
        explanationBn: "লাইন ৪: K টি লিস্টের প্রথম নোডসমূহ Min-Heap এ যুক্ত।",
      ),
      DebuggerStepData(
        activeLineIndex: 5,
        topNodeValStr: "1",
        mergedListStr: "[1]",
        explanationEn: "Line 6: Pop min node 1. Attach to tail->next.",
        explanationBn: "লাইন ৬: সর্বনিম্ন নোড 1 পপ করে লিঙ্কড লিস্ট টেলে যুক্ত।",
      ),
      DebuggerStepData(
        activeLineIndex: 7,
        topNodeValStr: "1",
        mergedListStr: "[1, 1]",
        explanationEn: "Line 8: topNode->next exists (4) -> Push 4 into minHeap.",
        explanationBn: "লাইন ৮: topNode->next (4) বিদ্যমান -> ৪ কে হিপে পুশ।",
      ),
      DebuggerStepData(
        activeLineIndex: 9,
        topNodeValStr: "None",
        mergedListStr: "[1, 1, 2, 3, 4, 4, 5, 6]",
        explanationEn: "Line 10: Loop ends! Return dummy.next -> Merged List Complete! 🎉",
        explanationBn: "লাইন ১০: লুপ সম্পন্ন! return dummy.next -> সর্টেড লিঙ্কড লিস্ট সম্পূর্ণ! 🎉",
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
              ? "Line-by-Line Execution Debugger & Pointer Inspector"
              : "লাইন-বাই-লাইন এক্সিকিউশন ডিবাগার ও ওয়াচার",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF84CC16)),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF84CC16).withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF84CC16).withOpacity(0.4)),
          ),
          child: Text(
            widget.isEnglish ? step.explanationEn : step.explanationBn,
            style: const TextStyle(color: Color(0xFF84CC16), fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
        const SizedBox(height: 14),

        _buildCodeHighlightBox(step.activeLineIndex),
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
              color: isHighlighted ? const Color(0xFF84CC16).withOpacity(0.2) : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: isHighlighted ? Border.all(color: const Color(0xFF84CC16).withOpacity(0.6)) : null,
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
                      color: isHighlighted ? const Color(0xFF84CC16) : const Color(0xFF64748B),
                      fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
                if (isHighlighted)
                  const Padding(
                    padding: EdgeInsets.only(right: 6),
                    child: Icon(Icons.arrow_right_alt, color: Color(0xFF84CC16), size: 16),
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
              const Icon(Icons.bug_report, color: Color(0xFF84CC16), size: 18),
              const SizedBox(width: 8),
              Text(
                widget.isEnglish ? "Merge K Lists Method Watcher" : "মার্জ K মেথড ওয়াচার",
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 10,
            children: [
              _buildVariableBadge("topNode->val", step.topNodeValStr, AppTheme.accentNeonCyan),
              _buildVariableBadge("Merged output", step.mergedListStr, const Color(0xFF84CC16)),
            ],
          ),
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
              backgroundColor: const Color(0xFF84CC16),
              foregroundColor: AppTheme.primaryDark,
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
            style: const TextStyle(color: Color(0xFF84CC16), fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
