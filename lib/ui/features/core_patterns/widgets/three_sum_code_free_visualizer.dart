import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class ThreeSumCodeFreeStep {
  final int i;
  final int left;
  final int right;
  final List<int> sortedArray;
  final List<List<int>> tripletsFound;
  final String statusType; // 'init', 'found', 'too_small', 'too_large', 'skip_i', 'finish'
  final String titleEn;
  final String titleBn;
  final String descriptionEn;
  final String descriptionBn;
  final String visualTipEn;
  final String visualTipBn;
  final int currentSum;

  const ThreeSumCodeFreeStep({
    required this.i,
    required this.left,
    required this.right,
    required this.sortedArray,
    required this.tripletsFound,
    required this.statusType,
    required this.titleEn,
    required this.titleBn,
    required this.descriptionEn,
    required this.descriptionBn,
    required this.visualTipEn,
    required this.visualTipBn,
    required this.currentSum,
  });
}

class ThreeSumCodeFreeVisualizer extends StatefulWidget {
  final bool isEnglish;

  const ThreeSumCodeFreeVisualizer({
    super.key,
    required this.isEnglish,
  });

  @override
  State<ThreeSumCodeFreeVisualizer> createState() =>
      _ThreeSumCodeFreeVisualizerState();
}

class _ThreeSumCodeFreeVisualizerState
    extends State<ThreeSumCodeFreeVisualizer> {
  List<int> _rawInput = [-1, 0, 1, 2, -1, -4];
  List<ThreeSumCodeFreeStep> _steps = [];
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  // Presets
  final List<Map<String, dynamic>> _presets = [
    {
      'label': '[-1, 0, 1, 2, -1, -4]',
      'array': [-1, 0, 1, 2, -1, -4],
    },
    {
      'label': '[-2, 0, 0, 2, 2]',
      'array': [-2, 0, 0, 2, 2],
    },
    {
      'label': '[0, 0, 0]',
      'array': [0, 0, 0],
    },
    {
      'label': '[0, 1, 1]',
      'array': [0, 1, 1],
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
      _rawInput = List.from(arr);
      _currentStepIndex = 0;
      _generateCodeFreeSteps();
    });
  }

  void _generateCodeFreeSteps() {
    List<ThreeSumCodeFreeStep> steps = [];
    List<int> nums = List.from(_rawInput);
    nums.sort(); // Sorting array is mandatory for 3Sum

    int n = nums.length;
    List<List<int>> triplets = [];

    // Initial setup step
    steps.add(ThreeSumCodeFreeStep(
      i: 0,
      left: 1 < n ? 1 : 0,
      right: n > 0 ? n - 1 : 0,
      sortedArray: List.from(nums),
      tripletsFound: [],
      statusType: 'init',
      titleEn: "Step 1: Sort Array Ascending & Set Outer Loop i = 0",
      titleBn: "ধাপ ১: অ্যারে ছোট থেকে বড় সর্ট করুন ও আউটার লুপ i = 0 পয়েন্ট করুন",
      descriptionEn:
          "Sorted array: [${nums.join(', ')}]. Fixed pointer i starts at index 0 (${nums.isNotEmpty ? nums[0] : 0}). inner pointers left = 1, right = ${n - 1}.",
      descriptionBn:
          "সর্টেড অ্যারে: [${nums.join(', ')}]। ফিক্সড পয়েন্টার i শুরুতেই (ইনডেক্স 0), ইনস্পেকশন পয়েন্টার left = 1, right = ${n - 1}।",
      visualTipEn: "Sorting transforms 3Sum into N Two Sum II subproblems!",
      visualTipBn: "অ্যারে সর্ট করলে ৩-সাম প্রবলেমটি এন-সংখ্যক টু-সাম সাব-প্রবলেমে রূপান্তরিত হয়!",
      currentSum: n >= 3 ? nums[0] + nums[1] + nums[n - 1] : 0,
    ));

    int stepNum = 2;

    for (int i = 0; i < n - 2; i++) {
      // Optimization: if nums[i] > 0, breaking loop since sum cannot be 0
      if (nums[i] > 0) break;

      // Duplicate check for i
      if (i > 0 && nums[i] == nums[i - 1]) {
        steps.add(ThreeSumCodeFreeStep(
          i: i,
          left: i + 1,
          right: n - 1,
          sortedArray: List.from(nums),
          tripletsFound: List.from(triplets),
          statusType: 'skip_i',
          titleEn: "Step $stepNum: Skip Duplicate Outer Element nums[$i] (${nums[i]})",
          titleBn: "ধাপ $stepNum: ডুপ্লিকেট আউটার উপাদান nums[$i] (${nums[i]}) স্কিপ করা হলো",
          descriptionEn:
              "nums[$i] == nums[${i - 1}] (${nums[i]}). Skip i to avoid duplicate triplet solutions.",
          descriptionBn:
              "nums[$i] এবং আগের nums[${i - 1}] একই (${nums[i]})! ডুপ্লিকেট সমাধান এড়াতে i++ করা হলো।",
          visualTipEn: "Duplicate elements are skipped to guarantee unique triplet outputs.",
          visualTipBn: "ইউনিক ফলাফল নিশ্চিত করতে ডুপ্লিকেট মান স্কিপ করা হয়।",
          currentSum: 0,
        ));
        continue;
      }

      int left = i + 1;
      int right = n - 1;

      while (left < right) {
        int sum = nums[i] + nums[left] + nums[right];

        if (sum == 0) {
          triplets.add([nums[i], nums[left], nums[right]]);
          steps.add(ThreeSumCodeFreeStep(
            i: i,
            left: left,
            right: right,
            sortedArray: List.from(nums),
            tripletsFound: List.from(triplets),
            statusType: 'found',
            titleEn: "Step $stepNum: 🎉 Triplet Found! (${nums[i]} + ${nums[left]} + ${nums[right]} = 0)",
            titleBn: "ধাপ $stepNum: 🎉 ট্রিপলেট পাওয়া গেছে! (${nums[i]} + ${nums[left]} + ${nums[right]} = 0)",
            descriptionEn:
                "Sum equals 0! Triplet [${nums[i]}, ${nums[left]}, ${nums[right]}] added to result set.",
            descriptionBn:
                "যোগফল ০ এর সমান! [${nums[i]}, ${nums[left]}, ${nums[right]}] ট্রিপলেটটি রেজাল্টে যোগ করা হলো।",
            visualTipEn: "Valid triplet collected! Skip inner duplicates & shrink window.",
            visualTipBn: "সঠিক ট্রিপলেট সংগৃহীত! ডুপ্লিকেট এড়াতে উভয় পয়েন্টার সরান।",
            currentSum: sum,
          ));

          // Skip inner duplicates
          while (left < right && nums[left] == nums[left + 1]) left++;
          while (left < right && nums[right] == nums[right - 1]) right--;

          left++;
          right--;
        } else if (sum < 0) {
          steps.add(ThreeSumCodeFreeStep(
            i: i,
            left: left,
            right: right,
            sortedArray: List.from(nums),
            tripletsFound: List.from(triplets),
            statusType: 'too_small',
            titleEn: "Step $stepNum: Sum ($sum) < 0 (Too Small)",
            titleBn: "ধাপ $stepNum: যোগফল ($sum) < 0 (খুব ছোট)",
            descriptionEn:
                "(${nums[i]}) + (${nums[left]}) + (${nums[right]}) = $sum. Move left pointer rightward (left++) to increase sum.",
            descriptionBn:
                "যোগফল $sum খুব ছোট! যোগফল বাড়াতে left পয়েন্টার ডানে ১ সরাতে হবে।",
            visualTipEn: "Sum is too negative → Move left pointer rightward to get larger value.",
            visualTipBn: "যোগফল ছোট হওয়ায় left পয়েন্টার ডানে সরিয়ে মান বাড়ানো হলো।",
            currentSum: sum,
          ));
          left++;
        } else {
          steps.add(ThreeSumCodeFreeStep(
            i: i,
            left: left,
            right: right,
            sortedArray: List.from(nums),
            tripletsFound: List.from(triplets),
            statusType: 'too_large',
            titleEn: "Step $stepNum: Sum ($sum) > 0 (Too Large)",
            titleBn: "ধাপ $stepNum: যোগফল ($sum) > 0 (খুব বড়)",
            descriptionEn:
                "(${nums[i]}) + (${nums[left]}) + (${nums[right]}) = $sum. Move right pointer leftward (right--) to decrease sum.",
            descriptionBn:
                "যোগফল $sum খুব বড়! যোগফল কমাতে right পয়েন্টার বামে ১ সরাতে হবে।",
            visualTipEn: "Sum is too positive → Move right pointer leftward to get smaller value.",
            visualTipBn: "যোগফল বড় হওয়ায় right পয়েন্টার বামে সরিয়ে মান কমানো হলো।",
            currentSum: sum,
          ));
          right--;
        }
        stepNum++;
      }
    }

    // Finish step
    steps.add(ThreeSumCodeFreeStep(
      i: n - 1,
      left: n - 1,
      right: n - 1,
      sortedArray: List.from(nums),
      tripletsFound: List.from(triplets),
      statusType: 'finish',
      titleEn: "🎉 3SUM SEARCH COMPLETE!",
      titleBn: "🎉 ৩-সাম সার্চ সম্পূর্ণ!",
      descriptionEn:
          "Total unique triplets found: ${triplets.length} ${triplets.map((t) => '[${t.join(', ')}]').toList()}",
      descriptionBn:
          "সর্বমোট পাওয়া ইউনিক ট্রিপলেটসমূহ: ${triplets.length} টি ${triplets.map((t) => '[${t.join(', ')}]').toList()}",
      visualTipEn: "✨ Completed in O(N²) time using Two Pointers on sorted array!",
      visualTipBn: "✨ সর্টেড অ্যারেতে টু-পয়েন্টার দিয়ে O(N²) সময়ের মধ্যে সম্পূর্ণ!",
      currentSum: 0,
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
        ? ThreeSumCodeFreeStep(
            i: 0,
            left: 0,
            right: 0,
            sortedArray: _rawInput,
            tripletsFound: [],
            statusType: 'init',
            titleEn: '',
            titleBn: '',
            descriptionEn: '',
            descriptionBn: '',
            visualTipEn: '',
            visualTipBn: '',
            currentSum: 0,
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
                                ? '3Sum Visual Intuition'
                                : '৩-সাম ভিজ্যুয়াল অ্যানিমেশন',
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
                            ? 'Watch how outer loop i combines with inner left/right pointers to find all zero-sum triplets in O(N²) time!'
                            : 'কোনো কোড ছাড়াই দেখুন কীভাবে আউটার লুপ i এবং টু-পয়েন্টার পয়েন্টার দিয়ে সকল ০-যোগফলের ট্রিপলেট খুঁজে বের করা হয়!',
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
                    _rawInput.first == (preset['array'] as List).first;
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

          // 3. Dynamic Sum Gauge
          _buildSumGauge(step, isEng, isMobile),
          const SizedBox(height: 20),

          // 4. Sorted Array Pointer Visualizer
          _buildArrayPointerGraphic(step, isEng, isMobile),
          const SizedBox(height: 20),

          // 5. Triplets Result Collection Box
          _buildTripletsCollectionBox(step, isEng, isMobile),
          const SizedBox(height: 20),

          // 6. Playback Controls
          _buildPlaybackControls(isEng, isMobile),
          const SizedBox(height: 20),

          // 7. Intuition Explanation Card
          _buildIntuitionExplanationCard(step, isEng, isMobile),
        ],
      ),
    );
  }

  /// Visual Sum Gauge
  Widget _buildSumGauge(
      ThreeSumCodeFreeStep step, bool isEng, bool isMobile) {
    Color statusColor;
    IconData statusIcon;

    switch (step.statusType) {
      case 'finish':
        statusColor = AppTheme.accentGreen;
        statusIcon = Icons.check_circle_rounded;
        break;
      case 'found':
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
      case 'skip_i':
        statusColor = AppTheme.accentPurple;
        statusIcon = Icons.redo_rounded;
        break;
      default:
        statusColor = AppTheme.accentNeonCyan;
        statusIcon = Icons.explore_rounded;
    }

    final arr = step.sortedArray;
    final valI = step.i < arr.length ? arr[step.i] : 0;
    final valL = step.left < arr.length ? arr[step.left] : 0;
    final valR = step.right < arr.length ? arr[step.right] : 0;

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

          // Sum Equation Display
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
                  _buildTermBubble("nums[i]", "$valI", AppTheme.accentNeonCyan, isMobile),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Text("+", style: TextStyle(color: Colors.white, fontSize: Responsive.sp(context, 16), fontWeight: FontWeight.bold)),
                  ),
                  _buildTermBubble("nums[left]", "$valL", AppTheme.accentPurple, isMobile),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Text("+", style: TextStyle(color: Colors.white, fontSize: Responsive.sp(context, 16), fontWeight: FontWeight.bold)),
                  ),
                  _buildTermBubble("nums[right]", "$valR", AppTheme.accentAmber, isMobile),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text("=", style: TextStyle(color: statusColor, fontSize: Responsive.sp(context, 18), fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 14 : 18,
                      vertical: isMobile ? 8 : 12,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: statusColor, width: 2),
                    ),
                    child: Text(
                      "${step.currentSum}",
                      style: TextStyle(
                        fontSize: Responsive.sp(context, isMobile ? 18 : 22),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermBubble(String label, String val, Color color, bool isMobile) {
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
              fontSize: Responsive.sp(context, isMobile ? 14 : 16),
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
      ThreeSumCodeFreeStep step, bool isEng, bool isMobile) {
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
                  "N = ${arr.length}",
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

  /// Triplets Collection Box
  Widget _buildTripletsCollectionBox(
      ThreeSumCodeFreeStep step, bool isEng, bool isMobile) {
    final triplets = step.tripletsFound;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Responsive.sp(context, isMobile ? 12 : 16)),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.accentGreen.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isEng ? '🏆 Triplets Collected So Far:' : '🏆 সংগৃহীত ট্রিপলেটসমূহ:',
                style: TextStyle(
                  color: AppTheme.accentGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: Responsive.sp(context, 13.5),
                ),
              ),
              Text(
                "Count: ${triplets.length}",
                style: TextStyle(
                    color: AppTheme.accentGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: Responsive.sp(context, 12)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (triplets.isEmpty)
            Text(
              isEng ? "No triplets found yet..." : "এখনো কোনো ট্রিপলেট পাওয়া যায়নি...",
              style: TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: Responsive.sp(context, 12)),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: triplets.map((t) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.accentGreen.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.accentGreen),
                  ),
                  child: Text(
                    "[${t.join(', ')}]",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.bold,
                      fontSize: Responsive.sp(context, 12.5),
                    ),
                  ),
                );
              }).toList(),
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
      ThreeSumCodeFreeStep step, bool isEng, bool isMobile) {
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
