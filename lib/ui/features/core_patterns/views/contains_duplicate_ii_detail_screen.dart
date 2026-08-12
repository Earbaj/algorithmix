import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class ContainsDuplicateIIStep {
  final int index;
  final int currentVal;
  final Set<int> windowSet;
  final bool duplicateFound;
  final int? duplicateVal;
  final String decision; // 'init', 'check_set', 'duplicate_found', 'add_to_set', 'remove_oldest', 'finished_false'
  final int activeLine;
  final String actionEn;
  final String actionBn;
  final String reasonEn;
  final String reasonBn;

  const ContainsDuplicateIIStep({
    required this.index,
    required this.currentVal,
    required this.windowSet,
    required this.duplicateFound,
    this.duplicateVal,
    required this.decision,
    required this.activeLine,
    required this.actionEn,
    required this.actionBn,
    required this.reasonEn,
    required this.reasonBn,
  });
}

class ContainsDuplicateIIDetailScreen extends StatefulWidget {
  const ContainsDuplicateIIDetailScreen({super.key});

  @override
  State<ContainsDuplicateIIDetailScreen> createState() => _ContainsDuplicateIIDetailScreenState();
}

class _ContainsDuplicateIIDetailScreenState extends State<ContainsDuplicateIIDetailScreen>
    with SingleTickerProviderStateMixin {
  bool _isEnglish = true;
  late TabController _tabController;

  // Custom Input State
  final TextEditingController _numsController = TextEditingController(text: "1, 2, 3, 1");
  final TextEditingController _kController = TextEditingController(text: "3");
  List<int> _nums = [1, 2, 3, 1];
  int _k = 3;
  List<ContainsDuplicateIIStep> _steps = [];

  // Playback Control
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  // Code Language Selector
  String _selectedCodeLang = "C++";

  // Tab 2 Animation Model Selector (0: Step Flowcard, 1: Sliding Window Set Buffer, 2: Complexity Comparison)
  int _animationModelIndex = 0;
  int _flowStepIndex = 0;

  // Practice Mode State
  int _practiceIndex = 0;
  Set<int> _practiceWindowSet = {};
  String _userFeedbackEn = "Step through elements and check if a duplicate exists in the K-sized window!";
  String _userFeedbackBn = "উপাদানসমূহ একটির পর একটি চেক করে দেখুন K উইন্ডোতে দ্বৈত মান আছে কিনা!";
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
      if (parsed.isEmpty) parsed = [1, 2, 3, 1];
      _nums = parsed;

      int kVal = int.parse(_kController.text.trim());
      if (kVal <= 0) kVal = 1;
      _k = kVal;
    } catch (_) {
      _nums = [1, 2, 3, 1];
      _k = 3;
    }

    _steps = _generateSteps(_nums, _k);

    // Reset practice mode
    _resetPractice();
  }

  void _resetPractice() {
    _practiceIndex = 0;
    _practiceWindowSet = {};
    _practiceSolved = false;
    _userFeedbackEn = "Tap 'Next Step' to inspect elements in window size K = $_k!";
    _userFeedbackBn = "উইন্ডো সাইজ K = $_k এর উপাদানসমূহ পরীক্ষা করতে 'Next Step' চাপুন!";
  }

  List<ContainsDuplicateIIStep> _generateSteps(List<int> inputNums, int windowK) {
    List<ContainsDuplicateIIStep> steps = [];
    Set<int> seen = {};

    // Step 0: Init
    steps.add(ContainsDuplicateIIStep(
      index: 0,
      currentVal: 0,
      windowSet: {},
      duplicateFound: false,
      decision: "init",
      activeLine: 1,
      actionEn: "Line 1: Initialize Sliding Window Hash Set for nums = [${inputNums.join(', ')}], K = $windowK.",
      actionBn: "লাইন ১: অ্যাররে nums = [${inputNums.join(', ')}], K = $windowK এর জন্য স্লাইডিং উইন্ডো সেট শুরু।",
      reasonEn: "We maintain a hash set containing at most K elements to check duplicates in O(1) time.",
      reasonBn: "O(1) সময়ে দ্বৈত মান চেকের জন্য অনধিক K উপাদানের হ্যাশ সেট বজায় রাখা হবে।",
    ));

    bool found = false;

    for (int i = 0; i < inputNums.length; i++) {
      int val = inputNums[i];

      // Check if duplicate exists
      if (seen.contains(val)) {
        found = true;
        steps.add(ContainsDuplicateIIStep(
          index: i,
          currentVal: val,
          windowSet: Set.from(seen),
          duplicateFound: true,
          duplicateVal: val,
          decision: "duplicate_found",
          activeLine: 4,
          actionEn: "🎉 Line 4: Duplicate element '$val' found at index $i! (Already in window set). Return true!",
          actionBn: "🎉 লাইন ৪: ইনডেক্স $i এ দ্বৈত উপাদান '$val' পাওয়া গেছে! (ইতিমধ্যেই সেটে বিদ্যমান)। true রিটার্ন করুন!",
          reasonEn: "Element $val is present in window set, meaning distance between duplicates is <= K.",
          reasonBn: "উপাদান $val উইন্ডো সেটে থাকায় দুটি দ্বৈত মানের মধ্যবর্তী দূরত্ব <= K।",
        ));
        break;
      }

      // Add to set
      seen.add(val);
      steps.add(ContainsDuplicateIIStep(
        index: i,
        currentVal: val,
        windowSet: Set.from(seen),
        duplicateFound: false,
        decision: "add_to_set",
        activeLine: 5,
        actionEn: "📥 Line 5: Added '$val' at index $i to window set. Set = {${seen.join(', ')}}.",
        actionBn: "📥 লাইন ৫: ইনডেক্স $i এর '$val' উইন্ডো সেটে যুক্ত করা হলো। Set = {${seen.join(', ')}}।",
        reasonEn: "No duplicate for $val yet. Add to set buffer.",
        reasonBn: "$val এর জন্য কোনো দ্বৈত পাওয়া যায়নি। সেটে যোগ করুন।",
      ));

      // Maintain max set size K
      if (seen.length > windowK) {
        int oldestVal = inputNums[i - windowK];
        seen.remove(oldestVal);

        steps.add(ContainsDuplicateIIStep(
          index: i,
          currentVal: val,
          windowSet: Set.from(seen),
          duplicateFound: false,
          decision: "remove_oldest",
          activeLine: 6,
          actionEn: "🗑️ Line 6: Set size exceeded K ($windowK)! Removed oldest element '$oldestVal' from set.",
          actionBn: "🗑️ লাইন ৬: সেট সাইজ K ($windowK) অতিক্রম করেছে! সবচেয়ে পুরোনো উপাদান '$oldestVal' সেট থেকে মুছে ফেলা হলো।",
          reasonEn: "Keep set size strictly <= K to ensure only elements within K distance are checked.",
          reasonBn: "শুধুমাত্র K দূরত্বের উপাদান চেকের জন্য সেটের আকার <= K রাখা হয়।",
        ));
      }
    }

    if (!found) {
      steps.add(ContainsDuplicateIIStep(
        index: inputNums.length - 1,
        currentVal: 0,
        windowSet: Set.from(seen),
        duplicateFound: false,
        decision: "finished_false",
        activeLine: 8,
        actionEn: "❌ Line 8: Traversal Complete! No duplicate elements found within distance K = $windowK. Return false.",
        actionBn: "❌ লাইন ৮: অনুসন্ধান সম্পূর্ণ! K = $windowK দূরত্বের মধ্যে কোনো দ্বৈত উপাদান পাওয়া যায়নি। false রিটার্ন করুন।",
        reasonEn: "Scanned all elements without encountering any duplicate within window distance K.",
        reasonBn: "উইন্ডো দূরত্ব K এর মধ্যে কোনো দ্বৈত উপাদান ছাড়াই সমস্ত উপাদান পরীক্ষা শেষ।",
      ));
    }

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

  bool _checkContainsDuplicate(List<int> inputNums, int kVal) {
    Set<int> seen = {};
    for (int i = 0; i < inputNums.length; i++) {
      if (seen.contains(inputNums[i])) return true;
      seen.add(inputNums[i]);
      if (seen.length > kVal) seen.remove(inputNums[i - kVal]);
    }
    return false;
  }

  void _handlePracticeNextStep() {
    if (_practiceSolved || _practiceIndex >= _nums.length) return;
    bool expectedResult = _checkContainsDuplicate(_nums, _k);

    setState(() {
      int val = _nums[_practiceIndex];

      if (_practiceWindowSet.contains(val)) {
        _practiceSolved = true;
        _userFeedbackEn = "🎉 DUPLICATE FOUND! Element '$val' at index $_practiceIndex is already in window set! Result: TRUE!";
        _userFeedbackBn = "🎉 দ্বৈত মান পাওয়া গেছে! ইনডেক্স $_practiceIndex এর উপাদান '$val' ইতিমধ্যেই উইন্ডো সেটে আছে! রেজাল্ট: TRUE!";
        return;
      }

      _practiceWindowSet.add(val);
      if (_practiceWindowSet.length > _k) {
        _practiceWindowSet.remove(_nums[_practiceIndex - _k]);
      }

      _practiceIndex++;

      if (_practiceIndex == _nums.length) {
        _practiceSolved = true;
        if (!expectedResult) {
          _userFeedbackEn = "❌ Traversal finished! No duplicates found within distance K = $_k. Result: FALSE!";
          _userFeedbackBn = "❌ স্ক্যান সম্পূর্ণ! K = $_k দূরত্বের মধ্যে কোনো দ্বৈত মান নেই। রেজাল্ট: FALSE!";
        }
      } else {
        _userFeedbackEn = "Inspected index ${_practiceIndex - 1} (val $val). Next: Inspect index $_practiceIndex (val ${_nums[_practiceIndex]}).";
        _userFeedbackBn = "ইনডেক্স ${_practiceIndex - 1} (মান $val) পরীক্ষা সম্পন্ন। পরের: ইনডেক্স $_practiceIndex (মান ${_nums[_practiceIndex]}) পরীক্ষা করুন।";
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
          '219. Contains Duplicate II',
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
                    "219. Contains Duplicate II",
                    style: TextStyle(fontSize: Responsive.sp(context, 22), fontWeight: FontWeight.bold, color: Colors.white),
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
              children: ["Amazon", "Meta", "Microsoft"].map((company) {
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
                        ? "Given an integer array nums and an integer k, return true if there are two distinct indices i and j in the array such that nums[i] == nums[j] and abs(i - j) <= k."
                        : "একটি পূর্ণসংখ্যার অ্যাররে nums এবং একটি পূর্ণসংখ্যা k দেওয়া আছে। অ্যাররেতে এমন দুটি ভিন্ন ইনডেক্স i এবং j থাকলে true রিটার্ন করুন যাতে nums[i] == nums[j] এবং abs(i - j) <= k হয়।",
                    style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Examples
            Text(_isEnglish ? "Examples" : "উদাহরণসমূহ", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            _buildExampleCard("Example 1", "nums = [1,2,3,1], k = 3", "Output: true"),
            _buildExampleCard("Example 2", "nums = [1,0,1,1], k = 1", "Output: true"),
            _buildExampleCard("Example 3", "nums = [1,2,3,1,2,3], k = 2", "Output: false"),
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
                        _isEnglish ? "Key Intuition (Sliding Window Hash Set of Size K)" : "মূল আইডিয়া (সাইজ K এর স্লাইডিং উইন্ডো হ্যাশ সেট)",
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isEnglish
                        ? "1. Use a hash set to store elements of current sliding window.\n2. If nums[i] is already in set, return true (duplicate within distance K found!).\n3. Keep set size <= K by removing nums[i - k] when set exceeds size K."
                        : "১. বর্তমান স্লাইডিং উইন্ডোর উপাদান রাখতে একটি হ্যাশ সেট ব্যবহার করুন।\n২. nums[i] সেটে ইতিমধ্যেই থাকলে true রিটার্ন করুন (K দূরত্বের মধ্যে দ্বৈত পাওয়া গেছে)।\n৩. সেট সাইজ K অতিক্রম করলে পুরোনো উপাদান nums[i - k] মুছে সাইজ <= K রাখুন।",
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
              _isEnglish ? "Contains Duplicate II Visual Models" : "কনটেইনস ডুপ্লিকেট ২ ভিজ্যুয়াল মডেলসমূহ (কোডহীন গাইড)",
              style: TextStyle(fontSize: Responsive.sp(context, 18), fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 6),
            Text(
              _isEnglish
                  ? "Explore 3 interactive models for nums = [1, 2, 3, 1], K = 3."
                  : "nums = [1, 2, 3, 1], K = 3 এর জন্য ৩টি ইন্টারঅ্যাক্টিভ ভিজ্যুয়াল মডেল পর্যবেক্ষণ করুন।",
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 16),

            // Model Switcher Segmented Control
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildAnimationModelChip(0, _isEnglish ? "1. 🪜 Step Flowcard" : "১. 🪜 স্টেপ-বাই-স্টেপ ফ্লো-কার্ড"),
                  _buildAnimationModelChip(1, _isEnglish ? "2. 🛡️ Window Set Buffer" : "২. 🛡️ উইন্ডো সেট বাফার"),
                  _buildAnimationModelChip(2, _isEnglish ? "3. 📊 O(N*K) vs O(N) Comparison" : "৩. 📊 O(N*K) বনাম O(N) তুলনা"),
                ],
              ),
            ),
            const SizedBox(height: 20),

            if (_animationModelIndex == 0) _buildStepFlowcardModel(),
            if (_animationModelIndex == 1) _buildWindowSetBufferModel(),
            if (_animationModelIndex == 2) _buildComplexityComparisonModel(),

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
        "set": "{1}",
        "val": 1,
        "badge": "📥 ADD TO SET",
        "badgeColor": AppTheme.accentNeonCyan,
        "titleEn": "Step 1: Index 0 (val 1) ➔ Added 1 to Set = {1}",
        "titleBn": "ধাপ ১: ইনডেক্স ০ (মান ১) ➔ ১ যোগ করে সেটে রাখুন = {1}",
        "descEn": "No duplicate found. Set size = 1 <= K.",
        "descBn": "কোনো দ্বৈত মান নেই। সেট সাইজ = ১ <= K।",
      },
      {
        "step": 2,
        "set": "{1, 2}",
        "val": 2,
        "badge": "📥 ADD TO SET",
        "badgeColor": AppTheme.accentNeonCyan,
        "titleEn": "Step 2: Index 1 (val 2) ➔ Added 2 to Set = {1, 2}",
        "titleBn": "ধাপ ২: ইনডেক্স ১ (মান ২) ➔ ২ যোগ করে সেটে রাখুন = {1, 2}",
        "descEn": "No duplicate found. Set size = 2 <= K.",
        "descBn": "কোনো দ্বৈত মান নেই। সেট সাইজ = ২ <= K।",
      },
      {
        "step": 3,
        "set": "{1, 2, 3}",
        "val": 3,
        "badge": "📥 ADD TO SET",
        "badgeColor": AppTheme.accentNeonCyan,
        "titleEn": "Step 3: Index 2 (val 3) ➔ Added 3 to Set = {1, 2, 3}",
        "titleBn": "ধাপ ৩: ইনডেক্স ২ (মান ৩) ➔ ৩ যোগ করে সেটে রাখুন = {1, 2, 3}",
        "descEn": "No duplicate found. Set size = 3 <= K.",
        "descBn": "কোনো দ্বৈত মান নেই। সেট সাইজ = ৩ <= K।",
      },
      {
        "step": 4,
        "set": "{1, 2, 3}",
        "val": 1,
        "badge": "🎉 DUPLICATE FOUND",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 4: Index 3 (val 1) ➔ 1 is already in Set {1, 2, 3}! 🎉",
        "titleBn": "ধাপ ৪: ইনডেক্স ৩ (মান ১) ➔ ১ ইতিমধ্যেই সেটে রয়েছে! 🎉",
        "descEn": "Found duplicate '1' at distance |0 - 3| = 3 <= K (3). Return true!",
        "descBn": "দূরত্ব |0 - 3| = 3 <= K (3) এর মধ্যে দ্বৈত '1' পাওয়া গেছে! true রিটার্ন করুন!",
      },
    ];

    final currentStep = stepFlowData[_flowStepIndex.clamp(0, stepFlowData.length - 1)];
    final String setStr = currentStep["set"] as String;
    final int val = currentStep["val"] as int;
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
                _isEnglish ? "1. Step-by-Step Sliding Window Set Flowcard" : "১. স্টেপ-বাই-স্টেপ স্লাইডিং উইন্ডো সেট ফ্লো-কার্ড",
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
                ? "Watch element inspection and set duplicate matching."
                : "উপাদান পরীক্ষা এবং সেট ডুপ্লিকেট ম্যাচিং দেখুন।",
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
                    Text("Inspected Val = $val", style: TextStyle(color: badgeColor, fontWeight: FontWeight.bold, fontSize: 12)),
                    Text("Max Window Set Size K = $_k", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
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
                    "Set = $setStr",
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

  // MODEL 2: Window Set Buffer
  Widget _buildWindowSetBufferModel() {
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
            _isEnglish ? "2. Sliding Window Hash Set Buffer Rule" : "২. স্লাইডিং উইন্ডো হ্যাশ সেট বাফার নীতি",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            _isEnglish
                ? "Maintain hash set size <= K at all times.\nIf set.size() > K, erase nums[i - K] from hash set."
                : "সবসময় হ্যাশ সেটের আকার <= K বজায় রাখুন।\nset.size() > K হলে সেট থেকে পুরোনো উপাদান nums[i - K] মুছে দিন।",
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, height: 1.4),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.accentPink),
            ),
            child: const Text(
              "if (seen.size() > K) seen.erase(nums[i - K]); 🛡️",
              style: TextStyle(fontFamily: 'monospace', fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.accentPink),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  // MODEL 3: Complexity Comparison
  Widget _buildComplexityComparisonModel() {
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
            _isEnglish ? "3. O(N * K) Brute Force vs O(N) Hash Set" : "৩. O(N * K) ব্রুট ফোর্স বনাম O(N) হ্যাশ সেট",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            _isEnglish
                ? "Nested loop checks previous K elements for each index ➔ O(N * K).\nHash Set sliding window achieves O(1) average lookup/insertion ➔ O(N) total."
                : "নেস্টেড লুপ প্রতিটি ঘরে আগের K উপাদান চেক করে ➔ O(N * K)।\nহ্যাশ সেট স্লাইডিং উইন্ডো O(1) গরে কাজ করে ➔ সর্বমোট O(N)।",
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
              "Time Complexity: O(N)\nSpace Complexity: O(min(N, K)) 🎉",
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
                          labelText: _isEnglish ? "Nums (e.g. 1, 2, 3, 1)" : "অ্যাররে (যেমন 1, 2, 3, 1)",
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
                          labelText: _isEnglish ? "K" : "K",
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
                      _buildPresetChip("1, 2, 3, 1", "3"),
                      _buildPresetChip("1, 0, 1, 1", "1"),
                      _buildPresetChip("1, 2, 3, 1, 2, 3", "2"),
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
                  _buildSetCanvas(step),
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildCodeHighlightBox(step.activeLine)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildSetCanvas(step)),
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
    final expectedResult = _checkContainsDuplicate(_nums, _k);

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
                  ? "Step through elements and verify if a duplicate exists within K = $_k distance!"
                  : "উপাদানসমূহ স্টেপ বাই স্টেপ দেখে K = $_k দূরত্বের মধ্যে কোনো দ্বৈত মান আছে কিনা যাচাই করুন!",
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

            // Practice Window Set Display Box
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
                      Text("Inspected Index: $_practiceIndex / ${_nums.length}", style: const TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 12)),
                      Text("Expected Result: ${expectedResult ? 'TRUE' : 'FALSE'}", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Set Buffer: { ${_practiceWindowSet.join(', ')} }",
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.accentNeonCyan,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Step Button
            if (!_practiceSolved)
              Center(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentNeonCyan,
                    foregroundColor: AppTheme.primaryDark,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  ),
                  icon: const Icon(Icons.arrow_forward),
                  label: Text(_isEnglish ? "Next Step (Inspect Index $_practiceIndex)" : "পরবর্তী ইনডেক্স ($_practiceIndex) পরীক্ষা"),
                  onPressed: _handlePracticeNextStep,
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
  Widget _buildPresetChip(String numVal, String kVal) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ActionChip(
        backgroundColor: const Color(0xFF090D16),
        label: Text("[$numVal], K=$kVal", style: const TextStyle(color: AppTheme.accentNeonCyan, fontSize: 11)),
        onPressed: () {
          _numsController.text = numVal;
          _kController.text = kVal;
          _rebuildSteps();
        },
      ),
    );
  }

  Widget _buildCodeHighlightBox(int activeLine) {
    final codeLines = [
      "bool containsNearbyDuplicate(vector<int>& nums, int k) {",
      "    unordered_set<int> seen;",
      "    for (int i = 0; i < nums.size(); i++) {",
      "        if (seen.count(nums[i])) return true;",
      "        seen.insert(nums[i]);",
      "        if (seen.size() > k) seen.erase(nums[i - k]);",
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

  Widget _buildSetCanvas(ContainsDuplicateIIStep step) {
    Color decisionColor = AppTheme.accentPurple;
    String decisionLabel = "INIT";

    if (step.decision == "add_to_set") {
      decisionColor = AppTheme.accentNeonCyan;
      decisionLabel = "📥 ADD TO SET";
    } else if (step.decision == "remove_oldest") {
      decisionColor = AppTheme.accentPink;
      decisionLabel = "🗑️ REMOVE OLDEST";
    } else if (step.decision == "duplicate_found") {
      decisionColor = AppTheme.accentGreen;
      decisionLabel = "🎉 DUPLICATE FOUND";
    } else if (step.decision == "finished_false") {
      decisionColor = AppTheme.accentAmber;
      decisionLabel = "❌ NO DUPLICATE";
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
              Text("Index: [${step.index}] (val = ${step.currentVal})", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13)),
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

          // Window Set Buffer Display Box
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Window Set Size: ${step.windowSet.length} / $_k", style: TextStyle(color: decisionColor, fontWeight: FontWeight.bold, fontSize: 12)),
              Text("K = $_k", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
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
                  "Set Buffer: { ${step.windowSet.join(', ')} }",
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: decisionColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Visual Array Canvas
          const Text("Array Elements & Sliding Focus:", style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_nums.length, (idx) {
                bool isCurrent = idx == step.index;
                bool inWindow = idx <= step.index && idx > step.index - _k;

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: isCurrent
                        ? decisionColor.withOpacity(0.4)
                        : (inWindow ? AppTheme.accentNeonCyan.withOpacity(0.2) : AppTheme.surfaceDark),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isCurrent ? decisionColor : (inWindow ? AppTheme.accentNeonCyan : const Color(0xFF334155)),
                      width: isCurrent ? 2.0 : 1.0,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "${_nums[idx]}",
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isCurrent ? Colors.white : const Color(0xFF64748B),
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
    bool containsNearbyDuplicate(vector<int>& nums, int k) {
        unordered_set<int> seen;
        for (int i = 0; i < nums.size(); i++) {
            if (seen.count(nums[i])) return true;
            seen.insert(nums[i]);
            if (seen.size() > k) seen.erase(nums[i - k]);
        }
        return false;
    }
};""";
    } else if (lang == "Java") {
      code = """
class Solution {
    public boolean containsNearbyDuplicate(int[] nums, int k) {
        Set<Integer> seen = new HashSet<>();
        for (int i = 0; i < nums.length; i++) {
            if (seen.contains(nums[i])) return true;
            seen.add(nums[i]);
            if (seen.size() > k) seen.remove(nums[i - k]);
        }
        return false;
    }
}""";
    } else {
      code = """
class Solution:
    def containsNearbyDuplicate(self, nums: List[int], k: int) -> bool:
        seen = set()
        for i, val in enumerate(nums):
            if val in seen:
                return True
            seen.add(val)
            if len(seen) > k:
                seen.remove(nums[i - k])
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
