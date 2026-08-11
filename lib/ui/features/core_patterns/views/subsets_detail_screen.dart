import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class SubsetsStep {
  final int index;
  final List<int> currentSubset;
  final List<List<int>> allSubsets;
  final String decision; // 'init', 'include', 'exclude', 'base_case'
  final int activeLine;
  final String actionEn;
  final String actionBn;
  final String reasonEn;
  final String reasonBn;
  final int callStackDepth;

  const SubsetsStep({
    required this.index,
    required this.currentSubset,
    required this.allSubsets,
    required this.decision,
    required this.activeLine,
    required this.actionEn,
    required this.actionBn,
    required this.reasonEn,
    required this.reasonBn,
    required this.callStackDepth,
  });
}

class SubsetsDetailScreen extends StatefulWidget {
  const SubsetsDetailScreen({super.key});

  @override
  State<SubsetsDetailScreen> createState() => _SubsetsDetailScreenState();
}

class _SubsetsDetailScreenState extends State<SubsetsDetailScreen>
    with SingleTickerProviderStateMixin {
  bool _isEnglish = true;
  late TabController _tabController;

  // Custom Input State
  final TextEditingController _numbersController =
      TextEditingController(text: "1, 2, 3");

  List<int> _currentArray = [1, 2, 3];
  List<SubsetsStep> _steps = [];

  // Playback Control
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  // Code Language Selector
  String _selectedCodeLang = "C++";

  // Tab 2 Animation Model Selector (0: Hasse Diagram, 1: Binary Tree, 2: Bitmask Slider)
  int _animationModelIndex = 0;

  // Hasse Diagram State
  String? _selectedHasseNode;
  Set<String> _highlightedHasseSubsets = {};

  // Binary Decision Tree State
  int _selectedTreeLevel = -1; // -1 for All Levels
  String? _selectedTreeLeafPath;

  // Bitmask Slider State (0 to 7)
  double _bitmaskSliderVal = 5.0;

  // Practice Mode state
  int _practiceIndex = 0;
  List<int> _practicePath = [];
  List<List<int>> _practiceResults = [];
  List<String> _practiceHistory = [];
  String _userFeedbackEn = "Choose whether to INCLUDE or EXCLUDE current element!";
  String _userFeedbackBn = "বর্তমান উপাদানটি সাবসেটে রাখবেন নাকি বাদ দেবেন সিদ্ধান্ত নিন!";
  bool _practiceSolved = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _rebuildSteps();
    _selectHasseNode("{a, b}");
  }

  @override
  void dispose() {
    _tabController.dispose();
    _timer?.cancel();
    _numbersController.dispose();
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

    // Parse array
    try {
      List<int> parsed = _numbersController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .map((e) => int.parse(e))
          .toList();
      if (parsed.isEmpty) parsed = [1, 2, 3];
      if (parsed.length > 4) parsed = parsed.sublist(0, 4); // Limit for clean visualization
      _currentArray = parsed;
    } catch (_) {
      _currentArray = [1, 2, 3];
    }

    _steps = _generateSteps(_currentArray);

    // Reset practice mode
    _practiceIndex = 0;
    _practicePath = [];
    _practiceResults = [];
    _practiceHistory = [];
    _practiceSolved = false;
    _userFeedbackEn = "Choose whether to INCLUDE or EXCLUDE current element!";
    _userFeedbackBn = "বর্তমান উপাদানটি সাবসেটে রাখবেন নাকি বাদ দেবেন সিদ্ধান্ত নিন!";
  }

  List<SubsetsStep> _generateSteps(List<int> nums) {
    List<SubsetsStep> steps = [];
    List<int> path = [];
    List<List<int>> results = [];

    // Step 0: Init
    steps.add(SubsetsStep(
      index: 0,
      currentSubset: [],
      allSubsets: [],
      decision: "init",
      activeLine: 1,
      actionEn: "Line 1: Initialize recursive search for all 2ⁿ subsets of [${nums.join(', ')}].",
      actionBn: "লাইন ১: [${nums.join(', ')}] এর সব ২ⁿ টি সাবসেট অনুসন্ধানের রিকার্সন শুরু।",
      reasonEn: "Each element has 2 choices: Include or Exclude.",
      reasonBn: "প্রতিটি উপাদানের জন্য ২টি চয়েস: রাখবেন অথবা বাদ দেবেন।",
      callStackDepth: 0,
    ));

    void backtrack(int idx, int depth) {
      if (idx == nums.length) {
        results.add(List.from(path));
        steps.add(SubsetsStep(
          index: idx,
          currentSubset: List.from(path),
          allSubsets: results.map((e) => List<int>.from(e)).toList(),
          decision: "base_case",
          activeLine: 3,
          actionEn: "Line 3: Base Case reached (idx = $idx)! Saved subset [${path.join(', ')}] to result.",
          actionBn: "লাইন ৩: বেস কেস অর্জিত (idx = $idx)! সাবসেট [${path.join(', ')}] সংরক্ষন করা হলো।",
          reasonEn: "Reached end of array. Add current path subset to final results list.",
          reasonBn: "অ্যারের শেষ প্রান্তে পৌঁছেছি। বর্তমান সাবসেটটি চূড়ান্ত তালিকায় যোগ করো।",
          callStackDepth: depth,
        ));
        return;
      }

      // Choice 1: INCLUDE nums[idx]
      path.add(nums[idx]);
      steps.add(SubsetsStep(
        index: idx,
        currentSubset: List.from(path),
        allSubsets: results.map((e) => List<int>.from(e)).toList(),
        decision: "include",
        activeLine: 7,
        actionEn: "Line 7: Decision INCLUDE -> Added nums[$idx] = ${nums[idx]} to subset. Path = [${path.join(', ')}].",
        actionBn: "লাইন ৭: চয়েস INCLUDE -> nums[$idx] = ${nums[idx]} সাবসেটে যোগ করা হলো। Path = [${path.join(', ')}]।",
        reasonEn: "Branch 1: Take element ${nums[idx]} and recurse deeper to idx ${idx + 1}.",
        reasonBn: "ব্রাঞ্চ ১: উপাদান ${nums[idx]} গ্রহণ করে রিকার্সন লেভেল ${idx + 1} এ অগ্রসর হও।",
        callStackDepth: depth + 1,
      ));

      backtrack(idx + 1, depth + 1);

      // Choice 2: EXCLUDE nums[idx] (Backtrack)
      path.removeLast();
      steps.add(SubsetsStep(
        index: idx,
        currentSubset: List.from(path),
        allSubsets: results.map((e) => List<int>.from(e)).toList(),
        decision: "exclude",
        activeLine: 11,
        actionEn: "Line 11: Decision EXCLUDE (Backtrack) -> Removed ${nums[idx]}. Path = [${path.join(', ')}].",
        actionBn: "লাইন ১১: চয়েস EXCLUDE (ব্যাকট্র্যাক) -> ${nums[idx]} রিমুভ করা হলো। Path = [${path.join(', ')}]।",
        reasonEn: "Branch 2: Backtrack and explore option without element ${nums[idx]}.",
        reasonBn: "ব্রাঞ্চ ২: ব্যাকট্র্যাক করে ${nums[idx]} উপাদানটি ছাড়া বিকল্প পথ অনুসন্ধান করো।",
        callStackDepth: depth,
      ));

      backtrack(idx + 1, depth + 1);
    }

    backtrack(0, 0);

    // Final Step
    steps.add(SubsetsStep(
      index: nums.length,
      currentSubset: [],
      allSubsets: results.map((e) => List<int>.from(e)).toList(),
      decision: "base_case",
      activeLine: 13,
      actionEn: "🎉 Line 13: Recursion Finished! Total ${results.length} subsets generated for 2^${nums.length} choices!",
      actionBn: "🎉 লাইন ১৩: রিকার্সন সম্পন্ন! ২^${nums.length} টি চয়েসের জন্য মোট ${results.length} টি সাবসেট তৈরি হয়েছে!",
      reasonEn: "All binary choice subtrees have been fully explored.",
      reasonBn: "সমস্ত বাইনারি চয়েস সাবট্রি অনুসন্ধান সম্পন্ন হয়েছে।",
      callStackDepth: 0,
    ));

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

  // Hasse Diagram Logic: Highlight all subset descendants of selected node
  void _selectHasseNode(String nodeLabel) {
    Set<String> subsets = {};

    // Parse elements in nodeLabel
    Set<String> selectedChars = {};
    if (nodeLabel.contains('a')) selectedChars.add('a');
    if (nodeLabel.contains('b')) selectedChars.add('b');
    if (nodeLabel.contains('c')) selectedChars.add('c');

    List<String> allHasseNodes = [
      "{a, b, c}",
      "{a, b}", "{a, c}", "{b, c}",
      "{a}", "{b}", "{c}",
      "∅"
    ];

    for (String node in allHasseNodes) {
      Set<String> nodeChars = {};
      if (node.contains('a')) nodeChars.add('a');
      if (node.contains('b')) nodeChars.add('b');
      if (node.contains('c')) nodeChars.add('c');

      // Check if nodeChars is a subset of selectedChars
      if (selectedChars.containsAll(nodeChars)) {
        subsets.add(node);
      }
    }

    setState(() {
      _selectedHasseNode = nodeLabel;
      _highlightedHasseSubsets = subsets;
    });
  }

  void _handlePracticeDecision(bool include) {
    if (_practiceSolved || _practiceIndex >= _currentArray.length) return;

    final currNum = _currentArray[_practiceIndex];

    setState(() {
      if (include) {
        _practicePath.add(currNum);
        _practiceHistory.add("INCLUDE ($currNum)");
        _userFeedbackEn = "✅ Included $currNum! Current Path = [${_practicePath.join(', ')}].";
        _userFeedbackBn = "✅ $currNum সাবসেটে যোগ করা হলো! বর্তমান Path = [${_practicePath.join(', ')}]।";
      } else {
        _practiceHistory.add("EXCLUDE ($currNum)");
        _userFeedbackEn = "⚡ Excluded $currNum! Current Path = [${_practicePath.join(', ')}].";
        _userFeedbackBn = "⚡ $currNum বাদ দেওয়া হলো! বর্তমান Path = [${_practicePath.join(', ')}]।";
      }

      _practiceIndex++;

      if (_practiceIndex == _currentArray.length) {
        List<int> newSubset = List.from(_practicePath);
        bool exists = _practiceResults.any((s) => s.length == newSubset.length && List.generate(s.length, (i) => s[i] == newSubset[i]).every((b) => b));
        
        if (!exists) {
          _practiceResults.add(newSubset);
          _userFeedbackEn = "🎉 New Subset [${newSubset.join(', ')}] Discovered! (${_practiceResults.length} / ${1 << _currentArray.length})";
          _userFeedbackBn = "🎉 নতুন সাবসেট [${newSubset.join(', ')}] সংরক্ষিত! (${_practiceResults.length} / ${1 << _currentArray.length})";
        } else {
          _userFeedbackEn = "ℹ️ Subset [${newSubset.join(', ')}] was already collected. Explore other branches!";
          _userFeedbackBn = "ℹ️ সাবসেট [${newSubset.join(', ')}] ইতিমধ্যেই সংগৃহীত হয়েছে। অন্য চয়েস ট্রাই করুন!";
        }

        // Reset for next branch
        _practiceIndex = 0;
        _practicePath = [];

        if (_practiceResults.length == (1 << _currentArray.length)) {
          _practiceSolved = true;
          _userFeedbackEn = "🏆 CONGRATULATIONS! You generated all ${1 << _currentArray.length} subsets of power set!";
          _userFeedbackBn = "🏆 দারুণ! আপনি পাওয়ার সেটের সবকটি ${1 << _currentArray.length} টি সাবসেট বানিয়ে ফেলেছেন!";
        }
      }
    });
  }

  void _undoPracticeMove() {
    if (_practiceIndex > 0) {
      setState(() {
        _practiceIndex--;
        if (_practiceHistory.isNotEmpty) {
          final lastAction = _practiceHistory.removeLast();
          if (lastAction.startsWith("INCLUDE") && _practicePath.isNotEmpty) {
            _practicePath.removeLast();
          }
        }
        _userFeedbackEn = "↩️ Undid last move. Back to index $_practiceIndex. Path = [${_practicePath.join(', ')}].";
        _userFeedbackBn = "↩️ পূর্ববর্তী ধাপ বাতিল করা হলো। ইনডেক্স $_practiceIndex এ ফিরে এসেছেন।";
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
          '78. Subsets (Power Set)',
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
                    "78. Subsets (Power Set)",
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
                  child: const Text("Medium", style: TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              children: ["Amazon", "Meta", "Google", "Microsoft", "Apple", "Uber"].map((company) {
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
                        ? "Given an integer array nums of unique elements, return all possible subsets (the power set). The solution set must not contain duplicate subsets. Return the solution in any order."
                        : "একটি ইউনিক পূর্ণসংখ্যার অ্যারে nums দেওয়া আছে। এর সমস্ত সম্ভাব্য সাবসেট (পাওয়ার সেট) তৈরি করে রিটার্ন করুন। কোনো ডুপ্লিকেট সাবসেট থাকা যাবে না।",
                    style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Examples
            Text(_isEnglish ? "Examples" : "উদাহরণসমূহ", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            _buildExampleCard("Example 1", "nums = [1,2,3]", "Output: [[],[1],[2],[1,2],[3],[1,3],[2,3],[1,2,3]]"),
            _buildExampleCard("Example 2", "nums = [0]", "Output: [[],[0]]"),
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
                        _isEnglish ? "Key Intuition (Take / Skip Choice Tree)" : "মূল আইডিয়া (Take / Skip চয়েস ট্রি)",
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isEnglish
                        ? "For every element nums[i], we have exactly 2 choices: INCLUDE it in the current subset, or EXCLUDE it. This forms a full binary recursion tree of depth N with 2ⁿ leaf nodes, yielding all 2ⁿ subsets!"
                        : "প্রতিটি উপাদান nums[i] এর জন্য আমাদের ঠিক ২টি চয়েস থাকে: সাবসেটে রাখা (INCLUDE) অথবা বাদ দেওয়া (EXCLUDE)। এটি গভীরতা N এর একটি সম্পূর্ণ বাইনারি রিকার্সন ট্রি তৈরি করে যেখানে ২ⁿ টি সাবসেট উৎপন্ন হয়!",
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

  // TAB 2: Code-Free Animation (3 Interactive Visual Models requested by User)
  Widget _buildCodeFreeAnimationTab() {
    final hPadding = Responsive.horizontalPadding(context);

    return ResponsiveCenter(
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isEnglish ? "Power Set Visual Models (Concept Explanations)" : "পাওয়ার সেট ভিজ্যুয়াল মডেলসমূহ (কোডহীন গাইড)",
              style: TextStyle(fontSize: Responsive.sp(context, 18), fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 6),
            Text(
              _isEnglish
                  ? "Explore 3 interactive models (Hasse Lattice, Decision Tree, Bitmask Slider) for set S = {a, b, c} (2³ = 8 Subsets)."
                  : "সেট S = {a, b, c} এর ২³ = ৮টি সাবসেট ৩টি ইন্টারঅ্যাক্টিভ মডেলে (হাসি ডায়াগ্রাম, ডিসিশন ট্রি, বিটমাস্ক স্লাইডার) পর্যবেক্ষণ করুন।",
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 16),

            // Model Switcher Segmented Control
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildAnimationModelChip(0, _isEnglish ? "1. 🕸️ Hasse Diagram (Lattice)" : "১. 🕸️ হাসি ডায়াগ্রাম (Lattice)"),
                  _buildAnimationModelChip(1, _isEnglish ? "2. 🌳 Binary Decision Tree" : "২. 🌳 বাইনারি ডিসিশন ট্রি"),
                  _buildAnimationModelChip(2, _isEnglish ? "3. 🎚️ Bitmasking Slider" : "৩. 🎚️ বিটমাস্কিং স্লাইডার"),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Render selected visual model
            if (_animationModelIndex == 0) _buildHasseDiagramModel(),
            if (_animationModelIndex == 1) _buildBinaryDecisionTreeModel(),
            if (_animationModelIndex == 2) _buildBitmaskSliderModel(),

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

  // MODEL 1: Hasse Diagram (Lattice Structure Pyramid)
  Widget _buildHasseDiagramModel() {
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
                _isEnglish ? "Hasse Diagram (Lattice Pyramid)" : "হাসি ডায়াগ্রাম (ল্যাটিস পিরামিড)",
                style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
              ),
              if (_selectedHasseNode != null)
                TextButton(
                  onPressed: () => setState(() {
                    _selectedHasseNode = null;
                    _highlightedHasseSubsets.clear();
                  }),
                  child: Text(_isEnglish ? "Reset Selection" : "রিসেট", style: const TextStyle(color: AppTheme.accentPink, fontSize: 12)),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            _isEnglish
                ? "Tap any node (e.g. {a, b}) to highlight all its valid subset descendants below!"
                : "যেকোনো নোডে (যেমন {a, b}) ট্যাপ করলে তার অধীনে থাকা সমস্ত সাবসেট হাইলাইট হয়ে যাবে!",
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 20),

          // Selected Node Status Banner
          if (_selectedHasseNode != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppTheme.accentGreen.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.accentGreen),
              ),
              child: Text(
                _isEnglish
                    ? "Tapped Node [$_selectedHasseNode] ➔ Valid Subsets below: ${_highlightedHasseSubsets.join(', ')}"
                    : "সিলেক্ট করা নোড [$_selectedHasseNode] ➔ এর অধীনস্থ সাবসেটসমূহ: ${_highlightedHasseSubsets.join(', ')}",
                style: const TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),

          // Level 3 (Top Level)
          Center(child: _buildHasseNodeCard("{a, b, c}", Level: 3)),
          const SizedBox(height: 12),
          const Center(child: Icon(Icons.keyboard_double_arrow_down, color: AppTheme.textMuted, size: 18)),
          const SizedBox(height: 12),

          // Level 2
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildHasseNodeCard("{a, b}", Level: 2),
              _buildHasseNodeCard("{a, c}", Level: 2),
              _buildHasseNodeCard("{b, c}", Level: 2),
            ],
          ),
          const SizedBox(height: 12),
          const Center(child: Icon(Icons.keyboard_double_arrow_down, color: AppTheme.textMuted, size: 18)),
          const SizedBox(height: 12),

          // Level 1
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildHasseNodeCard("{a}", Level: 1),
              _buildHasseNodeCard("{b}", Level: 1),
              _buildHasseNodeCard("{c}", Level: 1),
            ],
          ),
          const SizedBox(height: 12),
          const Center(child: Icon(Icons.keyboard_double_arrow_down, color: AppTheme.textMuted, size: 18)),
          const SizedBox(height: 12),

          // Level 0 (Bottom)
          Center(child: _buildHasseNodeCard("∅", Level: 0)),
        ],
      ),
    );
  }

  Widget _buildHasseNodeCard(String nodeLabel, {required int Level}) {
    final isSelected = _selectedHasseNode == nodeLabel;
    final isDescendant = _highlightedHasseSubsets.contains(nodeLabel);

    Color bgColor = AppTheme.surfaceDark;
    Color borderColor = const Color(0xFF1E293B);
    Color textColor = Colors.white;

    if (isSelected) {
      bgColor = AppTheme.accentNeonCyan.withOpacity(0.3);
      borderColor = AppTheme.accentNeonCyan;
      textColor = AppTheme.accentNeonCyan;
    } else if (isDescendant) {
      bgColor = AppTheme.accentGreen.withOpacity(0.2);
      borderColor = AppTheme.accentGreen;
      textColor = AppTheme.accentGreen;
    }

    return InkWell(
      onTap: () => _selectHasseNode(nodeLabel),
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderColor, width: (isSelected || isDescendant) ? 2 : 1),
          boxShadow: isSelected
              ? [BoxShadow(color: AppTheme.accentNeonCyan.withOpacity(0.4), blurRadius: 10)]
              : isDescendant
                  ? [BoxShadow(color: AppTheme.accentGreen.withOpacity(0.3), blurRadius: 8)]
                  : null,
        ),
        child: Text(
          nodeLabel,
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 13),
        ),
      ),
    );
  }

  // MODEL 2: Binary Decision Tree Model
  Widget _buildBinaryDecisionTreeModel() {
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
            _isEnglish ? "Binary Decision Tree (Recursion Path)" : "বাইনারি ডিসিশন ট্রি (রিকার্সন পথ)",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            _isEnglish
                ? "Every element has 2 branches: Include (Right) vs Exclude (Left). Tap any leaf node to trace its full path!"
                : "প্রতিটি উপাদানের জন্য ২টি পথ: Include (ডানদিকে) এবং Exclude (বামদিকে)। ট্যাপ করে পুরো রিকার্সন পাথ দেখুন!",
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 16),

          // Tree Level Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildTreeLevelChip(-1, _isEnglish ? "All Tree Levels" : "সব লেভেল"),
                _buildTreeLevelChip(0, "Level 0: Root []"),
                _buildTreeLevelChip(1, "Level 1: Choice 'a'"),
                _buildTreeLevelChip(2, "Level 2: Choice 'b'"),
                _buildTreeLevelChip(3, "Level 3: Choice 'c'"),
              ],
            ),
          ),
          const SizedBox(height: 16),

          if (_selectedTreeLevel == -1 || _selectedTreeLevel == 0)
            _buildVisualStepBox(
              "Level 0: Root Node (Empty Subset [])",
              "Start with path = []. Next element to evaluate: 'a'.",
              Icons.account_tree,
              AppTheme.accentNeonCyan,
            ),
          if (_selectedTreeLevel == -1 || _selectedTreeLevel == 0) const SizedBox(height: 10),

          if (_selectedTreeLevel == -1 || _selectedTreeLevel == 1)
            _buildVisualStepBox(
              "Level 1: Decision on Element 'a'",
              "• Include 'a' ➔ path = [a]\n• Exclude 'a' ➔ path = []",
              Icons.alt_route,
              AppTheme.accentAmber,
            ),
          if (_selectedTreeLevel == -1 || _selectedTreeLevel == 1) const SizedBox(height: 10),

          if (_selectedTreeLevel == -1 || _selectedTreeLevel == 2)
            _buildVisualStepBox(
              "Level 2: Decision on Element 'b'",
              "• From [a] ➔ Branch to [a, b] and [a]\n• From [] ➔ Branch to [b] and []",
              Icons.fork_right,
              AppTheme.accentPurple,
            ),
          if (_selectedTreeLevel == -1 || _selectedTreeLevel == 2) const SizedBox(height: 10),

          if (_selectedTreeLevel == -1 || _selectedTreeLevel == 3)
            _buildVisualStepBox(
              "Level 3: Decision on Element 'c' (8 Leaf Subsets)",
              "Leaf Nodes: [a,b,c], [a,b], [a,c], [a], [b,c], [b], [c], []",
              Icons.check_circle_outline,
              AppTheme.accentGreen,
            ),
        ],
      ),
    );
  }

  // MODEL 3: Binary Bitmasking Slider Model
  Widget _buildBitmaskSliderModel() {
    int val = _bitmaskSliderVal.round();
    String binary = val.toRadixString(2).padLeft(3, '0');

    bool hasA = (val & 4) != 0; // Bit 2 (100)
    bool hasB = (val & 2) != 0; // Bit 1 (010)
    bool hasC = (val & 1) != 0; // Bit 0 (001)

    List<String> activeElements = [];
    if (hasA) activeElements.add("a");
    if (hasB) activeElements.add("b");
    if (hasC) activeElements.add("c");

    String subsetText = activeElements.isEmpty ? "∅ (Empty set)" : "{${activeElements.join(', ')}}";

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
            _isEnglish ? "Binary Bitmasking Slider (000 to 111)" : "বাইনারি বিটমাস্কিং স্লাইডার (000 থেকে 111)",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            _isEnglish
                ? "Every subset corresponds to a 3-bit binary integer from 0 (000) to 7 (111). Drag the slider to watch bits toggle!"
                : "পাওয়ার সেটের প্রতিটি সাবসেট ০ (000) থেকে ৭ (111) পর্যন্ত বাইনারি সংখ্যার সমতুল্য। স্লাইডার টেনে বিট টগল দেখুন!",
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 16),

          // Interactive Bitmask Cards (a, b, c)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildBitBox("a", "Bit 2 (4's place)", hasA),
              _buildBitBox("b", "Bit 1 (2's place)", hasB),
              _buildBitBox("c", "Bit 0 (1's place)", hasC),
            ],
          ),
          const SizedBox(height: 20),

          // Live Output Status Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.accentGreen),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Decimal Value: [$val]", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                    Text("Binary Bitmask: [$binary₂]", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  "Active Subset: $subsetText",
                  style: const TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Slider
          Text(
            _isEnglish ? "Drag Slider (0 to 7):" : "স্লাইডার টানুন (০ থেকে ৭):",
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.bold),
          ),
          Slider(
            value: _bitmaskSliderVal,
            min: 0,
            max: 7,
            divisions: 7,
            activeColor: AppTheme.accentNeonCyan,
            inactiveColor: AppTheme.surfaceDark,
            label: "$val ($binary)",
            onChanged: (newVal) {
              setState(() => _bitmaskSliderVal = newVal);
            },
          ),
          const SizedBox(height: 10),

          // Preset Quick Buttons
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const Text("Presets: ", style: TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
                _buildBitmaskPresetChip("000 (∅)", 0),
                _buildBitmaskPresetChip("100 ({a})", 4),
                _buildBitmaskPresetChip("101 ({a, c})", 5),
                _buildBitmaskPresetChip("111 ({a, b, c})", 7),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBitBox(String char, String bitLabel, bool isOn) {
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: 60,
          height: 65,
          decoration: BoxDecoration(
            color: isOn ? AppTheme.accentGreen.withOpacity(0.25) : AppTheme.surfaceDark,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isOn ? AppTheme.accentGreen : const Color(0xFF1E293B), width: isOn ? 2 : 1),
            boxShadow: isOn ? [BoxShadow(color: AppTheme.accentGreen.withOpacity(0.4), blurRadius: 10)] : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                char,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isOn ? Colors.white : AppTheme.textMuted,
                ),
              ),
              const SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: isOn ? AppTheme.accentGreen : Colors.transparent,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  isOn ? "1 [ON]" : "0 [OFF]",
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: isOn ? AppTheme.primaryDark : AppTheme.textMuted,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(bitLabel, style: const TextStyle(color: AppTheme.textMuted, fontSize: 9)),
      ],
    );
  }

  Widget _buildBitmaskPresetChip(String label, double val) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ActionChip(
        backgroundColor: const Color(0xFF090D16),
        label: Text(label, style: const TextStyle(color: AppTheme.accentNeonCyan, fontSize: 11)),
        onPressed: () {
          setState(() => _bitmaskSliderVal = val);
        },
      ),
    );
  }

  // TAB 3: Dynamic Visualizer
  Widget _buildVisualizerTab() {
    final step = _steps[_currentStepIndex];
    final isMobile = Responsive.isMobile(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(Responsive.horizontalPadding(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Input Box & Presets
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
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _numbersController,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          labelText: _isEnglish ? "Input Array nums (e.g. 1, 2, 3)" : "ইনপুট অ্যারে nums (যেমন 1, 2, 3)",
                          labelStyle: const TextStyle(color: AppTheme.accentNeonCyan, fontSize: 12),
                          filled: true,
                          fillColor: const Color(0xFF090D16),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentNeonCyan,
                        foregroundColor: AppTheme.primaryDark,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                      onPressed: () => setState(() => _rebuildSteps()),
                      child: Text(_isEnglish ? "Run" : "রান"),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      const Text("Presets: ", style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                      _buildPresetChip("1, 2, 3"),
                      _buildPresetChip("1, 2"),
                      _buildPresetChip("4, 5, 6"),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

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
                _buildSubsetsCanvas(step),
              ],
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildCodeHighlightBox(step.activeLine)),
                const SizedBox(width: 16),
                Expanded(child: _buildSubsetsCanvas(step)),
              ],
            ),

          const SizedBox(height: 20),

          // Control Bar
          _buildControlBar(),
        ],
      ),
    );
  }

  // TAB 4: Practice & Answer
  Widget _buildPracticeTab() {
    final hPadding = Responsive.horizontalPadding(context);
    final currNum = _practiceIndex < _currentArray.length ? _currentArray[_practiceIndex] : null;
    final totalTargetCount = 1 << _currentArray.length;

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
                  ? "Build all 2ⁿ subsets yourself by deciding to INCLUDE or EXCLUDE each element!"
                  : "প্রতিটি উপাদান অন্তর্ভুক্ত করবেন নাকি বাদ দেবেন সিদ্ধান্ত নিয়ে নিজে পাওয়ার সেট তৈরি করুন!",
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
                        _isEnglish ? "Progress: ${_practiceResults.length} / $totalTargetCount Subsets" : "অগ্রগতি: ${_practiceResults.length} / $totalTargetCount টি সাবসেট",
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      Text(
                        "${((_practiceResults.length / totalTargetCount) * 100).toInt()}%",
                        style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: _practiceResults.length / totalTargetCount,
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

            // Decision Buttons & Undo
            if (!_practiceSolved && currNum != null) ...[
              Text(
                _isEnglish ? "Decision for nums[$_practiceIndex] = [$currNum]:" : "nums[$_practiceIndex] = [$currNum] এর জন্য সিদ্ধান্ত:",
                style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentGreen,
                        foregroundColor: AppTheme.primaryDark,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      icon: const Icon(Icons.add_circle_outline),
                      label: Text(_isEnglish ? "INCLUDE ($currNum)" : "যুক্ত করো ($currNum)"),
                      onPressed: () => _handlePracticeDecision(true),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentPink,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      icon: const Icon(Icons.remove_circle_outline),
                      label: Text(_isEnglish ? "EXCLUDE ($currNum)" : "বাদ দাও ($currNum)"),
                      onPressed: () => _handlePracticeDecision(false),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              if (_practiceIndex > 0)
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

            // Collected Subsets Grid
            Text(
              _isEnglish
                  ? "Collected Subsets (${_practiceResults.length} / $totalTargetCount):"
                  : "সংগৃহীত সাবসেটসমূহ (${_practiceResults.length} / $totalTargetCount):",
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
                ? const Text("[ No Subsets Collected Yet ]", style: TextStyle(color: AppTheme.textMuted, fontSize: 12))
                : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _practiceResults.map((subset) {
                      return Chip(
                        backgroundColor: AppTheme.surfaceDark,
                        avatar: const Icon(Icons.check_circle, color: AppTheme.accentGreen, size: 16),
                        label: Text(
                          "[${subset.join(', ')}]",
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
  Widget _buildPresetChip(String text) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ActionChip(
        backgroundColor: const Color(0xFF090D16),
        label: Text(text, style: const TextStyle(color: AppTheme.accentNeonCyan, fontSize: 11)),
        onPressed: () {
          _numbersController.text = text;
          _rebuildSteps();
        },
      ),
    );
  }

  Widget _buildCodeHighlightBox(int activeLine) {
    final codeLines = [
      "void backtrack(int idx, vector<int>& nums, vector<int>& path, vector<vector<int>>& res) {",
      "    if (idx == nums.size()) {",
      "        res.push_back(path); // Save subset",
      "        return;",
      "    }",
      "    // Choice 1: INCLUDE nums[idx]",
      "    path.push_back(nums[idx]);",
      "    backtrack(idx + 1, nums, path, res);",
      "    // Choice 2: EXCLUDE nums[idx] (Backtrack)",
      "    path.pop_back();",
      "    backtrack(idx + 1, nums, path, res);",
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

  Widget _buildSubsetsCanvas(SubsetsStep step) {
    Color decisionColor = AppTheme.accentPurple;
    String decisionLabel = "INIT";

    if (step.decision == "include") {
      decisionColor = AppTheme.accentGreen;
      decisionLabel = "➕ INCLUDE";
    } else if (step.decision == "exclude") {
      decisionColor = AppTheme.accentPink;
      decisionLabel = "↩️ EXCLUDE";
    } else if (step.decision == "base_case") {
      decisionColor = AppTheme.accentAmber;
      decisionLabel = "🎉 BASE CASE";
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
              Text("Index: [${step.index}]", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13)),
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

          // Current Subset Path
          const Text("Accumulated Subset Path (path):", style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.accentPurple.withOpacity(0.5)),
            ),
            child: Text(
              "[${step.currentSubset.join(', ')}]",
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.accentGreen,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Result Subsets List
          const Text("Saved Subsets List (result):", style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
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
            child: step.allSubsets.isEmpty
                ? const Center(child: Text("[ No Subsets Saved Yet ]", style: TextStyle(color: AppTheme.textMuted, fontSize: 12)))
                : SingleChildScrollView(
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: step.allSubsets.map((subset) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppTheme.accentPurple.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppTheme.accentPurple),
                          ),
                          child: Text(
                            "[${subset.join(', ')}]",
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

  Widget _buildVisualStepBox(String title, String desc, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.2),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text(desc, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, height: 1.4)),
              ],
            ),
          ),
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
    void backtrack(int idx, vector<int>& nums, vector<int>& path, vector<vector<int>>& res) {
        if (idx == nums.size()) {
            res.push_back(path);
            return;
        }
        // Choice 1: INCLUDE
        path.push_back(nums[idx]);
        backtrack(idx + 1, nums, path, res);
        
        // Choice 2: EXCLUDE
        path.pop_back();
        backtrack(idx + 1, nums, path, res);
    }
    
    vector<vector<int>> subsets(vector<int>& nums) {
        vector<vector<int>> res;
        vector<int> path;
        backtrack(0, nums, path, res);
        return res;
    }
};""";
    } else if (lang == "Java") {
      code = """
class Solution {
    public List<List<Integer>> subsets(int[] nums) {
        List<List<Integer>> res = new ArrayList<>();
        backtrack(0, nums, new ArrayList<>(), res);
        return res;
    }

    private void backtrack(int idx, int[] nums, List<Integer> path, List<List<Integer>> res) {
        if (idx == nums.length) {
            res.add(new ArrayList<>(path));
            return;
        }
        // Include
        path.add(nums[idx]);
        backtrack(idx + 1, nums, path, res);
        
        // Exclude
        path.remove(path.size() - 1);
        backtrack(idx + 1, nums, path, res);
    }
}""";
    } else {
      code = """
class Solution:
    def subsets(self, nums: List[int]) -> List[List[int]]:
        res = []
        path = []

        def backtrack(idx):
            if idx == len(nums):
                res.append(path.copy())
                return
            
            # Include
            path.append(nums[idx])
            backtrack(idx + 1)
            
            # Exclude
            path.pop()
            backtrack(idx + 1)

        backtrack(0)
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
