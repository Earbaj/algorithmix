import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';

class MinStackAnimatedVisualizer extends StatefulWidget {
  final bool isEnglish;

  const MinStackAnimatedVisualizer({
    super.key,
    required this.isEnglish,
  });

  @override
  State<MinStackAnimatedVisualizer> createState() => _MinStackAnimatedVisualizerState();
}

class MinStackStepData {
  final String opName;
  final List<int> mainStack;
  final List<int> minStack;
  final String titleEn;
  final String titleBn;
  final String explanationEn;
  final String explanationBn;

  const MinStackStepData({
    required this.opName,
    required this.mainStack,
    required this.minStack,
    required this.titleEn,
    required this.titleBn,
    required this.explanationEn,
    required this.explanationBn,
  });
}

class _MinStackAnimatedVisualizerState extends State<MinStackAnimatedVisualizer> {
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  late final List<MinStackStepData> _steps;

  @override
  void initState() {
    super.initState();
    _steps = const [
      MinStackStepData(
        opName: "INIT",
        mainStack: [],
        minStack: [],
        titleEn: "1. Initialization",
        titleBn: "১. সূচনা (Initialization)",
        explanationEn: "Initialize Dual Stacks: Main Stack (st) & Auxiliary Min Stack (minSt).",
        explanationBn: "ডুয়েল স্ট্যাক তৈরি করি: মেইন স্ট্যাক (st) এবং অক্সিলিয়ারি Min Stack (minSt)।",
      ),
      MinStackStepData(
        opName: "PUSH (-2)",
        mainStack: [-2],
        minStack: [-2],
        titleEn: "2. Push (-2)",
        titleBn: "২. পুশ (-2)",
        explanationEn: "Push -2 into Main Stack. Min Stack is empty, so push -2 as current Minimum.",
        explanationBn: "-2 মেইন স্ট্যাকে পুশ করা হলো। Min Stack খালি থাকায় এটিই বর্তমান সর্বনিম্ন মান (-2)।",
      ),
      MinStackStepData(
        opName: "PUSH (0)",
        mainStack: [-2, 0],
        minStack: [-2, -2],
        titleEn: "3. Push (0)",
        titleBn: "৩. পুশ (0)",
        explanationEn: "Push 0 into Main Stack. Min(0, -2) = -2, so push -2 into Min Stack.",
        explanationBn: "0 মেইন স্ট্যাকে পুশ। Min(0, -2) = -2 হওয়ায় Min Stack এ -2 রিপিট পুশ করা হলো।",
      ),
      MinStackStepData(
        opName: "PUSH (-3)",
        mainStack: [-2, 0, -3],
        minStack: [-2, -2, -3],
        titleEn: "4. Push (-3)",
        titleBn: "৪. পুশ (-3)",
        explanationEn: "Push -3 into Main Stack. Min(-3, -2) = -3, so push NEW minimum -3 into Min Stack!",
        explanationBn: "-3 মেইন স্ট্যাকে পুশ। নতুন সর্বনিম্ন মান -3 পাওয়ায় Min Stack এর টপে -3 পুশ হলো!",
      ),
      MinStackStepData(
        opName: "GET_MIN()",
        mainStack: [-2, 0, -3],
        minStack: [-2, -2, -3],
        titleEn: "5. getMin() -> returns -3 in O(1)",
        titleBn: "৫. getMin() -> O(1) এ -3 রিটার্ন",
        explanationEn: "Query getMin(): Return top of Min Stack = -3 in instant O(1) time!",
        explanationBn: "getMin() কোয়েরি: Min Stack এর টপ মান (-3) তাত্ক্ষণিক O(1) টাইমে রিটার্ন হলো!",
      ),
      MinStackStepData(
        opName: "POP()",
        mainStack: [-2, 0],
        minStack: [-2, -2],
        titleEn: "6. Pop() -> removes top elements",
        titleBn: "৬. Pop() -> টপ এলিমেন্ট পপ",
        explanationEn: "Pop top element from Main Stack (-3) AND top element from Min Stack (-3).",
        explanationBn: "মেইন স্ট্যাক ও Min Stack উভয় থেকেই টপ মান (-3) পপ করা হলো।",
      ),
      MinStackStepData(
        opName: "GET_MIN()",
        mainStack: [-2, 0],
        minStack: [-2, -2],
        titleEn: "7. getMin() -> returns -2 in O(1)",
        titleBn: "৭. getMin() -> O(1) এ -2 রিটার্ন",
        explanationEn: "Query getMin(): Return new top of Min Stack = -2 in O(1) time!",
        explanationBn: "getMin() কোয়েরি: নতুন সর্বনিম্ন মান (-2) O(1) স্পিডে রিটার্ন করা হলো!",
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
            color: AppTheme.accentNeonCyan.withOpacity(0.12),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.accentNeonCyan.withOpacity(0.5)),
          ),
          child: Row(
            children: [
              const Icon(Icons.layers_outlined, color: AppTheme.accentNeonCyan, size: 24),
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

        // Dual Stack Vertical Bucket Canvas
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
                  _buildSingleStackBucket("Main Stack (st)", step.mainStack, AppTheme.accentGreen),
                  _buildSingleStackBucket("Min Stack (minSt)", step.minStack, AppTheme.accentPink),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                widget.isEnglish ? "Dual Vertical Stack: Parallel tracking guarantees O(1) minimum queries!" : "ডুয়েল ভার্টিক্যাল স্ট্যাক: সমান্তরাল ট্র্যাকিং O(1) মিনিমাম কোয়েরি নিশ্চিত করে!",
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

  Widget _buildSingleStackBucket(String title, List<int> items, Color accentColor) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(color: accentColor, fontWeight: FontWeight.bold, fontSize: 12),
        ),
        const SizedBox(height: 6),
        Container(
          width: 115,
          height: 170,
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
