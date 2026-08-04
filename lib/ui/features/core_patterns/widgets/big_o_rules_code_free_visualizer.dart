import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class RuleStep {
  final int ruleId;
  final String ruleTitleEn;
  final String ruleTitleBn;
  final String rawExpr;
  final String simplifiedExpr;
  final String explanationEn;
  final String explanationBn;

  const RuleStep({
    required this.ruleId,
    required this.ruleTitleEn,
    required this.ruleTitleBn,
    required this.rawExpr,
    required this.simplifiedExpr,
    required this.explanationEn,
    required this.explanationBn,
  });
}

class BigORulesCodeFreeVisualizer extends StatefulWidget {
  final bool isEnglish;

  const BigORulesCodeFreeVisualizer({
    super.key,
    required this.isEnglish,
  });

  @override
  State<BigORulesCodeFreeVisualizer> createState() =>
      _BigORulesCodeFreeVisualizerState();
}

class _BigORulesCodeFreeVisualizerState
    extends State<BigORulesCodeFreeVisualizer> {
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  List<RuleStep> _steps = [];

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
      RuleStep(
        ruleId: 1,
        ruleTitleEn: "Rule 1: Drop Constants",
        ruleTitleBn: "নিয়ম ১: কনস্ট্যান্ট সহগ বাদ দিন",
        rawExpr: "O(2N + 500)",
        simplifiedExpr: "O(N)",
        explanationEn: "Constant numbers (like 2 or 500) don't change asymptotic growth as N -> infinity.",
        explanationBn: "ধ্রুব সংখ্যা (যেমন ২ বা ৫০০) N এর অসীম বৃদ্ধিতে প্রভাব ফেলে না।",
      ),
      RuleStep(
        ruleId: 2,
        ruleTitleEn: "Rule 2: Drop Non-Dominant Terms",
        ruleTitleBn: "নিয়ম ২: ছোট বা অপ্রধান পদ বাদ দিন",
        rawExpr: "O(N² + 50N + 1000)",
        simplifiedExpr: "O(N²)",
        explanationEn: "N² completely dominates N when N is large. Drop lower powers of N.",
        explanationBn: "N বড় হলে N² এর তুলনায় N এবং ১০<ctrl42>০ নগণ্য হয়ে যায়।",
      ),
      RuleStep(
        ruleId: 3,
        ruleTitleEn: "Rule 3: Additive Sequential Code Blocks",
        ruleTitleBn: "নিয়ম ৩: আলাদা লুপগুলো যোগ হয়",
        rawExpr: "O(A) + O(B)",
        simplifiedExpr: "O(A + B)",
        explanationEn: "Independent sequential loops on arrays A and B are added together.",
        explanationBn: "আলাদা অ্যারে A ও B এর উপর লুপগুলোর সময়সীমা যোগ হয়।",
      ),
      RuleStep(
        ruleId: 4,
        ruleTitleEn: "Rule 4: Multiplicative Nested Loops",
        ruleTitleBn: "নিয়ম ৪: নেসটেড লুপগুলো গুণ হয়",
        rawExpr: "for A { for B }",
        simplifiedExpr: "O(A * B)",
        explanationEn: "Outer loop A running inner loop B results in multiplication O(A * B).",
        explanationBn: "বাইরের লুপ A এর ভেতর ভেতরের লুপ B চললে গুণফলের সময় লাগে।",
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
                Icon(Icons.checklist_rtl_rounded,
                    color: AppTheme.accentNeonCyan, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isEng
                            ? '4 Core Rules for Big O Calculation'
                            : 'বিগ ও (Big O) হিসাব করার ৪টি মৌলিক নিয়ম',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: Responsive.sp(context, 16),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        isEng
                            ? 'Interactive simplification steps for Big O equations!'
                            : 'বিগ ও সমীকরণ সহজীকরণেরInteractive ধাপসমূহ!',
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

          // Rule Visual Box
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(Responsive.sp(context, 16)),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.accentGreen, width: 1.8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEng ? step.ruleTitleEn : step.ruleTitleBn,
                  style: TextStyle(
                      color: AppTheme.accentGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: Responsive.sp(context, 15)),
                ),
                const SizedBox(height: 14),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppTheme.accentPink.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppTheme.accentPink),
                      ),
                      child: Text(
                        step.rawExpr,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: Responsive.sp(context, 14),
                        ),
                      ),
                    ),
                    const Icon(Icons.arrow_forward,
                        color: AppTheme.accentNeonCyan, size: 24),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppTheme.accentGreen.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppTheme.accentGreen),
                      ),
                      child: Text(
                        step.simplifiedExpr,
                        style: TextStyle(
                          color: AppTheme.accentGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: Responsive.sp(context, 14),
                        ),
                      ),
                    ),
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
                "Rule ${_currentStepIndex + 1} / ${_steps.length}",
                style: TextStyle(
                    color: AppTheme.accentNeonCyan,
                    fontWeight: FontWeight.bold,
                    fontSize: Responsive.sp(context, 12)),
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
              isEng ? step.explanationEn : step.explanationBn,
              style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: Responsive.sp(context, 12.5)),
            ),
          ),
        ],
      ),
    );
  }
}
