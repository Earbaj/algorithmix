import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class DfsStep {
  final int activeNodeVal;
  final int activeLineIndex;
  final List<int> callStackState;
  final List<int> visitedValues;
  final String explanationEn;
  final String explanationBn;

  const DfsStep({
    required this.activeNodeVal,
    required this.activeLineIndex,
    required this.callStackState,
    required this.visitedValues,
    required this.explanationEn,
    required this.explanationBn,
  });
}

class TreeDfsVisualizer extends StatefulWidget {
  final bool isEnglish;

  const TreeDfsVisualizer({super.key, required this.isEnglish});

  @override
  State<TreeDfsVisualizer> createState() => _TreeDfsVisualizerState();
}

class _TreeDfsVisualizerState extends State<TreeDfsVisualizer> {
  int _selectedTemplateIndex = 0;
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  final List<List<String>> _codeTemplates = const [
    // Template 1: Preorder Traversal (Root -> Left -> Right)
    [
      "void preorder(TreeNode* root, vector<int>& res) {",
      "    if (!root) return; // Base Case",
      "    res.push_back(root->val); // 1. Process Root",
      "    preorder(root->left, res);  // 2. Visit Left Subtree",
      "    preorder(root->right, res); // 3. Visit Right Subtree",
      "}",
    ],
    // Template 2: Inorder Traversal (Left -> Root -> Right)
    [
      "void inorder(TreeNode* root, vector<int>& res) {",
      "    if (!root) return; // Base Case",
      "    inorder(root->left, res);  // 1. Visit Left Subtree",
      "    res.push_back(root->val); // 2. Process Root (Sorted in BST!)",
      "    inorder(root->right, res); // 3. Visit Right Subtree",
      "}",
    ],
    // Template 3: Postorder Traversal / Path Sum
    [
      "bool hasPathSum(TreeNode* root, int targetSum) {",
      "    if (!root) return false; // Base Case",
      "    if (!root->left && !root->right) // Leaf Node Check",
      "        return targetSum == root->val;",
      "    return hasPathSum(root->left, targetSum - root->val) ||",
      "           hasPathSum(root->right, targetSum - root->val);",
      "}",
    ],
  ];

  final List<DfsStep> _template1Steps = const [
    DfsStep(
      activeNodeVal: 1,
      activeLineIndex: 1,
      callStackState: [1],
      visitedValues: [],
      explanationEn: "Line 2: Call preorder(root 1). Stack = [1].",
      explanationBn: "লাইন ২: preorder(root 1) রিকার্সিভ কল। স্ট্যাক = [1]।",
    ),
    DfsStep(
      activeNodeVal: 1,
      activeLineIndex: 2,
      callStackState: [1],
      visitedValues: [1],
      explanationEn: "Line 3: Preorder: Process Root 1 first! Add 1 to result. Result = [1].",
      explanationBn: "লাইন ৩: প্রি-অর্ডার: প্রথমে রুট 1 প্রসেস করা হলো! রেজাল্ট = [1]।",
    ),
    DfsStep(
      activeNodeVal: 2,
      activeLineIndex: 3,
      callStackState: [1, 2],
      visitedValues: [1],
      explanationEn: "Line 4: Recurse Left -> Call preorder(node 2). Stack = [1, 2].",
      explanationBn: "লাইন ৪: বামে রিকার্স কল -> preorder(node 2)। স্ট্যাক = [1, 2]।",
    ),
    DfsStep(
      activeNodeVal: 2,
      activeLineIndex: 2,
      callStackState: [1, 2],
      visitedValues: [1, 2],
      explanationEn: "Line 3: Process Root 2! Add 2 to result. Result = [1, 2].",
      explanationBn: "লাইন ৩: রুট 2 প্রসেস করা হলো! রেজাল্ট = [1, 2]।",
    ),
    DfsStep(
      activeNodeVal: 4,
      activeLineIndex: 3,
      callStackState: [1, 2, 4],
      visitedValues: [1, 2, 4],
      explanationEn: "Line 4: Recurse Left -> Call preorder(node 4). Add 4 to result. Result = [1, 2, 4].",
      explanationBn: "লাইন ৪: বামে রিকার্স কল -> 4 প্রসেস করা হলো। রেজাল্ট = [1, 2, 4]।",
    ),
    DfsStep(
      activeNodeVal: 5,
      activeLineIndex: 4,
      callStackState: [1, 2, 5],
      visitedValues: [1, 2, 4, 5],
      explanationEn: "Line 5: Backtrack to 2, Recurse Right -> Call preorder(node 5). Result = [1, 2, 4, 5].",
      explanationBn: "লাইন ৫: 2 এ ব্যাকট্র্যাক করে ডানে রিকার্স কল -> 5 প্রসেস করা হলো। রেজাল্ট = [1, 2, 4, 5]।",
    ),
    DfsStep(
      activeNodeVal: 3,
      activeLineIndex: 4,
      callStackState: [1, 3],
      visitedValues: [1, 2, 4, 5, 3],
      explanationEn: "Line 5: Backtrack to root 1, Recurse Right -> Call preorder(node 3). Result = [1, 2, 4, 5, 3].",
      explanationBn: "লাইন ৫: রুট 1 এ ব্যাকট্র্যাক করে ডানে রিকার্স কল -> 3 প্রসেস করা হলো।",
    ),
    DfsStep(
      activeNodeVal: 3,
      activeLineIndex: 5,
      callStackState: [],
      visitedValues: [1, 2, 4, 5, 3],
      explanationEn: "🎉 Line 6: Preorder Traversal Complete! Result = [1, 2, 4, 5, 3]!",
      explanationBn: "🎉 লাইন ৬: প্রি-অর্ডার ট্রাভার্সাল সম্পন্ন! রেজাল্ট = [1, 2, 4, 5, 3]!",
    ),
  ];

