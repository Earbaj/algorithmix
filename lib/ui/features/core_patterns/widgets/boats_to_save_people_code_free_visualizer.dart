import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class BoatsCodeFreeStep {
  final int left;
  final int right;
  final int limit;
  final List<int> sortedPeople;
  final int boatsCount;
  final List<String> boatLog;
  final String statusType; // 'init', 'pair_boat', 'heavy_alone', 'single_last', 'finish'
  final String titleEn;
  final String titleBn;
  final String descriptionEn;
  final String descriptionBn;
  final String visualTipEn;
  final String visualTipBn;

  const BoatsCodeFreeStep({
    required this.left,
    required this.right,
    required this.limit,
    required this.sortedPeople,
    required this.boatsCount,
    required this.boatLog,
    required this.statusType,
    required this.titleEn,
    required this.titleBn,
    required this.descriptionEn,
    required this.descriptionBn,
    required this.visualTipEn,
    required this.visualTipBn,
  });
}

class BoatsToSavePeopleCodeFreeVisualizer extends StatefulWidget {
  final bool isEnglish;

  const BoatsToSavePeopleCodeFreeVisualizer({
    super.key,
    required this.isEnglish,
  });

  @override
  State<BoatsToSavePeopleCodeFreeVisualizer> createState() =>
      _BoatsToSavePeopleCodeFreeVisualizerState();
}

