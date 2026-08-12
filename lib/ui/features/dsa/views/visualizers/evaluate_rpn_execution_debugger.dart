import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';

class EvaluateRpnExecutionDebugger extends StatefulWidget {
  final bool isEnglish;

  const EvaluateRpnExecutionDebugger({
    super.key,
    required this.isEnglish,
  });

  @override
  State<EvaluateRpnExecutionDebugger> createState() => _EvaluateRpnExecutionDebuggerState();
}

class DebuggerStepData {
  final int activeLineIndex;
  final String token;
  final String? operandB;
  final String? operandA;
  final List<int> stackContent;
  final String? conditionText;
  final String explanationEn;
  final String explanationBn;

  const DebuggerStepData({
    required this.activeLineIndex,
    required this.token,
    this.operandB,
    this.operandA,
    required this.stackContent,
    this.conditionText,
    required this.explanationEn,
    required this.explanationBn,
  });
}

class _EvaluateRpnExecutionDebuggerState extends State<EvaluateRpnExecutionDebugger> {
  final List<String> _codeLines = const [
    "int evalRPN(vector<string>& tokens) {",
    "    stack<int> st;",
    "    for (string& t : tokens) {",
    "        if (t == \"+\" || t == \"-\" || t == \"*\" || t == \"/\") {",
    "            int b = st.top(); st.pop();",
    "            int a = st.top(); st.pop();",
    "            if (t == \"+\") st.push(a + b);",
    "            else if (t == \"*\") st.push(a * b);",
    "        } else {",
    "            st.push(stoi(t));",
    "        }",
    "    }",
    "    return st.top();",
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
        token: "-",
        stackContent: [],
        explanationEn: "Line 1: Entry into evalRPN(tokens). Tokens = [\"2\", \"1\", \"+\", \"3\", \"*\"].",
        explanationBn: "লাইন ১: evalRPN(tokens) এ প্রবেশ। টোকেনস = [\"2\", \"1\", \"+\", \"3\", \"*\"|।",
      ),
      DebuggerStepData(
        activeLineIndex: 9,
        token: "2",
        stackContent: [2],
        conditionText: "st.push(stoi(\"2\"))",
        explanationEn: "Line 10: Token \"2\" is number -> push(2).",
        explanationBn: "লাইন ১০: টোকেন \"2\" একটি সংখ্যা -> push(2)।",
      ),
      DebuggerStepData(
        activeLineIndex: 9,
        token: "1",
        stackContent: [2, 1],
        conditionText: "st.push(stoi(\"1\"))",
        explanationEn: "Line 10: Token \"1\" is number -> push(1).",
        explanationBn: "লাইন ১০: টোকেন \"1\" একটি সংখ্যা -> push(1)।",
      ),
      DebuggerStepData(
        activeLineIndex: 4,
        token: "+",
        operandB: "1",
        operandA: "2",
        stackContent: [3],
        conditionText: "b = 1, a = 2 -> push(2 + 1 = 3)",
        explanationEn: "Lines 5-7: Token \"+\" is operator! Pop b=1, a=2. Push (2 + 1 = 3).",
        explanationBn: "লাইন ৫-৭: টোকেন \"+\" একটি অপারেটর! b=1 ও a=2 পপ করে 2+1=3 পুশ করি।",
      ),
      DebuggerStepData(
        activeLineIndex: 9,
        token: "3",
        stackContent: [3, 3],
        conditionText: "st.push(stoi(\"3\"))",
        explanationEn: "Line 10: Token \"3\" is number -> push(3).",
        explanationBn: "লাইন ১০: টোকেন \"3\" একটি সংখ্যা -> push(3)।",
      ),
      DebuggerStepData(
        activeLineIndex: 7,
        token: "*",
        operandB: "3",
        operandA: "3",
        stackContent: [9],
        conditionText: "b = 3, a = 3 -> push(3 * 3 = 9)",
        explanationEn: "Lines 5-8: Token \"*\" is operator! Pop b=3, a=3. Push (3 * 3 = 9).",
        explanationBn: "লাইন ৫-৮: টোকেন \"*\" একটি অপারেটর! b=3 ও a=3 পপ করে 3*3=9 পুশ করি।",
      ),
      DebuggerStepData(
        activeLineIndex: 12,
        token: "-",
        stackContent: [9],
        conditionText: "return st.top() -> 9",
        explanationEn: "Line 13: Loop finished. Return top of stack = 9 🎉",
        explanationBn: "লাইন ১৩: লুপ সমাপ্ত। স্ট্যাকের টপ মান = 9 রিটার্ন করা হলো 🎉",
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
            widget.isEnglish ? "RPN Expression Stack Canvas" : "RPN এক্সপ্রেশন স্ট্যাক ক্যানভাস",
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
                widget.isEnglish ? "Operand & Operator Watcher" : "অপারেট ও অপারেটর ওয়াচার",
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 10,
            children: [
              _buildVariableBadge("Token (t)", step.token, AppTheme.accentNeonCyan),
              _buildVariableBadge("Pop b (1st)", step.operandB ?? "-", AppTheme.accentPink),
              _buildVariableBadge("Pop a (2nd)", step.operandA ?? "-", AppTheme.accentGreen),
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
