import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class LetterCombinationsStep {
  final int index;
  final String currentDigit;
  final String currentLetters;
  final String currentCombination;
  final List<String> allCombinations;
  final String decision; // 'init', 'branch_letter', 'base_case', 'backtrack'
  final int activeLine;
  final String actionEn;
  final String actionBn;
  final String reasonEn;
  final String reasonBn;
  final int callStackDepth;

  const LetterCombinationsStep({
    required this.index,
    required this.currentDigit,
    required this.currentLetters,
    required this.currentCombination,
    required this.allCombinations,
    required this.decision,
    required this.activeLine,
    required this.actionEn,
    required this.actionBn,
    required this.reasonEn,
    required this.reasonBn,
    required this.callStackDepth,
  });
}

class LetterCombinationsDetailScreen extends StatefulWidget {
  const LetterCombinationsDetailScreen({super.key});

  @override
  State<LetterCombinationsDetailScreen> createState() => _LetterCombinationsDetailScreenState();
}

class _LetterCombinationsDetailScreenState extends State<LetterCombinationsDetailScreen>
    with SingleTickerProviderStateMixin {
  bool _isEnglish = true;
  late TabController _tabController;

  // Custom Input State
  final TextEditingController _digitsController = TextEditingController(text: "23");
  String _digits = "23";
  List<LetterCombinationsStep> _steps = [];

  // Keypad Map
  static const Map<String, String> keypadMap = {
    '2': 'abc',
    '3': 'def',
    '4': 'ghi',
    '5': 'jkl',
    '6': 'mno',
    '7': 'pqrs',
    '8': 'tuv',
    '9': 'wxyz',
  };

  // Playback Control
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  // Code Language Selector
  String _selectedCodeLang = "C++";

  // Tab 2 Animation Model Selector (0: Step Flowcard, 1: Keypad Grid, 2: Combination Product)
  int _animationModelIndex = 0;
  int _flowStepIndex = 0;

  // Practice Mode State
  int _practiceDigitIndex = 0;
  String _practiceCombination = "";
  List<String> _practiceResults = [];
  List<String> _practiceHistory = [];
  String _userFeedbackEn = "Tap keypad letter choices for each digit to form combinations!";
  String _userFeedbackBn = "প্রতিটি ডিজিটের জন্য কিপ্যাড অক্ষর নির্বাচন করে কম্বিনেশন তৈরি করুন!";
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
    _digitsController.dispose();
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

    // Parse digits
    String raw = _digitsController.text.trim();
    raw = raw.replaceAll(RegExp(r'[^2-9]'), '');
    if (raw.isEmpty) raw = "23";
    if (raw.length > 3) raw = raw.substring(0, 3); // Limit to 3 for clean step visualization
    _digits = raw;

    _steps = _generateSteps(_digits);

    // Reset practice mode
    _practiceDigitIndex = 0;
    _practiceCombination = "";
    _practiceResults = [];
    _practiceHistory = [];
    _practiceSolved = false;
    _userFeedbackEn = "Tap keypad letter choices for each digit to form combinations!";
    _userFeedbackBn = "প্রতিটি ডিজিটের জন্য কিপ্যাড অক্ষর নির্বাচন করে কম্বিনেশন তৈরি করুন!";
  }

  List<LetterCombinationsStep> _generateSteps(String digits) {
    List<LetterCombinationsStep> steps = [];
    List<String> results = [];
    StringBuffer path = StringBuffer();

    if (digits.isEmpty) return steps;

    // Step 0: Init
    steps.add(LetterCombinationsStep(
      index: 0,
      currentDigit: digits[0],
      currentLetters: keypadMap[digits[0]] ?? "",
      currentCombination: "",
      allCombinations: [],
      decision: "init",
      activeLine: 1,
      actionEn: "Line 1: Initialize backtracking for digits = \"$digits\". First digit = '${digits[0]}'.",
      actionBn: "লাইন ১: ডিজিট = \"$digits\" এর জন্য ব্যাকট্র্যাক শুরু। প্রথম ডিজিট = '${digits[0]}'।",
      reasonEn: "Digit '${digits[0]}' maps to keypad letters \"${keypadMap[digits[0]]}\".",
      reasonBn: "ডিজিট '${digits[0]}' এর কিপ্যাড অক্ষরগুলো হলো \"${keypadMap[digits[0]]}\"।",
      callStackDepth: 0,
    ));

    void backtrack(int idx, int depth) {
      if (idx == digits.length) {
        results.add(path.toString());
        steps.add(LetterCombinationsStep(
          index: idx - 1,
          currentDigit: digits[idx - 1],
          currentLetters: keypadMap[digits[idx - 1]] ?? "",
          currentCombination: path.toString(),
          allCombinations: List.from(results),
          decision: "base_case",
          activeLine: 3,
          actionEn: "🎉 Line 3: Base Case Reached (idx = $idx)! Saved combination \"${path.toString()}\".",
          actionBn: "🎉 লাইন ৩: বেস কেস অর্জিত (idx = $idx)! কম্বিনেশন \"${path.toString()}\" সংরক্ষিত।",
          reasonEn: "Reached end of digits string. Store complete combination.",
          reasonBn: "ডিজিট স্ট্রিংয়ের শেষ প্রান্তে পৌঁছানো হয়েছে। সম্পূর্ণ কম্বিনেশন সংরক্ষণ করো।",
          callStackDepth: depth,
        ));
        return;
      }

      String d = digits[idx];
      String letters = keypadMap[d] ?? "";

      for (int i = 0; i < letters.length; i++) {
        String ch = letters[i];
        path.write(ch);

        steps.add(LetterCombinationsStep(
          index: idx,
          currentDigit: d,
          currentLetters: letters,
          currentCombination: path.toString(),
          allCombinations: List.from(results),
          decision: "branch_letter",
          activeLine: 7,
          actionEn: "Line 7: Pick letter '$ch' for digit '$d' (idx = $idx). Combination = \"${path.toString()}\".",
          actionBn: "লাইন ৭: ডিজিট '$d' এর জন্য অক্ষর '$ch' নেওয়া হলো (idx = $idx)। Combination = \"${path.toString()}\"।",
          reasonEn: "Explore letter '$ch' from choices \"$letters\" and recurse to idx ${idx + 1}.",
          reasonBn: "পছন্দ \"$letters\" থেকে '$ch' গ্রহণ করে ইনডেক্স ${idx + 1} এ রিকার্সন চালাও।",
          callStackDepth: depth + 1,
        ));

        backtrack(idx + 1, depth + 1);

        // Backtrack
        String str = path.toString();
        path.clear();
        path.write(str.substring(0, str.length - 1));
      }
    }

    backtrack(0, 0);

    // Final Step
    steps.add(LetterCombinationsStep(
      index: digits.length - 1,
      currentDigit: digits[digits.length - 1],
      currentLetters: keypadMap[digits[digits.length - 1]] ?? "",
      currentCombination: "",
      allCombinations: List.from(results),
      decision: "base_case",
      activeLine: 12,
      actionEn: "🎉 Line 12: Backtracking Finished! Generated total ${results.length} unique combinations!",
      actionBn: "🎉 লাইন ১২: ব্যাকট্র্যাকিং সম্পন্ন! মোট ${results.length} টি কম্বিনেশন জেনারেট সম্পন্ন!",
      reasonEn: "All decision branches for digits \"$digits\" fully explored.",
      reasonBn: "ডিজিট \"$digits\" এর সমস্ত সিদ্ধান্ত চয়েস পরীক্ষা সম্পন্ন হয়েছে।",
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

  int _calculateTotalCombinations(String digits) {
    if (digits.isEmpty) return 0;
    int total = 1;
    for (int i = 0; i < digits.length; i++) {
      String l = keypadMap[digits[i]] ?? "";
      if (l.isNotEmpty) total *= l.length;
    }
    return total;
  }

  void _handlePracticePick(String char) {
    if (_practiceSolved || _practiceDigitIndex >= _digits.length) return;

    final targetTotal = _calculateTotalCombinations(_digits);

    setState(() {
      _practiceCombination += char;
      _practiceHistory.add("PICK '$char'");
      _practiceDigitIndex++;

      if (_practiceDigitIndex == _digits.length) {
        String combo = _practiceCombination;
        if (!_practiceResults.contains(combo)) {
          _practiceResults.add(combo);
          _userFeedbackEn = "🎉 Combination \"$combo\" Found! (${_practiceResults.length} / $targetTotal)";
          _userFeedbackBn = "🎉 কম্বিনেশন \"$combo\" সংগৃহীত! (${_practiceResults.length} / $targetTotal)";
        } else {
          _userFeedbackEn = "ℹ️ Combination \"$combo\" was already collected. Try other choices!";
          _userFeedbackBn = "ℹ️ কম্বিনেশন \"$combo\" ইতিমধ্যেই সংগৃহীত হয়েছে। অন্য বর্ণ চেষ্টা করুন!";
        }

        // Reset for next combination
        _practiceDigitIndex = 0;
        _practiceCombination = "";

        if (_practiceResults.length >= targetTotal) {
          _practiceSolved = true;
          _userFeedbackEn = "🏆 MASTERED! You generated all $targetTotal combinations for digits \"$_digits\"!";
          _userFeedbackBn = "🏆 দারুণ! আপনি ডিজিট \"$_digits\" এর সবকটি $targetTotal টি কম্বিনেশন বানিয়ে ফেলেছেন!";
        }
      } else {
        _userFeedbackEn = "✅ Selected '$char'! Next: Pick letter for digit '${_digits[_practiceDigitIndex]}'.";
        _userFeedbackBn = "✅ '$char' নির্বাচন করা হলো! পরবর্তী: ডিজিট '${_digits[_practiceDigitIndex]}' এর বর্ণ বেছে নিন।";
      }
    });
  }

  void _undoPracticeMove() {
    if (_practiceHistory.isNotEmpty && _practiceDigitIndex > 0) {
      setState(() {
        _practiceHistory.removeLast();
        _practiceDigitIndex--;
        if (_practiceCombination.isNotEmpty) {
          _practiceCombination = _practiceCombination.substring(0, _practiceCombination.length - 1);
        }
        _userFeedbackEn = "↩️ Undid last move. Combination = \"$_practiceCombination\".";
        _userFeedbackBn = "↩️ পূর্ববর্তী ধাপ বাতিল করা হলো। Combination = \"$_practiceCombination\"।";
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
          '17. Letter Combinations',
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
                    "17. Letter Combinations of a Phone Number",
                    style: TextStyle(fontSize: Responsive.sp(context, 20), fontWeight: FontWeight.bold, color: Colors.white),
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
                        ? "Given a string containing digits from 2-9 inclusive, return all possible letter combinations that the number could represent. Return the answer in any order. A mapping of digits to letters (just like on telephone buttons) is provided."
                        : "2-9 পর্যন্ত ডিজিট ধারণকারী একটি স্ট্রিং দেওয়া আছে। টেলিফোন কিপ্যাড ম্যাপিং অনুযায়ী সম্ভাব্য সব লেটার কম্বিনেশন রিটার্ন করুন।",
                    style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Keypad Grid Reference
            Text(_isEnglish ? "Keypad Mapping Table" : "কিপ্যাড ম্যাপিং টেবিল", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF090D16),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.accentPurple),
              ),
              child: Wrap(
                spacing: 12,
                runSpacing: 10,
                children: keypadMap.entries.map((e) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceDark,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.accentNeonCyan.withOpacity(0.5)),
                    ),
                    child: Text(
                      "${e.key} ➔ ${e.value}",
                      style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),

            // Examples
            Text(_isEnglish ? "Examples" : "উদাহরণসমূহ", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            _buildExampleCard("Example 1", "digits = \"23\"", "Output: [\"ad\",\"ae\",\"af\",\"bd\",\"be\",\"bf\",\"cd\",\"ce\",\"cf\"]"),
            _buildExampleCard("Example 2", "digits = \"\"", "Output: []"),
            _buildExampleCard("Example 3", "digits = \"2\"", "Output: [\"a\",\"b\",\"c\"]"),
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
                        _isEnglish ? "Key Intuition (Decision Tree Expansion)" : "মূল আইডিয়া (ডিসিশন ট্রি এক্সপ্যানশন)",
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isEnglish
                        ? "Each digit maps to 3 or 4 candidate letters. At level idx, we pick one letter for digits[idx] and recurse to idx + 1. When idx == digits.length, we save the combination!"
                        : "প্রতিটি ডিজিট ৩ বা ৪টি অক্ষরের সাথে ম্যাপ করে। ইনডেক্স idx এ আমরা digits[idx] এর জন্য একটি বর্ণ বেছে নিই এবং idx + 1 এ রিকার্সন চালাই। idx == digits.length হলে কম্বিনেশন সংরক্ষণ করা হয়!",
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
              _isEnglish ? "Letter Combinations Visual Models (Concept Explanations)" : "লেটার কম্বিনেশন ভিজ্যুয়াল মডেলসমূহ (কোডহীন গাইড)",
              style: TextStyle(fontSize: Responsive.sp(context, 18), fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 6),
            Text(
              _isEnglish
                  ? "Explore 3 interactive models for digits = \"23\" (2 ➔ abc, 3 ➔ def)."
                  : "ডিজিট = \"23\" (2 ➔ abc, 3 ➔ def) এর জন্য ৩টি ইন্টারঅ্যাক্টিভ ভিজ্যুয়াল মডেল পর্যবেক্ষণ করুন।",
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 16),

            // Model Switcher Segmented Control
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildAnimationModelChip(0, _isEnglish ? "1. 🪜 Step Flowcard" : "১. 🪜 স্টেপ-বাই-স্টেপ ফ্লো-কার্ড"),
                  _buildAnimationModelChip(1, _isEnglish ? "2. 📱 Phone Keypad" : "২. 📱 ফোন কিপ্যাড গ্রিড"),
                  _buildAnimationModelChip(2, _isEnglish ? "3. ✖️ Combination Product" : "৩. ✖️ কার্তেসীয় গুণজ সংখ্যা"),
                ],
              ),
            ),
            const SizedBox(height: 20),

            if (_animationModelIndex == 0) _buildStepFlowcardModel(),
            if (_animationModelIndex == 1) _buildKeypadGridModel(),
            if (_animationModelIndex == 2) _buildProductModel(),

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
        "combo": "",
        "digit": "2",
        "letters": "abc",
        "badge": "INIT",
        "badgeColor": AppTheme.accentNeonCyan,
        "titleEn": "Step 1: Start at index 0 (Digit '2' ➔ abc)",
        "titleBn": "ধাপ ১: ইনডেক্স ০ দিয়ে শুরু (ডিজিট '2' ➔ abc)",
        "descEn": "First digit '2' has candidate choices \"abc\". Pick 'a' first.",
        "descBn": "প্রথম ডিজিট '2' এর বিকল্প অক্ষর \"abc\"। প্রথমে 'a' নাও।",
      },
      {
        "step": 2,
        "combo": "a",
        "digit": "3",
        "letters": "def",
        "badge": "CHOOSE 'a'",
        "badgeColor": AppTheme.accentAmber,
        "titleEn": "Step 2: Pick 'a' for digit '2' ➔ Move to index 1 (Digit '3' ➔ def)",
        "titleBn": "ধাপ ২: ডিজিট '2' এর জন্য 'a' গ্রহণ ➔ ইনডেক্স ১ এ স্থানান্তরিত (ডিজিট '3' ➔ def)",
        "descEn": "Path = \"a\". Digit '3' has choices \"def\". Pick 'd' first.",
        "descBn": "Path = \"a\"। ডিজিট '3' এর অপশন \"def\"। প্রথমে 'd' নাও।",
      },
      {
        "step": 3,
        "combo": "ad",
        "digit": "3",
        "letters": "def",
        "badge": "🎉 SAVED \"ad\"",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 3: Pick 'd' for digit '3' ➔ Base Case Reached!",
        "titleBn": "ধাপ ৩: ডিজিট '3' এর জন্য 'd' গ্রহণ ➔ বেস কেস অর্জিত!",
        "descEn": "Path = \"ad\" (length 2 == digits.length). Saved combination \"ad\"!",
        "descBn": "Path = \"ad\" (দৈর্ঘ্য ২ == ডিজিটের দৈর্ঘ্য)। কম্বিনেশন \"ad\" সংরক্ষিত!",
      },
      {
        "step": 4,
        "combo": "ae",
        "digit": "3",
        "letters": "def",
        "badge": "🎉 SAVED \"ae\"",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 4: Backtrack to digit '3' & Pick 'e'",
        "titleBn": "ধাপ ৪: ব্যাকট্র্যাক করে ডিজিট '3' এর জন্য 'e' গ্রহণ",
        "descEn": "Path = \"ae\". Saved second combination \"ae\"!",
        "descBn": "Path = \"ae\"। দ্বিতীয় কম্বিনেশন \"ae\" সংরক্ষিত!",
      },
      {
        "step": 5,
        "combo": "af",
        "digit": "3",
        "letters": "def",
        "badge": "🎉 SAVED \"af\"",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 5: Pick 'f' for digit '3'",
        "titleBn": "ধাপ ৫: ডিজিট '3' এর জন্য 'f' গ্রহণ",
        "descEn": "Path = \"af\". Saved third combination \"af\"!",
        "descBn": "Path = \"af\"। তৃতীয় কম্বিনেশন \"af\" সংরক্ষিত!",
      },
      {
        "step": 6,
        "combo": "b",
        "digit": "2",
        "letters": "abc",
        "badge": "↩️ BACKTRACK 'b'",
        "badgeColor": AppTheme.accentAmber,
        "titleEn": "Step 6: Backtrack to digit '2' & Pick 'b'",
        "titleBn": "ধাপ ৬: ব্যাকট্র্যাক করে ডিজিট '2' এর জন্য 'b' গ্রহণ",
        "descEn": "Path = \"b\". Now evaluate choices \"def\" for digit '3'.",
        "descBn": "Path = \"b\"। এখন ডিজিট '3' এর জন্য \"def\" পরীক্ষা করো।",
      },
      {
        "step": 7,
        "combo": "bd",
        "digit": "3",
        "letters": "def",
        "badge": "🎉 SAVED \"bd\"",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 7: Pick 'd' for digit '3' ➔ Saved \"bd\"",
        "titleBn": "ধাপ ৭: ডিজিট '3' এর জন্য 'd' গ্রহণ ➔ \"bd\" সংরক্ষিত",
        "descEn": "Path = \"bd\". Saved fourth combination \"bd\"!",
        "descBn": "Path = \"bd\"। চতুর্থ কম্বিনেশন \"bd\" সংরক্ষিত!",
      },
      {
        "step": 8,
        "combo": "cf",
        "digit": "3",
        "letters": "def",
        "badge": "🎉 SAVED \"cf\"",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 8: Pick 'c' for digit '2' & 'f' for digit '3' ➔ Saved \"cf\"",
        "titleBn": "ধাপ ৮: ডিজিট '2' এর 'c' এবং '3' এর 'f' ➔ \"cf\" সংরক্ষিত",
        "descEn": "Path = \"cf\". Saved final combination \"cf\"!",
        "descBn": "Path = \"cf\"। শেষ কম্বিনেশন \"cf\" সংরক্ষিত!",
      },
      {
        "step": 9,
        "combo": "",
        "digit": "FINISHED",
        "letters": "",
        "badge": "🏆 FINISHED",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 9: All 9 Combinations Generated!",
        "titleBn": "ধাপ ৯: মোট ৯টি কম্বিনেশন জেনারেট সম্পন্ন!",
        "descEn": "Output = [\"ad\",\"ae\",\"af\",\"bd\",\"be\",\"bf\",\"cd\",\"ce\",\"cf\"]",
        "descBn": "কম্বিনেশন = [\"ad\",\"ae\",\"af\",\"bd\",\"be\",\"bf\",\"cd\",\"ce\",\"cf\"]",
      },
    ];

    final currentStep = stepFlowData[_flowStepIndex.clamp(0, stepFlowData.length - 1)];
    final String currentCombo = currentStep["combo"] as String;
    final String currentDigit = currentStep["digit"] as String;
    final String currentLetters = currentStep["letters"] as String;
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
                _isEnglish ? "1. Step-by-Step Keypad Flowcard" : "১. স্টেপ-বাই-স্টেপ কিপ্যাড ফ্লো-কার্ড",
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
                ? "Watch how digit letters expand into combinations step-by-step."
                : "ডিজিটের অক্ষরগুলো কীভাবে ধাপে ধাপে কম্বিনেশনে প্রসারিত হয় তা দেখুন।",
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

                // Active Digit & Combination Box
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Digit: '$currentDigit' ➔ Choices: \"$currentLetters\"", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
                    Text("Path Length: ${currentCombo.length} / ${_digits.length}", style: const TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 12)),
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
                    "\"$currentCombo\"",
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

  // MODEL 2: Phone Keypad Grid
  Widget _buildKeypadGridModel() {
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
            _isEnglish ? "2. Telephone Keypad Grid Reference" : "২. টেলিফোন কিপ্যাড গ্রিড রেফারেন্স",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            _isEnglish
                ? "Visual phone keypad buttons mapping 2-9 digits to letters."
                : "২-৯ ডিজিট থেকে বর্ণমালার টেলিফোন কিপ্যাড প্রদর্শন।",
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 16),

          // Keypad Buttons Grid Layout
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.6,
            physics: const NeverScrollableScrollPhysics(),
            children: keypadMap.entries.map((e) {
              final isTarget = _digits.contains(e.key);
              return Container(
                decoration: BoxDecoration(
                  color: isTarget ? AppTheme.accentPurple.withOpacity(0.3) : AppTheme.surfaceDark,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isTarget ? AppTheme.accentNeonCyan : const Color(0xFF1E293B), width: isTarget ? 2 : 1),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(e.key, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isTarget ? Colors.white : AppTheme.textMuted)),
                    const SizedBox(height: 2),
                    Text(e.value, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isTarget ? AppTheme.accentNeonCyan : AppTheme.textSecondary)),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // MODEL 3: Combination Product Formula
  Widget _buildProductModel() {
    int total = _calculateTotalCombinations(_digits);

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
            _isEnglish ? "3. Cartesian Product Combination Count" : "৩. কার্তেসীয় গুণজ সংখ্যা গণনা",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            _isEnglish
                ? "Total combinations = Product of choices for each digit. For digits \"23\" (3 × 3 = 9)."
                : "মোট কম্বিনেশন = প্রতিটি ডিজিটের পছন্দের গুণফল। \"23\" এর জন্য (৩ × ৩ = ৯)।",
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
              "Digits \"$_digits\" ➔ Total $total Combinations 🎉",
              style: const TextStyle(fontFamily: 'monospace', fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.accentGreen),
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
                        controller: _digitsController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          labelText: _isEnglish ? "Digits (e.g. 23, 24, 234)" : "ডিজিটসমূহ (যেমন 23, 24, 234)",
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
                      _buildPresetChip("23"),
                      _buildPresetChip("24"),
                      _buildPresetChip("234"),
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
                  _buildLetterCanvas(step),
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildCodeHighlightBox(step.activeLine)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildLetterCanvas(step)),
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
    final targetTotal = _calculateTotalCombinations(_digits);
    final currentDigit = _practiceDigitIndex < _digits.length ? _digits[_practiceDigitIndex] : null;
    final currentLetters = currentDigit != null ? (keypadMap[currentDigit] ?? "") : "";

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
                  ? "Build all $targetTotal combinations for digits \"$_digits\" by selecting keypad letters!"
                  : "ডিজিট \"$_digits\" এর জন্য সবকটি $targetTotal টি কম্বিনেশন তৈরি করতে কিপ্যাড থেকে বর্ণ নির্বাচন করুন!",
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
                        _isEnglish ? "Discovered: ${_practiceResults.length} / $targetTotal Combinations" : "সংগৃহীত: ${_practiceResults.length} / $targetTotal টি কম্বিনেশন",
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

            // Current Practice Combination Box
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
                      Text("Active Digit Index: $_practiceDigitIndex / ${_digits.length}", style: const TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 12)),
                      if (currentDigit != null)
                        Text("Digit '$currentDigit' ➔ Choices: \"$currentLetters\"", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _practiceCombination.isEmpty ? "[ EMPTY PATH ]" : "\"$_practiceCombination\"",
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _practiceCombination.isEmpty ? AppTheme.textMuted : AppTheme.accentNeonCyan,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Keypad Letter Pick Buttons
            if (!_practiceSolved && currentLetters.isNotEmpty) ...[
              Text(
                _isEnglish ? "Pick letter for digit '$currentDigit':" : "ডিজিট '$currentDigit' এর জন্য বর্ণ নির্বাচন করুন:",
                style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: currentLetters.split('').map((ch) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accentPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    ),
                    onPressed: () => _handlePracticePick(ch),
                    child: Text("'$ch'", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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

            // Discovered Combinations List
            Text(
              _isEnglish
                  ? "Collected Combinations (${_practiceResults.length} / $targetTotal):"
                  : "সংগৃহীত কম্বিনেশনসমূহ (${_practiceResults.length} / $targetTotal):",
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
                ? const Text("[ No Combinations Collected Yet ]", style: TextStyle(color: AppTheme.textMuted, fontSize: 12))
                : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _practiceResults.map((combo) {
                      return Chip(
                        backgroundColor: AppTheme.surfaceDark,
                        avatar: const Icon(Icons.check_circle, color: AppTheme.accentGreen, size: 16),
                        label: Text(
                          "\"$combo\"",
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
        label: Text("digits = \"$val\"", style: const TextStyle(color: AppTheme.accentNeonCyan, fontSize: 11)),
        onPressed: () {
          _digitsController.text = val;
          _rebuildSteps();
        },
      ),
    );
  }

  Widget _buildCodeHighlightBox(int activeLine) {
    final codeLines = [
      "void backtrack(int idx, string path, string digits, vector<string>& res) {",
      "    if (idx == digits.length()) {",
      "        res.push_back(path); // Save combination",
      "        return;",
      "    }",
      "    string letters = keypadMap[digits[idx]];",
      "    for (char c : letters) {",
      "        backtrack(idx + 1, path + c, digits, res); // Recurse",
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

  Widget _buildLetterCanvas(LetterCombinationsStep step) {
    Color decisionColor = AppTheme.accentPurple;
    String decisionLabel = "INIT";

    if (step.decision == "branch_letter") {
      decisionColor = AppTheme.accentAmber;
      decisionLabel = "➕ CHOOSE LETTER";
    } else if (step.decision == "base_case") {
      decisionColor = AppTheme.accentGreen;
      decisionLabel = "🎉 COMBINATION SAVED";
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

          // Current Combination & Mapped Letters Box
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Digit '${step.currentDigit}' ➔ Choices: \"${step.currentLetters}\"", style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
              Text("Length: ${step.currentCombination.length} / ${_digits.length}", style: const TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: step.currentCombination.length == _digits.length ? AppTheme.accentGreen : AppTheme.accentPurple.withOpacity(0.5)),
            ),
            child: Text(
              "\"${step.currentCombination}\"",
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: step.currentCombination.length == _digits.length ? AppTheme.accentGreen : Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),

          // Saved Combinations List
          const Text("Saved Letter Combinations:", style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
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
            child: step.allCombinations.isEmpty
                ? const Center(child: Text("[ No Combinations Saved Yet ]", style: TextStyle(color: AppTheme.textMuted, fontSize: 12)))
                : SingleChildScrollView(
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: step.allCombinations.map((combo) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppTheme.accentGreen.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppTheme.accentGreen),
                          ),
                          child: Text(
                            "\"$combo\"",
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
    const vector<string> pad = {"", "", "abc", "def", "ghi", "jkl", "mno", "pqrs", "tuv", "wxyz"};

    void backtrack(int idx, string path, string digits, vector<string>& res) {
        if (idx == digits.length()) {
            res.push_back(path);
            return;
        }
        string letters = pad[digits[idx] - '0'];
        for (char c : letters) {
            backtrack(idx + 1, path + c, digits, res);
        }
    }

    vector<string> letterCombinations(string digits) {
        if (digits.empty()) return {};
        vector<string> res;
        backtrack(0, "", digits, res);
        return res;
    }
};""";
    } else if (lang == "Java") {
      code = """
class Solution {
    private String[] pad = {"", "", "abc", "def", "ghi", "jkl", "mno", "pqrs", "tuv", "wxyz"};

    public List<String> letterCombinations(String digits) {
        List<String> res = new ArrayList<>();
        if (digits.isEmpty()) return res;
        backtrack(0, new StringBuilder(), digits, res);
        return res;
    }

    private void backtrack(int idx, StringBuilder path, String digits, List<String> res) {
        if (idx == digits.length()) {
            res.add(path.toString());
            return;
        }
        String letters = pad[digits.charAt(idx) - '0'];
        for (char c : letters.toCharArray()) {
            path.append(c);
            backtrack(idx + 1, path, digits, res);
            path.deleteCharAt(path.length() - 1);
        }
    }
}""";
    } else {
      code = """
class Solution:
    def letterCombinations(self, digits: str) -> List[str]:
        if not digits:
            return []
        
        pad = {"2":"abc", "3":"def", "4":"ghi", "5":"jkl", "6":"mno", "7":"pqrs", "8":"tuv", "9":"wxyz"}
        res = []

        def backtrack(idx, path):
            if idx == len(digits):
                res.append(path)
                return
            for c in pad[digits[idx]]:
                backtrack(idx + 1, path + c)

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
