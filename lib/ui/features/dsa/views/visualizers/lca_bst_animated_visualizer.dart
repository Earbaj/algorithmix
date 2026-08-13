import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';

class LcaBstAnimatedVisualizer extends StatefulWidget {
  final bool isEnglish;

  const LcaBstAnimatedVisualizer({
    super.key,
    required this.isEnglish,
  });

  @override
  State<LcaBstAnimatedVisualizer> createState() =>
      _LcaBstAnimatedVisualizerState();
}

class LcaStepData {
  final int currentNodeVal;
  final int pVal;
  final int qVal;
  final bool isLca;
  final String titleEn;
  final String titleBn;
  final String explanationEn;
  final String explanationBn;

  const LcaStepData({
    required this.currentNodeVal,
    required this.pVal,
    required this.qVal,
    required this.isLca,
    required this.titleEn,
    required this.titleBn,
    required this.explanationEn,
    required this.explanationBn,
  });
}

class _LcaBstAnimatedVisualizerState extends State<LcaBstAnimatedVisualizer> {
  final int _pVal = 2;
  final int _qVal = 8;

  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  late final List<LcaStepData> _steps;

  @override
  void initState() {
    super.initState();
    _steps = const [
      LcaStepData(
        currentNodeVal: 6,
        pVal: 2,
        qVal: 8,
        isLca: true,
        titleEn: "1. Start at Root (6) -> Targets p=2, q=8 SPLIT! 🎉",
        titleBn: "১. রুট নোড (6) এ টেস্ট -> p=2 ও q=8 দুই দিকে ভাগ হয়ে গেল! 🎉",
        explanationEn: "Compare targets with Root 6: Since `p=2 < 6` AND `q=8 > 6`, nodes p & q branch into opposite subtrees! Root 6 is the Lowest Common Ancestor! 🎉",
        explanationBn: "টার্গেট রুটের সাথে তুলনা: `p=2 < 6` (বামে) এবং `q=8 > 6` (ডানে)। ২ ও ৮ বিপরীত দিকে ভাগ হওয়ায় নোড 6 হলো সর্বনিম্ন সাধারণ পূর্বপুরুষ (LCA)! 🎉",
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
              const Icon(Icons.account_tree, color: AppTheme.accentNeonCyan, size: 24),
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

        // LCA Tree Graph Canvas
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
                  Text("Targets: p = $_pVal, q = $_qVal", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13, fontFamily: 'monospace')),
                  if (step.isLca)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.accentGreen.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppTheme.accentGreen),
                      ),
                      child: Text(
                        "LCA Node = ${step.currentNodeVal}",
                        style: const TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 12, fontFamily: 'monospace'),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),

              // Visual Tree Layout
              Column(
                children: [
                  // Level 0: Root 6
                  _buildNodeCircle(6, isLca: step.isLca),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.south_west, color: AppTheme.accentNeonCyan, size: 20),
                      const SizedBox(width: 50),
                      const Icon(Icons.south_east, color: AppTheme.accentAmber, size: 20),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Level 1: Left 2 (p), Right 8 (q)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildNodeCircle(2, isTargetP: true),
                      const SizedBox(width: 45),
                      _buildNodeCircle(8, isTargetQ: true),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.south_west, color: Colors.white.withOpacity(0.2), size: 16),
                          const SizedBox(width: 12),
                          Icon(Icons.south_east, color: Colors.white.withOpacity(0.2), size: 16),
                        ],
                      ),
                      const SizedBox(width: 45),
                      Row(
                        children: [
                          Icon(Icons.south_west, color: Colors.white.withOpacity(0.2), size: 16),
                          const SizedBox(width: 12),
                          Icon(Icons.south_east, color: Colors.white.withOpacity(0.2), size: 16),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Level 2: Children 0, 4 and 7, 9
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildNodeCircle(0, size: 36),
                      const SizedBox(width: 10),
                      _buildNodeCircle(4, size: 36),
                      const SizedBox(width: 30),
                      _buildNodeCircle(7, size: 36),
                      const SizedBox(width: 10),
                      _buildNodeCircle(9, size: 36),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        _buildControls(),
      ],
    );
  }

  Widget _buildNodeCircle(int val, {bool isLca = false, bool isTargetP = false, bool isTargetQ = false, double size = 44}) {
    Color bg = const Color(0xFF1E293B);
    Color border = const Color(0xFF334155);
    Color textCol = Colors.white70;

    if (isLca) {
      bg = AppTheme.accentGreen.withOpacity(0.3);
      border = AppTheme.accentGreen;
      textCol = AppTheme.accentGreen;
    } else if (isTargetP) {
      bg = AppTheme.accentNeonCyan.withOpacity(0.3);
      border = AppTheme.accentNeonCyan;
      textCol = AppTheme.accentNeonCyan;
    } else if (isTargetQ) {
      bg = AppTheme.accentAmber.withOpacity(0.3);
      border = AppTheme.accentAmber;
      textCol = AppTheme.accentAmber;
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
        border: Border.all(color: border, width: isLca || isTargetP || isTargetQ ? 2.5 : 1.5),
      ),
      child: Center(
        child: Text(
          "$val",
          style: TextStyle(color: textCol, fontWeight: FontWeight.bold, fontSize: size * 0.35, fontFamily: 'monospace'),
        ),
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
