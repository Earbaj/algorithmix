import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class SquaresCodeFreeStep {
  final int left;
  final int right;
  final int pos;
  final List<int> originalArray;
  final List<int?> resultArray;
  final String statusType; // 'init', 'choose_left', 'choose_right', 'finish'
  final String titleEn;
  final String titleBn;
  final String descriptionEn;
  final String descriptionBn;
  final String visualTipEn;
  final String visualTipBn;
  final int leftSq;
  final int rightSq;

  const SquaresCodeFreeStep({
    required this.left,
    required this.right,
    required this.pos,
    required this.originalArray,
    required this.resultArray,
    required this.statusType,
    required this.titleEn,
    required this.titleBn,
    required this.descriptionEn,
    required this.descriptionBn,
    required this.visualTipEn,
    required this.visualTipBn,
    required this.leftSq,
    required this.rightSq,
  });
}

class SquaresSortedArrayCodeFreeVisualizer extends StatefulWidget {
  final bool isEnglish;

  const SquaresSortedArrayCodeFreeVisualizer({
    super.key,
    required this.isEnglish,
  });

  @override
  State<SquaresSortedArrayCodeFreeVisualizer> createState() =>
      _SquaresSortedArrayCodeFreeVisualizerState();
}

class _SquaresSortedArrayCodeFreeVisualizerState
    extends State<SquaresSortedArrayCodeFreeVisualizer> {
  List<int> _currentArray = [-4, -1, 0, 3, 10];
  List<SquaresCodeFreeStep> _steps = [];
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  // Presets
  final List<Map<String, dynamic>> _presets = [
    {
      'label': '[-4, -1, 0, 3, 10]',
      'array': [-4, -1, 0, 3, 10],
    },
    {
      'label': '[-7, -3, 2, 3, 11]',
      'array': [-7, -3, 2, 3, 11],
    },
    {
      'label': '[-5, -4, -3, -2, -1]',
      'array': [-5, -4, -3, -2, -1],
    },
    {
      'label': '[1, 2, 3, 4, 5]',
      'array': [1, 2, 3, 4, 5],
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
    List<SquaresCodeFreeStep> steps = [];
    List<int> orig = List.from(_currentArray);
    int n = orig.length;
    List<int?> res = List.filled(n, null);

    int l = 0;
    int r = n - 1;
    int pos = n - 1;

    // Step 0: Start Pointers
    steps.add(SquaresCodeFreeStep(
      left: l,
      right: r,
      pos: pos,
      originalArray: List.from(orig),
      resultArray: List.from(res),
      statusType: 'init',
      titleEn: "Step 1: Place Pointers at Both Ends & Result Pointer at Back",
      titleBn: "ধাপ ১: উভয় প্রান্তে পয়েন্টার ও রেজাল্টের পেছনে রেজাল্ট পয়েন্টার",
      descriptionEn:
          "Left pointer starts at index 0 (${orig[l]}), Right pointer at last index (${orig[r]}). Fill result array from back (index $pos).",
      descriptionBn:
          "Left পয়েন্টার শুরুতে (${orig[l]}), Right পয়েন্টার শেষে (${orig[r]})। রেজাল্ট অ্যারে শেষ (ইনডেক্স $pos) থেকে ভরাট করা হবে।",
      visualTipEn: "The largest squared values always reside at array boundaries!",
      visualTipBn: "বর্গ করার পর সবচেয়ে বড় মান সর্বদা অ্যারের দুই প্রান্তেই থাকে!",
      leftSq: orig[l] * orig[l],
      rightSq: orig[r] * orig[r],
    ));

    int stepNum = 2;

    while (l <= r) {
      int sqL = orig[l] * orig[l];
      int sqR = orig[r] * orig[r];

      if (sqL > sqR) {
        res[pos] = sqL;
        steps.add(SquaresCodeFreeStep(
          left: l,
          right: r,
          pos: pos,
          originalArray: List.from(orig),
          resultArray: List.from(res),
          statusType: 'choose_left',
          titleEn: "Step $stepNum: Left Square ($sqL) > Right Square ($sqR)",
          titleBn: "ধাপ $stepNum: বামের বর্গ ($sqL) > ডানের বর্গ ($sqR)",
          descriptionEn:
              "(${orig[l]})² = $sqL is larger! Place $sqL at result[$pos]. Increment left (left++) & decrement pos.",
          descriptionBn:
              "(${orig[l]})² = $sqL বড়! রেজাল্ট[$pos] এ $sqL বসানো হলো। left পয়েন্টার ডানে ১ আগান।",
          visualTipEn: "Larger square placed at current largest empty slot from right to left.",
          visualTipBn: "বড় বর্গমানটি ডান থেকে বামে ফাঁকা স্থানে স্থানান্তরিত করা হলো।",
          leftSq: sqL,
          rightSq: sqR,
        ));
        l++;
      } else {
        res[pos] = sqR;
        steps.add(SquaresCodeFreeStep(
          left: l,
          right: r,
          pos: pos,
          originalArray: List.from(orig),
          resultArray: List.from(res),
          statusType: 'choose_right',
          titleEn: "Step $stepNum: Right Square ($sqR) ≥ Left Square ($sqL)",
          titleBn: "ধাপ $stepNum: ডানের বর্গ ($sqR) ≥ বামের বর্গ ($sqL)",
          descriptionEn:
              "(${orig[r]})² = $sqR is larger or equal! Place $sqR at result[$pos]. Decrement right (right--) & pos.",
          descriptionBn:
              "(${orig[r]})² = $sqR বড় বা সমান! রেজাল্ট[$pos] এ $sqR বসানো হলো। right পয়েন্টার বামে ১ কমান।",
          visualTipEn: "Larger square placed at current largest empty slot from right to left.",
          visualTipBn: "বড় বর্গমানটি ডান থেকে বামে ফাঁকা স্থানে স্থানান্তরিত করা হলো।",
          leftSq: sqL,
          rightSq: sqR,
        ));
        r--;
      }
      pos--;
      stepNum++;
    }

    // Finish step
    steps.add(SquaresCodeFreeStep(
      left: l,
      right: r,
      pos: -1,
      originalArray: List.from(orig),
      resultArray: List.from(res),
      statusType: 'finish',
      titleEn: "🎉 SQUARES SORTED COMPLETE!",
      titleBn: "🎉 বর্গ করে সর্টিং সম্পন্ন!",
      descriptionEn:
          "Result sorted in non-decreasing order: [${res.join(', ')}]",
      descriptionBn:
          "ছোট থেকে বড় ক্রমে সর্টেড রেজাল্ট: [${res.join(', ')}]",
      visualTipEn: "✨ Achieved in O(N) linear time without applying O(N log N) sort!",
      visualTipBn: "✨ O(N log N) সর্টিং ছাড়াই O(N) সময়ে নিখুঁতভাবে সম্পন্ন!",
      leftSq: 0,
      rightSq: 0,
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
        ? SquaresCodeFreeStep(
            left: 0,
            right: 0,
            pos: 0,
            originalArray: _currentArray,
            resultArray: List.filled(_currentArray.length, null),
            statusType: 'init',
            titleEn: '',
            titleBn: '',
            descriptionEn: '',
            descriptionBn: '',
            visualTipEn: '',
            visualTipBn: '',
            leftSq: 0,
            rightSq: 0,
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
                                ? 'Squares of Sorted Array Intuition'
                                : 'সর্টেড অ্যারে বর্গ ভিজ্যুয়াল অ্যানিমেশন',
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
                            ? 'Watch how opposite pointers compare absolute square values and fill the sorted result from back to front in O(N) time!'
                            : 'কোনো কোড ছাড়াই দেখুন কীভাবে বিপরীত পয়েন্টার বর্গ তুলনা করে রেজাল্ট অ্যারের পেছন থেকে ভরাট করে!',
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
            isEng ? '🎯 Choose a Sorted Test Array:' : '🎯 সর্টেড টেস্ট কেস বেছে নিন:',
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

          // 3. Dynamic Square Comparison Gauge
          _buildComparisonGauge(step, isEng, isMobile),
          const SizedBox(height: 20),

          // 4. Character Array Visualizer (Original & Result Array)
          _buildDualArrayGraphic(step, isEng, isMobile),
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

  /// Visual Comparison Gauge
  Widget _buildComparisonGauge(
      SquaresCodeFreeStep step, bool isEng, bool isMobile) {
    Color statusColor;
    IconData statusIcon;

    switch (step.statusType) {
      case 'finish':
        statusColor = AppTheme.accentGreen;
        statusIcon = Icons.check_circle_rounded;
        break;
      case 'choose_left':
        statusColor = AppTheme.accentNeonCyan;
        statusIcon = Icons.west_rounded;
        break;
      case 'choose_right':
        statusColor = AppTheme.accentPurple;
        statusIcon = Icons.east_rounded;
        break;
      default:
        statusColor = AppTheme.accentAmber;
        statusIcon = Icons.compare_arrows_rounded;
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

          // Comparison Bubble Display
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
                  _buildSqBubble(
                    label: "Left Sq (${step.left < step.originalArray.length ? step.originalArray[step.left] : 0}²)",
                    val: "${step.leftSq}",
                    color: AppTheme.accentNeonCyan,
                    isMobile: isMobile,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 18),
                    child: Text(
                      step.leftSq > step.rightSq
                          ? ">"
                          : (step.leftSq < step.rightSq ? "<" : "=="),
                      style: TextStyle(
                        color: statusColor,
                        fontSize: Responsive.sp(context, isMobile ? 18 : 22),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _buildSqBubble(
                    label: "Right Sq (${step.right >= 0 && step.right < step.originalArray.length ? step.originalArray[step.right] : 0}²)",
                    val: "${step.rightSq}",
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

  Widget _buildSqBubble({
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
            val,
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

  /// Graphic showing Original Array Pointers and Result Array Filling
  Widget _buildDualArrayGraphic(
      SquaresCodeFreeStep step, bool isEng, bool isMobile) {
    final orig = step.originalArray;
    final res = step.resultArray;

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
          // Original Input Array
          Text(
            isEng ? '1️⃣ Original Input Array Pointers:' : '১️⃣ মূল ইনপুট অ্যারে ও পয়েন্টারের অবস্থান:',
            style: TextStyle(
              color: AppTheme.accentNeonCyan,
              fontWeight: FontWeight.bold,
              fontSize: Responsive.sp(context, 13.5),
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(orig.length, (idx) {
                final val = orig[idx];
                final isLeft = idx == step.left;
                final isRight = idx == step.right;
                final isPassed = idx < step.left || idx > step.right;

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
                }

                return Opacity(
                  opacity: isPassed ? 0.35 : 1.0,
                  child: Container(
                    margin: EdgeInsets.only(right: isMobile ? 6 : 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 26,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (isLeft && isRight)
                                const Text('L&R',
                                    style: TextStyle(
                                        fontSize: 9,
                                        color: AppTheme.accentAmber,
                                        fontWeight: FontWeight.bold))
                              else if (isLeft)
                                const Text('Left',
                                    style: TextStyle(
                                        fontSize: 9,
                                        color: AppTheme.accentNeonCyan,
                                        fontWeight: FontWeight.bold))
                              else if (isRight)
                                const Text('Right',
                                    style: TextStyle(
                                        fontSize: 9,
                                        color: AppTheme.accentPurple,
                                        fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        Container(
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
                                '$val',
                                style: TextStyle(
                                  fontSize: Responsive.sp(
                                      context, isMobile ? 14 : 16),
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
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 20),

          // Sorted Result Array
          Text(
            isEng
                ? '2️⃣ Output Result Array (Filled Back to Front):'
                : '২️⃣ আউটপুট সর্টেড রেজাল্ট (পেছন থেকে সামনে ভরাট):',
            style: TextStyle(
              color: AppTheme.accentGreen,
              fontWeight: FontWeight.bold,
              fontSize: Responsive.sp(context, 13.5),
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(res.length, (idx) {
                final val = res[idx];
                final isPos = idx == step.pos;
                final isFilled = val != null;

                Color borderColor = isFilled
                    ? AppTheme.accentGreen.withOpacity(0.6)
                    : const Color(0xFF334155);
                Color bgColor = isFilled
                    ? AppTheme.accentGreen.withOpacity(0.15)
                    : AppTheme.primaryDark;

                if (isPos) {
                  borderColor = AppTheme.accentAmber;
                  bgColor = AppTheme.accentAmber.withOpacity(0.2);
                }

                return Container(
                  margin: EdgeInsets.only(right: isMobile ? 6 : 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 26,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (isPos)
                              const Text('Pos',
                                  style: TextStyle(
                                      fontSize: 9,
                                      color: AppTheme.accentAmber,
                                      fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      Container(
                        width: isMobile ? 46 : 54,
                        padding: EdgeInsets.symmetric(
                            vertical: isMobile ? 8 : 10),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: borderColor,
                            width: isPos ? 2.2 : 1.0,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              val != null ? '$val' : '?',
                              style: TextStyle(
                                fontSize: Responsive.sp(
                                    context, isMobile ? 14 : 16),
                                fontWeight: FontWeight.bold,
                                color: isFilled
                                    ? AppTheme.accentGreen
                                    : AppTheme.textMuted,
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
      SquaresCodeFreeStep step, bool isEng, bool isMobile) {
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
