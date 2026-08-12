import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class PermutationInStringStep {
  final int left;
  final int right;
  final String windowSub;
  final bool isPermutation;
  final String decision; // 'init', 'build_first_window', 'slide_window', 'permutation_found', 'finished_false'
  final int activeLine;
  final String actionEn;
  final String actionBn;
  final String reasonEn;
  final String reasonBn;

  const PermutationInStringStep({
    required this.left,
    required this.right,
    required this.windowSub,
    required this.isPermutation,
    required this.decision,
    required this.activeLine,
    required this.actionEn,
    required this.actionBn,
    required this.reasonEn,
    required this.reasonBn,
  });
}

class PermutationInStringDetailScreen extends StatefulWidget {
  const PermutationInStringDetailScreen({super.key});

  @override
  State<PermutationInStringDetailScreen> createState() => _PermutationInStringDetailScreenState();
}

class _PermutationInStringDetailScreenState extends State<PermutationInStringDetailScreen>
    with SingleTickerProviderStateMixin {
  bool _isEnglish = true;
  late TabController _tabController;

  // Custom Input State
  final TextEditingController _s1Controller = TextEditingController(text: "ab");
  final TextEditingController _s2Controller = TextEditingController(text: "eidbaooo");
  String _s1 = "ab";
  String _s2 = "eidbaooo";
  List<PermutationInStringStep> _steps = [];

  // Playback Control
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  // Code Language Selector
  String _selectedCodeLang = "C++";

  // Tab 2 Animation Model Selector (0: Step Flowcard, 1: Frequency Comparison Rule, 2: Complexity Calculator)
  int _animationModelIndex = 0;
  int _flowStepIndex = 0;

  // Practice Mode State
  int _practiceLeft = 0;
  String _userFeedbackEn = "Slide window of size |s1| across s2 and check if it is a permutation of s1!";
  String _userFeedbackBn = "s2 এর উপর |s1| সাইজের উইন্ডো স্লাইড করে s1 এর পারমিউটেশন আছে কিনা তা পরীক্ষা করুন!";
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
    _s1Controller.dispose();
    _s2Controller.dispose();
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

    String textS1 = _s1Controller.text.trim().toLowerCase();
    String textS2 = _s2Controller.text.trim().toLowerCase();
    if (textS1.isEmpty) textS1 = "ab";
    if (textS2.isEmpty) textS2 = "eidbaooo";
    _s1 = textS1;
    _s2 = textS2;

    _steps = _generateSteps(_s1, _s2);

    // Reset practice mode
    _resetPractice();
  }

  void _resetPractice() {
    _practiceLeft = 0;
    _practiceSolved = false;
    _userFeedbackEn = "Inspect window starting at index $_practiceLeft of s2!";
    _userFeedbackBn = "s2 এর ইনডেক্স $_practiceLeft থেকে শুরু হওয়া উইন্ডো পরীক্ষা করুন!";
  }

  List<PermutationInStringStep> _generateSteps(String s1Str, String s2Str) {
    List<PermutationInStringStep> steps = [];
    int n1 = s1Str.length;
    int n2 = s2Str.length;

    // Step 0: Init
    steps.add(PermutationInStringStep(
      left: 0,
      right: n1 - 1,
      windowSub: "",
      isPermutation: false,
      decision: "init",
      activeLine: 1,
      actionEn: "Line 1: Initialize Sliding Window for s1 = '$s1Str', s2 = '$s2Str'.",
      actionBn: "লাইন ১: s1 = '$s1Str', s2 = '$s2Str' এর জন্য স্লাইডিং উইন্ডো শুরু।",
      reasonEn: "We maintain 26-char frequency arrays for s1 and current window of s2 of length $n1.",
      reasonBn: "s1 এবং s2 এর $n1 দৈর্ঘ্যের উইন্ডোর জন্য ২৬-অক্ষরের ফ্রিকোয়েন্সি মেইনটেইন করা হবে।",
    ));

    if (n1 > n2) {
      steps.add(PermutationInStringStep(
        left: 0,
        right: 0,
        windowSub: s2Str,
        isPermutation: false,
        decision: "finished_false",
        activeLine: 2,
        actionEn: "🏁 Line 2: s1 length ($n1) > s2 length ($n2). Return false.",
        actionBn: "🏁 লাইন ২: s1 এর দৈর্ঘ্য ($n1) > s2 এর দৈর্ঘ্য ($n2)। false রিটার্ন করুন।",
        reasonEn: "s1 cannot be contained in a shorter string s2.",
        reasonBn: "s1 কোনো ছোট স্ট্রিং s2 এর ভেতরে থাকতে পারে না।",
      ));
      return steps;
    }

    List<int> s1Freq = List.filled(26, 0);
    List<int> s2Freq = List.filled(26, 0);

    for (int i = 0; i < n1; i++) {
      s1Freq[s1Str.codeUnitAt(i) - 97]++;
      s2Freq[s2Str.codeUnitAt(i) - 97]++;
    }

    bool isFirstMatch = _areFreqsEqual(s1Freq, s2Freq);

    steps.add(PermutationInStringStep(
      left: 0,
      right: n1 - 1,
      windowSub: s2Str.substring(0, n1),
      isPermutation: isFirstMatch,
      decision: isFirstMatch ? "permutation_found" : "build_first_window",
      activeLine: 4,
      actionEn: isFirstMatch
          ? "🎉 Line 4: First Window [0..${n1 - 1}] '${s2Str.substring(0, n1)}' IS A PERMUTATION of '$s1Str'! Return true!"
          : "🪟 Line 4: First Window [0..${n1 - 1}] '${s2Str.substring(0, n1)}' ➔ Frequency mismatch.",
      actionBn: isFirstMatch
          ? "🎉 লাইন ৪: প্রথম উইন্ডো [0..${n1 - 1}] '${s2Str.substring(0, n1)}' হলো '$s1Str' এর একটি পারমিউটেশন! true রিটার্ন করুন!"
          : "🪟 লাইন ৪: প্রথম উইন্ডো [0..${n1 - 1}] '${s2Str.substring(0, n1)}' ➔ ফ্রিকোয়েন্সি মেলেনি।",
      reasonEn: isFirstMatch
          ? "All character frequencies match s1 perfectly."
          : "Character frequencies do not match s1.",
      reasonBn: isFirstMatch
          ? "সমস্ত অক্ষরের ফ্রিকোয়েন্সি s1 এর সাথে মিলে গেছে।"
          : "অক্ষরের ফ্রিকোয়েন্সি s1 এর সাথে মেলেনি।",
    ));

    if (isFirstMatch) return steps;

    bool found = false;

    // Slide window right
    for (int i = n1; i < n2; i++) {
      int l = i - n1 + 1;
      int r = i;

      s2Freq[s2Str.codeUnitAt(r) - 97]++;
      s2Freq[s2Str.codeUnitAt(l - 1) - 97]--;

      bool isMatch = _areFreqsEqual(s1Freq, s2Freq);

      if (isMatch) {
        found = true;
        steps.add(PermutationInStringStep(
          left: l,
          right: r,
          windowSub: s2Str.substring(l, r + 1),
          isPermutation: true,
          decision: "permutation_found",
          activeLine: 8,
          actionEn: "🎉 Line 8: Window [${l}..${r}] '${s2Str.substring(l, r + 1)}' IS A PERMUTATION of '$s1Str'! Return true!",
          actionBn: "🎉 লাইন ৮: উইন্ডো [${l}..${r}] '${s2Str.substring(l, r + 1)}' হলো '$s1Str' এর একটি পারমিউটেশন! true রিটার্ন করুন!",
          reasonEn: "Frequency array matches s1 perfectly. Found valid permutation substring!",
          reasonBn: "ফ্রিকোয়েন্সি অ্যারে s1 এর সাথে হুবহু মিলেছে। বৈধ্য পারমিউটেশন সাব-স্ট্রিং পাওয়া গেছে!",
        ));
        break;
      } else {
        steps.add(PermutationInStringStep(
          left: l,
          right: r,
          windowSub: s2Str.substring(l, r + 1),
          isPermutation: false,
          decision: "slide_window",
          activeLine: 7,
          actionEn: "➡️ Line 7: Slide Window [${l}..${r}] '${s2Str.substring(l, r + 1)}' ➔ Mismatch.",
          actionBn: "➡️ লাইন ৭: উইন্ডো স্লাইড [${l}..${r}] '${s2Str.substring(l, r + 1)}' ➔ ফ্রিকোয়েন্সি মেলেনি।",
          reasonEn: "Window substring is not a permutation of s1.",
          reasonBn: "উইন্ডো সাব-স্ট্রিংটি s1 এর পারমিউটেশন নয়।",
        ));
      }
    }

    if (!found) {
      steps.add(PermutationInStringStep(
        left: n2 - n1,
        right: n2 - 1,
        windowSub: s2Str.substring(n2 - n1),
        isPermutation: false,
        decision: "finished_false",
        activeLine: 10,
        actionEn: "❌ Line 10: Traversal Complete! No permutation of '$s1Str' found in '$s2Str'. Return false.",
        actionBn: "❌ লাইন ১০: স্ক্যান সম্পূর্ণ! '$s2Str' এর ভেতরে '$s1Str' এর কোনো পারমিউটেশন পাওয়া যায়নি। false রিটার্ন করুন।",
        reasonEn: "Evaluated all window substrings in O(N2) linear time without match.",
        reasonBn: "কোনো ম্যাচ ছাড়াই O(N2) লিনিয়ার সময়ে সমস্ত উইন্ডো সাব-স্ট্রিং মূল্যায়ন শেষ।",
      ));
    }

    return steps;
  }

  bool _areFreqsEqual(List<int> f1, List<int> f2) {
    for (int i = 0; i < 26; i++) {
      if (f1[i] != f2[i]) return false;
    }
    return true;
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

  bool _checkInclusion(String s1Str, String s2Str) {
    if (s1Str.length > s2Str.length) return false;
    List<int> s1Freq = List.filled(26, 0);
    List<int> s2Freq = List.filled(26, 0);
    int n1 = s1Str.length;

    for (int i = 0; i < n1; i++) {
      s1Freq[s1Str.codeUnitAt(i) - 97]++;
      s2Freq[s2Str.codeUnitAt(i) - 97]++;
    }

    if (_areFreqsEqual(s1Freq, s2Freq)) return true;

    for (int i = n1; i < s2Str.length; i++) {
      s2Freq[s2Str.codeUnitAt(i) - 97]++;
      s2Freq[s2Str.codeUnitAt(i - n1) - 97]--;
      if (_areFreqsEqual(s1Freq, s2Freq)) return true;
    }
    return false;
  }

  void _handlePracticeCheckWindow(bool userClaimPermutation) {
    if (_practiceSolved || _practiceLeft + _s1.length > _s2.length) return;
    String sub = _s2.substring(_practiceLeft, _practiceLeft + _s1.length);
    List<int> f1 = List.filled(26, 0);
    List<int> f2 = List.filled(26, 0);
    for (int i = 0; i < _s1.length; i++) {
      f1[_s1.codeUnitAt(i) - 97]++;
      f2[sub.codeUnitAt(i) - 97]++;
    }
    bool actualIsMatch = _areFreqsEqual(f1, f2);

    setState(() {
      if (userClaimPermutation == actualIsMatch) {
        if (actualIsMatch) {
          _practiceSolved = true;
          _userFeedbackEn = "🎉 PERFECT! Window '$sub' at index $_practiceLeft IS a valid permutation of '$_s1'! Result: TRUE!";
          _userFeedbackBn = "🎉 দারুণ! ইনডেক্স $_practiceLeft এর উইন্ডো '$sub' হলো '$_s1' এর একটি বৈধ্য পারমিউটেশন! রেজাল্ট: TRUE!";
          return;
        }

        _practiceLeft++;
        if (_practiceLeft + _s1.length > _s2.length) {
          _practiceSolved = true;
          _userFeedbackEn = "❌ Traversal finished! No permutation of '$_s1' exists in '$_s2'. Result: FALSE!";
          _userFeedbackBn = "❌ স্ক্যান সম্পূর্ণ! '$_s2' এর ভেতরে '$_s1' এর কোনো পারমিউটেশন নেই। রেজাল্ট: FALSE!";
        } else {
          _userFeedbackEn = "Correct! Substring '$sub' is NOT a permutation. Next: Inspect index $_practiceLeft.";
          _userFeedbackBn = "সঠিক! সাব-স্ট্রিং '$sub' পারমিউটেশন নয়। পরের: ইনডেক্স $_practiceLeft পরীক্ষা করুন।";
        }
      } else {
        _userFeedbackEn = "Incorrect! Window '$sub' is ${actualIsMatch ? 'A PERMUTATION of ' + _s1 : 'NOT a permutation'}. Try again!";
        _userFeedbackBn = "ভুল উত্তর! উইন্ডো '$sub' হলো ${actualIsMatch ? _s1 + ' এর একটি পারমিউটেশন' : 'পারমিউটেশন নয়'}। আবার চেষ্টা করুন!";
      }
    });
  }

  void _undoPracticeMove() {
    setState(() {
      _resetPractice();
      _userFeedbackEn = "↩️ Reset practice state.";
      _userFeedbackBn = "↩️ প্র্যাকটিস স্টেট রিসেট করা হলো।";
    });
  }

  @override
  Widget build(BuildContext context) {
    final hPadding = Responsive.horizontalPadding(context);

    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      appBar: AppBar(
        title: Text(
          '567. Permutation in String',
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
                    "567. Permutation in String",
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
              children: ["Meta", "Microsoft", "Yandex"].map((company) {
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
                        ? "Given two strings s1 and s2, return true if s2 contains a permutation of s1, or false otherwise. In other words, return true if one of s1's permutations is the substring of s2."
                        : "দুটি স্ট্রিং s1 এবং s2 দেওয়া আছে। s2 স্ট্রিংয়ের ভেতরে s1 এর কোনো পারমিউটেশন (বিন্যাস) সাব-স্ট্রিং হিসেবে থাকলে true রিটার্ন করুন, অন্যথায় false রিটার্ন করুন।",
                    style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Examples
            Text(_isEnglish ? "Examples" : "উদাহরণসমূহ", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            _buildExampleCard("Example 1", "s1 = \"ab\", s2 = \"eidbaooo\"", "Output: true (Sub-window \"ba\" at 3 is a permutation of \"ab\")"),
            _buildExampleCard("Example 2", "s1 = \"ab\", s2 = \"eidboaoo\"", "Output: false"),
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
                        _isEnglish ? "Key Intuition (Fixed Window Frequency Matcher)" : "মূল আইডিয়া (ফিক্সড উইন্ডো ফ্রিকোয়েন্সি ম্যাচিং)",
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isEnglish
                        ? "1. Check if any substring of s2 of size |s1| has exact same character frequencies as s1.\n2. Maintain 26-char frequency arrays for s1 and current window of s2.\n3. Slide window in O(1) time per step. Total O(N2) linear time."
                        : "১. |s1| আকারের s2 এর কোনো সাব-স্ট্রিং s1 এর সমান ফ্রিকোয়েন্সি বহন করে কিনা চেক করুন।\n২. s1 এবং s2 এর উইন্ডোর জন্য ২৬-অক্ষরের ফ্রিকোয়েন্সি অ্যারে বজায় রাখুন।\n৩. O(1) সময়ে উইন্ডো স্লাইড করুন। সর্বমোট O(N2) লিনিয়ার সময়।",
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
              _isEnglish ? "Permutation in String Visual Models" : "পারমিউটেশন ইন স্ট্রিং ভিজ্যুয়াল মডেলসমূহ (কোডহীন গাইড)",
              style: TextStyle(fontSize: Responsive.sp(context, 18), fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 6),
            Text(
              _isEnglish
                  ? "Explore 3 interactive models for s1 = \"ab\", s2 = \"eidbaooo\"."
                  : "s1 = \"ab\", s2 = \"eidbaooo\" এর জন্য ৩টি ইন্টারঅ্যাক্টিভ ভিজ্যুয়াল মডেল পর্যবেক্ষণ করুন।",
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 16),

            // Model Switcher Segmented Control
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildAnimationModelChip(0, _isEnglish ? "1. 🪜 Step Flowcard" : "১. 🪜 স্টেপ-বাই-স্টেপ ফ্লো-কার্ড"),
                  _buildAnimationModelChip(1, _isEnglish ? "2. 📊 Frequency Comparison" : "২. 📊 ফ্রিকোয়েন্সি তুলনা নীতি"),
                  _buildAnimationModelChip(2, _isEnglish ? "3. 📊 Complexity Calculator" : "৩. 📊 টাইমিং ক্যালকুলেটর"),
                ],
              ),
            ),
            const SizedBox(height: 20),

            if (_animationModelIndex == 0) _buildStepFlowcardModel(),
            if (_animationModelIndex == 1) _buildFrequencyComparisonModel(),
            if (_animationModelIndex == 2) _buildComplexityCalculatorModel(),

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
        "window": "\"ei\"",
        "isPermutation": false,
        "badge": "➡️ SLIDE RIGHT",
        "badgeColor": AppTheme.accentAmber,
        "titleEn": "Step 1: First Window [0..1] = \"ei\" ➔ Mismatch",
        "titleBn": "ধাপ ১: প্রথম উইন্ডো [0..1] = \"ei\" ➔ ফ্রিকোয়েন্সি মেলেনি",
        "descEn": "Frequencies do not match s1 = 'ab'.",
        "descBn": "ফ্রিকোয়েন্সি s1 = 'ab' এর সাথে মেলেনি।",
      },
      {
        "step": 2,
        "window": "\"id\"",
        "isPermutation": false,
        "badge": "➡️ SLIDE RIGHT",
        "badgeColor": AppTheme.accentAmber,
        "titleEn": "Step 2: Slide Right (+d, -e) ➔ Window [1..2] = \"id\" (Mismatch)",
        "titleBn": "ধাপ ২: ডানে স্লাইড (+d, -e) ➔ উইন্ডো [1..2] = \"id\" (মেলেনি)",
        "descEn": "Frequencies do not match s1 = 'ab'.",
        "descBn": "ফ্রিকোয়েন্সি s1 = 'ab' এর সাথে মেলেনি।",
      },
      {
        "step": 3,
        "window": "\"db\"",
        "isPermutation": false,
        "badge": "➡️ SLIDE RIGHT",
        "badgeColor": AppTheme.accentAmber,
        "titleEn": "Step 3: Slide Right (+b, -i) ➔ Window [2..3] = \"db\" (Mismatch)",
        "titleBn": "ধাপ ৩: ডানে স্লাইড (+b, -i) ➔ উইন্ডো [2..3] = \"db\" (মেলেনি)",
        "descEn": "Frequencies do not match s1 = 'ab'.",
        "descBn": "ফ্রিকোয়েন্সি s1 = 'ab' এর সাথে মেলেনি।",
      },
      {
        "step": 4,
        "window": "\"ba\"",
        "isPermutation": true,
        "badge": "🎉 PERMUTATION MATCH",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 4: Slide Right (+a, -d) ➔ Window [3..4] = \"ba\" IS A MATCH! 🎉",
        "titleBn": "ধাপ ৪: ডানে স্লাইড (+a, -d) ➔ উইন্ডো [3..4] = \"ba\" হুবহু মিলেছে! 🎉",
        "descEn": "'ba' is a valid permutation of 'ab'. Return TRUE!",
        "descBn": "'ba' হলো 'ab' এর একটি বৈধ্য পারমিউটেশন। TRUE রিটার্ন করুন!",
      },
    ];

    final currentStep = stepFlowData[_flowStepIndex.clamp(0, stepFlowData.length - 1)];
    final String window = currentStep["window"] as String;
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
                _isEnglish ? "1. Step-by-Step Permutation Matching Flowcard" : "১. স্টেপ-বাই-স্টেপ পারমিউটেশন ম্যাচিং ফ্লো-কার্ড",
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
                ? "Watch fixed window sliding and permutation match discovery."
                : "ফিক্সড উইন্ডো স্লাইডিং এবং পারমিউটেশন ম্যাচ ডিসকভারি দেখুন।",
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

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Window = $window", style: TextStyle(color: badgeColor, fontWeight: FontWeight.bold, fontSize: 12)),
                    Text("Target s1 = '$_s1'", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
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
                    "Sub-window: \"$window\"",
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

  // MODEL 2: Frequency Comparison Rule
  Widget _buildFrequencyComparisonModel() {
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
            _isEnglish ? "2. Frequency Matching Rule" : "২. ফ্রিকোয়েন্সি ম্যাচিং নীতি",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            _isEnglish
                ? "Compare 26-size frequency arrays of s1 and s2 window:\ns2Freq[s2[i]-'a']++ and s2Freq[s2[i-|s1|]-'a']--"
                : "s1 এবং s2 এর উইন্ডোর ২৬ সাইজের ফ্রিকোয়েন্সি অ্যারে তুলনা করুন:\ns2Freq[s2[i]-'a']++ এবং s2Freq[s2[i-|s1|]-'a']--",
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
              "if (s1Freq == s2Freq) return true; 📊",
              style: TextStyle(fontFamily: 'monospace', fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.accentGreen),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  // MODEL 3: Complexity Calculator
  Widget _buildComplexityCalculatorModel() {
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
            _isEnglish ? "3. O(N2) Time vs O(1) Space Complexity" : "৩. O(N2) টাইম বনাম O(1) স্পেস কমপ্লেক্সিটি",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            _isEnglish
                ? "Brute force generates all N1! permutations ➔ Exponential.\nSliding Window updates 26 counters in O(1) per step ➔ O(N2) linear time total!"
                : "ব্রুট ফোর্স সমস্ত N1! পারমিউটেশন জেনারেট করে ➔ অত্যন্ত ধীর।\nস্লাইডিং উইন্ডো O(1) এ ২৬ কাউন্টার আপডেট করে ➔ সর্বমোট O(N2) লিনিয়ার সময়!",
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, height: 1.4),
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
              "Time Complexity: O(N2)\nSpace Complexity: O(1) (26 counters) 🎉",
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
                      flex: 1,
                      child: TextField(
                        controller: _s1Controller,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          labelText: _isEnglish ? "s1 (e.g. ab)" : "s1 (যেমন ab)",
                          labelStyle: const TextStyle(color: AppTheme.accentNeonCyan, fontSize: 12),
                          filled: true,
                          fillColor: const Color(0xFF090D16),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: _s2Controller,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          labelText: _isEnglish ? "s2 (e.g. eidbaooo)" : "s2 (যেমন eidbaooo)",
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
                      _buildPresetChip("ab", "eidbaooo"),
                      _buildPresetChip("ab", "eidboaoo"),
                      _buildPresetChip("adc", "dcda"),
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
                  _buildPermutationCanvas(step),
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildCodeHighlightBox(step.activeLine)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildPermutationCanvas(step)),
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
    final expectedResult = _checkInclusion(_s1, _s2);

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
                  ? "Inspect window of size |s1| = ${_s1.length} and determine if it is a valid permutation of '$_s1'!"
                  : "s2 তে |s1| = ${_s1.length} সাইজের উইন্ডো দেখে '$_s1' এর বৈধ্য পারমিউটেশন কিনা সিদ্ধান্ত নিন!",
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
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

            // Active Practice Window Box
            if (!_practiceSolved && _practiceLeft + _s1.length <= _s2.length)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
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
                        Text("Inspecting Start Index: [$_practiceLeft]", style: const TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 12)),
                        Text("Expected Result: ${expectedResult ? 'TRUE' : 'FALSE'}", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Window: \"${_s2.substring(_practiceLeft, _practiceLeft + _s1.length)}\" (Target s1: \"$_s1\")",
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accentGreen,
                            foregroundColor: AppTheme.primaryDark,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          ),
                          icon: const Icon(Icons.check_circle),
                          label: Text(_isEnglish ? "PERMUTATION (Match)" : "পারমিউটেশন (মিলেছে)"),
                          onPressed: () => _handlePracticeCheckWindow(true),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accentPink,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          ),
                          icon: const Icon(Icons.cancel),
                          label: Text(_isEnglish ? "NOT Permutation" : "পারমিউটেশন নয়"),
                          onPressed: () => _handlePracticeCheckWindow(false),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 12),
            if (_practiceLeft > 0 || _practiceSolved)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  icon: const Icon(Icons.undo, size: 16, color: AppTheme.accentAmber),
                  label: Text(_isEnglish ? "Reset State" : "রিসেট", style: const TextStyle(color: AppTheme.accentAmber, fontSize: 12)),
                  onPressed: _undoPracticeMove,
                ),
              ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // Helper Widgets
  Widget _buildPresetChip(String s1Val, String s2Val) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ActionChip(
        backgroundColor: const Color(0xFF090D16),
        label: Text("s1='$s1Val', s2='$s2Val'", style: const TextStyle(color: AppTheme.accentNeonCyan, fontSize: 11)),
        onPressed: () {
          _s1Controller.text = s1Val;
          _s2Controller.text = s2Val;
          _rebuildSteps();
        },
      ),
    );
  }

  Widget _buildCodeHighlightBox(int activeLine) {
    final codeLines = [
      "bool checkInclusion(string s1, string s2) {",
      "    int n1 = s1.size(), n2 = s2.size();",
      "    if (n1 > n2) return false;",
      "    vector<int> s1Freq(26, 0), s2Freq(26, 0);",
      "    for (int i = 0; i < n1; i++) { s1Freq[s1[i]-'a']++; s2Freq[s2[i]-'a']++; }",
      "    if (s1Freq == s2Freq) return true;",
      "    for (int i = n1; i < n2; i++) {",
      "        s2Freq[s2[i]-'a']++; s2Freq[s2[i-n1]-'a']--;",
      "        if (s1Freq == s2Freq) return true;",
      "    }",
      "    return false;",
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

  Widget _buildPermutationCanvas(PermutationInStringStep step) {
    Color decisionColor = AppTheme.accentPurple;
    String decisionLabel = "INIT";

    if (step.decision == "build_first_window") {
      decisionColor = AppTheme.accentNeonCyan;
      decisionLabel = "🪟 BUILD WINDOW";
    } else if (step.decision == "slide_window") {
      decisionColor = AppTheme.accentAmber;
      decisionLabel = "➡️ SLIDE WINDOW";
    } else if (step.decision == "permutation_found") {
      decisionColor = AppTheme.accentGreen;
      decisionLabel = "🎉 PERMUTATION FOUND";
    } else if (step.decision == "finished_false") {
      decisionColor = AppTheme.accentPink;
      decisionLabel = "❌ NO MATCH";
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
              Text("Window: [${step.left}..${step.right}] (|s1| = ${_s1.length})", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13)),
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

          // Window Substring & Match Box
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Window Substring = \"${step.windowSub}\"", style: TextStyle(color: decisionColor, fontWeight: FontWeight.bold, fontSize: 12)),
              Text("Target s1 = \"$_s1\"", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
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
            child: Column(
              children: [
                Text(
                  step.isPermutation ? "Result = TRUE 🎉" : "Result = Searching...",
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: decisionColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  "Sub-window: \"${step.windowSub}\"",
                  style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Visual String Canvas
          const Text("String s2 Sequence Canvas:", style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_s2.length, (idx) {
                bool inWindow = idx >= step.left && idx <= step.right;

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: inWindow ? decisionColor.withOpacity(0.3) : AppTheme.surfaceDark,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: inWindow ? decisionColor : const Color(0xFF334155),
                      width: inWindow ? 2.0 : 1.0,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        _s2[idx],
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: inWindow ? Colors.white : const Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "[$idx]",
                        style: const TextStyle(fontSize: 9, color: Color(0xFF64748B)),
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
    bool checkInclusion(string s1, string s2) {
        int n1 = s1.size(), n2 = s2.size();
        if (n1 > n2) return false;

        vector<int> s1Freq(26, 0), s2Freq(26, 0);
        for (int i = 0; i < n1; i++) {
            s1Freq[s1[i] - 'a']++;
            s2Freq[s2[i] - 'a']++;
        }

        if (s1Freq == s2Freq) return true;

        for (int i = n1; i < n2; i++) {
            s2Freq[s2[i] - 'a']++;
            s2Freq[s2[i - n1] - 'a']--;
            if (s1Freq == s2Freq) return true;
        }
        return false;
    }
};""";
    } else if (lang == "Java") {
      code = """
class Solution {
    public boolean checkInclusion(String s1, String s2) {
        int n1 = s1.length(), n2 = s2.length();
        if (n1 > n2) return false;

        int[] s1Freq = new int[26];
        int[] s2Freq = new int[26];

        for (int i = 0; i < n1; i++) {
            s1Freq[s1.charAt(i) - 'a']++;
            s2Freq[s2.charAt(i) - 'a']++;
        }

        if (Arrays.equals(s1Freq, s2Freq)) return true;

        for (int i = n1; i < n2; i++) {
            s2Freq[s2.charAt(i) - 'a']++;
            s2Freq[s2.charAt(i - n1) - 'a']--;
            if (Arrays.equals(s1Freq, s2Freq)) return true;
        }
        return false;
    }
}""";
    } else {
      code = """
class Solution:
    def checkInclusion(self, s1: str, s2: str) -> bool:
        n1, n2 = len(s1), len(s2)
        if n1 > n2:
            return False

        s1_count = Counter(s1)
        s2_count = Counter(s2[:n1])

        if s1_count == s2_count:
            return True

        for i in range(n1, n2):
            s2_count[s2[i]] += 1
            s2_count[s2[i - n1]] -= 1
            if s2_count[s2[i - n1]] == 0:
                del s2_count[s2[i - n1]]

            if s1_count == s2_count:
                return True

        return False""";
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
