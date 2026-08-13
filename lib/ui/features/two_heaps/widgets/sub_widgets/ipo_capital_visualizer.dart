import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import 'find_median_stream_visualizer.dart';

class IpoCapitalVisualizer extends StatefulWidget {
  final bool isEnglish;

  const IpoCapitalVisualizer({super.key, required this.isEnglish});

  @override
  State<IpoCapitalVisualizer> createState() => _IpoCapitalVisualizerState();
}

class _IpoCapitalVisualizerState extends State<IpoCapitalVisualizer> {
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  final List<String> _codeLines = const [
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
  ];

  final List<HeapStep> _steps = const [
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
            color: step.activeLineIndex == 9 ? AppTheme.accentGreen.withOpacity(0.15) : AppTheme.accentNeonCyan.withOpacity(0.15),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: step.activeLineIndex == 9 ? AppTheme.accentGreen : AppTheme.accentNeonCyan),
          ),
          child: Text(
            widget.isEnglish ? step.explanationEn : step.explanationBn,
            style: TextStyle(
              color: step.activeLineIndex == 9 ? AppTheme.accentGreen : AppTheme.accentNeonCyan,
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
              const Text("IPO Investment Status", style: TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13)),
              Text("Accumulated Capital w: [${step.activeLineIndex == 9 ? '22' : '2'}]", style: const TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 13)),
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
                      const Text("Affordable Profits Max-Heap", style: TextStyle(color: AppTheme.accentPurple, fontWeight: FontWeight.bold, fontSize: 12)),
                      const SizedBox(height: 8),
                      step.maxHeapState.isEmpty
                          ? const Text("Empty", style: TextStyle(color: AppTheme.textMuted, fontSize: 11))
                          : Wrap(
                              spacing: 6,
                              children: step.maxHeapState.map((val) => CircleAvatar(radius: 16, backgroundColor: AppTheme.accentPurple, child: Text("\$$val", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)))).toList(),
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
                      const Text("Capital Required Min-Heap", style: TextStyle(color: AppTheme.accentPink, fontWeight: FontWeight.bold, fontSize: 12)),
                      const SizedBox(height: 8),
                      step.minHeapState.isEmpty
                          ? const Text("Empty", style: TextStyle(color: AppTheme.textMuted, fontSize: 11))
                          : Wrap(
                              spacing: 6,
                              children: step.minHeapState.map((val) => CircleAvatar(radius: 16, backgroundColor: AppTheme.accentPink, child: Text("$val", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)))).toList(),
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
