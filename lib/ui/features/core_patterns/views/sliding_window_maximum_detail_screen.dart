import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class SlidingWindowMaximumStep {
  final int index;
  final int num;
  final int windowStart;
  final int windowEnd;
  final List<int> dequeIndices;
  final List<int> dequeValues;
  final List<int> result;
  final int? currentMax;
  final String decision; // 'init', 'pop_expired', 'pop_smaller', 'push_index', 'record_max', 'finished'
  final int activeLine;
  final String actionEn;
  final String actionBn;
  final String reasonEn;
  final String reasonBn;

  const SlidingWindowMaximumStep({
    required this.index,
    required this.num,
    required this.windowStart,
    required this.windowEnd,
    required this.dequeIndices,
    required this.dequeValues,
    required this.result,
    required this.currentMax,
    required this.decision,
    required this.activeLine,
    required this.actionEn,
    required this.actionBn,
    required this.reasonEn,
    required this.reasonBn,
  });
}

class SlidingWindowMaximumDetailScreen extends StatefulWidget {
  const SlidingWindowMaximumDetailScreen({super.key});

  @override
  State<SlidingWindowMaximumDetailScreen> createState() =>
      _SlidingWindowMaximumDetailScreenState();
}

class _SlidingWindowMaximumDetailScreenState
    extends State<SlidingWindowMaximumDetailScreen>
    with SingleTickerProviderStateMixin {
  bool _isEnglish = true;
  late TabController _tabController;

  // Custom Input State
  final TextEditingController _numsController = TextEditingController(text: "1, 3, -1, -3, 5, 3, 6, 7");
  final TextEditingController _kController = TextEditingController(text: "3");
  List<int> _nums = [1, 3, -1, -3, 5, 3, 6, 7];
  int _k = 3;
  List<SlidingWindowMaximumStep> _steps = [];

  // Playback Control
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  // Code Language Selector
  String _selectedCodeLang = "C++";

  // Tab 2 Animation Model Selector (0: Step Flowcard, 1: Monotonic Deque Rule, 2: Complexity Calculator)
  int _animationModelIndex = 0;
  int _flowStepIndex = 0;

  // Practice Mode State
  int _practiceIndex = 0;
  List<int> _practiceResult = [];
  List<int> _practiceDeque = [];
  String _userFeedbackEn = "Maintain monotonic decreasing deque. Front element is always window maximum!";
  String _userFeedbackBn = "মনোটোনিক ডিকিউ বজায় রাখুন। ফ্রন্টের উপাদানটিই উইন্ডোর সর্বোচ্চ মান!";
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

    try {
      List<int> parsed = _numsController.text
          .split(',')
          .map((e) => int.parse(e.trim()))
          .toList();
      int kVal = int.parse(_kController.text.trim());
      if (parsed.isEmpty) parsed = [1, 3, -1, -3, 5, 3, 6, 7];
      if (kVal <= 0) kVal = 3;
      _nums = parsed;
      _k = kVal;
    } catch (_) {
      _nums = [1, 3, -1, -3, 5, 3, 6, 7];
      _k = 3;
    }

    _steps = _generateSteps(_nums, _k);

    // Reset practice mode
    _resetPractice();
  }

  void _resetPractice() {
    _practiceIndex = 0;
    _practiceResult = [];
    _practiceDeque = [];
    _practiceSolved = false;
    _userFeedbackEn = "Inspect element at index 0 (${_nums.isNotEmpty ? _nums[0] : 0}) with window k = $_k!";
    _userFeedbackBn = "উইন্ডো k = $_k সহ ইনডেক্স 0 (${_nums.isNotEmpty ? _nums[0] : 0}) এর উপাদান পরীক্ষা করুন!";
  }

  List<SlidingWindowMaximumStep> _generateSteps(List<int> numbers, int kVal) {
    List<SlidingWindowMaximumStep> steps = [];
    int n = numbers.length;

    // Step 0: Init
    steps.add(SlidingWindowMaximumStep(
      index: 0,
      num: n > 0 ? numbers[0] : 0,
      windowStart: 0,
      windowEnd: 0,
      dequeIndices: [],
      dequeValues: [],
      result: [],
      currentMax: null,
      decision: "init",
      activeLine: 1,
      actionEn: "Line 1: Initialize Sliding Window Maximum for nums = [${numbers.join(', ')}], k = $kVal.",
      actionBn: "লাইন ১: nums = [${numbers.join(', ')}], k = $kVal এর জন্য স্লাইডিং উইন্ডো ম্যাক্সিমাম শুরু।",
      reasonEn: "We maintain a monotonic decreasing deque storing indices. The front of deque always holds maximum element.",
      reasonBn: "আমরা ডিকিউতে ইনডেক্সগুলো অধোক্রমে (monotonic decreasing) রাখব। ডিকিউর ফ্রন্টে সবসময় উইন্ডোর সর্বোচ্চ মান থাকবে।",
    ));

    if (n == 0 || kVal <= 0) {
      steps.add(const SlidingWindowMaximumStep(
        index: 0,
        num: 0,
        windowStart: 0,
        windowEnd: 0,
        dequeIndices: [],
        dequeValues: [],
        result: [],
        currentMax: null,
        decision: "finished",
        activeLine: 2,
        actionEn: "🏁 Line 2: Invalid k or empty array! Return [].",
        actionBn: "🏁 লাইন ২: অকার্যকর k বা খালি অ্যারে! [] রিটার্ন করুন।",
        reasonEn: "Empty array or invalid k.",
        reasonBn: "খালি অ্যারে বা অকার্যকর k।",
      ));
      return steps;
    }

    List<int> deque = []; // stores indices
    List<int> result = [];

    for (int i = 0; i < n; i++) {
      int val = numbers[i];

      // Remove out of window indices
      while (deque.isNotEmpty && deque.first < i - kVal + 1) {
        int poppedIdx = deque.removeAt(0);
        steps.add(SlidingWindowMaximumStep(
          index: i,
          num: val,
          windowStart: (i - kVal + 1) < 0 ? 0 : (i - kVal + 1),
          windowEnd: i,
          dequeIndices: List.from(deque),
          dequeValues: deque.map((idx) => numbers[idx]).toList(),
          result: List.from(result),
          currentMax: deque.isNotEmpty ? numbers[deque.first] : null,
          decision: "pop_expired",
          activeLine: 5,
          actionEn: "🗑️ Line 5: Popped index $poppedIdx (${numbers[poppedIdx]}) from Deque front (out of window [${i - kVal + 1}..$i]).",
          actionBn: "🗑️ লাইন ৫: ডিকিউ ফ্রন্ট থেকে ইনডেক্স $poppedIdx (${numbers[poppedIdx]}) সরিয়ে দেওয়া হলো (উইন্ডো [${i - kVal + 1}..$i] এর বাইরে)।",
          reasonEn: "Index $poppedIdx is no longer inside active window of size $kVal.",
          reasonBn: "ইনডেক্স $poppedIdx আর $kVal সাইজের সক্রিয় উইন্ডোর মধ্যে নেই।",
        ));
      }

      // Pop smaller values from back
      while (deque.isNotEmpty && numbers[deque.last] <= val) {
        int poppedIdx = deque.removeLast();
        steps.add(SlidingWindowMaximumStep(
          index: i,
          num: val,
          windowStart: (i - kVal + 1) < 0 ? 0 : (i - kVal + 1),
          windowEnd: i,
          dequeIndices: List.from(deque),
          dequeValues: deque.map((idx) => numbers[idx]).toList(),
          result: List.from(result),
          currentMax: deque.isNotEmpty ? numbers[deque.first] : null,
          decision: "pop_smaller",
          activeLine: 7,
          actionEn: "⚡ Line 7: Popped index $poppedIdx (${numbers[poppedIdx]}) from Deque back! Value ${numbers[poppedIdx]} <= current num ($val).",
          actionBn: "⚡ লাইন ৭: ডিকিউ ব্যাক থেকে ইনডেক্স $poppedIdx (${numbers[poppedIdx]}) রিমুভ করা হলো! মান ${numbers[poppedIdx]} <= বর্তমান মান ($val)।",
          reasonEn: "Smaller elements are useless because current element $val is larger and newer!",
          reasonBn: "ছোট মানগুলোর দরকার নেই কারণ নতুন মান $val বড় ও উইন্ডোতে দীর্ঘদিন থাকবে!",
        ));
      }

      // Push current index
      deque.add(i);
      steps.add(SlidingWindowMaximumStep(
        index: i,
        num: val,
        windowStart: (i - kVal + 1) < 0 ? 0 : (i - kVal + 1),
        windowEnd: i,
        dequeIndices: List.from(deque),
        dequeValues: deque.map((idx) => numbers[idx]).toList(),
        result: List.from(result),
        currentMax: numbers[deque.first],
        decision: "push_index",
        activeLine: 9,
        actionEn: "➡️ Line 9: Pushed index $i (val = $val) to Deque back ➔ Deque: [${deque.map((idx) => numbers[idx]).join(', ')}].",
        actionBn: "➡️ লাইন ৯: ডিকিউ ব্যাক এ ইনডেক্স $i (মান = $val) যোগ করা হলো ➔ ডিকিউ: [${deque.map((idx) => numbers[idx]).join(', ')}]।",
        reasonEn: "Maintain monotonic decreasing order in deque.",
        reasonBn: "ডিকিউতে অধোক্রম বজায় রাখা হচ্ছে।",
      ));

      // Record max for window
      if (i >= kVal - 1) {
        int maxVal = numbers[deque.first];
        result.add(maxVal);

        steps.add(SlidingWindowMaximumStep(
          index: i,
          num: val,
          windowStart: i - kVal + 1,
          windowEnd: i,
          dequeIndices: List.from(deque),
          dequeValues: deque.map((idx) => numbers[idx]).toList(),
          result: List.from(result),
          currentMax: maxVal,
          decision: "record_max",
          activeLine: 11,
          actionEn: "🎉 Line 11: Window [${i - kVal + 1}..$i] Complete! Recorded Maximum = $maxVal (Result = [${result.join(', ')}])!",
          actionBn: "🎉 লাইন ১১: উইন্ডো [${i - kVal + 1}..$i] সম্পূর্ণ! রেকর্ডকৃত সর্বোচ্চ মান = $maxVal (ফলাফল = [${result.join(', ')}])!",
          reasonEn: "The front element of deque nums[${deque.first}] = $maxVal is the maximum for window [${i - kVal + 1}..$i].",
          reasonBn: "ডিকিউর ফ্রন্ট উপাদান nums[${deque.first}] = $maxVal হলো উইন্ডো [${i - kVal + 1}..$i] এর সর্বোচ্চ মান।",
        ));
      }
    }

    steps.add(SlidingWindowMaximumStep(
      index: n - 1,
      num: numbers[n - 1],
      windowStart: n - kVal < 0 ? 0 : n - kVal,
      windowEnd: n - 1,
      dequeIndices: List.from(deque),
      dequeValues: deque.map((idx) => numbers[idx]).toList(),
      result: List.from(result),
      currentMax: deque.isNotEmpty ? numbers[deque.first] : null,
      decision: "finished",
      activeLine: 14,
      actionEn: "🏁 Line 14: Traversal Complete! Sliding Window Maximum Array = [${result.join(', ')}].",
      actionBn: "🏁 লাইন ১৪: স্ক্যান সম্পূর্ণ! স্লাইডিং উইন্ডো সর্বোচ্চ মানসমূহের অ্যারে = [${result.join(', ')}]।",
      reasonEn: "Processed all elements in O(N) time using Monotonic Deque.",
      reasonBn: "মনোটোনিক ডিকিউ ব্যবহার করে O(N) সময়ে সমস্ত উপাদান প্রক্রিয়াজাত সম্পন্ন।",
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

  List<int> _maxSlidingWindow(List<int> numbers, int kVal) {
    if (numbers.isEmpty || kVal <= 0) return [];
    List<int> deque = [];
    List<int> res = [];
    for (int i = 0; i < numbers.length; i++) {
      while (deque.isNotEmpty && deque.first < i - kVal + 1) {
        deque.removeAt(0);
      }
      while (deque.isNotEmpty && numbers[deque.last] <= numbers[i]) {
        deque.removeLast();
      }
      deque.add(i);
      if (i >= kVal - 1) {
        res.add(numbers[deque.first]);
      }
    }
    return res;
  }

  void _handlePracticeAction(String actionType) {
    if (_practiceSolved || _practiceIndex >= _nums.length) return;

    List<int> expectedRes = _maxSlidingWindow(_nums, _k);

    setState(() {
      _practiceIndex++;
      if (_practiceIndex >= _nums.length) {
        _practiceSolved = true;
        _userFeedbackEn = "🏆 MASTERED! You successfully tracked sliding window maximums using Monotonic Deque! Result = [${expectedRes.join(', ')}].";
        _userFeedbackBn = "🏆 দারুণ! আপনি মনোটোনিক ডিকিউ ব্যবহার করে উইন্ডোর সর্বোচ্চ মানসমূহ সফলভাবে বের করেছেন! ফলাফল = [${expectedRes.join(', ')}]।";
      } else {
        _userFeedbackEn = "Correct! Advanced to index $_practiceIndex (${_nums[_practiceIndex]}). Select next step action!";
        _userFeedbackBn = "সঠিক! ইনডেক্স $_practiceIndex (${_nums[_practiceIndex]}) এ অগ্রসর হওয়া হয়েছে। পরের পদক্ষেপ নির্বাচন করুন!";
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
          '239. Sliding Window Maximum',
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
                    "239. Sliding Window Maximum",
                    style: TextStyle(fontSize: Responsive.sp(context, 19), fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.accentPink.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.accentPink),
                  ),
                  child: const Text("Hard", style: TextStyle(color: AppTheme.accentPink, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              children: ["Amazon", "Meta", "Google", "Microsoft"].map((company) {
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
                        ? "You are given an array of integers nums, there is a sliding window of size k which is moving from the very left of the array to the very right. You can only see the k numbers in the window. Return the max sliding window array."
                        : "একটি পূর্ণসংখ্যার অ্যারে nums এবং একটি উইন্ডো সাইজ k দেওয়া আছে। উইন্ডোটি অ্যারের বাম থেকে ডানদিকে স্লাইড করে। প্রতিটি উইন্ডো পজিশনের সর্বোচ্চ মানগুলোর অ্যারে রিটার্ন করুন।",
                    style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Examples
            Text(_isEnglish ? "Examples" : "উদাহরণসমূহ", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            _buildExampleCard("Example 1", "nums = [1, 3, -1, -3, 5, 3, 6, 7], k = 3", "Output: [3, 3, 5, 5, 6, 7]"),
            _buildExampleCard("Example 2", "nums = [1], k = 1", "Output: [1]"),
            _buildExampleCard("Example 3", "nums = [9, 11], k = 2", "Output: [11]"),
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
                        _isEnglish ? "Key Intuition (Monotonic Decreasing Deque)" : "মূল আইডিয়া (মনোটোনিক ডিকিউ ডেটা স্ট্রাকচার)",
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isEnglish
                        ? "1. Store array indices in a double-ended queue (deque) in strictly decreasing order of values.\n2. Pop expired indices (deque.front() < i - k + 1) from front.\n3. Pop smaller values (nums[deque.back()] <= nums[i]) from back because they can never be the maximum!\n4. Front element nums[deque.front()] is always the window maximum in O(1) amortized time!"
                        : "১. ডিকিউতে মানগুলোর অধোক্রম (monotonic decreasing) অনুযায়ী ইনডেক্স রাখুন।\n২. মেয়াদী উইন্ডোর বাইরের ইনডেক্স ফ্রন্ট থেকে পপ করুন।\n৩. বর্তমানের চেয়ে ছোট মানগুলো ব্যাক থেকে সরিয়ে দিন কারণ সেগুলো কখনোই উইন্ডোর সর্বোচ্চ হতে পারবে না।\n৪. ডিকিউর ফ্রন্ট উপাদানই সর্বদা উইন্ডোর সর্বোচ্চ মান!",
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
              _isEnglish ? "Sliding Window Maximum Visual Models" : "স্লাইডিং উইন্ডো ম্যাক্সিমাম ভিজ্যুয়াল মডেলসমূহ (কোডহীন গাইড)",
              style: TextStyle(fontSize: Responsive.sp(context, 18), fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 6),
            Text(
              _isEnglish
                  ? "Explore 3 interactive models for nums = [1, 3, -1, -3, 5, 3, 6, 7], k = 3."
                  : "nums = [1, 3, -1, -3, 5, 3, 6, 7], k = 3 এর জন্য ৩টি ইন্টারঅ্যাক্টিভ ভিজ্যুয়াল মডেল পর্যবেক্ষণ করুন।",
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 16),

            // Model Switcher Segmented Control
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildAnimationModelChip(0, _isEnglish ? "1. 🪜 Step Flowcard" : "১. 🪜 স্টেপ-বাই-স্টেপ ফ্লো-কার্ড"),
                  _buildAnimationModelChip(1, _isEnglish ? "2. 📏 Monotonic Rule" : "২. 📏 মনোটোনিক ডিকিউ নীতি"),
                  _buildAnimationModelChip(2, _isEnglish ? "3. 📊 Complexity Calculator" : "৩. 📊 টাইমিং ক্যালকুলেটর"),
                ],
              ),
            ),
            const SizedBox(height: 20),

            if (_animationModelIndex == 0) _buildStepFlowcardModel(),
            if (_animationModelIndex == 1) _buildMonotonicRuleModel(),
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
        "window": "[1, 3, -1]",
        "deque": "[3, -1]",
        "max": 3,
        "res": "[3]",
        "badge": "🎉 WINDOW 1 MAX = 3",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 1: i = 2 (-1) ➔ Window [1, 3, -1] Deque: [3, -1] ➔ Max = 3",
        "titleBn": "ধাপ ১: i = 2 (-1) ➔ উইন্ডো [1, 3, -1] ডিকিউ: [3, -1] ➔ সর্বোচ্চ = ৩",
        "descEn": "3 is greater than 1, so 1 was popped. Front of deque is 3.",
        "descBn": "৩ এর মান ১ এর চেয়ে বড়, তাই ১ ডিকিউ থেকে পপ হয়েছে। ডিকিউ ফ্রন্ট = ৩।",
      },
      {
        "step": 2,
        "window": "[3, -1, -3]",
        "deque": "[3, -1, -3]",
        "max": 3,
        "res": "[3, 3]",
        "badge": "🎉 WINDOW 2 MAX = 3",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 2: i = 3 (-3) ➔ Window [3, -1, -3] Deque: [3, -1, -3] ➔ Max = 3",
        "titleBn": "ধাপ ২: i = 3 (-3) ➔ উইন্ডো [3, -1, -3] ডিকিউ: [3, -1, -3] ➔ সর্বোচ্চ = ৩",
        "descEn": "Elements in decreasing order. Front of deque is 3.",
        "descBn": "উপাদানগুলো অধোক্রমে রয়েছে। ডিকিউ ফ্রন্ট = ৩।",
      },
      {
        "step": 3,
        "window": "[-1, -3, 5]",
        "deque": "[5]",
        "max": 5,
        "res": "[3, 3, 5]",
        "badge": "⚡ POP SMALLER & MAX = 5",
        "badgeColor": AppTheme.accentAmber,
        "titleEn": "Step 3: i = 4 (5) ➔ 5 is larger than 3, -1, -3! Pop all! Deque: [5] ➔ Max = 5 🎉",
        "titleBn": "ধাপ ৩: i = 4 (5) ➔ ৫ এর মান ৩, -১, -৩ এর চেয়ে বড়! সব পপ করুন! ডিকিউ: [5] ➔ সর্বোচ্চ = ৫ 🎉",
        "descEn": "All smaller elements eliminated. Deque front = 5.",
        "descBn": "ছোট উপাদানগুলো সরিয়ে দেওয়া হলো। ডিকিউ ফ্রন্ট = ৫।",
      },
      {
        "step": 4,
        "window": "[3, 6, 7]",
        "deque": "[7]",
        "max": 7,
        "res": "[3, 3, 5, 5, 6, 7]",
        "badge": "🏁 COMPLETE",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 4: Traversal Complete! Final Sliding Max Array = [3, 3, 5, 5, 6, 7]",
        "titleBn": "ধাপ ৪: স্ক্যান সম্পূর্ণ! চূড়ান্ত উইন্ডো সর্বোচ্চ অ্যারে = [3, 3, 5, 5, 6, 7]",
        "descEn": "Executed in O(N) linear time using Monotonic Deque!",
        "descBn": "মনোটোনিক ডিকিউ দিয়ে O(N) লিনিয়ার সময়ে সমাধান করা হলো!",
      },
    ];

    final currentStep = stepFlowData[_flowStepIndex.clamp(0, stepFlowData.length - 1)];
    final String window = currentStep["window"] as String;
    final String dequeVal = currentStep["deque"] as String;
    final int maxVal = currentStep["max"] as int;
    final String resVal = currentStep["res"] as String;
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
                _isEnglish ? "1. Step-by-Step Monotonic Deque Flowcard" : "১. স্টেপ-বাই-স্টেপ মনোটোনিক ডিকিউ ফ্লো-কার্ড",
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
                ? "Watch monotonic decreasing deque push and pop operations."
                : "মনোটোনিক ডিকিউ পুশ ও পপ অপারেশনসমূহ দেখুন।",
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
                    Text("Window = $window | Deque = $dequeVal", style: TextStyle(color: badgeColor, fontWeight: FontWeight.bold, fontSize: 12)),
                    Text("Current Max = $maxVal", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
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
                    "Result Array = $resVal 🏆",
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

  // MODEL 2: Monotonic Rule
  Widget _buildMonotonicRuleModel() {
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
            _isEnglish ? "2. Monotonic Decreasing Structure Rule" : "২. মনোটোনিক অধোক্রম নীতি",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            _isEnglish
                ? "While deque is non-empty and nums[deque.back()] <= nums[i], pop_back(). Push index i to back. Record nums[deque.front()] for each window!"
                : "ডিকিউতে বর্তমান উপাদানের চেয়ে ছোট উপাদান থাকলে ব্যাক থেকে পপ করুন। বর্তমান ইনডেক্স যোগ করুন এবং ফ্রন্টের উপাদান রেকর্ড করুন!",
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
              "while (!dq.empty() && nums[dq.back()] <= nums[i]) dq.pop_back(); dq.push_back(i); 📏",
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
            _isEnglish ? "3. O(N) Time & O(K) Space Complexity" : "৩. O(N) টাইম এবং O(K) স্পেস কমপ্লেক্সিটি",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            _isEnglish
                ? "Naive max scan inside window takes O(N * K) time.\nMonotonic Deque pushes and pops each index at most once in O(N) time with O(K) space!"
                : "প্রতিটি উইন্ডোতে ম্যাক্সিমাম স্ক্যান করতে O(N * K) সময় লাগে।\nমনোটোনিক ডিকিউ প্রতিটি ইনডেক্স সর্বমোট ১ বার পুশ ও পপ করে O(N) টাইম ও O(K) স্পেসে সমাধান করে!",
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
              "Time Complexity: O(N)\nSpace Complexity: O(K) 🎉",
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
                        controller: _numsController,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          labelText: _isEnglish ? "Nums Array (e.g. 1, 3, -1, -3, 5, 3, 6, 7)" : "অ্যারে (যেমন 1, 3, -1, -3, 5, 3, 6, 7)",
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
                          labelText: _isEnglish ? "k (Window Size)" : "k (উইন্ডো সাইজ)",
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
                      _buildPresetChip("1, 3, -1, -3, 5, 3, 6, 7", "3"),
                      _buildPresetChip("1", "1"),
                      _buildPresetChip("9, 11", "2"),
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
                  _buildSlidingMaxCanvas(step),
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildCodeHighlightBox(step.activeLine)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildSlidingMaxCanvas(step)),
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
    final targetMaxArray = _maxSlidingWindow(_nums, _k);

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
                  ? "Track window expansion and maintain Monotonic Deque order!"
                  : "প্রতিটি উপাদানের জন্য ডিকিউতে মনোটোনিক অর্ডার বজায় রাখুন!",
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
            if (!_practiceSolved && _practiceIndex < _nums.length)
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
                        Text("Current Index: $_practiceIndex (${_nums[_practiceIndex]})", style: const TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 12)),
                        Text("Target Result: [${targetMaxArray.join(', ')}]", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Window: [${_nums.sublist((_practiceIndex - _k + 1) < 0 ? 0 : (_practiceIndex - _k + 1), _practiceIndex + 1).join(', ')}]",
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
                          label: Text(_isEnglish ? "PUSH INDEX" : "PUSH INDEX"),
                          onPressed: () => _handlePracticeAction("PUSH"),
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accentAmber,
                            foregroundColor: AppTheme.primaryDark,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          ),
                          icon: const Icon(Icons.delete_sweep),
                          label: Text(_isEnglish ? "POP SMALLER" : "POP SMALLER"),
                          onPressed: () => _handlePracticeAction("POP_SMALLER"),
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accentGreen,
                            foregroundColor: AppTheme.primaryDark,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          ),
                          icon: const Icon(Icons.star),
                          label: Text(_isEnglish ? "RECORD MAX" : "RECORD MAX"),
                          onPressed: () => _handlePracticeAction("RECORD_MAX"),
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
  Widget _buildPresetChip(String nVal, String kVal) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ActionChip(
        backgroundColor: const Color(0xFF090D16),
        label: Text("[$nVal], k=$kVal", style: const TextStyle(color: AppTheme.accentNeonCyan, fontSize: 11)),
        onPressed: () {
          _numsController.text = nVal;
          _kController.text = kVal;
          _rebuildSteps();
        },
      ),
    );
  }

  Widget _buildCodeHighlightBox(int activeLine) {
    final codeLines = [
      "vector<int> maxSlidingWindow(vector<int>& nums, int k) {",
      "    deque<int> dq;",
      "    vector<int> result;",
      "    for (int i = 0; i < nums.size(); i++) {",
      "        if (!dq.empty() && dq.front() < i - k + 1) dq.pop_front();",
      "        while (!dq.empty() && nums[dq.back()] <= nums[i]) {",
      "            dq.pop_back();",
      "        }",
      "        dq.push_back(i);",
      "        if (i >= k - 1) {",
      "            result.push_back(nums[dq.front()]);",
      "        }",
      "    }",
      "    return result;",
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

  Widget _buildSlidingMaxCanvas(SlidingWindowMaximumStep step) {
    Color decisionColor = AppTheme.accentPurple;
    String decisionLabel = "INIT";

    if (step.decision == "push_index") {
      decisionColor = AppTheme.accentNeonCyan;
      decisionLabel = "➡️ PUSH INDEX";
    } else if (step.decision == "pop_expired") {
      decisionColor = AppTheme.accentPink;
      decisionLabel = "🗑️ POP EXPIRED";
    } else if (step.decision == "pop_smaller") {
      decisionColor = AppTheme.accentAmber;
      decisionLabel = "⚡ POP SMALLER";
    } else if (step.decision == "record_max") {
      decisionColor = AppTheme.accentGreen;
      decisionLabel = "🎉 RECORD MAX";
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
              Text("Window: [${step.windowStart} .. ${step.windowEnd}] (k = ${step.k})", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13)),
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

          // Deque State Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.accentNeonCyan),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Monotonic Deque (Decreasing):", style: TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
                    Text("Front Max = ${step.currentMax ?? '-'}", style: const TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 6),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: step.dequeIndices.isEmpty
                        ? [const Text("[Empty Deque]", style: TextStyle(color: Color(0xFF64748B), fontSize: 12))]
                        : List.generate(step.dequeIndices.length, (idx) {
                            int dIdx = step.dequeIndices[idx];
                            int dVal = step.dequeValues[idx];
                            bool isFront = idx == 0;

                            return Container(
                              margin: const EdgeInsets.only(right: 6),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: isFront ? AppTheme.accentGreen.withOpacity(0.3) : AppTheme.primaryDark,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: isFront ? AppTheme.accentGreen : AppTheme.accentPurple),
                              ),
                              child: Text(
                                "idx $dIdx (val $dVal)",
                                style: TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: isFront ? AppTheme.accentGreen : Colors.white,
                                ),
                              ),
                            );
                          }),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Output Result Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: decisionColor.withOpacity(0.5)),
            ),
            child: Text(
              "Result Array = [${step.result.join(', ')}] 🏆",
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

          // Visual Array Sequence Canvas
          const Text("Nums Array Canvas:", style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_nums.length, (idx) {
                bool inWindow = idx >= step.windowStart && idx <= step.windowEnd;
                bool isCurrent = idx == step.index;
                bool inDeque = step.dequeIndices.contains(idx);
                bool isMax = step.dequeIndices.isNotEmpty && step.dequeIndices.first == idx;

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: isMax
                        ? AppTheme.accentGreen.withOpacity(0.4)
                        : (inWindow ? decisionColor.withOpacity(0.35) : AppTheme.surfaceDark),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isMax
                          ? AppTheme.accentGreen
                          : (inWindow ? decisionColor : const Color(0xFF334155)),
                      width: inWindow ? 2.0 : 1.0,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        isCurrent ? "i" : (inDeque ? "dq" : ""),
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isMax ? AppTheme.accentGreen : AppTheme.accentNeonCyan),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "${_nums[idx]}",
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isMax ? AppTheme.accentGreen : (inWindow ? Colors.white : const Color(0xFF64748B)),
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
    vector<int> maxSlidingWindow(vector<int>& nums, int k) {
        deque<int> dq;
        vector<int> result;
        for (int i = 0; i < nums.size(); i++) {
            if (!dq.empty() && dq.front() < i - k + 1) {
                dq.pop_front();
            }
            while (!dq.empty() && nums[dq.back()] <= nums[i]) {
                dq.pop_back();
            }
            dq.push_back(i);
            if (i >= k - 1) {
                result.push_back(nums[dq.front()]);
            }
        }
        return result;
    }
};""";
    } else if (lang == "Java") {
      code = """
class Solution {
    public int[] maxSlidingWindow(int[] nums, int k) {
        if (nums.length == 0) return new int[0];
        Deque<Integer> dq = new ArrayDeque<>();
        int[] result = new int[nums.length - k + 1];
        int resIdx = 0;
        
        for (int i = 0; i < nums.length; i++) {
            if (!dq.isEmpty() && dq.peekFirst() < i - k + 1) {
                dq.pollFirst();
            }
            while (!dq.isEmpty() && nums[dq.peekLast()] <= nums[i]) {
                dq.pollLast();
            }
            dq.offerLast(i);
            if (i >= k - 1) {
                result[resIdx++] = nums[dq.peekFirst()];
            }
        }
        return result;
    }
}""";
    } else {
      code = """
class Solution:
    def maxSlidingWindow(self, nums: List[int], k: int) -> List[int]:
        dq = deque()
        result = []
        
        for i in range(len(nums)):
            if dq and dq[0] < i - k + 1:
                dq.popleft()
            while dq and nums[dq[-1]] <= nums[i]:
                dq.pop()
            dq.append(i)
            if i >= k - 1:
                result.append(nums[dq[0]])
                
        return result""";
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
