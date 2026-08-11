import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class WordSearchStep {
  final int row;
  final int col;
  final int wordIndex;
  final List<List<int>> matchedPath;
  final String decision; // 'init', 'match_char', 'mismatch', 'visited', 'word_found', 'backtrack'
  final int activeLine;
  final String actionEn;
  final String actionBn;
  final String reasonEn;
  final String reasonBn;
  final int callStackDepth;

  const WordSearchStep({
    required this.row,
    required this.col,
    required this.wordIndex,
    required this.matchedPath,
    required this.decision,
    required this.activeLine,
    required this.actionEn,
    required this.actionBn,
    required this.reasonEn,
    required this.reasonBn,
    required this.callStackDepth,
  });
}

class WordSearchDetailScreen extends StatefulWidget {
  const WordSearchDetailScreen({super.key});

  @override
  State<WordSearchDetailScreen> createState() => _WordSearchDetailScreenState();
}

class _WordSearchDetailScreenState extends State<WordSearchDetailScreen>
    with SingleTickerProviderStateMixin {
  bool _isEnglish = true;
  late TabController _tabController;

  // 2D Grid Board & Target Word
  final List<List<String>> _board = [
    ['A', 'B', 'C', 'E'],
    ['S', 'F', 'C', 'S'],
    ['A', 'D', 'E', 'E'],
  ];

  // Preset Selection (0: "ABCCED", 1: "SEE", 2: "ABCB")
  int _presetIndex = 0;
  String _targetWord = "ABCCED";
  List<WordSearchStep> _steps = [];

  // Playback Control
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  // Code Language Selector
  String _selectedCodeLang = "C++";

  // Tab 2 Animation Model Selector (0: Step Flowcard, 1: 2D Grid Navigator, 2: Visited Marker)
  int _animationModelIndex = 0;
  int _flowStepIndex = 0;

  // Practice Mode State
  List<List<int>> _practicePath = [];
  String _practiceMatchedStr = "";
  List<String> _practiceHistory = [];
  String _userFeedbackEn = "Tap grid cells sequentially to trace the target word!";
  String _userFeedbackBn = "টার্গেট শব্দটি তৈরি করতে গ্রিড সেলগুলোতে পরপর স্পর্শ করুন!";
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

    if (_presetIndex == 0) _targetWord = "ABCCED";
    if (_presetIndex == 1) _targetWord = "SEE";
    if (_presetIndex == 2) _targetWord = "ABCB";

    _steps = _generateStepsForWord(_targetWord);

    // Reset practice mode
    _practicePath = [];
    _practiceMatchedStr = "";
    _practiceHistory = [];
    _practiceSolved = false;
    _userFeedbackEn = "Tap grid cells sequentially to trace target word \"$_targetWord\"!";
    _userFeedbackBn = "টার্গেট শব্দ \"$_targetWord\" তৈরি করতে গ্রিড সেলগুলোতে পরপর স্পর্শ করুন!";
  }

  List<WordSearchStep> _generateStepsForWord(String word) {
    List<WordSearchStep> steps = [];

    if (word == "ABCCED") {
      steps = [
        const WordSearchStep(
          row: 0,
          col: 0,
          wordIndex: 0,
          matchedPath: [[0, 0]],
          decision: "match_char",
          activeLine: 1,
          actionEn: "Line 1: Match 'A' at cell (0, 0) for word[0]. Mark '#' visited.",
          actionBn: "লাইন ১: সেল (0, 0) তে 'A' এর সাথে মিল পাওয়া গেল। '#' ভিজিটেড মার্ক।",
          reasonEn: "board[0][0] == 'A'. Start 4-directional DFS from cell (0, 0).",
          reasonBn: "board[0][0] == 'A'। সেল (0, 0) থেকে ৪-দিকমুখী DFS রিকার্সন শুরু।",
          callStackDepth: 1,
        ),
        const WordSearchStep(
          row: 0,
          col: 1,
          wordIndex: 1,
          matchedPath: [[0, 0], [0, 1]],
          decision: "match_char",
          activeLine: 7,
          actionEn: "Line 7: Move RIGHT to (0, 1) ➔ Match 'B' for word[1]. Mark '#' visited.",
          actionBn: "লাইন ৭: ডানে (0, 1) তে স্থানান্তর ➔ 'B' এর সাথে মিল পাওয়া গেল।",
          reasonEn: "board[0][1] == 'B'. Move to wordIndex 2.",
          reasonBn: "board[0][1] == 'B'। wordIndex 2 এ স্থানান্তরিত।",
          callStackDepth: 2,
        ),
        const WordSearchStep(
          row: 0,
          col: 2,
          wordIndex: 2,
          matchedPath: [[0, 0], [0, 1], [0, 2]],
          decision: "match_char",
          activeLine: 7,
          actionEn: "Line 7: Move RIGHT to (0, 2) ➔ Match 'C' for word[2]. Mark '#' visited.",
          actionBn: "লাইন ৭: ডানে (0, 2) তে স্থানান্তর ➔ 'C' এর সাথে মিল পাওয়া গেল।",
          reasonEn: "board[0][2] == 'C'. Move to wordIndex 3.",
          reasonBn: "board[0][2] == 'C'। wordIndex 3 এ স্থানান্তরিত।",
          callStackDepth: 3,
        ),
        const WordSearchStep(
          row: 1,
          col: 2,
          wordIndex: 3,
          matchedPath: [[0, 0], [0, 1], [0, 2], [1, 2]],
          decision: "match_char",
          activeLine: 7,
          actionEn: "Line 7: Move DOWN to (1, 2) ➔ Match 'C' for word[3]. Mark '#' visited.",
          actionBn: "লাইন ৭: নিচে (1, 2) তে স্থানান্তর ➔ 'C' এর সাথে মিল পাওয়া গেল।",
          reasonEn: "board[1][2] == 'C'. Move to wordIndex 4.",
          reasonBn: "board[1][2] == 'C'। wordIndex 4 এ স্থানান্তরিত।",
          callStackDepth: 4,
        ),
        const WordSearchStep(
          row: 2,
          col: 2,
          wordIndex: 4,
          matchedPath: [[0, 0], [0, 1], [0, 2], [1, 2], [2, 2]],
          decision: "match_char",
          activeLine: 7,
          actionEn: "Line 7: Move DOWN to (2, 2) ➔ Match 'E' for word[4]. Mark '#' visited.",
          actionBn: "লাইন ৭: নিচে (2, 2) তে স্থানান্তর ➔ 'E' এর সাথে মিল পাওয়া গেল।",
          reasonEn: "board[2][2] == 'E'. Move to wordIndex 5.",
          reasonBn: "board[2][2] == 'E'। wordIndex 5 এ স্থানান্তরিত।",
          callStackDepth: 5,
        ),
        const WordSearchStep(
          row: 2,
          col: 1,
          wordIndex: 5,
          matchedPath: [[0, 0], [0, 1], [0, 2], [1, 2], [2, 2], [2, 1]],
          decision: "match_char",
          activeLine: 7,
          actionEn: "Line 7: Move LEFT to (2, 1) ➔ Match 'D' for word[5]. Mark '#' visited.",
          actionBn: "লাইন ৭: বামে (2, 1) তে স্থানান্তর ➔ 'D' এর সাথে মিল পাওয়া গেল।",
          reasonEn: "board[2][1] == 'D'. Final character matched!",
          reasonBn: "board[2][1] == 'D'। শেষ অক্ষর মিল সম্পন্ন!",
          callStackDepth: 6,
        ),
        const WordSearchStep(
          row: 2,
          col: 1,
          wordIndex: 6,
          matchedPath: [[0, 0], [0, 1], [0, 2], [1, 2], [2, 2], [2, 1]],
          decision: "word_found",
          activeLine: 4,
          actionEn: "🎉 Line 4: Full Word Match Complete! \"ABCCED\" Found! Returns true.",
          actionBn: "🎉 লাইন ৪: সম্পূর্ণ শব্দ \"ABCCED\" গ্রিডে খুঁজে পাওয়া গেছে! true রিটার্ন সম্পন্ন।",
          reasonEn: "k == word.length(). Target word fully constructed.",
          reasonBn: "k == word.length()। টার্গেট শব্দ তৈরি সম্পন্ন।",
          callStackDepth: 0,
        ),
      ];
    } else if (word == "SEE") {
      steps = [
        const WordSearchStep(
          row: 1,
          col: 3,
          wordIndex: 0,
          matchedPath: [[1, 3]],
          decision: "match_char",
          activeLine: 1,
          actionEn: "Line 1: Match 'S' at cell (1, 3) for word[0].",
          actionBn: "লাইন ১: সেল (1, 3) তে 'S' এর সাথে মিল।",
          reasonEn: "board[1][3] == 'S'.",
          reasonBn: "board[1][3] == 'S'।",
          callStackDepth: 1,
        ),
        const WordSearchStep(
          row: 2,
          col: 3,
          wordIndex: 1,
          matchedPath: [[1, 3], [2, 3]],
          decision: "match_char",
          activeLine: 7,
          actionEn: "Line 7: Move DOWN to (2, 3) ➔ Match 'E' for word[1].",
          actionBn: "লাইন ৭: নিচে (2, 3) তে স্থানান্তর ➔ 'E' এর সাথে মিল।",
          reasonEn: "board[2][3] == 'E'.",
          reasonBn: "board[2][3] == 'E'।",
          callStackDepth: 2,
        ),
        const WordSearchStep(
          row: 2,
          col: 2,
          wordIndex: 2,
          matchedPath: [[1, 3], [2, 3], [2, 2]],
          decision: "match_char",
          activeLine: 7,
          actionEn: "Line 7: Move LEFT to (2, 2) ➔ Match 'E' for word[2].",
          actionBn: "লাইন ৭: বামে (2, 2) তে স্থানান্তর ➔ 'E' এর সাথে মিল।",
          reasonEn: "board[2][2] == 'E'.",
          reasonBn: "board[2][2] == 'E'।",
          callStackDepth: 3,
        ),
        const WordSearchStep(
          row: 2,
          col: 2,
          wordIndex: 3,
          matchedPath: [[1, 3], [2, 3], [2, 2]],
          decision: "word_found",
          activeLine: 4,
          actionEn: "🎉 Line 4: Word \"SEE\" Found! Returns true.",
          actionBn: "🎉 লাইন ৪: শব্দ \"SEE\" পাওয়া গেছে! true রিটার্ন।",
          reasonEn: "Target word found.",
          reasonBn: "টার্গেট শব্দ অর্জিত।",
          callStackDepth: 0,
        ),
      ];
    } else {
      // "ABCB" -> False
      steps = [
        const WordSearchStep(
          row: 0,
          col: 0,
          wordIndex: 0,
          matchedPath: [[0, 0]],
          decision: "match_char",
          activeLine: 1,
          actionEn: "Line 1: Match 'A' at (0, 0).",
          actionBn: "লাইন ১: (0, 0) তে 'A' মিল।",
          reasonEn: "board[0][0] == 'A'.",
          reasonBn: "board[0][0] == 'A'।",
          callStackDepth: 1,
        ),
        const WordSearchStep(
          row: 0,
          col: 1,
          wordIndex: 1,
          matchedPath: [[0, 0], [0, 1]],
          decision: "match_char",
          activeLine: 7,
          actionEn: "Line 7: Match 'B' at (0, 1).",
          actionBn: "লাইন ৭: (0, 1) তে 'B' মিল।",
          reasonEn: "board[0][1] == 'B'.",
          reasonBn: "board[0][1] == 'B'।",
          callStackDepth: 2,
        ),
        const WordSearchStep(
          row: 0,
          col: 2,
          wordIndex: 2,
          matchedPath: [[0, 0], [0, 1], [0, 2]],
          decision: "match_char",
          activeLine: 7,
          actionEn: "Line 7: Match 'C' at (0, 2). Next: Looking for 'B'.",
          actionBn: "লাইন ৭: (0, 2) তে 'C' মিল। পরবর্তী: 'B' অনুসন্ধান।",
          reasonEn: "board[0][2] == 'C'.",
          reasonBn: "board[0][2] == 'C'।",
          callStackDepth: 3,
        ),
        const WordSearchStep(
          row: 0,
          col: 1,
          wordIndex: 3,
          matchedPath: [[0, 0], [0, 1], [0, 2]],
          decision: "visited",
          activeLine: 5,
          actionEn: "❌ Line 5: Cell (0, 1) is already visited ('#')! Cannot reuse cell.",
          actionBn: "❌ লাইন ৫: সেল (0, 1) ইতিমধ্যেই ভিজিটেড ('#')! পুনরায় ব্যবহার সম্ভব নয়।",
          reasonEn: "Same letter cell may not be used more than once.",
          reasonBn: "একই অক্ষরের সেল একাধিকবার ব্যবহার করা যায় না।",
          callStackDepth: 3,
        ),
        const WordSearchStep(
          row: 0,
          col: 0,
          wordIndex: 0,
          matchedPath: [],
          decision: "mismatch",
          activeLine: 12,
          actionEn: "❌ Line 12: Word \"ABCB\" NOT Found in grid! Returns false.",
          actionBn: "❌ লাইন ১২: \"ABCB\" শব্দটি গ্রিডে পাওয়া যায়নি! false রিটার্ন সম্পন্ন।",
          reasonEn: "All DFS branches failed.",
          reasonBn: "সমস্ত DFS ডালপালা ব্যর্থ হয়েছে।",
          callStackDepth: 0,
        ),
      ];
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

    String cellChar = _board[r][c];
    int nextWordIdx = _practicePath.length;

    if (nextWordIdx < _targetWord.length && cellChar == _targetWord[nextWordIdx]) {
      // Check if already visited in path
      bool alreadyVisited = _practicePath.any((pos) => pos[0] == r && pos[1] == c);

      if (!alreadyVisited) {
        setState(() {
          _practicePath.add([r, c]);
          _practiceMatchedStr += cellChar;
          _practiceHistory.add("TAP ($r, $c)");

          if (_practiceMatchedStr == _targetWord) {
            _practiceSolved = true;
            _userFeedbackEn = "🏆 MASTERED! You found word \"$_targetWord\" in the grid!";
            _userFeedbackBn = "🏆 দারুণ! আপনি গ্রিডে \"$_targetWord\" শব্দটি খুঁজে বের করেছেন!";
          } else {
            _userFeedbackEn = "✅ Matched '$cellChar'! Current: \"$_practiceMatchedStr\". Next: '${_targetWord[_practicePath.length]}'.";
            _userFeedbackBn = "✅ '$cellChar' মিলেছে! বর্তমান: \"$_practiceMatchedStr\"। পরবর্তী: '${_targetWord[_practicePath.length]}'।";
          }
        });
      } else {
        setState(() {
          _userFeedbackEn = "⚠️ Cell ($r, $c) is already used in this path! Pick an adjacent unvisited cell.";
          _userFeedbackBn = "⚠️ সেল ($r, $c) ইতিমধ্যেই ব্যবহৃত হয়েছে! অন্য সংলগ্ন সেল বেছে নিন।";
        });
      }
    } else {
      setState(() {
        _userFeedbackEn = "❌ Cell ($r, $c) contains '$cellChar', but expected '${_targetWord[nextWordIdx]}'.";
        _userFeedbackBn = "❌ সেল ($r, $c) তে আছে '$cellChar', কিন্তু প্রত্যাশিত ছিল '${_targetWord[nextWordIdx]}'।";
      });
    }
  }

  void _undoPracticeMove() {
    if (_practiceHistory.isNotEmpty && _practicePath.isNotEmpty) {
      setState(() {
        _practiceHistory.removeLast();
        _practicePath.removeLast();
        _practiceMatchedStr = _practiceMatchedStr.substring(0, _practiceMatchedStr.length - 1);
        _userFeedbackEn = "↩️ Undid last cell tap. Matched = \"$_practiceMatchedStr\".";
        _userFeedbackBn = "↩️ পূর্ববর্তী সেল ট্যাপ বাতিল করা হলো। Matched = \"$_practiceMatchedStr\"।";
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
          '79. Word Search',
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
                    "79. Word Search",
                    style: TextStyle(fontSize: Responsive.sp(context, 22), fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.accentAmber.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.accentAmber),
                  ),
                  child: const Text("Medium", style: TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 12)),
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
                        ? "Given an m x n grid of characters board and a string word, return true if word exists in the grid. The word can be constructed from letters of sequentially adjacent cells."
                        : "একটি m x n গ্রিড board এবং একটি স্ট্রিং word দেওয়া আছে। গ্রিডে শব্দটি পাওয়া গেলে true রিটার্ন করুন। পর পর সংলগ্ন সেলের অক্ষর থেকে শব্দ তৈরি হতে হবে।",
                    style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Examples
            Text(_isEnglish ? "Examples" : "উদাহরণসমূহ", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            _buildExampleCard("Example 1", "board = [[\"A\",\"B\",\"C\",\"E\"],[\"S\",\"F\",\"C\",\"S\"],[\"A\",\"D\",\"E\",\"E\"]], word = \"ABCCED\"", "Output: true"),
            _buildExampleCard("Example 2", "word = \"SEE\"", "Output: true"),
            _buildExampleCard("Example 3", "word = \"ABCB\"", "Output: false"),
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
                        _isEnglish ? "Key Intuition (4-Directional Backtracking Grid Search)" : "মূল আইডিয়া (৪-দিকমুখী ব্যাকট্র্যাকিং গ্রিড সার্চ)",
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isEnglish
                        ? "At cell (r, c), check bounds and character match. Temporarily mark cell visited (board[r][c] = '#'). Recurse in 4 directions (Up, Down, Left, Right). Restore original character on backtrack!"
                        : "সেল (r, c) এ বাউন্ডারি ও অক্ষরের মিল চেক করুন। সাময়িকভাবে সেল ভিজিটেড মার্ক করুন (board[r][c] = '#')। ৪-দিকে রিকার্সন চালান। ব্যাকট্র্যাকে মূল অক্ষর পুনর্বহাল করুন!",
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
              _isEnglish ? "Word Search Visual Models (Concept Explanations)" : "ওয়ার্ড সার্চ ভিজ্যুয়াল মডেলসমূহ (কোডহীন গাইড)",
              style: TextStyle(fontSize: Responsive.sp(context, 18), fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 6),
            Text(
              _isEnglish
                  ? "Explore 3 interactive models for word = \"ABCCED\" on 3x4 grid."
                  : "৩x৪ গ্রিডে word = \"ABCCED\" এর জন্য ৩টি ইন্টারঅ্যাক্টিভ ভিজ্যুয়াল মডেল পর্যবেক্ষণ করুন।",
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 16),

            // Model Switcher Segmented Control
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildAnimationModelChip(0, _isEnglish ? "1. 🪜 Step Flowcard" : "১. 🪜 স্টেপ-বাই-স্টেপ ফ্লো-কার্ড"),
                  _buildAnimationModelChip(1, _isEnglish ? "2. 🗺️ 2D Grid Navigator" : "২. 🗺️ ২ডি গ্রিড নেভিগেটর"),
                  _buildAnimationModelChip(2, _isEnglish ? "3. 🛑 Visited Marker Rule" : "৩. 🛑 ভিজিটেড মার্কার নিয়ম"),
                ],
              ),
            ),
            const SizedBox(height: 20),

            if (_animationModelIndex == 0) _buildStepFlowcardModel(),
            if (_animationModelIndex == 1) _buildGridNavigatorModel(),
            if (_animationModelIndex == 2) _buildVisitedMarkerModel(),

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
        "cell": "(0, 0)",
        "char": "A",
        "matched": "A",
        "badge": "MATCH 'A'",
        "badgeColor": AppTheme.accentNeonCyan,
        "titleEn": "Step 1: Match 'A' at cell (0, 0)",
        "titleBn": "ধাপ ১: সেল (0, 0) তে 'A' মিল পাওয়া গেল",
        "descEn": "board[0][0] == 'A'. Mark (0, 0) visited '#'. Next: Move Right to (0, 1).",
        "descBn": "board[0][0] == 'A'। (0, 0) কভার্ড '#' মার্ক। পরবর্তী: ডানে (0, 1) তে স্থানান্তর।",
      },
      {
        "step": 2,
        "cell": "(0, 1)",
        "char": "B",
        "matched": "AB",
        "badge": "MATCH 'B'",
        "badgeColor": AppTheme.accentAmber,
        "titleEn": "Step 2: Move Right to (0, 1) ➔ Match 'B'",
        "titleBn": "ধাপ ২: ডানে (0, 1) তে স্থানান্তর ➔ 'B' মিল",
        "descEn": "board[0][1] == 'B'. Mark (0, 1) visited '#'. Next: Move Right to (0, 2).",
        "descBn": "board[0][1] == 'B'। (0, 1) কভার্ড '#' মার্ক। পরবর্তী: ডানে (0, 2) তে স্থানান্তর।",
      },
      {
        "step": 3,
        "cell": "(0, 2)",
        "char": "C",
        "matched": "ABC",
        "badge": "MATCH 'C'",
        "badgeColor": AppTheme.accentAmber,
        "titleEn": "Step 3: Move Right to (0, 2) ➔ Match 'C'",
        "titleBn": "ধাপ ৩: ডানে (0, 2) তে স্থানান্তর ➔ 'C' মিল",
        "descEn": "board[0][2] == 'C'. Mark visited '#'. Next: Move Down to (1, 2).",
        "descBn": "board[0][2] == 'C'। (0, 2) ভিজিটেড। পরবর্তী: নিচে (1, 2) তে স্থানান্তর।",
      },
      {
        "step": 4,
        "cell": "(1, 2)",
        "char": "C",
        "matched": "ABCC",
        "badge": "MATCH 'C'",
        "badgeColor": AppTheme.accentAmber,
        "titleEn": "Step 4: Move Down to (1, 2) ➔ Match second 'C'",
        "titleBn": "ধাপ ৪: নিচে (1, 2) তে স্থানান্তর ➔ দ্বিতীয় 'C' মিল",
        "descEn": "board[1][2] == 'C'. Mark visited '#'. Next: Move Down to (2, 2).",
        "descBn": "board[1][2] == 'C'। (1, 2) ভিজিটেড। পরবর্তী: নিচে (2, 2) তে স্থানান্তর।",
      },
      {
        "step": 5,
        "cell": "(2, 2)",
        "char": "E",
        "matched": "ABCCE",
        "badge": "MATCH 'E'",
        "badgeColor": AppTheme.accentPurple,
        "titleEn": "Step 5: Move Down to (2, 2) ➔ Match 'E'",
        "titleBn": "ধাপ ৫: নিচে (2, 2) তে স্থানান্তর ➔ 'E' মিল",
        "descEn": "board[2][2] == 'E'. Mark visited '#'. Next: Move Left to (2, 1).",
        "descBn": "board[2][2] == 'E'। (2, 2) ভিজিটেড। পরবর্তী: বামে (2, 1) তে স্থানান্তর।",
      },
      {
        "step": 6,
        "cell": "(2, 1)",
        "char": "D",
        "matched": "ABCCED",
        "badge": "🎉 WORD FOUND",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 6: Move Left to (2, 1) ➔ Match final 'D' 🎉!",
        "titleBn": "ধাপ ৬: বামে (2, 1) তে স্থানান্তর ➔ শেষ 'D' মিল 🎉!",
        "descEn": "Matched full word \"ABCCED\"! Returns true!",
        "descBn": "সম্পূর্ণ শব্দ \"ABCCED\" জেনারেট সম্পন্ন! true রিটার্ন!",
      },
    ];

    final currentStep = stepFlowData[_flowStepIndex.clamp(0, stepFlowData.length - 1)];
    final String activeCell = currentStep["cell"] as String;
    final String activeChar = currentStep["char"] as String;
    final String matchedStr = currentStep["matched"] as String;
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
                _isEnglish ? "1. Step-by-Step Grid Search Flowcard" : "১. স্টেপ-বাই-স্টেপ গ্রিড সার্চ ফ্লো-কার্ড",
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
                ? "Watch how 4-directional DFS traverses grid cells to match target word."
                : "৪-দিকমুখী DFS কীভাবে ধাপে ধাপে গ্রিড সেলে টার্গেট শব্দ মেলায় তা দেখুন।",
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

                // Active Cell & Matched String Box
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Active Cell: $activeCell ('$activeChar')", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
                    Text("Matched: ${matchedStr.length} / ${_targetWord.length}", style: const TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 12)),
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
                    "\"$matchedStr\"",
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

  // MODEL 2: 2D Grid Navigator
  Widget _buildGridNavigatorModel() {
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
            _isEnglish ? "2. Interactive 2D Grid Cell Navigator" : "২. ইন্টারঅ্যাক্টিভ ২ডি গ্রিড সেল নেভিগেটর",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            _isEnglish
                ? "4-directional moves (Up, Down, Left, Right) from active cell (r, c)."
                : "অ্যাক্টিভ সেল (r, c) থেকে ৪-দিকমুখী (উপরে, নিচে, বামে, ডানে) মুভমেন্ট।",
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 16),

          // 2D Grid Representation
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.accentPurple),
            ),
            child: Column(
              children: List.generate(_board.length, (r) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_board[r].length, (c) {
                    bool isPath = (r == 0 && c == 0) || (r == 0 && c == 1) || (r == 0 && c == 2) || (r == 1 && c == 2) || (r == 2 && c == 2) || (r == 2 && c == 1);
                    return Container(
                      width: 48,
                      height: 48,
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: isPath ? AppTheme.accentGreen.withOpacity(0.3) : const Color(0xFF090D16),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: isPath ? AppTheme.accentGreen : const Color(0xFF1E293B), width: isPath ? 2 : 1),
                      ),
                      child: Center(
                        child: Text(
                          _board[r][c],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isPath ? AppTheme.accentNeonCyan : Colors.white,
                          ),
                        ),
                      ),
                    );
                  }),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // MODEL 3: Visited Marker Rule
  Widget _buildVisitedMarkerModel() {
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
            _isEnglish ? "3. Visited Cell In-Place Marker Rule ('#')" : "৩. ভিজিটেড সেল ইন-প্লেস মার্কার নিয়ম ('#')",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            _isEnglish
                ? "Temporarily replace board[r][c] = '#' to prevent cycles. Restore board[r][c] = temp on backtrack!"
                : "চক্র প্রতিরোধে সাময়িকভাবে board[r][c] = '#' মার্ক করা হয় এবং ব্যাকট্র্যাকে মূল মান পুনর্বহাল হয়!",
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
              "char temp = board[r][c]; board[r][c] = '#'; // Recurse ... board[r][c] = temp;",
              style: TextStyle(fontFamily: 'monospace', fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.accentGreen),
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
          // Preset Selector Bar
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
                const Text("Select Target Word Preset:", style: TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildPresetChip(0, "word = \"ABCCED\" (True)"),
                      _buildPresetChip(1, "word = \"SEE\" (True)"),
                      _buildPresetChip(2, "word = \"ABCB\" (False)"),
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
                  _buildWordSearchCanvas(step),
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildCodeHighlightBox(step.activeLine)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildWordSearchCanvas(step)),
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
                  ? "Tap grid cells sequentially to trace target word \"$_targetWord\"!"
                  : "টার্গেট শব্দ \"$_targetWord\" তৈরি করতে গ্রিড সেলগুলোতে পরপর স্পর্শ করুন!",
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
                        _isEnglish ? "Matched: ${_practiceMatchedStr.length} / ${_targetWord.length} Chars" : "মিলেছে: ${_practiceMatchedStr.length} / ${_targetWord.length} টি বর্ণ",
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      Text(
                        "${((_practiceMatchedStr.length / _targetWord.length) * 100).clamp(0, 100).toInt()}%",
                        style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: _targetWord.isEmpty ? 0.0 : (_practiceMatchedStr.length / _targetWord.length).clamp(0.0, 1.0),
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

            // Practice Grid Interactive Canvas
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF090D16),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.accentPurple),
              ),
              child: Column(
                children: [
                  Text("Target: \"$_targetWord\"", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 12),
                  Column(
                    children: List.generate(_board.length, (r) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(_board[r].length, (c) {
                          bool isSelected = _practicePath.any((pos) => pos[0] == r && pos[1] == c);
                          return GestureDetector(
                            onTap: () => _handlePracticeCellTap(r, c),
                            child: Container(
                              width: 52,
                              height: 52,
                              margin: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: isSelected ? AppTheme.accentGreen.withOpacity(0.3) : AppTheme.surfaceDark,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: isSelected ? AppTheme.accentGreen : const Color(0xFF1E293B), width: isSelected ? 2 : 1),
                              ),
                              child: Center(
                                child: Text(
                                  _board[r][c],
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected ? AppTheme.accentNeonCyan : Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      );
                    }),
                  ),
                  const SizedBox(height: 10),
                  if (_practiceHistory.isNotEmpty)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        icon: const Icon(Icons.undo, size: 16, color: AppTheme.accentAmber),
                        label: Text(_isEnglish ? "Undo Move" : "ধাপ বাতিল", style: const TextStyle(color: AppTheme.accentAmber, fontSize: 12)),
                        onPressed: _undoPracticeMove,
                      ),
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

  // Helper Widgets
  Widget _buildPresetChip(int index, String label) {
    final isSelected = _presetIndex == index;
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        selectedColor: AppTheme.accentPurple,
        backgroundColor: const Color(0xFF090D16),
        labelStyle: TextStyle(color: isSelected ? Colors.white : AppTheme.accentNeonCyan, fontSize: 11),
        onSelected: (selected) {
          if (selected) {
            setState(() {
              _presetIndex = index;
              _rebuildSteps();
            });
          }
        },
      ),
    );
  }

  Widget _buildCodeHighlightBox(int activeLine) {
    final codeLines = [
      "bool dfs(int r, int c, int k, vector<vector<char>>& board, string& word) {",
      "    if (k == word.size()) return true;",
      "    if (r < 0 || c < 0 || r >= m || c >= n || board[r][c] != word[k]) return false;",
      "    char temp = board[r][c];",
      "    board[r][c] = '#'; // Mark visited",
      "    bool found = dfs(r+1, c, k+1, board, word) || dfs(r-1, c, k+1, board, word) ||",
      "                 dfs(r, c+1, k+1, board, word) || dfs(r, c-1, k+1, board, word);",
      "    board[r][c] = temp; // Backtrack restore",
      "    return found;",
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

  Widget _buildWordSearchCanvas(WordSearchStep step) {
    Color decisionColor = AppTheme.accentPurple;
    String decisionLabel = "INIT";

    if (step.decision == "match_char") {
      decisionColor = AppTheme.accentAmber;
      decisionLabel = "▶ MATCH (${step.row}, ${step.col})";
    } else if (step.decision == "word_found") {
      decisionColor = AppTheme.accentGreen;
      decisionLabel = "🎉 WORD FOUND";
    } else if (step.decision == "mismatch" || step.decision == "visited") {
      decisionColor = AppTheme.accentPink;
      decisionLabel = "❌ FAILED / VISITED";
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

          // 2D Grid Canvas Display
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: decisionColor.withOpacity(0.5)),
            ),
            child: Column(
              children: List.generate(_board.length, (r) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_board[r].length, (c) {
                    bool isActive = step.row == r && step.col == c;
                    bool isMatched = step.matchedPath.any((pos) => pos[0] == r && pos[1] == c);

                    return Container(
                      width: 44,
                      height: 44,
                      margin: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: isActive
                            ? AppTheme.accentNeonCyan.withOpacity(0.4)
                            : (isMatched ? AppTheme.accentGreen.withOpacity(0.25) : const Color(0xFF090D16)),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isActive ? AppTheme.accentNeonCyan : (isMatched ? AppTheme.accentGreen : const Color(0xFF1E293B)),
                          width: isActive ? 2 : 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          isMatched && !isActive ? '#' : _board[r][c],
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: isActive ? Colors.white : (isMatched ? AppTheme.accentGreen : AppTheme.textSecondary),
                          ),
                        ),
                      ),
                    );
                  }),
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
    int m, n;
    bool dfs(int r, int c, int k, vector<vector<char>>& board, string& word) {
        if (k == word.size()) return true;
        if (r < 0 || c < 0 || r >= m || c >= n || board[r][c] != word[k]) return false;
        
        char temp = board[r][c];
        board[r][c] = '#'; // Mark visited
        
        bool found = dfs(r+1, c, k+1, board, word) || dfs(r-1, c, k+1, board, word) ||
                     dfs(r, c+1, k+1, board, word) || dfs(r, c-1, k+1, board, word);
                     
        board[r][c] = temp; // Backtrack restore
        return found;
    }

    bool exist(vector<vector<char>>& board, string word) {
        m = board.size(); n = board[0].size();
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (dfs(i, j, 0, board, word)) return true;
            }
        }
        return false;
    }
};""";
    } else if (lang == "Java") {
      code = """
