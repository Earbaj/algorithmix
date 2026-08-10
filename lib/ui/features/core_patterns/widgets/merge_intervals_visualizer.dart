import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class IntervalStep {
  final int activeLineIndex;
  final List<int> currentInterval;
  final List<List<int>> mergedResult;
  final bool isMerging;
  final String explanationEn;
  final String explanationBn;

  const IntervalStep({
    required this.activeLineIndex,
    required this.currentInterval,
    required this.mergedResult,
    this.isMerging = false,
    required this.explanationEn,
    required this.explanationBn,
  });
}

class MergeIntervalsVisualizer extends StatefulWidget {
  final bool isEnglish;

  const MergeIntervalsVisualizer({super.key, required this.isEnglish});

  @override
  State<MergeIntervalsVisualizer> createState() => _MergeIntervalsVisualizerState();
}

class _MergeIntervalsVisualizerState extends State<MergeIntervalsVisualizer> {
  int _selectedTemplateIndex = 0;
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  final List<List<String>> _codeTemplates = const [
    // Template 1: Merge Overlapping Intervals
    [
      "vector<vector<int>> merge(vector<vector<int>>& intervals) {",
      "    sort(intervals.begin(), intervals.end()); // Step 1: Sort by start",
      "    vector<vector<int>> res = {intervals[0]};",
      "    for (int i = 1; i < intervals.size(); i++) {",
      "        if (intervals[i][0] <= res.back()[1]) { // OVERLAP!",
      "            res.back()[1] = max(res.back()[1], intervals[i][1]);",
      "        } else {",
      "            res.push_back(intervals[i]); // NO OVERLAP",
      "        }",
      "    }",
      "    return res;",
      "}",
    ],
    // Template 2: Insert Interval (3-Phase Pattern)
    [
      "vector<vector<int>> insert(vector<vector<int>>& intervals, vector<int>& newInterval) {",
      "    vector<vector<int>> res; int i = 0, n = intervals.size();",
      "    // Phase 1: Add intervals ending before newInterval",
      "    while (i < n && intervals[i][1] < newInterval[0]) res.push_back(intervals[i++]);",
      "    // Phase 2: Merge overlapping intervals",
      "    while (i < n && intervals[i][0] <= newInterval[1]) {",
      "        newInterval[0] = min(newInterval[0], intervals[i][0]);",
      "        newInterval[1] = max(newInterval[1], intervals[i][1]);",
      "        i++;",
      "    }",
      "    res.push_back(newInterval);",
      "    // Phase 3: Add remaining intervals",
      "    while (i < n) res.push_back(intervals[i++]);",
      "    return res;",
      "}",
    ],
    // Template 3: Interval List Intersections
    [
      "vector<vector<int>> intervalIntersection(vector<vector<int>>& A, vector<vector<int>>& B) {",
      "    vector<vector<int>> res; int i = 0, j = 0;",
      "    while (i < A.size() && j < B.size()) {",
      "        int start = max(A[i][0], B[j][0]), end = min(A[i][1], B[j][1]);",
      "        if (start <= end) res.push_back({start, end}); // Valid Intersection!",
      "        if (A[i][1] < B[j][1]) i++; else j++;",
      "    }",
      "    return res;",
      "}",
    ],
  ];

  final List<IntervalStep> _template1Steps = const [
    IntervalStep(
      activeLineIndex: 1,
      currentInterval: [1, 3],
      mergedResult: [],
      explanationEn: "Line 2: Input intervals = [[1, 3], [2, 6], [8, 10], [15, 18]]. Sorted by start time.",
      explanationBn: "লাইন ২: ইনপুট ইন্টারভাল = [[1, 3], [2, 6], [8, 10], [15, 18]]। স্টার্ট টাইম দিয়ে সর্ট করা হয়েছে।",
    ),
    IntervalStep(
      activeLineIndex: 2,
      currentInterval: [1, 3],
      mergedResult: [[1, 3]],
      explanationEn: "Line 3: Push first interval [1, 3] to merged result. Result = [[1, 3]].",
      explanationBn: "লাইন ৩: ১ম ইন্টারভাল [1, 3] রেজাল্টে যুক্ত করা হলো। রেজাল্ট = [[1, 3]]।",
    ),
    IntervalStep(
      activeLineIndex: 4,
      currentInterval: [2, 6],
      mergedResult: [[1, 3]],
      isMerging: true,
      explanationEn: "Line 5: Check interval [2, 6]: 2 <= 3 -> OVERLAP DETECTED with [1, 3]!",
      explanationBn: "লাইন ৫: ইন্টারভাল [2, 6] চেক: 2 <= 3 -> [1, 3] এর সাথে ওভারল্যাপ শনাক্ত করা হয়েছে!",
    ),
    IntervalStep(
      activeLineIndex: 5,
      currentInterval: [2, 6],
      mergedResult: [[1, 6]],
      isMerging: true,
      explanationEn: "Line 6: Execute Merge! res.back()[1] = max(3, 6) = 6. Merged Interval = [1, 6]!",
      explanationBn: "লাইন ৬: মার্জ সম্পাদন! res.back()[1] = max(3, 6) = 6। নতুন মার্জড ইন্টারভাল = [1, 6]!",
    ),
    IntervalStep(
      activeLineIndex: 7,
      currentInterval: [8, 10],
      mergedResult: [[1, 6], [8, 10]],
      explanationEn: "Line 8: Check interval [8, 10]: 8 > 6 -> NO OVERLAP. Append [8, 10]. Result = [[1, 6], [8, 10]].",
      explanationBn: "লাইন ৮: ইন্টারভাল [8, 10] চেক: 8 > 6 -> কোনো ওভারল্যাপ নেই। [8, 10] সরাসরি যোগ করা হলো।",
    ),
    IntervalStep(
      activeLineIndex: 7,
      currentInterval: [15, 18],
      mergedResult: [[1, 6], [8, 10], [15, 18]],
      explanationEn: "Line 8: Check interval [15, 18]: 15 > 10 -> NO OVERLAP. Append [15, 18].",
      explanationBn: "লাইন ৮: ইন্টারভাল [15, 18] চেক: 15 > 10 -> কোনো ওভারল্যাপ নেই। [15, 18] যোগ করা হলো।",
    ),
    IntervalStep(
      activeLineIndex: 10,
      currentInterval: [15, 18],
      mergedResult: [[1, 6], [8, 10], [15, 18]],
      explanationEn: "🎉 Line 11: Merge Intervals Complete! Return [[1, 6], [8, 10], [15, 18]]!",
      explanationBn: "🎉 লাইন ১১: ইন্টারভাল মার্জ সম্পন্ন! রেজাল্ট = [[1, 6], [8, 10], [15, 18]]!",
    ),
  ];

