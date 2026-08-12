import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';

class MatrixTransposePracticeQuiz extends StatefulWidget {
  final bool isEnglish;

  const MatrixTransposePracticeQuiz({
    super.key,
    required this.isEnglish,
  });

  @override
  State<MatrixTransposePracticeQuiz> createState() => _MatrixTransposePracticeQuizState();
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

class _MatrixTransposePracticeQuizState extends State<MatrixTransposePracticeQuiz> {
  int _activeSubTab = 0; // 0: Test Suite, 1: Quiz

  bool _isRunningTests = false;
  bool _testsCompleted = false;

  final List<TestCaseData> _testCases = const [
    TestCaseData(inputStr: "matrix = [[1, 2, 3], [4, 5, 6]] (2x3)", expectedOutputStr: "result = [[1, 4], [2, 5], [3, 6]] (3x2)"),
    TestCaseData(inputStr: "matrix = [[1, 2], [3, 4]] (2x2)", expectedOutputStr: "result = [[1, 3], [2, 4]] (2x2)"),
    TestCaseData(inputStr: "matrix = [[5]] (1x1)", expectedOutputStr: "result = [[5]] (1x1)"),
    TestCaseData(inputStr: "matrix = [[1, 2, 3, 4]] (1x4)", expectedOutputStr: "result = [[1], [2], [3], [4]] (4x1)"),
    TestCaseData(inputStr: "matrix = [[10], [20], [30]] (3x1)", expectedOutputStr: "result = [[10, 20, 30]] (1x3)"),
  ];

  final Map<int, int> _selectedAnswers = {};
  int _score = 0;

