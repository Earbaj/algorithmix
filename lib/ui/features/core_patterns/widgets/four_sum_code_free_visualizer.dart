import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class FourSumCodeFreeStep {
  final int i;
  final int j;
  final int left;
  final int right;
  final int target;
  final List<int> sortedArray;
  final int currentSum;
  final List<List<int>> collectedQuads;
  final String statusType; // 'init', 'quad_found', 'too_small', 'too_large', 'skip_dup', 'finish'
  final String titleEn;
  final String titleBn;
  final String descriptionEn;
  final String descriptionBn;
  final String visualTipEn;
  final String visualTipBn;

  const FourSumCodeFreeStep({
    required this.i,
    required this.j,
    required this.left,
    required this.right,
    required this.target,
    required this.sortedArray,
    required this.currentSum,
    required this.collectedQuads,
    required this.statusType,
    required this.titleEn,
    required this.titleBn,
    required this.descriptionEn,
    required this.descriptionBn,
    required this.visualTipEn,
    required this.visualTipBn,
  });
}

class FourSumCodeFreeVisualizer extends StatefulWidget {
  final bool isEnglish;

  const FourSumCodeFreeVisualizer({
    super.key,
    required this.isEnglish,
  });

  @override
  State<FourSumCodeFreeVisualizer> createState() =>
      _FourSumCodeFreeVisualizerState();
}