  final List<IntervalStep> _template2Steps = const [
    IntervalStep(
      activeLineIndex: 2,
      currentInterval: [1, 2],
      mergedResult: [[1, 2]],
      explanationEn: "Line 3: Phase 1: Interval [1, 2] ends before newInterval [4, 8] -> Append [1, 2].",
      explanationBn: "লাইন ৩: ১ম ধাপ: [1, 2] newInterval [4, 8] এর আগে শেষ হয়েছে -> [1, 2] যোগ।",
    ),
    IntervalStep(
      activeLineIndex: 6,
      currentInterval: [4, 8],
      mergedResult: [[1, 2], [3, 10]],
      isMerging: true,
      explanationEn: "Line 7: Phase 2: Overlapping intervals merged with [4, 8] -> Expanded to [3, 10]!",
      explanationBn: "লাইন ৭: ২য় ধাপ: ওভারল্যাপিং ইন্টারভাল মার্জ হয়ে [3, 10] তৈরি হলো!",
    ),
    IntervalStep(
      activeLineIndex: 11,
      currentInterval: [12, 16],
      mergedResult: [[1, 2], [3, 10], [12, 16]],
      explanationEn: "🎉 Line 12: Phase 3: Added remaining non-overlapping intervals! Complete!",
      explanationBn: "🎉 লাইন ১২: ৩য় ধাপ: ডানের সব নন-ওভারল্যাপিং ইন্টারভাল যুক্ত সম্পন্ন!",
    ),
  ];

  final List<IntervalStep> _template3Steps = const [
    IntervalStep(
      activeLineIndex: 3,
      currentInterval: [0, 2],
      mergedResult: [[1, 2]],
      isMerging: true,
      explanationEn: "Line 4: A = [0, 2], B = [1, 5] -> Overlap [max(0, 1), min(2, 5)] = [1, 2]!",
      explanationBn: "লাইন ৪: A = [0, 2], B = [1, 5] -> ছেদাংশ [max(0, 1), min(2, 5)] = [1, 2]!",
    ),
    IntervalStep(
      activeLineIndex: 4,
      currentInterval: [5, 10],
      mergedResult: [[1, 2], [5, 5]],
      isMerging: true,
      explanationEn: "🎉 Line 5: A = [5, 10], B = [1, 5] -> Intersection = [5, 5]! Advanced pointer A!",
      explanationBn: "🎉 লাইন ৫: A = [5, 10], B = [1, 5] -> ছেদাংশ = [5, 5]! পয়েন্টার আগানো সম্পন্ন!",
    ),
  ];

  List<IntervalStep> get _currentSteps {
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
              _buildTemplateChip(0, widget.isEnglish ? "Merge Intervals" : "ইন্টারভাল মার্জ"),
              _buildTemplateChip(1, widget.isEnglish ? "Insert Interval" : "ইনসার্ট ইন্টারভাল"),
              _buildTemplateChip(2, widget.isEnglish ? "Interval Intersections" : "ইন্টারভাল ছেদাংশ"),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Status Log Banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: step.isMerging ? AppTheme.accentGreen.withOpacity(0.15) : AppTheme.accentPurple.withOpacity(0.15),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: step.isMerging ? AppTheme.accentGreen : AppTheme.accentPurple),
          ),
          child: Text(
            widget.isEnglish ? step.explanationEn : step.explanationBn,
            style: TextStyle(
              color: step.isMerging ? AppTheme.accentGreen : AppTheme.accentNeonCyan,
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
              _buildIntervalCanvas(step),
            ],
          )
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildCodeSnippetWithHighlight(_currentCodeLines, step.activeLineIndex)),
              const SizedBox(width: 16),
              Expanded(child: _buildIntervalCanvas(step)),
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

  Widget _buildIntervalCanvas(IntervalStep step) {
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
              Text(
                "Active Candidate: [${step.currentInterval[0]}, ${step.currentInterval[1]}]",
                style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13),
              ),
              if (step.isMerging)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.accentGreen.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.accentGreen),
                  ),
                  child: const Text("MERGING OVERLAP", style: TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 10)),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Merged Result Intervals Collector Bar
          const Text("Merged Interval Result List:", style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.accentPurple.withOpacity(0.5)),
            ),
            child: step.mergedResult.isEmpty
                ? Text(widget.isEnglish ? "[ Result List Empty ]" : "[ রেজাল্ট খালি ]", style: const TextStyle(color: AppTheme.textMuted, fontSize: 13))
                : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: step.mergedResult.map((interval) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppTheme.accentPurple,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                        child: Text(
                          "[${interval[0]}, ${interval[1]}]",
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      );
                    }).toList(),
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
