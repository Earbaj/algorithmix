import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import 'package:algorithmix/ui/features/core_patterns/widgets/merge_sorted_array_code_free_visualizer.dart';

class MergeSortedArrayStep {
  final int p1;
  final int p2;
  final int p;
  final int activeLine;
  final List<int> nums1State;
  final List<int> nums2State;
  final String actionEn;
  final String actionBn;
  final String reasonEn;
  final String reasonBn;
  final bool isFinish;

  const MergeSortedArrayStep({
    required this.p1,
    required this.p2,
    required this.p,
    required this.activeLine,
    required this.nums1State,
    required this.nums2State,
    required this.actionEn,
    required this.actionBn,
    required this.reasonEn,
    required this.reasonBn,
    this.isFinish = false,
  });
}

class MergeSortedArrayDetailScreen extends StatefulWidget {
  const MergeSortedArrayDetailScreen({super.key});

  @override
  State<MergeSortedArrayDetailScreen> createState() =>
      _MergeSortedArrayDetailScreenState();
}

class _MergeSortedArrayDetailScreenState
    extends State<MergeSortedArrayDetailScreen>
    with SingleTickerProviderStateMixin {
  bool _isEnglish = true;
  late TabController _tabController;

  // Custom Input State
  final TextEditingController _nums1Controller =
      TextEditingController(text: "1, 2, 3, 0, 0, 0");
  final TextEditingController _mController = TextEditingController(text: "3");
  final TextEditingController _nums2Controller =
      TextEditingController(text: "2, 5, 6");
  final TextEditingController _nController = TextEditingController(text: "3");

  List<int> _currentNums1 = [1, 2, 3, 0, 0, 0];
  int _currentM = 3;
  List<int> _currentNums2 = [2, 5, 6];
  int _currentN = 3;

  List<MergeSortedArrayStep> _steps = [];

  // Playback Control
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  // Practice Mode State
  bool _showAnswer = false;
  int _userP1 = 2;
  int _userP2 = 2;
  int _userP = 5;
  List<int> _userNums1 = [1, 2, 3, 0, 0, 0];
  List<int> _userNums2 = [2, 5, 6];
  String _userFeedbackEn = "Compare nums1[p1] vs nums2[p2]. Choose 'Place nums1[p1]' or 'Place nums2[p2]'!";
  String _userFeedbackBn = "nums1[p1] এবং nums2[p2] এর মধ্যে তুলনা করে বাটন চাপুন!";
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
    _nums1Controller.dispose();
    _mController.dispose();
    _nums2Controller.dispose();
    _nController.dispose();
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
      _currentM = int.parse(_mController.text.trim());
      _currentN = int.parse(_nController.text.trim());
      _currentNums1 = _nums1Controller.text
          .split(',')
          .map((e) => int.parse(e.trim()))
          .toList();
      _currentNums2 = _nums2Controller.text
          .split(',')
          .map((e) => int.parse(e.trim()))
          .toList();
    } catch (_) {
      _currentNums1 = [1, 2, 3, 0, 0, 0];
      _currentM = 3;
      _currentNums2 = [2, 5, 6];
      _currentN = 3;
    }

    _userNums1 = List.from(_currentNums1);
    _userNums2 = List.from(_currentNums2);
    _userP1 = _currentM - 1;
    _userP2 = _currentN - 1;
    _userP = _currentM + _currentN - 1;
    _userSolved = false;
    _userFeedbackEn = "Start merging elements from back to front!";
    _userFeedbackBn = "পেছন থেকে সামনে মার্জ করা শুরু করুন!";

    _steps = _generateSteps(_currentNums1, _currentM, _currentNums2, _currentN);
    setState(() {});
  }

  List<MergeSortedArrayStep> _generateSteps(
      List<int> origN1, int m, List<int> origN2, int n) {
    List<MergeSortedArrayStep> steps = [];
    List<int> n1 = List.from(origN1);
    List<int> n2 = List.from(origN2);

    int p1 = m - 1;
    int p2 = n - 1;
    int p = m + n - 1;

    // Line 2: Pointers setup
    steps.add(MergeSortedArrayStep(
      p1: p1,
      p2: p2,
      p: p,
      activeLine: 2,
      nums1State: List.from(n1),
      nums2State: List.from(n2),
      actionEn: "Line 2: Init p1 = ${m - 1}, p2 = ${n - 1}, p = ${m + n - 1}",
      actionBn: "লাইন ২: সূচনা p1 = ${m - 1}, p2 = ${n - 1}, p = ${m + n - 1}",
      reasonEn: "Pointers set to the ends of valid elements and write buffer.",
      reasonBn: "উপাদানগুলোর শেষ ও রাইট বাফারে পয়েন্টার বসানো হলো।",
    ));

    while (p2 >= 0) {
      // Line 3: Loop check
      steps.add(MergeSortedArrayStep(
        p1: p1,
        p2: p2,
        p: p,
        activeLine: 3,
        nums1State: List.from(n1),
        nums2State: List.from(n2),
        actionEn: "Line 3: Check while (p2 >= 0) → ($p2 >= 0) is TRUE",
        actionBn: "লাইন ৩: লুপ শর্ত চেক while (p2 >= 0) → ($p2 >= 0) সত্য",
        reasonEn: "Elements remain in nums2. Compare values.",
        reasonBn: "nums2 তে উপাদান বাকি রয়েছে। মানসমূহ তুলনা করুন।",
      ));

      if (p1 >= 0 && n1[p1] > n2[p2]) {
        // Line 4 & 5: Place nums1[p1]
        n1[p] = n1[p1];
        steps.add(MergeSortedArrayStep(
          p1: p1,
          p2: p2,
          p: p,
          activeLine: 4,
          nums1State: List.from(n1),
          nums2State: List.from(n2),
          actionEn: "Line 4 & 5: nums1[p1] (${origN1[p1]}) > nums2[p2] (${n2[p2]}) → Execute nums1[p--] = nums1[p1--]",
          actionBn: "লাইন ৪ ও ৫: nums1[p1] (${origN1[p1]}) > nums2[p2] (${n2[p2]}) → nums1[p--] = nums1[p1--] সম্পাদন",
          reasonEn: "Placed ${origN1[p1]} at nums1[$p]. Decremented p1 & p.",
          reasonBn: "nums1[$p] এ ${origN1[p1]} বসানো হলো এবং p1 ও p কমানো হলো।",
        ));
        p1--;
      } else {
        // Line 6 & 7: Place nums2[p2]
        int val2 = n2[p2];
        n1[p] = val2;
        steps.add(MergeSortedArrayStep(
          p1: p1,
          p2: p2,
          p: p,
          activeLine: 6,
          nums1State: List.from(n1),
          nums2State: List.from(n2),
          actionEn: "Line 6 & 7: nums2[p2] ($val2) ≥ nums1[p1] (${p1 >= 0 ? n1[p1] : 'N/A'}) → Execute nums1[p--] = nums2[p2--]",
          actionBn: "লাইন ৬ ও ৭: nums2[p2] ($val2) ≥ nums1[p1] (${p1 >= 0 ? n1[p1] : 'N/A'}) → nums1[p--] = nums2[p2--] সম্পাদন",
          reasonEn: "Placed $val2 at nums1[$p]. Decremented p2 & p.",
          reasonBn: "nums1[$p] এ $val2 বসানো হলো এবং p2 ও p কমানো হলো।",
        ));
        p2--;
      }
      p--;
    }

    // Line 9: Finish
    steps.add(MergeSortedArrayStep(
      p1: p1,
      p2: p2,
      p: p,
      activeLine: 9,
      nums1State: List.from(n1),
      nums2State: List.from(n2),
      actionEn: "Line 9: Function Complete 🎉 Merged nums1: [${n1.join(', ')}]",
      actionBn: "লাইন ৯: ফাংশন সমাপ্ত 🎉 মার্জড nums1: [${n1.join(', ')}]",
      reasonEn: "All elements merged in-place in non-decreasing order!",
      reasonBn: "সব উপাদান সর্টেড অর্ডারে ইন-প্লেস মার্জ সম্পন্ন হয়েছে!",
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

  void _loadPreset(Map<String, dynamic> preset) {
    _nums1Controller.text = (preset['nums1'] as List).join(', ');
    _mController.text = preset['m'].toString();
    _nums2Controller.text = (preset['nums2'] as List).join(', ');
    _nController.text = preset['n'].toString();
    _rebuildSteps();
  }

  void _handleUserChoice(String side) {
    if (_userSolved || _userP2 < 0) return;

    int val1 = (_userP1 >= 0) ? _userNums1[_userP1] : -999999;
    int val2 = _userNums2[_userP2];

    setState(() {
      if (side == "nums1") {
        if (_userP1 >= 0 && val1 > val2) {
          _userNums1[_userP] = val1;
          _userP1--;
          _userP--;
          _userFeedbackEn = "✅ Correct! nums1[p1] ($val1) was larger. Placed at index $_userP.";
          _userFeedbackBn = "✅ সঠিক পদক্ষেপ! nums1[p1] ($val1) বড় থাকায় বসানো হলো।";
        } else {
          _userFeedbackEn = "⚠️ nums2[p2] ($val2) is larger or equal! Place nums2[p2].";
          _userFeedbackBn = "⚠️ nums2[p2] ($val2) বড় বা সমান! nums2[p2] নির্বাচন করুন।";
        }
      } else if (side == "nums2") {
        if (_userP1 < 0 || val2 >= val1) {
          _userNums1[_userP] = val2;
          _userP2--;
          _userP--;
          _userFeedbackEn = "✅ Correct! nums2[p2] ($val2) was larger or equal. Placed at index $_userP.";
          _userFeedbackBn = "✅ সঠিক পদক্ষেপ! nums2[p2] ($val2) বড়/সমান থাকায় বসানো হলো।";
        } else {
          _userFeedbackEn = "⚠️ nums1[p1] ($val1) is larger! Place nums1[p1].";
          _userFeedbackBn = "⚠️ nums1[p1] ($val1) বড়! nums1[p1] নির্বাচন করুন।";
        }
      }

      if (_userP2 < 0) {
        _userSolved = true;
        _userFeedbackEn = "🎉 Excellent! You merged the arrays in-place: [${_userNums1.join(', ')}]";
        _userFeedbackBn = "🎉 দারুণ! আপনি সফলভাবে ইন-প্লেস মার্জ করেছেন: [${_userNums1.join(', ')}]";
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
          '88. Merge Sorted Array',
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
                    color: AppTheme.accentGreen.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.accentGreen),
                  ),
                  child: Text(
                    '🟢 Easy',
                    style: TextStyle(
                        color: AppTheme.accentGreen,
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
                    'LeetCode #88',
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
                    '⭐ FAANG Classic (Meta, MS, Amazon)',
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
                  ? 'Merge Sorted Array'
                  : 'মার্জ সর্টেড অ্যারে (Merge Sorted Array)',
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
                        ? 'You are given two integer arrays nums1 and nums2, sorted in non-decreasing order, and two integers m and n, representing the number of elements in nums1 and nums2 respectively.\n\nMerge nums1 and nums2 into a single array sorted in non-decreasing order inside nums1 in-place. nums1 has a length of m + n.'
                        : 'দুটি নন-ডিক্রিজিং সর্টেড পূর্ণসংখ্যার অ্যারে nums1 ও nums2 এবং দুটি সংখ্যা m ও n দেওয়া আছে।\n\nnums1 এর ভেতরেই (যার সাইজ m + n) ইন-প্লেস মার্জ করে সর্টেড অ্যারে গঠন করুন।',
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
              "nums1 = [1,2,3,0,0,0], m = 3, nums2 = [2,5,6], n = 3",
              "Output: [1,2,2,3,5,6]",
              _isEnglish
                  ? "Explanation: Arrays [1,2,3] and [2,5,6] merged into [1,2,2,3,5,6]."
                  : "ব্যাখ্যা: [1,2,3] এবং [2,5,6] মার্জ হয়ে [1,2,2,3,5,6] হয়েছে।",
            ),
            _buildExampleCard(
              "Example 2",
              "nums1 = [1], m = 1, nums2 = [], n = 0",
              "Output: [1]",
              _isEnglish
                  ? "Explanation: Single array remains unchanged."
                  : "ব্যাখ্যা: ১টি উপাদানের অ্যারে অপরিবর্তিত থাকে।",
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
      child: MergeSortedArrayCodeFreeVisualizer(isEnglish: _isEnglish),
    );
  }

  // TAB 3: Dynamic Visualizer
  Widget _buildVisualizerTab(double hPadding) {
    final isMobile = Responsive.isMobile(context);
    final step = _steps.isEmpty
        ? MergeSortedArrayStep(
            p1: 0,
            p2: 0,
            p: 0,
            activeLine: 0,
            nums1State: _currentNums1,
            nums2State: _currentNums2,
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
                          controller: _nums1Controller,
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'monospace',
                              fontSize: Responsive.sp(context, 12.5)),
                          decoration: InputDecoration(
                            labelText: _isEnglish ? 'nums1 (with 0s buffer)' : 'nums1 (বাফার সহ)',
                            labelStyle: TextStyle(fontSize: Responsive.sp(context, 11)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 70,
                        child: TextField(
                          controller: _mController,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: Responsive.sp(context, 12.5)),
                          decoration: InputDecoration(
                            labelText: 'm',
                            labelStyle: TextStyle(fontSize: Responsive.sp(context, 11)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _nums2Controller,
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'monospace',
                              fontSize: Responsive.sp(context, 12.5)),
                          decoration: InputDecoration(
                            labelText: _isEnglish ? 'nums2' : 'nums2',
                            labelStyle: TextStyle(fontSize: Responsive.sp(context, 11)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 70,
                        child: TextField(
                          controller: _nController,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: Responsive.sp(context, 12.5)),
                          decoration: InputDecoration(
                            labelText: 'n',
                            labelStyle: TextStyle(fontSize: Responsive.sp(context, 11)),
                          ),
                        ),
                      ),
                    ],
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
                            ? '🎮 Practice Mode: Merge Arrays Yourself!'
                            : '🎮 প্র্যাকটিস মোড: নিজে মার্জ করুন!',
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
                        ? 'nums1: [${_currentNums1.join(', ')}], nums2: [${_currentNums2.join(', ')}]'
                        : 'nums1: [${_currentNums1.join(', ')}], nums2: [${_currentNums2.join(', ')}]',
                    style: TextStyle(
                        color: AppTheme.accentNeonCyan,
                        fontWeight: FontWeight.bold,
                        fontSize: Responsive.sp(context, 12.5)),
                  ),
                  const SizedBox(height: 16),

                  // nums1 View
                  Text('nums1 Array (Write Pointer p at index $_userP):',
                      style: TextStyle(
                          fontSize: Responsive.sp(context, 12),
                          color: AppTheme.accentNeonCyan)),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(_userNums1.length, (idx) {
                        final val = _userNums1[idx];
                        final isP1 = idx == _userP1;
                        final isP = idx == _userP;

                        Color boxBg = AppTheme.primaryDark;
                        Color borderColor = const Color(0xFF334155);

                        if (isP1 && isP) {
                          boxBg = AppTheme.accentAmber.withOpacity(0.3);
                          borderColor = AppTheme.accentAmber;
                        } else if (isP1) {
                          boxBg = AppTheme.accentNeonCyan.withOpacity(0.25);
                          borderColor = AppTheme.accentNeonCyan;
                        } else if (isP) {
                          boxBg = AppTheme.accentAmber.withOpacity(0.15);
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
                              if (isP1 && isP)
                                Text('P1&P',
                                    style: TextStyle(
                                        fontSize: Responsive.sp(context, 10),
                                        color: AppTheme.accentAmber,
                                        fontWeight: FontWeight.bold))
                              else if (isP1)
                                Text('p1',
                                    style: TextStyle(
                                        fontSize: Responsive.sp(context, 10),
                                        color: AppTheme.accentNeonCyan,
                                        fontWeight: FontWeight.bold))
                              else if (isP)
                                Text('Write p',
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

                  // nums2 View
                  Text('nums2 Array (Read Pointer p2 at index $_userP2):',
                      style: TextStyle(
                          fontSize: Responsive.sp(context, 12),
                          color: AppTheme.accentPurple)),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(_userNums2.length, (idx) {
                        final val = _userNums2[idx];
                        final isP2 = idx == _userP2;

                        Color boxBg = isP2
                            ? AppTheme.accentPurple.withOpacity(0.25)
                            : AppTheme.primaryDark;
                        Color borderColor = isP2
                            ? AppTheme.accentPurple
                            : const Color(0xFF334155);

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
                              if (isP2)
                                Text('p2',
                                    style: TextStyle(
                                        fontSize: Responsive.sp(context, 10),
                                        color: AppTheme.accentPurple,
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
                        onPressed: _userSolved || _userP2 < 0
                            ? null
                            : () => _handleUserChoice("nums1"),
                        icon: Icon(Icons.south, size: Responsive.sp(context, 16)),
                        label: Text(
                            _isEnglish
                                ? 'Place nums1[p1] (${_userP1 >= 0 ? _userNums1[_userP1] : 'N/A'})'
                                : 'nums1[p1] বসান',
                            style: TextStyle(fontSize: Responsive.sp(context, 13))),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accentNeonCyan),
                      ),
                      ElevatedButton.icon(
                        onPressed: _userSolved || _userP2 < 0
                            ? null
                            : () => _handleUserChoice("nums2"),
                        icon: Icon(Icons.north, size: Responsive.sp(context, 16)),
                        label: Text(
                            _isEnglish
                                ? 'Place nums2[p2] (${_userP2 >= 0 ? _userNums2[_userP2] : 'N/A'})'
                                : 'nums2[p2] বসান',
                            style: TextStyle(fontSize: Responsive.sp(context, 13))),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accentPurple),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            _userNums1 = List.from(_currentNums1);
                            _userNums2 = List.from(_currentNums2);
                            _userP1 = _currentM - 1;
                            _userP2 = _currentN - 1;
                            _userP = _currentM + _currentN - 1;
                            _userSolved = false;
                            _userFeedbackEn = "Reset done! Compare elements.";
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
                                ? "• Time Complexity: O(m + n) — Pointers iterate through nums1 and nums2 at most once.\n• Space Complexity: O(1) — In-place modification using the tail buffer of nums1."
                                : "• টাইম কমপ্লেক্সিটি: O(m + n) — পয়েন্টারদ্বয় সর্বমোট ১বার পার হয়।\n• স্পেস কমপ্লেক্সিটি: O(1) — nums1 এর বাফার এলাকা ব্যবহার করে ইন-প্লেস সম্পন্ন হয়।",
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
      "void merge(vector<int>& nums1, int m, vector<int>& nums2, int n) {",
      "    int p1 = m - 1, p2 = n - 1, p = m + n - 1;",
      "    while (p2 >= 0) {",
      "        if (p1 >= 0 && nums1[p1] > nums2[p2]) {",
      "            nums1[p--] = nums1[p1--];",
      "        } else {",
      "            nums1[p--] = nums2[p2--];",
      "        }",
      "    }",
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

  Widget _buildArrayVisualizationBox(MergeSortedArrayStep step) {
    final n1 = step.nums1State;
    final n2 = step.nums2State;

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
                "Arrays State",
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
                  "nums1: ${n1.length} | nums2: ${n2.length}",
                  style: TextStyle(
                      color: AppTheme.accentNeonCyan,
                      fontWeight: FontWeight.bold,
                      fontSize: Responsive.sp(context, 12)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // nums1 Display
          Text("nums1 (Buffer & Write Pointer):",
              style: TextStyle(
                  fontSize: Responsive.sp(context, 11),
                  color: AppTheme.accentNeonCyan)),
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(n1.length, (idx) {
                final val = n1[idx];
                final isP1 = idx == step.p1;
                final isP = idx == step.p;

                Color boxBg = AppTheme.primaryDark;
                Color borderColor = const Color(0xFF334155);

                if (isP1 && isP) {
                  boxBg = AppTheme.accentAmber.withOpacity(0.35);
                  borderColor = AppTheme.accentAmber;
                } else if (isP1) {
                  boxBg = AppTheme.accentNeonCyan.withOpacity(0.25);
                  borderColor = AppTheme.accentNeonCyan;
                } else if (isP) {
                  boxBg = AppTheme.accentAmber.withOpacity(0.15);
                  borderColor = AppTheme.accentAmber;
                }

                return Container(
                  margin: const EdgeInsets.only(right: 6),
                  padding: EdgeInsets.symmetric(
                    horizontal: Responsive.sp(context, 10),
                    vertical: Responsive.sp(context, 6),
                  ),
                  decoration: BoxDecoration(
                    color: boxBg,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: borderColor, width: 1.5),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '$val',
                        style: TextStyle(
                            fontSize: Responsive.sp(context, 14),
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
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
          const SizedBox(height: 12),

          // nums2 Display
          Text("nums2 (Read Pointer):",
              style: TextStyle(
                  fontSize: Responsive.sp(context, 11),
                  color: AppTheme.accentPurple)),
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(n2.length, (idx) {
                final val = n2[idx];
                final isP2 = idx == step.p2;

                Color boxBg = isP2
                    ? AppTheme.accentPurple.withOpacity(0.25)
                    : AppTheme.primaryDark;
                Color borderColor = isP2
                    ? AppTheme.accentPurple
                    : const Color(0xFF334155);

                return Container(
                  margin: const EdgeInsets.only(right: 6),
                  padding: EdgeInsets.symmetric(
                    horizontal: Responsive.sp(context, 10),
                    vertical: Responsive.sp(context, 6),
                  ),
                  decoration: BoxDecoration(
                    color: boxBg,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: borderColor, width: 1.5),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '$val',
                        style: TextStyle(
                            fontSize: Responsive.sp(context, 14),
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
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
    void merge(vector<int>& nums1, int m, vector<int>& nums2, int n) {
        int p1 = m - 1, p2 = n - 1, p = m + n - 1;
        while (p2 >= 0) {
            if (p1 >= 0 && nums1[p1] > nums2[p2]) {
                nums1[p--] = nums1[p1--];
            } else {
                nums1[p--] = nums2[p2--];
            }
        }
    }
};""";
    } else if (lang == "Java") {
      code = """
class Solution {
    public void merge(int[] nums1, int m, int[] nums2, int n) {
        int p1 = m - 1, p2 = n - 1, p = m + n - 1;
        while (p2 >= 0) {
            if (p1 >= 0 && nums1[p1] > nums2[p2]) {
                nums1[p--] = nums1[p1--];
            } else {
                nums1[p--] = nums2[p2--];
            }
        }
    }
}""";
    } else if (lang == "Python") {
      code = """
class Solution:
    def merge(self, nums1: List[int], m: int, nums2: List[int], n: int) -> None:
        p1, p2, p = m - 1, n - 1, m + n - 1
        while p2 >= 0:
            if p1 >= 0 and nums1[p1] > nums2[p2]:
                nums1[p] = nums1[p1]
                p1 -= 1
            else:
                nums1[p] = nums2[p2]
                p2 -= 1
            p -= 1""";
    } else {
      code = """
void merge(List<int> nums1, int m, List<int> nums2, int n) {
  int p1 = m - 1, p2 = n - 1, p = m + n - 1;
  while (p2 >= 0) {
    if (p1 >= 0 && nums1[p1] > nums2[p2]) {
      nums1[p--] = nums1[p1--];
    } else {
      nums1[p--] = nums2[p2--];
    }
  }
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
