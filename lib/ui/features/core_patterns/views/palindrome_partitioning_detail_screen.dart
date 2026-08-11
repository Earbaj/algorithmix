import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class PalindromePartitioningStep {
  final int startIndex;
  final int endIndex;
  final String currentSubstring;
  final bool isSubPalindrome;
  final List<String> currentPath;
  final List<List<String>> allPartitions;
  final String decision; // 'init', 'valid_palindrome', 'not_palindrome', 'base_case', 'backtrack'
  final int activeLine;
  final String actionEn;
  final String actionBn;
  final String reasonEn;
  final String reasonBn;
  final int callStackDepth;

  const PalindromePartitioningStep({
    required this.startIndex,
    required this.endIndex,
    required this.currentSubstring,
    required this.isSubPalindrome,
    required this.currentPath,
    required this.allPartitions,
    required this.decision,
    required this.activeLine,
    required this.actionEn,
    required this.actionBn,
    required this.reasonEn,
    required this.reasonBn,
    required this.callStackDepth,
  });
}

class PalindromePartitioningDetailScreen extends StatefulWidget {
  const PalindromePartitioningDetailScreen({super.key});

  @override
  State<PalindromePartitioningDetailScreen> createState() => _PalindromePartitioningDetailScreenState();
}

class _PalindromePartitioningDetailScreenState extends State<PalindromePartitioningDetailScreen>
    with SingleTickerProviderStateMixin {
  bool _isEnglish = true;
  late TabController _tabController;

  // Custom Input State
  final TextEditingController _inputController = TextEditingController(text: "aab");
  String _inputStr = "aab";
  List<PalindromePartitioningStep> _steps = [];

  // Playback Control
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  // Code Language Selector
  String _selectedCodeLang = "C++";

  // Tab 2 Animation Model Selector (0: Step Flowcard, 1: Two-Pointer Checker, 2: Substring Cut Tree)
  int _animationModelIndex = 0;
  int _flowStepIndex = 0;

  // Practice Mode State
  int _practiceStart = 0;
  List<String> _practiceCurrentPath = [];
  List<List<String>> _practiceResults = [];
  List<String> _practiceHistory = [];
  String _userFeedbackEn = "Select palindrome cut endpoints to partition string into valid palindromes!";
  String _userFeedbackBn = "বৈধ প্যালিনড্রোমে স্ট্রিং ভাগ করতে প্যালিনড্রোম কাট নির্বাচন করুন!";
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
    if (clean.isEmpty) clean = "aab";
    if (clean.length > 5) clean = clean.substring(0, 5); // Limit for clean visualization
    _inputStr = clean;

    _steps = _generateSteps(_inputStr);

    // Reset practice mode
    _practiceStart = 0;
    _practiceCurrentPath = [];
    _practiceResults = [];
    _practiceHistory = [];
    _practiceSolved = false;
    _userFeedbackEn = "Select palindrome cut endpoints to partition '$_inputStr'!";
    _userFeedbackBn = "স্ট্রিং '$_inputStr' ভাগ করতে প্যালিনড্রোম কাট নির্বাচন করুন!";
  }

  bool _checkPalindrome(String s, int left, int right) {
    while (left < right) {
      if (s[left] != s[right]) return false;
      left++;
      right--;
    }
    return true;
  }

  List<PalindromePartitioningStep> _generateSteps(String s) {
    List<PalindromePartitioningStep> steps = [];
    List<List<String>> results = [];
    List<String> path = [];

    // Step 0: Init
    steps.add(PalindromePartitioningStep(
      startIndex: 0,
      endIndex: 0,
      currentSubstring: "",
      isSubPalindrome: true,
      currentPath: [],
      allPartitions: [],
      decision: "init",
      activeLine: 1,
      actionEn: "Line 1: Initialize Palindrome Partitioning for string '$s'.",
      actionBn: "লাইন ১: স্ট্রিং '$s' এর জন্য প্যালিনড্রোম পার্টিশনিং ব্যাকট্র্যাক শুরু।",
      reasonEn: "We cut string at index i whenever substring s[start...i] forms a valid palindrome.",
      reasonBn: "সাবস্ট্রিং s[start...i] একটি প্যালিনড্রোম হলে ইনডেক্স i এ স্ট্রিংটি কাটা হবে।",
      callStackDepth: 0,
    ));

    void backtrack(int start, int depth) {
      if (start == s.length) {
        results.add(List.from(path));
        steps.add(PalindromePartitioningStep(
          startIndex: start,
          endIndex: start,
          currentSubstring: "",
          isSubPalindrome: true,
          currentPath: List.from(path),
          allPartitions: List.from(results),
          decision: "base_case",
          activeLine: 3,
          actionEn: "🎉 Line 3: End of String Reached! Saved partition [${path.map((e) => '"$e"').join(', ')}].",
          actionBn: "🎉 লাইন ৩: স্ট্রিং এর শেষ প্রান্তে পৌঁছেছে! পার্টিশন [${path.map((e) => '"$e"').join(', ')}] সংরক্ষিত।",
          reasonEn: "Entire string partitioned into valid palindromes.",
          reasonBn: "সম্পূর্ণ স্ট্রিংটি বৈধ প্যালিনড্রোমে বিভক্ত হয়েছে।",
          callStackDepth: depth,
        ));
        return;
      }

      for (int i = start; i < s.length; i++) {
        String sub = s.substring(start, i + 1);
        bool isPalin = _checkPalindrome(s, start, i);

        if (!isPalin) {
          steps.add(PalindromePartitioningStep(
            startIndex: start,
            endIndex: i,
            currentSubstring: sub,
            isSubPalindrome: false,
            currentPath: List.from(path),
            allPartitions: List.from(results),
            decision: "not_palindrome",
            activeLine: 7,
            actionEn: "🛑 Line 7: Substring '$sub' (indices $start..$i) is NOT a palindrome! Skip branch.",
            actionBn: "🛑 লাইন ৭: সাবস্ট্রিং '$sub' (ইনডেক্স $start..$i) প্যালিনড্রোম নয়! ব্রাঞ্চ ছাঁটাই।",
            reasonEn: "Substring '$sub' reads differently backward.",
            reasonBn: "সাবস্ট্রিং '$sub' উল্টো করে পড়লে সমান নয়।",
            callStackDepth: depth,
          ));
          continue;
        }

        path.add(sub);
        steps.add(PalindromePartitioningStep(
          startIndex: start,
          endIndex: i,
          currentSubstring: sub,
          isSubPalindrome: true,
          currentPath: List.from(path),
          allPartitions: List.from(results),
          decision: "valid_palindrome",
          activeLine: 8,
          actionEn: "Line 8: Substring '$sub' is a Palindrome! Cut at $i ➔ Path = [${path.map((e) => '"$e"').join(', ')}].",
          actionBn: "লাইন ৮: সাবস্ট্রিং '$sub' একটি প্যালিনড্রোম! ইনডেক্স $i এ কাট ➔ Path = [${path.map((e) => '"$e"').join(', ')}]।",
          reasonEn: "Valid palindrome choice. Recurse for remaining substring starting at ${i + 1}.",
          reasonBn: "বৈধ প্যালিনড্রোম নির্বাচন। ${i + 1} থেকে শুরু হওয়া অবশিষ্ট স্ট্রিং এ রিকার্সন চালাও।",
          callStackDepth: depth + 1,
        ));

        backtrack(i + 1, depth + 1);

        // Backtrack
        path.removeLast();
        steps.add(PalindromePartitioningStep(
          startIndex: start,
          endIndex: i,
          currentSubstring: sub,
          isSubPalindrome: true,
          currentPath: List.from(path),
          allPartitions: List.from(results),
          decision: "backtrack",
          activeLine: 10,
          actionEn: "Line 10: Backtrack ↩️ Pop substring '$sub' ➔ Reverted to [${path.map((e) => '"$e"').join(', ')}].",
          actionBn: "লাইন ১০: ব্যাকট্র্যাক ↩️ সাবস্ট্রিং '$sub' বাদ ➔ পুনর্বহাল [${path.map((e) => '"$e"').join(', ')}]।",
          reasonEn: "Restore path to explore next substring length.",
          reasonBn: "পরবর্তী দৈর্ঘ্যের সাবস্ট্রিং অনুসন্ধানের জন্য অবস্হা পুনর্বহাল করো।",
          callStackDepth: depth,
        ));
      }
    }

    backtrack(0, 0);

    // Final Step
    steps.add(PalindromePartitioningStep(
      startIndex: s.length,
      endIndex: s.length,
      currentSubstring: "",
      isSubPalindrome: true,
      currentPath: [],
      allPartitions: List.from(results),
      decision: "base_case",
      activeLine: 12,
      actionEn: "🎉 Line 12: Backtracking Complete! Generated total ${results.length} valid palindrome partitions!",
      actionBn: "🎉 লাইন ১২: ব্যাকট্র্যাকিং সম্পূর্ণ! মোট ${results.length} টি বৈধ প্যালিনড্রোম পার্টিশন তৈরি সম্পন্ন!",
      reasonEn: "All partition cuts for '$s' fully explored.",
      reasonBn: "স্ট্রিং '$s' এর সমস্ত পার্টিশন ক্লিভেজ পরীক্ষা সম্পন্ন হয়েছে।",
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

  int _calculateUniquePartitionsCount(String s) {
    List<List<String>> res = [];
    List<String> path = [];

    void bt(int start) {
      if (start == s.length) {
        res.add(List.from(path));
        return;
      }
      for (int i = start; i < s.length; i++) {
        if (_checkPalindrome(s, start, i)) {
          path.add(s.substring(start, i + 1));
          bt(i + 1);
          path.removeLast();
        }
      }
    }

    bt(0);
    return res.length;
  }

  void _handlePracticeCut(int endIdx) {
    if (_practiceSolved || _practiceStart >= _inputStr.length) return;

    final targetTotal = _calculateUniquePartitionsCount(_inputStr);
    String sub = _inputStr.substring(_practiceStart, endIdx + 1);
    bool isPalin = _checkPalindrome(_inputStr, _practiceStart, endIdx);

    setState(() {
      if (!isPalin) {
        _userFeedbackEn = "🛑 Substring '$sub' is NOT a palindrome! Try another cut index.";
        _userFeedbackBn = "🛑 সাবস্ট্রিং '$sub' প্যালিনড্রোম নয়! অন্য কাট ইনডেক্স চেষ্টা করুন।";
        return;
      }

      _practiceCurrentPath.add(sub);
      _practiceHistory.add("CUT $endIdx ($sub)");
      _practiceStart = endIdx + 1;

      if (_practiceStart == _inputStr.length) {
        List<String> copy = List.from(_practiceCurrentPath);
        bool exists = _practiceResults.any((p) => p.join(',') == copy.join(','));

        if (!exists) {
          _practiceResults.add(copy);
          _userFeedbackEn = "🎉 Valid Partition [${copy.map((e) => '"$e"').join(', ')}] Saved! (${_practiceResults.length} / $targetTotal)";
          _userFeedbackBn = "🎉 বৈধ পার্টিশন [${copy.map((e) => '"$e"').join(', ')}] সংরক্ষিত! (${_practiceResults.length} / $targetTotal)";
        } else {
          _userFeedbackEn = "ℹ️ Partition [${copy.map((e) => '"$e"').join(', ')}] was already collected. Try another cut!";
          _userFeedbackBn = "ℹ️ পার্টিশন [${copy.map((e) => '"$e"').join(', ')}] ইতিমধ্যেই সংগৃহীত হয়েছে। অন্য কাট চেষ্টা করুন!";
        }

        // Reset for next partition
        _practiceStart = 0;
        _practiceCurrentPath = [];

        if (_practiceResults.length >= targetTotal) {
          _practiceSolved = true;
          _userFeedbackEn = "🏆 MASTERED! You generated all $targetTotal palindrome partitions for '$_inputStr'!";
          _userFeedbackBn = "🏆 দারুণ! আপনি '$_inputStr' এর সবকটি $targetTotal টি প্যালিনড্রোম পার্টিশন বানিয়ে ফেলেছেন!";
        }
      } else {
        _userFeedbackEn = "✅ Cut '$sub'! Next: Select palindrome cut starting at index $_practiceStart.";
        _userFeedbackBn = "✅ '$sub' কাটা হলো! পরবর্তী: ইনডেক্স $_practiceStart থেকে প্যালিনড্রোম কাট বেছে নিন।";
      }
    });
  }

  void _undoPracticeMove() {
    if (_practiceHistory.isNotEmpty) {
      setState(() {
        _practiceHistory.removeLast();
        if (_practiceCurrentPath.isNotEmpty) {
          String popped = _practiceCurrentPath.removeLast();
          _practiceStart -= popped.length;
        } else {
          _practiceStart = 0;
        }
        _userFeedbackEn = "↩️ Undid last cut move. Current Path = [${_practiceCurrentPath.map((e) => '"$e"').join(', ')}].";
        _userFeedbackBn = "↩️ পূর্ববর্তী কাট ধাপ বাতিল করা হলো। Current Path = [${_practiceCurrentPath.map((e) => '"$e"').join(', ')}]।";
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
          '131. Palindrome Partitioning',
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
                    "131. Palindrome Partitioning",
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
                        ? "Given a string s, partition s such that every substring of the partition is a palindrome. Return all possible palindrome partitioning of s."
                        : "একটি স্ট্রিং s দেওয়া আছে। স্ট্রিংটিকে এমনভাবে ভাগ করুন যাতে ভাগের প্রতিটি সাবস্ট্রিং একটি প্যালিনড্রোম হয়। সমস্ত সম্ভাব্য প্যালিনড্রোম পার্টিশনিং রিটার্ন করুন।",
                    style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Examples
            Text(_isEnglish ? "Examples" : "উদাহরণসমূহ", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            _buildExampleCard("Example 1", 's = "aab"', 'Output: [["a","a","b"],["aa","b"]]'),
            _buildExampleCard("Example 2", 's = "a"', 'Output: [["a"]]'),
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
                        _isEnglish ? "Key Intuition (Substring Palindrome Check + Backtracking Cut)" : "মূল আইডিয়া (প্যালিনড্রোম চেক + ব্যাকট্র্যাকিং কাট)",
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isEnglish
                        ? "At position start, test substring s[start...i]. If it is a palindrome, cut the string at index i and recurse for the remaining substring starting at i + 1."
                        : "পজিশন start এ সাবস্ট্রিং s[start...i] পরীক্ষা করুন। এটি প্যালিনড্রোম হলে ইনডেক্স i এ কেটে i + 1 থেকে শুরু হওয়া অবশিষ্ট স্ট্রিং এ রিকার্সন চালান।",
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
              _isEnglish ? "Palindrome Partitioning Visual Models (Concept Explanations)" : "প্যালিনড্রোম পার্টিশনিং ভিজ্যুয়াল মডেলসমূহ (কোডহীন গাইড)",
              style: TextStyle(fontSize: Responsive.sp(context, 18), fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 6),
            Text(
              _isEnglish
                  ? "Explore 3 interactive models for string s = 'aab'."
                  : "স্ট্রিং s = 'aab' এর জন্য ৩টি ইন্টারঅ্যাক্টিভ ভিজ্যুয়াল মডেল পর্যবেক্ষণ করুন।",
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 16),

            // Model Switcher Segmented Control
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildAnimationModelChip(0, _isEnglish ? "1. 🪜 Step Flowcard" : "১. 🪜 স্টেপ-বাই-স্টেপ ফ্লো-কার্ড"),
                  _buildAnimationModelChip(1, _isEnglish ? "2. 🔍 Two-Pointer Palindrome Checker" : "২. 🔍 টু-পয়েন্টার প্যালিনড্রোম চেকার"),
                  _buildAnimationModelChip(2, _isEnglish ? "3. ✂️ Substring Cut Tree" : "৩. ✂️ সাবস্ট্রিং কাট ট্রি"),
                ],
              ),
            ),
            const SizedBox(height: 20),

            if (_animationModelIndex == 0) _buildStepFlowcardModel(),
            if (_animationModelIndex == 1) _buildTwoPointerCheckerModel(),
            if (_animationModelIndex == 2) _buildCutTreeModel(),

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
        "sub": "a",
        "path": [],
        "isPalin": true,
        "badge": "INIT",
        "badgeColor": AppTheme.accentNeonCyan,
        "titleEn": "Step 1: Start at index 0 for string 'aab'",
        "titleBn": "ধাপ ১: স্ট্রিং 'aab' এর জন্য ইনডেক্স ০ থেকে শুরু",
        "descEn": "Test substring s[0..0] = 'a'. Next: Palindrome check.",
        "descBn": "সাবস্ট্রিং s[0..0] = 'a' পরীক্ষা। পরবর্তী: প্যালিনড্রোম চেক।",
      },
      {
        "step": 2,
        "sub": "a",
        "path": ["a"],
        "isPalin": true,
        "badge": "✅ PALINDROME",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 2: Substring 'a' is a Palindrome! Cut at 0",
        "titleBn": "ধাপ ২: সাবস্ট্রিং 'a' প্যালিনড্রোম! ইনডেক্স ০ এ কাট",
        "descEn": "Path = ['a']. Recurse for remaining 'ab' starting at index 1.",
        "descBn": "Path = ['a']। ইনডেক্স ১ থেকে অবশিষ্ট 'ab' এ রিকার্সন।",
      },
      {
        "step": 3,
        "sub": "a",
        "path": ["a", "a"],
        "isPalin": true,
        "badge": "✅ PALINDROME",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 3: Substring 'a' is a Palindrome! Cut at 1",
        "titleBn": "ধাপ ৩: সাবস্ট্রিং 'a' প্যালিনড্রোম! ইনডেক্স ১ এ কাট",
        "descEn": "Path = ['a', 'a']. Recurse for remaining 'b' starting at index 2.",
        "descBn": "Path = ['a', 'a']। ইনডেক্স ২ থেকে অবশিষ্ট 'b' এ রিকার্সন।",
      },
      {
        "step": 4,
        "sub": "b",
        "path": ["a", "a", "b"],
        "isPalin": true,
        "badge": "🎉 SAVED ['a','a','b']",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 4: End Reached! Saved Partition ['a', 'a', 'b']",
        "titleBn": "ধাপ ৪: শেষ প্রান্তে পৌঁছানো হয়েছে! ['a', 'a', 'b'] সংরক্ষিত",
        "descEn": "Saved first valid partition ['a', 'a', 'b']!",
        "descBn": "প্রথম বৈধ প্যালিনড্রোম পার্টিশন ['a', 'a', 'b'] সংরক্ষিত!",
      },
      {
        "step": 5,
        "sub": "aa",
        "path": ["aa"],
        "isPalin": true,
        "badge": "✅ PALINDROME",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 5: Backtrack & Test Substring 'aa' at start 0 ➔ Palindrome!",
        "titleBn": "ধাপ ৫: ব্যাকট্র্যাক ও ইনডেক্স ০ এ 'aa' পরীক্ষা ➔ প্যালিনড্রোম!",
        "descEn": "Path = ['aa']. Recurse for remaining 'b' starting at index 2.",
        "descBn": "Path = ['aa']। ইনডেক্স ২ থেকে অবশিষ্ট 'b' এ রিকার্সন।",
      },
      {
        "step": 6,
        "sub": "b",
        "path": ["aa", "b"],
        "isPalin": true,
        "badge": "🎉 SAVED ['aa','b']",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 6: End Reached! Saved Partition ['aa', 'b']",
        "titleBn": "ধাপ ৬: শেষ প্রান্তে পৌঁছানো হয়েছে! ['aa', 'b'] সংরক্ষিত",
        "descEn": "Saved second valid partition ['aa', 'b']!",
        "descBn": "দ্বিতীয় বৈধ প্যালিনড্রোম পার্টিশন ['aa', 'b'] সংরক্ষিত!",
      },
      {
        "step": 7,
        "sub": "aab",
        "path": [],
        "isPalin": false,
        "badge": "🛑 NOT PALINDROME",
        "badgeColor": AppTheme.accentPink,
        "titleEn": "Step 7: Test Substring 'aab' ➔ NOT a Palindrome!",
        "titleBn": "ধাপ ৭: সাবস্ট্রিং 'aab' পরীক্ষা ➔ প্যালিনড্রোম নয়!",
        "descEn": "'aab' != 'baa'. Branch pruned!",
        "descBn": "'aab' এবং 'baa' সমান নয়। ব্রাঞ্চ ছাঁটাই!",
      },
    ];

    final currentStep = stepFlowData[_flowStepIndex.clamp(0, stepFlowData.length - 1)];
    final String sub = currentStep["sub"] as String;
    final List<String> currentPath = (currentStep["path"] as List).cast<String>();
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
                _isEnglish ? "1. Step-by-Step Palindrome Partitioning Flowcard" : "১. স্টেপ-বাই-স্টেপ প্যালিনড্রোম পার্টিশনিং ফ্লো-কার্ড",
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
                ? "Watch how palindrome cuts form valid partition paths."
                : "প্যালিনড্রোম কাট কীভাবে বৈধ পার্টিশন গঠন করে তা দেখুন।",
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

                // Active Substring & Path Display
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Tested Substring: '$sub'", style: TextStyle(color: badgeColor, fontWeight: FontWeight.bold, fontSize: 12)),
                    Text("Partitions: ${currentPath.length}", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
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
                    "[ ${currentPath.map((e) => '"$e"').join(' , ')} ]",
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

  // MODEL 2: Two-Pointer Palindrome Checker
  Widget _buildTwoPointerCheckerModel() {
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
            _isEnglish ? "2. Two-Pointer Palindrome Checker (left -> <- right)" : "২. টু-পয়েন্টার প্যালিনড্রোম চেকার (left -> <- right)",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            _isEnglish
                ? "Compare characters from both ends moving inward: while (left < right) if (s[left] != s[right]) return false;"
                : "দুই প্রান্ত থেকে ভেতরের দিকে অক্ষর তুলনা করুন: while (left < right) if (s[left] != s[right]) return false;",
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
              "isPalindrome(\"aa\") ➔ 'a' == 'a' ➔ TRUE ✅",
              style: TextStyle(fontFamily: 'monospace', fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.accentGreen),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  // MODEL 3: Substring Cut Tree
  Widget _buildCutTreeModel() {
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
            _isEnglish ? "3. Substring Partition Cut Tree ('a|a|b' vs 'aa|b')" : "৩. সাবস্ট্রিং পার্টিশন কাট ট্রি ('a|a|b' বনাম 'aa|b')",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            _isEnglish
                ? "Visualizing valid partition cut points (|) along string 'aab'."
                : "স্ট্রিং 'aab' এর সাথে বৈধ পার্টিশন কাট পয়েন্টগুলো (|) পর্যবেক্ষণ।",
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
              "Partition 1: a | a | b ➔ [\"a\", \"a\", \"b\"]\nPartition 2: aa | b ➔ [\"aa\", \"b\"]",
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
                        controller: _inputController,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          labelText: _isEnglish ? "Custom String (e.g. aab)" : "কাস্টম স্ট্রিং (যেমন aab)",
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
                      _buildPresetChip("aab"),
                      _buildPresetChip("racecar"),
                      _buildPresetChip("aba"),
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
                  _buildPalindromePartitioningCanvas(step),
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildCodeHighlightBox(step.activeLine)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildPalindromePartitioningCanvas(step)),
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
    final targetTotal = _calculateUniquePartitionsCount(_inputStr);

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
                  ? "Build all $targetTotal palindrome partitions for string '$_inputStr' by choosing cut endpoints!"
                  : "স্ট্রিং '$_inputStr' এর জন্য সবকটি $targetTotal টি প্যালিনড্রোম পার্টিশন তৈরি করতে কাট ইনডেক্স নির্বাচন করুন!",
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
                        _isEnglish ? "Discovered: ${_practiceResults.length} / $targetTotal Partitions" : "সংগৃহীত: ${_practiceResults.length} / $targetTotal টি পার্টিশন",
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

            // Current Path Box
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
                      Text("Start Index: $_practiceStart / ${_inputStr.length}", style: const TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 12)),
                      Text("Input = '$_inputStr'", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "[ ${_practiceCurrentPath.map((e) => '"$e"').join(' , ')} ]",
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

            // Cut End Index Buttons
            if (!_practiceSolved && _practiceStart < _inputStr.length) ...[
              Text(
                _isEnglish
                    ? "Select end index i >= $_practiceStart to cut substring s[$_practiceStart..i]:"
                    : "সাবস্ট্রিং s[$_practiceStart..i] কাটার জন্য ইনডেক্স i >= $_practiceStart নির্বাচন করুন:",
                style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: List.generate(_inputStr.length - _practiceStart, (offset) {
                  int endIdx = _practiceStart + offset;
                  String sub = _inputStr.substring(_practiceStart, endIdx + 1);
                  bool isPalin = _checkPalindrome(_inputStr, _practiceStart, endIdx);

                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isPalin ? AppTheme.accentGreen : AppTheme.surfaceDark,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onPressed: () => _handlePracticeCut(endIdx),
                    child: Text("Cut '$sub' (end: $endIdx)", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  );
                }),
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

            // Discovered Partitions List
            Text(
              _isEnglish
                  ? "Collected Valid Partitions (${_practiceResults.length} / $targetTotal):"
                  : "সংগৃহীত বৈধ পার্টিশনসমূহ (${_practiceResults.length} / $targetTotal):",
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
                ? const Text("[ No Partitions Collected Yet ]", style: TextStyle(color: AppTheme.textMuted, fontSize: 12))
                : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _practiceResults.map((part) {
                      return Chip(
                        backgroundColor: AppTheme.surfaceDark,
                        avatar: const Icon(Icons.check_circle, color: AppTheme.accentGreen, size: 16),
                        label: Text(
                          "[ ${part.map((e) => '"$e"').join(', ')} ]",
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
      "void backtrack(int start, string& s, vector<string>& path, vector<vector<string>>& res) {",
      "    if (start == s.size()) {",
      "        res.push_back(path); // Save valid partition!",
      "        return;",
      "    }",
      "    for (int i = start; i < s.size(); i++) {",
      "        if (isPalindrome(s, start, i)) {",
      "            path.push_back(s.substr(start, i - start + 1));",
      "            backtrack(i + 1, s, path, res);",
      "            path.pop_back(); // Backtrack",
      "        }",
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

  Widget _buildPalindromePartitioningCanvas(PalindromePartitioningStep step) {
    Color decisionColor = AppTheme.accentPurple;
    String decisionLabel = "INIT";

    if (step.decision == "valid_palindrome") {
      decisionColor = AppTheme.accentGreen;
      decisionLabel = "✅ PALINDROME (CUT)";
    } else if (step.decision == "not_palindrome") {
      decisionColor = AppTheme.accentPink;
      decisionLabel = "🛑 NOT PALINDROME";
    } else if (step.decision == "base_case") {
      decisionColor = AppTheme.accentGreen;
      decisionLabel = "🎉 PARTITION SAVED";
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
              Text("start = [${step.startIndex}], i = [${step.endIndex}]", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13)),
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

          // Substring & Active Path Display Box
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Sub: '${step.currentSubstring}'", style: TextStyle(color: decisionColor, fontWeight: FontWeight.bold, fontSize: 12)),
              Text("Path Size: ${step.currentPath.length}", style: const TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 12)),
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
              "[ ${step.currentPath.map((e) => '"$e"').join(' , ')} ]",
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

          // Saved Valid Partitions List
          const Text("Saved Palindrome Partitions:", style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
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
            child: step.allPartitions.isEmpty
                ? const Center(child: Text("[ No Partitions Saved Yet ]", style: TextStyle(color: AppTheme.textMuted, fontSize: 12)))
                : SingleChildScrollView(
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: step.allPartitions.map((part) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppTheme.accentGreen.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppTheme.accentGreen),
                          ),
                          child: Text(
                            "[ ${part.map((e) => '"$e"').join(', ')} ]",
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
    bool isPalindrome(const string& s, int left, int right) {
        while (left < right) {
            if (s[left++] != s[right--]) return false;
        }
        return true;
    }

    void backtrack(int start, string& s, vector<string>& path, vector<vector<string>>& res) {
        if (start == s.size()) {
            res.push_back(path);
            return;
        }
        for (int i = start; i < s.size(); i++) {
            if (isPalindrome(s, start, i)) {
                path.push_back(s.substr(start, i - start + 1));
                backtrack(i + 1, s, path, res);
                path.pop_back();
            }
        }
    }

    vector<vector<string>> partition(string s) {
        vector<vector<string>> res;
        vector<string> path;
        backtrack(0, s, path, res);
        return res;
    }
};""";
    } else if (lang == "Java") {
      code = """
class Solution {
    public List<List<String>> partition(String s) {
        List<List<String>> res = new ArrayList<>();
        backtrack(0, s, new ArrayList<>(), res);
        return res;
    }

    private void backtrack(int start, String s, List<String> path, List<List<String>> res) {
        if (start == s.length()) {
            res.add(new ArrayList<>(path));
            return;
        }
        for (int i = start; i < s.length(); i++) {
            if (isPalindrome(s, start, i)) {
                path.add(s.substring(start, i + 1));
                backtrack(i + 1, s, path, res);
                path.remove(path.size() - 1);
            }
        }
    }

    private boolean isPalindrome(String s, int left, int right) {
        while (left < right) {
            if (s.charAt(left++) != s.charAt(right--)) return false;
        }
        return true;
    }
}""";
    } else {
      code = """
class Solution:
    def partition(self, s: str) -> List[List[str]]:
        res = []

        def isPalindrome(left, right):
            while left < right:
                if s[left] != s[right]:
                    return False
                left += 1
                right -= 1
            return True

        def backtrack(start, path):
            if start == len(s):
                res.append(list(path))
                return
            for i in range(start, len(s)):
                if isPalindrome(start, i):
                    path.append(s[start:i+1])
                    backtrack(i + 1, path)
                    path.pop()

        backtrack(0, [])
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
