import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class LetterCasePermutationStep {
  final int index;
  final String currentChar;
  final String currentBranch;
  final bool isDigit;
  final List<String> allPermutations;
  final String decision; // 'init', 'keep_digit', 'branch_lowercase', 'branch_uppercase', 'base_case', 'backtrack'
  final int activeLine;
  final String actionEn;
  final String actionBn;
  final String reasonEn;
  final String reasonBn;
  final int callStackDepth;

  const LetterCasePermutationStep({
    required this.index,
    required this.currentChar,
    required this.currentBranch,
    required this.isDigit,
    required this.allPermutations,
    required this.decision,
    required this.activeLine,
    required this.actionEn,
    required this.actionBn,
    required this.reasonEn,
    required this.reasonBn,
    required this.callStackDepth,
  });
}

class LetterCasePermutationDetailScreen extends StatefulWidget {
  const LetterCasePermutationDetailScreen({super.key});

  @override
  State<LetterCasePermutationDetailScreen> createState() => _LetterCasePermutationDetailScreenState();
}

class _LetterCasePermutationDetailScreenState extends State<LetterCasePermutationDetailScreen>
    with SingleTickerProviderStateMixin {
  bool _isEnglish = true;
  late TabController _tabController;

  // Custom Input State
  final TextEditingController _inputController = TextEditingController(text: "a1b2");
  String _inputStr = "a1b2";
  List<LetterCasePermutationStep> _steps = [];

  // Playback Control
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  // Code Language Selector
  String _selectedCodeLang = "C++";

  // Tab 2 Animation Model Selector (0: Step Flowcard, 1: Binary Tree Branching, 2: Permutation Counter)
  int _animationModelIndex = 0;
  int _flowStepIndex = 0;

  // Practice Mode State
  int _practiceIndex = 0;
  String _practiceCurrentBranch = "";
  List<String> _practiceResults = [];
  List<String> _practiceHistory = [];
  String _userFeedbackEn = "Select lowercase or uppercase case choices for letters to form all permutations!";
  String _userFeedbackBn = "সবকটি বিন্যাস তৈরি করতে অক্ষরের জন্য ছোট বা বড় হাতের রূপ নির্বাচন করুন!";
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
    _flowStepIndex = 0;

    String clean = _inputController.text.trim();
    if (clean.isEmpty) clean = "a1b2";
    if (clean.length > 5) clean = clean.substring(0, 5); // Limit for clean visualization
    _inputStr = clean;

    _steps = _generateSteps(_inputStr);

    // Reset practice mode
    _practiceIndex = 0;
    _practiceCurrentBranch = "";
    _practiceResults = [];
    _practiceHistory = [];
    _practiceSolved = false;
    _userFeedbackEn = "Select case choices for string '$_inputStr'!";
    _userFeedbackBn = "স্ট্রিং '$_inputStr' এর অক্ষরের জন্য রূপ নির্বাচন করুন!";
  }

  bool _isDigitChar(String ch) {
    if (ch.isEmpty) return false;
    int code = ch.codeUnitAt(0);
    return code >= 48 && code <= 57;
  }

  List<LetterCasePermutationStep> _generateSteps(String s) {
    List<LetterCasePermutationStep> steps = [];
    List<String> results = [];

    // Step 0: Init
    steps.add(LetterCasePermutationStep(
      index: 0,
      currentChar: s.isNotEmpty ? s[0] : "",
      currentBranch: "",
      isDigit: s.isNotEmpty ? _isDigitChar(s[0]) : false,
      allPermutations: [],
      decision: "init",
      activeLine: 1,
      actionEn: "Line 1: Initialize Letter Case Permutation for string '$s'.",
      actionBn: "লাইন ১: স্ট্রিং '$s' এর জন্য Letter Case Permutation ব্যাকট্র্যাক শুরু।",
      reasonEn: "Digits have 1 fixed path, while letters branch into lowercase and uppercase.",
      reasonBn: "সংখ্যাগুলোতে ১টি নির্দিষ্ট পথ রয়েছে, অন্যদিকে অক্ষরগুলোতে ছোট ও বড় হাতের রিকার্সন চলবে।",
      callStackDepth: 0,
    ));

    void backtrack(int idx, String current, int depth) {
      if (idx == s.length) {
        results.add(current);
        steps.add(LetterCasePermutationStep(
          index: idx,
          currentChar: "",
          currentBranch: current,
          isDigit: false,
          allPermutations: List.from(results),
          decision: "base_case",
          activeLine: 3,
          actionEn: "🎉 Line 3: Base Case Reached! Saved permutation \"$current\".",
          actionBn: "🎉 লাইন ৩: বেস কেস অর্জিত! বিন্যাস \"$current\" সংরক্ষিত।",
          reasonEn: "Index reached end of string. Full permutation formed.",
          reasonBn: "ইনডেক্স স্ট্রিংয়ের শেষ প্রান্তে পৌঁছেছে। একটি সম্পূর্ণ বিন্যাস তৈরি সম্পন্ন।",
          callStackDepth: depth,
        ));
        return;
      }

      String ch = s[idx];
      bool isDigit = _isDigitChar(ch);

      if (isDigit) {
        steps.add(LetterCasePermutationStep(
          index: idx,
          currentChar: ch,
          currentBranch: current + ch,
          isDigit: true,
          allPermutations: List.from(results),
          decision: "keep_digit",
          activeLine: 6,
          actionEn: "Line 6: Index $idx ('$ch') is a DIGIT ➔ Keep unchanged: \"${current + ch}\".",
          actionBn: "লাইন ৬: ইনডেক্স $idx ('$ch') একটি সংখ্যা ➔ অপরিবর্তিত রাখুন: \"${current + ch}\"।",
          reasonEn: "Digits have no letter case variation. Recurse to next index ${idx + 1}.",
          reasonBn: "সংখ্যার কোনো কেস পরিবর্তন নেই। পরবর্তী ইনডেক্স ${idx + 1} এ রিকার্সন চালাও।",
          callStackDepth: depth,
        ));
        backtrack(idx + 1, current + ch, depth + 1);
      } else {
        // Choice 1: Lowercase
        String lower = ch.toLowerCase();
        steps.add(LetterCasePermutationStep(
          index: idx,
          currentChar: ch,
          currentBranch: current + lower,
          isDigit: false,
          allPermutations: List.from(results),
          decision: "branch_lowercase",
          activeLine: 8,
          actionEn: "Line 8: Index $idx ('$ch') ➔ Lowercase branch '$lower' ➔ \"${current + lower}\".",
          actionBn: "লাইন ৮: ইনডেক্স $idx ('$ch') ➔ ছোট হাতের রূপ '$lower' ➔ \"${current + lower}\"।",
          reasonEn: "First binary branch: Use lowercase letter '$lower'.",
          reasonBn: "প্রথম বাইনারি ডাল: ছোট হাতের বর্ণ '$lower' ব্যবহার করুন।",
          callStackDepth: depth + 1,
        ));
        backtrack(idx + 1, current + lower, depth + 1);

        // Choice 2: Uppercase
        String upper = ch.toUpperCase();
        steps.add(LetterCasePermutationStep(
          index: idx,
          currentChar: ch,
          currentBranch: current + upper,
          isDigit: false,
          allPermutations: List.from(results),
          decision: "branch_uppercase",
          activeLine: 9,
          actionEn: "Line 9: Index $idx ('$ch') ➔ Uppercase branch '$upper' ➔ \"${current + upper}\".",
          actionBn: "লাইন ৯: ইনডেক্স $idx ('$ch') ➔ বড় হাতের রূপ '$upper' ➔ \"${current + upper}\"।",
          reasonEn: "Second binary branch: Use uppercase letter '$upper'.",
          reasonBn: "দ্বিতীয় বাইনারি ডাল: বড় হাতের বর্ণ '$upper' ব্যবহার করুন।",
          callStackDepth: depth + 1,
        ));
        backtrack(idx + 1, current + upper, depth + 1);
      }
    }

    backtrack(0, "", 0);

    // Final Step
    steps.add(LetterCasePermutationStep(
      index: s.length,
      currentChar: "",
      currentBranch: "",
      isDigit: false,
      allPermutations: List.from(results),
      decision: "base_case",
      activeLine: 11,
      actionEn: "🎉 Line 11: Backtracking Complete! Generated total ${results.length} permutations!",
      actionBn: "🎉 লাইন ১১: ব্যাকট্র্যাকিং সম্পূর্ণ! মোট ${results.length} টি বিন্যাস তৈরি সম্পন্ন!",
      reasonEn: "All binary letter case branches for '$s' fully explored.",
      reasonBn: "স্ট্রিং '$s' এর সমস্ত কেস বিন্যাস ডালপালা পরীক্ষা সম্পন্ন হয়েছে।",
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

  int _calculateTotalPermutationsCount(String s) {
    int letters = 0;
    for (int i = 0; i < s.length; i++) {
      if (!_isDigitChar(s[i])) letters++;
    }
    return 1 << letters;
  }

  void _handlePracticeChoice(String choiceVal) {
    if (_practiceSolved || _practiceIndex >= _inputStr.length) return;

    final targetTotal = _calculateTotalPermutationsCount(_inputStr);

    setState(() {
      _practiceCurrentBranch += choiceVal;
      _practiceHistory.add("CHAR '$choiceVal'");
      _practiceIndex++;

      // Automatically bypass digits if next char is digit
      while (_practiceIndex < _inputStr.length && _isDigitChar(_inputStr[_practiceIndex])) {
        _practiceCurrentBranch += _inputStr[_practiceIndex];
        _practiceHistory.add("DIGIT '${_inputStr[_practiceIndex]}'");
        _practiceIndex++;
      }

      if (_practiceIndex >= _inputStr.length) {
        String perm = _practiceCurrentBranch;
        bool exists = _practiceResults.contains(perm);

        if (!exists) {
          _practiceResults.add(perm);
          _userFeedbackEn = "🎉 Permutation \"$perm\" Saved! (${_practiceResults.length} / $targetTotal)";
          _userFeedbackBn = "🎉 বিন্যাস \"$perm\" সংরক্ষিত! (${_practiceResults.length} / $targetTotal)";
        } else {
          _userFeedbackEn = "ℹ️ Permutation \"$perm\" was already collected. Try another branch!";
          _userFeedbackBn = "ℹ️ বিন্যাস \"$perm\" ইতিমধ্যেই সংগৃহীত হয়েছে। অন্য ডাল চেষ্টা করুন!";
        }

        // Reset for next permutation
        _practiceIndex = 0;
        _practiceCurrentBranch = "";
        while (_practiceIndex < _inputStr.length && _isDigitChar(_inputStr[_practiceIndex])) {
          _practiceCurrentBranch += _inputStr[_practiceIndex];
          _practiceIndex++;
        }

        if (_practiceResults.length >= targetTotal) {
          _practiceSolved = true;
          _userFeedbackEn = "🏆 MASTERED! You generated all $targetTotal permutations for '$_inputStr'!";
          _userFeedbackBn = "🏆 দারুণ! আপনি '$_inputStr' এর সবকটি $targetTotal টি বিন্যাস বানিয়ে ফেলেছেন!";
        }
      } else {
        _userFeedbackEn = "✅ Selected '$choiceVal'! Next: Choose case for index $_practiceIndex ('${_inputStr[_practiceIndex]}').";
        _userFeedbackBn = "✅ '$choiceVal' নির্বাচন করা হলো! পরবর্তী: ইনডেক্স $_practiceIndex ('${_inputStr[_practiceIndex]}') এর রূপ বেছে নিন।";
      }
    });
  }

  void _undoPracticeMove() {
    if (_practiceHistory.isNotEmpty) {
      setState(() {
        _practiceHistory.removeLast();
        if (_practiceCurrentBranch.isNotEmpty) {
          _practiceCurrentBranch = _practiceCurrentBranch.substring(0, _practiceCurrentBranch.length - 1);
        }
        if (_practiceIndex > 0) _practiceIndex--;
        _userFeedbackEn = "↩️ Undid last move. Current Branch = \"$_practiceCurrentBranch\".";
        _userFeedbackBn = "↩️ পূর্ববর্তী ধাপ বাতিল করা হলো। Current Branch = \"$_practiceCurrentBranch\"।";
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
          '784. Letter Case Permutation',
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
                    "784. Letter Case Permutation",
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
                        ? "Given a string s, we can transform every letter individually to be lowercase or uppercase to create another string. Return a list of all possible strings we could create."
                        : "একটি স্ট্রিং s দেওয়া আছে। প্রতিটি অক্ষরকে আলাদাভাবে ছোট হাতের বা বড় হাতের রূপ দিয়ে নতুন স্ট্রিং তৈরি করা সম্ভব। তৈরি করা সম্ভব এমন সমস্ত সম্ভাব্য স্ট্রিংয়ের তালিকা রিটার্ন করুন।",
                    style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Examples
            Text(_isEnglish ? "Examples" : "উদাহরণসমূহ", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            _buildExampleCard("Example 1", 's = "a1b2"', 'Output: ["a1b2","a1B2","A1b2","A1B2"]'),
            _buildExampleCard("Example 2", 's = "3z4"', 'Output: ["3z4","3Z4"]'),
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
                        _isEnglish ? "Key Intuition (Digit vs Letter Binary Branching)" : "মূল আইডিয়া (সংখ্যা বনাম অক্ষর বাইনারি ডালপালা)",
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isEnglish
                        ? "1. Digits have only 1 fixed path (keep unchanged).\n2. Letters create a binary split (2^k permutations): Recurse on lowercase and uppercase variations."
                        : "১. সংখ্যাগুলোতে ১টি নির্দিষ্ট পথ রয়েছে (অপরিবর্তিত রাখুন)।\n২. অক্ষরগুলোতে বাইনারি স্প্লিট তৈরি হয় (2^k বিন্যাস): ছোট হাতের ও বড় হাতের রূপের উপর রিকার্সন চালান।",
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
              _isEnglish ? "Letter Case Permutation Visual Models (Concept Explanations)" : "লেটার কেস পারমিউটেশন ভিজ্যুয়াল মডেলসমূহ (কোডহীন গাইড)",
              style: TextStyle(fontSize: Responsive.sp(context, 18), fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 6),
            Text(
              _isEnglish
                  ? "Explore 3 interactive models for string s = 'a1b2'."
                  : "স্ট্রিং s = 'a1b2' এর জন্য ৩টি ইন্টারঅ্যাক্টিভ ভিজ্যুয়াল মডেল পর্যবেক্ষণ করুন।",
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 16),

            // Model Switcher Segmented Control
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildAnimationModelChip(0, _isEnglish ? "1. 🪜 Step Flowcard" : "১. 🪜 স্টেপ-বাই-স্টেপ ফ্লো-কার্ড"),
                  _buildAnimationModelChip(1, _isEnglish ? "2. 🌿 Binary Tree Split" : "২. 🌿 বাইনারি ট্রি ডালপালা স্প্লিট"),
                  _buildAnimationModelChip(2, _isEnglish ? "3. 📊 2^k Permutation Count" : "৩. 📊 2^k বিন্যাস সংখ্যা"),
                ],
              ),
            ),
            const SizedBox(height: 20),

            if (_animationModelIndex == 0) _buildStepFlowcardModel(),
            if (_animationModelIndex == 1) _buildBinaryTreeModel(),
            if (_animationModelIndex == 2) _buildPermutationCounterModel(),

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
        "branch": "",
        "idx": 0,
        "char": "a",
        "badge": "INIT",
        "badgeColor": AppTheme.accentNeonCyan,
        "titleEn": "Step 1: Start at index 0 ('a') for string 'a1b2'",
        "titleBn": "ধাপ ১: স্ট্রিং 'a1b2' এর ইনডেক্স ০ ('a') থেকে শুরু",
        "descEn": "Character 'a' is a letter ➔ Binary split into lowercase 'a' and uppercase 'A'.",
        "descBn": "অক্ষর 'a' একটি বর্ণ ➔ ছোট হাতের 'a' ও বড় হাতের 'A' বাইনারি স্প্লিট।",
      },
      {
        "step": 2,
        "branch": "a1b2",
        "idx": 3,
        "char": "2",
        "badge": "🎉 SAVED \"a1b2\"",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 2: Lowercase 'a' ➔ Keep '1' ➔ Lowercase 'b' ➔ Keep '2' ➔ Saved \"a1b2\"",
        "titleBn": "ধাপ ২: ছোট হাতের 'a' ➔ '1' স্থির ➔ ছোট 'b' ➔ '2' স্থির ➔ \"a1b2\" সংরক্ষিত",
        "descEn": "Saved first permutation \"a1b2\"!",
        "descBn": "প্রথম বিন্যাস \"a1b2\" সংরক্ষিত!",
      },
      {
        "step": 3,
        "branch": "a1B2",
        "idx": 3,
        "char": "2",
        "badge": "🎉 SAVED \"a1B2\"",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 3: Uppercase 'B' ➔ Keep '2' ➔ Saved \"a1B2\"",
        "titleBn": "ধাপ ৩: বড় হাতের 'B' ➔ '2' স্থির ➔ \"a1B2\" সংরক্ষিত",
        "descEn": "Saved second permutation \"a1B2\"!",
        "descBn": "দ্বিতীয় বিন্যাস \"a1B2\" সংরক্ষিত!",
      },
      {
        "step": 4,
        "branch": "A1b2",
        "idx": 3,
        "char": "2",
        "badge": "🎉 SAVED \"A1b2\"",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 4: Uppercase 'A' ➔ Keep '1' ➔ Lowercase 'b' ➔ Saved \"A1b2\"",
        "titleBn": "ধাপ ৪: বড় হাতের 'A' ➔ '1' স্থির ➔ ছোট 'b' ➔ \"A1b2\" সংরক্ষিত",
        "descEn": "Saved third permutation \"A1b2\"!",
        "descBn": "তৃতীয় বিন্যাস \"A1b2\" সংরক্ষিত!",
      },
      {
        "step": 5,
        "branch": "A1B2",
        "idx": 3,
        "char": "2",
        "badge": "🎉 SAVED \"A1B2\"",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 5: Uppercase 'B' ➔ Keep '2' ➔ Saved \"A1B2\"",
        "titleBn": "ধাপ ৫: বড় হাতের 'B' ➔ '2' স্থির ➔ \"A1B2\" সংরক্ষিত",
        "descEn": "Saved fourth permutation \"A1B2\"!",
        "descBn": "চতুর্থ বিন্যাস \"A1B2\" সংরক্ষিত!",
      },
      {
        "step": 6,
        "branch": "",
        "idx": 4,
        "char": "",
        "badge": "🏆 FINISHED",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 6: Traversal Complete! Total 4 Permutations",
        "titleBn": "ধাপ ৬: ব্যাকট্র্যাকিং সম্পূর্ণ! মোট ৪টি বিন্যাস",
        "descEn": "Generated 4 permutations: [\"a1b2\", \"a1B2\", \"A1b2\", \"A1B2\"]!",
        "descBn": "মোট ৪টি বিন্যাস তৈরি সম্পন্ন: [\"a1b2\", \"a1B2\", \"A1b2\", \"A1B2\"]!",
      },
    ];

    final currentStep = stepFlowData[_flowStepIndex.clamp(0, stepFlowData.length - 1)];
    final String branch = currentStep["branch"] as String;
    final int idx = currentStep["idx"] as int;
    final String ch = currentStep["char"] as String;
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
                _isEnglish ? "1. Step-by-Step Letter Case Permutation Flowcard" : "১. স্টেপ-বাই-স্টেপ লেটার কেস পারমিউটেশন ফ্লো-কার্ড",
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
                ? "Watch how letters branch into lowercase and uppercase variations."
                : "অক্ষরগুলো কীভাবে ছোট ও বড় হাতের রিকার্সন ডালে বিভক্ত হয় তা দেখুন।",
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

                // Active Pointer & Branch Box
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Active Index: $idx ('$ch')", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
                    Text("Length: ${branch.length}", style: const TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 12)),
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
                    "\"$branch\"",
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 20,
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

  // MODEL 2: Binary Tree Split
  Widget _buildBinaryTreeModel() {
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
            _isEnglish ? "2. Binary Tree Split (Digit = 1 path, Letter = 2 paths)" : "২. বাইনারি ট্রি ডালপালা স্প্লিট (সংখ্যা = ১ পথ, বর্ণ = ২ পথ)",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            _isEnglish
                ? "At each step: if digit, keep unchanged; if letter, branch into tolower() and toupper()."
                : "প্রতিটি ধাপে: সংখ্যা হলে অপরিবর্তিত; বর্ণ হলে tolower() ও toupper() এ ২ ডাল।",
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
              "      'a'\n     /   \\\n   'a'   'A'\n    |     |\n   '1'   '1'\n   / \\   / \\\n  'b' 'B' 'b' 'B'",
              style: TextStyle(fontFamily: 'monospace', fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white, height: 1.4),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  // MODEL 3: Permutation Counter
  Widget _buildPermutationCounterModel() {
    int count = _calculateTotalPermutationsCount(_inputStr);

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
            _isEnglish ? "3. Total Permutations Formula (2^k)" : "৩. মোট পারমিউটেশন সূত্র (2^k)",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            _isEnglish
                ? "Where k = number of letters in string. For 'a1b2', k = 2 letters ➔ 2^2 = 4 permutations."
                : "যেখানে k = স্ট্রিংয়ের মোট বর্ণের সংখ্যা। 'a1b2' এর জন্য k = 2 টি বর্ণ ➔ 2^2 = 4 টি বিন্যাস।",
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
            child: Text(
              "String '$_inputStr' ➔ Total $count Permutations 🎉",
              style: const TextStyle(fontFamily: 'monospace', fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.accentGreen),
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
                        controller: _inputController,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          labelText: _isEnglish ? "Custom String (e.g. a1b2)" : "কাস্টম স্ট্রিং (যেমন a1b2)",
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
                      _buildPresetChip("a1b2"),
                      _buildPresetChip("3z4"),
                      _buildPresetChip("ab"),
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
                  _buildLetterCasePermutationCanvas(step),
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildCodeHighlightBox(step.activeLine)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildLetterCasePermutationCanvas(step)),
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
    final targetTotal = _calculateTotalPermutationsCount(_inputStr);

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
                  ? "Build all $targetTotal permutations for string '$_inputStr' by choosing case choices!"
                  : "স্ট্রিং '$_inputStr' এর জন্য সবকটি $targetTotal টি বিন্যাস তৈরি করতে অক্ষরের রূপ বেছে নিন!",
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
                        _isEnglish ? "Discovered: ${_practiceResults.length} / $targetTotal Permutations" : "সংগৃহীত: ${_practiceResults.length} / $targetTotal টি বিন্যাস",
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

            // Current Branch Box
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
                      Text("Active Index: $_practiceIndex / ${_inputStr.length}", style: const TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 12)),
                      Text("Input = '$_inputStr'", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "\"$_practiceCurrentBranch\"",
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.accentNeonCyan,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Lowercase vs Uppercase Choice Buttons
            if (!_practiceSolved && _practiceIndex < _inputStr.length) ...[
              if (!_isDigitChar(_inputStr[_practiceIndex])) ...[
                Text(
                  _isEnglish
                      ? "Choose case for character '${_inputStr[_practiceIndex]}' at index $_practiceIndex:"
                      : "ইনডেক্স $_practiceIndex এর অক্ষর '${_inputStr[_practiceIndex]}' এর জন্য কেস বেছে নিন:",
                  style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      onPressed: () => _handlePracticeChoice(_inputStr[_practiceIndex].toLowerCase()),
                      child: Text("Lowercase '${_inputStr[_practiceIndex].toLowerCase()}'", style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentAmber,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      onPressed: () => _handlePracticeChoice(_inputStr[_practiceIndex].toUpperCase()),
                      child: Text("Uppercase '${_inputStr[_practiceIndex].toUpperCase()}'", style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
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

            // Discovered Permutations List
            Text(
              _isEnglish
                  ? "Collected Permutations (${_practiceResults.length} / $targetTotal):"
                  : "সংগৃহীত বিন্যাসসমূহ (${_practiceResults.length} / $targetTotal):",
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
                ? const Text("[ No Permutations Collected Yet ]", style: TextStyle(color: AppTheme.textMuted, fontSize: 12))
                : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _practiceResults.map((perm) {
                      return Chip(
                        backgroundColor: AppTheme.surfaceDark,
                        avatar: const Icon(Icons.check_circle, color: AppTheme.accentGreen, size: 16),
                        label: Text(
                          "\"$perm\"",
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
        label: Text('"$val"', style: const TextStyle(color: AppTheme.accentNeonCyan, fontSize: 11)),
        onPressed: () {
          _inputController.text = val;
          _rebuildSteps();
        },
      ),
    );
  }

  Widget _buildCodeHighlightBox(int activeLine) {
    final codeLines = [
      "void backtrack(int index, string current, string& s, vector<string>& res) {",
      "    if (index == s.size()) {",
      "        res.push_back(current); // Base case: save permutation",
      "        return;",
      "    }",
      "    if (isdigit(s[index])) {",
      "        backtrack(index + 1, current + s[index], s, res); // Digit fixed",
      "    } else {",
      "        backtrack(index + 1, current + (char)tolower(s[index]), s, res);",
      "        backtrack(index + 1, current + (char)toupper(s[index]), s, res);",
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

  Widget _buildLetterCasePermutationCanvas(LetterCasePermutationStep step) {
    Color decisionColor = AppTheme.accentPurple;
    String decisionLabel = "INIT";

    if (step.decision == "keep_digit") {
      decisionColor = AppTheme.accentAmber;
      decisionLabel = "🔢 DIGIT FIXED";
    } else if (step.decision == "branch_lowercase") {
      decisionColor = AppTheme.accentNeonCyan;
      decisionLabel = "🔤 LOWERCASE";
    } else if (step.decision == "branch_uppercase") {
      decisionColor = AppTheme.accentAmber;
      decisionLabel = "🔠 UPPERCASE";
    } else if (step.decision == "base_case") {
      decisionColor = AppTheme.accentGreen;
      decisionLabel = "🎉 PERMUTATION SAVED";
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
              Text("Index: [${step.index}] ('${step.currentChar}')", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13)),
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

          // Active Built String Box
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Type: ${step.isDigit ? 'Digit' : 'Letter'}", style: TextStyle(color: decisionColor, fontWeight: FontWeight.bold, fontSize: 12)),
              Text("Depth: ${step.callStackDepth}", style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
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
              "\"${step.currentBranch}\"",
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

          // Saved Permutations List
          const Text("Saved Letter Case Permutations:", style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
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
            child: step.allPermutations.isEmpty
                ? const Center(child: Text("[ No Permutations Saved Yet ]", style: TextStyle(color: AppTheme.textMuted, fontSize: 12)))
                : SingleChildScrollView(
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: step.allPermutations.map((perm) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppTheme.accentGreen.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppTheme.accentGreen),
                          ),
                          child: Text(
                            "\"$perm\"",
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
    void backtrack(int index, string current, string& s, vector<string>& res) {
        if (index == s.size()) {
            res.push_back(current);
            return;
        }
        if (isdigit(s[index])) {
            backtrack(index + 1, current + s[index], s, res);
        } else {
            backtrack(index + 1, current + (char)tolower(s[index]), s, res);
            backtrack(index + 1, current + (char)toupper(s[index]), s, res);
        }
    }

    vector<string> letterCasePermutation(string s) {
        vector<string> res;
        backtrack(0, "", s, res);
        return res;
    }
};""";
    } else if (lang == "Java") {
      code = """
class Solution {
    public List<String> letterCasePermutation(String s) {
        List<String> res = new ArrayList<>();
        backtrack(0, "", s, res);
        return res;
    }

    private void backtrack(int index, String current, String s, List<String> res) {
        if (index == s.length()) {
            res.add(current);
            return;
        }
        char ch = s.charAt(index);
        if (Character.isDigit(ch)) {
            backtrack(index + 1, current + ch, s, res);
        } else {
            backtrack(index + 1, current + Character.toLowerCase(ch), s, res);
            backtrack(index + 1, current + Character.toUpperCase(ch), s, res);
        }
    }
}""";
    } else {
      code = """
class Solution:
    def letterCasePermutation(self, s: str) -> List[str]:
        res = []

        def backtrack(index, current):
            if index == len(s):
                res.append(current)
                return
            if s[index].isdigit():
                backtrack(index + 1, current + s[index])
            else:
                backtrack(index + 1, current + s[index].lower())
                backtrack(index + 1, current + s[index].upper())

        backtrack(0, "")
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
