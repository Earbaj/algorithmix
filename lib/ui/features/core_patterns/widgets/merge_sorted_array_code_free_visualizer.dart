import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class MergeSortedCodeFreeStep {
  final int p1;
  final int p2;
  final int p;
  final List<int> nums1State;
  final List<int> nums2State;
  final String statusType; // 'init', 'place_nums1', 'place_nums2', 'finish'
  final String titleEn;
  final String titleBn;
  final String descriptionEn;
  final String descriptionBn;
  final String visualTipEn;
  final String visualTipBn;
  final int val1;
  final int val2;

  const MergeSortedCodeFreeStep({
    required this.p1,
    required this.p2,
    required this.p,
    required this.nums1State,
    required this.nums2State,
    required this.statusType,
    required this.titleEn,
    required this.titleBn,
    required this.descriptionEn,
    required this.descriptionBn,
    required this.visualTipEn,
    required this.visualTipBn,
    required this.val1,
    required this.val2,
  });
}

class MergeSortedArrayCodeFreeVisualizer extends StatefulWidget {
  final bool isEnglish;

  const MergeSortedArrayCodeFreeVisualizer({
    super.key,
    required this.isEnglish,
  });

  @override
  State<MergeSortedArrayCodeFreeVisualizer> createState() =>
      _MergeSortedArrayCodeFreeVisualizerState();
}

