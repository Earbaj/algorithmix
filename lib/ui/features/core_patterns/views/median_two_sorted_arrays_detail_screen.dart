import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import 'package:algorithmix/ui/features/core_patterns/widgets/median_two_sorted_arrays_code_free_visualizer.dart';

class MedianStep {
  final int partition1;
  final int partition2;
  final int maxLeft1;
  final int minRight1;
  final int maxLeft2;
  final int minRight2;
  final int activeLine;
  final List<int> nums1;
  final List<int> nums2;
  final double calculatedMedian;
  final String actionEn;
  final String actionBn;
  final String reasonEn;
  final String reasonBn;
  final bool isFinish;

  const MedianStep({
    required this.partition1,
    required this.partition2,
    required this.maxLeft1,
    required this.minRight1,
    required this.maxLeft2,
    required this.minRight2,
    required this.activeLine,
    required this.nums1,
    required this.nums2,
    required this.calculatedMedian,
    required this.actionEn,
    required this.actionBn,
    required this.reasonEn,
    required this.reasonBn,
    this.isFinish = false,
  });
}

class MedianTwoSortedArraysDetailScreen extends StatefulWidget {
  const MedianTwoSortedArraysDetailScreen({super.key});

  @override
  State<MedianTwoSortedArraysDetailScreen> createState() =>
      _MedianTwoSortedArraysDetailScreenState();
}

