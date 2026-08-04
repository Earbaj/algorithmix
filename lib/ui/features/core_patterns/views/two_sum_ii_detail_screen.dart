import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import 'package:algorithmix/ui/features/core_patterns/widgets/two_sum_code_free_visualizer.dart';

class TwoSumIIStep {
  final int left;
  final int right;
  final int sum;
  final int activeLine;
  final String actionEn;
  final String actionBn;
  final String reasonEn;
  final String reasonBn;
  final bool isMatch;

  const TwoSumIIStep({
    required this.left,
    required this.right,
    required this.sum,
    required this.activeLine,
    required this.actionEn,
    required this.actionBn,
    required this.reasonEn,
    required this.reasonBn,
    this.isMatch = false,
  });
}

class TwoSumIIDetailScreen extends StatefulWidget {
  const TwoSumIIDetailScreen({super.key});

  @override
  State<TwoSumIIDetailScreen> createState() => _TwoSumIIDetailScreenState();
}

class _TwoSumIIDetailScreenState extends State<TwoSumIIDetailScreen>
    with SingleTickerProviderStateMixin {
  bool _isEnglish = true;
  late TabController _tabController;

  // Custom Input State
  final TextEditingController _numbersController =
      TextEditingController(text: "2, 7, 11, 15");
  final TextEditingController _targetController =
      TextEditingController(text: "9");

  List<int> _currentArray = [2, 7, 11, 15];
  int _currentTarget = 9;
  List<TwoSumIIStep> _steps = [];

  // Playback Control
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  // Practice Mode / Answer reveal state
  bool _showAnswer = false;
  int _userLeft = 0;
  int _userRight = 3;
  String _userFeedbackEn = "Select your move to find target sum!";
  String _userFeedbackBn = "টার্গেট সাম পেতে আপনার পরবর্তী মুভ সিলেক্ট করুন!";
  bool _userSolved = false;
  String _selectedCodeLang = "C++";

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
    _numbersController.dispose();
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

    // Parse array
    try {
      List<int> parsed = _numbersController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .map((e) => int.parse(e))
          .toList();
      if (parsed.length < 2) {
        parsed = [2, 7, 11, 15];
      }
      parsed.sort(); // Two sum II requires sorted array
      _currentArray = parsed;
    } catch (_) {
      _currentArray = [2, 7, 11, 15];
    }

    // Parse target
    try {
      _currentTarget = int.parse(_targetController.text.trim());
    } catch (_) {
      _currentTarget = 9;
    }

    _userLeft = 0;
    _userRight = _currentArray.length - 1;
    _userSolved = false;
    _userFeedbackEn = "Start moving left/right pointers to hit target $_currentTarget!";
    _userFeedbackBn = "টার্গেট $_currentTarget মিলাতে left/right পয়েন্টার সরানো শুরু করুন!";

    // Generate dynamic simulation steps line-by-line
    _steps = _generateSteps(_currentArray, _currentTarget);
    setState(() {});
  }

  /// Granular Line-by-Line Dynamic Step Generation
  List<TwoSumIIStep> _generateSteps(List<int> arr, int target) {
    List<TwoSumIIStep> steps = [];
    int l = 0;
    int r = arr.length - 1;

    // Line 2: Initialize left pointer
    steps.add(TwoSumIIStep(
      left: l,
      right: r,
      sum: arr[l] + arr[r],
      activeLine: 2,
      actionEn: "Line 2: Initialize left pointer → left = 0 (value: ${arr[l]})",
      actionBn: "লাইন ২: left পয়েন্টার সূচনা → left = 0 (মান: ${arr[l]})",
      reasonEn: "The left pointer starts at the beginning of the sorted array (index 0).",
      reasonBn: "সর্টেড অ্যারের একদম শুরুতে (ইন্ডেক্স 0) left পয়েন্টার বসানো হলো।",
    ));

    // Line 3: Initialize right pointer on separate line for beginners
    steps.add(TwoSumIIStep(
      left: l,
      right: r,
      sum: arr[l] + arr[r],
      activeLine: 3,
      actionEn: "Line 3: Initialize right pointer → right = ${arr.length - 1} (value: ${arr[r]})",
      actionBn: "লাইন ৩: right পয়েন্টার সূচনা → right = ${arr.length - 1} (মান: ${arr[r]})",
      reasonEn: "The right pointer starts at the last element (index ${arr.length - 1}). Target = $target.",
      reasonBn: "সর্টেড অ্যারের শেষ উপাদানে (ইন্ডেক্স ${arr.length - 1}) right পয়েন্টার বসানো হলো। Target = $target।",
    ));

    while (l < r) {
      int sum = arr[l] + arr[r];

      // Line 4: Loop condition check
      steps.add(TwoSumIIStep(
        left: l,
        right: r,
        sum: sum,
        activeLine: 4,
        actionEn: "Line 4: Check condition while (left < right) → ($l < $r) is TRUE",
        actionBn: "লাইন ৪: লুপ শর্ত চেক while (left < right) → ($l < $r) সত্য",
        reasonEn: "Pointers haven't crossed yet. Proceed inside the loop.",
        reasonBn: "পয়েন্টারদ্বয় এখনো পরস্পরকে অতিক্রম করেনি। লুপের ভেতর প্রবেশ করুন।",
      ));

      // Line 5: Calculate sum
      steps.add(TwoSumIIStep(
        left: l,
        right: r,
        sum: sum,
        activeLine: 5,
        actionEn: "Line 5: Calculate sum = numbers[left] + numbers[right] = ${arr[l]} + ${arr[r]} = $sum",
        actionBn: "লাইন ৫: যোগফল নির্ণয় sum = numbers[left] + numbers[right] = ${arr[l]} + ${arr[r]} = $sum",
        reasonEn: "Current pair sum is $sum. Compare $sum with target $target.",
        reasonBn: "বর্তমান জোড়ার যোগফল $sum। টার্গেট $target এর সাথে তুলনা করা হচ্ছে।",
      ));

      // Line 6: Check equality
      steps.add(TwoSumIIStep(
        left: l,
        right: r,
        sum: sum,
        activeLine: 6,
        actionEn: "Line 6: Check if (sum == target) → ($sum == $target) is ${sum == target ? 'TRUE 🎉' : 'FALSE'}",
        actionBn: "লাইন ৬: সমতা চেক if (sum == target) → ($sum == $target) ${sum == target ? 'সত্য 🎉' : 'মিথ্যা'}",
        reasonEn: sum == target
            ? "Sum matches target! Solution found."
            : "Sum does not match target. Proceed to else-if branches.",
        reasonBn: sum == target
            ? "যোগফল টার্গেটের সমান! কাঙ্ক্ষিত সমাধান প্রাপ্ত।"
            : "যোগফল টার্গেটের সমান নয়। পরবর্তী শর্তের দিকে যান।",
      ));

      if (sum == target) {
        // Line 7: Return result
        steps.add(TwoSumIIStep(
          left: l,
          right: r,
          sum: sum,
          activeLine: 7,
          actionEn: "Line 7: 🎉 TARGET MATCHED! Return 1-based indices: {${l + 1}, ${r + 1}}",
          actionBn: "লাইন ৭: 🎉 টার্গেট ম্যাচ! ১-ভিত্তিক ইনডেক্স রিটার্ন করুন: {${l + 1}, ${r + 1}}",
          reasonEn: "Numbers at indices ${l + 1} and ${r + 1} (${arr[l]} + ${arr[r]}) sum up to $target!",
          reasonBn: "ইনডেক্স ${l + 1} এবং ${r + 1} এর মানদ্বয় (${arr[l]} + ${arr[r]}) যোগ করলে $target পাওয়া যায়!",
          isMatch: true,
        ));
        break;
      } else if (sum < target) {
        // Line 8: Else if condition sum < target
        steps.add(TwoSumIIStep(
          left: l,
          right: r,
          sum: sum,
          activeLine: 8,
          actionEn: "Line 8: Check else if (sum < target) → ($sum < $target) is TRUE",
          actionBn: "লাইন ৮: চেক else if (sum < target) → ($sum < $target) সত্য",
          reasonEn: "Sum ($sum) is smaller than target ($target). We need a larger sum.",
          reasonBn: "যোগফল ($sum) টার্গেট ($target) এর চেয়ে ছোট। বড় যোগফল পেতে হবে।",
        ));

        // Line 9: Execute left++
        l++;
        steps.add(TwoSumIIStep(
          left: l,
          right: r,
          sum: arr[l] + arr[r],
          activeLine: 9,
          actionEn: "Line 9: Execute left++ → left is now index $l (val: ${arr[l]})",
          actionBn: "লাইন ৯: left++ সম্পাদন → left এখন ইনডেক্স $l (মান: ${arr[l]})",
          reasonEn: "Since array is sorted, incrementing left moves to a larger element to increase sum.",
          reasonBn: "যেহেতু অ্যারে সর্টেড, left বাড়ালে বড় উপাদান পাওয়া যাবে এবং যোগফল বাড়বে।",
        ));
      } else {
        // Line 8: Else if condition sum < target (FALSE)
        steps.add(TwoSumIIStep(
          left: l,
          right: r,
          sum: sum,
          activeLine: 8,
          actionEn: "Line 8: Check else if (sum < target) → ($sum < $target) is FALSE",
          actionBn: "লাইন ৮: চেক else if (sum < target) → ($sum < $target) মিথ্যা",
          reasonEn: "Sum ($sum) is greater than target ($target). Proceed to else block.",
          reasonBn: "যোগফল ($sum) টার্গেট ($target) এর চেয়ে বড়। else ব্লকে চলে যান।",
        ));

        // Line 10: Else branch
        steps.add(TwoSumIIStep(
          left: l,
          right: r,
          sum: sum,
          activeLine: 10,
          actionEn: "Line 10: Enter else block",
          actionBn: "লাইন ১০: else ব্লকে প্রবেশ করুন",
          reasonEn: "Sum is larger than target. Decrement right pointer to reduce sum.",
          reasonBn: "যোগফল টার্গেটের চেয়ে বড়। যোগফল কমাতে right পয়েন্টার কমান।",
        ));

        // Line 11: Execute right--
        r--;
        steps.add(TwoSumIIStep(
          left: l,
          right: r,
          sum: arr[l] + arr[r],
          activeLine: 11,
          actionEn: "Line 11: Execute right-- → right is now index $r (val: ${arr[r]})",
          actionBn: "লাইন ১১: right-- সম্পাদন → right এখন ইনডেক্স $r (মান: ${arr[r]})",
          reasonEn: "Since array is sorted, decrementing right moves to a smaller element to decrease sum.",
          reasonBn: "যেহেতু অ্যারে সর্টেড, right কমালে ছোট উপাদান পাওয়া যাবে এবং যোগফল কমবে।",
        ));
      }
    }

    if (steps.isEmpty || !steps.last.isMatch) {
      steps.add(TwoSumIIStep(
        left: l,
        right: r,
        sum: 0,
        activeLine: 14,
        actionEn: "Line 14: Return {} → ❌ No pair sums up to $target",
        actionBn: "লাইন ১৪: Return {} → ❌ কোনো জোড়া মিলিয়ে $target পাওয়া যায়নি",
        reasonEn: "Pointers met/crossed without finding target.",
        reasonBn: "পয়েন্টারদ্বয় পরস্পরকে অতিক্রম করেছে কিন্তু কোনো সমাধান পাওয়া যায়নি।",
      ));
    }

    return steps;
  }

  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;
    });

    if (_isPlaying) {
      _timer = Timer.periodic(const Duration(milliseconds: 1500), (timer) {
        if (_currentStepIndex < _steps.length - 1) {
          setState(() {
            _currentStepIndex++;
          });
        } else {
          _timer?.cancel();
          setState(() {
            _isPlaying = false;
          });
        }
      });
    } else {
      _timer?.cancel();
    }
  }

  // Preset Handlers
  void _loadPreset(List<int> arr, int target) {
    _numbersController.text = arr.join(', ');
    _targetController.text = target.toString();
    _rebuildSteps();
  }

  // Interactive user play step
  void _handleUserMove(String action) {
    if (_userSolved) return;
    int currSum = _currentArray[_userLeft] + _currentArray[_userRight];

    setState(() {
      if (currSum == _currentTarget) {
        _userSolved = true;
        _userFeedbackEn = "🎉 Perfect! You found the solution indices: [${_userLeft + 1}, ${_userRight + 1}]!";
        _userFeedbackBn = "🎉 দারুণ! আপনি সঠিক ইনডেক্স পেয়ে গেছেন: [${_userLeft + 1}, ${_userRight + 1}]!";
        return;
      }

      if (action == "left_inc") {
        if (currSum < _currentTarget) {
          _userLeft++;
          _userFeedbackEn = "✅ Correct choice! Sum was too small ($currSum < $_currentTarget), left++ increases sum.";
          _userFeedbackBn = "✅ সঠিক সিদ্ধান্ত! সাম ছোট ছিল ($currSum < $_currentTarget), left++ যোগফল বাড়াবে।";
        } else {
          _userLeft++;
          _userFeedbackEn = "⚠️ Careful! Sum was already too big ($currSum > $_currentTarget). Decrementing right was optimal.";
          _userFeedbackBn = "⚠️ সতর্ক থাকুন! সাম ইতিমধ্যেই বড় ছিল ($currSum > $_currentTarget)। right-- কমানো উচিৎ ছিল।";
        }
      } else if (action == "right_dec") {
        if (currSum > _currentTarget) {
          _userRight--;
          _userFeedbackEn = "✅ Correct choice! Sum was too large ($currSum > $_currentTarget), right-- decreases sum.";
          _userFeedbackBn = "✅ সঠিক সিদ্ধান্ত! সাম বড় ছিল ($currSum > $_currentTarget), right-- যোগফল কমাবে।";
        } else {
          _userRight--;
          _userFeedbackEn = "⚠️ Careful! Sum was too small ($currSum < $_currentTarget). Incrementing left was optimal.";
          _userFeedbackBn = "⚠️ সতর্ক থাকুন! সাম ছোট ছিল ($currSum < $_currentTarget)। left++ বাড়ানো উচিৎ ছিল।";
        }
      }

      int newSum = _currentArray[_userLeft] + _currentArray[_userRight];
      if (newSum == _currentTarget) {
        _userSolved = true;
        _userFeedbackEn = "🎉 Congratulations! Target $_currentTarget matched at 1-based indices [${_userLeft + 1}, ${_userRight + 1}]!";
        _userFeedbackBn = "🎉 অভিনন্দন! টার্গেট $_currentTarget মিলে গেছে ১-ভিত্তিক ইনডেক্স [${_userLeft + 1}, ${_userRight + 1}] এ!";
      } else if (_userLeft >= _userRight) {
        _userFeedbackEn = "❌ Pointers crossed! Reset or try another test case.";
        _userFeedbackBn = "❌ পয়েন্টার ক্রস করেছে! রিসেট করুন।";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final hPadding = Responsive.horizontalPadding(context);

    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      appBar: AppBar(
        title: Text(
          '167. Two Sum II (Sorted Array)',
          style: TextStyle(fontSize: Responsive.sp(context, 18), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          // EN / BN Language Switcher
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
                setState(() {
                  _isEnglish = !_isEnglish;
                });
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
          labelStyle: TextStyle(fontSize: Responsive.sp(context, 14), fontWeight: FontWeight.bold),
          unselectedLabelStyle: TextStyle(fontSize: Responsive.sp(context, 13)),
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
          _buildProblemDescriptionTab(hPadding),
          _buildCodeFreeVisualizerTab(hPadding),
          _buildVisualizerTab(hPadding),
          _buildPracticeAndAnswerTab(hPadding),
        ],
      ),
    );
  }

  // TAB 2: Code-Free Intuitive Visualizer (Zero Code)
  Widget _buildCodeFreeVisualizerTab(double hPadding) {
    return ResponsiveCenter(
      maxWidth: 1280.0,
      padding: EdgeInsets.all(hPadding),
      child: TwoSumCodeFreeVisualizer(isEnglish: _isEnglish),
    );
  }


  // TAB 1: Problem Description & Key Intuition
  Widget _buildProblemDescriptionTab(double hPadding) {
    return ResponsiveCenter(
      maxWidth: 1280.0, // Expanded width
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Badges Header
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.accentGreen.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.accentGreen),
                  ),
                  child: Text(
                    '🟢 Easy',
                    style: TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: Responsive.sp(context, 12)),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.accentPurple.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.accentPurple),
                  ),
                  child: Text(
                    'LeetCode #167',
                    style: TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: Responsive.sp(context, 12)),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.accentPink.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.accentPink),
                  ),
                  child: Text(
                    '⭐ FAANG Classic',
                    style: TextStyle(color: AppTheme.accentPink, fontWeight: FontWeight.bold, fontSize: Responsive.sp(context, 12)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Title
            Text(
              _isEnglish
                  ? 'Two Sum II - Input Array Is Sorted'
                  : 'টু সাম ২ - ইনপুট অ্যারে সর্টেড (Two Sum II)',
              style: TextStyle(
                fontSize: Responsive.sp(context, 22),
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),

            // Statement Box
            Container(
              padding: EdgeInsets.all(Responsive.sp(context, 18)),
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isEnglish
                        ? 'Problem Statement'
                        : 'সমস্যার বিবরণ',
                    style: TextStyle(
                      fontSize: Responsive.sp(context, 16),
                      fontWeight: FontWeight.bold,
                      color: AppTheme.accentNeonCyan,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _isEnglish
                        ? 'Given a 1-indexed array of integers "numbers" that is already sorted in non-decreasing order, find two numbers such that they add up to a specific "target" number.\n\nReturn the indices of the two numbers, 1-indexed [index1, index2], where 1 <= index1 < index2 <= numbers.length.\n\nConstraint: You must write an algorithm that uses only O(1) extra space.'
                        : 'একটি ১-ভিত্তিক ইনটিজার অ্যারে "numbers" দেওয়া আছে যা আগে থেকেই ছোট থেকে বড় (non-decreasing order) সর্ট করা আছে। এমন দুটি সংখ্যা খুঁজুন যাদের যোগফল নির্দিষ্ট "target" নম্বরের সমান।\n\nসংখ্যা দুটির ১-ভিত্তিক ইনডেক্স [index1, index2] রিটার্ন করুন, যেখানে 1 <= index1 < index2 <= numbers.length।\n\nশর্ত: আপনাকে অবশ্যই O(1) অতিরিক্ত স্পেস কমপ্লেক্সিটিতে অ্যালগরিদমটি লিখতে হবে।',
                    style: TextStyle(
                      fontSize: Responsive.sp(context, 14),
                      color: AppTheme.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Examples
            Text(
              _isEnglish ? '📌 Example Cases' : '📌 উদাহরণসমূহ',
              style: TextStyle(
                fontSize: Responsive.sp(context, 18),
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            _buildExampleCard(
              "Example 1",
              "numbers = [2, 7, 11, 15], target = 9",
              "Output: [1, 2]",
              _isEnglish
                  ? "Explanation: 2 + 7 = 9. Therefore index1 = 1, index2 = 2. We return [1, 2]."
                  : "ব্যাখ্যা: ২ + ৭ = ৯। তাই index1 = ১, index2 = ২। আউটপুট [১, ২]।",
            ),
            _buildExampleCard(
              "Example 2",
              "numbers = [2, 3, 4], target = 6",
              "Output: [1, 3]",
              _isEnglish
                  ? "Explanation: 2 + 4 = 6. Therefore index1 = 1, index2 = 3. We return [1, 3]."
                  : "ব্যাখ্যা: ২ + ৪ = ৬। তাই index1 = ১, index2 = ৩। আউটপুট [১, ৩]।",
            ),
            _buildExampleCard(
              "Example 3",
              "numbers = [-1, 0], target = -1",
              "Output: [1, 2]",
              _isEnglish
                  ? "Explanation: -1 + 0 = -1. Therefore index1 = 1, index2 = 2."
                  : "ব্যাখ্যা: -১ + ০ = -১। তাই index1 = ১, index2 = ২।",
            ),
            const SizedBox(height: 20),

            // Why Two Pointers Works (Intuition)
            Container(
              padding: EdgeInsets.all(Responsive.sp(context, 18)),
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.accentPurple.withOpacity(0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb_outline, color: AppTheme.accentAmber, size: Responsive.sp(context, 24)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _isEnglish ? '🧠 Why Two Pointers Beats Brute Force?' : '🧠 কেন Two Pointers সেরা উপায়?',
                          style: TextStyle(
                            fontSize: Responsive.sp(context, 16),
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildIntuitionRow(
                    "❌ Brute Force O(N²)",
                    _isEnglish
                        ? "Check every pair (i, j). Takes quadratic time and gets TLE on N=30,000."
                        : "প্রতিটি জোড়া (i, j) চেক করা। সময় লাগবে O(N²) যা N=30,000 হলে TLE খাবে।",
                  ),
                  _buildIntuitionRow(
                    "⚡ Binary Search O(N log N)",
                    _isEnglish
                        ? "For each number x, binary search target-x. Good, but takes O(N log N)."
                        : "প্রতিটি সংখ্যা x এর জন্য binary search দিয়ে target-x খোজা। O(N log N) সময় নিবে।",
                  ),
                  _buildIntuitionRow(
                    "🚀 Two Pointers O(N) Time, O(1) Space",
                    _isEnglish
                        ? "Put left at index 0 and right at index N-1. If sum > target, decrease right. If sum < target, increase left. Never misses the answer because array is sorted!"
                        : "left কে ০ এবং right কে N-১ এ বসান। sum > target হলে right কমান, sum < target হলে left বাড়ান। সর্টেড অ্যারে হওয়ায় একটি পদক্ষেপও ভুল হয় না!",
                    highlight: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // TAB 2: Dynamic Input & 2D Scrollable Visualizer (Expanded Code Trace Width: 580px)
  Widget _buildVisualizerTab(double hPadding) {
    final isMobile = Responsive.isMobile(context);
    final step = _steps.isEmpty
        ? const TwoSumIIStep(
            left: 0,
            right: 0,
            sum: 0,
            activeLine: 0,
            actionEn: "",
            actionBn: "",
            reasonEn: "",
            reasonBn: "")
        : _steps[_currentStepIndex];

    return ResponsiveCenter(
      maxWidth: 1280.0, // Expanded width for visualizer
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical, // Top-to-bottom scroll
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dynamic Input Box
            Container(
              padding: EdgeInsets.all(Responsive.sp(context, 16)),
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.accentNeonCyan.withOpacity(0.4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isEnglish ? '⚙️ Dynamic Test Case Generator' : '⚙️ ডায়নামিক ইনপুট ও টেস্ট কেস',
                    style: TextStyle(
                      fontSize: Responsive.sp(context, 16),
                      fontWeight: FontWeight.bold,
                      color: AppTheme.accentNeonCyan,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (isMobile)
                    Column(
                      children: [
                        TextField(
                          controller: _numbersController,
                          style: TextStyle(color: Colors.white, fontFamily: 'monospace', fontSize: Responsive.sp(context, 13)),
                          decoration: InputDecoration(
                            labelText: _isEnglish ? 'Sorted Array (comma separated)' : 'সর্টেড অ্যারে (কমা দিয়ে separated)',
                            hintText: 'e.g. 1, 3, 4, 6, 8, 11, 15',
                            labelStyle: TextStyle(fontSize: Responsive.sp(context, 12)),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _targetController,
                          keyboardType: TextInputType.number,
                          style: TextStyle(color: Colors.white, fontFamily: 'monospace', fontSize: Responsive.sp(context, 13)),
                          decoration: InputDecoration(
                            labelText: _isEnglish ? 'Target' : 'টার্গেট',
                            hintText: '10',
                            labelStyle: TextStyle(fontSize: Responsive.sp(context, 12)),
                          ),
                        ),
                      ],
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextField(
                            controller: _numbersController,
                            style: TextStyle(color: Colors.white, fontFamily: 'monospace', fontSize: Responsive.sp(context, 13)),
                            decoration: InputDecoration(
                              labelText: _isEnglish ? 'Sorted Array (comma separated)' : 'সর্টেড অ্যারে (কমা দিয়ে separated)',
                              hintText: 'e.g. 1, 3, 4, 6, 8, 11, 15',
                              labelStyle: TextStyle(fontSize: Responsive.sp(context, 12)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 1,
                          child: TextField(
                            controller: _targetController,
                            keyboardType: TextInputType.number,
                            style: TextStyle(color: Colors.white, fontFamily: 'monospace', fontSize: Responsive.sp(context, 13)),
                            decoration: InputDecoration(
                              labelText: _isEnglish ? 'Target' : 'টার্গেট',
                              hintText: '10',
                              labelStyle: TextStyle(fontSize: Responsive.sp(context, 12)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 12),

                  // Preset buttons
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal, // Left-to-right scroll
                    child: Row(
                      children: [
                        Text('Presets: ', style: TextStyle(color: AppTheme.textMuted, fontSize: Responsive.sp(context, 12))),
                        _buildPresetChip('[2, 7, 11, 15] (t=9)', [2, 7, 11, 15], 9),
                        _buildPresetChip('[1, 3, 4, 6, 8, 11] (t=14)', [1, 3, 4, 6, 8, 11], 14),
                        _buildPresetChip('[-5, -2, 0, 3, 7] (t=1)', [-5, -2, 0, 3, 7], 1),
                        _buildPresetChip('[5, 10, 15, 20, 25] (t=35)', [5, 10, 15, 20, 25], 35),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  ElevatedButton.icon(
                    onPressed: _rebuildSteps,
                    icon: Icon(Icons.bolt, color: Colors.white, size: Responsive.sp(context, 18)),
                    label: Text(
                      _isEnglish ? 'Run Dynamic Visualizer' : 'ভিজ্যুয়ালাইজার রান করুন',
                      style: TextStyle(fontSize: Responsive.sp(context, 14), fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentPurple),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Step Visualization Section (Expanded Code Trace Width: 580px)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal, // Left-to-Right scroll support for wide screens / trace
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: isMobile ? MediaQuery.of(context).size.width - (hPadding * 2) : 1150.0,
                ),
                child: isMobile
                    ? Column(
                        children: [
                          _buildCodeTraceWidget(step.activeLine),
                          const SizedBox(height: 16),
                          _buildArrayVisualizationBox(step),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 580, // Expanded width for C++ Execution Trace
                            child: _buildCodeTraceWidget(step.activeLine),
                          ),
                          const SizedBox(width: 16),
                          SizedBox(
                            width: 550, // Array Visualization Box width
                            child: _buildArrayVisualizationBox(step),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 16),

            // Playback Controls Bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: Responsive.sp(context, 16), vertical: 12),
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.skip_previous, color: Colors.white, size: Responsive.sp(context, 20)),
                        onPressed: _currentStepIndex > 0
                            ? () => setState(() => _currentStepIndex--)
                            : null,
                      ),
                      IconButton(
                        icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, color: AppTheme.accentNeonCyan, size: Responsive.sp(context, 24)),
                        onPressed: _togglePlay,
                      ),
                      IconButton(
                        icon: Icon(Icons.skip_next, color: Colors.white, size: Responsive.sp(context, 20)),
                        onPressed: _currentStepIndex < _steps.length - 1
                            ? () => setState(() => _currentStepIndex++)
                            : null,
                      ),
                      IconButton(
                        icon: Icon(Icons.refresh, color: AppTheme.textMuted, size: Responsive.sp(context, 20)),
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
                    "Step ${_currentStepIndex + 1} / ${_steps.length}",
                    style: TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.bold, fontSize: Responsive.sp(context, 13)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // TAB 3: Interactive Practice & Full Solution (Expanded Width: 1280.0)
  Widget _buildPracticeAndAnswerTab(double hPadding) {
    final currSum = _currentArray[_userLeft] + _currentArray[_userRight];

    return ResponsiveCenter(
      maxWidth: 1280.0, // Expanded width
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Try It Yourself Interactive Box
            Container(
              padding: EdgeInsets.all(Responsive.sp(context, 18)),
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _userSolved ? AppTheme.accentGreen : AppTheme.accentAmber),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _userSolved ? Icons.check_circle : Icons.extension_outlined,
                        color: _userSolved ? AppTheme.accentGreen : AppTheme.accentAmber,
                        size: Responsive.sp(context, 24),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _isEnglish ? '🎮 Practice Mode: Solve It Yourself!' : '🎮 প্র্যাকটিস মোড: নিজে ট্রাই করুন!',
                        style: TextStyle(
                          fontSize: Responsive.sp(context, 16),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _isEnglish
                        ? 'Current Test Case: numbers = $_currentArray | Target = $_currentTarget'
                        : 'বর্তমান টেস্ট কেস: numbers = $_currentArray | Target = $_currentTarget',
                    style: TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: Responsive.sp(context, 13)),
                  ),
                  const SizedBox(height: 16),

                  // Pointer Array View (Scrollable Left-to-Right)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(_currentArray.length, (idx) {
                        final val = _currentArray[idx];
                        final isLeft = idx == _userLeft;
                        final isRight = idx == _userRight;
                        final isMatchedPair = _userSolved && (isLeft || isRight);

                        Color boxColor = AppTheme.primaryDark;
                        Color borderColor = const Color(0xFF334155);

                        if (isMatchedPair) {
                          boxColor = AppTheme.accentGreen.withOpacity(0.3);
                          borderColor = AppTheme.accentGreen;
                        } else if (isLeft && isRight) {
                          boxColor = AppTheme.accentAmber.withOpacity(0.3);
                          borderColor = AppTheme.accentAmber;
                        } else if (isLeft) {
                          boxColor = AppTheme.accentNeonCyan.withOpacity(0.25);
                          borderColor = AppTheme.accentNeonCyan;
                        } else if (isRight) {
                          boxColor = AppTheme.accentPurple.withOpacity(0.25);
                          borderColor = AppTheme.accentPurple;
                        }

                        return Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: EdgeInsets.symmetric(
                            horizontal: Responsive.sp(context, 14),
                            vertical: Responsive.sp(context, 10),
                          ),
                          decoration: BoxDecoration(
                            color: boxColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: borderColor, width: 2),
                          ),
                          child: Column(
                            children: [
                              if (isLeft && isRight)
                                Text('L & R', style: TextStyle(fontSize: Responsive.sp(context, 10), color: AppTheme.accentAmber, fontWeight: FontWeight.bold))
                              else if (isLeft)
                                Text('Left (L)', style: TextStyle(fontSize: Responsive.sp(context, 10), color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold))
                              else if (isRight)
                                Text('Right (R)', style: TextStyle(fontSize: Responsive.sp(context, 10), color: AppTheme.accentPurple, fontWeight: FontWeight.bold))
                              else
                                Text(' ', style: TextStyle(fontSize: Responsive.sp(context, 10))),
                              const SizedBox(height: 4),
                              Text(
                                '$val',
                                style: TextStyle(fontSize: Responsive.sp(context, 18), fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '[1-based: ${idx + 1}]',
                                style: TextStyle(fontSize: Responsive.sp(context, 9), color: AppTheme.textMuted),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Current Calculation Banner (Responsive)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryDark,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 12,
                      runSpacing: 6,
                      children: [
                        Text(
                          "Current sum: ${_currentArray[_userLeft]} + ${_currentArray[_userRight]} = $currSum",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: Responsive.sp(context, 13)),
                        ),
                        Text(
                          "Target: $_currentTarget",
                          style: TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: Responsive.sp(context, 13)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // User Action Buttons
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _userSolved || _userLeft >= _userRight
                            ? null
                            : () => _handleUserMove("left_inc"),
                        icon: Icon(Icons.arrow_forward_ios, size: Responsive.sp(context, 14)),
                        label: Text(_isEnglish ? 'Move Left++' : 'left++ বাড়ান', style: TextStyle(fontSize: Responsive.sp(context, 13))),
                        style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentNeonCyan),
                      ),
                      ElevatedButton.icon(
                        onPressed: _userSolved || _userLeft >= _userRight
                            ? null
                            : () => _handleUserMove("right_dec"),
                        icon: Icon(Icons.arrow_back_ios, size: Responsive.sp(context, 14)),
                        label: Text(_isEnglish ? 'Move Right--' : 'right-- কমান', style: TextStyle(fontSize: Responsive.sp(context, 13))),
                        style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentPurple),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            _userLeft = 0;
                            _userRight = _currentArray.length - 1;
                            _userSolved = false;
                            _userFeedbackEn = "Reset done! Choose your next move.";
                            _userFeedbackBn = "রিসেট করা হয়েছে! পরবর্তী পদক্ষেপ সিলেক্ট করুন।";
                          });
                        },
                        icon: Icon(Icons.refresh, size: Responsive.sp(context, 16), color: Colors.white),
                        label: Text(_isEnglish ? 'Reset' : 'রিসেট', style: TextStyle(fontSize: Responsive.sp(context, 13))),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // User Feedback box
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _userSolved ? AppTheme.accentGreen.withOpacity(0.15) : AppTheme.primaryDark,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: _userSolved ? AppTheme.accentGreen : const Color(0xFF334155)),
                    ),
                    child: Text(
                      _isEnglish ? _userFeedbackEn : _userFeedbackBn,
                      style: TextStyle(
                        color: _userSolved ? AppTheme.accentGreen : AppTheme.textSecondary,
                        fontWeight: FontWeight.w600,
                        fontSize: Responsive.sp(context, 13),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Reveal Solution Section (If User Cannot Solve)
            Container(
              padding: EdgeInsets.all(Responsive.sp(context, 18)),
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.accentPink.withOpacity(0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isEnglish ? "Need Help or Stuck?" : "সমস্যা সমাধান করতে পারছ না?",
                              style: TextStyle(
                                fontSize: Responsive.sp(context, 16),
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _isEnglish
                                  ? "Reveal complete solution code in multiple languages & visualizer."
                                  : "সম্পূর্ণ সমাধান, কোড এবং গাইডলাইন দেখুন।",
                              style: TextStyle(color: AppTheme.textSecondary, fontSize: Responsive.sp(context, 12)),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _showAnswer = !_showAnswer;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _showAnswer ? AppTheme.accentGreen : AppTheme.accentPink,
                        ),
                        child: Text(
                          _showAnswer
                              ? (_isEnglish ? "Hide Answer" : "উত্তর লুকান")
                              : (_isEnglish ? "Reveal Solution Code" : "উত্তর ও কোড দেখুন"),
                          style: TextStyle(fontSize: Responsive.sp(context, 13), fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),

                  if (_showAnswer) ...[
                    const Divider(height: 28, color: Color(0xFF334155)),

                    // Language Tabs for Code Solution
                    Row(
                      children: ["C++", "Java", "Python", "Dart"].map((lang) {
                        final isSel = _selectedCodeLang == lang;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(lang, style: TextStyle(fontSize: Responsive.sp(context, 12))),
                            selected: isSel,
                            selectedColor: AppTheme.accentPurple,
                            backgroundColor: AppTheme.primaryDark,
                            labelStyle: TextStyle(
                              color: isSel ? Colors.white : AppTheme.textSecondary,
                              fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                            ),
                            onSelected: (val) {
                              if (val) {
                                setState(() {
                                  _selectedCodeLang = lang;
                                });
                              }
                            },
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 12),

                    // Full Code Box Solution (With Copy Option)
                    _buildFullCodeSnippet(_selectedCodeLang),
                    const SizedBox(height: 16),

                    // Complexity & Detailed Breakdown
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryDark,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "⏱️ Complexity Analysis:",
                            style: TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: Responsive.sp(context, 14)),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _isEnglish
                                ? "• Time Complexity: O(N) — In the worst case, each element is visited at most once as left increment and right decrement move towards center.\n• Space Complexity: O(1) — Only two integer pointers are used, fulfilling the memory restriction."
                                : "• টাইম কমপ্লেক্সিটি: O(N) — সর্বোচ্চ ক্ষেত্রে প্রতিটি এলিমেন্ট পয়েন্টার দ্বারা ১ বার পরিদর্শিত হয়।\n• স্পেস কমপ্লেক্সিটি: O(1) — মাত্র দুইটি ইনটিজার পয়েন্টার (left & right) ব্যবহৃত হয়।",
                            style: TextStyle(color: AppTheme.textSecondary, fontSize: Responsive.sp(context, 13), height: 1.4),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // Helpers
  Widget _buildPresetChip(String label, List<int> arr, int t) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ActionChip(
        label: Text(label, style: TextStyle(fontSize: Responsive.sp(context, 11), color: Colors.white)),
        backgroundColor: AppTheme.primaryDark,
        onPressed: () => _loadPreset(arr, t),
      ),
    );
  }

  Widget _buildExampleCard(String title, String input, String output, String desc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.accentNeonCyan, fontSize: Responsive.sp(context, 13))),
          const SizedBox(height: 4),
          Text(input, style: TextStyle(fontFamily: 'monospace', color: Colors.white, fontSize: Responsive.sp(context, 12))),
          Text(output, style: TextStyle(fontFamily: 'monospace', color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: Responsive.sp(context, 12))),
          const SizedBox(height: 4),
          Text(desc, style: TextStyle(color: AppTheme.textSecondary, fontSize: Responsive.sp(context, 12))),
        ],
      ),
    );
  }

  Widget _buildIntuitionRow(String title, String desc, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            highlight ? Icons.star : Icons.chevron_right,
            color: highlight ? AppTheme.accentGreen : AppTheme.textMuted,
            size: Responsive.sp(context, 18),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: highlight ? AppTheme.accentGreen : Colors.white,
                    fontSize: Responsive.sp(context, 13),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: Responsive.sp(context, 12), height: 1.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Expanded & Ultra-Clear Line-by-Line Code Snippet Highlight Widget (Width 580px)
  Widget _buildCodeTraceWidget(int activeLine) {
    final codeLines = const [
      "vector<int> twoSum(vector<int>& numbers, int target) {",
      "    int left = 0;",
      "    int right = numbers.size() - 1;",
      "    while (left < right) {",
      "        int sum = numbers[left] + numbers[right];",
      "        if (sum == target) {",
      "            return {left + 1, right + 1};",
      "        } else if (sum < target) {",
      "            left++;",
      "        } else {",
      "            right--;",
      "        }",
      "    }",
      "    return {};",
      "}",
    ];

    final fullCodeText = codeLines.join('\n');

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Responsive.sp(context, 14)),
      decoration: BoxDecoration(
        color: const Color(0xFF090D16),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF1E293B), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Copy Code Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.code_rounded, color: AppTheme.accentNeonCyan, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    "C++ Execution Trace",
                    style: TextStyle(
                      color: AppTheme.accentNeonCyan,
                      fontWeight: FontWeight.bold,
                      fontSize: Responsive.sp(context, 13.5),
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () => _copyToClipboard(fullCodeText, "C++ Visualizer Code"),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppTheme.accentPurple.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.accentPurple.withOpacity(0.5)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.copy, size: Responsive.sp(context, 13), color: AppTheme.accentNeonCyan),
                      const SizedBox(width: 4),
                      Text(
                        _isEnglish ? "Copy" : "কপি",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: Responsive.sp(context, 11.5),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Code Trace Lines (Scrollable Left-to-Right with expanded width)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(codeLines.length, (idx) {
                final lineNum = idx + 1;
                final isActive = lineNum == activeLine;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(vertical: 2.5),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(
                    color: isActive ? AppTheme.accentPurple.withOpacity(0.35) : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                    border: isActive ? const Border(left: BorderSide(color: AppTheme.accentNeonCyan, width: 4)) : null,
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 28,
                        child: Text(
                          '$lineNum',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: Responsive.sp(context, 12),
                            color: isActive ? AppTheme.accentNeonCyan : AppTheme.textMuted,
                            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                      Text(
                        codeLines[idx],
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: Responsive.sp(context, 13),
                          color: isActive ? Colors.white : const Color(0xFF94A3B8),
                          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                        ),
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

  Widget _buildArrayVisualizationBox(TwoSumIIStep step) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Responsive.sp(context, 16)),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: step.isMatch ? AppTheme.accentGreen : const Color(0xFF334155),
          width: step.isMatch ? 2.0 : 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Calculation Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Current sum: ${step.sum}",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: Responsive.sp(context, 14)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.accentNeonCyan.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Target: $_currentTarget",
                  style: TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: Responsive.sp(context, 12)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Array Box Animation View (Scrollable Left-to-Right)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_currentArray.length, (idx) {
                final val = _currentArray[idx];
                final isLeft = idx == step.left;
                final isRight = idx == step.right;
                final isMatched = step.isMatch && (isLeft || isRight);
                final isOutside = idx < step.left || idx > step.right;

                Color boxBg = AppTheme.primaryDark;
                Color borderColor = const Color(0xFF334155);

                if (isMatched) {
                  boxBg = AppTheme.accentGreen.withOpacity(0.35);
                  borderColor = AppTheme.accentGreen;
                } else if (isLeft && isRight) {
                  boxBg = AppTheme.accentAmber.withOpacity(0.35);
                  borderColor = AppTheme.accentAmber;
                } else if (isLeft) {
                  boxBg = AppTheme.accentNeonCyan.withOpacity(0.25);
                  borderColor = AppTheme.accentNeonCyan;
                } else if (isRight) {
                  boxBg = AppTheme.accentPurple.withOpacity(0.25);
                  borderColor = AppTheme.accentPurple;
                } else if (isOutside) {
                  boxBg = AppTheme.primaryDark.withOpacity(0.4);
                  borderColor = Colors.transparent;
                }

                return Opacity(
                  opacity: isOutside ? 0.35 : 1.0,
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: EdgeInsets.symmetric(
                      horizontal: Responsive.sp(context, 12),
                      vertical: Responsive.sp(context, 8),
                    ),
                    decoration: BoxDecoration(
                      color: boxBg,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: borderColor, width: 2),
                    ),
                    child: Column(
                      children: [
                        if (isLeft && isRight)
                          Text('L&R', style: TextStyle(fontSize: Responsive.sp(context, 10), color: AppTheme.accentAmber, fontWeight: FontWeight.bold))
                        else if (isLeft)
                          Text('Left', style: TextStyle(fontSize: Responsive.sp(context, 10), color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold))
                        else if (isRight)
                          Text('Right', style: TextStyle(fontSize: Responsive.sp(context, 10), color: AppTheme.accentPurple, fontWeight: FontWeight.bold))
                        else
                          Text(' ', style: TextStyle(fontSize: Responsive.sp(context, 10))),
                        const SizedBox(height: 4),
                        Text(
                          '$val',
                          style: TextStyle(
                            fontSize: Responsive.sp(context, 16),
                            fontWeight: FontWeight.bold,
                            color: isMatched ? AppTheme.accentGreen : Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'idx ${idx + 1}',
                          style: TextStyle(fontSize: Responsive.sp(context, 9), color: AppTheme.textMuted),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 16),

          // Action Explanation Box
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(Responsive.sp(context, 12)),
            decoration: BoxDecoration(
              color: step.isMatch
                  ? AppTheme.accentGreen.withOpacity(0.15)
                  : AppTheme.primaryDark,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: step.isMatch ? AppTheme.accentGreen : const Color(0xFF334155),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isEnglish ? step.actionEn : step.actionBn,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: step.isMatch ? AppTheme.accentGreen : Colors.white,
                    fontSize: Responsive.sp(context, 13),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _isEnglish ? step.reasonEn : step.reasonBn,
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: Responsive.sp(context, 12), height: 1.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Solution Code Box with COPY CODE BUTTON
  Widget _buildFullCodeSnippet(String lang) {
    String code = "";
    if (lang == "C++") {
      code = """
class Solution {
public:
    vector<int> twoSum(vector<int>& numbers, int target) {
        int left = 0;
        int right = numbers.size() - 1;
        
        while (left < right) {
            int current_sum = numbers[left] + numbers[right];
            if (current_sum == target) {
                return {left + 1, right + 1}; // 1-indexed
            } else if (current_sum < target) {
                left++;  // Increase sum by moving left pointer rightward
            } else {
                right--; // Decrease sum by moving right pointer leftward
            }
        }
        return {};
    }
};""";
    } else if (lang == "Java") {
      code = """
class Solution {
    public int[] twoSum(int[] numbers, int target) {
        int left = 0;
        int right = numbers.length - 1;
        
        while (left < right) {
            int sum = numbers[left] + numbers[right];
            if (sum == target) {
                return new int[]{left + 1, right + 1}; // 1-indexed
            } else if (sum < target) {
                left++;
            } else {
                right--;
            }
        }
        return new int[]{};
    }
}""";
    } else if (lang == "Python") {
      code = """
class Solution:
    def twoSum(self, numbers: List[int], target: int) -> List[int]:
        left = 0
        right = len(numbers) - 1
        
        while left < right:
            curr_sum = numbers[left] + numbers[right]
            if curr_sum == target:
                return [left + 1, right + 1] # 1-indexed
            elif curr_sum < target:
                left += 1
            else:
                right -= 1
        return []""";
    } else {
      code = """
List<int> twoSum(List<int> numbers, int target) {
  int left = 0;
  int right = numbers.length - 1;
  
  while (left < right) {
    int sum = numbers[left] + numbers[right];
    if (sum == target) {
      return [left + 1, right + 1]; // 1-indexed
    } else if (sum < target) {
      left++;
    } else {
      right--;
    }
  }
  return [];
}""";
    }

    return Container(
      padding: EdgeInsets.all(Responsive.sp(context, 14)),
      decoration: BoxDecoration(
        color: const Color(0xFF090D16),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Language & Copy Code Button
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 10,
            runSpacing: 8,
            children: [
              Text(
                "$lang Solution Code",
                style: TextStyle(
                  color: AppTheme.accentNeonCyan,
                  fontWeight: FontWeight.bold,
                  fontSize: Responsive.sp(context, 13),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _copyToClipboard(code, "$lang Solution"),
                icon: Icon(Icons.copy_all, size: Responsive.sp(context, 14)),
                label: Text(
                  _isEnglish ? "Copy Code" : "কোড কপি করুন",
                  style: TextStyle(fontSize: Responsive.sp(context, 12), fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentPurple,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              code.trim(),
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: Responsive.sp(context, 12.5),
                color: const Color(0xFF38BDF8),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
