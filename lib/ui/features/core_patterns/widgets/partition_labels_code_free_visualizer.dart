import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class PartitionCodeFreeStep {
  final int currentIndex;
  final String currentChar;
  final int charLastIndex;
  final int start;
  final int end;
  final String currentString;
  final List<int> partitionSizes;
  final List<String> partitionSubstrings;
  final String statusType; // 'init', 'expand_window', 'cut_partition', 'finish'
  final String titleEn;
  final String titleBn;
  final String descriptionEn;
  final String descriptionBn;
  final String visualTipEn;
  final String visualTipBn;

  const PartitionCodeFreeStep({
    required this.currentIndex,
    required this.currentChar,
    required this.charLastIndex,
    required this.start,
    required this.end,
    required this.currentString,
    required this.partitionSizes,
    required this.partitionSubstrings,
    required this.statusType,
    required this.titleEn,
    required this.titleBn,
    required this.descriptionEn,
    required this.descriptionBn,
    required this.visualTipEn,
    required this.visualTipBn,
  });
}

class PartitionLabelsCodeFreeVisualizer extends StatefulWidget {
  final bool isEnglish;

  const PartitionLabelsCodeFreeVisualizer({
    super.key,
    required this.isEnglish,
  });

  @override
  State<PartitionLabelsCodeFreeVisualizer> createState() =>
      _PartitionLabelsCodeFreeVisualizerState();
}

