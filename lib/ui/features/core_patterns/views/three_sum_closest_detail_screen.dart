import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import 'package:algorithmix/ui/features/core_patterns/widgets/three_sum_closest_code_free_visualizer.dart';

class ThreeSumClosestStep {
  final int i;
  final int left;
  final int right;
  final int target;
  final int activeLine;
  final List<int> sortedArray;
  final int currentSum;
  final int closestSum;
  final String actionEn;
  final String actionBn;
  final String reasonEn;
  final String reasonBn;
  final bool isFinish;

  const ThreeSumClosestStep({
    required this.i,
    required this.left,
    required this.right,
    required this.target,
    required this.activeLine,
    required this.sortedArray,
    required this.currentSum,
    required this.closestSum,
    required this.actionEn,
    required this.actionBn,
    required this.reasonEn,
    required this.reasonBn,
    this.isFinish = false,
  });
}

class ThreeSumClosestDetailScreen extends StatefulWidget {
  const ThreeSumClosestDetailScreen({super.key});

  @override
  State<ThreeSumClosestDetailScreen> createState() =>
      _ThreeSumClosestDetailScreenState();
}

class _ThreeSumClosestDetailScreenState
    extends State<ThreeSumClosestDetailScreen>
    with SingleTickerProviderStateMixin {
  bool _isEnglish = true;
  late TabController _tabController;

  // Custom Input State
  final TextEditingController _inputController =
      TextEditingController(text: "-1, 2, 1, -4");
  final TextEditingController _targetController =
      TextEditingController(text: "1");

  List<int> _currentArray = [-1, 2, 1, -4];
  int _currentTarget = 1;

  List<ThreeSumClosestStep> _steps = [];

  // Playback Control
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  // Practice Mode State
  bool _showAnswer = false;
  int _userI = 0;
  int _userLeft = 1;
  int _userRight = 3;
  List<int> _userSortedArray = [-4, -1, 1, 2];
  int _userClosest = -3;
  String _userFeedbackEn = "Compare sum to target. Choose 'Move Left++' or 'Move Right--'!";
  String _userFeedbackBn = "যোগফল ও টার্গেট তুলনা করে সঠিক পদক্ষেপ নিন!";
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
    _targetController.dispose();
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
      _currentTarget = int.parse(_targetController.text.trim());
      List<int> parsed = _inputController.text
          .split(',')
          .map((e) => int.parse(e.trim()))
          .toList();
      if (parsed.isEmpty) {
        parsed = [-1, 2, 1, -4];
      }
      _currentArray = parsed;
    } catch (_) {
      _currentArray = [-1, 2, 1, -4];
      _currentTarget = 1;
    }

    List<int> sorted = List.from(_currentArray);
    sorted.sort();
    _userSortedArray = List.from(sorted);
    _userI = 0;
    _userLeft = 1;
    _userRight = sorted.length - 1;
    _userClosest = sorted[0] + sorted[1] + sorted[sorted.length - 1];
    _userSolved = false;
    _userFeedbackEn = "Start evaluating closest sum on sorted array!";
    _userFeedbackBn = "সর্টেড অ্যারেতে নিকটতম যোগফল খোঁজা শুরু করুন!";

    _steps = _generateSteps(_currentArray, _currentTarget);
    setState(() {});
  }

  List<ThreeSumClosestStep> _generateSteps(List<int> orig, int target) {
    List<ThreeSumClosestStep> steps = [];
    List<int> nums = List.from(orig);
    nums.sort();

    int n = nums.length;
    if (n < 3) return steps;

    int closest = nums[0] + nums[1] + nums[2];

    // Line 2: Sort
    steps.add(ThreeSumClosestStep(
      i: 0,
      left: 1,
      right: n - 1,
      target: target,
      activeLine: 2,
      sortedArray: List.from(nums),
      currentSum: closest,
      closestSum: closest,
      actionEn: "Line 2: sort(nums) → [${nums.join(', ')}]",
      actionBn: "লাইন ২: sort(nums) → [${nums.join(', ')}]",
      reasonEn: "Array sorted. Initial closest sum = $closest.",
      reasonBn: "অ্যারে সর্ট করা হলো। প্রাথমিক নিকটতম যোগফল = $closest।",
    ));

    for (int i = 0; i < n - 2; i++) {
      int left = i + 1;
      int right = n - 1;

      // Line 5: Loop setup
      steps.add(ThreeSumClosestStep(
        i: i,
        left: left,
        right: right,
        target: target,
        activeLine: 5,
        sortedArray: List.from(nums),
        currentSum: nums[i] + nums[left] + nums[right],
        closestSum: closest,
        actionEn: "Line 5: Outer i = $i (${nums[i]}), left = $left, right = $right",
        actionBn: "লাইন ৫: আউটার i = $i (${nums[i]}), left = $left, right = $right",
        reasonEn: "Set inner bounds left and right for outer element nums[$i].",
        reasonBn: "nums[$i] এর জন্য পয়েন্টারদ্বয় সসীমা নির্ধারণ করা হলো।",
      ));

      while (left < right) {
        int sum = nums[i] + nums[left] + nums[right];

        if ((sum - target).abs() < (closest - target).abs()) {
          closest = sum;
          steps.add(ThreeSumClosestStep(
            i: i,
            left: left,
            right: right,
            target: target,
            activeLine: 7,
            sortedArray: List.from(nums),
            currentSum: sum,
            closestSum: closest,
            actionEn: "Line 7: Update closest sum to $closest 🎉 (Diff: ${(closest - target).abs()})",
            actionBn: "লাইন ৭: নিকটতম যোগফল $closest এ আপডেট করা হলো 🎉 (পার্থক্য: ${(closest - target).abs()})",
            reasonEn: "Sum $sum is closer to target $target than previous best!",
            reasonBn: "যোগফল $sum টার্গেট $target এর পূর্বের চেয়ে কাছাকাছি!",
          ));
        }

        if (sum == target) {
          steps.add(ThreeSumClosestStep(
            i: i,
            left: left,
            right: right,
            target: target,
            activeLine: 8,
            sortedArray: List.from(nums),
            currentSum: sum,
            closestSum: closest,
            actionEn: "Line 8: sum == target → Return target $target directly!",
            actionBn: "লাইন ৮: sum == target → সরাসরি টার্গেট $target রিটার্ন!",
            reasonEn: "Exact target match found! Difference is 0.",
            reasonBn: "নিখুঁত মিল পাওয়া গেছে! পার্থক্য ০।",
            isFinish: true,
          ));
          return steps;
        } else if (sum < target) {
          steps.add(ThreeSumClosestStep(
            i: i,
            left: left,
            right: right,
            target: target,
            activeLine: 10,
            sortedArray: List.from(nums),
            currentSum: sum,
            closestSum: closest,
            actionEn: "Line 10: sum ($sum) < target ($target) → left++",
            actionBn: "লাইন ১০: sum ($sum) < target ($target) → left++",
            reasonEn: "Sum is smaller than target. Increment left pointer to increase sum.",
            reasonBn: "যোগফল ছোট হওয়ায় left পয়েন্টার ডানে সরানো হলো।",
          ));
          left++;
        } else {
          steps.add(ThreeSumClosestStep(
            i: i,
            left: left,
            right: right,
            target: target,
            activeLine: 12,
            sortedArray: List.from(nums),
            currentSum: sum,
            closestSum: closest,
            actionEn: "Line 12: sum ($sum) > target ($target) → right--",
            actionBn: "লাইন ১২: sum ($sum) > target ($target) → right--",
            reasonEn: "Sum is larger than target. Decrement right pointer to decrease sum.",
            reasonBn: "যোগফল বড় হওয়ায় right পয়েন্টার বামে সরানো হলো।",
          ));
          right--;
        }
      }
    }

    // Line 16: Finish
    steps.add(ThreeSumClosestStep(
      i: n - 1,
      left: n - 1,
      right: n - 1,
      target: target,
      activeLine: 16,
      sortedArray: List.from(nums),
      currentSum: closest,
      closestSum: closest,
      actionEn: "Line 16: return closest 🎉 Closest Sum = $closest",
      actionBn: "লাইন ১৬: return closest 🎉 নিকটতম যোগফল = $closest",
      reasonEn: "Search completed! Best closest sum returned.",
      reasonBn: "সার্চ সমাপ্ত! সেরা সমাধান রিটার্ন করা হয়েছে।",
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

  void _loadPreset(List<int> arr, int target) {
    _inputController.text = arr.join(', ');
    _targetController.text = target.toString();
    _rebuildSteps();
  }

  void _handleUserAction(String action) {
    if (_userSolved || _userLeft >= _userRight) return;

    int valI = _userSortedArray[_userI];
    int valL = _userSortedArray[_userLeft];
    int valR = _userSortedArray[_userRight];
    int sum = valI + valL + valR;

    setState(() {
      if ((sum - _currentTarget).abs() < (_userClosest - _currentTarget).abs()) {
        _userClosest = sum;
      }

      if (action == "left_inc") {
        if (sum <= _currentTarget) {
          _userLeft++;
          _userFeedbackEn = "✅ Correct! Sum ($sum) <= target. Moved left++.";
          _userFeedbackBn = "✅ সঠিক পদক্ষেপ! left++ করা হলো।";
        } else {
          _userFeedbackEn = "⚠️ Sum ($sum) > target! Choose 'Move Right--'.";
          _userFeedbackBn = "⚠️ যোগফল টার্গেটের চেয়ে বড়! 'Move Right--' চাপুন।";
        }
      } else if (action == "right_dec") {
        if (sum >= _currentTarget) {
          _userRight--;
          _userFeedbackEn = "✅ Correct! Sum ($sum) >= target. Moved right--.";
          _userFeedbackBn = "✅ সঠিক পদক্ষেপ! right-- করা হলো।";
        } else {
          _userFeedbackEn = "⚠️ Sum ($sum) < target! Choose 'Move Left++'.";
          _userFeedbackBn = "⚠️ যোগফল টার্গেটের চেয়ে ছোট! 'Move Left++' চাপুন।";
        }
      }

      if (_userLeft >= _userRight) {
        _userI++;
        if (_userI >= _userSortedArray.length - 2) {
          _userSolved = true;
          _userFeedbackEn = "🎉 Perfect! Closest Sum to target $_currentTarget is $_userClosest!";
          _userFeedbackBn = "🎉 দারুণ! টার্গেট $_currentTarget এর সবচেয়ে কাছের যোগফল $_userClosest!";
        } else {
          _userLeft = _userI + 1;
          _userRight = _userSortedArray.length - 1;
        }
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
          '16. 3Sum Closest',
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
                    color: AppTheme.accentAmber.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.accentAmber),
                  ),
                  child: Text(
                    '🟡 Medium',
                    style: TextStyle(
                        color: AppTheme.accentAmber,
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
                    'LeetCode #16',
                    style: TextStyle(
                        color: AppTheme.accentNeonCyan,
                        fontWeight: FontWeight.bold,
                        fontSize: Responsive.sp(context, 12)),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.accentPink.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.accentPink),
                  ),
                  child: Text(
                    '⭐ FAANG Classic (Amazon, Meta, MS)',
                    style: TextStyle(
                        color: AppTheme.accentPink,
                        fontWeight: FontWeight.bold,
                        fontSize: Responsive.sp(context, 12)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              _isEnglish
                  ? '3Sum Closest'
                  : '৩-সাম ক্লোজেস্ট (3Sum Closest)',
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
                        ? 'Given an integer array nums of length n and an integer target, find three integers in nums such that the sum is closest to target.\n\nReturn the sum of the three integers. You may assume that each input would have exactly one solution.'
                        : 'একটি পূর্ণসংখ্যার অ্যারে nums এবং একটি target দেওয়া আছে। nums থেকে এমন ৩টি সংখ্যা বেছে নিন যাদের যোগফল target এর সবচেয়ে কাছাকাছি হয়।\n\nসেই ৩টি সংখ্যার যোগফল রিটার্ন করুন।',
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
              "nums = [-1, 2, 1, -4], target = 1",
              "Output: 2",
              _isEnglish
                  ? "Explanation: Sum closest to target 1 is 2 (-1 + 2 + 1 = 2)."
                  : "ব্যাখ্যা: target 1 এর সবচেয়ে কাছাকাছি যোগফল হলো 2 (-1 + 2 + 1 = 2)।",
            ),
            _buildExampleCard(
              "Example 2",
              "nums = [0, 0, 0], target = 1",
              "Output: 0",
              _isEnglish
                  ? "Explanation: Sum closest to target 1 is 0 (0 + 0 + 0 = 0)."
                  : "ব্যাখ্যা: 0+0+0 = 0 যোগফলটি target 1 এর সবচেয়ে কাছাকাছি।",
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
      child: ThreeSumClosestCodeFreeVisualizer(isEnglish: _isEnglish),
    );
  }

  // TAB 3: Dynamic Visualizer
  Widget _buildVisualizerTab(double hPadding) {
    final isMobile = Responsive.isMobile(context);
    final step = _steps.isEmpty
        ? ThreeSumClosestStep(
            i: 0,
            left: 0,
            right: 0,
            target: _currentTarget,
            activeLine: 0,
            sortedArray: _currentArray,
            currentSum: 0,
            closestSum: 0,
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
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _inputController,
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'monospace',
                              fontSize: Responsive.sp(context, 13)),
                          decoration: InputDecoration(
                            labelText: _isEnglish
                                ? 'Integer Array nums (comma separated)'
                                : 'ইন্টিজার অ্যারে nums (কমা দিয়ে separated)',
                            hintText: 'e.g. -1, 2, 1, -4',
                            labelStyle: TextStyle(fontSize: Responsive.sp(context, 12)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 90,
                        child: TextField(
                          controller: _targetController,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: Responsive.sp(context, 13)),
                          decoration: InputDecoration(
                            labelText: 'target',
                            labelStyle: TextStyle(fontSize: Responsive.sp(context, 12)),
                          ),
                        ),
                      ),
                    ],
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
                        _buildPresetChip('[-1, 2, 1, -4], target 1', [-1, 2, 1, -4], 1),
                        _buildPresetChip('[0, 0, 0], target 1', [0, 0, 0], 1),
                        _buildPresetChip('[1, 1, 1, 0], target -100', [1, 1, 1, 0], -100),
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
    final arr = _userSortedArray;
    final valI = _userI < arr.length ? arr[_userI] : 0;
    final valL = _userLeft < arr.length ? arr[_userLeft] : 0;
    final valR = _userRight < arr.length ? arr[_userRight] : 0;
    final currentSum = valI + valL + valR;
    final diff = (currentSum - _currentTarget).abs();
    final bestDiff = (_userClosest - _currentTarget).abs();

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
                            ? '🎮 Practice Mode: Find 3Sum Closest Yourself!'
                            : '🎮 প্র্যাকটিস মোড: নিজে ক্লোজেস্ট যোগফল বের করুন!',
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
                        ? 'Sorted Input: [${_userSortedArray.join(', ')}], Target: $_currentTarget'
                        : 'সর্টেড ইনপুট: [${_userSortedArray.join(', ')}], টার্গেট: $_currentTarget',
                    style: TextStyle(
                        color: AppTheme.accentNeonCyan,
                        fontWeight: FontWeight.bold,
                        fontSize: Responsive.sp(context, 13)),
                  ),
                  const SizedBox(height: 16),

                  // Current Sum Gauge
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
                          "Current Sum: $currentSum (diff: $diff)",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: Responsive.sp(context, 12.5)),
                        ),
                        Text(
                          "Best Closest: $_userClosest (diff: $bestDiff)",
                          style: TextStyle(
                              color: AppTheme.accentGreen,
                              fontWeight: FontWeight.bold,
                              fontSize: Responsive.sp(context, 12.5)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Sorted Array Pointers View
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(arr.length, (idx) {
                        final val = arr[idx];
                        final isI = idx == _userI;
                        final isLeft = idx == _userLeft;
                        final isRight = idx == _userRight;

                        Color boxBg = AppTheme.primaryDark;
                        Color borderColor = const Color(0xFF334155);

                        if (isI && isLeft) {
                          boxBg = AppTheme.accentPurple.withOpacity(0.3);
                          borderColor = AppTheme.accentPurple;
                        } else if (isI) {
                          boxBg = AppTheme.accentNeonCyan.withOpacity(0.25);
                          borderColor = AppTheme.accentNeonCyan;
                        } else if (isLeft) {
                          boxBg = AppTheme.accentPurple.withOpacity(0.25);
                          borderColor = AppTheme.accentPurple;
                        } else if (isRight) {
                          boxBg = AppTheme.accentAmber.withOpacity(0.25);
                          borderColor = AppTheme.accentAmber;
                        }

                        return Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: EdgeInsets.symmetric(
                            horizontal: Responsive.sp(context, 14),
                            vertical: Responsive.sp(context, 10),
                          ),
                          decoration: BoxDecoration(
                            color: boxBg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: borderColor, width: 2),
                          ),
                          child: Column(
                            children: [
                              if (isI && isLeft)
                                Text('i&L',
                                    style: TextStyle(
                                        fontSize: Responsive.sp(context, 10),
                                        color: AppTheme.accentPurple,
                                        fontWeight: FontWeight.bold))
                              else if (isI)
                                Text('i',
                                    style: TextStyle(
                                        fontSize: Responsive.sp(context, 10),
                                        color: AppTheme.accentNeonCyan,
                                        fontWeight: FontWeight.bold))
                              else if (isLeft)
                                Text('Left',
                                    style: TextStyle(
                                        fontSize: Responsive.sp(context, 10),
                                        color: AppTheme.accentPurple,
                                        fontWeight: FontWeight.bold))
                              else if (isRight)
                                Text('Right',
                                    style: TextStyle(
                                        fontSize: Responsive.sp(context, 10),
                                        color: AppTheme.accentAmber,
                                        fontWeight: FontWeight.bold))
                              else
                                Text(' ',
                                    style: TextStyle(fontSize: Responsive.sp(context, 10))),
                              const SizedBox(height: 4),
                              Text(
                                '$val',
                                style: TextStyle(
                                    fontSize: Responsive.sp(context, 18),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '[$idx]',
                                style: TextStyle(
                                    fontSize: Responsive.sp(context, 9),
                                    color: AppTheme.textMuted),
                              ),
                            ],
                          ),
                        );
                      }),
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
                            : () => _handleUserAction("left_inc"),
                        icon: Icon(Icons.arrow_forward, size: Responsive.sp(context, 16)),
                        label: Text(
                            _isEnglish
                                ? 'Move Left++ (Sum <= Target)'
                                : 'Left++ করুন (Sum <= Target)',
                            style: TextStyle(fontSize: Responsive.sp(context, 13))),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accentNeonCyan),
                      ),
                      ElevatedButton.icon(
                        onPressed: _userSolved || _userLeft >= _userRight
                            ? null
                            : () => _handleUserAction("right_dec"),
                        icon: Icon(Icons.arrow_back, size: Responsive.sp(context, 16)),
                        label: Text(
                            _isEnglish
                                ? 'Move Right-- (Sum >= Target)'
                                : 'Right-- করুন (Sum >= Target)',
                            style: TextStyle(fontSize: Responsive.sp(context, 13))),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accentAmber),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            List<int> sorted = List.from(_currentArray);
                            sorted.sort();
                            _userSortedArray = List.from(sorted);
                            _userI = 0;
                            _userLeft = 1;
                            _userRight = sorted.length - 1;
                            _userClosest = sorted[0] + sorted[1] + sorted[sorted.length - 1];
                            _userSolved = false;
                            _userFeedbackEn = "Reset done! Evaluate sums.";
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
                                ? "• Time Complexity: O(N²) — Sorting takes O(N log N), outer loop runs N times, inner Two Pointers search takes O(N).\n• Space Complexity: O(1) auxiliary space."
                                : "• টাইম কমপ্লেক্সিটি: O(N²) — সর্টিং এ O(N log N), আউটার লুপে N এবং ইনার টু-পয়েন্টারে O(N)।\n• স্পেস কমপ্লেক্সিটি: O(1) অতিরিক্ত মেমোরি।",
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

  Widget _buildPresetChip(String label, List<int> arr, int target) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ActionChip(
        label: Text(label,
            style: TextStyle(
                fontSize: Responsive.sp(context, 11), color: Colors.white)),
        backgroundColor: AppTheme.primaryDark,
        onPressed: () => _loadPreset(arr, target),
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
      "int threeSumClosest(vector<int>& nums, int target) {",
      "    sort(nums.begin(), nums.end());",
      "    int closest = nums[0] + nums[1] + nums[2];",
      "    for (int i = 0; i < nums.size() - 2; i++) {",
      "        int left = i + 1, right = nums.size() - 1;",
      "        while (left < right) {",
      "            int sum = nums[i] + nums[left] + nums[right];",
      "            if (abs(sum - target) < abs(closest - target)) closest = sum;",
      "            if (sum == target) return target;",
      "            if (sum < target) left++;",
      "            else right--;",
      "        }",
      "    }",
      "    return closest;",
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

  Widget _buildArrayVisualizationBox(ThreeSumClosestStep step) {
    final arr = step.sortedArray;

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
                "Sorted Array Pointers State",
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
                  "Target: ${step.target}",
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
              children: List.generate(arr.length, (idx) {
                final val = arr[idx];
                final isI = idx == step.i;
                final isLeft = idx == step.left;
                final isRight = idx == step.right;

                Color boxBg = AppTheme.primaryDark;
                Color borderColor = const Color(0xFF334155);

                if (isI && isLeft) {
                  boxBg = AppTheme.accentPurple.withOpacity(0.35);
                  borderColor = AppTheme.accentPurple;
                } else if (isI) {
                  boxBg = AppTheme.accentNeonCyan.withOpacity(0.25);
                  borderColor = AppTheme.accentNeonCyan;
                } else if (isLeft) {
                  boxBg = AppTheme.accentPurple.withOpacity(0.25);
                  borderColor = AppTheme.accentPurple;
                } else if (isRight) {
                  boxBg = AppTheme.accentAmber.withOpacity(0.25);
                  borderColor = AppTheme.accentAmber;
                }

                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: EdgeInsets.symmetric(
                    horizontal: Responsive.sp(context, 12),
                    vertical: Responsive.sp(context, 10),
                  ),
                  decoration: BoxDecoration(
                    color: boxBg,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: borderColor, width: 2),
                  ),
                  child: Column(
                    children: [
                      if (isI && isLeft)
                        Text('i&L',
                            style: TextStyle(
                                fontSize: Responsive.sp(context, 9.5),
                                color: AppTheme.accentPurple,
                                fontWeight: FontWeight.bold))
                      else if (isI)
                        Text('i',
                            style: TextStyle(
                                fontSize: Responsive.sp(context, 9.5),
                                color: AppTheme.accentNeonCyan,
                                fontWeight: FontWeight.bold))
                      else if (isLeft)
                        Text('Left',
                            style: TextStyle(
                                fontSize: Responsive.sp(context, 9.5),
                                color: AppTheme.accentPurple,
                                fontWeight: FontWeight.bold))
                      else if (isRight)
                        Text('Right',
                            style: TextStyle(
                                fontSize: Responsive.sp(context, 9.5),
                                color: AppTheme.accentAmber,
                                fontWeight: FontWeight.bold))
                      else
                        Text(' ',
                            style: TextStyle(fontSize: Responsive.sp(context, 9.5))),
                      const SizedBox(height: 4),
                      Text(
                        '$val',
                        style: TextStyle(
                          fontSize: Responsive.sp(context, 16),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '[$idx]',
                        style: TextStyle(
                            fontSize: Responsive.sp(context, 9),
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
    int threeSumClosest(vector<int>& nums, int target) {
        sort(nums.begin(), nums.end());
        int closest = nums[0] + nums[1] + nums[2];
        int n = nums.size();
        
        for (int i = 0; i < n - 2; i++) {
            int left = i + 1, right = n - 1;
            while (left < right) {
                int sum = nums[i] + nums[left] + nums[right];
                if (abs(sum - target) < abs(closest - target)) {
                    closest = sum;
                }
                if (sum == target) return target;
                if (sum < target) {
                    left++;
                } else {
                    right--;
                }
            }
        }
        return closest;
    }
};""";
    } else if (lang == "Java") {
      code = """
class Solution {
    public int threeSumClosest(int[] nums, int target) {
        Arrays.sort(nums);
        int closest = nums[0] + nums[1] + nums[2];
        int n = nums.length;
        
        for (int i = 0; i < n - 2; i++) {
            int left = i + 1, right = n - 1;
            while (left < right) {
                int sum = nums[i] + nums[left] + nums[right];
                if (Math.abs(sum - target) < Math.abs(closest - target)) {
                    closest = sum;
                }
                if (sum == target) return target;
                if (sum < target) {
                    left++;
                } else {
                    right--;
                }
            }
        }
        return closest;
    }
}""";
    } else if (lang == "Python") {
      code = """
class Solution:
    def threeSumClosest(self, nums: List[int], target: int) -> int:
        nums.sort()
        closest = nums[0] + nums[1] + nums[2]
        n = len(nums)
        
        for i in range(n - 2):
            left, right = i + 1, n - 1
            while left < right:
                total = nums[i] + nums[left] + nums[right]
                if abs(total - target) < abs(closest - target):
                    closest = total
                if total == target:
                    return target
                if total < target:
                    left += 1
                else:
                    right -= 1
        return closest""";
    } else {
      code = """
int threeSumClosest(List<int> nums, int target) {
  nums.sort();
  int closest = nums[0] + nums[1] + nums[2];
  int n = nums.length;

  for (int i = 0; i < n - 2; i++) {
    int left = i + 1, right = n - 1;
    while (left < right) {
      int sum = nums[i] + nums[left] + nums[right];
      if ((sum - target).abs() < (closest - target).abs()) {
        closest = sum;
      }
      if (sum == target) return target;
      if (sum < target) {
        left++;
      } else {
        right--;
      }
    }
  }
  return closest;
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
