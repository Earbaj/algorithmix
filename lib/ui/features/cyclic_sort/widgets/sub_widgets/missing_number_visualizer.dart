import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import 'standard_cyclic_sort_visualizer.dart';

class MissingNumberVisualizer extends StatefulWidget {
  final bool isEnglish;

  const MissingNumberVisualizer({super.key, required this.isEnglish});

  @override
  State<MissingNumberVisualizer> createState() => _MissingNumberVisualizerState();
}

class _MissingNumberVisualizerState extends State<MissingNumberVisualizer> {
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  final List<String> _codeLines = const [
    "int missingNumber(vector<int>& nums) {",
    "    int i = 0, n = nums.size();",
    "    while (i < n) {",
    "        if (nums[i] < n && nums[i] != nums[nums[i]]) {",
    "            swap(nums[i], nums[nums[i]]);",
    "        } else i++;",
    "    }",
    "    for (int j = 0; j < n; j++) {",
    "        if (nums[j] != j) return j; // MISSING NUMBER FOUND!",
    "    }",
    "    return n;",
    "}",
  ];

  final List<CyclicStep> _steps = const [
    CyclicStep(
      activeIndex: 0,
      correctIndex: 3,
      activeLineIndex: 2,
      arrayState: [3, 0, 1], // N = 3, Missing 2
      explanationEn: "Line 3: Cyclic Sort [3, 0, 1] (range 0 to N=3). nums[0] = 3 (out of bounds 3 == N), advance i++.",
      explanationBn: "লাইন ৩: সাইক্লিক সর্ট [3, 0, 1]। nums[0] = 3 (সীমানার বাইরে), i++ আগানো হলো।",
    ),
    CyclicStep(
      activeIndex: 1,
      correctIndex: 0,
      activeLineIndex: 4,
      arrayState: [0, 3, 1],
      isSwapping: true,
      explanationEn: "Line 5: Swap nums[1] (0) with nums[0] (3) -> Array = [0, 3, 1]. 0 is now at index 0!",
      explanationBn: "লাইন ৫: 0 কে তার সঠিক স্থান 0 তে সোয়াপ করা হলো! অ্যারে = [0, 3, 1]।",
    ),
    CyclicStep(
      activeIndex: 2,
      correctIndex: 1,
      activeLineIndex: 4,
      arrayState: [0, 1, 3],
      isSwapping: true,
      explanationEn: "Line 5: Swap nums[2] (1) with nums[1] (3) -> Array = [0, 1, 3]. 1 is now at index 1!",
      explanationBn: "লাইন ৫: 1 কে তার সঠিক স্থান 1 এ সোয়াপ করা হলো! অ্যারে = [0, 1, 3]।",
    ),
    CyclicStep(
      activeIndex: 2,
      correctIndex: 2,
      activeLineIndex: 8,
      arrayState: [0, 1, 3],
      explanationEn: "🎉 Line 9: Scan array: Index 2 has nums[2] = 3 != 2. MISSING NUMBER IS 2!",
      explanationBn: "🎉 লাইন ৯: ইনডেক্স ট্রাভার্সাল: ইনডেক্স 2 এ nums[2] = 3 != 2। নিখোঁজ সংখ্যা = 2!",
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
          const Text("Array Elements & Missing Number Scan:", style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
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
