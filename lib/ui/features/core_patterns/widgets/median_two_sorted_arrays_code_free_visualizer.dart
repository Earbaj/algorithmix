import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class MedianCodeFreeStep {
  final int partition1;
  final int partition2;
  final int maxLeft1;
  final int minRight1;
  final int maxLeft2;
  final int minRight2;
  final List<int> nums1;
  final List<int> nums2;
  final double calculatedMedian;
  final String statusType; // 'init', 'search_step', 'found_median', 'finish'
  final String titleEn;
  final String titleBn;
  final String descriptionEn;
  final String descriptionBn;
  final String visualTipEn;
  final String visualTipBn;

  const MedianCodeFreeStep({
    required this.partition1,
    required this.partition2,
    required this.maxLeft1,
    required this.minRight1,
    required this.maxLeft2,
    required this.minRight2,
    required this.nums1,
    required this.nums2,
    required this.calculatedMedian,
    required this.statusType,
    required this.titleEn,
    required this.titleBn,
    required this.descriptionEn,
    required this.descriptionBn,
    required this.visualTipEn,
    required this.visualTipBn,
  });
}

class MedianTwoSortedArraysCodeFreeVisualizer extends StatefulWidget {
  final bool isEnglish;

  const MedianTwoSortedArraysCodeFreeVisualizer({
    super.key,
    required this.isEnglish,
  });

  @override
  State<MedianTwoSortedArraysCodeFreeVisualizer> createState() =>
      _MedianTwoSortedArraysCodeFreeVisualizerState();
}

