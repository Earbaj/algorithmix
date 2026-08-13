import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';

class FindMiddleNodeAnimatedVisualizer extends StatefulWidget {
  final bool isEnglish;

  const FindMiddleNodeAnimatedVisualizer({
    super.key,
    required this.isEnglish,
  });

  @override
  State<FindMiddleNodeAnimatedVisualizer> createState() => _FindMiddleNodeAnimatedVisualizerState();
}

class LLStepData {
  final int slowVal;
  final int fastVal;
  final bool isFound;
  final String titleEn;
  final String titleBn;
  final String explanationEn;
  final String explanationBn;

  const LLStepData({
    required this.slowVal,
    required this.fastVal,
    required this.isFound,
    required this.titleEn,
    required this.titleBn,
    required this.explanationEn,
    required this.explanationBn,
  });
}

class _FindMiddleNodeAnimatedVisualizerState extends State<FindMiddleNodeAnimatedVisualizer> {
  final List<int> _nodes = const [1, 2, 3, 4, 5];

  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  late final List<LLStepData> _steps;

  @override
  void initState() {
    super.initState();
    _steps = const [
      LLStepData(
        slowVal: 1,
        fastVal: 1,
        isFound: false,
        titleEn: "1. Initialization",
        titleBn: "১. সূচনা (Initialization)",
        explanationEn: "Initialize slow = head (Node 1), fast = head (Node 1).",
        explanationBn: "slow = head (Node 1) এবং fast = head (Node 1) ডিক্লেয়ার করি।",
      ),
      LLStepData(
        slowVal: 2,
        fastVal: 3,
        isFound: false,
        titleEn: "2. Step 1: Move slow +1, fast +2",
        titleBn: "২. ধাপ ১: slow ১ ধাপ, fast ২ ধাপ সরান",
        explanationEn: "slow advances to Node 2 (1 step). fast advances to Node 3 (2 steps).",
        explanationBn: "slow ১ ধাপ এগিয়ে Node 2 এ এবং fast ২ ধাপ এগিয়ে Node 3 এ পৌঁছায়।",
      ),
      LLStepData(
        slowVal: 3,
        fastVal: 5,
        isFound: false,
        titleEn: "3. Step 2: Move slow +1, fast +2",
        titleBn: "৩. ধাপ ২: slow ১ ধাপ, fast ২ ধাপ সরান",
        explanationEn: "slow advances to Node 3 (1 step). fast advances to Node 5 (2 steps).",
        explanationBn: "slow ১ ধাপ এগিয়ে Node 3 এ এবং fast ২ ধাপ এগিয়ে Node 5 এ পৌঁছায়।",
      ),
      LLStepData(
        slowVal: 3,
        fastVal: 5,
        isFound: true,
        titleEn: "4. Middle Node Found! 🎉",
        titleBn: "৪. মিডল নোড পাওয়া গেছে! 🎉",
        explanationEn: "fast->next is NULL! Loop terminates. The slow pointer points to Node 3, which is the Middle Node!",
        explanationBn: "fast->next = NULL হওয়ায় লুপ বন্ধ! slow পয়েন্টারটি Node 3 নির্দেশ করছে, যা লিঙ্কড লিস্টের কাঙ্ক্ষিত মিডল নোড!",
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
              const Icon(Icons.speed, color: AppTheme.accentNeonCyan, size: 24),
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

        // Visual Canvas Box
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
                  _buildLegendItem("slow (+1)", AppTheme.accentGreen),
                  const SizedBox(width: 20),
                  _buildLegendItem("fast (+2)", Colors.purpleAccent),
                ],
              ),
              const SizedBox(height: 20),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_nodes.length, (idx) {
                    final val = _nodes[idx];
                    final isSlow = step.slowVal == val;
                    final isFast = step.fastVal == val;
                    final isTargetMiddle = step.isFound && isSlow;

                    return Row(
                      children: [
                        Column(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (isSlow) _buildBadge("slow", AppTheme.accentGreen),
                                if (isFast) _buildBadge("fast", Colors.purpleAccent),
                              ],
                            ),
                            const SizedBox(height: 6),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: isTargetMiddle
                                    ? AppTheme.accentGreen.withOpacity(0.35)
                                    : (isSlow
                                        ? AppTheme.accentGreen.withOpacity(0.2)
                                        : (isFast ? Colors.purpleAccent.withOpacity(0.2) : const Color(0xFF1E293B))),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isTargetMiddle
                                      ? AppTheme.accentGreen
                                      : (isSlow ? AppTheme.accentGreen : (isFast ? Colors.purpleAccent : const Color(0xFF334155))),
                                  width: isTargetMiddle ? 3 : (isSlow || isFast ? 2 : 1),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "$val",
                                  style: TextStyle(
                                    color: isTargetMiddle ? AppTheme.accentGreen : Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Node $val",
                              style: TextStyle(color: isTargetMiddle ? AppTheme.accentGreen : AppTheme.textMuted, fontSize: 10, fontWeight: isTargetMiddle ? FontWeight.bold : FontWeight.normal),
                            ),
                          ],
                        ),
                        if (idx < _nodes.length - 1)
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Icon(Icons.arrow_forward, color: AppTheme.accentNeonCyan, size: 20),
                          ),
                      ],
                    );
                  }),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                widget.isEnglish ? "Fast Pointer moves 2x speed of Slow Pointer" : "ফাস্ট পয়েন্টার স্লো পয়েন্টারের দ্বিগুণ গতিতে চলে",
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
