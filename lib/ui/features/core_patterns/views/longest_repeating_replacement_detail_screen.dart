import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class LongestRepeatingReplacementStep {
  final int left;
  final int right;
  final String windowSub;
  final String maxFreqChar;
  final int maxFreq;
  final int replaceCount;
  final int k;
  final int maxLength;
  final String decision; // 'init', 'expand', 'shrink_left', 'max_updated', 'finished'
  final int activeLine;
  final String actionEn;
  final String actionBn;
  final String reasonEn;
  final String reasonBn;

  const LongestRepeatingReplacementStep({
    required this.left,
    required this.right,
    required this.windowSub,
    required this.maxFreqChar,
    required this.maxFreq,
    required this.replaceCount,
    required this.k,
    required this.maxLength,
    required this.decision,
    required this.activeLine,
    required this.actionEn,
    required this.actionBn,
    required this.reasonEn,
    required this.reasonBn,
  });
}

class LongestRepeatingReplacementDetailScreen extends StatefulWidget {
  const LongestRepeatingReplacementDetailScreen({super.key});

  @override
  State<LongestRepeatingReplacementDetailScreen> createState() =>
      _LongestRepeatingReplacementDetailScreenState();
}

class _LongestRepeatingReplacementDetailScreenState
    extends State<LongestRepeatingReplacementDetailScreen>
    with SingleTickerProviderStateMixin {
  bool _isEnglish = true;
  late TabController _tabController;

  // Custom Input State
  final TextEditingController _sController = TextEditingController(text: "AABABBA");
  final TextEditingController _kController = TextEditingController(text: "1");
  String _s = "AABABBA";
  int _k = 1;
  List<LongestRepeatingReplacementStep> _steps = [];

  // Playback Control
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  // Code Language Selector
  String _selectedCodeLang = "C++";

  // Tab 2 Animation Model Selector (0: Step Flowcard, 1: Replacement Rule, 2: Complexity Calculator)
  int _animationModelIndex = 0;
  int _flowStepIndex = 0;

  // Practice Mode State
  int _practiceRight = 0;
  int _practiceLeft = 0;
  int _practiceMaxLen = 0;
  String _userFeedbackEn = "Expand right pointer and check if replacements needed (window_len - max_freq) <= k!";
  String _userFeedbackBn = "ডান পয়েন্টার বাড়িয়ে (window_len - max_freq) <= k শর্ত পরীক্ষা করুন!";
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
    _kController.dispose();
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

    String textS = _sController.text.trim().toUpperCase();
    if (textS.isEmpty) textS = "AABABBA";
    int kVal = int.tryParse(_kController.text.trim()) ?? 1;
    if (kVal < 0) kVal = 0;

    _s = textS;
    _k = kVal;

    _steps = _generateSteps(_s, _k);

    // Reset practice mode
    _resetPractice();
  }

  void _resetPractice() {
    _practiceLeft = 0;
    _practiceRight = 0;
    _practiceMaxLen = 0;
    _practiceSolved = false;
    _userFeedbackEn = "Inspect character at right = 0 ('${_s.isNotEmpty ? _s[0] : ''}') with k = $_k!";
    _userFeedbackBn = "k = $_k সহ ইনডেক্স right = 0 ('${_s.isNotEmpty ? _s[0] : ''}') এর অক্ষরটি পরীক্ষা করুন!";
  }

  List<LongestRepeatingReplacementStep> _generateSteps(String sStr, int kVal) {
    List<LongestRepeatingReplacementStep> steps = [];
    int n = sStr.length;

    // Step 0: Init
    steps.add(LongestRepeatingReplacementStep(
      left: 0,
      right: 0,
      windowSub: n > 0 ? sStr.substring(0, 1) : "",
      maxFreqChar: n > 0 ? sStr[0] : "",
      maxFreq: 0,
      replaceCount: 0,
      k: kVal,
      maxLength: 0,
      decision: "init",
      activeLine: 1,
      actionEn: "Line 1: Initialize Sliding Window for s = '$sStr', k = $kVal.",
      actionBn: "লাইন ১: s = '$sStr', k = $kVal এর জন্য স্লাইডিং উইন্ডো শুরু।",
      reasonEn: "We track character frequencies in counts[26] and max frequency maxFreq.",
      reasonBn: "আমরা counts[26] এ অক্ষরের ফ্রিকোয়েন্সি এবং সর্বোচ্চ ফ্রিকোয়েন্সি maxFreq ট্র্যাক করব।",
    ));

    if (n == 0) {
      steps.add(const LongestRepeatingReplacementStep(
        left: 0,
        right: 0,
        windowSub: "",
        maxFreqChar: "",
        maxFreq: 0,
        replaceCount: 0,
        k: 0,
        maxLength: 0,
        decision: "finished",
        activeLine: 2,
        actionEn: "🏁 Line 2: Empty string s! Return 0.",
        actionBn: "🏁 লাইন ২: খালি স্ট্রিং s! 0 রিটার্ন করুন।",
        reasonEn: "Empty string has length 0.",
        reasonBn: "খালি স্ট্রিংয়ের দৈর্ঘ্য ০।",
      ));
      return steps;
    }

    List<int> counts = List.filled(26, 0);
    int l = 0;
    int maxFreq = 0;
    int maxLen = 0;

    for (int r = 0; r < n; r++) {
      int charCode = sStr.codeUnitAt(r) - 65;
      if (charCode < 0 || charCode >= 26) charCode = 0;
      counts[charCode]++;

      if (counts[charCode] > maxFreq) {
        maxFreq = counts[charCode];
      }

      int windowLen = r - l + 1;
      int replaceCount = windowLen - maxFreq;

      if (replaceCount > kVal) {
        int leftCharCode = sStr.codeUnitAt(l) - 65;
        if (leftCharCode >= 0 && leftCharCode < 26) counts[leftCharCode]--;
        l++;

        steps.add(LongestRepeatingReplacementStep(
          left: l,
          right: r,
          windowSub: sStr.substring(l, r + 1),
          maxFreqChar: sStr[r],
          maxFreq: maxFreq,
          replaceCount: (r - l + 1) - maxFreq,
          k: kVal,
          maxLength: maxLen,
          decision: "shrink_left",
          activeLine: 7,
          actionEn: "⬅️ Line 7: Replacements needed ($replaceCount) > k ($kVal)! Shrink left pointer to $l.",
          actionBn: "⬅️ লাইন ৭: প্রয়োজনীয় রূপান্তর ($replaceCount) > k ($kVal)! বাম পয়েন্টার বাড়িয়ে $l এ আনা হলো।",
          reasonEn: "Window contains too many characters to replace using k = $kVal operations. Increment left pointer.",
          reasonBn: "উইন্ডোতে k = $kVal এর চেয়ে বেশি রূপান্তর দরকার। তাই বাম পয়েন্টার এক ঘর বাড়ানো হলো।",
        ));
      } else {
        if (windowLen > maxLen) {
          maxLen = windowLen;
          steps.add(LongestRepeatingReplacementStep(
            left: l,
            right: r,
            windowSub: sStr.substring(l, r + 1),
            maxFreqChar: sStr[r],
            maxFreq: maxFreq,
            replaceCount: replaceCount,
            k: kVal,
            maxLength: maxLen,
            decision: "max_updated",
            activeLine: 9,
            actionEn: "🎉 Line 9: NEW Max Valid Substring! Window [${l}..${r}] '${sStr.substring(l, r + 1)}' ➔ Length = $maxLen!",
            actionBn: "🎉 লাইন ৯: নতুন সর্বোচ্চ বৈধ্য সাব-স্ট্রিং! উইন্ডো [${l}..${r}] '${sStr.substring(l, r + 1)}' ➔ দৈর্ঘ্য = $maxLen!",
            reasonEn: "Current valid window length $windowLen exceeds max length. Update maxLen!",
            reasonBn: "বর্তমান বৈধ্য উইন্ডোর দৈর্ঘ্য $windowLen সর্বমোট দৈর্ঘ্য ছাড়িয়ে গেছে। maxLen আপডেট করুন!",
          ));
        } else {
          steps.add(LongestRepeatingReplacementStep(
            left: l,
            right: r,
            windowSub: sStr.substring(l, r + 1),
            maxFreqChar: sStr[r],
            maxFreq: maxFreq,
            replaceCount: replaceCount,
            k: kVal,
            maxLength: maxLen,
            decision: "expand",
            activeLine: 8,
            actionEn: "➡️ Line 8: Expand right to $r ('${sStr[r]}') ➔ Window [${l}..${r}] '${sStr.substring(l, r + 1)}' (Len = $windowLen, Max = $maxLen).",
            actionBn: "➡️ লাইন ৮: ডান পয়েন্টার $r ('${sStr[r]}') এ বাড়ানো হলো ➔ উইন্ডো [${l}..${r}] '${sStr.substring(l, r + 1)}' (দৈর্ঘ্য = $windowLen, সর্বমোট = $maxLen)।",
            reasonEn: "Valid window with $replaceCount replacements <= k ($kVal).",
            reasonBn: "$replaceCount টি রূপান্তর সহ বৈধ্য উইন্ডো <= k ($kVal)।",
          ));
        }
      }
    }

    steps.add(LongestRepeatingReplacementStep(
      left: l,
      right: n - 1,
      windowSub: sStr.substring(l),
      maxFreqChar: "",
      maxFreq: maxFreq,
      replaceCount: 0,
      k: kVal,
      maxLength: maxLen,
      decision: "finished",
      activeLine: 11,
      actionEn: "🏁 Line 11: Traversal Complete! Longest Repeating Character Replacement Length = $maxLen.",
      actionBn: "🏁 লাইন ১১: স্ক্যান সম্পূর্ণ! সবচেয়ে দীর্ঘ একক ক্যারেক্টার সাব-স্ট্রিং দৈর্ঘ্য = $maxLen।",
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

  int _characterReplacement(String sStr, int kVal) {
    List<int> counts = List.filled(26, 0);
    int l = 0, maxF = 0, maxL = 0;
    for (int r = 0; r < sStr.length; r++) {
      int code = sStr.codeUnitAt(r) - 65;
      if (code >= 0 && code < 26) counts[code]++;
      maxF = max(maxF, counts[code]);
      if ((r - l + 1) - maxF > kVal) {
        int lCode = sStr.codeUnitAt(l) - 65;
        if (lCode >= 0 && lCode < 26) counts[lCode]--;
        l++;
      }
      maxL = max(maxL, r - l + 1);
    }
    return maxL;
  }

  void _handlePracticeAction(String actionType) {
    if (_practiceSolved || _practiceRight >= _s.length) return;

    List<int> counts = List.filled(26, 0);
    int l = 0, maxF = 0, maxL = 0;
    bool expectedShrink = false;
    bool expectedMax = false;

    for (int r = 0; r <= _practiceRight; r++) {
      int code = _s.codeUnitAt(r) - 65;
      if (code >= 0 && code < 26) counts[code]++;
      maxF = max(maxF, counts[code]);
      if ((r - l + 1) - maxF > _k) {
        if (r == _practiceRight) expectedShrink = true;
        int lCode = _s.codeUnitAt(l) - 65;
        if (lCode >= 0 && lCode < 26) counts[lCode]--;
        l++;
      }
      int curLen = r - l + 1;
      if (curLen > maxL) {
        if (r == _practiceRight) expectedMax = true;
        maxL = curLen;
      }
    }

    String expectedAction = "EXPAND";
    if (expectedShrink) expectedAction = "SHRINK";
    if (expectedMax) expectedAction = "MAX_UPDATED";

    setState(() {
      if (actionType == expectedAction || (actionType == "EXPAND" && expectedAction == "EXPAND")) {
        _practiceLeft = l;
        _practiceMaxLen = maxL;
        _practiceRight++;

        if (_practiceRight >= _s.length) {
          _practiceSolved = true;
          _userFeedbackEn = "🏆 MASTERED! You correctly evaluated character replacement condition! Max Length = $maxL!";
          _userFeedbackBn = "🏆 দারুণ! আপনি ক্যারেক্টার রিপ্লেসমেন্ট শর্ত সঠিকভাবে মূল্যায়ন করেছেন! সর্বমোট দৈর্ঘ্য = $maxL!";
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
          '424. Longest Repeating Character Replacement',
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
                    "424. Longest Repeating Character Replacement",
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
              children: ["Meta", "Amazon", "Google"].map((company) {
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
                        ? "You are given a string s consisting of uppercase English letters and an integer k. You can perform at most k character replacements. Return the length of the longest substring containing the same letter."
                        : "একটি স্ট্রিং s (বড় হাতের ইংরেজি অক্ষর) এবং একটি সংখ্যা k দেওয়া আছে। সর্বোচ্চ k টি অক্ষর যেকোনো অক্ষরে রূপান্তর করতে পারবেন। রূপান্তরের পর একই অক্ষরের সবচেয়ে দীর্ঘ সাব-স্ট্রিংয়ের দৈর্ঘ্য কত হবে তা নির্ণয় করুন।",
                    style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Examples
            Text(_isEnglish ? "Examples" : "উদাহরণসমূহ", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            _buildExampleCard("Example 1", "s = \"ABAB\", k = 2", "Output: 4 (Replace 2 chars to get \"AAAA\" or \"BBBB\")"),
            _buildExampleCard("Example 2", "s = \"AABABBA\", k = 1", "Output: 4 (Replace middle 'A' to get \"AABBBBA\" with substring \"BBBB\" of length 4)"),
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
                        _isEnglish ? "Key Intuition (Window Replacement Condition)" : "মূল আইডিয়া (উইন্ডো রূপান্তর শর্ত)",
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isEnglish
                        ? "1. In any window [left..right], keep the most frequent character (maxFreq) and replace the remaining (window_len - maxFreq) characters.\n2. Valid condition: (window_len - maxFreq) <= k.\n3. If (window_len - maxFreq) > k, shrink window from left (left++).\n4. Achieves O(N) linear time complexity and O(1) space complexity!"
                        : "১. যেকোনো উইন্ডোতে [left..right] সবচেয়ে বেশিবার থাকা ক্যারেক্টার (maxFreq) রেখে বাকি (window_len - maxFreq) টি পরিবর্তন করুন।\n২. বৈধ্য শর্ত: (window_len - maxFreq) <= k।\n৩. শর্ত ভঙ্গ হলে (window_len - maxFreq) > k বাম পয়েন্টার কমান (left++)।\n৪. O(N) লিনিয়ার সময় ও O(1) স্পেস কমপ্লেক্সিটি।",
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
              _isEnglish ? "Character Replacement Visual Models" : "ক্যারেক্টার রিপ্লেসমেন্ট ভিজ্যুয়াল মডেলসমূহ (কোডহীন গাইড)",
              style: TextStyle(fontSize: Responsive.sp(context, 18), fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 6),
            Text(
              _isEnglish
                  ? "Explore 3 interactive models for s = \"AABABBA\", k = 1."
                  : "s = \"AABABBA\", k = 1 এর জন্য ৩টি ইন্টারঅ্যাক্টিভ ভিজ্যুয়াল মডেল পর্যবেক্ষণ করুন।",
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 16),

            // Model Switcher Segmented Control
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildAnimationModelChip(0, _isEnglish ? "1. 🪜 Step Flowcard" : "১. 🪜 স্টেপ-বাই-স্টেপ ফ্লো-কার্ড"),
                  _buildAnimationModelChip(1, _isEnglish ? "2. 📏 Replacement Rule" : "২. 📏 রিপ্লেসমেন্ট নীতি"),
                  _buildAnimationModelChip(2, _isEnglish ? "3. 📊 Complexity Calculator" : "৩. 📊 টাইমিং ক্যালকুলেটর"),
                ],
              ),
            ),
            const SizedBox(height: 20),

            if (_animationModelIndex == 0) _buildStepFlowcardModel(),
            if (_animationModelIndex == 1) _buildReplacementRuleModel(),
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
        "window": "\"AABA\"",
        "max": 4,
        "badge": "🎉 MAX LENGTH = 4",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 1: Window [0..3] = \"AABA\" ➔ maxFreq=3 ('A'), replacements=1 <= k (1)",
        "titleBn": "ধাপ ১: উইন্ডো [0..3] = \"AABA\" ➔ maxFreq=3 ('A'), প্রয়োজনীয় রূপান্তর=1 <= k (1)",
        "descEn": "Replaced 'B' with 'A' to get valid repeating substring \"AAAA\" of length 4!",
        "descBn": "'B' কে 'A' এ রূপান্তর করে ৪ দৈর্ঘ্যের বৈধ্য পুনরাবৃত্তি সাব-স্ট্রিং \"AAAA\" পাওয়া গেল!",
      },
      {
        "step": 2,
        "window": "\"AABAB\"",
        "max": 4,
        "badge": "⬅️ SHRINK LEFT",
        "badgeColor": AppTheme.accentAmber,
        "titleEn": "Step 2: Window [0..4] = \"AABAB\" ➔ replacements=2 > k (1)! Shrink Left",
        "titleBn": "ধাপ ২: উইন্ডো [0..4] = \"AABAB\" ➔ প্রয়োজনীয় রূপান্তর=2 > k (1)! বাম কমান",
        "descEn": "Too many replacements needed (2 > 1). Increment left pointer to index 1.",
        "descBn": "k = 1 এর চেয়ে বেশি রূপান্তর দরকার (2 > 1)। বাম পয়েন্টার ইনডেক্স ১ এ নিন।",
      },
      {
        "step": 3,
        "window": "\"ABBA\"",
        "max": 4,
        "badge": "➡️ VALID WINDOW",
        "badgeColor": AppTheme.accentNeonCyan,
        "titleEn": "Step 3: Window [3..6] = \"ABBA\" ➔ maxFreq=2, replacements=2 > k ➔ Shrink Left",
        "titleBn": "ধাপ ৩: উইন্ডো [3..6] = \"ABBA\" ➔ maxFreq=2, প্রয়োজনীয় রূপান্তর=2 > k ➔ বাম কমান",
        "descEn": "Shrinking left maintains maximum valid window length = 4.",
        "descBn": "বাম পয়েন্টার কমাবার মাধ্যমে সর্বোচ্চ বৈধ্য উইন্ডোর দৈর্ঘ্য ৪ বজায় রাখা হলো।",
      },
      {
        "step": 4,
        "window": "\"ABBA\"",
        "max": 4,
        "badge": "🏁 COMPLETE",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 4: All Characters Evaluated! Final Max Length = 4",
        "titleBn": "ধাপ ৪: সমস্ত অক্ষর মূল্যায়ন সম্পন্ন! চূড়ান্ত সর্বোচ্চ দৈর্ঘ্য = ৪",
        "descEn": "Longest Repeating Character Replacement Length = 4!",
        "descBn": "সবচেয়ে দীর্ঘ পুনরাবৃত্তি ক্যারেক্টার রিপ্লেসমেন্ট দৈর্ঘ্য = ৪!",
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
                _isEnglish ? "1. Step-by-Step Character Replacement Flowcard" : "১. স্টেপ-বাই-স্টেপ ক্যারেক্টার রিপ্লেসমেন্ট ফ্লো-কার্ড",
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
                ? "Watch dynamic window expansion and replacement limit evaluation."
                : "ডাইনামিক উইন্ডো এক্সপ্যানশন এবং রিপ্লেসমেন্ট লিমিট মূল্যায়ন দেখুন।",
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
                    "Longest Valid Substring Length = $maxVal",
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

  // MODEL 2: Replacement Rule
  Widget _buildReplacementRuleModel() {
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
            _isEnglish ? "2. Window Replacement Condition Formula" : "২. উইন্ডো রিপ্লেসমেন্ট শর্ত নীতি",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            _isEnglish
                ? "For window size (right - left + 1), replacements needed = (window_size - maxFreq).\nIf (window_size - maxFreq) > k ➔ Shrink Left (left++)."
                : "উইন্ডো সাইজ (right - left + 1) এর জন্য রূপান্তর প্রয়োজন = (window_size - maxFreq)।\nযদি (window_size - maxFreq) > k হয় ➔ বাম পয়েন্টার কমান (left++)।",
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
              "if ((right - left + 1) - maxFreq > k) left++; 📏",
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
                ? "Brute force checks all substrings in O(26 * N^2) time.\nSliding Window moves left and right pointers at most N times total in O(N) time with 26 frequency counters O(1) space!"
                : "ব্রুট ফোর্স O(26 * N^2) সময়ে সমস্ত সাব-স্ট্রিং পরীক্ষা করে।\nস্লাইডিং উইন্ডো বাম ও ডান পয়েন্টার সর্বমোট N বার সরিয়ে O(N) টাইমে ২৬ কাউন্টার O(1) স্পেসে সমাধান করে!",
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
              "Time Complexity: O(N)\nSpace Complexity: O(1) (26 counters) 🎉",
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
                      flex: 2,
                      child: TextField(
                        controller: _sController,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          labelText: _isEnglish ? "String s (e.g. AABABBA)" : "স্ট্রিং s (যেমন AABABBA)",
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
                        controller: _kController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          labelText: _isEnglish ? "k (Replacements)" : "k (রূপান্তর)",
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
                      _buildPresetChip("AABABBA", "1"),
                      _buildPresetChip("ABAB", "2"),
                      _buildPresetChip("AAAA", "2"),
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
                  _buildReplacementCanvas(step),
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildCodeHighlightBox(step.activeLine)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildReplacementCanvas(step)),
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
    final targetMaxLen = _characterReplacement(_s, _k);

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
                          label: Text(_isEnglish ? "EXPAND (Valid)" : "EXPAND (বৈধ্য)"),
                          onPressed: () => _handlePracticeAction("EXPAND"),
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accentAmber,
                            foregroundColor: AppTheme.primaryDark,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          ),
                          icon: const Icon(Icons.arrow_back),
                          label: Text(_isEnglish ? "SHRINK LEFT" : "SHRINK LEFT"),
                          onPressed: () => _handlePracticeAction("SHRINK"),
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
  Widget _buildPresetChip(String sVal, String kVal) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ActionChip(
        backgroundColor: const Color(0xFF090D16),
        label: Text("s='$sVal', k=$kVal", style: const TextStyle(color: AppTheme.accentNeonCyan, fontSize: 11)),
        onPressed: () {
          _sController.text = sVal;
          _kController.text = kVal;
          _rebuildSteps();
        },
      ),
    );
  }

  Widget _buildCodeHighlightBox(int activeLine) {
    final codeLines = [
      "int characterReplacement(string s, int k) {",
      "    vector<int> counts(26, 0);",
      "    int left = 0, maxFreq = 0, maxLength = 0;",
      "    for (int right = 0; right < s.size(); right++) {",
      "        counts[s[right] - 'A']++;",
      "        maxFreq = max(maxFreq, counts[s[right] - 'A']);",
      "        if ((right - left + 1) - maxFreq > k) {",
      "            counts[s[left] - 'A']--; left++;",
      "        }",
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

  Widget _buildReplacementCanvas(LongestRepeatingReplacementStep step) {
    Color decisionColor = AppTheme.accentPurple;
    String decisionLabel = "INIT";

    if (step.decision == "expand") {
      decisionColor = AppTheme.accentNeonCyan;
      decisionLabel = "➡️ EXPAND RIGHT";
    } else if (step.decision == "shrink_left") {
      decisionColor = AppTheme.accentAmber;
      decisionLabel = "⬅️ SHRINK LEFT";
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
              Text("Window: [L:${step.left} .. R:${step.right}] (k = ${step.k})", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13)),
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

          // Substring & Meter
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Window Substring = \"${step.windowSub}\"", style: TextStyle(color: decisionColor, fontWeight: FontWeight.bold, fontSize: 12)),
              Text("Replacements = ${step.replaceCount} / k=${step.k}", style: TextStyle(color: step.replaceCount <= step.k ? AppTheme.accentGreen : AppTheme.accentPink, fontWeight: FontWeight.bold, fontSize: 12)),
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
                  "Max Valid Substring Length = ${step.maxLength}",
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
                  "Max Char Freq in Window = ${step.maxFreq} ('${step.maxFreqChar}')",
                  style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                ),
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
    int characterReplacement(string s, int k) {
        vector<int> counts(26, 0);
        int left = 0, maxFreq = 0, maxLength = 0;

        for (int right = 0; right < s.size(); right++) {
            counts[s[right] - 'A']++;
            maxFreq = max(maxFreq, counts[s[right] - 'A']);

            if ((right - left + 1) - maxFreq > k) {
                counts[s[left] - 'A']--;
                left++;
            }
            maxLength = max(maxLength, right - left + 1);
        }
        return maxLength;
    }
};""";
    } else if (lang == "Java") {
      code = """
class Solution {
    public int characterReplacement(String s, int k) {
        int[] counts = new int[26];
        int left = 0, maxFreq = 0, maxLength = 0;

        for (int right = 0; right < s.length(); right++) {
            counts[s.charAt(right) - 'A']++;
            maxFreq = Math.max(maxFreq, counts[s.charAt(right) - 'A']);

            if ((right - left + 1) - maxFreq > k) {
                counts[s.charAt(left) - 'A']--;
                left++;
            }
            maxLength = Math.max(maxLength, right - left + 1);
        }
        return maxLength;
    }
}""";
    } else {
      code = """
class Solution:
    def characterReplacement(self, s: str, k: int) -> int:
        counts = {}
        left = 0
        max_freq = 0
        max_len = 0

        for right in range(len(s)):
            counts[s[right]] = counts.get(s[right], 0) + 1
            max_freq = max(max_freq, counts[s[right]])

            if (right - left + 1) - max_freq > k:
                counts[s[left]] -= 1
                left += 1

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
