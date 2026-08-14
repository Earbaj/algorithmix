import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class MonotonicStep {
  final int activeIndex;
  final int activeLineIndex;
  final List<int> stackIndices;
  final List<int> ansArray;
  final String explanationEn;
  final String explanationBn;

  const MonotonicStep({
    required this.activeIndex,
    required this.activeLineIndex,
    required this.stackIndices,
    required this.ansArray,
    required this.explanationEn,
    required this.explanationBn,
  });
}

class DailyTemperaturesVisualizer extends StatefulWidget {
  final bool isEnglish;

  const DailyTemperaturesVisualizer({super.key, required this.isEnglish});

  @override
  State<DailyTemperaturesVisualizer> createState() => _DailyTemperaturesVisualizerState();
}

class _DailyTemperaturesVisualizerState extends State<DailyTemperaturesVisualizer> {
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  final List<String> _codeLines = const [
    "vector<int> dailyTemperatures(vector<int>& temp) {",
    "    int n = temp.size(); vector<int> ans(n, 0); stack<int> st;",
    "    for (int i = 0; i < n; i++) {",
    "        while (!st.empty() && temp[i] > temp[st.top()]) {",
    "            int prevIdx = st.top(); st.pop();",
    "            ans[prevIdx] = i - prevIdx; // Calculate wait days!",
    "        }",
    "        st.push(i);",
    "    }",
    "    return ans;",
    "}",
  ];

  final List<MonotonicStep> _steps = const [
    MonotonicStep(
      activeIndex: 0,
      activeLineIndex: 7,
      stackIndices: [0],
      ansArray: [0, 0, 0, 0],
      explanationEn: "Line 8: i=0 (T=73). Stack empty -> Push index 0 (T=73). Stack = [0].",
      explanationBn: "লাইন ৮: i=0 (T=73)। স্ট্যাক খালি -> ইনডেক্স ০ পুশ। Stack = [0]।",
    ),
    MonotonicStep(
      activeIndex: 1,
      activeLineIndex: 5,
      stackIndices: [1],
      ansArray: [1, 0, 0, 0],
      explanationEn: "Line 6: i=1 (T=74) > T[0] (73)! Pop 0: ans[0] = 1 - 0 = 1 day. Push index 1.",
      explanationBn: "লাইন ৬: i=1 (T=74) > T[0] (73)! ইনডেক্স 0 পপ: ans[0] = 1 - 0 = 1 দিন। ইনডেক্স 1 পুশ।",
    ),
    MonotonicStep(
      activeIndex: 2,
      activeLineIndex: 7,
      stackIndices: [1, 2],
      ansArray: [1, 0, 0, 0],
      explanationEn: "Line 8: i=2 (T=71) < T[1] (74). Push index 2. Stack = [1, 2].",
      explanationBn: "লাইন ৮: i=2 (T=71) < T[1] (74)। ইনডেক্স 2 পুশ। Stack = [1, 2]।",
    ),
    MonotonicStep(
      activeIndex: 3,
      activeLineIndex: 5,
      stackIndices: [3],
      ansArray: [1, 1, 1, 0],
      explanationEn: "Line 6: i=3 (T=75) > T[2](71) & T[1](74)! Pop 2 (ans[2]=1), Pop 1 (ans[1]=2). Push index 3.",
      explanationBn: "লাইন ৬: i=3 (T=75) > T[2] ও T[1]! ২ ও ১ পপ: ans[2]=1, ans[1]=2 দিন। ইনডেক্স 3 পুশ।",
    ),
    MonotonicStep(
      activeIndex: 3,
      activeLineIndex: 9,
      stackIndices: [3],
      ansArray: [1, 2, 1, 0],
      explanationEn: "🎉 Line 10: Daily Temperatures Completed! Answer array = [1, 2, 1, 0]!",
      explanationBn: "🎉 লাইন ১০: ডেইলি টেম্পারেচার্স সম্পন্ন! উত্তর এরে = [1, 2, 1, 0]!",
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
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: step.activeLineIndex == 9 ? AppTheme.accentGreen.withOpacity(0.15) : AppTheme.accentNeonCyan.withOpacity(0.15),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: step.activeLineIndex == 9 ? AppTheme.accentGreen : AppTheme.accentNeonCyan),
          ),
          child: Text(
            widget.isEnglish ? step.explanationEn : step.explanationBn,
            style: TextStyle(
              color: step.activeLineIndex == 9 ? AppTheme.accentGreen : AppTheme.accentNeonCyan,
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
              _buildCanvas(step),
            ],
          )
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildCodeSnippetWithHighlight(_codeLines, step.activeLineIndex)),
              const SizedBox(width: 16),
              Expanded(child: _buildCanvas(step)),
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

  Widget _buildCanvas(MonotonicStep step) {
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Stack Indices: ${step.stackIndices}", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13)),
              Text("Ans: ${step.ansArray}", style: const TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 16),
          const Text("Stack Visual (Top to Bottom):", style: TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
          const SizedBox(height: 8),
          Column(
            children: step.stackIndices.reversed.map((idxVal) {
              return Container(
                margin: const EdgeInsets.only(bottom: 4),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.accentPurple.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppTheme.accentPurple),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Index: $idxVal", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                    const Text("Top Node", style: TextStyle(color: AppTheme.accentNeonCyan, fontSize: 11)),
                  ],
                ),
              );
            }).toList(),
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
