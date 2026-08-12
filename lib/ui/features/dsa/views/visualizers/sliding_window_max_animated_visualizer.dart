import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';

class SlidingWindowMaxAnimatedVisualizer extends StatefulWidget {
  final bool isEnglish;

  const SlidingWindowMaxAnimatedVisualizer({
    super.key,
    required this.isEnglish,
  });

  @override
  State<SlidingWindowMaxAnimatedVisualizer> createState() =>
      _SlidingWindowMaxAnimatedVisualizerState();
}

class SwmStepData {
  final int windowStart;
  final int windowEnd;
  final List<int> dequeIndices; // Front to Back
  final List<int> maxResults;
  final String titleEn;
  final String titleBn;
  final String explanationEn;
  final String explanationBn;

  const SwmStepData({
    required this.windowStart,
    required this.windowEnd,
    required this.dequeIndices,
    required this.maxResults,
    required this.titleEn,
    required this.titleBn,
    required this.explanationEn,
    required this.explanationBn,
  });
}

class _SlidingWindowMaxAnimatedVisualizerState
    extends State<SlidingWindowMaxAnimatedVisualizer> {
  final List<int> _nums = const [1, 3, -1, -3, 5, 3, 6, 7];
  final int _k = 3;

  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  late final List<SwmStepData> _steps;

  @override
  void initState() {
    super.initState();
    _steps = const [
      SwmStepData(
        windowStart: 0,
        windowEnd: 0,
        dequeIndices: [0],
        maxResults: [],
        titleEn: "1. i = 0 (val = 1)",
        titleBn: "১. i = 0 (মান = 1)",
        explanationEn: "Push index 0 into Deque. Deque = [0 (val 1)]. Window size < 3, no output yet.",
        explanationBn: "ইনডেক্স ০ ডিকিউতে পুশ। ডিকিউ = [0 (মান 1)]। উইন্ডো এখনও ৩ হয়নি।",
      ),
      SwmStepData(
        windowStart: 0,
        windowEnd: 1,
        dequeIndices: [1],
        maxResults: [],
        titleEn: "2. i = 1 (val = 3) -> Pop back index 0",
        titleBn: "২. i = 1 (মান = 3) -> পপ ব্যাক ইনডেক্স ০",
        explanationEn: "val 3 > val 1 at index 0. Pop index 0 from Back. Push index 1. Deque = [1 (val 3)].",
        explanationBn: "মান ৩ > ১ হওয়ায় ব্যাক থেকে ইনডেক্স ০ পপ হলো। ইনডেক্স ১ পুশ। ডিকিউ = [1 (মান 3)]।",
      ),
      SwmStepData(
        windowStart: 0,
        windowEnd: 2,
        dequeIndices: [1, 2],
        maxResults: [3],
        titleEn: "3. Window [1, 3, -1] -> Max = 3 🎉",
        titleBn: "৩. উইন্ডো [1, 3, -1] -> ম্যাক্স = 3 🎉",
        explanationEn: "Push index 2. Window 1 complete! Deque Front = index 1 (val 3). Max = 3!",
        explanationBn: "ইনডেক্স ২ পুশ। প্রথম উইন্ডো পূর্ণ! ডিকিউ ফ্রন্ট = ১ (মান ৩)। ম্যাক্স = ৩!",
      ),
      SwmStepData(
        windowStart: 1,
        windowEnd: 3,
        dequeIndices: [1, 2, 3],
        maxResults: [3, 3],
        titleEn: "4. Window [3, -1, -3] -> Max = 3 🎉",
        titleBn: "৪. উইন্ডো [3, -1, -3] -> ম্যাক্স = 3 🎉",
        explanationEn: "Push index 3. Window slides [3, -1, -3]. Deque Front = index 1 (val 3). Max = 3!",
        explanationBn: "উইন্ডো সরে [3, -1, -3]। ডিকিউ ফ্রন্ট = ১ (মান ৩)। ম্যাক্স = ৩!",
      ),
      SwmStepData(
        windowStart: 2,
        windowEnd: 4,
        dequeIndices: [4],
        maxResults: [3, 3, 5],
        titleEn: "5. Window [-1, -3, 5] -> Max = 5 🎉",
        titleBn: "৫. উইন্ডো [-1, -3, 5] -> ম্যাক্স = 5 🎉",
        explanationEn: "val 5 clears smaller indices. Deque Front = index 4 (val 5). Max = 5!",
        explanationBn: "মান ৫ ডিকের সব ছোট ইনডেক্স সরিয়ে ফেলে। ফ্রন্ট = ৪ (মান ৫)। ম্যাক্স = ৫!",
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
            color: AppTheme.accentAmber.withOpacity(0.12),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.accentAmber.withOpacity(0.5)),
          ),
          child: Row(
            children: [
              const Icon(Icons.view_headline, color: AppTheme.accentAmber, size: 24),
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

        // Monotonic Deque & Sliding Window Array Canvas
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
              // Sliding Window Array
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_nums.length, (idx) {
                    final inWindow = idx >= step.windowStart && idx <= step.windowEnd;

                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: inWindow ? AppTheme.accentAmber.withOpacity(0.25) : const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: inWindow ? AppTheme.accentAmber : const Color(0xFF334155), width: inWindow ? 2 : 1),
                      ),
                      child: Column(
                        children: [
                          Text("idx $idx", style: const TextStyle(color: AppTheme.textMuted, fontSize: 10)),
                          const SizedBox(height: 4),
                          Text("${_nums[idx]}", style: TextStyle(color: inWindow ? AppTheme.accentAmber : Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                        ],
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 18),

              // Double-Ended Queue (Deque) Pipe Frame
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTheme.accentNeonCyan, width: 2),
                ),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("FRONT (Max Candidate)", style: TextStyle(color: AppTheme.accentGreen, fontSize: 10, fontWeight: FontWeight.bold)),
                        Text("BACK (Push/Pop)", style: TextStyle(color: AppTheme.accentPink, fontSize: 10, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(step.dequeIndices.length, (idx) {
                          final arrayIndex = step.dequeIndices[idx];
                          final val = _nums[arrayIndex];
                          final isFront = idx == 0;

                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: isFront ? AppTheme.accentGreen.withOpacity(0.3) : AppTheme.surfaceDark,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: isFront ? AppTheme.accentGreen : const Color(0xFF334155)),
                            ),
                            child: Column(
                              children: [
                                Text("idx $arrayIndex", style: const TextStyle(color: AppTheme.textMuted, fontSize: 9)),
                                Text("$val", style: TextStyle(color: isFront ? AppTheme.accentGreen : Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Results Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.accentGreen.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.accentGreen),
                ),
                child: Text(
                  "Sliding Max Result = ${step.maxResults}",
                  style: const TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 13, fontFamily: 'monospace'),
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
