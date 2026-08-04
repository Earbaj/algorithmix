import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class CaseStep {
  final String caseName;
  final String scenarioEn;
  final String scenarioBn;
  final String complexity;
  final Color color;
  final int ops;

  const CaseStep({
    required this.caseName,
    required this.scenarioEn,
    required this.scenarioBn,
    required this.complexity,
    required this.color,
    required this.ops,
  });
}

class BestWorstCaseCodeFreeVisualizer extends StatefulWidget {
  final bool isEnglish;

  const BestWorstCaseCodeFreeVisualizer({
    super.key,
    required this.isEnglish,
  });

  @override
  State<BestWorstCaseCodeFreeVisualizer> createState() =>
      _BestWorstCaseCodeFreeVisualizerState();
}

class _BestWorstCaseCodeFreeVisualizerState
    extends State<BestWorstCaseCodeFreeVisualizer> {
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  List<CaseStep> _steps = [];

  @override
  void initState() {
    super.initState();
    _generateSteps();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _generateSteps() {
    _steps = const [
      CaseStep(
        caseName: "1. Best Case (Ω - Big Omega)",
        scenarioEn: "Linear Search: Target is found at index 0 on 1st step!",
        scenarioBn: "লিনিয়ার সার্চ: টার্গেট প্রথম ইনডেক্সেই পাওয়া গেছে!",
        complexity: "O(1)",
        color: AppTheme.accentGreen,
        ops: 1,
      ),
      CaseStep(
        caseName: "2. Average Case (Θ - Big Theta)",
        scenarioEn: "Linear Search: Target is found in the middle of array at index N/2.",
        scenarioBn: "লিনিয়ার সার্চ: টার্গেট অ্যারের মাঝামাঝি পাওয়া গেছে।",
        complexity: "O(N)",
        color: AppTheme.accentNeonCyan,
        ops: 50,
      ),
      CaseStep(
        caseName: "3. Worst Case (O - Big O)",
        scenarioEn: "Linear Search: Target is at last index N-1 or not present at all!",
        scenarioBn: "লিনিয়ার সার্চ: টার্গেট শেষ ইনডেক্সে বা অনুপস্থিত!",
        complexity: "O(N)",
        color: AppTheme.accentPink,
        ops: 100,
      ),
    ];
  }

  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;
    });

    if (_isPlaying) {
      _timer = Timer.periodic(const Duration(milliseconds: 1800), (timer) {
        if (_currentStepIndex < _steps.length - 1) {
          setState(() {
            _currentStepIndex++;
          });
        } else {
          _timer?.cancel();
          setState(() {
            _isPlaying = false;
          });
        }
      });
    } else {
      _timer?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEng = widget.isEnglish;
    final isMobile = Responsive.isMobile(context);
    final step = _steps[_currentStepIndex];

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        vertical: Responsive.verticalPadding(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(isMobile ? 12 : 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.accentPurple.withOpacity(0.25),
                  AppTheme.accentNeonCyan.withOpacity(0.15),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.accentNeonCyan.withOpacity(0.4)),
            ),
            child: Row(
              children: [
                Icon(Icons.pie_chart_outline_rounded,
                    color: AppTheme.accentNeonCyan, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isEng
                            ? 'Best vs Average vs Worst Case Visualizer'
                            : 'বেস্ট বনাম এভারেজ বনাম ওয়ার্স্ট কেস ভিজ্যুয়ালাইজার',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: Responsive.sp(context, 16),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        isEng
                            ? 'Compare search steps across Best, Average, and Worst case scenarios!'
                            : 'বেস্ট, এভারেজ ও ওয়ার্স্ট কেসের সার্চ স্টেপের তুলনা দেখুন!',
                        style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: Responsive.sp(context, 12)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Case Graphic Card
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(Responsive.sp(context, 16)),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: step.color, width: 1.8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.caseName,
                  style: TextStyle(
                      color: step.color,
                      fontWeight: FontWeight.bold,
                      fontSize: Responsive.sp(context, 15)),
                ),
                const SizedBox(height: 10),

                Text(
                  isEng ? step.scenarioEn : step.scenarioBn,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: Responsive.sp(context, 13)),
                ),
                const SizedBox(height: 14),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Time Complexity: ${step.complexity}",
                        style: TextStyle(
                            color: step.color,
                            fontWeight: FontWeight.bold,
                            fontSize: Responsive.sp(context, 13))),
                    Text("Operations: ${step.ops}",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: Responsive.sp(context, 13))),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.skip_previous,
                        color: Colors.white, size: Responsive.sp(context, 20)),
                    onPressed: _currentStepIndex > 0
                        ? () => setState(() => _currentStepIndex--)
                        : null,
                  ),
                  IconButton(
                    icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow,
                        color: AppTheme.accentNeonCyan,
                        size: Responsive.sp(context, 24)),
                    onPressed: _togglePlay,
                  ),
                  IconButton(
                    icon: Icon(Icons.skip_next,
                        color: Colors.white, size: Responsive.sp(context, 20)),
                    onPressed: _currentStepIndex < _steps.length - 1
                        ? () => setState(() => _currentStepIndex++)
                        : null,
                  ),
                ],
              ),
              Text(
                "Case ${_currentStepIndex + 1} / ${_steps.length}",
                style: TextStyle(
                    color: AppTheme.accentNeonCyan,
                    fontWeight: FontWeight.bold,
                    fontSize: Responsive.sp(context, 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
