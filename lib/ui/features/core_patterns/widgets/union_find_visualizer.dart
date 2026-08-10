import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class UnionFindStep {
  final int u;
  final int v;
  final int activeLineIndex;
  final List<int> parentArray;
  final int componentsCount;
  final bool isMerged;
  final String explanationEn;
  final String explanationBn;

  const UnionFindStep({
    required this.u,
    required this.v,
    required this.activeLineIndex,
    required this.parentArray,
    required this.componentsCount,
    this.isMerged = true,
    required this.explanationEn,
    required this.explanationBn,
  });
}

class UnionFindVisualizer extends StatefulWidget {
  final bool isEnglish;

  const UnionFindVisualizer({super.key, required this.isEnglish});

  @override
  State<UnionFindVisualizer> createState() => _UnionFindVisualizerState();
}

class _UnionFindVisualizerState extends State<UnionFindVisualizer> {
  int _selectedTemplateIndex = 0;
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  final List<List<String>> _codeTemplates = const [
    // Template 1: Number of Connected Components
    [
      "class DSU {",
      "    vector<int> parent; int count;",
      "public:",
      "    DSU(int n) : count(n), parent(n) { iota(parent.begin(), parent.end(), 0); }",
      "    int find(int i) { return parent[i] == i ? i : parent[i] = find(parent[i]); } // Path Compression",
      "    bool unite(int u, int v) {",
      "        int rootU = find(u), rootV = find(v);",
      "        if (rootU == rootV) return false;             // Already connected!",
      "        parent[rootV] = rootU; count--; return true; // Merge roots & decrement count",
      "    }",
      "};",
    ],
    // Template 2: Redundant Connection
    [
      "vector<int> findRedundantConnection(vector<vector<int>>& edges) {",
      "    int n = edges.size(); DSU dsu(n + 1);",
      "    for (auto& edge : edges) {",
      "        if (!dsu.unite(edge[0], edge[1])) return edge; // Cycle edge detected!",
      "    }",
      "    return {};",
      "}",
    ],
    // Template 3: Most Stones Removed
    [
      "int removeStones(vector<vector<int>>& stones) {",
      "    DSU dsu(20002);",
      "    for (auto& s : stones) dsu.unite(s[0], s[1] + 10001); // Unite row and col",
      "    unordered_set<int> roots;",
      "    for (auto& s : stones) roots.insert(dsu.find(s[0]));",
      "    return stones.size() - roots.size();",
      "}",
    ],
  ];

  final List<UnionFindStep> _template1Steps = const [
    UnionFindStep(
      u: 0,
      v: 1,
      activeLineIndex: 3,
      parentArray: [0, 1, 2, 3],
      componentsCount: 4,
      explanationEn: "Line 4: DSU Init (N=4). parent = [0, 1, 2, 3]. Components Count = 4.",
      explanationBn: "লাইন ৪: DSU প্রারম্ভিককরণ (N=4)। parent = [0, 1, 2, 3]। কম্পোনেন্ট = ৪।",
    ),
    UnionFindStep(
      u: 0,
      v: 1,
      activeLineIndex: 8,
      parentArray: [0, 0, 2, 3],
      componentsCount: 3,
      explanationEn: "Line 9: unite(0, 1): find(0)=0, find(1)=1. Merged! parent[1] = 0. Count = 3.",
      explanationBn: "লাইন ৯: unite(0, 1): find(0)=0, find(1)=1। মার্জড! parent[1] = 0। কাউন্ট = ৩।",
    ),
    UnionFindStep(
      u: 2,
      v: 3,
      activeLineIndex: 8,
      parentArray: [0, 0, 2, 2],
      componentsCount: 2,
      explanationEn: "Line 9: unite(2, 3): find(2)=2, find(3)=3. Merged! parent[3] = 2. Count = 2.",
      explanationBn: "লাইন ৯: unite(2, 3): find(2)=2, find(3)=3। মার্জড! parent[3] = 2। কাউন্ট = ২।",
    ),
    UnionFindStep(
      u: 1,
      v: 3,
      activeLineIndex: 8,
      parentArray: [0, 0, 0, 2],
      componentsCount: 1,
      explanationEn: "Line 9: unite(1, 3): find(1)=0, find(3)=2. Merged roots 0 and 2! Count = 1.",
      explanationBn: "লাইন ৯: unite(1, 3): find(1)=0, find(3)=2। রুট 0 ও 2 মার্জড! কাউন্ট = ১।",
    ),
    UnionFindStep(
      u: 0,
      v: 3,
      activeLineIndex: 7,
      parentArray: [0, 0, 0, 0],
      componentsCount: 1,
      isMerged: false,
      explanationEn: "🎉 Line 8: unite(0, 3): find(0)=0 == find(3)=0. Already connected! Total Components = 1!",
      explanationBn: "🎉 লাইন ৮: unite(0, 3): find(0)=0 == find(3)=0। ইতিমধ্যেই সংযুক্ত! মোট কম্পোনেন্ট = ১!",
    ),
  ];