class _BoatsToSavePeopleCodeFreeVisualizerState
    extends State<BoatsToSavePeopleCodeFreeVisualizer> {
  List<int> _rawPeople = [3, 2, 2, 1];
  int _limit = 3;

  List<BoatsCodeFreeStep> _steps = [];
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  // Presets
  final List<Map<String, dynamic>> _presets = [
    {
      'label': '[3, 2, 2, 1], limit = 3',
      'people': [3, 2, 2, 1],
      'limit': 3,
    },
    {
      'label': '[3, 5, 3, 4], limit = 5',
      'people': [3, 5, 3, 4],
      'limit': 5,
    },
    {
      'label': '[5, 1, 4, 2], limit = 6',
      'people': [5, 1, 4, 2],
      'limit': 6,
    },
    {
      'label': '[1, 2], limit = 3',
      'people': [1, 2],
      'limit': 3,
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

  void _loadPreset(List<int> people, int limit) {
    _timer?.cancel();
    setState(() {
      _isPlaying = false;
      _rawPeople = List.from(people);
      _limit = limit;
      _currentStepIndex = 0;
      _generateCodeFreeSteps();
    });
  }

  void _generateCodeFreeSteps() {
    List<BoatsCodeFreeStep> steps = [];
    List<int> people = List.from(_rawPeople);
    people.sort();

    int n = people.length;
    if (n == 0) return;

    int left = 0;
    int right = n - 1;
    int boats = 0;
    List<String> logs = [];

    // Initial setup step
    steps.add(BoatsCodeFreeStep(
      left: left,
      right: right,
      limit: _limit,
      sortedPeople: List.from(people),
      boatsCount: 0,
      boatLog: [],
      statusType: 'init',
      titleEn: "Step 1: Sort Weights & Set left = 0, right = ${n - 1}",
      titleBn: "ধাপ ১: ওজন অনুযায়ী সর্ট করুন ও পয়েন্টার বসান (left = 0, right = ${n - 1})",
      descriptionEn:
          "Sorted weights: [${people.join(', ')}]. Boat limit = $_limit. Left (lightest) = ${people[left]}, Right (heaviest) = ${people[right]}.",
      descriptionBn:
          "সর্টেড ওজনসমূহ: [${people.join(', ')}]। নৌকার ক্ষমতা = $_limit। হালকা (left) = ${people[left]}, ভারী (right) = ${people[right]}।",
      visualTipEn: "Greedy Strategy: Pair the heaviest person with the lightest person whenever possible!",
      visualTipBn: "লোভী কৌশল: সম্ভব হলেই সবচেয়ে ভারী ব্যক্তির সাথে সবচেয়ে হালকা ব্যক্তিকে একই নৌকায় পার করুন!",
    ));

    int stepNum = 2;

    while (left <= right) {
      if (left == right) {
        boats++;
        logs.add("Boat #$boats: [${people[left]}] (Single Person)");
        steps.add(BoatsCodeFreeStep(
          left: left,
          right: right,
          limit: _limit,
          sortedPeople: List.from(people),
          boatsCount: boats,
          boatLog: List.from(logs),
          statusType: 'single_last',
          titleEn: "Step $stepNum: Last Person (${people[left]}) Gets Boat #$boats ⛵",
          titleBn: "ধাপ $stepNum: সর্বশেষ ব্যক্তি (${people[left]}) নৌকা #$boats পাবেন ⛵",
          descriptionEn:
              "Only 1 person remaining (weight ${people[left]}). Assign a dedicated boat #$boats.",
          descriptionBn:
              "কেবল ১ জন ব্যক্তি অবশিষ্ট আছেন (ওজন ${people[left]})। তাকে নৌকা #$boats এ বরাদ্দ করা হলো।",
          visualTipEn: "Final person assigned a boat!",
          visualTipBn: "সর্বশেষ ব্যক্তি নৌকায় উঠলেন!",
        ));
        break;
      }

      int sum = people[left] + people[right];

      if (sum <= _limit) {
        boats++;
        logs.add("Boat #$boats: [${people[left]} + ${people[right]} = $sum]");
        steps.add(BoatsCodeFreeStep(
          left: left,
          right: right,
          limit: _limit,
          sortedPeople: List.from(people),
          boatsCount: boats,
          boatLog: List.from(logs),
          statusType: 'pair_boat',
          titleEn: "Step $stepNum: Pair Light (${people[left]}) + Heavy (${people[right]}) = $sum ≤ $_limit 🎉",
          titleBn: "ধাপ $stepNum: হালকা (${people[left]}) + ভারী (${people[right]}) = $sum ≤ $_limit 🎉",
          descriptionEn:
              "Heaviest (${people[right]}) and Lightest (${people[left]}) fit in Boat #$boats! Advance left++ and right--.",
          descriptionBn:
              "সবচেয়ে ভারী (${people[right]}) এবং সবচেয়ে হালকা (${people[left]}) উভয়েই নৌকা #$boats এ ফিট করেছেন! left++ এবং right-- করা হলো।",
          visualTipEn: "Optimal pairing achieved! 2 people saved in 1 boat.",
          visualTipBn: "সর্বোত্তম জোড় তৈরি হলো! ১টি নৌকায় ২ জন পার হলেন।",
        ));
        left++;
        right--;
      } else {
        boats++;
        logs.add("Boat #$boats: [${people[right]}] (Heavy Alone)");
        steps.add(BoatsCodeFreeStep(
          left: left,
          right: right,
          limit: _limit,
          sortedPeople: List.from(people),
          boatsCount: boats,
          boatLog: List.from(logs),
          statusType: 'heavy_alone',
          titleEn: "Step $stepNum: Sum (${people[left]} + ${people[right]} = $sum) > $_limit → Heavy Alone 🛶",
          titleBn: "ধাপ $stepNum: যোগফল (${people[left]} + ${people[right]} = $sum) > $_limit → ভারী ব্যক্তি একা 🛶",
          descriptionEn:
              "Heaviest person (${people[right]}) cannot pair with lightest (${people[left]}). Send heavy person alone in Boat #$boats! Decrement right--.",
          descriptionBn:
              "সবচেয়ে ভারী ব্যক্তি (${people[right]}) সবচেয়ে হালকা জনের সাথেও জায়গা পাননি। তাকে একা নৌকা #$boats এ পাঠানো হলো! right-- কমান।",
          visualTipEn: "Heavy person takes a solo boat! Light person stays for lighter partners.",
          visualTipBn: "ভারী ব্যক্তি একা নৌকা নিলেন! হালকা ব্যক্তি পরবর্তী সুযোগের জন্য অপেক্ষা করবেন।",
        ));
        right--;
      }
      stepNum++;
    }

    // Finish step
    steps.add(BoatsCodeFreeStep(
      left: 0,
      right: n - 1,
      limit: _limit,
      sortedPeople: List.from(people),
      boatsCount: boats,
      boatLog: List.from(logs),
      statusType: 'finish',
      titleEn: "🎉 ALL PEOPLE SAVED! Total Minimum Boats Required = $boats ⛵",
      titleBn: "🎉 সকলকে নিরাপদে পার করা হয়েছে! সর্বমোট প্রয়োজনীয় নৌকা = $boats ⛵",
      descriptionEn:
          "Successfully evacuated all $n people using $boats boats under limit $_limit!",
      descriptionBn:
          "সীমা $_limit এর অধীনে সর্বমোট $boats টি নৌকার সাহায্যে সকল $n জনকে নিরাপদে স্থানান্তরিত করা হলো!",
      visualTipEn: "✨ Completed in O(N log N) greedy two-pointer time!",
      visualTipBn: "✨ O(N log N) গ্রিডি কৌশলে সম্পন্ন!",
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
        ? BoatsCodeFreeStep(
            left: 0,
            right: _rawPeople.length - 1,
            limit: _limit,
            sortedPeople: _rawPeople,
            boatsCount: 0,
            boatLog: [],
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
                    Icons.sailing_rounded,
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
                                ? 'Boats to Save People Intuition'
                                : 'বোটস টু সেভ পিপল ভিজ্যুয়াল অ্যানিমেশন',
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
                            ? 'Watch Greedy Two Pointers pair the heaviest and lightest people to minimize the number of rescue boats needed!'
                            : 'কোনো কোড ছাড়াই দেখুন কীভাবে গ্রিডি টু-পয়েন্টার দিয়ে সবচেয়ে ভারী ও হালকা ব্যক্তিকে মিলিয়ে সর্বনিম্ন নৌকায় সকলকে উদ্ধার করা হয়!',
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
                final isSelected = _rawPeople.length ==
                        (preset['people'] as List).length &&
                    _limit == preset['limit'];
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
                        _loadPreset(List<int>.from(preset['people']), preset['limit']);
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),

          // 3. Status Gauge & Boat Count
          _buildStatusGauge(step, isEng, isMobile),
          const SizedBox(height: 20),

          // 4. Sorted People & Boat Allocation Graphic
          _buildPeopleBoatGraphic(step, isEng, isMobile),
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
      BoatsCodeFreeStep step, bool isEng, bool isMobile) {
    Color statusColor;
    IconData statusIcon;

    switch (step.statusType) {
      case 'finish':
      case 'pair_boat':
        statusColor = AppTheme.accentGreen;
        statusIcon = Icons.sailing_rounded;
        break;
      case 'heavy_alone':
        statusColor = AppTheme.accentAmber;
        statusIcon = Icons.directions_boat_rounded;
        break;
      case 'single_last':
        statusColor = AppTheme.accentNeonCyan;
        statusIcon = Icons.person_rounded;
        break;
      default:
        statusColor = AppTheme.accentNeonCyan;
        statusIcon = Icons.explore_rounded;
    }

    final p = step.sortedPeople;
    final sum = step.left <= step.right ? p[step.left] + p[step.right] : 0;

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
                  _buildStatBubble("Boat Limit", "${step.limit}", AppTheme.accentNeonCyan, isMobile),
                  const SizedBox(width: 10),
                  _buildStatBubble("Light + Heavy", step.left <= step.right ? "$sum" : "Done", AppTheme.accentPurple, isMobile),
                  const SizedBox(width: 10),
                  _buildStatBubble("Total Boats ⛵", "${step.boatsCount}", AppTheme.accentGreen, isMobile),
                ],
              ),
            ),
          ),
          if (step.boatLog.isNotEmpty) ...[
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: step.boatLog.map((log) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.accentPurple.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.accentPurple.withOpacity(0.5)),
                    ),
                    child: Text(
                      log,
                      style: TextStyle(
                          color: AppTheme.accentNeonCyan,
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

  /// Graphic showing Sorted People & Pointers (left, right)
  Widget _buildPeopleBoatGraphic(
      BoatsCodeFreeStep step, bool isEng, bool isMobile) {
    final arr = step.sortedPeople;

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
                isEng ? 'Sorted People Weights (left, right):' : 'সর্টেড মানুষের ওজন ও পয়েন্টারদ্বয়:',
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
                  "Limit: ${step.limit}",
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
                final isLeft = idx == step.left;
                final isRight = idx == step.right;

                Color borderColor = const Color(0xFF334155);
                Color bgColor = AppTheme.primaryDark;

                if (isLeft && isRight) {
                  borderColor = AppTheme.accentGreen;
                  bgColor = AppTheme.accentGreen.withOpacity(0.25);
                } else if (isLeft) {
                  borderColor = AppTheme.accentNeonCyan;
                  bgColor = AppTheme.accentNeonCyan.withOpacity(0.25);
                } else if (isRight) {
                  borderColor = AppTheme.accentAmber;
                  bgColor = AppTheme.accentAmber.withOpacity(0.25);
                }

                return Container(
                  margin: EdgeInsets.only(right: isMobile ? 6 : 8),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 24,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (isLeft && isRight)
                              const Text('L&R',
                                  style: TextStyle(
                                      fontSize: 9.5,
                                      color: AppTheme.accentGreen,
                                      fontWeight: FontWeight.bold))
                            else if (isLeft)
                              const Text('Light',
                                  style: TextStyle(
                                      fontSize: 9.5,
                                      color: AppTheme.accentNeonCyan,
                                      fontWeight: FontWeight.bold))
                            else if (isRight)
                              const Text('Heavy',
                                  style: TextStyle(
                                      fontSize: 9.5,
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
                            width: (isLeft || isRight) ? 2.2 : 1.0,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.person,
                              color: (isLeft || isRight)
                                  ? Colors.white
                                  : AppTheme.textMuted,
                              size: 16,
                            ),
                            const SizedBox(height: 2),
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
      BoatsCodeFreeStep step, bool isEng, bool isMobile) {
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