class _MergeSortedArrayCodeFreeVisualizerState
    extends State<MergeSortedArrayCodeFreeVisualizer> {
  List<int> _initialNums1 = [1, 2, 3, 0, 0, 0];
  int _m = 3;
  List<int> _initialNums2 = [2, 5, 6];
  int _n = 3;

  List<MergeSortedCodeFreeStep> _steps = [];
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  // Presets
  final List<Map<String, dynamic>> _presets = [
    {
      'label': 'nums1=[1,2,3,0,0,0], nums2=[2,5,6]',
      'nums1': [1, 2, 3, 0, 0, 0],
      'm': 3,
      'nums2': [2, 5, 6],
      'n': 3,
    },
    {
      'label': 'nums1=[4,5,6,0,0,0], nums2=[1,2,3]',
      'nums1': [4, 5, 6, 0, 0, 0],
      'm': 3,
      'nums2': [1, 2, 3],
      'n': 3,
    },
    {
      'label': 'nums1=[1], nums2=[]',
      'nums1': [1],
      'm': 1,
      'nums2': <int>[],
      'n': 0,
    },
    {
      'label': 'nums1=[0], nums2=[1]',
      'nums1': [0],
      'm': 0,
      'nums2': [1],
      'n': 1,
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

  void _loadPreset(Map<String, dynamic> preset) {
    _timer?.cancel();
    setState(() {
      _isPlaying = false;
      _initialNums1 = List<int>.from(preset['nums1']);
      _m = preset['m'];
      _initialNums2 = List<int>.from(preset['nums2']);
      _n = preset['n'];
      _currentStepIndex = 0;
      _generateCodeFreeSteps();
    });
  }

  void _generateCodeFreeSteps() {
    List<MergeSortedCodeFreeStep> steps = [];
    List<int> n1 = List.from(_initialNums1);
    List<int> n2 = List.from(_initialNums2);

    int p1 = _m - 1;
    int p2 = _n - 1;
    int p = _m + _n - 1;

    // Step 0: Start Pointers at Back
    steps.add(MergeSortedCodeFreeStep(
      p1: p1,
      p2: p2,
      p: p,
      nums1State: List.from(n1),
      nums2State: List.from(n2),
      statusType: 'init',
      titleEn: "Step 1: Place Pointers at Back of Both Arrays",
      titleBn: "ধাপ ১: উভয় অ্যারের পেছনে পয়েন্টার সূচনা",
      descriptionEn:
          "p1 starts at index $p1 (nums1), p2 starts at index $p2 (nums2), write pointer p starts at index $p (nums1 back buffer).",
      descriptionBn:
          "p1 ইনডেক্স $p1 (nums1), p2 ইনডেক্স $p2 (nums2) এবং রাইট পয়েন্টার p ইনডেক্স $p (nums1 এর পেছনে) বসানো হলো।",
      visualTipEn: "Merge from right to left to avoid overwriting elements in nums1!",
      visualTipBn: "nums1 এর উপাদান ওভাররাইট হওয়া ঠেকাতে পেছন থেকে সামনে মার্জ করুন!",
      val1: (p1 >= 0 && p1 < n1.length) ? n1[p1] : -999,
      val2: (p2 >= 0 && p2 < n2.length) ? n2[p2] : -999,
    ));

    int stepNum = 2;

    while (p2 >= 0) {
      int val1 = (p1 >= 0) ? n1[p1] : -999999;
      int val2 = n2[p2];

      if (p1 >= 0 && n1[p1] > n2[p2]) {
        n1[p] = n1[p1];
        steps.add(MergeSortedCodeFreeStep(
          p1: p1,
          p2: p2,
          p: p,
          nums1State: List.from(n1),
          nums2State: List.from(n2),
          statusType: 'place_nums1',
          titleEn: "Step $stepNum: nums1[$p1] ($val1) > nums2[$p2] ($val2)",
          titleBn: "ধাপ $stepNum: nums1[$p1] ($val1) > nums2[$p2] ($val2)",
          descriptionEn:
              "nums1[$p1] ($val1) is larger! Place $val1 at nums1[$p]. Decrement p1-- & p--.",
          descriptionBn:
              "nums1[$p1] ($val1) বড়! $val1 সংখ্যাটি nums1[$p] এ বসানো হলো। p1 ও p পয়েন্টার ১ কমান।",
          visualTipEn: "Larger value placed at back write position p.",
          visualTipBn: "বড় মানটি রাইট পজিশন p এ স্থানান্তরিত হলো।",
          val1: val1,
          val2: val2,
        ));
        p1--;
      } else {
        n1[p] = n2[p2];
        steps.add(MergeSortedCodeFreeStep(
          p1: p1,
          p2: p2,
          p: p,
          nums1State: List.from(n1),
          nums2State: List.from(n2),
          statusType: 'place_nums2',
          titleEn: "Step $stepNum: nums2[$p2] ($val2) ≥ nums1[$p1] (${p1 >= 0 ? val1 : 'N/A'})",
          titleBn: "ধাপ $stepNum: nums2[$p2] ($val2) ≥ nums1[$p1] (${p1 >= 0 ? val1 : 'N/A'})",
          descriptionEn:
              "nums2[$p2] ($val2) is larger or equal! Place $val2 at nums1[$p]. Decrement p2-- & p--.",
          descriptionBn:
              "nums2[$p2] ($val2) বড় বা সমান! $val2 সংখ্যাটি nums1[$p] এ বসানো হলো। p2 ও p পয়েন্টার ১ কমান।",
          visualTipEn: "Element from nums2 placed into write position p.",
          visualTipBn: "nums2 থেকে বড় মানটি nums1 এর স্থান p এ বসানো হলো।",
          val1: val1,
          val2: val2,
        ));
        p2--;
      }
      p--;
      stepNum++;
    }

    // Finish step
    steps.add(MergeSortedCodeFreeStep(
      p1: p1,
      p2: p2,
      p: p,
      nums1State: List.from(n1),
      nums2State: List.from(n2),
      statusType: 'finish',
      titleEn: "🎉 MERGE SORTED ARRAYS COMPLETE!",
      titleBn: "🎉 মার্জ ও সর্টিং সম্পূর্ণ!",
      descriptionEn:
          "Merged result sorted in non-decreasing order inside nums1: [${n1.join(', ')}]",
      descriptionBn:
          "nums1 এর ভেতরে মার্জড ও সর্টেড ফলাফল: [${n1.join(', ')}]",
      visualTipEn: "✨ Completed in-place with O(m + n) time and O(1) extra space!",
      visualTipBn: "✨ কোনো অতিরিক্ত মেমোরি ছাড়াই O(m + n) সময়ে নিখুঁতভাবে ইন-প্লেস মার্জ সম্পন্ন!",
      val1: 0,
      val2: 0,
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
        ? MergeSortedCodeFreeStep(
            p1: 0,
            p2: 0,
            p: 0,
            nums1State: _initialNums1,
            nums2State: _initialNums2,
            statusType: 'init',
            titleEn: '',
            titleBn: '',
            descriptionEn: '',
            descriptionBn: '',
            visualTipEn: '',
            visualTipBn: '',
            val1: 0,
            val2: 0,
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
                                ? 'Merge Sorted Array Intuition'
                                : 'মার্জ সর্টেড অ্যারে ভিজ্যুয়াল অ্যানিমেশন',
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
                            ? 'Watch how pointers merge two sorted arrays in-place from back to front with O(1) extra space!'
                            : 'কোনো কোড ছাড়াই দেখুন কীভাবে টু-পয়েন্টার পেছন থেকে সামনে ইন-প্লেস মার্জ সম্পন্ন করে!',
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
                final isSelected = _initialNums1.length ==
                        (preset['nums1'] as List).length &&
                    _initialNums2.length == (preset['nums2'] as List).length &&
                    _m == preset['m'];
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
                        _loadPreset(preset);
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),

          // 3. Dynamic Status Gauge
          _buildStatusGauge(step, isEng, isMobile),
          const SizedBox(height: 20),

          // 4. Dual Array Graphic
          _buildDualArrayGraphic(step, isEng, isMobile),
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
      MergeSortedCodeFreeStep step, bool isEng, bool isMobile) {
    Color statusColor;
    IconData statusIcon;

    switch (step.statusType) {
      case 'finish':
        statusColor = AppTheme.accentGreen;
        statusIcon = Icons.check_circle_rounded;
        break;
      case 'place_nums1':
        statusColor = AppTheme.accentNeonCyan;
        statusIcon = Icons.south_rounded;
        break;
      case 'place_nums2':
        statusColor = AppTheme.accentPurple;
        statusIcon = Icons.north_rounded;
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
                  _buildPointerBubble(
                    label: "nums1[p1]",
                    val: step.p1 >= 0 ? "${step.val1}" : "N/A",
                    color: AppTheme.accentNeonCyan,
                    isMobile: isMobile,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 18),
                    child: Text(
                      step.val1 > step.val2
                          ? ">"
                          : (step.val1 < step.val2 ? "<" : "=="),
                      style: TextStyle(
                        color: statusColor,
                        fontSize: Responsive.sp(context, isMobile ? 18 : 22),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _buildPointerBubble(
                    label: "nums2[p2]",
                    val: step.p2 >= 0 ? "${step.val2}" : "N/A",
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
              fontSize: Responsive.sp(context, isMobile ? 15 : 18),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  /// Graphic showing nums1 (Buffer) and nums2
  Widget _buildDualArrayGraphic(
      MergeSortedCodeFreeStep step, bool isEng, bool isMobile) {
    final n1 = step.nums1State;
    final n2 = step.nums2State;

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
          // nums1 Display
          Text(
            isEng ? '1️⃣ nums1 Array (In-Place Target with Buffer):' : '১️⃣ nums1 অ্যারে (বাফার স্থান সহ লক্ষ্যের স্থান):',
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
              children: List.generate(n1.length, (idx) {
                final val = n1[idx];
                final isP1 = idx == step.p1;
                final isP = idx == step.p;

                Color borderColor = const Color(0xFF334155);
                Color bgColor = AppTheme.primaryDark;

                if (isP1 && isP) {
                  borderColor = AppTheme.accentAmber;
                  bgColor = AppTheme.accentAmber.withOpacity(0.25);
                } else if (isP1) {
                  borderColor = AppTheme.accentNeonCyan;
                  bgColor = AppTheme.accentNeonCyan.withOpacity(0.25);
                } else if (isP) {
                  borderColor = AppTheme.accentAmber;
                  bgColor = AppTheme.accentAmber.withOpacity(0.15);
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
                            if (isP1 && isP)
                              const Text('P1&P',
                                  style: TextStyle(
                                      fontSize: 9,
                                      color: AppTheme.accentAmber,
                                      fontWeight: FontWeight.bold))
                            else if (isP1)
                              const Text('p1',
                                  style: TextStyle(
                                      fontSize: 9,
                                      color: AppTheme.accentNeonCyan,
                                      fontWeight: FontWeight.bold))
                            else if (isP)
                              const Text('Write p',
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
                            width: (isP1 || isP) ? 2.2 : 1.0,
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
          const SizedBox(height: 20),

          // nums2 Display
          Text(
            isEng ? '2️⃣ nums2 Array (Source to Merge):' : '২️⃣ nums2 অ্যারে (মার্জ করার সোর্স):',
            style: TextStyle(
              color: AppTheme.accentPurple,
              fontWeight: FontWeight.bold,
              fontSize: Responsive.sp(context, 13.5),
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(n2.length, (idx) {
                final val = n2[idx];
                final isP2 = idx == step.p2;

                Color borderColor = isP2
                    ? AppTheme.accentPurple
                    : const Color(0xFF334155);
                Color bgColor = isP2
                    ? AppTheme.accentPurple.withOpacity(0.25)
                    : AppTheme.primaryDark;

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
                            if (isP2)
                              const Text('p2',
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
                            width: isP2 ? 2.2 : 1.0,
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
      MergeSortedCodeFreeStep step, bool isEng, bool isMobile) {
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
