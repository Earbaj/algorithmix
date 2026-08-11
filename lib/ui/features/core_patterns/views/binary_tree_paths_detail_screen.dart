import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class BinaryTreePathsStep {
  final String activeNodeVal;
  final String currentPathString;
  final List<String> allPaths;
  final String decision; // 'init', 'visit_node', 'leaf_reached', 'backtrack'
  final int activeLine;
  final String actionEn;
  final String actionBn;
  final String reasonEn;
  final String reasonBn;
  final int callStackDepth;

  const BinaryTreePathsStep({
    required this.activeNodeVal,
    required this.currentPathString,
    required this.allPaths,
    required this.decision,
    required this.activeLine,
    required this.actionEn,
    required this.actionBn,
    required this.reasonEn,
    required this.reasonBn,
    required this.callStackDepth,
  });
}

class BinaryTreePathsDetailScreen extends StatefulWidget {
  const BinaryTreePathsDetailScreen({super.key});

  @override
  State<BinaryTreePathsDetailScreen> createState() => _BinaryTreePathsDetailScreenState();
}

class _BinaryTreePathsDetailScreenState extends State<BinaryTreePathsDetailScreen>
    with SingleTickerProviderStateMixin {
  bool _isEnglish = true;
  late TabController _tabController;

  // Preset Selection (0: Tree 1 [1,2,3,null,5], 1: Tree 2 [10,5,15,2], 2: Tree 3 [1,2])
  int _presetIndex = 0;
  List<BinaryTreePathsStep> _steps = [];

  // Playback Control
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  // Code Language Selector
  String _selectedCodeLang = "C++";

  // Tab 2 Animation Model Selector (0: Step Flowcard, 1: Tree Graph, 2: Leaf Checker)
  int _animationModelIndex = 0;
  int _flowStepIndex = 0;

  // Practice Mode State
  List<String> _practiceCurrentPath = [];
  List<String> _practiceResults = [];
  List<String> _practiceHistory = [];
  String _userFeedbackEn = "Tap tree nodes to trace root-to-leaf paths!";
  String _userFeedbackBn = "রুট থেকে লিফ পর্যন্ত পাথ তৈরি করতে ট্রি নোডগুলোতে স্পর্শ করুন!";
  bool _practiceSolved = false;

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
    _flowStepIndex = 0;

    _steps = _generateStepsForPreset(_presetIndex);

    // Reset practice mode
    _practiceCurrentPath = [];
    _practiceResults = [];
    _practiceHistory = [];
    _practiceSolved = false;
    _userFeedbackEn = "Tap tree nodes to trace root-to-leaf paths!";
    _userFeedbackBn = "রুট থেকে লিফ পর্যন্ত পাথ তৈরি করতে ট্রি নোডগুলোতে স্পর্শ করুন!";
  }

  List<BinaryTreePathsStep> _generateStepsForPreset(int preset) {
    List<BinaryTreePathsStep> steps = [];

    if (preset == 0) {
      // Tree 1: 1 -> (2 -> 5, 3)
      steps = [
        const BinaryTreePathsStep(
          activeNodeVal: "1",
          currentPathString: "1",
          allPaths: [],
          decision: "visit_node",
          activeLine: 1,
          actionEn: "Line 1: Visit Root Node '1' ➔ Path = \"1\".",
          actionBn: "লাইন ১: রুট নোড '1' পরিদর্শন ➔ Path = \"1\"।",
          reasonEn: "Start DFS top-down from root node 1.",
          reasonBn: "রুট নোড 1 থেকে উপর-নিচে DFS রিকার্সন শুরু।",
          callStackDepth: 1,
        ),
        const BinaryTreePathsStep(
          activeNodeVal: "2",
          currentPathString: "1->2",
          allPaths: [],
          decision: "visit_node",
          activeLine: 7,
          actionEn: "Line 7: Recurse Left child '2' ➔ Path = \"1->2\".",
          actionBn: "লাইন ৭: বাম পাশের নোড '2' এ প্রবেশ ➔ Path = \"1->2\"।",
          reasonEn: "Node 1 has left child 2. Append '->2'.",
          reasonBn: "নোড 1 এর বাম চাইল্ড 2 বিদ্যমান। '->2' যোগ করা হলো।",
          callStackDepth: 2,
        ),
        const BinaryTreePathsStep(
          activeNodeVal: "5",
          currentPathString: "1->2->5",
          allPaths: [],
          decision: "visit_node",
          activeLine: 8,
          actionEn: "Line 8: Recurse Right child '5' ➔ Path = \"1->2->5\".",
          actionBn: "লাইন ৮: ডান পাশের নোড '5' এ প্রবেশ ➔ Path = \"1->2->5\"।",
          reasonEn: "Node 2 has right child 5. Append '->5'.",
          reasonBn: "নোড 2 এর ডান চাইল্ড 5 বিদ্যমান। '->5' যোগ করা হলো।",
          callStackDepth: 3,
        ),
        const BinaryTreePathsStep(
          activeNodeVal: "5",
          currentPathString: "1->2->5",
          allPaths: ["1->2->5"],
          decision: "leaf_reached",
          activeLine: 3,
          actionEn: "🎉 Line 3: Leaf Node '5' Reached! Saved path \"1->2->5\".",
          actionBn: "🎉 লাইন ৩: লিফ নোড '5' অর্জিত! \"1->2->5\" পাথ সংরক্ষিত।",
          reasonEn: "Node 5 has no left/right children (leaf). Save full path.",
          reasonBn: "নোড 5 এর আর কোনো বাম/ডান চাইল্ড নেই। সম্পূর্ণ পাথ সংরক্ষণ করো।",
          callStackDepth: 3,
        ),
        const BinaryTreePathsStep(
          activeNodeVal: "1",
          currentPathString: "1",
          allPaths: ["1->2->5"],
          decision: "backtrack",
          activeLine: 9,
          actionEn: "Line 9: Backtrack ↩️ Return to Root Node '1'.",
          actionBn: "লাইন ৯: ব্যাকট্র্যাক ↩️ রুট নোড '1' এ প্রত্যাবর্তন।",
          reasonEn: "Completed left branch recursion. Now explore right child of 1.",
          reasonBn: "বাম ডালের রিকার্সন সম্পন্ন। এখন নোড 1 এর ডান চাইল্ড পরীক্ষা করো।",
          callStackDepth: 1,
        ),
        const BinaryTreePathsStep(
          activeNodeVal: "3",
          currentPathString: "1->3",
          allPaths: ["1->2->5"],
          decision: "visit_node",
          activeLine: 8,
          actionEn: "Line 8: Recurse Right child '3' ➔ Path = \"1->3\".",
          actionBn: "লাইন ৮: ডান পাশের নোড '3' এ প্রবেশ ➔ Path = \"1->3\"।",
          reasonEn: "Node 1 has right child 3. Append '->3'.",
          reasonBn: "নোড 1 এর ডান চাইল্ড 3 বিদ্যমান। '->3' যোগ করা হলো।",
          callStackDepth: 2,
        ),
        const BinaryTreePathsStep(
          activeNodeVal: "3",
          currentPathString: "1->3",
          allPaths: ["1->2->5", "1->3"],
          decision: "leaf_reached",
          activeLine: 3,
          actionEn: "🎉 Line 3: Leaf Node '3' Reached! Saved second path \"1->3\".",
          actionBn: "🎉 লাইন ৩: লিফ নোড '3' অর্জিত! দ্বিতীয় পাথ \"1->3\" সংরক্ষিত।",
          reasonEn: "Node 3 is a leaf node. Save path string.",
          reasonBn: "নোড 3 একটি লিফ নোড। পাথ স্ট্রিং সংরক্ষণ করো।",
          callStackDepth: 2,
        ),
        const BinaryTreePathsStep(
          activeNodeVal: "1",
          currentPathString: "",
          allPaths: ["1->2->5", "1->3"],
          decision: "leaf_reached",
          activeLine: 10,
          actionEn: "🎉 Line 10: DFS Traversal Complete! Generated total 2 root-to-leaf paths!",
          actionBn: "🎉 লাইন ১০: DFS রিকার্সন সম্পূর্ণ! মোট ২টি root-to-leaf পাথ জেনারেট সম্পন্ন!",
          reasonEn: "All binary tree paths explored.",
          reasonBn: "সমস্ত ট্রি পাথ অনুসন্ধান সম্পন্ন হয়েছে।",
          callStackDepth: 0,
        ),
      ];
    } else {
      // Preset 1: Tree [10, 5, 15, 2]
      steps = [
        const BinaryTreePathsStep(
          activeNodeVal: "10",
          currentPathString: "10",
          allPaths: [],
          decision: "visit_node",
          activeLine: 1,
          actionEn: "Line 1: Visit Root '10' ➔ Path = \"10\".",
          actionBn: "লাইন ১: রুট '10' পরিদর্শন ➔ Path = \"10\"।",
          reasonEn: "Start DFS top-down.",
          reasonBn: "DFS উপর-নিচে শুরু।",
          callStackDepth: 1,
        ),
        const BinaryTreePathsStep(
          activeNodeVal: "5",
          currentPathString: "10->5",
          allPaths: [],
          decision: "visit_node",
          activeLine: 7,
          actionEn: "Line 7: Recurse Left child '5' ➔ Path = \"10->5\".",
          actionBn: "লাইন ৭: বাম চাইল্ড '5' এ প্রবেশ ➔ Path = \"10->5\"।",
          reasonEn: "Append '->5'.",
          reasonBn: "'->5' যোগ করা হলো।",
          callStackDepth: 2,
        ),
        const BinaryTreePathsStep(
          activeNodeVal: "2",
          currentPathString: "10->5->2",
          allPaths: [],
          decision: "visit_node",
          activeLine: 7,
          actionEn: "Line 7: Recurse Left child '2' ➔ Path = \"10->5->2\".",
          actionBn: "লাইন ৭: বাম চাইল্ড '2' এ প্রবেশ ➔ Path = \"10->5->2\"।",
          reasonEn: "Append '->2'.",
          reasonBn: "'->2' যোগ করা হলো।",
          callStackDepth: 3,
        ),
        const BinaryTreePathsStep(
          activeNodeVal: "2",
          currentPathString: "10->5->2",
          allPaths: ["10->5->2"],
          decision: "leaf_reached",
          activeLine: 3,
          actionEn: "🎉 Line 3: Leaf Node '2' Reached! Saved path \"10->5->2\".",
          actionBn: "🎉 লাইন ৩: লিফ নোড '2' অর্জিত! \"10->5->2\" পাথ সংরক্ষিত।",
          reasonEn: "Leaf reached.",
          reasonBn: "লিফ নোড প্রাপ্ত।",
          callStackDepth: 3,
        ),
        const BinaryTreePathsStep(
          activeNodeVal: "15",
          currentPathString: "10->15",
          allPaths: ["10->5->2", "10->15"],
          decision: "leaf_reached",
          activeLine: 3,
          actionEn: "🎉 Line 3: Leaf Node '15' Reached! Saved second path \"10->15\".",
          actionBn: "🎉 লাইন ৩: লিফ নোড '15' অর্জিত! \"10->15\" পাথ সংরক্ষিত।",
          reasonEn: "Leaf reached.",
          reasonBn: "লিফ নোড প্রাপ্ত।",
          callStackDepth: 2,
        ),
      ];
    }

    return steps;
  }

  void _togglePlay() {
    setState(() => _isPlaying = !_isPlaying);
    if (_isPlaying) {
      _timer = Timer.periodic(const Duration(milliseconds: 1400), (timer) {
        if (_currentStepIndex < _steps.length - 1) {
          setState(() => _currentStepIndex++);
        } else {
          _timer?.cancel();
          setState(() => _isPlaying = false);
        }
      });
    } else {
      _timer?.cancel();
    }
  }

  void _handlePracticeNodeTap(String nodeVal) {
    if (_practiceSolved) return;

    List<String> targetPaths = _presetIndex == 0 ? ["1->2->5", "1->3"] : ["10->5->2", "10->15"];

    setState(() {
      _practiceCurrentPath.add(nodeVal);
      _practiceHistory.add("TAP '$nodeVal'");

      String currentStr = _practiceCurrentPath.join("->");

      if (targetPaths.contains(currentStr)) {
        if (!_practiceResults.contains(currentStr)) {
          _practiceResults.add(currentStr);
          _userFeedbackEn = "🎉 Perfect! Valid path \"$currentStr\" Saved! (${_practiceResults.length} / ${targetPaths.length})";
          _userFeedbackBn = "🎉 দারুণ! সঠিক পাথ \"$currentStr\" সংরক্ষিত! (${_practiceResults.length} / ${targetPaths.length})";
        } else {
          _userFeedbackEn = "ℹ️ Path \"$currentStr\" was already collected. Trace another path!";
          _userFeedbackBn = "ℹ️ পাথ \"$currentStr\" ইতিমধ্যেই সংগৃহীত হয়েছে। অন্যটি চেষ্টা করুন!";
        }

        // Reset for next path
        _practiceCurrentPath = [];

        if (_practiceResults.length >= targetPaths.length) {
          _practiceSolved = true;
          _userFeedbackEn = "🏆 MASTERED! You collected all ${targetPaths.length} root-to-leaf paths!";
          _userFeedbackBn = "🏆 দারুণ! আপনি সবকটি ${targetPaths.length} টি root-to-leaf পাথ বের করে ফেলেছেন!";
        }
      } else {
        _userFeedbackEn = "✅ Added '$nodeVal'! Current Path = \"$currentStr\". Keep tracing towards a leaf!";
        _userFeedbackBn = "✅ '$nodeVal' যোগ করা হলো! বর্তমান পাথ = \"$currentStr\"। লিফ নোডের দিকে এগিয়ে যান!";
      }
    });
  }

  void _undoPracticeMove() {
    if (_practiceHistory.isNotEmpty && _practiceCurrentPath.isNotEmpty) {
      setState(() {
        _practiceHistory.removeLast();
        _practiceCurrentPath.removeLast();
        _userFeedbackEn = "↩️ Undid last node tap. Path = \"${_practiceCurrentPath.join('->')}\".";
        _userFeedbackBn = "↩️ পূর্ববর্তী নোড ট্যাপ বাতিল করা হলো। Path = \"${_practiceCurrentPath.join('->')}\"।";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final hPadding = Responsive.horizontalPadding(context);

    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      appBar: AppBar(
        title: Text(
          '257. Binary Tree Paths',
          style: TextStyle(fontSize: Responsive.sp(context, 18), fontWeight: FontWeight.bold),
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
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: Responsive.sp(context, 13)),
              ),
              onPressed: () {
                setState(() => _isEnglish = !_isEnglish);
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
          _buildProblemDescriptionTab(),
          _buildCodeFreeAnimationTab(),
          _buildVisualizerTab(),
          _buildPracticeTab(),
        ],
      ),
    );
  }

  // TAB 1: Problem Description
  Widget _buildProblemDescriptionTab() {
    final hPadding = Responsive.horizontalPadding(context);

    return ResponsiveCenter(
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title + Tags
            Row(
              children: [
                Expanded(
                  child: Text(
                    "257. Binary Tree Paths",
                    style: TextStyle(fontSize: Responsive.sp(context, 22), fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.accentGreen.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.accentGreen),
                  ),
                  child: const Text("Easy", style: TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              children: ["Meta", "Amazon", "Microsoft", "Google", "Apple", "Uber"].map((company) {
                return Chip(
                  backgroundColor: AppTheme.surfaceDark,
                  label: Text(company, style: const TextStyle(color: AppTheme.accentNeonCyan, fontSize: 11)),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Description Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF1E293B)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isEnglish
                        ? "Given the root of a binary tree, return all root-to-leaf paths in any order. A leaf is a node with no children."
                        : "একটি বাইনারি ট্রি-এর রুট নোড দেওয়া আছে। রুট থেকে লিফ (root-to-leaf) পর্যন্ত সমস্ত সম্ভাব্য পথের সংযোগ স্ট্রিং রিটার্ন করুন।",
                    style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Examples
            Text(_isEnglish ? "Examples" : "উদাহরণসমূহ", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            _buildExampleCard("Example 1", "root = [1, 2, 3, null, 5]", "Output: [\"1->2->5\", \"1->3\"]"),
            _buildExampleCard("Example 2", "root = [1]", "Output: [\"1\"]"),
            const SizedBox(height: 20),

            // Intuition Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.accentPurple.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.accentPurple),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.lightbulb_outline, color: AppTheme.accentAmber, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        _isEnglish ? "Key Intuition (DFS Top-to-Bottom Traversal)" : "মূল আইডিয়া (DFS উপর থেকে নিচে ট্রাভার্সাল)",
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isEnglish
                        ? "Pass the current path string down recursion. Append node->val. When left == nullptr && right == nullptr (leaf node reached), save the path string to results!"
                        : "রিকার্সনে বর্তমান পাথ স্ট্রিং নিচে পাঠান। node->val যুক্ত করুন। যখন left == nullptr && right == nullptr (লিফ নোডে পৌঁছানো হয়), পাথটি সংরক্ষন করুন!",
                    style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13, height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Code Solutions (C++, Java, Python)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _isEnglish ? "Code Solutions" : "কোড সমাধানসমূহ",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                DropdownButton<String>(
                  value: _selectedCodeLang,
                  dropdownColor: AppTheme.surfaceDark,
                  style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold),
                  items: ["C++", "Java", "Python"].map((lang) {
                    return DropdownMenuItem(value: lang, child: Text(lang));
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedCodeLang = val);
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildCodeSnippetBox(_selectedCodeLang),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // TAB 2: Code-Free Animation (3 Interactive Concept Models)
  Widget _buildCodeFreeAnimationTab() {
    final hPadding = Responsive.horizontalPadding(context);

    return ResponsiveCenter(
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isEnglish ? "Binary Tree Paths Visual Models (Concept Explanations)" : "বাইনারি ট্রি পাথ ভিজ্যুয়াল মডেলসমূহ (কোডহীন গাইড)",
              style: TextStyle(fontSize: Responsive.sp(context, 18), fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 6),
            Text(
              _isEnglish
                  ? "Explore 3 interactive models for Tree [1, 2, 3, null, 5]."
                  : "ট্রি [1, 2, 3, null, 5] এর জন্য ৩টি ইন্টারঅ্যাক্টিভ ভিজ্যুয়াল মডেল পর্যবেক্ষণ করুন।",
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 16),

            // Model Switcher Segmented Control
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildAnimationModelChip(0, _isEnglish ? "1. 🪜 Step Flowcard" : "১. 🪜 স্টেপ-বাই-স্টেপ ফ্লো-কার্ড"),
                  _buildAnimationModelChip(1, _isEnglish ? "2. 🌲 Tree Graph Canvas" : "২. 🌲 ট্রি গ্রাফ ক্যানভাস"),
                  _buildAnimationModelChip(2, _isEnglish ? "3. 🍃 Leaf Node Checker" : "৩. 🍃 লিফ নোড চেকার"),
                ],
              ),
            ),
            const SizedBox(height: 20),

            if (_animationModelIndex == 0) _buildStepFlowcardModel(),
            if (_animationModelIndex == 1) _buildTreeGraphModel(),
            if (_animationModelIndex == 2) _buildLeafCheckerModel(),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimationModelChip(int index, String label) {
    final isSelected = _animationModelIndex == index;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        selectedColor: AppTheme.accentPurple,
        backgroundColor: AppTheme.surfaceDark,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : AppTheme.textSecondary,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 12,
        ),
        onSelected: (selected) {
          if (selected) setState(() => _animationModelIndex = index);
        },
      ),
    );
  }

  // MODEL 1: Step-by-Step Backtracking Flowcard Engine
  Widget _buildStepFlowcardModel() {
    final stepFlowData = [
      {
        "step": 1,
        "node": "1",
        "path": "1",
        "badge": "VISIT ROOT '1'",
        "badgeColor": AppTheme.accentNeonCyan,
        "titleEn": "Step 1: Start DFS at Root Node '1'",
        "titleBn": "ধাপ ১: রুট নোড '1' এ DFS শুরু",
        "descEn": "Path initialized to \"1\". Next: Recurse to left child 2.",
        "descBn": "Path শুরু হলো \"1\" দিয়ে। পরবর্তী: বাম চাইল্ড 2 এ রিকার্সন।",
      },
      {
        "step": 2,
        "node": "2",
        "path": "1->2",
        "badge": "VISIT LEFT '2'",
        "badgeColor": AppTheme.accentAmber,
        "titleEn": "Step 2: Recurse Left to Node '2'",
        "titleBn": "ধাপ ২: বাম পাশের নোড '2' এ রিকার্সন",
        "descEn": "Appended \"->2\". Path becomes \"1->2\". Next: Recurse right child 5.",
        "descBn": "\"->2\" যুক্ত হয়ে Path হলো \"1->2\"। পরবর্তী: ডান চাইল্ড 5 এ প্রবেশ।",
      },
      {
        "step": 3,
        "node": "5",
        "path": "1->2->5",
        "badge": "🎉 SAVED \"1->2->5\"",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 3: Recurse Right to Leaf Node '5' ➔ Path Saved!",
        "titleBn": "ধাপ ৩: লিফ নোড '5' এ প্রবেশ ➔ পাথ সংরক্ষিত!",
        "descEn": "Appended \"->5\". Path = \"1->2->5\". Node 5 is a leaf. Saved \"1->2->5\"!",
        "descBn": "\"->5\" যুক্ত হয়ে Path = \"1->2->5\"। নোড 5 একটি লিফ। \"1->2->5\" সংরক্ষিত!",
      },
      {
        "step": 4,
        "node": "1",
        "path": "1",
        "badge": "↩️ BACKTRACK '1'",
        "badgeColor": AppTheme.accentAmber,
        "titleEn": "Step 4: Backtrack to Root Node '1'",
        "titleBn": "ধাপ ৪: ব্যাকট্র্যাক করে রুট নোড '1' এ ফেরত",
        "descEn": "Completed left subtree of 1. Now evaluate right child 3.",
        "descBn": "নোড 1 এর বাম সাবট্রি সম্পন্ন। এখন ডান চাইল্ড 3 পরীক্ষা করো।",
      },
      {
        "step": 5,
        "node": "3",
        "path": "1->3",
        "badge": "🎉 SAVED \"1->3\"",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 5: Recurse Right to Leaf Node '3' ➔ Path Saved!",
        "titleBn": "ধাপ ৫: লিফ নোড '3' এ প্রবেশ ➔ পাথ সংরক্ষিত!",
        "descEn": "Appended \"->3\". Path = \"1->3\". Node 3 is a leaf. Saved \"1->3\"!",
        "descBn": "\"->3\" যুক্ত হয়ে Path = \"1->3\"। নোড 3 একটি লিফ। \"1->3\" সংরক্ষিত!",
      },
      {
        "step": 6,
        "node": "FINISHED",
        "path": "",
        "badge": "🏆 FINISHED",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 6: DFS Traversal Complete!",
        "titleBn": "ধাপ ৬: DFS ট্রাভার্সাল সম্পূর্ণ!",
        "descEn": "Found total 2 root-to-leaf paths: [\"1->2->5\", \"1->3\"].",
        "descBn": "মোট ২টি root-to-leaf পাথ অর্জিত: [\"1->2->5\", \"1->3\"]।",
      },
    ];

    final currentStep = stepFlowData[_flowStepIndex.clamp(0, stepFlowData.length - 1)];
    final String activeNode = currentStep["node"] as String;
    final String currentPath = currentStep["path"] as String;
    final String badgeText = currentStep["badge"] as String;
    final Color badgeColor = currentStep["badgeColor"] as Color;
    final String stepTitle = _isEnglish ? (currentStep["titleEn"] as String) : (currentStep["titleBn"] as String);
    final String stepDesc = _isEnglish ? (currentStep["descEn"] as String) : (currentStep["descBn"] as String);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF090D16),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _isEnglish ? "1. Step-by-Step Tree Paths Flowcard" : "১. স্টেপ-বাই-স্টেপ ট্রি পাথ ফ্লো-কার্ড",
                style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
              ),
              Text(
                "Step ${_flowStepIndex + 1} / ${stepFlowData.length}",
                style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            _isEnglish
                ? "Watch how DFS explores root-to-leaf paths step-by-step."
                : "DFS কীভাবে ধাপে ধাপে রুট থেকে লিফ পাথ অন্বেষণ করে তা দেখুন।",
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 16),

          // Active Step Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: badgeColor, width: 2),
              boxShadow: [BoxShadow(color: badgeColor.withOpacity(0.2), blurRadius: 10)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(stepTitle, style: TextStyle(color: badgeColor, fontWeight: FontWeight.bold, fontSize: 14)),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: badgeColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: badgeColor),
                      ),
                      child: Text(badgeText, style: TextStyle(color: badgeColor, fontWeight: FontWeight.bold, fontSize: 11)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Active Node & Path String Box
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Active Node: '$activeNode'", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
                    Text("Path String:", style: const TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 6),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF090D16),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: badgeColor.withOpacity(0.5)),
                  ),
                  child: Text(
                    "\"$currentPath\"",
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: badgeColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 12),

                Text(stepDesc, style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.4)),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Stepper Control Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF1E293B)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.skip_previous, color: Colors.white, size: 20),
                      onPressed: _flowStepIndex > 0 ? () => setState(() => _flowStepIndex--) : null,
                    ),
                    IconButton(
                      icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, color: AppTheme.accentNeonCyan, size: 22),
                      onPressed: () {
                        setState(() => _isPlaying = !_isPlaying);
                        if (_isPlaying) {
                          _timer = Timer.periodic(const Duration(milliseconds: 1400), (t) {
                            if (_flowStepIndex < stepFlowData.length - 1) {
                              setState(() => _flowStepIndex++);
                            } else {
                              t.cancel();
                              setState(() => _isPlaying = false);
                            }
                          });
                        } else {
                          _timer?.cancel();
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.skip_next, color: Colors.white, size: 20),
                      onPressed: _flowStepIndex < stepFlowData.length - 1 ? () => setState(() => _flowStepIndex++) : null,
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh, color: AppTheme.accentNeonCyan, size: 20),
                      onPressed: () {
                        _timer?.cancel();
                        setState(() {
                          _isPlaying = false;
                          _flowStepIndex = 0;
                        });
                      },
                    ),
                  ],
                ),
                Text(
                  "Step ${_flowStepIndex + 1} / ${stepFlowData.length}",
                  style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // MODEL 2: Visual Binary Tree Graph Canvas
  Widget _buildTreeGraphModel() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF090D16),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _isEnglish ? "2. Visual Binary Tree Graph Canvas" : "২. ভিজ্যুয়াল বাইনারি ট্রি গ্রাফ ক্যানভাস",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            _isEnglish
                ? "Top-to-bottom binary tree structure showing parent and leaf child connections."
                : "প্যারেন্ট এবং চাইল্ড সংযোগ প্রদর্শনকারী উপর-থেকে-নিচে বাইনারি ট্রি।",
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 16),

          // Tree Canvas Graphic
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.accentPurple),
            ),
            child: Column(
              children: [
                _buildTreeNodeCard("1", "Root Node", AppTheme.accentNeonCyan),
                const SizedBox(height: 4),
                const Text("│", style: TextStyle(color: AppTheme.textMuted, fontSize: 14)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        _buildTreeNodeCard("2", "Internal Node", AppTheme.accentAmber),
                        const SizedBox(height: 4),
                        const Text("│", style: TextStyle(color: AppTheme.textMuted, fontSize: 14)),
                        _buildTreeNodeCard("5", "Leaf Node 🍃", AppTheme.accentGreen),
                      ],
                    ),
                    const SizedBox(width: 40),
                    Column(
                      children: [
                        _buildTreeNodeCard("3", "Leaf Node 🍃", AppTheme.accentGreen),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTreeNodeCard(String val, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color, width: 2),
      ),
      child: Column(
        children: [
          Text(val, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16)),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 10)),
        ],
      ),
    );
  }

  // MODEL 3: Leaf Node Checker Rule
  Widget _buildLeafCheckerModel() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF090D16),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _isEnglish ? "3. Leaf Node Checker Condition" : "৩. লিফ নোড চেকিং কন্ডিশন",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            _isEnglish
                ? "A node is a leaf when left == nullptr && right == nullptr. This triggers saving the full path string!"
                : "left == nullptr && right == nullptr হলে একটি নোডকে লিফ বলা হয়। এটি সম্পূর্ণ পাথ সংরক্ষণ ট্রিগার করে!",
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.accentGreen),
            ),
            child: const Text(
              "if (!node->left && !node->right) res.push_back(path); 🎉",
              style: TextStyle(fontFamily: 'monospace', fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.accentGreen),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  // TAB 3: Dynamic Visualizer
  Widget _buildVisualizerTab() {
    final step = _steps.isNotEmpty ? _steps[_currentStepIndex.clamp(0, _steps.length - 1)] : null;
    final isMobile = Responsive.isMobile(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(Responsive.horizontalPadding(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Preset Selector Bar
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF1E293B)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Select Binary Tree Preset:", style: TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildPresetChip(0, "Tree 1: [1, 2, 3, null, 5]"),
                      _buildPresetChip(1, "Tree 2: [10, 5, 15, 2]"),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          if (step != null) ...[
            // Status Log Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.accentPurple.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.accentPurple),
              ),
              child: Text(
                _isEnglish ? step.actionEn : step.actionBn,
                style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
            const SizedBox(height: 16),

            // Code Snippet + Canvas Layout
            if (isMobile)
              Column(
                children: [
                  _buildCodeHighlightBox(step.activeLine),
                  const SizedBox(height: 16),
                  _buildTreePathsCanvas(step),
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildCodeHighlightBox(step.activeLine)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTreePathsCanvas(step)),
                ],
              ),

            const SizedBox(height: 20),

            // Control Bar
            _buildControlBar(),
          ],
        ],
      ),
    );
  }

  // TAB 4: Practice & Answer
  Widget _buildPracticeTab() {
    final hPadding = Responsive.horizontalPadding(context);
    List<String> targetPaths = _presetIndex == 0 ? ["1->2->5", "1->3"] : ["10->5->2", "10->15"];

    return ResponsiveCenter(
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isEnglish ? "Interactive Practice Mode" : "ইন্টারেক্টিভ প্র্যাকটিস মোড",
              style: TextStyle(fontSize: Responsive.sp(context, 18), fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 6),
            Text(
              _isEnglish
                  ? "Build all ${targetPaths.length} root-to-leaf paths by tapping tree nodes!"
                  : "ট্রি নোডগুলোতে স্পর্শ করে সবকটি ${targetPaths.length} টি root-to-leaf পাথ বের করুন!",
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 16),

            // Progress Score Bar
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.accentNeonCyan.withOpacity(0.4)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _isEnglish ? "Discovered: ${_practiceResults.length} / ${targetPaths.length} Paths" : "সংগৃহীত: ${_practiceResults.length} / ${targetPaths.length} টি পাথ",
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      Text(
                        "${((_practiceResults.length / targetPaths.length) * 100).clamp(0, 100).toInt()}%",
                        style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: targetPaths.isEmpty ? 0.0 : (_practiceResults.length / targetPaths.length).clamp(0.0, 1.0),
                      backgroundColor: AppTheme.primaryDark,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.accentGreen),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Feedback Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _practiceSolved ? AppTheme.accentGreen.withOpacity(0.2) : AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _practiceSolved ? AppTheme.accentGreen : AppTheme.accentNeonCyan),
              ),
              child: Text(
                _isEnglish ? _userFeedbackEn : _userFeedbackBn,
                style: TextStyle(
                  color: _practiceSolved ? AppTheme.accentGreen : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Current Practice Path Box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF090D16),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.accentPurple),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Active Traced Path:", style: TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 12)),
                      Text("Nodes Count = ${_practiceCurrentPath.length}", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _practiceCurrentPath.isEmpty ? "[ EMPTY PATH ]" : "\"${_practiceCurrentPath.join('->')}\"",
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _practiceCurrentPath.isEmpty ? AppTheme.textMuted : AppTheme.accentNeonCyan,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Node Tap Choice Buttons
            if (!_practiceSolved) ...[
              Text(
                _isEnglish ? "Tap next tree node to extend path:" : "পাথ বাড়াতে পরবর্তী ট্রি নোডে চাপ দিন:",
                style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: (_presetIndex == 0 ? ["1", "2", "3", "5"] : ["10", "5", "15", "2"]).map((nodeVal) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accentPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    ),
                    onPressed: () => _handlePracticeNodeTap(nodeVal),
                    child: Text("Node '$nodeVal'", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              if (_practiceHistory.isNotEmpty)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    icon: const Icon(Icons.undo, size: 16, color: AppTheme.accentAmber),
                    label: Text(_isEnglish ? "Undo Move" : "ধাপ বাতিল", style: const TextStyle(color: AppTheme.accentAmber, fontSize: 12)),
                    onPressed: _undoPracticeMove,
                  ),
                ),
            ],

            const SizedBox(height: 20),

            // Discovered Paths List
            Text(
              _isEnglish
                  ? "Collected Paths (${_practiceResults.length} / ${targetPaths.length}):"
                  : "সংগৃহীত পাথসমূহ (${_practiceResults.length} / ${targetPaths.length}):",
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF090D16),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF1E293B)),
              ),
              child: _practiceResults.isEmpty
                ? const Text("[ No Paths Collected Yet ]", style: TextStyle(color: AppTheme.textMuted, fontSize: 12))
                : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _practiceResults.map((p) {
                      return Chip(
                        backgroundColor: AppTheme.surfaceDark,
                        avatar: const Icon(Icons.check_circle, color: AppTheme.accentGreen, size: 16),
                        label: Text(
                          "\"$p\"",
                          style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      );
                    }).toList(),
                  ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // Helper Widgets
  Widget _buildPresetChip(int index, String label) {
    final isSelected = _presetIndex == index;
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        selectedColor: AppTheme.accentPurple,
        backgroundColor: const Color(0xFF090D16),
        labelStyle: TextStyle(color: isSelected ? Colors.white : AppTheme.accentNeonCyan, fontSize: 11),
        onSelected: (selected) {
          if (selected) {
            setState(() {
              _presetIndex = index;
              _rebuildSteps();
            });
          }
        },
      ),
    );
  }

  Widget _buildCodeHighlightBox(int activeLine) {
    final codeLines = [
      "void dfs(TreeNode* root, string path, vector<string>& res) {",
      "    if (!root) return;",
      "    path += to_string(root->val);",
      "    if (!root->left && !root->right) {",
      "        res.push_back(path); // Save leaf path",
      "        return;",
      "    }",
      "    if (root->left) dfs(root->left, path + \"->\", res);",
      "    if (root->right) dfs(root->right, path + \"->\", res);",
      "}",
    ];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF090D16),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(codeLines.length, (idx) {
          final lineNum = idx + 1;
          final isHighlighted = lineNum == activeLine;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            margin: const EdgeInsets.symmetric(vertical: 1),
            decoration: BoxDecoration(
              color: isHighlighted ? AppTheme.accentPurple.withOpacity(0.25) : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: isHighlighted ? Border.all(color: AppTheme.accentPurple) : null,
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 24,
                  child: Text(
                    "$lineNum",
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                      color: isHighlighted ? AppTheme.accentNeonCyan : const Color(0xFF64748B),
                      fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
                if (isHighlighted)
                  const Padding(
                    padding: EdgeInsets.only(right: 6),
                    child: Icon(Icons.arrow_right_alt, color: AppTheme.accentNeonCyan, size: 14),
                  )
                else
                  const SizedBox(width: 20),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      codeLines[idx],
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        color: isHighlighted ? Colors.white : const Color(0xFF38BDF8),
                        fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTreePathsCanvas(BinaryTreePathsStep step) {
    Color decisionColor = AppTheme.accentPurple;
    String decisionLabel = "INIT";

    if (step.decision == "visit_node") {
      decisionColor = AppTheme.accentAmber;
      decisionLabel = "▶ VISIT NODE '${step.activeNodeVal}'";
    } else if (step.decision == "leaf_reached") {
      decisionColor = AppTheme.accentGreen;
      decisionLabel = "🍃 LEAF REACHED";
    } else if (step.decision == "backtrack") {
      decisionColor = AppTheme.accentAmber;
      decisionLabel = "↩️ BACKTRACK";
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF090D16),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Active Node: '${step.activeNodeVal}'", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: decisionColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: decisionColor),
                ),
                child: Text(decisionLabel, style: TextStyle(color: decisionColor, fontWeight: FontWeight.bold, fontSize: 11)),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Current Path String Box
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Accumulated Path String:", style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
              Text("Depth: ${step.callStackDepth}", style: const TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: decisionColor.withOpacity(0.5)),
            ),
            child: Text(
              "\"${step.currentPathString}\"",
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: decisionColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),

          // Saved Paths List
          const Text("Saved Root-to-Leaf Paths:", style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 80, maxHeight: 180),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF1E293B)),
            ),
            child: step.allPaths.isEmpty
                ? const Center(child: Text("[ No Paths Saved Yet ]", style: TextStyle(color: AppTheme.textMuted, fontSize: 12)))
                : SingleChildScrollView(
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: step.allPaths.map((p) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppTheme.accentGreen.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppTheme.accentGreen),
                          ),
                          child: Text(
                            "\"$p\"",
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.primaryDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.textMuted.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.skip_previous, color: Colors.white),
                onPressed: _currentStepIndex > 0 ? () => setState(() => _currentStepIndex--) : null,
              ),
              IconButton(
                icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, color: AppTheme.accentNeonCyan),
                onPressed: _togglePlay,
              ),
              IconButton(
                icon: const Icon(Icons.skip_next, color: Colors.white),
                onPressed: _currentStepIndex < _steps.length - 1 ? () => setState(() => _currentStepIndex++) : null,
              ),
              IconButton(
                icon: const Icon(Icons.refresh, color: AppTheme.accentNeonCyan),
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
            _isEnglish
                ? "Step ${_currentStepIndex + 1} of ${_steps.length}"
                : "ধাপ ${_currentStepIndex + 1} / ${_steps.length}",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildExampleCard(String label, String input, String output) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(height: 2),
          Text("Input: $input", style: const TextStyle(color: Colors.white, fontSize: 13)),
          Text(output, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildCodeSnippetBox(String lang) {
    String code = "";
    if (lang == "C++") {
      code = """
class Solution {
public:
    void dfs(TreeNode* root, string path, vector<string>& res) {
        if (!root) return;
        path += to_string(root->val);
        if (!root->left && !root->right) {
            res.push_back(path);
            return;
        }
        if (root->left) dfs(root->left, path + "->", res);
        if (root->right) dfs(root->right, path + "->", res);
    }

    vector<string> binaryTreePaths(TreeNode* root) {
        vector<string> res;
        dfs(root, "", res);
        return res;
    }
};""";
    } else if (lang == "Java") {
      code = """
class Solution {
    public List<String> binaryTreePaths(TreeNode root) {
        List<String> res = new ArrayList<>();
        if (root != null) dfs(root, "", res);
        return res;
    }

    private void dfs(TreeNode root, String path, List<String> res) {
        path += root.val;
        if (root.left == null && root.right == null) {
            res.add(path);
            return;
        }
        if (root.left != null) dfs(root.left, path + "->", res);
        if (root.right != null) dfs(root.right, path + "->", res);
    }
}""";
    } else {
      code = """
class Solution:
    def binaryTreePaths(self, root: Optional[TreeNode]) -> List[str]:
        res = []

        def dfs(node, path):
            if not node:
                return
            path += str(node.val)
            if not node.left and not node.right:
                res.append(path)
                return
            if node.left:
                dfs(node.left, path + "->")
            if node.right:
                dfs(node.right, path + "->")

        dfs(root, "")
        return res""";
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF090D16),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("$lang Solution", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13)),
              IconButton(
                icon: const Icon(Icons.copy, color: AppTheme.accentNeonCyan, size: 18),
                onPressed: () => _copyToClipboard(code, lang),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(code, style: const TextStyle(fontFamily: 'monospace', fontSize: 12, color: Color(0xFF38BDF8), height: 1.4)),
          ),
        ],
      ),
    );
  }
}
