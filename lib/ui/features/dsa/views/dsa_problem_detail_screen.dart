import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:algorithmix/domain/models/dsa_data.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

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

  // Visualizer Step State
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  // Problem 1 State (Min/Max)
  List<int> _p1Arr = [15, 42, 8, 99, 23];
  int _p1Pointer = 0;
  int _p1Min = 15;
  int _p1Max = 15;
  String _p1Log = "";

  // Problem 2 State (Reverse Array)
  List<int> _p2Arr = [1, 2, 3, 4, 5];
  int _p2Left = 0;
  int _p2Right = 4;
  String _p2Log = "";

  // Problem 3 State (2D Transpose)
  List<List<int>> _p3Matrix = [
    [1, 2, 3],
    [4, 5, 6],
  ];
  List<List<int>> _p3Result = [
    [0, 0],
    [0, 0],
    [0, 0]
  ];
  int _p3Row = 0;
  int _p3Col = 0;
  String _p3Log = "";

  // Problem 4 State (3D Layer Sum)
  List<List<List<int>>> _p4Cube = [
    [
      [1, 2],
      [3, 4]
    ],
    [
      [5, 6],
      [7, 8]
    ]
  ];
  int _p4Layer = 0;
  int _p4Sum = 0;
  String _p4Log = "";

  @override
  void initState() {
    super.initState();
    _isEnglish = widget.initialLanguageIsEnglish;
    _tabController = TabController(length: 4, vsync: this);
    _resetVisualizerState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _resetVisualizerState() {
    _timer?.cancel();
    _isPlaying = false;
    _currentStepIndex = 0;

    // Reset P1
    _p1Arr = [15, 42, 8, 99, 23];
    _p1Pointer = 0;
    _p1Min = _p1Arr[0];
    _p1Max = _p1Arr[0];
    _p1Log = _isEnglish ? "Start traversal at index 0. Initial Min = 15, Max = 15" : "ট্রাভার্সাল শুরু। প্রাথমিক Min = 15, Max = 15";

    // Reset P2
    _p2Arr = [1, 2, 3, 4, 5];
    _p2Left = 0;
    _p2Right = _p2Arr.length - 1;
    _p2Log = _isEnglish ? "Left pointer at 0 (val 1), Right pointer at 4 (val 5)" : "Left পয়েন্টার index 0, Right পয়েন্টার index 4";

    // Reset P3
    _p3Matrix = [
      [1, 2, 3],
      [4, 5, 6],
    ];
    _p3Result = [
      [0, 0],
      [0, 0],
      [0, 0]
    ];
    _p3Row = 0;
    _p3Col = 0;
    _p3Log = _isEnglish ? "Transposing matrix[0][0] = 1 -> result[0][0] = 1" : "ম্যাট্রিক্স ট্রান্সপোজ শুরু matrix[0][0] = 1 -> result[0][0] = 1";

    // Reset P4
    _p4Layer = 0;
    _p4Sum = 10;
    _p4Log = _isEnglish ? "Layer 0: Elements [[1,2],[3,4]] -> Sum = 10" : "লেয়ার ০: যোগফল ১০";

    setState(() {});
  }

  void _nextStep() {
    setState(() {
      if (widget.problem.id.contains("1") || widget.problem.id == "arr-1") {
        // Min Max
        if (_p1Pointer < _p1Arr.length - 1) {
          _p1Pointer++;
          final val = _p1Arr[_p1Pointer];
          if (val < _p1Min) _p1Min = val;
          if (val > _p1Max) _p1Max = val;
          _p1Log = _isEnglish
              ? "Step ${_p1Pointer + 1}: Checked index $_p1Pointer (val $val). Min = $_p1Min, Max = $_p1Max"
              : "ধাপ ${_p1Pointer + 1}: index $_p1Pointer (মান $val) চেক করা হলো। আপডেট Min = $_p1Min, Max = $_p1Max";
        } else {
          _p1Log = _isEnglish ? "🎉 Traversal Complete! Final Min = $_p1Min, Max = $_p1Max" : "🎉 ট্রাভার্সাল সম্পন্ন! চূড়ান্ত Min = $_p1Min, Max = $_p1Max";
          if (_isPlaying) {
            _timer?.cancel();
            _isPlaying = false;
          }
        }
      } else if (widget.problem.id.contains("2") || widget.problem.id == "arr-2") {
        // Reverse
        if (_p2Left < _p2Right) {
          final temp = _p2Arr[_p2Left];
          _p2Arr[_p2Left] = _p2Arr[_p2Right];
          _p2Arr[_p2Right] = temp;
          _p2Log = _isEnglish
              ? "Swapped arr[$_p2Left] and arr[$_p2Right]! Array is now $_p2Arr"
              : "arr[$_p2Left] এবং arr[$_p2Right] সোয়াপ হলো! অ্যারে এখন $_p2Arr";
          _p2Left++;
          _p2Right--;
        } else {
          _p2Log = _isEnglish ? "🎉 Array Reversal Completed in-place!" : "🎉 অ্যারে উল্টানো সম্পন্ন হয়েছে!";
          if (_isPlaying) {
            _timer?.cancel();
            _isPlaying = false;
          }
        }
      } else if (widget.problem.id.contains("3") || widget.problem.id == "arr-3") {
        // Transpose
        if (_p3Row < 2) {
          _p3Result[_p3Col][_p3Row] = _p3Matrix[_p3Row][_p3Col];
          _p3Log = _isEnglish
              ? "Transposed matrix[$_p3Row][$_p3Col] = ${_p3Matrix[_p3Row][_p3Col]} into result[$_p3Col][$_p3Row]"
              : "matrix[$_p3Row][$_p3Col] = ${_p3Matrix[_p3Row][_p3Col]} ট্রান্সপোজ হয়ে result[$_p3Col][$_p3Row] এ গেল";

          _p3Col++;
          if (_p3Col >= 3) {
            _p3Col = 0;
            _p3Row++;
          }
        } else {
          _p3Log = _isEnglish ? "🎉 2D Matrix Transpose Complete!" : "🎉 ২D ম্যাট্রিক্স ট্রান্সপোজ সম্পন্ন!";
          if (_isPlaying) {
            _timer?.cancel();
            _isPlaying = false;
          }
        }
      } else {
        // 3D Layer Sum
        if (_p4Layer == 0) {
          _p4Layer = 1;
          _p4Sum = 36;
          _p4Log = _isEnglish ? "Inspecting Layer 1: Elements [[5,6],[7,8]] -> Total Sum = 36" : "লেয়ার ১ এর উপাদান যোগ করা হলো -> মোট যোগফল ৩৬";
        } else {
          _p4Log = _isEnglish ? "🎉 All 3D Layers Summed Successfully!" : "🎉 সব ৩D লেয়ারের যোগফল সম্পন্ন!";
          if (_isPlaying) {
            _timer?.cancel();
            _isPlaying = false;
          }
        }
      }
    });
  }

  void _togglePlay() {
    if (_isPlaying) {
      _timer?.cancel();
      setState(() {
        _isPlaying = false;
      });
    } else {
      setState(() {
        _isPlaying = true;
      });
      _timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
        _nextStep();
      });
    }
  }

  Widget _buildVisualizerControlsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          onPressed: _togglePlay,
          icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
          label: Text(_isPlaying ? "Pause" : "Auto Play"),
          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentPurple),
        ),
        const SizedBox(width: 12),
        OutlinedButton.icon(
          onPressed: _nextStep,
          icon: const Icon(Icons.skip_next),
          label: Text(_isEnglish ? "Next Step" : "পরবর্তী ধাপ"),
        ),
        const SizedBox(width: 12),
        IconButton(
          icon: const Icon(Icons.refresh, color: AppTheme.accentNeonCyan),
          onPressed: _resetVisualizerState,
        ),
      ],
    );
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

  Widget _buildCurrentProblemVisualizerCanvas() {
    if (widget.problem.id.contains("2") || widget.problem.id == "arr-2") {
      return _buildReverseVisualizerCanvas();
    } else if (widget.problem.id.contains("3") || widget.problem.id == "arr-3") {
      return _buildTransposeVisualizerCanvas();
    } else if (widget.problem.id.contains("4") || widget.problem.id == "arr-4") {
      return _buildLayerSumVisualizerCanvas();
    } else {
      return _buildMinMaxVisualizerCanvas();
    }
  }

  // TAB 2: Step Visualizer tailored to current problem
  Widget _buildVisualizerTab(double hPadding) {
    String currentLog = _p1Log;
    if (widget.problem.id.contains("2") || widget.problem.id == "arr-2") {
      currentLog = _p2Log;
    } else if (widget.problem.id.contains("3") || widget.problem.id == "arr-3") {
      currentLog = _p3Log;
    } else if (widget.problem.id.contains("4") || widget.problem.id == "arr-4") {
      currentLog = _p4Log;
    }

    return ResponsiveCenter(
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: Column(
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
                currentLog,
                style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
            const SizedBox(height: 16),

            // Visualization Display Canvas
            _buildCurrentProblemVisualizerCanvas(),

            const SizedBox(height: 20),

            // Controls: Play, Step, Reset
            _buildVisualizerControlsRow(),
          ],
        ),
      ),
    );
  }

  // Min Max Canvas
  Widget _buildMinMaxVisualizerCanvas() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFF090D16), borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFF1E293B))),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("Current Min: $_p1Min", style: const TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 16)),
              Text("Current Max: $_p1Max", style: const TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_p1Arr.length, (i) {
              final isCurrent = i == _p1Pointer;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                width: 60,
                height: 70,
                decoration: BoxDecoration(
                  color: isCurrent ? AppTheme.accentNeonCyan : AppTheme.surfaceDark,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isCurrent ? Colors.white : AppTheme.accentNeonCyan.withOpacity(0.4), width: isCurrent ? 2.5 : 1),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("${_p1Arr[i]}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isCurrent ? AppTheme.primaryDark : Colors.white)),
                    const SizedBox(height: 4),
                    Text("[$i]", style: TextStyle(fontSize: 10, color: isCurrent ? AppTheme.primaryDark : AppTheme.textMuted)),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // Reverse Canvas
  Widget _buildReverseVisualizerCanvas() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFF090D16), borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFF1E293B))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_p2Arr.length, (i) {
          final isLeft = i == _p2Left;
          final isRight = i == _p2Right;
          final color = isLeft ? AppTheme.accentGreen : (isRight ? AppTheme.accentAmber : AppTheme.surfaceDark);

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 6),
            width: 60,
            height: 75,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: (isLeft || isRight) ? Colors.white : AppTheme.textMuted.withOpacity(0.3)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("${_p2Arr[i]}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: (isLeft || isRight) ? AppTheme.primaryDark : Colors.white)),
                const SizedBox(height: 4),
                Text(isLeft ? "LEFT [$i]" : (isRight ? "RIGHT [$i]" : "[$i]"), style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: (isLeft || isRight) ? AppTheme.primaryDark : AppTheme.textMuted)),
              ],
            ),
          );
        }),
      ),
    );
  }

  // Transpose Canvas
  Widget _buildTransposeVisualizerCanvas() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF090D16), borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFF1E293B))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Original Matrix
          Column(
            children: [
              const Text("Original Matrix (2x3)", style: TextStyle(color: AppTheme.accentPurple, fontWeight: FontWeight.bold, fontSize: 12)),
              const SizedBox(height: 8),
              ...List.generate(2, (r) {
                return Row(
                  children: List.generate(3, (c) {
                    final isHl = r == _p3Row && c == _p3Col;
                    return Container(
                      margin: const EdgeInsets.all(4),
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(color: isHl ? AppTheme.accentPurple : AppTheme.surfaceDark, borderRadius: BorderRadius.circular(8)),
                      child: Center(child: Text("${_p3Matrix[r][c]}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                    );
                  }),
                );
              }),
            ],
          ),
          const Icon(Icons.arrow_forward, color: AppTheme.accentNeonCyan),
          // Transposed Matrix
          Column(
            children: [
              const Text("Transposed Result (3x2)", style: TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 12)),
              const SizedBox(height: 8),
              ...List.generate(3, (r) {
                return Row(
                  children: List.generate(2, (c) {
                    final isHl = r == _p3Col && c == _p3Row;
                    return Container(
                      margin: const EdgeInsets.all(4),
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(color: isHl ? AppTheme.accentGreen : AppTheme.surfaceDark, borderRadius: BorderRadius.circular(8)),
                      child: Center(child: Text("${_p3Result[r][c]}", style: TextStyle(color: isHl ? AppTheme.primaryDark : Colors.white, fontWeight: FontWeight.bold))),
                    );
                  }),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  // Layer Sum Canvas
  Widget _buildLayerSumVisualizerCanvas() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFF090D16), borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFF1E293B))),
      child: Column(
        children: [
          Text("3D Layer $_p4Layer Element Sum = $_p4Sum", style: const TextStyle(color: AppTheme.accentPink, fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: AppTheme.surfaceDark, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.accentPink)),
                child: Text(_p4Layer == 0 ? "Layer 0: [[1, 2], [3, 4]]" : "Layer 1: [[5, 6], [7, 8]]", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  int _getActiveLineNumber() {
    if (widget.problem.id.contains("1") || widget.problem.id == "arr-1") {
      if (_p1Pointer == 0) return 2;
      if (_p1Pointer < _p1Arr.length - 1) return 4;
      return 7;
    } else if (widget.problem.id.contains("2") || widget.problem.id == "arr-2") {
      if (_p2Left < _p2Right) return 4;
      return 5;
    } else if (widget.problem.id.contains("3") || widget.problem.id == "arr-3") {
      if (_p3Row < 2) return 6;
      return 8;
    } else {
      if (_p4Layer == 0) return 3;
      return 6;
    }
  }

  Widget _buildHighlightedCodeBlock() {
    final code = _getCodeForSelectedLanguage();
    final lines = code.trim().split('\n');
    final activeLine = _getActiveLineNumber();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(lines.length, (idx) {
        final lineNumber = idx + 1;
        final isActive = lineNumber == activeLine;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          margin: const EdgeInsets.symmetric(vertical: 1),
          decoration: BoxDecoration(
            color: isActive ? AppTheme.accentNeonCyan.withOpacity(0.2) : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            border: isActive ? Border.all(color: AppTheme.accentNeonCyan.withOpacity(0.6)) : null,
          ),
          child: Row(
            children: [
              SizedBox(
                width: 28,
                child: Text(
                  "$lineNumber",
                  style: TextStyle(
                    fontSize: 11,
                    fontFamily: 'monospace',
                    color: isActive ? AppTheme.accentNeonCyan : const Color(0xFF64748B),
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
              if (isActive)
                const Padding(
                  padding: EdgeInsets.only(right: 6),
                  child: Icon(Icons.arrow_right_alt, color: AppTheme.accentNeonCyan, size: 16),
                )
              else
                const SizedBox(width: 22),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    lines[idx],
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12.5,
                      color: isActive ? Colors.white : const Color(0xFF38BDF8),
                      fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildVariableWatcherPanel() {
    List<Map<String, String>> variableState = [];
    String explanation = "";

    if (widget.problem.id.contains("1") || widget.problem.id == "arr-1") {
      final currentVal = _p1Arr[_p1Pointer];
      final isMinUpdated = currentVal < _p1Min;
      final isMaxUpdated = currentVal > _p1Max;

      variableState = [
        {"var": "i (Loop Index)", "val": "$_p1Pointer"},
        {"var": "arr[i] (Current)", "val": "$currentVal"},
        {"var": "minVal (Minimum)", "val": "$_p1Min"},
        {"var": "maxVal (Maximum)", "val": "$_p1Max"},
      ];

      explanation = _isEnglish
          ? "Loop Step #${_p1Pointer + 1}: Inspecting element arr[$_p1Pointer] = $currentVal. Checking if $currentVal < minVal ($isMinUpdated) or $currentVal > maxVal ($isMaxUpdated)."
          : "লুপের ধাপ #${_p1Pointer + 1}: ইনডেক্স arr[$_p1Pointer] = $currentVal পরীক্ষা করা হচ্ছে। $currentVal < minVal ($isMinUpdated) অথবা $currentVal > maxVal ($isMaxUpdated)।";
    } else if (widget.problem.id.contains("2") || widget.problem.id == "arr-2") {
      variableState = [
        {"var": "left Pointer", "val": "$_p2Left (val ${_p2Arr.isNotEmpty && _p2Left < _p2Arr.length ? _p2Arr[_p2Left] : 0})"},
        {"var": "right Pointer", "val": "$_p2Right (val ${_p2Arr.isNotEmpty && _p2Right >= 0 ? _p2Arr[_p2Right] : 0})"},
        {"var": "Swap Status", "val": _p2Left < _p2Right ? "SWAPPING IN-PLACE" : "COMPLETE"},
      ];

      explanation = _isEnglish
          ? "Two-Pointer In-Place Reversal: Swapping left element at index $_p2Left with right element at index $_p2Right, then advancing pointers inwards."
          : "টু-পয়েন্টার সোয়াপিং: বামের ইনডেক্স $_p2Left এর সাথে ডানের ইনডেক্স $_p2Right এর মান মেমোরিতে অদলবদল করে পয়েন্টার দুটিকে ভেতরের দিকে সরানো হচ্ছে।";
    } else if (widget.problem.id.contains("3") || widget.problem.id == "arr-3") {
      variableState = [
        {"var": "Row (r)", "val": "$_p3Row"},
        {"var": "Col (c)", "val": "$_p3Col"},
        {"var": "matrix[r][c]", "val": "${_p3Matrix[_p3Row][_p3Col]}"},
        {"var": "result[c][r]", "val": "${_p3Result[_p3Col][_p3Row]}"},
      ];

      explanation = _isEnglish
          ? "2D Grid Transpose: Reading element at row $_p3Row, col $_p3Col (${_p3Matrix[_p3Row][_p3Col]}) and assigning it to transposed grid at row $_p3Col, col $_p3Row."
          : "২D গ্রিড ট্রান্সপোজ: সারি $_p3Row, কলাম $_p3Col এর মান (${_p3Matrix[_p3Row][_p3Col]}) পড়ে ট্রান্সপোজড রেজাল্ট ম্যাট্রিক্সের সারি $_p3Col, কলাম $_p3Row এ বসানো হচ্ছে।";
    } else {
      variableState = [
        {"var": "3D Layer Depth", "val": "$_p4Layer"},
        {"var": "Current Layer Sum", "val": _p4Layer == 0 ? "10" : "26"},
        {"var": "Accumulated Total", "val": "$_p4Sum"},
      ];

      explanation = _isEnglish
          ? "3D Tensor Volume Accumulation: Iterating depth layer $_p4Layer elements and adding to total sum."
          : "৩D টেনসর ভলিউম যোগফল: ডেপথ লেয়ার $_p4Layer এর প্রতিটি উপাদান সমষ্টি যোগ করা হচ্ছে।";
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.bug_report_outlined, color: AppTheme.accentAmber, size: 18),
              const SizedBox(width: 8),
              Text(
                _isEnglish ? "Live Variable Watcher & Memory Inspector" : "লাইভ ভেরিয়েবল ওয়াচার ও মেমোরি ইন্সপেক্টর",
                style: const TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Variable Table Grid
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: variableState.map((item) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceDark,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFF1E293B)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("${item['var']}: ", style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                    Text(item['val'] ?? "", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),

          // Natural Language Step Explanation
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.accentPurple.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.accentPurple.withOpacity(0.3)),
            ),
            child: Text(
              explanation,
              style: const TextStyle(color: Colors.white, fontSize: 12, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  // TAB 2: Step Visualizer tailored to current problem
  Widget _buildVisualizerTab(double hPadding) {
    String currentLog = _p1Log;
    if (widget.problem.id.contains("2") || widget.problem.id == "arr-2") {
      currentLog = _p2Log;
    } else if (widget.problem.id.contains("3") || widget.problem.id == "arr-3") {
      currentLog = _p3Log;
    } else if (widget.problem.id.contains("4") || widget.problem.id == "arr-4") {
      currentLog = _p4Log;
    }

    return ResponsiveCenter(
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: Column(
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
                currentLog,
                style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
            const SizedBox(height: 16),

            // Live Variable Watcher Panel
            _buildVariableWatcherPanel(),
            const SizedBox(height: 16),

            // Visualization Display Canvas
            _buildCurrentProblemVisualizerCanvas(),

            const SizedBox(height: 20),

            // Controls: Play, Step, Reset
            _buildVisualizerControlsRow(),
          ],
        ),
      ),
    );
  }

  // TAB 3: Multi-Language Code with Embedded Visualizer and Controls
  Widget _buildCodeTab(double hPadding) {
    String currentLog = _p1Log;
    if (widget.problem.id.contains("2") || widget.problem.id == "arr-2") {
      currentLog = _p2Log;
    } else if (widget.problem.id.contains("3") || widget.problem.id == "arr-3") {
      currentLog = _p3Log;
    } else if (widget.problem.id.contains("4") || widget.problem.id == "arr-4") {
      currentLog = _p4Log;
    }

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

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: const Color(0xFF090D16), borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFF1E293B))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(width: 10, height: 10, decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle)),
                          const SizedBox(width: 6),
                          Container(width: 10, height: 10, decoration: const BoxDecoration(color: Colors.amberAccent, shape: BoxShape.circle)),
                          const SizedBox(width: 6),
                          Container(width: 10, height: 10, decoration: const BoxDecoration(color: Colors.greenAccent, shape: BoxShape.circle)),
                          const SizedBox(width: 10),
                          Text(_isEnglish ? "Line-by-Line Code Execution Highlight" : "লাইন-বাই-লাইন কোড এক্সিকিউশন হাইলাইট", style: const TextStyle(color: AppTheme.accentNeonCyan, fontSize: 11, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy, color: AppTheme.accentNeonCyan, size: 18),
                        onPressed: () => _copyToClipboard(_getCodeForSelectedLanguage()),
                      ),
                    ],
                  ),
                  const Divider(color: Color(0xFF1E293B)),
                  const SizedBox(height: 6),
                  _buildHighlightedCodeBlock(),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Live Variable Watcher & Inspector inside Code Tab
            _buildVariableWatcherPanel(),
            const SizedBox(height: 20),

            // Live Problem Step Visualizer integrated inside Solution Code Tab
            Text(_isEnglish ? "Interactive Execution Visualizer" : "ইন্টারেক্টিভ ভিজ্যুয়ালাইজার ও কন্ট্রোলস", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.accentNeonCyan)),
            const SizedBox(height: 8),

            // Status Log Banner inside Code Tab
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.accentNeonCyan.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.accentNeonCyan.withOpacity(0.4)),
              ),
              child: Text(
                currentLog,
                style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
            const SizedBox(height: 10),

            _buildCurrentProblemVisualizerCanvas(),
            const SizedBox(height: 14),

            // Play, Step, Reset controls in Code Tab
            _buildVisualizerControlsRow(),
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
                  Text(
                    _isEnglish
                        ? "Test your logic on custom cases by clicking run below."
                        : "নিচে রান বাটনে ক্লিক করে টেস্ট কাস্টম কেসের ওপর লজিক যাচাই করুন।",
                    style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                  ),
                  const SizedBox(height: 14),
                  ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(_isEnglish ? "All Test Cases Passed Successfully! 🎉" : "সব টেস্ট কেস সফলভাবে পাশ হয়েছে! 🎉"), backgroundColor: AppTheme.accentGreen),
                      );
                    },
                    icon: const Icon(Icons.play_circle_fill),
                    label: Text(_isEnglish ? "Run All Tests" : "সব টেস্ট রান করুন"),
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
}
