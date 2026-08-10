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

class TreeBfsVisualizer extends StatefulWidget {
  final bool isEnglish;

  const TreeBfsVisualizer({super.key, required this.isEnglish});

  @override
  State<TreeBfsVisualizer> createState() => _TreeBfsVisualizerState();
}

class _TreeBfsVisualizerState extends State<TreeBfsVisualizer> {
  int _selectedTemplateIndex = 0;
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  final List<List<String>> _codeTemplates = const [
    // Template 1: Standard Level Order Traversal
    [
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
    ],
    // Template 2: Binary Tree Zigzag Level Order Traversal
    [
      "vector<vector<int>> zigzagLevelOrder(TreeNode* root) {",
      "    vector<vector<int>> res; if (!root) return res;",
      "    queue<TreeNode*> q; q.push(root); bool leftToRight = true;",
      "    while (!q.empty()) {",
      "        int size = q.size(); vector<int> level(size);",
      "        for (int i = 0; i < size; i++) {",
      "            TreeNode* curr = q.front(); q.pop();",
      "            int index = leftToRight ? i : (size - 1 - i);",
      "            level[index] = curr->val;",
      "            if (curr->left) q.push(curr->left); if (curr->right) q.push(curr->right);",
      "        }",
      "        leftToRight = !leftToRight; res.push_back(level);",
      "    }",
      "    return res;",
      "}",
    ],
    // Template 3: Binary Tree Right Side View
    [
      "vector<int> rightSideView(TreeNode* root) {",
      "    vector<int> res; if (!root) return res;",
      "    queue<TreeNode*> q; q.push(root);",
      "    while (!q.empty()) {",
      "        int size = q.size();",
      "        for (int i = 0; i < size; i++) {",
      "            TreeNode* curr = q.front(); q.pop();",
      "            if (i == size - 1) res.push_back(curr->val); // Rightmost!",
      "            if (curr->left) q.push(curr->left); if (curr->right) q.push(curr->right);",
      "        }",
      "    }",
      "    return res;",
      "}",
    ],
  ];

  final List<BfsStep> _template1Steps = const [
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

  final List<BfsStep> _template2Steps = const [
    BfsStep(
      activeNodeVal: 3,
      currentLevelIndex: 0,
      activeLineIndex: 2,
      queueState: [3],
      resultState: [],
      explanationEn: "Line 3: Zigzag BFS initialized. leftToRight = true.",
      explanationBn: "লাইন ৩: জিগজ্যাগ BFS শুরু। leftToRight = true।",
    ),
    BfsStep(
      activeNodeVal: 20,
      currentLevelIndex: 1,
      activeLineIndex: 8,
      queueState: [15, 7],
      resultState: [[3], [20, 9]],
      explanationEn: "Line 9: Level 1: leftToRight = false -> Flip level vector into [20, 9]!",
      explanationBn: "লাইন ৯: লেভেল ১: leftToRight = false -> লেভেল ভেক্টর উল্টে [20, 9] তৈরি হলো!",
    ),
    BfsStep(
      activeNodeVal: 7,
      currentLevelIndex: 2,
      activeLineIndex: 11,
      queueState: [],
      resultState: [[3], [20, 9], [15, 7]],
      explanationEn: "🎉 Line 12: Zigzag Traversal Complete! Result = [[3], [20, 9], [15, 7]]!",
      explanationBn: "🎉 লাইন ১২: জিগজ্যাগ ট্রাভার্সাল সম্পন্ন! রেজাল্ট = [[3], [20, 9], [15, 7]]!",
    ),
  ];

  final List<BfsStep> _template3Steps = const [
    BfsStep(
      activeNodeVal: 3,
      currentLevelIndex: 0,
      activeLineIndex: 7,
      queueState: [9, 20],
      resultState: [[3]],
      explanationEn: "Line 8: Level 0: Only node 3 -> Add 3 to Right Side View.",
      explanationBn: "লাইন ৮: লেভেল ০: রাইট সাইড ভিউ তে 3 যোগ।",
    ),
    BfsStep(
      activeNodeVal: 20,
      currentLevelIndex: 1,
      activeLineIndex: 7,
      queueState: [15, 7],
      resultState: [[3], [20]],
      explanationEn: "Line 8: Level 1: Last node i == size - 1 is 20 -> Add 20 to Right Side View.",
      explanationBn: "লাইন ৮: লেভেল ১: শেষ নোড 20 -> রাইট সাইড ভিউ তে 20 যোগ।",
    ),
    BfsStep(
      activeNodeVal: 7,
      currentLevelIndex: 2,
      activeLineIndex: 7,
      queueState: [],
      resultState: [[3], [20], [7]],
      explanationEn: "🎉 Line 8: Level 2: Last node is 7 -> Add 7! Right Side View Result = [3, 20, 7]!",
      explanationBn: "🎉 লাইন ৮: লেভেল ২: শেষ নোড 7 -> রাইট সাইড ভিউ রেজাল্ট = [3, 20, 7]!",
    ),
  ];

  List<BfsStep> get _currentSteps {
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
              _buildTemplateChip(0, widget.isEnglish ? "Level Order Traversal" : "লেভেল অর্ডার ট্রাভার্সাল"),
              _buildTemplateChip(1, widget.isEnglish ? "Zigzag Level Order" : "জিগজ্যাগ লেভেল অর্ডার"),
              _buildTemplateChip(2, widget.isEnglish ? "Right Side View" : "রাইট সাইড ভিউ"),
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
              _buildBfsCanvas(step),
            ],
          )
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildCodeSnippetWithHighlight(_currentCodeLines, step.activeLineIndex)),
              const SizedBox(width: 16),
              Expanded(child: _buildBfsCanvas(step)),
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
              Text("Active Level: [Depth ${step.currentLevelIndex}]", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13)),
              Text("Active Node: [${step.activeNodeVal}]", style: const TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 16),

          // FIFO Queue Inspector
          const Text("FIFO Queue Inspector (Front -> Back):", style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.accentPurple.withOpacity(0.4)),
            ),
            child: step.queueState.isEmpty
                ? Text(widget.isEnglish ? "[ Queue Empty ]" : "[ ক্যু খালি ]", style: const TextStyle(color: AppTheme.textMuted, fontSize: 12))
                : Wrap(
                    spacing: 8,
                    children: step.queueState.map((val) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.accentPurple,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text("$val", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                      );
                    }).toList(),
                  ),
          ),
          const SizedBox(height: 16),

          // Level Order Result collector
          const Text("Traversals Result Accumulator:", style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.accentGreen.withOpacity(0.4)),
            ),
            child: step.resultState.isEmpty
                ? Text(widget.isEnglish ? "[ Result Empty ]" : "[ রেজাল্ট খালি ]", style: const TextStyle(color: AppTheme.textMuted, fontSize: 12))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: step.resultState.map((lvl) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Text(
                          "Level -> ${lvl.toString()}",
                          style: const TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 12, fontFamily: 'monospace'),
                        ),
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
