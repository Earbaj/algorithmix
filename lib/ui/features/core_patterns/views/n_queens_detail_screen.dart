import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class NQueensStep {
  final int row;
  final int col;
  final List<String> board;
  final Set<int> cols;
  final Set<int> diag1; // r - c
  final Set<int> diag2; // r + c
  final List<List<String>> allSolutions;
  final String decision; // 'init', 'place_queen', 'conflict_detected', 'n_queens_placed', 'backtrack'
  final int activeLine;
  final String actionEn;
  final String actionBn;
  final String reasonEn;
  final String reasonBn;
  final int callStackDepth;

  const NQueensStep({
    required this.row,
    required this.col,
    required this.board,
    required this.cols,
    required this.diag1,
    required this.diag2,
    required this.allSolutions,
    required this.decision,
    required this.activeLine,
    required this.actionEn,
    required this.actionBn,
    required this.reasonEn,
    required this.reasonBn,
    required this.callStackDepth,
  });
}

class NQueensDetailScreen extends StatefulWidget {
  const NQueensDetailScreen({super.key});

  @override
  State<NQueensDetailScreen> createState() => _NQueensDetailScreenState();
}

class _NQueensDetailScreenState extends State<NQueensDetailScreen>
    with SingleTickerProviderStateMixin {
  bool _isEnglish = true;
  late TabController _tabController;

  // Custom Input State
  int _n = 4;
  List<NQueensStep> _steps = [];

  // Playback Control
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  // Code Language Selector
  String _selectedCodeLang = "C++";

  // Tab 2 Animation Model Selector (0: Step Flowcard, 1: Attack Field Guide, 2: Solutions Count)
  int _animationModelIndex = 0;
  int _flowStepIndex = 0;

  // Practice Mode State
  List<List<String>> _practiceBoard = [];
  Set<int> _practiceCols = {};
  Set<int> _practiceDiag1 = {};
  Set<int> _practiceDiag2 = {};
  List<List<String>> _practiceResults = [];
  List<String> _practiceHistory = [];
  String _userFeedbackEn = "Tap chessboard cells to place N queens without any attack conflicts!";
  String _userFeedbackBn = "কোনো আক্রমণ দ্বন্দ্ব ছাড়া N টি কুইন বসাতে দাবাবোর্ডের সেলে স্পর্শ করুন!";
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

    _steps = _generateSteps(_n);

    // Reset practice mode
    _resetPracticeBoard();
  }

  void _resetPracticeBoard() {
    _practiceBoard = List.generate(_n, (_) => List.generate(_n, (_) => "."));
    _practiceCols = {};
    _practiceDiag1 = {};
    _practiceDiag2 = {};
    _practiceResults = [];
    _practiceHistory = [];
    _practiceSolved = false;
    _userFeedbackEn = "Tap chessboard cells to place $_n queens without any attack conflicts!";
    _userFeedbackBn = "কোনো আক্রমণ দ্বন্দ্ব ছাড়া $_n টি কুইন বসাতে দাবাবোর্ডের সেলে স্পর্শ করুন!";
  }

  List<NQueensStep> _generateSteps(int size) {
    List<NQueensStep> steps = [];
    List<List<String>> solutions = [];
    List<List<String>> board = List.generate(size, (_) => List.generate(size, (_) => "."));

    Set<int> cols = {};
    Set<int> diag1 = {};
    Set<int> diag2 = {};

    List<String> boardToStrings(List<List<String>> b) {
      return b.map((row) => row.join('')).toList();
    }

    // Step 0: Init
    steps.add(NQueensStep(
      row: 0,
      col: 0,
      board: boardToStrings(board),
      cols: {},
      diag1: {},
      diag2: {},
      allSolutions: [],
      decision: "init",
      activeLine: 1,
      actionEn: "Line 1: Initialize $size-Queens puzzle on $size x $size chessboard.",
      actionBn: "লাইন ১: $size x $size দাবাবোর্ডে $size-Queens সমস্যা সমাধান শুরু।",
      reasonEn: "We place 1 queen per row while tracking attacked columns, main diagonals (r-c), and anti-diagonals (r+c).",
      reasonBn: "কলাম, প্রধান ডায়াগোনাল (r-c) এবং অ্যান্টি-ডায়াগোনাল (r+c) ট্র্যাক রেখে প্রতি সারিতে ১টি কুইন বসানো হবে।",
      callStackDepth: 0,
    ));

    void backtrack(int r, int depth) {
      if (r == size) {
        solutions.add(boardToStrings(board));
        steps.add(NQueensStep(
          row: r - 1,
          col: size - 1,
          board: boardToStrings(board),
          cols: Set.from(cols),
          diag1: Set.from(diag1),
          diag2: Set.from(diag2),
          allSolutions: List.from(solutions),
          decision: "n_queens_placed",
          activeLine: 3,
          actionEn: "🎉 Line 3: All $size Queens Successfully Placed! Saved Solution #${solutions.length}.",
          actionBn: "🎉 লাইন ৩: সমস্ত $size টি কুইন সফলভাবে বসানো হয়েছে! সমাধান #${solutions.length} সংরক্ষিত।",
          reasonEn: "Valid non-attacking placement configuration achieved.",
          reasonBn: "পরস্পরকে আক্রমণ না করা সম্পূর্ণ বৈধ কুইন বিন্যাস অর্জিত।",
          callStackDepth: depth,
        ));
        return;
      }

      for (int c = 0; c < size; c++) {
        int d1 = r - c;
        int d2 = r + c;

        if (cols.contains(c) || diag1.contains(d1) || diag2.contains(d2)) {
          steps.add(NQueensStep(
            row: r,
            col: c,
            board: boardToStrings(board),
            cols: Set.from(cols),
            diag1: Set.from(diag1),
            diag2: Set.from(diag2),
            allSolutions: List.from(solutions),
            decision: "conflict_detected",
            activeLine: 7,
            actionEn: "🛑 Line 7: Conflict at cell ($r, $c)! (Col: ${cols.contains(c)}, Diag1: ${diag1.contains(d1)}, Diag2: ${diag2.contains(d2)}).",
            actionBn: "🛑 লাইন ৭: সেল ($r, $c) এ আক্রমণ দ্বন্দ্ব ধরা পড়েছে! (Col, Diag1 বা Diag2 আক্রান্ত)।",
            reasonEn: "Another queen is attacking column $c or diagonals (r-c = $d1, r+c = $d2).",
            reasonBn: "অন্য একটি কুইন কলাম $c বা ডায়াগোনাল (r-c = $d1, r+c = $d2) এ আক্রমণ করছে।",
            callStackDepth: depth,
          ));
          continue;
        }

        // Place queen
        board[r][c] = "Q";
        cols.add(c);
        diag1.add(d1);
        diag2.add(d2);

        steps.add(NQueensStep(
          row: r,
          col: c,
          board: boardToStrings(board),
          cols: Set.from(cols),
          diag1: Set.from(diag1),
          diag2: Set.from(diag2),
          allSolutions: List.from(solutions),
          decision: "place_queen",
          activeLine: 9,
          actionEn: "♛ Line 9: Placed Queen at ($r, $c). Recurse for row ${r + 1}.",
          actionBn: "♛ লাইন ৯: সেল ($r, $c) এ কুইন স্থাপন। সারি ${r + 1} এর জন্য রিকার্সন শুরু।",
          reasonEn: "No conflicts. Mark column and diagonals attacked and proceed to row ${r + 1}.",
          reasonBn: "কোনো দ্বন্দ্ব নেই। কলাম ও ডায়াগোনাল আক্রান্ত হিসেবে মার্ক করে সারি ${r + 1} এ যান।",
          callStackDepth: depth + 1,
        ));

        backtrack(r + 1, depth + 1);

        // Backtrack
        board[r][c] = ".";
        cols.remove(c);
        diag1.remove(d1);
        diag2.remove(d2);

        steps.add(NQueensStep(
          row: r,
          col: c,
          board: boardToStrings(board),
          cols: Set.from(cols),
          diag1: Set.from(diag1),
          diag2: Set.from(diag2),
          allSolutions: List.from(solutions),
          decision: "backtrack",
          activeLine: 11,
          actionEn: "Line 11: Backtrack ↩️ Removed Queen from ($r, $c).",
          actionBn: "লাইন ১১: ব্যাকট্র্যাক ↩️ সেল ($r, $c) থেকে কুইন অপসারণ।",
          reasonEn: "Unmark column and diagonals to explore next column choice in row $r.",
          reasonBn: "সারি $r এর পরবর্তী কলাম বিকল্প পরীক্ষার জন্য মার্কারগুলো মুক্ত করুন।",
          callStackDepth: depth,
        ));
      }
    }

    backtrack(0, 0);

    // Final Step
    steps.add(NQueensStep(
      row: size - 1,
      col: size - 1,
      board: boardToStrings(board),
      cols: {},
      diag1: {},
      diag2: {},
      allSolutions: List.from(solutions),
      decision: "n_queens_placed",
      activeLine: 13,
      actionEn: "🎉 Line 13: Backtracking Complete! Generated total ${solutions.length} distinct solutions for $size-Queens!",
      actionBn: "🎉 লাইন ১৩: ব্যাকট্র্যাকিং সম্পূর্ণ! $size-Queens এর মোট ${solutions.length} টি স্বতন্ত্র সমাধান তৈরি সম্পন্ন!",
      reasonEn: "All $size x $size placement trees fully searched.",
      reasonBn: "সমস্ত $size x $size কুইন বিন্যাস অনুসন্ধান সম্পন্ন হয়েছে।",
      callStackDepth: 0,
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

  int _calculateSolutionsCount(int size) {
    if (size == 4) return 2;
    if (size == 5) return 10;
    if (size == 6) return 4;
    return 2;
  }

  void _handlePracticeCellTap(int r, int c) {
    if (_practiceSolved) return;

    int d1 = r - c;
    int d2 = r + c;
    bool isQueen = _practiceBoard[r][c] == "Q";

    setState(() {
      if (isQueen) {
        // Remove queen
        _practiceBoard[r][c] = ".";
        _practiceCols.remove(c);
        _practiceDiag1.remove(d1);
        _practiceDiag2.remove(d2);
        _practiceHistory.add("REMOVE ($r, $c)");
        _userFeedbackEn = "↩️ Removed Queen from ($r, $c).";
        _userFeedbackBn = "↩️ সেল ($r, $c) থেকে কুইন অপসারণ করা হলো।";
      } else {
        // Check conflict
        if (_practiceCols.contains(c) || _practiceDiag1.contains(d1) || _practiceDiag2.contains(d2)) {
          _userFeedbackEn = "🛑 Conflict at ($r, $c)! Column, main diagonal, or anti-diagonal is attacked!";
          _userFeedbackBn = "🛑 সেল ($r, $c) এ আক্রমণ দ্বন্দ্ব! কলাম বা ডায়াগোনাল ইতিমধ্যেই আক্রান্ত!";
          return;
        }

        // Place queen
        _practiceBoard[r][c] = "Q";
        _practiceCols.add(c);
        _practiceDiag1.add(d1);
        _practiceDiag2.add(d2);
        _practiceHistory.add("PLACE ($r, $c)");
        _userFeedbackEn = "♛ Placed Queen at ($r, $c)! Queens placed: ${_practiceCols.length} / $_n.";
        _userFeedbackBn = "♛ সেল ($r, $c) এ কুইন স্থাপন! কুইন বসানো হয়েছে: ${_practiceCols.length} / $_n।";

        // Check full board
        if (_practiceCols.length == _n) {
          List<String> solutionStr = _practiceBoard.map((row) => row.join('')).toList();
          bool exists = _practiceResults.any((s) => s.join('') == solutionStr.join(''));

          int targetTotal = _calculateSolutionsCount(_n);

          if (!exists) {
            _practiceResults.add(solutionStr);
            _userFeedbackEn = "🎉 Valid Solution #${_practiceResults.length} Discovered! (${_practiceResults.length} / $targetTotal)";
            _userFeedbackBn = "🎉 বৈধ সমাধান #${_practiceResults.length} আবিষ্কৃত! (${_practiceResults.length} / $targetTotal)";
          } else {
            _userFeedbackEn = "ℹ️ Solution was already discovered. Try another queen arrangement!";
            _userFeedbackBn = "ℹ️ সমাধানটি ইতিমধ্যেই সংগৃহীত হয়েছে। অন্য কুইন বিন্যাস চেষ্টা করুন!";
          }

          if (_practiceResults.length >= targetTotal) {
            _practiceSolved = true;
            _userFeedbackEn = "🏆 MASTERED! You found all $targetTotal distinct solutions for $_n-Queens!";
            _userFeedbackBn = "🏆 দারুণ! আপনি $_n-Queens এর সবকটি $targetTotal টি স্বতন্ত্র সমাধান বের করে ফেলেছেন!";
          }
        }
      }
    });
  }

  void _undoPracticeMove() {
    if (_practiceHistory.isNotEmpty) {
      setState(() {
        _practiceHistory.removeLast();
        _resetPracticeBoard();
        _userFeedbackEn = "↩️ Reset practice board for new move.";
        _userFeedbackBn = "↩️ নতুন মুভের জন্য বোর্ড রিসেট করা হলো।";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final hPadding = Responsive.horizontalPadding(context);

    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      appBar: AppBar(
        title: Text(
          '51. N-Queens',
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
                    "51. N-Queens",
                    style: TextStyle(fontSize: Responsive.sp(context, 22), fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.accentPink.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.accentPink),
                  ),
                  child: const Text("Hard", style: TextStyle(color: AppTheme.accentPink, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              children: ["Meta", "Amazon", "Microsoft", "Google", "Apple", "Uber"].map((company) {
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
                        ? "The n-queens puzzle is the problem of placing n queens on an n x n chessboard such that no two queens attack each other. Given an integer n, return all distinct solutions to the n-queens puzzle."
                        : "n-queens সমস্যা হলো একটি n x n দাবাবোর্ডে n টি কুইন বসানো যাতে কোনো দুটি কুইন একে অপরকে আক্রমণ না করে। n এর জন্য সমস্ত ভিন্ন ভিন্ন সমাধান রিটার্ন করুন।",
                    style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Examples
            Text(_isEnglish ? "Examples" : "উদাহরণসমূহ", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            _buildExampleCard("Example 1", "n = 4", 'Output: [[".Q..","...Q","Q...","..Q."],["..Q.","Q...","...Q",".Q.."]]'),
            _buildExampleCard("Example 2", "n = 1", 'Output: [["Q"]]'),
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
                        _isEnglish ? "Key Intuition (Row Placement + 3 Conflict Sets)" : "মূল আইডিয়া (সারি অনুযায়ী বসানো + ৩টি দ্বন্দ্ব সেট)",
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isEnglish
                        ? "1. Place queens row-by-row (row = 0 to n-1).\n2. Maintain 3 hash sets to check conflicts in O(1) time:\n   - Column set: col\n   - Main diagonal set: row - col\n   - Anti-diagonal set: row + col"
                        : "১. সারি অনুযায়ী কুইন বসান (row = 0 থেকে n-1)।\n২. O(1) সময়ে আক্রমণ দ্বন্দ্ব চেক করতে ৩টি সেট বজায় রাখুন:\n   - কলাম সেট: col\n   - প্রধান ডায়াগোনাল: row - col\n   - অ্যান্টি-ডায়াগোনাল: row + col",
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
              _isEnglish ? "N-Queens Visual Models (Concept Explanations)" : "N-Queens ভিজ্যুয়াল মডেলসমূহ (কোডহীন গাইড)",
              style: TextStyle(fontSize: Responsive.sp(context, 18), fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 6),
            Text(
              _isEnglish
                  ? "Explore 3 interactive models for N = 4 board."
                  : "N = 4 বোর্ডের জন্য ৩টি ইন্টারঅ্যাক্টিভ ভিজ্যুয়াল মডেল পর্যবেক্ষণ করুন।",
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 16),

            // Model Switcher Segmented Control
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildAnimationModelChip(0, _isEnglish ? "1. 🪜 Step Flowcard" : "১. 🪜 স্টেপ-বাই-স্টেপ ফ্লো-কার্ড"),
                  _buildAnimationModelChip(1, _isEnglish ? "2. ⚔️ Attack Field Guide" : "২. ⚔️ ডায়াগোনাল ও কলাম অ্যাটাক ফিল্ড"),
                  _buildAnimationModelChip(2, _isEnglish ? "3. ♛ Solutions Count Table" : "৩. ♛ সমাধান সংখ্যা তালিকা"),
                ],
              ),
            ),
            const SizedBox(height: 20),

            if (_animationModelIndex == 0) _buildStepFlowcardModel(),
            if (_animationModelIndex == 1) _buildAttackFieldGuideModel(),
            if (_animationModelIndex == 2) _buildSolutionsCountModel(),

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
        "row": 0,
        "col": 1,
        "badge": "♛ PLACE (0, 1)",
        "badgeColor": AppTheme.accentNeonCyan,
        "titleEn": "Step 1: Place Queen at (0, 1) in Row 0",
        "titleBn": "ধাপ ১: সারি ০ এর সেল (0, 1) এ কুইন স্থাপন",
        "descEn": "Mark column 1, main diag (0-1 = -1), anti-diag (0+1 = 1) attacked.",
        "descBn": "কলাম 1, ডায়াগোনাল 1 (-1), অ্যান্টি-ডায়াগোনাল (1) আক্রান্ত মার্ক।",
      },
      {
        "step": 2,
        "row": 1,
        "col": 3,
        "badge": "♛ PLACE (1, 3)",
        "badgeColor": AppTheme.accentAmber,
        "titleEn": "Step 2: Place Queen at (1, 3) in Row 1",
        "titleBn": "ধাপ ২: সারি ১ এর সেল (1, 3) এ কুইন স্থাপন",
        "descEn": "Cols (0, 1, 2) in Row 1 were attacked! Place at (1, 3).",
        "descBn": "সারি ১ এর কলাম (0, 1, 2) আক্রান্ত ছিল! (1, 3) এ কুইন বসানো হলো।",
      },
      {
        "step": 3,
        "row": 2,
        "col": 0,
        "badge": "♛ PLACE (2, 0)",
        "badgeColor": AppTheme.accentAmber,
        "titleEn": "Step 3: Place Queen at (2, 0) in Row 2",
        "titleBn": "ধাপ ৩: সারি ২ এর সেল (2, 0) এ কুইন স্থাপন",
        "descEn": "No conflicts at (2, 0). Proceed to Row 3.",
        "descBn": "সেল (2, 0) এ কোনো দ্বন্দ্ব নেই। সারি ৩ এ যান।",
      },
      {
        "step": 4,
        "row": 3,
        "col": 2,
        "badge": "🎉 SAVED SOLUTION 1",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 4: Place Queen at (3, 2) ➔ Saved Solution 1!",
        "titleBn": "ধাপ ৪: সেল (3, 2) এ কুইন ➔ সমাধান ১ সংরক্ষিত!",
        "descEn": "All 4 Queens placed on 4x4 board: [\".Q..\", \"...Q\", \"Q...\", \"..Q.\"]!",
        "descBn": "৪x৪ বোর্ডে ৪টি কুইন বসানো সম্পন্ন: [\".Q..\", \"...Q\", \"Q...\", \"..Q.\"]!",
      },
      {
        "step": 5,
        "row": 0,
        "col": 2,
        "badge": "♛ PLACE (0, 2)",
        "badgeColor": AppTheme.accentPurple,
        "titleEn": "Step 5: Backtrack & Place Queen at (0, 2) in Row 0",
        "titleBn": "ধাপ ৫: ব্যাকট্র্যাক ও সারি ০ এর সেল (0, 2) এ কুইন স্থাপন",
        "descEn": "Explore second distinct solution branch.",
        "descBn": "দ্বিতীয় স্বতন্ত্র সমাধান ডালপালা পর্যবেক্ষণ।",
      },
      {
        "step": 6,
        "row": 3,
        "col": 1,
        "badge": "🎉 SAVED SOLUTION 2",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 6: Saved Solution 2!",
        "titleBn": "ধাপ ৬: সমাধান ২ সংরক্ষিত!",
        "descEn": "Saved second valid configuration: [\"..Q.\", \"Q...\", \"...Q\", \".Q..\"]!",
        "descBn": "দ্বিতীয় বৈধ কুইন কনফিগারেশন সংরক্ষিত: [\"..Q.\", \"Q...\", \"...Q\", \".Q..\"]!",
      },
      {
        "step": 7,
        "row": 3,
        "col": 3,
        "badge": "🏆 FINISHED",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 7: Traversal Complete! Total 2 Distinct Solutions",
        "titleBn": "ধাপ ৭: ব্যাকট্র্যাকিং সম্পূর্ণ! মোট ২টি স্বতন্ত্র সমাধান",
        "descEn": "Found all 2 distinct solutions for 4-Queens puzzle!",
        "descBn": "4-Queens সমস্যার সমস্ত ২টি সমাধান পাওয়া গেছে!",
      },
    ];

    final currentStep = stepFlowData[_flowStepIndex.clamp(0, stepFlowData.length - 1)];
    final int r = currentStep["row"] as int;
    final int c = currentStep["col"] as int;
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
                _isEnglish ? "1. Step-by-Step N-Queens Flowcard" : "১. স্টেপ-বাই-স্টেপ N-Queens ফ্লো-কার্ড",
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
                ? "Watch row-by-row queen placement and conflict backtracking."
                : "সারি অনুযায়ী কুইন বসানো এবং ব্যাকট্র্যাকিং দেখুন।",
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

                // Active Placement Box
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Cell: ($r, $c)", style: TextStyle(color: badgeColor, fontWeight: FontWeight.bold, fontSize: 12)),
                    Text("Board Size: 4 x 4", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
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

  // MODEL 2: Attack Field Guide
  Widget _buildAttackFieldGuideModel() {
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
            _isEnglish ? "2. Diagonal & Column Attack Field Formulas" : "২. ডায়াগোনাল ও কলাম আক্রমণ ক্ষেত্র সূত্র",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            _isEnglish
                ? "3 formulas for O(1) conflict checking:\n1. Column: col\n2. Main Diagonal: row - col\n3. Anti-Diagonal: row + col"
                : "O(1) সময়ে আক্রমণ দ্বন্দ্ব চেকের ৩টি সূত্র:\n১. কলাম: col\n২. প্রধান ডায়াগোনাল: row - col\n৩. অ্যান্টি-ডায়াগোনাল: row + col",
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
              "if (cols.count(c) || diag1.count(r-c) || diag2.count(r+c)) continue; 🛑",
              style: TextStyle(fontFamily: 'monospace', fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.accentPink),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  // MODEL 3: Solutions Count Table
  Widget _buildSolutionsCountModel() {
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
            _isEnglish ? "3. N-Queens Solutions Count Table" : "৩. N-Queens সমাধান সংখ্যা তালিকা",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            _isEnglish
                ? "Total valid distinct solutions for different board sizes N:"
                : "বিভিন্ন বোর্ড সাইজ N এর জন্য মোট অনন্য সমাধান সংখ্যা:",
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
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
              "N = 1 ➔ 1 solution\nN = 4 ➔ 2 solutions 🎉\nN = 5 ➔ 10 solutions\nN = 8 ➔ 92 solutions",
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
          // Input Box & Board Size Selector
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF1E293B)),
            ),
            child: Row(
              children: [
                Text(
                  _isEnglish ? "Board Size N:" : "বোর্ড সাইজ N:",
                  style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(width: 14),
                DropdownButton<int>(
                  value: _n,
                  dropdownColor: const Color(0xFF090D16),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                  items: [4, 5, 6].map((size) {
                    return DropdownMenuItem(value: size, child: Text("$size x $size"));
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _n = val;
                        _rebuildSteps();
                      });
                    }
                  },
                ),
                const Spacer(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentNeonCyan,
                    foregroundColor: AppTheme.primaryDark,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  onPressed: () => setState(() => _rebuildSteps()),
                  child: Text(_isEnglish ? "Re-Run" : "পুনরায় রান"),
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
                  _buildNQueensCanvas(step),
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildCodeHighlightBox(step.activeLine)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildNQueensCanvas(step)),
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
    final targetTotal = _calculateSolutionsCount(_n);

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
                  ? "Place $_n queens on $_n x $_n board by tapping cells without causing conflicts!"
                  : "কোনো আক্রমণ ছাড়াই সেলে স্পর্শ করে $_n x $_n বোর্ডে $_n টি কুইন স্থাপন করুন!",
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 16),

            // Progress Score Bar
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.accentNeonCyan.withOpacity(0.4)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _isEnglish ? "Discovered: ${_practiceResults.length} / $targetTotal Solutions" : "সংগৃহীত: ${_practiceResults.length} / $targetTotal টি সমাধান",
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      Text(
                        "${((_practiceResults.length / targetTotal) * 100).clamp(0, 100).toInt()}%",
                        style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: targetTotal == 0 ? 0.0 : (_practiceResults.length / targetTotal).clamp(0.0, 1.0),
                      backgroundColor: AppTheme.primaryDark,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.accentGreen),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
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

            // Practice Board Grid
            Center(
              child: Container(
                width: Responsive.isMobile(context) ? 280 : 320,
                height: Responsive.isMobile(context) ? 280 : 320,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.accentPurple, width: 2),
                ),
                child: Column(
                  children: List.generate(_n, (r) {
                    return Expanded(
                      child: Row(
                        children: List.generate(_n, (c) {
                          bool isDarkCell = (r + c) % 2 == 1;
                          bool hasQueen = _practiceBoard[r][c] == "Q";
                          bool isAttacked = _practiceCols.contains(c) ||
                              _practiceDiag1.contains(r - c) ||
                              _practiceDiag2.contains(r + c);

                          return Expanded(
                            child: GestureDetector(
                              onTap: () => _handlePracticeCellTap(r, c),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: hasQueen
                                      ? AppTheme.accentGreen.withOpacity(0.4)
                                      : (isAttacked && !hasQueen
                                          ? AppTheme.accentPink.withOpacity(0.2)
                                          : (isDarkCell ? const Color(0xFF1E293B) : const Color(0xFF0F172A))),
                                  border: Border.all(color: const Color(0xFF334155), width: 0.5),
                                ),
                                child: Center(
                                  child: hasQueen
                                      ? const Text("♛", style: TextStyle(fontSize: 24, color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold))
                                      : (isAttacked ? const Text("❌", style: TextStyle(fontSize: 12, color: AppTheme.accentPink)) : null),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (_practiceHistory.isNotEmpty)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  icon: const Icon(Icons.undo, size: 16, color: AppTheme.accentAmber),
                  label: Text(_isEnglish ? "Reset Board" : "বোর্ড রিসেট", style: const TextStyle(color: AppTheme.accentAmber, fontSize: 12)),
                  onPressed: _undoPracticeMove,
                ),
              ),

            const SizedBox(height: 20),

            // Discovered Solutions List
            Text(
              _isEnglish
                  ? "Collected Valid Solutions (${_practiceResults.length} / $targetTotal):"
                  : "সংগৃহীত বৈধ সমাধানসমূহ (${_practiceResults.length} / $targetTotal):",
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF090D16),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF1E293B)),
              ),
              child: _practiceResults.isEmpty
                ? const Text("[ No Solutions Discovered Yet ]", style: TextStyle(color: AppTheme.textMuted, fontSize: 12))
                : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _practiceResults.map((sol) {
                      return Chip(
                        backgroundColor: AppTheme.surfaceDark,
                        avatar: const Icon(Icons.check_circle, color: AppTheme.accentGreen, size: 16),
                        label: Text(
                          "[ ${sol.join(', ')} ]",
                          style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 11),
                        ),
                      );
                    }).toList(),
                  ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // Helper Widgets
  Widget _buildCodeHighlightBox(int activeLine) {
    final codeLines = [
      "void backtrack(int r, int n, vector<string>& board, vector<vector<string>>& res) {",
      "    if (r == n) {",
      "        res.push_back(board); // All N queens placed!",
      "        return;",
      "    }",
      "    for (int c = 0; c < n; c++) {",
      "        if (cols.count(c) || diag1.count(r-c) || diag2.count(r+c)) continue;",
      "        board[r][c] = 'Q';",
      "        cols.insert(c); diag1.insert(r-c); diag2.insert(r+c);",
      "        backtrack(r + 1, n, board, res);",
      "        board[r][c] = '.';",
      "        cols.erase(c); diag1.erase(r-c); diag2.erase(r+c);",
      "    }",
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

  Widget _buildNQueensCanvas(NQueensStep step) {
    Color decisionColor = AppTheme.accentPurple;
    String decisionLabel = "INIT";

    if (step.decision == "place_queen") {
      decisionColor = AppTheme.accentNeonCyan;
      decisionLabel = "♛ PLACE QUEEN";
    } else if (step.decision == "conflict_detected") {
      decisionColor = AppTheme.accentPink;
      decisionLabel = "🛑 CONFLICT";
    } else if (step.decision == "n_queens_placed") {
      decisionColor = AppTheme.accentGreen;
      decisionLabel = "🎉 N QUEENS PLACED";
    } else if (step.decision == "backtrack") {
      decisionColor = AppTheme.accentAmber;
      decisionLabel = "↩️ BACKTRACK";
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
              Text("row = [${step.row}], col = [${step.col}]", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13)),
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

          // Live Chessboard Grid Display
          Center(
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: decisionColor, width: 2),
              ),
              child: Column(
                children: List.generate(_n, (r) {
                  return Expanded(
                    child: Row(
                      children: List.generate(_n, (c) {
                        bool isDarkCell = (r + c) % 2 == 1;
                        bool hasQueen = false;
                        if (r < step.board.length && c < step.board[r].length) {
                          hasQueen = step.board[r][c] == "Q";
                        }
                        bool isCurrentCell = (r == step.row && c == step.col);

                        return Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: isCurrentCell
                                  ? decisionColor.withOpacity(0.4)
                                  : (hasQueen
                                      ? AppTheme.accentGreen.withOpacity(0.4)
                                      : (isDarkCell ? const Color(0xFF1E293B) : const Color(0xFF0F172A))),
                              border: Border.all(color: const Color(0xFF334155), width: 0.5),
                            ),
                            child: Center(
                              child: hasQueen
                                  ? const Text("♛", style: TextStyle(fontSize: 18, color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold))
                                  : null,
                            ),
                          ),
                        );
                      }),
                    ),
                  );
                }),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Saved Solutions List
          const Text("Saved Distinct Solutions:", style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 80, maxHeight: 180),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF1E293B)),
            ),
            child: step.allSolutions.isEmpty
                ? const Center(child: Text("[ No Solutions Saved Yet ]", style: TextStyle(color: AppTheme.textMuted, fontSize: 12)))
                : SingleChildScrollView(
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: step.allSolutions.map((sol) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppTheme.accentGreen.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppTheme.accentGreen),
                          ),
                          child: Text(
                            "[ ${sol.join(', ')} ]",
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                          ),
                        );
                      }).toList(),
                    ),
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
    unordered_set<int> cols, diag1, diag2;

    void backtrack(int r, int n, vector<string>& board, vector<vector<string>>& res) {
        if (r == n) {
            res.push_back(board);
            return;
        }
        for (int c = 0; c < n; c++) {
            if (cols.count(c) || diag1.count(r - c) || diag2.count(r + c)) continue;
            board[r][c] = 'Q';
            cols.insert(c); diag1.insert(r - c); diag2.insert(r + c);
            backtrack(r + 1, n, board, res);
            board[r][c] = '.';
            cols.erase(c); diag1.erase(r - c); diag2.erase(r + c);
        }
    }

    vector<vector<string>> solveNQueens(int n) {
        vector<vector<string>> res;
        vector<string> board(n, string(n, '.'));
        backtrack(0, n, board, res);
        return res;
    }
};""";
    } else if (lang == "Java") {
      code = """
class Solution {
    private Set<Integer> cols = new HashSet<>();
    private Set<Integer> diag1 = new HashSet<>();
    private Set<Integer> diag2 = new HashSet<>();

    public List<List<String>> solveNQueens(int n) {
        List<List<String>> res = new ArrayList<>();
        char[][] board = new char[n][n];
        for (int i = 0; i < n; i++) Arrays.fill(board[i], '.');
        backtrack(0, n, board, res);
        return res;
    }

    private void backtrack(int r, int n, char[][] board, List<List<String>> res) {
        if (r == n) {
            List<String> sol = new ArrayList<>();
            for (char[] row : board) sol.add(new String(row));
            res.add(sol);
            return;
        }
        for (int c = 0; c < n; c++) {
            if (cols.contains(c) || diag1.contains(r - c) || diag2.contains(r + c)) continue;
            board[r][c] = 'Q';
            cols.add(c); diag1.add(r - c); diag2.add(r + c);
            backtrack(r + 1, n, board, res);
            board[r][c] = '.';
            cols.remove(c); diag1.remove(r - c); diag2.remove(r + c);
        }
    }
}""";
    } else {
      code = """
class Solution:
    def solveNQueens(self, n: int) -> List[List[str]]:
        cols = set()
        diag1 = set()
        diag2 = set()
        res = []
        board = [["."] * n for _ in range(n)]

        def backtrack(r):
            if r == n:
                res.append(["".join(row) for row in board])
                return
            for c in range(n):
                if c in cols or (r - c) in diag1 or (r + c) in diag2:
                    continue
                board[r][c] = "Q"
                cols.add(c); diag1.add(r - c); diag2.add(r + c)
                backtrack(r + 1)
                board[r][c] = "."
                cols.remove(c); diag1.remove(r - c); diag2.remove(r + c)

        backtrack(0)
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
