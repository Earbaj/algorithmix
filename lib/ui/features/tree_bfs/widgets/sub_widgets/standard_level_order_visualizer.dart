import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class BfsStep {
  final int activeNodeVal;
  final int currentLevelIndex;
  final int activeLineIndex;
  final List<int> queueState;
  final List<List<int>> resultState;
  final String explanationEn;
  final String explanationBn;

  const BfsStep({
    required this.activeNodeVal,
    required this.currentLevelIndex,
    required this.activeLineIndex,
    required this.queueState,
    required this.resultState,
    required this.explanationEn,
    required this.explanationBn,
  });
}

class StandardLevelOrderVisualizer extends StatefulWidget {
  final bool isEnglish;

  const StandardLevelOrderVisualizer({super.key, required this.isEnglish});

  @override
  State<StandardLevelOrderVisualizer> createState() => _StandardLevelOrderVisualizerState();
}

class _StandardLevelOrderVisualizerState extends State<StandardLevelOrderVisualizer> {
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  final List<String> _codeLines = const [
    "vector<vector<int>> levelOrder(TreeNode* root) {",
    "    vector<vector<int>> res; if (!root) return res;",
    "    queue<TreeNode*> q; q.push(root); // Init FIFO Queue",
    "    while (!q.empty()) {",
    "        int levelSize = q.size(); // Snapshot level size!",
    "        vector<int> level;",
    "        for (int i = 0; i < levelSize; i++) {",
    "            TreeNode* curr = q.front(); q.pop();",
    "            level.push_back(curr->val);",
    "            if (curr->left) q.push(curr->left);",
    "            if (curr->right) q.push(curr->right);",
    "        }",
    "        res.push_back(level);",
    "    }",
    "    return res;",
    "}",
  ];