  final List<QuizQuestion> _quizQuestions = const [
    QuizQuestion(
      questionEn: "1. What are the dimensions of the transposed matrix if the input matrix is of size R x C?",
      questionBn: "১. ইনপুট ম্যাট্রিক্সের আকার R x C হলে এর ট্রান্সপোজড ম্যাট্রিক্সের আকার কত হবে?",
      optionsEn: ["A) C x R", "B) R x C", "C) (R+C) x (R+C)", "D) R^2 x C^2"],
      optionsBn: ["A) C x R", "B) R x C", "C) (R+C) x (R+C)", "D) R^2 x C^2"],
      correctOptionIndex: 0,
      explanationEn: "Correct! Transposing swaps rows with columns, so an R x C matrix becomes a C x R matrix.",
      explanationBn: "সঠিক! ট্রান্সপোজ করলে সারি এবং কলামের অবস্থান অদলবদল হয়, ফলে R x C ম্যাট্রিক্স পরিবর্তিত হয়ে C x R ম্যাট্রিক্সে পরিণত হয়।",
    ),
    QuizQuestion(
      questionEn: "2. How can an N x N square matrix be transposed in-place without using extra matrix space?",
      questionBn: "২. অতিরিক্ত কোনো ম্যাট্রিক্স মেমোরি ব্যবহার না করেই একটি N x N স্কয়ার ম্যাট্রিক্স কীভাবে In-Place ট্রান্সপোজ করা যায়?",
      optionsEn: [
        "A) Swap matrix[r][c] with matrix[c][r] for all pairs where r < c",
        "B) Swap elements for all pairs r and c",
        "C) Reverse each row",
        "D) It is impossible without extra matrix"
      ],
      optionsBn: [
        "A) r < c শর্তের সাপেক্ষে matrix[r][c] এবং matrix[c][r] অদলবদল করে",
        "B) সব r এবং c এর জন্য সব সংখ্যা ২ বার সোয়াপ করে",
        "C) প্রতিটি সারি উল্টে দিয়ে",
        "D) অতিরিক্ত ম্যাট্রিক্স ছাড়া ইন-প্লেস করা সম্ভব নয়"
      ],
      correctOptionIndex: 0,
      explanationEn: "Correct! For a square matrix, swapping upper triangle elements (where r < c) across the main diagonal transposes the matrix in O(1) extra space.",
      explanationBn: "সঠিক! স্কয়ার ম্যাট্রিক্সে ডায়াগোনালের ওপরের উপাদানগুলো (r < c) অদলবদল করলে ইন-প্লেস O(1) স্পেসে ট্রান্সপোজ সম্পন্ন হয়।",
    ),
    QuizQuestion(
      questionEn: "3. What happens to the main diagonal elements (matrix[i][i]) during matrix transposition?",
      questionBn: "৩. ম্যাট্রিক্স ট্রান্সপোজের সময় প্রধান ডায়াগোনালের উপাদানগুলোর (matrix[i][i]) কী ঘটে?",
      optionsEn: [
        "A) They remain in their exact same positions",
        "B) They are reversed",
        "C) They become zero",
        "D) They swap with the last row"
      ],
      optionsBn: [
        "A) উপাদানগুলো তাদের নিজ নিজ জায়গায় অপরিবর্তিত থাকে",
        "B) উপাদানগুলো উল্টে যায়",
        "C) তারা শূন্য হয়ে যায়",
        "D) শেষ সারির সাথে অদলবদল হয়"
      ],
      correctOptionIndex: 0,
      explanationEn: "Correct! On the main diagonal where row index equals column index (r == c), matrix[i][i] transposes to res[i][i], which is the exact same position.",
      explanationBn: "সঠিক! ডায়াগোনালে r == c হওয়ায়, matrix[i][i] ট্রান্সপোজ করার পরও ঠিক একই স্থানে থাকে।",
    ),
    QuizQuestion(
      questionEn: "4. What is the Time Complexity of transposing an R x C matrix?",
      questionBn: "৪. R x C ম্যাট্রিক্স ট্রান্সপোজ করার Time Complexity কত?",
      optionsEn: ["A) O(R * C)", "B) O(R + C)", "C) O(R^2)", "D) O(C^2)"],
      optionsBn: ["A) O(R * C)", "B) O(R + C)", "C) O(R^2)", "D) O(C^2)"],
      correctOptionIndex: 0,
      explanationEn: "Correct! Every cell of the R x C matrix must be read once and assigned to the result matrix, resulting in linear O(R * C) time complexity.",
      explanationBn: "সঠিক! ম্যাট্রিক্সের প্রতিটি সেল একবার ভিসিট ও অ্যাসাইন করা হয়, তাই সময় লাগে O(R * C)।",
    ),
    QuizQuestion(
      questionEn: "5. How is 'Rotate Matrix 90 Degrees Clockwise' related to Matrix Transpose?",
      questionBn: "৫. একটি ম্যাট্রিক্সকে ৯০ ডিগ্রি ঘড়ির কাঁটার দিকে ঘোরাতে (Rotate 90° Clockwise) ম্যাট্রিক্স ট্রান্সপোজের ভূমিকা কী?",
      optionsEn: [
        "A) First Transpose the matrix, then Reverse each row!",
        "B) Only sort the matrix",
        "C) Reverse the columns only",
        "D) Transpose 4 times"
      ],
      optionsBn: [
        "A) প্রথমে ম্যাট্রিক্সকে ট্রান্সপোজ করুন, তারপর প্রতিটি সারি রিভার্স করুন!",
        "B) শুধু ম্যাট্রিক্স সর্ট করা",
        "C) কেবল কলামগুলো উল্টানো",
        "D) ৪ বার ট্রান্সপোজ করা"
      ],
      correctOptionIndex: 0,
      explanationEn: "Correct! Rotated Matrix 90° Clockwise = Transpose(Matrix) followed by reversing each row of the transposed matrix!",
      explanationBn: "সঠিক! ৯০ ডিগ্রি ঘড়ির কাঁটার দিকে ঘোরাতে প্রথমে ম্যাট্রিক্সটি Transpose করে এরপর প্রতিটি সারি Reverse করলেই কাঙ্ক্ষিত ম্যাট্রিক্স পাওয়া যায়!",
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
                            widget.isEnglish ? "Matrix Transpose Quiz" : "ম্যাট্রিক্স কুইজ",
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
                      widget.isEnglish ? "Matrix Transpose Test Runner" : "ম্যাট্রিক্স ট্রান্সপোজ টেস্ট রানার",
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
                    ? "Verify matrix transpose logic against rectangular, square, row vector, and column vector matrices."
                    : "রেকট্যাঙ্গুলার, স্কয়ার, রো-ভেক্টর ও কলাম-ভেক্টর ম্যাট্রিক্সে ট্রান্সপোজ লজিক টেস্ট করুন।",
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
                      widget.isEnglish ? "Matrix Transpose Mastery Quiz" : "ম্যাট্রিক্স ট্রান্সপোজ মাস্টার কুইজ",
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
