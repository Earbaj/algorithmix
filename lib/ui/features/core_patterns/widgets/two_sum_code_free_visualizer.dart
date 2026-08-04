import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class CodeFreeStep {
  final int left;
  final int right;
  final int sum;
  final String statusType; // 'init', 'too_small', 'too_big', 'matched', 'no_match'
  final String titleEn;
  final String titleBn;
  final String descriptionEn;
  final String descriptionBn;
  final String visualTipEn;
  final String visualTipBn;

  const CodeFreeStep({
    required this.left,
    required this.right,
    required this.sum,
    required this.statusType,
    required this.titleEn,
    required this.titleBn,
    required this.descriptionEn,
    required this.descriptionBn,
    required this.visualTipEn,
    required this.visualTipBn,
  });
}

class TwoSumCodeFreeVisualizer extends StatefulWidget {
  final bool isEnglish;

  const TwoSumCodeFreeVisualizer({
    super.key,
    required this.isEnglish,
  });

  @override
  State<TwoSumCodeFreeVisualizer> createState() => _TwoSumCodeFreeVisualizerState();
}

class _TwoSumCodeFreeVisualizerState extends State<TwoSumCodeFreeVisualizer>
    with SingleTickerProviderStateMixin {
  // Active Preset Data
  List<int> _array = [2, 7, 11, 15];
  int _target = 9;

  // Animation & Steps State
  List<CodeFreeStep> _steps = [];
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  // Presets
  final List<Map<String, dynamic>> _presets = [
    {
      'label': '[2, 7, 11, 15] (Target: 9)',
      'array': [2, 7, 11, 15],
      'target': 9,
    },
    {
      'label': '[1, 3, 4, 6, 8, 11, 15] (Target: 10)',
      'array': [1, 3, 4, 6, 8, 11, 15],
      'target': 10,
    },
    {
      'label': '[2, 3, 4, 7, 11, 12] (Target: 15)',
      'array': [2, 3, 4, 7, 11, 12],
      'target': 15,
    },
    {
      'label': '[-4, -1, 1, 3, 5, 8] (Target: 4)',
      'array': [-4, -1, 1, 3, 5, 8],
      'target': 4,
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
      _array = List.from(arr);
      _target = target;
      _currentStepIndex = 0;
      _generateCodeFreeSteps();
    });
  }

  void _generateCodeFreeSteps() {
    List<CodeFreeStep> steps = [];
    int l = 0;
    int r = _array.length - 1;

    // Step 0: Start Pointers
    steps.add(CodeFreeStep(
      left: l,
      right: r,
      sum: _array[l] + _array[r],
      statusType: 'init',
      titleEn: "Step 1: Place Pointers at Both Ends",
      titleBn: "ধাপ ১: দুই প্রান্তে পয়েন্টার বসানো",
      descriptionEn:
          "Since the array is sorted, Left pointer starts at the smallest element (${_array[l]}) and Right pointer starts at the largest element (${_array[r]}).",
      descriptionBn:
          "যেহেতু অ্যারে সর্টেড, Left পয়েন্টার ক্ষুদ্রতম মানে (${_array[l]}) এবং Right পয়েন্টার বৃহত্তম মানে (${_array[r]}) বসানো হলো।",
      visualTipEn: "Search target is $_target. Let's compare their sum!",
      visualTipBn: "কাঙ্ক্ষিত টার্গেট হলো $_target। চলুন যোগফল মেপে দেখা যাক!",
    ));

    while (l < r) {
      int sum = _array[l] + _array[r];

      if (sum == _target) {
        steps.add(CodeFreeStep(
          left: l,
          right: r,
          sum: sum,
          statusType: 'matched',
          titleEn: "🎉 TARGET MATCHED!",
          titleBn: "🎉 টার্গেট সম্পূর্ণ মিলে গেছে!",
          descriptionEn:
              "The pair (${_array[l]} + ${_array[r]}) gives exactly $_target! Solution found at 1-based indices [${l + 1}, ${r + 1}].",
          descriptionBn:
              "জোড়া (${_array[l]} + ${_array[r]}) যোগ করলে ঠিক $_target পাওয়া যায়! ১-ভিত্তিক ইনডেক্স [${l + 1}, ${r + 1}] সমাধান।",
          visualTipEn: "✨ Perfect balance achieved! No more pointer moves needed.",
          visualTipBn: "✨ একদম নিখুঁত সমতা অর্জিত হয়েছে! আর পয়েন্টার সরানোর প্রয়োজন নেই।",
        ));
        break;
      } else if (sum < _target) {
        steps.add(CodeFreeStep(
          left: l,
          right: r,
          sum: sum,
          statusType: 'too_small',
          titleEn: "Sum ($sum) < Target ($_target) ➔ TOO SMALL",
          titleBn: "যোগফল ($sum) < টার্গেট ($_target) ➔ খুব ছোট",
          descriptionEn:
              "Current sum ($sum) is smaller than target ($_target). To INCREASE the sum, shift the Left pointer 1 step to the right! (Element ${_array[l]} is too small).",
          descriptionBn:
              "বর্তমান যোগফল ($sum) টার্গেট ($_target) এর চেয়ে ছোট। যোগফল বাড়াতে Left পয়েন্টার ১ ধাপ ডানে সরান! (উপাদান ${_array[l]} ছোট)।",
          visualTipEn:
              "💡 Intuition: Since array is sorted, moving Right pointer left would only DECREASE the sum. So we MUST move Left pointer right!",
          visualTipBn:
              "💡 ভিজ্যুয়াল লজিক: অ্যারে সর্টেড হওয়ায় Right বামে নিলে যোগফল আরও কমবে। তাই যোগফল বাড়াতে Left ডানে সরানো ছাড়া উপায় নেই!",
        ));
        l++;
      } else {
        steps.add(CodeFreeStep(
          left: l,
          right: r,
          sum: sum,
          statusType: 'too_big',
          titleEn: "Sum ($sum) > Target ($_target) ➔ TOO LARGE",
          titleBn: "যোগফল ($sum) > টার্গেট ($_target) ➔ খুব বড়",
          descriptionEn:
              "Current sum ($sum) is larger than target ($_target). To DECREASE the sum, shift the Right pointer 1 step to the left! (Element ${_array[r]} is too large).",
          descriptionBn:
              "বর্তমান যোগফল ($sum) টার্গেট ($_target) এর চেয়ে বড়। যোগফল কমাতে Right পয়েন্টার ১ ধাপ বামে সরান! (উপাদান ${_array[r]} বড়)।",
          visualTipEn:
              "💡 Intuition: Since array is sorted, moving Left pointer right would only INCREASE the sum. So we MUST move Right pointer left!",
          visualTipBn:
              "💡 ভিজ্যুয়াল লজিক: অ্যারে সর্টেড হওয়ায় Left ডানে নিলে যোগফল আরও বাড়বে। তাই যোগফল কমাতে Right বামে সরানো ছাড়া উপায় নেই!",
        ));
        r--;
      }
    }

    if (steps.isEmpty || steps.last.statusType != 'matched') {
      steps.add(CodeFreeStep(
        left: l,
        right: r,
        sum: 0,
        statusType: 'no_match',
        titleEn: "❌ No Pair Found",
        titleBn: "❌ কোনো সমাধান পাওয়া যায়নি",
        descriptionEn: "Pointers crossed without finding any pair that sums up to $_target.",
        descriptionBn: "পয়েন্টারদ্বয় পরস্পরকে অতিক্রম করেছে কিন্তু কোনো জোড়া পাওয়া যায়নি।",
        visualTipEn: "Try another test case or custom target!",
        visualTipBn: "অন্য টেস্ট কেস সিলেক্ট করে আবার ট্রাই করুন!",
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
        ? CodeFreeStep(
            left: 0,
            right: 0,
            sum: 0,
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
          // 1. Zero Code Banner Header (Responsive)
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
                            isEng ? 'Pure Visual Intuition' : 'সম্পূর্ণ কোডহীন ভিজ্যুয়াল অ্যানিমেশন',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: Responsive.sp(context, 16),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
                            ? 'No complex code syntax! Watch how two pointers dynamically search and eliminate elements in a sorted array.'
                            : 'কোনো জটিল কোড ছাড়াই দেখুন কীভাবে সর্টেড অ্যারেতে টু-পয়েন্টার উপাদান চিহ্নিত ও বাদ দিয়ে কাঙ্ক্ষিত যোগফল খুঁজে পায়।',
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
            isEng ? '🎯 Choose a Test Case:' : '🎯 টেস্ট কেস বেছে নিন:',
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
                    _target == preset['target'] && _array.length == (preset['array'] as List).length;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(
                      preset['label'],
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
                        color: isSelected ? AppTheme.accentNeonCyan : const Color(0xFF334155),
                      ),
                    ),
                    onSelected: (val) {
                      if (val) {
                        _loadPreset(preset['array'], preset['target']);
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),

          // 3. Dynamic Balance Scale / Gauge Visualizer (Responsive)
          _buildBalanceGauge(step, isEng, isMobile),
          const SizedBox(height: 20),

          // 4. Pointer-Array Graphic Box (Responsive)
          _buildAnimatedArrayGraphic(step, isEng, isMobile),
          const SizedBox(height: 20),

          // 5. Interactive Playback Controls (Responsive)
          _buildPlaybackControls(isEng, isMobile),
          const SizedBox(height: 20),

          // 6. Visual Explanation Card (Intuition Focus)
          _buildIntuitionExplanationCard(step, isEng, isMobile),
        ],
      ),
    );
  }

  /// Visual Balance Gauge showing target comparison visually
  Widget _buildBalanceGauge(CodeFreeStep step, bool isEng, bool isMobile) {
    Color statusColor;
    IconData statusIcon;

    switch (step.statusType) {
      case 'matched':
        statusColor = AppTheme.accentGreen;
        statusIcon = Icons.check_circle_rounded;
        break;
      case 'too_small':
        statusColor = AppTheme.accentAmber;
        statusIcon = Icons.arrow_circle_up_rounded;
        break;
      case 'too_big':
        statusColor = AppTheme.accentPink;
        statusIcon = Icons.arrow_circle_down_rounded;
        break;
      case 'no_match':
        statusColor = Colors.redAccent;
        statusIcon = Icons.cancel_rounded;
        break;
      default:
        statusColor = AppTheme.accentNeonCyan;
        statusIcon = Icons.tune_rounded;
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
          // Header gauge label - Responsive layout for mobile vs desktop
          if (isMobile)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryDark,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFF334155)),
                      ),
                      child: Text(
                        "Target = $_target",
                        style: TextStyle(
                          color: AppTheme.accentNeonCyan,
                          fontWeight: FontWeight.bold,
                          fontSize: Responsive.sp(context, 12),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
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
                          fontSize: Responsive.sp(context, 13.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(statusIcon, color: statusColor, size: Responsive.sp(context, 20)),
                    const SizedBox(width: 8),
                    Text(
                      isEng ? step.titleEn : step.titleBn,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: Responsive.sp(context, 14.5),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryDark,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF334155)),
                  ),
                  child: Text(
                    "Target = $_target",
                    style: TextStyle(
                      color: AppTheme.accentNeonCyan,
                      fontWeight: FontWeight.bold,
                      fontSize: Responsive.sp(context, 12),
                    ),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 16),

          // Visual Combination Orb Display (Scrollable horizontally on very small screens)
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
                  // Left value capsule
                  _buildValueBubble(
                    label: "Left Ptr",
                    val: _array[step.left],
                    color: AppTheme.accentNeonCyan,
                    isMobile: isMobile,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: isMobile ? 8 : 12),
                    child: Text(
                      "+",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: Responsive.sp(context, isMobile ? 18 : 22),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Right value capsule
                  _buildValueBubble(
                    label: "Right Ptr",
                    val: _array[step.right],
                    color: AppTheme.accentPurple,
                    isMobile: isMobile,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: isMobile ? 8 : 12),
                    child: Text(
                      "=",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: Responsive.sp(context, isMobile ? 18 : 22),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Sum capsule
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 12 : 16,
                      vertical: isMobile ? 8 : 10,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: statusColor, width: 2),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Sum",
                          style: TextStyle(
                            fontSize: Responsive.sp(context, 10),
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "${step.sum}",
                          style: TextStyle(
                            fontSize: Responsive.sp(context, isMobile ? 17 : 20),
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                          ),
                        ),
                      ],
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

  Widget _buildValueBubble({
    required String label,
    required int val,
    required Color color,
    required bool isMobile,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 10 : 14,
        vertical: isMobile ? 6 : 8,
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
            "$val",
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

  /// Animated Array Graphic showing active pointers and eliminated items
  Widget _buildAnimatedArrayGraphic(CodeFreeStep step, bool isEng, bool isMobile) {
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
          // Responsive Header: Stack legends below title on mobile
          if (isMobile) ...[
            Text(
              isEng ? '📊 Array & Pointer Positions' : '📊 অ্যারে ও পয়েন্টারের বর্তমান অবস্থান',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: Responsive.sp(context, 13.5),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 6,
              children: [
                _buildLegendItem("Left (L)", AppTheme.accentNeonCyan),
                _buildLegendItem("Right (R)", AppTheme.accentPurple),
                _buildLegendItem(isEng ? "Eliminated" : "বাদ পড়েছে", AppTheme.textMuted),
              ],
            ),
          ] else ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isEng ? '📊 Array & Pointer Positions' : '📊 অ্যারে ও পয়েন্টারের বর্তমান অবস্থান',
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
                    _buildLegendItem(isEng ? "Eliminated" : "বাদ পড়েছে", AppTheme.textMuted),
                  ],
                ),
              ],
            ),
          ],
          const SizedBox(height: 16),

          // Scrollable Array Element Cards
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(_array.length, (idx) {
                final val = _array[idx];
                final isLeft = idx == step.left;
                final isRight = idx == step.right;
                final isMatched = step.statusType == 'matched' && (isLeft || isRight);
                final isEliminated = idx < step.left || idx > step.right;

                Color borderColor = const Color(0xFF334155);
                Color bgColor = AppTheme.primaryDark;

                if (isMatched) {
                  borderColor = AppTheme.accentGreen;
                  bgColor = AppTheme.accentGreen.withOpacity(0.25);
                } else if (isLeft && isRight) {
                  borderColor = AppTheme.accentAmber;
                  bgColor = AppTheme.accentAmber.withOpacity(0.25);
                } else if (isLeft) {
                  borderColor = AppTheme.accentNeonCyan;
                  bgColor = AppTheme.accentNeonCyan.withOpacity(0.2);
                } else if (isRight) {
                  borderColor = AppTheme.accentPurple;
                  bgColor = AppTheme.accentPurple.withOpacity(0.2);
                } else if (isEliminated) {
                  borderColor = Colors.transparent;
                  bgColor = const Color(0xFF0F172A).withOpacity(0.4);
                }

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: EdgeInsets.only(right: isMobile ? 8 : 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Top Pointer Indicator
                      SizedBox(
                        height: 36,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (isLeft && isRight)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppTheme.accentAmber,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'L & R',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              )
                            else if (isLeft)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppTheme.accentNeonCyan,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'Left (L)',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              )
                            else if (isRight)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppTheme.accentPurple,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'Right (R)',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            else if (isEliminated)
                              const Icon(Icons.cancel_outlined, color: AppTheme.textMuted, size: 14)
                            else
                              const SizedBox.shrink(),
                            if (isLeft || isRight)
                              Icon(
                                Icons.arrow_drop_down,
                                color: isLeft ? AppTheme.accentNeonCyan : AppTheme.accentPurple,
                                size: 18,
                              ),
                          ],
                        ),
                      ),

                      // Card Body
                      Opacity(
                        opacity: isEliminated ? 0.35 : 1.0,
                        child: AnimatedScale(
                          scale: (isLeft || isRight) ? 1.08 : 1.0,
                          duration: const Duration(milliseconds: 250),
                          child: Container(
                            width: isMobile ? 55 : 65,
                            padding: EdgeInsets.symmetric(vertical: isMobile ? 10 : 12),
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: borderColor,
                                width: (isLeft || isRight) ? 2.5 : 1.0,
                              ),
                              boxShadow: (isLeft || isRight)
                                  ? [
                                      BoxShadow(
                                        color: borderColor.withOpacity(0.3),
                                        blurRadius: 10,
                                        spreadRadius: 1,
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Column(
                              children: [
                                Text(
                                  '$val',
                                  style: TextStyle(
                                    fontSize: Responsive.sp(context, isMobile ? 16 : 18),
                                    fontWeight: FontWeight.bold,
                                    color: isMatched
                                        ? AppTheme.accentGreen
                                        : (isEliminated ? AppTheme.textMuted : Colors.white),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'idx ${idx + 1}',
                                  style: TextStyle(
                                    fontSize: Responsive.sp(context, 9.5),
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
                icon: Icon(Icons.skip_previous_rounded, color: Colors.white, size: Responsive.sp(context, isMobile ? 20 : 24)),
                onPressed: _currentStepIndex > 0
                    ? () => setState(() => _currentStepIndex--)
                    : null,
              ),
              SizedBox(width: isMobile ? 8 : 12),
              IconButton(
                padding: isMobile ? EdgeInsets.zero : const EdgeInsets.all(8),
                constraints: isMobile ? const BoxConstraints() : null,
                tooltip: _isPlaying ? (isEng ? "Pause" : "পজ") : (isEng ? "Play" : "প্লে"),
                icon: Icon(
                  _isPlaying ? Icons.pause_circle_filled_rounded : Icons.play_circle_fill_rounded,
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
                icon: Icon(Icons.skip_next_rounded, color: Colors.white, size: Responsive.sp(context, isMobile ? 20 : 24)),
                onPressed: _currentStepIndex < _steps.length - 1
                    ? () => setState(() => _currentStepIndex++)
                    : null,
              ),
              SizedBox(width: isMobile ? 8 : 12),
              IconButton(
                padding: isMobile ? EdgeInsets.zero : const EdgeInsets.all(8),
                constraints: isMobile ? const BoxConstraints() : null,
                tooltip: isEng ? "Reset" : "রিসেট",
                icon: Icon(Icons.replay_rounded, color: AppTheme.textMuted, size: Responsive.sp(context, isMobile ? 18 : 22)),
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
          style: TextStyle(color: AppTheme.textSecondary, fontSize: Responsive.sp(context, 11)),
        ),
      ],
    );
  }

  /// Visual Explanation Card for Beginner Conceptual Understanding
  Widget _buildIntuitionExplanationCard(CodeFreeStep step, bool isEng, bool isMobile) {
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
              Icon(Icons.lightbulb_rounded, color: AppTheme.accentAmber, size: Responsive.sp(context, isMobile ? 18 : 22)),
              const SizedBox(width: 8),
              Text(
                isEng ? 'Intuition & Action Explanation' : 'সহজ ব্যাখ্যা ও লজিক',
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
              border: Border.all(color: AppTheme.accentNeonCyan.withOpacity(0.3)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline_rounded, color: AppTheme.accentNeonCyan, size: Responsive.sp(context, isMobile ? 16 : 18)),
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
