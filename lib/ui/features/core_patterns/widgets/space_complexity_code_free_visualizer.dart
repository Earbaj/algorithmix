import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class StackFrameStep {
  final int depth;
  final List<String> stackFrames;
  final String statusType;
  final String titleEn;
  final String titleBn;
  final String descriptionEn;
  final String descriptionBn;

  const StackFrameStep({
    required this.depth,
    required this.stackFrames,
    required this.statusType,
    required this.titleEn,
    required this.titleBn,
    required this.descriptionEn,
    required this.descriptionBn,
  });
}

class SpaceComplexityCodeFreeVisualizer extends StatefulWidget {
  final bool isEnglish;

  const SpaceComplexityCodeFreeVisualizer({
    super.key,
    required this.isEnglish,
  });

  @override
  State<SpaceComplexityCodeFreeVisualizer> createState() =>
      _SpaceComplexityCodeFreeVisualizerState();
}

class _SpaceComplexityCodeFreeVisualizerState
    extends State<SpaceComplexityCodeFreeVisualizer> {
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  List<StackFrameStep> _steps = [];

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
    _steps = [
      const StackFrameStep(
        depth: 1,
        stackFrames: ["factorial(4)"],
        statusType: "push",
        titleEn: "Step 1: Call factorial(4) → Push Frame 1",
        titleBn: "ধাপ ১: factorial(4) কল → স্ট্যাক ফ্রেম ১ পুশ",
        descriptionEn: "Initial main call to factorial(4). Call stack depth = 1.",
        descriptionBn: "factorial(4) এর প্রাথমিক কল। স্ট্যাক গভীরতা = ১।",
      ),
      const StackFrameStep(
        depth: 2,
        stackFrames: ["factorial(3)", "factorial(4)"],
        statusType: "push",
        titleEn: "Step 2: Call factorial(3) → Push Frame 2",
        titleBn: "ধাপ ২: factorial(3) কল → স্ট্যাক ফ্রেম ২ পুশ",
        descriptionEn: "Recursive call factorial(3). Call stack depth = 2.",
        descriptionBn: "রিকার্সিভ কল factorial(3)। স্ট্যাক গভীরতা = ২।",
      ),
      const StackFrameStep(
        depth: 3,
        stackFrames: ["factorial(2)", "factorial(3)", "factorial(4)"],
        statusType: "push",
        titleEn: "Step 3: Call factorial(2) → Push Frame 3",
        titleBn: "ধাপ ৩: factorial(2) কল → স্ট্যাক ফ্রেম ৩ পুশ",
        descriptionEn: "Recursive call factorial(2). Call stack depth = 3.",
        descriptionBn: "রিকার্সিভ কল factorial(2)। স্ট্যাক গভীরতা = ৩।",
      ),
      const StackFrameStep(
        depth: 4,
        stackFrames: ["factorial(1) [Base]", "factorial(2)", "factorial(3)", "factorial(4)"],
        statusType: "push",
        titleEn: "Step 4: Call factorial(1) Base Case → Push Frame 4 (Max Stack Depth)",
        titleBn: "ধাপ ৪: factorial(1) বেস কেস → সর্বোচ্চ স্ট্যাক ফ্রেম ৪",
        descriptionEn: "Reached Base Case factorial(1) = 1! Maximum Stack Overhead O(N) = 4 frames.",
        descriptionBn: "বেস কেসে পৌঁছেছে! সর্বোচ্চ কল স্ট্যাক মেমোরি O(N) = ৪ ফ্রেম।",
      ),
      const StackFrameStep(
        depth: 3,
        stackFrames: ["factorial(2) returns 2", "factorial(3)", "factorial(4)"],
        statusType: "pop",
        titleEn: "Step 5: Unwind Stack → Pop factorial(1) return 1",
        titleBn: "ধাপ ৫: স্ট্যাক আনওয়াইন্ড → factorial(1) ব্যাকট্র্যাক",
        descriptionEn: "Returning 1 up the stack to resolve factorial(2).",
        descriptionBn: "স্ট্যাক ফ্রেম কমিয়ে factorial(2) রিসলভ করা হচ্ছে।",
      ),
      const StackFrameStep(
        depth: 0,
        stackFrames: [],
        statusType: "finish",
        titleEn: "🎉 Execution Finish: Result 24 (Call Stack Memory Cleared)",
        titleBn: "🎉 এক্সিকিউশন সম্পূর্ণ: ফলাফল ২৪ (কল স্ট্যাক মেমোরি ক্লিয়ার)",
        descriptionEn: "All recursive frames popped. Peak memory space allocated = O(N).",
        descriptionBn: "সকল রিকার্সিভ ফ্রেম পপ হয়েছে। পিক স্পেস কমপ্লেক্সিটি = O(N)।",
      ),
    ];
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
                Icon(Icons.layers_rounded,
                    color: AppTheme.accentNeonCyan, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isEng
                            ? 'Recursion Call Stack Memory Visualizer'
                            : 'রিকার্শন কল স্ট্যাক মেমোরি ভিজ্যুয়ালাইজার',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: Responsive.sp(context, 16),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        isEng
                            ? 'Watch stack frames push & pop during recursive calls to visualize O(N) Space Complexity!'
                            : 'রিকার্সিভ কলের সময় স্ট্যাক ফ্রেম পুশ ও পপ হওয়ার মাধ্যমে O(N) স্পেস দেখুন!',
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

          // Call stack vertical graphic
          Container(
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
                  "Call Stack Frames (Depth: ${step.depth}):",
                  style: TextStyle(
                      color: AppTheme.accentNeonCyan,
                      fontWeight: FontWeight.bold,
                      fontSize: Responsive.sp(context, 13.5)),
                ),
                const SizedBox(height: 14),

                if (step.stackFrames.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      isEng ? "[Stack Memory Cleared]" : "[স্ট্যাক মেমোরি ক্লিয়ার]",
                      style: TextStyle(
                          color: AppTheme.accentGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: Responsive.sp(context, 12)),
                    ),
                  )
                else
                  ...step.stackFrames.map((frame) {
                    return Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppTheme.accentPurple.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: AppTheme.accentPurple, width: 1.5),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.memory,
                              color: AppTheme.accentNeonCyan, size: 18),
                          const SizedBox(width: 10),
                          Text(
                            frame,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'monospace',
                              fontWeight: FontWeight.bold,
                              fontSize: Responsive.sp(context, 13),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
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
                "Step ${_currentStepIndex + 1} / ${_steps.length}",
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
}
