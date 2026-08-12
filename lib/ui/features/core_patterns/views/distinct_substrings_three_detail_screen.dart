import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class DistinctSubstringsThreeStep {
  final int index;
  final String windowSubstring;
  final bool isGood;
  final int goodCount;
  final String decision; // 'init', 'good_found', 'not_good', 'finished'
  final int activeLine;
  final String actionEn;
  final String actionBn;
  final String reasonEn;
  final String reasonBn;

  const DistinctSubstringsThreeStep({
    required this.index,
    required this.windowSubstring,
    required this.isGood,
    required this.goodCount,
    required this.decision,
    required this.activeLine,
    required this.actionEn,
    required this.actionBn,
    required this.reasonEn,
    required this.reasonBn,
  });
}

class DistinctSubstringsThreeDetailScreen extends StatefulWidget {
  const DistinctSubstringsThreeDetailScreen({super.key});

  @override
  State<DistinctSubstringsThreeDetailScreen> createState() => _DistinctSubstringsThreeDetailScreenState();
}

class _DistinctSubstringsThreeDetailScreenState extends State<DistinctSubstringsThreeDetailScreen>
    with SingleTickerProviderStateMixin {
  bool _isEnglish = true;
  late TabController _tabController;

  // Custom Input State
  final TextEditingController _sController = TextEditingController(text: "xyzzaz");
  String _s = "xyzzaz";
  List<DistinctSubstringsThreeStep> _steps = [];

  // Playback Control
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  // Code Language Selector
  String _selectedCodeLang = "C++";

  // Tab 2 Animation Model Selector (0: Step Flowcard, 1: Uniqueness Filter Rule, 2: Complexity Calculator)
  int _animationModelIndex = 0;
  int _flowStepIndex = 0;

  // Practice Mode State
  int _practiceIndex = 0;
  int _practiceUserGoodCount = 0;
  String _userFeedbackEn = "Inspect 3-character windows and count all good substrings with distinct characters!";
  String _userFeedbackBn = "৩ ক্যারেক্টারের উইন্ডো দেখে সমস্ত ইউনিক গুড সাব-স্ট্রিং গণনা করুন!";
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

    String text = _sController.text.trim();
    if (text.isEmpty) text = "xyzzaz";
    _s = text;

    _steps = _generateSteps(_s);

    // Reset practice mode
    _resetPractice();
  }

  void _resetPractice() {
    _practiceIndex = 0;
    _practiceUserGoodCount = 0;
    _practiceSolved = false;
    _userFeedbackEn = "Inspect 3-character window starting at index 0!";
    _userFeedbackBn = "ইনডেক্স ০ থেকে শুরু হওয়া ৩ ক্যারেক্টারের উইন্ডো পরীক্ষা করুন!";
  }

  List<DistinctSubstringsThreeStep> _generateSteps(String inputStr) {
    List<DistinctSubstringsThreeStep> steps = [];
    int n = inputStr.length;

    // Step 0: Init
    steps.add(DistinctSubstringsThreeStep(
      index: 0,
      windowSubstring: "",
      isGood: false,
      goodCount: 0,
      decision: "init",
      activeLine: 1,
      actionEn: "Line 1: Initialize Sliding Window for string s = '$inputStr', K = 3.",
      actionBn: "লাইন ১: স্ট্রিং s = '$inputStr', K = 3 এর জন্য স্লাইডিং উইন্ডো শুরু।",
      reasonEn: "We check every contiguous 3-character window for unique characters.",
      reasonBn: "প্রতিটি পর পর ৩ ক্যারেক্টারের উইন্ডোতে সবগুলো অক্ষর আলাদা কিনা চেক করা হবে।",
    ));

    if (n < 3) {
      steps.add(DistinctSubstringsThreeStep(
        index: 0,
        windowSubstring: inputStr,
        isGood: false,
        goodCount: 0,
        decision: "finished",
        activeLine: 2,
        actionEn: "🏁 Line 2: String length < 3. Return 0 good substrings.",
        actionBn: "🏁 লাইন ২: স্ট্রিং দৈর্ঘ্য < 3। 0 গুড সাব-স্ট্রিং রিটার্ন করুন।",
        reasonEn: "String must be at least 3 characters long.",
        reasonBn: "স্ট্রিংয়ের দৈর্ঘ্য অন্তত ৩ হতে হবে।",
      ));
      return steps;
    }

    int goodCount = 0;

    for (int i = 0; i <= n - 3; i++) {
      String sub = inputStr.substring(i, i + 3);
      String a = sub[0];
      String b = sub[1];
      String c = sub[2];
      bool isGood = (a != b && b != c && a != c);

      if (isGood) {
        goodCount++;
        steps.add(DistinctSubstringsThreeStep(
          index: i,
          windowSubstring: sub,
          isGood: true,
          goodCount: goodCount,
          decision: "good_found",
          activeLine: 5,
          actionEn: "🎉 Line 5: Window [$i..${i + 2}] '$sub' has ALL UNIQUE characters! Good Substrings = $goodCount.",
          actionBn: "🎉 লাইন ৫: উইন্ডো [$i..${i + 2}] '$sub' এর প্রতিটি অক্ষর আলাদা! গুড সাব-স্ট্রিং = $goodCount।",
          reasonEn: "All 3 characters '$a', '$b', '$c' are distinct.",
          reasonBn: "৩টি অক্ষর '$a', '$b', '$c' সম্পূর্ণ অনন্য।",
        ));
      } else {
        steps.add(DistinctSubstringsThreeStep(
          index: i,
          windowSubstring: sub,
          isGood: false,
          goodCount: goodCount,
          decision: "not_good",
          activeLine: 6,
          actionEn: "❌ Line 6: Window [$i..${i + 2}] '$sub' contains duplicate characters. Skip.",
          actionBn: "❌ লাইন ৬: উইন্ডো [$i..${i + 2}] '$sub' এ ডুপ্লিকেট অক্ষর রয়েছে। এড়িয়ে চলুন।",
          reasonEn: "Window contains repeated characters.",
          reasonBn: "উইন্ডোতে একই অক্ষর বারবার রয়েছে।",
        ));
      }
    }

    steps.add(DistinctSubstringsThreeStep(
      index: n - 3,
      windowSubstring: inputStr.substring(n - 3),
      isGood: false,
      goodCount: goodCount,
      decision: "finished",
      activeLine: 8,
      actionEn: "🏁 Line 8: Traversal Complete! Total Good Substrings of Size 3 = $goodCount.",
      actionBn: "🏁 লাইন ৮: স্ক্যান সম্পূর্ণ! ৩ সাইজের সর্বমোট গুড সাব-স্ট্রিং = $goodCount।",
      reasonEn: "Scanned all contiguous substrings of length 3 in O(N) linear time.",
      reasonBn: "O(N) লিনিয়ার সময়ে ৩ দৈর্ঘ্যের সমস্ত সাব-স্ট্রিং স্ক্যান সম্পন্ন।",
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

  int _countGoodSubstrings(String str) {
    int cnt = 0;
    for (int i = 0; i <= str.length - 3; i++) {
      if (str[i] != str[i + 1] && str[i + 1] != str[i + 2] && str[i] != str[i + 2]) {
        cnt++;
      }
    }
    return cnt;
  }

  void _handlePracticeAnswer(bool userClaimGood) {
    if (_practiceSolved || _practiceIndex > _s.length - 3) return;
    String sub = _s.substring(_practiceIndex, _practiceIndex + 3);
    bool actualGood = (sub[0] != sub[1] && sub[1] != sub[2] && sub[0] != sub[2]);

    setState(() {
      if (userClaimGood == actualGood) {
        if (actualGood) _practiceUserGoodCount++;

        _practiceIndex++;
        if (_practiceIndex > _s.length - 3) {
          _practiceSolved = true;
          _userFeedbackEn = "🏆 MASTERED! You correctly identified all good substrings! Total Good = $_practiceUserGoodCount!";
          _userFeedbackBn = "🏆 দারুণ! আপনি নিখুঁতভাবে সমস্ত গুড সাব-স্ট্রিং শনাক্ত করেছেন! সর্বমোট = $_practiceUserGoodCount!";
        } else {
          _userFeedbackEn = "Correct! '$sub' is ${actualGood ? 'GOOD' : 'NOT GOOD'}. Next: Inspect window starting at index $_practiceIndex.";
          _userFeedbackBn = "সঠিক! '$sub' হলো ${actualGood ? 'গুড' : 'নট গুড'}। পরের: ইনডেক্স $_practiceIndex থেকে শুরু হওয়া উইন্ডো পরীক্ষা করুন।";
        }
      } else {
        _userFeedbackEn = "Incorrect! Substring '$sub' is ${actualGood ? 'GOOD (all unique)' : 'NOT GOOD (duplicates exist)'}. Try again!";
        _userFeedbackBn = "ভুল উত্তর! সাব-স্ট্রিং '$sub' হলো ${actualGood ? 'গুড (সবগুলো আলাদা)' : 'নট গুড (ডুপ্লিকেট রয়েছে)'}। আবার চেষ্টা করুন!";
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
          '1876. Substrings of Size Three with Distinct Characters',
          style: TextStyle(fontSize: Responsive.sp(context, 16), fontWeight: FontWeight.bold),
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
                    "1876. Substrings of Size Three with Distinct Characters",
                    style: TextStyle(fontSize: Responsive.sp(context, 20), fontWeight: FontWeight.bold, color: Colors.white),
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
              children: ["Google", "Amazon"].map((company) {
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
                        ? "A string is good if there are no repeated characters. Given a string s, return the number of good substrings of length three in s."
                        : "একটি স্ট্রিং s দেওয়া আছে। ৩ দৈর্ঘ্যের এমন কতটি সাব-স্ট্রিং আছে যার সবগুলো অক্ষর ইউনিক (অনন্য/আলাদা)?",
                    style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Examples
            Text(_isEnglish ? "Examples" : "উদাহরণসমূহ", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            _buildExampleCard("Example 1", "s = \"xyzzaz\"", "Output: 1 (Good substring: \"xyz\")"),
            _buildExampleCard("Example 2", "s = \"aababcabc\"", "Output: 4 (Good substrings: \"abc\", \"bca\", \"cab\", \"abc\")"),
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
                        _isEnglish ? "Key Intuition (Fixed Window K = 3 Uniqueness Check)" : "মূল আইডিয়া (ফিক্সড K = 3 উইন্ডো ইউনিকনেস চেক)",
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isEnglish
                        ? "1. Iterate through all contiguous 3-character windows s[i..i+2].\n2. Check s[i] != s[i+1] && s[i+1] != s[i+2] && s[i] != s[i+2].\n3. Increment count if all 3 characters are distinct in O(N) linear time."
                        : "১. ৩ ক্যারেক্টারের সমস্ত পর পর উইন্ডো s[i..i+2] লুপ করুন।\n২. s[i] != s[i+1] && s[i+1] != s[i+2] && s[i] != s[i+2] চেক করুন।\n৩. প্রতিটি ৩টি অক্ষর আলাদা হলে কাউন্ট ১ বাড়ান।",
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
              _isEnglish ? "Distinct Substrings of Size 3 Visual Models" : "৩ সাইজের ইউনিক সাব-স্ট্রিং ভিজ্যুয়াল মডেলসমূহ (কোডহীন গাইড)",
              style: TextStyle(fontSize: Responsive.sp(context, 18), fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 6),
            Text(
              _isEnglish
                  ? "Explore 3 interactive models for s = \"xyzzaz\", K = 3."
                  : "s = \"xyzzaz\", K = 3 এর জন্য ৩টি ইন্টারঅ্যাক্টিভ ভিজ্যুয়াল মডেল পর্যবেক্ষণ করুন।",
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 16),

            // Model Switcher Segmented Control
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildAnimationModelChip(0, _isEnglish ? "1. 🪜 Step Flowcard" : "১. 🪜 স্টেপ-বাই-স্টেপ ফ্লো-কার্ড"),
                  _buildAnimationModelChip(1, _isEnglish ? "2. 🔍 Uniqueness Filter" : "২. 🔍 ইউনিকনেস ফিল্টার নীতি"),
                  _buildAnimationModelChip(2, _isEnglish ? "3. 📊 Complexity Calculator" : "৩. 📊 টাইমিং ক্যালকুলেটর"),
                ],
              ),
            ),
            const SizedBox(height: 20),

            if (_animationModelIndex == 0) _buildStepFlowcardModel(),
            if (_animationModelIndex == 1) _buildUniquenessFilterModel(),
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
        "window": "\"xyz\"",
        "isGood": true,
        "count": 1,
        "badge": "🎉 GOOD SUBSTRING",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 1: Window [0..2] = \"xyz\" ➔ All 3 characters unique!",
        "titleBn": "ধাপ ১: উইন্ডো [0..2] = \"xyz\" ➔ ৩টি অক্ষরই আলাদা!",
        "descEn": "'x' != 'y' != 'z'. Good Substring Count = 1.",
        "descBn": "'x' != 'y' != 'z'। গুড সাব-স্ট্রিং গণনা = ১।",
      },
      {
        "step": 2,
        "window": "\"yzz\"",
        "isGood": false,
        "count": 1,
        "badge": "❌ DUPLICATE 'z'",
        "badgeColor": AppTheme.accentPink,
        "titleEn": "Step 2: Window [1..3] = \"yzz\" ➔ Contains duplicate 'z'.",
        "titleBn": "ধাপ ২: উইন্ডো [1..3] = \"yzz\" ➔ ডুপ্লিকেট 'z' বিদ্যমান।",
        "descEn": "'z' is repeated. Not a good substring.",
        "descBn": "'z' অক্ষরটি দুইবার রয়েছে। এটি গুড সাব-স্ট্রিং নয়।",
      },
      {
        "step": 3,
        "window": "\"zza\"",
        "isGood": false,
        "count": 1,
        "badge": "❌ DUPLICATE 'z'",
        "badgeColor": AppTheme.accentPink,
        "titleEn": "Step 3: Window [2..4] = \"zza\" ➔ Contains duplicate 'z'.",
        "titleBn": "ধাপ ৩: উইন্ডো [2..4] = \"zza\" ➔ ডুপ্লিকেট 'z' বিদ্যমান।",
        "descEn": "'z' is repeated. Not a good substring.",
        "descBn": "'z' অক্ষরটি দুইবার রয়েছে। এটি গুড সাব-স্ট্রিং নয়।",
      },
      {
        "step": 4,
        "window": "\"zaz\"",
        "isGood": false,
        "count": 1,
        "badge": "🏁 COMPLETE",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 4: Window [3..5] = \"zaz\" ➔ Contains duplicate 'z'.",
        "titleBn": "ধাপ ৪: উইন্ডো [3..5] = \"zaz\" ➔ ডুপ্লিকেট 'z' বিদ্যমান।",
        "descEn": "All windows evaluated. Total Good Substrings = 1! 🎉",
        "descBn": "সমস্ত উইন্ডো মূল্যায়ন সম্পন্ন। সর্বমোট গুড সাব-স্ট্রিং = ১! 🎉",
      },
    ];

    final currentStep = stepFlowData[_flowStepIndex.clamp(0, stepFlowData.length - 1)];
    final String window = currentStep["window"] as String;
    final int count = currentStep["count"] as int;
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
                _isEnglish ? "1. Step-by-Step Window Uniqueness Flowcard" : "১. স্টেপ-বাই-স্টেপ উইন্ডো ইউনিকনেস ফ্লো-কার্ড",
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
                ? "Watch fixed 3-character window sliding and uniqueness verification."
                : "ফিক্সড ৩-ক্যারেক্টার উইন্ডো স্লাইডিং এবং ইউনিকনেস ভেরিফিকেশন দেখুন।",
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
                    Text("Good Count = $count", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
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
                    "Window: \"$window\"",
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

  // MODEL 2: Uniqueness Filter Rule
  Widget _buildUniquenessFilterModel() {
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
            _isEnglish ? "2. 3-Character Uniqueness Verification Rule" : "২. ৩-ক্যারেক্টার ইউনিকনেস ভেরিফিকেশন নীতি",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            _isEnglish
                ? "For a 3-character substring s[i..i+2] = (a, b, c):\nCheck: a != b && b != c && a != c"
                : "৩-ক্যারেক্টারের সাব-স্ট্রিং s[i..i+2] = (a, b, c) এর জন্য:\nচেক করুন: a != b && b != c && a != c",
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
              "if (s[i] != s[i+1] && s[i+1] != s[i+2] && s[i] != s[i+2]) count++; 🔍",
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
            _isEnglish ? "3. O(N) Linear Time & O(1) Space Complexity" : "৩. O(N) লিনিয়ার টাইম এবং O(1) স্পেস কমপ্লেক্সিটি",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            _isEnglish
                ? "Since window size K = 3 is fixed, checking each window takes 3 comparisons = O(1).\nScanning N-2 windows total takes linear O(N) time."
                : "যেহেতু উইন্ডো সাইজ K = 3 ফিক্সড, প্রতিটি ঘর চেক করতে মাত্র ৩টি তুলনা লাগে = O(1)।\nN-2 টি উইন্ডো চেক করতে সর্বমোট লিনিয়ার O(N) সময় লাগে।",
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
              "Time Complexity: O(N)\nSpace Complexity: O(1) 🎉",
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
                          labelText: _isEnglish ? "String s (e.g. xyzzaz)" : "স্ট্রিং s (যেমন xyzzaz)",
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
                      _buildPresetChip("xyzzaz"),
                      _buildPresetChip("aababcabc"),
                      _buildPresetChip("owuxo"),
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
                  _buildWindowCanvas(step),
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildCodeHighlightBox(step.activeLine)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildWindowCanvas(step)),
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
    final targetGood = _countGoodSubstrings(_s);

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
                  ? "Inspect each 3-character window and decide if all characters are unique (Good Substring)!"
                  : "প্রতিটি ৩-ক্যারেক্টারের উইন্ডো দেখে সবগুলো অক্ষর আলাদা কিনা (গুড সাব-স্ট্রিং) সিদ্ধান্ত নিন!",
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

            // Active Window Card
            if (!_practiceSolved && _practiceIndex <= _s.length - 3)
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
                        Text("Inspecting Window [$_practiceIndex..${_practiceIndex + 2}]", style: const TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 12)),
                        Text("Good Found: $_practiceUserGoodCount / $targetGood", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "\"${_s.substring(_practiceIndex, _practiceIndex + 3)}\"",
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 22,
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
                          label: Text(_isEnglish ? "GOOD (All 3 Unique)" : "গুড (৩টিই আলাদা)"),
                          onPressed: () => _handlePracticeAnswer(true),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accentPink,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          ),
                          icon: const Icon(Icons.cancel),
                          label: Text(_isEnglish ? "NOT GOOD (Has Duplicates)" : "নট গুড (ডুপ্লিকেট আছে)"),
                          onPressed: () => _handlePracticeAnswer(false),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 12),
            if (_practiceIndex > 0 || _practiceSolved)
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
  Widget _buildPresetChip(String sVal) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ActionChip(
        backgroundColor: const Color(0xFF090D16),
        label: Text("'$sVal'", style: const TextStyle(color: AppTheme.accentNeonCyan, fontSize: 11)),
        onPressed: () {
          _sController.text = sVal;
          _rebuildSteps();
        },
      ),
    );
  }

  Widget _buildCodeHighlightBox(int activeLine) {
    final codeLines = [
      "int countGoodSubstrings(string s) {",
      "    if (s.length() < 3) return 0;",
      "    int count = 0;",
      "    for (int i = 0; i <= s.length() - 3; i++) {",
      "        if (s[i] != s[i+1] && s[i+1] != s[i+2] && s[i] != s[i+2])",
      "            count++;",
      "    }",
      "    return count;",
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

  Widget _buildWindowCanvas(DistinctSubstringsThreeStep step) {
    Color decisionColor = AppTheme.accentPurple;
    String decisionLabel = "INIT";

    if (step.decision == "good_found") {
      decisionColor = AppTheme.accentGreen;
      decisionLabel = "🎉 GOOD SUBSTRING";
    } else if (step.decision == "not_good") {
      decisionColor = AppTheme.accentPink;
      decisionLabel = "❌ DUPLICATE CHAR";
    } else if (step.decision == "finished") {
      decisionColor = AppTheme.accentGreen;
      decisionLabel = "🏁 FINISHED";
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
              Text("Window: [${step.index}..${step.index + 2}]", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13)),
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

          // Substring & Good Counter Box
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Substring = \"${step.windowSubstring}\"", style: TextStyle(color: decisionColor, fontWeight: FontWeight.bold, fontSize: 12)),
              Text("Good Count = ${step.goodCount}", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
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
                  "Total Good Substrings = ${step.goodCount}",
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
                  "Active Window: \"${step.windowSubstring}\"",
                  style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Visual String Canvas
          const Text("String Characters Sequence Canvas:", style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_s.length, (idx) {
                bool inWindow = idx >= step.index && idx <= step.index + 2;

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
                        _s[idx],
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
    int countGoodSubstrings(string s) {
        if (s.length() < 3) return 0;
        int count = 0;
        for (int i = 0; i <= s.length() - 3; i++) {
            if (s[i] != s[i+1] && s[i+1] != s[i+2] && s[i] != s[i+2]) {
                count++;
            }
        }
        return count;
    }
};""";
    } else if (lang == "Java") {
      code = """
class Solution {
    public int countGoodSubstrings(String s) {
        if (s.length() < 3) return 0;
        int count = 0;
        for (int i = 0; i <= s.length() - 3; i++) {
            char a = s.charAt(i), b = s.charAt(i+1), c = s.charAt(i+2);
            if (a != b && b != c && a != c) {
                count++;
            }
        }
        return count;
    }
}""";
    } else {
      code = """
class Solution:
    def countGoodSubstrings(self, s: str) -> int:
        if len(s) < 3:
            return 0
        count = 0
        for i in range(len(s) - 2):
            if len(set(s[i:i+3])) == 3:
                count += 1
        return count""";
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
