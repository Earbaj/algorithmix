import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';

class ImplementQueueStacksAnimatedVisualizer extends StatefulWidget {
  final bool isEnglish;

  const ImplementQueueStacksAnimatedVisualizer({
    super.key,
    required this.isEnglish,
  });

  @override
  State<ImplementQueueStacksAnimatedVisualizer> createState() =>
      _ImplementQueueStacksAnimatedVisualizerState();
}

class QueueStepData {
  final String opName;
  final List<int> stIn;
  final List<int> stOut;
  final String titleEn;
  final String titleBn;
  final String explanationEn;
  final String explanationBn;

  const QueueStepData({
    required this.opName,
    required this.stIn,
    required this.stOut,
    required this.titleEn,
    required this.titleBn,
    required this.explanationEn,
    required this.explanationBn,
  });
}

class _ImplementQueueStacksAnimatedVisualizerState
    extends State<ImplementQueueStacksAnimatedVisualizer> {
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  late final List<QueueStepData> _steps;

  @override
  void initState() {
    super.initState();
    _steps = const [
      QueueStepData(
        opName: "INIT",
        stIn: [],
        stOut: [],
        titleEn: "1. Initialization",
        titleBn: "১. সূচনা (Initialization)",
        explanationEn: "Initialize 2 Stacks: `stIn` (for Enqueue) & `stOut` (for Dequeue).",
        explanationBn: "২টি স্ট্যাক সূচনা করি: `stIn` (পুশের জন্য) এবং `stOut` (পপের জন্য)।",
      ),
      QueueStepData(
        opName: "push(1)",
        stIn: [1],
        stOut: [],
        titleEn: "2. push(1) -> Enqueue 1",
        titleBn: "২. push(1) -> 1 এনকিউ",
        explanationEn: "Enqueue 1: Push 1 onto `stIn` stack.",
        explanationBn: "১ এনকিউ: ১ কে `stIn` স্ট্যাকে পুশ করি।",
      ),
      QueueStepData(
        opName: "push(2)",
        stIn: [1, 2],
        stOut: [],
        titleEn: "3. push(2) -> Enqueue 2",
        titleBn: "৩. push(2) -> 2 এনকিউ",
        explanationEn: "Enqueue 2: Push 2 onto `stIn` stack. `stIn` now has [1, 2].",
        explanationBn: "২ এনকিউ: ২ কে `stIn` স্ট্যাকে পুশ করি। `stIn` এখন [1, 2]।",
      ),
      QueueStepData(
        opName: "transfer()",
        stIn: [],
        stOut: [2, 1],
        titleEn: "4. peek() / pop() -> Transfer elements to stOut!",
        titleBn: "৪. peek() / pop() -> stOut এ উপাদান স্থানান্তর!",
        explanationEn: "`stOut` is empty! Pop all elements from `stIn` and push to `stOut`. Order is reversed to FIFO: Top of `stOut` is 1!",
        explanationBn: "`stOut` খালি! `stIn` এর উপাদান পপ করে `stOut` এ রাখলে ক্রম রিভার্স হয়ে FIFO রুল পূরণ হয়! `stOut` এর টপে এখন ১!",
      ),
      QueueStepData(
        opName: "pop() -> 1",
        stIn: [],
        stOut: [2],
        titleEn: "5. pop() -> returns 1 (First In First Out 🎉)",
        titleBn: "৫. pop() -> 1 রিটার্ন (ফার্স্ট-ইন ফার্স্ট-আউট 🎉)",
        explanationEn: "Pop 1 from `stOut`. The element that entered FIRST (1) is popped FIRST! FIFO order achieved!",
        explanationBn: "`stOut` থেকে ১ পপ হলো। যে উপাদানটি সবার আগে (1) এসেছিল সেটিই সবার আগে পপ হলো! FIFO নীতি সফল!",
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
  Widget build(BuildContext context) {
    final step = _steps[_currentStepIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.accentAmber.withOpacity(0.12),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.accentAmber.withOpacity(0.5)),
          ),
          child: Row(
            children: [
              const Icon(Icons.swap_horizontal_circle_outlined, color: AppTheme.accentAmber, size: 24),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.isEnglish ? step.titleEn : step.titleBn,
                      style: const TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 14),
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

        // Visual Two-Stack FIFO Queue Canvas
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStackBucket("stIn (Enqueue Rear ➡️)", step.stIn, AppTheme.accentAmber),
                  const Icon(Icons.arrow_forward, color: AppTheme.accentNeonCyan, size: 24),
                  _buildStackBucket("stOut (Dequeue Front ➡️)", step.stOut, AppTheme.accentGreen),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                widget.isEnglish ? "Two LIFO Stacks combined to form a First-In First-Out (FIFO) Queue Pipeline!" : "২টি LIFO স্ট্যাক মিলে ফার্স্ট-ইন ফার্স্ট-আউট (FIFO) কিউ পাইপলাইন তৈরি করে!",
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

  Widget _buildStackBucket(String title, List<int> items, Color accentColor) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(color: accentColor, fontWeight: FontWeight.bold, fontSize: 11),
        ),
        const SizedBox(height: 6),
        Container(
          width: 110,
          height: 160,
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(14),
              bottomRight: Radius.circular(14),
            ),
            border: Border(
              left: BorderSide(color: accentColor, width: 2),
              right: BorderSide(color: accentColor, width: 2),
              bottom: BorderSide(color: accentColor, width: 3),
            ),
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 2),
                color: accentColor.withOpacity(0.15),
                child: Text("TOP", textAlign: TextAlign.center, style: TextStyle(color: accentColor, fontSize: 9, fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SingleChildScrollView(
                    reverse: true,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (items.isEmpty)
                          const Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: Text("EMPTY", style: TextStyle(color: AppTheme.textMuted, fontSize: 10)),
                          )
                        else
                          ...List.generate(items.length, (idx) {
                            final itemIdx = items.length - 1 - idx;
                            final val = items[itemIdx];
                            final isTop = itemIdx == items.length - 1;

                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: isTop ? accentColor.withOpacity(0.3) : AppTheme.surfaceDark,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: isTop ? accentColor : const Color(0xFF334155)),
                              ),
                              child: Text(
                                "$val",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontFamily: 'monospace', color: isTop ? accentColor : Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                            );
                          }),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
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
          ElevatedButton.icon(
            onPressed: _togglePlay,
            icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
            label: Text(_isPlaying
                ? (widget.isEnglish ? "Pause" : "পজ করুন")
                : (widget.isEnglish ? "Auto Play" : "অটো প্লে")),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentAmber,
              foregroundColor: AppTheme.primaryDark,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.skip_next, color: Colors.white),
            onPressed: _currentStepIndex < _steps.length - 1 ? _nextStep : null,
            tooltip: widget.isEnglish ? "Next Step" : "পরের স্টেপ",
          ),
          Text(
            "${_currentStepIndex + 1}/${_steps.length}",
            style: const TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
