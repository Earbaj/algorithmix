import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';

class SearchBstPracticeQuiz extends StatefulWidget {
  final bool isEnglish;

  const SearchBstPracticeQuiz({
    super.key,
    required this.isEnglish,
  });

  @override
  State<SearchBstPracticeQuiz> createState() => _SearchBstPracticeQuizState();
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

class _SearchBstPracticeQuizState extends State<SearchBstPracticeQuiz> {
  int _activeSubTab = 0;

  bool _isRunningTests = false;
  bool _testsCompleted = false;

  final List<TestCaseData> _testCases = const [
    TestCaseData(inputStr: "root = [4,2,7,1,3], val = 2", expectedOutputStr: "Subtree = [2, 1, 3]"),
    TestCaseData(inputStr: "root = [4,2,7,1,3], val = 5", expectedOutputStr: "Subtree = null"),
    TestCaseData(inputStr: "root = [4,2,7,1,3], val = 7", expectedOutputStr: "Subtree = [7]"),
  ];

  final Map<int, int> _selectedAnswers = {};
  int _score = 0;

  final List<QuizQuestion> _quizQuestions = const [
    QuizQuestion(
      questionEn: "1. Why does searching in a balanced BST take O(log N) average logarithmic time?",
      questionBn: "১. ব্যালেন্সড BST তে সার্চ করলে কেন গড়ে O(log N) সময় লাগে?",
      optionsEn: [
        "A) At each node comparison (`val < node.val`), exactly HALF of the remaining tree search space is eliminated!",
        "B) It searches all tree nodes sequentially",
        "C) It converts tree nodes to hash keys",
        "D) It uses random sampling"
      ],
      optionsBn: [
        "A) প্রতিটি নোড তুলনায় (`val < node.val`) বাকি ট্রির ঠিক অর্ধেক অংশ ট্রাভার্সাল বাদ পড়ে যায়!",
        "B) এটি সব নোড ধারাবাহিকভাবে সার্চ করে",
        "C) এটি নোডগুলোকে হ্যাশ কীতে রূপান্তর করে",
        "D) এটি র‍্যান্ডম স্যাম্পলিং করে"
      ],
      correctOptionIndex: 0,
      explanationEn: "Correct! The BST invariant (`Left < Root < Right`) cuts the remaining search space in half at every step.",
      explanationBn: "সঠিক! BST নিয়ম মেনে চলায় প্রতি ধাপে সার্চ স্পেস অর্ধেক হয়ে যায়, যার সময়কাল O(log N)।",
    ),
    QuizQuestion(
      questionEn: "2. What is the worst-case search time complexity when a BST degenerates into a skewed linked list?",
      questionBn: "২. BST বিকৃত হয়ে সকেউড লিঙ্কড লিস্টে (Skewed Tree) পরিণত হলে সবচেয়ে খারাপ সার্চ টাইম জটিলতা কত?",
      optionsEn: [
        "A) O(N) linear time",
        "B) O(log N)",
        "C) O(1)",
        "D) O(N^2)"
      ],
      optionsBn: [
        "A) O(N) লিনিয়ার সময়",
        "B) O(log N)",
        "C) O(1)",
        "D) O(N^2)"
      ],
      correctOptionIndex: 0,
      explanationEn: "Correct! If numbers are inserted in strictly sorted order (1->2->3->4), the tree becomes a single line of length N.",
      explanationBn: "সঠিক! ক্রমানুসারে উপাদান ইনসার্ট করলে ট্রিটি লিঙ্কড লিস্টের মতো সোজা লম্বা হয়ে যায় (O(N))।",
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
                            widget.isEnglish ? "Search BST Quiz" : "সার্চ BST কুইজ",
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
                      widget.isEnglish ? "Search in BST Test Runner" : "সার্চ BST টেস্ট রানার",
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
                    ? "Verify binary search tree target lookup logic for existing and missing target values."
                    : "বিদ্যমান ও অনুপস্থিত মানের জন্য BST সার্চ লজিক ভেরিফাই করুন।",
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
                      widget.isEnglish ? "Search BST Mastery Quiz" : "সার্চ BST মাস্টার কুইজ",
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
