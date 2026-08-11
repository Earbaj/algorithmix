import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class SudokuSolverStep {
  final int row;
  final int col;
  final String digit;
  final List<List<String>> board;
  final bool isValid;
  final String decision; // 'init', 'try_digit', 'valid_placement', 'conflict_found', 'board_solved', 'backtrack'
  final int activeLine;
  final String actionEn;
  final String actionBn;
  final String reasonEn;
  final String reasonBn;
  final int callStackDepth;

  const SudokuSolverStep({
    required this.row,
    required this.col,
    required this.digit,
    required this.board,
    required this.isValid,
    required this.decision,
    required this.activeLine,
    required this.actionEn,
    required this.actionBn,
    required this.reasonEn,
    required this.reasonBn,
    required this.callStackDepth,
  });
}

class SudokuSolverDetailScreen extends StatefulWidget {
  const SudokuSolverDetailScreen({super.key});

  @override
  State<SudokuSolverDetailScreen> createState() => _SudokuSolverDetailScreenState();
}

class _SudokuSolverDetailScreenState extends State<SudokuSolverDetailScreen>
    with SingleTickerProviderStateMixin {
  bool _isEnglish = true;
  late TabController _tabController;

  // Preset Sudoku Puzzle (Compact 9x9 or 4x4 for smooth visualization)
  int _selectedPreset = 0; // 0: Easy 9x9, 1: Classic 9x9, 2: 4x4 Mini
  List<List<String>> _initialBoard = [];
  List<SudokuSolverStep> _steps = [];

  // Playback Control
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  // Code Language Selector
  String _selectedCodeLang = "C++";

  // Tab 2 Animation Model Selector (0: Step Flowcard, 1: 3-Way Rule Validation, 2: Sudoku Constraint Rule)
  int _animationModelIndex = 0;
  int _flowStepIndex = 0;

  // Practice Mode State
  List<List<String>> _practiceBoard = [];
  int _selectedPracticeRow = -1;
  int _selectedPracticeCol = -1;
  List<String> _practiceHistory = [];
  String _userFeedbackEn = "Tap an empty cell '.' and pick a digit 1-9 to solve the Sudoku board!";
  String _userFeedbackBn = "সুডোকু ঘর মিলাতে কোনো ফাঁকা ঘরে স্পর্শ করে ১-৯ সংখ্যাটি নির্বাচন করুন!";
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

  List<List<String>> _getPresetBoard(int presetIdx) {
    if (presetIdx == 2) {
      // 4x4 Mini Sudoku
      return [
        ["1", ".", ".", "4"],
        [".", "2", "3", "."],
        [".", "3", "2", "."],
        ["4", ".", ".", "1"],
      ];
    } else if (presetIdx == 1) {
      // Classic 9x9 Sudoku
      return [
        ["5", "3", ".", ".", "7", ".", ".", ".", "."],
        ["6", ".", ".", "1", "9", "5", ".", ".", "."],
        [".", "9", "8", ".", ".", ".", ".", "6", "."],
        ["8", ".", ".", ".", "6", ".", ".", ".", "3"],
        ["4", ".", ".", "8", ".", "3", ".", ".", "1"],
        ["7", ".", ".", ".", "2", ".", ".", ".", "6"],
        [".", "6", ".", ".", ".", ".", "2", "8", "."],
        [".", ".", ".", "4", "1", "9", ".", ".", "5"],
        [".", ".", ".", ".", "8", ".", ".", "7", "9"],
      ];
    } else {
      // Easy 9x9 Sudoku
      return [
        ["5", "3", "4", "6", "7", "8", "9", "1", "2"],
        ["6", "7", "2", "1", "9", "5", "3", "4", "8"],
        ["1", "9", "8", "3", "4", "2", "5", "6", "."],
        ["8", "5", "9", "7", "6", "1", "4", "2", "3"],
        ["4", "2", "6", "8", "5", "3", "7", "9", "1"],
        ["7", "1", "3", "9", "2", "4", "8", "5", "6"],
        ["9", "6", "1", "5", "3", "7", "2", "8", "4"],
        ["2", "8", "7", "4", "1", "9", "6", "3", "5"],
        ["3", "4", "5", "2", "8", "6", "1", "7", "."],
      ];
    }
  }

  void _rebuildSteps() {
    _timer?.cancel();
    _isPlaying = false;
    _currentStepIndex = 0;
    _flowStepIndex = 0;

    _initialBoard = _getPresetBoard(_selectedPreset);
    _steps = _generateSteps(_initialBoard);

    // Reset practice mode
    _resetPracticeBoard();
  }

  void _resetPracticeBoard() {
    _practiceBoard = _getPresetBoard(_selectedPreset);
    _selectedPracticeRow = -1;
    _selectedPracticeCol = -1;
    _practiceHistory = [];
    _practiceSolved = false;
    _userFeedbackEn = "Tap an empty cell '.' and pick a digit to solve the Sudoku board!";
    _userFeedbackBn = "সুডোকু ঘর মিলাতে কোনো ফাঁকা ঘরে স্পর্শ করে সংখ্যা নির্বাচন করুন!";
  }

  bool _isValidPlacement(List<List<String>> b, int r, int c, String d) {
    int size = b.length;
    int subSize = (size == 4) ? 2 : 3;

    for (int i = 0; i < size; i++) {
      if (b[r][i] == d) return false; // Row check
      if (b[i][c] == d) return false; // Col check

      int boxR = subSize * (r ~/ subSize) + (i ~/ subSize);
      int boxC = subSize * (c ~/ subSize) + (i % subSize);
      if (b[boxR][boxC] == d) return false; // Box check
    }
    return true;
  }

  List<SudokuSolverStep> _generateSteps(List<List<String>> startBoard) {
    List<SudokuSolverStep> steps = [];
    int size = startBoard.length;
    int maxDigits = (size == 4) ? 4 : 9;

    List<List<String>> b = startBoard.map((row) => List<String>.from(row)).toList();

    List<List<String>> copyBoard(List<List<String>> source) {
      return source.map((row) => List<String>.from(row)).toList();
    }

    // Step 0: Init
    steps.add(SudokuSolverStep(
      row: 0,
      col: 0,
      digit: "",
      board: copyBoard(b),
      isValid: true,
      decision: "init",
      activeLine: 1,
      actionEn: "Line 1: Initialize Sudoku Solver on $size x $size board.",
      actionBn: "লাইন ১: $size x $size বোর্ডে সুডোকু সলভার শুরু।",
      reasonEn: "We fill empty cells '.' with digits 1-$maxDigits while validating Row, Column, and Subgrid constraints.",
      reasonBn: "সারি, কলাম ও সাবগ্রিড পরীক্ষা করে ফাঁকা ঘর '.' গুলোতে ১-$maxDigits বসানো হবে।",
      callStackDepth: 0,
    ));

    bool solve(int depth) {
      for (int r = 0; r < size; r++) {
        for (int c = 0; c < size; c++) {
          if (b[r][c] == ".") {
            for (int dInt = 1; dInt <= maxDigits; dInt++) {
              String d = dInt.toString();
              bool valid = _isValidPlacement(b, r, c, d);

              if (!valid) {
                steps.add(SudokuSolverStep(
                  row: r,
                  col: c,
                  digit: d,
                  board: copyBoard(b),
                  isValid: false,
                  decision: "conflict_found",
                  activeLine: 8,
                  actionEn: "🛑 Line 8: Tested '$d' at ($r, $c) ➔ Conflict detected! (Row/Col/Box violation).",
                  actionBn: "🛑 লাইন ৮: সেল ($r, $c) এ '$d' পরীক্ষা ➔ দ্বন্দ্ব পাওয়া গেছে! (সারি/কলাম/বক্স)।",
                  reasonEn: "Digit '$d' already exists in row $r, column $c, or local subgrid.",
                  reasonBn: "সংখ্যা '$d' ইতিমধ্যেই সারি $r, কলাম $c বা স্থানীয় সাবগ্রিডে বিদ্যমান।",
                  callStackDepth: depth,
                ));
                continue;
              }

              b[r][c] = d;
              steps.add(SudokuSolverStep(
                row: r,
                col: c,
                digit: d,
                board: copyBoard(b),
                isValid: true,
                decision: "valid_placement",
                activeLine: 9,
                actionEn: "✅ Line 9: Placed '$d' at cell ($r, $c). Recurse to next empty cell.",
                actionBn: "✅ লাইন ৯: সেল ($r, $c) এ '$d' স্থাপন। পরবর্তী ফাঁকা ঘরের জন্য রিকার্সন শুরু।",
                reasonEn: "Valid placement. Recurse to solve remaining empty cells.",
                reasonBn: "বৈধ স্থাপন। অবশিষ্ট ফাঁকা ঘর পূরণের জন্য রিকার্সন চালান।",
                callStackDepth: depth + 1,
              ));

              if (solve(depth + 1)) return true;

              b[r][c] = ".";
              steps.add(SudokuSolverStep(
                row: r,
                col: c,
                digit: d,
                board: copyBoard(b),
                isValid: true,
                decision: "backtrack",
                activeLine: 11,
                actionEn: "Line 11: Backtrack ↩️ Reset cell ($r, $c) to '.'.",
                actionBn: "লাইন ১১: ব্যাকট্র্যাক ↩️ সেল ($r, $c) রিসেট করে '.' করা হলো।",
                reasonEn: "Subsequent branch failed. Restore cell to '.' and try next digit.",
                reasonBn: "পরবর্তী ডাল ব্যর্থ হয়েছে। সেলটি রিসেট করে পরের সংখ্যা পরীক্ষা করুন।",
                callStackDepth: depth,
              ));
            }
            return false;
          }
        }
      }
      return true; // All solved
    }

    bool solved = solve(0);

    if (solved) {
      steps.add(SudokuSolverStep(
        row: size - 1,
        col: size - 1,
        digit: "",
        board: copyBoard(b),
        isValid: true,
        decision: "board_solved",
        activeLine: 3,
        actionEn: "🎉 Line 3: SUDOKU SOLVED! All cells successfully filled!",
        actionBn: "🎉 লাইন ৩: সুডোকু সমাধান সম্পন্ন! সমস্ত ঘর সঠিকভাবে পূর্ণ হয়েছে!",
        reasonEn: "Every row, column, and subgrid satisfies all Sudoku rules.",
        reasonBn: "প্রতিটি সারি, কলাম ও সাবগ্রিড সুডোকুর সমস্ত নিয়ম পূরণ করেছে।",
        callStackDepth: 0,
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

  void _handlePracticeCellTap(int r, int c) {
    if (_practiceSolved) return;
    // Only allow editing empty initial cells
    if (_initialBoard[r][c] != ".") {
      setState(() {
        _userFeedbackEn = "ℹ️ Cell ($r, $c) is fixed in the initial puzzle and cannot be modified.";
        _userFeedbackBn = "ℹ️ সেল ($r, $c) পাজলের নির্ধারিত ঘর এবং পরিবর্তনযোগ্য নয়।";
      });
      return;
    }

    setState(() {
      _selectedPracticeRow = r;
      _selectedPracticeCol = c;
      _userFeedbackEn = "Selected cell ($r, $c). Now pick a digit from 1 to ${(_initialBoard.length == 4) ? 4 : 9}.";
      _userFeedbackBn = "সেল ($r, $c) নির্বাচিত। এখন ১ থেকে ${(_initialBoard.length == 4) ? 4 : 9} পর্যন্ত সংখ্যা বেছে নিন।";
    });
  }

  void _handlePracticeDigitPick(String digit) {
    if (_selectedPracticeRow == -1 || _selectedPracticeCol == -1 || _practiceSolved) return;

    int r = _selectedPracticeRow;
    int c = _selectedPracticeCol;

    setState(() {
      bool valid = _isValidPlacement(_practiceBoard, r, c, digit);

      if (!valid) {
        _userFeedbackEn = "🛑 Conflict! Digit '$digit' violates Row, Column, or 3x3 Subgrid rules at ($r, $c)!";
        _userFeedbackBn = "🛑 দ্বন্দ্ব! সংখ্যা '$digit' সেল ($r, $c) এর সারি, কলাম বা সাবগ্রিডের নিয়ম অমান্য করেছে!";
        return;
      }

      _practiceBoard[r][c] = digit;
      _practiceHistory.add("SET ($r, $c) = $digit");
      _userFeedbackEn = "✅ Placed '$digit' at ($r, $c)!";
      _userFeedbackBn = "✅ সেল ($r, $c) এ '$digit' বসানো হলো!";

      // Check if board solved
      bool fullyFilled = true;
      int size = _practiceBoard.length;
      for (int i = 0; i < size; i++) {
        for (int j = 0; j < size; j++) {
          if (_practiceBoard[i][j] == ".") fullyFilled = false;
        }
      }

      if (fullyFilled) {
        _practiceSolved = true;
        _userFeedbackEn = "🏆 MASTERED! You completely solved the Sudoku puzzle!";
        _userFeedbackBn = "🏆 দারুণ! আপনি সম্পূর্ণ সুডোকু পাজলটি সমাধান করে ফেলেছেন!";
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
          '37. Sudoku Solver',
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
                    "37. Sudoku Solver",
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
                        ? "Write a program to solve a Sudoku puzzle by filling the empty cells. A sudoku solution must satisfy all of the following rules:\n1. Each of the digits 1-9 must occur exactly once in each row.\n2. Each of the digits 1-9 must occur exactly once in each column.\n3. Each of the digits 1-9 must occur exactly once in each of the 9 3x3 sub-boxes of the grid."
                        : "ফাঁকা ঘরগুলি পূরণ করে একটি সুডোকু পাজল সমাধান করার একটি প্রোগ্রাম লিখুন। একটি সুডোকু সমাধানকে সমস্ত নিয়ম পূরণ করতে হবে:\n১. প্রতিটি সারি, কলাম এবং ৯টি ৩x৩ সাব-বক্সে ১-৯ সংখ্যাগুলি ঠিক একবার থাকতে হবে।",
                    style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
                  ),
                ],
              ),
            ),
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
                        _isEnglish ? "Key Intuition (3-Way Rule Validation + Backtracking)" : "মূল আইডিয়া (৩-মুখী নিয়ম যাচাই + ব্যাকট্র্যাকিং)",
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isEnglish
                        ? "1. Locate first empty cell ('.').\n2. Try digits '1'-'9' and validate Row, Column, and 3x3 Subgrid.\n3. If valid, place digit and recurse. If stuck, reset to '.' and backtrack."
                        : "১. প্রথম ফাঁকা ঘর ('.') খুঁজুন।\n২. '১'-'৯' সংখ্যা বসিয়ে সারি, কলাম ও ৩x৩ সাবগ্রিড পরীক্ষা করুন।\n৩. বৈধ হলে সংখ্যা বসিয়ে রিকার্সন চালান। ব্যর্থ হলে '.' করে ব্যাকট্র্যাক করুন।",
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
              _isEnglish ? "Sudoku Solver Visual Models (Concept Explanations)" : "সুডোকু সলভার ভিজ্যুয়াল মডেলসমূহ (কোডহীন গাইড)",
              style: TextStyle(fontSize: Responsive.sp(context, 18), fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 6),
            Text(
              _isEnglish
                  ? "Explore 3 interactive models for Sudoku Solver algorithm."
                  : "সুডোকু অ্যালগরিদমের জন্য ৩টি ইন্টারঅ্যাক্টিভ ভিজ্যুয়াল মডেল পর্যবেক্ষণ করুন।",
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 16),

            // Model Switcher Segmented Control
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildAnimationModelChip(0, _isEnglish ? "1. 🪜 Step Flowcard" : "১. 🪜 স্টেপ-বাই-স্টেপ ফ্লো-কার্ড"),
                  _buildAnimationModelChip(1, _isEnglish ? "2. 🧱 3-Way Rule Validation" : "২. 🧱 ৩-মুখী নিয়ম যাচাই"),
                  _buildAnimationModelChip(2, _isEnglish ? "3. 🧩 Sudoku Rule Guide" : "৩. 🧩 সুডোকু রুল গাইড"),
                ],
              ),
            ),
            const SizedBox(height: 20),

            if (_animationModelIndex == 0) _buildStepFlowcardModel(),
            if (_animationModelIndex == 1) _buildThreeWayRuleModel(),
            if (_animationModelIndex == 2) _buildSudokuRuleGuideModel(),

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
        "col": 2,
        "digit": "1",
        "badge": "🛑 ROW CONFLICT",
        "badgeColor": AppTheme.accentPink,
        "titleEn": "Step 1: Test digit '1' at cell (0, 2) ➔ Row Conflict!",
        "titleBn": "ধাপ ১: সেল (0, 2) এ '1' পরীক্ষা ➔ সারি দ্বন্দ্ব!",
        "descEn": "Digit '1' is already present in Row 0! Skipped '1'.",
        "descBn": "সারি ০ এ সংখ্যা '1' ইতিমধ্যেই বিদ্যমান! '1' বাতিল।",
      },
      {
        "step": 2,
        "row": 0,
        "col": 2,
        "digit": "4",
        "badge": "✅ VALID PLACEMENT",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 2: Test digit '4' at cell (0, 2) ➔ Valid!",
        "titleBn": "ধাপ ২: সেল (0, 2) এ '4' পরীক্ষা ➔ বৈধ!",
        "descEn": "Row 0, Col 2, and 3x3 Subgrid valid! Placed '4' at (0, 2).",
        "descBn": "সারি ০, কলাম ২ এবং ৩x৩ সাবগ্রিড বৈধ! (0, 2) এ '4' স্থাপন।",
      },
      {
        "step": 3,
        "row": 0,
        "col": 7,
        "digit": "2",
        "badge": "🛑 BOX CONFLICT",
        "badgeColor": AppTheme.accentPink,
        "titleEn": "Step 3: Test digit '2' at cell (0, 7) ➔ 3x3 Box Conflict!",
        "titleBn": "ধাপ ৩: সেল (0, 7) এ '2' পরীক্ষা ➔ ৩x৩ বক্স দ্বন্দ্ব!",
        "descEn": "Digit '2' already present in top-right 3x3 subgrid! Skipped.",
        "descBn": "উপরের ডান ৩x৩ সাবগ্রিডে সংখ্যা '2' ইতিমধ্যেই বিদ্যমান! বাতিল।",
      },
      {
        "step": 4,
        "row": 8,
        "col": 8,
        "digit": "9",
        "badge": "🎉 SUDOKU SOLVED",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 4: All Empty Cells Filled ➔ Sudoku Solved!",
        "titleBn": "ধাপ ৪: সমস্ত ফাঁকা ঘর পূর্ণ ➔ সুডোকু সমাধান সম্পন্ন!",
        "descEn": "Successfully filled all 81 cells obeying all Sudoku constraints!",
        "descBn": "সমস্ত সুডোকু নিয়ম মেনে ৮১টি ঘর সফলভাবে পূর্ণ করা হয়েছে!",
      },
    ];

    final currentStep = stepFlowData[_flowStepIndex.clamp(0, stepFlowData.length - 1)];
    final int r = currentStep["row"] as int;
    final int c = currentStep["col"] as int;
    final String digit = currentStep["digit"] as String;
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
                _isEnglish ? "1. Step-by-Step Sudoku Solver Flowcard" : "১. স্টেপ-বাই-স্টেপ সুডোকু সলভার ফ্লো-কার্ড",
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
                ? "Watch digit testing and 3-way constraint validation."
                : "ডিজিট পরীক্ষা এবং ৩-মুখী নিয়ম যাচাই দেখুন।",
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
                    Text("Tested Digit: '$digit'", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
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

  // MODEL 2: 3-Way Rule Validation
  Widget _buildThreeWayRuleModel() {
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
            _isEnglish ? "2. 3-Way Validation Rule (Row, Column & 3x3 Subgrid)" : "২. ৩-মুখী নিয়ম যাচাই (সারি, কলাম ও ৩x৩ সাবগ্রিড)",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            _isEnglish
                ? "Checking if digit d is valid at position (r, c):\n1. board[r][i] != d\n2. board[i][c] != d\n3. board[3*(r/3) + i/3][3*(c/3) + i%3] != d"
                : "সেল (r, c) এ সংখ্যা d বসানোর ৩টি শর্ত:\n১. board[r][i] != d (সারি)\n২. board[i][c] != d (কলাম)\n৩. board[3*(r/3)+i/3][3*(c/3)+i%3] != d (সাবগ্রিড)",
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
              "isValid(r, c, d) ➔ Check Row, Col, and 3x3 Box simultaneously!",
              style: TextStyle(fontFamily: 'monospace', fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.accentPink),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  // MODEL 3: Sudoku Rule Guide
  Widget _buildSudokuRuleGuideModel() {
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
            _isEnglish ? "3. Sudoku Constraints Summary" : "৩. সুডোকু নিয়ম সংক্ষেপ",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            _isEnglish
                ? "A valid Sudoku board must contain numbers 1-9 without duplicates in any Row, Column, or 3x3 Subgrid."
                : "একটি বৈধ সুডোকু বোর্ডে প্রতিটি সারি, কলাম বা ৩x৩ সাবগ্রিডে ১-৯ সংখ্যাগুলো ডুপ্লিকেট ছাড়া থাকতে হবে।",
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
              "9 Rows x 9 Cols = 81 Cells\n9 Subgrids (3x3 each)\nUnique Digits 1-9 🎉",
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
          // Input Box & Preset Selector
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
                  _isEnglish ? "Sudoku Puzzle:" : "সুডোকু পাজল:",
                  style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(width: 14),
                DropdownButton<int>(
                  value: _selectedPreset,
                  dropdownColor: const Color(0xFF090D16),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                  items: const [
                    DropdownMenuItem(value: 0, child: Text("Easy 9x9")),
                    DropdownMenuItem(value: 1, child: Text("Classic 9x9")),
                    DropdownMenuItem(value: 2, child: Text("4x4 Mini")),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _selectedPreset = val;
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
                  _buildSudokuCanvas(step),
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildCodeHighlightBox(step.activeLine)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildSudokuCanvas(step)),
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
    int size = _initialBoard.length;
    int maxDigits = (size == 4) ? 4 : 9;

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
                  ? "Tap an empty cell and select a digit 1-$maxDigits to solve the board!"
                  : "ফাঁকা ঘরে স্পর্শ করে ১-$maxDigits সংখ্যা বসিয়ে সুডোকু মেলান!",
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

            // Practice Sudoku Grid
            Center(
              child: Container(
                width: Responsive.isMobile(context) ? 280 : 320,
                height: Responsive.isMobile(context) ? 280 : 320,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.accentPurple, width: 2),
                ),
                child: Column(
                  children: List.generate(size, (r) {
                    return Expanded(
                      child: Row(
                        children: List.generate(size, (c) {
                          String val = _practiceBoard[r][c];
                          bool isFixed = _initialBoard[r][c] != ".";
                          bool isSelected = (r == _selectedPracticeRow && c == _selectedPracticeCol);

                          // Subgrid thick border detection
                          int subSize = (size == 4) ? 2 : 3;
                          bool hasBottomBorder = (r + 1) % subSize == 0 && r + 1 < size;
                          bool hasRightBorder = (c + 1) % subSize == 0 && c + 1 < size;

                          return Expanded(
                            child: GestureDetector(
                              onTap: () => _handlePracticeCellTap(r, c),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppTheme.accentNeonCyan.withOpacity(0.3)
                                      : (isFixed ? const Color(0xFF0F172A) : const Color(0xFF1E293B)),
                                  border: Border(
                                    top: const BorderSide(color: Color(0xFF334155), width: 0.5),
                                    left: const BorderSide(color: Color(0xFF334155), width: 0.5),
                                    right: BorderSide(
                                      color: hasRightBorder ? AppTheme.accentPurple : const Color(0xFF334155),
                                      width: hasRightBorder ? 2.0 : 0.5,
                                    ),
                                    bottom: BorderSide(
                                      color: hasBottomBorder ? AppTheme.accentPurple : const Color(0xFF334155),
                                      width: hasBottomBorder ? 2.0 : 0.5,
                                    ),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    val == "." ? "" : val,
                                    style: TextStyle(
                                      fontFamily: 'monospace',
                                      fontSize: Responsive.sp(context, size == 4 ? 18 : 14),
                                      fontWeight: isFixed ? FontWeight.bold : FontWeight.w600,
                                      color: isFixed ? Colors.white : AppTheme.accentNeonCyan,
                                    ),
                                  ),
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
            const SizedBox(height: 16),

            // Digit Keypad Selector
            if (!_practiceSolved && _selectedPracticeRow != -1 && _selectedPracticeCol != -1) ...[
              Center(
                child: Text(
                  _isEnglish ? "Pick digit for cell ($_selectedPracticeRow, $_selectedPracticeCol):" : "সেল ($_selectedPracticeRow, $_selectedPracticeCol) এর জন্য ডিজিট বেছে নিন:",
                  style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(maxDigits, (idx) {
                    String dStr = (idx + 1).toString();
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentPurple,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(40, 40),
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () => _handlePracticeDigitPick(dStr),
                      child: Text(dStr, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    );
                  }),
                ),
              ),
            ],

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

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // Helper Widgets
  Widget _buildCodeHighlightBox(int activeLine) {
    final codeLines = [
      "bool solve(vector<vector<char>>& board) {",
      "    for (int r = 0; r < 9; r++) {",
      "        for (int c = 0; c < 9; c++) {",
      "            if (board[r][c] == '.') {",
      "                for (char d = '1'; d <= '9'; d++) {",
      "                    if (isValid(board, r, c, d)) {",
      "                        board[r][c] = d;",
      "                        if (solve(board)) return true;",
      "                        board[r][c] = '.'; // Backtrack",
      "                    }",
      "                }",
      "                return false;",
      "            }",
      "        }",
      "    }",
      "    return true; // Solved!",
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

  Widget _buildSudokuCanvas(SudokuSolverStep step) {
    Color decisionColor = AppTheme.accentPurple;
    String decisionLabel = "INIT";

    if (step.decision == "valid_placement") {
      decisionColor = AppTheme.accentGreen;
      decisionLabel = "✅ PLACED '${step.digit}'";
    } else if (step.decision == "conflict_found") {
      decisionColor = AppTheme.accentPink;
      decisionLabel = "🛑 CONFLICT '${step.digit}'";
    } else if (step.decision == "board_solved") {
      decisionColor = AppTheme.accentGreen;
      decisionLabel = "🎉 SUDOKU SOLVED";
    } else if (step.decision == "backtrack") {
      decisionColor = AppTheme.accentAmber;
      decisionLabel = "↩️ BACKTRACK";
    }

    int size = step.board.length;
    int subSize = (size == 4) ? 2 : 3;

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
              Text("Cell: (${step.row}, ${step.col})", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13)),
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

          // Live Sudoku Grid Board
          Center(
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: decisionColor, width: 2),
              ),
              child: Column(
                children: List.generate(size, (r) {
                  return Expanded(
                    child: Row(
                      children: List.generate(size, (c) {
                        String val = step.board[r][c];
                        bool isCurrentCell = (r == step.row && c == step.col);
                        bool isFixed = _initialBoard[r][c] != ".";

                        bool hasBottomBorder = (r + 1) % subSize == 0 && r + 1 < size;
                        bool hasRightBorder = (c + 1) % subSize == 0 && c + 1 < size;

                        return Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: isCurrentCell
                                  ? decisionColor.withOpacity(0.4)
                                  : (isFixed ? const Color(0xFF0F172A) : const Color(0xFF1E293B)),
                              border: Border(
                                top: const BorderSide(color: Color(0xFF334155), width: 0.5),
                                left: const BorderSide(color: Color(0xFF334155), width: 0.5),
                                right: BorderSide(
                                  color: hasRightBorder ? AppTheme.accentPurple : const Color(0xFF334155),
                                  width: hasRightBorder ? 2.0 : 0.5,
                                ),
                                bottom: BorderSide(
                                  color: hasBottomBorder ? AppTheme.accentPurple : const Color(0xFF334155),
                                  width: hasBottomBorder ? 2.0 : 0.5,
                                ),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                val == "." ? "" : val,
                                style: TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: size == 4 ? 16 : 11,
                                  fontWeight: isCurrentCell ? FontWeight.bold : FontWeight.w600,
                                  color: isCurrentCell
                                      ? Colors.white
                                      : (isFixed ? const Color(0xFF94A3B8) : AppTheme.accentNeonCyan),
                                ),
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

  Widget _buildCodeSnippetBox(String lang) {
    String code = "";
    if (lang == "C++") {
      code = """
class Solution {
public:
    bool isValid(vector<vector<char>>& board, int r, int c, char d) {
        for (int i = 0; i < 9; i++) {
            if (board[r][i] == d) return false;
            if (board[i][c] == d) return false;
            if (board[3 * (r / 3) + i / 3][3 * (c / 3) + i % 3] == d) return false;
        }
        return true;
    }

    bool solve(vector<vector<char>>& board) {
        for (int r = 0; r < 9; r++) {
            for (int c = 0; c < 9; c++) {
                if (board[r][c] == '.') {
                    for (char d = '1'; d <= '9'; d++) {
                        if (isValid(board, r, c, d)) {
                            board[r][c] = d;
                            if (solve(board)) return true;
                            board[r][c] = '.';
                        }
                    }
                    return false;
                }
            }
        }
        return true;
    }

    void solveSudoku(vector<vector<char>>& board) {
        solve(board);
    }
};""";
    } else if (lang == "Java") {
      code = """
class Solution {
    public void solveSudoku(char[][] board) {
        solve(board);
    }

    private boolean solve(char[][] board) {
        for (int r = 0; r < 9; r++) {
            for (int c = 0; c < 9; c++) {
                if (board[r][c] == '.') {
                    for (char d = '1'; d <= '9'; d++) {
                        if (isValid(board, r, c, d)) {
                            board[r][c] = d;
                            if (solve(board)) return true;
                            board[r][c] = '.';
                        }
                    }
                    return false;
                }
            }
        }
        return true;
    }

    private boolean isValid(char[][] board, int r, int c, char d) {
        for (int i = 0; i < 9; i++) {
            if (board[r][i] == d) return false;
            if (board[i][c] == d) return false;
            if (board[3 * (r / 3) + i / 3][3 * (c / 3) + i % 3] == d) return false;
        }
        return true;
    }
}""";
    } else {
      code = """
class Solution:
    def solveSudoku(self, board: List[List[str]]) -> None:
        def isValid(r, c, d):
            for i in range(9):
                if board[r][i] == d: return False
                if board[i][c] == d: return False
                if board[3 * (r // 3) + i // 3][3 * (c // 3) + i % 3] == d: return False
            return True

        def solve():
            for r in range(9):
                for c in range(9):
                    if board[r][c] == '.':
                        for d in map(str, range(1, 10)):
                            if isValid(r, c, d):
                                board[r][c] = d
                                if solve(): return True
                                board[r][c] = '.'
                        return False
            return True

        solve()""";
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
