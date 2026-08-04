import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class ContainerWaterCodeFreeStep {
  final int left;
  final int right;
  final List<int> heights;
  final int currentArea;
  final int maxArea;
  final String statusType; // 'init', 'update_max', 'move_left', 'move_right', 'finish'
  final String titleEn;
  final String titleBn;
  final String descriptionEn;
  final String descriptionBn;
  final String visualTipEn;
  final String visualTipBn;

  const ContainerWaterCodeFreeStep({
    required this.left,
    required this.right,
    required this.heights,
    required this.currentArea,
    required this.maxArea,
    required this.statusType,
    required this.titleEn,
    required this.titleBn,
    required this.descriptionEn,
    required this.descriptionBn,
    required this.visualTipEn,
    required this.visualTipBn,
  });
}

class ContainerWithMostWaterCodeFreeVisualizer extends StatefulWidget {
  final bool isEnglish;

  const ContainerWithMostWaterCodeFreeVisualizer({
    super.key,
    required this.isEnglish,
  });

  @override
  State<ContainerWithMostWaterCodeFreeVisualizer> createState() =>
      _ContainerWithMostWaterCodeFreeVisualizerState();
}

class _ContainerWithMostWaterCodeFreeVisualizerState
    extends State<ContainerWithMostWaterCodeFreeVisualizer> {
  List<int> _currentHeights = [1, 8, 6, 2, 5, 4, 8, 3, 7];

  List<ContainerWaterCodeFreeStep> _steps = [];
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  // Presets
  final List<Map<String, dynamic>> _presets = [
    {
      'label': '[1, 8, 6, 2, 5, 4, 8, 3, 7]',
      'heights': [1, 8, 6, 2, 5, 4, 8, 3, 7],
    },
    {
      'label': '[1, 1]',
      'heights': [1, 1],
    },
    {
      'label': '[4, 3, 2, 1, 4]',
      'heights': [4, 3, 2, 1, 4],
    },
    {
      'label': '[1, 2, 1]',
      'heights': [1, 2, 1],
    },
  ];

  @override
  void initState() {
    super.initState();
    _generateCodeFreeSteps();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _loadPreset(List<int> heights) {
    _timer?.cancel();
    setState(() {
      _isPlaying = false;
      _currentHeights = List.from(heights);
      _currentStepIndex = 0;
      _generateCodeFreeSteps();
    });
  }

  void _generateCodeFreeSteps() {
    List<ContainerWaterCodeFreeStep> steps = [];
    List<int> h = List.from(_currentHeights);
    int n = h.length;

    if (n < 2) return;

    int left = 0;
    int right = n - 1;
    int maxArea = 0;

    // Initial setup step
    int initialWidth = right - left;
    int initialHeight = min(h[left], h[right]);
    int initialArea = initialWidth * initialHeight;
    maxArea = initialArea;

    steps.add(ContainerWaterCodeFreeStep(
      left: left,
      right: right,
      heights: List.from(h),
      currentArea: initialArea,
      maxArea: maxArea,
      statusType: 'init',
      titleEn: "Step 1: Place Left Pointer at 0 & Right Pointer at ${n - 1}",
      titleBn: "ধাপ ১: বামে Left (০) এবং ডানে Right (${n - 1}) পয়েন্টার বসান",
      descriptionEn:
          "Left height = ${h[left]}, Right height = ${h[right]}. Container width = $initialWidth, effective height = $initialHeight. Initial water area = $initialArea.",
      descriptionBn:
          "Left উচ্চতা = ${h[left]}, Right উচ্চতা = ${h[right]}। কনটেইনারের প্রস্থ = $initialWidth, কার্যকরী উচ্চতা = $initialHeight। প্রাথমিক পানির ক্ষেত্রফল = $initialArea।",
      visualTipEn: "The container capacity is limited by the shorter vertical line!",
      visualTipBn: "পানির সর্বোচ্চ ধারণক্ষমতা খাটো স্তম্ভের উচ্চতার ওপর নির্ভর করে!",
    ));

    int stepNum = 2;

    while (left < right) {
      int width = right - left;
      int minH = min(h[left], h[right]);
      int area = width * minH;

      bool isNewMax = area > maxArea;
      if (isNewMax) {
        maxArea = area;
        steps.add(ContainerWaterCodeFreeStep(
          left: left,
          right: right,
          heights: List.from(h),
          currentArea: area,
          maxArea: maxArea,
          statusType: 'update_max',
          titleEn: "Step $stepNum: 🎉 New Maximum Water Area Found! ($maxArea)",
          titleBn: "ধাপ $stepNum: 🎉 নতুন সর্বোচ্চ পানির এলাকা পাওয়া গেছে! ($maxArea)",
          descriptionEn:
              "Area = min(${h[left]}, ${h[right]}) × $width = $area. This beats previous max! Updated maxArea to $maxArea.",
          descriptionBn:
              "ক্ষেত্রফল = min(${h[left]}, ${h[right]}) × $width = $area। এটি আগের ক্ষেত্রফলকে ছাড়িয়ে গেছে! maxArea = $maxArea।",
          visualTipEn: "Larger container volume recorded!",
          visualTipBn: "নতুন সর্বোচ্চ পানির আয়তন রেকর্ড করা হলো!",
        ));
      }

      if (h[left] < h[right]) {
        if (!isNewMax) {
          steps.add(ContainerWaterCodeFreeStep(
            left: left,
            right: right,
            heights: List.from(h),
            currentArea: area,
            maxArea: maxArea,
            statusType: 'move_left',
            titleEn: "Step $stepNum: Left Bar (${h[left]}) < Right Bar (${h[right]}) → Move Left++",
            titleBn: "ধাপ $stepNum: বামের স্তম্ভ (${h[left]}) < ডানের স্তম্ভ (${h[right]}) → Left++ করুন",
            descriptionEn:
                "Left bar (${h[left]}) is shorter! To potentially find a taller container, move Left pointer rightward (left++).",
            descriptionBn:
                "বামের স্তম্ভ (${h[left]}) খাটো! উচুঁ স্তম্ভের আশায় left পয়েন্টার ডানে সরাতে হবে।",
            visualTipEn: "Greedy Strategy: Moving the shorter line is the only way to increase container height!",
            visualTipBn: "লোভী কৌশল: খাটো স্তম্ভ সরালেই কেবল ভবিষ্যতে উচ্চতা বাড়ার সুযোগ তৈরি হয়!",
          ));
        }
        left++;
      } else {
        if (!isNewMax) {
          steps.add(ContainerWaterCodeFreeStep(
            left: left,
            right: right,
            heights: List.from(h),
            currentArea: area,
            maxArea: maxArea,
            statusType: 'move_right',
            titleEn: "Step $stepNum: Right Bar (${h[right]}) ≤ Left Bar (${h[left]}) → Move Right--",
            titleBn: "ধাপ $stepNum: ডানের স্তম্ভ (${h[right]}) ≤ বামের স্তম্ভ (${h[left]}) → Right-- করুন",
            descriptionEn:
                "Right bar (${h[right]}) is shorter or equal! Move Right pointer leftward (right--).",
            descriptionBn:
                "ডানের স্তম্ভ (${h[right]}) খাটো বা সমান! right পয়েন্টার বামে সরাতে হবে।",
            visualTipEn: "Greedy Strategy: Moving the shorter line is the only way to increase container height!",
            visualTipBn: "লোভী কৌশল: খাটো স্তম্ভ সরালেই কেবল ভবিষ্যতে উচ্চতা বাড়ার সুযোগ তৈরি হয়!",
          ));
        }
        right--;
      }
      stepNum++;
    }

    // Finish step
    steps.add(ContainerWaterCodeFreeStep(
      left: 0,
      right: n - 1,
      heights: List.from(h),
      currentArea: maxArea,
      maxArea: maxArea,
      statusType: 'finish',
      titleEn: "🎉 SEARCH COMPLETE! Maximum Water Container Area = $maxArea",
      titleBn: "🎉 সার্চ সম্পূর্ণ! সর্বোচ্চ পানির ক্ষেত্রফল = $maxArea",
      descriptionEn:
          "The maximum water container can hold $maxArea units of water!",
      descriptionBn:
          "সর্বোচ্চ পানির ধারণক্ষমতা হলো $maxArea ইউনিট!",
      visualTipEn: "✨ Achieved optimal container capacity in O(N) linear time!",
      visualTipBn: "✨ O(N) সময়ের মধ্যে সর্বোচ্চ পানির আয়তন সফলভাবে পাওয়া গেছে!",
    ));

    _steps = steps;
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
    final step = _steps.isEmpty
        ? ContainerWaterCodeFreeStep(
            left: 0,
            right: _currentHeights.length - 1,
            heights: _currentHeights,
            currentArea: 0,
            maxArea: 0,
            statusType: 'init',
            titleEn: '',
            titleBn: '',
            descriptionEn: '',
            descriptionBn: '',
            visualTipEn: '',
            visualTipBn: '',
          )
        : _steps[_currentStepIndex];

    final isEng = widget.isEnglish;
    final isMobile = Responsive.isMobile(context);

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        vertical: Responsive.verticalPadding(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Zero Code Banner Header
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(isMobile ? 8 : 12),
                  decoration: BoxDecoration(
                    color: AppTheme.accentNeonCyan.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    color: AppTheme.accentNeonCyan,
                    size: Responsive.sp(context, isMobile ? 22 : 28),
                  ),
                ),
                SizedBox(width: isMobile ? 10 : 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          Text(
                            isEng
                                ? 'Container With Most Water Intuition'
                                : 'কন্টেইনার উইথ মোস্ট ওয়াটার অ্যানিমেশন',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: Responsive.sp(context, 16),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppTheme.accentGreen.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: AppTheme.accentGreen),
                            ),
                            child: Text(
                              isEng ? '100% Code-Free' : '১০০% কোডফ্রি',
                              style: TextStyle(
                                color: AppTheme.accentGreen,
                                fontSize: Responsive.sp(context, 10.5),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isEng
                            ? 'Watch how Two Pointers dynamically shrink the container width while greedily moving the shorter line to maximize water capacity in O(N) time!'
                            : 'কোনো কোড ছাড়াই দেখুন কীভাবে টু-পয়েন্টার দিয়ে খাটো স্তম্ভ সরিয়ে পানি ধারণক্ষমতা সর্বোচ্চ করা হয়!',
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: Responsive.sp(context, 12),
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 2. Preset Selector
          Text(
            isEng ? '🎯 Choose a Test Case Preset:' : '🎯 টেস্ট কেস বেছে নিন:',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: Responsive.sp(context, 14),
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _presets.map((preset) {
                final isSelected = _currentHeights.length ==
                        (preset['heights'] as List).length &&
                    _currentHeights.first == (preset['heights'] as List).first;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(
                      preset['label'],
                      style: TextStyle(
                        fontSize: Responsive.sp(context, 11.5),
                        color: isSelected ? Colors.white : AppTheme.textSecondary,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: AppTheme.accentPurple,
                    backgroundColor: AppTheme.surfaceDark,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: isSelected
                            ? AppTheme.accentNeonCyan
                            : const Color(0xFF334155),
                      ),
                    ),
                    onSelected: (val) {
                      if (val) {
                        _loadPreset(List<int>.from(preset['heights']));
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),

          // 3. Dynamic Water Area Gauge
          _buildStatusGauge(step, isEng, isMobile),
          const SizedBox(height: 20),

          // 4. Interactive Bar & Water Container Graphic
          _buildWaterContainerGraphic(step, isEng, isMobile),
          const SizedBox(height: 20),

          // 5. Playback Controls
          _buildPlaybackControls(isEng, isMobile),
          const SizedBox(height: 20),

          // 6. Intuition Explanation Card
          _buildIntuitionExplanationCard(step, isEng, isMobile),
        ],
      ),
    );
  }

  /// Visual Status Gauge
  Widget _buildStatusGauge(
      ContainerWaterCodeFreeStep step, bool isEng, bool isMobile) {
    Color statusColor;
    IconData statusIcon;

    switch (step.statusType) {
      case 'finish':
      case 'update_max':
        statusColor = AppTheme.accentGreen;
        statusIcon = Icons.water_drop_rounded;
        break;
      case 'move_left':
        statusColor = AppTheme.accentNeonCyan;
        statusIcon = Icons.east_rounded;
        break;
      case 'move_right':
        statusColor = AppTheme.accentPurple;
        statusIcon = Icons.west_rounded;
        break;
      default:
        statusColor = AppTheme.accentNeonCyan;
        statusIcon = Icons.water_rounded;
    }

    final h = step.heights;
    final w = step.right - step.left;
    final minH = min(h[step.left], h[step.right]);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Responsive.sp(context, isMobile ? 12 : 16)),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusColor.withOpacity(0.6), width: 1.8),
        boxShadow: [
          BoxShadow(
            color: statusColor.withOpacity(0.12),
            blurRadius: 16,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(statusIcon, color: statusColor, size: Responsive.sp(context, 20)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isEng ? step.titleEn : step.titleBn,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: Responsive.sp(context, isMobile ? 13.5 : 14.5),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Area Calculation Bubble
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 12 : 20,
                vertical: isMobile ? 10 : 14,
              ),
              decoration: BoxDecoration(
                color: AppTheme.primaryDark,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: statusColor.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildMetricBubble("Width (R-L)", "$w", AppTheme.accentNeonCyan, isMobile),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Text("×", style: TextStyle(color: Colors.white, fontSize: Responsive.sp(context, 18), fontWeight: FontWeight.bold)),
                  ),
                  _buildMetricBubble("Effective Height", "$minH", AppTheme.accentPurple, isMobile),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text("=", style: TextStyle(color: statusColor, fontSize: Responsive.sp(context, 18), fontWeight: FontWeight.bold)),
                  ),
                  _buildMetricBubble("Current Area", "${step.currentArea}", AppTheme.accentAmber, isMobile),
                  const SizedBox(width: 12),
                  _buildMetricBubble("Max Area", "${step.maxArea}", AppTheme.accentGreen, isMobile),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricBubble(String label, String val, Color color, bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 10 : 14,
        vertical: isMobile ? 6 : 8,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: Responsive.sp(context, 9.5),
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            val,
            style: TextStyle(
              fontSize: Responsive.sp(context, isMobile ? 13 : 15),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  /// Graphic showing Water Bars and Transparent Water Container Box
  Widget _buildWaterContainerGraphic(
      ContainerWaterCodeFreeStep step, bool isEng, bool isMobile) {
    final h = step.heights;
    final maxBarH = h.reduce(max);
    final minH = min(h[step.left], h[step.right]);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Responsive.sp(context, isMobile ? 12 : 16)),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isEng ? 'Visual Water Container & Vertical Bars:' : 'ভিজ্যুয়াল ওয়াটার কন্টেইনার ও বারসমূহ:',
            style: TextStyle(
              color: AppTheme.accentNeonCyan,
              fontWeight: FontWeight.bold,
              fontSize: Responsive.sp(context, 13.5),
            ),
          ),
          const SizedBox(height: 16),

          // Bars Container Graphic
          SizedBox(
            height: isMobile ? 180 : 220,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final barWidth = isMobile ? 24.0 : 32.0;
                final availableWidth = constraints.maxWidth;
                final spacing = max(4.0, (availableWidth - (h.length * barWidth)) / (h.length + 1));

                return Stack(
                  children: [
                    // Water Container Blue Box
                    if (step.left < step.right)
                      Positioned(
                        left: spacing + (step.left * (barWidth + spacing)) + (barWidth / 2),
                        width: (step.right - step.left) * (barWidth + spacing),
                        bottom: 24,
                        height: maxBarH > 0 ? (minH / maxBarH) * (isMobile ? 120 : 150) : 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF0284C7).withOpacity(0.35),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                                color: const Color(0xFF38BDF8), width: 1.5),
                          ),
                          child: Center(
                            child: FittedBox(
                              child: Text(
                                "🌊 ${step.currentArea}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  shadows: [
                                    Shadow(color: Colors.black, blurRadius: 4),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                    // Vertical Height Bars
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAlignment.end,
                      children: List.generate(h.length, (idx) {
                        final heightVal = h[idx];
                        final isLeft = idx == step.left;
                        final isRight = idx == step.right;

                        double barPx = maxBarH > 0
                            ? (heightVal / maxBarH) * (isMobile ? 120 : 150)
                            : 10;

                        Color barColor = const Color(0xFF475569);
                        if (isLeft && isRight) {
                          barColor = AppTheme.accentAmber;
                        } else if (isLeft) {
                          barColor = AppTheme.accentNeonCyan;
                        } else if (isRight) {
                          barColor = AppTheme.accentPurple;
                        }

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: 20,
                              child: Text(
                                '$heightVal',
                                style: TextStyle(
                                  fontSize: Responsive.sp(context, 10),
                                  color: (isLeft || isRight)
                                      ? Colors.white
                                      : AppTheme.textMuted,
                                  fontWeight: (isLeft || isRight)
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                            Container(
                              width: barWidth,
                              height: barPx,
                              decoration: BoxDecoration(
                                color: barColor,
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(6)),
                                border: (isLeft || isRight)
                                    ? Border.all(color: Colors.white, width: 1.5)
                                    : null,
                                boxShadow: (isLeft || isRight)
                                    ? [
                                        BoxShadow(
                                          color: barColor.withOpacity(0.5),
                                          blurRadius: 8,
                                        )
                                      ]
                                    : null,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              isLeft && isRight
                                  ? 'L&R'
                                  : (isLeft
                                      ? 'Left'
                                      : (isRight ? 'Right' : '[$idx]')),
                              style: TextStyle(
                                fontSize: Responsive.sp(context, 9),
                                color: (isLeft || isRight)
                                    ? barColor
                                    : AppTheme.textMuted,
                                fontWeight: (isLeft || isRight)
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
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
                padding: isMobile ? EdgeInsets.zero : const EdgeInsets.all(8),
                constraints: isMobile ? const BoxConstraints() : null,
                tooltip: isEng ? "Previous Step" : "আগের ধাপ",
                icon: Icon(Icons.skip_previous_rounded,
                    color: Colors.white,
                    size: Responsive.sp(context, isMobile ? 20 : 24)),
                onPressed: _currentStepIndex > 0
                    ? () => setState(() => _currentStepIndex--)
                    : null,
              ),
              SizedBox(width: isMobile ? 8 : 12),
              IconButton(
                padding: isMobile ? EdgeInsets.zero : const EdgeInsets.all(8),
                constraints: isMobile ? const BoxConstraints() : null,
                tooltip: _isPlaying
                    ? (isEng ? "Pause" : "পজ")
                    : (isEng ? "Play" : "প্লে"),
                icon: Icon(
                  _isPlaying
                      ? Icons.pause_circle_filled_rounded
                      : Icons.play_circle_fill_rounded,
                  color: AppTheme.accentNeonCyan,
                  size: Responsive.sp(context, isMobile ? 28 : 34),
                ),
                onPressed: _togglePlay,
              ),
              SizedBox(width: isMobile ? 8 : 12),
              IconButton(
                padding: isMobile ? EdgeInsets.zero : const EdgeInsets.all(8),
                constraints: isMobile ? const BoxConstraints() : null,
                tooltip: isEng ? "Next Step" : "পরের ধাপ",
                icon: Icon(Icons.skip_next_rounded,
                    color: Colors.white,
                    size: Responsive.sp(context, isMobile ? 20 : 24)),
                onPressed: _currentStepIndex < _steps.length - 1
                    ? () => setState(() => _currentStepIndex++)
                    : null,
              ),
              SizedBox(width: isMobile ? 8 : 12),
              IconButton(
                padding: isMobile ? EdgeInsets.zero : const EdgeInsets.all(8),
                constraints: isMobile ? const BoxConstraints() : null,
                tooltip: isEng ? "Reset" : "রিসেট",
                icon: Icon(Icons.replay_rounded,
                    color: AppTheme.textMuted,
                    size: Responsive.sp(context, isMobile ? 18 : 22)),
                onPressed: () {
                  _timer?.cancel();
                  setState(() {
                    _isPlaying = false;
                    _currentStepIndex = 0;
                  });
                },
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 8 : 12,
              vertical: isMobile ? 4 : 6,
            ),
            decoration: BoxDecoration(
              color: AppTheme.primaryDark,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.accentPurple.withOpacity(0.4)),
            ),
            child: Text(
              isEng
                  ? "Step ${_currentStepIndex + 1}/${_steps.length}"
                  : "ধাপ ${_currentStepIndex + 1}/${_steps.length}",
              style: TextStyle(
                color: AppTheme.accentNeonCyan,
                fontWeight: FontWeight.bold,
                fontSize: Responsive.sp(context, isMobile ? 11 : 12.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntuitionExplanationCard(
      ContainerWaterCodeFreeStep step, bool isEng, bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Responsive.sp(context, isMobile ? 12 : 16)),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.accentPurple.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_rounded,
                  color: AppTheme.accentAmber,
                  size: Responsive.sp(context, isMobile ? 18 : 22)),
              const SizedBox(width: 8),
              Text(
                isEng ? 'Intuition & Logic' : 'সহজ ব্যাখ্যা ও লজিক',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: Responsive.sp(context, isMobile ? 13.5 : 14.5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            isEng ? step.descriptionEn : step.descriptionBn,
            style: TextStyle(
              color: Colors.white,
              fontSize: Responsive.sp(context, isMobile ? 12.5 : 13),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: EdgeInsets.all(isMobile ? 10 : 12),
            decoration: BoxDecoration(
              color: AppTheme.primaryDark,
              borderRadius: BorderRadius.circular(10),
              border:
                  Border.all(color: AppTheme.accentNeonCyan.withOpacity(0.3)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline_rounded,
                    color: AppTheme.accentNeonCyan,
                    size: Responsive.sp(context, isMobile ? 16 : 18)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isEng ? step.visualTipEn : step.visualTipBn,
                    style: TextStyle(
                      color: AppTheme.accentNeonCyan,
                      fontSize: Responsive.sp(context, isMobile ? 11.5 : 12),
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
