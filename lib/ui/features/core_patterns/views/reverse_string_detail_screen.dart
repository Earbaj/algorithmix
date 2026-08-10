import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import 'package:algorithmix/ui/features/core_patterns/widgets/reverse_string_code_free_visualizer.dart';

class ReverseStringStep {
  final int left;
  final int right;
  final int activeLine;
  final List<String> arrayState;
  final String actionEn;
  final String actionBn;
  final String reasonEn;
  final String reasonBn;
  final bool isFinish;

  const ReverseStringStep({
    required this.left,
    required this.right,
    required this.activeLine,
    required this.arrayState,
    required this.actionEn,
    required this.actionBn,
    required this.reasonEn,
    required this.reasonBn,
    this.isFinish = false,
  });
}

class ReverseStringDetailScreen extends StatefulWidget {
  const ReverseStringDetailScreen({super.key});

  @override
  State<ReverseStringDetailScreen> createState() =>
      _ReverseStringDetailScreenState();
}

class _ReverseStringDetailScreenState extends State<ReverseStringDetailScreen>
    with SingleTickerProviderStateMixin {
  bool _isEnglish = true;
  late TabController _tabController;

  // Custom Input State
  final TextEditingController _inputController =
      TextEditingController(text: "h, e, l, l, o");

  List<String> _currentArray = ["h", "e", "l", "l", "o"];
  List<ReverseStringStep> _steps = [];

  // Playback Control
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  // Practice Mode State
  bool _showAnswer = false;
  int _userLeft = 0;
  int _userRight = 4;
  List<String> _userArray = ["h", "e", "l", "l", "o"];
  String _userFeedbackEn = "Tap Swap to exchange left & right characters in-place!";
  String _userFeedbackBn = "ইন-প্লেস অক্ষর অদলবদল করতে Swap বাটনে চাপ দিন!";
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
      List<String> parsed = _inputController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
      if (parsed.isEmpty) {
        parsed = ["h", "e", "l", "l", "o"];
      }
      _currentArray = parsed;
    } catch (_) {
      _currentArray = ["h", "e", "l", "l", "o"];
    }

    _userArray = List.from(_currentArray);
    _userLeft = 0;
    _userRight = _currentArray.length - 1;
    _userSolved = false;
    _userFeedbackEn = "Start swapping left and right characters!";
    _userFeedbackBn = "অক্ষরসমূহ অদলবদল করা শুরু করুন!";

    _steps = _generateSteps(_currentArray);
    setState(() {});
  }

  List<ReverseStringStep> _generateSteps(List<String> input) {
    List<ReverseStringStep> steps = [];
    List<String> arr = List.from(input);
    int l = 0;
    int r = arr.length - 1;

    // Line 2: Initialize pointers
    steps.add(ReverseStringStep(
      left: l,
      right: r,
      activeLine: 2,
      arrayState: List.from(arr),
      actionEn: "Line 2: Initialize pointers → left = 0 ('${arr[l]}'), right = ${arr.length - 1} ('${arr[r]}')",
      actionBn: "লাইন ২: পয়েন্টার সূচনা → left = 0 ('${arr[l]}'), right = ${arr.length - 1} ('${arr[r]}')",
      reasonEn: "Left pointer starts at beginning and Right pointer starts at end.",
      reasonBn: "Left পয়েন্টার শুরুতে (০) এবং Right পয়েন্টার একদম শেষে বসানো হলো।",
    ));

    while (l < r) {
      // Line 3: Check while (left < right)
      steps.add(ReverseStringStep(
        left: l,
        right: r,
        activeLine: 3,
        arrayState: List.from(arr),
        actionEn: "Line 3: Check while (left < right) → ($l < $r) is TRUE",
        actionBn: "লাইন ৩: লুপ শর্ত চেক while (left < right) → ($l < $r) সত্য",
        reasonEn: "Pointers haven't met or crossed yet. Proceed with swap.",
        reasonBn: "পয়েন্টারদ্বয় এখনো কেন্দ্রে পৌঁছায়নি। অদলবদল চালিয়ে যান।",
      ));

      // Line 4: Perform swap
      String charL = arr[l];
      String charR = arr[r];
      String temp = arr[l];
      arr[l] = arr[r];
      arr[r] = temp;

      steps.add(ReverseStringStep(
        left: l,
        right: r,
        activeLine: 4,
        arrayState: List.from(arr),
        actionEn: "Line 4: Execute swap(s[left], s[right]) → Swap ('$charL' ⇋ '$charR')",
        actionBn: "লাইন ৪: swap(s[left], s[right]) সম্পাদন → অদলবদল ('$charL' ⇋ '$charR')",
        reasonEn: "In-place swap exchanges characters at left and right indices.",
        reasonBn: "ইন-প্লেস Swap দিয়ে বাম ও ডান ইনডেক্সের অক্ষর অদলবদল করা হলো।",
      ));

      // Line 5 & 6: Increment left & Decrement right
      l++;
      r--;
      steps.add(ReverseStringStep(
        left: l,
        right: r,
        activeLine: 5,
        arrayState: List.from(arr),
        actionEn: "Line 5 & 6: Execute left++ and right--",
        actionBn: "লাইন ৫ ও ৬: left++ এবং right-- সম্পাদন",
        reasonEn: "Increment left pointer to $l and decrement right pointer to $r.",
        reasonBn: "left পয়েন্টার ডানদিকে এবং right পয়েন্টার বামদিকে সরানো হলো।",
      ));
    }

    // Line 8: Finish
    steps.add(ReverseStringStep(
      left: l,
      right: r,
      activeLine: 8,
      arrayState: List.from(arr),
      actionEn: "Line 8: Function Complete 🎉 Reversed Result: [${arr.join(', ')}]",
      actionBn: "লাইন ৮: ফাংশন সমাপ্ত 🎉 রিভার্সড ফলাফল: [${arr.join(', ')}]",
      reasonEn: "Pointers met/crossed in center. String successfully reversed in-place!",
      reasonBn: "পয়েন্টারদ্বয় কেন্দ্রে পৌঁছে গেছে। স্ট্রিং সফলভাবে রিভার্সড হয়েছে!",
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

  void _loadPreset(List<String> arr) {
    _inputController.text = arr.join(', ');
    _rebuildSteps();
  }

  void _handleUserSwap() {
    if (_userSolved || _userLeft >= _userRight) return;

    setState(() {
      String temp = _userArray[_userLeft];
      _userArray[_userLeft] = _userArray[_userRight];
      _userArray[_userRight] = temp;

      _userLeft++;
      _userRight--;

      if (_userLeft >= _userRight) {
        _userSolved = true;
        _userFeedbackEn = "🎉 Perfect! You reversed the string in-place: ${_userArray.join('')}!";
        _userFeedbackBn = "🎉 দারুণ! আপনি সফলভাবে স্ট্রিংটি রিভার্স করেছেন: ${_userArray.join('')}!";
      } else {
        _userFeedbackEn = "✅ Swapped successfully! Continue with next pair.";
        _userFeedbackBn = "✅ Swap সম্পন্ন হয়েছে! পরবর্তী জোড়া অদলবদল করুন।";
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
          '344. Reverse String',
          style: TextStyle(
            fontSize: Responsive.sp(context, 18),
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
                    'LeetCode #344',
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
                    '⭐ FAANG Classic (Google, Apple)',
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
              _isEnglish ? 'Reverse String' : 'রিভার্স স্ট্রিং (Reverse String)',
              style: TextStyle(
                fontSize: Responsive.sp(context, 22),
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
                        ? 'Write a function that reverses a string. The input string is given as an array of characters s.\n\nYou must do this by modifying the input array in-place with O(1) extra memory.'
                        : 'একটি ফাংশন লিখুন যা একটি স্ট্রিং কে বিপরীত (reverse) করবে। ইনপুট স্ট্রিংটি একটি ক্যারেক্টার অ্যারে s হিসেবে দেওয়া আছে।\n\nআপনাকে অবশ্যই O(1) অতিরিক্ত মেমোরি ব্যবহার করে ইনপুট অ্যারেটি ইন-প্লেস modify করতে হবে।',
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
              "s = [\"h\", \"e\", \"l\", \"l\", \"o\"]",
              "Output: [\"o\", \"l\", \"l\", \"e\", \"h\"]",
              _isEnglish
                  ? "Explanation: In-place swaps 'h' with 'o' and 'e' with 'l'."
                  : "ব্যাখ্যা: ইন-প্লেস 'h' এবং 'o' এবং 'e' এবং 'l' অদলবদল করা হয়েছে।",
            ),
            _buildExampleCard(
              "Example 2",
              "s = [\"H\", \"a\", \"n\", \"n\", \"a\", \"h\"]",
              "Output: [\"h\", \"a\", \"n\", \"n\", \"a\", \"H\"]",
              _isEnglish
                  ? "Explanation: All characters swapped in-place with zero auxiliary memory."
                  : "ব্যাখ্যা: কোনো অতিরিক্ত মেমোরি ছাড়াই সব বর্ণ অদলবদল করা হয়েছে।",
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
      child: ReverseStringCodeFreeVisualizer(isEnglish: _isEnglish),
    );
  }

  // TAB 3: Dynamic Visualizer
  Widget _buildVisualizerTab(double hPadding) {
    final isMobile = Responsive.isMobile(context);
    final step = _steps.isEmpty
        ? ReverseStringStep(
            left: 0,
            right: 0,
            activeLine: 0,
            arrayState: _currentArray,
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
                          ? 'Character Array (comma separated)'
                          : 'ক্যারেক্টার অ্যারে (কমা দিয়ে separated)',
                      hintText: 'e.g. h, e, l, l, o',
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
                        _buildPresetChip('["h","e","l","l","o"]', ["h", "e", "l", "l", "o"]),
                        _buildPresetChip('["H","a","n","n","a","h"]', ["H", "a", "n", "n", "a", "h"]),
                        _buildPresetChip('["a","b","c"]', ["a", "b", "c"]),
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
                            ? '🎮 Practice Mode: Reverse It Yourself!'
                            : '🎮 প্র্যাকটিস মোড: নিজে Swap করুন!',
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
                        ? 'Original: [${_currentArray.join(', ')}]'
                        : 'মূল ইনপুট: [${_currentArray.join(', ')}]',
                    style: TextStyle(
                        color: AppTheme.accentNeonCyan,
                        fontWeight: FontWeight.bold,
                        fontSize: Responsive.sp(context, 13)),
                  ),
                  const SizedBox(height: 16),

                  // Array View
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(_userArray.length, (idx) {
                        final char = _userArray[idx];
                        final isLeft = idx == _userLeft;
                        final isRight = idx == _userRight;

                        Color boxColor = AppTheme.primaryDark;
                        Color borderColor = const Color(0xFF334155);

                        if (_userSolved) {
                          boxColor = AppTheme.accentGreen.withOpacity(0.2);
                          borderColor = AppTheme.accentGreen;
                        } else if (isLeft && isRight) {
                          boxColor = AppTheme.accentAmber.withOpacity(0.3);
                          borderColor = AppTheme.accentAmber;
                        } else if (isLeft) {
                          boxColor = AppTheme.accentNeonCyan.withOpacity(0.25);
                          borderColor = AppTheme.accentNeonCyan;
                        } else if (isRight) {
                          boxColor = AppTheme.accentPurple.withOpacity(0.25);
                          borderColor = AppTheme.accentPurple;
                        }

                        return Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: EdgeInsets.symmetric(
                            horizontal: Responsive.sp(context, 14),
                            vertical: Responsive.sp(context, 10),
                          ),
                          decoration: BoxDecoration(
                            color: boxColor,
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
                                '"$char"',
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
                            : _handleUserSwap,
                        icon: Icon(Icons.swap_horiz, size: Responsive.sp(context, 16)),
                        label: Text(
                            _isEnglish ? 'Swap (Left ⇋ Right)' : 'অদলবদল করুন (Swap)',
                            style: TextStyle(fontSize: Responsive.sp(context, 13))),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accentNeonCyan),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            _userArray = List.from(_currentArray);
                            _userLeft = 0;
                            _userRight = _currentArray.length - 1;
                            _userSolved = false;
                            _userFeedbackEn = "Reset done! Start swapping.";
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
                                ? "• Time Complexity: O(N) — Swapping happens N/2 times.\n• Space Complexity: O(1) — Memory requirement is constant since array is modified in-place."
                                : "• টাইম কমপ্লেক্সিটি: O(N) — N/2 বার swapping সম্পন্ন হয়।\n• স্পেস কমপ্লেক্সিটি: O(1) — কোনো অতিরিক্ত মেমোরি ছাড়াই ইন-প্লেস কাজ করে।",
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

  Widget _buildPresetChip(String label, List<String> arr) {
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
      "void reverseString(vector<char>& s) {",
      "    int left = 0, right = s.size() - 1;",
      "    while (left < right) {",
      "        swap(s[left], s[right]);",
      "        left++;",
      "        right--;",
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

  Widget _buildArrayVisualizationBox(ReverseStringStep step) {
    final arr = step.arrayState;

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
                "Array Reversal State",
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
                final char = arr[idx];
                final isLeft = idx == step.left;
                final isRight = idx == step.right;
                final isSwapped = idx < step.left || idx > step.right;

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
                } else if (isSwapped) {
                  borderColor = AppTheme.accentGreen.withOpacity(0.6);
                  boxBg = AppTheme.accentGreen.withOpacity(0.12);
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
                      if (isLeft && isRight)
                        Text('L&R',
                            style: TextStyle(
                                fontSize: Responsive.sp(context, 9.5),
                                color: AppTheme.accentAmber,
                                fontWeight: FontWeight.bold))
                      else if (isLeft)
                        Text('Left',
                            style: TextStyle(
                                fontSize: Responsive.sp(context, 9.5),
                                color: AppTheme.accentNeonCyan,
                                fontWeight: FontWeight.bold))
                      else if (isRight)
                        Text('Right',
                            style: TextStyle(
                                fontSize: Responsive.sp(context, 9.5),
                                color: AppTheme.accentPurple,
                                fontWeight: FontWeight.bold))
                      else
                        Text(' ',
                            style: TextStyle(fontSize: Responsive.sp(context, 9.5))),
                      const SizedBox(height: 4),
                      Text(
                        '"$char"',
                        style: TextStyle(
                          fontSize: Responsive.sp(context, 16),
                          fontWeight: FontWeight.bold,
                          color: isSwapped ? AppTheme.accentGreen : Colors.white,
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
    void reverseString(vector<char>& s) {
        int left = 0, right = s.size() - 1;
        while (left < right) {
            swap(s[left], s[right]);
            left++;
            right--;
        }
    }
};""";
    } else if (lang == "Java") {
      code = """
class Solution {
    public void reverseString(char[] s) {
        int left = 0, right = s.length - 1;
        while (left < right) {
            char temp = s[left];
            s[left] = s[right];
            s[right] = temp;
            left++;
            right--;
        }
    }
}""";
    } else if (lang == "Python") {
      code = """
class Solution:
    def reverseString(self, s: List[str]) -> None:
        left, right = 0, len(s) - 1
        while left < right:
            s[left], s[right] = s[right], s[left]
            left += 1
            right -= 1""";
    } else {
      code = """
void reverseString(List<String> s) {
  int left = 0, right = s.length - 1;
  while (left < right) {
    String temp = s[left];
    s[left] = s[right];
    s[right] = temp;
    left++;
    right--;
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
