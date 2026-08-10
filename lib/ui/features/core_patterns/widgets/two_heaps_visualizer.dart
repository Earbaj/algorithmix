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

class TwoHeapsVisualizer extends StatefulWidget {
  final bool isEnglish;

  const TwoHeapsVisualizer({super.key, required this.isEnglish});

  @override
  State<TwoHeapsVisualizer> createState() => _TwoHeapsVisualizerState();
}

class _TwoHeapsVisualizerState extends State<TwoHeapsVisualizer> {
  int _selectedTemplateIndex = 0;
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  final List<List<String>> _codeTemplates = const [
    // Template 1: Find Median from Data Stream
    [
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
    ],
    // Template 2: IPO / Maximize Capital
    [
      "int findMaximizedCapital(int k, int w, vector<int>& profits, vector<int>& capital) {",
      "    priority_queue<pair<int,int>, vector<pair<int,int>>, greater<pair<int,int>>> minCap;",
      "    priority_queue<int> maxProfit;",
      "    for (int i = 0; i < n; i++) minCap.push({capital[i], profits[i]});",
      "    for (int i = 0; i < k; i++) {",
      "        while (!minCap.empty() && minCap.top().first <= w) {",
      "            maxProfit.push(minCap.top().second); minCap.pop();",
      "        }",
      "        if (maxProfit.empty()) break;",
      "        w += maxProfit.top(); maxProfit.pop(); // Pick max profit!",
      "    }",
      "    return w;",
      "}",
    ],
    // Template 3: Sliding Window Median
    [
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
    ],
  ];