  final List<DfsStep> _template2Steps = const [
    DfsStep(
      activeNodeVal: 4,
      activeLineIndex: 2,
      callStackState: [1, 2, 4],
      visitedValues: [],
      explanationEn: "Line 3: Inorder: Go left first until null -> Reached leftmost leaf node 4.",
      explanationBn: "লাইন ৩: ইন-অর্ডার: বামের সর্বনিম্ন লিফ নোড 4 এ পৌঁছানো হলো।",
    ),
    DfsStep(
      activeNodeVal: 4,
      activeLineIndex: 3,
      callStackState: [1, 2, 4],
      visitedValues: [4],
      explanationEn: "Line 4: Process Node 4! Add 4 to result. Result = [4].",
      explanationBn: "লাইন ৪: নোড 4 প্রসেস করা হলো! রেজাল্ট = [4]।",
    ),
    DfsStep(
      activeNodeVal: 2,
      activeLineIndex: 3,
      callStackState: [1, 2],
      visitedValues: [4, 2],
      explanationEn: "Line 4: Backtrack to parent Node 2. Process Node 2! Result = [4, 2].",
      explanationBn: "লাইন ৪: ব্যাকট্র্যাক করে নোড 2 এ প্রসেস করা হলো! রেজাল্ট = [4, 2]।",
    ),
    DfsStep(
      activeNodeVal: 5,
      activeLineIndex: 3,
      callStackState: [1, 5],
      visitedValues: [4, 2, 5],
      explanationEn: "Line 4: Visit right node 5. Process Node 5! Result = [4, 2, 5].",
      explanationBn: "লাইন ৪: ডানের নোড 5 এ প্রসেস করা হলো! রেজাল্ট = [4, 2, 5]।",
    ),
    DfsStep(
      activeNodeVal: 1,
      activeLineIndex: 3,
      callStackState: [1],
      visitedValues: [4, 2, 5, 1],
      explanationEn: "Line 4: Backtrack to Root 1. Process Root 1! Result = [4, 2, 5, 1].",
      explanationBn: "লাইন ৪: রুটে ব্যাকট্র্যাক করে 1 প্রসেস করা হলো! রেজাল্ট = [4, 2, 5, 1]।",
    ),
    DfsStep(
      activeNodeVal: 3,
      activeLineIndex: 3,
      callStackState: [],
      visitedValues: [4, 2, 5, 1, 3],
      explanationEn: "🎉 Line 4: Inorder Traversal Complete! Output is sorted in BST: [4, 2, 5, 1, 3]!",
      explanationBn: "🎉 লাইন ৪: ইন-অর্ডার ট্রাভার্সাল সম্পন্ন! রেজাল্ট = [4, 2, 5, 1, 3]!",
    ),
  ];

