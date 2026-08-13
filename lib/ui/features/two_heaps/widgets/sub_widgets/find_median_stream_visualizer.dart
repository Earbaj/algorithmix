import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class HeapStep {
  final int activeNum;
  final int activeLineIndex;
  final List<int> maxHeapState; // Small half
  final List<int> minHeapState; // Large half
  final double currentMedian;
  final bool isBalanced;
  final String explanationEn;
  final String explanationBn;

  const HeapStep({
    required this.activeNum,
    required this.activeLineIndex,
    required this.maxHeapState,
    required this.minHeapState,
    required this.currentMedian,
    this.isBalanced = true,
    required this.explanationEn,
    required this.explanationBn,
  });
}

class FindMedianStreamVisualizer extends StatefulWidget {
  final bool isEnglish;

  const FindMedianStreamVisualizer({super.key, required this.isEnglish});

  @override
  State<FindMedianStreamVisualizer> createState() => _FindMedianStreamVisualizerState();
}

class _FindMedianStreamVisualizerState extends State<FindMedianStreamVisualizer> {
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  final List<String> _codeLines = const [
    "class MedianFinder {",
    "    priority_queue<int> maxHeap; // Small half",
    "    priority_queue<int, vector<int>, greater<int>> minHeap; // Large half",
    "public:",
    "    void addNum(int num) {",
    "        maxHeap.push(num);",
    "        minHeap.push(maxHeap.top()); maxHeap.pop(); // Balance step 1",
    "        if (minHeap.size() > maxHeap.size()) {",
    "            maxHeap.push(minHeap.top()); minHeap.pop(); // Balance step 2",
    "        }",
    "    }",
    "    double findMedian() {",
    "        if (maxHeap.size() > minHeap.size()) return maxHeap.top();",
    "        return (maxHeap.top() + minHeap.top()) / 2.0; // O(1) Query!",
    "    }",
    "};",
  ];

  final List<HeapStep> _steps = const [
    HeapStep(
      activeNum: 5,
      activeLineIndex: 5,
      maxHeapState: [5],
      minHeapState: [],
      currentMedian: 5.0,
      explanationEn: "Line 6: addNum(5): Push 5 to maxHeap. maxHeap = [5], minHeap = [].",
      explanationBn: "লাইন ৬: addNum(5): maxHeap এ 5 যোগ। maxHeap = [5], minHeap = []।",
    ),
    HeapStep(
      activeNum: 5,
      activeLineIndex: 12,
      maxHeapState: [5],
      minHeapState: [],
      currentMedian: 5.0,
      explanationEn: "Line 13: findMedian(): maxHeap size (1) > minHeap (0). Median = 5.0!",
      explanationBn: "লাইন ১৩: findMedian(): maxHeap সাইজ (১) > minHeap (০)। মিডিয়ান = 5.0!",
    ),
    HeapStep(
      activeNum: 15,
      activeLineIndex: 6,
      maxHeapState: [5],
      minHeapState: [15],
      currentMedian: 10.0,
      isBalanced: false,
      explanationEn: "Line 7: addNum(15): Moved 15 to minHeap. maxHeap = [5], minHeap = [15].",
      explanationBn: "লাইন ৭: addNum(15): minHeap এ 15 স্থানান্তরিত। maxHeap = [5], minHeap = [15]।",
    ),
    HeapStep(
      activeNum: 15,
      activeLineIndex: 13,
      maxHeapState: [5],
      minHeapState: [15],
      currentMedian: 10.0,
      explanationEn: "Line 14: findMedian(): Equal sizes (1, 1). Median = (5 + 15) / 2.0 = 10.0!",
      explanationBn: "লাইন ১৪: findMedian(): সমান সাইজ (১, ১)। মিডিয়ান = (5 + 15) / 2.0 = 10.0!",
    ),
    HeapStep(
      activeNum: 1,
      activeLineIndex: 8,
      maxHeapState: [5, 1],
      minHeapState: [15],
      currentMedian: 5.0,
      explanationEn: "Line 9: addNum(1): Rebalanced maxHeap size to 2. maxHeap = [5, 1], minHeap = [15].",
      explanationBn: "লাইন ৯: addNum(1): maxHeap সাইজ ২ এ রিব্যালেন্সড। maxHeap = [5, 1], minHeap = [15]।",
    ),
    HeapStep(
      activeNum: 1,
      activeLineIndex: 12,
      maxHeapState: [5, 1],
      minHeapState: [15],
      currentMedian: 5.0,
      explanationEn: "Line 13: findMedian(): maxHeap size (2) > minHeap (1). Median = maxHeap.top() = 5.0!",
      explanationBn: "লাইন ১৩: findMedian(): maxHeap সাইজ (২) > minHeap (১)। মিডিয়ান = 5.0!",
    ),
    HeapStep(
      activeNum: 3,
      activeLineIndex: 8,
      maxHeapState: [3, 1],
      minHeapState: [5, 15],
      currentMedian: 4.0,
      explanationEn: "Line 9: addNum(3): Rebalanced! maxHeap = [3, 1], minHeap = [5, 15].",
      explanationBn: "লাইন ৯: addNum(3): রিব্যালেন্সড! maxHeap = [3, 1], minHeap = [5, 15]।",
    ),
    HeapStep(
      activeNum: 3,
      activeLineIndex: 13,
      maxHeapState: [3, 1],
      minHeapState: [5, 15],
      currentMedian: 4.0,
      explanationEn: "🎉 Line 14: findMedian(): Equal sizes (2, 2). Median = (3 + 5) / 2.0 = 4.0!",
      explanationBn: "🎉 লাইন ১৪: findMedian(): সমান সাইজ (২, ২)। মিডিয়ান = (3 + 5) / 2.0 = 4.0!",
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
            color: step.activeLineIndex == 13 ? AppTheme.accentGreen.withOpacity(0.15) : AppTheme.accentNeonCyan.withOpacity(0.15),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: step.activeLineIndex == 13 ? AppTheme.accentGreen : AppTheme.accentNeonCyan),
          ),
          child: Text(
            widget.isEnglish ? step.explanationEn : step.explanationBn,
            style: TextStyle(
              color: step.activeLineIndex == 13 ? AppTheme.accentGreen : AppTheme.accentNeonCyan,
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
              Text("Active Stream Num: [${step.activeNum}]", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13)),
              Text("O(1) Calculated Median: [${step.currentMedian}]", style: const TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 16),

          // Dual Heap Visual Containers
          Row(
            children: [
              // Max-Heap Container (Smaller Half)
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
                      const Text("Max-Heap (Smaller Half)", style: TextStyle(color: AppTheme.accentPurple, fontWeight: FontWeight.bold, fontSize: 12)),
                      const SizedBox(height: 8),
                      step.maxHeapState.isEmpty
                          ? const Text("Empty", style: TextStyle(color: AppTheme.textMuted, fontSize: 11))
                          : Wrap(
                              spacing: 6,
                              children: step.maxHeapState.map((val) => CircleAvatar(radius: 16, backgroundColor: AppTheme.accentPurple, child: Text("$val", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)))).toList(),
                            ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Min-Heap Container (Larger Half)
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
                      const Text("Min-Heap (Larger Half)", style: TextStyle(color: AppTheme.accentPink, fontWeight: FontWeight.bold, fontSize: 12)),
                      const SizedBox(height: 8),
                      step.minHeapState.isEmpty
                          ? const Text("Empty", style: TextStyle(color: AppTheme.textMuted, fontSize: 11))
                          : Wrap(
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
