import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';

class ReverseDoublyLinkedListAnimatedVisualizer extends StatefulWidget {
  final bool isEnglish;

  const ReverseDoublyLinkedListAnimatedVisualizer({
    super.key,
    required this.isEnglish,
  });

  @override
  State<ReverseDoublyLinkedListAnimatedVisualizer> createState() =>
      _ReverseDoublyLinkedListAnimatedVisualizerState();
}

class DLLStepData {
  final int currVal;
  final int tempVal;
  final String titleEn;
  final String titleBn;
  final String explanationEn;
  final String explanationBn;

  const DLLStepData({
    required this.currVal,
    required this.tempVal,
    required this.titleEn,
    required this.titleBn,
    required this.explanationEn,
    required this.explanationBn,
  });
}

class _ReverseDoublyLinkedListAnimatedVisualizerState
    extends State<ReverseDoublyLinkedListAnimatedVisualizer> {
  final List<int> _nodes = const [1, 2, 3, 4];

  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  late final List<DLLStepData> _steps;

  @override
  void initState() {
    super.initState();
    _steps = const [
      DLLStepData(
        currVal: 1,
        tempVal: -1,
        titleEn: "1. Initialization",
        titleBn: "১. সূচনা (Initialization)",
        explanationEn: "Doubly Linked List node chain [1 <-> 2 <-> 3 <-> 4]. Set curr = head (1), temp = NULL.",
        explanationBn: "দ্বিমুখী নোড চেইন [1 <-> 2 <-> 3 <-> 4]। curr = head (1) এবং temp = NULL সেট করি।",
      ),
      DLLStepData(
        currVal: 1,
        tempVal: -1,
        titleEn: "2. Swap Node 1 (prev & next)",
        titleBn: "২. Node 1 এর prev ও next অদলবদল (Swap)",
        explanationEn: "Node 1: temp = curr->prev (NULL). Swap curr->prev with curr->next. Advance curr = curr->prev.",
        explanationBn: "Node 1: temp = NULL সেভ করি। prev ও next পয়েন্টার স্থান পরিবর্তন করে। curr পরবর্তী নোডে এগোয়।",
      ),
      DLLStepData(
        currVal: 2,
        tempVal: 1,
        titleEn: "3. Swap Node 2 (prev & next)",
        titleBn: "৩. Node 2 এর prev ও next অদলবদল (Swap)",
        explanationEn: "Node 2: temp = Node 1. Swap curr->prev with curr->next. Advance curr = curr->prev (Node 3).",
        explanationBn: "Node 2: temp = Node 1 সেভ। Node 2 এর উভয় পয়েন্টার swap করা হলো।",
      ),
      DLLStepData(
        currVal: 3,
        tempVal: 2,
        titleEn: "4. Swap Node 3 (prev & next)",
        titleBn: "৪. Node 3 এর prev ও next অদলবদল (Swap)",
        explanationEn: "Node 3: temp = Node 2. Swap curr->prev with curr->next. Advance curr = curr->prev (Node 4).",
        explanationBn: "Node 3: temp = Node 2 সেভ। Node 3 এর উভয় পয়েন্টার swap করা হলো।",
      ),
      DLLStepData(
        currVal: 4,
        tempVal: 3,
        titleEn: "5. Swap Node 4 (prev & next)",
        titleBn: "৫. Node 4 এর prev ও next অদলবদল (Swap)",
        explanationEn: "Node 4: temp = Node 3. Swap curr->prev with curr->next. curr reaches NULL.",
        explanationBn: "Node 4: temp = Node 3 সেভ। Node 4 এর উভয় পয়েন্টার swap শেষ। curr = NULL।",
      ),
      DLLStepData(
        currVal: -1,
        tempVal: 3,
        titleEn: "6. DLL Reversal Complete! 🎉",
        titleBn: "৬. DLL রিভার্সাল সম্পূর্ণ! 🎉",
        explanationEn: "Return new head = temp->prev (Node 4). The reversed Doubly Linked List is [4 <-> 3 <-> 2 <-> 1]!",
        explanationBn: "নতুন হেড temp->prev (Node 4) রিটার্ন করা হলো। উল্টানো দ্বিমুখী লিস্ট: [4 <-> 3 <-> 2 <-> 1]!",
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
              const Icon(Icons.swap_horiz, color: AppTheme.accentNeonCyan, size: 24),
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

        // Visual Canvas
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLegendItem("curr ptr", AppTheme.accentNeonCyan),
                  const SizedBox(width: 20),
                  _buildLegendItem("temp ptr", AppTheme.accentPink),
                ],
              ),
              const SizedBox(height: 20),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_nodes.length, (idx) {
                    final val = _nodes[idx];
                    final isCurr = step.currVal == val;
                    final isTemp = step.tempVal == val;

                    return Row(
                      children: [
                        Column(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (isCurr) _buildBadge("curr", AppTheme.accentNeonCyan),
                                if (isTemp) _buildBadge("temp", AppTheme.accentPink),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: isCurr
                                    ? AppTheme.accentNeonCyan.withOpacity(0.3)
                                    : (isTemp ? AppTheme.accentPink.withOpacity(0.2) : const Color(0xFF1E293B)),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isCurr
                                      ? AppTheme.accentNeonCyan
                                      : (isTemp ? AppTheme.accentPink : const Color(0xFF334155)),
                                  width: isCurr || isTemp ? 2 : 1,
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
                            Text("Node $val", style: const TextStyle(color: AppTheme.textMuted, fontSize: 10)),
                          ],
                        ),
                        if (idx < _nodes.length - 1)
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Icon(Icons.compare_arrows, color: AppTheme.accentGreen, size: 22),
                          ),
                      ],
                    );
                  }),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                widget.isEnglish ? "Swapping prev & next pointers for Doubly Linked List" : "Doubly Linked List এর prev ও next উভয় পয়েন্টার অদলবদল",
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
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(6), border: Border.all(color: color)),
      child: Text(label, style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.bold)),
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
