import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';

class ReverseSinglyLinkedListAnimatedVisualizer extends StatefulWidget {
  final bool isEnglish;

  const ReverseSinglyLinkedListAnimatedVisualizer({
    super.key,
    required this.isEnglish,
  });

  @override
  State<ReverseSinglyLinkedListAnimatedVisualizer> createState() =>
      _ReverseSinglyLinkedListAnimatedVisualizerState();
}

class LLStepData {
  final int prevVal; // -1 for null
  final int currVal; // -1 for null
  final int nextTempVal; // -1 for null
  final List<int> nodeValues;
  final Map<int, int?> reversedLinks; // nodeId -> targetNodeId (-1 for null)
  final String titleEn;
  final String titleBn;
  final String explanationEn;
  final String explanationBn;

  const LLStepData({
    required this.prevVal,
    required this.currVal,
    required this.nextTempVal,
    required this.nodeValues,
    required this.reversedLinks,
    required this.titleEn,
    required this.titleBn,
    required this.explanationEn,
    required this.explanationBn,
  });
}

class _ReverseSinglyLinkedListAnimatedVisualizerState
    extends State<ReverseSinglyLinkedListAnimatedVisualizer> {
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  late final List<LLStepData> _steps;

  @override
  void initState() {
    super.initState();
    _steps = const [
      LLStepData(
        prevVal: -1,
        currVal: 1,
        nextTempVal: -1,
        nodeValues: [1, 2, 3, 4],
        reversedLinks: {1: 2, 2: 3, 3: 4, 4: -1},
        titleEn: "1. Initialization",
        titleBn: "১. সূচনা (Initialization)",
        explanationEn: "Initialize prev = NULL, curr = Head (1). Pointer nextTemp is undefined.",
        explanationBn: "prev = NULL এবং curr = Head (1) সেট করি। nextTemp পয়েন্টার এখনো ডিফাইন হয়নি।",
      ),
      LLStepData(
        prevVal: -1,
        currVal: 1,
        nextTempVal: 2,
        nodeValues: [1, 2, 3, 4],
        reversedLinks: {1: 2, 2: 3, 3: 4, 4: -1},
        titleEn: "2. Save nextTemp = curr->next (2)",
        titleBn: "২. পরবর্তী নোড সেভ: nextTemp = curr->next (2)",
        explanationEn: "Store nextTemp = curr->next (Node 2) so we don't lose the remaining list chain.",
        explanationBn: "nextTemp = Node 2 সেভ করি যেন পরবর্তী লিংকগুলোর এড্রেস হারিয়ে না যায়।",
      ),
      LLStepData(
        prevVal: -1,
        currVal: 1,
        nextTempVal: 2,
        nodeValues: [1, 2, 3, 4],
        reversedLinks: {1: -1, 2: 3, 3: 4, 4: -1},
        titleEn: "3. Flip Link: curr->next = prev (NULL)",
        titleBn: "৩. লিংক রিভার্স: curr->next = prev (NULL)",
        explanationEn: "Flip current node's next pointer backwards to prev (NULL). Link reversed!",
        explanationBn: "Node 1 এর next পয়েন্টার ঘুরিয়ে পিছনের prev (NULL) এর দিকে পয়েন্ট করি।",
      ),
      LLStepData(
        prevVal: 1,
        currVal: 2,
        nextTempVal: 3,
        nodeValues: [1, 2, 3, 4],
        reversedLinks: {1: -1, 2: 1, 3: 4, 4: -1},
        titleEn: "4. Advance Pointers & Flip Node 2",
        titleBn: "৪. পয়েন্টার এগোনো ও Node 2 রিভার্স",
        explanationEn: "Advance prev = curr (1), curr = nextTemp (2). Save nextTemp = 3, flip Node 2 -> Node 1.",
        explanationBn: "prev = Node 1 এবং curr = Node 2 এগিয়ে নিই। Node 2 এর লিংক ঘুরিয়ে 1 এর দিকে দিই।",
      ),
      LLStepData(
        prevVal: 2,
        currVal: 3,
        nextTempVal: 4,
        nodeValues: [1, 2, 3, 4],
        reversedLinks: {1: -1, 2: 1, 3: 2, 4: -1},
        titleEn: "5. Advance Pointers & Flip Node 3",
        titleBn: "৫. পয়েন্টার এগোনো ও Node 3 রিভার্স",
        explanationEn: "Advance prev = 2, curr = 3. Save nextTemp = 4, flip Node 3 -> Node 2.",
        explanationBn: "prev = Node 2 এবং curr = Node 3 এগিয়ে নিই। Node 3 এর লিংক ঘুরিয়ে 2 এর দিকে দিই।",
      ),
      LLStepData(
        prevVal: 3,
        currVal: 4,
        nextTempVal: -1,
        nodeValues: [1, 2, 3, 4],
        reversedLinks: {1: -1, 2: 1, 3: 2, 4: 3},
        titleEn: "6. Advance Pointers & Flip Node 4",
        titleBn: "৬. পয়েন্টার এগোনো ও Node 4 রিভার্স",
        explanationEn: "Advance prev = 3, curr = 4. nextTemp = NULL. Flip Node 4 -> Node 3.",
        explanationBn: "prev = Node 3 এবং curr = Node 4। nextTemp = NULL। Node 4 এর লিংক ঘুরিয়ে 3 এর দিকে দিই।",
      ),
      LLStepData(
        prevVal: 4,
        currVal: -1,
        nextTempVal: -1,
        nodeValues: [1, 2, 3, 4],
        reversedLinks: {4: 3, 3: 2, 2: 1, 1: -1},
        titleEn: "7. Reversal Complete (New Head = prev) 🎉",
        titleBn: "৭. রিভার্সাল সম্পূর্ণ (নতুন হেড = prev) 🎉",
        explanationEn: "curr reaches NULL. Loop ends! Return prev (Node 4) as the new Head of reversed list [4 -> 3 -> 2 -> 1 -> NULL].",
        explanationBn: "curr = NULL হওয়াই লুপ শেষ! নতুন হেড prev (Node 4) রিটার্ন করা হলো [4 -> 3 -> 2 -> 1 -> NULL]।",
      ),
    ];
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _togglePlay() {
    setState(() => _isPlaying = !_isPlaying);
    if (_isPlaying) {
      _timer = Timer.periodic(const Duration(milliseconds: 1500), (timer) {
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
  Widget build(BuildContext context) {
    final step = _steps[_currentStepIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title & Description Banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.accentNeonCyan.withOpacity(0.12),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.accentNeonCyan.withOpacity(0.5)),
          ),
          child: Row(
            children: [
              const Icon(Icons.link, color: AppTheme.accentNeonCyan, size: 24),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.isEnglish ? step.titleEn : step.titleBn,
                      style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.isEnglish ? step.explanationEn : step.explanationBn,
                      style: const TextStyle(color: Colors.white, fontSize: 12, height: 1.3),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Visual Linked List Canvas
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF090D16),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF1E293B)),
          ),
          child: Column(
            children: [
              // Pointer Legend
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLegendItem("prev", AppTheme.accentAmber),
                  const SizedBox(width: 16),
                  _buildLegendItem("curr", AppTheme.accentNeonCyan),
                  const SizedBox(width: 16),
                  _buildLegendItem("nextTemp", AppTheme.accentPink),
                ],
              ),
              const SizedBox(height: 20),

              // Nodes Chain Canvas
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // NULL badge on left
                    _buildNullBadge("NULL"),
                    const Icon(Icons.arrow_left, color: AppTheme.textMuted),

                    ...List.generate(step.nodeValues.length, (idx) {
                      final val = step.nodeValues[idx];
                      final isPrev = step.prevVal == val;
                      final isCurr = step.currVal == val;
                      final isNextTemp = step.nextTempVal == val;
                      final targetVal = step.reversedLinks[val];

                      return Row(
                        children: [
                          // Node Box
                          Column(
                            children: [
                              // Pointer Badges Top
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (isPrev) _buildPointerBadge("prev", AppTheme.accentAmber),
                                  if (isCurr) _buildPointerBadge("curr", AppTheme.accentNeonCyan),
                                  if (isNextTemp) _buildPointerBadge("nextTemp", AppTheme.accentPink),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: isCurr
                                      ? AppTheme.accentNeonCyan.withOpacity(0.3)
                                      : (isPrev ? AppTheme.accentAmber.withOpacity(0.2) : const Color(0xFF1E293B)),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isCurr
                                        ? AppTheme.accentNeonCyan
                                        : (isPrev ? AppTheme.accentAmber : const Color(0xFF334155)),
                                    width: isCurr || isPrev ? 2 : 1,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "$val",
                                    style: TextStyle(
                                      color: isCurr ? AppTheme.accentNeonCyan : Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Node $val",
                                style: const TextStyle(color: AppTheme.textMuted, fontSize: 10),
                              ),
                            ],
                          ),
                          // Arrow Link
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Icon(
                              targetVal == -1 && val == 1
                                  ? Icons.close
                                  : (targetVal != null && targetVal < val ? Icons.arrow_back : Icons.arrow_forward),
                              color: targetVal != null && targetVal < val ? AppTheme.accentGreen : AppTheme.accentNeonCyan,
                              size: 20,
                            ),
                          ),
                        ],
                      );
                    }),

                    // NULL badge on right
                    _buildNullBadge("NULL"),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Text(
                widget.isEnglish
                    ? "In-Place Pointer Reversal: curr->next = prev"
                    : "ইন-প্লেস পয়েন্টার রিভার্সাল: curr->next = prev",
                style: const TextStyle(color: AppTheme.textMuted, fontSize: 11, fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        _buildControls(),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildPointerBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildNullBadge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Text(label, style: const TextStyle(color: AppTheme.textMuted, fontWeight: FontWeight.bold, fontSize: 11)),
    );
  }

  Widget _buildControls() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.replay, color: Colors.white70),
            onPressed: _reset,
            tooltip: widget.isEnglish ? "Reset" : "রিসেট",
          ),
          IconButton(
            icon: const Icon(Icons.skip_previous, color: Colors.white),
            onPressed: _currentStepIndex > 0 ? _prevStep : null,
            tooltip: widget.isEnglish ? "Previous Step" : "আগের স্টেপ",
          ),
          IconButton(
            icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
            onPressed: _togglePlay,
            tooltip: _isPlaying
                ? (widget.isEnglish ? "Pause" : "পজ করুন")
                : (widget.isEnglish ? "Auto Play" : "অটো প্লে"),
          ),
          IconButton(
            icon: const Icon(Icons.skip_next, color: Colors.white),
            onPressed: _currentStepIndex < _steps.length - 1 ? _nextStep : null,
            tooltip: widget.isEnglish ? "Next Step" : "পরের স্টেপ",
          ),
          Text(
            "${_currentStepIndex + 1}/${_steps.length}",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
