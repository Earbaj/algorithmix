import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class HeapElementStep {
  final int activeNum;
  final int activeLineIndex;
  final List<int> minHeapState; // Size K Min-Heap
  final int k;
  final int? evictedNum;
  final String explanationEn;
  final String explanationBn;

  const HeapElementStep({
    required this.activeNum,
    required this.activeLineIndex,
    required this.minHeapState,
    required this.k,
    this.evictedNum,
    required this.explanationEn,
    required this.explanationBn,
  });
}

class KthLargestElementVisualizer extends StatefulWidget {
  final bool isEnglish;

  const KthLargestElementVisualizer({super.key, required this.isEnglish});

  @override
  State<KthLargestElementVisualizer> createState() => _KthLargestElementVisualizerState();
}

class _KthLargestElementVisualizerState extends State<KthLargestElementVisualizer> {
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  final List<String> _codeLines = const [
    "int findKthLargest(vector<int>& nums, int k) {",
    "    priority_queue<int, vector<int>, greater<int>> minHeap; // Min-Heap of size K",
    "    for (int num : nums) {",
    "        minHeap.push(num);                          // Push current element",
    "        if (minHeap.size() > k) minHeap.pop();     // Evict smallest element!",
    "    }",
    "    return minHeap.top(); // Kth largest element found in O(N log K)!",
    "}",
  ];

  final List<HeapElementStep> _steps = const [
    HeapElementStep(
      activeNum: 3,
      activeLineIndex: 3,
      minHeapState: [3],
      k: 2,
      explanationEn: "Line 4: Process num = 3. minHeap.push(3) -> minHeap = [3]. size (1) <= k (2).",
      explanationBn: "লাইন ৪: num = 3 প্রক্রিয়াকরণ। minHeap এ 3 যোগ -> minHeap = [3]।",
    ),
    HeapElementStep(
      activeNum: 2,
      activeLineIndex: 3,
      minHeapState: [2, 3],
      k: 2,
      explanationEn: "Line 4: Process num = 2. minHeap.push(2) -> minHeap = [2, 3]. size (2) <= k (2).",
      explanationBn: "লাইন ৪: num = 2 প্রক্রিয়াকরণ। minHeap এ 2 যোগ -> minHeap = [2, 3]।",
    ),
    HeapElementStep(
      activeNum: 1,
      activeLineIndex: 4,
      minHeapState: [2, 3],
      k: 2,
      evictedNum: 1,
      explanationEn: "Line 5: Process num = 1. Pushed 1 -> size (3) > k (2). Evicted 1! minHeap = [2, 3].",
      explanationBn: "লাইন ৫: num = 1 যোগ -> সাইজ ৩ > ২। ক্ষুদ্রতম ১ পপ করা হলো! minHeap = [2, 3]।",
    ),
    HeapElementStep(
      activeNum: 5,
      activeLineIndex: 4,
      minHeapState: [3, 5],
      k: 2,
      evictedNum: 2,
      explanationEn: "Line 5: Process num = 5. Pushed 5 -> size (3) > k (2). Evicted smallest 2! minHeap = [3, 5].",
      explanationBn: "লাইন ৫: num = 5 যোগ -> সাইজ ৩ > ২। 2 পপ করা হলো! minHeap = [3, 5]।",
    ),
    HeapElementStep(
      activeNum: 6,
      activeLineIndex: 4,
      minHeapState: [5, 6],
      k: 2,
      evictedNum: 3,
      explanationEn: "Line 5: Process num = 6. Pushed 6 -> size (3) > k (2). Evicted smallest 3! minHeap = [5, 6].",
      explanationBn: "লাইন ৫: num = 6 যোগ -> সাইজ ৩ > ২। 3 পপ করা হলো! minHeap = [5, 6]।",
    ),
    HeapElementStep(
      activeNum: 6,
      activeLineIndex: 6,
      minHeapState: [5, 6],
      k: 2,
      explanationEn: "🎉 Line 7: Loop finished! Kth Largest Element = minHeap.top() = 5!",
      explanationBn: "🎉 লাইন ৭: লুপ শেষ! ২-তম বৃহত্তম সংখ্যা = minHeap.top() = 5!",
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
            color: step.activeLineIndex == 6 ? AppTheme.accentGreen.withOpacity(0.15) : AppTheme.accentNeonCyan.withOpacity(0.15),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: step.activeLineIndex == 6 ? AppTheme.accentGreen : AppTheme.accentNeonCyan),
          ),
          child: Text(
            widget.isEnglish ? step.explanationEn : step.explanationBn,
            style: TextStyle(
              color: step.activeLineIndex == 6 ? AppTheme.accentGreen : AppTheme.accentNeonCyan,
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

  Widget _buildCanvas(HeapElementStep step) {
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
              Text("Processing Num: [${step.activeNum}]", style: const TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 13)),
              Text("Min-Heap Size: ${step.minHeapState.length} / K=${step.k}", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 16),

          // Heap Container Visualizer
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.accentPurple.withOpacity(0.5)),
            ),
            child: Column(
              children: [
                const Text("⚡ Min-Heap (Size K = 2)", style: TextStyle(color: AppTheme.accentPurple, fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(step.minHeapState.length, (idx) {
                    final val = step.minHeapState[idx];
                    final isTop = idx == 0;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Column(
                        children: [
                          Container(
                            width: 46,
                            height: 46,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isTop ? AppTheme.accentNeonCyan.withOpacity(0.2) : AppTheme.accentPurple.withOpacity(0.2),
                              shape: BoxShape.circle,
                              border: Border.all(color: isTop ? AppTheme.accentNeonCyan : AppTheme.accentPurple, width: 2),
                            ),
                            child: Text(
                              "$val",
                              style: TextStyle(
                                color: isTop ? AppTheme.accentNeonCyan : Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(isTop ? "TOP (Min)" : "Root", style: TextStyle(color: isTop ? AppTheme.accentNeonCyan : AppTheme.textMuted, fontSize: 10, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),

          if (step.evictedNum != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.accentPink.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.accentPink.withOpacity(0.5)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.output, color: AppTheme.accentPink, size: 16),
                  const SizedBox(width: 8),
                  Text("Evicted Element: [${step.evictedNum}] (Exceeded Heap Size K=2)", style: const TextStyle(color: AppTheme.accentPink, fontWeight: FontWeight.bold, fontSize: 11)),
                ],
              ),
            ),
          ],
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
