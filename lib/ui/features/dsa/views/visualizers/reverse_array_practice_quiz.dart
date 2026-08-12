import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';

class ReverseArrayPracticeQuiz extends StatefulWidget {
  final bool isEnglish;

  const ReverseArrayPracticeQuiz({
    super.key,
    required this.isEnglish,
  });

  @override
  State<ReverseArrayPracticeQuiz> createState() => _ReverseArrayPracticeQuizState();
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

  const TestCaseData({
    required this.inputStr,
    required this.expectedOutputStr,
  });
}

class _ReverseArrayPracticeQuizState extends State<ReverseArrayPracticeQuiz> {
  int _activeSubTab = 0; // 0: Test Suite, 1: Quiz

  bool _isRunningTests = false;
  bool _testsCompleted = false;

  final List<TestCaseData> _testCases = const [
    TestCaseData(inputStr: "[1, 2, 3, 4, 5]", expectedOutputStr: "[5, 4, 3, 2, 1]"),
    TestCaseData(inputStr: "[10, 20]", expectedOutputStr: "[20, 10]"),
    TestCaseData(inputStr: "[7]", expectedOutputStr: "[7]"),
    TestCaseData(inputStr: "[-1, -2, -3]", expectedOutputStr: "[-3, -2, -1]"),
    TestCaseData(inputStr: "[1, 2, 3, 4]", expectedOutputStr: "[4, 3, 2, 1]"),
  ];

  final Map<int, int> _selectedAnswers = {};
  int _score = 0;

