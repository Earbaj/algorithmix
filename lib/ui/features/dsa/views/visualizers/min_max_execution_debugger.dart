import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';

class MinMaxExecutionDebugger extends StatefulWidget {
  final bool isEnglish;

  const MinMaxExecutionDebugger({
    super.key,
    required this.isEnglish,
  });

  @override
  State<MinMaxExecutionDebugger> createState() => _MinMaxExecutionDebuggerState();
}

class DebuggerStepData {
  final int activeLineIndex;
  final int? i;
  final int? currentArrVal;
  final int? minVal;
  final int? maxVal;
  final String? conditionText;
  final String explanationEn;
  final String explanationBn;

  const DebuggerStepData({
    required this.activeLineIndex,
    this.i,
    this.currentArrVal,
    this.minVal,
    this.maxVal,
    this.conditionText,
    required this.explanationEn,
    required this.explanationBn,
  });
}

class _MinMaxExecutionDebuggerState extends State<MinMaxExecutionDebugger> {
  final List<String> _codeLines = const [
    "pair<int, int> findMinMax(vector<int>& arr) {",
    "    int minVal = arr[0], maxVal = arr[0];",
    "    for (int i = 1; i < arr.size(); i++) {",
    "        if (arr[i] < minVal) minVal = arr[i];",
    "        if (arr[i] > maxVal) maxVal = arr[i];",
    "    }",
    "    return {minVal, maxVal};",
    "}",
  ];