class _PartitionLabelsCodeFreeVisualizerState
    extends State<PartitionLabelsCodeFreeVisualizer> {
  String _rawString = "ababcbacadefegdehijhklij";

  List<PartitionCodeFreeStep> _steps = [];
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  // Presets
  final List<Map<String, String>> _presets = [
    {
      'label': '"ababcbacadefegdehijhklij"',
      'string': "ababcbacadefegdehijhklij",
    },
    {
      'label': '"eccbbbbdec"',
      'string': "eccbbbbdec",
    },
    {
      'label': '"abcab"',
      'string': "abcab",
    },
    {
      'label': '"a"',
      'string': "a",
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

  void _loadPreset(String str) {
    _timer?.cancel();
    setState(() {
      _isPlaying = false;
      _rawString = str;
      _currentStepIndex = 0;
      _generateCodeFreeSteps();
    });
  }

  void _generateCodeFreeSteps() {
    List<PartitionCodeFreeStep> steps = [];
    String s = _rawString;
    int n = s.length;

    if (n == 0) return;

    // Build last index map
    Map<String, int> lastIdx = {};
    for (int i = 0; i < n; i++) {
      lastIdx[s[i]] = i;
    }

    int start = 0;
    int end = 0;
    List<int> sizes = [];
    List<String> substrings = [];

    // Initial setup step
    steps.add(PartitionCodeFreeStep(
      currentIndex: 0,
      currentChar: s[0],
      charLastIndex: lastIdx[s[0]]!,
      start: 0,
      end: lastIdx[s[0]]!,
      currentString: s,
      partitionSizes: [],
      partitionSubstrings: [],
      statusType: 'init',
      titleEn: "Step 1: Compute Last Occurrence Map & Init start = 0",
      titleBn: "ধাপ ১: প্রতিটি অক্ষরের শেষ অবস্থান বের করুন ও start = 0 সেট করুন",
      descriptionEn:
          "String: '$s'. First char '${s[0]}' ends at index ${lastIdx[s[0]]}. Initial partition window set to [0 ... ${lastIdx[s[0]]}].",
      descriptionBn:
          "স্ট্রিং: '$s'। প্রথম অক্ষর '${s[0]}' এর শেষ অবস্থান ইনডেক্স ${lastIdx[s[0]]}। প্রথম পার্টিশন উইন্ডো [0 ... ${lastIdx[s[0]]}]।",
      visualTipEn: "Greedy Window: Expand boundary 'end' to max last-occurrence of any character inside the window!",
      visualTipBn: "গ্রিডি উইন্ডো: উইন্ডোর ভেতরে থাকা যেকোনো অক্ষরের শেষ অবস্থান অনুযায়ী 'end' ডানে বাড়ান!",
    ));

    int stepNum = 2;

    for (int i = 0; i < n; i++) {
      String ch = s[i];
      int last = lastIdx[ch]!;
      int oldEnd = end;

      if (last > end) {
        end = last;
        steps.add(PartitionCodeFreeStep(
          currentIndex: i,
          currentChar: ch,
          charLastIndex: last,
          start: start,
          end: end,
          currentString: s,
          partitionSizes: List.from(sizes),
          partitionSubstrings: List.from(substrings),
          statusType: 'expand_window',
          titleEn: "Step $stepNum: Index $i ('$ch') → Last Seen at $last > $oldEnd → Expand Window end = $end",
          titleBn: "ধাপ $stepNum: ইনডেক্স $i ('$ch') → শেষ দেখা $last > $oldEnd → উইন্ডো বৃদ্ধি end = $end",
          descriptionEn:
              "Character '$ch' at index $i appears further at index $last. Expand partition boundary 'end' to $end.",
          descriptionBn:
              "ইনডেক্স $i এর অক্ষর '$ch' এর শেষ অবস্থান $last। পার্টিশন সীমানা 'end' বাড়াই $end পর্যন্ত।",
          visualTipEn: "Window expanded to include all occurrences of '$ch'!",
          visualTipBn: "'$ch' এর সকল উপস্থিতি অন্তর্ভুক্ত করতে উইন্ডো বড় হলো!",
        ));
      }

      if (i == end) {
        int partLen = end - start + 1;
        String sub = s.substring(start, end + 1);
        sizes.add(partLen);
        substrings.add(sub);

        steps.add(PartitionCodeFreeStep(
          currentIndex: i,
          currentChar: ch,
          charLastIndex: last,
          start: start,
          end: end,
          currentString: s,
          partitionSizes: List.from(sizes),
          partitionSubstrings: List.from(substrings),
          statusType: 'cut_partition',
          titleEn: "Step $stepNum: Reached End (i == end == $end) 🎉 Cut Partition '$sub' (Length $partLen)",
          titleBn: "ধাপ $stepNum: উইন্ডো শেষ (i == end == $end) 🎉 পার্টিশন কর্তন '$sub' (দৈর্ঘ্য $partLen)",
          descriptionEn:
              "Reached end of window at index $i! No characters in '$sub' appear past index $i. Partition complete! Next start = ${i + 1}.",
          descriptionBn:
              "ইনডেক্স $i এ পার্টিশন উইন্ডো পূর্ণ হলো! '$sub' এর কোনো অক্ষর এর বাইরে নেই। পরবর্তী উইন্ডো শুরু হবে ইনডেক্স ${i + 1} থেকে।",
          visualTipEn: "🎉 Valid Partition Cut! All letters contained inside this segment.",
          visualTipBn: "🎉 সফল পার্টিশন! এই টুকরোর সকল অক্ষর এর ভেতরেই সীমাবদ্ধ।",
        ));

        start = i + 1;
      }
      stepNum++;
    }

    // Finish step
    steps.add(PartitionCodeFreeStep(
      currentIndex: n - 1,
      currentChar: s[n - 1],
      charLastIndex: n - 1,
      start: start,
      end: n - 1,
      currentString: s,
      partitionSizes: List.from(sizes),
      partitionSubstrings: List.from(substrings),
      statusType: 'finish',
      titleEn: "🎉 PARTITION COMPLETE! Result Sizes = [${sizes.join(', ')}]",
      titleBn: "🎉 পার্টিশন সম্পূর্ণ! প্রাপ্ত সাইজ তালিকা = [${sizes.join(', ')}]",
      descriptionEn:
          "Successfully split '$s' into ${sizes.length} optimal partitions: ${substrings.map((e) => "'$e' (${e.length})").join(', ')}.",
      descriptionBn:
          "সফলভাবে '$s' কে ${sizes.length} টি পার্টিশনে বিভক্ত করা হলো!",
      visualTipEn: "✨ Completed in O(N) linear time and O(1) space!",
      visualTipBn: "✨ O(N) সময়ে সফলভাবে বিভক্ত করা হলো!",
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
        ? PartitionCodeFreeStep(
            currentIndex: 0,
            currentChar: _rawString.isNotEmpty ? _rawString[0] : '',
            charLastIndex: 0,
            start: 0,
            end: 0,
            currentString: _rawString,
            partitionSizes: [],
            partitionSubstrings: [],
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
                    Icons.content_cut_rounded,
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
                                ? 'Partition Labels Intuition'
                                : 'পার্টিশন লেবেলস ভিজ্যুয়াল অ্যানিমেশন',
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
                            ? 'Watch Greedy Window expansion dynamically group characters into maximum valid non-overlapping partitions!'
                            : 'কোনো কোড ছাড়াই দেখুন কীভাবে গ্রিডি উইন্ডো প্রসারণের মাধ্যমে স্ট্রিংকে সর্বোচ্চ ভ্যালিড ডুপ্লিকেটমুক্ত পার্টিশনে ভাগ করা হয়!',
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
                final isSelected = _rawString == preset['string'];
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
                        _loadPreset(preset['string']!);
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),

          // 3. Status Gauge & Completed Partitions
          _buildStatusGauge(step, isEng, isMobile),
          const SizedBox(height: 20),

          // 4. String Character Window Graphic
          _buildCharacterWindowGraphic(step, isEng, isMobile),
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
      PartitionCodeFreeStep step, bool isEng, bool isMobile) {
    Color statusColor;
    IconData statusIcon;

    switch (step.statusType) {
      case 'finish':
      case 'cut_partition':
        statusColor = AppTheme.accentGreen;
        statusIcon = Icons.content_cut_rounded;
        break;
      case 'expand_window':
        statusColor = AppTheme.accentAmber;
        statusIcon = Icons.open_in_full_rounded;
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
                  _buildStatBubble("Current Index (i)", "${step.currentIndex} ('${step.currentChar}')", AppTheme.accentNeonCyan, isMobile),
                  const SizedBox(width: 10),
                  _buildStatBubble("Window [start..end]", "[${step.start} .. ${step.end}]", AppTheme.accentPurple, isMobile),
                  const SizedBox(width: 10),
                  _buildStatBubble("Partitions Cut", "${step.partitionSizes.length}", AppTheme.accentGreen, isMobile),
                ],
              ),
            ),
          ),
          if (step.partitionSubstrings.isNotEmpty) ...[
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: List.generate(step.partitionSubstrings.length, (idx) {
                  final sub = step.partitionSubstrings[idx];
                  final len = step.partitionSizes[idx];
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.accentGreen.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.accentGreen),
                    ),
                    child: Text(
                      "'$sub' ($len)",
                      style: TextStyle(
                          color: AppTheme.accentGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: Responsive.sp(context, 11)),
                    ),
                  );
                }),
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

  /// Graphic showing String Characters with start & end window bounds
  Widget _buildCharacterWindowGraphic(
      PartitionCodeFreeStep step, bool isEng, bool isMobile) {
    final s = step.currentString;

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
                isEng ? 'String Window Partition Track:' : 'স্ট্রিং পার্টিশন উইন্ডো অবস্থান:',
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
                  "Window: [${step.start} .. ${step.end}]",
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
                final isCurrent = idx == step.currentIndex;
                final inWindow = idx >= step.start && idx <= step.end;
                final isStart = idx == step.start;
                final isEnd = idx == step.end;

                Color borderColor = const Color(0xFF334155);
                Color bgColor = AppTheme.primaryDark;

                if (isCurrent) {
                  borderColor = AppTheme.accentPink;
                  bgColor = AppTheme.accentPink.withOpacity(0.3);
                } else if (isStart || isEnd) {
                  borderColor = AppTheme.accentNeonCyan;
                  bgColor = AppTheme.accentNeonCyan.withOpacity(0.25);
                } else if (inWindow) {
                  borderColor = AppTheme.accentPurple;
                  bgColor = AppTheme.accentPurple.withOpacity(0.15);
                }

                List<String> ptrs = [];
                if (isCurrent) ptrs.add("i");
                if (isStart) ptrs.add("start");
                if (isEnd) ptrs.add("end");

                return Container(
                  margin: EdgeInsets.only(right: isMobile ? 4 : 6),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 24,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (ptrs.isNotEmpty)
                              Text(
                                ptrs.join('&'),
                                style: TextStyle(
                                  fontSize: Responsive.sp(context, 9),
                                  color: isCurrent
                                      ? AppTheme.accentPink
                                      : AppTheme.accentNeonCyan,
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
                            width: (isCurrent || isStart || isEnd) ? 2.0 : 1.0,
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
      PartitionCodeFreeStep step, bool isEng, bool isMobile) {
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
