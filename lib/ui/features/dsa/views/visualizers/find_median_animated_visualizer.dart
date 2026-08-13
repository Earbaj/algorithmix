import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';

class FindMedianAnimatedVisualizer extends StatefulWidget {
  final bool isEnglish;

  const FindMedianAnimatedVisualizer({
    super.key,
    required this.isEnglish,
  });

  @override
  State<FindMedianAnimatedVisualizer> createState() =>
      _FindMedianAnimatedVisualizerState();
}

class MedianStepData {
  final int incomingNum;
  final List<int> maxHeapLower; // Max-Heap for small half
  final List<int> minHeapUpper; // Min-Heap for large half
  final double currentMedian;
  final String titleEn;
  final String titleBn;
  final String explanationEn;
  final String explanationBn;

  const MedianStepData({
    required this.incomingNum,
    required this.maxHeapLower,
    required this.minHeapUpper,
    required this.currentMedian,
    required this.titleEn,
    required this.titleBn,
    required this.explanationEn,
    required this.explanationBn,
  });
}

class _FindMedianAnimatedVisualizerState
    extends State<FindMedianAnimatedVisualizer> {
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  late final List<MedianStepData> _steps;

  @override
  void initState() {
    super.initState();
    _steps = const [
      MedianStepData(
        incomingNum: 1,
        maxHeapLower: [1],
        minHeapUpper: [],
        currentMedian: 1.0,
        titleEn: "1. Incoming num = 1 -> Add to Max-Heap (Lower Half)",
        titleBn: "১. ইনকমিং সংখ্যা = ১ -> Max-Heap এ যোগ (ছোট অর্ধেক)",
        explanationEn: "Add 1 to Max-Heap. Max-Heap size 1 > Min-Heap size 0. Median = 1.0.",
        explanationBn: "১ কে Max-Heap এ যোগ। Max-Heap সাইজ ১ > Min-Heap সাইজ ০। মিডিয়ান = ১.০।",
      ),
      MedianStepData(
        incomingNum: 2,
        maxHeapLower: [1],
        minHeapUpper: [2],
        currentMedian: 1.5,
        titleEn: "2. Incoming num = 2 -> Add to Min-Heap (Upper Half)",
        titleBn: "২. ইনকমিং সংখ্যা = ২ -> Min-Heap এ যোগ (বড় অর্ধেক)",
        explanationEn: "Add 2 to Min-Heap. Equal sizes (1 == 1) -> Median = (Max-Heap.top + Min-Heap.top) / 2 = (1 + 2)/2 = 1.5! 🎉",
        explanationBn: "২ কে Min-Heap এ যোগ। সাইজ সমান (১ == ১) -> মিডিয়ান = (১ + ২)/২ = ১.৫! 🎉",
      ),
      MedianStepData(
        incomingNum: 3,
        maxHeapLower: [2, 1],
        minHeapUpper: [3],
        currentMedian: 2.0,
        titleEn: "3. Incoming num = 3 -> Balance Heaps -> Median = 2.0! 🎉",
        titleBn: "৩. ইনকমিং সংখ্যা = ৩ -> হিপ ব্যালেন্সড -> মিডিয়ান = ২.০! 🎉",
        explanationEn: "Add 3 to Min-Heap, balance top into Max-Heap. Max-Heap root [2] is Median = 2.0 in O(1) time! 🎉",
        explanationBn: "৩ হিপে যোগ করে ব্যালেন্স করা হলো। Max-Heap এর রুট [২] হলো বর্তমান মিডিয়ান = ২.০ (O(1))! 🎉",
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
              const Icon(Icons.waves, color: Color(0xFF84CC16), size: 24),
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

        // Visual Display of Two Heaps (Max-Heap Left & Min-Heap Right)
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Incoming Stream: num = ${step.incomingNum}", style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.accentGreen.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.accentGreen),
                    ),
                    child: Text(
                      "Live Median = ${step.currentMedian}",
                      style: const TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 12, fontFamily: 'monospace'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Max-Heap Lower Half
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.accentPurple.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppTheme.accentPurple.withOpacity(0.5)),
                      ),
                      child: Column(
                        children: [
                          const Text("Max-Heap (Lower Half)", style: TextStyle(color: AppTheme.accentPurple, fontSize: 11, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          ...List.generate(step.maxHeapLower.length, (idx) {
                            final isRoot = idx == 0;
                            return Container(
                              margin: const EdgeInsets.only(bottom: 6),
                              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                              decoration: BoxDecoration(
                                color: isRoot ? AppTheme.accentPurple.withOpacity(0.3) : const Color(0xFF1E293B),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: isRoot ? AppTheme.accentPurple : const Color(0xFF334155)),
                              ),
                              child: Text("${step.maxHeapLower[idx]}", style: TextStyle(color: isRoot ? Colors.white : Colors.white70, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // 2. Min-Heap Upper Half
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.accentNeonCyan.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppTheme.accentNeonCyan.withOpacity(0.5)),
                      ),
                      child: Column(
                        children: [
                          const Text("Min-Heap (Upper Half)", style: TextStyle(color: AppTheme.accentNeonCyan, fontSize: 11, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          if (step.minHeapUpper.isEmpty)
                            const Text("Empty", style: TextStyle(color: Colors.white38, fontSize: 11))
                          else
                            ...List.generate(step.minHeapUpper.length, (idx) {
                              final isRoot = idx == 0;
                              return Container(
                                margin: const EdgeInsets.only(bottom: 6),
                                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                                decoration: BoxDecoration(
                                  color: isRoot ? AppTheme.accentNeonCyan.withOpacity(0.3) : const Color(0xFF1E293B),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: isRoot ? AppTheme.accentNeonCyan : const Color(0xFF334155)),
                                ),
                                child: Text("${step.minHeapUpper[idx]}", style: TextStyle(color: isRoot ? Colors.white : Colors.white70, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
                              );
                            }),
                        ],
                      ),
                    ),
                  ),
                ],
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
