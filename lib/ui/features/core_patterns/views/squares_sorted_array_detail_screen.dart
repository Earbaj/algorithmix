import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import 'package:algorithmix/ui/features/core_patterns/widgets/squares_sorted_array_code_free_visualizer.dart';

class SquaresSortedArrayStep {
  final int left;
  final int right;
  final int pos;
  final int activeLine;
  final List<int> originalArray;
  final List<int?> resultArray;
  final String actionEn;
  final String actionBn;
  final String reasonEn;
  final String reasonBn;
  final bool isFinish;

  const SquaresSortedArrayStep({
    required this.left,
    required this.right,
    required this.pos,
    required this.activeLine,
    required this.originalArray,
    required this.resultArray,
    required this.actionEn,
    required this.actionBn,
    required this.reasonEn,
    required this.reasonBn,
    this.isFinish = false,
  });
}

class SquaresSortedArrayDetailScreen extends StatefulWidget {
  const SquaresSortedArrayDetailScreen({super.key});

  @override
  State<SquaresSortedArrayDetailScreen> createState() =>
      _SquaresSortedArrayDetailScreenState();
}

class _SquaresSortedArrayDetailScreenState
    extends State<SquaresSortedArrayDetailScreen>
    with SingleTickerProviderStateMixin {
  bool _isEnglish = true;
  late TabController _tabController;

  // Custom Input State
  final TextEditingController _inputController =
      TextEditingController(text: "-4, -1, 0, 3, 10");

  List<int> _currentArray = [-4, -1, 0, 3, 10];
  List<SquaresSortedArrayStep> _steps = [];

  // Playback Control
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  // Practice Mode State
  bool _showAnswer = false;
  int _userLeft = 0;
  int _userRight = 4;
  int _userPos = 4;
  List<int> _userArray = [-4, -1, 0, 3, 10];
  List<int?> _userResult = [null, null, null, null, null];
  String _userFeedbackEn = "Compare (-4)² vs (10)². Choose 'Place Left Square' or 'Place Right Square'!";
  String _userFeedbackBn = "(-4)² এবং (10)² এর মধ্যে তুলনা করে সঠিক বাটন নির্বাচন করুন!";
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
        parsed = [-4, -1, 0, 3, 10];
      }
      parsed.sort(); // Ensure sorted
      _currentArray = parsed;
    } catch (_) {
      _currentArray = [-4, -1, 0, 3, 10];
    }

    int n = _currentArray.length;
    _userArray = List.from(_currentArray);
    _userResult = List.filled(n, null);
    _userLeft = 0;
    _userRight = n - 1;
    _userPos = n - 1;
    _userSolved = false;
    _userFeedbackEn = "Start comparing squares from opposite ends!";
    _userFeedbackBn = "উভয় প্রান্ত থেকে বর্গ তুলনা শুরু করুন!";

    _steps = _generateSteps(_currentArray);
    setState(() {});
  }

  List<SquaresSortedArrayStep> _generateSteps(List<int> orig) {
    List<SquaresSortedArrayStep> steps = [];
    int n = orig.length;
    List<int?> res = List.filled(n, null);

    int l = 0;
    int r = n - 1;
    int pos = n - 1;

    // Line 2 & 3: Init pointers & result vector
    steps.add(SquaresSortedArrayStep(
      left: l,
      right: r,
      pos: pos,
      activeLine: 2,
      originalArray: List.from(orig),
      resultArray: List.from(res),
      actionEn: "Line 2 & 3: Init left = 0, right = ${n - 1}, res of size $n",
      actionBn: "লাইন ২ ও ৩: left = 0, right = ${n - 1} এবং সাইজ $n এর res তৈরি",
      reasonEn: "Prepare pointers and result vector for O(N) traversal.",
      reasonBn: "O(N) ট্রাভার্সালের জন্য পয়েন্টার ও রেজাল্ট ভেক্টর প্রস্তুত করা হলো।",
    ));

    while (l <= r) {
      // Line 4: Check loop condition
      steps.add(SquaresSortedArrayStep(
        left: l,
        right: r,
        pos: pos,
        activeLine: 4,
        originalArray: List.from(orig),
        resultArray: List.from(res),
        actionEn: "Line 4: Check while (left <= right) → ($l <= $r) is TRUE",
        actionBn: "লাইন ৪: শর্ত চেক while (left <= right) → ($l <= $r) সত্য",
        reasonEn: "Pointers haven't crossed yet. Compare squared values.",
        reasonBn: "পয়েন্টার অতিক্রম করেনি। স্কয়ার বা বর্গ মানসমূহ তুলনা করা হচ্ছে।",
      ));

      int sqL = orig[l] * orig[l];
      int sqR = orig[r] * orig[r];

      if (sqL > sqR) {
        // Line 5: Check if left > right
        steps.add(SquaresSortedArrayStep(
          left: l,
          right: r,
          pos: pos,
          activeLine: 5,
          originalArray: List.from(orig),
          resultArray: List.from(res),
          actionEn: "Line 5: (sqL > sqR) → ($sqL > $sqR) is TRUE",
          actionBn: "লাইন ৫: (sqL > sqR) → ($sqL > $sqR) সত্য",
          reasonEn: "Left square $sqL is larger than right square $sqR.",
          reasonBn: "বামের বর্গ $sqL ডানের বর্গ $sqR এর চেয়ে বড়।",
        ));

        res[pos] = sqL;
        // Line 6 & 7: Place left sq & left++
        steps.add(SquaresSortedArrayStep(
          left: l,
          right: r,
          pos: pos,
          activeLine: 6,
          originalArray: List.from(orig),
          resultArray: List.from(res),
          actionEn: "Line 6 & 7: Execute res[pos--] = sqL; left++; → Place $sqL",
          actionBn: "লাইন ৬ ও ৭: res[pos--] = sqL; left++; সম্পাদন → $sqL বসানো হলো",
          reasonEn: "Placed $sqL at result[$pos] and incremented left pointer.",
          reasonBn: "রেজাল্ট[$pos] এ $sqL বসানো হলো এবং left ১ বাড়ানো হলো।",
        ));
        l++;
      } else {
        // Line 8: Else branch
        steps.add(SquaresSortedArrayStep(
          left: l,
          right: r,
          pos: pos,
          activeLine: 8,
          originalArray: List.from(orig),
          resultArray: List.from(res),
          actionEn: "Line 8: (sqL > sqR) → ($sqL > $sqR) is FALSE",
          actionBn: "লাইন ৮: (sqL > sqR) → ($sqL > $sqR) মিথ্যা",
          reasonEn: "Right square $sqR is larger than or equal to left square $sqL.",
          reasonBn: "ডানের বর্গ $sqR বামের বর্গের চেয়ে বড় বা সমান।",
        ));

        res[pos] = sqR;
        // Line 9 & 10: Place right sq & right--
        steps.add(SquaresSortedArrayStep(
          left: l,
          right: r,
          pos: pos,
          activeLine: 9,
          originalArray: List.from(orig),
          resultArray: List.from(res),
          actionEn: "Line 9 & 10: Execute res[pos--] = sqR; right--; → Place $sqR",
          actionBn: "লাইন ৯ ও ১০: res[pos--] = sqR; right--; সম্পাদন → $sqR বসানো হলো",
          reasonEn: "Placed $sqR at result[$pos] and decremented right pointer.",
          reasonBn: "রেজাল্ট[$pos] এ $sqR বসানো হলো এবং right ১ কমানো হলো।",
        ));
        r--;
      }
      pos--;
    }

    // Line 12: Return result
    steps.add(SquaresSortedArrayStep(
      left: l,
      right: r,
      pos: -1,
      activeLine: 12,
      originalArray: List.from(orig),
      resultArray: List.from(res),
      actionEn: "Line 12: return res 🎉 Sorted Squares: [${res.join(', ')}]",
      actionBn: "লাইন ১২: return res 🎉 সর্টেড বর্গ: [${res.join(', ')}]",
      reasonEn: "Function completed! Array returned in non-decreasing sorted order.",
      reasonBn: "ফাংশন সম্পূর্ণ! ছোট থেকে বড় অর্ডারে সর্টেড রেজাল্ট রিটার্ন করা হয়েছে।",
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

  void _handleUserChoice(String side) {
    if (_userSolved || _userPos < 0) return;

    int sqL = _userArray[_userLeft] * _userArray[_userLeft];
    int sqR = _userArray[_userRight] * _userArray[_userRight];

    setState(() {
      if (side == "left") {
        if (sqL > sqR) {
          _userResult[_userPos] = sqL;
          _userLeft++;
          _userPos--;
          _userFeedbackEn = "✅ Correct! Left square ($sqL) was larger. Placed at result position.";
          _userFeedbackBn = "✅ সঠিক পদক্ষেপ! বামের বর্গ ($sqL) বড় থাকায় রেজাল্টে বসানো হলো।";
        } else {
          _userFeedbackEn = "⚠️ Right square ($sqR) is larger or equal! Choose Right Square.";
          _userFeedbackBn = "⚠️ ডানের বর্গ ($sqR) বড় বা সমান! Right Square নির্বাচন করুন।";
        }
      } else if (side == "right") {
        if (sqR >= sqL) {
          _userResult[_userPos] = sqR;
          _userRight--;
          _userPos--;
          _userFeedbackEn = "✅ Correct! Right square ($sqR) was larger or equal. Placed at result position.";
          _userFeedbackBn = "✅ সঠিক পদক্ষেপ! ডানের বর্গ ($sqR) বড়/সমান থাকায় রেজাল্টে বসানো হলো।";
        } else {
          _userFeedbackEn = "⚠️ Left square ($sqL) is larger! Choose Left Square.";
          _userFeedbackBn = "⚠️ বামের বর্গ ($sqL) বড়! Left Square নির্বাচন করুন।";
        }
      }

      if (_userPos < 0) {
        _userSolved = true;
        _userFeedbackEn = "🎉 Outstanding! You sorted the squared array: [${_userResult.join(', ')}]";
        _userFeedbackBn = "🎉 দারুণ! আপনি সফলভাবে সর্টেড স্কয়ার অ্যারে তৈরি করেছেন: [${_userResult.join(', ')}]";
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
          '977. Squares of a Sorted Array',
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
                    'LeetCode #977',
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
                    '⭐ FAANG Classic (Google, Amazon)',
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
                  ? 'Squares of a Sorted Array'
                  : 'সর্টেড অ্যারের স্কয়ার সর্টিং (Squares of a Sorted Array)',
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
                        ? 'Given an integer array nums sorted in non-decreasing order, return an array of the squares of each number sorted in non-decreasing order.\n\nConstraint: Can you achieve O(N) time complexity using Two Pointers?'
                        : 'একটি নন-ডিক্রিজিং সর্টেড পূর্ণসংখ্যার অ্যারে nums দেওয়া আছে, প্রতিটি উপাদানের বর্গ (squares) নিয়ে নন-ডিক্রিজিং সর্টেড অর্ডারে একটি অ্যারে রিটার্ন করুন।\n\nশর্ত: টু-পয়েন্টার ব্যবহার করে O(N) টাইমে করা সম্ভব?',
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
              "nums = [-4, -1, 0, 3, 10]",
              "Output: [0, 1, 9, 16, 100]",
              _isEnglish
                  ? "Explanation: After squaring: [16, 1, 0, 9, 100]. Sorted: [0, 1, 9, 16, 100]."
                  : "ব্যাখ্যা: বর্গ করার পর: [16, 1, 0, 9, 100]। সর্ট করার পর: [0, 1, 9, 16, 100]।",
            ),
            _buildExampleCard(
              "Example 2",
              "nums = [-7, -3, 2, 3, 11]",
              "Output: [4, 9, 9, 49, 121]",
              _isEnglish
                  ? "Explanation: After squaring: [49, 9, 4, 9, 121]. Sorted: [4, 9, 9, 49, 121]."
                  : "ব্যাখ্যা: বর্গ করার পর সর্টেড ফলাফল: [4, 9, 9, 49, 121]।",
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
      child: SquaresSortedArrayCodeFreeVisualizer(isEnglish: _isEnglish),
    );
  }

  // TAB 3: Dynamic Visualizer
  Widget _buildVisualizerTab(double hPadding) {
    final isMobile = Responsive.isMobile(context);
    final step = _steps.isEmpty
        ? SquaresSortedArrayStep(
            left: 0,
            right: 0,
            pos: 0,
            activeLine: 0,
            originalArray: _currentArray,
            resultArray: List.filled(_currentArray.length, null),
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
                          ? 'Sorted Integer Array nums (comma separated)'
                          : 'সর্টেড ইন্টিজার অ্যারে nums (কমা দিয়ে separated)',
                      hintText: 'e.g. -4, -1, 0, 3, 10',
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
                        _buildPresetChip('[-4,-1,0,3,10]', [-4, -1, 0, 3, 10]),
                        _buildPresetChip('[-7,-3,2,3,11]', [-7, -3, 2, 3, 11]),
                        _buildPresetChip('[-5,-4,-3,-2,-1]', [-5, -4, -3, -2, -1]),
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
                            ? '🎮 Practice Mode: Sort Squares Yourself!'
                            : '🎮 প্র্যাকটিস মোড: নিজে বর্গ সর্ট করুন!',
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
                        ? 'Original Sorted Input: [${_currentArray.join(', ')}]'
                        : 'মূল সর্টেড ইনপুট: [${_currentArray.join(', ')}]',
                    style: TextStyle(
                        color: AppTheme.accentNeonCyan,
                        fontWeight: FontWeight.bold,
                        fontSize: Responsive.sp(context, 13)),
                  ),
                  const SizedBox(height: 16),

                  // Original Pointers View
                  Text('Original Input Pointers:',
                      style: TextStyle(
                          fontSize: Responsive.sp(context, 12),
                          color: AppTheme.textSecondary)),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(_userArray.length, (idx) {
                        final val = _userArray[idx];
                        final isLeft = idx == _userLeft;
                        final isRight = idx == _userRight;

                        Color boxBg = AppTheme.primaryDark;
                        Color borderColor = const Color(0xFF334155);

                        if (isLeft && isRight) {
                          boxBg = AppTheme.accentAmber.withOpacity(0.3);
                          borderColor = AppTheme.accentAmber;
                        } else if (isLeft) {
                          boxBg = AppTheme.accentNeonCyan.withOpacity(0.25);
                          borderColor = AppTheme.accentNeonCyan;
                        } else if (isRight) {
                          boxBg = AppTheme.accentPurple.withOpacity(0.25);
                          borderColor = AppTheme.accentPurple;
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
                              if (isLeft && isRight)
                                Text('L&R',
                                    style: TextStyle(
                                        fontSize: Responsive.sp(context, 10),
                                        color: AppTheme.accentAmber,
                                        fontWeight: FontWeight.bold))
                              else if (isLeft)
                                Text('Left',
                                    style: TextStyle(
                                        fontSize: Responsive.sp(context, 10),
                                        color: AppTheme.accentNeonCyan,
                                        fontWeight: FontWeight.bold))
                              else if (isRight)
                                Text('Right',
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

                  // Result Array Filling
                  Text('Result Array (Filled Back to Front):',
                      style: TextStyle(
                          fontSize: Responsive.sp(context, 12),
                          color: AppTheme.textSecondary)),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(_userResult.length, (idx) {
                        final val = _userResult[idx];
                        final isPos = idx == _userPos;
                        final isFilled = val != null;

                        Color boxBg = isFilled
                            ? AppTheme.accentGreen.withOpacity(0.2)
                            : AppTheme.primaryDark;
                        Color borderColor = isFilled
                            ? AppTheme.accentGreen
                            : const Color(0xFF334155);

                        if (isPos) {
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
                              if (isPos)
                                Text('Pos',
                                    style: TextStyle(
                                        fontSize: Responsive.sp(context, 10),
                                        color: AppTheme.accentAmber,
                                        fontWeight: FontWeight.bold))
                              else
                                Text(' ',
                                    style: TextStyle(fontSize: Responsive.sp(context, 10))),
                              const SizedBox(height: 4),
                              Text(
                                val != null ? '$val' : '?',
                                style: TextStyle(
                                    fontSize: Responsive.sp(context, 18),
                                    fontWeight: FontWeight.bold,
                                    color: isFilled
                                        ? AppTheme.accentGreen
                                        : AppTheme.textMuted),
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
                        onPressed: _userSolved || _userPos < 0
                            ? null
                            : () => _handleUserChoice("left"),
                        icon: Icon(Icons.west, size: Responsive.sp(context, 16)),
                        label: Text(
                            _isEnglish
                                ? 'Place Left Square (${_userLeft < _userArray.length ? _userArray[_userLeft] * _userArray[_userLeft] : 0})'
                                : 'Left এর স্কয়ার বসান',
                            style: TextStyle(fontSize: Responsive.sp(context, 13))),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accentNeonCyan),
                      ),
                      ElevatedButton.icon(
                        onPressed: _userSolved || _userPos < 0
                            ? null
                            : () => _handleUserChoice("right"),
                        icon: Icon(Icons.east, size: Responsive.sp(context, 16)),
                        label: Text(
                            _isEnglish
                                ? 'Place Right Square (${_userRight >= 0 ? _userArray[_userRight] * _userArray[_userRight] : 0})'
                                : 'Right এর স্কয়ার বসান',
                            style: TextStyle(fontSize: Responsive.sp(context, 13))),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accentPurple),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            int n = _currentArray.length;
                            _userArray = List.from(_currentArray);
                            _userResult = List.filled(n, null);
                            _userLeft = 0;
                            _userRight = n - 1;
                            _userPos = n - 1;
                            _userSolved = false;
                            _userFeedbackEn = "Reset done! Compare squares.";
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
                                ? "• Time Complexity: O(N) — Pointers iterate through array once in opposite direction.\n• Space Complexity: O(N) — Required space for result vector."
                                : "• টাইম কমপ্লেক্সিটি: O(N) — পয়েন্টারদ্বয় বিপরীত দিক থেকে মাত্র ১ বার স্ক্যান করে।\n• স্পেস কমপ্লেক্সিটি: O(N) — আউটপুট ভেক্টরের জন্য প্রয়োজনীয় স্থান।",
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
      "vector<int> sortedSquares(vector<int>& nums) {",
      "    int n = nums.size();",
      "    vector<int> res(n);",
      "    int left = 0, right = n - 1, pos = n - 1;",
      "    while (left <= right) {",
      "        if (abs(nums[left]) > abs(nums[right])) {",
      "            res[pos--] = nums[left] * nums[left];",
      "            left++;",
      "        } else {",
      "            res[pos--] = nums[right] * nums[right];",
      "            right--;",
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

  Widget _buildArrayVisualizationBox(SquaresSortedArrayStep step) {
    final orig = step.originalArray;
    final res = step.resultArray;

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
                "Original & Result Arrays",
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
                  "Length: ${orig.length}",
                  style: TextStyle(
                      color: AppTheme.accentNeonCyan,
                      fontWeight: FontWeight.bold,
                      fontSize: Responsive.sp(context, 12)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Original Input Display
          Text("Original Pointers:",
              style: TextStyle(
                  fontSize: Responsive.sp(context, 11),
                  color: AppTheme.textSecondary)),
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(orig.length, (idx) {
                final val = orig[idx];
                final isLeft = idx == step.left;
                final isRight = idx == step.right;

                Color boxBg = AppTheme.primaryDark;
                Color borderColor = const Color(0xFF334155);

                if (isLeft && isRight) {
                  boxBg = AppTheme.accentAmber.withOpacity(0.35);
                  borderColor = AppTheme.accentAmber;
                } else if (isLeft) {
                  boxBg = AppTheme.accentNeonCyan.withOpacity(0.25);
                  borderColor = AppTheme.accentNeonCyan;
                } else if (isRight) {
                  boxBg = AppTheme.accentPurple.withOpacity(0.25);
                  borderColor = AppTheme.accentPurple;
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

          // Result Display
          Text("Result Array (Back to Front):",
              style: TextStyle(
                  fontSize: Responsive.sp(context, 11),
                  color: AppTheme.accentGreen)),
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(res.length, (idx) {
                final val = res[idx];
                final isPos = idx == step.pos;
                final isFilled = val != null;

                Color boxBg = isFilled
                    ? AppTheme.accentGreen.withOpacity(0.2)
                    : AppTheme.primaryDark;
                Color borderColor = isFilled
                    ? AppTheme.accentGreen
                    : const Color(0xFF334155);

                if (isPos) {
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
                        val != null ? '$val' : '?',
                        style: TextStyle(
                            fontSize: Responsive.sp(context, 14),
                            fontWeight: FontWeight.bold,
                            color: isFilled
                                ? AppTheme.accentGreen
                                : AppTheme.textMuted),
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
    vector<int> sortedSquares(vector<int>& nums) {
        int n = nums.size();
        vector<int> res(n);
        int left = 0, right = n - 1, pos = n - 1;
        
        while (left <= right) {
            if (abs(nums[left]) > abs(nums[right])) {
                res[pos--] = nums[left] * nums[left];
                left++;
            } else {
                res[pos--] = nums[right] * nums[right];
                right--;
            }
        }
        return res;
    }
};""";
    } else if (lang == "Java") {
      code = """
class Solution {
    public int[] sortedSquares(int[] nums) {
        int n = nums.length;
        int[] res = new int[n];
        int left = 0, right = n - 1, pos = n - 1;
        
        while (left <= right) {
            if (Math.abs(nums[left]) > Math.abs(nums[right])) {
                res[pos--] = nums[left] * nums[left];
                left++;
            } else {
                res[pos--] = nums[right] * nums[right];
                right--;
            }
        }
        return res;
    }
}""";
    } else if (lang == "Python") {
      code = """
class Solution:
    def sortedSquares(self, nums: List[int]) -> List[int]:
        n = len(nums)
        res = [0] * n
        left, right, pos = 0, n - 1, n - 1
        
        while left <= right:
            if abs(nums[left]) > abs(nums[right]):
                res[pos] = nums[left] ** 2
                left += 1
            else:
                res[pos] = nums[right] ** 2
                right -= 1
            pos -= 1
        return res""";
    } else {
      code = """
List<int> sortedSquares(List<int> nums) {
  int n = nums.length;
  List<int> res = List.filled(n, 0);
  int left = 0, right = n - 1, pos = n - 1;

  while (left <= right) {
    if (nums[left].abs() > nums[right].abs()) {
      res[pos--] = nums[left] * nums[left];
      left++;
    } else {
      res[pos--] = nums[right] * nums[right];
      right--;
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
