import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'floyds_cycle_detection/floyds_cycle_canvas_widget.dart';
import 'floyds_cycle_detection/floyds_cycle_controls_widget.dart';

class DetectCycleLinkedListAnimatedVisualizer extends StatefulWidget {
  final bool isEnglish;

  const DetectCycleLinkedListAnimatedVisualizer({
    super.key,
    required this.isEnglish,
  });

  @override
  State<DetectCycleLinkedListAnimatedVisualizer> createState() =>
      _DetectCycleLinkedListAnimatedVisualizerState();
}

class LLStepData {
  final int slowVal;
  final int fastVal;
  final bool isCycleDetected;
  final String titleEn;
  final String titleBn;
  final String explanationEn;
  final String explanationBn;

  const LLStepData({
    required this.slowVal,
    required this.fastVal,
    required this.isCycleDetected,
    required this.titleEn,
    required this.titleBn,
    required this.explanationEn,
    required this.explanationBn,
  });
}

class _DetectCycleLinkedListAnimatedVisualizerState
    extends State<DetectCycleLinkedListAnimatedVisualizer> {
  final List<int> _nodes = const [1, 2, 3, 4]; // 4 points back to 2

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
        isCycleDetected: false,
        titleEn: "1. Initialization",
        titleBn: "১. সূচনা (Initialization)",
        explanationEn: "Linked List contains a cycle: Node 4 -> Node 2. Initialize slow = head (1), fast = head (1).",
        explanationBn: "লিঙ্কড লিস্টে সাইকেল বিদ্যমান: Node 4 -> Node 2। slow = Node 1, fast = Node 1 সূচনা করি।",
      ),
      LLStepData(
        slowVal: 2,
        fastVal: 3,
        isCycleDetected: false,
        titleEn: "2. Step 1: slow +1, fast +2",
        titleBn: "২. ধাপ ১: slow ১ ধাপ, fast ২ ধাপ সরান",
        explanationEn: "slow moves to Node 2. fast moves to Node 3.",
        explanationBn: "slow ১ ধাপ এগিয়ে Node 2 এ এবং fast ২ ধাপ এগিয়ে Node 3 এ যায়।",
      ),
      LLStepData(
        slowVal: 3,
        fastVal: 2,
        isCycleDetected: false,
        titleEn: "3. Step 2: fast wraps around cycle (Node 4 -> Node 2)",
        titleBn: "৩. ধাপ ২: fast সাইকেল ঘুরে নোড 2 এ পৌঁছাল",
        explanationEn: "slow moves to Node 3. fast moves from 3 to 4, then wraps around cycle to Node 2!",
        explanationBn: "slow ১ ধাপ এগিয়ে Node 3 এ। fast ৪ পার হয়ে সাইকেলের মাধ্যমে ঘুরিয়া Node 2 এ পৌঁছাল!",
      ),
      LLStepData(
        slowVal: 4,
        fastVal: 4,
        isCycleDetected: true,
        titleEn: "4. Cycle Detected! (slow == fast) 🎉",
        titleBn: "৪. সাইকেল শনাক্ত হয়েছে! (slow == fast) 🎉",
        explanationEn: "slow moves to Node 4. fast moves 2 steps (Node 3 -> Node 4). Both pointers meet at Node 4! Return TRUE!",
        explanationBn: "slow এবং fast উভয় পয়েন্টার Node 4 এ মিলিত হয়েছে (slow == fast)! সাইকেল শনাক্তকরণ সফল! রিটার্ন TRUE!",
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
              const Icon(Icons.sync_problem, color: AppTheme.accentNeonCyan, size: 24),
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

        FloydsCycleCanvasWidget(
          isEnglish: widget.isEnglish,
          nodes: _nodes,
          slowVal: step.slowVal,
          fastVal: step.fastVal,
          isCycleDetected: step.isCycleDetected,
        ),
        const SizedBox(height: 20),

        FloydsCycleControlsWidget(
          isEnglish: widget.isEnglish,
          currentStepIndex: _currentStepIndex,
          totalSteps: _steps.length,
          isPlaying: _isPlaying,
          onReset: _reset,
          onPrev: _currentStepIndex > 0 ? _prevStep : null,
          onTogglePlay: _togglePlay,
          onNext: _currentStepIndex < _steps.length - 1 ? _nextStep : null,
        ),
      ],
    );
  }
}
