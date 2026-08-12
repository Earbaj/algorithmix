import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class TargetSumStep {
  final int index;
  final int currentSum;
  final String expression;
  final List<String> allWays;
  final String decision; // 'init', 'add_positive', 'subtract_negative', 'target_met', 'target_failed', 'backtrack'
  final int activeLine;
  final String actionEn;
  final String actionBn;
  final String reasonEn;
  final String reasonBn;
  final int callStackDepth;

  const TargetSumStep({
    required this.index,
    required this.currentSum,
    required this.expression,
    required this.allWays,
    required this.decision,
    required this.activeLine,
    required this.actionEn,
    required this.actionBn,
    required this.reasonEn,
    required this.reasonBn,
    required this.callStackDepth,
  });
}

class TargetSumDetailScreen extends StatefulWidget {
  const TargetSumDetailScreen({super.key});

  @override
  State<TargetSumDetailScreen> createState() => _TargetSumDetailScreenState();
}

class _TargetSumDetailScreenState extends State<TargetSumDetailScreen>
    with SingleTickerProviderStateMixin {
  bool _isEnglish = true;
  late TabController _tabController;

  // Custom Input State
  final TextEditingController _numsController = TextEditingController(text: "1, 1, 1, 1, 1");
  final TextEditingController _targetController = TextEditingController(text: "3");
  List<int> _nums = [1, 1, 1, 1, 1];
  int _target = 3;
  List<TargetSumStep> _steps = [];

  // Playback Control
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  // Code Language Selector
  String _selectedCodeLang = "C++";

  // Tab 2 Animation Model Selector (0: Step Flowcard, 1: Sign Balance Scale, 2: Subset Sum DP Reduction)
  int _animationModelIndex = 0;
  int _flowStepIndex = 0;

  // Practice Mode State
  int _practiceIndex = 0;
  int _practiceCurrentSum = 0;
  List<String> _practiceCurrentExpr = [];
  List<String> _practiceResults = [];
  List<String> _practiceHistory = [];
  String _userFeedbackEn = "Tap '+' or '-' for each number to form expressions that equal target!";
  String _userFeedbackBn = "টার্গেটের সমান করতে প্রতিটি সংখ্যার জন্য '+' বা '-' বাটন স্পর্শ করুন!";
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
    _numsController.dispose();
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
    _flowStepIndex = 0;

    try {
      List<int> parsed = _numsController.text
          .split(',')
          .map((e) => int.parse(e.trim()))
          .toList();
      if (parsed.isEmpty) parsed = [1, 1, 1, 1, 1];
      if (parsed.length > 5) parsed = parsed.sublist(0, 5); // Limit for visualization
      _nums = parsed;

      _target = int.parse(_targetController.text.trim());
    } catch (_) {
      _nums = [1, 1, 1, 1, 1];
      _target = 3;
    }

    _steps = _generateSteps(_nums, _target);

    // Reset practice mode
    _resetPractice();
  }

  void _resetPractice() {
    _practiceIndex = 0;
    _practiceCurrentSum = 0;
    _practiceCurrentExpr = [];
    _practiceResults = [];
    _practiceHistory = [];
    _practiceSolved = false;
    _userFeedbackEn = "Tap '+' or '-' for each number to evaluate to target $_target!";
    _userFeedbackBn = "টার্গেট $_target এ পৌঁছাতে প্রতিটি সংখ্যার জন্য '+' বা '-' নির্বাচন করুন!";
  }

  List<TargetSumStep> _generateSteps(List<int> inputNums, int targetVal) {
    List<TargetSumStep> steps = [];
    List<String> validWays = [];

    // Step 0: Init
    steps.add(TargetSumStep(
      index: 0,
      currentSum: 0,
      expression: "",
      allWays: [],
      decision: "init",
      activeLine: 1,
      actionEn: "Line 1: Initialize Target Sum for nums = [${inputNums.join(', ')}], target = $targetVal.",
      actionBn: "লাইন ১: অ্যাররে nums = [${inputNums.join(', ')}], target = $targetVal এর জন্য Target Sum শুরু।",
      reasonEn: "Each element has two binary choices: '+' or '-'.",
      reasonBn: "প্রতিটি উপাদানের জন্য ২টি বিকল্প রয়েছে: '+' অথবা '-'।",
      callStackDepth: 0,
    ));

    void backtrack(int idx, int currentSum, String expr, int depth) {
      if (idx == inputNums.length) {
        bool isMet = currentSum == targetVal;
        if (isMet) validWays.add(expr);

        steps.add(TargetSumStep(
          index: idx,
          currentSum: currentSum,
          expression: expr,
          allWays: List.from(validWays),
          decision: isMet ? "target_met" : "target_failed",
          activeLine: 3,
          actionEn: isMet
              ? "🎉 Line 3: Target Met (Sum = $currentSum == $targetVal)! Saved expression \"$expr\"."
              : "🛑 Line 3: End of Array (Sum = $currentSum != $targetVal). Not a valid way.",
          actionBn: isMet
              ? "🎉 লাইন ৩: টার্গেট অর্জিত (Sum = $currentSum == $targetVal)! রাশি \"$expr\" সংরক্ষিত।"
              : "🛑 লাইন ৩: অ্যাররের শেষ (Sum = $currentSum != $targetVal)। বৈধ রাশি নয়।",
          reasonEn: isMet
              ? "All numbers assigned signs and evaluated sum equals target."
              : "Assigned signs sum does not match target $targetVal.",
          reasonBn: isMet
              ? "চিহ্ন বসিয়ে প্রাপ্ত মোট যোগফল টার্গেটের সমান।"
              : "চিহ্ন বসিয়ে প্রাপ্ত যোগফল টার্গেট $targetVal এর সাথে মেলেনি।",
          callStackDepth: depth,
        ));
        return;
      }

      int val = inputNums[idx];

      // Choice 1: Add (+val)
      String addExpr = expr.isEmpty ? "+$val" : "$expr + $val";
      steps.add(TargetSumStep(
        index: idx,
        currentSum: currentSum + val,
        expression: addExpr,
        allWays: List.from(validWays),
        decision: "add_positive",
        activeLine: 6,
        actionEn: "➕ Line 6: Add (+$val) at index $idx ➔ Sum = ${currentSum + val}, Expr = \"$addExpr\".",
        actionBn: "➕ লাইন ৬: ইনডেক্স $idx এ (+$val) যোগ ➔ Sum = ${currentSum + val}, Expr = \"$addExpr\"।",
        reasonEn: "First binary branch: Assign positive sign to $val.",
        reasonBn: "প্রথম বাইনারি ডাল: $val এর জন্য ধনাত্মক '+' চিহ্ন নির্ধারণ করুন।",
        callStackDepth: depth + 1,
      ));
      backtrack(idx + 1, currentSum + val, addExpr, depth + 1);

      // Choice 2: Subtract (-val)
      String subExpr = expr.isEmpty ? "-$val" : "$expr - $val";
      steps.add(TargetSumStep(
        index: idx,
        currentSum: currentSum - val,
        expression: subExpr,
        allWays: List.from(validWays),
        decision: "subtract_negative",
        activeLine: 7,
        actionEn: "➖ Line 7: Subtract (-$val) at index $idx ➔ Sum = ${currentSum - val}, Expr = \"$subExpr\".",
        actionBn: "➖ লাইন ৭: ইনডেক্স $idx এ (-$val) বিয়োগ ➔ Sum = ${currentSum - val}, Expr = \"$subExpr\"।",
        reasonEn: "Second binary branch: Assign negative sign to $val.",
        reasonBn: "দ্বিতীয় বাইনারি ডাল: $val এর জন্য ঋণাত্মক '-' চিহ্ন নির্ধারণ করুন।",
        callStackDepth: depth + 1,
      ));
      backtrack(idx + 1, currentSum - val, subExpr, depth + 1);
    }

    backtrack(0, 0, "", 0);

    // Final Step
    steps.add(TargetSumStep(
      index: inputNums.length,
      currentSum: 0,
      expression: "",
      allWays: List.from(validWays),
      decision: "target_met",
      activeLine: 9,
      actionEn: "🎉 Line 9: Backtracking Complete! Found total ${validWays.length} distinct ways to reach target $targetVal!",
      actionBn: "🎉 লাইন ৯: ব্যাকট্র্যাকিং সম্পূর্ণ! টার্গেট $targetVal এ পৌঁছানোর মোট ${validWays.length} টি উপায় পাওয়া গেছে!",
      reasonEn: "All \$2^N sign placement branches fully explored.",
      reasonBn: "সমস্ত \$2^N টি চিহ্ন বিন্যাস ডালপালা পরীক্ষা সম্পন্ন হয়েছে।",
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

  int _calculateTotalWaysCount(List<int> inputNums, int targetVal) {
    int count = 0;
    void bt(int idx, int sum) {
      if (idx == inputNums.length) {
        if (sum == targetVal) count++;
        return;
      }
      bt(idx + 1, sum + inputNums[idx]);
      bt(idx + 1, sum - inputNums[idx]);
    }

    bt(0, 0);
    return count;
  }

  void _handlePracticeSignPick(String sign) {
    if (_practiceSolved || _practiceIndex >= _nums.length) return;

    final targetTotal = _calculateTotalWaysCount(_nums, _target);
    int val = _nums[_practiceIndex];

    setState(() {
      if (sign == "+") {
        _practiceCurrentSum += val;
        _practiceCurrentExpr.add("+$val");
      } else {
        _practiceCurrentSum -= val;
        _practiceCurrentExpr.add("-$val");
      }

      _practiceHistory.add("SIGN $sign$val");
      _practiceIndex++;

      if (_practiceIndex == _nums.length) {
        String exprStr = _practiceCurrentExpr.join(" ");

        if (_practiceCurrentSum == _target) {
          bool exists = _practiceResults.contains(exprStr);
          if (!exists) {
            _practiceResults.add(exprStr);
            _userFeedbackEn = "🎉 Target Met! Expression \"$exprStr\" = $_target Saved! (${_practiceResults.length} / $targetTotal)";
            _userFeedbackBn = "🎉 টার্গেট অর্জিত! রাশি \"$exprStr\" = $_target সংরক্ষিত! (${_practiceResults.length} / $targetTotal)";
          } else {
            _userFeedbackEn = "ℹ️ Expression \"$exprStr\" was already collected. Try another combination!";
            _userFeedbackBn = "ℹ️ রাশি \"$exprStr\" ইতিমধ্যেই সংগৃহীত হয়েছে। অন্য চিহ্ন কম্বিনেশন চেষ্টা করুন!";
          }
        } else {
          _userFeedbackEn = "🛑 Sum = $_practiceCurrentSum != Target $_target. Try another sign path!";
          _userFeedbackBn = "🛑 Sum = $_practiceCurrentSum != টার্গেট $_target। অন্য চিহ্ন পথ চেষ্টা করুন!";
        }

        // Reset for next expression
        _practiceIndex = 0;
        _practiceCurrentSum = 0;
        _practiceCurrentExpr = [];

        if (_practiceResults.length >= targetTotal) {
          _practiceSolved = true;
          _userFeedbackEn = "🏆 MASTERED! You found all $targetTotal ways to reach target $_target for array [${_nums.join(', ')}]!";
          _userFeedbackBn = "🏆 দারুণ! আপনি অ্যাররে [${_nums.join(', ')}] এর জন্য টার্গেট $_target এ পৌঁছানোর সবকটি $targetTotal টি উপায় বের করে ফেলেছেন!";
        }
      } else {
        _userFeedbackEn = "✅ Selected '$sign$val'! Sum = $_practiceCurrentSum. Next: Choose sign for index $_practiceIndex (value ${_nums[_practiceIndex]}).";
        _userFeedbackBn = "✅ '$sign$val' নির্বাচন করা হলো! Sum = $_practiceCurrentSum। পরবর্তী: ইনডেক্স $_practiceIndex (মান ${_nums[_practiceIndex]}) এর চিহ্ন বেছে নিন।";
      }
    });
  }

  void _undoPracticeMove() {
    if (_practiceHistory.isNotEmpty) {
      setState(() {
        _practiceHistory.removeLast();
        _resetPractice();
        _userFeedbackEn = "↩️ Reset practice expression.";
        _userFeedbackBn = "↩️ প্র্যাকটিস রাশি রিসেট করা হলো।";
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
          '494. Target Sum',
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
                    "494. Target Sum",
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
                        ? "You are given an integer array nums and an integer target. You want to build an expression out of nums by adding one of the symbols '+' and '-' before each integer in nums and then concatenate all the integers. Return the number of different expressions that you can build, which evaluates to target."
                        : "একটি পূর্ণসংখ্যার অ্যাররে nums এবং একটি টার্গেট সংখ্যা দেওয়া আছে। প্রতিটি সংখ্যার আগে '+' বা '-' চিহ্ন বসিয়ে একটি রাশি তৈরি করুন। চিহ্ন বসিয়ে গঠিত কতগুলি ভিন্ন রাশি টার্গেটের সমান হয় তার সংখ্যা রিটার্ন করুন।",
                    style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Examples
            Text(_isEnglish ? "Examples" : "উদাহরণসমূহ", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            _buildExampleCard("Example 1", "nums = [1,1,1,1,1], target = 3", "Output: 5"),
            _buildExampleCard("Example 2", "nums = [1], target = 1", "Output: 1"),
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
                        _isEnglish ? "Key Intuition (+ / - Binary Choice Tree + Memoization)" : "মূল আইডিয়া (+ / - বাইনারি নির্বাচন ট্রি + মেমোইজেশন)",
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isEnglish
                        ? "1. At each index, make two binary decisions: +nums[i] or -nums[i].\n2. At index == nums.size(), return 1 if sum == target, else 0.\n3. Memoization with dp[index][sum] avoids redundant state evaluations."
                        : "১. প্রতিটি ইনডেক্সে ২টি বাইনারি সিদ্ধান্ত নিন: +nums[i] অথবা -nums[i]।\n২. index == nums.size() হলে sum == target হলে ১ এবং অন্যথায় ০ রিটার্ন করুন।\n৩. dp[index][sum] দিয়ে মেমোইজেশন অতিরিক্ত হিসাব প্রতিরোধ করে।",
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
              _isEnglish ? "Target Sum Visual Models (Concept Explanations)" : "টার্গেট সাম ভিজ্যুয়াল মডেলসমূহ (কোডহীন গাইড)",
              style: TextStyle(fontSize: Responsive.sp(context, 18), fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 6),
            Text(
              _isEnglish
                  ? "Explore 3 interactive models for array nums = [1, 1, 1], target = 1."
                  : "অ্যাররে nums = [1, 1, 1], target = 1 এর জন্য ৩টি ইন্টারঅ্যাক্টিভ ভিজ্যুয়াল মডেল পর্যবেক্ষণ করুন।",
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 16),

            // Model Switcher Segmented Control
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildAnimationModelChip(0, _isEnglish ? "1. 🪜 Step Flowcard" : "১. 🪜 স্টেপ-বাই-স্টেপ ফ্লো-কার্ড"),
                  _buildAnimationModelChip(1, _isEnglish ? "2. ⚖️ Sign Balance Scale (+ / -)" : "২. ⚖️ চিহ্ন ব্যালেন্স স্কেল (+ / -)"),
                  _buildAnimationModelChip(2, _isEnglish ? "3. 📊 Subset Sum DP Reduction" : "৩. 📊 সাবসেট সাম ডিপি রূপান্তর"),
                ],
              ),
            ),
            const SizedBox(height: 20),

            if (_animationModelIndex == 0) _buildStepFlowcardModel(),
            if (_animationModelIndex == 1) _buildSignBalanceScaleModel(),
            if (_animationModelIndex == 2) _buildSubsetSumReductionModel(),

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
        "expr": "+1 +1 -1",
        "sum": 1,
        "badge": "🎉 TARGET MET",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 1: Choice (+1) ➔ (+1) ➔ (-1) ➔ Sum = 1 == Target 🎉",
        "titleBn": "ধাপ ১: পছন্দ (+1) ➔ (+1) ➔ (-1) ➔ Sum = 1 == টার্গেট 🎉",
        "descEn": "Saved Way #1: \"+1 +1 -1\". Sum = 1 matches target 1!",
        "descBn": "উপায় #১ সংরক্ষিত: \"+1 +1 -1\"। যোগফল ১ টার্গেট ১ এর সমান!",
      },
      {
        "step": 2,
        "expr": "+1 -1 +1",
        "sum": 1,
        "badge": "🎉 TARGET MET",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 2: Choice (+1) ➔ (-1) ➔ (+1) ➔ Sum = 1 == Target 🎉",
        "titleBn": "ধাপ ২: পছন্দ (+1) ➔ (-1) ➔ (+1) ➔ Sum = 1 == টার্গেট 🎉",
        "descEn": "Saved Way #2: \"+1 -1 +1\". Sum = 1 matches target 1!",
        "descBn": "উপায় #২ সংরক্ষিত: \"+1 -1 +1\"। যোগফল ১ টার্গেট ১ এর সমান!",
      },
      {
        "step": 3,
        "expr": "-1 +1 +1",
        "sum": 1,
        "badge": "🎉 TARGET MET",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 3: Choice (-1) ➔ (+1) ➔ (+1) ➔ Sum = 1 == Target 🎉",
        "titleBn": "ধাপ ৩: পছন্দ (-1) ➔ (+1) ➔ (+1) ➔ Sum = 1 == টার্গেট 🎉",
        "descEn": "Saved Way #3: \"-1 +1 +1\". Sum = 1 matches target 1!",
        "descBn": "উপায় #৩ সংরক্ষিত: \"-1 +1 +1\"। যোগফল ১ টার্গেট ১ এর সমান!",
      },
      {
        "step": 4,
        "expr": "",
        "sum": 0,
        "badge": "🏆 FINISHED",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 4: Traversal Complete! Total 3 Valid Ways Found",
        "titleBn": "ধাপ ৪: ব্যাকট্র্যাকিং সম্পূর্ণ! মোট ৩টি বৈধ উপায় পাওয়া গেছে",
        "descEn": "Generated 3 valid expressions for nums = [1, 1, 1] and target = 1!",
        "descBn": "nums = [1, 1, 1] এবং target = 1 এর জন্য ৩টি বৈধ রাশি তৈরি সম্পন্ন!",
      },
    ];

    final currentStep = stepFlowData[_flowStepIndex.clamp(0, stepFlowData.length - 1)];
    final String expr = currentStep["expr"] as String;
    final int sum = currentStep["sum"] as int;
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
                _isEnglish ? "1. Step-by-Step Target Sum Flowcard" : "১. স্টেপ-বাই-স্টেপ টার্গেট সাম ফ্লো-কার্ড",
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
                ? "Watch binary '+' and '-' sign placements evaluation."
                : "বাইনারি '+' এবং '-' চিহ্ন বসিয়ে যোগফল মূল্যায়ন দেখুন।",
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

                // Expression & Sum Display
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Sum: $sum", style: TextStyle(color: badgeColor, fontWeight: FontWeight.bold, fontSize: 12)),
                    Text("Target: $_target", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
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

  // MODEL 2: Sign Balance Scale
  Widget _buildSignBalanceScaleModel() {
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
            _isEnglish ? "2. Sign Balance Scale (+ / -)" : "২. চিহ্ন ব্যালেন্স স্কেল (+ / -)",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            _isEnglish
                ? "Group numbers into positive set P and negative set N such that sum(P) - sum(N) = target."
                : "সংখ্যার সংকলনকে পজিটিভ সেট P এবং নেগেটিভ সেট N এ ভাগ করুন যাতে sum(P) - sum(N) = target হয়।",
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
              "Positive Set P (+)  -  Negative Set N (-)  =  Target ⚖️",
              style: TextStyle(fontFamily: 'monospace', fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  // MODEL 3: Subset Sum DP Reduction
  Widget _buildSubsetSumReductionModel() {
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
            _isEnglish ? "3. Subset Sum DP Reduction Formula" : "৩. সাবসেট সাম ডিপি রূপান্তর সূত্র",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            _isEnglish
                ? "P - N = target AND P + N = totalSum\n=> 2 * P = totalSum + target\n=> P = (totalSum + target) / 2"
                : "P - N = target এবং P + N = totalSum\n=> 2 * P = totalSum + target\n=> P = (totalSum + target) / 2",
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, height: 1.4),
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
              "Target Sum ➔ Subset Sum DP with target P = (sum + target) / 2 🎉",
              style: TextStyle(fontFamily: 'monospace', fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.accentGreen),
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
                      flex: 2,
                      child: TextField(
                        controller: _numsController,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          labelText: _isEnglish ? "Nums (e.g. 1, 1, 1, 1, 1)" : "অ্যাররে (যেমন 1, 1, 1, 1, 1)",
                          labelStyle: const TextStyle(color: AppTheme.accentNeonCyan, fontSize: 12),
                          filled: true,
                          fillColor: const Color(0xFF090D16),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: TextField(
                        controller: _targetController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          labelText: _isEnglish ? "Target" : "টার্গেট",
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
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
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
                      _buildPresetChip("1, 1, 1, 1, 1", "3"),
                      _buildPresetChip("1, 2, 1", "2"),
                      _buildPresetChip("1", "1"),
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
                  _buildTargetSumCanvas(step),
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildCodeHighlightBox(step.activeLine)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTargetSumCanvas(step)),
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
    final targetTotal = _calculateTotalWaysCount(_nums, _target);

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
                  ? "Build all $targetTotal valid expressions for target $_target by picking '+' or '-' for each number!"
                  : "টার্গেট $_target এর জন্য সবকটি $targetTotal টি অনন্য রাশি তৈরি করতে প্রতিটি সংখ্যার জন্য '+' বা '-' বাটন চাপুন!",
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
                        _isEnglish ? "Discovered: ${_practiceResults.length} / $targetTotal Valid Ways" : "সংগৃহীত: ${_practiceResults.length} / $targetTotal টি বৈধ উপায়",
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

            // Active Expression & Sum Display Box
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
                      Text("Index: $_practiceIndex / ${_nums.length}", style: const TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 12)),
                      Text("Sum = $_practiceCurrentSum / $_target", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _practiceCurrentExpr.isEmpty ? "[ Empty Expression ]" : _practiceCurrentExpr.join(" "),
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.accentNeonCyan,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Sign Choice Buttons (+ / -)
            if (!_practiceSolved && _practiceIndex < _nums.length) ...[
              Text(
                _isEnglish
                    ? "Pick sign for number ${_nums[_practiceIndex]} at index $_practiceIndex:"
                    : "ইনডেক্স $_practiceIndex এর সংখ্যা ${_nums[_practiceIndex]} এর জন্য চিহ্ন বেছে নিন:",
                style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accentGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    onPressed: () => _handlePracticeSignPick("+"),
                    child: Text("+ ${_nums[_practiceIndex]}", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 14),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accentPink,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    onPressed: () => _handlePracticeSignPick("-"),
                    child: Text("- ${_nums[_practiceIndex]}", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              if (_practiceHistory.isNotEmpty)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    icon: const Icon(Icons.undo, size: 16, color: AppTheme.accentAmber),
                    label: Text(_isEnglish ? "Reset Expression" : "রাশি রিসেট", style: const TextStyle(color: AppTheme.accentAmber, fontSize: 12)),
                    onPressed: _undoPracticeMove,
                  ),
                ),
            ],

            const SizedBox(height: 20),

            // Discovered Ways List
            Text(
              _isEnglish
                  ? "Collected Valid Ways (${_practiceResults.length} / $targetTotal):"
                  : "সংগৃহীত বৈধ উপায়সমূহ (${_practiceResults.length} / $targetTotal):",
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
                ? const Text("[ No Expressions Collected Yet ]", style: TextStyle(color: AppTheme.textMuted, fontSize: 12))
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
  Widget _buildPresetChip(String numVal, String targetVal) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ActionChip(
        backgroundColor: const Color(0xFF090D16),
        label: Text("[$numVal], t=$targetVal", style: const TextStyle(color: AppTheme.accentNeonCyan, fontSize: 11)),
        onPressed: () {
          _numsController.text = numVal;
          _targetController.text = targetVal;
          _rebuildSteps();
        },
      ),
    );
  }

  Widget _buildCodeHighlightBox(int activeLine) {
    final codeLines = [
      "int backtrack(int index, int currentSum, vector<int>& nums, int target) {",
      "    if (index == nums.size()) {",
      "        return currentSum == target ? 1 : 0; // Target met?",
      "    }",
      "    // Choice 1: Add (+) | Choice 2: Subtract (-)",
      "    int add = backtrack(index + 1, currentSum + nums[index], nums, target);",
      "    int sub = backtrack(index + 1, currentSum - nums[index], nums, target);",
      "    return add + sub;",
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

  Widget _buildTargetSumCanvas(TargetSumStep step) {
    Color decisionColor = AppTheme.accentPurple;
    String decisionLabel = "INIT";

    if (step.decision == "add_positive") {
      decisionColor = AppTheme.accentGreen;
      decisionLabel = "➕ ADD (+)";
    } else if (step.decision == "subtract_negative") {
      decisionColor = AppTheme.accentPink;
      decisionLabel = "➖ SUBTRACT (-)";
    } else if (step.decision == "target_met") {
      decisionColor = AppTheme.accentGreen;
      decisionLabel = "🎉 TARGET MET";
    } else if (step.decision == "target_failed") {
      decisionColor = AppTheme.accentPink;
      decisionLabel = "🔴 TARGET FAILED";
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

          // Active Expression & Accumulated Sum Meter
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Accumulated Sum: ${step.currentSum}", style: TextStyle(color: decisionColor, fontWeight: FontWeight.bold, fontSize: 12)),
              Text("Target: $_target", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
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
              step.expression.isEmpty ? "\"\"" : "\"${step.expression}\"",
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
            child: step.allWays.isEmpty
                ? const Center(child: Text("[ No Valid Expressions Saved Yet ]", style: TextStyle(color: AppTheme.textMuted, fontSize: 12)))
                : SingleChildScrollView(
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: step.allWays.map((expr) {
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
    int backtrack(int index, int currentSum, vector<int>& nums, int target) {
        if (index == nums.size()) {
            return currentSum == target ? 1 : 0;
        }
        int add = backtrack(index + 1, currentSum + nums[index], nums, target);
        int sub = backtrack(index + 1, currentSum - nums[index], nums, target);
        return add + sub;
    }

    int findTargetSumWays(vector<int>& nums, int target) {
        return backtrack(0, 0, nums, target);
    }
};""";
    } else if (lang == "Java") {
      code = """
class Solution {
    public int findTargetSumWays(int[] nums, int target) {
        return backtrack(0, 0, nums, target);
    }

    private int backtrack(int index, int currentSum, int[] nums, int target) {
        if (index == nums.length) {
            return currentSum == target ? 1 : 0;
        }
        int add = backtrack(index + 1, currentSum + nums[index], nums, target);
        int sub = backtrack(index + 1, currentSum - nums[index], nums, target);
        return add + sub;
    }
}""";
    } else {
      code = """
class Solution:
    def findTargetSumWays(self, nums: List[int], target: int) -> int:
        memo = {}

        def backtrack(index, currentSum):
            if index == len(nums):
                return 1 if currentSum == target else 0
            if (index, currentSum) in memo:
                return memo[(index, currentSum)]

            add = backtrack(index + 1, currentSum + nums[index])
            sub = backtrack(index + 1, currentSum - nums[index])
            memo[(index, currentSum)] = add + sub
            return memo[(index, currentSum)]

        return backtrack(0, 0)""";
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
