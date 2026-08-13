import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class SearchStep {
  final int low;
  final int mid;
  final int high;
  final int activeLineIndex;
  final List<int> arrayState;
  final int target;
  final String explanationEn;
  final String explanationBn;

  const SearchStep({
    required this.low,
    required this.mid,
    required this.high,
    required this.activeLineIndex,
    required this.arrayState,
    required this.target,
    required this.explanationEn,
    required this.explanationBn,
  });
}

class RotatedArraySearchVisualizer extends StatefulWidget {
  final bool isEnglish;

  const RotatedArraySearchVisualizer({super.key, required this.isEnglish});

  @override
  State<RotatedArraySearchVisualizer> createState() => _RotatedArraySearchVisualizerState();
}

class _RotatedArraySearchVisualizerState extends State<RotatedArraySearchVisualizer> {
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  final List<String> _codeLines = const [
    "int search(vector<int>& nums, int target) {",
    "    int low = 0, high = nums.size() - 1;",
    "    while (low <= high) {",
    "        int mid = low + (high - low) / 2;",
    "        if (nums[mid] == target) return mid; // Found!",
    "        if (nums[low] <= nums[mid]) { // Left half is sorted",
    "            if (nums[low] <= target && target < nums[mid]) high = mid - 1;",
    "            else low = mid + 1;",
    "        } else { // Right half is sorted",
    "            if (nums[mid] < target && target <= nums[high]) low = mid + 1;",
    "            else high = mid - 1;",
    "        }",
    "    }",
    "    return -1;",
    "}",
  ];

  final List<SearchStep> _steps = const [
    SearchStep(
      low: 0,
      mid: 3,
      high: 6,
      activeLineIndex: 3,
      arrayState: [4, 5, 6, 7, 0, 1, 2],
      target: 0,
      explanationEn: "Line 4: Rotated Array = [4, 5, 6, 7, 0, 1, 2], Target = 0. low = 0 (4), high = 6 (2). mid = 3 (val 7).",
      explanationBn: "লাইন ৪: রোটেটেড অ্যারে = [4, 5, 6, 7, 0, 1, 2], টার্গেট = 0। low = 0, high = 6। mid = 3 (মান 7)।",
    ),
    SearchStep(
      low: 0,
      mid: 3,
      high: 6,
      activeLineIndex: 5,
      arrayState: [4, 5, 6, 7, 0, 1, 2],
      target: 0,
      explanationEn: "Line 6: Check nums[low] (4) <= nums[mid] (7) -> TRUE. Left half [4, 5, 6, 7] is sorted!",
      explanationBn: "লাইন ৬: শর্ত 4 <= 7 সত্য! বাম অর্ধেক [4, 5, 6, 7] সর্টেড।",
    ),
    SearchStep(
      low: 4,
      mid: 3,
      high: 6,
      activeLineIndex: 7,
      arrayState: [4, 5, 6, 7, 0, 1, 2],
      target: 0,
      explanationEn: "Line 8: Target 0 is NOT in [4..7]. Search right half! Set low = mid + 1 = 4.",
      explanationBn: "লাইন ৮: টার্গেট 0 বামের সীমানায় নেই। ডানের অর্ধে সার্চ করুন! low = 4 করা হলো।",
    ),
    SearchStep(
      low: 4,
      mid: 5,
      high: 6,
      activeLineIndex: 3,
      arrayState: [4, 5, 6, 7, 0, 1, 2],
      target: 0,
      explanationEn: "Line 4: low = 4 (0), high = 6 (2). Calculate mid = 4 + (6 - 4) / 2 = 5 (val 1).",
      explanationBn: "লাইন ৪: low = 4, high = 6। mid = 5 (মান 1)।",
    ),
    SearchStep(
      low: 4,
      mid: 4,
      high: 4,
      activeLineIndex: 4,
      arrayState: [4, 5, 6, 7, 0, 1, 2],
      target: 0,
      explanationEn: "🎉 Line 5: Target 0 FOUND at Index 4! Return 4!",
      explanationBn: "🎉 লাইন ৫: টার্গেট 0 ইনডেক্স 4 এ পাওয়া গেছে! রিটার্ন 4!",
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
              Text("Pointers: low=${step.low}, mid=${step.mid}, high=${step.high}", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
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
                final isTargetFound = step.activeLineIndex == 4 && isMid;

                Color boxColor = AppTheme.surfaceDark;
                Color borderColor = const Color(0xFF334155);

                if (isTargetFound) {
                  boxColor = AppTheme.accentGreen.withOpacity(0.3);
                  borderColor = AppTheme.accentGreen;
                } else if (isMid) {
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
                          border: Border.all(color: borderColor, width: (isMid || isTargetFound) ? 2 : 1),
                        ),
                        child: Text(
                          "${step.arrayState[idx]}",
                          style: TextStyle(
                            color: isTargetFound ? AppTheme.accentGreen : (isMid ? AppTheme.accentAmber : Colors.white),
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
