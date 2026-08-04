import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class MinWindowCodeFreeStep {
  final int left;
  final int right;
  final int formed;
  final int required;
  final String currentWindowStr;
  final String bestWindowStr;
  final int bestLen;
  final String s;
  final String t;
  final String statusType; // 'init', 'expand_right', 'valid_window_shrink', 'finish'
  final String titleEn;
  final String titleBn;
  final String descriptionEn;
  final String descriptionBn;
  final String visualTipEn;
  final String visualTipBn;

  const MinWindowCodeFreeStep({
    required this.left,
    required this.right,
    required this.formed,
    required this.required,
    required this.currentWindowStr,
    required this.bestWindowStr,
    required this.bestLen,
    required this.s,
    required this.t,
    required this.statusType,
    required this.titleEn,
    required this.titleBn,
    required this.descriptionEn,
    required this.descriptionBn,
    required this.visualTipEn,
    required this.visualTipBn,
  });
}

class MinWindowSubstringCodeFreeVisualizer extends StatefulWidget {
  final bool isEnglish;

  const MinWindowSubstringCodeFreeVisualizer({
    super.key,
    required this.isEnglish,
  });

  @override
  State<MinWindowSubstringCodeFreeVisualizer> createState() =>
      _MinWindowSubstringCodeFreeVisualizerState();
}

