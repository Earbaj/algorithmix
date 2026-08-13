import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';

class TopKFrequentAnimatedVisualizer extends StatefulWidget {
  final bool isEnglish;

  const TopKFrequentAnimatedVisualizer({
    super.key,
    required this.isEnglish,
  });

  @override
  State<TopKFrequentAnimatedVisualizer> createState() =>
      _TopKFrequentAnimatedVisualizerState();
}

class TopKStepData {
  final int activePairIdx;
  final Map<int, int> freqMap;
  final List<MapEntry<int, int>> minHeapPairs; // (freq, val)
  final String titleEn;
  final String titleBn;
  final String explanationEn;
  final String explanationBn;

  const TopKStepData({
    required this.activePairIdx,
    required this.freqMap,
    required this.minHeapPairs,
    required this.titleEn,
    required this.titleBn,
    required this.explanationEn,
    required this.explanationBn,
  });
}

class _TopKFrequentAnimatedVisualizerState
    extends State<TopKFrequentAnimatedVisualizer> {
  final List<int> _nums = const [1, 1, 1, 2, 2, 3];
  final int _k = 2;

  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  late final List<TopKStepData> _steps;

  @override
  void initState() {
    super.initState();
    _steps = const [
      TopKStepData(
        activePairIdx: 0,
        freqMap: {1: 3, 2: 2, 3: 1},
        minHeapPairs: [MapEntry(3, 1)],
        titleEn: "1. Count Frequencies -> Push pair (freq=3, val=1)",
        titleBn: "১. ফ্রিকোয়েন্সি গণনা -> (freq=3, val=1) পুশ",
        explanationEn: "Frequency map: {1: 3, 2: 2, 3: 1}. Push pair (3, 1) into Min-Heap.",
        explanationBn: "ফ্রিকোয়েন্সি ম্যাপ তৈরি। (3, 1) জোড়া Min-Heap এ পুশ করা হলো।",
      ),
      TopKStepData(
        activePairIdx: 1,
        freqMap: {1: 3, 2: 2, 3: 1},
        minHeapPairs: [MapEntry(2, 2), MapEntry(3, 1)],
        titleEn: "2. Push pair (freq=2, val=2) -> Heap Size = 2 <= K",
        titleBn: "২. (freq=2, val=2) পুশ -> হিপ সাইজ = ২ <= K",
        explanationEn: "Push pair (2, 2). Min-Heap orders by frequency: root has min frequency (2, 2). Size = 2.",
        explanationBn: "(2, 2) পুশ। Min-Heap ছোট ফ্রিকোয়েন্সি (2, 2) কে রুটে রেখেছে।",
      ),
      TopKStepData(
        activePairIdx: 2,
        freqMap: {1: 3, 2: 2, 3: 1},
        minHeapPairs: [MapEntry(2, 2), MapEntry(3, 1)],
        titleEn: "3. Push (freq=1, val=3) -> Size(3) > K(2)! Pop min (1, 3)",
        titleBn: "৩. (freq=1, val=3) পুশ -> সাইজ(৩) > K(২)! পপ মিন (1, 3)",
        explanationEn: "Push (1, 3) -> Heap size becomes 3! Pop smallest frequency (1, 3). Retains Top 2: [1, 2]! 🎉",
        explanationBn: "(1, 3) পুশ করে সাইজ ৩ হলে সবচেয়ে কম ফ্রিকোয়েন্সির (1, 3) পপ করা হলো। Top 2 উপাদান = [1, 2]! 🎉",
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
            color: const Color(0xFF84CC16).withOpacity(0.15),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF84CC16).withOpacity(0.5)),
          ),
          child: Row(
            children: [
              const Icon(Icons.bar_chart, color: Color(0xFF84CC16), size: 24),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.isEnglish ? step.titleEn : step.titleBn,
                      style: const TextStyle(color: Color(0xFF84CC16), fontWeight: FontWeight.bold, fontSize: 14),
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

        // Hash Map Frequencies + Min Heap Display
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
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
                  const Text("1. Frequency Hash Map Table:", style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                  Text("Top K = $_k", style: const TextStyle(color: AppTheme.accentNeonCyan, fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
                ],
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: step.freqMap.entries.map((entry) {
                    return Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceDark,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF334155)),
                      ),
                      child: Column(
                        children: [
                          Text("val: ${entry.key}", style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
                          const SizedBox(height: 2),
                          Text("freq: ${entry.value}", style: const TextStyle(color: Color(0xFF84CC16), fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),

              // Min Heap Pairs Display
              const Text("2. Priority Min-Heap Pairs (sorted by frequency):", style: TextStyle(color: Color(0xFF84CC16), fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(step.minHeapPairs.length, (idx) {
                    final pair = step.minHeapPairs[idx];
                    return Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: idx == 0 ? AppTheme.accentGreen.withOpacity(0.2) : const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: idx == 0 ? AppTheme.accentGreen : const Color(0xFF334155)),
                      ),
                      child: Text(
                        "(freq=${pair.key}, val=${pair.value})",
                        style: TextStyle(
                          color: idx == 0 ? AppTheme.accentGreen : Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'monospace',
                          fontSize: 13,
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        _buildControls(),
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
              backgroundColor: const Color(0xFF84CC16),
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
            style: const TextStyle(color: Color(0xFF84CC16), fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
