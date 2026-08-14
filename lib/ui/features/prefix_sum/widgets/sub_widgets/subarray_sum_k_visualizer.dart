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

class SubarraySumKVisualizer extends StatefulWidget {
  final bool isEnglish;

  const SubarraySumKVisualizer({super.key, required this.isEnglish});

  @override
  State<SubarraySumKVisualizer> createState() => _SubarraySumKVisualizerState();
}

class _SubarraySumKVisualizerState extends State<SubarraySumKVisualizer> {
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  final List<String> _codeLines = const [
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
  ];

  final List<PrefixStep> _steps = const [
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
            color: step.activeLineIndex == 10 ? AppTheme.accentGreen.withOpacity(0.15) : AppTheme.accentNeonCyan.withOpacity(0.15),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: step.activeLineIndex == 10 ? AppTheme.accentGreen : AppTheme.accentNeonCyan),
          ),
          child: Text(
            widget.isEnglish ? step.explanationEn : step.explanationBn,
            style: TextStyle(
              color: step.activeLineIndex == 10 ? AppTheme.accentGreen : AppTheme.accentNeonCyan,
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

  Widget _buildCanvas(PrefixStep step) {
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
              Text("currSum: ${step.currSum}", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13)),
              Text("Subarray Count: [${step.count}]", style: const TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 16),
          const Text("Prefix Map State {Sum: Count}:", style: TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: step.prefixMapState.entries.map((e) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.accentPurple.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppTheme.accentPurple),
                ),
                child: Text(
                  "${e.key} => ${e.value}",
                  style: const TextStyle(color: AppTheme.accentPurple, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              );
            }).toList(),
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
