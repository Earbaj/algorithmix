import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class CombinationSumIIStep {
  final int startIndex;
  final int currentIndex;
  final List<int> currentPath;
  final int currentSum;
  final int remainingTarget;
  final List<List<int>> allCombinations;
  final String decision; // 'init', 'push_candidate', 'skip_duplicate', 'target_met', 'exceeded', 'backtrack'
  final int activeLine;
  final String actionEn;
  final String actionBn;
  final String reasonEn;
  final String reasonBn;
  final int callStackDepth;

  const CombinationSumIIStep({
    required this.startIndex,
    required this.currentIndex,
    required this.currentPath,
    required this.currentSum,
    required this.remainingTarget,
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

class CombinationSumIIDetailScreen extends StatefulWidget {
  const CombinationSumIIDetailScreen({super.key});

  @override
  State<CombinationSumIIDetailScreen> createState() => _CombinationSumIIDetailScreenState();
}

class _CombinationSumIIDetailScreenState extends State<CombinationSumIIDetailScreen>
    with SingleTickerProviderStateMixin {
  bool _isEnglish = true;
  late TabController _tabController;

  // Custom Input State
  final TextEditingController _candidatesController = TextEditingController(text: "2, 5, 2, 1, 2");
  final TextEditingController _targetController = TextEditingController(text: "5");
  List<int> _candidates = [1, 2, 2, 2, 5];
  int _target = 5;
  List<CombinationSumIIStep> _steps = [];

  // Playback Control
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  // Code Language Selector
  String _selectedCodeLang = "C++";

  // Tab 2 Animation Model Selector (0: Step Flowcard, 1: Single Use Stack, 2: Target Countdown)
  int _animationModelIndex = 0;
  int _flowStepIndex = 0;

  // Practice Mode State
  int _practiceStart = 0;
  List<int> _practiceCurrentPath = [];
  List<List<int>> _practiceResults = [];
  List<String> _practiceHistory = [];
  String _userFeedbackEn = "Choose candidates to PUSH or SKIP DUPLICATES to reach target!";
  String _userFeedbackBn = "টার্গেটে পৌঁছাতে ক্যান্ডিডেট যোগ বা ডুপ্লিকেট স্কিপ করুন!";
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
    _candidatesController.dispose();
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

    // Parse candidates & target
    try {
      List<int> parsed = _candidatesController.text
          .split(',')
          .map((e) => int.parse(e.trim()))
          .toList();
      if (parsed.isEmpty) parsed = [2, 5, 2, 1, 2];
      if (parsed.length > 5) parsed = parsed.sublist(0, 5);
      parsed.sort(); // Sorting required for Combination Sum II!
      _candidates = parsed;

      _target = int.parse(_targetController.text.trim());
      if (_target <= 0) _target = 5;
    } catch (_) {
      _candidates = [1, 2, 2, 2, 5];
      _target = 5;
    }

    _steps = _generateSteps(_candidates, _target);

    // Reset practice mode
    _practiceStart = 0;
    _practiceCurrentPath = [];
    _practiceResults = [];
    _practiceHistory = [];
    _practiceSolved = false;
    _userFeedbackEn = "Choose candidates to PUSH or SKIP DUPLICATES to reach target $_target!";
    _userFeedbackBn = "টার্গেট $_target এ পৌঁছাতে ক্যান্ডিডেট যোগ বা ডুপ্লিকেট স্কিপ করুন!";
  }

  List<CombinationSumIIStep> _generateSteps(List<int> sortedCandidates, int targetVal) {
    List<CombinationSumIIStep> steps = [];
    List<List<int>> results = [];
    List<int> path = [];

    // Step 0: Init & Sort
    steps.add(CombinationSumIIStep(
      startIndex: 0,
      currentIndex: 0,
      currentPath: [],
      currentSum: 0,
      remainingTarget: targetVal,
      allCombinations: [],
      decision: "init",
      activeLine: 1,
      actionEn: "Line 1: Sort candidates [${sortedCandidates.join(', ')}] & start target = $targetVal.",
      actionBn: "লাইন ১: ক্যান্ডিডেট [${sortedCandidates.join(', ')}] সর্ট এবং টার্গেট = $targetVal শুরু।",
      reasonEn: "Sorting groups identical numbers so duplicate combinations can be pruned cleanly.",
      reasonBn: "সর্টিং একই সংখ্যাগুলোকে পাশাপাশি রাখে যাতে ডুপ্লিকেট কম্বিনেশন স্কিপ করা যায়।",
      callStackDepth: 0,
    ));

    void backtrack(int start, int remain, int depth) {
      if (remain == 0) {
        results.add(List.from(path));
        steps.add(CombinationSumIIStep(
          startIndex: start,
          currentIndex: start,
          currentPath: List.from(path),
          currentSum: targetVal,
          remainingTarget: 0,
          allCombinations: List.from(results),
          decision: "target_met",
          activeLine: 3,
          actionEn: "🎉 Line 3: Target Met (remain = 0)! Saved combination [${path.join(', ')}].",
          actionBn: "🎉 লাইন ৩: টার্গেট অর্জিত (remain = 0)! কম্বিনেশন [${path.join(', ')}] সংরক্ষিত।",
          reasonEn: "Sum of elements equals target. Save valid combination.",
          reasonBn: "উপাদানগুলোর যোগফল টার্গেটের সমান। কম্বিনেশন সংরক্ষণ করো।",
          callStackDepth: depth,
        ));
        return;
      }

      for (int i = start; i < sortedCandidates.length; i++) {
        int val = sortedCandidates[i];

        // Prune if candidate > remain
        if (val > remain) {
          steps.add(CombinationSumIIStep(
            startIndex: start,
            currentIndex: i,
            currentPath: List.from(path),
            currentSum: targetVal - remain,
            remainingTarget: remain,
            allCombinations: List.from(results),
            decision: "exceeded",
            activeLine: 6,
            actionEn: "🔴 Line 6: Candidate '$val' > remaining ($remain). Prune branch!",
            actionBn: "🔴 লাইন ৬: ক্যান্ডিডেট '$val' > অবশিষ্ট ($remain)। ব্রাঞ্চ ছাঁটাই!",
            reasonEn: "Since candidates are sorted, all subsequent elements will also exceed target.",
            reasonBn: "ক্যান্ডিডেটগুলো সর্টেড হওয়ায় পরবর্তী সমস্ত উপাদানও টার্গেট ছাড়িয়ে যাবে।",
            callStackDepth: depth,
          ));
          break;
        }

        // Check duplicate rule: if (i > start && candidates[i] == candidates[i-1]) continue;
        if (i > start && sortedCandidates[i] == sortedCandidates[i - 1]) {
          steps.add(CombinationSumIIStep(
            startIndex: start,
            currentIndex: i,
            currentPath: List.from(path),
            currentSum: targetVal - remain,
            remainingTarget: remain,
            allCombinations: List.from(results),
            decision: "skip_duplicate",
            activeLine: 7,
            actionEn: "🛑 Line 7: Skip Duplicate candidate '$val' at index $i (i > start && candidates[i] == candidates[i-1]).",
            actionBn: "🛑 লাইন ৭: ইনডেক্স $i এ ডুপ্লিকেট ক্যান্ডিডেট '$val' বাদ দেওয়া হলো।",
            reasonEn: "Candidate '$val' was already processed at index ${i - 1} at this recursion level.",
            reasonBn: "এই রিকার্সন লেভেলে ইনডেক্স ${i - 1} এ '$val' ইতিমধ্যেই প্রসেস করা হয়েছে।",
            callStackDepth: depth,
          ));
          continue;
        }

        path.add(val);
        steps.add(CombinationSumIIStep(
          startIndex: start,
          currentIndex: i,
          currentPath: List.from(path),
          currentSum: targetVal - (remain - val),
          remainingTarget: remain - val,
          allCombinations: List.from(results),
          decision: "push_candidate",
          activeLine: 8,
          actionEn: "Line 8: Push candidate '$val' ➔ Path = [${path.join(', ')}], Remain = ${remain - val}.",
          actionBn: "লাইন ৮: ক্যান্ডিডেট '$val' যোগ ➔ Path = [${path.join(', ')}], Remain = ${remain - val}।",
          reasonEn: "Valid choice. Recurse to i + 1 (single use constraint).",
          reasonBn: "বৈধ নির্বাচন। i + 1 এ রিকার্সন চালাও (একবার ব্যবহারের শর্তে)।",
          callStackDepth: depth + 1,
        ));

        backtrack(i + 1, remain - val, depth + 1);

        // Backtrack
        path.removeLast();
        steps.add(CombinationSumIIStep(
          startIndex: start,
          currentIndex: i,
          currentPath: List.from(path),
          currentSum: targetVal - remain,
          remainingTarget: remain,
          allCombinations: List.from(results),
          decision: "backtrack",
          activeLine: 10,
          actionEn: "Line 10: Backtrack ↩️ Pop last element '$val' ➔ Reverted to [${path.join(', ')}].",
          actionBn: "লাইন ১০: ব্যাকট্র্যাক ↩️ শেষ উপাদান '$val' বাদ ➔ পুনর্বহাল [${path.join(', ')}]।",
          reasonEn: "Restore state for next iteration.",
          reasonBn: "পরবর্তী ইটারেশনের জন্য অবস্হা পুনর্বহাল করো।",
          callStackDepth: depth,
        ));
      }
    }

    backtrack(0, targetVal, 0);

    // Final Step
    steps.add(CombinationSumIIStep(
      startIndex: sortedCandidates.length,
      currentIndex: sortedCandidates.length,
      currentPath: [],
      currentSum: 0,
      remainingTarget: 0,
      allCombinations: List.from(results),
      decision: "target_met",
      activeLine: 12,
      actionEn: "🎉 Line 12: Backtracking Complete! Generated total ${results.length} unique combinations!",
      actionBn: "🎉 লাইন ১২: ব্যাকট্র্যাকিং সম্পূর্ণ! মোট ${results.length} টি অনন্য কম্বিনেশন তৈরি সম্পন্ন!",
      reasonEn: "All decision branches for target $targetVal fully traversed.",
      reasonBn: "টার্গেট $targetVal এর সমস্ত সিদ্ধান্ত চয়েস পরীক্ষা সম্পন্ন হয়েছে।",
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

  int _calculateUniqueCombinationsCount(List<int> sortedCandidates, int targetVal) {
    Set<String> unique = {};
    List<int> path = [];

    void bt(int start, int remain) {
      if (remain == 0) {
        unique.add(path.join(','));
        return;
      }
      for (int i = start; i < sortedCandidates.length; i++) {
        if (sortedCandidates[i] > remain) break;
        if (i > start && sortedCandidates[i] == sortedCandidates[i - 1]) continue;
        path.add(sortedCandidates[i]);
        bt(i + 1, remain - sortedCandidates[i]);
        path.removeLast();
      }
    }

    bt(0, targetVal);
    return unique.length;
  }

  void _handlePracticePush(int val, int idx) {
    if (_practiceSolved) return;

    final targetTotal = _calculateUniqueCombinationsCount(_candidates, _target);

    setState(() {
      _practiceCurrentPath.add(val);
      _practiceHistory.add("PUSH $val");

      int currentSum = _practiceCurrentPath.fold(0, (a, b) => a + b);

      if (currentSum == _target) {
        List<int> copy = List.from(_practiceCurrentPath);
        copy.sort();
        bool exists = _practiceResults.any((c) => c.join(',') == copy.join(','));

        if (!exists) {
          _practiceResults.add(copy);
          _userFeedbackEn = "🎉 Target Met! Unique Combination [${copy.join(', ')}] Saved! (${_practiceResults.length} / $targetTotal)";
          _userFeedbackBn = "🎉 টার্গেট অর্জিত! অনন্য কম্বিনেশন [${copy.join(', ')}] সংরক্ষিত! (${_practiceResults.length} / $targetTotal)";
        } else {
          _userFeedbackEn = "ℹ️ Combination [${copy.join(', ')}] was already collected. Try another branch!";
          _userFeedbackBn = "ℹ️ কম্বিনেশন [${copy.join(', ')}] ইতিমধ্যেই সংগৃহীত হয়েছে। অন্য ব্রাঞ্চ চেষ্টা করুন!";
        }

        // Reset for next combination
        _practiceCurrentPath = [];

        if (_practiceResults.length >= targetTotal) {
          _practiceSolved = true;
          _userFeedbackEn = "🏆 MASTERED! You generated all $targetTotal unique combinations for target $_target!";
          _userFeedbackBn = "🏆 দারুণ! আপনি টার্গেট $_target এর জন্য সবকটি $targetTotal টি অনন্য কম্বিনেশন বানিয়ে ফেলেছেন!";
        }
      } else if (currentSum > _target) {
        _userFeedbackEn = "🔴 Exceeded Target! Sum ($currentSum) > $_target. Click Undo to backtrack!";
        _userFeedbackBn = "🔴 টার্গেট অতিক্রান্ত! যোগফল ($currentSum) > $_target। ব্যাকট্র্যাক করতে Undo চাপুন!";
      } else {
        _userFeedbackEn = "✅ Pushed $val! Current Sum = $currentSum / $_target (Remain = ${_target - currentSum}).";
        _userFeedbackBn = "✅ $val যোগ করা হলো! বর্তমান যোগফল = $currentSum / $_target (অবশিষ্ট = ${_target - currentSum})।";
      }
    });
  }

  void _undoPracticeMove() {
    if (_practiceHistory.isNotEmpty) {
      setState(() {
        _practiceHistory.removeLast();
        if (_practiceCurrentPath.isNotEmpty) {
          _practiceCurrentPath.removeLast();
        }
        int currentSum = _practiceCurrentPath.fold(0, (a, b) => a + b);
        _userFeedbackEn = "↩️ Undid last move. Path = [${_practiceCurrentPath.join(', ')}], Sum = $currentSum.";
        _userFeedbackBn = "↩️ পূর্ববর্তী ধাপ বাতিল করা হলো। Path = [${_practiceCurrentPath.join(', ')}], Sum = $currentSum।";
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
          '40. Combination Sum II',
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
                    "40. Combination Sum II",
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
                        ? "Given a collection of candidate numbers (candidates) and a target number (target), find all unique combinations in candidates where the candidate numbers sum to target. Each number in candidates may only be used ONCE in the combination."
                        : "ক্যান্ডিডেট সংখ্যার সংকলন এবং একটি টার্গেট সংখ্যা দেওয়া আছে। যোগফল টার্গেটের সমান হওয়া সমস্ত অনন্য কম্বিনেশন খুঁজুন। প্রতিটি সংখ্যা কেবল একবার ব্যবহারযোগ্য।",
                    style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Examples
            Text(_isEnglish ? "Examples" : "উদাহরণসমূহ", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            _buildExampleCard("Example 1", "candidates = [10,1,2,7,6,1,5], target = 8", "Output: [[1,1,6],[1,2,5],[1,7],[2,6]]"),
            _buildExampleCard("Example 2", "candidates = [2,5,2,1,2], target = 5", "Output: [[1,2,2],[5]]"),
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
                        _isEnglish ? "Key Intuition (Sort + Single Use (i+1) + Duplicate Skipping)" : "মূল আইডিয়া (সর্টিং + একবার ব্যবহার + ডুপ্লিকেট স্কিপ)",
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isEnglish
                        ? "1. Sort candidates first ([1, 1, 2, 5, 6, 7, 10]).\n2. Recurse to i + 1 (single use per candidate).\n3. Skip duplicates at same depth: if (i > start && candidates[i] == candidates[i-1]) continue;."
                        : "১. ক্যান্ডিডেটগুলো সর্ট করুন ([1, 1, 2, 5, 6, 7, 10])।\n২. i + 1 এ রিকার্সন চালান (একবার ব্যবহার সীমাবদ্ধতা)।\n৩. একই ডালপালায় ডুপ্লিকেট বাদ দিন: if (i > start && candidates[i] == candidates[i-1]) continue।",
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
              _isEnglish ? "Combination Sum II Visual Models (Concept Explanations)" : "কম্বিনেশন সাম II ভিজ্যুয়াল মডেলসমূহ (কোডহীন গাইড)",
              style: TextStyle(fontSize: Responsive.sp(context, 18), fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 6),
            Text(
              _isEnglish
                  ? "Explore 3 interactive models for candidates = [1, 2, 2, 2, 5], target = 5."
                  : "ক্যান্ডিডেট = [1, 2, 2, 2, 5], টার্গেট = 5 এর জন্য ৩টি ইন্টারঅ্যাক্টিভ ভিজ্যুয়াল মডেল পর্যবেক্ষণ করুন।",
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 16),

            // Model Switcher Segmented Control
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildAnimationModelChip(0, _isEnglish ? "1. 🪜 Step Flowcard" : "১. 🪜 স্টেপ-বাই-স্টেপ ফ্লো-কার্ড"),
                  _buildAnimationModelChip(1, _isEnglish ? "2. 🥞 Single Use Stack (i+1)" : "২. 🥞 সিঙ্গেল ইউজ স্ট্যাক (i+1)"),
                  _buildAnimationModelChip(2, _isEnglish ? "3. 🎯 Target Countdown" : "৩. 🎯 টার্গেট কাউন্টডাউন বিয়োগ"),
                ],
              ),
            ),
            const SizedBox(height: 20),

            if (_animationModelIndex == 0) _buildStepFlowcardModel(),
            if (_animationModelIndex == 1) _buildSingleUseStackModel(),
            if (_animationModelIndex == 2) _buildTargetCountdownModel(),

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
        "path": [],
        "remain": 5,
        "badge": "INIT",
        "badgeColor": AppTheme.accentNeonCyan,
        "titleEn": "Step 1: Start at Target = 5 with candidates [1, 2, 2, 2, 5]",
        "titleBn": "ধাপ ১: টার্গেট = 5 নিয়ে ক্যান্ডিডেট [1, 2, 2, 2, 5] এ শুরু",
        "descEn": "Sorted candidates [1, 2, 2, 2, 5]. Next: Push candidate '1' at index 0.",
        "descBn": "সর্টেড ক্যান্ডিডেট [1, 2, 2, 2, 5]। পরবর্তী: ইনডেক্স ০ এর '1' যোগ।",
      },
      {
        "step": 2,
        "path": [1],
        "remain": 4,
        "badge": "PUSH '1' (i+1)",
        "badgeColor": AppTheme.accentAmber,
        "titleEn": "Step 2: Push candidate '1' ➔ Path = [1], Remain = 4",
        "titleBn": "ধাপ ২: ক্যান্ডিডেট '1' যোগ ➔ Path = [1], Remain = 4",
        "descEn": "Path = [1], Remain = 4. Next: Push candidate '2' at index 1.",
        "descBn": "Path = [1], Remain = 4। পরবর্তী: ইনডেক্স ১ এর '2' যোগ।",
      },
      {
        "step": 3,
        "path": [1, 2],
        "remain": 2,
        "badge": "PUSH '2' (i+1)",
        "badgeColor": AppTheme.accentAmber,
        "titleEn": "Step 3: Push candidate '2' ➔ Path = [1, 2], Remain = 2",
        "titleBn": "ধাপ ৩: ক্যান্ডিডেট '2' যোগ ➔ Path = [1, 2], Remain = 2",
        "descEn": "Path = [1, 2], Remain = 2. Next: Push second candidate '2' at index 2.",
        "descBn": "Path = [1, 2], Remain = 2। পরবর্তী: ইনডেক্স ২ এর '2' যোগ।",
      },
      {
        "step": 4,
        "path": [1, 2, 2],
        "remain": 0,
        "badge": "🎉 TARGET MET (0)",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 4: Push candidate '2' ➔ Target Met! Saved [1, 2, 2]",
        "titleBn": "ধাপ ৪: ক্যান্ডিডেট '2' যোগ ➔ টার্গেট অর্জিত! [1, 2, 2] সংরক্ষিত",
        "descEn": "Remain = 0 🎉 Saved valid unique combination [1, 2, 2]!",
        "descBn": "Remain = 0 🎉 অনন্য কম্বিনেশন [1, 2, 2] সংরক্ষিত!",
      },
      {
        "step": 5,
        "path": [1, 2],
        "remain": 2,
        "badge": "🛑 SKIP DUPLICATE '2'",
        "badgeColor": AppTheme.accentPink,
        "titleEn": "Step 5: Skip Duplicate '2' at index 3!",
        "titleBn": "ধাপ ৫: ইনডেক্স ৩ এর ডুপ্লিকেট '2' বাদ দেওয়া হলো!",
        "descEn": "i > start && candidates[3] == candidates[2] ('2' == '2'). Skipped duplicate combination!",
        "descBn": "i > start এবং candidates[3] == candidates[2]। ডুপ্লিকেট কম্বিনেশন ছাঁটাই!",
      },
      {
        "step": 6,
        "path": [5],
        "remain": 0,
        "badge": "🎉 TARGET MET (0)",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 6: Push candidate '5' at index 4 ➔ Saved [5]",
        "titleBn": "ধাপ ৬: ইনডেক্স ৪ এর ক্যান্ডিডেট '5' যোগ ➔ [5] সংরক্ষিত",
        "descEn": "Remain = 0 🎉 Saved second unique combination [5]!",
        "descBn": "Remain = 0 🎉 দ্বিতীয় অনন্য কম্বিনেশন [5] সংরক্ষিত!",
      },
      {
        "step": 7,
        "path": [],
        "remain": 0,
        "badge": "🏆 FINISHED",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 7: Traversal Complete! Total 2 Unique Combinations",
        "titleBn": "ধাপ ৭: ব্যাকট্র্যাকিং সম্পূর্ণ! মোট ২টি অনন্য কম্বিনেশন",
        "descEn": "Generated 2 unique combinations: [[1, 2, 2], [5]] for target = 5!",
        "descBn": "টার্গেট 5 এর জন্য মোট ২টি অনন্য কম্বিনেশন তৈরি সম্পন্ন: [[1, 2, 2], [5]]!",
      },
    ];

    final currentStep = stepFlowData[_flowStepIndex.clamp(0, stepFlowData.length - 1)];
    final List<int> currentPath = (currentStep["path"] as List).cast<int>();
    final int remain = currentStep["remain"] as int;
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
                _isEnglish ? "1. Step-by-Step Combination Sum II Flowcard" : "১. স্টেপ-বাই-স্টেপ কম্বিনেশন সাম II ফ্লো-কার্ড",
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
                ? "Watch how single-use constraint (i+1) and duplicate pruning work step-by-step."
                : "একবার ব্যবহারের শর্ত (i+1) এবং ডুপ্লিকেট স্কিপিং কীভাবে কাজ করে তা দেখুন।",
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

                // Active Path & Remaining Target Box
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Active Path: [${currentPath.join(', ')}]", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
                    Text("Remain = $remain / $_target", style: TextStyle(color: badgeColor, fontWeight: FontWeight.bold, fontSize: 12)),
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
                    "[ ${currentPath.join(' , ')} ]",
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

  // MODEL 2: Single Use Stack
  Widget _buildSingleUseStackModel() {
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
            _isEnglish ? "2. Single-Use Constraint (i + 1 Recursion Move)" : "২. একবার ব্যবহারের শর্ত (i + 1 রিকার্সন স্লাইড)",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            _isEnglish
                ? "Unlike Combination Sum I which recurses to i (reuse allowed), Combination Sum II moves to i + 1."
                : "Combination Sum I এর মতো i (পুনর্ব্যবহার) এর পরিবর্তে Combination Sum II i + 1 এ বৃদ্ধি পায়।",
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.accentAmber),
            ),
            child: const Text(
              "backtrack(i + 1, remain - candidates[i]); ➔ Move to NEXT index!",
              style: TextStyle(fontFamily: 'monospace', fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.accentAmber),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  // MODEL 3: Target Countdown
  Widget _buildTargetCountdownModel() {
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
            _isEnglish ? "3. Target Countdown Subtraction Meter" : "৩. টার্গেট কাউন্টডাউন বিয়োগ মিটার",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            _isEnglish
                ? "Subtract candidate value from target until remain == 0."
                : "remain == 0 না হওয়া পর্যন্ত ক্যান্ডিডেটের মান বিয়োগ করুন।",
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
              "Target 5 ➔ -1 ➔ 4 ➔ -2 ➔ 2 ➔ -2 ➔ 0 🎉 (Target Met!)",
              style: TextStyle(fontFamily: 'monospace', fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.accentGreen),
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
                        controller: _candidatesController,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          labelText: _isEnglish ? "Candidates (e.g. 2,5,2,1,2)" : "ক্যান্ডিডেট (যেমন 2,5,2,1,2)",
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
                      _buildPresetChip("2, 5, 2, 1, 2", "5"),
                      _buildPresetChip("10, 1, 2, 7, 6, 1, 5", "8"),
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
                  _buildCombinationSumIICanvas(step),
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildCodeHighlightBox(step.activeLine)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildCombinationSumIICanvas(step)),
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
    final targetTotal = _calculateUniqueCombinationsCount(_candidates, _target);

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
                  ? "Build all $targetTotal unique combinations for target $_target by selecting candidates!"
                  : "টার্গেট $_target এর জন্য সবকটি $targetTotal টি অনন্য কম্বিনেশন তৈরি করতে ক্যান্ডিডেট নির্বাচন করুন!",
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
                      Text("Sum = ${_practiceCurrentPath.fold(0, (a, b) => a + b)} / $_target", style: const TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 12)),
                      Text("Sorted: [${_candidates.join(', ')}]", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "[ ${_practiceCurrentPath.join(' , ')} ]",
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

            // Push Candidate Choice Buttons
            if (!_practiceSolved) ...[
              Text(
                _isEnglish ? "Push candidate element to path:" : "পাথে ক্যান্ডিডেট উপাদান যোগ করুন:",
                style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: List.generate(_candidates.length, (idx) {
                  int val = _candidates[idx];
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accentPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    ),
                    onPressed: () => _handlePracticePush(val, idx),
                    child: Text("Push '$val' (idx: $idx)", style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
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

            // Discovered Combinations List
            Text(
              _isEnglish
                  ? "Collected Unique Combinations (${_practiceResults.length} / $targetTotal):"
                  : "সংগৃহীত অনন্য কম্বিনেশনসমূহ (${_practiceResults.length} / $targetTotal):",
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
                ? const Text("[ No Unique Combinations Collected Yet ]", style: TextStyle(color: AppTheme.textMuted, fontSize: 12))
                : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _practiceResults.map((combo) {
                      return Chip(
                        backgroundColor: AppTheme.surfaceDark,
                        avatar: const Icon(Icons.check_circle, color: AppTheme.accentGreen, size: 16),
                        label: Text(
                          "[ ${combo.join(', ')} ]",
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
  Widget _buildPresetChip(String candVal, String targetVal) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ActionChip(
        backgroundColor: const Color(0xFF090D16),
        label: Text("[$candVal], t=$targetVal", style: const TextStyle(color: AppTheme.accentNeonCyan, fontSize: 11)),
        onPressed: () {
          _candidatesController.text = candVal;
          _targetController.text = targetVal;
          _rebuildSteps();
        },
      ),
    );
  }

  Widget _buildCodeHighlightBox(int activeLine) {
    final codeLines = [
      "void backtrack(int start, int target, vector<int>& candidates, vector<int>& path, vector<vector<int>>& res) {",
      "    if (target == 0) {",
      "        res.push_back(path); // Valid unique combination!",
      "        return;",
      "    }",
      "    for (int i = start; i < candidates.size(); i++) {",
      "        if (candidates[i] > target) break; // Prune",
      "        if (i > start && candidates[i] == candidates[i-1]) continue; // Skip duplicate",
      "        path.push_back(candidates[i]);",
      "        backtrack(i + 1, target - candidates[i], candidates, path, res); // i + 1 single use",
      "        path.pop_back(); // Backtrack",
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

  Widget _buildCombinationSumIICanvas(CombinationSumIIStep step) {
    Color decisionColor = AppTheme.accentPurple;
    String decisionLabel = "INIT";

    if (step.decision == "push_candidate") {
      decisionColor = AppTheme.accentAmber;
      decisionLabel = "➕ PUSH (i+1)";
    } else if (step.decision == "skip_duplicate") {
      decisionColor = AppTheme.accentPink;
      decisionLabel = "🛑 SKIP DUPLICATE";
    } else if (step.decision == "target_met") {
      decisionColor = AppTheme.accentGreen;
      decisionLabel = "🎉 TARGET MET";
    } else if (step.decision == "exceeded") {
      decisionColor = AppTheme.accentPink;
      decisionLabel = "🔴 EXCEEDED";
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
              Text("start = [${step.startIndex}], i = [${step.currentIndex}]", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13)),
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

          // Current Path & Target Remaining Display Box
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Sorted Candidates: [${_candidates.join(', ')}]", style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
              Text("Remain = ${step.remainingTarget} / $_target", style: TextStyle(color: decisionColor, fontWeight: FontWeight.bold, fontSize: 12)),
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
              "[ ${step.currentPath.join(' , ')} ]",
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

          // Saved Unique Combinations List
          const Text("Saved Unique Combinations:", style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
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
                            "[ ${combo.join(', ')} ]",
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
    void backtrack(int start, int target, vector<int>& candidates, vector<int>& path, vector<vector<int>>& res) {
        if (target == 0) {
            res.push_back(path);
            return;
        }
        for (int i = start; i < candidates.size(); i++) {
            if (candidates[i] > target) break; // Prune
            if (i > start && candidates[i] == candidates[i-1]) continue; // Skip duplicate
            path.push_back(candidates[i]);
            backtrack(i + 1, target - candidates[i], candidates, path, res);
            path.pop_back();
        }
    }

    vector<vector<int>> combinationSum2(vector<int>& candidates, int target) {
        sort(candidates.begin(), candidates.end()); // Sort first!
        vector<vector<int>> res;
        vector<int> path;
        backtrack(0, target, candidates, path, res);
        return res;
    }
};""";
    } else if (lang == "Java") {
      code = """
class Solution {
    public List<List<Integer>> combinationSum2(int[] candidates, int target) {
        Arrays.sort(candidates); // Sort first!
        List<List<Integer>> res = new ArrayList<>();
        backtrack(0, target, candidates, new ArrayList<>(), res);
        return res;
    }

    private void backtrack(int start, int target, int[] candidates, List<Integer> path, List<List<Integer>> res) {
        if (target == 0) {
            res.add(new ArrayList<>(path));
            return;
        }
        for (int i = start; i < candidates.length; i++) {
            if (candidates[i] > target) break;
            if (i > start && candidates[i] == candidates[i - 1]) continue;
            path.add(candidates[i]);
            backtrack(i + 1, target - candidates[i], candidates, path, res);
            path.remove(path.size() - 1);
        }
    }
}""";
    } else {
      code = """
class Solution:
    def combinationSum2(self, candidates: List[int], target: int) -> List[List[int]]:
        candidates.sort() # Sort first!
        res = []

        def backtrack(start, remain, path):
            if remain == 0:
                res.append(list(path))
                return
            for i in range(start, len(candidates)):
                if candidates[i] > remain:
                    break
                if i > start and candidates[i] == candidates[i - 1]:
                    continue
                path.append(candidates[i])
                backtrack(i + 1, remain - candidates[i], path)
                path.pop()

        backtrack(0, target, [])
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
