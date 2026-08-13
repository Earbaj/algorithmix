import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';

class NumIslandsAnimatedVisualizer extends StatefulWidget {
  final bool isEnglish;

  const NumIslandsAnimatedVisualizer({
    super.key,
    required this.isEnglish,
  });

  @override
  State<NumIslandsAnimatedVisualizer> createState() =>
      _NumIslandsAnimatedVisualizerState();
}

class IslandStepData {
  final int islandCount;
  final List<List<String>> gridState;
  final String titleEn;
  final String titleBn;
  final String explanationEn;
  final String explanationBn;

  const IslandStepData({
    required this.islandCount,
    required this.gridState,
    required this.titleEn,
    required this.titleBn,
    required this.explanationEn,
    required this.explanationBn,
  });
}

class _NumIslandsAnimatedVisualizerState
    extends State<NumIslandsAnimatedVisualizer> {
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  late final List<IslandStepData> _steps;

  @override
  void initState() {
    super.initState();
    _steps = const [
      IslandStepData(
        islandCount: 0,
        gridState: [
          ["1", "1", "0"],
          ["1", "1", "0"],
          ["0", "0", "1"],
        ],
        titleEn: "1. Initial 2D Binary Matrix Grid",
        titleBn: "১. প্রাথমিক ২D বাইনারি ম্যাট্রিক্স গ্রিড",
        explanationEn: "Grid with Land ('1') and Water ('0'). Start iterating cells from (0, 0).",
        explanationBn: "মাটি ('1') এবং পানি ('0') নিয়ে ৩x৩ গ্রিড। সেল স্ক্যান শুরু।",
      ),
      IslandStepData(
        islandCount: 1,
        gridState: [
          ["0", "0", "0"],
          ["0", "0", "0"],
          ["0", "0", "1"],
        ],
        titleEn: "2. Found Land at (0,0) -> Island 1 Counted & Sunk! 🌊",
        titleBn: "২. (0,0) এ মাটি পাওয়া গেল -> দ্বীপ ১ গণনা ও পানি করা হলো! 🌊",
        explanationEn: "Cell (0, 0) == '1'! Increment island count = 1. Launch DFS to sink connected land cells (0,0), (0,1), (1,0), (1,1) into '0'.",
        explanationBn: "সেল (0,0) এ মাটি পাওয়া গেছে! দ্বীপ গণনা = ১। DFS চালিয়ে সংযুক্ত মাটি সব পানি '0' করে দেওয়া হলো।",
      ),
      IslandStepData(
        islandCount: 2,
        gridState: [
          ["0", "0", "0"],
          ["0", "0", "0"],
          ["0", "0", "0"],
        ],
        titleEn: "3. Found Land at (2,2) -> Island 2 Counted & Sunk! 🎉",
        titleBn: "৩. (2,2) এ মাটি পাওয়া গেল -> দ্বীপ ২ গণনা ও সমাপ্তি! 🎉",
        explanationEn: "Scan finds land at (2, 2) == '1'! Increment island count = 2. Sink (2, 2). Total Islands = 2! 🎉",
        explanationBn: "সেল (2,2) এ নতুন বিচ্ছিন্ন দ্বীপ পাওয়া গেল! মোট দ্বীপ সংখ্যা = ২! 🎉",
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
              const Icon(Icons.grid_on, color: AppTheme.accentNeonCyan, size: 24),
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

        // Visual Display of 2D Matrix Grid
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFF090D16),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF1E293B)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("2D Matrix Grid:", style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.accentGreen.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.accentGreen),
                    ),
                    child: Text(
                      "Island Count = ${step.islandCount}",
                      style: const TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 12, fontFamily: 'monospace'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Column(
                children: List.generate(step.gridState.length, (r) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(step.gridState[r].length, (c) {
                      final val = step.gridState[r][c];
                      final isLand = val == "1";
                      return Container(
                        margin: const EdgeInsets.all(4),
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: isLand ? AppTheme.accentGreen.withOpacity(0.3) : AppTheme.surfaceDark,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: isLand ? AppTheme.accentGreen : const Color(0xFF334155), width: isLand ? 2 : 1),
                        ),
                        child: Center(
                          child: Text(
                            isLand ? "1 🏞️" : "0 🌊",
                            style: TextStyle(
                              color: isLand ? AppTheme.accentGreen : Colors.white38,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
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
