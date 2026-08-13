import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';

class TensorSumAnimatedVisualizer extends StatefulWidget {
  final bool isEnglish;

  const TensorSumAnimatedVisualizer({
    super.key,
    required this.isEnglish,
  });

  @override
  State<TensorSumAnimatedVisualizer> createState() => _TensorSumAnimatedVisualizerState();
}

class VisualizerStepData {
  final int d;
  final int currentSum;
  final String titleEn;
  final String titleBn;
  final String explanationEn;
  final String explanationBn;

  const VisualizerStepData({
    required this.d,
    required this.currentSum,
    required this.titleEn,
    required this.titleBn,
    required this.explanationEn,
    required this.explanationBn,
  });
}

class _TensorSumAnimatedVisualizerState extends State<TensorSumAnimatedVisualizer> {
  final List<List<List<int>>> _tensor = const [
    [
      [1, 2],
      [3, 4]
    ], // Depth 0 (sum = 10)
    [
      [5, 6],
      [7, 8]
    ], // Depth 1 (sum = 26)
  ]; // Total sum = 36

  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  late final List<VisualizerStepData> _steps;

  @override
  void initState() {
    super.initState();
    _steps = const [
      VisualizerStepData(
        d: -1,
        currentSum: 0,
        titleEn: "1. Initialization",
        titleBn: "১. সূচনা (Initialization)",
        explanationEn: "Initialize total = 0. Tensor volume has 2 Depth Layers (2 x 2 x 2).",
        explanationBn: "total = 0 দিয়ে শুরু করি। ৩D টেনসরটিতে ২টি ডেপথ লেয়ার রয়েছে (২ x ২ x ২)।",
      ),
      VisualizerStepData(
        d: 0,
        currentSum: 10,
        titleEn: "2. Process Depth Layer 0",
        titleBn: "২. ডেপথ লেয়ার 0 যোগ করা",
        explanationEn: "Summing 2x2 layer at d=0: [[1, 2], [3, 4]] -> Layer sum = 10. Total = 10.",
        explanationBn: "d=0 এর ২x২ লেয়ারের সংখ্যা যোগ: [[1, 2], [3, 4]] -> লেয়ার যোগফল = 10। মোট = 10।",
      ),
      VisualizerStepData(
        d: 1,
        currentSum: 36,
        titleEn: "3. Process Depth Layer 1",
        titleBn: "৩. ডেপথ লেয়ার 1 যোগ করা",
        explanationEn: "Summing 2x2 layer at d=1: [[5, 6], [7, 8]] -> Layer sum = 26. Total = 10 + 26 = 36.",
        explanationBn: "d=1 এর ২x২ লেয়ারের সংখ্যা যোগ: [[5, 6], [7, 8]] -> লেয়ার যোগফল = 26। মোট = 36।",
      ),
      VisualizerStepData(
        d: -1,
        currentSum: 36,
        titleEn: "4. 3D Volume Sum Complete 🎉",
        titleBn: "৪. ৩D টেনসর যোগ সম্পন্ন 🎉",
        explanationEn: "All depth layers processed! Final accumulated 3D Tensor Total Sum = 36.",
        explanationBn: "সবগুলো ডেপথ লেয়ার প্রসেস করা শেষ! ৩D টেনসরের মোট সমষ্টি = 36।",
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
      _timer = Timer.periodic(const Duration(milliseconds: 1500), (timer) {
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
              const Icon(Icons.layers_outlined, color: AppTheme.accentNeonCyan, size: 22),
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

        // Visual Canvas Box (3D Tensor Layers)
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
              // Total Accumulator Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.accentGreen.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.accentGreen),
                ),
                child: Text(
                  "TOTAL ACCUMULATED SUM: ${step.currentSum}",
                  style: const TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
              const SizedBox(height: 16),

              // Depth Layers
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_tensor.length, (dIdx) {
                    final isLayerActive = step.d == dIdx;
                    final layerMatrix = _tensor[dIdx];

                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isLayerActive ? AppTheme.accentNeonCyan.withOpacity(0.15) : const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isLayerActive ? AppTheme.accentNeonCyan : const Color(0xFF334155),
                          width: isLayerActive ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            "Depth Layer d = $dIdx",
                            style: TextStyle(
                              fontSize: 11,
                              color: isLayerActive ? AppTheme.accentNeonCyan : AppTheme.textSecondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Column(
                            children: List.generate(layerMatrix.length, (rIdx) {
                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                children: List.generate(layerMatrix[rIdx].length, (cIdx) {
                                  final val = layerMatrix[rIdx][cIdx];
                                  return Container(
                                    margin: const EdgeInsets.all(3),
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: isLayerActive ? AppTheme.accentNeonCyan.withOpacity(0.3) : const Color(0xFF090D16),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: isLayerActive ? AppTheme.accentNeonCyan : const Color(0xFF334155)),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "$val",
                                        style: TextStyle(
                                          color: isLayerActive ? Colors.white : Colors.white70,
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
                    );
                  }),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                widget.isEnglish ? "3D Tensor Volume Accumulator total += tensor[d][r][c]" : "৩D টেনসর ডেপথ লেয়ার সামেশন total += tensor[d][r][c]",
                style: const TextStyle(color: AppTheme.textMuted, fontSize: 11, fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

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
          IconButton(
            icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
            onPressed: _togglePlay,
            tooltip: _isPlaying
                ? (widget.isEnglish ? "Pause" : "পজ করুন")
                : (widget.isEnglish ? "Auto Play" : "অটো প্লে"),
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