  final List<int> _array = const [15, 42, 8, 99, 23];
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
        explanationEn: "Line 1: Entry into function findMinMax(arr) with arr = [15, 42, 8, 99, 23].",
        explanationBn: "লাইন ১: findMinMax(arr) ফাংশনে প্রবেশ, যেখানে arr = [15, 42, 8, 99, 23]।",
      ),
      DebuggerStepData(
        activeLineIndex: 1,
        i: 0,
        currentArrVal: 15,
        minVal: 15,
        maxVal: 15,
        conditionText: "arr[0] = 15",
        explanationEn: "Line 2: Variable Initialization: minVal = arr[0] (15), maxVal = arr[0] (15).",
        explanationBn: "লাইন ২: ভ্যারিয়েবল ডিক্লেয়ার: minVal = 15 এবং maxVal = 15 সেটিং।",
      ),
      DebuggerStepData(
        activeLineIndex: 2,
        i: 1,
        currentArrVal: 42,
        minVal: 15,
        maxVal: 15,
        conditionText: "i = 1; (1 < 5) -> TRUE",
        explanationEn: "Line 3: Loop Start: i = 1. Condition 1 < 5 is TRUE. Enter loop body.",
        explanationBn: "লাইন ৩: লুপ শুরু: i = 1। শর্ত 1 < 5 সত্য (TRUE)। লুপের ভেতরে প্রবেশ।",
      ),
      DebuggerStepData(
        activeLineIndex: 3,
        i: 1,
        currentArrVal: 42,
        minVal: 15,
        maxVal: 15,
        conditionText: "42 < 15 -> FALSE",
        explanationEn: "Line 4: Check if (arr[1] < minVal) -> 42 < 15 (FALSE). minVal remains 15.",
        explanationBn: "লাইন ৪: শর্ত চেক if (arr[1] < minVal) -> 42 < 15 মিথ্যা (FALSE)। minVal অপরিবর্তিত।",
      ),
      DebuggerStepData(
        activeLineIndex: 4,
        i: 1,
        currentArrVal: 42,
        minVal: 15,
        maxVal: 42,
        conditionText: "42 > 15 -> TRUE (Update maxVal)",
        explanationEn: "Line 5: Check if (arr[1] > maxVal) -> 42 > 15 (TRUE!). Update maxVal = 42.",
        explanationBn: "লাইন ৫: শর্ত চেক if (arr[1] > maxVal) -> 42 > 15 সত্য (TRUE)! maxVal = 42 আপডেট হলো।",
      ),
      DebuggerStepData(
        activeLineIndex: 2,
        i: 2,
        currentArrVal: 8,
        minVal: 15,
        maxVal: 42,
        conditionText: "i++ -> i = 2; (2 < 5) -> TRUE",
        explanationEn: "Line 3: Increment i++ -> i = 2. Condition 2 < 5 is TRUE.",
        explanationBn: "লাইন ৩: লুপ ইনক্রিমেন্ট i++ -> i = 2। শর্ত 2 < 5 সত্য (TRUE)।",
      ),
      DebuggerStepData(
        activeLineIndex: 3,
        i: 2,
        currentArrVal: 8,
        minVal: 8,
        maxVal: 42,
        conditionText: "8 < 15 -> TRUE (Update minVal)",
        explanationEn: "Line 4: Check if (arr[2] < minVal) -> 8 < 15 (TRUE!). Update minVal = 8.",
        explanationBn: "লাইন ৪: শর্ত চেক if (arr[2] < minVal) -> 8 < 15 সত্য (TRUE)! minVal = 8 আপডেট হলো।",
      ),
      DebuggerStepData(
        activeLineIndex: 4,
        i: 2,
        currentArrVal: 8,
        minVal: 8,
        maxVal: 42,
        conditionText: "8 > 42 -> FALSE",
        explanationEn: "Line 5: Check if (arr[2] > maxVal) -> 8 > 42 (FALSE). maxVal remains 42.",
        explanationBn: "লাইন ৫: শর্ত চেক if (arr[2] > maxVal) -> 8 > 42 মিথ্যা (FALSE)। maxVal অপরিবর্তিত।",
      ),
      DebuggerStepData(
        activeLineIndex: 2,
        i: 3,
        currentArrVal: 99,
        minVal: 8,
        maxVal: 42,
        conditionText: "i++ -> i = 3; (3 < 5) -> TRUE",
        explanationEn: "Line 3: Increment i++ -> i = 3. Condition 3 < 5 is TRUE.",
        explanationBn: "লাইন ৩: লুপ ইনক্রিমেন্ট i++ -> i = 3। শর্ত 3 < 5 সত্য (TRUE)।",
      ),
      DebuggerStepData(
        activeLineIndex: 3,
        i: 3,
        currentArrVal: 99,
        minVal: 8,
        maxVal: 42,
        conditionText: "99 < 8 -> FALSE",
        explanationEn: "Line 4: Check if (arr[3] < minVal) -> 99 < 8 (FALSE). minVal remains 8.",
        explanationBn: "লাইন ৪: শর্ত চেক if (arr[3] < minVal) -> 99 < 8 মিথ্যা (FALSE)। minVal অপরিবর্তিত।",
      ),
      DebuggerStepData(
        activeLineIndex: 4,
        i: 3,
        currentArrVal: 99,
        minVal: 8,
        maxVal: 99,
        conditionText: "99 > 42 -> TRUE (Update maxVal)",
        explanationEn: "Line 5: Check if (arr[3] > maxVal) -> 99 > 42 (TRUE!). Update maxVal = 99.",
        explanationBn: "লাইন ৫: শর্ত চেক if (arr[3] > maxVal) -> 99 > 42 সত্য (TRUE)! maxVal = 99 আপডেট হলো।",
      ),
      DebuggerStepData(
        activeLineIndex: 2,
        i: 4,
        currentArrVal: 23,
        minVal: 8,
        maxVal: 99,
        conditionText: "i++ -> i = 4; (4 < 5) -> TRUE",
        explanationEn: "Line 3: Increment i++ -> i = 4. Condition 4 < 5 is TRUE.",
        explanationBn: "লাইন ৩: লুপ ইনক্রিমেন্ট i++ -> i = 4। শর্ত 4 < 5 সত্য (TRUE)।",
      ),
      DebuggerStepData(
        activeLineIndex: 3,
        i: 4,
        currentArrVal: 23,
        minVal: 8,
        maxVal: 99,
        conditionText: "23 < 8 -> FALSE",
        explanationEn: "Line 4: Check if (arr[4] < minVal) -> 23 < 8 (FALSE). minVal remains 8.",
        explanationBn: "লাইন ৪: শর্ত চেক if (arr[4] < minVal) -> 23 < 8 মিথ্যা (FALSE)। minVal অপরিবর্তিত।",
      ),
      DebuggerStepData(
        activeLineIndex: 4,
        i: 4,
        currentArrVal: 23,
        minVal: 8,
        maxVal: 99,
        conditionText: "23 > 99 -> FALSE",
        explanationEn: "Line 5: Check if (arr[4] > maxVal) -> 23 > 99 (FALSE). maxVal remains 99.",
        explanationBn: "লাইন ৫: শর্ত চেক if (arr[4] > maxVal) -> 23 > 99 মিথ্যা (FALSE)। maxVal অপরিবর্তিত।",
      ),
      DebuggerStepData(
        activeLineIndex: 2,
        i: 5,
        minVal: 8,
        maxVal: 99,
        conditionText: "i++ -> i = 5; (5 < 5) -> FALSE (Exit loop)",
        explanationEn: "Line 3: Increment i++ -> i = 5. Condition 5 < 5 is FALSE! Exit loop.",
        explanationBn: "লাইন ৩: লুপ ইনক্রিমেন্ট i++ -> i = 5। শর্ত 5 < 5 মিথ্যা (FALSE)! লুপ শেষ।",
      ),
      DebuggerStepData(
        activeLineIndex: 6,
        i: 5,
        minVal: 8,
        maxVal: 99,
        conditionText: "Return {8, 99}",
        explanationEn: "Line 7: Return final result {minVal: 8, maxVal: 99}. Debugger finished 🎉",
        explanationBn: "লাইন ৭: চূড়ান্ত ফলাফল {minVal: 8, maxVal: 99} রিটার্ন করা হলো। এক্সিকিউশন সমাপ্ত 🎉",
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
        // Title & Step Banner
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

        // Code Box with Active Line Highlight
        _buildCodeHighlightBox(step.activeLineIndex),
        const SizedBox(height: 16),

        // Array Memory State Canvas
        _buildArrayCanvas(step),
        const SizedBox(height: 16),

        // Variable Watcher & State Inspector Panel
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
    final currentI = step.i;

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
                widget.isEnglish ? "Array Memory & Index Pointer Canvas" : "অ্যারে মেমোরি ও ইন্ডেক্স পয়েন্টার ক্যানভাস",
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
              ),
              if (currentI != null && currentI < _array.length)
                Text(
                  "i = $currentI (arr[$currentI] = ${_array[currentI]})",
                  style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12),
                ),
            ],
          ),
          const SizedBox(height: 14),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_array.length, (idx) {
                final val = _array[idx];
                final isCurrentIndex = currentI == idx;
                final isMinVal = step.minVal == val;
                final isMaxVal = step.maxVal == val;

                Color borderColor = const Color(0xFF334155);
                Color bgColor = const Color(0xFF1E293B);

                if (isCurrentIndex) {
                  borderColor = AppTheme.accentNeonCyan;
                  bgColor = AppTheme.accentNeonCyan.withOpacity(0.2);
                } else if (isMinVal) {
                  borderColor = AppTheme.accentGreen;
                  bgColor = AppTheme.accentGreen.withOpacity(0.15);
                } else if (isMaxVal) {
                  borderColor = AppTheme.accentAmber;
                  bgColor = AppTheme.accentAmber.withOpacity(0.15);
                }

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  width: 56,
                  height: 68,
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: borderColor, width: isCurrentIndex ? 2.5 : 1.5),
                    boxShadow: isCurrentIndex
                        ? [BoxShadow(color: AppTheme.accentNeonCyan.withOpacity(0.3), blurRadius: 8)]
                        : [],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "[$idx]",
                        style: TextStyle(
                          fontSize: 10,
                          color: isCurrentIndex ? AppTheme.accentNeonCyan : AppTheme.textSecondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "$val",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isCurrentIndex
                              ? Colors.white
                              : isMinVal
                                  ? AppTheme.accentGreen
                                  : isMaxVal
                                      ? AppTheme.accentAmber
                                      : Colors.white70,
                        ),
                      ),
                      if (isCurrentIndex)
                        const Icon(Icons.arrow_drop_up, color: AppTheme.accentNeonCyan, size: 14),
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
                widget.isEnglish ? "Variable Watch & Expression Evaluator" : "ভ্যারিয়েবল ওয়াচ ও কন্ডিশন এভালুয়েটর",
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Grid of Variables
          Wrap(
            spacing: 12,
            runSpacing: 10,
            children: [
              _buildVariableBadge("i (index)", step.i != null ? "${step.i}" : "-", Colors.purpleAccent),
              _buildVariableBadge("arr[i]", step.currentArrVal != null ? "${step.currentArrVal}" : "-", AppTheme.accentNeonCyan),
              _buildVariableBadge("minVal", step.minVal != null ? "${step.minVal}" : "-", AppTheme.accentGreen),
              _buildVariableBadge("maxVal", step.maxVal != null ? "${step.maxVal}" : "-", AppTheme.accentAmber),
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
                      "Condition: ${step.conditionText}",
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
