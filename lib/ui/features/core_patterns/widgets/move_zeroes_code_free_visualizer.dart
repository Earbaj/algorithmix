import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class MoveZeroesCodeFreeStep {
  final int slow;
  final int fast;
  final List<int> arrayState;
  final String statusType; // 'init', 'skip_zero', 'swap_non_zero', 'finish'
  final String titleEn;
  final String titleBn;
  final String descriptionEn;
  final String descriptionBn;
  final String visualTipEn;
  final String visualTipBn;
  final int fastVal;

  const MoveZeroesCodeFreeStep({
    required this.slow,
    required this.fast,
    required this.arrayState,
    required this.statusType,
    required this.titleEn,
    required this.titleBn,
    required this.descriptionEn,
    required this.descriptionBn,
    required this.visualTipEn,
    required this.visualTipBn,
    required this.fastVal,
  });
}

class MoveZeroesCodeFreeVisualizer extends StatefulWidget {
  final bool isEnglish;

  const MoveZeroesCodeFreeVisualizer({
    super.key,
    required this.isEnglish,
  });

  @override
  State<MoveZeroesCodeFreeVisualizer> createState() =>
      _MoveZeroesCodeFreeVisualizerState();
}

class _MoveZeroesCodeFreeVisualizerState
    extends State<MoveZeroesCodeFreeVisualizer> {
  List<int> _currentArray = [0, 1, 0, 3, 12];
  List<MoveZeroesCodeFreeStep> _steps = [];
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  // Presets
  final List<Map<String, dynamic>> _presets = [
    {
      'label': '[0, 1, 0, 3, 12]',
      'array': [0, 1, 0, 3, 12],
    },
    {
      'label': '[0, 0, 1]',
      'array': [0, 0, 1],
    },
    {
      'label': '[4, 2, 4, 0, 0, 3, 0, 5, 1, 0]',
      'array': [4, 2, 4, 0, 0, 3, 0, 5, 1, 0],
    },
    {
      'label': '[0]',
      'array': [0],
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
    List<MoveZeroesCodeFreeStep> steps = [];
    List<int> arr = List.from(_currentArray);
    int slow = 0;

    // Initial Step
    steps.add(MoveZeroesCodeFreeStep(
      slow: 0,
      fast: 0,
      arrayState: List.from(arr),
      statusType: 'init',
      titleEn: "Step 1: Start Both Pointers at Index 0",
      titleBn: "ধাপ ১: উভয় পয়েন্টার ইনডেক্স ০ থেকে শুরু",
      descriptionEn:
          "Slow pointer tracks valid non-zero placement position ($slow). Fast pointer scans array from index 0.",
      descriptionBn:
          "Slow পয়েন্টার পরবর্তী নন-জিরো জমার স্থান (ইনডেক্স $slow) নির্দেশ করে। Fast পয়েন্টার অ্যারে স্ক্যান করবে।",
      visualTipEn: "Same-direction pointers move together from left to right!",
      visualTipBn: "একই দিকমুখী টু-পয়েন্টার বাম থেকে ডানে এগোবে!",
      fastVal: arr.isNotEmpty ? arr[0] : 0,
    ));

    int stepNum = 2;

    for (int fast = 0; fast < arr.length; fast++) {
      int val = arr[fast];

      if (val != 0) {
        // Swap non-zero
        int temp = arr[slow];
        arr[slow] = arr[fast];
        arr[fast] = temp;

        steps.add(MoveZeroesCodeFreeStep(
          slow: slow,
          fast: fast,
          arrayState: List.from(arr),
          statusType: 'swap_non_zero',
          titleEn: "Step $stepNum: Non-Zero $val Found at Index $fast",
          titleBn: "ধাপ $stepNum: ইনডেক্স $fast এ নন-জিরো $val পাওয়া গেছে",
          descriptionEn:
              "Non-zero $val found! Swap arr[$slow] and arr[$fast]. Increment slow pointer (slow++).",
          descriptionBn:
              "নন-জিরো $val পাওয়া গেছে! arr[$slow] ও arr[$fast] অদলবদল করুন। slow পয়েন্টার ১ বাড়ান।",
          visualTipEn: "Non-zero values are pushed forward while zeros drift to the back!",
          visualTipBn: "নন-জিরো সংখ্যাগুলোকে সামনে আনা হচ্ছে এবং জিরোকে পেছনে পাঠানো হচ্ছে!",
          fastVal: val,
        ));
        slow++;
      } else {
        // Zero encountered
        steps.add(MoveZeroesCodeFreeStep(
          slow: slow,
          fast: fast,
          arrayState: List.from(arr),
          statusType: 'skip_zero',
          titleEn: "Step $stepNum: Zero Encountered at Index $fast",
          titleBn: "ধাপ $stepNum: ইনডেক্স $fast এ জিরো (0) পাওয়া গেছে",
          descriptionEn:
              "Zero found at index $fast. Do nothing to slow pointer ($slow). Advance fast pointer.",
          descriptionBn:
              "ইনডেক্স $fast এ জিরো পাওয়া গেছে। slow পয়েন্টার ($slow) অপরিবর্তিত রেখে fast আগান।",
          visualTipEn: "Zeros wait until a non-zero element arrives for swapping.",
          visualTipBn: "পরবর্তী নন-জিরো এলিমেন্ট পাওয়ার আগ পর্যন্ত জিরোগুলো অপেক্ষা করে।",
          fastVal: 0,
        ));
      }
      stepNum++;
    }

    // Finish Step
    steps.add(MoveZeroesCodeFreeStep(
      slow: slow,
      fast: arr.length - 1,
      arrayState: List.from(arr),
      statusType: 'finish',
      titleEn: "🎉 MOVE ZEROES COMPLETE!",
      titleBn: "🎉 জিরো সরানোর কাজ সম্পূর্ণ!",
      descriptionEn:
          "All non-zero elements preserved in original relative order at front: [${arr.join(', ')}]",
      descriptionBn:
          "মূল অর্ডার বজায় রেখে সমস্ত নন-জিরো উপাদান সামনে আনা হয়েছে: [${arr.join(', ')}]",
      visualTipEn: "✨ Achieved in O(N) single pass time and O(1) in-place space!",
      visualTipBn: "✨ মাত্র ১ পাশে O(N) টাইম ও O(1) মেমোরিতে সমস্যার সমাধান!",
      fastVal: 0,
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
        ? MoveZeroesCodeFreeStep(
            slow: 0,
            fast: 0,
            arrayState: _currentArray,
            statusType: 'init',
            titleEn: '',
            titleBn: '',
            descriptionEn: '',
            descriptionBn: '',
            visualTipEn: '',
            visualTipBn: '',
            fastVal: 0,
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
                                ? 'Move Zeroes Intuition'
                                : 'মুভ জিরোজ ভিজ্যুয়াল অ্যানিমেশন',
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
                            ? 'Watch how same-direction Slow & Fast pointers move non-zero elements to front while preserving relative order!'
                            : 'কোনো কোড ছাড়াই দেখুন কীভাবে একই দিকমুখী Slow ও Fast পয়েন্টার মূল অর্ডার ঠিক রেখে জিরোগুলোকে পেছনে পাঠায়!',
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
                        _loadPreset(List<int>.from(preset['array']));
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),

          // 3. Dynamic Pointer Status Gauge
          _buildStatusGauge(step, isEng, isMobile),
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

  /// Visual Status Gauge
  Widget _buildStatusGauge(
      MoveZeroesCodeFreeStep step, bool isEng, bool isMobile) {
    Color statusColor;
    IconData statusIcon;

    switch (step.statusType) {
      case 'finish':
        statusColor = AppTheme.accentGreen;
        statusIcon = Icons.check_circle_rounded;
        break;
      case 'swap_non_zero':
        statusColor = AppTheme.accentNeonCyan;
        statusIcon = Icons.swap_horiz_rounded;
        break;
      case 'skip_zero':
        statusColor = AppTheme.accentAmber;
        statusIcon = Icons.forward_rounded;
        break;
      default:
        statusColor = AppTheme.accentPurple;
        statusIcon = Icons.alt_route_rounded;
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

          // Pointer Status Capsule Display
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
                  _buildPointerBubble(
                    label: "Slow (Placement)",
                    val: "idx ${step.slow}",
                    color: AppTheme.accentNeonCyan,
                    isMobile: isMobile,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 18),
                    child: Icon(Icons.east_rounded,
                        color: statusColor,
                        size: Responsive.sp(context, isMobile ? 22 : 28)),
                  ),
                  _buildPointerBubble(
                    label: "Fast (Scan)",
                    val: "val ${step.fastVal}",
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

  Widget _buildPointerBubble({
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
              fontSize: Responsive.sp(context, isMobile ? 14 : 16),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  /// Array Graphic showing active pointers and elements
  Widget _buildCharacterArrayGraphic(
      MoveZeroesCodeFreeStep step, bool isEng, bool isMobile) {
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
              isEng ? '🔤 Array State & Pointers' : '🔤 অ্যারেই ও পয়েন্টারের অবস্থান',
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
                _buildLegendItem("Slow (Write)", AppTheme.accentNeonCyan),
                _buildLegendItem("Fast (Read)", AppTheme.accentPurple),
                _buildLegendItem("Non-Zero", AppTheme.accentGreen),
              ],
            ),
          ] else ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isEng ? '🔤 Array State & Pointers' : '🔤 অ্যারেই ও পয়েন্টারের অবস্থান',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: Responsive.sp(context, 14),
                  ),
                ),
                Row(
                  children: [
                    _buildLegendItem("Slow (Write)", AppTheme.accentNeonCyan),
                    const SizedBox(width: 10),
                    _buildLegendItem("Fast (Read)", AppTheme.accentPurple),
                    const SizedBox(width: 10),
                    _buildLegendItem("Non-Zero", AppTheme.accentGreen),
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
                final val = arr[idx];
                final isSlow = idx == step.slow;
                final isFast = idx == step.fast;
                final isNonZeroPlaced = idx < step.slow && val != 0;

                Color borderColor = const Color(0xFF334155);
                Color bgColor = AppTheme.primaryDark;

                if (isSlow && isFast) {
                  borderColor = AppTheme.accentAmber;
                  bgColor = AppTheme.accentAmber.withOpacity(0.25);
                } else if (isSlow) {
                  borderColor = AppTheme.accentNeonCyan;
                  bgColor = AppTheme.accentNeonCyan.withOpacity(0.25);
                } else if (isFast) {
                  borderColor = AppTheme.accentPurple;
                  bgColor = AppTheme.accentPurple.withOpacity(0.25);
                } else if (isNonZeroPlaced) {
                  borderColor = AppTheme.accentGreen.withOpacity(0.6);
                  bgColor = AppTheme.accentGreen.withOpacity(0.12);
                } else if (val == 0) {
                  borderColor = AppTheme.accentAmber.withOpacity(0.3);
                  bgColor = AppTheme.accentAmber.withOpacity(0.06);
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
                            if (isSlow && isFast)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 1),
                                decoration: BoxDecoration(
                                  color: AppTheme.accentAmber,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'S&F',
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              )
                            else if (isSlow)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 1),
                                decoration: BoxDecoration(
                                  color: AppTheme.accentNeonCyan,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'Slow',
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              )
                            else if (isFast)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 1),
                                decoration: BoxDecoration(
                                  color: AppTheme.accentPurple,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'Fast',
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            if (isSlow || isFast)
                              Icon(
                                Icons.arrow_drop_down,
                                color: isSlow
                                    ? AppTheme.accentNeonCyan
                                    : AppTheme.accentPurple,
                                size: 16,
                              ),
                          ],
                        ),
                      ),

                      // Card Body
                      AnimatedScale(
                        scale: (isSlow || isFast) ? 1.08 : 1.0,
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
                              width: (isSlow || isFast) ? 2.2 : 1.0,
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                '$val',
                                style: TextStyle(
                                  fontSize: Responsive.sp(
                                      context, isMobile ? 15 : 17),
                                  fontWeight: FontWeight.bold,
                                  color: val != 0
                                      ? AppTheme.accentGreen
                                      : AppTheme.accentAmber,
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
      MoveZeroesCodeFreeStep step, bool isEng, bool isMobile) {
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
