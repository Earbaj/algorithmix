import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import 'standard_cyclic_sort_visualizer.dart';

class FindDuplicateVisualizer extends StatefulWidget {
  final bool isEnglish;

  const FindDuplicateVisualizer({super.key, required this.isEnglish});

  @override
  State<FindDuplicateVisualizer> createState() => _FindDuplicateVisualizerState();
}

class _FindDuplicateVisualizerState extends State<FindDuplicateVisualizer> {
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  final List<String> _codeLines = const [
    "int findDuplicate(vector<int>& nums) {",
    "    int i = 0, n = nums.size();",
    "    while (i < n) {",
    "        if (nums[i] != i + 1) {",
    "            int correctIdx = nums[i] - 1;",
    "            if (nums[i] != nums[correctIdx]) swap(nums[i], nums[correctIdx]);",
    "            else return nums[i]; // DUPLICATE FOUND!",
    "        } else i++;",
    "    }",
    "    return -1;",
    "}",
  ];

  final List<CyclicStep> _steps = const [
    CyclicStep(
      activeIndex: 0,
      correctIndex: 0,
      activeLineIndex: 3,
      arrayState: [1, 3, 4, 2, 2],
      explanationEn: "Line 4: i = 0: nums[0] = 1 == 0 + 1 -> Correct position! Advance i++.",
      explanationBn: "লাইন ৪: i = 0: nums[0] = 1 == 0 + 1 -> সঠিক অবস্থান! i++ আগানো হলো।",
    ),
    CyclicStep(
      activeIndex: 1,
      correctIndex: 2,
      activeLineIndex: 5,
      arrayState: [1, 4, 3, 2, 2],
      isSwapping: true,
      explanationEn: "Line 6: i = 1: nums[1] = 3. Swap with nums[2] (4) -> Array = [1, 4, 3, 2, 2].",
      explanationBn: "লাইন ৬: i = 1: nums[1] = 3। nums[2] (4) এর সাথে সোয়াপ -> [1, 4, 3, 2, 2]।",
    ),
    CyclicStep(
      activeIndex: 1,
      correctIndex: 3,
      activeLineIndex: 5,
      arrayState: [1, 2, 3, 4, 2],
      isSwapping: true,
      explanationEn: "Line 6: nums[1] = 4. Swap with nums[3] (2) -> Array = [1, 2, 3, 4, 2].",
      explanationBn: "লাইন ৬: nums[1] = 4। nums[3] (2) এর সাথে সোয়াপ -> [1, 2, 3, 4, 2]।",
    ),
    CyclicStep(
      activeIndex: 4,
      correctIndex: 1,
      activeLineIndex: 6,
      arrayState: [1, 2, 3, 4, 2],
      explanationEn: "🎉 Line 7: At i = 4: nums[4] = 2, but nums[1] is ALREADY 2! DUPLICATE FOUND = 2!",
      explanationBn: "🎉 লাইন ৭: i = 4: nums[4] = 2, কিন্তু nums[1] এ ইতিমধ্যেই 2 বিদ্যমান! ডুপ্লিকেট সংখ্যা = 2!",
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
            color: step.isSwapping ? AppTheme.accentAmber.withOpacity(0.15) : AppTheme.accentNeonCyan.withOpacity(0.15),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: step.isSwapping ? AppTheme.accentAmber : AppTheme.accentNeonCyan),
          ),
          child: Text(
            widget.isEnglish ? step.explanationEn : step.explanationBn,
            style: TextStyle(
              color: step.isSwapping ? AppTheme.accentAmber : AppTheme.accentNeonCyan,
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
              _buildArrayCanvas(step),
            ],
          )
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildCodeSnippetWithHighlight(_codeLines, step.activeLineIndex)),
              const SizedBox(width: 16),
              Expanded(child: _buildArrayCanvas(step)),
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

  Widget _buildArrayCanvas(CyclicStep step) {
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
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("Active Index i: [${step.activeIndex}]", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13)),
              Text("Target Index: [${step.correctIndex}]", style: const TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 16),
          const Text("Array Elements & Duplicate Detector:", style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(step.arrayState.length, (i) {
                final isCurrent = i == step.activeIndex;
                final isTarget = i == step.correctIndex;
                final isBoth = isCurrent && isTarget;

                final Color color = isBoth
                    ? AppTheme.accentGreen
                    : (isCurrent ? AppTheme.accentNeonCyan : (isTarget ? AppTheme.accentAmber : AppTheme.surfaceDark));

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 55,
                    height: 60,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: (isCurrent || isTarget) ? Colors.white : const Color(0xFF1E293B),
                        width: (isCurrent || isTarget) ? 2.5 : 1,
                      ),
                      boxShadow: (isCurrent || isTarget) ? [BoxShadow(color: color.withOpacity(0.6), blurRadius: 8)] : [],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${step.arrayState[i]}",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: (isCurrent || isTarget) ? AppTheme.primaryDark : Colors.white),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "[$i]",
                          style: TextStyle(fontSize: 9, color: (isCurrent || isTarget) ? AppTheme.primaryDark : AppTheme.textMuted),
                        ),
                      ],
                    ),
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
