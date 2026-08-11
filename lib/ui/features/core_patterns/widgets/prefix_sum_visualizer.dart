import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class PrefixStep {
  final int activeIndex;
  final int activeLineIndex;
  final List<int> prefixArray;
  final Map<int, int> prefixMapState;
  final int currSum;
  final int count;
  final String explanationEn;
  final String explanationBn;

  const PrefixStep({
    required this.activeIndex,
    required this.activeLineIndex,
    required this.prefixArray,
    required this.prefixMapState,
    required this.currSum,
    required this.count,
    required this.explanationEn,
    required this.explanationBn,
  });
}

class PrefixSumVisualizer extends StatefulWidget {
  final bool isEnglish;

  const PrefixSumVisualizer({super.key, required this.isEnglish});

  @override
  State<PrefixSumVisualizer> createState() => _PrefixSumVisualizerState();
}

class _PrefixSumVisualizerState extends State<PrefixSumVisualizer> {
  int _selectedTemplateIndex = 0;
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  final List<List<String>> _codeTemplates = const [
    // Template 1: Subarray Sum Equals K
    [
      "int subarraySum(vector<int>& nums, int k) {",
      "    unordered_map<int, int> prefixMap; prefixMap[0] = 1; // Base case!",
      "    int currSum = 0, count = 0;",
      "    for (int num : nums) {",
      "        currSum += num;",
      "        if (prefixMap.count(currSum - k)) {",
      "            count += prefixMap[currSum - k]; // Subarray found!",
      "        }",
      "        prefixMap[currSum]++;",
      "    }",
      "    return count;",
      "}",
    ],
    // Template 2: Range Sum Query Immutable
    [
      "class NumArray {",
      "    vector<int> prefix;",
      "public:",
      "    NumArray(vector<int>& nums) {",
      "        prefix.resize(nums.size() + 1, 0);",
      "        for (int i = 0; i < nums.size(); i++) {",
      "            prefix[i + 1] = prefix[i] + nums[i]; // Cumulative sum",
      "        }",
      "    }",
      "    int sumRange(int left, int right) {",
      "        return prefix[right + 1] - prefix[left]; // O(1) Range Query!",
      "    }",
      "};",
    ],
    // Template 3: Product of Array Except Self
    [
      "vector<int> productExceptSelf(vector<int>& nums) {",
      "    int n = nums.size(); vector<int> ans(n, 1);",
      "    int prefix = 1;",
      "    for (int i = 0; i < n; i++) { ans[i] = prefix; prefix *= nums[i]; } // Left pass",
      "    int suffix = 1;",
      "    for (int i = n - 1; i >= 0; i--) { ans[i] *= suffix; suffix *= nums[i]; } // Right pass",
      "    return ans;",
      "}",
    ],
  ];

  final List<PrefixStep> _template1Steps = const [
    PrefixStep(
      activeIndex: 0,
      activeLineIndex: 1,
      prefixArray: [0, 1],
      prefixMapState: {0: 1},
      currSum: 0,
      count: 0,
      explanationEn: "Line 2: Init prefixMap[0] = 1. k = 2. nums = [1, 1, 1].",
      explanationBn: "লাইন ২: prefixMap[0] = 1 প্রারম্ভিককরণ। k = 2। nums = [1, 1, 1]।",
    ),
    PrefixStep(
      activeIndex: 0,
      activeLineIndex: 4,
      prefixArray: [0, 1],
      prefixMapState: {0: 1, 1: 1},
      currSum: 1,
      count: 0,
      explanationEn: "Line 5: i=0 (num 1): currSum = 1. map check (1 - 2 = -1) -> not found. map[1] = 1.",
      explanationBn: "লাইন ৫: i=0 (num 1): currSum = 1। map চেক (1 - 2 = -1) -> পাওয়া যায়নি। map[1] = 1।",
    ),
    PrefixStep(
      activeIndex: 1,
      activeLineIndex: 6,
      prefixArray: [0, 1, 2],
      prefixMapState: {0: 1, 1: 1, 2: 1},
      currSum: 2,
      count: 1,
      explanationEn: "Line 7: i=1 (num 1): currSum = 2. map check (2 - 2 = 0) -> FOUND (map[0]=1)! Count = 1.",
      explanationBn: "লাইন ৭: i=1 (num 1): currSum = 2। map চেক (2 - 2 = 0) -> পাওয়া গেছে! Count = 1।",
    ),
    PrefixStep(
      activeIndex: 2,
      activeLineIndex: 6,
      prefixArray: [0, 1, 2, 3],
      prefixMapState: {0: 1, 1: 1, 2: 1, 3: 1},
      currSum: 3,
      count: 2,
      explanationEn: "Line 7: i=2 (num 1): currSum = 3. map check (3 - 2 = 1) -> FOUND (map[1]=1)! Count = 2.",
      explanationBn: "লাইন ৭: i=2 (num 1): currSum = 3। map চেক (3 - 2 = 1) -> পাওয়া গেছে! Count = 2।",
    ),
    PrefixStep(
      activeIndex: 2,
      activeLineIndex: 10,
      prefixArray: [0, 1, 2, 3],
      prefixMapState: {0: 1, 1: 1, 2: 1, 3: 1},
      currSum: 3,
      count: 2,
      explanationEn: "🎉 Line 11: Subarray Sum Equals K Completed! Total Subarrays Count = 2!",
      explanationBn: "🎉 লাইন ১১: Subarray Sum Equals K সম্পন্ন! মোট সাবএরে সংখ্যা = ২!",
    ),
  ];

