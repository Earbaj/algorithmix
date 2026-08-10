import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import 'package:algorithmix/ui/features/core_patterns/widgets/trapping_rain_water_code_free_visualizer.dart';

class RainWaterStep {
  final int left;
  final int right;
  final int leftMax;
  final int rightMax;
  final int activeLine;
  final List<int> heights;
  final List<int> trappedWaterPerBar;
  final int totalWater;
  final String actionEn;
  final String actionBn;
  final String reasonEn;
  final String reasonBn;
  final bool isFinish;

  const RainWaterStep({
    required this.left,
    required this.right,
    required this.leftMax,
    required this.rightMax,
    required this.activeLine,
    required this.heights,
    required this.trappedWaterPerBar,
    required this.totalWater,
    required this.actionEn,
    required this.actionBn,
    required this.reasonEn,
    required this.reasonBn,
    this.isFinish = false,
  });
}

class TrappingRainWaterDetailScreen extends StatefulWidget {
  const TrappingRainWaterDetailScreen({super.key});

  @override
  State<TrappingRainWaterDetailScreen> createState() =>
      _TrappingRainWaterDetailScreenState();
}

class _TrappingRainWaterDetailScreenState
    extends State<TrappingRainWaterDetailScreen>
    with SingleTickerProviderStateMixin {
  bool _isEnglish = true;
  late TabController _tabController;

  // Custom Input State
  final TextEditingController _inputController =
      TextEditingController(text: "0, 1, 0, 2, 1, 0, 1, 3, 2, 1, 2, 1");

  List<int> _currentHeights = [0, 1, 0, 2, 1, 0, 1, 3, 2, 1, 2, 1];
  List<RainWaterStep> _steps = [];

  // Playback Control
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  // Practice Mode State
  bool _showAnswer = false;
  int _userLeft = 0;
  int _userRight = 11;
  int _userLeftMax = 0;
  int _userRightMax = 0;
  int _userTotalWater = 0;
  List<int> _userWaterPerBar = List.filled(12, 0);
  String _userFeedbackEn = "Compare height[left] & height[right]. Update leftMax/rightMax or add water!";
  String _userFeedbackBn = "উচ্চতা তুলনা করে সীমানা তৈরি করুন এবং পানির পরিমাণ বের করুন!";
  bool _userSolved = false;
  String _selectedCodeLang = "C++";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _rebuildSteps();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _timer?.cancel();
    _inputController.dispose();
    super.dispose();
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text.trim()));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              _isEnglish
                  ? '$label copied to clipboard!'
                  : '$label কোড ক্লিপবোর্ডে কপি হয়েছে!',
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
        backgroundColor: AppTheme.accentGreen,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _rebuildSteps() {
    _timer?.cancel();
    _isPlaying = false;
    _currentStepIndex = 0;

    try {
      List<int> parsed = _inputController.text
          .split(',')
          .map((e) => int.parse(e.trim()))
          .toList();
      if (parsed.isEmpty) {
        parsed = [0, 1, 0, 2, 1, 0, 1, 3, 2, 1, 2, 1];
      }
      _currentHeights = parsed;
    } catch (_) {
      _currentHeights = [0, 1, 0, 2, 1, 0, 1, 3, 2, 1, 2, 1];
    }

    _userLeft = 0;
    _userRight = _currentHeights.length - 1;
    _userLeftMax = 0;
    _userRightMax = 0;
    _userTotalWater = 0;
    _userWaterPerBar = List.filled(_currentHeights.length, 0);
    _userSolved = false;
    _userFeedbackEn = "Start trapping rain water!";
    _userFeedbackBn = "বৃষ্টির পানি ট্র্যাপ করা শুরু করুন!";

    _steps = _generateSteps(_currentHeights);
    setState(() {});
  }

  List<RainWaterStep> _generateSteps(List<int> orig) {
    List<RainWaterStep> steps = [];
    List<int> heights = List.from(orig);
    int n = heights.length;

    if (n == 0) return steps;

    int left = 0;
    int right = n - 1;
    int leftMax = 0;
    int rightMax = 0;
    int totalWater = 0;
    List<int> waterPerBar = List.filled(n, 0);

    // Line 2: Init
    steps.add(RainWaterStep(
      left: left,
      right: right,
      leftMax: 0,
      rightMax: 0,
      activeLine: 2,
      heights: List.from(heights),
      trappedWaterPerBar: List.from(waterPerBar),
      totalWater: 0,
      actionEn: "Line 2: left = 0, right = ${n - 1}, leftMax = 0, rightMax = 0",
      actionBn: "লাইন ২: left = 0, right = ${n - 1}, leftMax = 0, rightMax = 0",
      reasonEn: "Set two pointers at both ends of elevation map.",
      reasonBn: "উচ্চতার ম্যাপের উভয়প্রান্তে ২ জন পয়েন্টার সেট করা হলো।",
    ));

    while (left < right) {
      if (heights[left] < heights[right]) {
        if (heights[left] >= leftMax) {
          leftMax = heights[left];
          steps.add(RainWaterStep(
            left: left,
            right: right,
            leftMax: leftMax,
            rightMax: rightMax,
            activeLine: 6,
            heights: List.from(heights),
            trappedWaterPerBar: List.from(waterPerBar),
            totalWater: totalWater,
            actionEn: "Line 6: leftMax = max(leftMax, h[$left]) → $leftMax",
            actionBn: "লাইন ৬: leftMax = max(leftMax, h[$left]) → $leftMax",
            reasonEn: "Height at index $left is new peak boundary for left side.",
            reasonBn: "ইনডেক্স $left এর উচ্চতা বামপাশের নতুন সর্বোচ্চ সীমানা তৈরি করেছে।",
          ));
        } else {
          int w = leftMax - heights[left];
          waterPerBar[left] = w;
          totalWater += w;
          steps.add(RainWaterStep(
            left: left,
            right: right,
            leftMax: leftMax,
            rightMax: rightMax,
            activeLine: 7,
            heights: List.from(heights),
            trappedWaterPerBar: List.from(waterPerBar),
            totalWater: totalWater,
            actionEn: "Line 7: water += leftMax ($leftMax) - h[$left] (${heights[left]}) = $w units 🌊",
            actionBn: "লাইন ৭: water += leftMax ($leftMax) - h[$left] (${heights[left]}) = $w ইউনিট 🌊",
            reasonEn: "Trapped $w units of water at index $left! Total = $totalWater.",
            reasonBn: "ইনডেক্স $left এ $w ইউনিট পানি জমা হলো! সর্বমোট = $totalWater।",
          ));
        }
        left++;
      } else {
        if (heights[right] >= rightMax) {
          rightMax = heights[right];
          steps.add(RainWaterStep(
            left: left,
            right: right,
            leftMax: leftMax,
            rightMax: rightMax,
            activeLine: 10,
            heights: List.from(heights),
            trappedWaterPerBar: List.from(waterPerBar),
            totalWater: totalWater,
            actionEn: "Line 10: rightMax = max(rightMax, h[$right]) → $rightMax",
            actionBn: "লাইন ১০: rightMax = max(rightMax, h[$right]) → $rightMax",
            reasonEn: "Height at index $right is new peak boundary for right side.",
            reasonBn: "ইনডেক্স $right এর উচ্চতা ডানপাশের নতুন সর্বোচ্চ সীমানা তৈরি করেছে।",
          ));
        } else {
          int w = rightMax - heights[right];
          waterPerBar[right] = w;
          totalWater += w;
          steps.add(RainWaterStep(
            left: left,
            right: right,
            leftMax: leftMax,
            rightMax: rightMax,
            activeLine: 11,
            heights: List.from(heights),
            trappedWaterPerBar: List.from(waterPerBar),
            totalWater: totalWater,
            actionEn: "Line 11: water += rightMax ($rightMax) - h[$right] (${heights[right]}) = $w units 🌊",
            actionBn: "লাইন ১১: water += rightMax ($rightMax) - h[$right] (${heights[right]}) = $w ইউনিট 🌊",
            reasonEn: "Trapped $w units of water at index $right! Total = $totalWater.",
            reasonBn: "ইনডেক্স $right এ $w ইউনিট পানি জমা হলো! সর্বমোট = $totalWater।",
          ));
        }
        right--;
      }
    }

    // Line 15: Finish
    steps.add(RainWaterStep(
      left: left,
      right: right,
      leftMax: leftMax,
      rightMax: rightMax,
      activeLine: 15,
      heights: List.from(heights),
      trappedWaterPerBar: List.from(waterPerBar),
      totalWater: totalWater,
      actionEn: "Line 15: return water 🎉 Total Trapped Water = $totalWater Units",
      actionBn: "লাইন ১৫: return water 🎉 সর্বমোট জমা পানি = $totalWater ইউনিট",
      reasonEn: "Trapping Rain Water algorithm completed in O(N) linear time and O(1) space!",
      reasonBn: "O(N) সময়াধিক্যে ও O(1) অতিরিক্ত মেমোরিতে ট্র্যাপিং রেইন ওয়াটার সম্পন্ন!",
      isFinish: true,
    ));

    return steps;
  }

  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;
    });

    if (_isPlaying) {
      _timer = Timer.periodic(const Duration(milliseconds: 1500), (timer) {
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

  void _loadPreset(List<int> h) {
    _inputController.text = h.join(', ');
    _rebuildSteps();
  }

  void _handleUserAction() {
    if (_userSolved || _userLeft >= _userRight) return;

    final h = _currentHeights;

    setState(() {
      if (h[_userLeft] < h[_userRight]) {
        if (h[_userLeft] >= _userLeftMax) {
          _userLeftMax = h[_userLeft];
          _userFeedbackEn = "✅ Updated leftMax to $_userLeftMax at index $_userLeft.";
          _userFeedbackBn = "✅ leftMax আপডেট হয়ে $_userLeftMax হলো।";
        } else {
          int w = _userLeftMax - h[_userLeft];
          _userWaterPerBar[_userLeft] = w;
          _userTotalWater += w;
          _userFeedbackEn = "✅ Trapped $w units water at index $_userLeft! Total = $_userTotalWater.";
          _userFeedbackBn = "✅ $w ইউনিট পানি জমা হলো! সর্বমোট = $_userTotalWater।";
        }
        _userLeft++;
      } else {
        if (h[_userRight] >= _userRightMax) {
          _userRightMax = h[_userRight];
          _userFeedbackEn = "✅ Updated rightMax to $_userRightMax at index $_userRight.";
          _userFeedbackBn = "✅ rightMax আপডেট হয়ে $_userRightMax হলো।";
        } else {
          int w = _userRightMax - h[_userRight];
          _userWaterPerBar[_userRight] = w;
          _userTotalWater += w;
          _userFeedbackEn = "✅ Trapped $w units water at index $_userRight! Total = $_userTotalWater.";
          _userFeedbackBn = "✅ $w ইউনিট পানি জমা হলো! সর্বমোট = $_userTotalWater।";
        }
        _userRight--;
      }

      if (_userLeft >= _userRight) {
        _userSolved = true;
        _userFeedbackEn = "🎉 Perfect! Total Trapped Water = $_userTotalWater Units 🌊!";
        _userFeedbackBn = "🎉 দারুণ! সর্বমোট জমা পানি = $_userTotalWater ইউনিট 🌊!";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final hPadding = Responsive.horizontalPadding(context);

    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      appBar: AppBar(
        title: Text(
          '42. Trapping Rain Water',
          style: TextStyle(
            fontSize: Responsive.sp(context, 16),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: TextButton.icon(
              style: TextButton.styleFrom(
                backgroundColor: AppTheme.accentPurple.withOpacity(0.2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              icon: Icon(
                Icons.language,
                color: _isEnglish ? AppTheme.accentNeonCyan : AppTheme.accentPink,
                size: Responsive.sp(context, 18),
              ),
              label: Text(
                _isEnglish ? 'EN' : 'BN',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: Responsive.sp(context, 13)),
              ),
              onPressed: () {
                setState(() {
                  _isEnglish = !_isEnglish;
                });
              },
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.accentNeonCyan,
          labelColor: AppTheme.accentNeonCyan,
          unselectedLabelColor: AppTheme.textSecondary,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          padding: EdgeInsets.zero,
          labelStyle: TextStyle(
              fontSize: Responsive.sp(context, 14), fontWeight: FontWeight.bold),
          unselectedLabelStyle:
              TextStyle(fontSize: Responsive.sp(context, 13)),
          tabs: [
            Tab(text: _isEnglish ? '📘 Problem Description' : '📘 প্রবলেম বিবরণ'),
            Tab(text: _isEnglish ? '🎨 Code-Free Animation' : '🎨 কোডহীন ভিজ্যুয়াল গাইড'),
            Tab(text: _isEnglish ? '⚡ Dynamic Visualizer' : '⚡ কাস্টম ইনপুট ও ভিজ্যুয়ালাইজার'),
            Tab(text: _isEnglish ? '💡 Practice & Answer' : '💡 প্র্যাকটিস ও উত্তর'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildProblemDescriptionTab(hPadding),
          _buildCodeFreeVisualizerTab(hPadding),
          _buildVisualizerTab(hPadding),
          _buildPracticeAndAnswerTab(hPadding),
        ],
      ),
    );
  }

  // TAB 1: Problem Description
  Widget _buildProblemDescriptionTab(double hPadding) {
    return ResponsiveCenter(
      maxWidth: 1280.0,
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.accentPink.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.accentPink),
                  ),
                  child: Text(
                    '🔴 Hard',
                    style: TextStyle(
                        color: AppTheme.accentPink,
                        fontWeight: FontWeight.bold,
                        fontSize: Responsive.sp(context, 12)),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.accentPurple.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.accentPurple),
                  ),
                  child: Text(
                    'LeetCode #42',
                    style: TextStyle(
                        color: AppTheme.accentNeonCyan,
                        fontWeight: FontWeight.bold,
                        fontSize: Responsive.sp(context, 12)),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.accentGreen.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.accentGreen),
                  ),
                  child: Text(
                    '⭐ Two Pointers Boundary Master',
                    style: TextStyle(
                        color: AppTheme.accentGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: Responsive.sp(context, 12)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              _isEnglish ? 'Trapping Rain Water' : 'ট্র্যাপিং রেইন ওয়াটার (Trapping Rain Water)',
              style: TextStyle(
                fontSize: Responsive.sp(context, 20),
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),

            // Statement Box
            Container(
              padding: EdgeInsets.all(Responsive.sp(context, 18)),
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isEnglish ? 'Problem Statement' : 'সমস্যার বিবরণ',
                    style: TextStyle(
                      fontSize: Responsive.sp(context, 16),
                      fontWeight: FontWeight.bold,
                      color: AppTheme.accentNeonCyan,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _isEnglish
                        ? 'Given n non-negative integers representing an elevation map where the width of each bar is 1, compute how much water it can trap after raining.'
                        : 'n সংখ্যক অ-ঋণাত্মক ইন্টিজারের সমন্বয়ে গঠিত একটি উচ্চতার ম্যাপ দেওয়া আছে যেখানে প্রতিটি বারের প্রস্থ ১ একক। বৃষ্টি হওয়ার পর এতে মোট কত একক পানি জমে থাকবে তা গণনা করুন।',
                    style: TextStyle(
                      fontSize: Responsive.sp(context, 14),
                      color: AppTheme.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Examples
            Text(
              _isEnglish ? '📌 Example Cases' : '📌 উদাহরণসমূহ',
              style: TextStyle(
                fontSize: Responsive.sp(context, 18),
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            _buildExampleCard(
              "Example 1",
              "height = [0, 1, 0, 2, 1, 0, 1, 3, 2, 1, 2, 1]",
              "Output: 6",
              _isEnglish
                  ? "Explanation: 6 units of rain water are trapped in the hollow gaps between elevation bars."
                  : "ব্যাখ্যা: বারগুলির ফাঁকা স্থানে সর্বমোট ৬ ইউনিট পানি জমে থাকে।",
            ),
            _buildExampleCard(
              "Example 2",
              "height = [4, 2, 0, 3, 2, 5]",
              "Output: 9",
              _isEnglish
                  ? "Explanation: 9 units of rain water are trapped between index 0 (height 4) and index 5 (height 5)."
                  : "ব্যাখ্যা: ইনডেক্স ০ ও ৫ এর মাঝখানে ৯ ইউনিট পানি জমে থাকে।",
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // TAB 2: Code-Free Animation
  Widget _buildCodeFreeVisualizerTab(double hPadding) {
    return ResponsiveCenter(
      maxWidth: 1280.0,
      padding: EdgeInsets.all(hPadding),
      child: TrappingRainWaterCodeFreeVisualizer(isEnglish: _isEnglish),
    );
  }

  // TAB 3: Dynamic Visualizer
  Widget _buildVisualizerTab(double hPadding) {
    final isMobile = Responsive.isMobile(context);
    final step = _steps.isEmpty
        ? RainWaterStep(
            left: 0,
            right: 0,
            leftMax: 0,
            rightMax: 0,
            activeLine: 0,
            heights: _currentHeights,
            trappedWaterPerBar: List.filled(_currentHeights.length, 0),
            totalWater: 0,
            actionEn: "",
            actionBn: "",
            reasonEn: "",
            reasonBn: "")
        : _steps[_currentStepIndex];

    return ResponsiveCenter(
      maxWidth: 1280.0,
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dynamic Input Box
            Container(
              padding: EdgeInsets.all(Responsive.sp(context, 16)),
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.accentNeonCyan.withOpacity(0.4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isEnglish ? '⚙️ Dynamic Test Case Generator' : '⚙️ ডায়নামিক ইনপুট ও টেস্ট কেস',
                    style: TextStyle(
                      fontSize: Responsive.sp(context, 16),
                      fontWeight: FontWeight.bold,
                      color: AppTheme.accentNeonCyan,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _inputController,
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'monospace',
                        fontSize: Responsive.sp(context, 13)),
                    decoration: InputDecoration(
                      labelText: _isEnglish
                          ? 'Elevation Heights (comma separated)'
                          : 'উচ্চতার ম্যাপ (কমা দিয়ে separated)',
                      hintText: 'e.g. 0, 1, 0, 2, 1, 0, 1, 3, 2, 1, 2, 1',
                      labelStyle: TextStyle(fontSize: Responsive.sp(context, 12)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Text('Presets: ',
                            style: TextStyle(
                                color: AppTheme.textMuted,
                                fontSize: Responsive.sp(context, 12))),
                        _buildPresetChip('[0,1,0,2,1,0,1,3,2,1,2,1]', [0, 1, 0, 2, 1, 0, 1, 3, 2, 1, 2, 1]),
                        _buildPresetChip('[4,2,0,3,2,5]', [4, 2, 0, 3, 2, 5]),
                        _buildPresetChip('[3,0,2,0,4]', [3, 0, 2, 0, 4]),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: _rebuildSteps,
                    icon: Icon(Icons.bolt, color: Colors.white, size: Responsive.sp(context, 18)),
                    label: Text(
                      _isEnglish ? 'Run Dynamic Visualizer' : 'ভিজ্যুয়ালাইজার রান করুন',
                      style: TextStyle(
                          fontSize: Responsive.sp(context, 14), fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentPurple),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Visualization Layout: Stack on Mobile, Side-by-Side Horizontal Scroll on Desktop
            if (isMobile)
              Column(
                children: [
                  _buildCodeTraceWidget(step.activeLine),
                  const SizedBox(height: 16),
                  _buildArrayVisualizationBox(step),
                ],
              )
            else
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 580,
                      child: _buildCodeTraceWidget(step.activeLine),
                    ),
                    const SizedBox(width: 16),
                    SizedBox(
                      width: 550,
                      child: _buildArrayVisualizationBox(step),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),

            // Playback Controls
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: Responsive.sp(context, 16), vertical: 12),
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
                        icon: Icon(Icons.skip_previous,
                            color: Colors.white, size: Responsive.sp(context, 20)),
                        onPressed: _currentStepIndex > 0
                            ? () => setState(() => _currentStepIndex--)
                            : null,
                      ),
                      IconButton(
                        icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow,
                            color: AppTheme.accentNeonCyan,
                            size: Responsive.sp(context, 24)),
                        onPressed: _togglePlay,
                      ),
                      IconButton(
                        icon: Icon(Icons.skip_next,
                            color: Colors.white, size: Responsive.sp(context, 20)),
                        onPressed: _currentStepIndex < _steps.length - 1
                            ? () => setState(() => _currentStepIndex++)
                            : null,
                      ),
                      IconButton(
                        icon: Icon(Icons.refresh,
                            color: AppTheme.textMuted, size: Responsive.sp(context, 20)),
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
                  Text(
                    "Step ${_currentStepIndex + 1} / ${_steps.length}",
                    style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.bold,
                        fontSize: Responsive.sp(context, 13)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // TAB 4: Practice & Answer
  Widget _buildPracticeAndAnswerTab(double hPadding) {
    final h = _currentHeights;

    return ResponsiveCenter(
      maxWidth: 1280.0,
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Try It Yourself Interactive Box
            Container(
              padding: EdgeInsets.all(Responsive.sp(context, 18)),
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: _userSolved ? AppTheme.accentGreen : AppTheme.accentAmber),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _userSolved ? Icons.check_circle : Icons.extension_outlined,
                        color: _userSolved ? AppTheme.accentGreen : AppTheme.accentAmber,
                        size: Responsive.sp(context, 24),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _isEnglish
                            ? '🎮 Practice Mode: Calculate Trapped Water Step by Step!'
                            : '🎮 প্র্যাকটিস মোড: নিজে ট্র্যাপড পানি হিসাব করুন!',
                        style: TextStyle(
                          fontSize: Responsive.sp(context, 16),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _isEnglish
                        ? 'Heights: [${_currentHeights.join(', ')}]'
                        : 'উচ্চতাসমূহ: [${_currentHeights.join(', ')}]',
                    style: TextStyle(
                        color: AppTheme.accentNeonCyan,
                        fontWeight: FontWeight.bold,
                        fontSize: Responsive.sp(context, 13)),
                  ),
                  const SizedBox(height: 16),

                  // Current Water Gauge
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryDark,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.accentNeonCyan.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "leftMax: $_userLeftMax | rightMax: $_userRightMax",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: Responsive.sp(context, 12.5)),
                        ),
                        Text(
                          "Total Water: $_userTotalWater Units 🌊",
                          style: TextStyle(
                              color: AppTheme.accentGreen,
                              fontWeight: FontWeight.bold,
                              fontSize: Responsive.sp(context, 12.5)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // User Action Buttons
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _userSolved || _userLeft >= _userRight
                            ? null
                            : _handleUserAction,
                        icon: Icon(Icons.water_drop, size: Responsive.sp(context, 16)),
                        label: Text(
                            _isEnglish
                                ? 'Evaluate Next Step (Auto Two-Pointer)'
                                : 'পরবর্তী ধাপ ট্র্যাকিং করুন',
                            style: TextStyle(fontSize: Responsive.sp(context, 13))),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accentNeonCyan),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            _userLeft = 0;
                            _userRight = _currentHeights.length - 1;
                            _userLeftMax = 0;
                            _userRightMax = 0;
                            _userTotalWater = 0;
                            _userWaterPerBar = List.filled(_currentHeights.length, 0);
                            _userSolved = false;
                            _userFeedbackEn = "Reset done!";
                            _userFeedbackBn = "রিসেট করা হয়েছে!";
                          });
                        },
                        icon: Icon(Icons.refresh,
                            size: Responsive.sp(context, 16), color: Colors.white),
                        label: Text(_isEnglish ? 'Reset' : 'রিসেট',
                            style: TextStyle(fontSize: Responsive.sp(context, 13))),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Feedback Box
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _userSolved
                          ? AppTheme.accentGreen.withOpacity(0.15)
                          : AppTheme.primaryDark,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: _userSolved
                              ? AppTheme.accentGreen
                              : const Color(0xFF334155)),
                    ),
                    child: Text(
                      _isEnglish ? _userFeedbackEn : _userFeedbackBn,
                      style: TextStyle(
                        color: _userSolved ? AppTheme.accentGreen : AppTheme.textSecondary,
                        fontWeight: FontWeight.w600,
                        fontSize: Responsive.sp(context, 13),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Reveal Solution Section
            Container(
              padding: EdgeInsets.all(Responsive.sp(context, 18)),
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.accentPink.withOpacity(0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isEnglish ? "Need Help or Stuck?" : "সমস্যা সমাধান করতে পারছ না?",
                              style: TextStyle(
                                fontSize: Responsive.sp(context, 16),
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _isEnglish
                                  ? "Reveal complete solution code in C++, Java, Python, and Dart."
                                  : "সম্পূর্ণ সমাধান ও কোড গাইডলাইন দেখুন।",
                              style: TextStyle(
                                  color: AppTheme.textSecondary,
                                  fontSize: Responsive.sp(context, 12)),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _showAnswer = !_showAnswer;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              _showAnswer ? AppTheme.accentGreen : AppTheme.accentPink,
                        ),
                        child: Text(
                          _showAnswer
                              ? (_isEnglish ? "Hide Answer" : "উত্তর লুকান")
                              : (_isEnglish ? "Reveal Solution Code" : "উত্তর ও কোড দেখুন"),
                          style: TextStyle(
                              fontSize: Responsive.sp(context, 13),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  if (_showAnswer) ...[
                    const Divider(height: 28, color: Color(0xFF334155)),
                    Row(
                      children: ["C++", "Java", "Python", "Dart"].map((lang) {
                        final isSel = _selectedCodeLang == lang;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(lang,
                                style: TextStyle(fontSize: Responsive.sp(context, 12))),
                            selected: isSel,
                            selectedColor: AppTheme.accentPurple,
                            backgroundColor: AppTheme.primaryDark,
                            labelStyle: TextStyle(
                              color: isSel ? Colors.white : AppTheme.textSecondary,
                              fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                            ),
                            onSelected: (val) {
                              if (val) {
                                setState(() {
                                  _selectedCodeLang = lang;
                                });
                              }
                            },
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 12),
                    _buildFullCodeSnippet(_selectedCodeLang),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryDark,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "⏱️ Complexity Analysis:",
                            style: TextStyle(
                                color: AppTheme.accentNeonCyan,
                                fontWeight: FontWeight.bold,
                                fontSize: Responsive.sp(context, 14)),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _isEnglish
                                ? "• Time Complexity: O(N) — Single pass with Two Pointers from left and right.\n• Space Complexity: O(1) auxiliary space — Only constant scalar variables leftMax, rightMax."
                                : "• টাইম কমপ্লেক্সিটি: O(N) — বাম ও ডানের টু-পয়েন্টার দিয়ে ১টি পাসেই সমাধান।\n• স্পেস কমপ্লেক্সিটি: O(1) অতিরিক্ত মেমোরি।",
                            style: TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: Responsive.sp(context, 13),
                                height: 1.4),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildPresetChip(String label, List<int> h) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ActionChip(
        label: Text(label,
            style: TextStyle(
                fontSize: Responsive.sp(context, 11), color: Colors.white)),
        backgroundColor: AppTheme.primaryDark,
        onPressed: () => _loadPreset(h),
      ),
    );
  }

  Widget _buildExampleCard(
      String title, String input, String output, String desc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.accentNeonCyan,
                  fontSize: Responsive.sp(context, 13))),
          const SizedBox(height: 4),
          Text(input,
              style: TextStyle(
                  fontFamily: 'monospace',
                  color: Colors.white,
                  fontSize: Responsive.sp(context, 12))),
          Text(output,
              style: TextStyle(
                  fontFamily: 'monospace',
                  color: AppTheme.accentGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: Responsive.sp(context, 12))),
          const SizedBox(height: 4),
          Text(desc,
              style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: Responsive.sp(context, 12))),
        ],
      ),
    );
  }

  Widget _buildCodeTraceWidget(int activeLine) {
    final codeLines = const [
      "int trap(vector<int>& height) {",
      "    int left = 0, right = height.size() - 1;",
      "    int leftMax = 0, rightMax = 0, water = 0;",
      "    while (left < right) {",
      "        if (height[left] < height[right]) {",
      "            if (height[left] >= leftMax) leftMax = height[left];",
      "            else water += leftMax - height[left];",
      "            left++;",
      "        } else {",
      "            if (height[right] >= rightMax) rightMax = height[right];",
      "            else water += rightMax - height[right];",
      "            right--;",
      "        }",
      "    }",
      "    return water;",
      "}",
    ];

    final fullCodeText = codeLines.join('\n');

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Responsive.sp(context, 14)),
      decoration: BoxDecoration(
        color: const Color(0xFF090D16),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF1E293B), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.code_rounded,
                      color: AppTheme.accentNeonCyan, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    "C++ Execution Trace",
                    style: TextStyle(
                      color: AppTheme.accentNeonCyan,
                      fontWeight: FontWeight.bold,
                      fontSize: Responsive.sp(context, 13.5),
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () => _copyToClipboard(fullCodeText, "C++ Trace Code"),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppTheme.accentPurple.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.accentPurple.withOpacity(0.5)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.copy,
                          size: Responsive.sp(context, 13),
                          color: AppTheme.accentNeonCyan),
                      const SizedBox(width: 4),
                      Text(
                        _isEnglish ? "Copy" : "কপি",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: Responsive.sp(context, 11.5),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(codeLines.length, (idx) {
                final lineNum = idx + 1;
                final isActive = lineNum == activeLine;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(vertical: 2.5),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppTheme.accentPurple.withOpacity(0.35)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                    border: isActive
                        ? const Border(
                            left: BorderSide(
                                color: AppTheme.accentNeonCyan, width: 4))
                        : null,
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 28,
                        child: Text(
                          '$lineNum',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: Responsive.sp(context, 12),
                            color: isActive
                                ? AppTheme.accentNeonCyan
                                : AppTheme.textMuted,
                            fontWeight:
                                isActive ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                      Text(
                        codeLines[idx],
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: Responsive.sp(context, 13),
                          color:
                              isActive ? Colors.white : const Color(0xFF94A3B8),
                          fontWeight:
                              isActive ? FontWeight.bold : FontWeight.normal,
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

  Widget _buildArrayVisualizationBox(RainWaterStep step) {
    final heights = step.heights;
    final water = step.trappedWaterPerBar;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Responsive.sp(context, 16)),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: step.isFinish ? AppTheme.accentGreen : const Color(0xFF334155),
          width: step.isFinish ? 2.0 : 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Elevation Map & Two Pointers",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: Responsive.sp(context, 14)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.accentNeonCyan.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Water: ${step.totalWater} units",
                  style: TextStyle(
                      color: AppTheme.accentNeonCyan,
                      fontWeight: FontWeight.bold,
                      fontSize: Responsive.sp(context, 12)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(heights.length, (idx) {
                final h = heights[idx];
                final w = water[idx];
                final isLeft = idx == step.left;
                final isRight = idx == step.right;

                Color boxBg = AppTheme.primaryDark;
                Color borderColor = const Color(0xFF334155);

                if (isLeft && isRight) {
                  boxBg = AppTheme.accentGreen.withOpacity(0.25);
                  borderColor = AppTheme.accentGreen;
                } else if (isLeft) {
                  boxBg = AppTheme.accentNeonCyan.withOpacity(0.25);
                  borderColor = AppTheme.accentNeonCyan;
                } else if (isRight) {
                  boxBg = AppTheme.accentAmber.withOpacity(0.25);
                  borderColor = AppTheme.accentAmber;
                }

                return Container(
                  margin: const EdgeInsets.only(right: 6),
                  padding: EdgeInsets.symmetric(
                    horizontal: Responsive.sp(context, 10),
                    vertical: Responsive.sp(context, 8),
                  ),
                  decoration: BoxDecoration(
                    color: boxBg,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: borderColor, width: 1.5),
                  ),
                  child: Column(
                    children: [
                      if (isLeft && isRight)
                        Text('L&R',
                            style: TextStyle(
                                fontSize: Responsive.sp(context, 9),
                                color: AppTheme.accentGreen,
                                fontWeight: FontWeight.bold))
                      else if (isLeft)
                        Text('L',
                            style: TextStyle(
                                fontSize: Responsive.sp(context, 9),
                                color: AppTheme.accentNeonCyan,
                                fontWeight: FontWeight.bold))
                      else if (isRight)
                        Text('R',
                            style: TextStyle(
                                fontSize: Responsive.sp(context, 9),
                                color: AppTheme.accentAmber,
                                fontWeight: FontWeight.bold))
                      else
                        Text(' ',
                            style: TextStyle(fontSize: Responsive.sp(context, 9))),
                      const SizedBox(height: 4),
                      Text(
                        '$h',
                        style: TextStyle(
                          fontSize: Responsive.sp(context, 15),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      if (w > 0)
                        Text(
                          '+$w',
                          style: TextStyle(
                            fontSize: Responsive.sp(context, 9.5),
                            color: const Color(0xFF38BDF8),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      const SizedBox(height: 4),
                      Text(
                        '[$idx]',
                        style: TextStyle(
                            fontSize: Responsive.sp(context, 8.5),
                            color: AppTheme.textMuted),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 16),

          Container(
            width: double.infinity,
            padding: EdgeInsets.all(Responsive.sp(context, 12)),
            decoration: BoxDecoration(
              color: step.isFinish
                  ? AppTheme.accentGreen.withOpacity(0.15)
                  : AppTheme.primaryDark,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: step.isFinish
                    ? AppTheme.accentGreen
                    : const Color(0xFF334155),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isEnglish ? step.actionEn : step.actionBn,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: step.isFinish ? AppTheme.accentGreen : Colors.white,
                    fontSize: Responsive.sp(context, 13),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _isEnglish ? step.reasonEn : step.reasonBn,
                  style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: Responsive.sp(context, 12),
                      height: 1.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFullCodeSnippet(String lang) {
    String code = "";
    if (lang == "C++") {
      code = """
class Solution {
public:
    int trap(vector<int>& height) {
        int left = 0, right = height.size() - 1;
        int leftMax = 0, rightMax = 0;
        int water = 0;
        
        while (left < right) {
            if (height[left] < height[right]) {
                if (height[left] >= leftMax) {
                    leftMax = height[left];
                } else {
                    water += leftMax - height[left];
                }
                left++;
            } else {
                if (height[right] >= rightMax) {
                    rightMax = height[right];
                } else {
                    water += rightMax - height[right];
                }
                right--;
            }
        }
        return water;
    }
};""";
    } else if (lang == "Java") {
      code = """
class Solution {
    public int trap(int[] height) {
        int left = 0, right = height.length - 1;
        int leftMax = 0, rightMax = 0;
        int water = 0;
        
        while (left < right) {
            if (height[left] < height[right]) {
                if (height[left] >= leftMax) {
                    leftMax = height[left];
                } else {
                    water += leftMax - height[left];
                }
                left++;
            } else {
                if (height[right] >= rightMax) {
                    rightMax = height[right];
                } else {
                    water += rightMax - height[right];
                }
                right--;
            }
        }
        return water;
    }
}""";
    } else if (lang == "Python") {
      code = """
class Solution:
    def trap(self, height: List[int]) -> int:
        left, right = 0, len(height) - 1
        left_max = right_max = 0
        water = 0
        
        while left < right:
            if height[left] < height[right]:
                if height[left] >= left_max:
                    left_max = height[left]
                else:
                    water += left_max - height[left]
                left += 1
            else:
                if height[right] >= right_max:
                    right_max = height[right]
                else:
                    water += right_max - height[right]
                right -= 1
        return water""";
    } else {
      code = """
int trap(List<int> height) {
  int left = 0, right = height.length - 1;
  int leftMax = 0, rightMax = 0;
  int water = 0;

  while (left < right) {
    if (height[left] < height[right]) {
      if (height[left] >= leftMax) {
        leftMax = height[left];
      } else {
        water += leftMax - height[left];
      }
      left++;
    } else {
      if (height[right] >= rightMax) {
        rightMax = height[right];
      } else {
        water += rightMax - height[right];
      }
      right--;
    }
  }
  return water;
}""";
    }

    return Container(
      padding: EdgeInsets.all(Responsive.sp(context, 14)),
      decoration: BoxDecoration(
        color: const Color(0xFF090D16),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 10,
            runSpacing: 8,
            children: [
              Text(
                "$lang Solution Code",
                style: TextStyle(
                  color: AppTheme.accentNeonCyan,
                  fontWeight: FontWeight.bold,
                  fontSize: Responsive.sp(context, 13),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _copyToClipboard(code, "$lang Solution"),
                icon: Icon(Icons.copy_all, size: Responsive.sp(context, 14)),
                label: Text(
                  _isEnglish ? "Copy Code" : "কোড কপি করুন",
                  style: TextStyle(
                      fontSize: Responsive.sp(context, 12),
                      fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentPurple,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              code.trim(),
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: Responsive.sp(context, 12.5),
                color: const Color(0xFF38BDF8),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
