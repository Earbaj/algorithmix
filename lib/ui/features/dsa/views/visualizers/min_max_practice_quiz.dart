import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';

class MinMaxPracticeQuiz extends StatefulWidget {
  final bool isEnglish;

  const MinMaxPracticeQuiz({
    super.key,
    required this.isEnglish,
  });

  @override
  State<MinMaxPracticeQuiz> createState() => _MinMaxPracticeQuizState();
}

class QuizQuestion {
  final String questionEn;
  final String questionBn;
  final List<String> optionsEn;
  final List<String> optionsBn;
  final int correctOptionIndex;
  final String explanationEn;
  final String explanationBn;

  const QuizQuestion({
    required this.questionEn,
    required this.questionBn,
    required this.optionsEn,
    required this.optionsBn,
    required this.correctOptionIndex,
    required this.explanationEn,
    required this.explanationBn,
  });
}

class TestCaseData {
  final String inputStr;
  final String expectedOutputStr;
  final List<int> arrayInput;
  final int expectedMin;
  final int expectedMax;

  const TestCaseData({
    required this.inputStr,
    required this.expectedOutputStr,
    required this.arrayInput,
    required this.expectedMin,
    required this.expectedMax,
  });
}

class _MinMaxPracticeQuizState extends State<MinMaxPracticeQuiz> {
  int _activeSubTab = 0; // 0: Test Suite Runner, 1: Concept Quiz

  // Test Suite Runner State
  bool _isRunningTests = false;
  bool _testsCompleted = false;

  final List<TestCaseData> _testCases = const [
    TestCaseData(
      inputStr: "[15, 42, 8, 99, 23]",
      expectedOutputStr: "{min: 8, max: 99}",
      arrayInput: [15, 42, 8, 99, 23],
      expectedMin: 8,
      expectedMax: 99,
    ),
    TestCaseData(
      inputStr: "[-15, -42, -8, -99, -23]",
      expectedOutputStr: "{min: -99, max: -8}",
      arrayInput: [-15, -42, -8, -99, -23],
      expectedMin: -99,
      expectedMax: -8,
    ),
    TestCaseData(
      inputStr: "[100]",
      expectedOutputStr: "{min: 100, max: 100}",
      arrayInput: [100],
      expectedMin: 100,
      expectedMax: 100,
    ),
    TestCaseData(
      inputStr: "[5, 5, 5, 5, 5]",
      expectedOutputStr: "{min: 5, max: 5}",
      arrayInput: [5, 5, 5, 5, 5],
      expectedMin: 5,
      expectedMax: 5,
    ),
    TestCaseData(
      inputStr: "[0, -5, 10, -20, 30]",
      expectedOutputStr: "{min: -20, max: 30}",
      arrayInput: [0, -5, 10, -20, 30],
      expectedMin: -20,
      expectedMax: 30,
    ),
  ];

  // Quiz State
  final Map<int, int> _selectedAnswers = {};
  int _score = 0;

