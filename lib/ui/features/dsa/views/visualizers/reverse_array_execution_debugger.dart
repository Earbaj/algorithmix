import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';

class ReverseArrayExecutionDebugger extends StatefulWidget {
  final bool isEnglish;

  const ReverseArrayExecutionDebugger({
    super.key,
    required this.isEnglish,
  });

  @override
  State<ReverseArrayExecutionDebugger> createState() => _ReverseArrayExecutionDebuggerState();
}

class DebuggerStepData {
  final int activeLineIndex;
  final int? left;
  final int? right;
  final List<int> arrayState;
  final String? conditionText;
  final String explanationEn;
  final String explanationBn;

  const DebuggerStepData({
    required this.activeLineIndex,
    this.left,
    this.right,
    required this.arrayState,
    this.conditionText,
    required this.explanationEn,
    required this.explanationBn,
  });
}

class _ReverseArrayExecutionDebuggerState extends State<ReverseArrayExecutionDebugger> {
  final List<String> _codeLines = const [
    "void reverseArray(vector<int>& arr) {",
    "    int left = 0, right = arr.size() - 1;",
    "    while (left < right) {",
    "        swap(arr[left], arr[right]);",
    "        left++; right--;",
    "    }",
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
        arrayState: [1, 2, 3, 4, 5],
        explanationEn: "Line 1: Entry into function reverseArray(arr) with arr = [1, 2, 3, 4, 5].",
        explanationBn: "লাইন ১: reverseArray(arr) ফাংশনে প্রবেশ, যেখানে arr = [1, 2, 3, 4, 5]।",
      ),
      DebuggerStepData(
        activeLineIndex: 1,
        left: 0,
        right: 4,
        arrayState: [1, 2, 3, 4, 5],
        conditionText: "left = 0, right = 4",
        explanationEn: "Line 2: Initialize left = 0 and right = arr.size() - 1 (4).",
        explanationBn: "লাইন ২: পয়েন্টার সূচনা: left = 0 এবং right = 4 সেট করা হলো।",
      ),
      DebuggerStepData(
        activeLineIndex: 2,
        left: 0,
        right: 4,
        arrayState: [1, 2, 3, 4, 5],
        conditionText: "(0 < 4) -> TRUE",
        explanationEn: "Line 3: Loop condition check while (left < right) -> 0 < 4 is TRUE. Enter loop.",
        explanationBn: "লাইন ৩: শর্ত চেক (0 < 4) সত্য (TRUE)। লুপে প্রবেশ করুন।",
      ),
      DebuggerStepData(
        activeLineIndex: 3,
        left: 0,
        right: 4,
        arrayState: [5, 2, 3, 4, 1],
        conditionText: "swap(arr[0], arr[4])",
        explanationEn: "Line 4: Swap arr[0] (1) and arr[4] (5). Memory state becomes [5, 2, 3, 4, 1].",
        explanationBn: "লাইন ৪: মেমোরিতে arr[0] (1) এবং arr[4] (5) অদলবদল করা হলো।",
      ),
      DebuggerStepData(
        activeLineIndex: 4,
        left: 1,
        right: 3,
        arrayState: [5, 2, 3, 4, 1],
        conditionText: "left++ -> 1, right-- -> 3",
        explanationEn: "Line 5: Advance left++ (1) and decrement right-- (3).",
        explanationBn: "লাইন ৫: পয়েন্টার পরিবর্তন: left = 1 এবং right = 3।",
      ),
      DebuggerStepData(
        activeLineIndex: 2,
        left: 1,
        right: 3,
        arrayState: [5, 2, 3, 4, 1],
        conditionText: "(1 < 3) -> TRUE",
        explanationEn: "Line 3: Check condition while (left < right) -> 1 < 3 is TRUE. Continue loop.",
        explanationBn: "লাইন ৩: শর্ত চেক (1 < 3) সত্য (TRUE)। লুপ চলবে।",
      ),
      DebuggerStepData(
        activeLineIndex: 3,
        left: 1,
        right: 3,
        arrayState: [5, 4, 3, 2, 1],
        conditionText: "swap(arr[1], arr[3])",
        explanationEn: "Line 4: Swap arr[1] (2) and arr[3] (4). Memory state becomes [5, 4, 3, 2, 1].",
        explanationBn: "লাইন ৪: মেমোরিতে arr[1] (2) এবং arr[3] (4) অদলবদল করা হলো।",
      ),
      DebuggerStepData(
        activeLineIndex: 4,
        left: 2,
        right: 2,
        arrayState: [5, 4, 3, 2, 1],
        conditionText: "left++ -> 2, right-- -> 2",
        explanationEn: "Line 5: Advance left++ (2) and decrement right-- (2).",
        explanationBn: "লাইন ৫: পয়েন্টার পরিবর্তন: left = 2 এবং right = 2।",
      ),
      DebuggerStepData(
        activeLineIndex: 2,
        left: 2,
        right: 2,
        arrayState: [5, 4, 3, 2, 1],
        conditionText: "(2 < 2) -> FALSE (Exit loop)",
        explanationEn: "Line 3: Check condition while (left < right) -> 2 < 2 is FALSE! Exit loop.",
        explanationBn: "লাইন ৩: শর্ত চেক (2 < 2) মিথ্যা (FALSE)! লুপ সমাপ্ত।",
      ),
      DebuggerStepData(
        activeLineIndex: 6,
        left: 2,
        right: 2,
        arrayState: [5, 4, 3, 2, 1],
        conditionText: "Reversal Complete",
        explanationEn: "Line 7: Function execution finished. Reversed array [5, 4, 3, 2, 1] 🎉",
        explanationBn: "লাইন ৭: ফাংশন এক্সিকিউশন সম্পূর্ণ! উল্টানো অ্যারে [5, 4, 3, 2, 1] 🎉",
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
        // Title Banner
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

        // Code Highlight Box
        _buildCodeHighlightBox(step.activeLineIndex),
        const SizedBox(height: 16),

        // Array Canvas
        _buildArrayCanvas(step),
        const SizedBox(height: 16),

        // Variable Watch Panel
        _buildVariableWatchPanel(step),
        const SizedBox(height: 16),

        // Controls
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

  Widget _buildArrayCanvas(DebuggerStepData step) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.isEnglish ? "Memory & Array State Canvas" : "মেমোরি ও অ্যারে স্টেট ক্যানভাস",
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
              ),
              if (step.left != null && step.right != null && step.left! >= 0 && step.right! < step.arrayState.length)
                Text(
                  "left: ${step.left}, right: ${step.right}",
                  style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12),
                ),
            ],
          ),
          const SizedBox(height: 14),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(step.arrayState.length, (idx) {
                final val = step.arrayState[idx];
                final isLeft = step.left == idx;
                final isRight = step.right == idx;

                Color borderColor = const Color(0xFF334155);
                Color bgColor = const Color(0xFF1E293B);

                if (isLeft && isRight) {
                  borderColor = AppTheme.accentPurple;
                  bgColor = AppTheme.accentPurple.withOpacity(0.2);
                } else if (isLeft) {
                  borderColor = AppTheme.accentGreen;
                  bgColor = AppTheme.accentGreen.withOpacity(0.2);
                } else if (isRight) {
                  borderColor = AppTheme.accentAmber;
                  bgColor = AppTheme.accentAmber.withOpacity(0.2);
                }

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  width: 56,
                  height: 68,
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: borderColor, width: (isLeft || isRight) ? 2.5 : 1.5),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "[$idx]",
                        style: TextStyle(
                          fontSize: 10,
                          color: isLeft
                              ? AppTheme.accentGreen
                              : isRight
                                  ? AppTheme.accentAmber
                                  : AppTheme.textSecondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "$val",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isLeft
                              ? AppTheme.accentGreen
                              : isRight
                                  ? AppTheme.accentAmber
                                  : Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
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
                widget.isEnglish ? "Variable Watch & Loop Evaluator" : "ভ্যারিয়েবল ওয়াচ ও লুপ এভালুয়েটর",
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 10,
            children: [
              _buildVariableBadge("left", step.left != null ? "${step.left}" : "-", AppTheme.accentGreen),
              _buildVariableBadge("right", step.right != null ? "${step.right}" : "-", AppTheme.accentAmber),
              _buildVariableBadge("arr[left]", (step.left != null && step.left! < step.arrayState.length) ? "${step.arrayState[step.left!]}" : "-", AppTheme.accentNeonCyan),
              _buildVariableBadge("arr[right]", (step.right != null && step.right! < step.arrayState.length) ? "${step.arrayState[step.right!]}" : "-", Colors.purpleAccent),
            ],
          ),
          if (step.conditionText != null) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: step.conditionText!.contains("TRUE")
                    ? AppTheme.accentGreen.withOpacity(0.15)
                    : step.conditionText!.contains("FALSE")
                        ? Colors.redAccent.withOpacity(0.15)
                        : AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: step.conditionText!.contains("TRUE")
                      ? AppTheme.accentGreen
                      : step.conditionText!.contains("FALSE")
                          ? Colors.redAccent
                          : AppTheme.textMuted,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    step.conditionText!.contains("TRUE")
                        ? Icons.check_circle_outline
                        : step.conditionText!.contains("FALSE")
                            ? Icons.highlight_off
                            : Icons.info_outline,
                    color: step.conditionText!.contains("TRUE")
                        ? AppTheme.accentGreen
                        : step.conditionText!.contains("FALSE")
                            ? Colors.redAccent
                            : Colors.white70,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Expression: ${step.conditionText}",
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: step.conditionText!.contains("TRUE")
                            ? AppTheme.accentGreen
                            : step.conditionText!.contains("FALSE")
                                ? Colors.redAccent
                                : Colors.white,
                      ),
                    ),
                  ),
                ],
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
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
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
