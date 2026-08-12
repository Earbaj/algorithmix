import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class RemoveInvalidParenthesesStep {
  final int index;
  final int remLeft;
  final int remRight;
  final int balance;
  final String currentExpr;
  final List<String> allValidExprs;
  final String decision; // 'init', 'keep_char', 'remove_left_paren', 'remove_right_paren', 'valid_result_saved', 'invalid_balance_pruned', 'backtrack'
  final int activeLine;
  final String actionEn;
  final String actionBn;
  final String reasonEn;
  final String reasonBn;
  final int callStackDepth;

  const RemoveInvalidParenthesesStep({
    required this.index,
    required this.remLeft,
    required this.remRight,
    required this.balance,
    required this.currentExpr,
    required this.allValidExprs,
    required this.decision,
    required this.activeLine,
    required this.actionEn,
    required this.actionBn,
    required this.reasonEn,
    required this.reasonBn,
    required this.callStackDepth,
  });
}

class RemoveInvalidParenthesesDetailScreen extends StatefulWidget {
  const RemoveInvalidParenthesesDetailScreen({super.key});

  @override
  State<RemoveInvalidParenthesesDetailScreen> createState() => _RemoveInvalidParenthesesDetailScreenState();
}

class _RemoveInvalidParenthesesDetailScreenState extends State<RemoveInvalidParenthesesDetailScreen>
    with SingleTickerProviderStateMixin {
  bool _isEnglish = true;
  late TabController _tabController;

  // Custom Input State
  final TextEditingController _sController = TextEditingController(text: "()())()");
  String _s = "()())()";
  List<RemoveInvalidParenthesesStep> _steps = [];

  // Playback Control
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  // Code Language Selector
  String _selectedCodeLang = "C++";

  // Tab 2 Animation Model Selector (0: Step Flowcard, 1: Parentheses Balance Meter, 2: Min Removals Pre-Calculation Rule)
  int _animationModelIndex = 0;
  int _flowStepIndex = 0;

  // Practice Mode State
  Set<int> _practiceRemovedIndices = {};
  List<String> _practiceResults = [];
  List<String> _practiceHistory = [];
  String _userFeedbackEn = "Tap parentheses to mark them for removal and form valid strings!";
  String _userFeedbackBn = "বৈধ স্ট্রিং তৈরি করতে বাদ দেওয়ার বন্ধনীগুলোতে স্পর্শ করুন!";
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
    _sController.dispose();
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

    String inputStr = _sController.text.trim();
    if (inputStr.isEmpty) inputStr = "()())()";
    if (inputStr.length > 8) inputStr = inputStr.substring(0, 8); // Limit for smooth search tree
    _s = inputStr;

    _steps = _generateSteps(_s);

    // Reset practice mode
    _resetPractice();
  }

  void _resetPractice() {
    _practiceRemovedIndices = {};
    _practiceResults = [];
    _practiceHistory = [];
    _practiceSolved = false;
    _userFeedbackEn = "Tap parentheses to mark them for removal and form valid strings for \"$_s\"!";
    _userFeedbackBn = "\"$_s\" এর জন্য অবৈধ বন্ধনী স্পর্শ করে বাদ দিয়ে উত্তর তৈরি করুন!";
  }

  List<RemoveInvalidParenthesesStep> _generateSteps(String str) {
    List<RemoveInvalidParenthesesStep> steps = [];
    Set<String> validExprs = {};

    // Pass 1: Calculate minLeft and minRight
    int minLeft = 0, minRight = 0;
    for (int i = 0; i < str.length; i++) {
      if (str[i] == '(') {
        minLeft++;
      } else if (str[i] == ')') {
        if (minLeft > 0) {
          minLeft--;
        } else {
          minRight++;
        }
      }
    }

    // Step 0: Init
    steps.add(RemoveInvalidParenthesesStep(
      index: 0,
      remLeft: minLeft,
      remRight: minRight,
      balance: 0,
      currentExpr: "",
      allValidExprs: [],
      decision: "init",
      activeLine: 1,
      actionEn: "Line 1: Pre-calculated min removals required: '(' = $minLeft, ')' = $minRight.",
      actionBn: "লাইন ১: বাদ দিতে হবে এমন ন্যূনতম সংখ্যা হিসাব সম্পন্ন: '(' = $minLeft, ')' = $minRight।",
      reasonEn: "Initial pass determines exact minimum '(' and ')' to delete.",
      reasonBn: "প্রথম পদক্ষেপে নিশ্চিত করা হয়েছে সর্বনিম্ন কতটি '(' এবং ')' বাদ দিতে হবে।",
      callStackDepth: 0,
    ));

    void backtrack(int idx, int rLeft, int rRight, int bal, String expr, int depth) {
      if (bal < 0) {
        steps.add(RemoveInvalidParenthesesStep(
          index: idx,
          remLeft: rLeft,
          remRight: rRight,
          balance: bal,
          currentExpr: expr,
          allValidExprs: List.from(validExprs),
          decision: "invalid_balance_pruned",
          activeLine: 5,
          actionEn: "🛑 Line 5: Balance < 0 at index $idx! More ')' than '(' ➔ Pruned branch.",
          actionBn: "🛑 লাইন ৫: ইনডেক্স $idx এ Balance < 0! '(' এর চেয়ে ')' বেশি ➔ ডাল ছাঁটাই।",
          reasonEn: "Parenthesis expression cannot have closing bracket without preceding open bracket.",
          reasonBn: "পূর্ববর্তী খোলা বন্ধনী ছাড়া নতুন বন্ধনী বন্ধ করা যাবে না।",
          callStackDepth: depth,
        ));
        return;
      }

      if (idx == str.length) {
        if (rLeft == 0 && rRight == 0 && bal == 0) {
          bool isNew = !validExprs.contains(expr);
          if (isNew) validExprs.add(expr);

          steps.add(RemoveInvalidParenthesesStep(
            index: idx,
            remLeft: rLeft,
            remRight: rRight,
            balance: bal,
            currentExpr: expr,
            allValidExprs: List.from(validExprs),
            decision: "valid_result_saved",
            activeLine: 3,
            actionEn: "🎉 Line 3: Saved Valid Expression \"$expr\"!",
            actionBn: "🎉 লাইন ৩: সংগৃহীত বৈধ রাশি \"$expr\"!",
            reasonEn: "All invalid brackets removed and parentheses perfectly balanced.",
            reasonBn: "সমস্ত অবৈধ বন্ধনী বাদ পড়ে তৈরি রাশিটি সম্পূর্ণ ভারসাম্যপূর্ণ।",
            callStackDepth: depth,
          ));
        }
        return;
      }

      String ch = str[idx];

      if (ch == '(') {
        // Choice 1: Remove '(' if rLeft > 0
        if (rLeft > 0) {
          steps.add(RemoveInvalidParenthesesStep(
            index: idx,
            remLeft: rLeft - 1,
            remRight: rRight,
            balance: bal,
            currentExpr: expr,
            allValidExprs: List.from(validExprs),
            decision: "remove_left_paren",
            activeLine: 9,
            actionEn: "✂️ Line 9: Remove '(' at index $idx. Remaining remLeft = ${rLeft - 1}.",
            actionBn: "✂️ লাইন ৯: ইনডেক্স $idx এর '(' বাদ দেওয়া হলো। অবশিষ্ট remLeft = ${rLeft - 1}।",
            reasonEn: "Option 1 for '(': Delete it to satisfy minLeft removal quota.",
            reasonBn: "বিকল্প ১: minLeft কোটা মেটাতে '(' বাদ দেওয়া।",
            callStackDepth: depth + 1,
          ));
          backtrack(idx + 1, rLeft - 1, rRight, bal, expr, depth + 1);
        }

        // Choice 2: Keep '('
        steps.add(RemoveInvalidParenthesesStep(
          index: idx,
          remLeft: rLeft,
          remRight: rRight,
          balance: bal + 1,
          currentExpr: "$expr(",
          allValidExprs: List.from(validExprs),
          decision: "keep_char",
          activeLine: 10,
          actionEn: "✅ Line 10: Keep '(' at index $idx. Balance = ${bal + 1}.",
          actionBn: "✅ লাইন ১০: ইনডেক্স $idx এর '(' রাখা হলো। Balance = ${bal + 1}।",
          reasonEn: "Option 2 for '(': Include in expression and increment balance.",
          reasonBn: "বিকল্প ২: রাশিতে '(' অন্তর্ভুক্ত করে ব্যালেন্স বাড়ানো।",
          callStackDepth: depth + 1,
        ));
        backtrack(idx + 1, rLeft, rRight, bal + 1, "$expr(", depth + 1);
      } else if (ch == ')') {
        // Choice 1: Remove ')' if rRight > 0
        if (rRight > 0) {
          steps.add(RemoveInvalidParenthesesStep(
            index: idx,
            remLeft: rLeft,
            remRight: rRight - 1,
            balance: bal,
            currentExpr: expr,
            allValidExprs: List.from(validExprs),
            decision: "remove_right_paren",
            activeLine: 12,
            actionEn: "✂️ Line 12: Remove ')' at index $idx. Remaining remRight = ${rRight - 1}.",
            actionBn: "✂️ লাইন ১২: ইনডেক্স $idx এর ')' বাদ দেওয়া হলো। অবশিষ্ট remRight = ${rRight - 1}।",
            reasonEn: "Option 1 for ')': Delete it to satisfy minRight removal quota.",
            reasonBn: "বিকল্প ১: minRight কোটা মেটাতে ')' বাদ দেওয়া।",
            callStackDepth: depth + 1,
          ));
          backtrack(idx + 1, rLeft, rRight - 1, bal, expr, depth + 1);
        }

        // Choice 2: Keep ')'
        steps.add(RemoveInvalidParenthesesStep(
          index: idx,
          remLeft: rLeft,
          remRight: rRight,
          balance: bal - 1,
          currentExpr: "$expr)",
          allValidExprs: List.from(validExprs),
          decision: "keep_char",
          activeLine: 13,
          actionEn: "✅ Line 13: Keep ')' at index $idx. Balance = ${bal - 1}.",
          actionBn: "✅ লাইন ১৩: ইনডেক্স $idx এর ')' রাখা হলো। Balance = ${bal - 1}।",
          reasonEn: "Option 2 for ')': Include in expression and decrement balance.",
          reasonBn: "বিকল্প ২: রাশিতে ')' অন্তর্ভুক্ত করে ব্যালেন্স কমানো।",
          callStackDepth: depth + 1,
        ));
        backtrack(idx + 1, rLeft, rRight, bal - 1, "$expr)", depth + 1);
      } else {
        // Letter character -> keep always
        steps.add(RemoveInvalidParenthesesStep(
          index: idx,
          remLeft: rLeft,
          remRight: rRight,
          balance: bal,
          currentExpr: "$expr$ch",
          allValidExprs: List.from(validExprs),
          decision: "keep_char",
          activeLine: 15,
          actionEn: "✅ Line 15: Keep letter '$ch' at index $idx.",
          actionBn: "✅ লাইন ১৫: ইনডেক্স $idx এর বর্ণ '$ch' রাখা হলো।",
          reasonEn: "Letters are non-parenthesis characters and preserved.",
          reasonBn: "বর্ণগুলো বন্ধনী নয় তাই সবসময় অপরিবর্তিত থাকবে।",
          callStackDepth: depth + 1,
        ));
        backtrack(idx + 1, rLeft, rRight, bal, "$expr$ch", depth + 1);
      }
    }

    backtrack(0, minLeft, minRight, 0, "", 0);

    // Final Step
    steps.add(RemoveInvalidParenthesesStep(
      index: str.length,
      remLeft: 0,
      remRight: 0,
      balance: 0,
      currentExpr: "",
      allValidExprs: List.from(validExprs),
      decision: "valid_result_saved",
      activeLine: 16,
      actionEn: "🎉 Line 16: Backtracking Complete! Found total ${validExprs.length} valid expressions for \"$str\"!",
      actionBn: "🎉 লাইন ১৬: ব্যাকট্র্যাকিং সম্পূর্ণ! \"$str\" এর জন্য মোট ${validExprs.length} টি বৈধ রাশি উদ্ধার করা হয়েছে!",
      reasonEn: "All bracket removal trees fully explored.",
      reasonBn: "সমস্ত বন্ধনী ছাঁটাই অনুসন্ধান ডালপালা পরীক্ষা সম্পন্ন হয়েছে।",
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

  int _calculateTargetValidResultsCount(String str) {
    Set<String> validExprs = {};
    int minLeft = 0, minRight = 0;
    for (int i = 0; i < str.length; i++) {
      if (str[i] == '(') minLeft++;
      else if (str[i] == ')') {
        if (minLeft > 0) minLeft--;
        else minRight++;
      }
    }

    void bt(int idx, int rLeft, int rRight, int bal, String expr) {
      if (bal < 0) return;
      if (idx == str.length) {
        if (rLeft == 0 && rRight == 0 && bal == 0) validExprs.add(expr);
        return;
      }
      String ch = str[idx];
      if (ch == '(') {
        if (rLeft > 0) bt(idx + 1, rLeft - 1, rRight, bal, expr);
        bt(idx + 1, rLeft, rRight, bal + 1, "$expr(");
      } else if (ch == ')') {
        if (rRight > 0) bt(idx + 1, rLeft, rRight - 1, bal, expr);
        bt(idx + 1, rLeft, rRight, bal - 1, "$expr)");
      } else {
        bt(idx + 1, rLeft, rRight, bal, "$expr$ch");
      }
    }

    bt(0, minLeft, minRight, 0, "");
    return validExprs.length;
  }

  void _handlePracticeCharTap(int idx) {
    if (_practiceSolved) return;
    final targetTotal = _calculateTargetValidResultsCount(_s);

    setState(() {
      if (_practiceRemovedIndices.contains(idx)) {
        _practiceRemovedIndices.remove(idx);
        _userFeedbackEn = "↩️ Restored char at index $idx.";
        _userFeedbackBn = "↩️ ইনডেক্স $idx এর ব্র্যাকেট পুনর্বহাল করা হলো।";
      } else {
        _practiceRemovedIndices.add(idx);
        _userFeedbackEn = "✂️ Marked char at index $idx for removal.";
        _userFeedbackBn = "✂️ ইনডেক্স $idx এর ব্র্যাকেট বাদ দেওয়ার জন্য চিহ্নিত করা হলো।";
      }

      // Check resulting string
      StringBuffer sb = StringBuffer();
      for (int i = 0; i < _s.length; i++) {
        if (!_practiceRemovedIndices.contains(i)) {
          sb.write(_s[i]);
        }
      }
      String candidateStr = sb.toString();

      // Check validity of candidateStr
      int bal = 0;
      bool valid = true;
      for (int i = 0; i < candidateStr.length; i++) {
        if (candidateStr[i] == '(') bal++;
        else if (candidateStr[i] == ')') bal--;
        if (bal < 0) { valid = false; break; }
      }
      if (bal != 0) valid = false;

      if (valid) {
        if (!_practiceResults.contains(candidateStr)) {
          _practiceResults.add(candidateStr);
          _userFeedbackEn = "🎉 Valid Expression Discovered: \"$candidateStr\"! (${_practiceResults.length} / $targetTotal)";
          _userFeedbackBn = "🎉 বৈধ রাশি আবিষ্কৃত: \"$candidateStr\"! (${_practiceResults.length} / $targetTotal)";
        }

        if (_practiceResults.length >= targetTotal) {
          _practiceSolved = true;
          _userFeedbackEn = "🏆 MASTERED! You found all $targetTotal valid expressions for \"$_s\" with minimum removals!";
          _userFeedbackBn = "🏆 দারুণ! আপনি \"$_s\" এর সমস্ত $targetTotal টি বৈধ্য রাশি উদ্ধার করে ফেলেছেন!";
        }
      }
    });
  }

  void _undoPracticeMove() {
    setState(() {
      _resetPractice();
      _userFeedbackEn = "↩️ Reset practice string.";
      _userFeedbackBn = "↩️ প্র্যাকটিস স্ট্রিং রিসেট করা হলো।";
    });
  }

  @override
  Widget build(BuildContext context) {
    final hPadding = Responsive.horizontalPadding(context);

    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      appBar: AppBar(
        title: Text(
          '301. Remove Invalid Parentheses',
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
                    "301. Remove Invalid Parentheses",
                    style: TextStyle(fontSize: Responsive.sp(context, 22), fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.accentPink.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.accentPink),
                  ),
                  child: const Text("Hard", style: TextStyle(color: AppTheme.accentPink, fontWeight: FontWeight.bold, fontSize: 12)),
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
                        ? "Given a string s containing parentheses and letters, remove the minimum number of invalid parentheses to make the input string valid. Return all possible results. You may return the answer in any order."
                        : "বন্ধনী এবং অক্ষর ধারণকারী একটি স্ট্রিং s দেওয়া আছে। ইনপুট স্ট্রিংটিকে বৈধ করতে সর্বনিম্ন সংখ্যক অবৈধ বন্ধনী বাদ দিন। সমস্ত সম্ভাব্য ফলাফল রিটার্ন করুন।",
                    style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Examples
            Text(_isEnglish ? "Examples" : "উদাহরণসমূহ", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            _buildExampleCard("Example 1", 's = "()())()"', 'Output: ["(())()","()()()"]'),
            _buildExampleCard("Example 2", 's = "(a)())()"', 'Output: ["(a())()","(a)()()"]'),
            _buildExampleCard("Example 3", 's = ")("', 'Output: [""]'),
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
                        _isEnglish ? "Key Intuition (Min Removals Pre-calculation + Balance Pruning)" : "মূল আইডিয়া (ন্যূনতম ছাঁটাই হিসাব + ব্যালেন্স প্রুনিং)",
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isEnglish
                        ? "1. Pre-calculate minLeft and minRight bracket removals in O(N) pass.\n2. Maintain balance >= 0 (open - close) at all times; prune immediately if balance < 0.\n3. Avoid duplicate strings using hash set."
                        : "১. O(N) সময়ে প্রাক-হিসাব করে minLeft এবং minRight ব্র্যাকেট বাদ দেওয়া নিশ্চিত করুন।\n২. সবসময় balance >= 0 বজায় রাখুন; balance < 0 হলেই সঙ্গে সঙ্গে ডাল ছাঁটাই করুন।\n৩. হ্যাশ সেট ব্যবহার করে একই ফলাফল বারবার নেওয়া এড়ান।",
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
              _isEnglish ? "Remove Invalid Parentheses Models" : "ইনভ্যালিড ব্র্যাকেট রিমুভাল মডেলসমূহ (কোডহীন গাইড)",
              style: TextStyle(fontSize: Responsive.sp(context, 18), fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 6),
            Text(
              _isEnglish
                  ? "Explore 3 interactive models for string s = \"()())()\"."
                  : "স্ট্রিং s = \"()())()\" এর জন্য ৩টি ইন্টারঅ্যাক্টিভ ভিজ্যুয়াল মডেল পর্যবেক্ষণ করুন।",
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 16),

            // Model Switcher Segmented Control
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildAnimationModelChip(0, _isEnglish ? "1. 🪜 Step Flowcard" : "১. 🪜 স্টেপ-বাই-স্টেপ ফ্লো-কার্ড"),
                  _buildAnimationModelChip(1, _isEnglish ? "2. ⚖️ Parentheses Balance Meter" : "২. ⚖️ ব্র্যাকেট ব্যালেন্স মিটার"),
                  _buildAnimationModelChip(2, _isEnglish ? "3. 📊 Min Removals Pre-Calculation" : "৩. 📊 ন্যূনতম ছাঁটাই প্রাক-হিসাব"),
                ],
              ),
            ),
            const SizedBox(height: 20),

            if (_animationModelIndex == 0) _buildStepFlowcardModel(),
            if (_animationModelIndex == 1) _buildBalanceMeterModel(),
            if (_animationModelIndex == 2) _buildPreCalculationModel(),

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
        "expr": "( ( ) ) ( )",
        "badge": "🎉 VALID EXPR #1",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 1: Remove ')' at Index 4 ➔ Saved \"(())()\"!",
        "titleBn": "ধাপ ১: ইনডেক্স ৪ এর ')' বাদ দেওয়া হলো ➔ \"(())()\" সংরক্ষিত!",
        "descEn": "Removed 1 invalid ')' bracket. Resulting string is valid & balanced.",
        "descBn": "১টি অবৈধ ')' বাদ দেওয়া হলো। নতুন স্ট্রিংটি সুষম ও বৈধ।",
      },
      {
        "step": 2,
        "expr": "( ) ( ) ( )",
        "badge": "🎉 VALID EXPR #2",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 2: Remove ')' at Index 2 ➔ Saved \"()()()\"!",
        "titleBn": "ধাপ ২: ইনডেক্স ২ এর ')' বাদ দেওয়া হলো ➔ \"()()()\" সংরক্ষিত!",
        "descEn": "Removed 1 invalid ')' bracket. Resulting string is valid & balanced.",
        "descBn": "১টি অবৈধ ')' বাদ দেওয়া হলো। নতুন স্ট্রিংটি সুষম ও বৈধ।",
      },
      {
        "step": 3,
        "expr": "()())()",
        "badge": "🏆 FINISHED",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 3: Traversal Complete! Found 2 Valid Expressions",
        "titleBn": "ধাপ ৩: অনুসন্ধান সম্পূর্ণ! মোট ২টি বৈধ রাশি পাওয়া গেছে",
        "descEn": "Found all unique valid expressions for \"()())()\" with min 1 removal!",
        "descBn": "সর্বনিম্ন ১টি ব্র্যাকেট বাদ দিয়ে \"()())()\" এর সমস্ত অনন্য উত্তর মিলল!",
      },
    ];

    final currentStep = stepFlowData[_flowStepIndex.clamp(0, stepFlowData.length - 1)];
    final String expr = currentStep["expr"] as String;
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
                _isEnglish ? "1. Step-by-Step Parentheses Pruning Flowcard" : "১. স্টেপ-বাই-স্টেপ বন্ধনী ছাঁটাই ফ্লো-কার্ড",
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
                ? "Watch min bracket removal decisions."
                : "ন্যূনতম বন্ধনী ছাঁটাইয়ের পদক্ষেপ পর্যবেক্ষণ করুন।",
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

                // Expression Display Box
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF090D16),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: badgeColor.withOpacity(0.5)),
                  ),
                  child: Text(
                    "\"$expr\"",
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

  // MODEL 2: Balance Meter
  Widget _buildBalanceMeterModel() {
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
            _isEnglish ? "2. Parentheses Balance Meter (bal >= 0)" : "২. ব্র্যাকেট ব্যালেন্স মিটার (bal >= 0)",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            _isEnglish
                ? "Increment balance for '(', decrement for ')'. Prune immediately if balance < 0."
                : "'(' এর জন্য ব্যালেন্স বাড়ান, ')' এর জন্য ব্যালেন্স কমান। ব্যালেন্স < 0 হলেই ছাঁটাই করুন।",
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, height: 1.4),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.accentPink),
            ),
            child: const Text(
              "if (bal < 0) return; // Prune branch immediately! 🛑",
              style: TextStyle(fontFamily: 'monospace', fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.accentPink),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  // MODEL 3: Pre-Calculation Model
  Widget _buildPreCalculationModel() {
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
            _isEnglish ? "3. Min Removals Pre-Calculation Rule" : "৩. ন্যূনতম ছাঁটাই প্রাক-হিসাব নীতি",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            _isEnglish
                ? "First O(N) pass calculates exactly how many '(' (minLeft) and ')' (minRight) MUST be removed."
                : "প্রথম O(N) পদক্ষেপে কয়টি '(' (minLeft) এবং ')' (minRight) বাদ দিতে হবে তা নিখুঁতভাবে নির্ধারণ করা হয়।",
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
              "s = \"()())()\" ➔ minLeft = 0, minRight = 1 🎉\nOnly 1 ')' bracket needs to be removed!",
              style: TextStyle(fontFamily: 'monospace', fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white, height: 1.5),
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
                        controller: _sController,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          labelText: _isEnglish ? "String s" : "স্ট্রিং s",
                          labelStyle: const TextStyle(color: AppTheme.accentNeonCyan, fontSize: 12),
                          filled: true,
                          fillColor: const Color(0xFF090D16),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
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
                      _buildPresetChip("()())()"),
                      _buildPresetChip("(a)())()"),
                      _buildPresetChip(")("),
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
                  _buildRemoveParenthesesCanvas(step),
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildCodeHighlightBox(step.activeLine)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildRemoveParenthesesCanvas(step)),
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
    final targetTotal = _calculateTargetValidResultsCount(_s);

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
                  ? "Tap parentheses to remove minimum brackets and form all $targetTotal valid expressions!"
                  : "ব্র্যাকেটে স্পর্শ করে সর্বনিম্ন ছাঁটাইয়ের মাধ্যমে সমস্ত $targetTotal টি বৈধ্য রাশি উদ্ধার করুন!",
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
                        _isEnglish ? "Discovered: ${_practiceResults.length} / $targetTotal Valid Expressions" : "সংগৃহীত: ${_practiceResults.length} / $targetTotal টি বৈধ রাশি",
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
                      value: targetTotal == 0 ? 0.0 : (_practiceResults.length / targetTotal).clamp(0.0, 1.0),
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

            // Interactive String Brackets
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
                decoration: BoxDecoration(
                  color: const Color(0xFF090D16),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTheme.accentPurple),
                ),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: List.generate(_s.length, (idx) {
                    bool isRemoved = _practiceRemovedIndices.contains(idx);
                    String ch = _s[idx];

                    return GestureDetector(
                      onTap: () => _handlePracticeCharTap(idx),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: isRemoved ? AppTheme.accentPink.withOpacity(0.25) : AppTheme.surfaceDark,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: isRemoved ? AppTheme.accentPink : AppTheme.accentNeonCyan),
                        ),
                        child: Text(
                          ch,
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isRemoved ? AppTheme.accentPink : Colors.white,
                            decoration: isRemoved ? TextDecoration.lineThrough : null,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (_practiceRemovedIndices.isNotEmpty)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  icon: const Icon(Icons.undo, size: 16, color: AppTheme.accentAmber),
                  label: Text(_isEnglish ? "Reset Removals" : "রিসেট", style: const TextStyle(color: AppTheme.accentAmber, fontSize: 12)),
                  onPressed: _undoPracticeMove,
                ),
              ),

            const SizedBox(height: 20),

            // Discovered Results List
            Text(
              _isEnglish
                  ? "Collected Valid Expressions (${_practiceResults.length} / $targetTotal):"
                  : "সংগৃহীত বৈধ রাশি সমুহ (${_practiceResults.length} / $targetTotal):",
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
                ? const Text("[ No Valid Expressions Discovered Yet ]", style: TextStyle(color: AppTheme.textMuted, fontSize: 12))
                : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _practiceResults.map((expr) {
                      return Chip(
                        backgroundColor: AppTheme.surfaceDark,
                        avatar: const Icon(Icons.check_circle, color: AppTheme.accentGreen, size: 16),
                        label: Text(
                          "\"$expr\"",
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
  Widget _buildPresetChip(String val) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ActionChip(
        backgroundColor: const Color(0xFF090D16),
        label: Text("\"$val\"", style: const TextStyle(color: AppTheme.accentNeonCyan, fontSize: 11)),
        onPressed: () {
          _sController.text = val;
          _rebuildSteps();
        },
      ),
    );
  }

  Widget _buildCodeHighlightBox(int activeLine) {
    final codeLines = [
      "void backtrack(int idx, int rLeft, int rRight, int bal, string expr) {",
      "    if (bal < 0) return; // Prune invalid balance",
      "    if (idx == s.size()) {",
      "        if (rLeft == 0 && rRight == 0 && bal == 0) res.insert(expr);",
      "        return;",
      "    }",
      "    char c = s[idx];",
      "    if (c == '(') {",
      "        if (rLeft > 0) backtrack(idx + 1, rLeft - 1, rRight, bal, expr);",
      "        backtrack(idx + 1, rLeft, rRight, bal + 1, expr + '(');",
      "    } else if (c == ')') {",
      "        if (rRight > 0) backtrack(idx + 1, rLeft, rRight - 1, bal, expr);",
      "        backtrack(idx + 1, rLeft, rRight, bal - 1, expr + ')');",
      "    } else {",
      "        backtrack(idx + 1, rLeft, rRight, bal, expr + c);",
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

  Widget _buildRemoveParenthesesCanvas(RemoveInvalidParenthesesStep step) {
    Color decisionColor = AppTheme.accentPurple;
    String decisionLabel = "INIT";

    if (step.decision == "keep_char") {
      decisionColor = AppTheme.accentNeonCyan;
      decisionLabel = "✅ KEEP CHAR";
    } else if (step.decision == "remove_left_paren") {
      decisionColor = AppTheme.accentPink;
      decisionLabel = "✂️ REMOVE '('";
    } else if (step.decision == "remove_right_paren") {
      decisionColor = AppTheme.accentPink;
      decisionLabel = "✂️ REMOVE ')'";
    } else if (step.decision == "invalid_balance_pruned") {
      decisionColor = AppTheme.accentPink;
      decisionLabel = "🛑 BALANCE PRUNED";
    } else if (step.decision == "valid_result_saved") {
      decisionColor = AppTheme.accentGreen;
      decisionLabel = "🎉 RESULT SAVED";
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

          // Quotas & Balance Meters
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("remLeft: ${step.remLeft}, remRight: ${step.remRight}", style: const TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 12)),
              Text("Balance: ${step.balance}", style: TextStyle(color: decisionColor, fontWeight: FontWeight.bold, fontSize: 12)),
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
              step.currentExpr.isEmpty ? "\"\"" : "\"${step.currentExpr}\"",
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: decisionColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),

          // Saved Valid Expressions List
          const Text("Saved Valid Expressions:", style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
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
            child: step.allValidExprs.isEmpty
                ? const Center(child: Text("[ No Valid Expressions Saved Yet ]", style: TextStyle(color: AppTheme.textMuted, fontSize: 12)))
                : SingleChildScrollView(
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: step.allValidExprs.map((expr) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppTheme.accentGreen.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppTheme.accentGreen),
                          ),
                          child: Text(
                            "\"$expr\"",
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
    unordered_set<string> res;

    void backtrack(int idx, int rLeft, int rRight, int bal, string expr, string& s) {
        if (bal < 0) return;
        if (idx == s.size()) {
            if (rLeft == 0 && rRight == 0 && bal == 0) res.insert(expr);
            return;
        }
        char c = s[idx];
        if (c == '(') {
            if (rLeft > 0) backtrack(idx + 1, rLeft - 1, rRight, bal, expr, s);
            backtrack(idx + 1, rLeft, rRight, bal + 1, expr + '(', s);
        } else if (c == ')') {
            if (rRight > 0) backtrack(idx + 1, rLeft, rRight - 1, bal, expr, s);
            backtrack(idx + 1, rLeft, rRight, bal - 1, expr + ')', s);
        } else {
            backtrack(idx + 1, rLeft, rRight, bal, expr + c, s);
        }
    }

    vector<string> removeInvalidParentheses(string s) {
        int rLeft = 0, rRight = 0;
        for (char c : s) {
            if (c == '(') rLeft++;
            else if (c == ')') {
                if (rLeft > 0) rLeft--;
                else rRight++;
            }
        }
        backtrack(0, rLeft, rRight, 0, "", s);
        return vector<string>(res.begin(), res.end());
    }
};""";
    } else if (lang == "Java") {
      code = """
class Solution {
    private Set<String> res = new HashSet<>();

    public List<String> removeInvalidParentheses(String s) {
        int rLeft = 0, rRight = 0;
        for (char c : s.toCharArray()) {
            if (c == '(') rLeft++;
            else if (c == ')') {
                if (rLeft > 0) rLeft--;
                else rRight++;
            }
        }
        backtrack(0, rLeft, rRight, 0, new StringBuilder(), s);
        return new ArrayList<>(res);
    }

    private void backtrack(int idx, int rLeft, int rRight, int bal, StringBuilder expr, String s) {
        if (bal < 0) return;
        if (idx == s.length()) {
            if (rLeft == 0 && rRight == 0 && bal == 0) res.add(expr.toString());
            return;
        }
        char c = s.charAt(idx);
        int len = expr.length();
        if (c == '(') {
            if (rLeft > 0) backtrack(idx + 1, rLeft - 1, rRight, bal, expr, s);
            expr.append('(');
            backtrack(idx + 1, rLeft, rRight, bal + 1, expr, s);
            expr.setLength(len);
        } else if (c == ')') {
            if (rRight > 0) backtrack(idx + 1, rLeft, rRight - 1, bal, expr, s);
            expr.append(')');
            backtrack(idx + 1, rLeft, rRight, bal - 1, expr, s);
            expr.setLength(len);
        } else {
            expr.append(c);
            backtrack(idx + 1, rLeft, rRight, bal, expr, s);
            expr.setLength(len);
        }
    }
}""";
    } else {
      code = """
class Solution:
    def removeInvalidParentheses(self, s: str) -> List[str]:
        rLeft = 0
        rRight = 0
        for c in s:
            if c == '(':
                rLeft += 1
            elif c == ')':
                if rLeft > 0:
                    rLeft -= 1
                else:
                    rRight += 1

        res = set()

        def backtrack(idx, rL, rR, bal, expr):
            if bal < 0:
                return
            if idx == len(s):
                if rL == 0 and rR == 0 and bal == 0:
                    res.add("".join(expr))
                return
            c = s[idx]
            if c == '(':
                if rL > 0:
                    backtrack(idx + 1, rL - 1, rR, bal, expr)
                expr.append('(')
                backtrack(idx + 1, rL, rR, bal + 1, expr)
                expr.pop()
            elif c == ')':
                if rR > 0:
                    backtrack(idx + 1, rL, rR - 1, bal, expr)
                expr.append(')')
                backtrack(idx + 1, rL, rR, bal - 1, expr)
                expr.pop()
            else:
                expr.append(c)
                backtrack(idx + 1, rL, rR, bal, expr)
                expr.pop()

        backtrack(0, rLeft, rRight, 0, [])
        return list(res)""";
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
