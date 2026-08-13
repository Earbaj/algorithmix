import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class KWayStep {
  final int activeVal;
  final int activeLineIndex;
  final List<int> heapValues;
  final List<int> mergedOutput;
  final String explanationEn;
  final String explanationBn;

  const KWayStep({
    required this.activeVal,
    required this.activeLineIndex,
    required this.heapValues,
    required this.mergedOutput,
    required this.explanationEn,
    required this.explanationBn,
  });
}

class MergeKSortedListsVisualizer extends StatefulWidget {
  final bool isEnglish;

  const MergeKSortedListsVisualizer({super.key, required this.isEnglish});

  @override
  State<MergeKSortedListsVisualizer> createState() => _MergeKSortedListsVisualizerState();
}

class _MergeKSortedListsVisualizerState extends State<MergeKSortedListsVisualizer> {
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  final List<String> _codeLines = const [
    "struct compare { bool operator()(ListNode* a, ListNode* b) { return a->val > b->val; } };",
    "ListNode* mergeKLists(vector<ListNode*>& lists) {",
    "    priority_queue<ListNode*, vector<ListNode*>, compare> minHeap; // Size K",
    "    for (auto l : lists) if (l) minHeap.push(l); // Init 1st element of K lists",
    "    ListNode dummy(0), *tail = &dummy;",
    "    while (!minHeap.empty()) {",
    "        ListNode* top = minHeap.top(); minHeap.pop(); // Pop minimum node",
    "        tail->next = top; tail = tail->next;         // Append to merged result",
    "        if (top->next) minHeap.push(top->next);     // Push next node from list",
    "    }",
    "    return dummy.next;",
    "}",
  ];

  final List<KWayStep> _steps = const [
    KWayStep(
      activeVal: 1,
      activeLineIndex: 3,
      heapValues: [1, 1, 2],
      mergedOutput: [],
      explanationEn: "Line 4: Initialized Min-Heap with 1st element of K=3 lists: minHeap = [1, 1, 2].",
      explanationBn: "লাইন ৪: K=3 টি লিস্টের প্রথম উপাদান দিয়ে Min-Heap প্রারম্ভিককরণ: minHeap = [1, 1, 2]।",
    ),
    KWayStep(
      activeVal: 1,
      activeLineIndex: 6,
      heapValues: [1, 2, 4],
      mergedOutput: [1],
      explanationEn: "Line 7: Popped minimum 1! Appended to merged output = [1]. Pushed top->next (4).",
      explanationBn: "লাইন ৭: সর্বনিম্ন 1 পপ করা হলো! মার্জড আউটপুটে যোগ = [1]। পরবর্তী নোড 4 পুশ করা হলো।",
    ),
    KWayStep(
      activeVal: 1,
      activeLineIndex: 6,
      heapValues: [2, 3, 4],
      mergedOutput: [1, 1],
      explanationEn: "Line 7: Popped next minimum 1! Appended to merged output = [1, 1]. Pushed top->next (3).",
      explanationBn: "লাইন ৭: পরবর্তী সর্বনিম্ন 1 পপ! মার্জড আউটপুট = [1, 1]। পরবর্তী নোড 3 পুশ করা হলো।",
    ),
    KWayStep(
      activeVal: 2,
      activeLineIndex: 6,
      heapValues: [3, 4, 6],
      mergedOutput: [1, 1, 2],
      explanationEn: "Line 7: Popped minimum 2! Appended to merged output = [1, 1, 2]. Pushed 6.",
      explanationBn: "লাইন ৭: সর্বনিম্ন 2 পপ! মার্জড আউটপুট = [1, 1, 2]। 6 পুশ করা হলো।",
    ),
    KWayStep(
      activeVal: 3,
      activeLineIndex: 6,
      heapValues: [4, 5, 6],
      mergedOutput: [1, 1, 2, 3],
      explanationEn: "Line 7: Popped minimum 3! Appended to merged output = [1, 1, 2, 3]. Pushed 5.",
      explanationBn: "লাইন ৭: সর্বনিম্ন 3 পপ! মার্জড আউটপুট = [1, 1, 2, 3]। 5 পুশ করা হলো।",
    ),
    KWayStep(
      activeVal: 6,
      activeLineIndex: 10,
      heapValues: [],
      mergedOutput: [1, 1, 2, 3, 4, 4, 5, 6],
      explanationEn: "🎉 Line 11: All K lists merged in O(N log K) time! Final Output = [1, 1, 2, 3, 4, 4, 5, 6]!",
      explanationBn: "🎉 লাইন ১১: সবকটি K লিস্ট সফলভাবে মার্জ সম্পন্ন! চূড়ান্ত আউটপুট = [1, 1, 2, 3, 4, 4, 5, 6]!",
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
            color: step.activeLineIndex == 10 ? AppTheme.accentGreen.withOpacity(0.15) : AppTheme.accentNeonCyan.withOpacity(0.15),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: step.activeLineIndex == 10 ? AppTheme.accentGreen : AppTheme.accentNeonCyan),
          ),
          child: Text(
            widget.isEnglish ? step.explanationEn : step.explanationBn,
            style: TextStyle(
              color: step.activeLineIndex == 10 ? AppTheme.accentGreen : AppTheme.accentNeonCyan,
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

  Widget _buildCanvas(KWayStep step) {
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
              Text("Active Min Node: [${step.activeVal}]", style: const TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 13)),
              Text("Heap Size: ${step.heapValues.length}", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 16),

          // Min Heap Display
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.accentPurple.withOpacity(0.5)),
            ),
            child: Column(
              children: [
                const Text("⚡ Min-Heap (K Candidates)", style: TextStyle(color: AppTheme.accentPurple, fontWeight: FontWeight.bold, fontSize: 12)),
                const SizedBox(height: 10),
                if (step.heapValues.isEmpty)
                  const Text("Heap Empty!", style: TextStyle(color: AppTheme.textMuted, fontSize: 12))
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: step.heapValues.map((v) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppTheme.accentPurple.withOpacity(0.2),
                          shape: BoxShape.circle,
                          border: Border.all(color: AppTheme.accentPurple),
                        ),
                        child: Text("$v", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Merged Result Display
          Text("Merged Output List:", style: TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: step.mergedOutput.map((val) {
                return Container(
                  margin: const EdgeInsets.only(right: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppTheme.accentGreen.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.accentGreen),
                  ),
                  child: Text("$val", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
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