  final List<HeapStep> _template1Steps = const [
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

  final List<HeapStep> _template2Steps = const [
    HeapStep(
      activeNum: 0,
      activeLineIndex: 3,
      maxHeapState: [],
      minHeapState: [1, 2, 3],
      currentMedian: 0.0,
      explanationEn: "Line 4: IPO: Min-Heap minCap populated with capital required = [1, 2, 3].",
      explanationBn: "লাইন ৪: IPO: Min-Heap এ ক্যাপিটালের চাহিদা [1, 2, 3] পুশ করা হলো।",
    ),
    HeapStep(
      activeNum: 1,
      activeLineIndex: 6,
      maxHeapState: [10, 20],
      minHeapState: [3],
      currentMedian: 20.0,
      explanationEn: "Line 7: Current Capital w = 2: Push affordable project profits to maxProfit Max-Heap = [20, 10].",
      explanationBn: "লাইন ৭: বর্তমান মূলধন w = 2: সামর্থ্যের ভেতর থাকা প্রফিট [20, 10] Max-Heap এ নেওয়া হলো।",
    ),
    HeapStep(
      activeNum: 1,
      activeLineIndex: 9,
      maxHeapState: [10],
      minHeapState: [],
      currentMedian: 20.0,
      explanationEn: "🎉 Line 10: Pick max profit 20! New Capital w = 2 + 20 = 22!",
      explanationBn: "🎉 লাইন ১০: সর্বোচ্চ প্রফিট 20 নির্বাচন! নতুন মূলধন w = 2 + 20 = 22!",
    ),
  ];

  final List<HeapStep> _template3Steps = const [
    HeapStep(
      activeNum: 1,
      activeLineIndex: 3,
      maxHeapState: [1],
      minHeapState: [3],
      currentMedian: 2.0,
      explanationEn: "Line 4: Sliding Window (k=2): Dual heaps small = [1], large = [3].",
      explanationBn: "লাইন ৪: স্লাইডিং উইন্ডো (k=2): হিপ সেট small = [1], large = [3]।",
    ),
    HeapStep(
      activeNum: 1,
      activeLineIndex: 9,
      maxHeapState: [1],
      minHeapState: [3],
      currentMedian: 2.0,
      explanationEn: "🎉 Line 10: Window Median = (1 + 3) / 2.0 = 2.0!",
      explanationBn: "🎉 লাইন ১০: উইন্ডো মিডিয়ান = (1 + 3) / 2.0 = 2.0!",
    ),
  ];

  List<HeapStep> get _currentSteps {
    if (_selectedTemplateIndex == 1) return _template2Steps;
    if (_selectedTemplateIndex == 2) return _template3Steps;
    return _template1Steps;
  }

  List<String> get _currentCodeLines {
    return _codeTemplates[_selectedTemplateIndex];
  }

  void _togglePlay() {
    setState(() => _isPlaying = !_isPlaying);
    if (_isPlaying) {
      _timer = Timer.periodic(const Duration(milliseconds: 1400), (timer) {
        if (_currentStepIndex < _currentSteps.length - 1) {
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
    if (_currentStepIndex < _currentSteps.length - 1) {
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
    final step = _currentSteps[_currentStepIndex];
    final isMobile = Responsive.isMobile(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Template Selector Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildTemplateChip(0, widget.isEnglish ? "Find Median Data Stream" : "ডাটা স্ট্রিম মিডিয়ান"),
              _buildTemplateChip(1, widget.isEnglish ? "IPO / Maximize Capital" : "IPO ক্যাপিটাল ম্যাক্সিমাইজ"),
              _buildTemplateChip(2, widget.isEnglish ? "Sliding Window Median" : "স্লাইডিং উইন্ডো মিডিয়ান"),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Status Log Banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: step.isBalanced ? AppTheme.accentPurple.withOpacity(0.15) : AppTheme.accentAmber.withOpacity(0.15),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: step.isBalanced ? AppTheme.accentPurple : AppTheme.accentAmber),
          ),
          child: Text(
            widget.isEnglish ? step.explanationEn : step.explanationBn,
            style: TextStyle(
              color: step.isBalanced ? AppTheme.accentNeonCyan : AppTheme.accentAmber,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Code Snippet + Visualizer Box Layout
        if (isMobile)
          Column(
            children: [
              _buildCodeSnippetWithHighlight(_currentCodeLines, step.activeLineIndex),
              const SizedBox(height: 16),
              _buildDualHeapCanvas(step),
            ],
          )
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildCodeSnippetWithHighlight(_currentCodeLines, step.activeLineIndex)),
              const SizedBox(width: 16),
              Expanded(child: _buildDualHeapCanvas(step)),
            ],
          ),

        const SizedBox(height: 20),

        // Controls Bar
        _buildControlBar(),
      ],
    );
  }

  Widget _buildTemplateChip(int index, String label) {
    final isSelected = _selectedTemplateIndex == index;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        selectedColor: AppTheme.accentPurple,
        backgroundColor: AppTheme.surfaceDark,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : AppTheme.textSecondary,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        onSelected: (selected) {
          if (selected) {
            _timer?.cancel();
            setState(() {
              _selectedTemplateIndex = index;
              _currentStepIndex = 0;
              _isPlaying = false;
            });
          }
        },
      ),
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

  Widget _buildDualHeapCanvas(HeapStep step) {
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
              Text("O(1) Current Median: [${step.currentMedian}]", style: const TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 13)),
              Text("Active Num: [${step.activeNum}]", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 16),

          // Two Heaps Side-by-Side Canvas
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Max Heap (Smaller Half)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceDark,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.accentPink.withOpacity(0.5)),
                  ),
                  child: Column(
                    children: [
                      const Text("Max-Heap (Small Half)", style: TextStyle(color: AppTheme.accentPink, fontWeight: FontWeight.bold, fontSize: 11)),
                      const SizedBox(height: 8),
                      step.maxHeapState.isEmpty
                          ? const Text("[ Empty ]", style: TextStyle(color: AppTheme.textMuted, fontSize: 11))
                          : Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: step.maxHeapState.map((v) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(color: AppTheme.accentPink, borderRadius: BorderRadius.circular(6)),
                                  child: Text("$v", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                                );
                              }).toList(),
                            ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Min Heap (Larger Half)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceDark,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.accentNeonCyan.withOpacity(0.5)),
                  ),
                  child: Column(
                    children: [
                      const Text("Min-Heap (Large Half)", style: TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 11)),
                      const SizedBox(height: 8),
                      step.minHeapState.isEmpty
                          ? const Text("[ Empty ]", style: TextStyle(color: AppTheme.textMuted, fontSize: 11))
                          : Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: step.minHeapState.map((v) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(color: AppTheme.accentNeonCyan, borderRadius: BorderRadius.circular(6)),
                                  child: Text("$v", style: const TextStyle(color: AppTheme.primaryDark, fontWeight: FontWeight.bold, fontSize: 11)),
                                );
                              }).toList(),
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
                onPressed: _currentStepIndex < _currentSteps.length - 1 ? _nextStep : null,
              ),
              IconButton(
                icon: const Icon(Icons.refresh, color: AppTheme.accentNeonCyan),
                onPressed: _reset,
              ),
            ],
          ),
          Text(
            widget.isEnglish
                ? "Step ${_currentStepIndex + 1} of ${_currentSteps.length}"
                : "ধাপ ${_currentStepIndex + 1} / ${_currentSteps.length}",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
