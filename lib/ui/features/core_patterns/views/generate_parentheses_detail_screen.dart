import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class GenerateParenthesesStep {
  final int openCount;
  final int closeCount;
  final String currentString;
  final List<String> allValidStrings;
  final String decision; // 'init', 'add_open', 'add_close', 'base_case', 'backtrack'
  final int activeLine;
  final String actionEn;
  final String actionBn;
  final String reasonEn;
  final String reasonBn;
  final int callStackDepth;

  const GenerateParenthesesStep({
    required this.openCount,
    required this.closeCount,
    required this.currentString,
    required this.allValidStrings,
    required this.decision,
    required this.activeLine,
    required this.actionEn,
    required this.actionBn,
    required this.reasonEn,
    required this.reasonBn,
    required this.callStackDepth,
  });
}

class GenerateParenthesesDetailScreen extends StatefulWidget {
  const GenerateParenthesesDetailScreen({super.key});

  @override
  State<GenerateParenthesesDetailScreen> createState() => _GenerateParenthesesDetailScreenState();
}

class _GenerateParenthesesDetailScreenState extends State<GenerateParenthesesDetailScreen>
    with SingleTickerProviderStateMixin {
  bool _isEnglish = true;
  late TabController _tabController;

  // Custom Input State
  final TextEditingController _nController = TextEditingController(text: "3");
  int _n = 3;
  List<GenerateParenthesesStep> _steps = [];

  // Playback Control
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  // Code Language Selector
  String _selectedCodeLang = "C++";

  // Tab 2 Animation Model Selector (0: Step-by-Step Flowcard, 1: Balance Scale, 2: Catalan Formula)
  int _animationModelIndex = 0;
  int _flowStepIndex = 0;

  // Practice Mode State
  int _practiceOpen = 0;
  int _practiceClose = 0;
  String _practiceString = "";
  List<String> _practiceResults = [];
  List<String> _practiceHistory = [];
  String _userFeedbackEn = "Choose whether to ADD '(' or ADD ')' to build valid parentheses!";
  String _userFeedbackBn = "সঠিক বন্ধনী তৈরি করতে '(' যোগ করবেন নাকি ')' যোগ করবেন সিদ্ধান্ত নিন!";
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
    _flowStepIndex = 0;

    // Parse n
    try {
      _n = int.parse(_nController.text.trim());
      if (_n <= 0) _n = 3;
      if (_n > 4) _n = 4; // Limit for clean step visualization
    } catch (_) {
      _n = 3;
    }

    _steps = _generateSteps(_n);

    // Reset practice mode
    _practiceOpen = 0;
    _practiceClose = 0;
    _practiceString = "";
    _practiceResults = [];
    _practiceHistory = [];
    _practiceSolved = false;
    _userFeedbackEn = "Choose whether to ADD '(' or ADD ')' to build valid parentheses!";
    _userFeedbackBn = "সঠিক বন্ধনী তৈরি করতে '(' যোগ করবেন নাকি ')' যোগ করবেন সিদ্ধান্ত নিন!";
  }

  List<GenerateParenthesesStep> _generateSteps(int n) {
    List<GenerateParenthesesStep> steps = [];
    List<String> results = [];
    StringBuffer current = StringBuffer();

    // Step 0: Init
    steps.add(GenerateParenthesesStep(
      openCount: 0,
      closeCount: 0,
      currentString: "",
      allValidStrings: [],
      decision: "init",
      activeLine: 1,
      actionEn: "Line 1: Initialize backtracking for n = $n pair parentheses.",
      actionBn: "লাইন ১: n = $n জোড়া বন্ধনীর জন্য ব্যাকট্র্যাক শুরু।",
      reasonEn: "We track open and close count to build well-formed parentheses.",
      reasonBn: "সঠিক বন্ধনী তৈরির জন্য open এবং close গণনা ট্র্যাক করা হয়।",
      callStackDepth: 0,
    ));

    void backtrack(int open, int close, int depth) {
      if (open == n && close == n) {
        results.add(current.toString());
        steps.add(GenerateParenthesesStep(
          openCount: open,
          closeCount: close,
          currentString: current.toString(),
          allValidStrings: List.from(results),
          decision: "base_case",
          activeLine: 3,
          actionEn: "🎉 Line 3: Base Case Reached! Valid string \"${current.toString()}\" saved.",
          actionBn: "🎉 লাইন ৩: বেস কেস অর্জিত! সঠিক বন্ধনী \"${current.toString()}\" সংরক্ষিত।",
          reasonEn: "open == n and close == n. Full well-formed string constructed.",
          reasonBn: "open == n এবং close == n। সম্পূর্ণ সঠিক বন্ধনী তৈরি সম্পন্ন।",
          callStackDepth: depth,
        ));
        return;
      }

      // Rule 1: Add Open '(' if open < n
      if (open < n) {
        current.write("(");
        steps.add(GenerateParenthesesStep(
          openCount: open + 1,
          closeCount: close,
          currentString: current.toString(),
          allValidStrings: List.from(results),
          decision: "add_open",
          activeLine: 7,
          actionEn: "Line 7: Decision ADD '(' -> openCount becomes ${open + 1}. String = \"${current.toString()}\".",
          actionBn: "লাইন ৭: চয়েস ADD '(' -> openCount হলো ${open + 1}। String = \"${current.toString()}\"।",
          reasonEn: "Rule 1: open < n ($open < $n). We can safely add an open parenthesis '('.",
          reasonBn: "নিয়ম ১: open < n ($open < $n)। নিশ্চিন্তে open বন্ধনী '(' যোগ করা যায়।",
          callStackDepth: depth + 1,
        ));

        backtrack(open + 1, close, depth + 1);

        // Backtrack
        String str = current.toString();
        current.clear();
        current.write(str.substring(0, str.length - 1));
      }

      // Rule 2: Add Close ')' if close < open
      if (close < open) {
        current.write(")");
        steps.add(GenerateParenthesesStep(
          openCount: open,
          closeCount: close + 1,
          currentString: current.toString(),
          allValidStrings: List.from(results),
          decision: "add_close",
          activeLine: 11,
          actionEn: "Line 11: Decision ADD ')' -> closeCount becomes ${close + 1}. String = \"${current.toString()}\".",
          actionBn: "লাইন ১১: চয়েস ADD ')' -> closeCount হলো ${close + 1}। String = \"${current.toString()}\"।",
          reasonEn: "Rule 2: close < open ($close < $open). We can add a close parenthesis ')' to balance.",
          reasonBn: "নিয়ম ২: close < open ($close < $open)। ভারসাম্য রক্ষায় close বন্ধনী ')' যোগ করা হয়।",
          callStackDepth: depth + 1,
        ));

        backtrack(open, close + 1, depth + 1);

        // Backtrack
        String str = current.toString();
        current.clear();
        current.write(str.substring(0, str.length - 1));
      }
    }

    backtrack(0, 0, 0);

    // Final Step
    steps.add(GenerateParenthesesStep(
      openCount: n,
      closeCount: n,
      currentString: "",
      allValidStrings: List.from(results),
      decision: "base_case",
      activeLine: 13,
      actionEn: "🎉 Line 13: Backtracking Complete! Generated total ${results.length} valid combinations!",
      actionBn: "🎉 লাইন ১৩: ব্যাকট্র্যাকিং সম্পূর্ণ! মোট ${results.length} টি সঠিক বন্ধনী জেনারেট সম্পন্ন!",
      reasonEn: "All binary choice trees explored.",
      reasonBn: "সমস্ত চয়েস ট্রি ট্রাভার্সাল সম্পন্ন হয়েছে।",
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

  // Calculate Catalan Number C_n = (2n)! / ((n+1)! * n!)
  int _getCatalanNumber(int n) {
    if (n <= 1) return 1;
    if (n == 2) return 2;
    if (n == 3) return 5;
    if (n == 4) return 14;
    return 42;
  }

  void _handlePracticeMove(String action) {
    if (_practiceSolved) return;

    final targetTotal = _getCatalanNumber(_n);

    setState(() {
      if (action == "open") {
        if (_practiceOpen < _n) {
          _practiceOpen++;
          _practiceString += "(";
          _practiceHistory.add("ADD '('");
          _userFeedbackEn = "✅ Added '('. String = \"$_practiceString\" (Open: $_practiceOpen, Close: $_practiceClose).";
          _userFeedbackBn = "✅ '(' যোগ করা হলো। String = \"$_practiceString\"।";
        } else {
          _userFeedbackEn = "⚠️ Cannot add '(': openCount already reached limit n = $_n!";
          _userFeedbackBn = "⚠️ '(' যোগ করা সম্ভব নয়: openCount সীমা n = $_n এ পৌঁছে গেছে!";
        }
      } else if (action == "close") {
        if (_practiceClose < _practiceOpen) {
          _practiceClose++;
          _practiceString += ")";
          _practiceHistory.add("ADD ')'");
          _userFeedbackEn = "✅ Added ')'. String = \"$_practiceString\" (Open: $_practiceOpen, Close: $_practiceClose).";
          _userFeedbackBn = "✅ ')' যোগ করা হলো। String = \"$_practiceString\"।";
        } else {
          _userFeedbackEn = "⚠️ Cannot add ')': closeCount ($_practiceClose) must be less than openCount ($_practiceOpen)!";
          _userFeedbackBn = "⚠️ ')' যোগ করা সম্ভব নয়: closeCount ($_practiceClose) অবশ্যই openCount ($_practiceOpen) এর চেয়ে কম হতে হবে!";
        }
      }

      // Check if complete valid string formed
      if (_practiceOpen == _n && _practiceClose == _n) {
        String validStr = _practiceString;
        if (!_practiceResults.contains(validStr)) {
          _practiceResults.add(validStr);
          _userFeedbackEn = "🎉 Perfect! Valid string \"$validStr\" saved! (${_practiceResults.length} / $targetTotal)";
          _userFeedbackBn = "🎉 দারুণ! সঠিক বন্ধনী \"$validStr\" সংরক্ষিত! (${_practiceResults.length} / $targetTotal)";
        } else {
          _userFeedbackEn = "ℹ️ String \"$validStr\" was already collected. Build other combinations!";
          _userFeedbackBn = "ℹ️ \"$validStr\" বন্ধনীটি ইতিমধ্যেই সংগৃহীত হয়েছে। অন্যটি চেষ্টা করুন!";
        }

        // Reset for next combination
        _practiceOpen = 0;
        _practiceClose = 0;
        _practiceString = "";

        if (_practiceResults.length >= targetTotal) {
          _practiceSolved = true;
          _userFeedbackEn = "🏆 MASTERED! You generated all $targetTotal valid parentheses combinations!";
          _userFeedbackBn = "🏆 দারুণ! আপনি সবকটি $targetTotal টি সঠিক বন্ধনী বানিয়ে ফেলেছেন!";
        }
      }
    });
  }

  void _undoPracticeMove() {
    if (_practiceHistory.isNotEmpty) {
      setState(() {
        final lastAction = _practiceHistory.removeLast();
        if (lastAction == "ADD '('" && _practiceOpen > 0 && _practiceString.isNotEmpty) {
          _practiceOpen--;
          _practiceString = _practiceString.substring(0, _practiceString.length - 1);
        } else if (lastAction == "ADD ')'" && _practiceClose > 0 && _practiceString.isNotEmpty) {
          _practiceClose--;
          _practiceString = _practiceString.substring(0, _practiceString.length - 1);
        }
        _userFeedbackEn = "↩️ Undid last move. String = \"$_practiceString\".";
        _userFeedbackBn = "↩️ পূর্ববর্তী ধাপ বাতিল করা হলো। String = \"$_practiceString\"।";
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
          '22. Generate Parentheses',
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
                    "22. Generate Parentheses",
                    style: TextStyle(fontSize: Responsive.sp(context, 22), fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.accentAmber.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.accentAmber),
                  ),
                  child: const Text("Medium", style: TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 12)),
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
                        ? "Given n pairs of parentheses, write a function to generate all combinations of well-formed parentheses."
                        : "n জোড়া বন্ধনী দেওয়া আছে। সঠিক ও সুগঠিত বন্ধনীর (well-formed parentheses) সমস্ত সম্ভাব্য কম্বিনেশন রিটার্ন করুন।",
                    style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Examples
            Text(_isEnglish ? "Examples" : "উদাহরণসমূহ", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            _buildExampleCard("Example 1", "n = 3", "Output: [\"((()))\",\"(()())\",\"(())()\",\"()(())\",\"()()()\"]"),
            _buildExampleCard("Example 2", "n = 1", "Output: [\"()\"]"),
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
                        _isEnglish ? "Key Intuition (Open vs Close Balance Rules)" : "মূল আইডিয়া (Open এবং Close এর ভারসাম্য নিয়ম)",
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isEnglish
                        ? "• Rule 1: Can add open '(' if open < n.\n• Rule 2: Can add close ')' if close < open.\n• Base Case: When open == n and close == n, save the well-formed string! This guarantees valid balanced output."
                        : "• নিয়ম ১: open < n হলে '(' যোগ করা যাবে।\n• নিয়ম ২: close < open হলে ')' যোগ করা যাবে।\n• বেস কেস: open == n এবং close == n হলে বন্ধনীটি সম্পূর্ণ হয়! এটি প্রতিটি স্ট্রিং সঠিক হওয়া নিশ্চিত করে।",
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
              _isEnglish ? "Generate Parentheses Visual Models (Concept Explanations)" : "জেনারেট প্যারেন্থেসিস ভিজ্যুয়াল মডেলসমূহ (কোডহীন গাইড)",
              style: TextStyle(fontSize: Responsive.sp(context, 18), fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 6),
            Text(
              _isEnglish
                  ? "Explore 3 interactive models for n = 3 pairs of parentheses."
                  : "n = 3 জোড়া বন্ধনীর জন্য ৩টি ইন্টারঅ্যাক্টিভ ভিজ্যুয়াল মডেল পর্যবেক্ষণ করুন।",
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 16),

            // Model Switcher Segmented Control
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildAnimationModelChip(0, _isEnglish ? "1. 🪜 Step Flowcard" : "১. 🪜 স্টেপ-বাই-স্টেপ ফ্লো-কার্ড"),
                  _buildAnimationModelChip(1, _isEnglish ? "2. ⚖️ Balance Scale" : "২. ⚖️ বন্ধনী সামঞ্জস্য স্কেল"),
                  _buildAnimationModelChip(2, _isEnglish ? "3. 🔢 Catalan Formula" : "৩. 🔢 ক্যাটালান সংখ্যা সূত্র"),
                ],
              ),
            ),
            const SizedBox(height: 20),

            if (_animationModelIndex == 0) _buildStepFlowcardModel(),
            if (_animationModelIndex == 1) _buildBalanceScaleModel(),
            if (_animationModelIndex == 2) _buildCatalanFormulaModel(),

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
        "str": "",
        "open": 0,
        "close": 0,
        "badge": "INIT",
        "badgeColor": AppTheme.accentNeonCyan,
        "titleEn": "Step 1: Start Empty String (open = 0, close = 0)",
        "titleBn": "ধাপ ১: ফাঁকা স্ট্রিং দিয়ে শুরু (open = 0, close = 0)",
        "descEn": "Target n = 3. String is empty \"\". Rule 1 applies (open < 3). Add '('.",
        "descBn": "টার্গেট n = 3। String ফাঁকা \"\"। নিয়ম ১ প্রযোজ্য (open < 3)। '(' যোগ করো।",
      },
      {
        "step": 2,
        "str": "(",
        "open": 1,
        "close": 0,
        "badge": "➕ ADD '('",
        "badgeColor": AppTheme.accentAmber,
        "titleEn": "Step 2: Added '(' ➔ String = \"(\"",
        "titleBn": "ধাপ ২: '(' যোগ ➔ String = \"(\"",
        "descEn": "open = 1, close = 0. Rule 1 applies (open < 3). Add second '('.",
        "descBn": "open = 1, close = 0। নিয়ম ১ প্রযোজ্য (open < 3)। দ্বিতীয় '(' যোগ করো।",
      },
      {
        "step": 3,
        "str": "((",
        "open": 2,
        "close": 0,
        "badge": "➕ ADD '('",
        "badgeColor": AppTheme.accentAmber,
        "titleEn": "Step 3: Added '(' ➔ String = \"((\"",
        "titleBn": "ধাপ ৩: '(' যোগ ➔ String = \"((\"",
        "descEn": "open = 2, close = 0. Rule 1 applies (open < 3). Add third '('.",
        "descBn": "open = 2, close = 0। নিয়ম ১ প্রযোজ্য (open < 3)। তৃতীয় '(' যোগ করো।",
      },
      {
        "step": 4,
        "str": "(((",
        "open": 3,
        "close": 0,
        "badge": "➕ ADD '('",
        "badgeColor": AppTheme.accentAmber,
        "titleEn": "Step 4: Added '(' ➔ String = \"(((\"",
        "titleBn": "ধাপ ৪: '(' যোগ ➔ String = \"(((\"",
        "descEn": "open = 3 (reached limit n). Rule 2 applies (close < open). Add ')'.",
        "descBn": "open = 3 (সীমা n ছুঁয়েছে)। নিয়ম ২ প্রযোজ্য (close < open)। ')' যোগ করো।",
      },
      {
        "step": 5,
        "str": "((()",
        "open": 3,
        "close": 1,
        "badge": "➕ ADD ')'",
        "badgeColor": AppTheme.accentPurple,
        "titleEn": "Step 5: Added ')' ➔ String = \"((()\"",
        "titleBn": "ধাপ ৫: ')' যোগ ➔ String = \"((()\"",
        "descEn": "open = 3, close = 1. Rule 2 applies (close < 3). Add second ')'.",
        "descBn": "open = 3, close = 1। নিয়ম ২ প্রযোজ্য (close < 3)। দ্বিতীয় ')' যোগ করো।",
      },
      {
        "step": 6,
        "str": "((())",
        "open": 3,
        "close": 2,
        "badge": "➕ ADD ')'",
        "badgeColor": AppTheme.accentPurple,
        "titleEn": "Step 6: Added ')' ➔ String = \"((())\"",
        "titleBn": "ধাপ ৬: ')' যোগ ➔ String = \"((())\"",
        "descEn": "open = 3, close = 2. Rule 2 applies (close < 3). Add final ')'.",
        "descBn": "open = 3, close = 2। নিয়ম ২ প্রযোজ্য (close < 3)। শেষ ')' যোগ করো।",
      },
      {
        "step": 7,
        "str": "((()))",
        "open": 3,
        "close": 3,
        "badge": "🎉 VALID MATCH",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 7: Added ')' ➔ String = \"((()))\"",
        "titleBn": "ধাপ ৭: ')' যোগ ➔ String = \"((()))\"",
        "descEn": "open == 3 and close == 3 🎉 Base Case Reached! Saved \"((()))\" to results!",
        "descBn": "open == 3 এবং close == 3 🎉 বেস কেস অর্জিত! \"((()))\" সংরক্ষিত!",
      },
      {
        "step": 8,
        "str": "(()",
        "open": 2,
        "close": 1,
        "badge": "↩️ BACKTRACK",
        "badgeColor": AppTheme.accentAmber,
        "titleEn": "Step 8: Backtrack to String = \"(()\"",
        "titleBn": "ধাপ ৮: ব্যাকট্র্যাক করে String = \"(()\" এ ফেরত",
        "descEn": "Backtracked to open = 2, close = 1. Explore alternative branch.",
        "descBn": "ব্যাকট্র্যাক করে open = 2, close = 1। বিকল্প ব্রাঞ্চ নির্বাচন করো।",
      },
      {
        "step": 9,
        "str": "(()())",
        "open": 3,
        "close": 3,
        "badge": "🎉 VALID MATCH",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 9: Found Second Combination \"(()())\"",
        "titleBn": "ধাপ ৯: দ্বিতীয় সটিক বন্ধনী \"(()())\" তৈরি",
        "descEn": "open = 3, close = 3 🎉 Saved second valid combination \"(()())\"!",
        "descBn": "open = 3, close = 3 🎉 দ্বিতীয় সঠিক বন্ধনী \"(()())\" সংরক্ষিত!",
      },
      {
        "step": 10,
        "str": "()()()",
        "open": 3,
        "close": 3,
        "badge": "🏆 FINISHED",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 10: Traversal Finished! Total 5 Combinations",
        "titleBn": "ধাপ ১০: ব্যাকট্র্যাকিং সম্পন্ন! মোট ৫টি সঠিক বন্ধনী",
        "descEn": "All 5 Catalan combinations generated for n = 3!",
        "descBn": "n = 3 এর জন্য মোট ৫টি ক্যাটালান বন্ধনী তৈরি সম্পন্ন!",
      },
    ];

    final currentStep = stepFlowData[_flowStepIndex.clamp(0, stepFlowData.length - 1)];
    final String currentStr = currentStep["str"] as String;
    final int openCount = currentStep["open"] as int;
    final int closeCount = currentStep["close"] as int;
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
                _isEnglish ? "1. Step-by-Step Parentheses Flowcard" : "১. স্টেপ-বাই-স্টেপ বন্ধনী ফ্লো-কার্ড",
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
                ? "Follow how open and close parentheses are balanced step-by-step."
                : "উন্মুক্ত ও ক্লোজ বন্ধনীর ভারসাম্য কীভাবে ধাপে ধাপে রক্ষিত হয় তা পর্যবেক্ষণ করুন।",
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

                // String & Counter Meters
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Open '(' = $openCount / 3", style: const TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 12)),
                    Text("Close ')' = $closeCount / 3", style: const TextStyle(color: AppTheme.accentPurple, fontWeight: FontWeight.bold, fontSize: 12)),
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
                    "\"$currentStr\"",
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

  // MODEL 2: Parentheses Balance Scale
  Widget _buildBalanceScaleModel() {
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
            _isEnglish ? "2. Parentheses Balance Scale Meter" : "২. বন্ধনী সামঞ্জস্য স্কেল মিটার",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            _isEnglish
                ? "Close ')' count must NEVER exceed Open '(' count at any step to ensure well-formed string!"
                : "সঠিক বন্ধনী হতে কোনো মুহূর্তেই Close ')' সংখ্যা Open '(' সংখ্যাকে অতিক্রম করতে পারবে না!",
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 16),

          // Scale Meter Box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.accentGreen),
            ),
            child: Column(
              children: [
                const Text("Balanced Pair: \"((()))\"", style: TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: const [
                        Text("Open '(': 3", style: TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 14)),
                        SizedBox(height: 4),
                        Icon(Icons.arrow_upward, color: AppTheme.accentAmber, size: 24),
                      ],
                    ),
                    const Icon(Icons.balance, color: AppTheme.accentGreen, size: 36),
                    Column(
                      children: const [
                        Text("Close ')': 3", style: TextStyle(color: AppTheme.accentPurple, fontWeight: FontWeight.bold, fontSize: 14)),
                        SizedBox(height: 4),
                        Icon(Icons.arrow_downward, color: AppTheme.accentPurple, size: 24),
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

  // MODEL 3: Catalan Number Formula Counter
  Widget _buildCatalanFormulaModel() {
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
            _isEnglish ? "3. Catalan Number Formula (C_n)" : "৩. ক্যাটালান সংখ্যা সূত্র (C_n)",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            _isEnglish
                ? "The number of valid parentheses combinations for n pairs is given by Catalan Number C_n = (2n)! / ((n+1)! * n!)."
                : "n জোড়া বন্ধনীর জন্য সঠিক কম্বিনেশনের সংখ্যা ক্যাটালান নম্বর C_n সূত্র দ্বারা নির্ধারিত হয়।",
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.accentPurple),
            ),
            child: const Text(
              "C₃ = (6!) / (4! × 3!) = 720 / (24 × 6) = 5 Combinations 🎉",
              style: TextStyle(fontFamily: 'monospace', fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.accentNeonCyan),
              textAlign: TextAlign.center,
            ),
          ),
        ],
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
                        controller: _nController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          labelText: _isEnglish ? "Number of Pairs n (1 to 4)" : "বন্ধনী জোড়া n (১ থেকে ৪)",
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
                      _buildPresetChip("1"),
                      _buildPresetChip("2"),
                      _buildPresetChip("3"),
                      _buildPresetChip("4"),
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
                _buildParenthesesCanvas(step),
              ],
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildCodeHighlightBox(step.activeLine)),
                const SizedBox(width: 16),
                Expanded(child: _buildParenthesesCanvas(step)),
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
    final targetTotal = _getCatalanNumber(_n);

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
                  ? "Build all $targetTotal valid parentheses strings for n = $_n by deciding to ADD '(' or ADD ')'!"
                  : "n = $_n এর জন্য '(' বা ')' যোগ করার সিদ্ধান্ত নিয়ে সবকটি $targetTotal টি সঠিক বন্ধনী তৈরি করুন!",
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
                        _isEnglish ? "Discovered: ${_practiceResults.length} / $targetTotal Strings" : "সংগৃহীত: ${_practiceResults.length} / $targetTotal টি বন্ধনী",
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      Text(
                        "${((_practiceResults.length / targetTotal) * 100).clamp(0, 100).toInt()}%",
                        style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: (_practiceResults.length / targetTotal).clamp(0.0, 1.0),
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

            // Current Practice String Box
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
                      Text("Open '(': $_practiceOpen / $_n", style: const TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 12)),
                      Text("Close ')' = $_practiceClose / $_n", style: const TextStyle(color: AppTheme.accentPurple, fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _practiceString.isEmpty ? "[ EMPTY STRING ]" : "\"$_practiceString\"",
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _practiceString.isEmpty ? AppTheme.textMuted : AppTheme.accentNeonCyan,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Decision Buttons & Undo
            if (!_practiceSolved) ...[
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentAmber,
                        foregroundColor: AppTheme.primaryDark,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      icon: const Icon(Icons.add),
                      label: Text(_isEnglish ? "ADD '('" : "ADD '('"),
                      onPressed: () => _handlePracticeMove("open"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      icon: const Icon(Icons.add),
                      label: Text(_isEnglish ? "ADD ')'" : "ADD ')'"),
                      onPressed: () => _handlePracticeMove("close"),
                    ),
                  ),
                ],
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

            // Discovered Strings List
            Text(
              _isEnglish
                  ? "Collected Valid Strings (${_practiceResults.length} / $targetTotal):"
                  : "সংগৃহীত বন্ধনীসমূহ (${_practiceResults.length} / $targetTotal):",
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
                ? const Text("[ No Valid Strings Collected Yet ]", style: TextStyle(color: AppTheme.textMuted, fontSize: 12))
                : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _practiceResults.map((str) {
                      return Chip(
                        backgroundColor: AppTheme.surfaceDark,
                        avatar: const Icon(Icons.check_circle, color: AppTheme.accentGreen, size: 16),
                        label: Text(
                          "\"$str\"",
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
  Widget _buildPresetChip(String nVal) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ActionChip(
        backgroundColor: const Color(0xFF090D16),
        label: Text("n = $nVal", style: const TextStyle(color: AppTheme.accentNeonCyan, fontSize: 11)),
        onPressed: () {
          _nController.text = nVal;
          _rebuildSteps();
        },
      ),
    );
  }

  Widget _buildCodeHighlightBox(int activeLine) {
    final codeLines = [
      "void backtrack(int open, int close, int n, string s, vector<string>& res) {",
      "    if (open == n && close == n) {",
      "        res.push_back(s); // Valid well-formed string!",
      "        return;",
      "    }",
      "    // Rule 1: Add '(' if open < n",
      "    if (open < n) {",
      "        backtrack(open + 1, close, n, s + \"(\", res);",
      "    }",
      "    // Rule 2: Add ')' if close < open",
      "    if (close < open) {",
      "        backtrack(open, close + 1, n, s + \")\", res);",
      "    }",
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

  Widget _buildParenthesesCanvas(GenerateParenthesesStep step) {
    Color decisionColor = AppTheme.accentPurple;
    String decisionLabel = "INIT";

    if (step.decision == "add_open") {
      decisionColor = AppTheme.accentAmber;
      decisionLabel = "➕ ADD '('";
    } else if (step.decision == "add_close") {
      decisionColor = AppTheme.accentPurple;
      decisionLabel = "➕ ADD ')'";
    } else if (step.decision == "base_case") {
      decisionColor = AppTheme.accentGreen;
      decisionLabel = "🎉 VALID MATCH";
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
              Text("n = $_n Pairs", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13)),
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

          // Current String & Counter Meters
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Open '(': ${step.openCount} / $_n", style: const TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 12)),
              Text("Close ')' = ${step.closeCount} / $_n", style: const TextStyle(color: AppTheme.accentPurple, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: step.openCount == _n && step.closeCount == _n ? AppTheme.accentGreen : AppTheme.accentPurple.withOpacity(0.5)),
            ),
            child: Text(
              "\"${step.currentString}\"",
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: step.openCount == _n && step.closeCount == _n ? AppTheme.accentGreen : Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),

          // Saved Valid Strings List
          const Text("Saved Valid Combinations:", style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
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
            child: step.allValidStrings.isEmpty
                ? const Center(child: Text("[ No Combinations Saved Yet ]", style: TextStyle(color: AppTheme.textMuted, fontSize: 12)))
                : SingleChildScrollView(
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: step.allValidStrings.map((str) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppTheme.accentGreen.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppTheme.accentGreen),
                          ),
                          child: Text(
                            "\"$str\"",
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
    void backtrack(int open, int close, int n, string s, vector<string>& res) {
        if (open == n && close == n) {
            res.push_back(s);
            return;
        }
        if (open < n) {
            backtrack(open + 1, close, n, s + "(", res);
        }
        if (close < open) {
            backtrack(open, close + 1, n, s + ")", res);
        }
    }

    vector<string> generateParenthesis(int n) {
        vector<string> res;
        backtrack(0, 0, n, "", res);
        return res;
    }
};""";
    } else if (lang == "Java") {
      code = """
class Solution {
    public List<String> generateParenthesis(int n) {
        List<String> res = new ArrayList<>();
        backtrack(0, 0, n, "", res);
        return res;
    }

    private void backtrack(int open, int close, int n, String s, List<String> res) {
        if (open == n && close == n) {
            res.add(s);
            return;
        }
        if (open < n) {
            backtrack(open + 1, close, n, s + "(", res);
        }
        if (close < open) {
            backtrack(open, close + 1, n, s + ")", res);
        }
    }
}""";
    } else {
      code = """
class Solution:
    def generateParenthesis(self, n: int) -> List[str]:
        res = []

        def backtrack(open_c, close_c, s):
            if open_c == n and close_c == n:
                res.append(s)
                return
            if open_c < n:
                backtrack(open_c + 1, close_c, s + "(")
            if close_c < open_c:
                backtrack(open_c, close_c + 1, s + ")")

        backtrack(0, 0, "")
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
