import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class SubsetsStep {
  final List<int> currentPath;
  final int activeIndex;
  final int activeLineIndex;
  final List<List<int>> generatedSubsets;
  final String explanationEn;
  final String explanationBn;

  const SubsetsStep({
    required this.currentPath,
    required this.activeIndex,
    required this.activeLineIndex,
    required this.generatedSubsets,
    required this.explanationEn,
    required this.explanationBn,
  });
}

class SubsetsBacktrackingVisualizer extends StatefulWidget {
  final bool isEnglish;

  const SubsetsBacktrackingVisualizer({super.key, required this.isEnglish});

  @override
  State<SubsetsBacktrackingVisualizer> createState() => _SubsetsBacktrackingVisualizerState();
}

class _SubsetsBacktrackingVisualizerState extends State<SubsetsBacktrackingVisualizer> {
  int _selectedTemplateIndex = 0;
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  final List<List<String>> _codeTemplates = const [
    // Template 1: Subsets
    [
      "void backtrack(int start, vector<int>& nums, vector<int>& curr, vector<vector<int>>& res) {",
      "    res.push_back(curr); // Add subset candidate to result",
      "    for (int i = start; i < nums.size(); i++) {",
      "        curr.push_back(nums[i]);            // 1. Make Choice",
      "        backtrack(i + 1, nums, curr, res);   // 2. Recurse next index",
      "        curr.pop_back();                    // 3. Undo Choice (Backtrack!)",
      "    }",
      "}",
    ],
    // Template 2: Permutations
    [
      "void backtrack(vector<int>& nums, vector<int>& curr, vector<bool>& visited, vector<vector<int>>& res) {",
      "    if (curr.size() == nums.size()) { res.push_back(curr); return; }",
      "    for (int i = 0; i < nums.size(); i++) {",
      "        if (visited[i]) continue;",
      "        visited[i] = true; curr.push_back(nums[i]); // Choose",
      "        backtrack(nums, curr, visited, res);         // Recurse",
      "        curr.pop_back(); visited[i] = false;        // Backtrack!",
      "    }",
      "}",
    ],
    // Template 3: Combination Sum
    [
      "void backtrack(int start, int target, vector<int>& nums, vector<int>& curr, vector<vector<int>>& res) {",
      "    if (target == 0) { res.push_back(curr); return; }",
      "    if (target < 0) return;",
      "    for (int i = start; i < nums.size(); i++) {",
      "        curr.push_back(nums[i]);",
      "        backtrack(i, target - nums[i], nums, curr, res); // Reuse index i!",
      "        curr.pop_back();",
      "    }",
      "}",
    ],
  ];

  final List<SubsetsStep> _template1Steps = const [
    SubsetsStep(
      currentPath: [],
      activeIndex: 0,
      activeLineIndex: 1,
      generatedSubsets: [[]],
      explanationEn: "Line 2: Empty subset [] pushed to result list. Result = [[]].",
      explanationBn: "লাইন ২: ফাঁকা সাবসেট [] রেজাল্ট লিস্টে যোগ করা হলো। রেজাল্ট = [[]] ।",
    ),
    SubsetsStep(
      currentPath: [1],
      activeIndex: 0,
      activeLineIndex: 3,
      generatedSubsets: [[]],
      explanationEn: "Line 4: Choose nums[0] = 1 -> curr = [1]. Recurse backtrack(1).",
      explanationBn: "লাইন ৪: nums[0] = 1 নির্বাচন করা হলো -> curr = [1]। r... এ যাওয়া হলো।",
    ),
    SubsetsStep(
      currentPath: [1],
      activeIndex: 0,
      activeLineIndex: 1,
      generatedSubsets: [[], [1]],
      explanationEn: "Line 2: Subset [1] pushed to result list. Result = [[], [1]].",
      explanationBn: "লাইন ২: সাবসেট [1] রেজাল্ট লিস্টে যোগ করা হলো। রেজাল্ট = [[], [1]]।",
    ),
    SubsetsStep(
      currentPath: [1, 2],
      activeIndex: 1,
      activeLineIndex: 3,
      generatedSubsets: [[], [1]],
      explanationEn: "Line 4: Choose nums[1] = 2 -> curr = [1, 2]. Recurse backtrack(2).",
      explanationBn: "লাইন ৪: nums[1] = 2 নির্বাচন করা হলো -> curr = [1, 2]।",
    ),
    SubsetsStep(
      currentPath: [1, 2],
      activeIndex: 1,
      activeLineIndex: 1,
      generatedSubsets: [[], [1], [1, 2]],
      explanationEn: "Line 2: Subset [1, 2] pushed to result list. Result = [[], [1], [1, 2]].",
      explanationBn: "লাইন ২: সাবসেট [1, 2] রেজাল্ট লিস্টে যোগ করা হলো।",
    ),
    SubsetsStep(
      currentPath: [1],
      activeIndex: 1,
      activeLineIndex: 5,
      generatedSubsets: [[], [1], [1, 2]],
      explanationEn: "Line 6: Undo Choice! curr.pop_back() removes 2 -> curr = [1].",
      explanationBn: "লাইন ৬: চয়েস বাতিল! curr.pop_back() দিয়ে 2 রিমুভ -> curr = [1]।",
    ),
    SubsetsStep(
      currentPath: [2],
      activeIndex: 1,
      activeLineIndex: 3,
      generatedSubsets: [[], [1], [1, 2], [2]],
      explanationEn: "Line 4: Backtrack complete to root loop. Choose nums[1] = 2 -> curr = [2].",
      explanationBn: "লাইন ৪: ব্যাকট্র্যাক শেষে লুপে ২ নির্বাচন -> curr = [2]।",
    ),
    SubsetsStep(
      currentPath: [],
      activeIndex: 2,
      activeLineIndex: 7,
      generatedSubsets: [[], [1], [1, 2], [2]],
      explanationEn: "🎉 Line 8: Power Set Complete! All 2^N subsets generated!",
      explanationBn: "🎉 লাইন ৮: পাওয়ার সেট সম্পন্ন! সবকটি সাবসেট তৈরি শেষ!",
    ),
  ];

