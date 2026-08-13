import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';

class ReverseArrayAnimatedVisualizer extends StatefulWidget {
  final bool isEnglish;

  const ReverseArrayAnimatedVisualizer({
    super.key,
    required this.isEnglish,
  });

  @override
  State<ReverseArrayAnimatedVisualizer> createState() => _ReverseArrayAnimatedVisualizerState();
}

class VisualizerStepData {
  final int left;
  final int right;
  final List<int> arrayState;
  final String titleEn;
  final String titleBn;
  final String explanationEn;
  final String explanationBn;

  const VisualizerStepData({
    required this.left,
    required this.right,
    required this.arrayState,
    required this.titleEn,
    required this.titleBn,
    required this.explanationEn,
    required this.explanationBn,
  });
}

class _ReverseArrayAnimatedVisualizerState extends State<ReverseArrayAnimatedVisualizer> {
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  late final List<VisualizerStepData> _steps;

  @override
  void initState() {
    super.initState();
    _steps = const [
      VisualizerStepData(
        left: 0,
        right: 4,
        arrayState: [1, 2, 3, 4, 5],
        titleEn: "1. Initialization",
        titleBn: "১. সূচনা (Initialization)",
        explanationEn: "Set pointer left = 0 (val 1) and right = 4 (val 5). Check condition 0 < 4 (TRUE).",
        explanationBn: "left = 0 (মান 1) এবং right = 4 (মান 5) পয়েন্টার সেট করি। শর্ত 0 < 4 সত্য (TRUE)।",
      ),
      VisualizerStepData(
        left: 0,
        right: 4,
        arrayState: [5, 2, 3, 4, 1],
        titleEn: "2. Swap arr[0] and arr[4]",
        titleBn: "২. arr[0] এবং arr[4] অদলবদল (Swap)",
        explanationEn: "Swap arr[0] (1) with arr[4] (5) in-place. Array becomes [5, 2, 3, 4, 1].",
        explanationBn: "arr[0] (1) এবং arr[4] (5) অদলবদল করা হলো। অ্যারে দাঁড়ায় [5, 2, 3, 4, 1]।",
      ),
      VisualizerStepData(
        left: 1,
        right: 3,
        arrayState: [5, 2, 3, 4, 1],
        titleEn: "3. Advance Pointers (left++, right--)",
        titleBn: "৩. পয়েন্টার পরিবর্তন (left++, right--)",
        explanationEn: "Advance left++ -> 1 and right-- -> 3. Check condition 1 < 3 (TRUE).",
        explanationBn: "পয়েন্টার বাড়ানো/কমানো: left = 1 এবং right = 3। শর্ত 1 < 3 সত্য (TRUE)।",
      ),
      VisualizerStepData(
        left: 1,
        right: 3,
        arrayState: [5, 4, 3, 2, 1],
        titleEn: "4. Swap arr[1] and arr[3]",
        titleBn: "৪. arr[1] এবং arr[3] অদলবদল (Swap)",
        explanationEn: "Swap arr[1] (2) with arr[3] (4) in-place. Array becomes [5, 4, 3, 2, 1].",
        explanationBn: "arr[1] (2) এবং arr[3] (4) অদলবদল করা হলো। অ্যারে দাঁড়ায় [5, 4, 3, 2, 1]।",
      ),
      VisualizerStepData(
        left: 2,
        right: 2,
        arrayState: [5, 4, 3, 2, 1],
        titleEn: "5. Pointers Meet (left == right)",
        titleBn: "৫. পয়েন্টার মিলিত (left == right)",
        explanationEn: "Advance left++ -> 2 and right-- -> 2. Condition 2 < 2 is FALSE! Loop terminates.",
        explanationBn: "left = 2 এবং right = 2 পয়েন্টার দুটি মাঝখানে মিলিত হয়েছে। শর্ত 2 < 2 মিথ্যা! লুপ শেষ।",
      ),
      VisualizerStepData(
        left: -1,
        right: -1,
        arrayState: [5, 4, 3, 2, 1],
        titleEn: "6. Reversal Complete 🎉",
        titleBn: "৬. রিভার্সাল সম্পূর্ণ 🎉",
        explanationEn: "Array in-place reversal completed successfully! Final reversed array: [5, 4, 3, 2, 1].",
        explanationBn: "অ্যারে রিভার্সাল সফলভাবে সম্পন্ন হয়েছে! চূড়ান্ত উল্টানো অ্যারে: [5, 4, 3, 2, 1]।",
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
        // Title Banner
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
              const Icon(Icons.swap_horiz, color: AppTheme.accentNeonCyan, size: 22),
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
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF090D16),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF1E293B)),
          ),
          child: Column(
            children: [
              // Pointer status cards
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildPointerCard("LEFT POINTER", step.left >= 0 ? "arr[${step.left}]" : "-", AppTheme.accentGreen),
                  _buildPointerCard("RIGHT POINTER", step.right >= 0 ? "arr[${step.right}]" : "-", AppTheme.accentAmber),
                ],
              ),
              const SizedBox(height: 24),

              // Animated Array Cards
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(step.arrayState.length, (idx) {
                    final isLeft = idx == step.left;
                    final isRight = idx == step.right;
                    final val = step.arrayState[idx];

                    Color borderColor = const Color(0xFF334155);
                    Color bgColor = const Color(0xFF1E293B);

                    if (isLeft && isRight) {
                      borderColor = AppTheme.accentPurple;
                      bgColor = AppTheme.accentPurple.withOpacity(0.25);
                    } else if (isLeft) {
                      borderColor = AppTheme.accentGreen;
                      bgColor = AppTheme.accentGreen.withOpacity(0.2);
                    } else if (isRight) {
                      borderColor = AppTheme.accentAmber;
                      bgColor = AppTheme.accentAmber.withOpacity(0.2);
                    }

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 350),
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      width: 58,
                      height: 76,
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: borderColor, width: (isLeft || isRight) ? 2.5 : 1.5),
                        boxShadow: (isLeft || isRight)
                            ? [BoxShadow(color: borderColor.withOpacity(0.4), blurRadius: 10)]
                            : [],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "[$idx]",
                            style: TextStyle(
                              fontSize: 10,
                              color: isLeft
                                  ? AppTheme.accentGreen
                                  : isRight
                                      ? AppTheme.accentAmber
                                      : AppTheme.textSecondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "$val",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isLeft
                                  ? AppTheme.accentGreen
                                  : isRight
                                      ? AppTheme.accentAmber
                                      : Colors.white,
                            ),
                          ),
                          if (isLeft && isRight)
                            const Text("L&R", style: TextStyle(fontSize: 9, color: AppTheme.accentPurple, fontWeight: FontWeight.bold))
                          else if (isLeft)
                            const Text("L", style: TextStyle(fontSize: 10, color: AppTheme.accentGreen, fontWeight: FontWeight.bold))
                          else if (isRight)
                            const Text("R", style: TextStyle(fontSize: 10, color: AppTheme.accentAmber, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.isEnglish ? "In-Place Two Pointer Swapping Visualizer" : "টু-পয়েন্টার ইন-প্লেস সোয়াপিং ভিজ্যুয়ালাইজার",
                style: const TextStyle(color: AppTheme.textMuted, fontSize: 11, fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Controls
        _buildControls(),
      ],
    );
  }

  Widget _buildPointerCard(String title, String val, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.6)),
      ),
      child: Column(
        children: [
          Text(title, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(val, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
        ],
      ),
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