  final List<QuizQuestion> _quizQuestions = const [
    QuizQuestion(
      questionEn: "1. What is the Space Complexity of the Two-Pointer In-Place Array Reversal algorithm?",
      questionBn: "১. টু-পয়েন্টার ইন-প্লেস অ্যারে রিভার্সাল অ্যালগরিদমের Space Complexity কত?",
      optionsEn: ["A) O(1) Auxiliary Space", "B) O(N) Space", "C) O(N log N) Space", "D) O(N^2) Space"],
      optionsBn: ["A) O(1) অতিরিক্ত মেমোরি", "B) O(N) মেমোরি", "C) O(N log N) মেমোরি", "D) O(N^2) মেমোরি"],
      correctOptionIndex: 0,
      explanationEn: "Correct! In-place reversal swaps elements directly inside the original array memory without creating a new copy array, so it takes O(1) space.",
      explanationBn: "সঠিক! ইন-প্লেস রিভার্সাল কোনো নতুন অ্যারে না বানিয়ে মূল অ্যারেতেই উপাদানগুলো Swap করে, তাই এতে মাত্র O(1) স্পেস লাগে।",
    ),
    QuizQuestion(
      questionEn: "2. How many total swap operations are performed to reverse an array of size N?",
      questionBn: "২. N সাইজের একটি অ্যারে রিভার্স করতে মোট কতটি Swap অপারেশন করতে হয়?",
      optionsEn: ["A) N swaps", "B) ⌊N / 2⌋ swaps", "C) N - 1 swaps", "D) N^2 swaps"],
      optionsBn: ["A) N টি সোয়াপ", "B) ⌊N / 2⌋ টি সোয়াপ", "C) N - 1 টি সোয়াপ", "D) N^2 টি সোয়াপ"],
      correctOptionIndex: 1,
      explanationEn: "Correct! Pointers start at boundaries and move inward, swapping pairs until they meet in the center. Thus, exactly ⌊N / 2⌋ swaps are needed.",
      explanationBn: "সঠিক! পয়েন্টার দুটি দুই প্রান্ত থেকে মাঝখানে মিলিত হওয়া পর্যন্ত কাজ করে, তাই ঠিক ⌊N / 2⌋ সংখ্যক সোয়াপ প্রয়োজন।",
    ),
    QuizQuestion(
      questionEn: "3. What happens during while (left < right) when an array has an ODD length (e.g. N = 5)?",
      questionBn: "৩. অ্যারের দৈর্ঘ্য যদি বেজোড় (ODD) হয় (যেমন N = 5), তবে while (left < right) লুপের শেষে কী ঘটে?",
      optionsEn: [
        "A) Middle element is swapped with itself",
        "B) Middle element remains in its original position (left == right terminates loop)",
        "C) Infinite loop occurs",
        "D) Out of bounds exception"
      ],
      optionsBn: [
        "A) মাঝের এলিমেন্ট নিজের সাথেই সোয়াপ হয়",
        "B) মাঝের এলিমেন্ট নিজের জায়গায় অপরিবর্তিত থাকে (left == right হলে লুপ বন্ধ হয়)",
        "C) ইনফাইনাইট লুপ তৈরি হয়",
        "D) আউট অফ বাউন্ডস এরর দেয়"
      ],
      correctOptionIndex: 1,
      explanationEn: "Correct! When left == right at the center index, left < right becomes FALSE, so the middle element stays safely in place without unnecessary swaps.",
      explanationBn: "সঠিক! মাঝের উপাদানটিতে left == right হওয়ার সাথে সাথে left < right শর্ত মিথ্যা হয়ে যায়, তাই মাঝের সংখ্যাটি ঠিক থাকে।",
    ),
    QuizQuestion(
      questionEn: "4. How can two numbers a and b be swapped without using a temporary variable?",
      questionBn: "৪. কোনো থার্ড/টেম্পোরারি ভ্যারিয়েবল ছাড়া দুটি সংখ্যা a এবং b কীভাবে Swap করা যায়?",
      optionsEn: [
        "A) Using XOR: a = a ^ b; b = a ^ b; a = a ^ b;",
        "B) Using Multiplication: a = a * b;",
        "C) It is impossible without extra variable",
        "D) Using a loop"
      ],
      optionsBn: [
        "A) Bitwise XOR ব্যবহার করে: a = a ^ b; b = a ^ b; a = a ^ b;",
        "B) গুণফল ব্যবহার করে: a = a * b;",
        "C) অতিরিক্ত ভ্যারিয়েবল ছাড়া সম্ভব নয়",
        "D) লুপ ব্যবহার করে"
      ],
      correctOptionIndex: 0,
      explanationEn: "Correct! Bitwise XOR operations swap two variables in-place without needing extra memory space for a temp variable.",
      explanationBn: "সঠিক! বিটওয়াইজ XOR ট্রিক দিয়ে কোনো থার্ড ভ্যারিয়েবল ছাড়াই দুটি মান অদলবদল করা সম্ভব।",
    ),
    QuizQuestion(
      questionEn: "5. What is the relation between checking if a string is a Palindrome and the Two-Pointer reversal technique?",
      questionBn: "৫. একটি স্ট্রিং Palindrome কিনা তা চেক করার সাথে টু-পয়েন্টার টেকনিকের সম্পর্ক কী?",
      optionsEn: [
        "A) Both use left & right pointers; Palindrome checks equality arr[left] == arr[right] instead of swapping",
        "B) They are completely unrelated algorithms",
        "C) Palindrome requires O(N^2) time",
        "D) Reversal requires sorting"
      ],
      optionsBn: [
        "A) দুটিই left ও right পয়েন্টার ব্যবহার করে; প্যালিনড্রমে সোয়াপের বদলে arr[left] == arr[right] সমান কিনা দেখা হয়",
        "B) তাদের মধ্যে কোনো সম্পর্ক নেই",
        "C) প্যালিনড্রমে O(N^2) সময় লাগে",
        "D) রিভার্স করতে সর্টিং লাগে"
      ],
      correctOptionIndex: 0,
      explanationEn: "Correct! Palindrome checking uses the identical two-pointer structure, but compares elements for equality instead of swapping them.",
      explanationBn: "সঠিক! প্যালিনড্রম চেকিং অ্যালগরিদম হুবহু একই টু-পয়েন্টার লজিক ব্যবহার করে, শুধু সোয়াপের বদলে মান দুটি সমান কিনা যাচাই করে।",
    ),
  ];

  void _runTestSuite() async {
    setState(() {
      _isRunningTests = true;
      _testsCompleted = false;
    });
    await Future.delayed(const Duration(milliseconds: 900));
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
        // Sub-tab Switcher
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
                            widget.isEnglish ? "Two Pointers Quiz" : "টু-পয়েন্টার কুইজ",
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
                      widget.isEnglish ? "Array Reversal Test Runner" : "অ্যারে রিভার্সাল টেস্ট রানার",
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
                          : (widget.isEnglish ? "Run All Tests" : "সব টেস্ট রান করুন"),
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
                    ? "Verify two-pointer in-place reversal logic against odd, even, single, negative, and small array cases."
                    : "বেজোড়, জোড়, সিঙ্গেল-ইলিমেন্ট ও নেগেটিভ বিভিন্ন অ্যারে কেসে ইন-প্লেস রিভার্সাল লজিক টেস্ট করুন।",
                style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
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
                        "Expected Reversed: ${tc.expectedOutputStr}",
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

  Widget _buildQuizSection() {
    final totalQ = _quizQuestions.length;
    final answeredCount = _selectedAnswers.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                      widget.isEnglish ? "Two-Pointer Reversal Mastery Quiz" : "টু-পয়েন্টার রিভার্সাল মাস্টার কুইজ",
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
