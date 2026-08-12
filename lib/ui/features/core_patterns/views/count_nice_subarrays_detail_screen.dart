import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class CountNiceSubarraysStep {
  final int left;
  final int right;
  final List<int> windowSub;
  final int oddCount;
  final int k;
  final int prefixEven;
  final int addedCount;
  final int totalNice;
  final String decision; // 'init', 'expand', 'shrink_left', 'count_updated', 'finished'
  final int activeLine;
  final String actionEn;
  final String actionBn;
  final String reasonEn;
  final String reasonBn;

  const CountNiceSubarraysStep({
    required this.left,
    required this.right,
    required this.windowSub,
    required this.oddCount,
    required this.k,
    required this.prefixEven,
    required this.addedCount,
    required this.totalNice,
    required this.decision,
    required this.activeLine,
    required this.actionEn,
    required this.actionBn,
    required this.reasonEn,
    required this.reasonBn,
  });
}

class CountNiceSubarraysDetailScreen extends StatefulWidget {
  const CountNiceSubarraysDetailScreen({super.key});

  @override
  State<CountNiceSubarraysDetailScreen> createState() =>
      _CountNiceSubarraysDetailScreenState();
}

class _CountNiceSubarraysDetailScreenState
    extends State<CountNiceSubarraysDetailScreen>
    with SingleTickerProviderStateMixin {
  bool _isEnglish = true;
  late TabController _tabController;

  // Custom Input State
  final TextEditingController _numsController = TextEditingController(text: "1, 1, 2, 1, 1");
  final TextEditingController _kController = TextEditingController(text: "3");
  List<int> _nums = [1, 1, 2, 1, 1];
  int _k = 3;
  List<CountNiceSubarraysStep> _steps = [];

  // Playback Control
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  // Code Language Selector
  String _selectedCodeLang = "C++";

  // Tab 2 Animation Model Selector (0: Step Flowcard, 1: Prefix Even Rule, 2: Complexity Calculator)
  int _animationModelIndex = 0;
  int _flowStepIndex = 0;

  // Practice Mode State
  int _practiceRight = 0;
  int _practiceLeft = 0;
  int _practiceTotalNice = 0;
  String _userFeedbackEn = "Track odd numbers in window and count prefix even elements when oddCount == k!";
  String _userFeedbackBn = "উইন্ডোতে বিজোড় সংখ্যা ট্র্যাক করুন এবং oddCount == k হলে পূর্ববর্তী জোড় সংখ্যা হিসাব করুন!";
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
      if (parsed.isEmpty) parsed = [1, 1, 2, 1, 1];
      if (kVal < 0) kVal = 3;
      _nums = parsed;
      _k = kVal;
    } catch (_) {
      _nums = [1, 1, 2, 1, 1];
      _k = 3;
    }

    _steps = _generateSteps(_nums, _k);

    // Reset practice mode
    _resetPractice();
  }

  void _resetPractice() {
    _practiceLeft = 0;
    _practiceRight = 0;
    _practiceTotalNice = 0;
    _practiceSolved = false;
    _userFeedbackEn = "Inspect element at right = 0 (${_nums.isNotEmpty ? _nums[0] : 0}) with k = $_k!";
    _userFeedbackBn = "k = $_k সহ ইনডেক্স right = 0 (${_nums.isNotEmpty ? _nums[0] : 0}) এর উপাদান পরীক্ষা করুন!";
  }

  List<CountNiceSubarraysStep> _generateSteps(List<int> numbers, int kVal) {
    List<CountNiceSubarraysStep> steps = [];
    int n = numbers.length;

    // Step 0: Init
    steps.add(CountNiceSubarraysStep(
      left: 0,
      right: 0,
      windowSub: n > 0 ? [numbers[0]] : [],
      oddCount: 0,
      k: kVal,
      prefixEven: 0,
      addedCount: 0,
      totalNice: 0,
      decision: "init",
      activeLine: 1,
      actionEn: "Line 1: Initialize Count Nice Subarrays for nums = [${numbers.join(', ')}], k = $kVal.",
      actionBn: "লাইন ১: nums = [${numbers.join(', ')}], k = $kVal এর জন্য nice সাব-অ্যারে গণনা শুরু।",
      reasonEn: "We maintain left pointer, odd count, and prefix even count to find all subarrays with exactly $kVal odd numbers.",
      reasonBn: "আমরা ঠিক $kVal টি বিজোড় সংখ্যা সহ সমস্ত সাব-অ্যারে খুঁজে পেতে বাম পয়েন্টার, অড কাউন্ট ও প্রিফিক্স ইভেন গণনা করব।",
    ));

    if (n == 0 || kVal <= 0) {
      steps.add(CountNiceSubarraysStep(
        left: 0,
        right: 0,
        windowSub: [],
        oddCount: 0,
        k: kVal,
        prefixEven: 0,
        addedCount: 0,
        totalNice: 0,
        decision: "finished",
        activeLine: 2,
        actionEn: "🏁 Line 2: Invalid k or empty array! Return 0 nice subarrays.",
        actionBn: "🏁 লাইন ২: অকার্যকর k বা খালি অ্যারে! ০ nice সাব-অ্যারে রিটার্ন করুন।",
        reasonEn: "Empty array has 0 subarrays.",
        reasonBn: "খালি অ্যারেতে ০ টি সাব-অ্যারে থাকে।",
      ));
      return steps;
    }

    int l = 0;
    int oddCount = 0;
    int prefixEven = 0;
    int total = 0;

    for (int r = 0; r < n; r++) {
      if (numbers[r] % 2 != 0) {
        oddCount++;
        prefixEven = 0;
      }

      while (oddCount == kVal) {
        if (numbers[l] % 2 != 0) {
          oddCount--;
        } else {
          prefixEven++;
        }
        l++;

        steps.add(CountNiceSubarraysStep(
          left: l,
          right: r,
          windowSub: numbers.sublist(l, r + 1),
          oddCount: oddCount,
          k: kVal,
          prefixEven: prefixEven,
          addedCount: 0,
          totalNice: total,
          decision: "shrink_left",
          activeLine: 7,
          actionEn: "⬅️ Line 7: oddCount == k ($kVal)! Shrink left pointer to $l (prefixEven = $prefixEven).",
          actionBn: "⬅️ লাইন ৭: oddCount == k ($kVal)! বাম পয়েন্টার বাড়িয়ে $l এ আনা হলো (prefixEven = $prefixEven)।",
          reasonEn: "Count prefix even numbers before the first odd number in the valid window.",
          reasonBn: "বৈধ্য উইন্ডোর প্রথম বিজোড় সংখ্যার পূর্ববর্তী জোড় সংখ্যাগুলো গণনা করা হচ্ছে।",
        ));
      }

      if (l > 0 && oddCount == kVal - 1) {
        int added = prefixEven + 1;
        total += added;

        steps.add(CountNiceSubarraysStep(
          left: l,
          right: r,
          windowSub: numbers.sublist(l, r + 1),
          oddCount: oddCount,
          k: kVal,
          prefixEven: prefixEven,
          addedCount: added,
          totalNice: total,
          decision: "count_updated",
          activeLine: 9,
          actionEn: "🎉 Line 9: Window [${l}..${r}] ➔ Added $added Nice Subarrays! (Total = $total)",
          actionBn: "🎉 লাইন ৯: উইন্ডো [${l}..${r}] ➔ $added টি Nice সাব-অ্যারে যুক্ত হলো! (সর্বমোট = $total)",
          reasonEn: "Each prefix even element extends valid subarray by +1. Added (prefixEven + 1) = $added.",
          reasonBn: "প্রতিটি পূর্ববর্তী জোড় সংখ্যা বৈধ্য সাব-অ্যারে +১ বাড়ায়। যুক্ত হলো (prefixEven + 1) = $added।",
        ));
      } else {
        steps.add(CountNiceSubarraysStep(
          left: l,
          right: r,
          windowSub: numbers.sublist(l, r + 1),
          oddCount: oddCount,
          k: kVal,
          prefixEven: prefixEven,
          addedCount: 0,
          totalNice: total,
          decision: "expand",
          activeLine: 8,
          actionEn: "➡️ Line 8: Expand right to $r (${numbers[r]}) ➔ Window [${l}..${r}] [${numbers.sublist(l, r + 1).join(', ')}] (Odds = $oddCount, Total = $total).",
          actionBn: "➡️ লাইন ৮: ডান পয়েন্টার $r (${numbers[r]}) এ বাড়ানো হলো ➔ উইন্ডো [${l}..${r}] [${numbers.sublist(l, r + 1).join(', ')}] (বিজোড় = $oddCount, সর্বমোট = $total)।",
          reasonEn: "Current window oddCount = $oddCount.",
          reasonBn: "বর্তমান উইন্ডো oddCount = $oddCount।",
        ));
      }
    }

    steps.add(CountNiceSubarraysStep(
      left: l < n ? l : n - 1,
      right: n - 1,
      windowSub: l < n ? numbers.sublist(l) : [],
      oddCount: oddCount,
      k: kVal,
      prefixEven: prefixEven,
      addedCount: 0,
      totalNice: total,
      decision: "finished",
      activeLine: 11,
      actionEn: "🏁 Line 11: Traversal Complete! Total Number of Nice Subarrays = $total.",
      actionBn: "🏁 লাইন ১১: স্ক্যান সম্পূর্ণ! সর্বমোট Nice সাব-অ্যারে সংখ্যা = $total টি।",
      reasonEn: "Evaluated all subarrays in O(N) linear time.",
      reasonBn: "O(N) লিনিয়ার সময়ে সমস্ত সাব-অ্যারের মূল্যায়ন সম্পূর্ণ।",
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

  int _numberOfSubarrays(List<int> numbers, int kVal) {
    if (kVal <= 0) return 0;
    int l = 0, odds = 0, prefixEven = 0, total = 0;
    for (int r = 0; r < numbers.length; r++) {
      if (numbers[r] % 2 != 0) {
        odds++;
        prefixEven = 0;
      }
      while (odds == kVal) {
        if (numbers[l] % 2 != 0) {
          odds--;
        } else {
          prefixEven++;
        }
        l++;
      }
      if (l > 0 && odds == kVal - 1) {
        total += (prefixEven + 1);
      }
    }
    return total;
  }

  void _handlePracticeAction(String actionType) {
    if (_practiceSolved || _practiceRight >= _nums.length) return;

    if (_k <= 0) {
      setState(() {
        _practiceSolved = true;
        _userFeedbackEn = "k <= 0 yields 0 subarrays!";
        _userFeedbackBn = "k <= 0 হলে ০ টি সাব-অ্যারে পাওয়া যায়!";
      });
      return;
    }

    int l = 0, odds = 0, prefixEven = 0, total = 0;
    bool expectedShrink = false;
    bool expectedCount = false;

    for (int r = 0; r <= _practiceRight; r++) {
      if (_nums[r] % 2 != 0) {
        odds++;
        prefixEven = 0;
      }
      while (odds == _k) {
        if (r == _practiceRight) expectedShrink = true;
        if (_nums[l] % 2 != 0) {
          odds--;
        } else {
          prefixEven++;
        }
        l++;
      }
      if (l > 0 && odds == _k - 1) {
        if (r == _practiceRight) expectedCount = true;
        total += (prefixEven + 1);
      }
    }

    String expectedAction = "EXPAND";
    if (expectedShrink) expectedAction = "SHRINK";
    if (expectedCount && !expectedShrink) expectedAction = "COUNT_UPDATED";

    setState(() {
      if (actionType == expectedAction || (actionType == "EXPAND" && expectedAction == "EXPAND")) {
        _practiceLeft = l;
        _practiceTotalNice = total;
        _practiceRight++;

        if (_practiceRight >= _nums.length) {
          _practiceSolved = true;
          _userFeedbackEn = "🏆 MASTERED! You correctly counted nice subarrays with k odd numbers! Total Nice = $total!";
          _userFeedbackBn = "🏆 দারুণ! আপনি k টি বিজোড় সংখ্যা সহ nice সাব-অ্যারে সঠিকভাবে গণনা করেছেন! সর্বমোট = $total!";
        } else {
          _userFeedbackEn = "Correct! Inspecting index $_practiceRight (${_nums[_practiceRight]}). Select next step action!";
          _userFeedbackBn = "সঠিক! ইনডেক্স $_practiceRight (${_nums[_practiceRight]}) পরীক্ষা করা হচ্ছে। পরের পদক্ষেপ নির্বাচন করুন!";
        }
      } else {
        _userFeedbackEn = "Incorrect! Index ${_practiceRight} (${_nums[_practiceRight]}) requires action: $expectedAction. Try again!";
        _userFeedbackBn = "ভুল উত্তর! ইনডেক্স ${_practiceRight} (${_nums[_practiceRight]}) এর জন্য সঠিক অ্যাকশন হলো: $expectedAction। আবার চেষ্টা করুন!";
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
          '1248. Count Number of Nice Subarrays',
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
                    "1248. Count Number of Nice Subarrays",
                    style: TextStyle(fontSize: Responsive.sp(context, 19), fontWeight: FontWeight.bold, color: Colors.white),
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
              children: ["Meta", "Amazon"].map((company) {
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
                        ? "Given an array of integers nums and an integer k. A continuous subarray is called nice if there are k odd numbers in it. Return the number of nice sub-arrays."
                        : "একটি পূর্ণসংখ্যার অ্যারে nums এবং একটি সংখ্যা k দেওয়া আছে। একটি সংলগ্ন সাব-অ্যারে কে nice বলা হবে যদি তাতে ঠিক k টি বিজোড় (odd) সংখ্যা থাকে। সর্বমোট কতটি nice সাব-অ্যারে সম্ভব তা নির্ণয় করুন।",
                    style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Examples
            Text(_isEnglish ? "Examples" : "উদাহরণসমূহ", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            _buildExampleCard("Example 1", "nums = [1, 1, 2, 1, 1], k = 3", "Output: 2 (Subarrays [1, 1, 2, 1] and [1, 2, 1, 1])"),
            _buildExampleCard("Example 2", "nums = [2, 4, 6], k = 1", "Output: 0"),
            _buildExampleCard("Example 3", "nums = [2, 2, 2, 1, 2, 2, 1, 2, 2, 2], k = 2", "Output: 16"),
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
                        _isEnglish ? "Key Intuition (Prefix Even Counter Sliding Window)" : "মূল আইডিয়া (প্রিফিক্স ইভেন কাউন্টার স্লাইডিং উইন্ডো)",
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isEnglish
                        ? "1. Track oddCount inside window [left..right].\n2. When oddCount == k, shrink left pointer and count preceding even numbers prefixEven.\n3. Every trailing even number extends the valid window by +1, so totalNice += (prefixEven + 1)!\n4. Achieves O(N) linear time complexity and O(1) space complexity!"
                        : "১. উইন্ডোতে বিজোড় সংখ্যা oddCount ট্র্যাক করুন।\n২. oddCount == k হওয়া মাত্রই বাম পয়েন্টার কমিয়ে পূর্ববর্তী জোড় সংখ্যা prefixEven গণনা করুন।\n৩. প্রতিটি পূর্ববর্তী জোড় সংখ্যা বৈধ্য উইন্ডোকে +১ করে বাড়ায়, তাই totalNice += (prefixEven + 1)!\n৪. O(N) লিনিয়ার সময় ও O(1) স্পেস কমপ্লেক্সিটি।",
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
              _isEnglish ? "Nice Subarrays Visual Models" : "নাইস সাব-অ্যারে ভিজ্যুয়াল মডেলসমূহ (কোডহীন গাইড)",
              style: TextStyle(fontSize: Responsive.sp(context, 18), fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 6),
            Text(
              _isEnglish
                  ? "Explore 3 interactive models for nums = [1, 1, 2, 1, 1], k = 3."
                  : "nums = [1, 1, 2, 1, 1], k = 3 এর জন্য ৩টি ইন্টারঅ্যাক্টিভ ভিজ্যুয়াল মডেল পর্যবেক্ষণ করুন।",
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 16),

            // Model Switcher Segmented Control
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildAnimationModelChip(0, _isEnglish ? "1. 🪜 Step Flowcard" : "১. 🪜 স্টেপ-বাই-স্টেপ ফ্লো-কার্ড"),
                  _buildAnimationModelChip(1, _isEnglish ? "2. 📏 Prefix Even Rule" : "২. 📏 প্রিফিক্স ইভেন গণনা নীতি"),
                  _buildAnimationModelChip(2, _isEnglish ? "3. 📊 Complexity Calculator" : "৩. 📊 টাইমিং ক্যালকুলেটর"),
                ],
              ),
            ),
            const SizedBox(height: 20),

            if (_animationModelIndex == 0) _buildStepFlowcardModel(),
            if (_animationModelIndex == 1) _buildPrefixEvenRuleModel(),
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
        "window": "[1, 1, 2, 1]",
        "odds": 3,
        "added": 1,
        "total": 1,
        "badge": "🎉 ADDED 1 NICE SUBARRAY",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 1: r = 3 [1, 1, 2, 1] ➔ Odds = 3 == 3! Added 1 ([1, 1, 2, 1]). Total = 1",
        "titleBn": "ধাপ ১: r = 3 [1, 1, 2, 1] ➔ বিজোড় = ৩ == ৩! যুক্ত হলো ১ টি ([1, 1, 2, 1])। সর্বমোট = ১",
        "descEn": "[1, 1, 2, 1] contains exactly 3 odd numbers.",
        "descBn": "[1, 1, 2, 1] এ ঠিক ৩টি বিজোড় সংখ্যা রয়েছে।",
      },
      {
        "step": 2,
        "window": "[1, 2, 1, 1]",
        "odds": 3,
        "added": 1,
        "total": 2,
        "badge": "🎉 ADDED 1 NICE SUBARRAY",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 2: r = 4 [1, 2, 1, 1] ➔ Odds = 3 == 3! Added 1 ([1, 2, 1, 1]). Total = 2 🎉",
        "titleBn": "ধাপ ২: r = 4 [1, 2, 1, 1] ➔ বিজোড় = ৩ == ৩! যুক্ত হলো ১ টি ([1, 2, 1, 1])। সর্বমোট = ২ 🎉",
        "descEn": "[1, 2, 1, 1] also contains 3 odd numbers. Total nice subarrays = 2!",
        "descBn": "[1, 2, 1, 1] এও ৩টি বিজোড় সংখ্যা রয়েছে। মোট nice সাব-অ্যারে = ২ টি!",
      },
      {
        "step": 3,
        "window": "[1, 2, 1, 1]",
        "odds": 3,
        "added": 0,
        "total": 2,
        "badge": "🏁 COMPLETE",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 3: Traversal Complete! Total Nice Subarrays = 2",
        "titleBn": "ধাপ ৩: স্ক্যান সম্পূর্ণ! সর্বমোট Nice সাব-অ্যারে = ২ টি",
        "descEn": "All elements processed in O(N) linear time!",
        "descBn": "O(N) লিনিয়ার সময়ে সমস্ত উপাদান প্রসেস সম্পন্ন!",
      },
    ];

    final currentStep = stepFlowData[_flowStepIndex.clamp(0, stepFlowData.length - 1)];
    final String window = currentStep["window"] as String;
    final int oddsVal = currentStep["odds"] as int;
    final int addedVal = currentStep["added"] as int;
    final int totalVal = currentStep["total"] as int;
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
                _isEnglish ? "1. Step-by-Step Nice Subarray Counting Flowcard" : "১. স্টেপ-বাই-স্টেপ নাইস সাব-অ্যারে কাউন্টিং ফ্লো-কার্ড",
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
                ? "Watch right pointer expansion and prefix even subarray addition."
                : "ডান পয়েন্টার বিস্তার এবং প্রিফিক্স ইভেন সাব-অ্যারে যোগ দেখুন।",
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
                    Text("Subarray = $window (Odds = $oddsVal)", style: TextStyle(color: badgeColor, fontWeight: FontWeight.bold, fontSize: 12)),
                    Text("Added = +$addedVal", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
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
                    "Total Nice Subarrays = $totalVal 🔢",
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

  // MODEL 2: Prefix Even Rule
  Widget _buildPrefixEvenRuleModel() {
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
            _isEnglish ? "2. Prefix Even Counter Rule" : "২. প্রিফিক্স ইভেন গণনা নীতি",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            _isEnglish
                ? "When oddCount == k, shrink left pointer: if (nums[left] % 2 == 1) oddCount--; else prefixEven++; left++; Add (prefixEven + 1) to total!"
                : "oddCount == k হলে বাম কমান: nums[left] % 2 == 1 হলে oddCount--; অন্যথায় prefixEven++; left++; মোট গণনায় (prefixEven + 1) যোগ করুন!",
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
              "while (oddCount == k) { if (nums[left++] % 2 != 0) oddCount--; else prefixEven++; } total += (prefixEven + 1); 📏",
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
                ? "Brute force checks all subarrays in O(N^2) time.\nSliding Window processes left and right pointers at most N times total in O(N) time with O(1) space!"
                : "ব্রুট ফোর্স O(N^2) সময়ে সমস্ত সাব-অ্যারে পরীক্ষা করে।\nস্লাইডিং উইন্ডো বাম ও ডান পয়েন্টার সর্বমোট N বার সরিয়ে O(N) টাইম ও O(1) স্পেসে সমাধান করে!",
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
                      flex: 2,
                      child: TextField(
                        controller: _numsController,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          labelText: _isEnglish ? "Nums Array (e.g. 1, 1, 2, 1, 1)" : "অ্যারে (যেমন 1, 1, 2, 1, 1)",
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
                          labelText: _isEnglish ? "k (Odds)" : "k (বিজোড়)",
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
                      _buildPresetChip("1, 1, 2, 1, 1", "3"),
                      _buildPresetChip("2, 4, 6", "1"),
                      _buildPresetChip("2, 2, 2, 1, 2, 2, 1, 2, 2, 2", "2"),
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
                  _buildNiceSubarraysCanvas(step),
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildCodeHighlightBox(step.activeLine)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildNiceSubarraysCanvas(step)),
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
    final targetTotalNice = _numberOfSubarrays(_nums, _k);

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
                  ? "Track window expansion and count nice subarrays with k odd numbers!"
                  : "প্রতিটি উপাদানের জন্য উইন্ডো প্রসারিত করুন এবং k টি বিজোড় সংখ্যা সহ nice সাব-অ্যারে হিসাব করুন!",
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
            if (!_practiceSolved && _practiceRight < _nums.length)
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
                        Text("Current Index: right = $_practiceRight (${_nums[_practiceRight]})", style: const TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 12)),
                        Text("Total Nice Target: $targetTotalNice", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Window: [$_practiceLeft .. $_practiceRight] = [${_nums.sublist(_practiceLeft, _practiceRight + 1).join(', ')}]",
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
                          icon: const Icon(Icons.plus_one),
                          label: Text(_isEnglish ? "COUNT UPDATED" : "COUNT UPDATED"),
                          onPressed: () => _handlePracticeAction("COUNT_UPDATED"),
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
      "int numberOfSubarrays(vector<int>& nums, int k) {",
      "    int left = 0, oddCount = 0, prefixEven = 0, total = 0;",
      "    for (int right = 0; right < nums.size(); right++) {",
      "        if (nums[right] % 2 != 0) { oddCount++; prefixEven = 0; }",
      "        while (oddCount == k) {",
      "            if (nums[left++] % 2 != 0) oddCount--;",
      "            else prefixEven++;",
      "        }",
      "        if (left > 0 && oddCount == k - 1) total += (prefixEven + 1);",
      "    }",
      "    return total;",
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

  Widget _buildNiceSubarraysCanvas(CountNiceSubarraysStep step) {
    Color decisionColor = AppTheme.accentPurple;
    String decisionLabel = "INIT";

    if (step.decision == "expand") {
      decisionColor = AppTheme.accentNeonCyan;
      decisionLabel = "➡️ EXPAND RIGHT";
    } else if (step.decision == "shrink_left") {
      decisionColor = AppTheme.accentAmber;
      decisionLabel = "⬅️ SHRINK LEFT";
    } else if (step.decision == "count_updated") {
      decisionColor = AppTheme.accentGreen;
      decisionLabel = "🎉 COUNT UPDATED";
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

          // Subarray & Meter
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Odd Count = ${step.oddCount} / k=${step.k}", style: TextStyle(color: step.oddCount == step.k ? AppTheme.accentGreen : AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 12)),
              Text("Added = +${step.addedCount}", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
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
                  "Total Nice Subarrays = ${step.totalNice} 🔢",
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
                  "Prefix Even Count = ${step.prefixEven}",
                  style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Visual Array Sequence Canvas with Pointers L and R
          const Text("Nums Array Sequence Canvas (Odd / Even):", style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_nums.length, (idx) {
                bool inWindow = idx >= step.left && idx <= step.right;
                bool isL = idx == step.left;
                bool isR = idx == step.right;
                bool isOdd = _nums[idx] % 2 != 0;

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: inWindow
                        ? (isOdd ? AppTheme.accentPink.withOpacity(0.35) : AppTheme.accentPurple.withOpacity(0.35))
                        : AppTheme.surfaceDark,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: inWindow ? (isOdd ? AppTheme.accentPink : AppTheme.accentPurple) : const Color(0xFF334155),
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
                        "${_nums[idx]}",
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isOdd ? AppTheme.accentPink : (inWindow ? Colors.white : const Color(0xFF64748B)),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isOdd ? "ODD" : "EVEN",
                        style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: isOdd ? AppTheme.accentPink : const Color(0xFF64748B)),
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
    int numberOfSubarrays(vector<int>& nums, int k) {
        int left = 0, oddCount = 0, prefixEven = 0, total = 0;
        for (int right = 0; right < nums.size(); right++) {
            if (nums[right] % 2 != 0) { oddCount++; prefixEven = 0; }
            while (oddCount == k) {
                if (nums[left++] % 2 != 0) oddCount--;
                else prefixEven++;
            }
            if (left > 0 && oddCount == k - 1) total += (prefixEven + 1);
        }
        return total;
    }
};""";
    } else if (lang == "Java") {
      code = """
class Solution {
    public int numberOfSubarrays(int[] nums, int k) {
        int left = 0, oddCount = 0, prefixEven = 0, total = 0;
        for (int right = 0; right < nums.length; right++) {
            if (nums[right] % 2 != 0) { oddCount++; prefixEven = 0; }
            while (oddCount == k) {
                if (nums[left++] % 2 != 0) oddCount--;
                else prefixEven++;
            }
            if (left > 0 && oddCount == k - 1) total += (prefixEven + 1);
        }
        return total;
    }
}""";
    } else {
      code = """
class Solution:
    def numberOfSubarrays(self, nums: List[int], k: int) -> int:
        left = 0
        odd_count = 0
        prefix_even = 0
        total = 0

        for right in range(len(nums)):
            if nums[right] % 2 != 0:
                odd_count += 1
                prefix_even = 0
            while odd_count == k:
                if nums[left] % 2 != 0:
                    odd_count -= 1
                else:
                    prefix_even += 1
                left += 1
            if left > 0 and odd_count == k - 1:
                total += (prefix_even + 1)

        return total""";
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
