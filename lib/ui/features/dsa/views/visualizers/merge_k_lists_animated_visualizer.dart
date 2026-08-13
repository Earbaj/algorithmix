import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';

class MergeKListsAnimatedVisualizer extends StatefulWidget {
  final bool isEnglish;

  const MergeKListsAnimatedVisualizer({
    super.key,
    required this.isEnglish,
  });

  @override
  State<MergeKListsAnimatedVisualizer> createState() =>
      _MergeKListsAnimatedVisualizerState();
}

class MergeStepData {
  final List<int> minHeapVals;
  final List<int> mergedOutput;
  final String titleEn;
  final String titleBn;
  final String explanationEn;
  final String explanationBn;

  const MergeStepData({
    required this.minHeapVals,
    required this.mergedOutput,
    required this.titleEn,
    required this.titleBn,
    required this.explanationEn,
    required this.explanationBn,
  });
}

class _MergeKListsAnimatedVisualizerState
    extends State<MergeKListsAnimatedVisualizer> {
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  late final List<MergeStepData> _steps;

  @override
  void initState() {
    super.initState();
    _steps = const [
      MergeStepData(
        minHeapVals: [1, 1, 2],
        mergedOutput: [],
        titleEn: "1. Push Heads of K Lists into Min-Heap",
        titleBn: "১. K টি সর্টেড লিস্টের হেড Min-Heap এ পুশ",
        explanationEn: "Push head of L1 (1), L2 (1), L3 (2) into Min-Heap. Root = 1.",
        explanationBn: "L1 (1), L2 (1), L3 (2) এর প্রথম নোড হিপে পুশ। রুট = 1।",
      ),
      MergeStepData(
        minHeapVals: [1, 2, 4],
        mergedOutput: [1],
        titleEn: "2. Pop Min(1 from L1) -> Attach to Output & Push Next 4(L1)",
        titleBn: "২. পপ মিন 1(L1) -> আউটপুটে যুক্ত ও পরবর্তী 4(L1) পুশ",
        explanationEn: "Pop 1(L1), attach to merged list. Push next node 4(L1) into Heap.",
        explanationBn: "সর্বনিম্ন 1(L1) পপ করে রেজাল্টে যুক্ত। L1 এর পরের নোড 4 হিপে পুশ।",
      ),
      MergeStepData(
        minHeapVals: [2, 3, 4],
        mergedOutput: [1, 1],
        titleEn: "3. Pop Min(1 from L2) -> Attach to Output & Push Next 3(L2)",
        titleBn: "৩. পপ মিন 1(L2) -> আউটপুটে যুক্ত ও পরবর্তী 3(L2) পুশ",
        explanationEn: "Pop 1(L2), attach to merged list. Push next node 3(L2) into Heap.",
        explanationBn: "সর্বনিম্ন 1(L2) পপ করা হলো। L2 এর পরের নোড 3 হিপে পুশ।",
      ),
      MergeStepData(
        minHeapVals: [3, 4, 6],
        mergedOutput: [1, 1, 2],
        titleEn: "4. Pop Min(2 from L3) -> Attach & Push Next 6(L3)",
        titleBn: "৪. পপ মিন 2(L3) -> আউটপুটে যুক্ত ও পরবর্তী 6(L3) পুশ",
        explanationEn: "Pop 2(L3), attach to merged list. Push next node 6(L3). Merged: [1, 1, 2].",
        explanationBn: "সর্বনিম্ন 2(L3) পপ করা হলো। L3 এর পরের নোড 6 হিপে পুশ।",
      ),
      MergeStepData(
        minHeapVals: [],
        mergedOutput: [1, 1, 2, 3, 4, 4, 5, 6],
        titleEn: "5. Process All Nodes -> Merged List Complete! 🎉",
        titleBn: "৫. সমস্ত নোড প্রসেস শেষ -> সর্টেড লিঙ্কড লিস্ট সম্পূর্ণ! 🎉",
        explanationEn: "Repeatedly extract minimum and push next nodes until heap is empty! Final Merged: [1, 1, 2, 3, 4, 4, 5, 6]! 🎉",
        explanationBn: "হিপ খালি না হওয়া পর্যন্ত সর্বনিম্ন নোড পপ ও নেক্সট ইনসার্ট করে ফাইনাল সর্টেড লিস্ট তৈরি! 🎉",
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
              const Icon(Icons.alt_route, color: Color(0xFF84CC16), size: 24),
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

        // Visual Display of Input K Lists, Min Heap, & Merged Output
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
              const Text("Active Min-Heap Front Nodes:", style: TextStyle(color: Color(0xFF84CC16), fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: step.minHeapVals.isEmpty
                      ? [const Text("Heap is Empty", style: TextStyle(color: Colors.white54, fontSize: 12))]
                      : List.generate(step.minHeapVals.length, (idx) {
                          final isRoot = idx == 0;
                          return Container(
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: isRoot ? AppTheme.accentGreen.withOpacity(0.2) : AppTheme.surfaceDark,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: isRoot ? AppTheme.accentGreen : const Color(0xFF334155)),
                            ),
                            child: Text(
                              "Node(${step.minHeapVals[idx]})",
                              style: TextStyle(
                                color: isRoot ? AppTheme.accentGreen : Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'monospace',
                              ),
                            ),
                          );
                        }),
                ),
              ),
              const SizedBox(height: 20),

              // Merged Linked List Output Array
              const Text("Merged Sorted Linked List Result:", style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: step.mergedOutput.isEmpty
                      ? [const Text("Output is empty", style: TextStyle(color: Colors.white54, fontSize: 12))]
                      : List.generate(step.mergedOutput.length, (idx) {
                          return Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                decoration: BoxDecoration(
                                  color: AppTheme.accentGreen.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: AppTheme.accentGreen),
                                ),
                                child: Text(
                                  "${step.mergedOutput[idx]}",
                                  style: const TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontFamily: 'monospace'),
                                ),
                              ),
                              if (idx < step.mergedOutput.length - 1)
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 4),
                                  child: Icon(Icons.arrow_right_alt, color: AppTheme.accentGreen, size: 18),
                                ),
                            ],
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
