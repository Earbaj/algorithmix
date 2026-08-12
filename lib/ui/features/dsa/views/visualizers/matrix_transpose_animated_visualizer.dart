import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';

class MatrixTransposeAnimatedVisualizer extends StatefulWidget {
  final bool isEnglish;

  const MatrixTransposeAnimatedVisualizer({
    super.key,
    required this.isEnglish,
  });

  @override
  State<MatrixTransposeAnimatedVisualizer> createState() => _MatrixTransposeAnimatedVisualizerState();
}

class VisualizerStepData {
  final int r;
  final int c;
  final List<List<int>> resMatrix;
  final String titleEn;
  final String titleBn;
  final String explanationEn;
  final String explanationBn;

  const VisualizerStepData({
    required this.r,
    required this.c,
    required this.resMatrix,
    required this.titleEn,
    required this.titleBn,
    required this.explanationEn,
    required this.explanationBn,
  });
}

class _MatrixTransposeAnimatedVisualizerState extends State<MatrixTransposeAnimatedVisualizer> {
  final List<List<int>> _inputMatrix = const [
    [1, 2, 3],
    [4, 5, 6],
  ]; // 2 x 3

  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  late final List<VisualizerStepData> _steps;

  @override
  void initState() {
    super.initState();
    _steps = const [
      VisualizerStepData(
        r: -1,
        c: -1,
        resMatrix: [
          [0, 0],
          [0, 0],
          [0, 0],
        ],
        titleEn: "1. Initialization",
        titleBn: "১. সূচনা (Initialization)",
        explanationEn: "Input Matrix is 2x3. Create empty Result Matrix of size 3x2 with zeros.",
        explanationBn: "মূল ম্যাট্রিক্স ২টি সারি ও ৩টি কলামের (২x৩)। ফলাফল ম্যাট্রিক্স ৩x২ আকারের ০ দিয়ে সূচনা করি।",
      ),
      VisualizerStepData(
        r: 0,
        c: 0,
        resMatrix: [
          [1, 0],
          [0, 0],
          [0, 0],
        ],
        titleEn: "2. Transpose matrix[0][0] = 1",
        titleBn: "২. ট্রান্সপোজ matrix[0][0] = 1",
        explanationEn: "Copy matrix[0][0] (1) to res[0][0] = 1.",
        explanationBn: "matrix[0][0] (1) মানটি res[0][0] = 1 এ কপি করা হলো।",
      ),
      VisualizerStepData(
        r: 0,
        c: 1,
        resMatrix: [
          [1, 0],
          [2, 0],
          [0, 0],
        ],
        titleEn: "3. Transpose matrix[0][1] = 2",
        titleBn: "৩. ট্রান্সপোজ matrix[0][1] = 2",
        explanationEn: "Swap position: copy matrix[0][1] (2) to res[1][0] = 2.",
        explanationBn: "অবস্থান পরিবর্তন: matrix[0][1] (2) মানটি res[1][0] = 2 এ কপি করা হলো।",
      ),
      VisualizerStepData(
        r: 0,
        c: 2,
        resMatrix: [
          [1, 0],
          [2, 0],
          [3, 0],
        ],
        titleEn: "4. Transpose matrix[0][2] = 3",
        titleBn: "৪. ট্রান্সপোজ matrix[0][2] = 3",
        explanationEn: "Swap position: copy matrix[0][2] (3) to res[2][0] = 3.",
        explanationBn: "অবস্থান পরিবর্তন: matrix[0][2] (3) মানটি res[2][0] = 3 এ কপি করা হলো।",
      ),
      VisualizerStepData(
        r: 1,
        c: 0,
        resMatrix: [
          [1, 4],
          [2, 0],
          [3, 0],
        ],
        titleEn: "5. Transpose matrix[1][0] = 4",
        titleBn: "৫. ট্রান্সপোজ matrix[1][0] = 4",
        explanationEn: "Second row: copy matrix[1][0] (4) to res[0][1] = 4.",
        explanationBn: "দ্বিতীয় সারি: matrix[1][0] (4) মানটি res[0][1] = 4 এ কপি করা হলো।",
      ),
      VisualizerStepData(
        r: 1,
        c: 1,
        resMatrix: [
          [1, 4],
          [2, 5],
          [3, 0],
        ],
        titleEn: "6. Transpose matrix[1][1] = 5",
        titleBn: "৬. ট্রান্সপোজ matrix[1][1] = 5",
        explanationEn: "Copy matrix[1][1] (5) to res[1][1] = 5.",
        explanationBn: "matrix[1][1] (5) মানটি res[1][1] = 5 এ কপি করা হলো।",
      ),
      VisualizerStepData(
        r: 1,
        c: 2,
        resMatrix: [
          [1, 4],
          [2, 5],
          [3, 6],
        ],
        titleEn: "7. Transpose matrix[1][2] = 6",
        titleBn: "৭. ট্রান্সপোজ matrix[1][2] = 6",
        explanationEn: "Copy matrix[1][2] (6) to res[2][1] = 6.",
        explanationBn: "matrix[1][2] (6) মানটি res[2][1] = 6 এ কপি করা হলো।",
      ),
      VisualizerStepData(
        r: -1,
        c: -1,
        resMatrix: [
          [1, 4],
          [2, 5],
          [3, 6],
        ],
        titleEn: "8. Transpose Complete 🎉",
        titleBn: "৮. ট্রান্সপোজ সম্পূর্ণ 🎉",
        explanationEn: "Matrix Transpose finished! Original (2x3) transposed into Result (3x2) matrix.",
        explanationBn: "ম্যাট্রিক্স ট্রান্সপোজ সম্পূর্ণ! মূল (২x৩) ম্যাট্রিক্স পরিবর্তিত হয়ে (৩x২) ম্যাট্রিক্সে রূপান্তরিত হয়েছে।",
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
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.accentNeonCyan.withOpacity(0.12),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.accentNeonCyan.withOpacity(0.5)),
          ),
          child: Row(
            children: [
              const Icon(Icons.grid_4x4, color: AppTheme.accentNeonCyan, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.isEnglish ? step.titleEn : step.titleBn,
                      style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.isEnglish ? step.explanationEn : step.explanationBn,
                      style: const TextStyle(color: Colors.white, fontSize: 12, height: 1.3),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Visual Canvas Box (Dual Matrices)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF090D16),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF1E293B)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Input Matrix (2x3)
                  Column(
                    children: [
                      Text(
                        widget.isEnglish ? "Original Matrix (2x3)" : "মূল ম্যাট্রিক্স (২x৩)",
                        style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      Column(
                        children: List.generate(_inputMatrix.length, (rowIdx) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(_inputMatrix[rowIdx].length, (colIdx) {
                              final isCurrent = step.r == rowIdx && step.c == colIdx;
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                margin: const EdgeInsets.all(3),
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: isCurrent ? AppTheme.accentNeonCyan.withOpacity(0.3) : const Color(0xFF1E293B),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isCurrent ? AppTheme.accentNeonCyan : const Color(0xFF334155),
                                    width: isCurrent ? 2 : 1,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "${_inputMatrix[rowIdx][colIdx]}",
                                    style: TextStyle(
                                      color: isCurrent ? AppTheme.accentNeonCyan : Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
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
                  const Icon(Icons.arrow_forward, color: AppTheme.textMuted),

                  // Result Matrix (3x2)
                  Column(
                    children: [
                      Text(
                        widget.isEnglish ? "Transposed Result (3x2)" : "ট্রান্সপোজড রেজাল্ট (৩x২)",
                        style: const TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      Column(
                        children: List.generate(step.resMatrix.length, (rowIdx) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(step.resMatrix[rowIdx].length, (colIdx) {
                              final isTarget = step.r == colIdx && step.c == rowIdx;
                              final val = step.resMatrix[rowIdx][colIdx];
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                margin: const EdgeInsets.all(3),
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: isTarget
                                      ? AppTheme.accentGreen.withOpacity(0.3)
                                      : (val != 0 ? AppTheme.accentGreen.withOpacity(0.1) : const Color(0xFF1E293B)),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isTarget ? AppTheme.accentGreen : const Color(0xFF334155),
                                    width: isTarget ? 2 : 1,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "$val",
                                    style: TextStyle(
                                      color: val != 0 ? AppTheme.accentGreen : AppTheme.textMuted,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
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
                ],
              ),
              const SizedBox(height: 14),
              Text(
                widget.isEnglish ? "Swapping Rows with Columns res[c][r] = matrix[r][c]" : "সারিকে কলামে রূপান্তর res[c][r] = matrix[r][c]",
                style: const TextStyle(color: AppTheme.textMuted, fontSize: 11, fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Controls
        _buildControls(),
      ],
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
            tooltip: widget.isEnglish ? "Previous Step" : "আগের স্টেপ",
          ),
          ElevatedButton.icon(
            onPressed: _togglePlay,
            icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
            label: Text(_isPlaying
                ? (widget.isEnglish ? "Pause" : "পজ করুন")
                : (widget.isEnglish ? "Auto Play" : "অটো প্লে")),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentNeonCyan,
              foregroundColor: AppTheme.primaryDark,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.skip_next, color: Colors.white),
            onPressed: _currentStepIndex < _steps.length - 1 ? _nextStep : null,
            tooltip: widget.isEnglish ? "Next Step" : "পরের স্টেপ",
          ),
          Text(
            "${_currentStepIndex + 1}/${_steps.length}",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
