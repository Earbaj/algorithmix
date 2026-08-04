import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class ThreeSumClosestCodeFreeStep {
  final int i;
  final int left;
  final int right;
  final int target;
  final List<int> sortedArray;
  final int currentSum;
  final int closestSum;
  final String statusType; // 'init', 'updated_best', 'too_small', 'too_large', 'exact_match', 'finish'
  final String titleEn;
  final String titleBn;
  final String descriptionEn;
  final String descriptionBn;
  final String visualTipEn;
  final String visualTipBn;

  const ThreeSumClosestCodeFreeStep({
    required this.i,
    required this.left,
    required this.right,
    required this.target,
    required this.sortedArray,
    required this.currentSum,
    required this.closestSum,
    required this.statusType,
    required this.titleEn,
    required this.titleBn,
    required this.descriptionEn,
    required this.descriptionBn,
    required this.visualTipEn,
    required this.visualTipBn,
  });
}

class ThreeSumClosestCodeFreeVisualizer extends StatefulWidget {
  final bool isEnglish;

  const ThreeSumClosestCodeFreeVisualizer({
    super.key,
    required this.isEnglish,
  });

  @override
  State<ThreeSumClosestCodeFreeVisualizer> createState() =>
      _ThreeSumClosestCodeFreeVisualizerState();
}