  final List<SubsetsStep> _template2Steps = const [
    SubsetsStep(
      currentPath: [1, 2],
      activeIndex: 0,
      activeLineIndex: 4,
      generatedSubsets: [],
      explanationEn: "Line 5: Permutation choice [1, 2] visited.",
      explanationBn: "লাইন ৫: পারমুটেশন চয়েস [1, 2] ভিজিটেড।",
    ),
    SubsetsStep(
      currentPath: [1, 2],
      activeIndex: 1,
      activeLineIndex: 1,
      generatedSubsets: [[1, 2]],
      explanationEn: "Line 2: Complete Permutation [1, 2] added to result!",
      explanationBn: "লাইন ২: সম্পূর্ণ পারমুটেশন [1, 2] রেজাল্টে যোগ!",
    ),
    SubsetsStep(
      currentPath: [2, 1],
      activeIndex: 1,
      activeLineIndex: 1,
      generatedSubsets: [[1, 2], [2, 1]],
      explanationEn: "🎉 Line 2: Permutation [2, 1] added! Complete!",
      explanationBn: "🎉 লাইন ২: পারমুটেশন [2, 1] যোগ! সম্পন্ন!",
    ),
  ];

  final List<SubsetsStep> _template3Steps = const [
    SubsetsStep(
      currentPath: [2, 2, 3],
      activeIndex: 0,
      activeLineIndex: 1,
      generatedSubsets: [[2, 2, 3]],
      explanationEn: "🎉 Line 2: Target sum 7 reached with combinations [2, 2, 3]!",
      explanationBn: "🎉 লাইন ২: টার্গেট সাম 7 এর কম্বিনেশন [2, 2, 3] অর্জিত!",
    ),
  ];

  List<SubsetsStep> get _currentSteps {
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
              _buildTemplateChip(0, widget.isEnglish ? "Subsets (Power Set)" : "পাওয়ার সেট সাবসেট"),
              _buildTemplateChip(1, widget.isEnglish ? "Permutations" : "পারমুটেশন (অনুক্ৰম)"),
              _buildTemplateChip(2, widget.isEnglish ? "Combination Sum" : "কম্বিনেশন সাম"),
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
              _buildSubsetsCanvas(step),
            ],
          )
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildCodeSnippetWithHighlight(_currentCodeLines, step.activeLineIndex)),
              const SizedBox(width: 16),
              Expanded(child: _buildSubsetsCanvas(step)),
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

  Widget _buildSubsetsCanvas(SubsetsStep step) {
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
              Text(
                "Active Path curr: ${step.currentPath.toString()}",
                style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13),
              ),
              Text(
                "Generated: [${step.generatedSubsets.length}]",
                style: const TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Subsets Generated Result Grid Canvas
          const Text("Backtracking Subsets Collection Output:", style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.accentGreen.withOpacity(0.4)),
            ),
            child: step.generatedSubsets.isEmpty
                ? Text(widget.isEnglish ? "[ Result Empty ]" : "[ রেজাল্ট খালি ]", style: const TextStyle(color: AppTheme.textMuted, fontSize: 12))
                : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: step.generatedSubsets.map((subset) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.accentGreen,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          subset.isEmpty ? "[]" : subset.toString(),
                          style: const TextStyle(color: AppTheme.primaryDark, fontWeight: FontWeight.bold, fontSize: 12),
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
