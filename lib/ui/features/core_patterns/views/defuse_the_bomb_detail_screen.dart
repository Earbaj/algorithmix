import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class DefuseTheBombStep {
  final int index;
  final int currentVal;
  final int windowLeft;
  final int windowRight;
  final int windowSum;
  final List<int> windowElements;
  final List<int> decryptedCode;
  final String decision; // 'init', 'k_zero', 'build_window', 'decrypt_i', 'slide_window', 'finished'
  final int activeLine;
  final String actionEn;
  final String actionBn;
  final String reasonEn;
  final String reasonBn;

  const DefuseTheBombStep({
    required this.index,
    required this.currentVal,
    required this.windowLeft,
    required this.windowRight,
    required this.windowSum,
    required this.windowElements,
    required this.decryptedCode,
    required this.decision,
    required this.activeLine,
    required this.actionEn,
    required this.actionBn,
    required this.reasonEn,
    required this.reasonBn,
  });
}

class DefuseTheBombDetailScreen extends StatefulWidget {
  const DefuseTheBombDetailScreen({super.key});

  @override
  State<DefuseTheBombDetailScreen> createState() => _DefuseTheBombDetailScreenState();
}

class _DefuseTheBombDetailScreenState extends State<DefuseTheBombDetailScreen>
    with SingleTickerProviderStateMixin {
  bool _isEnglish = true;
  late TabController _tabController;

  // Custom Input State
  final TextEditingController _codeController = TextEditingController(text: "5, 7, 1, 4");
  final TextEditingController _kController = TextEditingController(text: "3");
  List<int> _code = [5, 7, 1, 4];
  int _k = 3;
  List<DefuseTheBombStep> _steps = [];

  // Playback Control
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  // Code Language Selector
  String _selectedCodeLang = "C++";

  // Tab 2 Animation Model Selector (0: Step Flowcard, 1: Circular Wrap Rule, 2: Complexity Calculator)
  int _animationModelIndex = 0;
  int _flowStepIndex = 0;

  // Practice Mode State
  int _practiceIndex = 0;
  List<int> _userDecrypted = [];
  String _userFeedbackEn = "Decrypt the bomb code by calculating circular window sums!";
  String _userFeedbackBn = "বৃত্তাকার উইন্ডোর সাম হিসেব করে বোমা নিষ্ক্রিয় কোড ডিক্রিপ্ট করুন!";
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
    _codeController.dispose();
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
      List<int> parsed = _codeController.text
          .split(',')
          .map((e) => int.parse(e.trim()))
          .toList();
      if (parsed.isEmpty) parsed = [5, 7, 1, 4];
      _code = parsed;

      int kVal = int.parse(_kController.text.trim());
      _k = kVal;
    } catch (_) {
      _code = [5, 7, 1, 4];
      _k = 3;
    }

    _steps = _generateSteps(_code, _k);

    // Reset practice mode
    _resetPractice();
  }

  void _resetPractice() {
    _practiceIndex = 0;
    _userDecrypted = List.filled(_code.length, 0);
    _practiceSolved = false;
    _userFeedbackEn = "Decrypt index $_practiceIndex of code!";
    _userFeedbackBn = "কোডের ইনডেক্স $_practiceIndex ডিক্রিপ্ট করুন!";
  }

  List<DefuseTheBombStep> _generateSteps(List<int> inputCode, int windowK) {
    List<DefuseTheBombStep> steps = [];
    int n = inputCode.length;
    List<int> decrypted = List.filled(n, 0);

    // Step 0: Init
    steps.add(DefuseTheBombStep(
      index: 0,
      currentVal: inputCode[0],
      windowLeft: 0,
      windowRight: 0,
      windowSum: 0,
      windowElements: [],
      decryptedCode: List.from(decrypted),
      decision: "init",
      activeLine: 1,
      actionEn: "Line 1: Initialize Circular Sliding Window for code = [${inputCode.join(', ')}], K = $windowK.",
      actionBn: "লাইন ১: অ্যাররে code = [${inputCode.join(', ')}], K = $windowK এর জন্য সার্কুলার স্লাইডিং উইন্ডো শুরু।",
      reasonEn: "We decrypt each index using the sum of K next (if K>0) or previous (if K<0) elements.",
      reasonBn: "K>0 হলে পরবর্তী K এবং K<0 হলে পূর্ববর্তী K উপাদানের সাম দিয়ে প্রতিটি ঘর ডিক্রিপ্ট করা হবে।",
    ));

    if (windowK == 0) {
      steps.add(DefuseTheBombStep(
        index: 0,
        currentVal: inputCode[0],
        windowLeft: 0,
        windowRight: 0,
        windowSum: 0,
        windowElements: [],
        decryptedCode: List.from(decrypted),
        decision: "k_zero",
        activeLine: 2,
        actionEn: "🏁 Line 2: K = 0! Return all zeros: [${decrypted.join(', ')}].",
        actionBn: "🏁 লাইন ২: K = 0! সব ঘর 0 দিয়ে রিটার্ন করুন: [${decrypted.join(', ')}]।",
        reasonEn: "When K is 0, every element is replaced by 0.",
        reasonBn: "K এর মান 0 হলে প্রতিটি উপাদান 0 দ্বারা প্রতিস্থাপিত হয়।",
      ));
      return steps;
    }

    int l = windowK > 0 ? 1 : n - windowK.abs();
    int r = windowK > 0 ? windowK : n - 1;

    int sum = 0;
    List<int> firstElements = [];
    for (int idx = l; idx <= r; idx++) {
      int realIdx = (idx % n + n) % n;
      sum += inputCode[realIdx];
      firstElements.add(inputCode[realIdx]);
    }

    steps.add(DefuseTheBombStep(
      index: 0,
      currentVal: inputCode[0],
      windowLeft: (l % n + n) % n,
      windowRight: (r % n + n) % n,
      windowSum: sum,
      windowElements: firstElements,
      decryptedCode: List.from(decrypted),
      decision: "build_window",
      activeLine: 5,
      actionEn: "🪟 Line 5: Build initial window [l=${(l%n+n)%n}, r=${(r%n+n)%n}] ➔ Window Sum = $sum.",
      actionBn: "🪟 লাইন ৫: প্রাথমিক উইন্ডো [l=${(l%n+n)%n}, r=${(r%n+n)%n}] তৈরি ➔ Window Sum = $sum।",
      reasonEn: "Sum of initial K elements for circular window.",
      reasonBn: "সার্কুলার উইন্ডোর প্রাথমিক K টি উপাদানের সাম।",
    ));

    for (int i = 0; i < n; i++) {
      decrypted[i] = sum;

      steps.add(DefuseTheBombStep(
        index: i,
        currentVal: inputCode[i],
        windowLeft: (l % n + n) % n,
        windowRight: (r % n + n) % n,
        windowSum: sum,
        windowElements: _getCircularWindowElements(inputCode, l, r, n),
        decryptedCode: List.from(decrypted),
        decision: "decrypt_i",
        activeLine: 8,
        actionEn: "💣 Line 8: Decrypted code[$i] = $sum ➔ Decrypted Array = [${decrypted.join(', ')}].",
        actionBn: "💣 লাইন ৮: ডিক্রিপ্ট কোড[$i] = $sum ➔ ডিক্রিপ্টেড অ্যারে = [${decrypted.join(', ')}]।",
        reasonEn: "Set decrypted[i] = current circular window sum.",
        reasonBn: "decrypted[i] এর মান বর্তমান সার্কুলার উইন্ডো সামের সমান সেট করুন।",
      ));

      if (i < n - 1) {
        int subVal = inputCode[(l % n + n) % n];
        int addVal = inputCode[((r + 1) % n + n) % n];
        sum = sum - subVal + addVal;

        l++;
        r++;

        steps.add(DefuseTheBombStep(
          index: i + 1,
          currentVal: inputCode[i + 1],
          windowLeft: (l % n + n) % n,
          windowRight: (r % n + n) % n,
          windowSum: sum,
          windowElements: _getCircularWindowElements(inputCode, l, r, n),
          decryptedCode: List.from(decrypted),
          decision: "slide_window",
          activeLine: 10,
          actionEn: "➡️ Line 10: Slide window 1 step right (Subtracted $subVal, Added $addVal) ➔ NEW Window Sum = $sum.",
          actionBn: "➡️ লাইন ১০: উইন্ডো ১ ঘর ডানে স্লাইড (বিয়োগ $subVal, যোগ $addVal) ➔ নতুন Window Sum = $sum।",
          reasonEn: "Reuse window sum by subtracting left element and adding next circular right element.",
          reasonBn: "বাম উপাদান বিয়োগ এবং পরবর্তী সার্কুলার ডান উপাদান যোগ করে উইন্ডো সাম আপডেট।",
        ));
      }
    }

    steps.add(DefuseTheBombStep(
      index: n - 1,
      currentVal: inputCode[n - 1],
      windowLeft: (l % n + n) % n,
      windowRight: (r % n + n) % n,
      windowSum: sum,
      windowElements: _getCircularWindowElements(inputCode, l, r, n),
      decryptedCode: List.from(decrypted),
      decision: "finished",
      activeLine: 12,
      actionEn: "🏁 Line 12: BOMB DEFUSED! Final Decrypted Code = [${decrypted.join(', ')}].",
      actionBn: "🏁 লাইন ১২: বোমা নিষ্ক্রিয় সম্পন্ন! চূড়ান্ত ডিক্রিপ্ট কোড = [${decrypted.join(', ')}]।",
      reasonEn: "Successfully decrypted all n numbers using O(N) circular sliding window.",
      reasonBn: "O(N) সার্কুলার স্লাইডিং উইন্ডো ব্যবহার করে সমস্ত n টি সংখ্যা সাফল্যের সাথে ডিক্রিপ্ট হয়েছে।",
    ));

    return steps;
  }

  List<int> _getCircularWindowElements(List<int> inputCode, int l, int r, int n) {
    List<int> res = [];
    for (int idx = l; idx <= r; idx++) {
      int realIdx = (idx % n + n) % n;
      res.add(inputCode[realIdx]);
    }
    return res;
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

  List<int> _solveDefuseTheBomb(List<int> code, int k) {
    int n = code.length;
    List<int> res = List.filled(n, 0);
    if (k == 0) return res;

    int l = k > 0 ? 1 : n - k.abs();
    int r = k > 0 ? k : n - 1;

    int sum = 0;
    for (int idx = l; idx <= r; idx++) {
      sum += code[(idx % n + n) % n];
    }

    for (int i = 0; i < n; i++) {
      res[i] = sum;
      sum -= code[(l % n + n) % n];
      l++;
      r++;
      sum += code[(r % n + n) % n];
    }
    return res;
  }

  void _handlePracticeDecryptStep() {
    if (_practiceSolved || _practiceIndex >= _code.length) return;
    List<int> expectedDecrypted = _solveDefuseTheBomb(_code, _k);

    setState(() {
      _userDecrypted[_practiceIndex] = expectedDecrypted[_practiceIndex];
      _practiceIndex++;

      if (_practiceIndex == _code.length) {
        _practiceSolved = true;
        _userFeedbackEn = "🎉 BOMB DEFUSED! All numbers decrypted: [${_userDecrypted.join(', ')}]!";
        _userFeedbackBn = "🎉 বোমা নিষ্ক্রিয় সম্পন্ন! সমস্ত সংখ্যা ডিক্রিপ্ট হয়েছে: [${_userDecrypted.join(', ')}]!";
      } else {
        _userFeedbackEn = "Decrypted index ${_practiceIndex - 1} = ${expectedDecrypted[_practiceIndex - 1]}. Next: Decrypt index $_practiceIndex.";
        _userFeedbackBn = "ইনডেক্স ${_practiceIndex - 1} = ${expectedDecrypted[_practiceIndex - 1]} ডিক্রিপ্ট হয়েছে। পরের: ইনডেক্স $_practiceIndex ডিক্রিপ্ট করুন।";
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
          '1652. Defuse the Bomb',
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
                    "1652. Defuse the Bomb",
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
              children: ["Amazon", "Google"].map((company) {
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
                        ? "You have a bomb to defuse! You are given a circular array code of length n and a key k. Decrypt the code by replacing every number:\n- If k > 0, replace code[i] with sum of next k numbers.\n- If k < 0, replace code[i] with sum of previous |k| numbers.\n- If k == 0, replace code[i] with 0."
                        : "বোমা নিষ্ক্রিয় করতে circular অ্যাররে code এবং কী k দেওয়া আছে। k এর উপর ভিত্তি করে প্রতিটি সংখ্যা ডিক্রিপ্ট করুন:\n- k > 0 হলে পরবর্তী k টি সংখ্যার যোগফল বসান।\n- k < 0 হলে পূর্ববর্তী |k| টি সংখ্যার যোগফল বসান।\n- k == 0 হলে 0 বসান।",
                    style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Examples
            Text(_isEnglish ? "Examples" : "উদাহরণসমূহ", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            _buildExampleCard("Example 1", "code = [5,7,1,4], k = 3", "Output: [12,10,16,13]"),
            _buildExampleCard("Example 2", "code = [1,2,3,4], k = 0", "Output: [0,0,0,0]"),
            _buildExampleCard("Example 3", "code = [2,4,9,3], k = -2", "Output: [12,5,6,13]"),
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
                        _isEnglish ? "Key Intuition (Circular Sliding Window)" : "মূল আইডিয়া (বৃত্তাকার স্লাইডিং উইন্ডো)",
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isEnglish
                        ? "1. Determine initial window bounds [l, r] based on sign of K.\n2. Compute sum of first window taking modulo % N for wrap-around.\n3. Slide window right by 1 position (windowSum += code[(r+1)%n] - code[l%n]) in O(N) linear time."
                        : "১. K এর চিহ্নের উপর ভিত্তি করে প্রাথমিক উইন্ডো সীমা [l, r] নির্ধারণ করুন।\n২. বৃত্তাকার wrap-around এর জন্য % N মডিউলো ব্যবহার করে উইন্ডো সাম হিসাব করুন।\n৩. O(N) লিনিয়ার সময়ে উইন্ডো ১ ঘর ডানে স্লাইড করুন।",
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
              _isEnglish ? "Defuse the Bomb Visual Models" : "বোমা নিষ্ক্রিয়করণ ভিজ্যুয়াল মডেলসমূহ (কোডহীন গাইড)",
              style: TextStyle(fontSize: Responsive.sp(context, 18), fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 6),
            Text(
              _isEnglish
                  ? "Explore 3 interactive models for code = [5, 7, 1, 4], K = 3."
                  : "code = [5, 7, 1, 4], K = 3 এর জন্য ৩টি ইন্টারঅ্যাক্টিভ ভিজ্যুয়াল মডেল পর্যবেক্ষণ করুন।",
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 16),

            // Model Switcher Segmented Control
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildAnimationModelChip(0, _isEnglish ? "1. 🪜 Step Flowcard" : "১. 🪜 স্টেপ-বাই-স্টেপ ফ্লো-কার্ড"),
                  _buildAnimationModelChip(1, _isEnglish ? "2. ⭕ Circular Wrap Rule" : "২. ⭕ সার্কুলার র্যাপ নীতি"),
                  _buildAnimationModelChip(2, _isEnglish ? "3. 📊 Complexity Calculator" : "৩. 📊 টাইমিং ক্যালকুলেটর"),
                ],
              ),
            ),
            const SizedBox(height: 20),

            if (_animationModelIndex == 0) _buildStepFlowcardModel(),
            if (_animationModelIndex == 1) _buildCircularWrapRuleModel(),
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
        "window": "[7, 1, 4]",
        "sum": 12,
        "result": "[12, 0, 0, 0]",
        "badge": "💣 DECRYPT INDEX 0",
        "badgeColor": AppTheme.accentNeonCyan,
        "titleEn": "Step 1: Decrypt Index 0 (val 5) ➔ Window [7, 1, 4] = 12",
        "titleBn": "ধাপ ১: ডিক্রিপ্ট ইনডেক্স ০ (মান ৫) ➔ উইন্ডো [7, 1, 4] = 12",
        "descEn": "Sum of next 3 elements: 7 + 1 + 4 = 12. result[0] = 12.",
        "descBn": "পরবর্তী ৩ উপাদানের যোগফল: 7 + 1 + 4 = 12। result[0] = 12।",
      },
      {
        "step": 2,
        "window": "[1, 4, 5]",
        "sum": 10,
        "result": "[12, 10, 0, 0]",
        "badge": "💣 DECRYPT INDEX 1",
        "badgeColor": AppTheme.accentNeonCyan,
        "titleEn": "Step 2: Slide Right (+5, -7) ➔ Decrypt Index 1 (val 7) = 10",
        "titleBn": "ধাপ ২: ডানে স্লাইড (+5, -7) ➔ ডিক্রিপ্ট ইনডেক্স ১ (মান ৭) = 10",
        "descEn": "Sum of next 3 elements (wrapping): 1 + 4 + 5 = 10. result[1] = 10.",
        "descBn": "পরবর্তী ৩ উপাদানের যোগফল: 1 + 4 + 5 = 10। result[1] = 10।",
      },
      {
        "step": 3,
        "window": "[4, 5, 7]",
        "sum": 16,
        "result": "[12, 10, 16, 0]",
        "badge": "💣 DECRYPT INDEX 2",
        "badgeColor": AppTheme.accentNeonCyan,
        "titleEn": "Step 3: Slide Right (+7, -1) ➔ Decrypt Index 2 (val 1) = 16",
        "titleBn": "ধাপ ৩: ডানে স্লাইড (+7, -1) ➔ ডিক্রিপ্ট ইনডেক্স ২ (মান ১) = 16",
        "descEn": "Sum of next 3 elements (wrapping): 4 + 5 + 7 = 16. result[2] = 16.",
        "descBn": "পরবর্তী ৩ উপাদানের যোগফল: 4 + 5 + 7 = 16। result[2] = 16।",
      },
      {
        "step": 4,
        "window": "[5, 7, 1]",
        "sum": 13,
        "result": "[12, 10, 16, 13]",
        "badge": "🏁 BOMB DEFUSED",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 4: Slide Right (+1, -4) ➔ Decrypt Index 3 (val 4) = 13",
        "titleBn": "ধাপ ৪: ডানে স্লাইড (+1, -4) ➔ ডিক্রিপ্ট ইনডেক্স ৩ (মান ৪) = 13",
        "descEn": "Sum of next 3 elements: 5 + 7 + 1 = 13. Final Result: [12, 10, 16, 13]! 🎉",
        "descBn": "পরবর্তী ৩ উপাদানের যোগফল: 5 + 7 + 1 = 13। চূড়ান্ত ফলাফল: [12, 10, 16, 13]! 🎉",
      },
    ];

    final currentStep = stepFlowData[_flowStepIndex.clamp(0, stepFlowData.length - 1)];
    final String window = currentStep["window"] as String;
    final int sum = currentStep["sum"] as int;
    final String resultStr = currentStep["result"] as String;
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
                _isEnglish ? "1. Step-by-Step Circular Window Flowcard" : "১. স্টেপ-বাই-স্টেপ সার্কুলার উইন্ডো ফ্লো-কার্ড",
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
                ? "Watch circular sliding window updates and decryption array filling."
                : "সার্কুলার স্লাইডিং উইন্ডো আপডেট এবং ডিক্রিপশন অ্যারে পূরণ দেখুন।",
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
                    Text("Window Sum = $sum", style: TextStyle(color: badgeColor, fontWeight: FontWeight.bold, fontSize: 12)),
                    Text("Window: $window", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
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
                    "Decrypted = $resultStr",
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

  // MODEL 2: Circular Wrap Rule
  Widget _buildCircularWrapRuleModel() {
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
            _isEnglish ? "2. Circular Modulo % N Wrap-Around Formula" : "২. সার্কুলার মডিউলো % N র্যাপ-অ্যারাউন্ড সূত্র",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            _isEnglish
                ? "To access circular indices seamlessly:\nrealIndex = (idx % N + N) % N"
                : "বৃত্তাকার ইনডেক্স সহজে অ্যাক্সেস করতে:\nrealIndex = (idx % N + N) % N",
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, height: 1.4),
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
              "sum += code[(r + 1) % n] - code[l % n]; ⭕",
              style: TextStyle(fontFamily: 'monospace', fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.accentAmber),
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
            _isEnglish ? "3. O(N * |K|) Brute Force vs O(N) Circular Sliding Window" : "৩. O(N * |K|) ব্রুট ফোর্স বনাম O(N) সার্কুলার স্লাইডিং উইন্ডো",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            _isEnglish
                ? "Nested loop computes K elements for each index ➔ O(N * |K|).\nSliding Window slides circular pointers in O(1) per step ➔ O(N) total."
                : "নেস্টেড লুপ প্রতিটি ইনডেক্সে K টি এলিমেন্ট যোগ করে ➔ O(N * |K|)।\nস্লাইডিং উইন্ডো O(1) সময়ে পয়েন্টার সরিয়ে সাম আপডেট করে ➔ সর্বমোট O(N)।",
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
              "Time Complexity: O(N)\nSpace Complexity: O(N) for output 💣",
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
                        controller: _codeController,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          labelText: _isEnglish ? "Code (e.g. 5, 7, 1, 4)" : "কোড (যেমন 5, 7, 1, 4)",
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
                      _buildPresetChip("5, 7, 1, 4", "3"),
                      _buildPresetChip("1, 2, 3, 4", "0"),
                      _buildPresetChip("2, 4, 9, 3", "-2"),
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
                  _buildCircularCanvas(step),
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildCodeHighlightBox(step.activeLine)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildCircularCanvas(step)),
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
    final expectedDecrypted = _solveDefuseTheBomb(_code, _k);

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
                  ? "Decrypt the bomb array step-by-step for K = $_k!"
                  : "K = $_k এর জন্য বোমা নিস্ক্রিয়করণ অ্যারে স্টেপ বাই স্টেপ ডিক্রিপ্ট করুন!",
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

            // Practice Progress Box
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
                      Text("Decrypting Index: $_practiceIndex / ${_code.length}", style: const TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 12)),
                      Text("Target Output: [${expectedDecrypted.join(', ')}]", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Decrypted Code: [ ${_userDecrypted.join(', ')} ]",
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.accentGreen,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Decrypt Step Button
            if (!_practiceSolved)
              Center(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentNeonCyan,
                    foregroundColor: AppTheme.primaryDark,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  ),
                  icon: const Icon(Icons.flash_on),
                  label: Text(_isEnglish ? "Decrypt Index $_practiceIndex" : "ইনডেক্স $_practiceIndex ডিক্রিপ্ট করুন"),
                  onPressed: _handlePracticeDecryptStep,
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
          _codeController.text = numVal;
          _kController.text = kVal;
          _rebuildSteps();
        },
      ),
    );
  }

  Widget _buildCodeHighlightBox(int activeLine) {
    final codeLines = [
      "vector<int> decrypt(vector<int>& code, int k) {",
      "    int n = code.size();",
      "    vector<int> res(n, 0);",
      "    if (k == 0) return res;",
      "    int l = k > 0 ? 1 : n - abs(k), r = k > 0 ? k : n - 1;",
      "    int windowSum = 0;",
      "    for (int i = l; i <= r; i++) windowSum += code[i % n];",
      "    for (int i = 0; i < n; i++) {",
      "        res[i] = windowSum;",
      "        windowSum += code[(r + 1) % n] - code[l % n];",
      "        l++; r++;",
      "    }",
      "    return res;",
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

  Widget _buildCircularCanvas(DefuseTheBombStep step) {
    Color decisionColor = AppTheme.accentPurple;
    String decisionLabel = "INIT";

    if (step.decision == "build_window") {
      decisionColor = AppTheme.accentNeonCyan;
      decisionLabel = "🪟 BUILD WINDOW";
    } else if (step.decision == "decrypt_i") {
      decisionColor = AppTheme.accentGreen;
      decisionLabel = "💣 DECRYPT INDEX";
    } else if (step.decision == "slide_window") {
      decisionColor = AppTheme.accentAmber;
      decisionLabel = "➡️ SLIDE CIRCULAR";
    } else if (step.decision == "finished") {
      decisionColor = AppTheme.accentGreen;
      decisionLabel = "🏁 BOMB DEFUSED";
    } else if (step.decision == "k_zero") {
      decisionColor = AppTheme.textMuted;
      decisionLabel = "🏁 K = 0 ZEROES";
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
              Text("Decrypting Index: [${step.index}]", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13)),
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

          // Window Sum & Decrypted Array Box
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Window Sum = ${step.windowSum}", style: TextStyle(color: decisionColor, fontWeight: FontWeight.bold, fontSize: 12)),
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
                  "Decrypted = [ ${step.decryptedCode.join(', ')} ]",
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
                  "Active Circular Window: [ ${step.windowElements.join(', ')} ]",
                  style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Visual Array Canvas
          const Text("Circular Array Elements Canvas:", style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_code.length, (idx) {
                bool isTarget = idx == step.index;
                bool inWindow = step.windowElements.contains(_code[idx]);

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: isTarget
                        ? decisionColor.withOpacity(0.4)
                        : (inWindow ? AppTheme.accentNeonCyan.withOpacity(0.2) : AppTheme.surfaceDark),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isTarget ? decisionColor : (inWindow ? AppTheme.accentNeonCyan : const Color(0xFF334155)),
                      width: isTarget ? 2.0 : 1.0,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "${_code[idx]}",
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isTarget ? Colors.white : const Color(0xFF64748B),
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
    vector<int> decrypt(vector<int>& code, int k) {
        int n = code.size();
        vector<int> res(n, 0);
        if (k == 0) return res;
        int l = k > 0 ? 1 : n - abs(k);
        int r = k > 0 ? k : n - 1;
        int windowSum = 0;
        for (int i = l; i <= r; i++) {
            windowSum += code[i % n];
        }
        for (int i = 0; i < n; i++) {
            res[i] = windowSum;
            windowSum += code[(r + 1) % n] - code[l % n];
            l++; r++;
        }
        return res;
    }
};""";
    } else if (lang == "Java") {
      code = """
class Solution {
    public int[] decrypt(int[] code, int k) {
        int n = code.length;
        int[] res = new int[n];
        if (k == 0) return res;
        int l = k > 0 ? 1 : n - Math.abs(k);
        int r = k > 0 ? k : n - 1;
        int windowSum = 0;
        for (int i = l; i <= r; i++) {
            windowSum += code[i % n];
        }
        for (int i = 0; i < n; i++) {
            res[i] = windowSum;
            windowSum += code[(r + 1) % n] - code[l % n];
            l++; r++;
        }
        return res;
    }
}""";
    } else {
      code = """
class Solution:
    def decrypt(self, code: List[int], k: int) -> List[int]:
        n = len(code)
        res = [0] * n
        if k == 0:
            return res
        l = 1 if k > 0 else n - abs(k)
        r = k if k > 0 else n - 1
        window_sum = sum(code[i % n] for i in range(l, r + 1))

        for i in range(n):
            res[i] = window_sum
            window_sum += code[(r + 1) % n] - code[l % n]
            l += 1
            r += 1
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