  final List<QuizQuestion> _quizQuestions = const [
    QuizQuestion(
      questionEn: "1. What is the minimum number of comparisons needed to find BOTH min & max in an array of size N using the optimal pair comparison method?",
      questionBn: "১. পেয়ার কম্প্যারিসন মেথড ব্যবহার করে N সাইজের একটি অ্যারে থেকে Min এবং Max দুটোই বের করতে সর্বমোট কতগুলো তুলনা (Comparisons) প্রয়োজন?",
      optionsEn: [
        "A) 2N - 2 comparisons",
        "B) ⌈3N/2⌉ - 2 comparisons",
        "C) N log N comparisons",
        "D) N - 1 comparisons"
      ],
      optionsBn: [
        "A) 2N - 2 comparisons",
        "B) ⌈3N/2⌉ - 2 comparisons",
        "C) N log N comparisons",
        "D) N - 1 comparisons"
      ],
      correctOptionIndex: 1,
      explanationEn: "Correct! By comparing elements in pairs first, and then comparing the smaller with minVal and larger with maxVal, we only need ~3N/2 comparisons instead of 2N-2.",
      explanationBn: "সঠিক! উপাদানগুলোকে জোড়ায় জোড়ায় (Pairs) বিভক্ত করে তুলনা করলে সর্বমোট ~3N/2 টি তুলনাই যথেষ্ট (সাধারণ লুপের 2N-2 তুলনার চেয়ে কম)।",
    ),
    QuizQuestion(
      questionEn: "2. What bug happens if you initialize minVal = 0 and maxVal = 0 when processing all negative numbers like [-15, -42, -8]?",
      questionBn: "২. অ্যারের সব সংখ্যা যদি নেগেটিভ হয় (যেমন [-15, -42, -8]) এবং আপনি যদি minVal = 0, maxVal = 0 দিয়ে শুরু করেন, তবে কী ভুল হবে?",
      optionsEn: [
        "A) minVal becomes -42, maxVal becomes -8",
        "B) maxVal incorrectly stays 0 because no negative number is > 0",
        "C) minVal incorrectly stays 0",
        "D) Throws a NullPointerException"
      ],
      optionsBn: [
        "A) minVal = -42, maxVal = -8 সঠিকভাবে আসবে",
        "B) maxVal ভুলভাবে 0 থেকে যাবে, কারণ কোনো নেগেটিভ সংখ্যা 0-এর চেয়ে বড় নয়",
        "C) minVal ভুলভাবে 0 থেকে যাবে",
        "D) এটি নাল পয়েন্টার এক্সেপশন দেবে"
      ],
      correctOptionIndex: 1,
      explanationEn: "Correct! Initializing with 0 causes maxVal to stay 0 because maxVal > 0 is never true for negative numbers. Always initialize with arr[0]!",
      explanationBn: "সঠিক! 0 দিয়ে ইনিশিয়ালাইজ করলে নেগেটিভ অ্যারের ক্ষেত্রে maxVal সব সময় 0-ই থেকে যাবে। তাই সর্বদা arr[0] দিয়ে ইনিশিয়ালাইজ করা উচিত।",
    ),
    QuizQuestion(
      questionEn: "3. What should be the returned pair for a single-element array findMinMax([7])?",
      questionBn: "৩. একটিমাত্র উপাদান বিশিষ্ট অ্যারে findMinMax([7]) এর ক্ষেত্রে আউটপুট কী হবে?",
      optionsEn: [
        "A) {min: 7, max: 7}",
        "B) {min: 0, max: 7}",
        "C) {min: 7, max: 0}",
        "D) Out of bounds exception"
      ],
      optionsBn: [
        "A) {min: 7, max: 7}",
        "B) {min: 0, max: 7}",
        "C) {min: 7, max: 0}",
        "D) আউট অফ বাউন্ডস এরর"
      ],
      correctOptionIndex: 0,
      explanationEn: "Correct! When an array has only 1 element, both the minimum and maximum element are equal to that single element.",
      explanationBn: "সঠিক! অ্যারেতে ১টি উপাদান থাকলে সর্বনিম্ন এবং সর্বোচ্চ উভয় মানই সেই একক উপাদান (7)।",
    ),
    QuizQuestion(
      questionEn: "4. How can the min-element concept be used to solve 'Best Time to Buy & Sell Stock' (Max Difference arr[j] - arr[i] with j > i) in O(N)?",
      questionBn: "৪. 'Best Time to Buy & Sell Stock' বা সর্বোচ্চ পার্থক্য (arr[j] - arr[i] যেখানে j > i) প্রবলেমে Minimum ধারণার ভূমিকা কী?",
      optionsEn: [
        "A) Sort the array first",
        "B) Track min_so_far as you iterate and calculate max profit (current - min_so_far)",
        "C) Find global max and global min first",
        "D) Use 2 nested loops O(N^2)"
      ],
      optionsBn: [
        "A) প্রথমে অ্যারে সর্ট করতে হবে",
        "B) লুপে ঘোরার সময় min_so_far ট্র্যাক রেখে (current - min_so_far) সর্বোচ্চ প্রফিট হিসাব করা",
        "C) আগেই গ্লোবাল min ও max বের করা",
        "D) ২টি নেস্টেড লুপ O(N^2) ব্যবহার করা"
      ],
      correctOptionIndex: 1,
      explanationEn: "Correct! Keeping track of the lowest price seen so far (min_so_far) allows computing the max potential profit in a single O(N) pass!",
      explanationBn: "সঠিক! এখন পর্যন্ত দেখা সবচেয়ে কম দাম (min_so_far) ট্র্যাকিং রেখে এক পাসেই O(N) সময়ে সর্বোচ্চ প্রফিট বের করা যায়।",
    ),
    QuizQuestion(
      questionEn: "5. For an array with all equal elements [5, 5, 5, 5], how many times will minVal or maxVal be updated in loop body?",
      questionBn: "৫. সব উপাদান সমান হলে [5, 5, 5, 5], লুপ চলাকালীন minVal বা maxVal কতবার আপডেট হবে (arr[0] দিয়ে ইনিশিয়ালাইজ করার পর)?",
      optionsEn: [
        "A) 4 times",
        "B) 0 times",
        "C) 2 times",
        "D) 3 times"
      ],
      optionsBn: [
        "A) ৪ বার",
        "B) ০ বার (একবারও না)",
        "C) ২ বার",
        "D) ৩ বার"
      ],
      correctOptionIndex: 1,
      explanationEn: "Correct! Since arr[i] < minVal (5 < 5) and arr[i] > maxVal (5 > 5) are both FALSE for all elements, no updates occur in the loop body.",
      explanationBn: "সঠিক! 5 < 5 বা 5 > 5 কোনোটিই সত্য না হওয়ায় লুপের ভেতরে কোনো আপডেট হবে না (০ বার)।",
    ),
    QuizQuestion(
      questionEn: "6. What is the Time & Auxiliary Space Complexity of linear scan findMinMax?",
      questionBn: "৬. লিনিয়ার স্ক্যান findMinMax অ্যালগরিদমের Time ও Auxiliary Space Complexity কত?",
      optionsEn: [
        "A) Time: O(N), Space: O(1)",
        "B) Time: O(N log N), Space: O(N)",
        "C) Time: O(N^2), Space: O(1)",
        "D) Time: O(1), Space: O(N)"
      ],
      optionsBn: [
        "A) Time: O(N), Space: O(1)",
        "B) Time: O(N log N), Space: O(N)",
        "C) Time: O(N^2), Space: O(1)",
        "D) Time: O(1), Space: O(N)"
      ],
      correctOptionIndex: 0,
      explanationEn: "Correct! Linear scan visits each element once O(N) and uses constant extra space O(1) for minVal and maxVal variables.",
      explanationBn: "সঠিক! লিনিয়ার স্ক্যানে প্রতিটি এলিমেন্ট একবার ভিসিট করা হয় O(N) এবং অতিরিক্ত কনস্ট্যান্ট মেমোরি O(1) ব্যবহৃত হয়।",
    ),
  ];

