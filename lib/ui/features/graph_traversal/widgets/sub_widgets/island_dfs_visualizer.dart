import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class GraphTraversalStep {
  final String activeNode;
  final int activeLineIndex;
  final List<String> queueState;
  final List<String> visitedSet;
  final int islandCount;
  final String explanationEn;
  final String explanationBn;

  const GraphTraversalStep({
    required this.activeNode,
    required this.activeLineIndex,
    required this.queueState,
    required this.visitedSet,
    required this.islandCount,
    required this.explanationEn,
    required this.explanationBn,
  });
}

class IslandDFSVisualizer extends StatefulWidget {
  final bool isEnglish;

  const IslandDFSVisualizer({super.key, required this.isEnglish});

  @override
  State<IslandDFSVisualizer> createState() => _IslandDFSVisualizerState();
}

class _IslandDFSVisualizerState extends State<IslandDFSVisualizer> {
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  final List<String> _codeLines = const [
    "int numIslands(vector<vector<char>>& grid) {",
    "    int count = 0;",
    "    for (int r = 0; r < grid.size(); r++) {",
    "        for (int c = 0; c < grid[0].size(); c++) {",
    "            if (grid[r][c] == '1') { count++; dfs(grid, r, c); } // Sink island!",
    "        }",
    "    }",
    "    return count;",
    "}",
    "void dfs(vector<vector<char>>& g, int r, int c) {",
    "    if (r < 0 || r >= g.size() || c < 0 || c >= g[0].size() || g[r][c] == '0') return;",
    "    g[r][c] = '0'; // Mark visited (sink land)",
    "    dfs(g, r+1, c); dfs(g, r-1, c); dfs(g, r, c+1); dfs(g, r, c-1);",
    "}",
  ];

  final List<GraphTraversalStep> _steps = const [
    GraphTraversalStep(
      activeNode: "(0,0)",
      activeLineIndex: 4,
      queueState: [],
      visitedSet: ["(0,0)"],
      islandCount: 1,
      explanationEn: "Line 5: Found land '1' at cell (0,0). Increment count = 1. Trigger DFS.",
      explanationBn: "লাইন ৫: ঘর (0,0) এ ভূমি '1' পাওয়া গেছে। কাউন্ট = ১ বাড়িয়ে DFS শুরু।",
    ),
    GraphTraversalStep(
      activeNode: "(0,1)",
      activeLineIndex: 11,
      queueState: [],
      visitedSet: ["(0,0)", "(0,1)"],
      islandCount: 1,
      explanationEn: "Line 12: DFS visiting adjacent land (0,1). Sink cell to '0'.",
      explanationBn: "লাইন ১২: DFS প্রতিবেশী ঘর (0,1) এ গেছে। জল করে '0' বানানো হলো।",
    ),
    GraphTraversalStep(
      activeNode: "(1,1)",
      activeLineIndex: 11,
      queueState: [],
      visitedSet: ["(0,0)", "(0,1)", "(1,1)"],
      islandCount: 1,
      explanationEn: "Line 12: DFS visiting (1,1). Sink cell to '0'. Recursion backtracking.",
      explanationBn: "লাইন ১২: DFS ঘর (1,1) এ গেছে। জল করে ব্যাকট্র্যাক।",
    ),
    GraphTraversalStep(
      activeNode: "(2,2)",
      activeLineIndex: 4,
      queueState: [],
      visitedSet: ["(0,0)", "(0,1)", "(1,1)", "(2,2)"],
      islandCount: 2,
      explanationEn: "Line 5: Found second disconnected island at (2,2)! Count = 2. Trigger DFS.",
      explanationBn: "লাইন ৫: ঘর (2,2) এ ২য় বিচ্ছিন্ন দ্বীপ পাওয়া গেছে! কাউন্ট = ২।",
    ),
    GraphTraversalStep(
      activeNode: "Finish",
      activeLineIndex: 7,
      queueState: [],
      visitedSet: ["(0,0)", "(0,1)", "(1,1)", "(2,2)"],
      islandCount: 2,
      explanationEn: "🎉 Line 8: Grid traversal completed! Total Island Count = 2!",
      explanationBn: "🎉 লাইন ৮: গ্রিড ট্রাভার্সাল সম্পন্ন! মোট দ্বীপ সংখ্যা = ২!",
    ),
  ];

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

  void _nextStep() {
    if (_currentStepIndex < _steps.length - 1) {
      setState(() => _currentStepIndex++);
    }
  }

  void _prevStep() {
    if (_currentStepIndex > 0) {
      setState(() => _currentStepIndex--);
    }
  }

  void _reset() {
    _timer?.cancel();
    setState(() {
      _isPlaying = false;
      _currentStepIndex = 0;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final step = _steps[_currentStepIndex];
    final isMobile = Responsive.isMobile(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: step.activeLineIndex == 7 ? AppTheme.accentGreen.withOpacity(0.15) : AppTheme.accentNeonCyan.withOpacity(0.15),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: step.activeLineIndex == 7 ? AppTheme.accentGreen : AppTheme.accentNeonCyan),
          ),
          child: Text(
            widget.isEnglish ? step.explanationEn : step.explanationBn,
            style: TextStyle(
              color: step.activeLineIndex == 7 ? AppTheme.accentGreen : AppTheme.accentNeonCyan,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(height: 16),

        if (isMobile)
          Column(
            children: [
              _buildCodeSnippetWithHighlight(_codeLines, step.activeLineIndex),
              const SizedBox(height: 16),
              _buildCanvas(step),
            ],
          )
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildCodeSnippetWithHighlight(_codeLines, step.activeLineIndex)),
              const SizedBox(width: 16),
              Expanded(child: _buildCanvas(step)),
            ],
          ),

        const SizedBox(height: 20),
        _buildControlBar(),
      ],
    );
  }

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
              color: isHighlighted ? AppTheme.accentPurple.withOpacity(0.25) : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: isHighlighted ? Border.all(color: AppTheme.accentPurple) : null,
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

  Widget _buildCanvas(GraphTraversalStep step) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Active DFS Cell: ${step.activeNode}", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13)),
              Text("Islands: [${step.islandCount}]", style: const TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 16),
          const Text("Sunk Visited Land Cells:", style: TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: step.visitedSet.map((cell) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.accentGreen.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppTheme.accentGreen),
                ),
                child: Text(
                  cell,
                  style: const TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              );
            }).toList(),
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
                onPressed: _currentStepIndex > 0 ? _prevStep : null,
              ),
              IconButton(
                icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, color: AppTheme.accentNeonCyan),
                onPressed: _togglePlay,
              ),
              IconButton(
                icon: const Icon(Icons.skip_next, color: Colors.white),
                onPressed: _currentStepIndex < _steps.length - 1 ? _nextStep : null,
              ),
              IconButton(
                icon: const Icon(Icons.refresh, color: AppTheme.accentNeonCyan),
                onPressed: _reset,
              ),
            ],
          ),
          Text(
            widget.isEnglish
                ? "Step ${_currentStepIndex + 1} of ${_steps.length}"
                : "ধাপ ${_currentStepIndex + 1} / ${_steps.length}",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