class _MinWindowSubstringCodeFreeVisualizerState
    extends State<MinWindowSubstringCodeFreeVisualizer> {
  String _rawS = "ADOBECODEBANC";
  String _rawT = "ABC";

  List<MinWindowCodeFreeStep> _steps = [];
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  // Presets
  final List<Map<String, String>> _presets = [
    {
      'label': 's = "ADOBECODEBANC", t = "ABC"',
      's': "ADOBECODEBANC",
      't': "ABC",
    },
    {
      'label': 's = "a", t = "a"',
      's': "a",
      't': "a",
    },
    {
      'label': 's = "a", t = "aa"',
      's': "a",
      't': "aa",
    },
    {
      'label': 's = "OUZODYXAZV", t = "XYZ"',
      's': "OUZODYXAZV",
      't': "XYZ",
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
      _rawS = s;
      _rawT = t;
      _currentStepIndex = 0;
      _generateCodeFreeSteps();
    });
  }

  void _generateCodeFreeSteps() {
    List<MinWindowCodeFreeStep> steps = [];
    String s = _rawS;
    String t = _rawT;

    if (s.isEmpty || t.isEmpty) return;

    Map<String, int> tMap = {};
    for (int i = 0; i < t.length; i++) {
      String ch = t[i];
      tMap[ch] = (tMap[ch] ?? 0) + 1;
    }
    int required = tMap.length;

    Map<String, int> windowMap = {};
    int formed = 0;
    int left = 0;

    int minLen = 999999;
    String bestWindow = "";

    // Initial setup step
    steps.add(MinWindowCodeFreeStep(
      left: 0,
      right: 0,
      formed: 0,
      required: required,
      currentWindowStr: s.isNotEmpty ? s[0] : "",
      bestWindowStr: "",
      bestLen: 0,
      s: s,
      t: t,
      statusType: 'init',
      titleEn: "Step 1: Target Map for '$t' (Required Unique Chars: $required)",
      titleBn: "ধাপ ১: '$t' এর জন্য ফ্রিকোয়েন্সি ম্যাপ তৈরি (ইউনিক অক্ষর প্রয়োজন: $required)",
      descriptionEn:
          "Target string '$t' requires frequency of each character to be satisfied. We expand 'right' to find a valid window and contract 'left' to minimize length.",
      descriptionBn:
          "টার্গেট স্ট্রিং '$t' এর সকল অক্ষরের উপস্থিতি পূরণের জন্য উইন্ডো ডানে (right) বাড়ানো হবে এবং পরে বামে (left) কমিয়ে ছোট করা হবে।",
      visualTipEn: "Sliding Window Strategy: Expand right until valid, then shrink left to find MINIMUM length!",
      visualTipBn: "স্লাইডিং উইন্ডো কৌশল: উইন্ডো ভ্যালিড হওয়া পর্যন্ত ডানে বাড়ান, তারপর ছোট করতে বামে কমান!",
    ));

    int stepNum = 2;

    for (int right = 0; right < s.length; right++) {
      String charR = s[right];
      windowMap[charR] = (windowMap[charR] ?? 0) + 1;

      if (tMap.containsKey(charR) && windowMap[charR] == tMap[charR]) {
        formed++;
      }

      String curWin = s.substring(left, right + 1);

      steps.add(MinWindowCodeFreeStep(
        left: left,
        right: right,
        formed: formed,
        required: required,
        currentWindowStr: curWin,
        bestWindowStr: bestWindow,
        bestLen: minLen == 999999 ? 0 : minLen,
        statusType: 'expand_right',
        s: s,
        t: t,
        titleEn: "Step $stepNum: Expand right to $right ('$charR') → Formed: $formed / $required",
        titleBn: "ধাপ $stepNum: right বাড়িয়ে $right ('$charR') করা হলো → সন্তুষ্ট: $formed / $required",
        descriptionEn:
            "Added '$charR' at index $right. Current window: '$curWin' (length ${curWin.length}). Formed = $formed/$required.",
        descriptionBn:
            "ইনডেক্স $right এ '$charR' যোগ করা হলো। বর্তমান উইন্ডো: '$curWin' (দৈর্ঘ্য ${curWin.length})। সন্তুষ্ট = $formed/$required।",
        visualTipEn: formed == required
            ? "🎉 All target characters satisfied! Now shrinking window from left..."
            : "Expand right further until all target characters of '$t' are included.",
        visualTipBn: formed == required
            ? "🎉 টার্গেটের সকল অক্ষর মিলে গেছে! এবার বামে উইন্ডো ছোট করব..."
            : "টার্গেট '$t' এর সকল অক্ষর অন্তর্ভুক্ত করতে right ডানে সরাতে থাকুন।",
      ));

      while (left <= right && formed == required) {
        curWin = s.substring(left, right + 1);
        int curLen = curWin.length;

        if (curLen < minLen) {
          minLen = curLen;
          bestWindow = curWin;
        }

        steps.add(MinWindowCodeFreeStep(
          left: left,
          right: right,
          formed: formed,
          required: required,
          currentWindowStr: curWin,
          bestWindowStr: bestWindow,
          bestLen: minLen,
          statusType: 'valid_window_shrink',
          s: s,
          t: t,
          titleEn: "Step $stepNum: 🎉 Valid Window '$curWin' (Len $curLen) → Shrink left++ ($left)",
          titleBn: "ধাপ $stepNum: 🎉 ভ্যালিড উইন্ডো '$curWin' (দৈর্ঘ্য $curLen) → left++ ($left) কমান",
          descriptionEn:
              "Window '$curWin' satisfies '$t'! Current minimum best = '$bestWindow' ($minLen). Try shrinking left pointer ($left) to see if a smaller valid window exists.",
          descriptionBn:
              "উইন্ডো '$curWin' টার্গেট '$t' কভার করেছে! এখন পর্যন্ত সর্বনিম্ন = '$bestWindow' ($minLen)। আরও ছোট উইন্ডো খুঁজতে left++ করে ছোট করছি।",
          visualTipEn: "Updated minimum window candidate: '$bestWindow' ($minLen)!",
          visualTipBn: "নতুন ক্ষুদ্রতম সাবস্ট্রিং ক্যান্ডিডেট: '$bestWindow' ($minLen)!",
        ));

        String charL = s[left];
        windowMap[charL] = windowMap[charL]! - 1;
        if (tMap.containsKey(charL) && windowMap[charL]! < tMap[charL]!) {
          formed--;
        }
        left++;
      }
      stepNum++;
    }

    // Finish step
    steps.add(MinWindowCodeFreeStep(
      left: left,
      right: s.length - 1,
      formed: formed,
      required: required,
      currentWindowStr: bestWindow,
      bestWindowStr: bestWindow,
      bestLen: bestWindow.isEmpty ? 0 : bestWindow.length,
      statusType: 'finish',
      s: s,
      t: t,
      titleEn: bestWindow.isNotEmpty
          ? "🎉 SEARCH COMPLETE! Minimum Window = '$bestWindow' (Length $minLen)"
          : "🎉 SEARCH COMPLETE! No Valid Window Substring Found (Output: \"\")",
      titleBn: bestWindow.isNotEmpty
          ? "🎉 সার্চ সম্পূর্ণ! ক্ষুদ্রতম উইন্ডো Substring = '$bestWindow' (দৈর্ঘ্য $minLen)"
          : "🎉 সার্চ সম্পূর্ণ! টার্গেট $t এর কোনো ভ্যালিড সাবস্ট্রিং পাওয়া যায়নি (আউটপুট: \"\")",
      descriptionEn: bestWindow.isNotEmpty
          ? "The smallest substring in '$s' containing all characters of '$t' is '$bestWindow' with length ${bestWindow.length}."
          : "No substring in '$s' contains all characters of '$t'.",
      descriptionBn: bestWindow.isNotEmpty
          ? "'$s' এর মধ্যে '$t' এর সকল অক্ষর ধারণকারী সর্বনিম্ন সাবস্ট্রিং হলো '$bestWindow' (দৈর্ঘ্য ${bestWindow.length})।"
          : "স্ট্রিংটিতে টার্গেটের সকল অক্ষর ধারণকারী কোনো সাবস্ট্রিং নেই।",
      visualTipEn: "✨ Completed in O(|S| + |T|) linear time complexity!",
      visualTipBn: "✨ O(|S| + |T|) রৈখিক সময়াধিক্যে সফলভাবে সম্পন্ন!",
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
        ? MinWindowCodeFreeStep(
            left: 0,
            right: 0,
            formed: 0,
            required: 0,
            currentWindowStr: "",
            bestWindowStr: "",
            bestLen: 0,
            s: _rawS,
            t: _rawT,
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
                    Icons.crop_free_rounded,
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
                                ? 'Minimum Window Substring Intuition'
                                : 'মিনিমাম উইন্ডো সাবস্ট্রিং ভিজ্যুয়াল অ্যানিমেশন',
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
                            ? 'Watch Sliding Window expand right & shrink left to pinpoint the smallest substring containing all characters of t!'
                            : 'কোনো কোড ছাড়াই দেখুন কীভাবে স্লাইডিং উইন্ডো ডানে বাড়িয়ে ও বামে ছোট করে সর্বনিম্ন দৈর্ঘ্যের সাবস্ট্রিং খুঁজে বের করে!',
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
                    _rawS == preset['s'] && _rawT == preset['t'];
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

          // 3. Status Gauge & Target Match Tracker
          _buildStatusGauge(step, isEng, isMobile),
          const SizedBox(height: 20),

          // 4. Sliding Window Character Graphic
          _buildSlidingWindowGraphic(step, isEng, isMobile),
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
      MinWindowCodeFreeStep step, bool isEng, bool isMobile) {
    Color statusColor;
    IconData statusIcon;

    switch (step.statusType) {
      case 'finish':
      case 'valid_window_shrink':
        statusColor = AppTheme.accentGreen;
        statusIcon = Icons.check_circle_rounded;
        break;
      case 'expand_right':
        statusColor = AppTheme.accentNeonCyan;
        statusIcon = Icons.arrow_forward_rounded;
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
                  _buildStatBubble("Target t", "'${step.t}'", AppTheme.accentNeonCyan, isMobile),
                  const SizedBox(width: 10),
                  _buildStatBubble("Chars Formed", "${step.formed} / ${step.required}", AppTheme.accentPurple, isMobile),
                  const SizedBox(width: 10),
                  _buildStatBubble("Best Window", step.bestWindowStr.isEmpty ? "None" : "'${step.bestWindowStr}' (${step.bestLen})", AppTheme.accentGreen, isMobile),
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

  /// Graphic showing String Characters with left & right sliding window bounds
  Widget _buildSlidingWindowGraphic(
      MinWindowCodeFreeStep step, bool isEng, bool isMobile) {
    final s = step.s;

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
                isEng ? 'Sliding Window [left .. right]:' : 'স্লাইডিং উইন্ডো অবস্থান [left .. right]:',
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
                  "Window: [${step.left} .. ${step.right}]",
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
              children: List.generate(s.length, (idx) {
                final ch = s[idx];
                final isLeft = idx == step.left;
                final isRight = idx == step.right;
                final inWindow = idx >= step.left && idx <= step.right;

                Color borderColor = const Color(0xFF334155);
                Color bgColor = AppTheme.primaryDark;

                if (isLeft && isRight) {
                  borderColor = AppTheme.accentGreen;
                  bgColor = AppTheme.accentGreen.withOpacity(0.25);
                } else if (isLeft) {
                  borderColor = AppTheme.accentNeonCyan;
                  bgColor = AppTheme.accentNeonCyan.withOpacity(0.25);
                } else if (isRight) {
                  borderColor = AppTheme.accentPink;
                  bgColor = AppTheme.accentPink.withOpacity(0.25);
                } else if (inWindow) {
                  borderColor = AppTheme.accentPurple;
                  bgColor = AppTheme.accentPurple.withOpacity(0.15);
                }

                List<String> ptrs = [];
                if (isLeft) ptrs.add("L");
                if (isRight) ptrs.add("R");

                return Container(
                  margin: EdgeInsets.only(right: isMobile ? 4 : 6),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 22,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (ptrs.isNotEmpty)
                              Text(
                                ptrs.join('&'),
                                style: TextStyle(
                                  fontSize: Responsive.sp(context, 9),
                                  color: isLeft
                                      ? AppTheme.accentNeonCyan
                                      : AppTheme.accentPink,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Container(
                        width: isMobile ? 38 : 44,
                        padding: EdgeInsets.symmetric(
                            vertical: isMobile ? 8 : 10),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: borderColor,
                            width: (isLeft || isRight) ? 2.0 : 1.0,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              ch,
                              style: TextStyle(
                                fontSize: Responsive.sp(
                                    context, isMobile ? 14 : 16),
                                fontWeight: FontWeight.bold,
                                color: inWindow ? Colors.white : AppTheme.textMuted,
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
      MinWindowCodeFreeStep step, bool isEng, bool isMobile) {
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
