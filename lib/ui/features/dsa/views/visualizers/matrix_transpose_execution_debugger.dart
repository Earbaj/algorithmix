import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';

class MatrixTransposeExecutionDebugger extends StatefulWidget {
  final bool isEnglish;

  const MatrixTransposeExecutionDebugger({
    super.key,
    required this.isEnglish,
  });

  @override
  State<MatrixTransposeExecutionDebugger> createState() => _MatrixTransposeExecutionDebuggerState();
}

class DebuggerStepData {
  final int activeLineIndex;
  final int? r;
  final int? c;
  final int R;
  final int C;
  final List<List<int>> resMatrix;
  final String? conditionText;
  final String explanationEn;
  final String explanationBn;

  const DebuggerStepData({
    required this.activeLineIndex,
    this.r,
    this.c,
    required this.R,
    required this.C,
    required this.resMatrix,
    this.conditionText,
    required this.explanationEn,
    required this.explanationBn,
  });
}

class _MatrixTransposeExecutionDebuggerState extends State<MatrixTransposeExecutionDebugger> {
  final List<String> _codeLines = const [
    "vector<vector<int>> transposeMatrix(vector<vector<int>>& matrix) {",
    "    int R = matrix.size(), C = matrix[0].size();",
    "    vector<vector<int>> res(C, vector<int>(R));",
    "    for (int r = 0; r < R; r++) {",
    "        for (int c = 0; c < C; c++) {",
    "            res[c][r] = matrix[r][c];",
    "        }",
    "    }",
    "    return res;",
    "}",
  ];

