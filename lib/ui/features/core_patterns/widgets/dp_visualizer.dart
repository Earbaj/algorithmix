import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class DPStep {
  final int activeIndex;
  final int activeLineIndex;
  final List<int> dpTable;
  final String explanationEn;
  final String explanationBn;

  const DPStep({
    required this.activeIndex,
    required this.activeLineIndex,
    required this.dpTable,
    required this.explanationEn,
    required this.explanationBn,
  });
}

class DPVisualizer extends StatefulWidget {
  final bool isEnglish;

  const DPVisualizer({super.key, required this.isEnglish});

  @override
  State<DPVisualizer> createState() => _DPVisualizerState();
}

class _DPVisualizerState extends State<DPVisualizer> {
  int _selectedTemplateIndex = 0;
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  final List<List<String>> _codeTemplates = const [
    // Template 1: House Robber
    [
      "int rob(vector<int>& nums) {",
      "    if (nums.empty()) return 0;",
      "    int prev2 = 0, prev1 = 0;",
      "    for (int num : nums) {",
      "        int temp = prev1;",
      "        prev1 = max(prev1, prev2 + num); // State Transition!",
      "        prev2 = temp;",
      "    }",
      "    return prev1; // Max loot in O(N) time and O(1) space!",
      "}",
    ],
    // Template 2: 0/1 Knapsack
    [
      "bool canPartition(vector<int>& nums) {",
      "    int sum = accumulate(nums.begin(), nums.end(), 0);",
      "    if (sum % 2 != 0) return false;",
      "    int target = sum / 2;",
      "    vector<bool> dp(target + 1, false); dp[0] = true;",
      "    for (int num : nums) {",
      "        for (int w = target; w >= num; w--) { // Reverse 1D loop!",
      "            dp[w] = dp[w] || dp[w - num];",
      "        }",
      "    }",
      "    return dp[target];",
      "}",
    ],
    // Template 3: LCS
    [
      "int longestCommonSubsequence(string text1, string text2) {",
      "    int m = text1.size(), n = text2.size();",
      "    vector<vector<int>> dp(m + 1, vector<int>(n + 1, 0));",
      "    for (int i = 1; i <= m; i++) {",
      "        for (int j = 1; j <= n; j++) {",
      "            if (text1[i-1] == text2[j-1]) dp[i][j] = 1 + dp[i-1][j-1];",
      "            else dp[i][j] = max(dp[i-1][j], dp[i][j-1]);",
      "        }",
      "    }",
      "    return dp[m][n];",
      "}",
    ],
  ];

  final List<DPStep> _template1Steps = const [
    DPStep(
      activeIndex: 0,
      activeLineIndex: 5,
      dpTable: [1],
      explanationEn: "Line 6: House 0 (val 1). prev1 = max(0, 0 + 1) = 1. dp = [1].",
      explanationBn: "লাইন ৬: বাড়ি 0 (মান 1)। prev1 = max(0, 0 + 1) = 1। dp = [1] ।",
    ),
    DPStep(
      activeIndex: 1,
      activeLineIndex: 5,
      dpTable: [1, 2],
      explanationEn: "Line 6: House 1 (val 2). prev1 = max(1, 0 + 2) = 2. dp = [1, 2].",
      explanationBn: "লাইন ৬: বাড়ি 1 (মান 2)। prev1 = max(1, 0 + 2) = 2। dp = [1, 2]।",
    ),
    DPStep(
      activeIndex: 2,
      activeLineIndex: 5,
      dpTable: [1, 2, 4],
      explanationEn: "Line 6: House 2 (val 3). prev1 = max(2, 1 + 3) = 4. dp = [1, 2, 4].",
      explanationBn: "লাইন ৬: বাড়ি 2 (মান 3)। prev1 = max(2, 1 + 3) = 4। dp = [1, 2, 4]।",
    ),
    DPStep(
      activeIndex: 3,
      activeLineIndex: 5,
      dpTable: [1, 2, 4, 4],
      explanationEn: "Line 6: House 3 (val 1). prev1 = max(4, 2 + 1) = 4. dp = [1, 2, 4, 4].",
      explanationBn: "লাইন ৬: বাড়ি 3 (মান 1)। prev1 = max(4, 2 + 1) = 4। dp = [1, 2, 4, 4]।",
    ),
    DPStep(
      activeIndex: 3,
      activeLineIndex: 8,
      dpTable: [1, 2, 4, 4],
      explanationEn: "🎉 Line 9: Max loot calculated in O(N) time and O(1) space! Result = 4!",
      explanationBn: "🎉 লাইন ৯: O(N) টাইম ও O(1) স্পেসে সর্বোচ্চ চুরি হিসেব সম্পন্ন! উত্তর = 4!",
    ),
  ];

