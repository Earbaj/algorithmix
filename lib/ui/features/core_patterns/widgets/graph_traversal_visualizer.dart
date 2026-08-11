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

class GraphTraversalVisualizer extends StatefulWidget {
  final bool isEnglish;

  const GraphTraversalVisualizer({super.key, required this.isEnglish});

  @override
  State<GraphTraversalVisualizer> createState() => _GraphTraversalVisualizerState();
}

class _GraphTraversalVisualizerState extends State<GraphTraversalVisualizer> {
  int _selectedTemplateIndex = 0;
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  final List<List<String>> _codeTemplates = const [
    // Template 1: Number of Islands DFS
    [
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
    ],
    // Template 2: Clone Graph BFS
    [
      "Node* cloneGraph(Node* node) {",
      "    if (!node) return nullptr;",
      "    unordered_map<Node*, Node*> mp; queue<Node*> q;",
      "    mp[node] = new Node(node->val); q.push(node); // Map original -> clone",
      "    while (!q.empty()) {",
      "        Node* u = q.front(); q.pop();",
      "        for (Node* neighbor : u->neighbors) {",
      "            if (!mp.count(neighbor)) { mp[neighbor] = new Node(neighbor->val); q.push(neighbor); }",
      "            mp[u]->neighbors.push_back(mp[neighbor]);",
      "        }",
      "    }",
      "    return mp[node];",
      "}",
    ],
    // Template 3: Is Graph Bipartite?
    [
      "bool isBipartite(vector<vector<int>>& graph) {",
      "    int n = graph.size(); vector<int> color(n, 0); // 0: uncolored, 1 & -1: 2 colors",
      "    for (int i = 0; i < n; i++) {",
      "        if (color[i] != 0) continue;",
      "        queue<int> q; q.push(i); color[i] = 1;",
      "        while (!q.empty()) {",
      "            int u = q.front(); q.pop();",
      "            for (int v : graph[u]) {",
      "                if (color[v] == 0) { color[v] = -color[u]; q.push(v); }",
      "                else if (color[v] == color[u]) return false; // Color conflict!",
      "            }",
      "        }",
      "    }",
      "    return true;",
      "}",
    ],
  ];

