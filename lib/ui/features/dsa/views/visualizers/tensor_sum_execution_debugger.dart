import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';

class TensorSumExecutionDebugger extends StatefulWidget {
  final bool isEnglish;

  const TensorSumExecutionDebugger({
    super.key,
    required this.isEnglish,
  });

  @override
  State<TensorSumExecutionDebugger> createState() => _TensorSumExecutionDebuggerState();
}

class DebuggerStepData {
  final int activeLineIndex;
  final int? d;
  final int? r;
  final int? c;
  final int total;
  final String? conditionText;
  final String explanationEn;
  final String explanationBn;

  const DebuggerStepData({
    required this.activeLineIndex,
    this.d,
    this.r,
    this.c,
    required this.total,
    this.conditionText,
    required this.explanationEn,
    required this.explanationBn,
  });
}

class _TensorSumExecutionDebuggerState extends State<TensorSumExecutionDebugger> {
  final List<String> _codeLines = const [
    "int tensorSum(vector<vector<vector<int>>>& tensor) {",
    "    int total = 0;",
    "    for (int d = 0; d < tensor.size(); d++) {",
    "        for (int r = 0; r < tensor[0].size(); r++) {",
    "            for (int c = 0; c < tensor[0][0].size(); c++) {",
    "                total += tensor[d][r][c];",
    "            }",
    "        }",
    "    }",
    "    return total;",
    "}",
  ];

  final List<List<List<int>>> _tensor = const [
    [
      [1, 2],
      [3, 4]
    ], // Depth 0 (sum = 10)
    [
      [5, 6],
      [7, 8]
    ], // Depth 1 (sum = 26)
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
        total: 0,
        explanationEn: "Line 1: Entry into tensorSum(tensor). Tensor shape: 2 x 2 x 2.",
        explanationBn: "লাইন ১: tensorSum(tensor) ফাংশনে প্রবেশ। টেনসর আকার: ২ x ২ x ২।",
      ),
      DebuggerStepData(
        activeLineIndex: 1,
        total: 0,
        conditionText: "total = 0",
        explanationEn: "Line 2: Initialize total accumulator variable = 0.",
        explanationBn: "লাইন ২: মোট সমষ্টি সঞ্চয়কারী ভ্যারিয়েবল total = 0 সূচনা।",
      ),
      DebuggerStepData(
        activeLineIndex: 2,
        d: 0,
        total: 0,
        conditionText: "d = 0; (0 < 2) -> TRUE",
        explanationEn: "Line 3: Depth loop start d = 0. Check 0 < 2 is TRUE.",
        explanationBn: "লাইন ৩: ডেপথ লুপ শুরু d = 0। শর্ত 0 < 2 সত্য (TRUE)।",
      ),
      DebuggerStepData(
        activeLineIndex: 5,
        d: 0,
        r: 0,
        c: 0,
        total: 10,
        conditionText: "Layer d=0 sum: 1+2+3+4 = 10",
        explanationEn: "Line 6: Depth d=0 layer processed. total += 10 -> total = 10.",
        explanationBn: "লাইন ৬: ডেপথ d=0 লেয়ার প্রসেসড। total += 10 -> total = 10।",
      ),
      DebuggerStepData(
        activeLineIndex: 2,
        d: 1,
        total: 10,
        conditionText: "d = 1; (1 < 2) -> TRUE",
        explanationEn: "Line 3: Increment d = 1. Check 1 < 2 is TRUE.",
        explanationBn: "লাইন ৩: d = 1 ইনক্রিমেন্ট। শর্ত 1 < 2 সত্য (TRUE)।",
      ),
      DebuggerStepData(
        activeLineIndex: 5,
        d: 1,
        r: 1,
        c: 1,
        total: 36,
        conditionText: "Layer d=1 sum: 5+6+7+8 = 26",
        explanationEn: "Line 6: Depth d=1 layer processed. total += 26 -> total = 10 + 26 = 36.",
        explanationBn: "লাইন ৬: ডেপথ d=1 লেয়ার প্রসেসড। total += 26 -> total = 36।",
      ),
      DebuggerStepData(
        activeLineIndex: 2,
        d: 2,
        total: 36,
        conditionText: "d = 2; (2 < 2) -> FALSE (Exit loop)",
        explanationEn: "Line 3: Increment d = 2. Check 2 < 2 is FALSE! Exit loop.",
        explanationBn: "লাইন ৩: d = 2 ইনক্রিমেন্ট। শর্ত 2 < 2 মিথ্যা (FALSE)! লুপ শেষ।",
      ),
      DebuggerStepData(
        activeLineIndex: 9,
        total: 36,
        conditionText: "Return total = 36",
        explanationEn: "Line 10: Return final 3D tensor sum total = 36 🎉",
        explanationBn: "লাইন ১০: ৩D টেনসরের মোট সমষ্টি total = 36 রিটার্ন করা হলো 🎉",
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

        _buildTensorCanvas(step),
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

  Widget _buildTensorCanvas(DebuggerStepData step) {
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
                widget.isEnglish ? "3D Tensor Memory Volume Canvas" : "৩D টেনসর মেমোরি ভলিউম ক্যানভাস",
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
              ),
              Text(
                "Accumulated Total: ${step.total}",
                style: const TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_tensor.length, (dIdx) {
                final isLayerActive = step.d == dIdx;
                final layerMatrix = _tensor[dIdx];

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isLayerActive ? AppTheme.accentNeonCyan.withOpacity(0.15) : const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isLayerActive ? AppTheme.accentNeonCyan : const Color(0xFF334155),
                      width: isLayerActive ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Layer d = $dIdx",
                        style: TextStyle(
                          fontSize: 11,
                          color: isLayerActive ? AppTheme.accentNeonCyan : AppTheme.textSecondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Column(
                        children: List.generate(layerMatrix.length, (rIdx) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(layerMatrix[rIdx].length, (cIdx) {
                              final val = layerMatrix[rIdx][cIdx];
                              final isCellActive = isLayerActive && (step.r == rIdx && step.c == cIdx);

                              return Container(
                                margin: const EdgeInsets.all(2),
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: isCellActive
                                      ? AppTheme.accentGreen.withOpacity(0.4)
                                      : (isLayerActive ? AppTheme.accentNeonCyan.withOpacity(0.2) : const Color(0xFF090D16)),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: isCellActive
                                        ? AppTheme.accentGreen
                                        : (isLayerActive ? AppTheme.accentNeonCyan : const Color(0xFF334155)),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "$val",
                                    style: TextStyle(
                                      color: isCellActive ? AppTheme.accentGreen : (isLayerActive ? Colors.white : Colors.white70),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          );
                        }),
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
                widget.isEnglish ? "3D Loop Inspector & Accumulator Watch" : "৩D লুপ ইন্সপেক্টর ও টোটাল ওয়াচ",
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 10,
            children: [
              _buildVariableBadge("d (depth)", step.d != null ? "${step.d}" : "-", Colors.purpleAccent),
              _buildVariableBadge("r (row)", step.r != null ? "${step.r}" : "-", AppTheme.accentNeonCyan),
              _buildVariableBadge("c (col)", step.c != null ? "${step.c}" : "-", AppTheme.accentAmber),
              _buildVariableBadge("total sum", "${step.total}", AppTheme.accentGreen),
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
                      "State: ${step.conditionText}",
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
