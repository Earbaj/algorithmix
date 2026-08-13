import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import 'find_median_stream_visualizer.dart';

class SlidingWindowMedianVisualizer extends StatefulWidget {
  final bool isEnglish;

  const SlidingWindowMedianVisualizer({super.key, required this.isEnglish});

  @override
  State<SlidingWindowMedianVisualizer> createState() => _SlidingWindowMedianVisualizerState();
}

class _SlidingWindowMedianVisualizerState extends State<SlidingWindowMedianVisualizer> {
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  final List<String> _codeLines = const [
    "vector<double> medianSlidingWindow(vector<int>& nums, int k) {",
    "    multiset<long long> small, large;",
    "    auto balance = [&]() {",
    "        while (small.size() > large.size() + 1) {",
    "            large.insert(*small.rbegin()); small.erase(prev(small.end()));",
    "        }",
    "        while (large.size() > small.size()) {",
    "            small.insert(*large.begin()); large.erase(large.begin());",
    "        }",
    "    };",
    "    // Maintain dual heap sets over sliding window of size k",
    "    return res;",
    "}",
  ];

  final List<HeapStep> _steps = const [
    HeapStep(
      activeNum: 1,
      activeLineIndex: 10,
      maxHeapState: [1, 3],
      minHeapState: [3],
      currentMedian: 3.0,
      explanationEn: "Line 11: Sliding Window K = 3 over [1, 3, -1]. Window Median = 1.0!",
      explanationBn: "লাইন ১১: স্লাইডিং উইন্ডো K = 3 ([1, 3, -1] এর ওপর)। উইন্ডো মিডিয়ান = 1.0!",
    ),
    HeapStep(
      activeNum: 2,
      activeLineIndex: 10,
      maxHeapState: [3, -1],
      minHeapState: [5],
      currentMedian: 3.0,
      explanationEn: "Line 11: Slide window to right -> [3, -1, 5]. Window Median = 3.0!",
      explanationBn: "লাইন ১১: স্লাইডিং উইন্ডো ডানে সরানো হলো -> [3, -1, 5]। মিডিয়ান = 3.0!",
    ),
    HeapStep(
      activeNum: 3,
      activeLineIndex: 11,
      maxHeapState: [-1, 3],
      minHeapState: [5, 3],
      currentMedian: 3.0,
      explanationEn: "🎉 Line 12: Window Median result array = [1.0, 3.0, ...]!",
      explanationBn: "🎉 লাইন ১২: স্লাইডিং উইন্ডো মিডিয়ান ফলাফল ভেক্টর = [1.0, 3.0, ...]!",
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
            color: step.activeLineIndex == 11 ? AppTheme.accentGreen.withOpacity(0.15) : AppTheme.accentNeonCyan.withOpacity(0.15),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: step.activeLineIndex == 11 ? AppTheme.accentGreen : AppTheme.accentNeonCyan),
          ),
          child: Text(
            widget.isEnglish ? step.explanationEn : step.explanationBn,
            style: TextStyle(
              color: step.activeLineIndex == 11 ? AppTheme.accentGreen : AppTheme.accentNeonCyan,
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
              _buildHeapCanvas(step),
            ],
          )
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildCodeSnippetWithHighlight(_codeLines, step.activeLineIndex)),
              const SizedBox(width: 16),
              Expanded(child: _buildHeapCanvas(step)),
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

  Widget _buildHeapCanvas(HeapStep step) {
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
              const Text("Sliding Window K = 3 Dual Multiset", style: TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13)),
              Text("Window Median: [${step.currentMedian}]", style: const TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.accentPurple.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.accentPurple),
                  ),
                  child: Column(
                    children: [
                      const Text("Small Half Set", style: TextStyle(color: AppTheme.accentPurple, fontWeight: FontWeight.bold, fontSize: 12)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        children: step.maxHeapState.map((val) => CircleAvatar(radius: 16, backgroundColor: AppTheme.accentPurple, child: Text("$val", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)))).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.accentPink.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.accentPink),
                  ),
                  child: Column(
                    children: [
                      const Text("Large Half Set", style: TextStyle(color: AppTheme.accentPink, fontWeight: FontWeight.bold, fontSize: 12)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        children: step.minHeapState.map((val) => CircleAvatar(radius: 16, backgroundColor: AppTheme.accentPink, child: Text("$val", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)))).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