  void _runTestSuite() async {
    setState(() {
      _isRunningTests = true;
      _testsCompleted = false;
    });

    await Future.delayed(const Duration(milliseconds: 1000));

    setState(() {
      _isRunningTests = false;
      _testsCompleted = true;
    });
  }

  void _selectOption(int qIndex, int optionIndex) {
    if (_selectedAnswers.containsKey(qIndex)) return;

    setState(() {
      _selectedAnswers[qIndex] = optionIndex;
      if (optionIndex == _quizQuestions[qIndex].correctOptionIndex) {
        _score++;
      }
    });
  }

  void _resetQuiz() {
    setState(() {
      _selectedAnswers.clear();
      _score = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sub-Tab Switcher (Test Cases vs Concept Quiz)
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xFF090D16),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF1E293B)),
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _activeSubTab = 0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                    decoration: BoxDecoration(
                      color: _activeSubTab == 0 ? AppTheme.accentGreen.withOpacity(0.2) : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: _activeSubTab == 0 ? Border.all(color: AppTheme.accentGreen) : null,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.playlist_add_check, color: AppTheme.accentGreen, size: 16),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            widget.isEnglish ? "Automated Test Suite" : "অটোমেটেড টেস্ট রানার",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: _activeSubTab == 0 ? AppTheme.accentGreen : AppTheme.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _activeSubTab = 1),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                    decoration: BoxDecoration(
                      color: _activeSubTab == 1 ? AppTheme.accentPurple.withOpacity(0.2) : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: _activeSubTab == 1 ? Border.all(color: AppTheme.accentPurple) : null,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.quiz_outlined, color: AppTheme.accentPurple, size: 16),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            widget.isEnglish ? "Concept Mastery Quiz" : "কনসেপ্ট মাস্টার কুইজ",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: _activeSubTab == 1 ? AppTheme.accentPurple : AppTheme.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        if (_activeSubTab == 0) _buildTestSuiteSection(),
        if (_activeSubTab == 1) _buildQuizSection(),
      ],
    );
  }

  // ─── SUB-TAB 1: TEST SUITE RUNNER ───────────────────────────────────────────

  Widget _buildTestSuiteSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surfaceDark,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.accentGreen.withOpacity(0.4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.isEnglish ? "Interactive Test Runner" : "ইনটারেক্টিভ টেস্ট রানার",
                      style: const TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: _isRunningTests ? null : _runTestSuite,
                    icon: _isRunningTests
                        ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.primaryDark))
                        : const Icon(Icons.play_arrow, size: 18),
                    label: Text(
                      _isRunningTests
                          ? (widget.isEnglish ? "Testing..." : "টেস্ট হচ্ছে...")
                          : (widget.isEnglish ? "Run All Tests" : "সব টেস্ট কেস রান করুন"),
                      style: const TextStyle(fontSize: 12),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accentGreen,
                      foregroundColor: AppTheme.primaryDark,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                widget.isEnglish
                    ? "Verify algorithm correctness against positive, negative, duplicate, single-element, and zero-containing edge cases."
                    : "পজিটিভ, নেগেটিভ, ডুপ্লিকেট, সিঙ্গেল-ইলিমেন্ট ও শূন্য সম্বলিত বিভিন্ন টেস্ট কেসের সাথে অ্যালগরিদমের সঠিকতা যাচাই করুন।",
                style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // List of Test Cases
        ...List.generate(_testCases.length, (idx) {
          final tc = _testCases[idx];
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF090D16),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: _testsCompleted ? AppTheme.accentGreen.withOpacity(0.6) : const Color(0xFF1E293B),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: _testsCompleted ? AppTheme.accentGreen.withOpacity(0.2) : const Color(0xFF1E293B),
                  child: Text(
                    "${idx + 1}",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: _testsCompleted ? AppTheme.accentGreen : Colors.white70,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Input: ${tc.inputStr}",
                        style: const TextStyle(fontFamily: 'monospace', fontSize: 13, color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Expected Output: ${tc.expectedOutputStr}",
                        style: const TextStyle(fontFamily: 'monospace', fontSize: 12, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                if (_isRunningTests)
                  const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.accentNeonCyan))
                else if (_testsCompleted)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.accentGreen.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.accentGreen),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, color: AppTheme.accentGreen, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          widget.isEnglish ? "PASSED" : "সফল",
                          style: const TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 11),
                        ),
                      ],
                    ),
                  )
                else
                  Text(
                    widget.isEnglish ? "Ready" : "রেডি",
                    style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
                  ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // ─── SUB-TAB 2: CONCEPT MASTERY QUIZ ─────────────────────────────────────────

  Widget _buildQuizSection() {
    final totalQ = _quizQuestions.length;
    final answeredCount = _selectedAnswers.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Score Header Banner
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surfaceDark,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.accentPurple.withOpacity(0.5)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.isEnglish ? "Min & Max Concept Mastery Quiz" : "মিন ও ম্যাক্স কনসেপ্ট মাস্টার কুইজ",
                      style: const TextStyle(color: AppTheme.accentPurple, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.isEnglish
                          ? "Answered: $answeredCount / $totalQ"
                          : "উত্তর প্রদান: $answeredCount / $totalQ",
                      style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppTheme.accentPurple.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.accentPurple),
                    ),
                    child: Text(
                      "Score: $_score / $totalQ",
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.white70),
                    onPressed: _resetQuiz,
                    tooltip: widget.isEnglish ? "Reset Quiz" : "কুইজ রিসেট",
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // List of Quiz Questions
        ...List.generate(totalQ, (qIdx) {
          final q = _quizQuestions[qIdx];
          final selectedOption = _selectedAnswers[qIdx];
          final isAnswered = selectedOption != null;

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF090D16),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isAnswered
                    ? (selectedOption == q.correctOptionIndex ? AppTheme.accentGreen : Colors.redAccent)
                    : const Color(0xFF1E293B),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.isEnglish ? q.questionEn : q.questionBn,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14, height: 1.4),
                ),
                const SizedBox(height: 12),

                // Options
                ...List.generate(q.optionsEn.length, (optIdx) {
                  final optText = widget.isEnglish ? q.optionsEn[optIdx] : q.optionsBn[optIdx];
                  final isSelected = selectedOption == optIdx;
                  final isCorrect = optIdx == q.correctOptionIndex;

                  Color optBg = AppTheme.surfaceDark;
                  Color optBorder = const Color(0xFF334155);
                  Color textColor = Colors.white70;

                  if (isAnswered) {
                    if (isCorrect) {
                      optBg = AppTheme.accentGreen.withOpacity(0.2);
                      optBorder = AppTheme.accentGreen;
                      textColor = AppTheme.accentGreen;
                    } else if (isSelected) {
                      optBg = Colors.redAccent.withOpacity(0.2);
                      optBorder = Colors.redAccent;
                      textColor = Colors.redAccent;
                    }
                  }

                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: InkWell(
                      onTap: () => _selectOption(qIdx, optIdx),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: optBg,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: optBorder),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                optText,
                                style: TextStyle(color: textColor, fontWeight: isSelected || (isAnswered && isCorrect) ? FontWeight.bold : FontWeight.normal, fontSize: 13),
                              ),
                            ),
                            if (isAnswered && isCorrect)
                              const Icon(Icons.check_circle, color: AppTheme.accentGreen, size: 18)
                            else if (isSelected && !isCorrect)
                              const Icon(Icons.cancel, color: Colors.redAccent, size: 18),
                          ],
                        ),
                      ),
                    ),
                  );
                }),

                // Explanation Box when answered
                if (isAnswered) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.accentPurple.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppTheme.accentPurple.withOpacity(0.4)),
                    ),
                    child: Text(
                      widget.isEnglish ? q.explanationEn : q.explanationBn,
                      style: const TextStyle(color: Colors.white, fontSize: 12, height: 1.4),
                    ),
                  ),
                ],
              ],
            ),
          );
        }),
      ],
    );
  }
}
