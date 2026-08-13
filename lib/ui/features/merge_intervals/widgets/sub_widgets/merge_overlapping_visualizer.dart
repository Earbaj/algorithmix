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

class MergeOverlappingVisualizer extends StatefulWidget {
  final bool isEnglish;

  const MergeOverlappingVisualizer({super.key, required this.isEnglish});

  @override
  State<MergeOverlappingVisualizer> createState() => _MergeOverlappingVisualizerState();
}

class _MergeOverlappingVisualizerState extends State<MergeOverlappingVisualizer> {
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  final List<String> _codeLines = const [
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
  ];

  final List<IntervalStep> _steps = const [
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
        // Status Log Banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: step.isMerging ? AppTheme.accentAmber.withOpacity(0.15) : AppTheme.accentNeonCyan.withOpacity(0.15),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: step.isMerging ? AppTheme.accentAmber : AppTheme.accentNeonCyan),
          ),
          child: Text(
            widget.isEnglish ? step.explanationEn : step.explanationBn,
            style: TextStyle(
              color: step.isMerging ? AppTheme.accentAmber : AppTheme.accentNeonCyan,
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
              _buildIntervalCanvas(step),
            ],
          )
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildCodeSnippetWithHighlight(_codeLines, step.activeLineIndex)),
              const SizedBox(width: 16),
              Expanded(child: _buildIntervalCanvas(step)),
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
          Text(
            widget.isEnglish ? "Current Interval: [${step.currentInterval.join(', ')}]" : "বর্তমান ইন্টারভাল: [${step.currentInterval.join(', ')}]",
            style: const TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 16),
          Text(
            widget.isEnglish ? "Merged Result List:" : "মার্জড ইন্টারভাল লিস্ট:",
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: step.mergedResult.map((interval) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.accentPurple.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.accentPurple),
                ),
                child: Text(
                  "[${interval[0]}, ${interval[1]}]",
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                ),
              );
            }).toList(),
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
