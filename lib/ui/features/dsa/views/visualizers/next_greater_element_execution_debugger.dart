import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';

class NextGreaterElementExecutionDebugger extends StatefulWidget {
  final bool isEnglish;

  const NextGreaterElementExecutionDebugger({
    super.key,
    required this.isEnglish,
  });

  @override
  State<NextGreaterElementExecutionDebugger> createState() =>
      _NextGreaterElementExecutionDebuggerState();
}

class DebuggerStepData {
  final int activeLineIndex;
  final int index;
  final int currVal;
  final String topVal;
  final List<int> stackContent;
  final String? conditionText;
  final String explanationEn;
  final String explanationBn;

  const DebuggerStepData({
    required this.activeLineIndex,
    required this.index,
    required this.currVal,
    required this.topVal,
    required this.stackContent,
    this.conditionText,
    required this.explanationEn,
    required this.explanationBn,
  });
}

class _NextGreaterElementExecutionDebuggerState
    extends State<NextGreaterElementExecutionDebugger> {
  final List<String> _codeLines = const [
    "vector<int> nextGreaterElement(vector<int>& arr) {",
    "    int n = arr.size();",
    "    vector<int> res(n, -1);",
    "    stack<int> st;",
    "    for (int i = n - 1; i >= 0; i--) {",
    "        while (!st.empty() && st.top() <= arr[i]) st.pop();",
    "        if (!st.empty()) res[i] = st.top();",
    "        st.push(arr[i]);",
    "    }",
    "    return res;",
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
        activeLineIndex: 0,
        index: -1,
        currVal: -1,
        topVal: "-",
        stackContent: [],
        explanationEn: "Line 1: Entry into nextGreaterElement(arr). Array = [2, 1, 2, 4, 3].",
        explanationBn: "লাইন ১: nextGreaterElement(arr) এ প্রবেশ। অ্যারে = [2, 1, 2, 4, 3]।",
      ),
      DebuggerStepData(
        activeLineIndex: 5,
        index: 4,
        currVal: 3,
        topVal: "EMPTY",
        stackContent: [],
        conditionText: "st.empty() -> Loop skipped",
        explanationEn: "Line 6: i = 4 (val = 3). st is empty -> skip pop loop.",
        explanationBn: "লাইন ৬: i = ৪ (মান = ৩)। স্ট্যাক খালি -> পপ লুপ স্কিপ।",
      ),
      DebuggerStepData(
        activeLineIndex: 7,
        index: 4,
        currVal: 3,
        topVal: "3",
        stackContent: [3],
        conditionText: "res[4] = -1; st.push(3)",
        explanationEn: "Line 8: res[4] remains -1. Push 3 onto Stack.",
        explanationBn: "লাইন ৮: res[4] = -1 রয়ে গেল। ৩ কে স্ট্যাকে পুশ করি।",
      ),
      DebuggerStepData(
        activeLineIndex: 5,
        index: 3,
        currVal: 4,
        topVal: "EMPTY",
        stackContent: [],
        conditionText: "st.top() (3) <= 4 -> st.pop()",
        explanationEn: "Line 6: i = 3 (val = 4). Pop 3 since 3 <= 4. Stack becomes empty.",
        explanationBn: "লাইন ৬: i = ৩ (মান = ৪)। ৩ <= ৪ হওয়ায় ৩ পপ করা হলো। স্ট্যাক খালি।",
      ),
      DebuggerStepData(
        activeLineIndex: 7,
        index: 3,
        currVal: 4,
        topVal: "4",
        stackContent: [4],
        conditionText: "res[3] = -1; st.push(4)",
        explanationEn: "Line 8: res[3] remains -1. Push 4 onto Stack.",
        explanationBn: "লাইন ৮: res[3] = -1 রইল। ৪ কে স্ট্যাকে পুশ করি।",
      ),
      DebuggerStepData(
        activeLineIndex: 6,
        index: 2,
        currVal: 2,
        topVal: "4",
        stackContent: [4, 2],
        conditionText: "st.top() (4) > 2 -> res[2] = 4",
        explanationEn: "Line 7: i = 2 (val = 2). Top is 4 (4 > 2). res[2] = 4! Push 2.",
        explanationBn: "লাইন ৭: i = ২ (মান = ২)। টপ ৪ (৪ > ২)। res[2] = ৪ সেট হলো! ২ পুশ।",
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
              ? "Line-by-Line Execution Debugger & LIFO Canvas"
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

        _buildVerticalStackCanvas(step),
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

  Widget _buildVerticalStackCanvas(DebuggerStepData step) {
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
            widget.isEnglish ? "Monotonic Stack Memory Canvas" : "মনোটোনিক স্ট্যাক মেমোরি ক্যানভাস",
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 150,
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(14), bottomRight: Radius.circular(14)),
                  border: Border(left: BorderSide(color: AppTheme.accentGreen, width: 2), right: BorderSide(color: AppTheme.accentGreen, width: 2), bottom: BorderSide(color: AppTheme.accentGreen, width: 3)),
                ),
                child: Column(
                  children: [
                    Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 2), color: AppTheme.accentGreen.withOpacity(0.15), child: const Text("TOP", textAlign: TextAlign.center, style: TextStyle(color: AppTheme.accentGreen, fontSize: 9, fontWeight: FontWeight.bold))),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: SingleChildScrollView(
                          reverse: true,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (step.stackContent.isEmpty)
                                const Padding(padding: EdgeInsets.only(bottom: 20), child: Text("EMPTY", style: TextStyle(color: AppTheme.textMuted, fontSize: 10)))
                              else
                                ...List.generate(step.stackContent.length, (idx) {
                                  final itemIdx = step.stackContent.length - 1 - idx;
                                  final isTop = itemIdx == step.stackContent.length - 1;
                                  return Container(
                                    margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                                    padding: const EdgeInsets.symmetric(vertical: 4),
                                    width: double.infinity,
                                    decoration: BoxDecoration(color: isTop ? AppTheme.accentGreen.withOpacity(0.3) : AppTheme.surfaceDark, borderRadius: BorderRadius.circular(6), border: Border.all(color: isTop ? AppTheme.accentGreen : const Color(0xFF334155))),
                                    child: Text("${step.stackContent[itemIdx]}", textAlign: TextAlign.center, style: TextStyle(fontFamily: 'monospace', color: isTop ? AppTheme.accentGreen : Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                                  );
                                }),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
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
              const Icon(Icons.bug_report, color: AppTheme.accentPink, size: 18),
              const SizedBox(width: 8),
              Text(
                widget.isEnglish ? "Loop & Pointer Inspector" : "লুপ ও পয়েন্টার ইন্সপেক্টর",
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 10,
            children: [
              _buildVariableBadge("Index i", step.index == -1 ? "-" : "${step.index}", AppTheme.accentNeonCyan),
              _buildVariableBadge("arr[i]", step.currVal == -1 ? "-" : "${step.currVal}", AppTheme.accentPink),
              _buildVariableBadge("st.top()", step.topVal, AppTheme.accentGreen),
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
