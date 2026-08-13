import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import 'rotated_array_search_visualizer.dart';

class FirstLastPositionVisualizer extends StatefulWidget {
  final bool isEnglish;

  const FirstLastPositionVisualizer({super.key, required this.isEnglish});

  @override
  State<FirstLastPositionVisualizer> createState() => _FirstLastPositionVisualizerState();
}

class _FirstLastPositionVisualizerState extends State<FirstLastPositionVisualizer> {
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  final List<String> _codeLines = const [
    "int findFirst(vector<int>& nums, int target) {",
    "    int low = 0, high = nums.size() - 1, ans = -1;",
    "    while (low <= high) {",
    "        int mid = low + (high - low) / 2;",
    "        if (nums[mid] == target) { ans = mid; high = mid - 1; } // Squeeze Left",
    "        else if (nums[mid] < target) low = mid + 1;",
    "        else high = mid - 1;",
    "    }",
    "    return ans;",
    "}",
  ];

  final List<SearchStep> _steps = const [
    SearchStep(
      low: 0,
      mid: 2,
      high: 5,
      activeLineIndex: 3,
      arrayState: [5, 7, 7, 8, 8, 10],
      target: 8,
      explanationEn: "Line 4: Array = [5, 7, 7, 8, 8, 10], Target = 8. mid = 2 (val 7 < 8).",
      explanationBn: "লাইন ৪: mid = 2 (মান 7 < 8)।",
    ),
    SearchStep(
      low: 3,
      mid: 4,
      high: 5,
      activeLineIndex: 4,
      arrayState: [5, 7, 7, 8, 8, 10],
      target: 8,
      explanationEn: "Line 5: nums[4] = 8 == Target. Save ans = 4, continue searching left (high = 3) for First occurrence!",
      explanationBn: "লাইন ৫: nums[4] = 8 পাওয়া গেছে। ans = 4 সেভ করে ১ম ইনডেক্স খুঁজতে বামে গুটিয়ে আনুন।",
    ),
    SearchStep(
      low: 3,
      mid: 3,
      high: 3,
      activeLineIndex: 4,
      arrayState: [5, 7, 7, 8, 8, 10],
      target: 8,
      explanationEn: "🎉 Line 5: First occurrence of 8 FOUND at Index 3!",
      explanationBn: "🎉 লাইন ৫: টার্গেট 8 এর প্রথম উপস্থিতি ইনডেক্স 3 এ পাওয়া গেছে!",
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
            color: step.activeLineIndex == 4 ? AppTheme.accentGreen.withOpacity(0.15) : AppTheme.accentNeonCyan.withOpacity(0.15),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: step.activeLineIndex == 4 ? AppTheme.accentGreen : AppTheme.accentNeonCyan),
          ),
          child: Text(
            widget.isEnglish ? step.explanationEn : step.explanationBn,
            style: TextStyle(
              color: step.activeLineIndex == 4 ? AppTheme.accentGreen : AppTheme.accentNeonCyan,
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

  Widget _buildCanvas(SearchStep step) {
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
              Text("Target: [${step.target}]", style: const TextStyle(color: AppTheme.accentPink, fontWeight: FontWeight.bold, fontSize: 13)),
              Text("Boundary Position Result: [${step.activeLineIndex == 4 ? step.mid : 'None'}]", style: const TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(step.arrayState.length, (idx) {
                final isMid = idx == step.mid;
                final isLow = idx == step.low;
                final isHigh = idx == step.high;

                Color boxColor = AppTheme.surfaceDark;
                Color borderColor = const Color(0xFF334155);

                if (isMid) {
                  boxColor = AppTheme.accentAmber.withOpacity(0.3);
                  borderColor = AppTheme.accentAmber;
                } else if (idx >= step.low && idx <= step.high) {
                  boxColor = AppTheme.accentNeonCyan.withOpacity(0.12);
                  borderColor = AppTheme.accentNeonCyan.withOpacity(0.4);
                }

                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: Column(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: boxColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: borderColor, width: isMid ? 2 : 1),
                        ),
                        child: Text(
                          "${step.arrayState[idx]}",
                          style: TextStyle(
                            color: isMid ? AppTheme.accentAmber : Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text("[$idx]", style: const TextStyle(color: AppTheme.textMuted, fontSize: 10)),
                      if (isLow) const Text("LOW", style: TextStyle(color: AppTheme.accentNeonCyan, fontSize: 9, fontWeight: FontWeight.bold)),
                      if (isMid) const Text("MID", style: TextStyle(color: AppTheme.accentAmber, fontSize: 9, fontWeight: FontWeight.bold)),
                      if (isHigh) const Text("HIGH", style: TextStyle(color: AppTheme.accentPink, fontSize: 9, fontWeight: FontWeight.bold)),
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