  final List<DfsStep> _template3Steps = const [
    DfsStep(
      activeNodeVal: 1,
      activeLineIndex: 1,
      callStackState: [1],
      visitedValues: [],
      explanationEn: "Line 2: Path Sum check (targetSum = 7). Call hasPathSum(root 1, 7).",
      explanationBn: "লাইন ২: পাথ সাম চেক (targetSum = 7)। hasPathSum(root 1, 7)।",
    ),
    DfsStep(
      activeNodeVal: 4,
      activeLineIndex: 3,
      callStackState: [1, 2, 4],
      visitedValues: [1, 2, 4],
      explanationEn: "Line 4: Reached Leaf node 4. Path sum = 1 + 2 + 4 = 7 == 7 -> MATCH FOUND!",
      explanationBn: "লাইন ৪: লিফ নোড 4 এ পৌঁছানো হলো। পাথ সাম = 1 + 2 + 4 = 7 -> টার্গেট সাম মিলেছে!",
    ),
    DfsStep(
      activeNodeVal: 4,
      activeLineIndex: 4,
      callStackState: [],
      visitedValues: [1, 2, 4],
      explanationEn: "🎉 Line 5: Path Sum Exists! Returns TRUE!",
      explanationBn: "🎉 লাইন ৫: টার্গেট পাথ সাম বিদ্যমান! TRUE রিটার্ন করা হলো!",
    ),
  ];

  List<DfsStep> get _currentSteps {
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
              _buildTemplateChip(0, widget.isEnglish ? "Preorder Traversal" : "প্রি-অর্ডার ট্রাভার্সাল"),
              _buildTemplateChip(1, widget.isEnglish ? "Inorder Traversal" : "ইন-অর্ডার ট্রাভার্সাল"),
              _buildTemplateChip(2, widget.isEnglish ? "Postorder / Path Sum" : "পোস্ট-অর্ডার / পাথ সাম"),
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
              _buildDfsCanvas(step),
            ],
          )
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildCodeSnippetWithHighlight(_currentCodeLines, step.activeLineIndex)),
              const SizedBox(width: 16),
              Expanded(child: _buildDfsCanvas(step)),
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

  Widget _buildDfsCanvas(DfsStep step) {
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
              Text("Active Node: [Node ${step.activeNodeVal}]", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13)),
              Text("Stack Depth: [${step.callStackState.length}]", style: const TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 16),

          // Recursion Call Stack Inspector
          const Text("Recursion Call Stack Inspector (Bottom -> Top):", style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.accentAmber.withOpacity(0.4)),
            ),
            child: step.callStackState.isEmpty
                ? Text(widget.isEnglish ? "[ Call Stack Unwound Empty ]" : "[ কল স্ট্যাক খালি ]", style: const TextStyle(color: AppTheme.textMuted, fontSize: 12))
                : Wrap(
                    spacing: 8,
                    children: step.callStackState.map((val) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.accentAmber,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text("Node($val)", style: const TextStyle(color: AppTheme.primaryDark, fontWeight: FontWeight.bold, fontSize: 12)),
                      );
                    }).toList(),
                  ),
          ),
          const SizedBox(height: 16),

          // Visited Values Traversal Result
          const Text("Processed Traversal Output List:", style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.accentGreen.withOpacity(0.4)),
            ),
            child: step.visitedValues.isEmpty
                ? Text(widget.isEnglish ? "[ Result Empty ]" : "[ রেজাল্ট খালি ]", style: const TextStyle(color: AppTheme.textMuted, fontSize: 12))
                : Wrap(
                    spacing: 6,
                    children: step.visitedValues.map((v) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.accentGreen,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text("$v", style: const TextStyle(color: AppTheme.primaryDark, fontWeight: FontWeight.bold, fontSize: 12)),
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
