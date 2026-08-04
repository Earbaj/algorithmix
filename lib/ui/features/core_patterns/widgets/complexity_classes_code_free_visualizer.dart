import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class ClassRunnerStep {
  final double n;
  final String statusType;
  final String titleEn;
  final String titleBn;
  final String descriptionEn;
  final String descriptionBn;

  const ClassRunnerStep({
    required this.n,
    required this.statusType,
    required this.titleEn,
    required this.titleBn,
    required this.descriptionEn,
    required this.descriptionBn,
  });
}

class ComplexityClassesCodeFreeVisualizer extends StatefulWidget {
  final bool isEnglish;

  const ComplexityClassesCodeFreeVisualizer({
    super.key,
    required this.isEnglish,
  });

  @override
  State<ComplexityClassesCodeFreeVisualizer> createState() =>
      _ComplexityClassesCodeFreeVisualizerState();
}

class _ComplexityClassesCodeFreeVisualizerState
    extends State<ComplexityClassesCodeFreeVisualizer> {
  double _inputN = 16.0;
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  final List<double> _nValues = [1.0, 4.0, 16.0, 32.0, 64.0];
  List<ClassRunnerStep> _steps = [];

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
    List<ClassRunnerStep> steps = [];
    for (int i = 0; i < _nValues.length; i++) {
      double n = _nValues[i];
      steps.add(ClassRunnerStep(
        n: n,
        statusType: i == _nValues.length - 1 ? 'finish' : 'running',
        titleEn: "Step ${i + 1}: Input Size N = ${n.toInt()} Complexity Race",
        titleBn: "ধাপ ${i + 1}: ইনপুট সাইজ N = ${n.toInt()} এর কমপ্লেক্সিটি দৌড়",
        descriptionEn:
            "At N = ${n.toInt()}: O(1)=1, O(log N)=${(math.log(n) / math.log(2)).toInt()}, O(N)=${n.toInt()}, O(N log N)=${(n * (math.log(n) / math.log(2))).toInt()}, O(N²)=${(n * n).toInt()}.",
        descriptionBn:
            "N = ${n.toInt()} তে: O(1)=১, O(log N)=${(math.log(n) / math.log(2)).toInt()}, O(N)=${n.toInt()}, O(N log N)=${(n * (math.log(n) / math.log(2))).toInt()}, O(N²)=${(n * n).toInt()}।",
      ));
    }
    _steps = steps;
  }

  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;
    });

    if (_isPlaying) {
      _timer = Timer.periodic(const Duration(milliseconds: 1600), (timer) {
        if (_currentStepIndex < _steps.length - 1) {
          setState(() {
            _currentStepIndex++;
            _inputN = _steps[_currentStepIndex].n;
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
                Icon(Icons.directions_run_rounded,
                    color: AppTheme.accentNeonCyan, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isEng
                            ? 'Complexity Hierarchy Speed Race'
                            : 'কমপ্লেক্সিটি হায়ারার্কি গতি প্রতিযোগিতা',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: Responsive.sp(context, 16),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        isEng
                            ? 'Compare relative execution speeds as N increases from 1 to 64!'
                            : 'N এর মান ১ থেকে ৬৪ পর্যন্ত বাড়ার সাথে সাথে কার্যক্ষমতার তুলনা দেখুন!',
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

          // Speed bars
          _buildSpeedBar("O(1) Constant", 1.0, AppTheme.accentGreen),
          const SizedBox(height: 10),
          _buildSpeedBar("O(log N) Logarithmic",
              math.max(1.0, math.log(_inputN) / math.log(2)), AppTheme.accentNeonCyan),
          const SizedBox(height: 10),
          _buildSpeedBar("O(N) Linear", _inputN, AppTheme.accentBlue),
          const SizedBox(height: 10),
          _buildSpeedBar("O(N log N) Linearithmic",
              _inputN * (math.log(_inputN) / math.log(2)), AppTheme.accentPurple),
          const SizedBox(height: 10),
          _buildSpeedBar(
              "O(N²) Quadratic", _inputN * _inputN, AppTheme.accentAmber),
          const SizedBox(height: 20),

          // Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow,
                    color: AppTheme.accentNeonCyan, size: 28),
                onPressed: _togglePlay,
              ),
              Text(
                "N = ${_inputN.toInt()}",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: Responsive.sp(context, 14)),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: Text(
              isEng ? step.descriptionEn : step.descriptionBn,
              style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: Responsive.sp(context, 12.5)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpeedBar(String label, double ops, Color color) {
    double maxOps = _inputN * _inputN;
    double factor = (ops / maxOps).clamp(0.02, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: Responsive.sp(context, 12),
                    fontWeight: FontWeight.bold)),
            Text("~ ${ops.toInt()} ops",
                style: TextStyle(
                    color: color,
                    fontSize: Responsive.sp(context, 12),
                    fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: factor,
            minHeight: 12,
            backgroundColor: AppTheme.primaryDark,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