class _ThreeSumClosestCodeFreeVisualizerState
    extends State<ThreeSumClosestCodeFreeVisualizer> {
  List<int> _rawInput = [-1, 2, 1, -4];
  int _target = 1;

  List<ThreeSumClosestCodeFreeStep> _steps = [];
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  // Presets
  final List<Map<String, dynamic>> _presets = [
    {
      'label': '[-1, 2, 1, -4], target = 1',
      'array': [-1, 2, 1, -4],
      'target': 1,
    },
    {
      'label': '[0, 0, 0], target = 1',
      'array': [0, 0, 0],
      'target': 1,
    },
    {
      'label': '[1, 1, 1, 0], target = -100',
      'array': [1, 1, 1, 0],
      'target': -100,
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

  void _loadPreset(List<int> arr, int target) {
    _timer?.cancel();
    setState(() {
      _isPlaying = false;
      _rawInput = List.from(arr);
      _target = target;
      _currentStepIndex = 0;
      _generateCodeFreeSteps();
    });
  }

  void _generateCodeFreeSteps() {
    List<ThreeSumClosestCodeFreeStep> steps = [];
    List<int> nums = List.from(_rawInput);
    nums.sort();

    int n = nums.length;
    if (n < 3) return;

    int closestSum = nums[0] + nums[1] + nums[2];

    // Initial setup step
    steps.add(ThreeSumClosestCodeFreeStep(
      i: 0,
      left: 1,
      right: n - 1,
      target: _target,
      sortedArray: List.from(nums),
      currentSum: nums[0] + nums[1] + nums[n - 1],
      closestSum: closestSum,
      statusType: 'init',
      titleEn: "Step 1: Sort Array & Init Best Closest Sum = $closestSum",
      titleBn: "ধাপ ১: অ্যারে সর্ট করুন ও সেরা নিকটতম যোগফল $closestSum সূচনা করুন",
      descriptionEn:
          "Sorted array: [${nums.join(', ')}]. Target = $_target. Initial closest sum = $closestSum (diff = ${(closestSum - _target).abs()}).",
      descriptionBn:
          "সর্টেড অ্যারে: [${nums.join(', ')}]। টার্গেট = $_target। প্রাথমিক নিকটতম যোগফল = $closestSum।",
      visualTipEn: "Track min difference |sum - target| across all triplet combinations!",
      visualTipBn: "সকল ট্রিপলেটের জন্য সর্বনিম্ন পার্থক্য |sum - target| ট্র্যাকিং নিশ্চিত করুন!",
    ));

    int stepNum = 2;

    for (int i = 0; i < n - 2; i++) {
      int left = i + 1;
      int right = n - 1;

      while (left < right) {
        int sum = nums[i] + nums[left] + nums[right];

        bool isBetter = (sum - _target).abs() < (closestSum - _target).abs();
        if (isBetter) {
          closestSum = sum;
          steps.add(ThreeSumClosestCodeFreeStep(
            i: i,
            left: left,
            right: right,
            target: _target,
            sortedArray: List.from(nums),
            currentSum: sum,
            closestSum: closestSum,
            statusType: 'updated_best',
            titleEn: "Step $stepNum: 🎉 New Best Closest Sum Found! ($sum)",
            titleBn: "ধাপ $stepNum: 🎉 নতুন সেরা নিকটতম যোগফল পাওয়া গেছে! ($sum)",
            descriptionEn:
                "|($sum) - ($_target)| = ${(sum - _target).abs()} is closer to target than previous best! Updated closest sum to $sum.",
            descriptionBn:
                "|($sum) - ($_target)| = ${(sum - _target).abs()} আগের চেয়ে টার্গেটের কাছে! নিকটতম যোগফল $sum এ আপডেট করা হলো।",
            visualTipEn: "New minimum difference recorded!",
            visualTipBn: "নতুন সর্বনিম্ন পার্থক্য সংগৃহীত হলো!",
          ));
        }

        if (sum == _target) {
          steps.add(ThreeSumClosestCodeFreeStep(
            i: i,
            left: left,
            right: right,
            target: _target,
            sortedArray: List.from(nums),
            currentSum: sum,
            closestSum: closestSum,
            statusType: 'exact_match',
            titleEn: "Step $stepNum: Exact Match Found! Sum == Target ($_target)",
            titleBn: "ধাপ $stepNum: নিখুঁত মিল! যোগফল == টার্গেট ($_target)",
            descriptionEn:
                "Sum equals target $_target exactly (diff = 0). Return $_target immediately!",
            descriptionBn:
                "যোগফল পুরোপুরি টার্গেট $_target এর সমান! সাথে সাথে $_target রিটার্ন করা যাবে।",
            visualTipEn: "Diff is 0! Best possible result achieved.",
            visualTipBn: "পার্থক্য ০! সেরা উত্তর পাওয়া গেছে।",
          ));
          _steps = steps;
          return;
        } else if (sum < _target) {
          if (!isBetter) {
            steps.add(ThreeSumClosestCodeFreeStep(
              i: i,
              left: left,
              right: right,
              target: _target,
              sortedArray: List.from(nums),
              currentSum: sum,
              closestSum: closestSum,
              statusType: 'too_small',
              titleEn: "Step $stepNum: Sum ($sum) < Target ($_target)",
              titleBn: "ধাপ $stepNum: যোগফল ($sum) < টার্গেট ($_target)",
              descriptionEn:
                  "Sum $sum is smaller than target $_target. Move left pointer rightward (left++) to get a larger sum.",
              descriptionBn:
                  "যোগফল $sum টার্গেটের চেয়ে ছোট। যোগফল বাড়াতে left পয়েন্টার ডানে সরাতে হবে।",
              visualTipEn: "Move left pointer rightward to increase sum towards target.",
              visualTipBn: "যোগফল বড় করতে left পয়েন্টার ডানে সরান।",
            ));
          }
          left++;
        } else {
          if (!isBetter) {
            steps.add(ThreeSumClosestCodeFreeStep(
              i: i,
              left: left,
              right: right,
              target: _target,
              sortedArray: List.from(nums),
              currentSum: sum,
              closestSum: closestSum,
              statusType: 'too_large',
              titleEn: "Step $stepNum: Sum ($sum) > Target ($_target)",
              titleBn: "ধাপ $stepNum: যোগফল ($sum) > টার্গেট ($_target)",
              descriptionEn:
                  "Sum $sum is larger than target $_target. Move right pointer leftward (right--) to get a smaller sum.",
              descriptionBn:
                  "যোগফল $sum টার্গেটের চেয়ে বড়। যোগফল কমাতে right পয়েন্টার বামে সরাতে হবে।",
              visualTipEn: "Move right pointer leftward to decrease sum towards target.",
              visualTipBn: "যোগফল ছোট করতে right পয়েন্টার বামে সরান।",
            ));
          }
          right--;
        }
        stepNum++;
      }
    }

    // Finish step
    steps.add(ThreeSumClosestCodeFreeStep(
      i: n - 1,
      left: n - 1,
      right: n - 1,
      target: _target,
      sortedArray: List.from(nums),
      currentSum: closestSum,
      closestSum: closestSum,
      statusType: 'finish',
      titleEn: "🎉 SEARCH COMPLETE! Closest Sum = $closestSum",
      titleBn: "🎉 সার্চ সম্পূর্ণ! নিকটতম যোগফল = $closestSum",
      descriptionEn:
          "Result: $closestSum (Difference to target $_target: ${(closestSum - _target).abs()}).",
      descriptionBn:
          "ফলাফল: $closestSum (টার্গেট $_target থেকে পার্থক্য: ${(closestSum - _target).abs()})।",
      visualTipEn: "✨ Completed in O(N²) time!",
      visualTipBn: "✨ O(N²) সময়ের মধ্যে সম্পূর্ণ!",
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
        ? ThreeSumClosestCodeFreeStep(
            i: 0,
            left: 0,
            right: 0,
            target: _target,
            sortedArray: _rawInput,
            currentSum: 0,
            closestSum: 0,
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
                                ? '3Sum Closest Visual Intuition'
                                : '৩-সাম ক্লোজেস্ট ভিজ্যুয়াল অ্যানিমেশন',
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
                            ? 'Watch how Two Pointers optimize the triplet sum to get as close as possible to the target!'
                            : 'কোনো কোড ছাড়াই দেখুন কীভাবে টু-পয়েন্টার দিয়ে টার্গেটের সবচেয়ে কাছাকাছি যোগফল বের করা হয়!',
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
                final isSelected = _rawInput.length ==
                        (preset['array'] as List).length &&
                    _target == preset['target'];
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
                        _loadPreset(List<int>.from(preset['array']), preset['target']);
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),

          // 3. Dynamic Sum & Closest Comparison Gauge
          _buildStatusGauge(step, isEng, isMobile),
          const SizedBox(height: 20),

          // 4. Sorted Array Pointer Visualizer
          _buildArrayPointerGraphic(step, isEng, isMobile),
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
      ThreeSumClosestCodeFreeStep step, bool isEng, bool isMobile) {
    Color statusColor;
    IconData statusIcon;

    switch (step.statusType) {
      case 'finish':
      case 'exact_match':
        statusColor = AppTheme.accentGreen;
        statusIcon = Icons.check_circle_rounded;
        break;
      case 'updated_best':
        statusColor = AppTheme.accentGreen;
        statusIcon = Icons.stars_rounded;
        break;
      case 'too_small':
        statusColor = AppTheme.accentNeonCyan;
        statusIcon = Icons.arrow_upward_rounded;
        break;
      case 'too_large':
        statusColor = AppTheme.accentAmber;
        statusIcon = Icons.arrow_downward_rounded;
        break;
      default:
        statusColor = AppTheme.accentNeonCyan;
        statusIcon = Icons.explore_rounded;
    }

    final diffCurrent = (step.currentSum - step.target).abs();
    final diffBest = (step.closestSum - step.target).abs();

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

          // Difference Bubble Display
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
                  _buildStatBubble(
                    label: "Target",
                    val: "${step.target}",
                    color: AppTheme.accentNeonCyan,
                    isMobile: isMobile,
                  ),
                  const SizedBox(width: 12),
                  _buildStatBubble(
                    label: "Current Sum",
                    val: "${step.currentSum} (diff: $diffCurrent)",
                    color: AppTheme.accentPurple,
                    isMobile: isMobile,
                  ),
                  const SizedBox(width: 12),
                  _buildStatBubble(
                    label: "Best Closest Sum",
                    val: "${step.closestSum} (diff: $diffBest)",
                    color: AppTheme.accentGreen,
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

  Widget _buildStatBubble({
    required String label,
    required String val,
    required Color color,
    required bool isMobile,
  }) {
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

  /// Graphic showing Sorted Array with 3 Pointers
  Widget _buildArrayPointerGraphic(
      ThreeSumClosestCodeFreeStep step, bool isEng, bool isMobile) {
    final arr = step.sortedArray;

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
                isEng ? 'Sorted Array Pointers (i, left, right):' : 'সর্টেড অ্যারে ও ৩টি পয়েন্টারের অবস্থান:',
                style: TextStyle(
                  color: AppTheme.accentNeonCyan,
                  fontWeight: FontWeight.bold,
                  fontSize: Responsive.sp(context, 13.5),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.accentNeonCyan.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "Target: ${step.target}",
                  style: TextStyle(
                      color: AppTheme.accentNeonCyan,
                      fontWeight: FontWeight.bold,
                      fontSize: Responsive.sp(context, 11)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(arr.length, (idx) {
                final val = arr[idx];
                final isI = idx == step.i;
                final isLeft = idx == step.left;
                final isRight = idx == step.right;

                Color borderColor = const Color(0xFF334155);
                Color bgColor = AppTheme.primaryDark;

                if (isI && isLeft) {
                  borderColor = AppTheme.accentPurple;
                  bgColor = AppTheme.accentPurple.withOpacity(0.3);
                } else if (isI) {
                  borderColor = AppTheme.accentNeonCyan;
                  bgColor = AppTheme.accentNeonCyan.withOpacity(0.25);
                } else if (isLeft) {
                  borderColor = AppTheme.accentPurple;
                  bgColor = AppTheme.accentPurple.withOpacity(0.25);
                } else if (isRight) {
                  borderColor = AppTheme.accentAmber;
                  bgColor = AppTheme.accentAmber.withOpacity(0.25);
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
                            if (isI && isLeft)
                              const Text('i&L',
                                  style: TextStyle(
                                      fontSize: 9,
                                      color: AppTheme.accentPurple,
                                      fontWeight: FontWeight.bold))
                            else if (isI)
                              const Text('i',
                                  style: TextStyle(
                                      fontSize: 9.5,
                                      color: AppTheme.accentNeonCyan,
                                      fontWeight: FontWeight.bold))
                            else if (isLeft)
                              const Text('Left',
                                  style: TextStyle(
                                      fontSize: 9,
                                      color: AppTheme.accentPurple,
                                      fontWeight: FontWeight.bold))
                            else if (isRight)
                              const Text('Right',
                                  style: TextStyle(
                                      fontSize: 9,
                                      color: AppTheme.accentAmber,
                                      fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      Container(
                        width: isMobile ? 44 : 52,
                        padding: EdgeInsets.symmetric(
                            vertical: isMobile ? 8 : 10),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: borderColor,
                            width: (isI || isLeft || isRight) ? 2.2 : 1.0,
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
      ThreeSumClosestCodeFreeStep step, bool isEng, bool isMobile) {
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