class _MedianTwoSortedArraysDetailScreenState
    extends State<MedianTwoSortedArraysDetailScreen>
    with SingleTickerProviderStateMixin {
  bool _isEnglish = true;
  late TabController _tabController;

  // Custom Input State
  final TextEditingController _nums1Controller =
      TextEditingController(text: "1, 3");
  final TextEditingController _nums2Controller =
      TextEditingController(text: "2");

  List<int> _currentNums1 = [1, 3];
  List<int> _currentNums2 = [2];
  List<MedianStep> _steps = [];

  // Playback Control
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  // Practice Mode State
  bool _showAnswer = false;
  int _userP1 = 0;
  int _userP2 = 0;
  double _userCalculatedMedian = 0.0;
  String _userFeedbackEn = "Adjust partition p1 for nums1 to balance left and right halves!";
  String _userFeedbackBn = "nums1 এর জন্য পার্টিশন p1 সামঞ্জস্য করে সমতা আনুন!";
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
    _nums2Controller.dispose();
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
      List<int> n1 = _nums1Controller.text
          .split(',')
          .map((e) => int.parse(e.trim()))
          .toList();
      List<int> n2 = _nums2Controller.text
          .split(',')
          .map((e) => int.parse(e.trim()))
          .toList();
      _currentNums1 = n1;
      _currentNums2 = n2;
    } catch (_) {
      _currentNums1 = [1, 3];
      _currentNums2 = [2];
    }

    _userP1 = 0;
    _userP2 = 0;
    _userCalculatedMedian = 0.0;
    _userSolved = false;
    _userFeedbackEn = "Start finding the median!";
    _userFeedbackBn = "মধ্যমা খোঁজা শুরু করুন!";

    _steps = _generateSteps(_currentNums1, _currentNums2);
    setState(() {});
  }

  List<MedianStep> _generateSteps(List<int> n1Orig, List<int> n2Orig) {
    List<MedianStep> steps = [];
    List<int> nums1 = List.from(n1Orig);
    List<int> nums2 = List.from(n2Orig);

    int m = nums1.length;
    int n = nums2.length;

    if (m > n) {
      List<int> temp = nums1;
      nums1 = nums2;
      nums2 = temp;
      m = nums1.length;
      n = nums2.length;
    }

    int low = 0;
    int high = m;
    int halfLen = (m + n + 1) ~/ 2;

    const int inf = 9999999;
    const int negInf = -9999999;

    // Line 2: Ensure small array
    steps.add(MedianStep(
      partition1: 0,
      partition2: halfLen,
      maxLeft1: negInf,
      minRight1: m > 0 ? nums1[0] : inf,
      maxLeft2: halfLen > 0 && n >= halfLen ? nums2[halfLen - 1] : negInf,
      minRight2: halfLen < n ? nums2[halfLen] : inf,
      activeLine: 2,
      nums1: List.from(nums1),
      nums2: List.from(nums2),
      calculatedMedian: 0.0,
      actionEn: "Line 2: Ensure nums1 is smaller array (m = $m <= n = $n)",
      actionBn: "লাইন ২: নিশ্চিত করা হলো nums1 ছোট বা সমান দৈর্ঘ্যের (m = $m <= n = $n)",
      reasonEn: "Binary search on smaller array ensures O(log(min(m, n))) complexity.",
      reasonBn: "ছোট অ্যারের উপর বাইনারি সার্চ O(log(min(m, n))) সময় নিশ্চিত করে।",
    ));

    while (low <= high) {
      int p1 = (low + high) ~/ 2;
      int p2 = halfLen - p1;

      int maxLeft1 = (p1 == 0) ? negInf : nums1[p1 - 1];
      int minRight1 = (p1 == m) ? inf : nums1[p1];

      int maxLeft2 = (p2 == 0) ? negInf : nums2[p2 - 1];
      int minRight2 = (p2 == n) ? inf : nums2[p2];

      if (maxLeft1 <= minRight2 && maxLeft2 <= minRight1) {
        double median;
        if ((m + n) % 2 == 1) {
          median = (maxLeft1 > maxLeft2 ? maxLeft1 : maxLeft2).toDouble();
        } else {
          int lMax = maxLeft1 > maxLeft2 ? maxLeft1 : maxLeft2;
          int rMin = minRight1 < minRight2 ? minRight1 : minRight2;
          median = (lMax + rMin) / 2.0;
        }

        steps.add(MedianStep(
          partition1: p1,
          partition2: p2,
          maxLeft1: maxLeft1,
          minRight1: minRight1,
          maxLeft2: maxLeft2,
          minRight2: minRight2,
          activeLine: 10,
          nums1: List.from(nums1),
          nums2: List.from(nums2),
          calculatedMedian: median,
          actionEn: "Line 10: Valid Partition Split Found! Median = $median 🎉",
          actionBn: "লাইন ১০: ভ্যালিড পার্টিশন বিভাজন পাওয়া গেছে! মধ্যমা = $median 🎉",
          reasonEn: "maxLeft1 ($maxLeft1) <= minRight2 ($minRight2) and maxLeft2 ($maxLeft2) <= minRight1 ($minRight1). Perfect!",
          reasonBn: "উভয় সীমানার শর্ত পূরণ হয়েছে। মধ্যমা নিখুঁত হিসাব সম্পন্ন!",
        ));

        // Line 16: Finish
        steps.add(MedianStep(
          partition1: p1,
          partition2: p2,
          maxLeft1: maxLeft1,
          minRight1: minRight1,
          maxLeft2: maxLeft2,
          minRight2: minRight2,
          activeLine: 16,
          nums1: List.from(nums1),
          nums2: List.from(nums2),
          calculatedMedian: median,
          actionEn: "Line 16: return median 🎉 Median = $median",
          actionBn: "লাইন ১৬: return median 🎉 মধ্যমা = $median",
          reasonEn: "Median calculation complete in O(log(min(m, n))) time!",
          reasonBn: "O(log(min(m, n))) সময়ে মধ্যমা হিসাব সম্পূর্ণ!",
          isFinish: true,
        ));
        break;
      } else if (maxLeft1 > minRight2) {
        steps.add(MedianStep(
          partition1: p1,
          partition2: p2,
          maxLeft1: maxLeft1,
          minRight1: minRight1,
          maxLeft2: maxLeft2,
          minRight2: minRight2,
          activeLine: 14,
          nums1: List.from(nums1),
          nums2: List.from(nums2),
          calculatedMedian: 0.0,
          actionEn: "Line 14: maxLeft1 ($maxLeft1) > minRight2 ($minRight2) → high = ${p1 - 1}",
          actionBn: "লাইন ১৪: maxLeft1 ($maxLeft1) > minRight2 ($minRight2) → high = ${p1 - 1}",
          reasonEn: "Partition 1 is too far right. Move search high leftwards.",
          reasonBn: "পার্টিশন ১ বেশি ডানে থাকায় high বামে সরাতে হবে।",
        ));
        high = p1 - 1;
      } else {
        steps.add(MedianStep(
          partition1: p1,
          partition2: p2,
          maxLeft1: maxLeft1,
          minRight1: minRight1,
          maxLeft2: maxLeft2,
          minRight2: minRight2,
          activeLine: 15,
          nums1: List.from(nums1),
          nums2: List.from(nums2),
          calculatedMedian: 0.0,
          actionEn: "Line 15: maxLeft2 ($maxLeft2) > minRight1 ($minRight1) → low = ${p1 + 1}",
          actionBn: "লাইন ১৫: maxLeft2 ($maxLeft2) > minRight1 ($minRight1) → low = ${p1 + 1}",
          reasonEn: "Partition 1 is too far left. Move search low rightwards.",
          reasonBn: "পার্টিশন ১ বেশি বামে থাকায় low ডানে সরাতে হবে।",
        ));
        low = p1 + 1;
      }
    }

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

  void _loadPreset(List<int> n1, List<int> n2) {
    _nums1Controller.text = n1.join(', ');
    _nums2Controller.text = n2.join(', ');
    _rebuildSteps();
  }

  void _handleUserAction() {
    if (_userSolved) return;

    List<int> n1 = _currentNums1;
    List<int> n2 = _currentNums2;

    int m = n1.length;
    int n = n2.length;
    int halfLen = (m + n + 1) ~/ 2;

    int p1 = _userP1;
    int p2 = halfLen - p1;

    const int inf = 9999999;
    const int negInf = -9999999;

    int maxLeft1 = (p1 == 0) ? negInf : n1[p1 - 1];
    int minRight1 = (p1 == m) ? inf : n1[p1];
    int maxLeft2 = (p2 == 0) ? negInf : n2[p2 - 1];
    int minRight2 = (p2 == n) ? inf : n2[p2];

    setState(() {
      if (maxLeft1 <= minRight2 && maxLeft2 <= minRight1) {
        if ((m + n) % 2 == 1) {
          _userCalculatedMedian = (maxLeft1 > maxLeft2 ? maxLeft1 : maxLeft2).toDouble();
        } else {
          int lMax = maxLeft1 > maxLeft2 ? maxLeft1 : maxLeft2;
          int rMin = minRight1 < minRight2 ? minRight1 : minRight2;
          _userCalculatedMedian = (lMax + rMin) / 2.0;
        }
        _userSolved = true;
        _userFeedbackEn = "🎉 Perfect! Calculated Median = $_userCalculatedMedian!";
        _userFeedbackBn = "🎉 দারুণ! মধ্যমা (Median) = $_userCalculatedMedian!";
      } else if (maxLeft1 > minRight2) {
        if (_userP1 > 0) _userP1--;
        _userFeedbackEn = "maxLeft1 ($maxLeft1) > minRight2 ($minRight2). Shifted partition left.";
        _userFeedbackBn = "পার্টিশন বামে ছোট করা হলো।";
      } else {
        if (_userP1 < m) _userP1++;
        _userFeedbackEn = "maxLeft2 ($maxLeft2) > minRight1 ($minRight1). Shifted partition right.";
        _userFeedbackBn = "পার্টিশন ডানে বাড়ানো হলো।";
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
          '4. Median of 2 Sorted Arrays',
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
                    'LeetCode #4',
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
                    '⭐ Binary Search / Partition Method',
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
              _isEnglish
                  ? 'Median of Two Sorted Arrays'
                  : 'দুইটি সর্টেড অ্যারের মধ্যমা (Median of Two Sorted Arrays)',
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
                        ? 'Given two sorted arrays nums1 and nums2 of size m and n respectively, return the median of the two sorted arrays.\n\nThe overall run time complexity should be O(log (m+n)).'
                        : 'm ও n আকারের দুটি সর্টেড অ্যারে nums1 এবং nums2 দেওয়া আছে। উভয় অ্যারের সমন্বিত মধ্যমা (Median) বের করুন।\n\nঅ্যালগরিদমের সময়সীমা O(log(m+n)) হতে হবে।',
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
              "nums1 = [1, 3], nums2 = [2]",
              "Output: 2.00000",
              _isEnglish
                  ? "Explanation: Merged array = [1, 2, 3] and median is 2.0."
                  : "ব্যাখ্যা: একত্রিত অ্যারে = [1, 2, 3], মধ্যমা ২.০।",
            ),
            _buildExampleCard(
              "Example 2",
              "nums1 = [1, 2], nums2 = [3, 4]",
              "Output: 2.50000",
              _isEnglish
                  ? "Explanation: Merged array = [1, 2, 3, 4] and median is (2 + 3) / 2 = 2.5."
                  : "ব্যাখ্যা: একত্রিত অ্যারে = [1, 2, 3, 4], মধ্যমা (২ + ৩) / ২ = ২.৫।",
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
      child: MedianTwoSortedArraysCodeFreeVisualizer(isEnglish: _isEnglish),
    );
  }

  // TAB 3: Dynamic Visualizer
  Widget _buildVisualizerTab(double hPadding) {
    final isMobile = Responsive.isMobile(context);
    final step = _steps.isEmpty
        ? MedianStep(
            partition1: 0,
            partition2: 0,
            maxLeft1: 0,
            minRight1: 0,
            maxLeft2: 0,
            minRight2: 0,
            activeLine: 0,
            nums1: _currentNums1,
            nums2: _currentNums2,
            calculatedMedian: 0.0,
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
                              fontSize: Responsive.sp(context, 13)),
                          decoration: InputDecoration(
                            labelText: _isEnglish ? 'Sorted Array nums1' : 'সর্টেড অ্যারে nums1',
                            hintText: 'e.g. 1, 3',
                            labelStyle: TextStyle(fontSize: Responsive.sp(context, 12)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _nums2Controller,
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'monospace',
                              fontSize: Responsive.sp(context, 13)),
                          decoration: InputDecoration(
                            labelText: _isEnglish ? 'Sorted Array nums2' : 'সর্টেড অ্যারে nums2',
                            hintText: 'e.g. 2',
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
                        _buildPresetChip('nums1=[1,3], nums2=[2]', [1, 3], [2]),
                        _buildPresetChip('nums1=[1,2], nums2=[3,4]', [1, 2], [3, 4]),
                        _buildPresetChip('nums1=[0,0], nums2=[0,0]', [0, 0], [0, 0]),
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
                            ? '🎮 Practice Mode: Find Partition & Median!'
                            : '🎮 প্র্যাকটিস মোড: নিজে পার্টিশন মেলান ও মধ্যমা হিসাব করুন!',
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
                        ? "nums1: [${_currentNums1.join(', ')}], nums2: [${_currentNums2.join(', ')}]"
                        : "nums1: [${_currentNums1.join(', ')}], nums2: [${_currentNums2.join(', ')}]",
                    style: TextStyle(
                        color: AppTheme.accentNeonCyan,
                        fontWeight: FontWeight.bold,
                        fontSize: Responsive.sp(context, 13)),
                  ),
                  const SizedBox(height: 16),

                  // Current Partition Gauge
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
                          "User Partition 1: $_userP1",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: Responsive.sp(context, 12.5)),
                        ),
                        Text(
                          "Calculated Median: ${_userCalculatedMedian}",
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
                        onPressed: _userSolved ? null : _handleUserAction,
                        icon: Icon(Icons.balance, size: Responsive.sp(context, 16)),
                        label: Text(
                            _isEnglish
                                ? 'Evaluate Binary Search Step'
                                : 'ধাপ পরীক্ষা ও সার্চ করুন',
                            style: TextStyle(fontSize: Responsive.sp(context, 13))),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accentNeonCyan),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            _userP1 = 0;
                            _userP2 = 0;
                            _userCalculatedMedian = 0.0;
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
                                ? "• Time Complexity: O(log(min(m, n))) — Binary Search on smaller array size.\n• Space Complexity: O(1) auxiliary space — Only constant partition scalar variables."
                                : "• টাইম কমপ্লেক্সিটি: O(log(min(m, n))) — ছোট অ্যারের আকারের উপর বাইনারি সার্চ।\n• স্পেস কমপ্লেক্সিটি: O(1) অতিরিক্ত মেমোরি।",
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

  Widget _buildPresetChip(String label, List<int> n1, List<int> n2) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ActionChip(
        label: Text(label,
            style: TextStyle(
                fontSize: Responsive.sp(context, 11), color: Colors.white)),
        backgroundColor: AppTheme.primaryDark,
        onPressed: () => _loadPreset(n1, n2),
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
      "double findMedianSortedArrays(vector<int>& nums1, vector<int>& nums2) {",
      "    if (nums1.size() > nums2.size()) return findMedianSortedArrays(nums2, nums1);",
      "    int m = nums1.size(), n = nums2.size();",
      "    int low = 0, high = m, halfLen = (m + n + 1) / 2;",
      "    while (low <= high) {",
      "        int p1 = (low + high) / 2, p2 = halfLen - p1;",
      "        int maxLeft1 = (p1 == 0) ? INT_MIN : nums1[p1 - 1];",
      "        int minRight1 = (p1 == m) ? INT_MAX : nums1[p1];",
      "        int maxLeft2 = (p2 == 0) ? INT_MIN : nums2[p2 - 1];",
      "        int minRight2 = (p2 == n) ? INT_MAX : nums2[p2];",
      "        if (maxLeft1 <= minRight2 && maxLeft2 <= minRight1) {",
      "            if ((m + n) % 2 == 1) return max(maxLeft1, maxLeft2);",
      "            return (max(maxLeft1, maxLeft2) + min(minRight1, minRight2)) / 2.0;",
      "        } else if (maxLeft1 > minRight2) high = p1 - 1;",
      "        else low = p1 + 1;",
      "    }",
      "    return 0.0;",
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

  Widget _buildArrayVisualizationBox(MedianStep step) {
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
                "Partition Split State",
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
                  "P1: ${step.partition1} | P2: ${step.partition2}",
                  style: TextStyle(
                      color: AppTheme.accentNeonCyan,
                      fontWeight: FontWeight.bold,
                      fontSize: Responsive.sp(context, 12)),
                ),
              ),
            ],
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
    double findMedianSortedArrays(vector<int>& nums1, vector<int>& nums2) {
        if (nums1.size() > nums2.size()) return findMedianSortedArrays(nums2, nums1);
        
        int m = nums1.size(), n = nums2.size();
        int low = 0, high = m;
        int halfLen = (m + n + 1) / 2;
        
        while (low <= high) {
            int p1 = (low + high) / 2;
            int p2 = halfLen - p1;
            
            int maxLeft1 = (p1 == 0) ? INT_MIN : nums1[p1 - 1];
            int minRight1 = (p1 == m) ? INT_MAX : nums1[p1];
            
            int maxLeft2 = (p2 == 0) ? INT_MIN : nums2[p2 - 1];
            int minRight2 = (p2 == n) ? INT_MAX : nums2[p2];
            
            if (maxLeft1 <= minRight2 && maxLeft2 <= minRight1) {
                if ((m + n) % 2 == 1) {
                    return max(maxLeft1, maxLeft2);
                }
                return (max(maxLeft1, maxLeft2) + min(minRight1, minRight2)) / 2.0;
            } else if (maxLeft1 > minRight2) {
                high = p1 - 1;
            } else {
                low = p1 + 1;
            }
        }
        return 0.0;
    }
};""";
    } else if (lang == "Java") {
      code = """
class Solution {
    public double findMedianSortedArrays(int[] nums1, int[] nums2) {
        if (nums1.length > nums2.length) {
            return findMedianSortedArrays(nums2, nums1);
        }
        
        int m = nums1.length, n = nums2.length;
        int low = 0, high = m;
        int halfLen = (m + n + 1) / 2;
        
        while (low <= high) {
            int p1 = (low + high) / 2;
            int p2 = halfLen - p1;
            
            int maxLeft1 = (p1 == 0) ? Integer.MIN_VALUE : nums1[p1 - 1];
            int minRight1 = (p1 == m) ? Integer.MAX_VALUE : nums1[p1];
            
            int maxLeft2 = (p2 == 0) ? Integer.MIN_VALUE : nums2[p2 - 1];
            int minRight2 = (p2 == n) ? Integer.MAX_VALUE : nums2[p2];
            
            if (maxLeft1 <= minRight2 && maxLeft2 <= minRight1) {
                if ((m + n) % 2 == 1) {
                    return Math.max(maxLeft1, maxLeft2);
                }
                return (Math.max(maxLeft1, maxLeft2) + Math.min(minRight1, minRight2)) / 2.0;
            } else if (maxLeft1 > minRight2) {
                high = p1 - 1;
            } else {
                low = p1 + 1;
            }
        }
        return 0.0;
    }
}""";
    } else if (lang == "Python") {
      code = """
class Solution:
    def findMedianSortedArrays(self, nums1: List[int], nums2: List[int]) -> float:
        if len(nums1) > len(nums2):
            nums1, nums2 = nums2, nums1
            
        m, n = len(nums1), len(nums2)
        low, high = 0, m
        half_len = (m + n + 1) // 2
        
        while low <= high:
            p1 = (low + high) // 2
            p2 = half_len - p1
            
            max_left1 = float("-inf") if p1 == 0 else nums1[p1 - 1]
            min_right1 = float("inf") if p1 == m else nums1[p1]
            
            max_left2 = float("-inf") if p2 == 0 else nums2[p2 - 1]
            min_right2 = float("inf") if p2 == n else nums2[p2]
            
            if max_left1 <= min_right2 and max_left2 <= min_right1:
                if (m + n) % 2 == 1:
                    return max(max_left1, max_left2)
                return (max(max_left1, max_left2) + min(min_right1, min_right2)) / 2.0
            elif max_left1 > min_right2:
                high = p1 - 1
            else:
                low = p1 + 1
        return 0.0""";
    } else {
      code = """
double findMedianSortedArrays(List<int> nums1, List<int> nums2) {
  if (nums1.length > nums2.length) return findMedianSortedArrays(nums2, nums1);

  int m = nums1.length, n = nums2.length;
  int low = 0, high = m;
  int halfLen = (m + n + 1) ~/ 2;

  const int inf = 9999999;
  const int negInf = -9999999;

  while (low <= high) {
    int p1 = (low + high) ~/ 2;
    int p2 = halfLen - p1;

    int maxLeft1 = (p1 == 0) ? negInf : nums1[p1 - 1];
    int minRight1 = (p1 == m) ? inf : nums1[p1];

    int maxLeft2 = (p2 == 0) ? negInf : nums2[p2 - 1];
    int minRight2 = (p2 == n) ? inf : nums2[p2];

    if (maxLeft1 <= minRight2 && maxLeft2 <= minRight1) {
      if ((m + n) % 2 == 1) {
        return (maxLeft1 > maxLeft2 ? maxLeft1 : maxLeft2).toDouble();
      }
      int lMax = maxLeft1 > maxLeft2 ? maxLeft1 : maxLeft2;
      int rMin = minRight1 < minRight2 ? minRight1 : minRight2;
      return (lMax + rMin) / 2.0;
    } else if (maxLeft1 > minRight2) {
      high = p1 - 1;
    } else {
      low = p1 + 1;
    }
  }
  return 0.0;
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