  final List<GraphTraversalStep> _template1Steps = const [
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

  final List<GraphTraversalStep> _template2Steps = const [
    GraphTraversalStep(
      activeNode: "1",
      activeLineIndex: 3,
      queueState: ["1"],
      visitedSet: ["1"],
      islandCount: 0,
      explanationEn: "Line 4: Map original Node 1 -> Clone Node 1. Queue = [1].",
      explanationBn: "লাইন ৪: অরিজিনাল নোড ১ -> ক্লোন নোড ১ ম্যাপিং। ক্যু = [1]।",
    ),
    GraphTraversalStep(
      activeNode: "2",
      activeLineIndex: 7,
      queueState: ["2"],
      visitedSet: ["1", "2"],
      islandCount: 0,
      explanationEn: "Line 8: Popped 1, visited neighbor 2. Created Clone Node 2. Queue = [2].",
      explanationBn: "লাইন ৮: নোড ১ পপ, প্রতিবেশী ২ ভিজিট ও ক্লোন তৈরি। ক্যু = [2]।",
    ),
    GraphTraversalStep(
      activeNode: "Finish",
      activeLineIndex: 11,
      queueState: [],
      visitedSet: ["1", "2", "3", "4"],
      islandCount: 0,
      explanationEn: "🎉 Line 12: Graph Cloning Completed! All nodes deep copied with exact adjacency edges!",
      explanationBn: "🎉 লাইন ১২: গ্রাফ ক্লোনিং সম্পন্ন! এডজসহ সব নোড সফলভাবে ক্লোন করা হয়েছে!",
    ),
  ];

  final List<GraphTraversalStep> _template3Steps = const [
    GraphTraversalStep(
      activeNode: "0",
      activeLineIndex: 4,
      queueState: ["0"],
      visitedSet: ["0 (Color: 1)"],
      islandCount: 0,
      explanationEn: "Line 5: Set Node 0 Color = 1. Queue = [0].",
      explanationBn: "লাইন ৫: নোড ০ এর রঙ = ১ সেট করে ক্যু-তে যোগ = [0]।",
    ),
    GraphTraversalStep(
      activeNode: "1",
      activeLineIndex: 8,
      queueState: ["1"],
      visitedSet: ["0 (Color: 1)", "1 (Color: -1)"],
      islandCount: 0,
      explanationEn: "Line 9: Neighbor 1 uncolored. Set Color = -1. Queue = [1].",
      explanationBn: "লাইন ৯: প্রতিবেশী ১ এর রঙ ছিল না। বিপরীত রঙ -১ দেওয়া হলো।",
    ),
    GraphTraversalStep(
      activeNode: "Finish",
      activeLineIndex: 13,
      queueState: [],
      visitedSet: ["0 (Color: 1)", "1 (Color: -1)", "2 (Color: 1)", "3 (Color: -1)"],
      islandCount: 0,
      explanationEn: "🎉 Line 14: 2-Coloring Successful! Graph IS Bipartite!",
      explanationBn: "🎉 লাইন ১৪: ২-কালারিং সফল! গ্রাফটি একটি বাইপারটাইট গ্রাফ!",
    ),
  ];

  List<GraphTraversalStep> get _currentSteps {
    if (_selectedTemplateIndex == 1) return _template2Steps;
    if (_selectedTemplateIndex == 2) return _template3Steps;
    return _template1Steps;
  }

  List<String> get _currentCodeLines {
    return _codeTemplates[_selectedTemplateIndex];
  }

  void _togglePlay() {
    setState(() => _isPlaying = !_isPlaying);
    if (_isPlaying) {
      _timer = Timer.periodic(const Duration(milliseconds: 1400), (timer) {
        if (_currentStepIndex < _currentSteps.length - 1) {
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
    if (_currentStepIndex < _currentSteps.length - 1) {
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
    final step = _currentSteps[_currentStepIndex];
    final isMobile = Responsive.isMobile(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Template Selector Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildTemplateChip(0, widget.isEnglish ? "Number of Islands DFS" : "দ্বীপের সংখ্যা DFS"),
              _buildTemplateChip(1, widget.isEnglish ? "Clone Graph BFS" : "ক্লোন গ্রাফ BFS"),
              _buildTemplateChip(2, widget.isEnglish ? "Is Graph Bipartite?" : "বাইপারটাইট টেস্ট"),
            ],
          ),
        ),
        const SizedBox(height: 16),

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
            widget.isEnglish ? step.explanationEn : step.explanationBn,
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
        const SizedBox(height: 16),

        // Code Snippet + Visualizer Box Layout
        if (isMobile)
          Column(
            children: [
              _buildCodeSnippetWithHighlight(_currentCodeLines, step.activeLineIndex),
              const SizedBox(height: 16),
              _buildTraversalCanvas(step),
            ],
          )
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildCodeSnippetWithHighlight(_currentCodeLines, step.activeLineIndex)),
              const SizedBox(width: 16),
              Expanded(child: _buildTraversalCanvas(step)),
            ],
          ),

        const SizedBox(height: 20),

        // Controls Bar
        _buildControlBar(),
      ],
    );
  }

  Widget _buildTemplateChip(int index, String label) {
    final isSelected = _selectedTemplateIndex == index;
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
        ),
        onSelected: (selected) {
          if (selected) {
            _timer?.cancel();
            setState(() {
              _selectedTemplateIndex = index;
              _currentStepIndex = 0;
              _isPlaying = false;
            });
          }
        },
      ),
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

  Widget _buildTraversalCanvas(GraphTraversalStep step) {
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
              Text("Active Node: [${step.activeNode}]", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13)),
              if (step.islandCount > 0)
                Text("Islands Count: [${step.islandCount}]", style: const TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 16),

          // Queue / Stack State
          const Text("Queue / Stack State:", style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.accentPurple.withOpacity(0.5)),
            ),
            child: step.queueState.isEmpty
                ? const Text("[ Queue Empty ]", style: TextStyle(color: AppTheme.textMuted, fontSize: 11))
                : Wrap(
                    spacing: 6,
                    children: step.queueState.map((q) {
                      return Chip(
                        backgroundColor: AppTheme.accentPurple,
                        label: Text(q, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                      );
                    }).toList(),
                  ),
          ),
          const SizedBox(height: 16),

          // Visited Set Canvas Inspector
          const Text("Visited Set / Node State Inspector:", style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.accentGreen.withOpacity(0.5)),
            ),
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: step.visitedSet.map((v) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(color: AppTheme.accentGreen, borderRadius: BorderRadius.circular(8)),
                  child: Text(v, style: const TextStyle(color: AppTheme.primaryDark, fontWeight: FontWeight.bold, fontSize: 11)),
                );
              }).toList(),
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
            widget.isEnglish
                ? "Step ${_currentStepIndex + 1} of ${_currentSteps.length}"
                : "ধাপ ${_currentStepIndex + 1} / ${_currentSteps.length}",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