class Solution {
    public boolean exist(char[][] board, String word) {
        int m = board.length, n = board[0].length;
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (dfs(i, j, 0, board, word)) return true;
            }
        }
        return false;
    }

    private boolean dfs(int r, int c, int k, char[][] board, String word) {
        if (k == word.length()) return true;
        if (r < 0 || c < 0 || r >= board.length || c >= board[0].length || board[r][c] != word.charAt(k)) return false;
        
        char temp = board[r][c];
        board[r][c] = '#';
        
        boolean found = dfs(r+1, c, k+1, board, word) || dfs(r-1, c, k+1, board, word) ||
                        dfs(r, c+1, k+1, board, word) || dfs(r, c-1, k+1, board, word);
                        
        board[r][c] = temp;
        return found;
    }
}""";
    } else {
      code = """
class Solution:
    def exist(self, board: List[List[str]], word: str) -> bool:
        m, n = len(board), len(board[0])

        def dfs(r, c, k):
            if k == len(word):
                return True
            if r < 0 or c < 0 or r >= m or c >= n or board[r][c] != word[k]:
                return False
            
            temp = board[r][c]
            board[r][c] = '#'
            
            found = (dfs(r+1, c, k+1) or dfs(r-1, c, k+1) or 
                     dfs(r, c+1, k+1) or dfs(r, c-1, k+1))
                     
            board[r][c] = temp
            return found

        for i in range(m):
            for j in range(n):
                if dfs(i, j, 0):
                    return True
        return False""";
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
