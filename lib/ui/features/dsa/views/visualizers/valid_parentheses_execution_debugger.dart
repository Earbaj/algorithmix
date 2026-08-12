import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';

class ValidParenthesesExecutionDebugger extends StatefulWidget {
  final bool isEnglish;

  const ValidParenthesesExecutionDebugger({
    super.key,
    required this.isEnglish,
  });

  @override
  State<ValidParenthesesExecutionDebugger> createState() =>
      _ValidParenthesesExecutionDebuggerState();
}

class DebuggerStepData {
  final int activeLineIndex;
  final String currentChar;
  final String topChar;
  final List<String> stackContent;
  final String? conditionText;
  final String explanationEn;
  final String explanationBn;

  const DebuggerStepData({
    required this.activeLineIndex,
    required this.currentChar,
    required this.topChar,
    required this.stackContent,
    this.conditionText,
    required this.explanationEn,
    required this.explanationBn,
  });
}

class _ValidParenthesesExecutionDebuggerState
    extends State<ValidParenthesesExecutionDebugger> {
  final List<String> _codeLines = const [
    "bool isValid(string s) {",
    "    stack<char> st;",
    "    for (char c : s) {",
    "        if (c == '(' || c == '[' || c == '{') st.push(c);",
    "        else {",
    "            if (st.empty()) return false;",
    "            char top = st.top(); st.pop();",
    "            if ((c == ')' && top != '(') ||",
    "                (c == ']' && top != '[') ||",
    "                (c == '}' && top != '{')) return false;",
    "        }",
    "    }",
    "    return st.empty();",
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
        currentChar: "-",
        topChar: "-",
        stackContent: [],
        explanationEn: "Line 1: Entry into isValid(s). Input string s = \"([{}])\".",
        explanationBn: "লাইন ১: isValid(s) ফাংশনে প্রবেশ। ইনপুট s = \"([{}])\"।",
      ),
      DebuggerStepData(
        activeLineIndex: 1,
        currentChar: "-",
        topChar: "-",
        stackContent: [],
        conditionText: "stack<char> st initialized",
        explanationEn: "Line 2: Initialize empty stack 'st' for bracket tracking.",
        explanationBn: "লাইন ২: ব্র্যাকেট ট্র্যাকিংয়ের জন্য ফাঁকা স্ট্যাক 'st' তৈরি হলো।",
      ),
      DebuggerStepData(
        activeLineIndex: 3,
        currentChar: "(",
        topChar: "(",
        stackContent: ["("],
        conditionText: "c == '(' -> Push '(' onto stack",
        explanationEn: "Line 4: c = '('. Opening bracket found! Push '(' onto Top of Stack.",
        explanationBn: "লাইন ৪: c = '('। ওপেনিং ব্র্যাকেট পাওয়ায় স্ট্যাকের টপে পুশ করা হলো।",
      ),
      DebuggerStepData(
        activeLineIndex: 3,
        currentChar: "[",
        topChar: "[",
        stackContent: ["(", "["],
        conditionText: "c == '[' -> Push '[' onto stack",
        explanationEn: "Line 4: c = '['. Opening bracket found! Push '[' onto Top of Stack.",
        explanationBn: "লাইন ৪: c = '['। ওপেনিং ব্র্যাকেট পাওয়ায় স্ট্যাকের টপে পুশ করা হলো।",
      ),
      DebuggerStepData(
        activeLineIndex: 3,
        currentChar: "{",
        topChar: "{",
        stackContent: ["(", "[", "{"],
        conditionText: "c == '{' -> Push '{' onto stack",
        explanationEn: "Line 4: c = '{'. Opening bracket found! Push '{' onto Top of Stack.",
        explanationBn: "লাইন ৪: c = '{'। ওপেনিং ব্র্যাকেট পাওয়ায় স্ট্যাকের টপে পুশ করা হলো।",
      ),
      DebuggerStepData(
        activeLineIndex: 6,
        currentChar: "}",
        topChar: "{",
        stackContent: ["(", "["],
        conditionText: "char top = '{'; st.pop(); Match '}' == '{' -> SUCCESS!",
        explanationEn: "Line 7: c = '}'. Pop top bracket '{' from stack and verify match: Success!",
        explanationBn: "লাইন ৭: c = '}'। টপ ব্র্যাকেট '{' পপ করে ম্যাচ যাচাই করা হলো: সফল!",
      ),
      DebuggerStepData(
        activeLineIndex: 6,
        currentChar: "]",
        topChar: "[",
        stackContent: ["("],
        conditionText: "char top = '['; st.pop(); Match ']' == '[' -> SUCCESS!",
        explanationEn: "Line 7: c = ']'. Pop top bracket '[' from stack and verify match: Success!",
        explanationBn: "লাইন ৭: c = ']'। টপ ব্র্যাকেট '[' পপ করে ম্যাচ যাচাই করা হলো: সফল!",
      ),
      DebuggerStepData(
        activeLineIndex: 6,
        currentChar: ")",
        topChar: "(",
        stackContent: [],
        conditionText: "char top = '('; st.pop(); Match ')' == '(' -> SUCCESS!",
        explanationEn: "Line 7: c = ')'. Pop top bracket '(' from stack and verify match: Success!",
        explanationBn: "লাইন ৭: c = ')'। টপ ব্র্যাকেট '(' পপ করে ম্যাচ যাচাই করা হলো: সফল!",
      ),
      DebuggerStepData(
        activeLineIndex: 12,
        currentChar: "-",
        topChar: "-",
        stackContent: [],
        conditionText: "st.empty() == TRUE -> Return TRUE",
        explanationEn: "Line 13: Loop ends. st.empty() is TRUE! String is Valid! Return true 🎉",
        explanationBn: "লাইন ১৩: লুপ শেষ। st.empty() সত্য! রিটার্ন true 🎉",
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
              ? "Line-by-Line Execution Debugger & LIFO Stack Canvas"
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
            widget.isEnglish ? "Vertical LIFO Stack Memory Canvas" : "ভার্টিক্যাল LIFO স্ট্যাক মেমোরি ক্যানভাস",
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 160,
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(14),
                    bottomRight: Radius.circular(14),
                  ),
                  border: Border(
                    left: BorderSide(color: AppTheme.accentGreen, width: 2),
                    right: BorderSide(color: AppTheme.accentGreen, width: 2),
                    bottom: BorderSide(color: AppTheme.accentGreen, width: 3),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      color: AppTheme.accentGreen.withOpacity(0.15),
                      child: const Text("TOP", textAlign: TextAlign.center, style: TextStyle(color: AppTheme.accentGreen, fontSize: 9, fontWeight: FontWeight.bold)),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: SingleChildScrollView(
                          reverse: true,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (step.stackContent.isEmpty)
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 20),
                                  child: Text("EMPTY", style: TextStyle(color: AppTheme.textMuted, fontSize: 10)),
                                )
                              else
                                ...List.generate(step.stackContent.length, (idx) {
                                  final itemIdx = step.stackContent.length - 1 - idx;
                                  final item = step.stackContent[itemIdx];
                                  final isTop = itemIdx == step.stackContent.length - 1;

                                  return Container(
                                    margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                                    padding: const EdgeInsets.symmetric(vertical: 6),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: isTop ? AppTheme.accentGreen.withOpacity(0.3) : AppTheme.surfaceDark,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: isTop ? AppTheme.accentGreen : const Color(0xFF334155)),
                                    ),
                                    child: Text(
                                      item,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontFamily: 'monospace', color: isTop ? AppTheme.accentGreen : Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                                    ),
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
                widget.isEnglish ? "Variable & Stack Inspector" : "ভ্যারিয়েবল ও স্ট্যাক ইন্সপেক্টর",
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 10,
            children: [
              _buildVariableBadge("c (char)", step.currentChar, AppTheme.accentNeonCyan),
              _buildVariableBadge("st.top()", step.topChar, AppTheme.accentGreen),
              _buildVariableBadge("st.size()", "${step.stackContent.length}", Colors.purpleAccent),
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
