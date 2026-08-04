import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class ReverseStringCodeFreeStep {
  final int left;
  final int right;
  final List<String> arrayState;
  final String statusType; // 'init', 'swap', 'finish'
  final String titleEn;
  final String titleBn;
  final String descriptionEn;
  final String descriptionBn;
  final String visualTipEn;
  final String visualTipBn;
  final String swappedLeftChar;
  final String swappedRightChar;

  const ReverseStringCodeFreeStep({
    required this.left,
    required this.right,
    required this.arrayState,
    required this.statusType,
    required this.titleEn,
    required this.titleBn,
    required this.descriptionEn,
    required this.descriptionBn,
    required this.visualTipEn,
    required this.visualTipBn,
    required this.swappedLeftChar,
    required this.swappedRightChar,
  });
}

class ReverseStringCodeFreeVisualizer extends StatefulWidget {
  final bool isEnglish;

  const ReverseStringCodeFreeVisualizer({
    super.key,
    required this.isEnglish,
  });

  @override
  State<ReverseStringCodeFreeVisualizer> createState() =>
      _ReverseStringCodeFreeVisualizerState();
}

class _ReverseStringCodeFreeVisualizerState
    extends State<ReverseStringCodeFreeVisualizer> {
  List<String> _currentArray = ["h", "e", "l", "l", "o"];
  List<ReverseStringCodeFreeStep> _steps = [];
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  // Presets
  final List<Map<String, dynamic>> _presets = [
    {
      'label': '["h", "e", "l", "l", "o"]',
      'array': ["h", "e", "l", "l", "o"],
    },
    {
      'label': '["H", "a", "n", "n", "a", "h"]',
      'array': ["H", "a", "n", "n", "a", "h"],
    },
    {
      'label': '["A", "l", "g", "o", "r", "i", "t", "h", "m"]',
      'array': ["A", "l", "g", "o", "r", "i", "t", "h", "m"],
    },
    {
      'label': '["a", "b", "c"]',
      'array': ["a", "b", "c"],
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

  void _loadPreset(List<String> arr) {
    _timer?.cancel();
    setState(() {
      _isPlaying = false;
      _currentArray = List.from(arr);
      _currentStepIndex = 0;
      _generateCodeFreeSteps();
    });
  }

  void _generateCodeFreeSteps() {
    List<ReverseStringCodeFreeStep> steps = [];
    List<String> arr = List.from(_currentArray);
    int l = 0;
    int r = arr.length - 1;

    // Step 0: Start Pointers
    steps.add(ReverseStringCodeFreeStep(
      left: l,
      right: r,
      arrayState: List.from(arr),
      statusType: 'init',
      titleEn: "Step 1: Place Pointers at Both Ends",
      titleBn: "ধাপ ১: শুরু ও শেষ ইনডেক্সে পয়েন্টার বসানো",
      descriptionEn:
          "Left pointer starts at index 0 ('${arr[l]}') and Right pointer starts at last index ('${arr[r]}').",
      descriptionBn:
          "Left পয়েন্টার শুরুতে (০) এবং Right পয়েন্টার একদম শেষে বসানো হলো।",
      visualTipEn: "Swap elements at left and right pointers, then move inward!",
      visualTipBn: "উভয় পয়েন্টারের অক্ষর ইন-প্লেস অদলবদল (Swap) করুন এবং মাঝে এগোন!",
      swappedLeftChar: arr[l],
      swappedRightChar: arr[r],
    ));

    int stepNum = 2;

    while (l < r) {
      String charL = arr[l];
      String charR = arr[r];

      // Perform in-place swap
      String temp = arr[l];
      arr[l] = arr[r];
      arr[r] = temp;

      steps.add(ReverseStringCodeFreeStep(
        left: l,
        right: r,
        arrayState: List.from(arr),
        statusType: 'swap',
        titleEn: "Step $stepNum: Swap ('$charL' ⇋ '$charR')",
        titleBn: "ধাপ $stepNum: Swap অদলবদল ('$charL' ⇋ '$charR')",
        descriptionEn:
            "Swapped '${charL}' at index $l with '${charR}' at index $r. Increment left (left++) and decrement right (right--).",
        descriptionBn:
            "ইনডেক্স $l এর '$charL' এবং ইনডেক্স $r এর '$charR' Swap করা হলো। left পয়েন্টার বাড়ান ও right কমান।",
        visualTipEn: "In-place swap accomplishes reversal with zero extra memory O(1)!",
        visualTipBn: "কোনো অতিরিক্ত মেমোরি ছাড়া ইন-প্লেস Swap দিয়ে রিভার্স হচ্ছে!",
        swappedLeftChar: charR,
        swappedRightChar: charL,
      ));

      l++;
      r--;
      stepNum++;
    }

    // Finish step
    steps.add(ReverseStringCodeFreeStep(
      left: l,
      right: r,
      arrayState: List.from(arr),
      statusType: 'finish',
      titleEn: "🎉 STRING REVERSAL COMPLETE!",
      titleBn: "🎉 স্ট্রিং রিভার্স সম্পূর্ণ হয়েছে!",
      descriptionEn:
          "Pointers met or crossed in center. Reversed result: ${arr.join('')}",
      descriptionBn:
          "পয়েন্টারদ্বয় কেন্দ্রে পৌঁছে গেছে। চূড়ান্ত রিভার্সড রেজাল্ট: ${arr.join('')}",
      visualTipEn: "✨ Completed in O(N/2) swaps with O(1) auxiliary space!",
      visualTipBn: "✨ O(1) মেমোরিতে সম্পূর্ণ স্ট্রিং রিভার্সড সম্পন্ন হয়েছে।",
      swappedLeftChar: l < arr.length ? arr[l] : "",
      swappedRightChar: r >= 0 ? arr[r] : "",
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
        ? ReverseStringCodeFreeStep(
            left: 0,
            right: 0,
            arrayState: _currentArray,
            statusType: 'init',
            titleEn: '',
            titleBn: '',
            descriptionEn: '',
            descriptionBn: '',
            visualTipEn: '',
            visualTipBn: '',
            swappedLeftChar: '',
            swappedRightChar: '',
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
                                ? 'Reverse String Intuition'
                                : 'রিভার্স স্ট্রিং ভিজ্যুয়াল অ্যানিমেশন',
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
                            ? 'Watch how two pointers swap characters in-place from ends to center with O(1) extra space!'
                            : 'কোনো কোড ছাড়াই দেখুন কীভাবে টু-পয়েন্টার ইন-প্লেস অক্ষর অদলবদল করে সম্পূর্ণ স্ট্রিং রিভার্স করে!',
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
            isEng ? '🎯 Choose a Test Array:' : '🎯 টেস্ট কেস বেছে নিন:',
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
                        _loadPreset(List<String>.from(preset['array']));
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),

          // 3. Dynamic Swap Gauge
          _buildSwapGauge(step, isEng, isMobile),
          const SizedBox(height: 20),

          // 4. Character Array Visualizer
          _buildCharacterArrayGraphic(step, isEng, isMobile),
          const SizedBox(height: 20),

          // 5. Interactive Playback Controls
          _buildPlaybackControls(isEng, isMobile),
          const SizedBox(height: 20),

          // 6. Intuition Explanation Card
          _buildIntuitionExplanationCard(step, isEng, isMobile),
        ],
      ),
    );
  }

  /// Visual Swap Gauge
  Widget _buildSwapGauge(
      ReverseStringCodeFreeStep step, bool isEng, bool isMobile) {
    Color statusColor;
    IconData statusIcon;

    switch (step.statusType) {
      case 'finish':
        statusColor = AppTheme.accentGreen;
        statusIcon = Icons.check_circle_rounded;
        break;
      case 'swap':
        statusColor = AppTheme.accentNeonCyan;
        statusIcon = Icons.swap_horiz_rounded;
        break;
      default:
        statusColor = AppTheme.accentPurple;
        statusIcon = Icons.unfold_more_rounded;
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
          const SizedBox(height: 16),

          // Swap Capsule Display
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
                  _buildCharBubble(
                    label: "Left [${step.left}]",
                    val: step.left < step.arrayState.length ? step.arrayState[step.left] : "",
                    color: AppTheme.accentNeonCyan,
                    isMobile: isMobile,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 18),
                    child: Row(
                      children: [
                        Icon(Icons.swap_horiz_rounded,
                            color: statusColor,
                            size: Responsive.sp(context, isMobile ? 22 : 28)),
                      ],
                    ),
                  ),
                  _buildCharBubble(
                    label: "Right [${step.right}]",
                    val: step.right >= 0 && step.right < step.arrayState.length
                        ? step.arrayState[step.right]
                        : "",
                    color: AppTheme.accentPurple,
                    isMobile: isMobile,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCharBubble({
    required String label,
    required String val,
    required Color color,
    required bool isMobile,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 16,
        vertical: isMobile ? 6 : 10,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: Responsive.sp(context, 10),
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            "'$val'",
            style: TextStyle(
              fontSize: Responsive.sp(context, isMobile ? 15 : 18),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  /// Array Graphic showing active pointers and swapped positions
  Widget _buildCharacterArrayGraphic(
      ReverseStringCodeFreeStep step, bool isEng, bool isMobile) {
    final arr = step.arrayState;

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
          if (isMobile) ...[
            Text(
              isEng ? '🔤 Array In-Place Swap View' : '🔤 অ্যারেই ইন-প্লেস Swap ভিউ',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: Responsive.sp(context, 13.5),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              runSpacing: 6,
              children: [
                _buildLegendItem("Left (L)", AppTheme.accentNeonCyan),
                _buildLegendItem("Right (R)", AppTheme.accentPurple),
                _buildLegendItem(isEng ? "Swapped" : "Swap সম্পূর্ণ", AppTheme.accentGreen),
              ],
            ),
          ] else ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isEng ? '🔤 Array In-Place Swap View' : '🔤 অ্যারেই ইন-প্লেস Swap ভিউ',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: Responsive.sp(context, 14),
                  ),
                ),
                Row(
                  children: [
                    _buildLegendItem("Left (L)", AppTheme.accentNeonCyan),
                    const SizedBox(width: 10),
                    _buildLegendItem("Right (R)", AppTheme.accentPurple),
                    const SizedBox(width: 10),
                    _buildLegendItem(isEng ? "Swapped" : "Swap সম্পূর্ণ", AppTheme.accentGreen),
                  ],
                ),
              ],
            ),
          ],
          const SizedBox(height: 16),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(arr.length, (idx) {
                final char = arr[idx];
                final isLeft = idx == step.left;
                final isRight = idx == step.right;
                final isSwapped = idx < step.left || idx > step.right;

                Color borderColor = const Color(0xFF334155);
                Color bgColor = AppTheme.primaryDark;

                if (isLeft && isRight) {
                  borderColor = AppTheme.accentAmber;
                  bgColor = AppTheme.accentAmber.withOpacity(0.25);
                } else if (isLeft) {
                  borderColor = AppTheme.accentNeonCyan;
                  bgColor = AppTheme.accentNeonCyan.withOpacity(0.25);
                } else if (isRight) {
                  borderColor = AppTheme.accentPurple;
                  bgColor = AppTheme.accentPurple.withOpacity(0.25);
                } else if (isSwapped) {
                  borderColor = AppTheme.accentGreen.withOpacity(0.6);
                  bgColor = AppTheme.accentGreen.withOpacity(0.12);
                }

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: EdgeInsets.only(right: isMobile ? 6 : 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Top Pointer Indicator
                      SizedBox(
                        height: 34,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (isLeft && isRight)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 1),
                                decoration: BoxDecoration(
                                  color: AppTheme.accentAmber,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'L&R',
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              )
                            else if (isLeft)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 1),
                                decoration: BoxDecoration(
                                  color: AppTheme.accentNeonCyan,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'Left',
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              )
                            else if (isRight)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 1),
                                decoration: BoxDecoration(
                                  color: AppTheme.accentPurple,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'Right',
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            if (isLeft || isRight)
                              Icon(
                                Icons.arrow_drop_down,
                                color: isLeft
                                    ? AppTheme.accentNeonCyan
                                    : AppTheme.accentPurple,
                                size: 16,
                              ),
                          ],
                        ),
                      ),

                      // Card Body
                      AnimatedScale(
                        scale: (isLeft || isRight) ? 1.08 : 1.0,
                        duration: const Duration(milliseconds: 250),
                        child: Container(
                          width: isMobile ? 46 : 54,
                          padding: EdgeInsets.symmetric(
                              vertical: isMobile ? 8 : 10),
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: borderColor,
                              width: (isLeft || isRight) ? 2.2 : 1.0,
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                '"$char"',
                                style: TextStyle(
                                  fontSize: Responsive.sp(
                                      context, isMobile ? 15 : 17),
                                  fontWeight: FontWeight.bold,
                                  color: isSwapped
                                      ? AppTheme.accentGreen
                                      : Colors.white,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '$idx',
                                style: TextStyle(
                                  fontSize: Responsive.sp(context, 9),
                                  color: AppTheme.textMuted,
                                ),
                              ),
                            ],
                          ),
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

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: Responsive.sp(context, 11)),
        ),
      ],
    );
  }

  Widget _buildIntuitionExplanationCard(
      ReverseStringCodeFreeStep step, bool isEng, bool isMobile) {
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
