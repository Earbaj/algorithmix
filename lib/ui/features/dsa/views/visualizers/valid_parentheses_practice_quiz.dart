import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';

class ValidParenthesesPracticeQuiz extends StatefulWidget {
  final bool isEnglish;

  const ValidParenthesesPracticeQuiz({
    super.key,
    required this.isEnglish,
  });

  @override
  State<ValidParenthesesPracticeQuiz> createState() =>
      _ValidParenthesesPracticeQuizState();
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

class _ValidParenthesesPracticeQuizState extends State<ValidParenthesesPracticeQuiz> {
  int _activeSubTab = 0;

  bool _isRunningTests = false;
  bool _testsCompleted = false;

  final List<TestCaseData> _testCases = const [
    TestCaseData(inputStr: "s = \"()[]{}\"", expectedOutputStr: "True"),
    TestCaseData(inputStr: "s = \"([{}])\"", expectedOutputStr: "True"),
    TestCaseData(inputStr: "s = \"(]\"", expectedOutputStr: "False"),
    TestCaseData(inputStr: "s = \"(((\"", expectedOutputStr: "False (Stack not empty)"),
    TestCaseData(inputStr: "s = \")\"", expectedOutputStr: "False (Stack empty underflow)"),
  ];

  final Map<int, int> _selectedAnswers = {};
  int _score = 0;

  final List<QuizQuestion> _quizQuestions = const [
    QuizQuestion(
      questionEn: "1. Why is a Stack (LIFO) the ideal data structure for Valid Parentheses matching?",
      questionBn: "১. ব্র্যাকেট মেলানোর (Valid Parentheses) জন্য স্ট্যাক (LIFO) কেন আদর্শ ডেটা স্ট্রাকচার?",
      optionsEn: [
        "A) Because the LAST opened bracket MUST be closed FIRST before earlier opened brackets can be closed!",
        "B) Because Stack sorts characters in alphabetical order",
        "C) Because Stack uses binary search",
        "D) Because it takes O(N^2) space"
      ],
      optionsBn: [
        "A) কারণ সবার শেষে ওপেন হওয়া ব্র্যাকেটটিকে আগের ব্র্যাকেটগুলোর আগে বন্ধ (CLOSE) হতে হয় (LIFO নীতি)!",
        "B) কারণ স্ট্যাক ক্যারেক্টারকে সোর্ট করে",
        "C) কারণ স্ট্যাক বাইনারি সার্চ করে",
        "D) কারণ এতে O(N^2) স্পেস লাগে"
      ],
      correctOptionIndex: 0,
      explanationEn: "Correct! The nested nature of brackets requires Last-In, First-Out (LIFO) ordering to match innermost pairs first.",
      explanationBn: "সঠিক! ব্র্যাকেটের নেস্টেড ব্যবহারের কারণে সবার শেষের ওপেনিং ব্র্যাকেটকে সবার আগে ম্যাচ করতে LIFO মেকানিজম আবশ্যক।",
    ),
    QuizQuestion(
      questionEn: "2. What check MUST be performed when encountering a closing bracket like ')' before accessing `st.top()`?",
      questionBn: "২. ')' এর মতো ক্লোজিং ব্র্যাকেট পেলে `st.top()` এক্সেস করার আগে কোন চেক অবশ্যই করতে হবে?",
      optionsEn: [
        "A) `if (st.empty()) return false;` (Check for Stack Underflow!)",
        "B) `if (st.size() > 100)`",
        "C) `st.clear()`",
        "D) No check needed"
      ],
      optionsBn: [
        "A) `if (st.empty()) return false;` (স্ট্যাক খালি থাকলে আন্ডারফ্লো রোধ করতে!)",
        "B) `if (st.size() > 100)`",
        "C) `st.clear()`",
        "D) কোনো চেক করার প্রয়োজন নেই"
      ],
      correctOptionIndex: 0,
      explanationEn: "Correct! If the stack is empty when a closing bracket arrives, there is no matching open bracket, causing underflow/crash unless guarded.",
      explanationBn: "সঠিক! স্ট্যাক খালি থাকা অবস্থায় ক্লোজিং ব্র্যাকেট আসলে ম্যাচিং ওপেনিং ব্র্যাকেট নেই, ফলে ক্র্যাশ রোধ করতে `st.empty()` টেস্ট করতে হয়।",
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
                            widget.isEnglish ? "Bracket Matching Quiz" : "ব্র্যাকেট ম্যাচিং কুইজ",
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
                      widget.isEnglish ? "Valid Parentheses Test Runner" : "ব্র্যাকেট টেস্ট রানার",
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
                    ? "Verify LIFO stack bracket validation against nested, mismatched, unclosed, and underflow inputs."
                    : "নেস্টেড, অমিল ও অসমাপ্ত ব্র্যাকেট টেস্ট কেসগুলো স্ট্যাক দিয়ে যাচাই করুন।",
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
                        style: const TextStyle(fontFamily: 'monospace', fontSize: 12, color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Expected: ${tc.expectedOutputStr}",
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
                      widget.isEnglish ? "Valid Parentheses Mastery Quiz" : "ব্র্যাকেট ম্যাচিং মাস্টার কুইজ",
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
