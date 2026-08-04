import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class IsSubsequenceCodeFreeStep {
  final int i;
  final int j;
  final String sStr;
  final String tStr;
  final List<bool> matchedInT;
  final String statusType; // 'init', 'match', 'mismatch', 'finish_true', 'finish_false'
  final String titleEn;
  final String titleBn;
  final String descriptionEn;
  final String descriptionBn;
  final String visualTipEn;
  final String visualTipBn;

  const IsSubsequenceCodeFreeStep({
    required this.i,
    required this.j,
    required this.sStr,
    required this.tStr,
    required this.matchedInT,
    required this.statusType,
    required this.titleEn,
    required this.titleBn,
    required this.descriptionEn,
    required this.descriptionBn,
    required this.visualTipEn,
    required this.visualTipBn,
  });
}

class IsSubsequenceCodeFreeVisualizer extends StatefulWidget {
  final bool isEnglish;

  const IsSubsequenceCodeFreeVisualizer({
    super.key,
    required this.isEnglish,
  });

  @override
  State<IsSubsequenceCodeFreeVisualizer> createState() =>
      _IsSubsequenceCodeFreeVisualizerState();
}

class _IsSubsequenceCodeFreeVisualizerState
    extends State<IsSubsequenceCodeFreeVisualizer> {
  String _s = "abc";
  String _t = "ahbgdc";

  List<IsSubsequenceCodeFreeStep> _steps = [];
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  // Presets
  final List<Map<String, String>> _presets = [
    {
      'label': 's = "abc", t = "ahbgdc" (TRUE)',
      's': 'abc',
      't': 'ahbgdc',
    },
    {
      'label': 's = "axc", t = "ahbgdc" (FALSE)',
      's': 'axc',
      't': 'ahbgdc',
    },
    {
      'label': 's = "ace", t = "abcde" (TRUE)',
      's': 'ace',
      't': 'abcde',
    },
    {
      'label': 's = "sing", t = "string" (TRUE)',
      's': 'sing',
      't': 'string',
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

  void _loadPreset(String s, String t) {
    _timer?.cancel();
    setState(() {
      _isPlaying = false;
      _s = s;
      _t = t;
      _currentStepIndex = 0;
      _generateCodeFreeSteps();
    });
  }

  void _generateCodeFreeSteps() {
    List<IsSubsequenceCodeFreeStep> steps = [];
    int i = 0;
    int j = 0;
    List<bool> matchedInT = List.filled(_t.length, false);

    // Step 0: Initial Pointers Setup
    steps.add(IsSubsequenceCodeFreeStep(
      i: i,
      j: j,
      sStr: _s,
      tStr: _t,
      matchedInT: List.from(matchedInT),
      statusType: 'init',
      titleEn: "Step 1: Place Pointer i on s[0] & Pointer j on t[0]",
      titleBn: "ধাপ ১: পয়েন্টার i কে s[0] এ এবং পয়েন্টার j কে t[0] এ সূচনা",
      descriptionEn:
          "Target string s = \"$_s\", source string t = \"$_t\". We search for character '${_s.isNotEmpty ? _s[0] : ""}' in t.",
      descriptionBn:
          "টার্গেট s = \"$_s\", মূল স্ট্রিং t = \"$_t\"। আমরা t এর ভেতরে '${_s.isNotEmpty ? _s[0] : ""}' অক্ষরটি খুঁজব।",
      visualTipEn: "Pointer i advances ONLY when a character match occurs in string t!",
      visualTipBn: "স্ট্রিং t তে অক্ষর মিললেই কেবল পয়েন্টার i সামনের অক্ষরের দিকে এগোবে!",
    ));

    if (_s.isEmpty) {
      steps.add(IsSubsequenceCodeFreeStep(
        i: 0,
        j: 0,
        sStr: _s,
        tStr: _t,
        matchedInT: List.from(matchedInT),
        statusType: 'finish_true',
        titleEn: "🎉 IS SUBSEQUENCE = TRUE (Empty String)",
        titleBn: "🎉 সাবসিকোয়েন্স = সত্য (ফাঁকা স্ট্রিং)",
        descriptionEn: "An empty string is always a subsequence of any string!",
        descriptionBn: "ফাঁকা স্ট্রিং সর্বদা যেকোনো স্ট্রিংয়ের একটি সাবসিকোয়েন্স!",
        visualTipEn: "✨ Completed with true result!",
        visualTipBn: "✨ সত্য উত্তর সহ সম্পন্ন!",
      ));
      _steps = steps;
      return;
    }

    int stepNum = 2;

    while (i < _s.length && j < _t.length) {
      if (_s[i] == _t[j]) {
        matchedInT[j] = true;
        steps.add(IsSubsequenceCodeFreeStep(
          i: i,
          j: j,
          sStr: _s,
          tStr: _t,
          matchedInT: List.from(matchedInT),
          statusType: 'match',
          titleEn: "Step $stepNum: Match Found! s[$i] ('${_s[i]}') == t[$j] ('${_t[j]}')",
          titleBn: "ধাপ $stepNum: অক্ষর মিল পাওয়া গেছে! s[$i] ('${_s[i]}') == t[$j] ('${_t[j]}')",
          descriptionEn:
              "Character '${_s[i]}' matched! Advance target pointer i (i++) and source pointer j (j++).",
          descriptionBn:
              "অক্ষর '${_s[i]}' মিলে গেছে! টার্গেট পয়েন্টার i ও সোর্স পয়েন্টার j দুটোই ১ আগান।",
          visualTipEn: "Match confirmed! Move to search next target character.",
          visualTipBn: "ম্যাচ নিশ্চিত! s এর পরবর্তী অক্ষরের খোঁজে পয়েন্টার আগান।",
        ));
        i++;
      } else {
        steps.add(IsSubsequenceCodeFreeStep(
          i: i,
          j: j,
          sStr: _s,
          tStr: _t,
          matchedInT: List.from(matchedInT),
          statusType: 'mismatch',
          titleEn: "Step $stepNum: Mismatch. s[$i] ('${_s[i]}') != t[$j] ('${_t[j]}')",
          titleBn: "ধাপ $stepNum: অমিল। s[$i] ('${_s[i]}') != t[$j] ('${_t[j]}')",
          descriptionEn:
              "t[$j] is '${_t[j]}', but we need '${_s[i]}'. Skip t[$j] and advance j (j++).",
          descriptionBn:
              "t[$j] এর মান '${_t[j]}', কিন্তু আমাদের দরকার '${_s[i]}'। t[$j] স্কিপ করে j ১ আগান।",
          visualTipEn: "No match here. Keep scanning string t.",
          visualTipBn: "এখানে মেলেনি। t এর পরবর্তী অক্ষরের দিকে স্ক্যান চালিয়ে যান।",
        ));
      }
      j++;
      stepNum++;
    }

    bool isSubseq = i == _s.length;

    if (isSubseq) {
      steps.add(IsSubsequenceCodeFreeStep(
        i: i,
        j: j,
        sStr: _s,
        tStr: _t,
        matchedInT: List.from(matchedInT),
        statusType: 'finish_true',
        titleEn: "🎉 IS SUBSEQUENCE = TRUE!",
        titleBn: "🎉 সাবসিকোয়েন্স = সত্য!",
        descriptionEn:
            "All characters of \"$_s\" were found in \"$_t\" in relative order!",
        descriptionBn:
            "\"$_s\" এর সকল অক্ষর \"$_t\" এর মধ্যে সঠিক ক্রমানুসারে পাওয়া গেছে!",
        visualTipEn: "✨ Complete subsequence matched in O(|t|) time!",
        visualTipBn: "✨ O(|t|) সময়ের মধ্যে পুরো সাবসিকোয়েন্স সফলভাবে ম্যাচড!",
      ));
    } else {
      steps.add(IsSubsequenceCodeFreeStep(
        i: i,
        j: j,
        sStr: _s,
        tStr: _t,
        matchedInT: List.from(matchedInT),
        statusType: 'finish_false',
        titleEn: "❌ IS SUBSEQUENCE = FALSE",
        titleBn: "❌ সাবসিকোয়েন্স = মিথ্যা",
        descriptionEn:
            "Reached end of string t before finding character '${_s[i]}' of \"$_s\"!",
        descriptionBn:
            "\"$_s\" এর অক্ষর '${_s[i]}' পাওয়ার আগেই স্ট্রিং t শেষ হয়ে গেছে!",
        visualTipEn: "Target characters could not be fully matched.",
        visualTipBn: "টার্গেট অক্ষরসমূহ পুরোপুরি মেলাতে পাওয়া যায়নি।",
      ));
    }

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
        ? IsSubsequenceCodeFreeStep(
            i: 0,
            j: 0,
            sStr: _s,
            tStr: _t,
            matchedInT: List.filled(_t.length, false),
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
                                ? 'Is Subsequence Intuition'
                                : 'ইস সাবসিকোয়েন্স ভিজ্যুয়াল অ্যানিমেশন',
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
                            ? 'Watch how pointer i tracks target s while pointer j scans source string t in O(|t|) time!'
                            : 'কোনো কোড ছাড়াই দেখুন কীভাবে পয়েন্টার i টার্গেট স্ট্রিং s কে ট্রেস করে এবং j স্ট্রিং t স্ক্যান করে!',
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
                final isSelected =
                    _s == preset['s'] && _t == preset['t'];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(
                      preset['label']!,
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
                        _loadPreset(preset['s']!, preset['t']!);
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

          // 4. Dual String Pointers Graphic
          _buildDualStringGraphic(step, isEng, isMobile),
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
      IsSubsequenceCodeFreeStep step, bool isEng, bool isMobile) {
    Color statusColor;
    IconData statusIcon;

    switch (step.statusType) {
      case 'finish_true':
        statusColor = AppTheme.accentGreen;
        statusIcon = Icons.check_circle_rounded;
        break;
      case 'finish_false':
        statusColor = AppTheme.accentPink;
        statusIcon = Icons.cancel_rounded;
        break;
      case 'match':
        statusColor = AppTheme.accentGreen;
        statusIcon = Icons.task_alt_rounded;
        break;
      case 'mismatch':
        statusColor = AppTheme.accentAmber;
        statusIcon = Icons.subtitles_off_rounded;
        break;
      default:
        statusColor = AppTheme.accentNeonCyan;
        statusIcon = Icons.search_rounded;
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

          // Character Match Bubble
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
                    label: "Target s[i]",
                    char: step.i < step.sStr.length ? step.sStr[step.i] : "END",
                    color: AppTheme.accentNeonCyan,
                    isMobile: isMobile,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 18),
                    child: Text(
                      step.statusType == 'match'
                          ? "=="
                          : (step.statusType == 'mismatch' ? "!=" : "vs"),
                      style: TextStyle(
                        color: statusColor,
                        fontSize: Responsive.sp(context, isMobile ? 18 : 22),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _buildCharBubble(
                    label: "Source t[j]",
                    char: step.j < step.tStr.length ? step.tStr[step.j] : "END",
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
    required String char,
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
            "'$char'",
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

  /// Graphic showing Target s and Source t strings
  Widget _buildDualStringGraphic(
      IsSubsequenceCodeFreeStep step, bool isEng, bool isMobile) {
    final sStr = step.sStr;
    final tStr = step.tStr;

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
          // String s (Target)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isEng ? '1️⃣ Target String s (Pointer i):' : '১️⃣ টার্গেট স্ট্রিং s (পয়েন্টার i):',
                style: TextStyle(
                  color: AppTheme.accentNeonCyan,
                  fontWeight: FontWeight.bold,
                  fontSize: Responsive.sp(context, 13.5),
                ),
              ),
              Text(
                "Matched: ${step.i}/${sStr.length}",
                style: TextStyle(
                    color: AppTheme.accentGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: Responsive.sp(context, 12)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(sStr.length, (idx) {
                final ch = sStr[idx];
                final isI = idx == step.i;
                final isPassed = idx < step.i;

                Color borderColor = const Color(0xFF334155);
                Color bgColor = AppTheme.primaryDark;

                if (isI) {
                  borderColor = AppTheme.accentNeonCyan;
                  bgColor = AppTheme.accentNeonCyan.withOpacity(0.25);
                } else if (isPassed) {
                  borderColor = AppTheme.accentGreen;
                  bgColor = AppTheme.accentGreen.withOpacity(0.15);
                }

                return Container(
                  margin: EdgeInsets.only(right: isMobile ? 6 : 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 24,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (isI)
                              const Text('i',
                                  style: TextStyle(
                                      fontSize: 9.5,
                                      color: AppTheme.accentNeonCyan,
                                      fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      Container(
                        width: isMobile ? 42 : 48,
                        padding: EdgeInsets.symmetric(
                            vertical: isMobile ? 8 : 10),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: borderColor,
                            width: isI ? 2.2 : 1.0,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              "'$ch'",
                              style: TextStyle(
                                fontSize: Responsive.sp(
                                    context, isMobile ? 14 : 16),
                                fontWeight: FontWeight.bold,
                                color: isPassed ? AppTheme.accentGreen : Colors.white,
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

          // String t (Source)
          Text(
            isEng ? '2️⃣ Source String t (Pointer j):' : '২️⃣ সোর্স স্ট্রিং t (পয়েন্টার j):',
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
              children: List.generate(tStr.length, (idx) {
                final ch = tStr[idx];
                final isJ = idx == step.j;
                final isMatched = step.matchedInT[idx];

                Color borderColor = isJ
                    ? AppTheme.accentPurple
                    : (isMatched ? AppTheme.accentGreen : const Color(0xFF334155));
                Color bgColor = isJ
                    ? AppTheme.accentPurple.withOpacity(0.25)
                    : (isMatched ? AppTheme.accentGreen.withOpacity(0.15) : AppTheme.primaryDark);

                return Container(
                  margin: EdgeInsets.only(right: isMobile ? 6 : 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 24,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (isJ)
                              const Text('j',
                                  style: TextStyle(
                                      fontSize: 9.5,
                                      color: AppTheme.accentPurple,
                                      fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      Container(
                        width: isMobile ? 42 : 48,
                        padding: EdgeInsets.symmetric(
                            vertical: isMobile ? 8 : 10),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: borderColor,
                            width: isJ ? 2.2 : 1.0,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              "'$ch'",
                              style: TextStyle(
                                fontSize: Responsive.sp(
                                    context, isMobile ? 14 : 16),
                                fontWeight: FontWeight.bold,
                                color: isMatched ? AppTheme.accentGreen : Colors.white,
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
      IsSubsequenceCodeFreeStep step, bool isEng, bool isMobile) {
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