class _MedianTwoSortedArraysCodeFreeVisualizerState
    extends State<MedianTwoSortedArraysCodeFreeVisualizer> {
  List<int> _rawNums1 = [1, 3];
  List<int> _rawNums2 = [2];

  List<MedianCodeFreeStep> _steps = [];
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  // Presets
  final List<Map<String, dynamic>> _presets = [
    {
      'label': 'nums1 = [1, 3], nums2 = [2]',
      'nums1': [1, 3],
      'nums2': [2],
    },
    {
      'label': 'nums1 = [1, 2], nums2 = [3, 4]',
      'nums1': [1, 2],
      'nums2': [3, 4],
    },
    {
      'label': 'nums1 = [0, 0], nums2 = [0, 0]',
      'nums1': [0, 0],
      'nums2': [0, 0],
    },
    {
      'label': 'nums1 = [2], nums2 = []',
      'nums1': [2],
      'nums2': <int>[],
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

  void _loadPreset(List<int> n1, List<int> n2) {
    _timer?.cancel();
    setState(() {
      _isPlaying = false;
      _rawNums1 = List.from(n1);
      _rawNums2 = List.from(n2);
      _currentStepIndex = 0;
      _generateCodeFreeSteps();
    });
  }

  void _generateCodeFreeSteps() {
    List<MedianCodeFreeStep> steps = [];
    List<int> nums1 = List.from(_rawNums1);
    List<int> nums2 = List.from(_rawNums2);

    int m = nums1.length;
    int n = nums2.length;

    // Ensure nums1 is smaller or equal length
    bool swapped = false;
    if (m > n) {
      List<int> tempArr = nums1;
      nums1 = nums2;
      nums2 = tempArr;
      m = nums1.length;
      n = nums2.length;
      swapped = true;
    }

    int low = 0;
    int high = m;
    int halfLen = (m + n + 1) ~/ 2;

    const int inf = 9999999;
    const int negInf = -9999999;

    // Initial step
    steps.add(MedianCodeFreeStep(
      partition1: 0,
      partition2: halfLen,
      maxLeft1: negInf,
      minRight1: m > 0 ? nums1[0] : inf,
      maxLeft2: halfLen > 0 && n >= halfLen ? nums2[halfLen - 1] : negInf,
      minRight2: halfLen < n ? nums2[halfLen] : inf,
      nums1: List.from(nums1),
      nums2: List.from(nums2),
      calculatedMedian: 0.0,
      statusType: 'init',
      titleEn: "Step 1: Init Binary Search on Smaller Array (m = $m, n = $n)",
      titleBn: "ধাপ ১: ছোট অ্যারের উপর বাইনারি সার্চ শুরু (m = $m, n = $n)",
      descriptionEn:
          "Target half length = (m + n + 1) / 2 = $halfLen. We search partition X in nums1 [0..$m] such that left half elements <= right half elements.",
      descriptionBn:
          "অর্ধেক অংশের দৈর্ঘ্য = $halfLen। nums1 এ পার্টিশন X খুঁজে বের করব যেন বামপাশের সব উপাদান ডানপাশের উপাদানের চেয়ে ছোট বা সমান হয়।",
      visualTipEn: "Partition Goal: Max(Left1, Left2) <= Min(Right1, Right2)!",
      visualTipBn: "পার্টিশনের লক্ষ্য: Max(Left1, Left2) <= Min(Right1, Right2) হতে হবে!",
    ));

    int stepNum = 2;

    while (low <= high) {
      int p1 = (low + high) ~/ 2;
      int p2 = halfLen - p1;

      int maxLeft1 = (p1 == 0) ? negInf : nums1[p1 - 1];
      int minRight1 = (p1 == m) ? inf : nums1[p1];

      int maxLeft2 = (p2 == 0) ? negInf : nums2[p2 - 1];
      int minRight2 = (p2 == n) ? inf : nums2[p2];

      if (maxLeft1 <= minRight2 && maxLeft2 <= minRight1) {
        double median;
        if ((m + n) % 2 == 1) {
          median = (maxLeft1 > maxLeft2 ? maxLeft1 : maxLeft2).toDouble();
        } else {
          int lMax = maxLeft1 > maxLeft2 ? maxLeft1 : maxLeft2;
          int rMin = minRight1 < minRight2 ? minRight1 : minRight2;
          median = (lMax + rMin) / 2.0;
        }

        steps.add(MedianCodeFreeStep(
          partition1: p1,
          partition2: p2,
          maxLeft1: maxLeft1,
          minRight1: minRight1,
          maxLeft2: maxLeft2,
          minRight2: minRight2,
          nums1: List.from(nums1),
          nums2: List.from(nums2),
          calculatedMedian: median,
          statusType: 'found_median',
          titleEn: "Step $stepNum: 🎉 Correct Partition Found! Median = $median",
          titleBn: "ধাপ $stepNum: 🎉 সঠিক পার্টিশন পাওয়া গেছে! মধ্যমা (Median) = $median",
          descriptionEn:
              "Partition 1 = $p1, Partition 2 = $p2. maxLeft1 ($maxLeft1) <= minRight2 ($minRight2) AND maxLeft2 ($maxLeft2) <= minRight1 ($minRight1). Perfect split!",
          descriptionBn:
              "পার্টিশন ১ = $p1, পার্টিশন ২ = $p2। উভয় সীমানার শর্ত পূরণ হয়েছে। নিখুঁত মধ্যমা নির্ধারণ সম্পন্ন!",
          visualTipEn: (m + n) % 2 == 1
              ? "Odd total length: Median = Max(left1, left2) = $median"
              : "Even total length: Median = (Max(left1, left2) + Min(right1, right2)) / 2 = $median",
          visualTipBn: (m + n) % 2 == 1
              ? "বিজোড় মোট দৈর্ঘ্য: মধ্যমা = Max(left1, left2) = $median"
              : "জোড় মোট দৈর্ঘ্য: মধ্যমা = (Max(left1, left2) + Min(right1, right2)) / 2 = $median",
        ));

        // Finish step
        steps.add(MedianCodeFreeStep(
          partition1: p1,
          partition2: p2,
          maxLeft1: maxLeft1,
          minRight1: minRight1,
          maxLeft2: maxLeft2,
          minRight2: minRight2,
          nums1: List.from(nums1),
          nums2: List.from(nums2),
          calculatedMedian: median,
          statusType: 'finish',
          titleEn: "🎉 MEDIAN COMPUTED! Result = $median",
          titleBn: "🎉 মধ্যমা হিসাব সম্পূর্ণ! ফলাফল = $median",
          descriptionEn:
              "Computed median $median in O(log(min(m, n))) logarithmic binary search time!",
          descriptionBn:
              "O(log(min(m, n))) সময়ে উভয় সর্টেড অ্যারের মধ্যমা $median পাওয়া গেল!",
          visualTipEn: "✨ Optimal Logarithmic Binary Search Solution!",
          visualTipBn: "✨ লগেরিথমিক বাইনারি সার্চের সেরা সমাধান!",
        ));
        break;
      } else if (maxLeft1 > minRight2) {
        steps.add(MedianCodeFreeStep(
          partition1: p1,
          partition2: p2,
          maxLeft1: maxLeft1,
          minRight1: minRight1,
          maxLeft2: maxLeft2,
          minRight2: minRight2,
          nums1: List.from(nums1),
          nums2: List.from(nums2),
          calculatedMedian: 0.0,
          statusType: 'search_step',
          titleEn: "Step $stepNum: maxLeft1 ($maxLeft1) > minRight2 ($minRight2) → Move high left",
          titleBn: "ধাপ $stepNum: maxLeft1 ($maxLeft1) > minRight2 ($minRight2) → high বামে সরান",
          descriptionEn:
              "Partition 1 is too far right in nums1. Decrease high = ${p1 - 1}.",
          descriptionBn:
              "nums1 এ পার্টিশন ১ বেশি ডানে চলে গেছে। high = ${p1 - 1} এ বামে কমান।",
          visualTipEn: "Too many elements taken from nums1. Shift search window left.",
          visualTipBn: "nums1 থেকে বেশি উপাদান নেওয়া হয়েছে। সার্চ উইন্ডো বামে সরান।",
        ));
        high = p1 - 1;
      } else {
        steps.add(MedianCodeFreeStep(
          partition1: p1,
          partition2: p2,
          maxLeft1: maxLeft1,
          minRight1: minRight1,
          maxLeft2: maxLeft2,
          minRight2: minRight2,
          nums1: List.from(nums1),
          nums2: List.from(nums2),
          calculatedMedian: 0.0,
          statusType: 'search_step',
          titleEn: "Step $stepNum: maxLeft2 ($maxLeft2) > minRight1 ($minRight1) → Move low right",
          titleBn: "ধাপ $stepNum: maxLeft2 ($maxLeft2) > minRight1 ($minRight1) → low ডানে সরান",
          descriptionEn:
              "Partition 1 is too far left in nums1. Increase low = ${p1 + 1}.",
          descriptionBn:
              "nums1 এ পার্টিশন ১ বেশি বামে থেকে গেছে। low = ${p1 + 1} এ ডানে বাড়ান।",
          visualTipEn: "Too few elements taken from nums1. Shift search window right.",
          visualTipBn: "nums1 থেকে কম উপাদান নেওয়া হয়েছে। সার্চ উইন্ডো ডানে সরান।",
        ));
        low = p1 + 1;
      }
      stepNum++;
    }

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
        ? MedianCodeFreeStep(
            partition1: 0,
            partition2: 0,
            maxLeft1: 0,
            minRight1: 0,
            maxLeft2: 0,
            minRight2: 0,
            nums1: _rawNums1,
            nums2: _rawNums2,
            calculatedMedian: 0.0,
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
                    Icons.balance_rounded,
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
                                ? 'Median of 2 Sorted Arrays Intuition'
                                : 'দুইটি সর্টেড অ্যারের মধ্যমা (Median) ভিজ্যুয়াল অ্যানিমেশন',
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
                            ? 'Watch Logarithmic Binary Search partition two sorted arrays into equal left & right halves to find the median!'
                            : 'কোনো কোড ছাড়াই দেখুন কীভাবে লগেরিথমিক বাইনারি সার্চ দিয়ে দুটি সর্টেড অ্যারেকে সমান দুভাগে কেটে মধ্যমা পাওয়া যায়!',
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
                final isSelected =
                    _rawNums1.join(',') == (preset['nums1'] as List).join(',') &&
                        _rawNums2.join(',') == (preset['nums2'] as List).join(',');
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(
                      preset['label']!,
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
                        _loadPreset(
                            List<int>.from(preset['nums1']), List<int>.from(preset['nums2']));
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),

          // 3. Status Gauge & Partition Info
          _buildStatusGauge(step, isEng, isMobile),
          const SizedBox(height: 20),

          // 4. Partition Graphic (nums1 & nums2 split)
          _buildPartitionGraphic(step, isEng, isMobile),
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
      MedianCodeFreeStep step, bool isEng, bool isMobile) {
    Color statusColor;
    IconData statusIcon;

    switch (step.statusType) {
      case 'finish':
      case 'found_median':
        statusColor = AppTheme.accentGreen;
        statusIcon = Icons.check_circle_rounded;
        break;
      case 'search_step':
        statusColor = AppTheme.accentAmber;
        statusIcon = Icons.swap_horiz_rounded;
        break;
      default:
        statusColor = AppTheme.accentNeonCyan;
        statusIcon = Icons.explore_rounded;
    }

    String maxL1 = step.maxLeft1 == -9999999 ? "-∞" : "${step.maxLeft1}";
    String minR1 = step.minRight1 == 9999999 ? "∞" : "${step.minRight1}";
    String maxL2 = step.maxLeft2 == -9999999 ? "-∞" : "${step.maxLeft2}";
    String minR2 = step.minRight2 == 9999999 ? "∞" : "${step.minRight2}";

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
                  _buildStatBubble("L1 max / R1 min", "$maxL1 / $minR1", AppTheme.accentNeonCyan, isMobile),
                  const SizedBox(width: 10),
                  _buildStatBubble("L2 max / R2 min", "$maxL2 / $minR2", AppTheme.accentPurple, isMobile),
                  const SizedBox(width: 10),
                  _buildStatBubble("Median", step.calculatedMedian == 0.0 ? "Searching..." : "${step.calculatedMedian}", AppTheme.accentGreen, isMobile),
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

  /// Graphic showing nums1 and nums2 with partition line divider
  Widget _buildPartitionGraphic(
      MedianCodeFreeStep step, bool isEng, bool isMobile) {
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
            isEng ? 'Partition Split Graphic:' : 'পার্টিশন বিভাজন লেআউট:',
            style: TextStyle(
              color: AppTheme.accentNeonCyan,
              fontWeight: FontWeight.bold,
              fontSize: Responsive.sp(context, 13.5),
            ),
          ),
          const SizedBox(height: 14),

          // nums1 row
          _buildSingleArrayPartition(
              "nums1", step.nums1, step.partition1, AppTheme.accentNeonCyan, isMobile),
          const SizedBox(height: 14),

          // nums2 row
          _buildSingleArrayPartition(
              "nums2", step.nums2, step.partition2, AppTheme.accentPurple, isMobile),
        ],
      ),
    );
  }

  Widget _buildSingleArrayPartition(
      String label, List<int> arr, int partition, Color color, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label (Partition = $partition):",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: Responsive.sp(context, 12)),
        ),
        const SizedBox(height: 6),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              if (arr.isEmpty)
                Container(
                  padding: const EdgeInsets.all(8),
                  child: Text("[Empty Array]",
                      style: TextStyle(
                          color: AppTheme.textMuted,
                          fontSize: Responsive.sp(context, 11))),
                )
              else
                ...List.generate(arr.length + 1, (idx) {
                  if (idx == partition) {
                    // Partition divider vertical line
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 4,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppTheme.accentPink,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    );
                  }

                  int itemIdx = idx > partition ? idx - 1 : idx;
                  bool isLeftHalf = itemIdx < partition;

                  return Container(
                    margin: const EdgeInsets.only(right: 4),
                    width: isMobile ? 38 : 44,
                    padding: EdgeInsets.symmetric(vertical: isMobile ? 8 : 10),
                    decoration: BoxDecoration(
                      color: isLeftHalf
                          ? color.withOpacity(0.25)
                          : AppTheme.primaryDark,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isLeftHalf ? color : const Color(0xFF334155),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '${arr[itemIdx]}',
                          style: TextStyle(
                            fontSize: Responsive.sp(context, isMobile ? 13 : 15),
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '[$itemIdx]',
                          style: TextStyle(
                            fontSize: Responsive.sp(context, 8.5),
                            color: AppTheme.textMuted,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
            ],
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
      MedianCodeFreeStep step, bool isEng, bool isMobile) {
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
