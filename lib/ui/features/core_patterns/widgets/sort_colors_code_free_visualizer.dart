import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class SortColorsCodeFreeStep {
  final int low;
  final int mid;
  final int high;
  final List<int> array;
  final String statusType; // 'init', 'swap_low_mid', 'move_mid', 'swap_mid_high', 'finish'
  final String titleEn;
  final String titleBn;
  final String descriptionEn;
  final String descriptionBn;
  final String visualTipEn;
  final String visualTipBn;

  const SortColorsCodeFreeStep({
    required this.low,
    required this.mid,
    required this.high,
    required this.array,
    required this.statusType,
    required this.titleEn,
    required this.titleBn,
    required this.descriptionEn,
    required this.descriptionBn,
    required this.visualTipEn,
    required this.visualTipBn,
  });
}

class SortColorsCodeFreeVisualizer extends StatefulWidget {
  final bool isEnglish;

  const SortColorsCodeFreeVisualizer({
    super.key,
    required this.isEnglish,
  });

  @override
  State<SortColorsCodeFreeVisualizer> createState() =>
      _SortColorsCodeFreeVisualizerState();
}

class _SortColorsCodeFreeVisualizerState
    extends State<SortColorsCodeFreeVisualizer> {
  List<int> _currentArray = [2, 0, 2, 1, 1, 0];

  List<SortColorsCodeFreeStep> _steps = [];
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  // Presets
  final List<Map<String, dynamic>> _presets = [
    {
      'label': '[2, 0, 2, 1, 1, 0]',
      'array': [2, 0, 2, 1, 1, 0],
    },
    {
      'label': '[2, 0, 1]',
      'array': [2, 0, 1],
    },
    {
      'label': '[0, 1, 2]',
      'array': [0, 1, 2],
    },
    {
      'label': '[1, 0, 2, 1, 0]',
      'array': [1, 0, 2, 1, 0],
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

  void _loadPreset(List<int> arr) {
    _timer?.cancel();
    setState(() {
      _isPlaying = false;
      _currentArray = List.from(arr);
      _currentStepIndex = 0;
      _generateCodeFreeSteps();
    });
  }

  void _generateCodeFreeSteps() {
    List<SortColorsCodeFreeStep> steps = [];
    List<int> nums = List.from(_currentArray);
    int n = nums.length;

    if (n == 0) return;

    int low = 0;
    int mid = 0;
    int high = n - 1;

    // Initial step
    steps.add(SortColorsCodeFreeStep(
      low: low,
      mid: mid,
      high: high,
      array: List.from(nums),
      statusType: 'init',
      titleEn: "Step 1: Init Pointers (low = 0, mid = 0, high = ${n - 1})",
      titleBn: "ধাপ ১: ৩টি পয়েন্টার বসান (low = 0, mid = 0, high = ${n - 1})",
      descriptionEn:
          "Partition regions: Red 🔴 (0s) before low, White ⚪ (1s) between low & mid, Blue 🔵 (2s) after high.",
      descriptionBn:
          "পার্টিশন অঞ্চলসমূহ: low এর পূর্বে লাল 🔴 (0), low ও mid এর মধ্যে সাদা ⚪ (1), high এর পরে নীল 🔵 (2)।",
      visualTipEn: "Dutch National Flag Algorithm sorts 0s, 1s, and 2s in a single pass O(N)!",
      visualTipBn: "ডাচ ন্যাশনাল ফ্ল্যাগ অ্যালগরিদম মাত্র ১টি পাসে O(N) সময়ে সর্ট করে!",
    ));

    int stepNum = 2;

    while (mid <= high) {
      int val = nums[mid];

      if (val == 0) {
        // Swap low & mid, then low++, mid++
        steps.add(SortColorsCodeFreeStep(
          low: low,
          mid: mid,
          high: high,
          array: List.from(nums),
          statusType: 'swap_low_mid',
          titleEn: "Step $stepNum: nums[mid] is 0 (Red 🔴) → Swap(low, mid), low++, mid++",
          titleBn: "ধাপ $stepNum: nums[mid] হলো 0 (লাল 🔴) → Swap(low, mid), low++, mid++",
          descriptionEn:
              "Found Red 🔴 (0) at index $mid. Swap nums[$low] (${nums[low]}) and nums[$mid] ($val). Increment both low & mid pointers.",
          descriptionBn:
              "ইনডেক্স $mid এ লাল 🔴 (0) পাওয়া গেছে। nums[$low] (${nums[low]}) ও nums[$mid] ($val) অদলবদল করুন। low ও mid পয়েন্টার বাড়ান।",
          visualTipEn: "Red elements (0s) are placed into the left partition!",
          visualTipBn: "লাল উপাদানসমূহকে (0) বামের পার্টিশনে পাঠানো হচ্ছে!",
        ));

        int temp = nums[low];
        nums[low] = nums[mid];
        nums[mid] = temp;
        low++;
        mid++;
      } else if (val == 1) {
        // Just mid++
        steps.add(SortColorsCodeFreeStep(
          low: low,
          mid: mid,
          high: high,
          array: List.from(nums),
          statusType: 'move_mid',
          titleEn: "Step $stepNum: nums[mid] is 1 (White ⚪) → Move mid++",
          titleBn: "ধাপ $stepNum: nums[mid] হলো 1 (সাদা ⚪) → mid++ করুন",
          descriptionEn:
              "Found White ⚪ (1) at index $mid. It is already in the middle partition. Simply advance mid++.",
          descriptionBn:
              "ইনডেক্স $mid এ সাদা ⚪ (1) পাওয়া গেছে। এটি ইতোমধ্যেই মাঝের পার্টিশনে আছে। কেবল mid++ এগিয়ে নিন।",
          visualTipEn: "White elements (1s) stay in the middle section!",
          visualTipBn: "সাদা উপাদানসমূহ (1) মাঝের ব্লকে থাকছে!",
        ));
        mid++;
      } else {
        // Swap mid & high, then high-- (do not increment mid!)
        steps.add(SortColorsCodeFreeStep(
          low: low,
          mid: mid,
          high: high,
          array: List.from(nums),
          statusType: 'swap_mid_high',
          titleEn: "Step $stepNum: nums[mid] is 2 (Blue 🔵) → Swap(mid, high), high--",
          titleBn: "ধাপ $stepNum: nums[mid] হলো 2 (নীল 🔵) → Swap(mid, high), high--",
          descriptionEn:
              "Found Blue 🔵 (2) at index $mid. Swap nums[$mid] ($val) and nums[$high] (${nums[high]}). Decrement high--. Do not move mid yet!",
          descriptionBn:
              "ইনডেক্স $mid এ নীল 🔵 (2) পাওয়া গেছে। nums[$mid] ($val) ও nums[$high] (${nums[high]}) অদলবদল করুন এবং high-- কমান।",
          visualTipEn: "Blue elements (2s) are sent to the right partition! Keep mid at same index to re-examine swapped value.",
          visualTipBn: "নীল উপাদানসমূহকে (2) ডানের পার্টিশনে পাঠানো হচ্ছে! স্বপ হওয়া নতুন উপাদান পরীক্ষার জন্য mid স্থির রাখুন।",
        ));

        int temp = nums[mid];
        nums[mid] = nums[high];
        nums[high] = temp;
        high--;
      }
      stepNum++;
    }

    // Finish step
    steps.add(SortColorsCodeFreeStep(
      low: low,
      mid: mid,
      high: high,
      array: List.from(nums),
      statusType: 'finish',
      titleEn: "🎉 SORT COMPLETE! Sorted Array = [${nums.join(', ')}]",
      titleBn: "🎉 সর্টিং সম্পূর্ণ! সর্টেড অ্যারে = [${nums.join(', ')}]",
      descriptionEn:
          "All 0s (Red 🔴), 1s (White ⚪), and 2s (Blue 🔵) are perfectly partitioned in-place!",
      descriptionBn:
          "সকল 0s (লাল 🔴), 1s (সাদা ⚪) এবং 2s (নীল 🔵) সর্টেড অবস্থায় পার্টিশন করা শেষ!",
      visualTipEn: "✨ Single pass 3-Way Partitioning completed in O(N) time and O(1) space!",
      visualTipBn: "✨ একক পাসে O(N) সময়ে ৩-ওয়ে পার্টিশনিং সম্পন্ন!",
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
        ? SortColorsCodeFreeStep(
            low: 0,
            mid: 0,
            high: _currentArray.length - 1,
            array: _currentArray,
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
                                ? 'Sort Colors (Dutch National Flag) Intuition'
                                : 'শর্ট কালার্স (ডাচ ন্যাশনাল ফ্ল্যাগ) অ্যানিমেশন',
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
                            ? 'Watch 3-Way Partitioning (low, mid, high) sort 0s (Red), 1s (White), and 2s (Blue) in a single pass O(N) without extra memory!'
                            : 'কোনো কোড ছাড়াই দেখুন কীভাবে ৩টি পয়েন্টারের সাহায্যে লাল, সাদা ও নীল রঙের ব্লক এক পাসে O(N) সময়ে সর্ট করা হয়!',
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
                final isSelected = _currentArray.length ==
                        (preset['array'] as List).length &&
                    _currentArray.first == (preset['array'] as List).first;
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
                        _loadPreset(List<int>.from(preset['array']));
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),

          // 3. Partition Regions Status Gauge
          _buildStatusGauge(step, isEng, isMobile),
          const SizedBox(height: 20),

          // 4. Color Blocks Pointer Graphic
          _buildColorBlockGraphic(step, isEng, isMobile),
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
      SortColorsCodeFreeStep step, bool isEng, bool isMobile) {
    Color statusColor;
    IconData statusIcon;

    switch (step.statusType) {
      case 'finish':
        statusColor = AppTheme.accentGreen;
        statusIcon = Icons.check_circle_rounded;
        break;
      case 'swap_low_mid':
        statusColor = const Color(0xFFEF4444); // Red
        statusIcon = Icons.swap_horiz_rounded;
        break;
      case 'move_mid':
        statusColor = const Color(0xFFF8FAFC); // White
        statusIcon = Icons.arrow_forward_rounded;
        break;
      case 'swap_mid_high':
        statusColor = const Color(0xFF3B82F6); // Blue
        statusIcon = Icons.swap_horizontal_circle_rounded;
        break;
      default:
        statusColor = AppTheme.accentNeonCyan;
        statusIcon = Icons.flag_rounded;
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

          // Partition Legend Bubbles
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
                  _buildPartitionLegend("0s Region", "🔴 Red", const Color(0xFFEF4444), isMobile),
                  const SizedBox(width: 10),
                  _buildPartitionLegend("1s Region", "⚪ White", const Color(0xFFE2E8F0), isMobile),
                  const SizedBox(width: 10),
                  _buildPartitionLegend("2s Region", "🔵 Blue", const Color(0xFF3B82F6), isMobile),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPartitionLegend(String title, String val, Color color, bool isMobile) {
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
            title,
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

  /// Graphic showing Color Blocks and 3 Pointers (low, mid, high)
  Widget _buildColorBlockGraphic(
      SortColorsCodeFreeStep step, bool isEng, bool isMobile) {
    final arr = step.array;

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
            isEng ? 'Color Blocks with Pointers (low, mid, high):' : 'কালার ব্লক ও ৩টি পয়েন্টারের অবস্থান:',
            style: TextStyle(
              color: AppTheme.accentNeonCyan,
              fontWeight: FontWeight.bold,
              fontSize: Responsive.sp(context, 13.5),
            ),
          ),
          const SizedBox(height: 14),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(arr.length, (idx) {
                final val = arr[idx];
                final isLow = idx == step.low;
                final isMid = idx == step.mid;
                final isHigh = idx == step.high;

                Color blockColor;
                String colorEmoji;
                if (val == 0) {
                  blockColor = const Color(0xFFEF4444); // Red
                  colorEmoji = "🔴";
                } else if (val == 1) {
                  blockColor = const Color(0xFFF1F5F9); // White
                  colorEmoji = "⚪";
                } else {
                  blockColor = const Color(0xFF3B82F6); // Blue
                  colorEmoji = "🔵";
                }

                List<String> pointerLabels = [];
                if (isLow) pointerLabels.add("low");
                if (isMid) pointerLabels.add("mid");
                if (isHigh) pointerLabels.add("high");

                return Container(
                  margin: EdgeInsets.only(right: isMobile ? 6 : 8),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 24,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (pointerLabels.isNotEmpty)
                              Text(
                                pointerLabels.join('&'),
                                style: TextStyle(
                                  fontSize: Responsive.sp(context, 9.5),
                                  color: isMid
                                      ? AppTheme.accentAmber
                                      : (isLow
                                          ? AppTheme.accentNeonCyan
                                          : AppTheme.accentPink),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Container(
                        width: isMobile ? 46 : 56,
                        padding: EdgeInsets.symmetric(
                            vertical: isMobile ? 10 : 12),
                        decoration: BoxDecoration(
                          color: blockColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: blockColor,
                            width: (isLow || isMid || isHigh) ? 2.5 : 1.5,
                          ),
                          boxShadow: (isLow || isMid || isHigh)
                              ? [
                                  BoxShadow(
                                    color: blockColor.withOpacity(0.4),
                                    blurRadius: 10,
                                  )
                                ]
                              : null,
                        ),
                        child: Column(
                          children: [
                            Text(
                              colorEmoji,
                              style: TextStyle(
                                  fontSize: Responsive.sp(context, 16)),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '$val',
                              style: TextStyle(
                                fontSize: Responsive.sp(
                                    context, isMobile ? 15 : 17),
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '[$idx]',
                              style: TextStyle(
                                fontSize: Responsive.sp(context, 8.5),
                                color: AppTheme.textMuted,
                              ),
                            ),
                          ],
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
      SortColorsCodeFreeStep step, bool isEng, bool isMobile) {
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
