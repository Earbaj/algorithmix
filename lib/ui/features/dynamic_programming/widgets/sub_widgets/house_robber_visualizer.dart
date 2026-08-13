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

class HouseRobberVisualizer extends StatefulWidget {
  final bool isEnglish;

  const HouseRobberVisualizer({super.key, required this.isEnglish});

  @override
  State<HouseRobberVisualizer> createState() => _HouseRobberVisualizerState();
}

class _HouseRobberVisualizerState extends State<HouseRobberVisualizer> {
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  final List<String> _codeLines = const [
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
  ];

  final List<DPStep> _steps = const [
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
            color: step.activeLineIndex == 8 ? AppTheme.accentGreen.withOpacity(0.15) : AppTheme.accentNeonCyan.withOpacity(0.15),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: step.activeLineIndex == 8 ? AppTheme.accentGreen : AppTheme.accentNeonCyan),
          ),
          child: Text(
            widget.isEnglish ? step.explanationEn : step.explanationBn,
            style: TextStyle(
              color: step.activeLineIndex == 8 ? AppTheme.accentGreen : AppTheme.accentNeonCyan,
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

  Widget _buildCanvas(DPStep step) {
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
              Text("Active House Index: [${step.activeIndex}]", style: const TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 13)),
              Text("Max Loot: [${step.dpTable.last}]", style: const TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 16),

          // 1D DP Array Visualization
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(step.dpTable.length, (idx) {
                final isCurrent = idx == step.activeIndex;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: Column(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isCurrent ? AppTheme.accentAmber.withOpacity(0.3) : AppTheme.accentPurple.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: isCurrent ? AppTheme.accentAmber : AppTheme.accentPurple, width: isCurrent ? 2 : 1),
                        ),
                        child: Text(
                          "${step.dpTable[idx]}",
                          style: TextStyle(
                            color: isCurrent ? AppTheme.accentAmber : Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text("dp[$idx]", style: const TextStyle(color: AppTheme.textMuted, fontSize: 10)),
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
