import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class CombinationSumStep {
  final int index;
  final List<int> currentCombination;
  final int currentSum;
  final List<List<int>> allCombinations;
  final String decision; // 'init', 'include_reuse', 'exclude_next', 'target_met', 'exceeded'
  final int activeLine;
  final String actionEn;
  final String actionBn;
  final String reasonEn;
  final String reasonBn;
  final int callStackDepth;

  const CombinationSumStep({
    required this.index,
    required this.currentCombination,
    required this.currentSum,
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

class CombinationSumDetailScreen extends StatefulWidget {
  const CombinationSumDetailScreen({super.key});

  @override
  State<CombinationSumDetailScreen> createState() => _CombinationSumDetailScreenState();
}

class _CombinationSumDetailScreenState extends State<CombinationSumDetailScreen>
    with SingleTickerProviderStateMixin {
  bool _isEnglish = true;
  late TabController _tabController;

  // Custom Input State
  final TextEditingController _candidatesController =
      TextEditingController(text: "2, 3, 6, 7");
  final TextEditingController _targetController =
      TextEditingController(text: "7");

  List<int> _currentCandidates = [2, 3, 6, 7];
  int _currentTarget = 7;
  List<CombinationSumStep> _steps = [];

  // Playback Control
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  // Code Language Selector
  String _selectedCodeLang = "C++";

  // Tab 2 Animation Model Selector (0: Decision Tree, 1: Target Balance Scale, 2: Candidate Multiplier)
  int _animationModelIndex = 0;
  String? _selectedTreeNodePath;
  int _treeStepIndex = 0;

  // Practice Mode State
  int _practiceIndex = 0;
  List<int> _practicePath = [];
  int _practiceSum = 0;
  List<List<int>> _practiceResults = [];
  List<String> _practiceHistory = [];
  String _userFeedbackEn = "Choose whether to REUSE current candidate or MOVE TO NEXT!";
  String _userFeedbackBn = "বর্তমান ক্যান্ডিডেট উপাদান পুনর্নবীকরণ (REUSE) করবেন নাকি পরবর্তী উপাদানে যাবেন সিদ্ধান্ত নিন!";
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

    // Parse candidates
    try {
      List<int> parsed = _candidatesController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .map((e) => int.parse(e))
          .toList();
      if (parsed.isEmpty) parsed = [2, 3, 6, 7];
      parsed.sort(); // Sort candidates for optimal backtracking
      _currentCandidates = parsed;
    } catch (_) {
      _currentCandidates = [2, 3, 6, 7];
    }

    // Parse target
    try {
      _currentTarget = int.parse(_targetController.text.trim());
      if (_currentTarget <= 0) _currentTarget = 7;
    } catch (_) {
      _currentTarget = 7;
    }

    _steps = _generateSteps(_currentCandidates, _currentTarget);

    // Reset practice mode
    _practiceIndex = 0;
    _practicePath = [];
    _practiceSum = 0;
    _practiceResults = [];
    _practiceHistory = [];
    _practiceSolved = false;
    _userFeedbackEn = "Choose whether to REUSE current candidate or MOVE TO NEXT!";
    _userFeedbackBn = "বর্তমান উপাদানটি পুনর্নবীকরণ করবেন নাকি পরবর্তী উপাদানে যাবেন সিদ্ধান্ত নিন!";
  }

  List<CombinationSumStep> _generateSteps(List<int> candidates, int target) {
    List<CombinationSumStep> steps = [];
    List<int> path = [];
    List<List<int>> results = [];

    // Step 0: Init
    steps.add(CombinationSumStep(
      index: 0,
      currentCombination: [],
      currentSum: 0,
      allCombinations: [],
      decision: "init",
      activeLine: 1,
      actionEn: "Line 1: Initialize Combination Sum backtrack for target = $target, candidates = [${candidates.join(', ')}].",
      actionBn: "লাইন ১: টার্গেট = $target এবং ক্যান্ডিডেট = [${candidates.join(', ')}] এর জন্য ব্যাকট্র্যাক শুরু।",
      reasonEn: "Each candidate can be reused unlimited times until sum >= target.",
      reasonBn: "যোগফল >= টার্গেট না হওয়া পর্যন্ত প্রতিটি উপাদান বারবার ব্যবহার করা যাবে।",
      callStackDepth: 0,
    ));

    void backtrack(int idx, int currSum, int depth) {
      if (currSum == target) {
        results.add(List.from(path));
        steps.add(CombinationSumStep(
          index: idx,
          currentCombination: List.from(path),
          currentSum: currSum,
          allCombinations: results.map((e) => List<int>.from(e)).toList(),
          decision: "target_met",
          activeLine: 3,
          actionEn: "🎉 Line 3: Target Met ($currSum == $target)! Combination [${path.join(', ')}] saved to results.",
          actionBn: "🎉 লাইন ৩: টার্গেট মিলে গেছে ($currSum == $target)! কম্বিনেশন [${path.join(', ')}] সংরক্ষিত হলো।",
          reasonEn: "Sum equals target. Add valid combination to output list.",
          reasonBn: "যোগফল টার্গেটের সমান। ভ্যালিড কম্বিনেশন আউটপুট লিস্টে যোগ করো।",
          callStackDepth: depth,
        ));
        return;
      }

      if (currSum > target || idx >= candidates.length) {
        steps.add(CombinationSumStep(
          index: idx >= candidates.length ? candidates.length - 1 : idx,
          currentCombination: List.from(path),
          currentSum: currSum,
          allCombinations: results.map((e) => List<int>.from(e)).toList(),
          decision: "exceeded",
          activeLine: 4,
          actionEn: currSum > target
              ? "Line 4: Prune branch! Sum ($currSum) exceeded target ($target). Backtracking."
              : "Line 4: Reached end of candidates without hitting target.",
          actionBn: currSum > target
              ? "লাইন ৪: ব্রাঞ্চ ছাঁটাই! যোগফল ($currSum) টার্গেট ($target) ছাড়িয়েছে। ব্যাকট্র্যাক করা হচ্ছে।"
              : "লাইন ৪: টার্গেট ছাড়াই ক্যান্ডিডেট শেষ প্রান্তে পৌঁছানো হয়েছে।",
          reasonEn: "Cannot reach target along this decision subtree.",
          reasonBn: "এই সিদ্ধান্ত সাবট্রিতে টার্গেট পাওয়া সম্ভব নয়।",
          callStackDepth: depth,
        ));
        return;
      }

      // Choice 1: REUSE candidate[idx]
      path.add(candidates[idx]);
      steps.add(CombinationSumStep(
        index: idx,
        currentCombination: List.from(path),
        currentSum: currSum + candidates[idx],
        allCombinations: results.map((e) => List<int>.from(e)).toList(),
        decision: "include_reuse",
        activeLine: 8,
        actionEn: "Line 8: Choice REUSE -> Added candidates[$idx] = ${candidates[idx]}. Sum = ${currSum + candidates[idx]}.",
        actionBn: "লাইন ৮: চয়েস REUSE -> candidates[$idx] = ${candidates[idx]} যোগ হলো। যোগফল = ${currSum + candidates[idx]}।",
        reasonEn: "Reuse element ${candidates[idx]} and recurse at same index $idx.",
        reasonBn: "উপাদান ${candidates[idx]} পুনরায় ব্যবহার করে একই ইনডেক্সে রিকার্সন চালাও।",
        callStackDepth: depth + 1,
      ));

      backtrack(idx, currSum + candidates[idx], depth + 1);

      // Backtrack: Remove candidate[idx]
      path.removeLast();

      // Choice 2: MOVE TO NEXT candidate (idx + 1)
      steps.add(CombinationSumStep(
        index: idx + 1,
        currentCombination: List.from(path),
        currentSum: currSum,
        allCombinations: results.map((e) => List<int>.from(e)).toList(),
        decision: "exclude_next",
        activeLine: 12,
        actionEn: "Line 12: Choice MOVE TO NEXT -> Skip candidates[$idx] = ${candidates[idx]} and advance to index ${idx + 1}.",
        actionBn: "লাইন ১২: চয়েস NEXT -> candidates[$idx] = ${candidates[idx]} স্কিপ করে ইনডেক্স ${idx + 1} এ অগ্রসর হও।",
        reasonEn: "Done exploring option with element ${candidates[idx]}. Move to next candidate.",
        reasonBn: "উপাদান ${candidates[idx]} দিয়ে অনুসন্ধান শেষ। পরবর্তী উপাদানে যাও।",
        callStackDepth: depth,
      ));

      backtrack(idx + 1, currSum, depth + 1);
    }

    backtrack(0, 0, 0);

    // Final Step
    steps.add(CombinationSumStep(
      index: candidates.length - 1,
      currentCombination: [],
      currentSum: 0,
      allCombinations: results.map((e) => List<int>.from(e)).toList(),
      decision: "target_met",
      activeLine: 14,
      actionEn: "🎉 Line 14: Backtracking Finished! Total ${results.length} unique combinations found for target = $target!",
      actionBn: "🎉 লাইন ১৪: ব্যাকট্র্যাকিং সম্পন্ন! টার্গেট = $target এর জন্য মোট ${results.length} টি অনন্য কম্বিনেশন পাওয়া গেছে!",
      reasonEn: "All decision branches fully traversed.",
      reasonBn: "সমস্ত সিদ্ধান্ত চয়েস সাবট্রি পরীক্ষা সম্পন্ন হয়েছে।",
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

  void _handlePracticeMove(String action) {
    if (_practiceSolved || _practiceIndex >= _currentCandidates.length) return;

    final currCandidate = _currentCandidates[_practiceIndex];

    setState(() {
      if (action == "reuse") {
        if (_practiceSum + currCandidate <= _currentTarget) {
          _practicePath.add(currCandidate);
          _practiceSum += currCandidate;
          _practiceHistory.add("REUSE ($currCandidate)");

          if (_practiceSum == _currentTarget) {
            List<int> combo = List.from(_practicePath);
            bool exists = _practiceResults.any((c) => c.length == combo.length && List.generate(c.length, (i) => c[i] == combo[i]).every((b) => b));
            if (!exists) {
              _practiceResults.add(combo);
              _userFeedbackEn = "🎉 Perfect! Combination [${combo.join(', ')}] sums to $_currentTarget!";
              _userFeedbackBn = "🎉 দারুণ! কম্বিনেশন [${combo.join(', ')}] এর যোগফল $_currentTarget!";
            } else {
              _userFeedbackEn = "ℹ️ Combination [${combo.join(', ')}] was already collected. Try other choices!";
              _userFeedbackBn = "ℹ️ কম্বিনেশন [${combo.join(', ')}] ইতিমধ্যেই সংগৃহীত হয়েছে!";
            }
            // Reset path for next branch
            _practicePath = [];
            _practiceSum = 0;
            _practiceIndex = 0;
          } else {
            _userFeedbackEn = "✅ Added $currCandidate. Current Sum = $_practiceSum / $_currentTarget. Keep going!";
            _userFeedbackBn = "✅ $currCandidate যোগ করা হলো। বর্তমান যোগফল = $_practiceSum / $_currentTarget।";
          }
        } else {
          _userFeedbackEn = "⚠️ Adding $currCandidate exceeds target ($_practiceSum + $currCandidate > $_currentTarget)! Choose MOVE NEXT.";
          _userFeedbackBn = "⚠️ $currCandidate যোগ করলে টার্গেট ছাড়িয়ে যাবে! NEXT চাপুন।";
        }
      } else if (action == "next") {
        _practiceHistory.add("NEXT");
        _practiceIndex++;
        if (_practiceIndex >= _currentCandidates.length) {
          _userFeedbackEn = "↩️ Reached end of candidates. Resetting path to explore new combinations.";
          _userFeedbackBn = "↩️ ক্যান্ডিডেট শেষ। নতুন কম্বিনেশনের জন্য রিসেট করা হলো।";
          _practicePath = [];
          _practiceSum = 0;
          _practiceIndex = 0;
        } else {
          _userFeedbackEn = "⚡ Advanced to next candidate: ${_currentCandidates[_practiceIndex]}. Current Sum = $_practiceSum.";
          _userFeedbackBn = "⚡ পরবর্তী উপাদানে স্থানান্তরিত: ${_currentCandidates[_practiceIndex]}।";
        }
      }

      // Check win state
      if (_practiceResults.length >= _steps.last.allCombinations.length && _steps.last.allCombinations.isNotEmpty) {
        _practiceSolved = true;
        _userFeedbackEn = "🏆 MASTERED! You found all ${_practiceResults.length} unique combinations!";
        _userFeedbackBn = "🏆 অভিনন্দন! আপনি সবকটি ${_practiceResults.length} টি কম্বিনেশন বের করে ফেলেছেন!";
      }
    });
  }

  void _undoPracticeMove() {
    if (_practiceHistory.isNotEmpty) {
      setState(() {
        final lastAction = _practiceHistory.removeLast();
        if (lastAction.startsWith("REUSE") && _practicePath.isNotEmpty) {
          final removedVal = _practicePath.removeLast();
          _practiceSum -= removedVal;
        } else if (lastAction == "NEXT" && _practiceIndex > 0) {
          _practiceIndex--;
        }
        _userFeedbackEn = "↩️ Undid last move. Sum = $_practiceSum / $_currentTarget.";
        _userFeedbackBn = "↩️ পূর্ববর্তী ধাপ বাতিল করা হলো। যোগফল = $_practiceSum / $_currentTarget।";
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
          '39. Combination Sum',
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
                    "39. Combination Sum",
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
              children: ["Meta", "Amazon", "Microsoft", "Google", "Bloomberg"].map((company) {
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
                        ? "Given an array of distinct integers candidates and a target integer target, return a list of all unique combinations of candidates where the chosen numbers sum to target. The same number may be chosen from candidates an unlimited number of times."
                        : "একটি ইউনিক ধনাত্মক সংখ্যার অ্যারে candidates এবং একটি লক্ষ্যমাত্রা target দেওয়া আছে। candidates থেকে এমন সব অনন্য কম্বিনেশন তৈরি করুন যাদের যোগফল target এর সমান হয়। যেকোনো উপাদান একাধিকবার ব্যবহার করা যাবে।",
                    style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Examples
            Text(_isEnglish ? "Examples" : "উদাহরণসমূহ", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            _buildExampleCard("Example 1", "candidates = [2,3,6,7], target = 7", "Output: [[2,2,3],[7]]"),
            _buildExampleCard("Example 2", "candidates = [2,3,5], target = 8", "Output: [[2,2,2,2],[2,3,3],[3,5]]"),
            _buildExampleCard("Example 3", "candidates = [2], target = 1", "Output: []"),
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
                        _isEnglish ? "Key Intuition (Unlimited Element Reuse & Pruning)" : "মূল আইডিয়া (উপাদান পুনর্নবীকরণ ও ছাঁটাই)",
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isEnglish
                        ? "Since elements can be reused unlimited times, when we REUSE candidate[idx], the index stays at idx. When we SKIP candidate[idx], we advance to idx + 1. If currSum > target, we immediately prune the branch!"
                        : "উপাদানসমূহ অনির্দিষ্টকাল ব্যবহার করা যায় বিধায়, REUSE চয়েসে ইনডেক্স একই পয়েন্টার idx এ থাকে। SKIP চয়েসে idx + 1 এ অগ্রসর হতে হয়। যোগফল টার্গেট ছাড়ালে অবিলম্বে ব্রাঞ্চ ছাঁটাই করা হয়!",
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
              _isEnglish ? "Combination Sum Visual Models (Concept Explanations)" : "কম্বিনেশন সাম ভিজ্যুয়াল মডেলসমূহ (কোডহীন গাইড)",
              style: TextStyle(fontSize: Responsive.sp(context, 18), fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 6),
            Text(
              _isEnglish
                  ? "Explore 3 interactive models for candidates = [2, 3, 6, 7], target = 7."
                  : "ক্যান্ডিডেট = [2, 3, 6, 7], টার্গেট = 7 এর জন্য ৩টি ইন্টারঅ্যাক্টিভ ভিজ্যুয়াল মডেল পর্যবেক্ষণ করুন।",
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 16),

            // Model Switcher Segmented Control
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildAnimationModelChip(0, _isEnglish ? "1. 🌲 Recursion Tree" : "১. 🌲 রিকার্সন চয়েস ট্রি"),
                  _buildAnimationModelChip(1, _isEnglish ? "2. ⚖️ Target Sum Scale" : "২. ⚖️ টার্গেট সাম স্কেল"),
                  _buildAnimationModelChip(2, _isEnglish ? "3. 🎚️ Candidate Multiplier" : "৩. 🎚️ ক্যান্ডিডেট মাল্টিপ্লায়ার"),
                ],
              ),
            ),
            const SizedBox(height: 20),

            if (_animationModelIndex == 0) _buildRecursionTreeModel(),
            if (_animationModelIndex == 1) _buildCurrentStackModel(),
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
  Widget _buildRecursionTreeModel() {
    final stepFlowData = [
      {
        "step": 1,
        "path": [],
        "sum": 0,
        "badge": "INIT",
        "badgeColor": AppTheme.accentNeonCyan,
        "titleEn": "Step 1: Start Recursion at Root Node",
        "titleBn": "ধাপ ১: রুট নোডে রিকার্সন শুরু",
        "descEn": "Path is empty []. Target is 7. First candidate to evaluate is 2.",
        "descBn": "Path এখন ফাঁকা []। টার্গেট 7। প্রথম টেস্ট করা ক্যান্ডিডেট 2।",
      },
      {
        "step": 2,
        "path": [2],
        "sum": 2,
        "badge": "➕ REUSE (2)",
        "badgeColor": AppTheme.accentAmber,
        "titleEn": "Step 2: Push candidate '2' into path",
        "titleBn": "ধাপ ২: ক্যান্ডিডেট '2' পাঠে যোগ করা হলো",
        "descEn": "Path = [2], Sum = 2 (< 7 🟡 Valid). Since elements can be reused, test '2' again.",
        "descBn": "Path = [2], Sum = 2 (< 7 🟡 ভ্যালিড)। উপাদান পুনর্নবীকরণযোগ্য হওয়ায় আবারও '2' চেষ্টা করো।",
      },
      {
        "step": 3,
        "path": [2, 2],
        "sum": 4,
        "badge": "➕ REUSE (2)",
        "badgeColor": AppTheme.accentAmber,
        "titleEn": "Step 3: Push candidate '2' again",
        "titleBn": "ধাপ ৩: আবারও ক্যান্ডিডেট '2' যোগ করা হলো",
        "descEn": "Path = [2, 2], Sum = 4 (< 7 🟡 Valid). Continue reusing candidate '2'.",
        "descBn": "Path = [2, 2], Sum = 4 (< 7 🟡 ভ্যালিড)। ক্যান্ডিডেট '2' যোগ করা চালিয়ে যাও।",
      },
      {
        "step": 4,
        "path": [2, 2, 2],
        "sum": 6,
        "badge": "➕ REUSE (2)",
        "badgeColor": AppTheme.accentAmber,
        "titleEn": "Step 4: Push candidate '2' third time",
        "titleBn": "ধাপ ৪: তৃতীয়বার ক্যান্ডিডেট '2' যোগ করা হলো",
        "descEn": "Path = [2, 2, 2], Sum = 6 (< 7 🟡 Valid). Continue reusing candidate '2'.",
        "descBn": "Path = [2, 2, 2], Sum = 6 (< 7 🟡 ভ্যালিড)। আরও একটি '2' টেস্ট করো।",
      },
      {
        "step": 5,
        "path": [2, 2, 2, 2],
        "sum": 8,
        "badge": "❌ EXCEEDED (> 7)",
        "badgeColor": AppTheme.accentPink,
        "titleEn": "Step 5: Push candidate '2' fourth time",
        "titleBn": "ধাপ ৫: চতুর্থবার ক্যান্ডিডেট '2' যোগ করা হলো",
        "descEn": "Path = [2, 2, 2, 2], Sum = 8 (> 7 🔴 EXCEEDED!). Pruning branch & Backtracking!",
        "descBn": "Path = [2, 2, 2, 2], Sum = 8 (> 7 🔴 টার্গেট অতিক্রান্ত!)। ব্রাঞ্চ ছাঁটাই ও ব্যাকট্র্যাক!",
      },
      {
        "step": 6,
        "path": [2, 2, 2],
        "sum": 6,
        "badge": "↩️ BACKTRACK (Pop 2)",
        "badgeColor": AppTheme.accentAmber,
        "titleEn": "Step 6: Backtrack (Pop last '2')",
        "titleBn": "ধাপ ৬: ব্যাকট্র্যাক (শেষ '2' বাদ)",
        "descEn": "Removed last 2. Path reverted to [2, 2, 2] (sum = 6). Next: Move to candidate '3'.",
        "descBn": "শেষ ২ বাদ। Path পুনর্বহাল [2, 2, 2] (Sum = 6)। পরবর্তী ক্যান্ডিডেট '3' এ যাও।",
      },
      {
        "step": 7,
        "path": [2, 2, 3],
        "sum": 7,
        "badge": "🎉 TARGET MET (7 == 7)",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 7: Push candidate '3'",
        "titleBn": "ধাপ ৭: ক্যান্ডিডেট '3' যোগ করা হলো",
        "descEn": "Path = [2, 2, 3], Sum = 7 (== 7 🟢 TARGET MET!). Saved valid combination [2, 2, 3]!",
        "descBn": "Path = [2, 2, 3], Sum = 7 (== 7 🟢 টার্গেট অর্জিত!)। কম্বিনেশন [2, 2, 3] সংরক্ষিত!",
      },
      {
        "step": 8,
        "path": [2, 3],
        "sum": 5,
        "badge": "↩️ BACKTRACK (Pop 3)",
        "badgeColor": AppTheme.accentAmber,
        "titleEn": "Step 8: Backtrack to Path = [2, 3]",
        "titleBn": "ধাপ ৮: ব্যাকট্র্যাক করে Path = [2, 3] এ ফেরত",
        "descEn": "Path = [2, 3], Sum = 5 (< 7 🟡 Valid). Explore next candidate options.",
        "descBn": "Path = [2, 3], Sum = 5 (< 7 🟡 ভ্যালিড)। পরবর্তী ক্যান্ডিডেট অনুসন্ধান করো।",
      },
      {
        "step": 9,
        "path": [7],
        "sum": 7,
        "badge": "🎉 TARGET MET (7 == 7)",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 9: Direct Push candidate '7'",
        "titleBn": "ধাপ ৯: সরাসরি ক্যান্ডিডেট '7' যোগ করা হলো",
        "descEn": "Path = [7], Sum = 7 (== 7 🟢 TARGET MET!). Saved second combination [7]!",
        "descBn": "Path = [7], Sum = 7 (== 7 🟢 টার্গেট অর্জিত!)। দ্বিতীয় কম্বিনেশন [7] সংরক্ষিত!",
      },
      {
        "step": 10,
        "path": [],
        "sum": 0,
        "badge": "🏆 FINISHED",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 10: Backtracking Traversal Complete!",
        "titleBn": "ধাপ ১০: ব্যাকট্র্যাকিং সম্পুর্ণ সম্পন্ন!",
        "descEn": "Found total 2 unique combinations: [[2, 2, 3], [7]] for target = 7.",
        "descBn": "টার্গেট 7 এর জন্য মোট ২টি অনন্য কম্বিনেশন অর্জিত: [[2, 2, 3], [7]]।",
      },
    ];

    final currentStep = stepFlowData[_treeStepIndex.clamp(0, stepFlowData.length - 1)];
    final List<int> currentPath = (currentStep["path"] as List).cast<int>();
    final int currentSum = currentStep["sum"] as int;
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
                _isEnglish ? "1. Step-by-Step Backtracking Flowcard" : "১. স্টেপ-বাই-স্টেপ ব্যাকট্র্যাকিং গাইড",
                style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
              ),
              Text(
                "Step ${_treeStepIndex + 1} / ${stepFlowData.length}",
                style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            _isEnglish
                ? "Follow the algorithm step-by-step to understand how candidates are pushed, evaluated, and backtracked."
                : "অ্যালগরিদম কীভাবে ক্যান্ডিডেট নির্বাচন করে, পরীক্ষা করে এবং ব্যাকট্র্যাক করে তা ধাপে ধাপে পর্যবেক্ষণ করুন।",
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

                // Path & Sum Meter
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Active Path (path):", style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                    Text("Sum = $currentSum / 7", style: TextStyle(color: badgeColor, fontWeight: FontWeight.bold, fontSize: 13)),
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
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: badgeColor,
                    ),
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
                      onPressed: _treeStepIndex > 0 ? () => setState(() => _treeStepIndex--) : null,
                    ),
                    IconButton(
                      icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, color: AppTheme.accentNeonCyan, size: 22),
                      onPressed: () {
                        setState(() => _isPlaying = !_isPlaying);
                        if (_isPlaying) {
                          _timer = Timer.periodic(const Duration(milliseconds: 1500), (t) {
                            if (_treeStepIndex < stepFlowData.length - 1) {
                              setState(() => _treeStepIndex++);
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
                      onPressed: _treeStepIndex < stepFlowData.length - 1 ? () => setState(() => _treeStepIndex++) : null,
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh, color: AppTheme.accentNeonCyan, size: 20),
                      onPressed: () {
                        _timer?.cancel();
                        setState(() {
                          _isPlaying = false;
                          _treeStepIndex = 0;
                        });
                      },
                    ),
                  ],
                ),
                Text(
                  "Step ${_treeStepIndex + 1} / ${stepFlowData.length}",
                  style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepTreeNodeCard(String title, String sumText, Color color, String nodePath, String activeNodePath) {
    final isActive = nodePath == activeNodePath;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isActive ? color.withOpacity(0.4) : AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isActive ? Colors.white : color, width: isActive ? 2.5 : 1.4),
        boxShadow: isActive
            ? [BoxShadow(color: color.withOpacity(0.8), blurRadius: 14)]
            : [BoxShadow(color: color.withOpacity(0.18), blurRadius: 6)],
      ),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isActive)
                const Padding(
                  padding: EdgeInsets.only(right: 4),
                  child: Icon(Icons.play_arrow, color: Colors.white, size: 14),
                ),
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isActive ? Colors.white : color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: color),
            ),
            child: Text(
              sumText,
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isActive ? Colors.white : color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalLine() {
    return Container(
      width: 2,
      height: 18,
      color: AppTheme.accentPurple.withOpacity(0.6),
    );
  }

  Widget _buildLegendChip(String label, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 11)),
    );
  }

  Widget _buildTreeNodeBox(String title, String desc, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1.5),
        boxShadow: [BoxShadow(color: color.withOpacity(0.15), blurRadius: 6)],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: color.withOpacity(0.2),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 4),
                Text(desc, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, height: 1.3)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // MODEL 2: The Current Stack (Push / Pop Array Memory Animation)
  Widget _buildCurrentStackModel() {
    final stackSteps = [
      {"action": "Push 2", "stack": [2], "sum": 2, "state": "valid", "msg": "Push 2 ➔ path = [2] (Sum = 2)"},
      {"action": "Push 2", "stack": [2, 2], "sum": 4, "state": "valid", "msg": "Push 2 ➔ path = [2, 2] (Sum = 4)"},
      {"action": "Push 2", "stack": [2, 2, 2], "sum": 6, "state": "valid", "msg": "Push 2 ➔ path = [2, 2, 2] (Sum = 6)"},
      {"action": "Push 2 ❌", "stack": [2, 2, 2, 2], "sum": 8, "state": "exceeded", "msg": "Push 2 ➔ path = [2, 2, 2, 2] (Sum 8 > 7)! EXCEEDED TARGET!"},
      {"action": "Pop 2 ↩️", "stack": [2, 2, 2], "sum": 6, "state": "pop", "msg": "Pop 2 (Backtrack) ➔ Revert path to [2, 2, 2]"},
      {"action": "Pop 2 ↩️", "stack": [2, 2], "sum": 4, "state": "pop", "msg": "Pop 2 (Backtrack) ➔ Revert path to [2, 2]"},
      {"action": "Push 3 🎉", "stack": [2, 2, 3], "sum": 7, "state": "success", "msg": "Push 3 ➔ path = [2, 2, 3] (Sum 7 == 7)! TARGET MET!"},
    ];

    final currentStackStep = stackSteps[_currentStepIndex.clamp(0, stackSteps.length - 1)];
    final List<int> stackList = currentStackStep["stack"] as List<int>;
    final int sumVal = currentStackStep["sum"] as int;
    final String stateStr = currentStackStep["state"] as String;
    final String msgStr = currentStackStep["msg"] as String;

    Color stateColor = AppTheme.accentNeonCyan;
    if (stateStr == "exceeded") stateColor = AppTheme.accentPink;
    if (stateStr == "pop") stateColor = AppTheme.accentAmber;
    if (stateStr == "success") stateColor = AppTheme.accentGreen;

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
            _isEnglish ? "2. The Current Stack (Push / Pop Memory Array)" : "২. স্ট্যাক মেমোরি মডেল (Push / Pop অ্যানিমেশন)",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            _isEnglish
                ? "Physical stack box showing elements pushing into memory array and popping out on backtrack."
                : "অ্যালগরিদম সংখ্যা নিলে স্ট্যাক বাক্সে কীভাবে Push হয় এবং ব্যাকট্র্যাক করলে কীভাবে Pop হয় তা দেখুন।",
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 16),

          // Status Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: stateColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: stateColor),
            ),
            child: Text(msgStr, style: TextStyle(color: stateColor, fontWeight: FontWeight.bold, fontSize: 12)),
          ),
          const SizedBox(height: 16),

          // Physical Stack Memory Container Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: stateColor, width: 2),
              boxShadow: [BoxShadow(color: stateColor.withOpacity(0.2), blurRadius: 10)],
            ),
            child: Column(
              children: [
                Text(
                  "Physical Stack Array Container: [ ${stackList.join(' , ')} ]",
                  style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 14),

                // Animated Stack Block Cards
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: stackList.isEmpty
                        ? [const Text("[ EMPTY STACK ]", style: TextStyle(color: AppTheme.textMuted, fontSize: 13))]
                        : stackList.map((val) {
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: stateColor.withOpacity(0.25),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: stateColor, width: 2),
                              ),
                              child: Text(
                                "$val",
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            );
                          }).toList(),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Current Stack Sum: ", style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                    Text("$sumVal / 7", style: TextStyle(color: stateColor, fontWeight: FontWeight.bold, fontSize: 15)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // MODEL 3: Target Countdown Subtraction (7 -> 5 -> 3 -> 0)
  Widget _buildTargetCountdownModel() {
    final countdownPaths = [
      {
        "title": "Path A: 7 ➔ 5 ➔ 3 ➔ 0 (Target Hit 0 🎉)",
        "steps": [
          {"target": 7, "sub": 0, "rem": 7, "state": "start"},
          {"target": 7, "sub": 2, "rem": 5, "state": "valid"},
          {"target": 5, "sub": 2, "rem": 3, "state": "valid"},
          {"target": 3, "sub": 3, "rem": 0, "state": "success"},
        ],
        "statusEn": "🎉 Target Hit 0! Valid Combination [2, 2, 3] Found!",
        "statusBn": "🎉 অবশিষ্ট মান 0! ভ্যালিড কম্বিনেশন [2, 2, 3] সংগৃহীত!",
      },
      {
        "title": "Path B: 7 ➔ 5 ➔ 3 ➔ 1 ➔ -1 (Negative Target 🔴)",
        "steps": [
          {"target": 7, "sub": 0, "rem": 7, "state": "start"},
          {"target": 7, "sub": 2, "rem": 5, "state": "valid"},
          {"target": 5, "sub": 2, "rem": 3, "state": "valid"},
          {"target": 3, "sub": 2, "rem": 1, "state": "valid"},
          {"target": 1, "sub": 2, "rem": -1, "state": "exceeded"},
        ],
        "statusEn": "🔴 Remaining is Negative (-1)! Branch Pruned and Backtracked.",
        "statusBn": "🔴 অবশিষ্ট মান ঋণাত্মক (-1)! ব্রাঞ্চ বাতিল করে ব্যাকট্র্যাক করা হয়েছে।",
      },
    ];

    final pathData = countdownPaths[_animationModelIndex == 2 ? 0 : 1];
    final stepsList = pathData["steps"] as List<Map<String, dynamic>>;

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
            _isEnglish ? "3. Target Countdown Subtraction (7 ➔ 5 ➔ 3 ➔ 0)" : "৩. টার্গেট সাবট্রাকশন কাউন্টডাউন (৭ ➔ ৫ ➔ ৩ ➔ ০)",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            _isEnglish
                ? "Subtractions from target: 7 ➔ -2 = 5 ➔ -2 = 3 ➔ -3 = 0 (Success hit 0)."
                : "টার্গেট থেকে প্রতিটি নির্বাচিত সংখ্যা বিয়োগ করে অবশিষ্ট মান ০ এ পৌঁছানোর ভিজ্যুয়াল প্রদর্শন।",
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 16),

          // Big Equation Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.accentGreen),
            ),
            child: const Text(
              "7  ➔  -2  ➔  5  ➔  -2  ➔  3  ➔  -3  ➔  0  (Success 🎉)",
              style: TextStyle(fontFamily: 'monospace', fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.accentGreen),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),

          // Subtraction Steps Chain
          Column(
            children: stepsList.map((step) {
              final subVal = step["sub"] as int;
              final remVal = step["rem"] as int;
              final state = step["state"] as String;

              Color stepColor = AppTheme.accentNeonCyan;
              if (state == "exceeded") stepColor = AppTheme.accentPink;
              if (state == "success") stepColor = AppTheme.accentGreen;

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceDark,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: stepColor),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      subVal == 0 ? "Start Target: $remVal" : "Subtract -$subVal from target",
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    Text(
                      "Remaining Target: [$remVal]",
                      style: TextStyle(color: stepColor, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // TAB 3: Dynamic Visualizer
  Widget _buildVisualizerTab() {
    final step = _steps[_currentStepIndex];
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
                          labelText: _isEnglish ? "Candidates (e.g. 2, 3, 6, 7)" : "ক্যান্ডিডেটস (যেমন 2, 3, 6, 7)",
                          labelStyle: const TextStyle(color: AppTheme.accentNeonCyan, fontSize: 11),
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
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          labelText: _isEnglish ? "Target" : "টার্গেট",
                          labelStyle: const TextStyle(color: AppTheme.accentGreen, fontSize: 11),
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
                      _buildPresetChip("2, 3, 6, 7", "7"),
                      _buildPresetChip("2, 3, 5", "8"),
                      _buildPresetChip("2", "1"),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

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
                _buildCombinationCanvas(step),
              ],
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildCodeHighlightBox(step.activeLine)),
                const SizedBox(width: 16),
                Expanded(child: _buildCombinationCanvas(step)),
              ],
            ),

          const SizedBox(height: 20),

          // Control Bar
          _buildControlBar(),
        ],
      ),
    );
  }

  // TAB 4: Practice & Answer
  Widget _buildPracticeTab() {
    final hPadding = Responsive.horizontalPadding(context);
    final currCandidate = _practiceIndex < _currentCandidates.length ? _currentCandidates[_practiceIndex] : null;

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
                  ? "Build valid combinations summing up to $_currentTarget by deciding to REUSE or MOVE NEXT!"
                  : "যোগফল $_currentTarget না হওয়া পর্যন্ত REUSE বা NEXT সিদ্ধান্ত নিয়ে কম্বিনেশন তৈরি করুন!",
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 16),

            // Target Sum Meter Card
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
                      Text("Current Sum: $_practiceSum / $_currentTarget", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                      Text(
                        "${((_practiceSum / _currentTarget) * 100).clamp(0, 100).toInt()}%",
                        style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: (_practiceSum / _currentTarget).clamp(0.0, 1.0),
                      backgroundColor: AppTheme.primaryDark,
                      valueColor: AlwaysStoppedAnimation<Color>(_practiceSum == _currentTarget ? AppTheme.accentGreen : AppTheme.accentNeonCyan),
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

            // Decision Buttons
            if (!_practiceSolved && currCandidate != null) ...[
              Text(
                _isEnglish ? "Candidate at index $_practiceIndex: [$currCandidate]" : "ইনডেক্স $_practiceIndex এর ক্যান্ডিডেট: [$currCandidate]",
                style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentGreen,
                        foregroundColor: AppTheme.primaryDark,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      icon: const Icon(Icons.add_circle_outline),
                      label: Text(_isEnglish ? "REUSE ($currCandidate)" : "পুনরায় নাও ($currCandidate)"),
                      onPressed: () => _handlePracticeMove("reuse"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      icon: const Icon(Icons.skip_next),
                      label: Text(_isEnglish ? "MOVE NEXT ➔" : "পরেরটি ➔"),
                      onPressed: () => _handlePracticeMove("next"),
                    ),
                  ),
                ],
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
                  ? "Discovered Unique Combinations (${_practiceResults.length}):"
                  : "সংগৃহীত কম্বিনেশনসমূহ (${_practiceResults.length}):",
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
                ? const Text("[ No Valid Combinations Found Yet ]", style: TextStyle(color: AppTheme.textMuted, fontSize: 12))
                : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _practiceResults.map((combo) {
                      return Chip(
                        backgroundColor: AppTheme.surfaceDark,
                        avatar: const Icon(Icons.check_circle, color: AppTheme.accentGreen, size: 16),
                        label: Text(
                          "[${combo.join(', ')}]",
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
  Widget _buildPresetChip(String candidates, String target) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ActionChip(
        backgroundColor: const Color(0xFF090D16),
        label: Text("[$candidates] t=$target", style: const TextStyle(color: AppTheme.accentNeonCyan, fontSize: 11)),
        onPressed: () {
          _candidatesController.text = candidates;
          _targetController.text = target;
          _rebuildSteps();
        },
      ),
    );
  }

  Widget _buildCodeHighlightBox(int activeLine) {
    final codeLines = [
      "void backtrack(int idx, int target, vector<int>& candidates, vector<int>& path, vector<vector<int>>& res) {",
      "    if (target == 0) {",
      "        res.push_back(path); // Valid combination found!",
      "        return;",
      "    }",
      "    if (target < 0 || idx == candidates.size()) return; // Prune branch",
      "    // Choice 1: REUSE candidate at index idx",
      "    path.push_back(candidates[idx]);",
      "    backtrack(idx, target - candidates[idx], candidates, path, res);",
      "    path.pop_back(); // Backtrack",
      "    // Choice 2: MOVE TO NEXT candidate (idx + 1)",
      "    backtrack(idx + 1, target, candidates, path, res);",
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

  Widget _buildCombinationCanvas(CombinationSumStep step) {
    Color decisionColor = AppTheme.accentPurple;
    String decisionLabel = "INIT";

    if (step.decision == "include_reuse") {
      decisionColor = AppTheme.accentGreen;
      decisionLabel = "➕ REUSE candidate";
    } else if (step.decision == "exclude_next") {
      decisionColor = AppTheme.accentPink;
      decisionLabel = "⚡ NEXT candidate";
    } else if (step.decision == "target_met") {
      decisionColor = AppTheme.accentGreen;
      decisionLabel = "🎉 TARGET MET";
    } else if (step.decision == "exceeded") {
      decisionColor = AppTheme.accentAmber;
      decisionLabel = "❌ PRUNE (>Target)";
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

          // Current Combination & Sum Meter
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Accumulated Path (path):", style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
              Text("Sum: ${step.currentSum} / $_currentTarget", style: TextStyle(color: step.currentSum == _currentTarget ? AppTheme.accentGreen : AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: step.currentSum == _currentTarget ? AppTheme.accentGreen : AppTheme.accentPurple.withOpacity(0.5)),
            ),
            child: Text(
              "[${step.currentCombination.join(', ')}]",
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: step.currentSum == _currentTarget ? AppTheme.accentGreen : Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Saved Combinations List
          const Text("Saved Unique Combinations (results):", style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
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
                            "[${combo.join(', ')}]",
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

  Widget _buildVisualStepBox(String title, String desc, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.2),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text(desc, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, height: 1.4)),
              ],
            ),
          ),
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
    void backtrack(int idx, int target, vector<int>& candidates, vector<int>& path, vector<vector<int>>& res) {
        if (target == 0) {
            res.push_back(path);
            return;
        }
        if (target < 0 || idx == candidates.size()) return;

        // Choice 1: REUSE candidates[idx]
        path.push_back(candidates[idx]);
        backtrack(idx, target - candidates[idx], candidates, path, res);
        path.pop_back();

        // Choice 2: MOVE TO NEXT candidate
        backtrack(idx + 1, target, candidates, path, res);
    }

    vector<vector<int>> combinationSum(vector<int>& candidates, int target) {
        vector<vector<int>> res;
        vector<int> path;
        backtrack(0, target, candidates, path, res);
        return res;
    }
};""";
    } else if (lang == "Java") {
      code = """
class Solution {
    public List<List<Integer>> combinationSum(int[] candidates, int target) {
        List<List<Integer>> res = new ArrayList<>();
        backtrack(0, target, candidates, new ArrayList<>(), res);
        return res;
    }

    private void backtrack(int idx, int target, int[] candidates, List<Integer> path, List<List<Integer>> res) {
        if (target == 0) {
            res.add(new ArrayList<>(path));
            return;
        }
        if (target < 0 || idx == candidates.length) return;

        // Reuse current candidate
        path.add(candidates[idx]);
        backtrack(idx, target - candidates[idx], candidates, path, res);
        path.remove(path.size() - 1);

        // Move to next candidate
        backtrack(idx + 1, target, candidates, path, res);
    }
}""";
    } else {
      code = """
class Solution:
    def combinationSum(self, candidates: List[int], target: int) -> List[List[int]]:
        res = []
        path = []

        def backtrack(idx, current_target):
            if current_target == 0:
                res.append(path.copy())
                return
            if current_target < 0 or idx == len(candidates):
                return

            # Reuse candidate
            path.append(candidates[idx])
            backtrack(idx, current_target - candidates[idx])
            path.pop()

            # Skip candidate
            backtrack(idx + 1, current_target)

        backtrack(0, target)
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