  final List<PrefixStep> _template2Steps = const [
    PrefixStep(
      activeIndex: 2,
      activeLineIndex: 6,
      prefixArray: [0, -2, 0, 3, -5, 2, -1],
      prefixMapState: {},
      currSum: 1,
      count: 0,
      explanationEn: "Line 7: Precomputed 1D Prefix Array = [0, -2, 0, 3, -5, 2, -1].",
      explanationBn: "লাইন ৭: ১D কিউমুলেটিভ প্রিফিক্স এরে ফিলিং সম্পন্ন।",
    ),
    PrefixStep(
      activeIndex: 2,
      activeLineIndex: 10,
      prefixArray: [0, -2, 0, 3, -5, 2, -1],
      prefixMapState: {},
      currSum: 1,
      count: 1,
      explanationEn: "🎉 Line 11: RangeSum(0, 2) = prefix[3] - prefix[0] = 3 - 0 = 3 in O(1) time!",
      explanationBn: "🎉 লাইন ১১: RangeSum(0, 2) = prefix[3] - prefix[0] = 3 - 0 = 3 ও(১) সময়ে সম্পন্ন!",
    ),
  ];

  final List<PrefixStep> _template3Steps = const [
    PrefixStep(
      activeIndex: 3,
      activeLineIndex: 5,
      prefixArray: [24, 12, 8, 6],
      prefixMapState: {},
      currSum: 0,
      count: 0,
      explanationEn: "🎉 Line 6: Product of Array Except Self = [24, 12, 8, 6] in O(N) time and O(1) space!",
      explanationBn: "🎉 লাইন ৬: Product Except Self = [24, 12, 8, 6] ও(N) টাইম ও ও(১) স্পেসে সম্পন্ন!",
    ),
  ];

  List<PrefixStep> get _currentSteps {
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
              _buildTemplateChip(0, widget.isEnglish ? "Subarray Sum Equals K" : "Subarray Sum = K"),
              _buildTemplateChip(1, widget.isEnglish ? "Range Sum Query O(1)" : "১D রেঞ্জ সাম কোয়েরি"),
              _buildTemplateChip(2, widget.isEnglish ? "Product Except Self" : "প্রোডাক্ট একসেপ্ট সেলফ"),
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
              _buildPrefixCanvas(step),
            ],
          )
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildCodeSnippetWithHighlight(_currentCodeLines, step.activeLineIndex)),
              const SizedBox(width: 16),
              Expanded(child: _buildPrefixCanvas(step)),
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

  Widget _buildPrefixCanvas(PrefixStep step) {
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
              Text("Cumulative Sum: [${step.currSum}]", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13)),
              Text("Count Result: [${step.count}]", style: const TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 16),

          // Prefix Sum Array Inspector
          const Text("Prefix Cumulative Sum Array:", style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(step.prefixArray.length, (i) {
                final isCurrent = i == step.activeIndex;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 50,
                  height: 60,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: isCurrent ? AppTheme.accentPurple : AppTheme.surfaceDark,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isCurrent ? AppTheme.accentNeonCyan : const Color(0xFF1E293B),
                      width: isCurrent ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${step.prefixArray[i]}",
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 2),
                      Text("P[$i]", style: const TextStyle(fontSize: 9, color: AppTheme.textMuted)),
                    ],
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 16),

          // Prefix HashMap Inspector
          if (step.prefixMapState.isNotEmpty) ...[
            const Text("Prefix Sum HashMap State ({sum: count}):", style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
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
                spacing: 8,
                children: step.prefixMapState.entries.map((e) {
                  return Chip(
                    backgroundColor: AppTheme.primaryDark,
                    label: Text(
                      "Sum ${e.key}: count ${e.value}",
                      style: const TextStyle(color: AppTheme.accentNeonCyan, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
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
