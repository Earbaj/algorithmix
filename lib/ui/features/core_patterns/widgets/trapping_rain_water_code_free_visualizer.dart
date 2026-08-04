import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class RainWaterCodeFreeStep {
  final int left;
  final int right;
  final int leftMax;
  final int rightMax;
  final int totalWater;
  final int addedWaterThisStep;
  final List<int> heights;
  final List<int> trappedWaterPerBar;
  final String statusType; // 'init', 'water_added_left', 'water_added_right', 'max_updated_left', 'max_updated_right', 'finish'
  final String titleEn;
  final String titleBn;
  final String descriptionEn;
  final String descriptionBn;
  final String visualTipEn;
  final String visualTipBn;

  const RainWaterCodeFreeStep({
    required this.left,
    required this.right,
    required this.leftMax,
    required this.rightMax,
    required this.totalWater,
    required this.addedWaterThisStep,
    required this.heights,
    required this.trappedWaterPerBar,
    required this.statusType,
    required this.titleEn,
    required this.titleBn,
    required this.descriptionEn,
    required this.descriptionBn,
    required this.visualTipEn,
    required this.visualTipBn,
  });
}

class TrappingRainWaterCodeFreeVisualizer extends StatefulWidget {
  final bool isEnglish;

  const TrappingRainWaterCodeFreeVisualizer({
    super.key,
    required this.isEnglish,
  });

  @override
  State<TrappingRainWaterCodeFreeVisualizer> createState() =>
      _TrappingRainWaterCodeFreeVisualizerState();
}

