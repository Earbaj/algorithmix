import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class TopologicalStep {
  final int activeNode;
  final int activeLineIndex;
  final List<int> queueState;
  final List<int> topologicalOrder;
  final Map<int, int> inDegrees;
  final String explanationEn;
  final String explanationBn;

  const TopologicalStep({
    required this.activeNode,
    required this.activeLineIndex,
    required this.queueState,
    required this.topologicalOrder,
    required this.inDegrees,
    required this.explanationEn,
    required this.explanationBn,
  });
}

class TopologicalSortVisualizer extends StatefulWidget {
  final bool isEnglish;

  const TopologicalSortVisualizer({super.key, required this.isEnglish});

  @override
  State<TopologicalSortVisualizer> createState() => _TopologicalSortVisualizerState();
}

class _TopologicalSortVisualizerState extends State<TopologicalSortVisualizer> {
  int _selectedTemplateIndex = 0;
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  final List<List<String>> _codeTemplates = const [
    // Template 1: Course Schedule II (Topological Order)
    [
      "vector<int> findOrder(int numCourses, vector<vector<int>>& prerequisites) {",
      "    vector<vector<int>> adj(numCourses); vector<int> inDegree(numCourses, 0);",
      "    for (auto& p : prerequisites) { adj[p[1]].push_back(p[0]); inDegree[p[0]]++; }",
      "    queue<int> q; for (int i = 0; i < numCourses; i++) if (inDegree[i] == 0) q.push(i);",
      "    vector<int> order;",
      "    while (!q.empty()) {",
      "        int u = q.front(); q.pop(); order.push_back(u); // Pop in-degree 0 node",
      "        for (int v : adj[u]) { if (--inDegree[v] == 0) q.push(v); }",
      "    }",
      "    return order.size() == numCourses ? order : vector<int>();",
      "}",
    ],
    // Template 2: Course Schedule (Cycle Detection)
    [
      "bool canFinish(int numCourses, vector<vector<int>>& prerequisites) {",
      "    vector<vector<int>> adj(numCourses); vector<int> inDegree(numCourses, 0);",
      "    for (auto& p : prerequisites) { adj[p[1]].push_back(p[0]); inDegree[p[0]]++; }",
      "    queue<int> q; for (int i = 0; i < numCourses; i++) if (inDegree[i] == 0) q.push(i);",
      "    int count = 0;",
      "    while (!q.empty()) {",
      "        int u = q.front(); q.pop(); count++;",
      "        for (int v : adj[u]) if (--inDegree[v] == 0) q.push(v);",
      "    }",
      "    return count == numCourses; // If count < N, cycle exists!",
      "}",
    ],
    // Template 3: Alien Dictionary
    [
      "string alienOrder(vector<string>& words) {",
      "    unordered_map<char, unordered_set<char>> adj; unordered_map<char, int> inDegree;",
      "    // Build character dependency graph from adjacent words comparison",
      "    queue<char> q; for (auto& p : inDegree) if (p.second == 0) q.push(p.first);",
      "    string order = \"\";",
      "    while (!q.empty()) {",
      "        char u = q.front(); q.pop(); order += u;",
      "        for (char v : adj[u]) if (--inDegree[v] == 0) q.push(v);",
      "    }",
      "    return order.size() == inDegree.size() ? order : \"\";",
      "}",
    ],
  ];

  final List<TopologicalStep> _template1Steps = const [
    TopologicalStep(
      activeNode: 0,
      activeLineIndex: 3,
      queueState: [0],
      topologicalOrder: [],
      inDegrees: {0: 0, 1: 1, 2: 1, 3: 1},
      explanationEn: "Line 4: Kahn's BFS initialized. Push inDegree=0 node: Queue = [0]. inDegree = {0:0, 1:1, 2:1, 3:1}.",
      explanationBn: "লাইন ৪: Kahn's BFS প্রারম্ভিককরণ। ইন-ডিগ্রি ০ নোড 0 ক্যু-তে যোগ = [0]।",
    ),
    TopologicalStep(
      activeNode: 0,
      activeLineIndex: 6,
      queueState: [1, 2],
      topologicalOrder: [0],
      inDegrees: {0: 0, 1: 0, 2: 0, 3: 1},
      explanationEn: "Line 7: Popped Node 0! Order = [0]. Decremented inDegree of neighbors 1 and 2 to 0 -> Queue = [1, 2].",
      explanationBn: "লাইন ৭: নোড 0 পপ করা হলো! অর্ডার = [0]। ১ ও ২ এর ইন-ডিগ্রি ০ হওয়ায় ক্যু-তে যোগ = [1, 2]।",
    ),
    TopologicalStep(
      activeNode: 1,
      activeLineIndex: 6,
      queueState: [2],
      topologicalOrder: [0, 1],
      inDegrees: {0: 0, 1: 0, 2: 0, 3: 1},
      explanationEn: "Line 7: Popped Node 1! Order = [0, 1]. Queue = [2].",
      explanationBn: "লাইন ৭: নোড 1 পপ! অর্ডার = [0, 1]। ক্যু = [2]।",
    ),
    TopologicalStep(
      activeNode: 2,
      activeLineIndex: 7,
      queueState: [3],
      topologicalOrder: [0, 1, 2],
      inDegrees: {0: 0, 1: 0, 2: 0, 3: 0},
      explanationEn: "Line 8: Popped Node 2! Order = [0, 1, 2]. Decremented neighbor 3 inDegree to 0 -> Queue = [3].",
      explanationBn: "লাইন ৮: নোড 2 পপ! অর্ডার = [0, 1, 2]। প্রতিবেশী ৩ এর ইন-ডিগ্রি ০ হওয়ায় ক্যু = [3]।",
    ),
    TopologicalStep(
      activeNode: 3,
      activeLineIndex: 9,
      queueState: [],
      topologicalOrder: [0, 1, 2, 3],
      inDegrees: {0: 0, 1: 0, 2: 0, 3: 0},
      explanationEn: "🎉 Line 10: Topological Sort Completed! Valid Course Order = [0, 1, 2, 3]!",
      explanationBn: "🎉 লাইন ১০: টোপোলজিক্যাল সর্ট সম্পন্ন! বৈধ কোর্স সিকোয়েন্স = [0, 1, 2, 3]!",
    ),
  ];

