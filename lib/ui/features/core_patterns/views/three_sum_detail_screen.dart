import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import 'package:algorithmix/ui/features/core_patterns/widgets/three_sum_code_free_visualizer.dart';

class ThreeSumStep {
  final int i;
  final int left;
  final int right;
  final int activeLine;
  final List<int> sortedArray;
  final List<List<int>> tripletsFound;
  final String actionEn;
  final String actionBn;
  final String reasonEn;
  final String reasonBn;
  final bool isFinish;

  const ThreeSumStep({
    required this.i,
    required this.left,
    required this.right,
    required this.activeLine,
    required this.sortedArray,
    required this.tripletsFound,
    required this.actionEn,
    required this.actionBn,
    required this.reasonEn,
    required this.reasonBn,
    this.isFinish = false,
  });
}

class ThreeSumDetailScreen extends StatefulWidget {
  const ThreeSumDetailScreen({super.key});

  @override
  State<ThreeSumDetailScreen> createState() => _ThreeSumDetailScreenState();
}

class _ThreeSumDetailScreenState extends State<ThreeSumDetailScreen>
    with SingleTickerProviderStateMixin {
  bool _isEnglish = true;
  late TabController _tabController;

  // Custom Input State
  final TextEditingController _inputController =
      TextEditingController(text: "-1, 0, 1, 2, -1, -4");

  List<int> _currentArray = [-1, 0, 1, 2, -1, -4];
  List<ThreeSumStep> _steps = [];

  // Playback Control
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  // Practice Mode State
  bool _showAnswer = false;
  int _userI = 0;
  int _userLeft = 1;
  int _userRight = 5;
  List<int> _userSortedArray = [-4, -1, -1, 0, 1, 2];
  List<List<int>> _userTriplets = [];
  String _userFeedbackEn = "Compare sum = nums[i] + nums[left] + nums[right]. Choose action!";
  String _userFeedbackBn = "যোগফল হিসেব করে সঠিক সিদ্ধান্ত নিন!";
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
        parsed = [-1, 0, 1, 2, -1, -4];
      }
      _currentArray = parsed;
    } catch (_) {
      _currentArray = [-1, 0, 1, 2, -1, -4];
    }

    List<int> sorted = List.from(_currentArray);
    sorted.sort();
    _userSortedArray = List.from(sorted);
    _userI = 0;
    _userLeft = 1;
    _userRight = sorted.length - 1;
    _userTriplets = [];
    _userSolved = false;
    _userFeedbackEn = "Start evaluating triplets on sorted array!";
    _userFeedbackBn = "সর্টেড অ্যারেতে ট্রিপলেট অনুসন্ধান শুরু করুন!";

    _steps = _generateSteps(_currentArray);
    setState(() {});
  }

  List<ThreeSumStep> _generateSteps(List<int> orig) {
    List<ThreeSumStep> steps = [];
    List<int> nums = List.from(orig);
    nums.sort();

    int n = nums.length;
    List<List<int>> triplets = [];

    // Line 2: Sort
    steps.add(ThreeSumStep(
      i: 0,
      left: 1 < n ? 1 : 0,
      right: n > 0 ? n - 1 : 0,
      activeLine: 2,
      sortedArray: List.from(nums),
      tripletsFound: [],
      actionEn: "Line 2: sort(nums.begin(), nums.end()) → [${nums.join(', ')}]",
      actionBn: "লাইন ২: sort(nums.begin(), nums.end()) → [${nums.join(', ')}]",
      reasonEn: "Array sorted to apply Two Pointers for each outer element i.",
      reasonBn: "টু-পয়েন্টার প্রয়োগের সুবিধার্থে অ্যারে ছোট থেকে বড় সর্ট করা হলো।",
    ));

    for (int i = 0; i < n - 2; i++) {
      if (nums[i] > 0) break;

      if (i > 0 && nums[i] == nums[i - 1]) {
        steps.add(ThreeSumStep(
          i: i,
          left: i + 1,
          right: n - 1,
          activeLine: 5,
          sortedArray: List.from(nums),
          tripletsFound: List.from(triplets),
          actionEn: "Line 5: if (i > 0 && nums[i] == nums[i-1]) continue → Skip duplicate i=$i (${nums[i]})",
          actionBn: "লাইন ৫: if (i > 0 && nums[i] == nums[i-1]) continue → ডুপ্লিকেট i=$i (${nums[i]}) স্কিপ",
          reasonEn: "Skip outer element to prevent duplicate triplets.",
          reasonBn: "ডুপ্লিকেট ট্রিপলেট এড়াতে ডুপ্লিকেট i স্কিপ করা হলো।",
        ));
        continue;
      }

      int left = i + 1;
      int right = n - 1;

      // Line 6 & 7: Inner loop init
      steps.add(ThreeSumStep(
        i: i,
        left: left,
        right: right,
        activeLine: 6,
        sortedArray: List.from(nums),
        tripletsFound: List.from(triplets),
        actionEn: "Line 6 & 7: Outer i = $i (${nums[i]}), Inner left = $left, right = $right",
        actionBn: "লাইন ৬ ও ৭: আউটার i = $i (${nums[i]}), ইনার left = $left, right = $right",
        reasonEn: "Set inner bounds left and right for fixed nums[i].",
        reasonBn: "ফিক্সড nums[i] এর জন্য ইনস্পেকশন সসীমা left ও right বসানো হলো।",
      ));

      while (left < right) {
        int sum = nums[i] + nums[left] + nums[right];

        if (sum == 0) {
          triplets.add([nums[i], nums[left], nums[right]]);
          steps.add(ThreeSumStep(
            i: i,
            left: left,
            right: right,
            activeLine: 9,
            sortedArray: List.from(nums),
            tripletsFound: List.from(triplets),
            actionEn: "Line 9: sum == 0 → Triplet [${nums[i]}, ${nums[left]}, ${nums[right]}] Collected 🎉",
            actionBn: "লাইন ৯: sum == 0 → ট্রিপলেট [${nums[i]}, ${nums[left]}, ${nums[right]}] সংগৃহীত 🎉",
            reasonEn: "Found zero sum! Added to result, now shrinking window.",
            reasonBn: "০-যোগফল পাওয়া গেছে! রেজাল্টে যোগ করে উভয় পয়েন্টার সরানো হচ্ছে।",
          ));

          while (left < right && nums[left] == nums[left + 1]) left++;
          while (left < right && nums[right] == nums[right - 1]) right--;
          left++;
          right--;
        } else if (sum < 0) {
          steps.add(ThreeSumStep(
            i: i,
            left: left,
            right: right,
            activeLine: 14,
            sortedArray: List.from(nums),
            tripletsFound: List.from(triplets),
            actionEn: "Line 14: sum ($sum) < 0 → left++ (move to ${left + 1})",
            actionBn: "লাইন ১৪: sum ($sum) < 0 → left++ (${left + 1} এ সরাব)",
            reasonEn: "Sum is too small. Move left pointer rightward to increase sum.",
            reasonBn: "যোগফল ছোট হওয়ায় left পয়েন্টার ডানে সরানো হলো।",
          ));
          left++;
        } else {
          steps.add(ThreeSumStep(
            i: i,
            left: left,
            right: right,
            activeLine: 16,
            sortedArray: List.from(nums),
            tripletsFound: List.from(triplets),
            actionEn: "Line 16: sum ($sum) > 0 → right-- (move to ${right - 1})",
            actionBn: "লাইন ১৬: sum ($sum) > 0 → right-- (${right - 1} এ সরাব)",
            reasonEn: "Sum is too large. Move right pointer leftward to decrease sum.",
            reasonBn: "যোগফল বড় হওয়ায় right পয়েন্টার বামে সরানো হলো।",
          ));
          right--;
        }
      }
    }

    // Line 20: Finish
    steps.add(ThreeSumStep(
      i: n - 1,
      left: n - 1,
      right: n - 1,
      activeLine: 20,
      sortedArray: List.from(nums),
      tripletsFound: List.from(triplets),
      actionEn: "Line 20: return res 🎉 Found ${triplets.length} unique triplets",
      actionBn: "লাইন ২০: return res 🎉 মোট ${triplets.length} টি ইউনিক ট্রিপলেট পাওয়া গেছে",
      reasonEn: "Algorithm finished in O(N²) time!",
      reasonBn: "O(N²) সময়ে সম্পূর্ণ সর্টেড ৩-সাম অ্যালগরিদম সম্পন্ন!",
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

  void _loadPreset(List<int> arr) {
    _inputController.text = arr.join(', ');
    _rebuildSteps();
  }

  void _handleUserAction(String action) {
    if (_userSolved || _userLeft >= _userRight) return;

    int valI = _userSortedArray[_userI];
    int valL = _userSortedArray[_userLeft];
    int valR = _userSortedArray[_userRight];
    int sum = valI + valL + valR;

    setState(() {
      if (action == "collect") {
        if (sum == 0) {
          _userTriplets.add([valI, valL, valR]);
          _userLeft++;
          _userRight--;
          _userFeedbackEn = "✅ Correct! Triplet [$valI, $valL, $valR] collected.";
          _userFeedbackBn = "✅ সঠিক পদক্ষেপ! [$valI, $valL, $valR] ট্রিপলেটটি সংগৃহীত হলো।";
        } else {
          _userFeedbackEn = "⚠️ Sum is $sum != 0! You cannot collect a triplet.";
          _userFeedbackBn = "⚠️ যোগফল $sum != 0! ট্রিপলেট নেওয়া যাবে না।";
        }
      } else if (action == "left_inc") {
        if (sum < 0) {
          _userLeft++;
          _userFeedbackEn = "✅ Correct! Sum ($sum) was < 0. Moved left++.";
          _userFeedbackBn = "✅ সঠিক পদক্ষেপ! যোগফল $sum < 0 হওয়ায় left++ করা হলো।";
        } else {
          _userFeedbackEn = "⚠️ Sum is not < 0! Choose another action.";
          _userFeedbackBn = "⚠️ যোগফল < 0 নয়! অন্য বাটন চাপুন।";
        }
      } else if (action == "right_dec") {
        if (sum > 0) {
          _userRight--;
          _userFeedbackEn = "✅ Correct! Sum ($sum) was > 0. Moved right--.";
          _userFeedbackBn = "✅ সঠিক পদক্ষেপ! যোগফল $sum > 0 থাকায় right-- করা হলো।";
        } else {
          _userFeedbackEn = "⚠️ Sum is not > 0! Choose another action.";
          _userFeedbackBn = "⚠️ যোগফল > 0 নয়! অন্য বাটন চাপুন।";
        }
      }

      if (_userLeft >= _userRight) {
        _userI++;
        if (_userI >= _userSortedArray.length - 2) {
          _userSolved = true;
          _userFeedbackEn = "🎉 Fantastic! Found all triplets: ${_userTriplets.map((t) => '[${t.join(', ')}]').toList()}";
          _userFeedbackBn = "🎉 দারুণ! সকল ট্রিপলেট খুঁজে বের করা সম্পন্ন!";
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
          '15. 3Sum',
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
                    'LeetCode #15',
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
                    '⭐ FAANG Must-Know (Meta, Google, MS)',
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
                  ? '3Sum (Three Sum)'
                  : '৩-সাম প্রবলেম (3Sum Problem)',
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
                        ? 'Given an integer array nums, return all the triplets [nums[i], nums[j], nums[k]] such that i != j, i != k, and j != k, and nums[i] + nums[j] + nums[k] == 0.\n\nNotice that the solution set must not contain duplicate triplets.'
                        : 'একটি পূর্ণসংখ্যার অ্যারে nums দেওয়া আছে। এমন সকল ইউনিক ট্রিপলেট [nums[i], nums[j], nums[k]] বের করুন যাতে i != j, i != k, j != k এবং nums[i] + nums[j] + nums[k] == 0 হয়।\n\nমনে রাখবেন: উত্তরে কোনো ডুপ্লিকেট ট্রিপলেট রাখা যাবে না।',
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
              "nums = [-1, 0, 1, 2, -1, -4]",
              "Output: [[-1, -1, 2], [-1, 0, 1]]",
              _isEnglish
                  ? "Explanation: Triplets (-1)+(-1)+2 = 0 and (-1)+0+1 = 0. Distinct triplets only."
                  : "ব্যাখ্যা: ট্রিপলেট দুটি হলো (-1)+(-1)+2 = 0 এবং (-1)+0+1 = 0।",
            ),
            _buildExampleCard(
              "Example 2",
              "nums = [0, 1, 1]",
              "Output: []",
              _isEnglish
                  ? "Explanation: No 3 elements sum up to 0."
                  : "ব্যাখ্যা: কোনো ৩টি উপাদান যোগ করে ০ বানানো সম্ভব নয়।",
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
      child: ThreeSumCodeFreeVisualizer(isEnglish: _isEnglish),
    );
  }

  // TAB 3: Dynamic Visualizer
  Widget _buildVisualizerTab(double hPadding) {
    final isMobile = Responsive.isMobile(context);
    final step = _steps.isEmpty
        ? ThreeSumStep(
            i: 0,
            left: 0,
            right: 0,
            activeLine: 0,
            sortedArray: _currentArray,
            tripletsFound: [],
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
                          ? 'Integer Array nums (comma separated)'
                          : 'ইন্টিজার অ্যারে nums (কমা দিয়ে separated)',
                      hintText: 'e.g. -1, 0, 1, 2, -1, -4',
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
                        _buildPresetChip('[-1, 0, 1, 2, -1, -4]', [-1, 0, 1, 2, -1, -4]),
                        _buildPresetChip('[-2, 0, 0, 2, 2]', [-2, 0, 0, 2, 2]),
                        _buildPresetChip('[0, 0, 0]', [0, 0, 0]),
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
                            ? '🎮 Practice Mode: Find 3Sum Triplets Yourself!'
                            : '🎮 প্র্যাকটিস মোড: নিজে ট্রিপলেট সলভ করুন!',
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
                        ? 'Sorted Input: [${_userSortedArray.join(', ')}]'
                        : 'সর্টেড ইনপুট: [${_userSortedArray.join(', ')}]',
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "nums[i] ($valI) + nums[left] ($valL) + nums[right] ($valR) = ",
                          style: TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: Responsive.sp(context, 13)),
                        ),
                        Text(
                          "$currentSum",
                          style: TextStyle(
                              color: currentSum == 0
                                  ? AppTheme.accentGreen
                                  : (currentSum < 0
                                      ? AppTheme.accentNeonCyan
                                      : AppTheme.accentAmber),
                              fontWeight: FontWeight.bold,
                              fontSize: Responsive.sp(context, 16)),
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
                            : () => _handleUserAction("collect"),
                        icon: Icon(Icons.stars, size: Responsive.sp(context, 16)),
                        label: Text(
                            _isEnglish
                                ? 'Collect Triplet (Sum == 0)'
                                : 'ট্রিপলেট জমা করুন (Sum == 0)',
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
                                ? 'Move Left++ (Sum < 0)'
                                : 'Left++ করুন (Sum < 0)',
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
                                ? 'Move Right-- (Sum > 0)'
                                : 'Right-- করুন (Sum > 0)',
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
                            _userTriplets = [];
                            _userSolved = false;
                            _userFeedbackEn = "Reset done! Inspect triplets.";
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
                                ? "• Time Complexity: O(N²) — Sorting takes O(N log N), outer loop runs N times, inner Two Pointers search takes O(N).\n• Space Complexity: O(1) auxiliary space (excluding result array)."
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

  Widget _buildPresetChip(String label, List<int> arr) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ActionChip(
        label: Text(label,
            style: TextStyle(
                fontSize: Responsive.sp(context, 11), color: Colors.white)),
        backgroundColor: AppTheme.primaryDark,
        onPressed: () => _loadPreset(arr),
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
      "vector<vector<int>> threeSum(vector<int>& nums) {",
      "    sort(nums.begin(), nums.end());",
      "    vector<vector<int>> res;",
      "    for (int i = 0; i < nums.size() - 2; i++) {",
      "        if (i > 0 && nums[i] == nums[i-1]) continue;",
      "        int left = i + 1, right = nums.size() - 1;",
      "        while (left < right) {",
      "            int sum = nums[i] + nums[left] + nums[right];",
      "            if (sum == 0) {",
      "                res.push_back({nums[i], nums[left], nums[right]});",
      "                while (left < right && nums[left] == nums[left+1]) left++;",
      "                while (left < right && nums[right] == nums[right-1]) right--;",
      "                left++; right--;",
      "            } else if (sum < 0) {",
      "                left++;",
      "            } else {",
      "                right--;",
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

  Widget _buildArrayVisualizationBox(ThreeSumStep step) {
    final arr = step.sortedArray;
    final triplets = step.tripletsFound;

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
                  "Length: ${arr.length}",
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

          // Triplets list
          if (triplets.isNotEmpty) ...[
            Text("Collected Triplets:",
                style: TextStyle(
                    color: AppTheme.accentGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: Responsive.sp(context, 12))),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: triplets.map((t) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.accentGreen.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppTheme.accentGreen),
                  ),
                  child: Text(
                    "[${t.join(', ')}]",
                    style: TextStyle(
                        fontFamily: 'monospace',
                        color: Colors.white,
                        fontSize: Responsive.sp(context, 11)),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
          ],

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
    vector<vector<int>> threeSum(vector<int>& nums) {
        sort(nums.begin(), nums.end());
        vector<vector<int>> res;
        int n = nums.size();
        
        for (int i = 0; i < n - 2; i++) {
            if (nums[i] > 0) break;
            if (i > 0 && nums[i] == nums[i-1]) continue;
            
            int left = i + 1, right = n - 1;
            while (left < right) {
                int sum = nums[i] + nums[left] + nums[right];
                if (sum == 0) {
                    res.push_back({nums[i], nums[left], nums[right]});
                    while (left < right && nums[left] == nums[left+1]) left++;
                    while (left < right && nums[right] == nums[right-1]) right--;
                    left++;
                    right--;
                } else if (sum < 0) {
                    left++;
                } else {
                    right--;
                }
            }
        }
        return res;
    }
};""";
    } else if (lang == "Java") {
      code = """
class Solution {
    public List<List<Integer>> threeSum(int[] nums) {
        Arrays.sort(nums);
        List<List<Integer>> res = new ArrayList<>();
        int n = nums.length;
        
        for (int i = 0; i < n - 2; i++) {
            if (nums[i] > 0) break;
            if (i > 0 && nums[i] == nums[i-1]) continue;
            
            int left = i + 1, right = n - 1;
            while (left < right) {
                int sum = nums[i] + nums[left] + nums[right];
                if (sum == 0) {
                    res.add(Arrays.asList(nums[i], nums[left], nums[right]));
                    while (left < right && nums[left] == nums[left+1]) left++;
                    while (left < right && nums[right] == nums[right-1]) right--;
                    left++;
                    right--;
                } else if (sum < 0) {
                    left++;
                } else {
                    right--;
                }
            }
        }
        return res;
    }
}""";
    } else if (lang == "Python") {
      code = """
class Solution:
    def threeSum(self, nums: List[int]) -> List[List[int]]:
        nums.sort()
        res = []
        n = len(nums)
        
        for i in range(n - 2):
            if nums[i] > 0:
                break
            if i > 0 and nums[i] == nums[i - 1]:
                continue
                
            left, right = i + 1, n - 1
            while left < right:
                total = nums[i] + nums[left] + nums[right]
                if total == 0:
                    res.append([nums[i], nums[left], nums[right]])
                    while left < right and nums[left] == nums[left + 1]:
                        left += 1
                    while left < right and nums[right] == nums[right - 1]:
                        right -= 1
                    left += 1
                    right -= 1
                elif total < 0:
                    left += 1
                else:
                    right -= 1
        return res""";
    } else {
      code = """
List<List<int>> threeSum(List<int> nums) {
  nums.sort();
  List<List<int>> res = [];
  int n = nums.length;

  for (int i = 0; i < n - 2; i++) {
    if (nums[i] > 0) break;
    if (i > 0 && nums[i] == nums[i - 1]) continue;

    int left = i + 1, right = n - 1;
    while (left < right) {
      int sum = nums[i] + nums[left] + nums[right];
      if (sum == 0) {
        res.add([nums[i], nums[left], nums[right]]);
        while (left < right && nums[left] == nums[left + 1]) left++;
        while (left < right && nums[right] == nums[right - 1]) right--;
        left++;
        right--;
      } else if (sum < 0) {
        left++;
      } else {
        right--;
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
