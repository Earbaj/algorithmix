import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class LongestSubstringStep {
  final int left;
  final int right;
  final String windowSub;
  final String duplicateChar;
  final int duplicateLastIndex;
  final int maxLength;
  final String longestSub;
  final String decision; // 'init', 'expand', 'duplicate_jump', 'max_updated', 'finished'
  final int activeLine;
  final String actionEn;
  final String actionBn;
  final String reasonEn;
  final String reasonBn;

  const LongestSubstringStep({
    required this.left,
    required this.right,
    required this.windowSub,
    required this.duplicateChar,
    required this.duplicateLastIndex,
    required this.maxLength,
    required this.longestSub,
    required this.decision,
    required this.activeLine,
    required this.actionEn,
    required this.actionBn,
    required this.reasonEn,
    required this.reasonBn,
  });
}

class LongestSubstringWithoutRepeatingDetailScreen extends StatefulWidget {
  const LongestSubstringWithoutRepeatingDetailScreen({super.key});

  @override
  State<LongestSubstringWithoutRepeatingDetailScreen> createState() =>
      _LongestSubstringWithoutRepeatingDetailScreenState();
}

class _LongestSubstringWithoutRepeatingDetailScreenState
    extends State<LongestSubstringWithoutRepeatingDetailScreen>
    with SingleTickerProviderStateMixin {
  bool _isEnglish = true;
  late TabController _tabController;

  // Custom Input State
  final TextEditingController _sController = TextEditingController(text: "abcabcbb");
  String _s = "abcabcbb";
  List<LongestSubstringStep> _steps = [];

  // Playback Control
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  // Code Language Selector
  String _selectedCodeLang = "C++";

  // Tab 2 Animation Model Selector (0: Step Flowcard, 1: Pointer Jump Rule, 2: Complexity Calculator)
  int _animationModelIndex = 0;
  int _flowStepIndex = 0;

  // Practice Mode State
  int _practiceRight = 0;
  int _practiceLeft = 0;
  int _practiceMaxLen = 0;
  String _userFeedbackEn = "Expand right pointer and handle duplicate character jumps!";
  String _userFeedbackBn = "ডান পয়েন্টার বাড়িয়ে ডুপ্লিকেট অক্ষরের জ্যাম্প চিহ্নিত করুন!";
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

    String textS = _sController.text.trim();
    if (textS.isEmpty) textS = "abcabcbb";
    _s = textS;

    _steps = _generateSteps(_s);

    // Reset practice mode
    _resetPractice();
  }

  void _resetPractice() {
    _practiceLeft = 0;
    _practiceRight = 0;
    _practiceMaxLen = 0;
    _practiceSolved = false;
    _userFeedbackEn = "Inspect character at right = 0 ('${_s.isNotEmpty ? _s[0] : ''}')!";
    _userFeedbackBn = "ইনডেক্স right = 0 ('${_s.isNotEmpty ? _s[0] : ''}') এর অক্ষরটি পরীক্ষা করুন!";
  }

  List<LongestSubstringStep> _generateSteps(String sStr) {
    List<LongestSubstringStep> steps = [];
    int n = sStr.length;

    // Step 0: Init
    steps.add(LongestSubstringStep(
      left: 0,
      right: 0,
      windowSub: n > 0 ? sStr.substring(0, 1) : "",
      duplicateChar: "",
      duplicateLastIndex: -1,
      maxLength: 0,
      longestSub: "",
      decision: "init",
      activeLine: 1,
      actionEn: "Line 1: Initialize Dynamic Sliding Window for s = '$sStr'.",
      actionBn: "লাইন ১: s = '$sStr' এর জন্য ডাইনামিক স্লাইডিং উইন্ডো শুরু।",
      reasonEn: "Maintain left pointer, last seen index map for 256 ASCII chars, and max length counter.",
      reasonBn: "বাম পয়েন্টার, ২৫৬ ASCII অক্ষরের লাস্ট-ইনডেক্স ম্যাপ এবং ম্যাক্সিমাম লেন্থ কাউন্টার বজায় রাখা হবে।",
    ));

    if (n == 0) {
      steps.add(const LongestSubstringStep(
        left: 0,
        right: 0,
        windowSub: "",
        duplicateChar: "",
        duplicateLastIndex: -1,
        maxLength: 0,
        longestSub: "",
        decision: "finished",
        activeLine: 2,
        actionEn: "🏁 Line 2: Empty String s! Return Max Length = 0.",
        actionBn: "🏁 লাইন ২: খালি স্ট্রিং s! সর্বমোট দৈর্ঘ্য = 0।",
        reasonEn: "Empty string has no substrings.",
        reasonBn: "খালি স্ট্রিংয়ের কোনো সাব-স্ট্রিং নেই।",
      ));
      return steps;
    }

    List<int> lastIndex = List.filled(256, -1);
    int l = 0;
    int maxLen = 0;
    String longestSub = "";

    for (int r = 0; r < n; r++) {
      int charCode = sStr.codeUnitAt(r);
      String c = sStr[r];

      bool isDuplicate = lastIndex[charCode] >= l;
      int prevIdx = lastIndex[charCode];

      if (isDuplicate) {
        l = lastIndex[charCode] + 1;
        steps.add(LongestSubstringStep(
          left: l,
          right: r,
          windowSub: sStr.substring(l, r + 1),
          duplicateChar: c,
          duplicateLastIndex: prevIdx,
          maxLength: maxLen,
          longestSub: longestSub,
          decision: "duplicate_jump",
          activeLine: 6,
          actionEn: "🦘 Line 6: Duplicate '$c' found at index $prevIdx! Jump left pointer to ${prevIdx + 1}.",
          actionBn: "🦘 লাইন ৬: ইনডেক্স $prevIdx এ ডুপ্লিকেট '$c' পাওয়া গেছে! বাম পয়েন্টার ${prevIdx + 1} এ লাফ দিল।",
          reasonEn: "To eliminate repeating character '$c', jump left pointer past its last seen index $prevIdx.",
          reasonBn: "পুনরাবৃত্তি হওয়া অক্ষর '$c' দূর করতে বাম পয়েন্টার আগের ইনডেক্স $prevIdx অতিক্রম করে লাফ দিল।",
        ));
      }

      lastIndex[charCode] = r;
      int curLen = r - l + 1;

      if (curLen > maxLen) {
        maxLen = curLen;
        longestSub = sStr.substring(l, r + 1);
        steps.add(LongestSubstringStep(
          left: l,
          right: r,
          windowSub: sStr.substring(l, r + 1),
          duplicateChar: isDuplicate ? c : "",
          duplicateLastIndex: isDuplicate ? prevIdx : -1,
          maxLength: maxLen,
          longestSub: longestSub,
          decision: "max_updated",
          activeLine: 8,
          actionEn: "🎉 Line 8: NEW Max Substring Found! Window [${l}..${r}] '$longestSub' ➔ Length = $maxLen!",
          actionBn: "🎉 লাইন ৮: নতুন সর্বোচ্চ সাব-স্ট্রিং পাওয়া গেছে! উইন্ডো [${l}..${r}] '$longestSub' ➔ দৈর্ঘ্য = $maxLen!",
          reasonEn: "Current unique substring length $curLen exceeds previous max length. Update maxLen!",
          reasonBn: "বর্তমান ইউনিক সাব-স্ট্রিং এর দৈর্ঘ্য $curLen পূর্বের সর্বোচ্চ দৈর্ঘ্য ছাড়িয়ে গেছে। maxLen আপডেট করুন!",
        ));
      } else {
        steps.add(LongestSubstringStep(
          left: l,
          right: r,
          windowSub: sStr.substring(l, r + 1),
          duplicateChar: isDuplicate ? c : "",
          duplicateLastIndex: isDuplicate ? prevIdx : -1,
          maxLength: maxLen,
          longestSub: longestSub,
          decision: "expand",
          activeLine: 7,
          actionEn: "➡️ Line 7: Expand right to index $r ('$c') ➔ Window [${l}..${r}] '${sStr.substring(l, r + 1)}' (Length = $curLen, Max = $maxLen).",
          actionBn: "➡️ লাইন ৭: ডান পয়েন্টার $r ('$c') এ বাড়ানো হলো ➔ উইন্ডো [${l}..${r}] '${sStr.substring(l, r + 1)}' (দৈর্ঘ্য = $curLen, সর্বমোট = $maxLen)।",
          reasonEn: "Window contains unique characters but length $curLen is <= maxLen $maxLen.",
          reasonBn: "উইন্ডোর সমস্ত অক্ষর ইউনিক হলেও দৈর্ঘ্য $curLen সর্বোচ্চ দৈর্ঘ্য $maxLen এর চেয়ে বড় নয়।",
        ));
      }
    }

    steps.add(LongestSubstringStep(
      left: l,
      right: n - 1,
      windowSub: sStr.substring(l),
      duplicateChar: "",
      duplicateLastIndex: -1,
      maxLength: maxLen,
      longestSub: longestSub,
      decision: "finished",
      activeLine: 10,
      actionEn: "🏁 Line 10: Traversal Complete! Longest Substring Without Repeating Characters = '$longestSub' (Length = $maxLen).",
      actionBn: "🏁 লাইন ১০: স্ক্যান সম্পূর্ণ! অক্ষরের পুনরাবৃত্তি ছাড়া সবচেয়ে দীর্ঘ সাব-স্ট্রিং = '$longestSub' (দৈর্ঘ্য = $maxLen)।",
      reasonEn: "Evaluated string s of length $n in O(N) linear time.",
      reasonBn: "O(N) লিনিয়ার সময়ে $n দৈর্ঘ্যের স্ট্রিং s এর মূল্যায়ন সম্পন্ন।",
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

  int _lengthOfLongestSubstring(String sStr) {
    List<int> lastIndex = List.filled(256, -1);
    int l = 0, maxL = 0;
    for (int r = 0; r < sStr.length; r++) {
      int code = sStr.codeUnitAt(r);
      if (lastIndex[code] >= l) {
        l = lastIndex[code] + 1;
      }
      lastIndex[code] = r;
      maxL = max(maxL, r - l + 1);
    }
    return maxL;
  }

  void _handlePracticeAction(String actionType) {
    if (_practiceSolved || _practiceRight >= _s.length) return;

    List<int> lastIndex = List.filled(256, -1);
    int l = 0, maxL = 0;
    bool expectedJump = false;
    bool expectedMax = false;

    for (int r = 0; r <= _practiceRight; r++) {
      int code = _s.codeUnitAt(r);
      if (lastIndex[code] >= l) {
        if (r == _practiceRight) expectedJump = true;
        l = lastIndex[code] + 1;
      }
      lastIndex[code] = r;
      int curL = r - l + 1;
      if (curL > maxL) {
        if (r == _practiceRight) expectedMax = true;
        maxL = curL;
      }
    }

    String expectedAction = "EXPAND";
    if (expectedJump) expectedAction = "JUMP";
    if (expectedMax) expectedAction = "MAX_UPDATED";

    setState(() {
      if (actionType == expectedAction || (actionType == "EXPAND" && expectedAction == "EXPAND")) {
        _practiceLeft = l;
        _practiceMaxLen = maxL;
        _practiceRight++;

        if (_practiceRight >= _s.length) {
          _practiceSolved = true;
          _userFeedbackEn = "🏆 MASTERED! You correctly tracked all window expansions and jumps! Max Length = $maxL!";
          _userFeedbackBn = "🏆 দারুণ! আপনি সমস্ত উইন্ডো এক্সপ্যানশন এবং জ্যাম্প সঠিকভাবে ট্র্যাক করেছেন! সর্বমোট দৈর্ঘ্য = $maxL!";
        } else {
          _userFeedbackEn = "Correct! Inspecting index $_practiceRight ('${_s[_practiceRight]}'). Select next step action!";
          _userFeedbackBn = "সঠিক! ইনডেক্স $_practiceRight ('${_s[_practiceRight]}') পরীক্ষা করা হচ্ছে। পরের পদক্ষেপ নির্বাচন করুন!";
        }
      } else {
        _userFeedbackEn = "Incorrect! Index ${_practiceRight} ('${_s[_practiceRight]}') requires action: $expectedAction. Try again!";
        _userFeedbackBn = "ভুল উত্তর! ইনডেক্স ${_practiceRight} ('${_s[_practiceRight]}') এর জন্য সঠিক অ্যাকশন হলো: $expectedAction। আবার চেষ্টা করুন!";
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
          '3. Longest Substring Without Repeating Characters',
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
                    "3. Longest Substring Without Repeating Characters",
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
              children: ["Meta", "Amazon", "Google", "Apple"].map((company) {
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
                        ? "Given a string s, find the length of the longest substring without repeating characters."
                        : "একটি স্ট্রিং s দেওয়া আছে। কোনো অক্ষর পুনরাবৃত্তি না করে সবচেয়ে দীর্ঘ সাব-স্ট্রিংয়ের দৈর্ঘ্য (Length) কত তা নির্ণয় করুন।",
                    style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Examples
            Text(_isEnglish ? "Examples" : "উদাহরণসমূহ", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            _buildExampleCard("Example 1", "s = \"abcabcbb\"", "Output: 3 (Longest Substring \"abc\")"),
            _buildExampleCard("Example 2", "s = \"bbbbb\"", "Output: 1 (Longest Substring \"b\")"),
            _buildExampleCard("Example 3", "s = \"pwwkew\"", "Output: 3 (Longest Substring \"wke\")"),
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
                        _isEnglish ? "Key Intuition (Dynamic Window with Index Hash Map)" : "মূল আইডিয়া (ডাইনামিক উইন্ডো ও ইনডেক্স হ্যাশ ম্যাপ)",
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isEnglish
                        ? "1. Expand right pointer one character at a time.\n2. Track last seen index of each character in lastIndex[256].\n3. If duplicate is encountered inside current window, jump left = max(left, lastIndex[char] + 1) in O(1) time.\n4. Single pass O(N) time & O(1) ASCII space complexity."
                        : "১. ডান পয়েন্টার এক এক ঘর করে বাড়ান।\n২. প্রতিটি অক্ষরের আগের ইনডেক্স lastIndex[256] অ্যারেতে রাখুন।\n৩. উইন্ডোর ভেতরে ডুপ্লিকেট অক্ষর পেলে বাম পয়েন্টার লাফ দিয়ে left = max(left, lastIndex[char] + 1) এ পাঠান।\n৪. ১ বার স্ক্যানে O(N) টাইম ও O(1) ASCII স্পেস কমপ্লেক্সিটি।",
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
              _isEnglish ? "Longest Substring Visual Models" : "লংগেস্ট সাব-স্ট্রিং ভিজ্যুয়াল মডেলসমূহ (কোডহীন গাইড)",
              style: TextStyle(fontSize: Responsive.sp(context, 18), fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 6),
            Text(
              _isEnglish
                  ? "Explore 3 interactive models for s = \"abcabcbb\"."
                  : "s = \"abcabcbb\" এর জন্য ৩টি ইন্টারঅ্যাক্টিভ ভিজ্যুয়াল মডেল পর্যবেক্ষণ করুন।",
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 16),

            // Model Switcher Segmented Control
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildAnimationModelChip(0, _isEnglish ? "1. 🪜 Step Flowcard" : "১. 🪜 স্টেপ-বাই-স্টেপ ফ্লো-কার্ড"),
                  _buildAnimationModelChip(1, _isEnglish ? "2. 🦘 Pointer Jump Rule" : "২. 🦘 পয়েন্টার জ্যাম্প নীতি"),
                  _buildAnimationModelChip(2, _isEnglish ? "3. 📊 Complexity Calculator" : "৩. 📊 টাইমিং ক্যালকুলেটর"),
                ],
              ),
            ),
            const SizedBox(height: 20),

            if (_animationModelIndex == 0) _buildStepFlowcardModel(),
            if (_animationModelIndex == 1) _buildPointerJumpRuleModel(),
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
        "window": "\"abc\"",
        "max": 3,
        "badge": "🎉 MAX LENGTH = 3",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 1: Expand [0..2] = \"abc\" ➔ Max Length = 3!",
        "titleBn": "ধাপ ১: উইন্ডো প্রসার [0..2] = \"abc\" ➔ সর্বমোট দৈর্ঘ্য = ৩!",
        "descEn": "'a', 'b', 'c' are unique. Recorded max length = 3.",
        "descBn": "'a', 'b', 'c' সবগুলো অক্ষর ইউনিক। সর্বোচ্চ দৈর্ঘ্য ৩ রেকর্ড করা হলো।",
      },
      {
        "step": 2,
        "window": "\"bca\"",
        "max": 3,
        "badge": "🦘 DUPLICATE JUMP",
        "badgeColor": AppTheme.accentAmber,
        "titleEn": "Step 2: Duplicate 'a' at index 3 ➔ Jump Left to index 1",
        "titleBn": "ধাপ ২: ইনডেক্স ৩ এ ডুপ্লিকেট 'a' ➔ বাম পয়েন্টার ইনডেক্স ১ এ লাফ দিল",
        "descEn": "Jumped left pointer past first 'a' at index 0. Window = 'bca' (Len = 3).",
        "descBn": "ইনডেক্স ০ এর প্রথম 'a' পার করে বাম পয়েন্টার ১ এ এলো। উইন্ডো = 'bca' (দৈর্ঘ্য = ৩)।",
      },
      {
        "step": 3,
        "window": "\"cab\"",
        "max": 3,
        "badge": "🦘 DUPLICATE JUMP",
        "badgeColor": AppTheme.accentAmber,
        "titleEn": "Step 3: Duplicate 'b' at index 4 ➔ Jump Left to index 2",
        "titleBn": "ধাপ ৩: ইনডেক্স ৪ এ ডুপ্লিকেট 'b' ➔ বাম পয়েন্টার ইনডেক্স ২ এ লাফ দিল",
        "descEn": "Jumped left pointer past first 'b' at index 1. Window = 'cab' (Len = 3).",
        "descBn": "ইনডেক্স ১ এর প্রথম 'b' পার করে বাম পয়েন্টার ২ এ এলো। উইন্ডো = 'cab' (দৈর্ঘ্য = ৩)।",
      },
      {
        "step": 4,
        "window": "\"abc\"",
        "max": 3,
        "badge": "🏁 COMPLETE",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 4: All Characters Evaluated! Final Max Substring Length = 3",
        "titleBn": "ধাপ ৪: সমস্ত অক্ষর মূল্যায়ন সম্পন্ন! চূড়ান্ত সর্বোচ্চ সাব-স্ট্রিং দৈর্ঘ্য = ৩",
        "descEn": "Longest Substring Without Repeating Characters = 'abc' (Length = 3)!",
        "descBn": "পুনরাবৃত্তি ছাড়া সবচেয়ে দীর্ঘ সাব-স্ট্রিং = 'abc' (দৈর্ঘ্য = ৩)!",
      },
    ];

    final currentStep = stepFlowData[_flowStepIndex.clamp(0, stepFlowData.length - 1)];
    final String window = currentStep["window"] as String;
    final int maxVal = currentStep["max"] as int;
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
                _isEnglish ? "1. Step-by-Step Window Expansion Flowcard" : "১. স্টেপ-বাই-স্টেপ উইন্ডো এক্সপ্যানশন ফ্লো-কার্ড",
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
                ? "Watch right pointer expansion and duplicate left pointer jumps."
                : "ডান পয়েন্টারের প্রসারণ এবং ডুপ্লিকেট অক্ষরের বাম পয়েন্টার জ্যাম্প দেখুন।",
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
                    Text("Sub-window = $window", style: TextStyle(color: badgeColor, fontWeight: FontWeight.bold, fontSize: 12)),
                    Text("Max Length = $maxVal", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
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
                    "Longest Unique Window: \"$window\" (Length $maxVal)",
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 16,
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

  // MODEL 2: Pointer Jump Rule
  Widget _buildPointerJumpRuleModel() {
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
            _isEnglish ? "2. Left Pointer Instant Jump Formula" : "২. বাম পয়েন্টার ইনস্ট্যান্ট জ্যাম্প নীতি",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            _isEnglish
                ? "Instead of shrinking left one step at a time with a while loop, jump left instantly:\nleft = max(left, lastIndex[char] + 1)"
                : "হোয়ািল লুপ দিয়ে এক ঘর এক ঘর কমানোর বদলে বাম পয়েন্টারকে সরাসরি লাফ দেওয়ান:\nleft = max(left, lastIndex[char] + 1)",
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
              "left = max(left, lastIndex[s[right]] + 1); 🦘",
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
            _isEnglish ? "3. O(N) Time & O(1) Space Complexity" : "৩. O(N) টাইম এবং O(1) স্পেস কমপ্লেক্সিটি",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            _isEnglish
                ? "Brute force checks all O(N^2) substrings in O(N^3) time.\nDynamic Sliding Window with Index Map scans string in single O(N) pass with O(1) ASCII space!"
                : "ব্রুট ফোর্স O(N^3) সময়ে সমস্ত O(N^2) সাব-স্ট্রিং পরীক্ষা করে।\nইনডেক্স ম্যাপ সহ ডাইনামিক স্লাইডিং উইন্ডো মাত্র ১ বার O(N) পাস এবং O(1) ASCII স্পেসে সমাধান করে!",
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
              "Time Complexity: O(N)\nSpace Complexity: O(1) (256 ASCII table) 🎉",
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
                          labelText: _isEnglish ? "String s (e.g. abcabcbb)" : "স্ট্রিং s (যেমন abcabcbb)",
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
                      _buildPresetChip("abcabcbb"),
                      _buildPresetChip("bbbbb"),
                      _buildPresetChip("pwwkew"),
                      _buildPresetChip("tmmzuxt"),
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
                  _buildLongestSubstringCanvas(step),
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildCodeHighlightBox(step.activeLine)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildLongestSubstringCanvas(step)),
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
    final targetMaxLen = _lengthOfLongestSubstring(_s);

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
                  ? "Track window expansion and decide next step action at each character!"
                  : "প্রতিটি অক্ষরের জন্য উইন্ডো প্রসারিত করুন এবং পরবর্তী অ্যাকশন নির্বাচন করুন!",
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

            // Practice Controls
            if (!_practiceSolved && _practiceRight < _s.length)
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
                        Text("Current Index: right = $_practiceRight ('${_s[_practiceRight]}')", style: const TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 12)),
                        Text("Max Length Target: $targetMaxLen", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Window: [$_practiceLeft .. $_practiceRight] = \"${_s.substring(_practiceLeft, _practiceRight + 1)}\"",
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      alignment: WrapAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accentNeonCyan,
                            foregroundColor: AppTheme.primaryDark,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          ),
                          icon: const Icon(Icons.arrow_forward),
                          label: Text(_isEnglish ? "EXPAND (Unique)" : "EXPAND (ইউনিক)"),
                          onPressed: () => _handlePracticeAction("EXPAND"),
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accentAmber,
                            foregroundColor: AppTheme.primaryDark,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          ),
                          icon: const Icon(Icons.redo),
                          label: Text(_isEnglish ? "JUMP (Duplicate)" : "JUMP (ডুপ্লিকেট)"),
                          onPressed: () => _handlePracticeAction("JUMP"),
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accentGreen,
                            foregroundColor: AppTheme.primaryDark,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          ),
                          icon: const Icon(Icons.star),
                          label: Text(_isEnglish ? "MAX UPDATED" : "MAX UPDATED"),
                          onPressed: () => _handlePracticeAction("MAX_UPDATED"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 12),
            if (_practiceRight > 0 || _practiceSolved)
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
  Widget _buildPresetChip(String val) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ActionChip(
        backgroundColor: const Color(0xFF090D16),
        label: Text("s='$val'", style: const TextStyle(color: AppTheme.accentNeonCyan, fontSize: 11)),
        onPressed: () {
          _sController.text = val;
          _rebuildSteps();
        },
      ),
    );
  }

  Widget _buildCodeHighlightBox(int activeLine) {
    final codeLines = [
      "int lengthOfLongestSubstring(string s) {",
      "    vector<int> lastIndex(256, -1);",
      "    int left = 0, maxLength = 0;",
      "    for (int right = 0; right < s.size(); right++) {",
      "        if (lastIndex[s[right]] >= left) {",
      "            left = lastIndex[s[right]] + 1;",
      "        }",
      "        lastIndex[s[right]] = right;",
      "        maxLength = max(maxLength, right - left + 1);",
      "    }",
      "    return maxLength;",
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

  Widget _buildLongestSubstringCanvas(LongestSubstringStep step) {
    Color decisionColor = AppTheme.accentPurple;
    String decisionLabel = "INIT";

    if (step.decision == "expand") {
      decisionColor = AppTheme.accentNeonCyan;
      decisionLabel = "➡️ EXPAND RIGHT";
    } else if (step.decision == "duplicate_jump") {
      decisionColor = AppTheme.accentAmber;
      decisionLabel = "🦘 DUPLICATE JUMP";
    } else if (step.decision == "max_updated") {
      decisionColor = AppTheme.accentGreen;
      decisionLabel = "🎉 MAX LEN UPDATED";
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
              Text("Window: [L:${step.left} .. R:${step.right}]", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13)),
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

          // Substring & Max Length Meter
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Window Substring = \"${step.windowSub}\"", style: TextStyle(color: decisionColor, fontWeight: FontWeight.bold, fontSize: 12)),
              Text("Max Length = ${step.maxLength}", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
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
                  "Max Unique Substring = \"${step.longestSub}\" (Length ${step.maxLength})",
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: decisionColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (step.duplicateChar.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    "Duplicate '${step.duplicateChar}' found at index ${step.duplicateLastIndex}!",
                    style: const TextStyle(color: AppTheme.accentAmber, fontSize: 12),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Visual String Sequence Canvas with Pointers L and R
          const Text("String s Sequence Canvas:", style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_s.length, (idx) {
                bool inWindow = idx >= step.left && idx <= step.right;
                bool isL = idx == step.left;
                bool isR = idx == step.right;

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: inWindow ? decisionColor.withOpacity(0.35) : AppTheme.surfaceDark,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: inWindow ? decisionColor : const Color(0xFF334155),
                      width: inWindow ? 2.0 : 1.0,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isL) const Text("L", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.accentNeonCyan)),
                          if (isL && isR) const Text("|", style: TextStyle(fontSize: 10, color: Colors.white)),
                          if (isR) const Text("R", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.accentPink)),
                        ],
                      ),
                      const SizedBox(height: 2),
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
    int lengthOfLongestSubstring(string s) {
        vector<int> lastIndex(256, -1);
        int left = 0, maxLength = 0;
        for (int right = 0; right < s.size(); right++) {
            if (lastIndex[s[right]] >= left) {
                left = lastIndex[s[right]] + 1;
            }
            lastIndex[s[right]] = right;
            maxLength = max(maxLength, right - left + 1);
        }
        return maxLength;
    }
};""";
    } else if (lang == "Java") {
      code = """
class Solution {
    public int lengthOfLongestSubstring(String s) {
        int[] lastIndex = new int[256];
        Arrays.fill(lastIndex, -1);
        int left = 0, maxLength = 0;

        for (int right = 0; right < s.length(); right++) {
            char c = s.charAt(right);
            if (lastIndex[c] >= left) {
                left = lastIndex[c] + 1;
            }
            lastIndex[c] = right;
            maxLength = Math.max(maxLength, right - left + 1);
        }
        return maxLength;
    }
}""";
    } else {
      code = """
class Solution:
    def lengthOfLongestSubstring(self, s: str) -> int:
        last_index = {}
        left = 0
        max_len = 0

        for right, char in enumerate(s):
            if char in last_index and last_index[char] >= left:
                left = last_index[char] + 1
            last_index[char] = right
            max_len = max(max_len, right - left + 1)

        return max_len""";
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