  final List<List<int>> _inputMatrix = const [
    [1, 2, 3],
    [4, 5, 6],
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
        R: 2,
        C: 3,
        resMatrix: [
          [0, 0],
          [0, 0],
          [0, 0],
        ],
        explanationEn: "Line 1: Entry into function transposeMatrix(matrix). Input size: 2 rows x 3 cols.",
        explanationBn: "লাইন ১: transposeMatrix(matrix) ফাংশনে প্রবেশ। ইনপুট সাইজ: ২ সারি x ৩ কলাম।",
      ),
      DebuggerStepData(
        activeLineIndex: 1,
        R: 2,
        C: 3,
        resMatrix: [
          [0, 0],
          [0, 0],
          [0, 0],
        ],
        conditionText: "R = 2, C = 3",
        explanationEn: "Line 2: R = matrix.size() (2), C = matrix[0].size() (3).",
        explanationBn: "লাইন ২: R = 2 এবং C = 3 ডিক্লেয়ার ও এসাইন করা হলো।",
      ),
      DebuggerStepData(
        activeLineIndex: 2,
        R: 2,
        C: 3,
        resMatrix: [
          [0, 0],
          [0, 0],
          [0, 0],
        ],
        conditionText: "res matrix size: 3x2",
        explanationEn: "Line 3: Initialize result matrix 'res' of dimension C x R (3x2) with zeroes.",
        explanationBn: "লাইন ৩: ৩x২ আকারের রেজাল্ট ম্যাট্রিক্স 'res' শূন্য দিয়ে তৈরি করা হলো।",
      ),
      DebuggerStepData(
        activeLineIndex: 3,
        r: 0,
        R: 2,
        C: 3,
        resMatrix: [
          [0, 0],
          [0, 0],
          [0, 0],
        ],
        conditionText: "r = 0; (0 < 2) -> TRUE",
        explanationEn: "Line 4: Outer loop start r = 0. Check 0 < 2 is TRUE.",
        explanationBn: "লাইন ৪: আউটার লুপ শুরু r = 0। শর্ত 0 < 2 সত্য (TRUE)।",
      ),
      DebuggerStepData(
        activeLineIndex: 4,
        r: 0,
        c: 0,
        R: 2,
        C: 3,
        resMatrix: [
          [0, 0],
          [0, 0],
          [0, 0],
        ],
        conditionText: "c = 0; (0 < 3) -> TRUE",
        explanationEn: "Line 5: Inner loop start c = 0. Check 0 < 3 is TRUE.",
        explanationBn: "লাইন ৫: ইনার লুপ শুরু c = 0। শর্ত 0 < 3 সত্য (TRUE)।",
      ),
      DebuggerStepData(
        activeLineIndex: 5,
        r: 0,
        c: 0,
        R: 2,
        C: 3,
        resMatrix: [
          [1, 0],
          [0, 0],
          [0, 0],
        ],
        conditionText: "res[0][0] = matrix[0][0] (1)",
        explanationEn: "Line 6: Execute res[0][0] = matrix[0][0] (1).",
        explanationBn: "লাইন ৬: res[0][0] = matrix[0][0] (1) এসাইন করা হলো।",
      ),
      DebuggerStepData(
        activeLineIndex: 4,
        r: 0,
        c: 1,
        R: 2,
        C: 3,
        resMatrix: [
          [1, 0],
          [2, 0],
          [0, 0],
        ],
        conditionText: "res[1][0] = matrix[0][1] (2)",
        explanationEn: "Line 6: Execute res[1][0] = matrix[0][1] (2). Transposed position!",
        explanationBn: "লাইন ৬: res[1][0] = matrix[0][1] (2) ট্রান্সপোজড পজিশনে এসাইন।",
      ),
      DebuggerStepData(
        activeLineIndex: 4,
        r: 0,
        c: 2,
        R: 2,
        C: 3,
        resMatrix: [
          [1, 0],
          [2, 0],
          [3, 0],
        ],
        conditionText: "res[2][0] = matrix[0][2] (3)",
        explanationEn: "Line 6: Execute res[2][0] = matrix[0][2] (3). First column of res complete!",
        explanationBn: "লাইন ৬: res[2][0] = matrix[0][2] (3)। প্রথম কলামের কাজ শেষ!",
      ),
      DebuggerStepData(
        activeLineIndex: 3,
        r: 1,
        c: 0,
        R: 2,
        C: 3,
        resMatrix: [
          [1, 4],
          [2, 0],
          [3, 0],
        ],
        conditionText: "res[0][1] = matrix[1][0] (4)",
        explanationEn: "Line 6: Increment r = 1. Execute res[0][1] = matrix[1][0] (4).",
        explanationBn: "লাইন ৬: r = 1 ইনক্রিমেন্ট। res[0][1] = matrix[1][0] (4) এসাইন।",
      ),
      DebuggerStepData(
        activeLineIndex: 4,
        r: 1,
        c: 1,
        R: 2,
        C: 3,
        resMatrix: [
          [1, 4],
          [2, 5],
          [3, 0],
        ],
        conditionText: "res[1][1] = matrix[1][1] (5)",
        explanationEn: "Line 6: Execute res[1][1] = matrix[1][1] (5). Diagonal position!",
        explanationBn: "লাইন ৬: res[1][1] = matrix[1][1] (5) ডায়াগোনাল পজিশনে এসাইন।",
      ),
      DebuggerStepData(
        activeLineIndex: 4,
        r: 1,
        c: 2,
        R: 2,
        C: 3,
        resMatrix: [
          [1, 4],
          [2, 5],
          [3, 6],
        ],
        conditionText: "res[2][1] = matrix[1][2] (6)",
        explanationEn: "Line 6: Execute res[2][1] = matrix[1][2] (6). All elements copied!",
        explanationBn: "লাইন ৬: res[2][1] = matrix[1][2] (6)। সব উপাদান কপি শেষ!",
      ),
      DebuggerStepData(
        activeLineIndex: 8,
        r: 2,
        c: 3,
        R: 2,
        C: 3,
        resMatrix: [
          [1, 4],
          [2, 5],
          [3, 6],
        ],
        conditionText: "Return res matrix (3x2)",
        explanationEn: "Line 9: Return final result matrix of size 3x2 🎉",
        explanationBn: "লাইন ৯: ৩x২ আকারের চূড়ান্ত রেজাল্ট ম্যাট্রিক্স রিটার্ন করা হলো 🎉",
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

        _buildMatrixCanvas(step),
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

  Widget _buildMatrixCanvas(DebuggerStepData step) {
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
            widget.isEnglish ? "Matrix Memory State Canvas" : "ম্যাট্রিক্স মেমোরি স্টেট ক্যানভাস",
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  const Text("matrix [r][c]", style: TextStyle(color: AppTheme.accentNeonCyan, fontSize: 11, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Column(
                    children: List.generate(_inputMatrix.length, (rowIdx) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(_inputMatrix[rowIdx].length, (colIdx) {
                          final isCurrent = step.r == rowIdx && step.c == colIdx;
                          return Container(
                            margin: const EdgeInsets.all(2),
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: isCurrent ? AppTheme.accentNeonCyan.withOpacity(0.3) : const Color(0xFF1E293B),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: isCurrent ? AppTheme.accentNeonCyan : const Color(0xFF334155)),
                            ),
                            child: Center(
                              child: Text("${_inputMatrix[rowIdx][colIdx]}", style: TextStyle(color: isCurrent ? AppTheme.accentNeonCyan : Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                            ),
                          );
                        }),
                      );
                    }),
                  ),
                ],
              ),
              const Icon(Icons.swap_horiz, color: AppTheme.textMuted),
              Column(
                children: [
                  const Text("res [c][r]", style: TextStyle(color: AppTheme.accentGreen, fontSize: 11, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Column(
                    children: List.generate(step.resMatrix.length, (rowIdx) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(step.resMatrix[rowIdx].length, (colIdx) {
                          final isTarget = step.r == colIdx && step.c == rowIdx;
                          final val = step.resMatrix[rowIdx][colIdx];
                          return Container(
                            margin: const EdgeInsets.all(2),
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: isTarget ? AppTheme.accentGreen.withOpacity(0.3) : (val != 0 ? AppTheme.accentGreen.withOpacity(0.1) : const Color(0xFF1E293B)),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: isTarget ? AppTheme.accentGreen : const Color(0xFF334155)),
                            ),
                            child: Center(
                              child: Text("$val", style: TextStyle(color: val != 0 ? AppTheme.accentGreen : AppTheme.textMuted, fontSize: 12, fontWeight: FontWeight.bold)),
                            ),
                          );
                        }),
                      );
                    }),
                  ),
                ],
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
                widget.isEnglish ? "Variable Watch & Outer/Inner Loops" : "ভ্যারিয়েবল ওয়াচ ও লুপ ইন্সপেক্টর",
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 10,
            children: [
              _buildVariableBadge("R (rows)", "${step.R}", Colors.purpleAccent),
              _buildVariableBadge("C (cols)", "${step.C}", AppTheme.accentNeonCyan),
              _buildVariableBadge("r (row ptr)", step.r != null ? "${step.r}" : "-", AppTheme.accentGreen),
              _buildVariableBadge("c (col ptr)", step.c != null ? "${step.c}" : "-", AppTheme.accentAmber),
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
                      "Operation: ${step.conditionText}",
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
