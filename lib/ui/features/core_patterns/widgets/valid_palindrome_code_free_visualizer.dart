import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class PalindromeCodeFreeStep {
  final int left;
  final int right;
  final String statusType; // 'init', 'skip_left', 'skip_right', 'matched', 'mismatch', 'success'
  final String titleEn;
  final String titleBn;
  final String descriptionEn;
  final String descriptionBn;
  final String visualTipEn;
  final String visualTipBn;
  final String leftChar;
  final String rightChar;

  const PalindromeCodeFreeStep({
    required this.left,
    required this.right,
    required this.statusType,
    required this.titleEn,
    required this.titleBn,
    required this.descriptionEn,
    required this.descriptionBn,
    required this.visualTipEn,
    required this.visualTipBn,
    required this.leftChar,
    required this.rightChar,
  });
}

class ValidPalindromeCodeFreeVisualizer extends StatefulWidget {
  final bool isEnglish;

  const ValidPalindromeCodeFreeVisualizer({
    super.key,
    required this.isEnglish,
  });

  @override
  State<ValidPalindromeCodeFreeVisualizer> createState() =>
      _ValidPalindromeCodeFreeVisualizerState();
}

class _ValidPalindromeCodeFreeVisualizerState
    extends State<ValidPalindromeCodeFreeVisualizer> {
  String _inputString = "A man, a plan, a canal: Panama";
  List<PalindromeCodeFreeStep> _steps = [];
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  // Presets
  final List<Map<String, String>> _presets = [
    {
      'label': '"A man, a plan, a canal: Panama"',
      'value': "A man, a plan, a canal: Panama",
    },
    {
      'label': '"race a car"',
      'value': "race a car",
    },
    {
      'label': '"Was it a car or a cat I saw?"',
      'value': "Was it a car or a cat I saw?",
    },
    {
      'label': '"No \'x\' in Nixon"',
      'value': "No 'x' in Nixon",
    },
    {
      'label': '"hello"',
      'value': "hello",
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
      _inputString = str;
      _currentStepIndex = 0;
      _generateCodeFreeSteps();
    });
  }

  bool _isAlphaNumeric(String char) {
    if (char.isEmpty) return false;
    final code = char.codeUnitAt(0);
    return (code >= 48 && code <= 57) || // 0-9
        (code >= 65 && code <= 90) || // A-Z
        (code >= 97 && code <= 122); // a-z
  }

  void _generateCodeFreeSteps() {
    List<PalindromeCodeFreeStep> steps = [];
    String s = _inputString;
    int l = 0;
    int r = s.length - 1;

    // Initial step
    steps.add(PalindromeCodeFreeStep(
      left: l,
      right: r,
      statusType: 'init',
      titleEn: "Step 1: Start Pointers at Both Ends",
      titleBn: "ধাপ ১: শুরু ও শেষ পয়েন্টার বসানো",
      descriptionEn:
          "Left pointer starts at index 0 ('${s[l]}') and Right pointer starts at last index ('${s[r]}').",
      descriptionBn:
          "Left পয়েন্টার ইনডেক্স 0 ('${s[l]}') এবং Right পয়েন্টার শেষ ইনডেক্সে ('${s[r]}') বসানো হলো।",
      visualTipEn: "Compare characters after skipping non-alphanumeric symbols & ignoring casing!",
      visualTipBn: "স্পেস বা পাংকচুয়েশন বাদ দিয়ে এবং অক্ষরের ছোট/বড় হাত উপেক্ষা করে তুলনা শুরু করা যাক!",
      leftChar: s[l],
      rightChar: s[r],
    ));

    bool isPalindrome = true;

    while (l < r) {
      String charL = s[l];
      String charR = s[r];

      // Skip left non-alphanumeric
      if (!_isAlphaNumeric(charL)) {
        steps.add(PalindromeCodeFreeStep(
          left: l,
          right: r,
          statusType: 'skip_left',
          titleEn: "Skip Symbol: '$charL' at Left",
          titleBn: "বাম দিকের সিম্বল '$charL' স্কিপ করুন",
          descriptionEn:
              "'$charL' is not an alphanumeric character. Move Left pointer rightward (left++)!",
          descriptionBn:
              "'$charL' কোনো অক্ষর বা সংখ্যা নয়। তাই Left পয়েন্টার ডানদিকে ১ ধাপ সরান!",
          visualTipEn: "Punctuation/spaces are ignored in valid palindrome checking.",
          visualTipBn: "প্যালিনড্রোম চেক করার সময় স্পেস ও কমা স্কিপ করা হয়।",
          leftChar: charL,
          rightChar: charR,
        ));
        l++;
        continue;
      }

      // Skip right non-alphanumeric
      if (!_isAlphaNumeric(charR)) {
        steps.add(PalindromeCodeFreeStep(
          left: l,
          right: r,
          statusType: 'skip_right',
          titleEn: "Skip Symbol: '$charR' at Right",
          titleBn: "ডান দিকের সিম্বল '$charR' স্কিপ করুন",
          descriptionEn:
              "'$charR' is not an alphanumeric character. Move Right pointer leftward (right--)!",
          descriptionBn:
              "'$charR' কোনো অক্ষর বা সংখ্যা নয়। তাই Right পয়েন্টার বামদিকে ১ ধাপ সরান!",
          visualTipEn: "Punctuation/spaces are ignored in valid palindrome checking.",
          visualTipBn: "প্যালিনড্রোম চেক করার সময় স্পেস ও কমা স্কিপ করা হয়।",
          leftChar: charL,
          rightChar: charR,
        ));
        r--;
        continue;
      }

      // Compare lowercase
      if (charL.toLowerCase() == charR.toLowerCase()) {
        steps.add(PalindromeCodeFreeStep(
          left: l,
          right: r,
          statusType: 'matched',
          titleEn: "Match: '$charL' == '$charR'",
          titleBn: "অক্ষর মিলেছে: '$charL' == '$charR'",
          descriptionEn:
              "Both characters '${charL.toUpperCase()}' match! Move both pointers inward (left++, right--).",
          descriptionBn:
              "উভয় অক্ষর '${charL.toUpperCase()}' পরস্পর মিলে গেছে! উভয় পয়েন্টার ভেতরের দিকে সরান।",
          visualTipEn: "Case-insensitive match! Symmetry holds so far.",
          visualTipBn: "অক্ষরের সাইজ বাদ দিয়ে সমতা বজায় রয়েছে।",
          leftChar: charL,
          rightChar: charR,
        ));
        l++;
        r--;
      } else {
        isPalindrome = false;
        steps.add(PalindromeCodeFreeStep(
          left: l,
          right: r,
          statusType: 'mismatch',
          titleEn: "❌ Mismatch: '$charL' != '$charR'",
          titleBn: "❌ অমিল: '$charL' != '$charR'",
          descriptionEn:
              "Character '$charL' at index $l does NOT match '$charR' at index $r. This string is NOT a valid palindrome!",
          descriptionBn:
              "ইনডেক্স $l এর অক্ষর '$charL' এবং ইনডেক্স $r এর অক্ষর '$charR' মিলেনি। এটি একটি ভ্যালিড প্যালিনড্রোম নয়!",
          visualTipEn: "First mismatch breaks symmetry completely!",
          visualTipBn: "একটি অমিল পেলেই সম্পূর্ণ স্ট্রিংটি প্যালিনড্রোম হওয়া থেকে বাতিল হয়ে যায়।",
          leftChar: charL,
          rightChar: charR,
        ));
        break;
      }
    }

    if (isPalindrome) {
      steps.add(PalindromeCodeFreeStep(
        left: l,
        right: r,
        statusType: 'success',
        titleEn: "🎉 VALID PALINDROME!",
        titleBn: "🎉 এটি একটি ভ্যালিড প্যালিনড্রোম!",
        descriptionEn:
            "All alphanumeric characters matched symmetrically from both ends to center!",
        descriptionBn:
            "উভয় প্রান্ত থেকে কেন্দ্র পর্যন্ত প্রতিটি বর্ণ ও সংখ্যা নিখুঁতভাবে মিলে গেছে!",
        visualTipEn: "✨ Perfect symmetry! Reading forward or backward gives the exact same result.",
        visualTipBn: "✨ সোজা বা উল্টো যেভাবেই পড়া হোক, একই স্ট্রিং পাওয়া যায়।",
        leftChar: l < s.length ? s[l] : "",
        rightChar: r >= 0 ? s[r] : "",
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
        ? const PalindromeCodeFreeStep(
            left: 0,
            right: 0,
            statusType: 'init',
            titleEn: '',
            titleBn: '',
            descriptionEn: '',
            descriptionBn: '',
            visualTipEn: '',
            visualTipBn: '',
            leftChar: '',
            rightChar: '',
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
          // 1. Banner Header (Zero Code)
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
                                ? 'Valid Palindrome Intuition'
                                : 'ভ্যালিড প্যালিনড্রোম ভিজ্যুয়াল গাইড',
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
                            ? 'Watch how two pointers scan from both ends to center while skipping punctuation and comparing characters!'
                            : 'কোনো কোড ছাড়াই দেখুন কীভাবে টু-পয়েন্টার উভয় প্রান্ত থেকে চিহ্নাদি স্কিপ করে ও বর্ণগুলো মিলিয়ে কেন্দ্রের দিকে এগোয়!',
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
            isEng ? '🎯 Choose a Preset String:' : '🎯 উদাহরণ স্ট্রিং বেছে নিন:',
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
                final isSelected = _inputString == preset['value'];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(
                      preset['label']!,
                      style: TextStyle(
                        fontSize: Responsive.sp(context, 11.5),
                        color: isSelected ? Colors.white : AppTheme.textSecondary,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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
                        _loadPreset(preset['value']!);
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),

          // 3. Dynamic Comparison Gauge
          _buildComparisonGauge(step, isEng, isMobile),
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

  /// Visual Comparison Gauge
  Widget _buildComparisonGauge(
      PalindromeCodeFreeStep step, bool isEng, bool isMobile) {
    Color statusColor;
    IconData statusIcon;

    switch (step.statusType) {
      case 'success':
        statusColor = AppTheme.accentGreen;
        statusIcon = Icons.check_circle_rounded;
        break;
      case 'matched':
        statusColor = AppTheme.accentNeonCyan;
        statusIcon = Icons.rule_folder_rounded;
        break;
      case 'skip_left':
      case 'skip_right':
        statusColor = AppTheme.accentAmber;
        statusIcon = Icons.redo_rounded;
        break;
      case 'mismatch':
        statusColor = Colors.redAccent;
        statusIcon = Icons.cancel_rounded;
        break;
      default:
        statusColor = AppTheme.accentPurple;
        statusIcon = Icons.straighten_rounded;
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
          // Header gauge label
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

          // Visual Character Match Capsule Display
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
                    label: "Left Char",
                    val: step.leftChar,
                    color: AppTheme.accentNeonCyan,
                    isMobile: isMobile,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: isMobile ? 10 : 16),
                    child: Text(
                      step.statusType == 'mismatch' ? "!=" : "==",
                      style: TextStyle(
                        color: statusColor,
                        fontSize: Responsive.sp(context, isMobile ? 18 : 22),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _buildCharBubble(
                    label: "Right Char",
                    val: step.rightChar,
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
    required String val,
    required Color color,
    required bool isMobile,
  }) {
    final displayVal = val == ' ' ? '␣' : val;
    final isAlpha = _isAlphaNumeric(val);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 16,
        vertical: isMobile ? 6 : 10,
      ),
      decoration: BoxDecoration(
        color: isAlpha ? color.withOpacity(0.15) : AppTheme.accentAmber.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isAlpha ? color : AppTheme.accentAmber, width: 1.5),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: Responsive.sp(context, 10),
              color: isAlpha ? color : AppTheme.accentAmber,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            "'$displayVal'",
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

  /// Character Array Graphic showing active pointers
  Widget _buildCharacterArrayGraphic(
      PalindromeCodeFreeStep step, bool isEng, bool isMobile) {
    final s = _inputString;

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
              isEng ? '🔤 String Characters & Pointers' : '🔤 স্ট্রিংয়ের অক্ষর ও পয়েন্টারের অবস্থান',
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
                _buildLegendItem("Left (L)", AppTheme.accentNeonCyan),
                _buildLegendItem("Right (R)", AppTheme.accentPurple),
                _buildLegendItem(isEng ? "Non-Alphanumeric" : "সিম্বল/স্পেস", AppTheme.accentAmber),
              ],
            ),
          ] else ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isEng ? '🔤 String Characters & Pointers' : '🔤 স্ট্রিংয়ের অক্ষর ও পয়েন্টারের অবস্থান',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: Responsive.sp(context, 14),
                  ),
                ),
                Row(
                  children: [
                    _buildLegendItem("Left (L)", AppTheme.accentNeonCyan),
                    const SizedBox(width: 10),
                    _buildLegendItem("Right (R)", AppTheme.accentPurple),
                    const SizedBox(width: 10),
                    _buildLegendItem(isEng ? "Non-Alphanumeric" : "সিম্বল/স্পেস", AppTheme.accentAmber),
                  ],
                ),
              ],
            ),
          ],
          const SizedBox(height: 16),

          // Scrollable Character Cards
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(s.length, (idx) {
                final char = s[idx];
                final displayChar = char == ' ' ? '␣' : char;
                final isLeft = idx == step.left;
                final isRight = idx == step.right;
                final isAlpha = _isAlphaNumeric(char);
                final isPassed = idx < step.left || idx > step.right;

                Color borderColor = const Color(0xFF334155);
                Color bgColor = AppTheme.primaryDark;

                if (isLeft && isRight) {
                  borderColor = AppTheme.accentAmber;
                  bgColor = AppTheme.accentAmber.withOpacity(0.25);
                } else if (isLeft) {
                  borderColor = AppTheme.accentNeonCyan;
                  bgColor = AppTheme.accentNeonCyan.withOpacity(0.2);
                } else if (isRight) {
                  borderColor = AppTheme.accentPurple;
                  bgColor = AppTheme.accentPurple.withOpacity(0.2);
                } else if (!isAlpha) {
                  borderColor = AppTheme.accentAmber.withOpacity(0.4);
                  bgColor = AppTheme.accentAmber.withOpacity(0.08);
                } else if (isPassed) {
                  borderColor = Colors.transparent;
                  bgColor = const Color(0xFF0F172A).withOpacity(0.4);
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
                            if (isLeft && isRight)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                decoration: BoxDecoration(
                                  color: AppTheme.accentAmber,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'L&R',
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              )
                            else if (isLeft)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                decoration: BoxDecoration(
                                  color: AppTheme.accentNeonCyan,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'Left',
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              )
                            else if (isRight)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                decoration: BoxDecoration(
                                  color: AppTheme.accentPurple,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'Right',
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            if (isLeft || isRight)
                              Icon(
                                Icons.arrow_drop_down,
                                color: isLeft ? AppTheme.accentNeonCyan : AppTheme.accentPurple,
                                size: 16,
                              ),
                          ],
                        ),
                      ),

                      // Card Body
                      Opacity(
                        opacity: isPassed ? 0.35 : 1.0,
                        child: AnimatedScale(
                          scale: (isLeft || isRight) ? 1.08 : 1.0,
                          duration: const Duration(milliseconds: 250),
                          child: Container(
                            width: isMobile ? 45 : 52,
                            padding: EdgeInsets.symmetric(vertical: isMobile ? 8 : 10),
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
                                Text(
                                  displayChar,
                                  style: TextStyle(
                                    fontSize: Responsive.sp(context, isMobile ? 15 : 17),
                                    fontWeight: FontWeight.bold,
                                    color: isAlpha
                                        ? Colors.white
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
      PalindromeCodeFreeStep step, bool isEng, bool isMobile) {
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
