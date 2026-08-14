import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class DebugVisualizerStep {
  final int left;
  final int right;
  final int? fixed;
  final int activeLineIndex;
  final List<int> arrayState;
  final String explanationEn;
  final String explanationBn;
  final bool isMatch;

  const DebugVisualizerStep({
    required this.left,
    required this.right,
    this.fixed,
    required this.activeLineIndex,
    required this.arrayState,
    required this.explanationEn,
    required this.explanationBn,
    this.isMatch = false,
  });
}

class OppositeDirectionVisualizer extends StatefulWidget {
  final bool isEnglish;

  const OppositeDirectionVisualizer({super.key, required this.isEnglish});

  @override
  State<OppositeDirectionVisualizer> createState() => _OppositeDirectionVisualizerState();
}

class _OppositeDirectionVisualizerState extends State<OppositeDirectionVisualizer> {
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  final List<String> _codeLines = const [
    "vector<int> twoSum(vector<int>& arr, int target) {",
    "   int left = 0;",
    "   right = arr.size() - 1;",
    "   while (left < right) {",
    "     int curr_sum = arr[left] + arr[right];",
    "     if (curr_sum == target) {",
    "         return {left, right};",
    "     }",
    "     else if (curr_sum < target) left++;",
    "     else right--;",
    "   }",
    "   return {-1, -1};",
    "}",
  ];

