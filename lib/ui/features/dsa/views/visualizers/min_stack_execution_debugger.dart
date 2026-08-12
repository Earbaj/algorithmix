import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';

class MinStackExecutionDebugger extends StatefulWidget {
  final bool isEnglish;

  const MinStackExecutionDebugger({
    super.key,
    required this.isEnglish,
  });

  @override
  State<MinStackExecutionDebugger> createState() => _MinStackExecutionDebuggerState();
}

class DebuggerStepData {
  final int activeLineIndex;
  final String opText;
  final List<int> mainStack;
  final List<int> minStack;
  final String explanationEn;
  final String explanationBn;

  const DebuggerStepData({
    required this.activeLineIndex,
    required this.opText,
    required this.mainStack,
    required this.minStack,
    required this.explanationEn,
    required this.explanationBn,
  });
}

class _MinStackExecutionDebuggerState extends State<MinStackExecutionDebugger> {
  final List<String> _codeLines = const [
    "class MinStack {",
    "    stack<int> st, minSt;",
    "public:",
    "    void push(int val) {",
    "        st.push(val);",
    "        if (minSt.empty() || val <= minSt.top()) minSt.push(val);",
    "        else minSt.push(minSt.top());",
    "    }",
    "    void pop() { st.pop(); minSt.pop(); }",
    "    int getMin() { return minSt.top(); }",
    "};",
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
        opText: "MinStack()",
        mainStack: [],
        minStack: [],
        explanationEn: "Line 1: Instantiating MinStack object.",
        explanationBn: "লাইন ১: MinStack অবজেক্ট ইন্সট্যানশিয়েট করা হলো।",
      ),
      DebuggerStepData(
        activeLineIndex: 4,
        opText: "push(-2)",
        mainStack: [-2],
        minStack: [-2],
        explanationEn: "Line 5: st.push(-2). minSt is empty, so minSt.push(-2).",
        explanationBn: "লাইন ৫: st.push(-2)। minSt খালি থাকায় minSt.push(-2)।",
      ),
      DebuggerStepData(
        activeLineIndex: 4,
        opText: "push(0)",
        mainStack: [-2, 0],
        minStack: [-2, -2],
        explanationEn: "Line 5: st.push(0). 0 > minSt.top() (-2), so minSt.push(-2).",
        explanationBn: "লাইন ৫: st.push(0)। 0 > minSt.top() (-2) থাকায় minSt এ -2 রিপিট পুশ।",
      ),
      DebuggerStepData(
        activeLineIndex: 5,
        opText: "push(-3)",
        mainStack: [-2, 0, -3],
        minStack: [-2, -2, -3],
        explanationEn: "Line 6: st.push(-3). -3 <= minSt.top() (-2) -> TRUE! minSt.push(-3).",
        explanationBn: "লাইন ৬: -3 <= minSt.top() (-2) সত্য! minSt এ -3 পুশ করা হলো।",
      ),
      DebuggerStepData(
        activeLineIndex: 9,
        opText: "getMin() -> -3",
        mainStack: [-2, 0, -3],
        minStack: [-2, -2, -3],
        explanationEn: "Line 10: getMin() returns minSt.top() = -3 in O(1) time!",
        explanationBn: "লাইন ১০: getMin() O(1) টাইমে minSt.top() = -3 রিটার্ন করে!",
      ),
      DebuggerStepData(
        activeLineIndex: 8,
        opText: "pop()",
        mainStack: [-2, 0],
        minStack: [-2, -2],
        explanationEn: "Line 9: st.pop() removes -3; minSt.pop() removes -3.",
        explanationBn: "লাইন ৯: st.pop() ও minSt.pop() উভয় স্ট্যাকের টপ পপ করে।",
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
              ? "Line-by-Line Execution Debugger & Dual Canvas"
              : "লাইন-বাই-লাইন এক্সিকিউশন ডিবাগার ও ডুয়েল ক্যানভাস",
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

        _buildDualStackCanvas(step),
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

  Widget _buildDualStackCanvas(DebuggerStepData step) {
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
            widget.isEnglish ? "MinStack Dual Memory Canvas" : "MinStack ডুয়েল মেমোরি ক্যানভাস",
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildBucket("st", step.mainStack, AppTheme.accentGreen),
              _buildBucket("minSt", step.minStack, AppTheme.accentPink),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBucket(String title, List<int> items, Color color) {
    return Column(
      children: [
        Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
        const SizedBox(height: 4),
        Container(
          width: 100,
          height: 140,
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
            border: Border(left: BorderSide(color: color, width: 2), right: BorderSide(color: color, width: 2), bottom: BorderSide(color: color, width: 3)),
          ),
          child: Column(
            children: [
              Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 2), color: color.withOpacity(0.15), child: Text("TOP", textAlign: TextAlign.center, style: TextStyle(color: color, fontSize: 8, fontWeight: FontWeight.bold))),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SingleChildScrollView(
                    reverse: true,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (items.isEmpty)
                          const Padding(padding: EdgeInsets.only(bottom: 14), child: Text("EMPTY", style: TextStyle(color: AppTheme.textMuted, fontSize: 9)))
                        else
                          ...List.generate(items.length, (idx) {
                            final itemIdx = items.length - 1 - idx;
                            final isTop = itemIdx == items.length - 1;
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              width: double.infinity,
                              decoration: BoxDecoration(color: isTop ? color.withOpacity(0.3) : AppTheme.surfaceDark, borderRadius: BorderRadius.circular(4), border: Border.all(color: isTop ? color : const Color(0xFF334155))),
                              child: Text("${items[itemIdx]}", textAlign: TextAlign.center, style: TextStyle(fontFamily: 'monospace', color: isTop ? color : Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
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
                widget.isEnglish ? "Pointer & State Watcher" : "পয়েন্টার ও স্টেট ওয়াচার",
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 10,
            children: [
              _buildVariableBadge("Operation", step.opText, AppTheme.accentNeonCyan),
              _buildVariableBadge("st.top()", step.mainStack.isNotEmpty ? "${step.mainStack.last}" : "EMPTY", AppTheme.accentGreen),
              _buildVariableBadge("getMin()", step.minStack.isNotEmpty ? "${step.minStack.last}" : "EMPTY", AppTheme.accentPink),
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
