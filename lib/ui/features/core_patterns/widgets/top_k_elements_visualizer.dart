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

class TopKElementsVisualizer extends StatefulWidget {
  final bool isEnglish;

  const TopKElementsVisualizer({super.key, required this.isEnglish});

  @override
  State<TopKElementsVisualizer> createState() => _TopKElementsVisualizerState();
}

class _TopKElementsVisualizerState extends State<TopKElementsVisualizer> {
  int _selectedTemplateIndex = 0;
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  final List<List<String>> _codeTemplates = const [
    // Template 1: Kth Largest Element
    [
      "int findKthLargest(vector<int>& nums, int k) {",
      "    priority_queue<int, vector<int>, greater<int>> minHeap; // Min-Heap of size K",
      "    for (int num : nums) {",
      "        minHeap.push(num);                          // Push current element",
      "        if (minHeap.size() > k) minHeap.pop();     // Evict smallest element!",
      "    }",
      "    return minHeap.top(); // Kth largest element found in O(N log K)!",
      "}",
    ],
    // Template 2: Top K Frequent Elements
    [
      "vector<int> topKFrequent(vector<int>& nums, int k) {",
      "    unordered_map<int, int> counts; for (int num : nums) counts[num]++;",
      "    priority_queue<pair<int,int>, vector<pair<int,int>>, greater<pair<int,int>>> minHeap;",
      "    for (auto& entry : counts) {",
      "        minHeap.push({entry.second, entry.first}); // {frequency, value}",
      "        if (minHeap.size() > k) minHeap.pop();",
      "    }",
      "    return res;",
      "}",
    ],
    // Template 3: K Closest Points to Origin
    [
      "vector<vector<int>> kClosest(vector<vector<int>>& points, int k) {",
      "    priority_queue<pair<int, int>> maxHeap; // {distance, index}",
      "    for (int i = 0; i < points.size(); i++) {",
      "        int dist = points[i][0]*points[i][0] + points[i][1]*points[i][1];",
      "        maxHeap.push({dist, i});",
      "        if (maxHeap.size() > k) maxHeap.pop(); // Evict farthest point!",
      "    }",
      "    return res;",
      "}",
    ],
  ];

  final List<HeapElementStep> _template1Steps = const [
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

  final List<HeapElementStep> _template2Steps = const [
    HeapElementStep(
      activeNum: 1,
      activeLineIndex: 4,
      minHeapState: [1, 2],
      k: 2,
      explanationEn: "Line 5: Top 2 Frequent elements populated in Min-Heap = [1, 2].",
      explanationBn: "লাইন ৫: সর্বোচ্চ ২ ফ্রিকোয়েন্সির মান Min-Heap এ যোগ = [1, 2] ।",
    ),
    HeapElementStep(
      activeNum: 1,
      activeLineIndex: 7,
      minHeapState: [1, 2],
      k: 2,
      explanationEn: "🎉 Line 8: Top 2 Frequent Elements = [1, 2]!",
      explanationBn: "🎉 লাইন ৮: টপ ২ ফ্রিকোয়েন্সির সংখ্যা = [1, 2]!",
    ),
  ];

  final List<HeapElementStep> _template3Steps = const [
    HeapElementStep(
      activeNum: 1,
      activeLineIndex: 5,
      minHeapState: [5, 8],
      k: 2,
      explanationEn: "Line 6: Distances calculated and populated into Heap.",
      explanationBn: "লাইন ৬: দূরত্ব মেপে হিপে পুশ করা হলো।",
    ),
    HeapElementStep(
      activeNum: 1,
      activeLineIndex: 7,
      minHeapState: [5, 8],
      k: 2,
      explanationEn: "🎉 Line 8: Top K Closest Points identified!",
      explanationBn: "🎉 লাইন ৮: নিকটতম K টি পয়েন্ট শনাক্ত সম্পন্ন!",
    ),
  ];

  List<HeapElementStep> get _currentSteps {
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
              _buildTemplateChip(0, widget.isEnglish ? "Kth Largest Element" : "K-তম বৃহত্তম সংখ্যা"),
              _buildTemplateChip(1, widget.isEnglish ? "Top K Frequent" : "টপ K ফ্রিকোয়েন্সি"),
              _buildTemplateChip(2, widget.isEnglish ? "K Closest Points" : "K টি নিকটতম পয়েন্ট"),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Status Log Banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.accentPurple.withOpacity(0.15),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.accentPurple),
          ),
          child: Text(
            widget.isEnglish ? step.explanationEn : step.explanationBn,
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
        const SizedBox(height: 16),

        // Code Snippet + Visualizer Box Layout
        if (isMobile)
          Column(
            children: [
              _buildCodeSnippetWithHighlight(_currentCodeLines, step.activeLineIndex),
              const SizedBox(height: 16),
              _buildHeapCanvas(step),
            ],
          )
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildCodeSnippetWithHighlight(_currentCodeLines, step.activeLineIndex)),
              const SizedBox(width: 16),
              Expanded(child: _buildHeapCanvas(step)),
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

  Widget _buildHeapCanvas(HeapElementStep step) {
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
              Text("Active Processing: [${step.activeNum}]", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13)),
              Text("Heap Limit K: [${step.k}]", style: const TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 16),

          // Min-Heap Visualization Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.accentGreen.withOpacity(0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Min-Heap State (Size ${step.minHeapState.length}/K):", style: const TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 12)),
                    if (step.evictedNum != null)
                      Text("Evicted: [${step.evictedNum}]", style: const TextStyle(color: AppTheme.accentPink, fontWeight: FontWeight.bold, fontSize: 11)),
                  ],
                ),
                const SizedBox(height: 10),
                step.minHeapState.isEmpty
                    ? const Text("[ Empty ]", style: TextStyle(color: AppTheme.textMuted, fontSize: 12))
                    : Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: step.minHeapState.map((val) {
                          final isTop = val == step.minHeapState.first;
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: isTop ? AppTheme.accentGreen : AppTheme.accentPurple,
                              borderRadius: BorderRadius.circular(10),
                              border: isTop ? Border.all(color: Colors.white, width: 2) : null,
                            ),
                            child: Text(
                              isTop ? "TOP: $val" : "$val",
                              style: TextStyle(
                                color: isTop ? AppTheme.primaryDark : Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
              ],
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
