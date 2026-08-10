import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import 'package:algorithmix/ui/features/core_patterns/widgets/four_sum_code_free_visualizer.dart';

class FourSumStep {
  final int i;
  final int j;
  final int left;
  final int right;
  final int target;
  final int activeLine;
  final List<int> sortedArray;
  final int currentSum;
  final List<List<int>> collectedQuads;
  final String actionEn;
  final String actionBn;
  final String reasonEn;
  final String reasonBn;
  final bool isFinish;

  const FourSumStep({
    required this.i,
    required this.j,
    required this.left,
    required this.right,
    required this.target,
    required this.activeLine,
    required this.sortedArray,
    required this.currentSum,
    required this.collectedQuads,
    required this.actionEn,
    required this.actionBn,
    required this.reasonEn,
    required this.reasonBn,
    this.isFinish = false,
  });
}

class FourSumDetailScreen extends StatefulWidget {
  const FourSumDetailScreen({super.key});

  @override
  State<FourSumDetailScreen> createState() => _FourSumDetailScreenState();
}

class _FourSumDetailScreenState extends State<FourSumDetailScreen>
    with SingleTickerProviderStateMixin {
  bool _isEnglish = true;
  late TabController _tabController;

  // Custom Input State
  final TextEditingController _inputController =
      TextEditingController(text: "1, 0, -1, 0, -2, 2");
  final TextEditingController _targetController =
      TextEditingController(text: "0");

  List<int> _currentArray = [1, 0, -1, 0, -2, 2];
  int _currentTarget = 0;

  List<FourSumStep> _steps = [];

  // Playback Control
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  // Practice Mode State
  bool _showAnswer = false;
  int _userI = 0;
  int _userJ = 1;
  int _userLeft = 2;
  int _userRight = 5;
  List<int> _userSortedArray = [-2, -1, 0, 0, 1, 2];
  List<List<int>> _userCollectedQuads = [];
  String _userFeedbackEn = "Compare 4Sum to target. Choose 'Collect Quadruplet', 'Move Left++', or 'Move Right--'!";
  String _userFeedbackBn = "৪-সাম এবং টার্গেট তুলনা করে সঠিক পদক্ষেপ নিন!";
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
        parsed = [1, 0, -1, 0, -2, 2];
      }
      _currentArray = parsed;
    } catch (_) {
      _currentArray = [1, 0, -1, 0, -2, 2];
      _currentTarget = 0;
    }

    List<int> sorted = List.from(_currentArray);
    sorted.sort();
    _userSortedArray = List.from(sorted);
    _userI = 0;
    _userJ = 1;
    _userLeft = 2;
    _userRight = sorted.length - 1;
    _userCollectedQuads = [];
    _userSolved = false;
    _userFeedbackEn = "Start evaluating 4Sum quadruplets!";
    _userFeedbackBn = "সর্টেড অ্যারেতে ৪-সাম খোঁজা শুরু করুন!";

    _steps = _generateSteps(_currentArray, _currentTarget);
    setState(() {});
  }

  List<FourSumStep> _generateSteps(List<int> orig, int target) {
    List<FourSumStep> steps = [];
    List<int> nums = List.from(orig);
    nums.sort();

    int n = nums.length;
    if (n < 4) return steps;

    List<List<int>> collected = [];

    // Line 2: Sort
    steps.add(FourSumStep(
      i: 0,
      j: 1,
      left: 2,
      right: n - 1,
      target: target,
      activeLine: 2,
      sortedArray: List.from(nums),
      currentSum: nums[0] + nums[1] + nums[2] + nums[n - 1],
      collectedQuads: [],
      actionEn: "Line 2: sort(nums) → [${nums.join(', ')}]",
      actionBn: "লাইন ২: sort(nums) → [${nums.join(', ')}]",
      reasonEn: "Array sorted. Prepares 4 pointers.",
      reasonBn: "অ্যারে সর্ট করা হলো। ৪টি পয়েন্টার সক্রিয়।",
    ));

    for (int i = 0; i < n - 3; i++) {
      if (i > 0 && nums[i] == nums[i - 1]) continue;

      for (int j = i + 1; j < n - 2; j++) {
        if (j > i + 1 && nums[j] == nums[j - 1]) continue;

        int left = j + 1;
        int right = n - 1;

        steps.add(FourSumStep(
          i: i,
          j: j,
          left: left,
          right: right,
          target: target,
          activeLine: 6,
          sortedArray: List.from(nums),
          currentSum: nums[i] + nums[j] + nums[left] + nums[right],
          collectedQuads: List.from(collected),
          actionEn: "Line 6: Fix i = $i (${nums[i]}), j = $j (${nums[j]}), left = $left, right = $right",
          actionBn: "লাইন ৬: স্থানাঙ্ক i = $i (${nums[i]}), j = $j (${nums[j]}), left = $left, right = $right",
          reasonEn: "Fix outer elements nums[$i] and nums[$j], search with inner left & right pointers.",
          reasonBn: "আউটার উপাদানদ্বয় নির্দিষ্ট করে ইনার টু-পয়েন্টার স্ক্যান শুরু।",
        ));

        while (left < right) {
          int sum = nums[i] + nums[j] + nums[left] + nums[right];

          if (sum == target) {
            List<int> quad = [nums[i], nums[j], nums[left], nums[right]];
            collected.add(List.from(quad));

            steps.add(FourSumStep(
              i: i,
              j: j,
              left: left,
              right: right,
              target: target,
              activeLine: 8,
              sortedArray: List.from(nums),
              currentSum: sum,
              collectedQuads: List.from(collected),
              actionEn: "Line 8: sum == target → Collect Quadruplet [${quad.join(', ')}] 🎉",
              actionBn: "লাইন ৮: sum == target → কুয়াড্রুপলেট সংগৃহীত [${quad.join(', ')}] 🎉",
              reasonEn: "Quadruplet sum matches target $target exactly!",
              reasonBn: "যোগফল নিখুঁতভাবে টার্গেট $target এর সমান!",
            ));

            while (left < right && nums[left] == nums[left + 1]) left++;
            while (left < right && nums[right] == nums[right - 1]) right--;

            left++;
            right--;
          } else if (sum < target) {
            steps.add(FourSumStep(
              i: i,
              j: j,
              left: left,
              right: right,
              target: target,
              activeLine: 11,
              sortedArray: List.from(nums),
              currentSum: sum,
              collectedQuads: List.from(collected),
              actionEn: "Line 11: sum ($sum) < target ($target) → left++",
              actionBn: "লাইন ১১: sum ($sum) < target ($target) → left++",
              reasonEn: "Sum is smaller than target. Increment left++ to increase sum.",
              reasonBn: "যোগফল ছোট হওয়ায় left পয়েন্টার ডানে সরানো হলো।",
            ));
            left++;
          } else {
            steps.add(FourSumStep(
              i: i,
              j: j,
              left: left,
              right: right,
              target: target,
              activeLine: 13,
              sortedArray: List.from(nums),
              currentSum: sum,
              collectedQuads: List.from(collected),
              actionEn: "Line 13: sum ($sum) > target ($target) → right--",
              actionBn: "লাইন ১৩: sum ($sum) > target ($target) → right--",
              reasonEn: "Sum is larger than target. Decrement right-- to decrease sum.",
              reasonBn: "যোগফল বড় হওয়ায় right পয়েন্টার বামে সরানো হলো।",
            ));
            right--;
          }
        }
      }
    }

    // Line 17: Finish
    steps.add(FourSumStep(
      i: n - 1,
      j: n - 1,
      left: n - 1,
      right: n - 1,
      target: target,
      activeLine: 17,
      sortedArray: List.from(nums),
      currentSum: target,
      collectedQuads: List.from(collected),
      actionEn: "Line 17: return res 🎉 Found ${collected.length} Quadruplets",
      actionBn: "লাইন ১৭: return res 🎉 মোট ${collected.length} টি কুয়াড্রুপলেট",
      reasonEn: "Completed 4Sum algorithm in O(N³) cubic time complexity!",
      reasonBn: "O(N³) সময়ে সর্টেড ৪-সাম অ্যালগরিদম সম্পন্ন!",
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
    int valJ = _userSortedArray[_userJ];
    int valL = _userSortedArray[_userLeft];
    int valR = _userSortedArray[_userRight];
    int sum = valI + valJ + valL + valR;

    setState(() {
      if (action == "collect") {
        if (sum == _currentTarget) {
          List<int> q = [valI, valJ, valL, valR];
          _userCollectedQuads.add(q);
          _userLeft++;
          _userRight--;
          _userFeedbackEn = "✅ Correct! Collected Quadruplet [${q.join(', ')}].";
          _userFeedbackBn = "✅ সঠিক! কুয়াড্রুপলেট [${q.join(', ')}] সংগৃহীত হলো।";
        } else {
          _userFeedbackEn = "⚠️ Sum ($sum) != target ($_currentTarget)! Choose 'Move Left++' or 'Move Right--'.";
          _userFeedbackBn = "⚠️ যোগফল ($sum) টার্গেটের সমান নয়! পয়েন্টার সরান।";
        }
      } else if (action == "left_inc") {
        if (sum < _currentTarget) {
          _userLeft++;
          _userFeedbackEn = "✅ Correct! Sum ($sum) < target. Moved left++.";
          _userFeedbackBn = "✅ সঠিক পদক্ষেপ! left++ করা হলো।";
        } else {
          _userFeedbackEn = "⚠️ Sum ($sum) >= target! Choose 'Collect' or 'Move Right--'.";
          _userFeedbackBn = "⚠️ যোগফল টার্গেটের চেয়ে বড় বা সমান! সঠিক বাটন চাপুন।";
        }
      } else if (action == "right_dec") {
        if (sum > _currentTarget) {
          _userRight--;
          _userFeedbackEn = "✅ Correct! Sum ($sum) > target. Moved right--.";
          _userFeedbackBn = "✅ সঠিক পদক্ষেপ! right-- করা হলো।";
        } else {
          _userFeedbackEn = "⚠️ Sum ($sum) <= target! Choose 'Collect' or 'Move Left++'.";
          _userFeedbackBn = "⚠️ যোগফল টার্গেটের চেয়ে ছোট বা সমান! সঠিক বাটন চাপুন।";
        }
      }

      if (_userLeft >= _userRight) {
        _userJ++;
        if (_userJ >= _userSortedArray.length - 2) {
          _userI++;
          _userJ = _userI + 1;
        }
        if (_userI >= _userSortedArray.length - 3) {
          _userSolved = true;
          _userFeedbackEn = "🎉 Perfect! Found all unique 4Sum quadruplets for target $_currentTarget!";
          _userFeedbackBn = "🎉 দারুণ! টার্গেট $_currentTarget এর সকল ৪-সাম কুয়াড্রুপলেট পাওয়া গেছে!";
        } else {
          _userLeft = _userJ + 1;
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
          '18. 4Sum',
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
                    'LeetCode #18',
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
                    '⭐ K-Sum Pattern Generalization',
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
              _isEnglish ? '4Sum' : '৪-সাম (4Sum)',
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
                        ? 'Given an array nums of n integers, return an array of all the unique quadruplets [nums[a], nums[b], nums[c], nums[d]] such that:\n\n• 0 <= a, b, c, d < n\n• a, b, c, and d are distinct.\n• nums[a] + nums[b] + nums[c] + nums[d] == target\n\nYou may return the answer in any order.'
                        : 'n সংখ্যক ইন্টিজারের একটি অ্যারে nums এবং একটি target দেওয়া আছে। সকল অনন্য কুয়াড্রুপলেট [nums[a], nums[b], nums[c], nums[d]] বের করুন যাদের যোগফল target এর সমান।',
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
              "nums = [1, 0, -1, 0, -2, 2], target = 0",
              "Output: [[-2, -1, 1, 2], [-2, 0, 0, 2], [-1, 0, 0, 1]]",
              _isEnglish
                  ? "Explanation: 3 unique quadruplets sum up to 0."
                  : "ব্যাখ্যা: ৩টি অনন্য কুয়াড্রুপলেটের যোগফল ০।",
            ),
            _buildExampleCard(
              "Example 2",
              "nums = [2, 2, 2, 2, 2], target = 8",
              "Output: [[2, 2, 2, 2]]",
              _isEnglish
                  ? "Explanation: Only 1 unique quadruplet exists despite duplicate 2s."
                  : "ব্যাখ্যা: ডুপ্লিকেট থাকা সত্ত্বেও কেবল ১টি অনন্য কুয়াড্রুপলেট বিদ্যমান।",
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
      child: FourSumCodeFreeVisualizer(isEnglish: _isEnglish),
    );
  }

  // TAB 3: Dynamic Visualizer
  Widget _buildVisualizerTab(double hPadding) {
    final isMobile = Responsive.isMobile(context);
    final step = _steps.isEmpty
        ? FourSumStep(
            i: 0,
            j: 1,
            left: 2,
            right: 0,
            target: _currentTarget,
            activeLine: 0,
            sortedArray: _currentArray,
            currentSum: 0,
            collectedQuads: [],
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
                            hintText: 'e.g. 1, 0, -1, 0, -2, 2',
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
                        _buildPresetChip('[1,0,-1,0,-2,2], target 0', [1, 0, -1, 0, -2, 2], 0),
                        _buildPresetChip('[2,2,2,2,2], target 8', [2, 2, 2, 2, 2], 8),
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
    final valJ = _userJ < arr.length ? arr[_userJ] : 0;
    final valL = _userLeft < arr.length ? arr[_userLeft] : 0;
    final valR = _userRight < arr.length ? arr[_userRight] : 0;
    final currentSum = valI + valJ + valL + valR;

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
                            ? '🎮 Practice Mode: Find 4Sum Quadruplets Yourself!'
                            : '🎮 প্র্যাকটিস মোড: নিজে ৪-সাম কুয়াড্রুপলেট বের করুন!',
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

                  // Current Sum & Quad List
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
                          "Current Sum: $currentSum",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: Responsive.sp(context, 12.5)),
                        ),
                        Text(
                          "Collected: ${_userCollectedQuads.length}",
                          style: TextStyle(
                              color: AppTheme.accentGreen,
                              fontWeight: FontWeight.bold,
                              fontSize: Responsive.sp(context, 12.5)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Pointers Array View
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(arr.length, (idx) {
                        final val = arr[idx];
                        final isI = idx == _userI;
                        final isJ = idx == _userJ;
                        final isLeft = idx == _userLeft;
                        final isRight = idx == _userRight;

                        Color boxBg = AppTheme.primaryDark;
                        Color borderColor = const Color(0xFF334155);

                        if (isI) {
                          boxBg = AppTheme.accentNeonCyan.withOpacity(0.25);
                          borderColor = AppTheme.accentNeonCyan;
                        } else if (isJ) {
                          boxBg = AppTheme.accentPurple.withOpacity(0.25);
                          borderColor = AppTheme.accentPurple;
                        } else if (isLeft) {
                          boxBg = AppTheme.accentAmber.withOpacity(0.25);
                          borderColor = AppTheme.accentAmber;
                        } else if (isRight) {
                          boxBg = AppTheme.accentPink.withOpacity(0.25);
                          borderColor = AppTheme.accentPink;
                        }

                        List<String> ptrs = [];
                        if (isI) ptrs.add("i");
                        if (isJ) ptrs.add("j");
                        if (isLeft) ptrs.add("Left");
                        if (isRight) ptrs.add("Right");

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
                              Text(
                                ptrs.join('&'),
                                style: TextStyle(
                                  fontSize: Responsive.sp(context, 10),
                                  color: isI
                                      ? AppTheme.accentNeonCyan
                                      : (isJ
                                          ? AppTheme.accentPurple
                                          : (isLeft
                                              ? AppTheme.accentAmber
                                              : AppTheme.accentPink)),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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
                            : () => _handleUserAction("collect"),
                        icon: Icon(Icons.add_task, size: Responsive.sp(context, 16)),
                        label: Text(
                            _isEnglish
                                ? 'Collect Quadruplet (Sum == Target)'
                                : 'সংগ্রহ করুন (Sum == Target)',
                            style: TextStyle(fontSize: Responsive.sp(context, 13))),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accentGreen),
                      ),
                      ElevatedButton.icon(
                        onPressed: _userSolved || _userLeft >= _userRight
                            ? null
                            : () => _handleUserAction("left_inc"),
                        icon: Icon(Icons.arrow_forward, size: Responsive.sp(context, 16)),
                        label: Text(
                            _isEnglish
                                ? 'Move Left++ (Sum < Target)'
                                : 'Left++ করুন (Sum < Target)',
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
                                ? 'Move Right-- (Sum > Target)'
                                : 'Right-- করুন (Sum > Target)',
                            style: TextStyle(fontSize: Responsive.sp(context, 13))),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accentPink),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            List<int> sorted = List.from(_currentArray);
                            sorted.sort();
                            _userSortedArray = List.from(sorted);
                            _userI = 0;
                            _userJ = 1;
                            _userLeft = 2;
                            _userRight = sorted.length - 1;
                            _userCollectedQuads = [];
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
                                ? "• Time Complexity: O(N³) — Sorting takes O(N log N), double outer loops take O(N²), inner two pointers search takes O(N).\n• Space Complexity: O(1) auxiliary space."
                                : "• টাইম কমপ্লেক্সিটি: O(N³) — সর্টিং এ O(N log N), আউটার দুটি লুপে O(N²) এবং ইনার টু-পয়েন্টারে O(N)।\n• স্পেস কমপ্লেক্সিটি: O(1) অতিরিক্ত মেমোরি।",
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
      "vector<vector<int>> fourSum(vector<int>& nums, int target) {",
      "    sort(nums.begin(), nums.end());",
      "    vector<vector<int>> res;",
      "    int n = nums.size();",
      "    for (int i = 0; i < n - 3; i++) {",
      "        if (i > 0 && nums[i] == nums[i - 1]) continue;",
      "        for (int j = i + 1; j < n - 2; j++) {",
      "            if (j > i + 1 && nums[j] == nums[j - 1]) continue;",
      "            int left = j + 1, right = n - 1;",
      "            while (left < right) {",
      "                long long sum = (long long)nums[i] + nums[j] + nums[left] + nums[right];",
      "                if (sum == target) {",
      "                    res.push_back({nums[i], nums[j], nums[left], nums[right]});",
      "                    while (left < right && nums[left] == nums[left + 1]) left++;",
      "                    while (left < right && nums[right] == nums[right - 1]) right--;",
      "                    left++; right--;",
      "                } else if (sum < target) left++;",
      "                else right--;",
      "            }",
      "        }",
      "    }",
      "    return res;",
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

  Widget _buildArrayVisualizationBox(FourSumStep step) {
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
                "Sorted Array 4 Pointers State",
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
                final isJ = idx == step.j;
                final isLeft = idx == step.left;
                final isRight = idx == step.right;

                Color boxBg = AppTheme.primaryDark;
                Color borderColor = const Color(0xFF334155);

                if (isI) {
                  boxBg = AppTheme.accentNeonCyan.withOpacity(0.25);
                  borderColor = AppTheme.accentNeonCyan;
                } else if (isJ) {
                  boxBg = AppTheme.accentPurple.withOpacity(0.25);
                  borderColor = AppTheme.accentPurple;
                } else if (isLeft) {
                  boxBg = AppTheme.accentAmber.withOpacity(0.25);
                  borderColor = AppTheme.accentAmber;
                } else if (isRight) {
                  boxBg = AppTheme.accentPink.withOpacity(0.25);
                  borderColor = AppTheme.accentPink;
                }

                List<String> ptrs = [];
                if (isI) ptrs.add("i");
                if (isJ) ptrs.add("j");
                if (isLeft) ptrs.add("Left");
                if (isRight) ptrs.add("Right");

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
                      Text(
                        ptrs.join('&'),
                        style: TextStyle(
                          fontSize: Responsive.sp(context, 9.5),
                          color: isI
                              ? AppTheme.accentNeonCyan
                              : (isJ
                                  ? AppTheme.accentPurple
                                  : (isLeft
                                      ? AppTheme.accentAmber
                                      : AppTheme.accentPink)),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
    vector<vector<int>> fourSum(vector<int>& nums, int target) {
        sort(nums.begin(), nums.end());
        vector<vector<int>> res;
        int n = nums.size();
        
        for (int i = 0; i < n - 3; i++) {
            if (i > 0 && nums[i] == nums[i - 1]) continue;
            for (int j = i + 1; j < n - 2; j++) {
                if (j > i + 1 && nums[j] == nums[j - 1]) continue;
                int left = j + 1, right = n - 1;
                while (left < right) {
                    long long sum = (long long)nums[i] + nums[j] + nums[left] + nums[right];
                    if (sum == target) {
                        res.push_back({nums[i], nums[j], nums[left], nums[right]});
                        while (left < right && nums[left] == nums[left + 1]) left++;
                        while (left < right && nums[right] == nums[right - 1]) right--;
                        left++;
                        right--;
                    } else if (sum < target) {
                        left++;
                    } else {
                        right--;
                    }
                }
            }
        }
        return res;
    }
};""";
    } else if (lang == "Java") {
      code = """
class Solution {
    public List<List<Integer>> fourSum(int[] nums, int target) {
        Arrays.sort(nums);
        List<List<Integer>> res = new ArrayList<>();
        int n = nums.length;
        
        for (int i = 0; i < n - 3; i++) {
            if (i > 0 && nums[i] == nums[i - 1]) continue;
            for (int j = i + 1; j < n - 2; j++) {
                if (j > i + 1 && nums[j] == nums[j - 1]) continue;
                int left = j + 1, right = n - 1;
                while (left < right) {
                    long sum = (long)nums[i] + nums[j] + nums[left] + nums[right];
                    if (sum == target) {
                        res.add(Arrays.asList(nums[i], nums[j], nums[left], nums[right]));
                        while (left < right && nums[left] == nums[left + 1]) left++;
                        while (left < right && nums[right] == nums[right - 1]) right--;
                        left++;
                        right--;
                    } else if (sum < target) {
                        left++;
                    } else {
                        right--;
                    }
                }
            }
        }
        return res;
    }
}""";
    } else if (lang == "Python") {
      code = """
class Solution:
    def fourSum(self, nums: List[int], target: int) -> List[List[int]]:
        nums.sort()
        res = []
        n = len(nums)
        
        for i in range(n - 3):
            if i > 0 and nums[i] == nums[i - 1]:
                continue
            for j in range(i + 1, n - 2):
                if j > i + 1 and nums[j] == nums[j - 1]:
                    continue
                left, right = j + 1, n - 1
                while left < right:
                    total = nums[i] + nums[j] + nums[left] + nums[right]
                    if total == target:
                        res.append([nums[i], nums[j], nums[left], nums[right]])
                        while left < right and nums[left] == nums[left + 1]:
                            left += 1
                        while left < right and nums[right] == nums[right - 1]:
                            right -= 1
                        left += 1
                        right -= 1
                    elif total < target:
                        left += 1
                    else:
                        right -= 1
        return res""";
    } else {
      code = """
List<List<int>> fourSum(List<int> nums, int target) {
  nums.sort();
  List<List<int>> res = [];
  int n = nums.length;

  for (int i = 0; i < n - 3; i++) {
    if (i > 0 && nums[i] == nums[i - 1]) continue;
    for (int j = i + 1; j < n - 2; j++) {
      if (j > i + 1 && nums[j] == nums[j - 1]) continue;
      int left = j + 1, right = n - 1;
      while (left < right) {
        int sum = nums[i] + nums[j] + nums[left] + nums[right];
        if (sum == target) {
          res.add([nums[i], nums[j], nums[left], nums[right]]);
          while (left < right && nums[left] == nums[left + 1]) left++;
          while (left < right && nums[right] == nums[right - 1]) right--;
          left++;
          right--;
        } else if (sum < target) {
          left++;
        } else {
          right--;
        }
      }
    }
  }
  return res;
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