  final List<BfsStep> _steps = const [
    BfsStep(
      activeNodeVal: 3,
      currentLevelIndex: 0,
      activeLineIndex: 2,
      queueState: [3],
      resultState: [],
      explanationEn: "Line 3: Push root (3) into FIFO Queue. Queue = [3].",
      explanationBn: "লাইন ৩: রুট (3) FIFO ক্যু তে পুশ করা হলো। ক্যু = [3]।",
    ),
    BfsStep(
      activeNodeVal: 3,
      currentLevelIndex: 0,
      activeLineIndex: 4,
      queueState: [3],
      resultState: [],
      explanationEn: "Line 5: Level 0: Snapshot levelSize = q.size() = 1.",
      explanationBn: "লাইন ৫: লেভেল ০: levelSize = q.size() = ১ এর স্ন্যাপশট নেওয়া হলো।",
    ),
    BfsStep(
      activeNodeVal: 3,
      currentLevelIndex: 0,
      activeLineIndex: 9,
      queueState: [9, 20],
      resultState: [[3]],
      explanationEn: "Line 8-11: Pop 3 from queue. Push children 9 and 20 into queue. Queue = [9, 20]. Level 0 = [3].",
      explanationBn: "লাইন ৮-১১: 3 পপ করা হলো। চিলড্রেন 9 ও 20 ক্যু তে পুশ করা হলো। লেভেল ০ = [3]।",
    ),
    BfsStep(
      activeNodeVal: 9,
      currentLevelIndex: 1,
      activeLineIndex: 4,
      queueState: [9, 20],
      resultState: [[3]],
      explanationEn: "Line 5: Level 1: Snapshot levelSize = q.size() = 2.",
      explanationBn: "লাইন ৫: লেভেল ১: levelSize = q.size() = ২ এর স্ন্যাপশট নেওয়া হলো।",
    ),
    BfsStep(
      activeNodeVal: 9,
      currentLevelIndex: 1,
      activeLineIndex: 7,
      queueState: [20],
      resultState: [[3], [9]],
      explanationEn: "Line 8: Pop 9 from queue. (9 is leaf node, no children). Queue = [20].",
      explanationBn: "লাইন ৮: ক্যু থেকে 9 পপ করা হলো। (9 এর কোনো চাইল্ড নেই)। ক্যু = [20]।",
    ),
    BfsStep(
      activeNodeVal: 20,
      currentLevelIndex: 1,
      activeLineIndex: 10,
      queueState: [15, 7],
      resultState: [[3], [9, 20]],
      explanationEn: "Line 8-11: Pop 20 from queue. Push children 15 and 7. Queue = [15, 7]. Level 1 = [9, 20].",
      explanationBn: "লাইন ৮-১১: 20 পপ করা হলো। চিলড্রেন 15 ও 7 ক্যু তে পুশ করা হলো। ক্যু = [15, 7]।",
    ),
    BfsStep(
      activeNodeVal: 15,
      currentLevelIndex: 2,
      activeLineIndex: 7,
      queueState: [7],
      resultState: [[3], [9, 20], [15]],
      explanationEn: "Line 8: Level 2: Pop 15 from queue. Queue = [7].",
      explanationBn: "লাইন ৮: লেভেল ২: ক্যু থেকে 15 পপ করা হলো। ক্যু = [7]।",
    ),
    BfsStep(
      activeNodeVal: 7,
      currentLevelIndex: 2,
      activeLineIndex: 12,
      queueState: [],
      resultState: [[3], [9, 20], [15, 7]],
      explanationEn: "Line 13: Pop 7 from queue. Level 2 = [15, 7]. Queue is now empty!",
      explanationBn: "লাইন ১৩: 7 পপ করা হলো। লেভেল ২ = [15, 7]। ক্যু এখন ফাঁকা!",
    ),
    BfsStep(
      activeNodeVal: 7,
      currentLevelIndex: 2,
      activeLineIndex: 14,
      queueState: [],
      resultState: [[3], [9, 20], [15, 7]],
      explanationEn: "🎉 Line 15: Tree BFS Level Order Complete! Result = [[3], [9, 20], [15, 7]]!",
      explanationBn: "🎉 লাইন ১৫: ট্রি BFS লেভেল অর্ডার ট্রাভার্সাল সম্পন্ন! রেজাল্ট = [[3], [9, 20], [15, 7]]!",
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
            color: step.queueState.isEmpty ? AppTheme.accentGreen.withOpacity(0.15) : AppTheme.accentNeonCyan.withOpacity(0.15),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: step.queueState.isEmpty ? AppTheme.accentGreen : AppTheme.accentNeonCyan),
          ),
          child: Text(
            widget.isEnglish ? step.explanationEn : step.explanationBn,
            style: TextStyle(
              color: step.queueState.isEmpty ? AppTheme.accentGreen : AppTheme.accentNeonCyan,
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
              _buildBfsCanvas(step),
            ],
          )
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildCodeSnippetWithHighlight(_codeLines, step.activeLineIndex)),
              const SizedBox(width: 16),
              Expanded(child: _buildBfsCanvas(step)),
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

  Widget _buildBfsCanvas(BfsStep step) {
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
              Text("Current Active Node: [${step.activeNodeVal}]", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13)),
              Text("Level Index: [${step.currentLevelIndex}]", style: const TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 16),
          const Text("FIFO Queue State (q.push / q.pop):", style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.accentNeonCyan.withOpacity(0.4)),
            ),
            child: Row(
              children: [
                const Icon(Icons.input, color: AppTheme.accentNeonCyan, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: step.queueState.isEmpty
                      ? const Text("Queue Empty (q.empty() == true)", style: TextStyle(color: AppTheme.textMuted, fontSize: 12, fontStyle: FontStyle.italic))
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: step.queueState.map((val) {
                              return Container(
                                margin: const EdgeInsets.only(right: 6),
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppTheme.accentNeonCyan.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: AppTheme.accentNeonCyan),
                                ),
                                child: Text("$val", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                              );
                            }).toList(),
                          ),
                        ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text("Result Level Vectors (2D vector<vector<int>>):", style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          const SizedBox(height: 8),
          Column(
            children: List.generate(step.resultState.length, (lvlIdx) {
              final levelVals = step.resultState[lvlIdx];
              return Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceDark,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.accentPurple.withOpacity(0.4)),
                ),
                child: Row(
                  children: [
                    Text("Level $lvlIdx: ", style: const TextStyle(color: AppTheme.accentPurple, fontWeight: FontWeight.bold, fontSize: 12)),
                    Text("[${levelVals.join(', ')}]", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                  ],
                ),
              );
            }),
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
