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

class DSUComponentsVisualizer extends StatefulWidget {
  final bool isEnglish;

  const DSUComponentsVisualizer({super.key, required this.isEnglish});

  @override
  State<DSUComponentsVisualizer> createState() => _DSUComponentsVisualizerState();
}

class _DSUComponentsVisualizerState extends State<DSUComponentsVisualizer> {
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  final List<String> _codeLines = const [
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
  ];

  final List<UnionFindStep> _steps = const [
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

  Widget _buildCanvas(UnionFindStep step) {
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
              Text("unite(${step.u}, ${step.v})", style: const TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 13)),
              Text("Components: [${step.componentsCount}]", style: const TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 16),

          // Parent Array Visualizer
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(step.parentArray.length, (idx) {
                final isRoot = step.parentArray[idx] == idx;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: Column(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isRoot ? AppTheme.accentGreen.withOpacity(0.25) : AppTheme.accentPurple.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: isRoot ? AppTheme.accentGreen : AppTheme.accentPurple, width: isRoot ? 2 : 1),
                        ),
                        child: Text(
                          "${step.parentArray[idx]}",
                          style: TextStyle(
                            color: isRoot ? AppTheme.accentGreen : Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text("P[$idx]", style: const TextStyle(color: AppTheme.textMuted, fontSize: 10)),
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