  final List<DPStep> _template2Steps = const [
    DPStep(
      activeIndex: 1,
      activeLineIndex: 7,
      dpTable: [1, 1, 0, 0, 1, 1],
      explanationEn: "Line 8: Reverse 1D loop: dp[w] = dp[w] || dp[w - num].",
      explanationBn: "লাইন ৮: উল্টো ১D লুপ: dp[w] = dp[w] || dp[w - num]।",
    ),
    DPStep(
      activeIndex: 2,
      activeLineIndex: 10,
      dpTable: [1, 1, 1, 1, 1, 1],
      explanationEn: "🎉 Line 11: Partition target reached! Subset sum partition possible!",
      explanationBn: "🎉 লাইন ১১: পার্টিশন টার্গেট মিলেছে! সমান যোগফলের সাবসেট সম্ভব!",
    ),
  ];

  final List<DPStep> _template3Steps = const [
    DPStep(
      activeIndex: 2,
      activeLineIndex: 6,
      dpTable: [0, 1, 2, 3],
      explanationEn: "Line 7: Character match text1[i-1] == text2[j-1]. 1 + dp[i-1][j-1].",
      explanationBn: "লাইন ৭: অক্ষর মিলেছে text1[i-1] == text2[j-1]। 1 + dp[i-1][j-1]।",
    ),
    DPStep(
      activeIndex: 3,
      activeLineIndex: 9,
      dpTable: [0, 1, 2, 3],
      explanationEn: "🎉 Line 10: Longest Common Subsequence length = 3!",
      explanationBn: "🎉 লাইন ১০: দীর্ঘতম কমন সাবসিকোয়েন্স দৈর্ঘ্য = 3!",
    ),
  ];

  List<DPStep> get _currentSteps {
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
              _buildTemplateChip(0, widget.isEnglish ? "House Robber (1D DP)" : "হাউস রবার (১D DP)"),
              _buildTemplateChip(1, widget.isEnglish ? "0/1 Knapsack Partition" : "০/১ ক্যানপস্যাক"),
              _buildTemplateChip(2, widget.isEnglish ? "Longest Common Subseq" : "দীর্ঘতম সর্টেড সাবসিকোয়েন্স"),
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
              _buildDPCanvas(step),
            ],
          )
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildCodeSnippetWithHighlight(_currentCodeLines, step.activeLineIndex)),
              const SizedBox(width: 16),
              Expanded(child: _buildDPCanvas(step)),
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

  Widget _buildDPCanvas(DPStep step) {
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
              Text("Active Index: [${step.activeIndex}]", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13)),
              Text("DP Result: [${step.dpTable.last}]", style: const TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 16),

          // DP Lookup Table State Canvas
          const Text("DP Lookup Table State Array:", style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(step.dpTable.length, (i) {
                final isCurrent = i == step.activeIndex;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 52,
                  height: 65,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: isCurrent ? AppTheme.accentPink : AppTheme.accentPurple,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isCurrent ? Colors.white : AppTheme.accentPurple,
                      width: isCurrent ? 2.5 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${step.dpTable[i]}",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "dp[$i]",
                        style: TextStyle(fontSize: 9, color: isCurrent ? Colors.white : AppTheme.textMuted),
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
