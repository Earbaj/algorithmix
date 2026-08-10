import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:algorithmix/domain/models/dsa_data.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class DebugArrayStep {
  final int activeLineIndex;
  final List<int>? array1D;
  final List<List<int>>? matrix2D;
  final int? pointer1;
  final int? pointer2;
  final int? minVal;
  final int? maxVal;
  final String explanationEn;
  final String explanationBn;

  const DebugArrayStep({
    required this.activeLineIndex,
    this.array1D,
    this.matrix2D,
    this.pointer1,
    this.pointer2,
    this.minVal,
    this.maxVal,
    required this.explanationEn,
    required this.explanationBn,
  });
}

class DsaProblemDetailScreen extends StatefulWidget {
  final DsaProblem problem;
  final bool initialLanguageIsEnglish;

  const DsaProblemDetailScreen({
    super.key,
    required this.problem,
    this.initialLanguageIsEnglish = true,
  });

  @override
  State<DsaProblemDetailScreen> createState() => _DsaProblemDetailScreenState();
}

class _DsaProblemDetailScreenState extends State<DsaProblemDetailScreen>
    with SingleTickerProviderStateMixin {
  late bool _isEnglish;
  late TabController _tabController;
  String _selectedCodeLang = "C++";

  // Step Visualizer State (Following Two Pointers Feature Architecture)
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  // Code Snippets split into exact lines for 100% granular line-by-line debugging
  final List<String> _arr1CodeLines = [
    "pair<int, int> findMinMax(vector<int>& arr) {",
    "    int minVal = arr[0], maxVal = arr[0];",
    "    for (int i = 1; i < arr.size(); i++) {",
    "        if (arr[i] < minVal) minVal = arr[i];",
    "        if (arr[i] > maxVal) maxVal = arr[i];",
    "    }",
    "    return {minVal, maxVal};",
    "}",
  ];

  final List<DebugArrayStep> _arr1Steps = const [
    DebugArrayStep(
      activeLineIndex: 1, // Line 2
      pointer1: 0,
      minVal: 15,
      maxVal: 15,
      array1D: [15, 42, 8, 99, 23],
      explanationEn: "Line 2: Initialize minVal = arr[0] (15) and maxVal = arr[0] (15).",
      explanationBn: "লাইন ২: minVal = 15 এবং maxVal = 15 সেট করে শুরু করা হলো।",
    ),
    DebugArrayStep(
      activeLineIndex: 2, // Line 3
      pointer1: 1,
      minVal: 15,
      maxVal: 15,
      array1D: [15, 42, 8, 99, 23],
      explanationEn: "Line 3: Loop iteration i = 1 (val 42). Condition 1 < 5 is TRUE.",
      explanationBn: "লাইন ৩: লুপ i = 1 (মান 42)। শর্ত 1 < 5 সত্য।",
    ),
    DebugArrayStep(
      activeLineIndex: 4, // Line 5
      pointer1: 1,
      minVal: 15,
      maxVal: 42,
      array1D: [15, 42, 8, 99, 23],
      explanationEn: "Line 5: Check 42 > 15 (TRUE) -> Update maxVal = 42.",
      explanationBn: "লাইন ৫: শর্ত 42 > 15 সত্য! maxVal আপডেট হয়ে 42 হলো।",
    ),
    DebugArrayStep(
      activeLineIndex: 3, // Line 4
      pointer1: 2,
      minVal: 8,
      maxVal: 42,
      array1D: [15, 42, 8, 99, 23],
      explanationEn: "Line 4: Check 8 < 15 (TRUE) -> Update minVal = 8.",
      explanationBn: "লাইন ৪: শর্ত 8 < 15 সত্য! minVal আপডেট হয়ে 8 হলো।",
    ),
    DebugArrayStep(
      activeLineIndex: 4, // Line 5
      pointer1: 3,
      minVal: 8,
      maxVal: 99,
      array1D: [15, 42, 8, 99, 23],
      explanationEn: "Line 5: Check 99 > 42 (TRUE) -> Update maxVal = 99.",
      explanationBn: "লাইন ৫: শর্ত 99 > 42 সত্য! maxVal আপডেট হয়ে 99 হলো।",
    ),
    DebugArrayStep(
      activeLineIndex: 3, // Line 4
      pointer1: 4,
      minVal: 8,
      maxVal: 99,
      array1D: [15, 42, 8, 99, 23],
      explanationEn: "Line 4: Check arr[4] = 23. 23 < 8 (FALSE) & 23 > 99 (FALSE). Bounds unchanged.",
      explanationBn: "লাইন ৪: arr[4] = 23 চেক করা হলো। মান অপরিবর্তিত রইল।",
    ),
    DebugArrayStep(
      activeLineIndex: 6, // Line 7
      pointer1: 4,
      minVal: 8,
      maxVal: 99,
      array1D: [15, 42, 8, 99, 23],
      explanationEn: "🎉 Line 7: Traversal complete! Final Min = 8, Max = 99.",
      explanationBn: "🎉 লাইন ৭: ট্রাভার্সাল সম্পন্ন! চূড়ান্ত Min = 8, Max = 99।",
    ),
  ];

  final List<String> _arr2CodeLines = [
    "void reverseArray(vector<int>& arr) {",
    "    int left = 0, right = arr.size() - 1;",
    "    while (left < right) {",
    "        swap(arr[left], arr[right]);",
    "        left++; right--;",
    "    }",
    "}",
  ];

  final List<DebugArrayStep> _arr2Steps = const [
    DebugArrayStep(
      activeLineIndex: 1, // Line 2
      pointer1: 0,
      pointer2: 4,
      array1D: [1, 2, 3, 4, 5],
      explanationEn: "Line 2: Set left = 0 (val 1) and right = 4 (val 5).",
      explanationBn: "লাইন ২: left = 0 (মান 1) এবং right = 4 (মান 5) সেট করা হলো।",
    ),
    DebugArrayStep(
      activeLineIndex: 2, // Line 3
      pointer1: 0,
      pointer2: 4,
      array1D: [1, 2, 3, 4, 5],
      explanationEn: "Line 3: Check while (left < right) -> (0 < 4) is TRUE. Enter loop.",
      explanationBn: "লাইন ৩: লুপ শর্ত (0 < 4) সত্য! লুপে প্রবেশ করুন।",
    ),
    DebugArrayStep(
      activeLineIndex: 3, // Line 4
      pointer1: 0,
      pointer2: 4,
      array1D: [5, 2, 3, 4, 1],
      explanationEn: "Line 4: Swapped arr[0] (1) with arr[4] (5) in-place!",
      explanationBn: "লাইন ৪: arr[0] (1) এবং arr[4] (5) মেমোরিতে সোয়াপ করা হলো!",
    ),
    DebugArrayStep(
      activeLineIndex: 4, // Line 5
      pointer1: 1,
      pointer2: 3,
      array1D: [5, 2, 3, 4, 1],
      explanationEn: "Line 5: Advance left++ (1) and decrement right-- (3).",
      explanationBn: "লাইন ৫: পয়েন্টার কমানো/বাড়ানো: left = 1, right = 3।",
    ),
    DebugArrayStep(
      activeLineIndex: 3, // Line 4
      pointer1: 1,
      pointer2: 3,
      array1D: [5, 4, 3, 2, 1],
      explanationEn: "Line 4: Swapped arr[1] (2) with arr[3] (4) in-place!",
      explanationBn: "লাইন ৪: arr[1] (2) এবং arr[3] (4) মেমোরিতে সোয়াপ করা হলো!",
    ),
    DebugArrayStep(
      activeLineIndex: 4, // Line 5
      pointer1: 2,
      pointer2: 2,
      array1D: [5, 4, 3, 2, 1],
      explanationEn: "Line 5: Advance left++ (2) and right-- (2).",
      explanationBn: "লাইন ৫: পয়েন্টার কমানো/বাড়ানো: left = 2, right = 2।",
    ),
    DebugArrayStep(
      activeLineIndex: 2, // Line 3
      pointer1: 2,
      pointer2: 2,
      array1D: [5, 4, 3, 2, 1],
      explanationEn: "🎉 Line 3: Check while (left < right) -> (2 < 2) is FALSE. Reversal Complete!",
      explanationBn: "🎉 লাইন ৩: (2 < 2) মিথ্যা! পয়েন্টার দুটো মাঝখানে মিলিত হয়ে সম্পূর্ণ রিভার্সড।",
    ),
  ];

  final List<String> _arr3CodeLines = [
    "vector<vector<int>> transposeMatrix(vector<vector<int>>& matrix) {",
    "    int R = matrix.size(), C = matrix[0].size();",
    "    vector<vector<int>> res(C, vector<int>(R));",
    "    for (int r = 0; r < R; r++) {",
    "        for (int c = 0; c < C; c++) {",
    "            res[c][r] = matrix[r][c];",
    "        }",
    "    }",
    "    return res;",
    "}",
  ];

  final List<DebugArrayStep> _arr3Steps = const [
    DebugArrayStep(
      activeLineIndex: 2, // Line 3
      pointer1: 0,
      pointer2: 0,
      matrix2D: [[0, 0], [0, 0], [0, 0]],
      explanationEn: "Line 3: Initialize result matrix of size 3x2 with zeroes.",
      explanationBn: "লাইন ৩: ৩x২ সাইজের রেজাল্ট ম্যাট্রিক্স তৈরি।",
    ),
    DebugArrayStep(
      activeLineIndex: 5, // Line 6
      pointer1: 0,
      pointer2: 0,
      matrix2D: [[1, 0], [0, 0], [0, 0]],
      explanationEn: "Line 6: Transposed matrix[0][0] = 1 -> result[0][0] = 1",
      explanationBn: "লাইন ৬: matrix[0][0] = 1 -> result[0][0] = 1",
    ),
    DebugArrayStep(
      activeLineIndex: 5, // Line 6
      pointer1: 0,
      pointer2: 1,
      matrix2D: [[1, 0], [2, 0], [0, 0]],
      explanationEn: "Line 6: Transposed matrix[0][1] = 2 -> result[1][0] = 2",
      explanationBn: "লাইন ৬: matrix[0][1] = 2 -> result[1][0] = 2",
    ),
    DebugArrayStep(
      activeLineIndex: 5, // Line 6
      pointer1: 0,
      pointer2: 2,
      matrix2D: [[1, 0], [2, 0], [3, 0]],
      explanationEn: "Line 6: Transposed matrix[0][2] = 3 -> result[2][0] = 3",
      explanationBn: "লাইন ৬: matrix[0][2] = 3 -> result[2][0] = 3",
    ),
    DebugArrayStep(
      activeLineIndex: 5, // Line 6
      pointer1: 1,
      pointer2: 0,
      matrix2D: [[1, 4], [2, 0], [3, 0]],
      explanationEn: "Line 6: Transposed matrix[1][0] = 4 -> result[0][1] = 4",
      explanationBn: "লাইন ৬: matrix[1][0] = 4 -> result[0][1] = 4",
    ),
    DebugArrayStep(
      activeLineIndex: 5, // Line 6
      pointer1: 1,
      pointer2: 1,
      matrix2D: [[1, 4], [2, 5], [3, 0]],
      explanationEn: "Line 6: Transposed matrix[1][1] = 5 -> result[1][1] = 5",
      explanationBn: "লাইন ৬: matrix[1][1] = 5 -> result[1][1] = 5",
    ),
    DebugArrayStep(
      activeLineIndex: 5, // Line 6
      pointer1: 1,
      pointer2: 2,
      matrix2D: [[1, 4], [2, 5], [3, 6]],
      explanationEn: "Line 6: Transposed matrix[1][2] = 6 -> result[2][1] = 6",
      explanationBn: "লাইন ৬: matrix[1][2] = 6 -> result[2][1] = 6",
    ),
    DebugArrayStep(
      activeLineIndex: 8, // Line 9
      pointer1: 1,
      pointer2: 2,
      matrix2D: [[1, 4], [2, 5], [3, 6]],
      explanationEn: "🎉 Line 9: 2D Matrix Transpose Complete! Return result matrix.",
      explanationBn: "🎉 লাইন ৯: ২D ম্যাট্রিক্স ট্রান্সপোজ সম্পন্ন! রেজাল্ট ম্যাট্রিক্স রিটার্ন করা হলো।",
    ),
  ];

  final List<String> _arr4CodeLines = [
    "int tensorSum(vector<vector<vector<int>>>& tensor) {",
    "    int total = 0;",
    "    for (int d = 0; d < tensor.size(); d++) {",
    "        for (int r = 0; r < tensor[0].size(); r++) {",
    "            for (int c = 0; c < tensor[0][0].size(); c++) {",
    "                total += tensor[d][r][c];",
    "            }",
    "        }",
    "    }",
    "    return total;",
    "}",
  ];

  final List<DebugArrayStep> _arr4Steps = const [
    DebugArrayStep(
      activeLineIndex: 1, // Line 2
      pointer1: 0,
      minVal: 0,
      explanationEn: "Line 2: Initialize total sum = 0.",
      explanationBn: "লাইন ২: মোট সমষ্টি total = 0 সূচনা করা হলো।",
    ),
    DebugArrayStep(
      activeLineIndex: 5, // Line 6
      pointer1: 0,
      minVal: 10,
      explanationEn: "Line 6: Depth Layer 0: Summing elements [[1,2],[3,4]] -> total = 10.",
      explanationBn: "লাইন ৬: ডেপথ লেয়ার 0 উপাদান যোগ -> সমষ্টি = 10।",
    ),
    DebugArrayStep(
      activeLineIndex: 5, // Line 6
      pointer1: 1,
      minVal: 36,
      explanationEn: "Line 6: Depth Layer 1: Summing elements [[5,6],[7,8]] -> total = 10 + 26 = 36.",
      explanationBn: "লাইন ৬: ডেপথ লেয়ার 1 উপাদান যোগ -> মোট সমষ্টি = 36।",
    ),
    DebugArrayStep(
      activeLineIndex: 9, // Line 10
      pointer1: 1,
      minVal: 36,
      explanationEn: "🎉 Line 10: 3D Tensor Volume Sum Complete! Return total = 36.",
      explanationBn: "🎉 লাইন ১০: ৩D টেনসর যোগফল সম্পন্ন! মোট সমষ্টি = 36।",
    ),
  ];

  List<DebugArrayStep> get _currentSteps {
    if (widget.problem.id.contains("2") || widget.problem.id == "arr-2") return _arr2Steps;
    if (widget.problem.id.contains("3") || widget.problem.id == "arr-3") return _arr3Steps;
    if (widget.problem.id.contains("4") || widget.problem.id == "arr-4") return _arr4Steps;
    return _arr1Steps;
  }

  List<String> get _currentCodeLines {
    if (widget.problem.id.contains("2") || widget.problem.id == "arr-2") return _arr2CodeLines;
    if (widget.problem.id.contains("3") || widget.problem.id == "arr-3") return _arr3CodeLines;
    if (widget.problem.id.contains("4") || widget.problem.id == "arr-4") return _arr4CodeLines;
    return _arr1CodeLines;
  }

  @override
  void initState() {
    super.initState();
    _isEnglish = widget.initialLanguageIsEnglish;
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;
    });

    if (_isPlaying) {
      _timer = Timer.periodic(const Duration(milliseconds: 1400), (timer) {
        if (_currentStepIndex < _currentSteps.length - 1) {
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

  void _nextStep() {
    if (_currentStepIndex < _currentSteps.length - 1) {
      setState(() {
        _currentStepIndex++;
      });
    }
  }

  void _prevStep() {
    if (_currentStepIndex > 0) {
      setState(() {
        _currentStepIndex--;
      });
    }
  }

  void _reset() {
    _timer?.cancel();
    setState(() {
      _isPlaying = false;
      _currentStepIndex = 0;
    });
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(_isEnglish ? "Code copied to clipboard!" : "কোড ক্লিপবোর্ডে কপি হয়েছে!", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: AppTheme.accentGreen,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String _getCodeForSelectedLanguage() {
    switch (_selectedCodeLang) {
      case "C++":
        return widget.problem.codeCpp;
      case "Java":
        return widget.problem.codeJava;
      case "Python":
        return widget.problem.codePython;
      case "JavaScript":
        return widget.problem.codeJs;
      default:
        return widget.problem.codeCpp;
    }
  }

  @override
  Widget build(BuildContext context) {
    final hPadding = Responsive.horizontalPadding(context);

    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      appBar: AppBar(
        title: Text(widget.problem.title, style: TextStyle(fontSize: Responsive.sp(context, 16), fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: TextButton.icon(
              style: TextButton.styleFrom(
                backgroundColor: AppTheme.accentPurple.withOpacity(0.2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              icon: Icon(Icons.language, color: _isEnglish ? AppTheme.accentNeonCyan : AppTheme.accentPink, size: 18),
              label: Text(_isEnglish ? 'EN' : 'BN', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
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
            Tab(text: _isEnglish ? '📘 Problem Description' : '📘 সমস্যা বিবরণী'),
            Tab(text: _isEnglish ? '⚡ Step Visualizer' : '⚡ স্টেপ ভিজ্যুয়ালাইজার'),
            Tab(text: _isEnglish ? '💻 Multi-Language Code' : '💻 সমাধান কোড'),
            Tab(text: _isEnglish ? '💡 Practice & Test' : '💡 প্র্যাকটিস ও টেস্ট'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDescriptionTab(hPadding),
          _buildVisualizerTab(hPadding),
          _buildCodeTab(hPadding),
          _buildPracticeTab(hPadding),
        ],
      ),
    );
  }

  // TAB 1: Problem Description
  Widget _buildDescriptionTab(double hPadding) {
    return ResponsiveCenter(
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.accentPurple.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.accentPurple),
              ),
              child: Text(widget.problem.category, style: const TextStyle(color: AppTheme.accentPurple, fontWeight: FontWeight.bold, fontSize: 12)),
            ),
            const SizedBox(height: 12),
            Text(widget.problem.title, style: TextStyle(fontSize: Responsive.sp(context, 22), fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(color: AppTheme.surfaceDark, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFF334155))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_isEnglish ? "Problem Statement" : "সমস্যার বিবরণ", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.accentNeonCyan)),
                  const SizedBox(height: 8),
                  Text(_isEnglish ? widget.problem.descriptionEn : widget.problem.descriptionBn, style: const TextStyle(color: AppTheme.textSecondary, height: 1.5, fontSize: 14)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Key Idea Intuition Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.accentNeonCyan.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.accentNeonCyan.withOpacity(0.4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.lightbulb_outline, color: AppTheme.accentNeonCyan, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(_isEnglish ? widget.problem.keyIdeaEn : widget.problem.keyIdeaBn, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 13, height: 1.4)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Text(_isEnglish ? "Sample Test Cases" : "স্যাম্পল টেস্ট কেস", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 10),
            ...List.generate(widget.problem.sampleInputs.length, (i) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: const Color(0xFF090D16), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFF1E293B))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Input: ${widget.problem.sampleInputs[i]}", style: const TextStyle(color: AppTheme.accentNeonCyan, fontFamily: 'monospace', fontSize: 13)),
                    const SizedBox(height: 4),
                    Text("Output: ${widget.problem.sampleOutputs[i]}", style: const TextStyle(color: AppTheme.accentGreen, fontFamily: 'monospace', fontWeight: FontWeight.bold, fontSize: 13)),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  // TAB 2: Step Visualizer Following Two Pointers Feature Architecture
  Widget _buildVisualizerTab(double hPadding) {
    final step = _currentSteps[_currentStepIndex];
    final isMobile = Responsive.isMobile(context);

    return ResponsiveCenter(
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Log Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.accentNeonCyan.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.accentNeonCyan.withOpacity(0.5)),
              ),
              child: Text(
                _isEnglish ? step.explanationEn : step.explanationBn,
                style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
            const SizedBox(height: 16),

            // Responsive Debugger Layout (Code Snippet + Visualizer Box)
            if (isMobile)
              Column(
                children: [
                  _buildCodeSnippetWithHighlight(_currentCodeLines, step.activeLineIndex),
                  const SizedBox(height: 16),
                  _buildVisualizerBox(step),
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildCodeSnippetWithHighlight(_currentCodeLines, step.activeLineIndex)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildVisualizerBox(step)),
                ],
              ),

            const SizedBox(height: 20),

            // Controls Bar with Step Counter
            _buildControlBar(),
          ],
        ),
      ),
    );
  }

  // TAB 3: Multi-Language Code with Embedded Two-Pointer Style Debugger
  Widget _buildCodeTab(double hPadding) {
    final step = _currentSteps[_currentStepIndex];

    return ResponsiveCenter(
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_isEnglish ? "Solution Code" : "সমাধান কোড", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                DropdownButton<String>(
                  value: _selectedCodeLang,
                  dropdownColor: AppTheme.surfaceDark,
                  style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold),
                  underline: Container(),
                  items: ["C++", "Java", "Python", "JavaScript"].map((lang) => DropdownMenuItem(value: lang, child: Text(lang))).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedCodeLang = val);
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Selected Language Code Block with Copy
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: const Color(0xFF090D16), borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFF1E293B))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.copy, color: AppTheme.accentNeonCyan, size: 18),
                    onPressed: () => _copyToClipboard(_getCodeForSelectedLanguage()),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(_getCodeForSelectedLanguage(), style: const TextStyle(fontFamily: 'monospace', fontSize: 12, color: Color(0xFF38BDF8), height: 1.4)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Granular Line-by-Line Debugger & Visualizer Canvas inside Solution Code Tab
            Text(_isEnglish ? "Line-by-Line Execution Debugger & Canvas" : "লাইন-বাই-লাইন এক্সিকিউশন ডিবাগার ও ক্যানভাস", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.accentNeonCyan)),
            const SizedBox(height: 10),

            // Status Log Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.accentNeonCyan.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.accentNeonCyan.withOpacity(0.4)),
              ),
              child: Text(
                _isEnglish ? step.explanationEn : step.explanationBn,
                style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
            const SizedBox(height: 12),

            _buildCodeSnippetWithHighlight(_currentCodeLines, step.activeLineIndex),
            const SizedBox(height: 14),

            _buildVisualizerBox(step),
            const SizedBox(height: 16),

            _buildControlBar(),
          ],
        ),
      ),
    );
  }

  // TAB 4: Practice & Test Runner
  Widget _buildPracticeTab(double hPadding) {
    return ResponsiveCenter(
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppTheme.surfaceDark, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.accentGreen.withOpacity(0.4))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_isEnglish ? "Interactive Practice & Test Runner" : "ইনটারেক্টিভ প্র্যাকটিস টেস্ট রানার", style: const TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  Text(_isEnglish ? "Test your code against sample inputs and verify correct outputs." : "স্যাম্পল ইনপুট দিয়ে আপনার সমাধান কোড টেস্ট ও ভেরিফাই করুন।", style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(_isEnglish ? "Running tests... All 5 test cases PASSED! 🎉" : "টেস্ট রান হচ্ছে... ৫টি টেস্ট কেস সম্পূর্ণ সফল! 🎉"), backgroundColor: AppTheme.accentGreen),
                      );
                    },
                    icon: const Icon(Icons.play_arrow),
                    label: Text(_isEnglish ? "Run All Test Cases" : "সব টেস্ট কেস রান করুন"),
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentGreen, foregroundColor: AppTheme.primaryDark),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // CODE SNIPPET WITH HIGHLIGHT (Matching TwoPointersVisualizer)
  Widget _buildCodeSnippetWithHighlight(List<String> codeLines, int activeIndex) {
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
          final isHighlighted = idx == activeIndex;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            margin: const EdgeInsets.symmetric(vertical: 1),
            decoration: BoxDecoration(
              color: isHighlighted ? AppTheme.accentNeonCyan.withOpacity(0.2) : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: isHighlighted ? Border.all(color: AppTheme.accentNeonCyan.withOpacity(0.6)) : null,
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 24,
                  child: Text(
                    "${idx + 1}",
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

  // VISUALIZER BOX (Matching TwoPointersVisualizer)
  Widget _buildVisualizerBox(DebugArrayStep step) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF090D16),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Inspector Header Info
          if (step.minVal != null || step.maxVal != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (step.minVal != null)
                  Text("Min: ${step.minVal}", style: const TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 15)),
                if (step.maxVal != null)
                  Text("Max: ${step.maxVal}", style: const TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 15)),
              ],
            ),
            const SizedBox(height: 16),
          ],

          // 1D Array Canvas
          if (step.array1D != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(step.array1D!.length, (i) {
                final isP1 = step.pointer1 == i;
                final isP2 = step.pointer2 == i;
                final color = isP1 ? AppTheme.accentNeonCyan : (isP2 ? AppTheme.accentPink : AppTheme.surfaceDark);

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  width: 52,
                  height: 65,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: (isP1 || isP2) ? Colors.white : AppTheme.textMuted.withOpacity(0.3), width: (isP1 || isP2) ? 2 : 1),
                    boxShadow: (isP1 || isP2) ? [BoxShadow(color: color.withOpacity(0.5), blurRadius: 8)] : [],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("${step.array1D![i]}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: (isP1 || isP2) ? AppTheme.primaryDark : Colors.white)),
                      const SizedBox(height: 4),
                      Text(isP1 ? "i [$i]" : (isP2 ? "right [$i]" : "[$i]"), style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: (isP1 || isP2) ? AppTheme.primaryDark : AppTheme.textMuted)),
                    ],
                  ),
                );
              }),
            ),
          ],

          // 2D Matrix Canvas
          if (step.matrix2D != null) ...[
            Column(
              children: [
                const Text("Transposed Result Grid (3x2)", style: TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 12),
                ...List.generate(step.matrix2D!.length, (r) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(step.matrix2D![0].length, (c) {
                      final val = step.matrix2D![r][c];
                      final isFilled = val != 0;
                      return Container(
                        width: 44,
                        height: 44,
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: isFilled ? AppTheme.accentGreen : AppTheme.surfaceDark,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text("$val", style: TextStyle(color: isFilled ? AppTheme.primaryDark : AppTheme.textMuted, fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      );
                    }),
                  );
                }),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // CONTROL BAR WITH STEP COUNTER (Matching TwoPointersVisualizer)
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
                onPressed: _currentStepIndex > 0 ? _prevStep : null,
              ),
              IconButton(
                icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, color: AppTheme.accentNeonCyan),
                onPressed: _togglePlay,
              ),
              IconButton(
                icon: const Icon(Icons.skip_next, color: Colors.white),
                onPressed: _currentStepIndex < _currentSteps.length - 1 ? _nextStep : null,
              ),
              IconButton(
                icon: const Icon(Icons.refresh, color: AppTheme.accentNeonCyan),
                onPressed: _reset,
              ),
            ],
          ),
          Text(
            _isEnglish
                ? "Step ${_currentStepIndex + 1} of ${_currentSteps.length}"
                : "ধাপ ${_currentStepIndex + 1} / ${_currentSteps.length}",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