  final List<DebugVisualizerStep> _steps = const [
    DebugVisualizerStep(
      left: 0,
      right: 6,
      activeLineIndex: 1,
      arrayState: [1, 2, 4, 6, 8, 11, 15],
      explanationEn: "Line 2: Initialize variables -> left = 0 (val 1). Target = 10.",
      explanationBn: "লাইন ২: ভ্যারিয়েবল ডিক্লেয়ার -> left = 0 (মান 1)। Target = 10।",
    ),
    DebugVisualizerStep(
      left: 0,
      right: 6,
      activeLineIndex: 2,
      arrayState: [1, 2, 4, 6, 8, 11, 15],
      explanationEn: "Line 3: Initialize variables -> right = 6 (val 15).",
      explanationBn: "লাইন ৩: ভ্যারিয়েবল ডিক্লেয়ার -> right = 6 (মান 15)।",
    ),
    DebugVisualizerStep(
      left: 0,
      right: 6,
      activeLineIndex: 3,
      arrayState: [1, 2, 4, 6, 8, 11, 15],
      explanationEn: "Line 4: Check while (left < right) -> (0 < 6) is TRUE. Enter loop.",
      explanationBn: "লাইন ৪: শর্ত চেক while (left < right) -> (0 < 6) সত্য! লুপে প্রবেশ করুন।",
    ),
    DebugVisualizerStep(
      left: 0,
      right: 6,
      activeLineIndex: 4,
      arrayState: [1, 2, 4, 6, 8, 11, 15],
      explanationEn: "Line 5: Calculate curr_sum = arr[0] + arr[6] = 1 + 15 = 16.",
      explanationBn: "লাইন ৫: হিসাব করুন curr_sum = arr[0] + arr[6] = 1 + 15 = 16।",
    ),
    DebugVisualizerStep(
      left: 0,
      right: 6,
      activeLineIndex: 5,
      arrayState: [1, 2, 4, 6, 8, 11, 15],
      explanationEn: "Line 6: Check if (curr_sum == target) -> (16 == 10) is FALSE.",
      explanationBn: "লাইন ৬: চেক if (curr_sum == target) -> (16 == 10) মিথ্যা।",
    ),
    DebugVisualizerStep(
      left: 0,
      right: 6,
      activeLineIndex: 8,
      arrayState: [1, 2, 4, 6, 8, 11, 15],
      explanationEn: "Line 9: Check else if (curr_sum < target) -> (16 < 10) is FALSE.",
      explanationBn: "লাইন ৯: চেক else if (curr_sum < target) -> (16 < 10) মিথ্যা।",
    ),
    DebugVisualizerStep(
      left: 0,
      right: 5,
      activeLineIndex: 9,
      arrayState: [1, 2, 4, 6, 8, 11, 15],
      explanationEn: "Line 10: Execute else right-- -> right decreases from 6 to 5.",
      explanationBn: "লাইন ১০: else এক্সিকিউট right-- -> right কমে 6 থেকে 5 হলো।",
    ),
    DebugVisualizerStep(
      left: 0,
      right: 5,
      activeLineIndex: 3,
      arrayState: [1, 2, 4, 6, 8, 11, 15],
      explanationEn: "Line 4: Check while (left < right) -> (0 < 5) is TRUE. Continue loop.",
      explanationBn: "লাইন ৪: শর্ত চেক while (left < right) -> (0 < 5) সত্য! লুপ চলবে।",
    ),
    DebugVisualizerStep(
      left: 0,
      right: 5,
      activeLineIndex: 4,
      arrayState: [1, 2, 4, 6, 8, 11, 15],
      explanationEn: "Line 5: Calculate curr_sum = arr[0] + arr[5] = 1 + 11 = 12.",
      explanationBn: "লাইন ৫: হিসাব করুন curr_sum = arr[0] + arr[5] = 1 + 11 = 12।",
    ),
    DebugVisualizerStep(
      left: 0,
      right: 5,
      activeLineIndex: 5,
      arrayState: [1, 2, 4, 6, 8, 11, 15],
      explanationEn: "Line 6: Check if (curr_sum == target) -> (12 == 10) is FALSE.",
      explanationBn: "লাইন ৬: চেক if (curr_sum == target) -> (12 == 10) মিথ্যা।",
    ),
    DebugVisualizerStep(
      left: 0,
      right: 5,
      activeLineIndex: 8,
      arrayState: [1, 2, 4, 6, 8, 11, 15],
      explanationEn: "Line 9: Check else if (curr_sum < target) -> (12 < 10) is FALSE.",
      explanationBn: "লাইন ৯: চেক else if (curr_sum < target) -> (12 < 10) মিথ্যা।",
    ),
    DebugVisualizerStep(
      left: 0,
      right: 4,
      activeLineIndex: 9,
      arrayState: [1, 2, 4, 6, 8, 11, 15],
      explanationEn: "Line 10: Execute else right-- -> right decreases from 5 to 4.",
      explanationBn: "লাইন ১০: else এক্সিকিউট right-- -> right কমে 5 থেকে 4 হলো।",
    ),
    DebugVisualizerStep(
      left: 0,
      right: 4,
      activeLineIndex: 3,
      arrayState: [1, 2, 4, 6, 8, 11, 15],
      explanationEn: "Line 4: Check while (left < right) -> (0 < 4) is TRUE.",
      explanationBn: "লাইন ৪: শর্ত চেক while (left < right) -> (0 < 4) সত্য।",
    ),
    DebugVisualizerStep(
      left: 0,
      right: 4,
      activeLineIndex: 4,
      arrayState: [1, 2, 4, 6, 8, 11, 15],
      explanationEn: "Line 5: Calculate curr_sum = arr[0] + arr[4] = 1 + 8 = 9.",
      explanationBn: "লাইন ৫: হিসাব করুন curr_sum = arr[0] + arr[4] = 1 + 8 = 9।",
    ),
    DebugVisualizerStep(
      left: 0,
      right: 4,
      activeLineIndex: 5,
      arrayState: [1, 2, 4, 6, 8, 11, 15],
      explanationEn: "Line 6: Check if (curr_sum == target) -> (9 == 10) is FALSE.",
      explanationBn: "লাইন ৬: চেক if (curr_sum == target) -> (9 == 10) মিথ্যা।",
    ),
    DebugVisualizerStep(
      left: 1,
      right: 4,
      activeLineIndex: 8,
      arrayState: [1, 2, 4, 6, 8, 11, 15],
      explanationEn: "Line 9: Check else if (curr_sum < target) -> (9 < 10) is TRUE! Execute left++ -> left increases from 0 to 1.",
      explanationBn: "লাইন ৯: চেক (9 < 10) সত্য! left++ এক্সিকিউট -> left বেড়ে 1 হলো।",
    ),
    DebugVisualizerStep(
      left: 1,
      right: 4,
      activeLineIndex: 3,
      arrayState: [1, 2, 4, 6, 8, 11, 15],
      explanationEn: "Line 4: Check while (left < right) -> (1 < 4) is TRUE.",
      explanationBn: "লাইন ৪: শর্ত চেক while (left < right) -> (1 < 4) সত্য।",
    ),
    DebugVisualizerStep(
      left: 1,
      right: 4,
      activeLineIndex: 4,
      arrayState: [1, 2, 4, 6, 8, 11, 15],
      explanationEn: "Line 5: Calculate curr_sum = arr[1] + arr[4] = 2 + 8 = 10.",
      explanationBn: "লাইন ৫: হিসাব করুন curr_sum = arr[1] + arr[4] = 2 + 8 = 10।",
    ),
    DebugVisualizerStep(
      left: 1,
      right: 4,
      activeLineIndex: 5,
      arrayState: [1, 2, 4, 6, 8, 11, 15],
      explanationEn: "Line 6: Check if (curr_sum == target) -> (10 == 10) is TRUE! MATCH FOUND!",
      explanationBn: "লাইন ৬: চেক if (curr_sum == target) -> (10 == 10) সত্য! টার্গেট সাম পাওয়া গেছে!",
      isMatch: true,
    ),
    DebugVisualizerStep(
      left: 1,
      right: 4,
      activeLineIndex: 6,
      arrayState: [1, 2, 4, 6, 8, 11, 15],
      explanationEn: "🎉 Line 7: Execute return {left, right} -> Returns indices {1, 4} (values 2 and 8). Success!",
      explanationBn: "🎉 লাইন ৭: এক্সিকিউট return {left, right} -> রিটার্ন ইনডেক্স {1, 4} (মান 2 এবং 8)। সফল!",
      isMatch: true,
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
            color: step.isMatch ? AppTheme.accentGreen.withOpacity(0.15) : AppTheme.accentNeonCyan.withOpacity(0.15),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: step.isMatch ? AppTheme.accentGreen : AppTheme.accentNeonCyan),
          ),
          child: Text(
            widget.isEnglish ? step.explanationEn : step.explanationBn,
            style: TextStyle(
              color: step.isMatch ? AppTheme.accentGreen : AppTheme.accentNeonCyan,
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

  Widget _buildCanvas(DebugVisualizerStep step) {
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
              Text("Left: [${step.left}] = ${step.arrayState[step.left]}", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13)),
              Text("Right: [${step.right}] = ${step.arrayState[step.right]}", style: const TextStyle(color: AppTheme.accentPink, fontWeight: FontWeight.bold, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(step.arrayState.length, (idx) {
                final isLeft = idx == step.left;
                final isRight = idx == step.right;
                final isSelected = isLeft || isRight;

                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: Column(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (step.isMatch ? AppTheme.accentGreen.withOpacity(0.3) : AppTheme.accentPurple.withOpacity(0.3))
                              : AppTheme.surfaceDark,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isLeft
                                ? AppTheme.accentNeonCyan
                                : (isRight ? AppTheme.accentPink : const Color(0xFF334155)),
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Text(
                          "${step.arrayState[idx]}",
                          style: TextStyle(
                            color: isLeft ? AppTheme.accentNeonCyan : (isRight ? AppTheme.accentPink : Colors.white),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text("[$idx]", style: const TextStyle(color: AppTheme.textMuted, fontSize: 10)),
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