class _FourSumCodeFreeVisualizerState
    extends State<FourSumCodeFreeVisualizer> {
  List<int> _rawInput = [1, 0, -1, 0, -2, 2];
  int _target = 0;

  List<FourSumCodeFreeStep> _steps = [];
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  // Presets
  final List<Map<String, dynamic>> _presets = [
    {
      'label': '[1, 0, -1, 0, -2, 2], target = 0',
      'array': [1, 0, -1, 0, -2, 2],
      'target': 0,
    },
    {
      'label': '[2, 2, 2, 2, 2], target = 8',
      'array': [2, 2, 2, 2, 2],
      'target': 8,
    },
    {
      'label': '[-3, -1, 0, 2, 4, 5], target = 1',
      'array': [-3, -1, 0, 2, 4, 5],
      'target': 1,
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
    List<FourSumCodeFreeStep> steps = [];
    List<int> nums = List.from(_rawInput);
    nums.sort();

    int n = nums.length;
    if (n < 4) return;

    List<List<int>> collected = [];

    // Initial setup step
    steps.add(FourSumCodeFreeStep(
      i: 0,
      j: 1,
      left: 2,
      right: n - 1,
      target: _target,
      sortedArray: List.from(nums),
      currentSum: nums[0] + nums[1] + nums[2] + nums[n - 1],
      collectedQuads: [],
      statusType: 'init',
      titleEn: "Step 1: Sort Array & Init 4 Pointers (i=0, j=1, left=2, right=${n - 1})",
      titleBn: "ধাপ ১: সর্ট করুন ও ৪টি পয়েন্টার বসান (i=0, j=1, left=2, right=${n - 1})",
      descriptionEn:
          "Sorted array: [${nums.join(', ')}]. Target = $_target. We use 2 outer loops (i, j) and 2 inner pointers (left, right).",
      descriptionBn:
          "সর্টেড অ্যারে: [${nums.join(', ')}]। টার্গেট = $_target। দুটি আউটার লুপ (i, j) এবং দুটি ইনার পয়েন্টার (left, right) ব্যবহৃত হচ্ছে।",
      visualTipEn: "4Sum reduces to 2Sum by fixing two elements (nums[i] and nums[j])!",
      visualTipBn: "4Sum সমস্যাটি i এবং j নির্দিষ্ট করে ২Sum সমস্যায় রূপান্তর করা হয়!",
    ));

    int stepNum = 2;

    for (int i = 0; i < n - 3; i++) {
      if (i > 0 && nums[i] == nums[i - 1]) continue;

      for (int j = i + 1; j < n - 2; j++) {
        if (j > i + 1 && nums[j] == nums[j - 1]) continue;

        int left = j + 1;
        int right = n - 1;

        while (left < right) {
          int sum = nums[i] + nums[j] + nums[left] + nums[right];

          if (sum == _target) {
            List<int> quad = [nums[i], nums[j], nums[left], nums[right]];
            collected.add(List.from(quad));

            steps.add(FourSumCodeFreeStep(
              i: i,
              j: j,
              left: left,
              right: right,
              target: _target,
              sortedArray: List.from(nums),
              currentSum: sum,
              collectedQuads: List.from(collected),
              statusType: 'quad_found',
              titleEn: "Step $stepNum: 🎉 Unique Quadruplet Found! [${quad.join(', ')}]",
              titleBn: "ধাপ $stepNum: 🎉 নতুন ট্রিপলেট পাওয়া গেছে! [${quad.join(', ')}]",
              descriptionEn:
                  "${nums[i]} + ${nums[j]} + ${nums[left]} + ${nums[right]} = $_target. Added [${quad.join(', ')}] to result list!",
              descriptionBn:
                  "${nums[i]} + ${nums[j]} + ${nums[left]} + ${nums[right]} = $_target। [${quad.join(', ')}] ফলাফল তালিকায় যুক্ত হলো!",
              visualTipEn: "Quadruplet sum matches target exactly!",
              visualTipBn: "৪টি সংখ্যার যোগফল টার্গেটের সাথে নিখুঁত মিলে গেছে!",
            ));

            while (left < right && nums[left] == nums[left + 1]) left++;
            while (left < right && nums[right] == nums[right - 1]) right--;

            left++;
            right--;
          } else if (sum < _target) {
            steps.add(FourSumCodeFreeStep(
              i: i,
              j: j,
              left: left,
              right: right,
              target: _target,
              sortedArray: List.from(nums),
              currentSum: sum,
              collectedQuads: List.from(collected),
              statusType: 'too_small',
              titleEn: "Step $stepNum: Sum ($sum) < Target ($_target) → Move left++",
              titleBn: "ধাপ $stepNum: যোগফল ($sum) < টার্গেট ($_target) → left++ করুন",
              descriptionEn:
                  "Sum $sum is smaller than target $_target. Move left pointer rightward (left++) to get a larger sum.",
              descriptionBn:
                  "যোগফল $sum টার্গেটের চেয়ে ছোট। যোগফল বাড়াতে left পয়েন্টার ডানে সরাতে হবে।",
              visualTipEn: "Move left pointer rightward to increase total sum.",
              visualTipBn: "যোগফল বড় করতে left পয়েন্টার ডানে সরান।",
            ));
            left++;
          } else {
            steps.add(FourSumCodeFreeStep(
              i: i,
              j: j,
              left: left,
              right: right,
              target: _target,
              sortedArray: List.from(nums),
              currentSum: sum,
              collectedQuads: List.from(collected),
              statusType: 'too_large',
              titleEn: "Step $stepNum: Sum ($sum) > Target ($_target) → Move right--",
              titleBn: "ধাপ $stepNum: যোগফল ($sum) > টার্গেট ($_target) → right-- করুন",
              descriptionEn:
                  "Sum $sum is larger than target $_target. Move right pointer leftward (right--) to get a smaller sum.",
              descriptionBn:
                  "যোগফল $sum টার্গেটের চেয়ে বড়। যোগফল কমাতে right পয়েন্টার বামে সরাতে হবে।",
              visualTipEn: "Move right pointer leftward to decrease total sum.",
              visualTipBn: "যোগফল ছোট করতে right পয়েন্টার বামে সরান।",
            ));
            right--;
          }
          stepNum++;
        }
      }
    }

    // Finish step
    steps.add(FourSumCodeFreeStep(
      i: n - 1,
      j: n - 1,
      left: n - 1,
      right: n - 1,
      target: _target,
      sortedArray: List.from(nums),
      currentSum: _target,
      collectedQuads: List.from(collected),
      statusType: 'finish',
      titleEn: "🎉 SEARCH COMPLETE! Total Unique Quadruplets = ${collected.length}",
      titleBn: "🎉 সার্চ সম্পূর্ণ! সর্বমোট ইউনিক কুয়াড্রুপলেট = ${collected.length}",
      descriptionEn:
          "Found ${collected.length} unique quadruplets matching target $_target: ${collected.map((e) => '[${e.join(', ')}]').join(', ')}.",
      descriptionBn:
          "টার্গেট $_target এর জন্য ${collected.length} টি ইউনিক কুয়াড্রুপলেট পাওয়া গেছে!",
      visualTipEn: "✨ Completed in O(N³) cubic time complexity!",
      visualTipBn: "✨ O(N³) সময়ের মধ্যে সম্পূর্ণ!",
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
        ? FourSumCodeFreeStep(
            i: 0,
            j: 1,
            left: 2,
            right: _rawInput.length - 1,
            target: _target,
            sortedArray: _rawInput,
            currentSum: 0,
            collectedQuads: [],
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
                                ? '4Sum (4 Pointers) Intuition'
                                : '৪-সাম (৪টি পয়েন্টার) ভিজ্যুয়াল অ্যানিমেশন',
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
                            ? 'Watch how 4 Pointers (i, j, left, right) systematically find all unique quadruplets summing to target!'
                            : 'কোনো কোড ছাড়াই দেখুন কীভাবে ৪টি পয়েন্টার দিয়ে টার্গেট যোগফলের সকল ইউনিক কুয়াড্রুপলেট খুঁজে বের করা হয়!',
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

          // 3. Dynamic Sum & Collected Quadruplets Status Gauge
          _buildStatusGauge(step, isEng, isMobile),
          const SizedBox(height: 20),

          // 4. Sorted Array 4-Pointers Graphic
          _buildFourPointerGraphic(step, isEng, isMobile),
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
      FourSumCodeFreeStep step, bool isEng, bool isMobile) {
    Color statusColor;
    IconData statusIcon;

    switch (step.statusType) {
      case 'finish':
      case 'quad_found':
        statusColor = AppTheme.accentGreen;
        statusIcon = Icons.check_circle_rounded;
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

          // Sum Gauge & Quad List
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
                  _buildStatBubble("Current Sum", "${step.currentSum}", AppTheme.accentPurple, isMobile),
                  const SizedBox(width: 10),
                  _buildStatBubble("Target", "${step.target}", AppTheme.accentNeonCyan, isMobile),
                  const SizedBox(width: 10),
                  _buildStatBubble("Collected Quads", "${step.collectedQuads.length}", AppTheme.accentGreen, isMobile),
                ],
              ),
            ),
          ),
          if (step.collectedQuads.isNotEmpty) ...[
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: step.collectedQuads.map((q) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.accentGreen.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.accentGreen),
                    ),
                    child: Text(
                      "[${q.join(', ')}]",
                      style: TextStyle(
                          color: AppTheme.accentGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: Responsive.sp(context, 11)),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
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

  /// Graphic showing Sorted Array with 4 Pointers (i, j, left, right)
  Widget _buildFourPointerGraphic(
      FourSumCodeFreeStep step, bool isEng, bool isMobile) {
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
                isEng ? 'Sorted Array 4-Pointers (i, j, left, right):' : 'সর্টেড অ্যারে ও ৪টি পয়েন্টারের অবস্থান:',
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
          const SizedBox(height: 14),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(arr.length, (idx) {
                final val = arr[idx];
                final isI = idx == step.i;
                final isJ = idx == step.j;
                final isLeft = idx == step.left;
                final isRight = idx == step.right;

                Color borderColor = const Color(0xFF334155);
                Color bgColor = AppTheme.primaryDark;

                if (isI) {
                  borderColor = AppTheme.accentNeonCyan;
                  bgColor = AppTheme.accentNeonCyan.withOpacity(0.25);
                } else if (isJ) {
                  borderColor = AppTheme.accentPurple;
                  bgColor = AppTheme.accentPurple.withOpacity(0.25);
                } else if (isLeft) {
                  borderColor = AppTheme.accentAmber;
                  bgColor = AppTheme.accentAmber.withOpacity(0.25);
                } else if (isRight) {
                  borderColor = AppTheme.accentPink;
                  bgColor = AppTheme.accentPink.withOpacity(0.25);
                }

                List<String> ptrLabels = [];
                if (isI) ptrLabels.add("i");
                if (isJ) ptrLabels.add("j");
                if (isLeft) ptrLabels.add("Left");
                if (isRight) ptrLabels.add("Right");

                return Container(
                  margin: EdgeInsets.only(right: isMobile ? 6 : 8),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 24,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (ptrLabels.isNotEmpty)
                              Text(
                                ptrLabels.join('&'),
                                style: TextStyle(
                                  fontSize: Responsive.sp(context, 9.5),
                                  color: isI
                                      ? AppTheme.accentNeonCyan
                                      : (isJ
                                          ? AppTheme.accentPurple
                                          : (isLeft
                                              ? AppTheme.accentAmber
                                              : AppTheme.accentPink)),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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
                            width: (isI || isJ || isLeft || isRight) ? 2.2 : 1.0,
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
      FourSumCodeFreeStep step, bool isEng, bool isMobile) {
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
