import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class FruitIntoBasketsStep {
  final int left;
  final int right;
  final List<int> windowSub;
  final Map<int, int> basketMap;
  final int maxPicked;
  final List<int> maxSubarray;
  final String decision; // 'init', 'expand', 'shrink_left', 'max_updated', 'finished'
  final int activeLine;
  final String actionEn;
  final String actionBn;
  final String reasonEn;
  final String reasonBn;

  const FruitIntoBasketsStep({
    required this.left,
    required this.right,
    required this.windowSub,
    required this.basketMap,
    required this.maxPicked,
    required this.maxSubarray,
    required this.decision,
    required this.activeLine,
    required this.actionEn,
    required this.actionBn,
    required this.reasonEn,
    required this.reasonBn,
  });
}

class FruitIntoBasketsDetailScreen extends StatefulWidget {
  const FruitIntoBasketsDetailScreen({super.key});

  @override
  State<FruitIntoBasketsDetailScreen> createState() =>
      _FruitIntoBasketsDetailScreenState();
}

class _FruitIntoBasketsDetailScreenState
    extends State<FruitIntoBasketsDetailScreen>
    with SingleTickerProviderStateMixin {
  bool _isEnglish = true;
  late TabController _tabController;

  // Custom Input State
  final TextEditingController _fruitsController = TextEditingController(text: "1, 2, 3, 2, 2");
  List<int> _fruits = [1, 2, 3, 2, 2];
  List<FruitIntoBasketsStep> _steps = [];

  // Playback Control
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  // Code Language Selector
  String _selectedCodeLang = "C++";

  // Tab 2 Animation Model Selector (0: Step Flowcard, 1: 2-Basket Capacity Rule, 2: Complexity Calculator)
  int _animationModelIndex = 0;
  int _flowStepIndex = 0;

  // Practice Mode State
  int _practiceRight = 0;
  int _practiceLeft = 0;
  int _practiceMaxPicked = 0;
  String _userFeedbackEn = "Pick fruits tree by tree with at most 2 distinct fruit types!";
  String _userFeedbackBn = "সর্বোচ্চ ২টি ভিন্ন টাইপের ফল সহ গাছ থেকে ফল সংগ্রহ করুন!";
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
    _fruitsController.dispose();
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
      List<int> parsed = _fruitsController.text
          .split(',')
          .map((e) => int.parse(e.trim()))
          .toList();
      if (parsed.isEmpty) parsed = [1, 2, 3, 2, 2];
      _fruits = parsed;
    } catch (_) {
      _fruits = [1, 2, 3, 2, 2];
    }

    _steps = _generateSteps(_fruits);

    // Reset practice mode
    _resetPractice();
  }

  void _resetPractice() {
    _practiceLeft = 0;
    _practiceRight = 0;
    _practiceMaxPicked = 0;
    _practiceSolved = false;
    _userFeedbackEn = "Inspect fruit at tree index right = 0 (${_fruits.isNotEmpty ? _fruits[0] : 0})!";
    _userFeedbackBn = "গাছের ইনডেক্স right = 0 (${_fruits.isNotEmpty ? _fruits[0] : 0}) এর ফল পরীক্ষা করুন!";
  }

  List<FruitIntoBasketsStep> _generateSteps(List<int> treeList) {
    List<FruitIntoBasketsStep> steps = [];
    int n = treeList.length;

    // Step 0: Init
    steps.add(FruitIntoBasketsStep(
      left: 0,
      right: 0,
      windowSub: n > 0 ? [treeList[0]] : [],
      basketMap: {},
      maxPicked: 0,
      maxSubarray: [],
      decision: "init",
      activeLine: 1,
      actionEn: "Line 1: Initialize 2 Fruit Baskets for trees = [${treeList.join(', ')}].",
      actionBn: "লাইন ১: trees = [${treeList.join(', ')}] এর জন্য ২টি ঝুড়ি গড়া শুরু।",
      reasonEn: "We use a hash map to maintain frequencies of at most 2 distinct fruit types.",
      reasonBn: "আমরা সর্বোচ্চ ২টি ভিন্ন টাইপের ফলের ফ্রিকোয়েন্সি রাখতে হ্যাশ ম্যাপ ব্যবহার করব।",
    ));

    if (n == 0) {
      steps.add(const FruitIntoBasketsStep(
        left: 0,
        right: 0,
        windowSub: [],
        basketMap: {},
        maxPicked: 0,
        maxSubarray: [],
        decision: "finished",
        activeLine: 2,
        actionEn: "🏁 Line 2: Empty tree row! Return 0 fruits.",
        actionBn: "🏁 লাইন ২: কোনো ফলের গাছ নেই! ০ ফল ফেরত দিন।",
        reasonEn: "Empty row yields 0 fruits.",
        reasonBn: "খালি সারিতে ০ টি ফল পাওয়া যায়।",
      ));
      return steps;
    }

    int l = 0;
    Map<int, int> bMap = {};
    int maxP = 0;
    List<int> maxSubarray = [];

    for (int r = 0; r < n; r++) {
      int fruit = treeList[r];
      bMap[fruit] = (bMap[fruit] ?? 0) + 1;

      if (bMap.length > 2) {
        int leftFruit = treeList[l];
        bMap[leftFruit] = bMap[leftFruit]! - 1;
        if (bMap[leftFruit] == 0) bMap.remove(leftFruit);
        l++;

        steps.add(FruitIntoBasketsStep(
          left: l,
          right: r,
          windowSub: treeList.sublist(l, r + 1),
          basketMap: Map.from(bMap),
          maxPicked: maxP,
          maxSubarray: List.from(maxSubarray),
          decision: "shrink_left",
          activeLine: 7,
          actionEn: "⬅️ Line 7: Distinct fruit types (${bMap.length + 1}) > 2! Shrink left pointer to $l.",
          actionBn: "⬅️ লাইন ৭: ফলের ভিন্ন টাইপ (${bMap.length + 1}) > ২! বাম পয়েন্টার বাড়িয়ে $l এ আনা হলো।",
          reasonEn: "Baskets can hold only 2 distinct fruit types. Remove fruit $leftFruit from left.",
          reasonBn: "ঝুড়িতে সর্বোচ্চ ২টি ভিন্ন টাইপ থাকতে পারে। বাম পাশ থেকে ফল $leftFruit রিমুভ করা হলো।",
        ));
      } else {
        int windowLen = r - l + 1;
        if (windowLen > maxP) {
          maxP = windowLen;
          maxSubarray = treeList.sublist(l, r + 1);
          steps.add(FruitIntoBasketsStep(
            left: l,
            right: r,
            windowSub: treeList.sublist(l, r + 1),
            basketMap: Map.from(bMap),
            maxPicked: maxP,
            maxSubarray: List.from(maxSubarray),
            decision: "max_updated",
            activeLine: 9,
            actionEn: "🎉 Line 9: NEW Max Fruits Picked! Window [${l}..${r}] [${maxSubarray.join(', ')}] ➔ Fruits Picked = $maxP!",
            actionBn: "🎉 লাইন ৯: নতুন সর্বোচ্চ সংগৃহীত ফল! উইন্ডো [${l}..${r}] [${maxSubarray.join(', ')}] ➔ সংগৃহীত ফল = $maxP!",
            reasonEn: "Current window size $windowLen exceeds previous max picked fruits. Update maxP!",
            reasonBn: "বর্তমান উইন্ডোর সাইজ $windowLen পূর্বের সর্বমোট সংগ্রহকে ছাড়িয়ে গেছে। maxP আপডেট করুন!",
          ));
        } else {
          steps.add(FruitIntoBasketsStep(
            left: l,
            right: r,
            windowSub: treeList.sublist(l, r + 1),
            basketMap: Map.from(bMap),
            maxPicked: maxP,
            maxSubarray: List.from(maxSubarray),
            decision: "expand",
            activeLine: 8,
            actionEn: "➡️ Line 8: Pick fruit type $fruit at tree $r ➔ Window [${l}..${r}] [${treeList.sublist(l, r + 1).join(', ')}] (Types = ${bMap.keys.join(', ')}, Max = $maxP).",
            actionBn: "➡️ লাইন ৮: $r নং গাছে ফল টাইপ $fruit তোলা হলো ➔ উইন্ডো [${l}..${r}] [${treeList.sublist(l, r + 1).join(', ')}] (টাইপ = ${bMap.keys.join(', ')}, সর্বমোট = $maxP)।",
            reasonEn: "Valid window with ${bMap.length} distinct fruit types in baskets.",
            reasonBn: "ঝুড়িতে ${bMap.length} টি ভিন্ন ফলের টাইপ সহ বৈধ্য উইন্ডো।",
          ));
        }
      }
    }

    steps.add(FruitIntoBasketsStep(
      left: l < n ? l : n - 1,
      right: n - 1,
      windowSub: l < n ? treeList.sublist(l) : [],
      basketMap: Map.from(bMap),
      maxPicked: maxP,
      maxSubarray: List.from(maxSubarray),
      decision: "finished",
      activeLine: 11,
      actionEn: "🏁 Line 11: Traversal Complete! Maximum Fruits Picked = $maxP (Subarray [${maxSubarray.join(', ')}]).",
      actionBn: "🏁 লাইন ১১: স্ক্যান সম্পূর্ণ! সর্বোচ্চ সংগৃহীত ফল = $maxP (সাব-অ্যারে [${maxSubarray.join(', ')}])।",
      reasonEn: "Evaluated tree row of length $n in O(N) linear time.",
      reasonBn: "O(N) লিনিয়ার সময়ে $n টি গাছের সারি মূল্যায়ন সম্পন্ন।",
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

  int _totalFruit(List<int> treeList) {
    int l = 0, maxP = 0;
    Map<int, int> bMap = {};
    for (int r = 0; r < treeList.length; r++) {
      bMap[treeList[r]] = (bMap[treeList[r]] ?? 0) + 1;
      if (bMap.length > 2) {
        bMap[treeList[l]] = bMap[treeList[l]]! - 1;
        if (bMap[treeList[l]] == 0) bMap.remove(treeList[l]);
        l++;
      }
      maxP = max(maxP, r - l + 1);
    }
    return maxP;
  }

  void _handlePracticeAction(String actionType) {
    if (_practiceSolved || _practiceRight >= _fruits.length) return;

    int l = 0, maxP = 0;
    Map<int, int> bMap = {};
    bool expectedShrink = false;
    bool expectedMax = false;

    for (int r = 0; r <= _practiceRight; r++) {
      bMap[_fruits[r]] = (bMap[_fruits[r]] ?? 0) + 1;
      if (bMap.length > 2) {
        if (r == _practiceRight) expectedShrink = true;
        bMap[_fruits[l]] = bMap[_fruits[l]]! - 1;
        if (bMap[_fruits[l]] == 0) bMap.remove(_fruits[l]);
        l++;
      }
      int curLen = r - l + 1;
      if (curLen > maxP) {
        if (r == _practiceRight) expectedMax = true;
        maxP = curLen;
      }
    }

    String expectedAction = "EXPAND";
    if (expectedShrink) expectedAction = "SHRINK";
    if (expectedMax) expectedAction = "MAX_UPDATED";

    setState(() {
      if (actionType == expectedAction || (actionType == "EXPAND" && expectedAction == "EXPAND")) {
        _practiceLeft = l;
        _practiceMaxPicked = maxP;
        _practiceRight++;

        if (_practiceRight >= _fruits.length) {
          _practiceSolved = true;
          _userFeedbackEn = "🏆 MASTERED! You correctly packed at most 2 distinct fruit types into baskets! Max Picked = $maxP!";
          _userFeedbackBn = "🏆 দারুণ! আপনি ঝুড়িতে সর্বোচ্চ ২টি ভিন্ন টাইপের ফল সঠিকভাবে সংগ্রহ করেছেন! সর্বমোট ফল = $maxP!";
        } else {
          _userFeedbackEn = "Correct! Inspecting tree index $_practiceRight (${_fruits[_practiceRight]}). Select next step action!";
          _userFeedbackBn = "সঠিক! ইনডেক্স $_practiceRight (${_fruits[_practiceRight]}) পরীক্ষা করা হচ্ছে। পরের পদক্ষেপ নির্বাচন করুন!";
        }
      } else {
        _userFeedbackEn = "Incorrect! Tree index ${_practiceRight} (${_fruits[_practiceRight]}) requires action: $expectedAction. Try again!";
        _userFeedbackBn = "ভুল উত্তর! ইনডেক্স ${_practiceRight} (${_fruits[_practiceRight]}) এর জন্য সঠিক অ্যাকশন হলো: $expectedAction। আবার চেষ্টা করুন!";
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
          '904. Fruit Into Baskets',
          style: TextStyle(fontSize: Responsive.sp(context, 17), fontWeight: FontWeight.bold),
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
                    "904. Fruit Into Baskets",
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
                        ? "You have 2 baskets, and each basket can only hold a single type of fruit. Return the maximum number of fruits you can pick from a contiguous sequence of trees with at most 2 distinct fruit types."
                        : "আপনার কাছে ২টি ঝুড়ি আছে এবং প্রতিটি ঝুড়িতে কেবল ১টি নির্দিষ্ট টাইপের ফল রাখা যায়। পর পর গাছ থেকে সর্বোচ্চ কতটি ফল সংগ্রহ করা যাবে যাতে ফলগুলোর মধ্যে সর্বোচ্চ ২টি ভিন্ন টাইপের ফল থাকে?",
                    style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Examples
            Text(_isEnglish ? "Examples" : "উদাহরণসমূহ", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            _buildExampleCard("Example 1", "fruits = [1, 2, 1]", "Output: 3 (Subarray [1, 2, 1])"),
            _buildExampleCard("Example 2", "fruits = [0, 1, 2, 2]", "Output: 3 (Subarray [1, 2, 2])"),
            _buildExampleCard("Example 3", "fruits = [1, 2, 3, 2, 2]", "Output: 4 (Subarray [2, 3, 2, 2])"),
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
                        _isEnglish ? "Key Intuition (At most 2 Distinct Fruit Types Map)" : "মূল আইডিয়া (সর্বোচ্চ ২টি ভিন্ন ফলের টাইপ ম্যাপ)",
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isEnglish
                        ? "1. Expand right pointer and maintain fruit frequencies in a Hash Map.\n2. Valid condition: basketMap.size() <= 2.\n3. When basketMap.size() > 2, shrink left pointer (left++) and decrement fruit frequency until size <= 2.\n4. Achieves O(N) linear time complexity and O(1) space complexity!"
                        : "১. ডান পয়েন্টার বাড়ান এবং হ্যাশ ম্যাপে ফলের ফ্রিকোয়েন্সি হিসাব রাখুন।\n২. বৈধ্য শর্ত: basketMap.size() <= 2।\n৩. basketMap.size() > 2 হলে বাম পয়েন্টার কমিয়ে (left++) টাইপ সংখ্যা ২ এ আনুন।\n৪. O(N) লিনিয়ার সময় ও O(1) স্পেস কমপ্লেক্সিটি।",
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
              _isEnglish ? "Fruit Into Baskets Visual Models" : "ফলের ঝুড়ি ভিজ্যুয়াল মডেলসমূহ (কোডহীন গাইড)",
              style: TextStyle(fontSize: Responsive.sp(context, 18), fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 6),
            Text(
              _isEnglish
                  ? "Explore 3 interactive models for fruits = [1, 2, 3, 2, 2]."
                  : "fruits = [1, 2, 3, 2, 2] এর জন্য ৩টি ইন্টারঅ্যাক্টিভ ভিজ্যুয়াল মডেল পর্যবেক্ষণ করুন।",
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 16),

            // Model Switcher Segmented Control
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildAnimationModelChip(0, _isEnglish ? "1. 🪜 Step Flowcard" : "১. 🪜 স্টেপ-বাই-স্টেপ ফ্লো-কার্ড"),
                  _buildAnimationModelChip(1, _isEnglish ? "2. 📏 2-Basket Capacity Rule" : "২. 📏 ২-ঝুড়ি ধারণক্ষমতার নীতি"),
                  _buildAnimationModelChip(2, _isEnglish ? "3. 📊 Complexity Calculator" : "৩. 📊 টাইমিং ক্যালকুলেটর"),
                ],
              ),
            ),
            const SizedBox(height: 20),

            if (_animationModelIndex == 0) _buildStepFlowcardModel(),
            if (_animationModelIndex == 1) _buildTwoBasketRuleModel(),
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
        "window": "[1, 2]",
        "types": "1, 2",
        "max": 2,
        "badge": "🎉 VALID BASKETS (LEN=2)",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 1: Pick [1, 2] at [0..1] ➔ Distinct Types = 2 <= 2! Length = 2",
        "titleBn": "ধাপ ১: [0..1] এ [1, 2] সংগ্রহ ➔ ভিন্ন টাইপ = ২ <= ২! দৈর্ঘ্য = ২",
        "descEn": "Baskets contain fruit type 1 and type 2.",
        "descBn": "ঝুড়িতে ফল টাইপ ১ এবং টাইপ ২ রয়েছে।",
      },
      {
        "step": 2,
        "window": "[1, 2, 3]",
        "types": "1, 2, 3",
        "max": 2,
        "badge": "⬅️ SHRINK LEFT",
        "badgeColor": AppTheme.accentAmber,
        "titleEn": "Step 2: Pick 3 at index 2 ➔ Distinct Types = 3 > 2! Shrink Left to index 1",
        "titleBn": "ধাপ ২: ইনডেক্স ২ এ ৩ সংগ্রহ ➔ ভিন্ন টাইপ = ৩ > ২! বাম কমান ইনডেক্স ১ এ",
        "descEn": "3 fruit types exceed 2 baskets. Drop fruit 1 from left.",
        "descBn": "৩টি ফলের টাইপ ২টি ঝুড়ি ছাড়িয়ে গেছে। বাম থেকে ফল ১ রিমুভ করুন।",
      },
      {
        "step": 3,
        "window": "[2, 3, 2, 2]",
        "types": "2, 3",
        "max": 4,
        "badge": "🎉 NEW MAX PICKED = 4",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 3: Expand to index 4 [2, 3, 2, 2] ➔ Types = {2, 3} <= 2! NEW Max = 4! 🎉",
        "titleBn": "ধাপ ৩: ইনডেক্স ৪ এ প্রসার [2, 3, 2, 2] ➔ টাইপ = {2, 3} <= ২! নতুন Max = ৪! 🎉",
        "descEn": "Subarray [2, 3, 2, 2] gives maximum 4 fruits with 2 baskets!",
        "descBn": "সাব-অ্যারে [2, 3, 2, 2] ২টি ঝুড়িতে সর্বোচ্চ ৪টি ফল সংগ্রহ প্রদান করে!",
      },
      {
        "step": 4,
        "window": "[2, 3, 2, 2]",
        "types": "2, 3",
        "max": 4,
        "badge": "🏁 COMPLETE",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 4: All Trees Evaluated! Maximum Fruits Picked = 4",
        "titleBn": "ধাপ ৪: সমস্ত গাছের সারি মূল্যায়ন সম্পন্ন! সর্বোচ্চ সংগৃহীত ফল = ৪",
        "descEn": "Maximum fruits picked with 2 baskets = 4!",
        "descBn": "২টি ঝুড়িতে সর্বোচ্চ সংগৃহীত ফল = ৪!",
      },
    ];

    final currentStep = stepFlowData[_flowStepIndex.clamp(0, stepFlowData.length - 1)];
    final String window = currentStep["window"] as String;
    final String typesVal = currentStep["types"] as String;
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
                _isEnglish ? "1. Step-by-Step Basket Collection Flowcard" : "১. স্টেপ-বাই-স্টেপ ঝুড়িতে ফল সংগ্রহ ফ্লো-কার্ড",
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
                ? "Watch right pointer expansion and 2-basket capacity check."
                : "ডান পয়েন্টার বিস্তার এবং ২-ঝুড়ি ধারণক্ষমতা পরীক্ষা দেখুন।",
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
                    Text("Trees = $window (Types: {$typesVal})", style: TextStyle(color: badgeColor, fontWeight: FontWeight.bold, fontSize: 12)),
                    Text("Max Picked = $maxVal", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
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
                    "Max Fruits Picked = $maxVal 🧺",
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

  // MODEL 2: 2-Basket Capacity Rule
  Widget _buildTwoBasketRuleModel() {
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
            _isEnglish ? "2. 2-Basket Capacity Rule" : "২. ২-ঝুড়ি ধারণক্ষমতার নীতি",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            _isEnglish
                ? "If basketMap.size() > 2, decrement fruit frequency at left: basketMap[fruits[left]]--. If count == 0, remove key."
                : "basketMap.size() > 2 হলে বামের ফলের ফ্রিকোয়েন্সি কমান: basketMap[fruits[left]]--। সংকা ০ হলে কি-টি রিমুভ করুন।",
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
              "if (basketMap.size() > 2) { if (--basketMap[fruits[left]] == 0) basketMap.erase(fruits[left]); left++; } 🧺",
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
                ? "Brute force checks all subarrays in O(N^2) time.\nSliding Window processes each tree at most twice in O(N) time with O(1) space (at most 3 items in map)!"
                : "ব্রুট ফোর্স O(N^2) সময়ে সমস্ত সাব-অ্যারে পরীক্ষা করে।\nস্লাইডিং উইন্ডো প্রতিটি গাছকে সর্বোচ্চ ২ বার প্রসেস করে O(N) টাইম ও O(1) স্পেসে (ম্যাপে সর্বোচ্চ ৩টি উপাদান)!",
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
                        controller: _fruitsController,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          labelText: _isEnglish ? "Fruits Array (e.g. 1, 2, 3, 2, 2)" : "ফলের অ্যারে (যেমন 1, 2, 3, 2, 2)",
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
                      _buildPresetChip("1, 2, 1"),
                      _buildPresetChip("0, 1, 2, 2"),
                      _buildPresetChip("1, 2, 3, 2, 2"),
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
                  _buildFruitCanvas(step),
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildCodeHighlightBox(step.activeLine)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildFruitCanvas(step)),
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
    final targetMaxPicked = _totalFruit(_fruits);

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
                  ? "Track window expansion and decide next step action at each tree element!"
                  : "প্রতিটি ফলের গাছের জন্য উইন্ডো প্রসারিত করুন এবং পরবর্তী অ্যাকশন নির্বাচন করুন!",
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
            if (!_practiceSolved && _practiceRight < _fruits.length)
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
                        Text("Current Tree Index: right = $_practiceRight (${_fruits[_practiceRight]})", style: const TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 12)),
                        Text("Max Picked Target: $targetMaxPicked", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Window: [$_practiceLeft .. $_practiceRight] = [${_fruits.sublist(_practiceLeft, _practiceRight + 1).join(', ')}]",
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
  Widget _buildPresetChip(String fVal) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ActionChip(
        backgroundColor: const Color(0xFF090D16),
        label: Text("[$fVal]", style: const TextStyle(color: AppTheme.accentNeonCyan, fontSize: 11)),
        onPressed: () {
          _fruitsController.text = fVal;
          _rebuildSteps();
        },
      ),
    );
  }

  Widget _buildCodeHighlightBox(int activeLine) {
    final codeLines = [
      "int totalFruit(vector<int>& fruits) {",
      "    unordered_map<int, int> basketMap;",
      "    int left = 0, maxPicked = 0;",
      "    for (int right = 0; right < fruits.size(); right++) {",
      "        basketMap[fruits[right]]++;",
      "        if (basketMap.size() > 2) {",
      "            if (--basketMap[fruits[left]] == 0) basketMap.erase(fruits[left]);",
      "            left++;",
      "        }",
      "        maxPicked = max(maxPicked, right - left + 1);",
      "    }",
      "    return maxPicked;",
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

  Widget _buildFruitCanvas(FruitIntoBasketsStep step) {
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
      decisionLabel = "🎉 MAX PICKED UPDATED";
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

          // Subarray & Meter
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Baskets Map: ${step.basketMap}", style: TextStyle(color: step.basketMap.length <= 2 ? AppTheme.accentGreen : AppTheme.accentPink, fontWeight: FontWeight.bold, fontSize: 12)),
              Text("Max Fruits Picked = ${step.maxPicked}", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
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
                  "Max Fruits Picked = ${step.maxPicked} 🧺",
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
                  "Max Subarray: [${step.maxSubarray.join(', ')}]",
                  style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Visual Array Sequence Canvas with Pointers L and R
          const Text("Fruit Trees Sequence Canvas:", style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_fruits.length, (idx) {
                bool inWindow = idx >= step.left && idx <= step.right;
                bool isL = idx == step.left;
                bool isR = idx == step.right;
                int fruitType = _fruits[idx];

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
                        "🍎 Type $fruitType",
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
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
    int totalFruit(vector<int>& fruits) {
        unordered_map<int, int> basketMap;
        int left = 0, maxPicked = 0;
        for (int right = 0; right < fruits.size(); right++) {
            basketMap[fruits[right]]++;
            if (basketMap.size() > 2) {
                if (--basketMap[fruits[left]] == 0) basketMap.erase(fruits[left]);
                left++;
            }
            maxPicked = max(maxPicked, right - left + 1);
        }
        return maxPicked;
    }
};""";
    } else if (lang == "Java") {
      code = """
class Solution {
    public int totalFruit(int[] fruits) {
        Map<Integer, Integer> basketMap = new HashMap<>();
        int left = 0, maxPicked = 0;
        for (int right = 0; right < fruits.length; right++) {
            basketMap.put(fruits[right], basketMap.getOrDefault(fruits[right], 0) + 1);
            if (basketMap.size() > 2) {
                basketMap.put(fruits[left], basketMap.get(fruits[left]) - 1);
                if (basketMap.get(fruits[left]) == 0) basketMap.remove(fruits[left]);
                left++;
            }
            maxPicked = Math.max(maxPicked, right - left + 1);
        }
        return maxPicked;
    }
}""";
    } else {
      code = """
class Solution:
    def totalFruit(self, fruits: List[int]) -> int:
        basket_map = {}
        left = 0
        max_picked = 0

        for right in range(len(fruits)):
            basket_map[fruits[right]] = basket_map.get(fruits[right], 0) + 1
            if len(basket_map) > 2:
                basket_map[fruits[left]] -= 1
                if basket_map[fruits[left]] == 0:
                    del basket_map[fruits[left]]
                left += 1
            max_picked = max(max_picked, right - left + 1)

        return max_picked""";
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
