import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class RemoveDuplicatesIICodeFreeStep {
  final int slow;
  final int fast;
  final List<int> array;
  final String statusType; // 'init', 'write_element', 'skip_duplicate', 'finish'
  final String titleEn;
  final String titleBn;
  final String descriptionEn;
  final String descriptionBn;
  final String visualTipEn;
  final String visualTipBn;

  const RemoveDuplicatesIICodeFreeStep({
    required this.slow,
    required this.fast,
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

class RemoveDuplicatesIICodeFreeVisualizer extends StatefulWidget {
  final bool isEnglish;

  const RemoveDuplicatesIICodeFreeVisualizer({
    super.key,
    required this.isEnglish,
  });

  @override
  State<RemoveDuplicatesIICodeFreeVisualizer> createState() =>
      _RemoveDuplicatesIICodeFreeVisualizerState();
}

class _RemoveDuplicatesIICodeFreeVisualizerState
    extends State<RemoveDuplicatesIICodeFreeVisualizer> {
  List<int> _currentArray = [1, 1, 1, 2, 2, 3];

  List<RemoveDuplicatesIICodeFreeStep> _steps = [];
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  // Presets
  final List<Map<String, dynamic>> _presets = [
    {
      'label': '[1, 1, 1, 2, 2, 3]',
      'array': [1, 1, 1, 2, 2, 3],
    },
    {
      'label': '[0, 0, 1, 1, 1, 1, 2, 3, 3]',
      'array': [0, 0, 1, 1, 1, 1, 2, 3, 3],
    },
    {
      'label': '[1, 1, 1, 1]',
      'array': [1, 1, 1, 1],
    },
    {
      'label': '[1, 2, 3, 4]',
      'array': [1, 2, 3, 4],
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
    List<RemoveDuplicatesIICodeFreeStep> steps = [];
    List<int> nums = List.from(_currentArray);
    int n = nums.length;

    if (n <= 2) {
      steps.add(RemoveDuplicatesIICodeFreeStep(
        slow: n,
        fast: n,
        array: List.from(nums),
        statusType: 'finish',
        titleEn: "Array Length ≤ 2 → Return $n Directly",
        titleBn: "অ্যারের দৈর্ঘ্য ≤ ২ → সরাসরি $n রিটার্ন",
        descriptionEn: "Array has $n elements, which naturally satisfies at most 2 duplicates allowed.",
        descriptionBn: "অ্যারেতে $n টি উপাদান রয়েছে, যা সর্বোচ্চ ২টির শর্ত পূরণ করে।",
        visualTipEn: "Small arrays automatically valid!",
        visualTipBn: "ছোট অ্যারে স্বয়ংক্রিয়ভাবে বৈধ!",
      ));
      _steps = steps;
      return;
    }

    int slow = 2;

    // Initial step
    steps.add(RemoveDuplicatesIICodeFreeStep(
      slow: 2,
      fast: 2,
      array: List.from(nums),
      statusType: 'init',
      titleEn: "Step 1: Keep First 2 Elements & Set slow = 2, fast = 2",
      titleBn: "ধাপ ১: প্রথম ২টি উপাদান ঠিক রেখে slow = ২, fast = ২ পয়েন্টার বসান",
      descriptionEn:
          "First 2 elements [${nums[0]}, ${nums[1]}] are allowed automatically. We inspect nums[fast] starting at index 2.",
      descriptionBn:
          "প্রথম ২টি উপাদান [${nums[0]}, ${nums[1]}] স্বয়ংক্রিয়ভাবে গ্রহণযোগ্য। ইনডেক্স ২ থেকে অনুসন্ধানী পয়েন্টার fast শুরু করা হলো।",
      visualTipEn: "Rule: Element nums[fast] is valid if nums[fast] != nums[slow - 2]!",
      visualTipBn: "নিয়ম: nums[fast] উপাদানটি বৈধ হবে যদি nums[fast] != nums[slow - 2] হয়!",
    ));

    int stepNum = 2;

    for (int fast = 2; fast < n; fast++) {
      int candidate = nums[fast];
      int compareVal = nums[slow - 2];

      if (candidate != compareVal) {
        nums[slow] = candidate;
        steps.add(RemoveDuplicatesIICodeFreeStep(
          slow: slow,
          fast: fast,
          array: List.from(nums),
          statusType: 'write_element',
          titleEn: "Step $stepNum: nums[fast] ($candidate) != nums[slow - 2] ($compareVal) → Write & slow++",
          titleBn: "ধাপ $stepNum: nums[fast] ($candidate) != nums[slow - 2] ($compareVal) → লিখুন ও slow++",
          descriptionEn:
              "Value $candidate has appeared less than twice in modified buffer. Write to nums[$slow] = $candidate and advance slow++.",
          descriptionBn:
              "উপাদান $candidate টি সর্টেড বাফারে সর্বোচ্চ একবার আগে এসেছে। nums[$slow] = $candidate লিখে slow++ বাড়ানো হলো।",
          visualTipEn: "Valid element kept! Advanced slow write pointer.",
          visualTipBn: "বৈধ উপাদান সংগৃহীত হলো! slow রাইট পয়েন্টার বাড়ানো হয়েছে।",
        ));
        slow++;
      } else {
        steps.add(RemoveDuplicatesIICodeFreeStep(
          slow: slow,
          fast: fast,
          array: List.from(nums),
          statusType: 'skip_duplicate',
          titleEn: "Step $stepNum: nums[fast] ($candidate) == nums[slow - 2] ($compareVal) → Skip Duplicate",
          titleBn: "ধাপ $stepNum: nums[fast] ($candidate) == nums[slow - 2] ($compareVal) → স্কিপ করুন",
          descriptionEn:
              "Value $candidate already exists 2 times at nums[slow - 2] and nums[slow - 1]. Skip this 3rd duplicate!",
          descriptionBn:
              "উপাদান $candidate টি ইতোমধ্যেই ২ বার সংরক্ষিত আছে। অতিরিক্ত ৩য় ডুপ্লিকেট স্কিপ করা হলো!",
          visualTipEn: "Duplicate count exceeded 2 limit! Skip without writing.",
          visualTipBn: "২টির বেশি ডুপ্লিকেট পাওয়া গেছে! না লিখে স্কিপ করুন।",
        ));
      }
      stepNum++;
    }

    // Finish step
    steps.add(RemoveDuplicatesIICodeFreeStep(
      slow: slow,
      fast: n - 1,
      array: List.from(nums),
      statusType: 'finish',
      titleEn: "🎉 DUP REMOVAL COMPLETE! New Length k = $slow",
      titleBn: "🎉 ডুপ্লিকেট রিমুভ সম্পূর্ণ! নতুন দৈর্ঘ্য k = $slow",
      descriptionEn:
          "First $slow elements [${nums.sublist(0, slow).join(', ')}] contain at most 2 occurrences of each number!",
      descriptionBn:
          "প্রথম $slow টি উপাদান [${nums.sublist(0, slow).join(', ')}] এ প্রতিটি সংখ্যা সর্বোচ্চ ২ বার করে বিদ্যমান!",
      visualTipEn: "✨ Single pass O(N) removal with O(1) memory completed!",
      visualTipBn: "✨ O(N) সময়ে অতিরিক্ত মেমোরি ছাড়াই সম্পূর্ণ!",
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
        ? RemoveDuplicatesIICodeFreeStep(
            slow: 2,
            fast: 2,
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
                                ? 'Remove Duplicates II (Max 2 Allowed)'
                                : 'রিমুভ ডুপ্লিকেটস ২ (সর্বোচ্চ ২টি অনুমতিপ্রাপ্ত)',
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
                            ? 'Watch how Write Pointer (slow) and Read Pointer (fast) filter excess duplicates so each element appears at most twice in-place!'
                            : 'কোনো কোড ছাড়াই দেখুন কীভাবে slow (রাইট) ও fast (রিড) পয়েন্টার প্রতিটি উপাদান সর্বোচ্চ ২টি করে রেখে বাকি অতিরিক্ত ডুপ্লিকেট রিমুভ করে!',
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

          // 3. Status Gauge
          _buildStatusGauge(step, isEng, isMobile),
          const SizedBox(height: 20),

          // 4. Array Pointers & Buffer Graphic
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
      RemoveDuplicatesIICodeFreeStep step, bool isEng, bool isMobile) {
    Color statusColor;
    IconData statusIcon;

    switch (step.statusType) {
      case 'finish':
      case 'write_element':
        statusColor = AppTheme.accentGreen;
        statusIcon = Icons.check_circle_rounded;
        break;
      case 'skip_duplicate':
        statusColor = AppTheme.accentAmber;
        statusIcon = Icons.block_rounded;
        break;
      default:
        statusColor = AppTheme.accentNeonCyan;
        statusIcon = Icons.explore_rounded;
    }

    final arr = step.array;
    final slowVal = step.slow < arr.length ? arr[step.slow] : null;
    final fastVal = step.fast < arr.length ? arr[step.fast] : null;
    final compareVal = (step.slow - 2) >= 0 && (step.slow - 2) < arr.length
        ? arr[step.slow - 2]
        : null;

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

          // Pointers & Valid Buffer Bubbles
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
                  _buildStatBubble("Write Pos (slow)", "${step.slow}", AppTheme.accentNeonCyan, isMobile),
                  const SizedBox(width: 10),
                  _buildStatBubble("Read Pos (fast)", "${step.fast} ($fastVal)", AppTheme.accentPurple, isMobile),
                  const SizedBox(width: 10),
                  _buildStatBubble("Check (slow - 2)", "${step.slow - 2} ($compareVal)", AppTheme.accentAmber, isMobile),
                  const SizedBox(width: 10),
                  _buildStatBubble("Valid Length k", "${step.slow}", AppTheme.accentGreen, isMobile),
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

  /// Graphic showing Array with Write (slow) & Read (fast) Pointers
  Widget _buildArrayPointerGraphic(
      RemoveDuplicatesIICodeFreeStep step, bool isEng, bool isMobile) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isEng ? 'Array Buffer & Pointers (slow, fast):' : 'অ্যারে বাফার ও পয়েন্টারদ্বয়:',
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
                  "Valid Buffer: [0 ... ${step.slow - 1}]",
                  style: TextStyle(
                      color: AppTheme.accentGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: Responsive.sp(context, 10.5)),
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
                final isSlow = idx == step.slow;
                final isFast = idx == step.fast;
                final isCheckPos = idx == (step.slow - 2);
                final isValidBuffer = idx < step.slow;

                Color borderColor = const Color(0xFF334155);
                Color bgColor = isValidBuffer
                    ? AppTheme.accentGreen.withOpacity(0.15)
                    : AppTheme.primaryDark;

                if (isSlow && isFast) {
                  borderColor = AppTheme.accentAmber;
                  bgColor = AppTheme.accentAmber.withOpacity(0.25);
                } else if (isSlow) {
                  borderColor = AppTheme.accentNeonCyan;
                  bgColor = AppTheme.accentNeonCyan.withOpacity(0.25);
                } else if (isFast) {
                  borderColor = AppTheme.accentPurple;
                  bgColor = AppTheme.accentPurple.withOpacity(0.25);
                } else if (isCheckPos) {
                  borderColor = AppTheme.accentAmber;
                }

                List<String> ptrLabels = [];
                if (isSlow) ptrLabels.add("slow");
                if (isFast) ptrLabels.add("fast");
                if (isCheckPos) ptrLabels.add("s-2");

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
                                  color: isSlow
                                      ? AppTheme.accentNeonCyan
                                      : (isFast
                                          ? AppTheme.accentPurple
                                          : AppTheme.accentAmber),
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
                            width: (isSlow || isFast || isCheckPos) ? 2.2 : 1.0,
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
                                color: isValidBuffer
                                    ? Colors.white
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
      RemoveDuplicatesIICodeFreeStep step, bool isEng, bool isMobile) {
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
