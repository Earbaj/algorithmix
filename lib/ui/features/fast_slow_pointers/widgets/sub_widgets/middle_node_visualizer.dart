import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import 'cycle_detection_visualizer.dart';

class MiddleNodeVisualizer extends StatefulWidget {
  final bool isEnglish;

  const MiddleNodeVisualizer({super.key, required this.isEnglish});

  @override
  State<MiddleNodeVisualizer> createState() => _MiddleNodeVisualizerState();
}

class _MiddleNodeVisualizerState extends State<MiddleNodeVisualizer> {
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  final List<String> _codeLines = const [
    "ListNode* middleNode(ListNode* head) {",
    "    ListNode *slow = head, *fast = head;",
    "    while (fast != nullptr && fast->next != nullptr) {",
    "        slow = slow->next;       // 1 step",
    "        fast = fast->next->next; // 2 steps",
    "    }",
    "    return slow; // Middle Node!",
    "}",
  ];

  final List<FastSlowStep> _steps = const [
    FastSlowStep(
      slow: 0,
      fast: 0,
      activeLineIndex: 1,
      nodeValues: [1, 2, 3, 4, 5],
      explanationEn: "Line 2: Set slow = head (1) and fast = head (1). List = [1 -> 2 -> 3 -> 4 -> 5].",
      explanationBn: "লাইন ২: slow = 1 এবং fast = 1 সূচনা। লিঙ্কড লিস্ট = [1 -> 2 -> 3 -> 4 -> 5]।",
    ),
    FastSlowStep(
      slow: 1,
      fast: 2,
      activeLineIndex: 3,
      nodeValues: [1, 2, 3, 4, 5],
      explanationEn: "Line 4: Advance slow 1 step -> Node 2. Advance fast 2 steps -> Node 3.",
      explanationBn: "লাইন ৪: slow ১ ধাপ এগোলো -> নোড 2। fast ২ ধাপ এগোলো -> নোড 3।",
    ),
    FastSlowStep(
      slow: 2,
      fast: 4,
      activeLineIndex: 4,
      nodeValues: [1, 2, 3, 4, 5],
      explanationEn: "Line 5: Advance slow 1 step -> Node 3. Advance fast 2 steps -> Node 5 (Tail).",
      explanationBn: "লাইন ৫: slow ১ ধাপ এগোলো -> নোড 3। fast ২ ধাপ এগোলো -> নোড 5 (শেষ নোড)।",
    ),
    FastSlowStep(
      slow: 2,
      fast: 4,
      activeLineIndex: 6,
      nodeValues: [1, 2, 3, 4, 5],
      hasCollision: true,
      explanationEn: "🎉 Line 7: Fast reached tail! Middle Node = slow (val 3)!",
      explanationBn: "🎉 লাইন ৭: fast শেষ নোডে পৌঁছেছে! মিডল নোড = 3 (slow)! সম্পন্ন!",
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
            color: step.hasCollision ? AppTheme.accentGreen.withOpacity(0.15) : AppTheme.accentPink.withOpacity(0.15),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: step.hasCollision ? AppTheme.accentGreen : AppTheme.accentPink),
          ),
          child: Text(
            widget.isEnglish ? step.explanationEn : step.explanationBn,
            style: TextStyle(
              color: step.hasCollision ? AppTheme.accentGreen : AppTheme.accentPink,
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
              _buildFastSlowCanvas(step),
            ],
          )
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildCodeSnippetWithHighlight(_codeLines, step.activeLineIndex)),
              const SizedBox(width: 16),
              Expanded(child: _buildFastSlowCanvas(step)),
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
              color: isHighlighted ? AppTheme.accentPink.withOpacity(0.25) : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: isHighlighted ? Border.all(color: AppTheme.accentPink) : null,
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

  Widget _buildFastSlowCanvas(FastSlowStep step) {
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
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("Slow Pointer Index: [${step.slow}]", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13)),
              Text("Fast Pointer Index: [${step.fast}]", style: const TextStyle(color: AppTheme.accentPink, fontWeight: FontWeight.bold, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 16),
          const Text("Linked List Nodes & Middle Tracker:", style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(step.nodeValues.length, (i) {
                final isSlow = i == step.slow;
                final isFast = i == step.fast;
                final isBoth = isSlow && isFast;

                final Color color = isBoth
                    ? AppTheme.accentGreen
                    : (isSlow ? AppTheme.accentNeonCyan : (isFast ? AppTheme.accentPink : AppTheme.surfaceDark));

                return Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 60,
                      height: 65,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: (isSlow || isFast) ? Colors.white : const Color(0xFF1E293B),
                          width: (isSlow || isFast) ? 2.5 : 1,
                        ),
                        boxShadow: (isSlow || isFast) ? [BoxShadow(color: color.withOpacity(0.6), blurRadius: 10)] : [],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${step.nodeValues[i]}",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: (isSlow || isFast) ? AppTheme.primaryDark : Colors.white),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isBoth ? "BOTH!" : (isSlow ? "MID" : (isFast ? "FAST" : "[$i]")),
                            style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.bold, color: (isSlow || isFast) ? AppTheme.primaryDark : AppTheme.textMuted),
                          ),
                        ],
                      ),
                    ),
                    if (i < step.nodeValues.length - 1)
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(Icons.arrow_right_alt, color: AppTheme.accentPink, size: 20),
                      ),
                  ],
                );
              }),
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
