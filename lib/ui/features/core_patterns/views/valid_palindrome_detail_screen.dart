import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import 'package:algorithmix/ui/features/core_patterns/widgets/valid_palindrome_code_free_visualizer.dart';

class ValidPalindromeStep {
  final int left;
  final int right;
  final int activeLine;
  final String actionEn;
  final String actionBn;
  final String reasonEn;
  final String reasonBn;
  final bool isMatch;
  final bool isFinish;

  const ValidPalindromeStep({
    required this.left,
    required this.right,
    required this.activeLine,
    required this.actionEn,
    required this.actionBn,
    required this.reasonEn,
    required this.reasonBn,
    this.isMatch = false,
    this.isFinish = false,
  });
}

class ValidPalindromeDetailScreen extends StatefulWidget {
  const ValidPalindromeDetailScreen({super.key});

  @override
  State<ValidPalindromeDetailScreen> createState() =>
      _ValidPalindromeDetailScreenState();
}

class _ValidPalindromeDetailScreenState
    extends State<ValidPalindromeDetailScreen>
    with SingleTickerProviderStateMixin {
  bool _isEnglish = true;
  late TabController _tabController;

  // Custom Input State
  final TextEditingController _stringController =
      TextEditingController(text: "A man, a plan, a canal: Panama");

  String _currentString = "A man, a plan, a canal: Panama";
  List<ValidPalindromeStep> _steps = [];

  // Playback Control
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  // Practice Mode / Answer reveal state
  bool _showAnswer = false;
  int _userLeft = 0;
  int _userRight = 29;
  String _userFeedbackEn = "Select your move to check palindrome symmetry!";
  String _userFeedbackBn = "প্যালিনড্রোম সমতা যাচাই করতে পরবর্তী মুভ সিলেক্ট করুন!";
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
    _stringController.dispose();
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

  bool _isAlphanumericChar(String char) {
    if (char.isEmpty) return false;
    final code = char.codeUnitAt(0);
    return (code >= 48 && code <= 57) ||
        (code >= 65 && code <= 90) ||
        (code >= 97 && code <= 122);
  }

  void _rebuildSteps() {
    _timer?.cancel();
    _isPlaying = false;
    _currentStepIndex = 0;

    _currentString = _stringController.text.trim();
    if (_currentString.isEmpty) {
      _currentString = "A man, a plan, a canal: Panama";
    }

    _userLeft = 0;
    _userRight = _currentString.length - 1;
    _userSolved = false;
    _userFeedbackEn = "Start moving left/right pointers to verify palindrome!";
    _userFeedbackBn = "প্যালিনড্রোম যাচাই করতে left/right পয়েন্টার সরানো শুরু করুন!";

    _steps = _generateSteps(_currentString);
    setState(() {});
  }

  List<ValidPalindromeStep> _generateSteps(String s) {
    List<ValidPalindromeStep> steps = [];
    int l = 0;
    int r = s.length - 1;

    // Line 2: Initialize pointers
    steps.add(ValidPalindromeStep(
      left: l,
      right: r,
      activeLine: 2,
      actionEn: "Line 2: Initialize pointers → left = 0 ('${s[l]}'), right = ${s.length - 1} ('${s[r]}')",
      actionBn: "লাইন ২: পয়েন্টার সূচনা → left = 0 ('${s[l]}'), right = ${s.length - 1} ('${s[r]}')",
      reasonEn: "Left starts at index 0 and Right starts at last index.",
      reasonBn: "Left পয়েন্টার শুরুতে (০) এবং Right পয়েন্টার একদম শেষে বসানো হলো।",
    ));

    bool isPal = true;

    while (l < r) {
      // Line 3: While loop condition
      steps.add(ValidPalindromeStep(
        left: l,
        right: r,
        activeLine: 3,
        actionEn: "Line 3: Check while (left < right) → ($l < $r) is TRUE",
        actionBn: "লাইন ৩: লুপ শর্ত চেক while (left < right) → ($l < $r) সত্য",
        reasonEn: "Pointers haven't crossed yet. Proceed with character checks.",
        reasonBn: "পয়েন্টারদ্বয় এখনো পরস্পরকে অতিক্রম করেনি। লুপের ভেতরে কাজ চলবে।",
      ));

      // Line 4: Skip left non-alphanumeric
      if (!_isAlphanumericChar(s[l])) {
        steps.add(ValidPalindromeStep(
          left: l,
          right: r,
          activeLine: 4,
          actionEn: "Line 4: Skip non-alphanumeric s[left] ('${s[l]}') → execute left++",
          actionBn: "লাইন ৪: নন-আলফানিউমেরিক s[left] ('${s[l]}') স্কিপ → left++ সম্পাদন",
          reasonEn: "'${s[l]}' is punctuation/space. Increment left pointer.",
          reasonBn: "'${s[l]}' সাধারণ বর্ণ নয়। left পয়েন্টার ১ বাড়ান।",
        ));
        l++;
        continue;
      }

      // Line 5: Skip right non-alphanumeric
      if (!_isAlphanumericChar(s[r])) {
        steps.add(ValidPalindromeStep(
          left: l,
          right: r,
          activeLine: 5,
          actionEn: "Line 5: Skip non-alphanumeric s[right] ('${s[r]}') → execute right--",
          actionBn: "লাইন ৫: নন-আলফানিউমেরিক s[right] ('${s[r]}') স্কিপ → right-- সম্পাদন",
          reasonEn: "'${s[r]}' is punctuation/space. Decrement right pointer.",
          reasonBn: "'${s[r]}' সাধারণ বর্ণ নয়। right পয়েন্টার ১ কমান।",
        ));
        r--;
        continue;
      }

      // Line 6: Check character match
      String cL = s[l].toLowerCase();
      String cR = s[r].toLowerCase();

      steps.add(ValidPalindromeStep(
        left: l,
        right: r,
        activeLine: 6,
        actionEn: "Line 6: Compare tolower(s[left]) vs tolower(s[right]) → ('$cL' vs '$cR')",
        actionBn: "লাইন ৬: তোলনা tolower(s[left]) এবং tolower(s[right]) → ('$cL' বনাম '$cR')",
        reasonEn: cL == cR
            ? "Characters match! Move both pointers inward."
            : "Characters do NOT match! String is NOT a valid palindrome.",
        reasonBn: cL == cR
            ? "বর্ণদ্বয় মিলে গেছে! উভয় পয়েন্টার ভেতরের দিকে সরান।"
            : "বর্ণদ্বয় মিলেনি! এটি প্যালিনড্রোম নয়।",
      ));

      if (cL != cR) {
        isPal = false;
        // Line 7: Return false
        steps.add(ValidPalindromeStep(
          left: l,
          right: r,
          activeLine: 7,
          actionEn: "Line 7: return false ❌ (Mismatch at '$cL' != '$cR')",
          actionBn: "লাইন ৭: return false ❌ (অমিল '$cL' != '$cR')",
          reasonEn: "First mismatch breaks palindrome symmetry.",
          reasonBn: "প্রথম অমিল পেলেই প্যালিনড্রোম হওয়া থেকে বাতিল হয়ে যায়।",
          isFinish: true,
        ));
        break;
      }

      // Line 8 & 9: Increment left & Decrement right
      l++;
      r--;
      steps.add(ValidPalindromeStep(
        left: l,
        right: r,
        activeLine: 8,
        actionEn: "Line 8 & 9: Execute left++ and right--",
        actionBn: "লাইন ৮ ও ৯: left++ এবং right-- সম্পাদন",
        reasonEn: "Move left to next char (index $l) and right to prev char (index $r).",
        reasonBn: "left পয়েন্টার ডানে এবং right পয়েন্টার বামে কমানো হলো।",
        isMatch: true,
      ));
    }

    if (isPal) {
      // Line 11: Return true
      steps.add(ValidPalindromeStep(
        left: l,
        right: r,
        activeLine: 11,
        actionEn: "Line 11: return true 🎉 (String is a Valid Palindrome)",
        actionBn: "লাইন ১১: return true 🎉 (স্ট্রিংটি একটি ভ্যালিড প্যালিনড্রোম)",
        reasonEn: "Pointers met/crossed with all characters matching symmetrically!",
        reasonBn: "সবগুলো বর্ণ সমতার সাথে মিলে গেছে!",
        isMatch: true,
        isFinish: true,
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

  void _loadPreset(String str) {
    _stringController.text = str;
    _rebuildSteps();
  }

  void _handleUserMove(String action) {
    if (_userSolved) return;
    final s = _currentString;

    setState(() {
      if (action == "skip_left") {
        if (!_isAlphanumericChar(s[_userLeft])) {
          _userLeft++;
          _userFeedbackEn = "✅ Correct! '${s[_userLeft - 1]}' is punctuation/space, left++ skips it.";
          _userFeedbackBn = "✅ সঠিক সিদ্ধান্ত! '${s[_userLeft - 1]}' স্কিপ করা হলো।";
        } else {
          _userFeedbackEn = "⚠️ '${s[_userLeft]}' is a valid alphanumeric character! Don't skip it.";
          _userFeedbackBn = "⚠️ '${s[_userLeft]}' একটি বর্ণ! স্কিপ করার প্রয়োজন নেই।";
        }
      } else if (action == "skip_right") {
        if (!_isAlphanumericChar(s[_userRight])) {
          _userRight--;
          _userFeedbackEn = "✅ Correct! '${s[_userRight + 1]}' is punctuation/space, right-- skips it.";
          _userFeedbackBn = "✅ সঠিক সিদ্ধান্ত! '${s[_userRight + 1]}' স্কিপ করা হলো।";
        } else {
          _userFeedbackEn = "⚠️ '${s[_userRight]}' is a valid alphanumeric character! Don't skip it.";
          _userFeedbackBn = "⚠️ '${s[_userRight]}' একটি বর্ণ! স্কিপ করার প্রয়োজন নেই।";
        }
      } else if (action == "match") {
        if (_isAlphanumericChar(s[_userLeft]) && _isAlphanumericChar(s[_userRight])) {
          if (s[_userLeft].toLowerCase() == s[_userRight].toLowerCase()) {
            _userLeft++;
            _userRight--;
            _userFeedbackEn = "✅ Match! '${s[_userLeft - 1]}' == '${s[_userRight + 1]}'. Both pointers moved inward.";
            _userFeedbackBn = "✅ মিলে গেছে! উভয় পয়েন্টার সরানো হলো।";
          } else {
            _userFeedbackEn = "❌ Mismatch detected! '${s[_userLeft]}' != '${s[_userRight]}'. Not a palindrome!";
            _userFeedbackBn = "❌ অমিল পাওয়া গেছে! এটি প্যালিনড্রোম নয়।";
          }
        } else {
          _userFeedbackEn = "⚠️ Skip symbols first before matching!";
          _userFeedbackBn = "⚠️ বর্ণ মিলানোর আগে সিম্বল স্কিপ করুন!";
        }
      }

      if (_userLeft >= _userRight) {
        _userSolved = true;
        _userFeedbackEn = "🎉 Congratulations! You verified the palindrome successfully!";
        _userFeedbackBn = "🎉 অভিনন্দন! আপনি সফলভাবে প্যালিনড্রোম সমতা যাচাই করেছেন!";
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
          '125. Valid Palindrome',
          style: TextStyle(
            fontSize: Responsive.sp(context, 18),
            fontWeight: FontWeight.bold,
          ),
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
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: Responsive.sp(context, 13)),
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
          tabAlignment: TabAlignment.start,
          padding: EdgeInsets.zero,
          labelStyle: TextStyle(
              fontSize: Responsive.sp(context, 14), fontWeight: FontWeight.bold),
          unselectedLabelStyle:
              TextStyle(fontSize: Responsive.sp(context, 13)),
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

  // TAB 1: Problem Description
  Widget _buildProblemDescriptionTab(double hPadding) {
    return ResponsiveCenter(
      maxWidth: 1280.0,
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                    style: TextStyle(
                        color: AppTheme.accentGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: Responsive.sp(context, 12)),
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
                    'LeetCode #125',
                    style: TextStyle(
                        color: AppTheme.accentNeonCyan,
                        fontWeight: FontWeight.bold,
                        fontSize: Responsive.sp(context, 12)),
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
                    '⭐ FAANG Classic (Meta, MS)',
                    style: TextStyle(
                        color: AppTheme.accentPink,
                        fontWeight: FontWeight.bold,
                        fontSize: Responsive.sp(context, 12)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              _isEnglish ? 'Valid Palindrome' : 'ভ্যালিড প্যালিনড্রোম (Valid Palindrome)',
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
                    _isEnglish ? 'Problem Statement' : 'সমস্যার বিবরণ',
                    style: TextStyle(
                      fontSize: Responsive.sp(context, 16),
                      fontWeight: FontWeight.bold,
                      color: AppTheme.accentNeonCyan,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _isEnglish
                        ? 'A phrase is a palindrome if, after converting all uppercase letters into lowercase letters and removing all non-alphanumeric characters, it reads the same forward and backward.\n\nGiven a string s, return true if it is a palindrome, or false otherwise.\n\nConstraint: O(1) extra space complexity.'
                        : 'একটি বাক্যকে প্যালিনড্রোম বলা হয় যদি বড় হাতের অক্ষরগুলোকে ছোট হাতে রূপান্তরিত করার পর এবং সমস্ত নন-আলফানিউমেরিক অক্ষর (যেমন স্পেস, কমা) বাদ দেওয়ার পর এটি সোজা এবং উল্টো উভয় দিক থেকে একইভাবে পড়া যায়।\n\nএকটি স্ট্রিং s দেওয়া আছে, প্যালিনড্রোম হলে true অন্যথায় false রিটার্ন করুন।\n\nশর্ত: O(1) অতিরিক্ত স্পেস কমপ্লেক্সিটি।',
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
              "s = \"A man, a plan, a canal: Panama\"",
              "Output: true",
              _isEnglish
                  ? "Explanation: \"amanaplanacanalpanama\" is a palindrome."
                  : "ব্যাখ্যা: সংসংোধন করার পর \"amanaplanacanalpanama\" একটি প্যালিনড্রোম।",
            ),
            _buildExampleCard(
              "Example 2",
              "s = \"race a car\"",
              "Output: false",
              _isEnglish
                  ? "Explanation: \"raceacar\" is not a palindrome ('e' != 'a')."
                  : "ব্যাখ্যা: \"raceacar\" প্যালিনড্রোম নয় ('e' != 'a')।",
            ),
            _buildExampleCard(
              "Example 3",
              "s = \" \"",
              "Output: true",
              _isEnglish
                  ? "Explanation: Empty string \"\" after removing non-alphanumeric characters reads same forward and backward."
                  : "ব্যাখ্যা: খালি স্ট্রিং \"\" সোজা ও উল্টো উভয় দিকে সমান।",
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // TAB 2: Code-Free Animation
  Widget _buildCodeFreeVisualizerTab(double hPadding) {
    return ResponsiveCenter(
      maxWidth: 1280.0,
      padding: EdgeInsets.all(hPadding),
      child: ValidPalindromeCodeFreeVisualizer(isEnglish: _isEnglish),
    );
  }

  // TAB 3: Dynamic Visualizer
  Widget _buildVisualizerTab(double hPadding) {
    final isMobile = Responsive.isMobile(context);
    final step = _steps.isEmpty
        ? const ValidPalindromeStep(
            left: 0,
            right: 0,
            activeLine: 0,
            actionEn: "",
            actionBn: "",
            reasonEn: "",
            reasonBn: "")
        : _steps[_currentStepIndex];

    return ResponsiveCenter(
      maxWidth: 1280.0,
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
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
                  TextField(
                    controller: _stringController,
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'monospace',
                        fontSize: Responsive.sp(context, 13)),
                    decoration: InputDecoration(
                      labelText: _isEnglish ? 'Input String s' : 'ইনপুট স্ট্রিং s',
                      hintText: 'e.g. A man, a plan, a canal: Panama',
                      labelStyle: TextStyle(fontSize: Responsive.sp(context, 12)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Text('Presets: ',
                            style: TextStyle(
                                color: AppTheme.textMuted,
                                fontSize: Responsive.sp(context, 12))),
                        _buildPresetChip('"A man..."', "A man, a plan, a canal: Panama"),
                        _buildPresetChip('"race a car"', "race a car"),
                        _buildPresetChip('"Was it a car..."', "Was it a car or a cat I saw?"),
                        _buildPresetChip('"No \'x\' in Nixon"', "No 'x' in Nixon"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: _rebuildSteps,
                    icon: Icon(Icons.bolt, color: Colors.white, size: Responsive.sp(context, 18)),
                    label: Text(
                      _isEnglish ? 'Run Dynamic Visualizer' : 'ভিজ্যুয়ালাইজার রান করুন',
                      style: TextStyle(
                          fontSize: Responsive.sp(context, 14), fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentPurple),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Visualization Layout: Stack on Mobile, Side-by-Side Horizontal Scroll on Desktop
            if (isMobile)
              Column(
                children: [
                  _buildCodeTraceWidget(step.activeLine),
                  const SizedBox(height: 16),
                  _buildArrayVisualizationBox(step),
                ],
              )
            else
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 580,
                      child: _buildCodeTraceWidget(step.activeLine),
                    ),
                    const SizedBox(width: 16),
                    SizedBox(
                      width: 550,
                      child: _buildArrayVisualizationBox(step),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),

            // Playback Controls
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: Responsive.sp(context, 16), vertical: 12),
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
                        icon: Icon(Icons.skip_previous,
                            color: Colors.white, size: Responsive.sp(context, 20)),
                        onPressed: _currentStepIndex > 0
                            ? () => setState(() => _currentStepIndex--)
                            : null,
                      ),
                      IconButton(
                        icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow,
                            color: AppTheme.accentNeonCyan,
                            size: Responsive.sp(context, 24)),
                        onPressed: _togglePlay,
                      ),
                      IconButton(
                        icon: Icon(Icons.skip_next,
                            color: Colors.white, size: Responsive.sp(context, 20)),
                        onPressed: _currentStepIndex < _steps.length - 1
                            ? () => setState(() => _currentStepIndex++)
                            : null,
                      ),
                      IconButton(
                        icon: Icon(Icons.refresh,
                            color: AppTheme.textMuted, size: Responsive.sp(context, 20)),
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
                    style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.bold,
                        fontSize: Responsive.sp(context, 13)),
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

  // TAB 4: Practice & Answer
  Widget _buildPracticeAndAnswerTab(double hPadding) {
    final s = _currentString;

    return ResponsiveCenter(
      maxWidth: 1280.0,
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
                border: Border.all(
                    color: _userSolved ? AppTheme.accentGreen : AppTheme.accentAmber),
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
                        _isEnglish ? '🎮 Practice Mode: Verify Yourself!' : '🎮 প্র্যাকটিস মোড: নিজে ট্রাই করুন!',
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
                        ? 'Current String: s = "$_currentString"'
                        : 'বর্তমান স্ট্রিং: s = "$_currentString"',
                    style: TextStyle(
                        color: AppTheme.accentNeonCyan,
                        fontWeight: FontWeight.bold,
                        fontSize: Responsive.sp(context, 13)),
                  ),
                  const SizedBox(height: 16),

                  // String View
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(s.length, (idx) {
                        final char = s[idx];
                        final displayChar = char == ' ' ? '␣' : char;
                        final isLeft = idx == _userLeft;
                        final isRight = idx == _userRight;
                        final isAlpha = _isAlphanumericChar(char);

                        Color boxColor = AppTheme.primaryDark;
                        Color borderColor = const Color(0xFF334155);

                        if (isLeft && isRight) {
                          boxColor = AppTheme.accentAmber.withOpacity(0.3);
                          borderColor = AppTheme.accentAmber;
                        } else if (isLeft) {
                          boxColor = AppTheme.accentNeonCyan.withOpacity(0.25);
                          borderColor = AppTheme.accentNeonCyan;
                        } else if (isRight) {
                          boxColor = AppTheme.accentPurple.withOpacity(0.25);
                          borderColor = AppTheme.accentPurple;
                        } else if (!isAlpha) {
                          boxColor = AppTheme.accentAmber.withOpacity(0.1);
                        }

                        return Container(
                          margin: const EdgeInsets.only(right: 6),
                          padding: EdgeInsets.symmetric(
                            horizontal: Responsive.sp(context, 10),
                            vertical: Responsive.sp(context, 8),
                          ),
                          decoration: BoxDecoration(
                            color: boxColor,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: borderColor, width: 2),
                          ),
                          child: Column(
                            children: [
                              if (isLeft && isRight)
                                Text('L&R',
                                    style: TextStyle(
                                        fontSize: Responsive.sp(context, 9.5),
                                        color: AppTheme.accentAmber,
                                        fontWeight: FontWeight.bold))
                              else if (isLeft)
                                Text('Left',
                                    style: TextStyle(
                                        fontSize: Responsive.sp(context, 9.5),
                                        color: AppTheme.accentNeonCyan,
                                        fontWeight: FontWeight.bold))
                              else if (isRight)
                                Text('Right',
                                    style: TextStyle(
                                        fontSize: Responsive.sp(context, 9.5),
                                        color: AppTheme.accentPurple,
                                        fontWeight: FontWeight.bold))
                              else
                                Text(' ',
                                    style: TextStyle(fontSize: Responsive.sp(context, 9.5))),
                              const SizedBox(height: 4),
                              Text(
                                displayChar,
                                style: TextStyle(
                                    fontSize: Responsive.sp(context, 16),
                                    fontWeight: FontWeight.bold,
                                    color: isAlpha ? Colors.white : AppTheme.accentAmber),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '$idx',
                                style: TextStyle(
                                    fontSize: Responsive.sp(context, 9),
                                    color: AppTheme.textMuted),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // User Action Buttons
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _userSolved || _userLeft >= _userRight
                            ? null
                            : () => _handleUserMove("skip_left"),
                        icon: Icon(Icons.redo, size: Responsive.sp(context, 14)),
                        label: Text(_isEnglish ? 'Skip Left Symbol' : 'Left সিম্বল স্কিপ',
                            style: TextStyle(fontSize: Responsive.sp(context, 13))),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accentAmber),
                      ),
                      ElevatedButton.icon(
                        onPressed: _userSolved || _userLeft >= _userRight
                            ? null
                            : () => _handleUserMove("skip_right"),
                        icon: Icon(Icons.undo, size: Responsive.sp(context, 14)),
                        label: Text(_isEnglish ? 'Skip Right Symbol' : 'Right সিম্বল স্কিপ',
                            style: TextStyle(fontSize: Responsive.sp(context, 13))),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accentAmber),
                      ),
                      ElevatedButton.icon(
                        onPressed: _userSolved || _userLeft >= _userRight
                            ? null
                            : () => _handleUserMove("match"),
                        icon: Icon(Icons.check, size: Responsive.sp(context, 14)),
                        label: Text(_isEnglish ? 'Check Match' : 'অক্ষর ম্যাচ করুন',
                            style: TextStyle(fontSize: Responsive.sp(context, 13))),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accentNeonCyan),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            _userLeft = 0;
                            _userRight = _currentString.length - 1;
                            _userSolved = false;
                            _userFeedbackEn = "Reset done! Choose your next move.";
                            _userFeedbackBn = "রিসেট করা হয়েছে!";
                          });
                        },
                        icon: Icon(Icons.refresh,
                            size: Responsive.sp(context, 16), color: Colors.white),
                        label: Text(_isEnglish ? 'Reset' : 'রিসেট',
                            style: TextStyle(fontSize: Responsive.sp(context, 13))),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Feedback Box
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _userSolved
                          ? AppTheme.accentGreen.withOpacity(0.15)
                          : AppTheme.primaryDark,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: _userSolved
                              ? AppTheme.accentGreen
                              : const Color(0xFF334155)),
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

            // Reveal Solution Section
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
                                  ? "Reveal complete solution code in C++, Java, Python, and Dart."
                                  : "সম্পূর্ণ সমাধান ও কোড গাইডলাইন দেখুন।",
                              style: TextStyle(
                                  color: AppTheme.textSecondary,
                                  fontSize: Responsive.sp(context, 12)),
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
                          backgroundColor:
                              _showAnswer ? AppTheme.accentGreen : AppTheme.accentPink,
                        ),
                        child: Text(
                          _showAnswer
                              ? (_isEnglish ? "Hide Answer" : "উত্তর লুকান")
                              : (_isEnglish ? "Reveal Solution Code" : "উত্তর ও কোড দেখুন"),
                          style: TextStyle(
                              fontSize: Responsive.sp(context, 13),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  if (_showAnswer) ...[
                    const Divider(height: 28, color: Color(0xFF334155)),
                    Row(
                      children: ["C++", "Java", "Python", "Dart"].map((lang) {
                        final isSel = _selectedCodeLang == lang;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(lang,
                                style: TextStyle(fontSize: Responsive.sp(context, 12))),
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
                    _buildFullCodeSnippet(_selectedCodeLang),
                    const SizedBox(height: 16),
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
                            style: TextStyle(
                                color: AppTheme.accentNeonCyan,
                                fontWeight: FontWeight.bold,
                                fontSize: Responsive.sp(context, 14)),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _isEnglish
                                ? "• Time Complexity: O(N) — Each character is visited at most once by left and right pointers.\n• Space Complexity: O(1) — No extra string is allocated; comparisons happen in-place."
                                : "• টাইম কমপ্লেক্সিটি: O(N) — সর্বোচ্চ ক্ষেত্রে প্রতিটি ক্যারেক্টার পয়েন্টার দ্বারা ১ বার পরিদর্শিত হয়।\n• স্পেস কমপ্লেক্সিটি: O(1) — কোনো নতুন স্ট্রিং তৈরি না করে ইন-প্লেস চেক করা হয়।",
                            style: TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: Responsive.sp(context, 13),
                                height: 1.4),
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

  Widget _buildPresetChip(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ActionChip(
        label: Text(label,
            style: TextStyle(
                fontSize: Responsive.sp(context, 11), color: Colors.white)),
        backgroundColor: AppTheme.primaryDark,
        onPressed: () => _loadPreset(value),
      ),
    );
  }

  Widget _buildExampleCard(
      String title, String input, String output, String desc) {
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
          Text(title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.accentNeonCyan,
                  fontSize: Responsive.sp(context, 13))),
          const SizedBox(height: 4),
          Text(input,
              style: TextStyle(
                  fontFamily: 'monospace',
                  color: Colors.white,
                  fontSize: Responsive.sp(context, 12))),
          Text(output,
              style: TextStyle(
                  fontFamily: 'monospace',
                  color: AppTheme.accentGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: Responsive.sp(context, 12))),
          const SizedBox(height: 4),
          Text(desc,
              style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: Responsive.sp(context, 12))),
        ],
      ),
    );
  }

  Widget _buildCodeTraceWidget(int activeLine) {
    final codeLines = const [
      "bool isPalindrome(string s) {",
      "    int left = 0, right = s.length() - 1;",
      "    while (left < right) {",
      "        while (left < right && !isalnum(s[left])) left++;",
      "        while (left < right && !isalnum(s[right])) right--;",
      "        if (tolower(s[left]) != tolower(s[right])) {",
      "            return false;",
      "        }",
      "        left++;",
      "        right--;",
      "    }",
      "    return true;",
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.code_rounded,
                      color: AppTheme.accentNeonCyan, size: 18),
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
                onTap: () => _copyToClipboard(fullCodeText, "C++ Trace Code"),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppTheme.accentPurple.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.accentPurple.withOpacity(0.5)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.copy,
                          size: Responsive.sp(context, 13),
                          color: AppTheme.accentNeonCyan),
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
                    color: isActive
                        ? AppTheme.accentPurple.withOpacity(0.35)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                    border: isActive
                        ? const Border(
                            left: BorderSide(
                                color: AppTheme.accentNeonCyan, width: 4))
                        : null,
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
                            color: isActive
                                ? AppTheme.accentNeonCyan
                                : AppTheme.textMuted,
                            fontWeight:
                                isActive ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                      Text(
                        codeLines[idx],
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: Responsive.sp(context, 13),
                          color:
                              isActive ? Colors.white : const Color(0xFF94A3B8),
                          fontWeight:
                              isActive ? FontWeight.bold : FontWeight.normal,
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

  Widget _buildArrayVisualizationBox(ValidPalindromeStep step) {
    final s = _currentString;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Responsive.sp(context, 16)),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: step.isFinish
              ? (step.isMatch ? AppTheme.accentGreen : Colors.redAccent)
              : const Color(0xFF334155),
          width: step.isFinish ? 2.0 : 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Symmetry Checking",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: Responsive.sp(context, 14)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.accentNeonCyan.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Length: ${s.length}",
                  style: TextStyle(
                      color: AppTheme.accentNeonCyan,
                      fontWeight: FontWeight.bold,
                      fontSize: Responsive.sp(context, 12)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(s.length, (idx) {
                final char = s[idx];
                final displayChar = char == ' ' ? '␣' : char;
                final isLeft = idx == step.left;
                final isRight = idx == step.right;
                final isAlpha = _isAlphanumericChar(char);

                Color boxBg = AppTheme.primaryDark;
                Color borderColor = const Color(0xFF334155);

                if (isLeft && isRight) {
                  boxBg = AppTheme.accentAmber.withOpacity(0.35);
                  borderColor = AppTheme.accentAmber;
                } else if (isLeft) {
                  boxBg = AppTheme.accentNeonCyan.withOpacity(0.25);
                  borderColor = AppTheme.accentNeonCyan;
                } else if (isRight) {
                  boxBg = AppTheme.accentPurple.withOpacity(0.25);
                  borderColor = AppTheme.accentPurple;
                } else if (!isAlpha) {
                  boxBg = AppTheme.accentAmber.withOpacity(0.08);
                }

                return Container(
                  margin: const EdgeInsets.only(right: 6),
                  padding: EdgeInsets.symmetric(
                    horizontal: Responsive.sp(context, 10),
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
                        Text('L&R',
                            style: TextStyle(
                                fontSize: Responsive.sp(context, 9.5),
                                color: AppTheme.accentAmber,
                                fontWeight: FontWeight.bold))
                      else if (isLeft)
                        Text('Left',
                            style: TextStyle(
                                fontSize: Responsive.sp(context, 9.5),
                                color: AppTheme.accentNeonCyan,
                                fontWeight: FontWeight.bold))
                      else if (isRight)
                        Text('Right',
                            style: TextStyle(
                                fontSize: Responsive.sp(context, 9.5),
                                color: AppTheme.accentPurple,
                                fontWeight: FontWeight.bold))
                      else
                        Text(' ',
                            style: TextStyle(fontSize: Responsive.sp(context, 9.5))),
                      const SizedBox(height: 4),
                      Text(
                        displayChar,
                        style: TextStyle(
                          fontSize: Responsive.sp(context, 16),
                          fontWeight: FontWeight.bold,
                          color: isAlpha ? Colors.white : AppTheme.accentAmber,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$idx',
                        style: TextStyle(
                            fontSize: Responsive.sp(context, 9),
                            color: AppTheme.textMuted),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 16),

          Container(
            width: double.infinity,
            padding: EdgeInsets.all(Responsive.sp(context, 12)),
            decoration: BoxDecoration(
              color: step.isFinish
                  ? (step.isMatch
                      ? AppTheme.accentGreen.withOpacity(0.15)
                      : Colors.redAccent.withOpacity(0.15))
                  : AppTheme.primaryDark,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: step.isFinish
                    ? (step.isMatch ? AppTheme.accentGreen : Colors.redAccent)
                    : const Color(0xFF334155),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isEnglish ? step.actionEn : step.actionBn,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: step.isFinish
                        ? (step.isMatch ? AppTheme.accentGreen : Colors.redAccent)
                        : Colors.white,
                    fontSize: Responsive.sp(context, 13),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _isEnglish ? step.reasonEn : step.reasonBn,
                  style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: Responsive.sp(context, 12),
                      height: 1.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFullCodeSnippet(String lang) {
    String code = "";
    if (lang == "C++") {
      code = """
class Solution {
public:
    bool isPalindrome(string s) {
        int left = 0, right = s.length() - 1;
        
        while (left < right) {
            while (left < right && !isalnum(s[left])) left++;
            while (left < right && !isalnum(s[right])) right--;
            
            if (tolower(s[left]) != tolower(s[right])) {
                return false;
            }
            left++;
            right--;
        }
        return true;
    }
};""";
    } else if (lang == "Java") {
      code = """
class Solution {
    public boolean isPalindrome(String s) {
        int left = 0, right = s.length() - 1;
        
        while (left < right) {
            while (left < right && !Character.isLetterOrDigit(s.charAt(left))) left++;
            while (left < right && !Character.isLetterOrDigit(s.charAt(right))) right--;
            
            if (Character.toLowerCase(s.charAt(left)) != Character.toLowerCase(s.charAt(right))) {
                return false;
            }
            left++;
            right--;
        }
        return true;
    }
}""";
    } else if (lang == "Python") {
      code = """
class Solution:
    def isPalindrome(self, s: str) -> bool:
        left, right = 0, len(s) - 1
        
        while left < right:
            while left < right and not s[left].isalnum():
                left += 1
            while left < right and not s[right].isalnum():
                right -= 1
            if s[left].lower() != s[right].lower():
                return False
            left += 1
            right -= 1
        return True""";
    } else {
      code = """
bool isPalindrome(String s) {
  int left = 0, right = s.length - 1;
  RegExp alphaNum = RegExp(r'[a-zA-Z0-9]');

  while (left < right) {
    while (left < right && !alphaNum.hasMatch(s[left])) left++;
    while (left < right && !alphaNum.hasMatch(s[right])) right--;

    if (s[left].toLowerCase() != s[right].toLowerCase()) {
      return false;
    }
    left++;
    right--;
  }
  return true;
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
                  style: TextStyle(
                      fontSize: Responsive.sp(context, 12),
                      fontWeight: FontWeight.bold),
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
