import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class AsymptoticStep {
  final double n;
  final double upperO;
  final double exactTheta;
  final double lowerOmega;
  final String statusType;
  final String titleEn;
  final String titleBn;
  final String descriptionEn;
  final String descriptionBn;
  final String visualTipEn;
  final String visualTipBn;

  const AsymptoticStep({
    required this.n,
    required this.upperO,
    required this.exactTheta,
    required this.lowerOmega,
    required this.statusType,
    required this.titleEn,
    required this.titleBn,
    required this.descriptionEn,
    required this.descriptionBn,
    required this.visualTipEn,
    required this.visualTipBn,
  });
}

class AsymptoticNotationsCodeFreeVisualizer extends StatefulWidget {
  final bool isEnglish;

  const AsymptoticNotationsCodeFreeVisualizer({
    super.key,
    required this.isEnglish,
  });

  @override
  State<AsymptoticNotationsCodeFreeVisualizer> createState() =>
      _AsymptoticNotationsCodeFreeVisualizerState();
}

class _AsymptoticNotationsCodeFreeVisualizerState
    extends State<AsymptoticNotationsCodeFreeVisualizer> {
  double _inputN = 10.0;
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  final List<double> _nValues = [1.0, 2.0, 4.0, 8.0, 16.0, 32.0, 64.0];
  List<AsymptoticStep> _steps = [];

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
    List<AsymptoticStep> steps = [];
    for (int i = 0; i < _nValues.length; i++) {
      double n = _nValues[i];
      double upper = 2.0 * n * n; // Upper bound c2 * n^2
      double exact = 1.5 * n * n + 3 * n; // Exact performance
      double lower = 0.5 * n * n; // Lower bound c1 * n^2

      steps.add(AsymptoticStep(
        n: n,
        upperO: upper,
        exactTheta: exact,
        lowerOmega: lower,
        statusType: i == _nValues.length - 1 ? 'finish' : 'scaling',
        titleEn: "Input Size N = ${n.toInt()} → Operation Bounds Scaling",
        titleBn: "ইনপুট সাইজ N = ${n.toInt()} → অপারেশন বাউন্ডস্ স্কেলিং",
        descriptionEn:
            "At N = ${n.toInt()}: Upper Bound O(N²) <= ${upper.toInt()} ops, Exact Θ(N²) = ${exact.toInt()} ops, Lower Bound Ω(N²) >= ${lower.toInt()} ops.",
        descriptionBn:
            "N = ${n.toInt()} তে: আপার বাউন্ড O(N²) <= ${upper.toInt()}, অ্যাকচুয়াল Θ(N²) = ${exact.toInt()}, লোয়ার বাউন্ড Ω(N²) >= ${lower.toInt()}।",
        visualTipEn: "Notice how Exact Theta always sits comfortably between Upper O and Lower Omega!",
        visualTipBn: "লক্ষ্য করুন কীভাবে অ্যাকচুয়াল Θ সবসময় O এবং Ω এর ঠিক মাঝে অবস্থান করে!",
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
          // Banner
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(isMobile ? 12 : 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.accentPurple.withOpacity(0.25),
                  AppTheme.accentNeonCyan.withOpacity(0.15),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.accentNeonCyan.withOpacity(0.4)),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(isMobile ? 8 : 12),
                  decoration: BoxDecoration(
                    color: AppTheme.accentNeonCyan.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.functions_rounded,
                    color: AppTheme.accentNeonCyan,
                    size: Responsive.sp(context, isMobile ? 22 : 28),
                  ),
                ),
                SizedBox(width: isMobile ? 10 : 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isEng
                            ? 'Asymptotic Notations Visualizer (O, Ω, Θ)'
                            : 'অ্যাসিম্পটোটিক নোটেশন ভিজ্যুয়ালাইজার (O, Ω, Θ)',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: Responsive.sp(context, 16),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isEng
                            ? 'Watch how Upper Bound Big O, Lower Bound Big Omega, and Tight Bound Big Theta envelop performance as N scales!'
                            : 'দেখুন কীভাবে N এর বৃদ্ধির সাথে আপার বাউন্ড O, লোয়ার বাউন্ড Ω এবং টাইট বাউন্ড Θ পারফরম্যান্সকে বেষ্টন করে রাখে!',
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: Responsive.sp(context, 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Status & Gauge
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(Responsive.sp(context, 14)),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.accentNeonCyan.withOpacity(0.4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEng ? step.titleEn : step.titleBn,
                  style: TextStyle(
                    color: AppTheme.accentNeonCyan,
                    fontWeight: FontWeight.bold,
                    fontSize: Responsive.sp(context, 14),
                  ),
                ),
                const SizedBox(height: 12),

                // 3 Notations Cards
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildNotationCard(
                        "Big O (Upper Bound)",
                        "O(N²)",
                        "<= ${step.upperO.toInt()} ops",
                        AppTheme.accentPink,
                      ),
                      const SizedBox(width: 10),
                      _buildNotationCard(
                        "Big Theta (Tight Bound)",
                        "Θ(N²)",
                        "~ ${step.exactTheta.toInt()} ops",
                        AppTheme.accentNeonCyan,
                      ),
                      const SizedBox(width: 10),
                      _buildNotationCard(
                        "Big Omega (Lower Bound)",
                        "Ω(N²)",
                        ">= ${step.lowerOmega.toInt()} ops",
                        AppTheme.accentGreen,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Bar Graphic
          _buildBoundsBarGraphic(step, isEng, isMobile),
          const SizedBox(height: 20),

          // Controls
          _buildPlaybackControls(isEng, isMobile),
          const SizedBox(height: 20),

          // Narrative
          _buildNarrativeCard(step, isEng, isMobile),
        ],
      ),
    );
  }

  Widget _buildNotationCard(
      String label, String notation, String opsText, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: Responsive.sp(context, 10),
                  color: color,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(notation,
                  style: TextStyle(
                      fontSize: Responsive.sp(context, 14),
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              Text(opsText,
                  style: TextStyle(
                      fontSize: Responsive.sp(context, 12),
                      color: color,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBoundsBarGraphic(
      AsymptoticStep step, bool isEng, bool isMobile) {
    double maxOps = step.upperO;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Responsive.sp(context, 16)),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isEng
                ? 'Relative Operation Height at N = ${step.n.toInt()}:'
                : 'N = ${step.n.toInt()} তে আপার, অ্যাকচুয়াল ও লোয়ার বাউন্ড উচ্চতা:',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: Responsive.sp(context, 13.5),
            ),
          ),
          const SizedBox(height: 16),

          _buildSingleBar("Big O (Upper Bound)", step.upperO, maxOps, AppTheme.accentPink),
          const SizedBox(height: 10),
          _buildSingleBar("Big Theta (Exact)", step.exactTheta, maxOps, AppTheme.accentNeonCyan),
          const SizedBox(height: 10),
          _buildSingleBar("Big Omega (Lower Bound)", step.lowerOmega, maxOps, AppTheme.accentGreen),
        ],
      ),
    );
  }

  Widget _buildSingleBar(String label, double val, double maxVal, Color color) {
    double factor = (val / maxVal).clamp(0.05, 1.0);

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
            Text("${val.toInt()} ops",
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

  Widget _buildPlaybackControls(bool isEng, bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.sp(context, isMobile ? 10 : 16),
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.skip_previous,
                    color: Colors.white, size: Responsive.sp(context, 20)),
                onPressed: _currentStepIndex > 0
                    ? () => setState(() {
                          _currentStepIndex--;
                          _inputN = _steps[_currentStepIndex].n;
                        })
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
                    ? () => setState(() {
                          _currentStepIndex++;
                          _inputN = _steps[_currentStepIndex].n;
                        })
                    : null,
              ),
            ],
          ),
          Text(
            "Step ${_currentStepIndex + 1} / ${_steps.length}",
            style: TextStyle(
                color: AppTheme.accentNeonCyan,
                fontWeight: FontWeight.bold,
                fontSize: Responsive.sp(context, 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildNarrativeCard(AsymptoticStep step, bool isEng, bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Responsive.sp(context, 14)),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.accentPurple.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isEng ? step.descriptionEn : step.descriptionBn,
            style: TextStyle(
                color: Colors.white,
                fontSize: Responsive.sp(context, 13),
                height: 1.4),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.primaryDark,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              isEng ? step.visualTipEn : step.visualTipBn,
              style: TextStyle(
                  color: AppTheme.accentNeonCyan,
                  fontSize: Responsive.sp(context, 12)),
            ),
          ),
        ],
      ),
    );
  }
}