  final List<TopologicalStep> _template2Steps = const [
    TopologicalStep(
      activeNode: 0,
      activeLineIndex: 3,
      queueState: [0],
      topologicalOrder: [0],
      inDegrees: {0: 0, 1: 1},
      explanationEn: "Line 4: In-degree 0 queue populated. Queue = [0].",
      explanationBn: "লাইন ৪: ইন-ডিগ্রি ০ ক্যু ফিল করা হলো = [0]।",
    ),
    TopologicalStep(
      activeNode: 1,
      activeLineIndex: 9,
      queueState: [],
      topologicalOrder: [0, 1],
      inDegrees: {0: 0, 1: 0},
      explanationEn: "🎉 Line 10: Processed nodes count (2) == N (2). No Cycle Exists! Course Schedule Possible!",
      explanationBn: "🎉 লাইন ১০: সবকটি নোড প্রসেস সম্পন্ন। গ্রাফে কোনো সাইকেল নেই! কোর্স সম্পূর্ণ করা সম্ভব!",
    ),
  ];

  final List<TopologicalStep> _template3Steps = const [
    TopologicalStep(
      activeNode: 0,
      activeLineIndex: 3,
      queueState: [1],
      topologicalOrder: [1, 2, 3],
      inDegrees: {1: 0, 2: 0, 3: 0},
      explanationEn: "🎉 Line 9: Alien Dictionary Topological Order = 'wert'!",
      explanationBn: "🎉 লাইন ৯: অ্যালিয়েন ডিকশনারির বর্ণমালার টোপোলজিক্যাল ক্রমানুসার = 'wert'!",
    ),
  ];

  List<TopologicalStep> get _currentSteps {
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
              _buildTemplateChip(0, widget.isEnglish ? "Course Schedule II Order" : "কোর্স সিকোয়েন্স সর্ট"),
              _buildTemplateChip(1, widget.isEnglish ? "Course Schedule Cycle Check" : "সাইকেল টেস্ট"),
              _buildTemplateChip(2, widget.isEnglish ? "Alien Dictionary" : "অ্যালিয়েন বর্ণমালা ডিকশনারি"),
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
              _buildTopologicalCanvas(step),
            ],
          )
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildCodeSnippetWithHighlight(_currentCodeLines, step.activeLineIndex)),
              const SizedBox(width: 16),
              Expanded(child: _buildTopologicalCanvas(step)),
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

  Widget _buildTopologicalCanvas(TopologicalStep step) {
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
              Text("Queue State: ${step.queueState.toString()}", style: const TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 16),

          // In-Degree Table Inspector
          const Text("In-Degree Map Inspector:", style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.accentPurple.withOpacity(0.5)),
            ),
            child: Wrap(
              spacing: 8,
              children: step.inDegrees.entries.map((e) {
                return Chip(
                  backgroundColor: e.value == 0 ? AppTheme.accentGreen : AppTheme.primaryDark,
                  label: Text(
                    "Node ${e.key}: deg ${e.value}",
                    style: TextStyle(
                      color: e.value == 0 ? AppTheme.primaryDark : Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          // Topological Order Result
          const Text("Topological Linear Order Result:", style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.accentGreen.withOpacity(0.5)),
            ),
            child: step.topologicalOrder.isEmpty
                ? const Text("[ Order Empty ]", style: TextStyle(color: AppTheme.textMuted, fontSize: 11))
                : Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: step.topologicalOrder.map((v) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(color: AppTheme.accentGreen, borderRadius: BorderRadius.circular(8)),
                        child: Text("Node $v", style: const TextStyle(color: AppTheme.primaryDark, fontWeight: FontWeight.bold, fontSize: 11)),
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