class _TrappingRainWaterCodeFreeVisualizerState
    extends State<TrappingRainWaterCodeFreeVisualizer> {
  List<int> _rawHeights = [0, 1, 0, 2, 1, 0, 1, 3, 2, 1, 2, 1];

  List<RainWaterCodeFreeStep> _steps = [];
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  // Presets
  final List<Map<String, dynamic>> _presets = [
    {
      'label': '[0, 1, 0, 2, 1, 0, 1, 3, 2, 1, 2, 1]',
      'heights': [0, 1, 0, 2, 1, 0, 1, 3, 2, 1, 2, 1],
    },
    {
      'label': '[4, 2, 0, 3, 2, 5]',
      'heights': [4, 2, 0, 3, 2, 5],
    },
    {
      'label': '[3, 0, 2, 0, 4]',
      'heights': [3, 0, 2, 0, 4],
    },
    {
      'label': '[1, 2, 3, 4]',
      'heights': [1, 2, 3, 4],
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

  void _loadPreset(List<int> h) {
    _timer?.cancel();
    setState(() {
      _isPlaying = false;
      _rawHeights = List.from(h);
      _currentStepIndex = 0;
      _generateCodeFreeSteps();
    });
  }

  void _generateCodeFreeSteps() {
    List<RainWaterCodeFreeStep> steps = [];
    List<int> heights = List.from(_rawHeights);
    int n = heights.length;

    if (n == 0) return;

    int left = 0;
    int right = n - 1;
    int leftMax = 0;
    int rightMax = 0;
    int totalWater = 0;
    List<int> waterPerBar = List.filled(n, 0);

    // Initial setup step
    steps.add(RainWaterCodeFreeStep(
      left: left,
      right: right,
      leftMax: 0,
      rightMax: 0,
      totalWater: 0,
      addedWaterThisStep: 0,
      heights: List.from(heights),
      trappedWaterPerBar: List.from(waterPerBar),
      statusType: 'init',
      titleEn: "Step 1: Init Two Pointers (left = 0, right = ${n - 1}) & maxes = 0",
      titleBn: "ধাপ ১: টু-পয়েন্টার বসান (left = 0, right = ${n - 1}) এবং maxes = 0 সেট করুন",
      descriptionEn:
          "Elevation map: [${heights.join(', ')}]. Left bar = ${heights[left]}, Right bar = ${heights[right]}. We move the pointer with smaller height.",
      descriptionBn:
          "উচ্চতার ম্যাপ: [${heights.join(', ')}]। বাম বার = ${heights[left]}, ডান বার = ${heights[right]}। কম উচ্চতার পয়েন্টারটি সরাব।",
      visualTipEn: "Key Insight: Water trapped at any index is bounded by min(leftMax, rightMax) - height[i]!",
      visualTipBn: "মূল লজিক: যেকোনো ঘরে জমা হওয়া পানি = min(leftMax, rightMax) - height[i]!",
    ));

    int stepNum = 2;

    while (left < right) {
      if (heights[left] < heights[right]) {
        if (heights[left] >= leftMax) {
          leftMax = heights[left];
          steps.add(RainWaterCodeFreeStep(
            left: left,
            right: right,
            leftMax: leftMax,
            rightMax: rightMax,
            totalWater: totalWater,
            addedWaterThisStep: 0,
            heights: List.from(heights),
            trappedWaterPerBar: List.from(waterPerBar),
            statusType: 'max_updated_left',
            titleEn: "Step $stepNum: Update leftMax = $leftMax at index $left",
            titleBn: "ধাপ $stepNum: ইনডেক্স $left এ leftMax = $leftMax আপডেট হলো",
            descriptionEn:
                "Height[left] (${heights[left]}) >= previous leftMax. No water can be trapped on this tall boundary bar. Move left++.",
            descriptionBn:
                "Height[left] (${heights[left]}) নতুন সর্বোচ্চ সীমানা তৈরি করায় পানি জমা হবে না। left++ করা হলো।",
            visualTipEn: "New left boundary wall raised!",
            visualTipBn: "বামপাশের নতুন সর্বোচ্চ দেয়াল তৈরি হলো!",
          ));
        } else {
          int w = leftMax - heights[left];
          waterPerBar[left] = w;
          totalWater += w;
          steps.add(RainWaterCodeFreeStep(
            left: left,
            right: right,
            leftMax: leftMax,
            rightMax: rightMax,
            totalWater: totalWater,
            addedWaterThisStep: w,
            heights: List.from(heights),
            trappedWaterPerBar: List.from(waterPerBar),
            statusType: 'water_added_left',
            titleEn: "Step $stepNum: 🌊 Trapped $w Units Water at Index $left! (leftMax $leftMax - h ${heights[left]})",
            titleBn: "ধাপ $stepNum: 🌊 ইনডেক্স $left এ $w ইউনিট পানি জমা হলো! (leftMax $leftMax - h ${heights[left]})",
            descriptionEn:
                "Left height ${heights[left]} < leftMax $leftMax. Trapped water = $leftMax - ${heights[left]} = $w units. Total water = $totalWater.",
            descriptionBn:
                "উচ্চতা ${heights[left]} সীমানা $leftMax এর চেয়ে কম হওয়ায় $w ইউনিট পানি জমেছে! সর্বমোট পানি = $totalWater।",
            visualTipEn: "Water trapped securely between leftMax wall and current bar!",
            visualTipBn: "দেয়াল ও বারের মাঝখানে পানি সঞ্চিত হলো!",
          ));
        }
        left++;
      } else {
        if (heights[right] >= rightMax) {
          rightMax = heights[right];
          steps.add(RainWaterCodeFreeStep(
            left: left,
            right: right,
            leftMax: leftMax,
            rightMax: rightMax,
            totalWater: totalWater,
            addedWaterThisStep: 0,
            heights: List.from(heights),
            trappedWaterPerBar: List.from(waterPerBar),
            statusType: 'max_updated_right',
            titleEn: "Step $stepNum: Update rightMax = $rightMax at index $right",
            titleBn: "ধাপ $stepNum: ইনডেক্স $right এ rightMax = $rightMax আপডেট হলো",
            descriptionEn:
                "Height[right] (${heights[right]}) >= previous rightMax. No water trapped on this tall boundary bar. Move right--.",
            descriptionBn:
                "Height[right] (${heights[right]}) নতুন সর্বোচ্চ সীমানা তৈরি করায় পানি জমা হবে না। right-- করা হলো।",
            visualTipEn: "New right boundary wall raised!",
            visualTipBn: "ডানপাশের নতুন সর্বোচ্চ দেয়াল তৈরি হলো!",
          ));
        } else {
          int w = rightMax - heights[right];
          waterPerBar[right] = w;
          totalWater += w;
          steps.add(RainWaterCodeFreeStep(
            left: left,
            right: right,
            leftMax: leftMax,
            rightMax: rightMax,
            totalWater: totalWater,
            addedWaterThisStep: w,
            heights: List.from(heights),
            trappedWaterPerBar: List.from(waterPerBar),
            statusType: 'water_added_right',
            titleEn: "Step $stepNum: 🌊 Trapped $w Units Water at Index $right! (rightMax $rightMax - h ${heights[right]})",
            titleBn: "ধাপ $stepNum: 🌊 ইনডেক্স $right এ $w ইউনিট পানি জমা হলো! (rightMax $rightMax - h ${heights[right]})",
            descriptionEn:
                "Right height ${heights[right]} < rightMax $rightMax. Trapped water = $rightMax - ${heights[right]} = $w units. Total water = $totalWater.",
            descriptionBn:
                "উচ্চতা ${heights[right]} সীমানা $rightMax এর চেয়ে কম হওয়ায় $w ইউনিট পানি জমেছে! সর্বমোট পানি = $totalWater।",
            visualTipEn: "Water trapped securely between rightMax wall and current bar!",
            visualTipBn: "ডানপাশের দেয়াল ও বারের মাঝখানে পানি সঞ্চিত হলো!",
          ));
        }
        right--;
      }
      stepNum++;
    }

    // Finish step
    steps.add(RainWaterCodeFreeStep(
      left: left,
      right: right,
      leftMax: leftMax,
      rightMax: rightMax,
      totalWater: totalWater,
      addedWaterThisStep: 0,
      heights: List.from(heights),
      trappedWaterPerBar: List.from(waterPerBar),
      statusType: 'finish',
      titleEn: "🎉 TRAPPING COMPLETE! Total Water Trapped = $totalWater Units 🌊",
      titleBn: "🎉 ট্র্যাপিং সম্পূর্ণ! সর্বমোট সঞ্চিত পানি = $totalWater ইউনিট 🌊",
      descriptionEn:
          "Successfully computed total trapped rain water ($totalWater units) across all $n elevation bars!",
      descriptionBn:
          "সকল $n টি উচ্চতার বারে সর্বমোট $totalWater ইউনিট সঞ্চিত পানি নিখুঁত হিসাব করা হয়েছে!",
      visualTipEn: "✨ Completed in O(N) linear time and O(1) space!",
      visualTipBn: "✨ O(N) সময়াধিক্যে ও O(1) মেমোরিতে সম্পূর্ণ!",
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
        ? RainWaterCodeFreeStep(
            left: 0,
            right: _rawHeights.length - 1,
            leftMax: 0,
            rightMax: 0,
            totalWater: 0,
            addedWaterThisStep: 0,
            heights: _rawHeights,
            trappedWaterPerBar: List.filled(_rawHeights.length, 0),
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
                    Icons.water_drop_rounded,
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
                                ? 'Trapping Rain Water Intuition'
                                : 'ট্র্যাপিং রেইন ওয়াটার ভিজ্যুয়াল অ্যানিমেশন',
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
                            ? 'Watch Two Pointers track leftMax and rightMax boundaries to calculate trapped water columns in real-time!'
                            : 'কোনো কোড ছাড়াই দেখুন কীভাবে টু-পয়েন্টার দিয়ে বাম ও ডান সীমানা ধরে পানির পরিমাণ হিসাব করা হয়!',
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
                final isSelected = _rawHeights.length ==
                        (preset['heights'] as List).length &&
                    _rawHeights.join(',') ==
                        (preset['heights'] as List).join(',');
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

          // 3. Status Gauge & Total Water Trapped
          _buildStatusGauge(step, isEng, isMobile),
          const SizedBox(height: 20),

          // 4. Elevation & Water Columns Visual Graphic
          _buildElevationWaterGraphic(step, isEng, isMobile),
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
      RainWaterCodeFreeStep step, bool isEng, bool isMobile) {
    Color statusColor;
    IconData statusIcon;

    switch (step.statusType) {
      case 'finish':
      case 'water_added_left':
      case 'water_added_right':
        statusColor = AppTheme.accentGreen;
        statusIcon = Icons.water_drop_rounded;
        break;
      case 'max_updated_left':
        statusColor = AppTheme.accentNeonCyan;
        statusIcon = Icons.crop_square_rounded;
        break;
      case 'max_updated_right':
        statusColor = AppTheme.accentAmber;
        statusIcon = Icons.crop_square_rounded;
        break;
      default:
        statusColor = AppTheme.accentNeonCyan;
        statusIcon = Icons.explore_rounded;
    }

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
          const SizedBox(height: 14),

          // Metric Bubbles
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 10 : 16,
                vertical: isMobile ? 8 : 12,
              ),
              decoration: BoxDecoration(
                color: AppTheme.primaryDark,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: statusColor.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  _buildStatBubble("leftMax", "${step.leftMax}", AppTheme.accentNeonCyan, isMobile),
                  const SizedBox(width: 10),
                  _buildStatBubble("rightMax", "${step.rightMax}", AppTheme.accentAmber, isMobile),
                  const SizedBox(width: 10),
                  _buildStatBubble("Total Trapped Water 🌊", "${step.totalWater} Units", AppTheme.accentGreen, isMobile),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBubble(String label, String val, Color color, bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 10 : 12,
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
              fontSize: Responsive.sp(context, isMobile ? 12 : 13.5),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  /// Elevation Map Graphic with Elevation Bars & Water Columns
  Widget _buildElevationWaterGraphic(
      RainWaterCodeFreeStep step, bool isEng, bool isMobile) {
    final heights = step.heights;
    final water = step.trappedWaterPerBar;
    int maxH = 1;
    for (int h in heights) {
      if (h > maxH) maxH = h;
    }

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isEng ? 'Elevation Map & Trapped Water Columns:' : 'উচ্চতার ম্যাপ ও জমে থাকা পানির স্তম্ভ:',
                style: TextStyle(
                  color: AppTheme.accentNeonCyan,
                  fontWeight: FontWeight.bold,
                  fontSize: Responsive.sp(context, 13.5),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.accentGreen.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "Water: ${step.totalWater} units",
                  style: TextStyle(
                      color: AppTheme.accentGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: Responsive.sp(context, 11)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(heights.length, (idx) {
                final h = heights[idx];
                final w = water[idx];
                final isLeft = idx == step.left;
                final isRight = idx == step.right;

                double barHeight = (h / maxH) * 110.0;
                double waterHeight = (w / maxH) * 110.0;

                return Container(
                  margin: EdgeInsets.only(right: isMobile ? 4 : 6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Pointer Header
                      SizedBox(
                        height: 22,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (isLeft && isRight)
                              const Text('L&R',
                                  style: TextStyle(
                                      fontSize: 9,
                                      color: AppTheme.accentGreen,
                                      fontWeight: FontWeight.bold))
                            else if (isLeft)
                              const Text('L',
                                  style: TextStyle(
                                      fontSize: 9,
                                      color: AppTheme.accentNeonCyan,
                                      fontWeight: FontWeight.bold))
                            else if (isRight)
                              const Text('R',
                                  style: TextStyle(
                                      fontSize: 9,
                                      color: AppTheme.accentAmber,
                                      fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Column Stack (Water on top of Elevation Bar)
                      Container(
                        width: isMobile ? 36 : 42,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: (isLeft || isRight)
                                ? (isLeft ? AppTheme.accentNeonCyan : AppTheme.accentAmber)
                                : const Color(0xFF334155),
                            width: (isLeft || isRight) ? 2.0 : 1.0,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // Water Column
                            if (w > 0)
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                width: double.infinity,
                                height: waterHeight < 12 ? 12 : waterHeight,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0284C7).withOpacity(0.85),
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                                ),
                                child: Center(
                                  child: Text(
                                    '+$w',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: Responsive.sp(context, 9.5),
                                    ),
                                  ),
                                ),
                              ),
                            // Bar Block
                            Container(
                              width: double.infinity,
                              height: barHeight < 16 ? 16 : barHeight,
                              decoration: BoxDecoration(
                                color: (isLeft || isRight)
                                    ? const Color(0xFF475569)
                                    : const Color(0xFF1E293B),
                                borderRadius: w > 0
                                    ? BorderRadius.zero
                                    : const BorderRadius.vertical(top: Radius.circular(4)),
                              ),
                              child: Center(
                                child: Text(
                                  '$h',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: Responsive.sp(context, 11),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '[$idx]',
                        style: TextStyle(
                          fontSize: Responsive.sp(context, 8.5),
                          color: AppTheme.textMuted,
                        ),
                      ),
                    ],
                  ),
                );
              }),
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
      RainWaterCodeFreeStep step, bool isEng, bool isMobile) {
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