  final List<UnionFindStep> _template2Steps = const [
    UnionFindStep(
      u: 1,
      v: 2,
      activeLineIndex: 3,
      parentArray: [0, 1, 1, 3],
      componentsCount: 2,
      explanationEn: "Line 4: unite(1, 2) succeeded.",
      explanationBn: "লাইন ৪: unite(1, 2) সফলভাবে সম্পূর্ণ।",
    ),
    UnionFindStep(
      u: 1,
      v: 3,
      activeLineIndex: 3,
      parentArray: [0, 1, 1, 1],
      componentsCount: 1,
      isMerged: false,
      explanationEn: "🎉 Line 4: find(1) == find(3). Redundant Cycle Edge [1, 3] Detected!",
      explanationBn: "🎉 লাইন ৪: find(1) == find(3)। সাইকেল তৈরির অপ্রয়োজনীয় এজ [1, 3] পাওয়া গেছে!",
    ),
  ];

  final List<UnionFindStep> _template3Steps = const [
    UnionFindStep(
      u: 0,
      v: 1,
      activeLineIndex: 5,
      parentArray: [0, 0, 0, 0],
      componentsCount: 1,
      explanationEn: "🎉 Line 6: Total Stones Removed = 5!",
      explanationBn: "🎉 লাইন ৬: মোট অপসারিত পাথর সংখ্যা = 5!",
    ),
  ];

  List<UnionFindStep> get _currentSteps {
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
              _buildTemplateChip(0, widget.isEnglish ? "Connected Components" : "কানেক্টেড কম্পোনেন্ট কাউন্ট"),
              _buildTemplateChip(1, widget.isEnglish ? "Redundant Edge Cycle" : "সাইকেল এডজ ডিটেকশন"),
              _buildTemplateChip(2, widget.isEnglish ? "Most Stones Removed" : "পাথর অপসারণ DSU"),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Status Log Banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: step.isMerged ? AppTheme.accentPurple.withOpacity(0.15) : AppTheme.accentAmber.withOpacity(0.15),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: step.isMerged ? AppTheme.accentPurple : AppTheme.accentAmber),
          ),
          child: Text(
            widget.isEnglish ? step.explanationEn : step.explanationBn,
            style: TextStyle(
              color: step.isMerged ? AppTheme.accentNeonCyan : AppTheme.accentAmber,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Code Snippet + Visualizer Box Layout
        if (isMobile)
          Column(
            children: [
              _buildCodeSnippetWithHighlight(_currentCodeLines, step.activeLineIndex),
              const SizedBox(height: 16),
              _buildDSUCanvas(step),
            ],
          )
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildCodeSnippetWithHighlight(_currentCodeLines, step.activeLineIndex)),
              const SizedBox(width: 16),
              Expanded(child: _buildDSUCanvas(step)),
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

  Widget _buildDSUCanvas(UnionFindStep step) {
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
              Text("Unite Pair: [${step.u}, ${step.v}]", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13)),
              Text("Components: [${step.componentsCount}]", style: const TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 16),

          // Parent Array Tree Inspector
          const Text("Parent Array Representation:", style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(step.parentArray.length, (i) {
                final isRoot = step.parentArray[i] == i;
                final isCurrentPair = i == step.u || i == step.v;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 55,
                  height: 65,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: isCurrentPair ? AppTheme.accentPurple : (isRoot ? AppTheme.accentGreen : AppTheme.surfaceDark),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isCurrentPair ? Colors.white : (isRoot ? AppTheme.accentGreen : const Color(0xFF1E293B)),
                      width: isCurrentPair ? 2.5 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${step.parentArray[i]}",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: (isCurrentPair || isRoot) ? AppTheme.primaryDark : Colors.white),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "P[$i]",
                        style: TextStyle(fontSize: 9, color: (isCurrentPair || isRoot) ? AppTheme.primaryDark : AppTheme.textMuted),
                      ),
                    ],
                  ),
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
