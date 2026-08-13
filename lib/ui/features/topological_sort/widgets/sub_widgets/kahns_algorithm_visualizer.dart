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

class KahnsAlgorithmVisualizer extends StatefulWidget {
  final bool isEnglish;

  const KahnsAlgorithmVisualizer({super.key, required this.isEnglish});

  @override
  State<KahnsAlgorithmVisualizer> createState() => _KahnsAlgorithmVisualizerState();
}

class _KahnsAlgorithmVisualizerState extends State<KahnsAlgorithmVisualizer> {
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  final List<String> _codeLines = const [
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
  ];

  final List<TopologicalStep> _steps = const [
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
            color: step.activeLineIndex == 9 ? AppTheme.accentGreen.withOpacity(0.15) : AppTheme.accentNeonCyan.withOpacity(0.15),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: step.activeLineIndex == 9 ? AppTheme.accentGreen : AppTheme.accentNeonCyan),
          ),
          child: Text(
            widget.isEnglish ? step.explanationEn : step.explanationBn,
            style: TextStyle(
              color: step.activeLineIndex == 9 ? AppTheme.accentGreen : AppTheme.accentNeonCyan,
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

  Widget _buildCanvas(TopologicalStep step) {
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
              Text("Active Node: [${step.activeNode}]", style: const TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 13)),
              Text("Queue: ${step.queueState}", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 16),

          // In-degree Status Display
          Wrap(
            spacing: 8,
            children: step.inDegrees.entries.map((e) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: e.value == 0 ? AppTheme.accentGreen.withOpacity(0.2) : AppTheme.surfaceDark,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: e.value == 0 ? AppTheme.accentGreen : const Color(0xFF334155)),
                ),
                child: Text("Node ${e.key}: inDeg=${e.value}", style: TextStyle(color: e.value == 0 ? AppTheme.accentGreen : Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // Topological Result Sequence
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.accentPurple.withOpacity(0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Topological Order Array:", style: TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
                const SizedBox(height: 6),
                Text("${step.topologicalOrder}", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 16)),
              ],
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
