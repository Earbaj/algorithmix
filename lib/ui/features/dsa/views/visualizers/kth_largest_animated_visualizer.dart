import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';

class KthLargestAnimatedVisualizer extends StatefulWidget {
  final bool isEnglish;

  const KthLargestAnimatedVisualizer({
    super.key,
    required this.isEnglish,
  });

  @override
  State<KthLargestAnimatedVisualizer> createState() =>
      _KthLargestAnimatedVisualizerState();
}

class HeapStepData {
  final int currentArrayIdx;
  final int currentNum;
  final List<int> minHeap;
  final int? poppedVal;
  final String titleEn;
  final String titleBn;
  final String explanationEn;
  final String explanationBn;

  const HeapStepData({
    required this.currentArrayIdx,
    required this.currentNum,
    required this.minHeap,
    this.poppedVal,
    required this.titleEn,
    required this.titleBn,
    required this.explanationEn,
    required this.explanationBn,
  });
}

class _KthLargestAnimatedVisualizerState
    extends State<KthLargestAnimatedVisualizer> {
  final List<int> _nums = const [3, 2, 1, 5, 6, 4];
  final int _k = 2;

  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  late final List<HeapStepData> _steps;

  @override
  void initState() {
    super.initState();
    _steps = const [
      HeapStepData(
        currentArrayIdx: 0,
        currentNum: 3,
        minHeap: [3],
        poppedVal: null,
        titleEn: "1. Push num = 3 into Min-Heap",
        titleBn: "১. Min-Heap এ ৩ পুশ করি",
        explanationEn: "Push 3 into Min-Heap. Size = 1 <= K(2). Min-Heap: [3].",
        explanationBn: "Min-Heap এ ৩ পুশ। সাইজ ১ <= K(২)। হিপ: [3]।",
      ),
      HeapStepData(
        currentArrayIdx: 1,
        currentNum: 2,
        minHeap: [2, 3],
        poppedVal: null,
        titleEn: "2. Push num = 2 into Min-Heap",
        titleBn: "২. Min-Heap এ ২ পুশ করি",
        explanationEn: "Push 2 into Min-Heap. Bubble Up places 2 at root [0]. Size = 2 <= K(2). Min-Heap: [2, 3].",
        explanationBn: "Min-Heap এ ২ পুশ। বাবল-আপ করে ২ কে রুটে রাখা হলো। সাইজ ২ <= K(২)। হিপ: [2, 3]।",
      ),
      HeapStepData(
        currentArrayIdx: 2,
        currentNum: 1,
        minHeap: [2, 3],
        poppedVal: 1,
        titleEn: "3. Push num = 1 -> Size(3) > K(2)! Pop Min (1)",
        titleBn: "৩. ১ পুশ -> সাইজ(৩) > K(২)! পপ মিন (১)",
        explanationEn: "Push 1 -> Heap size becomes 3! Pop minimum root 1 in O(log K). Heap retains [2, 3].",
        explanationBn: "১ পুশ করার পর হিপ সাইজ ৩ পার হয়! সর্বনিম্ন রুট ১ পপ করে সাইজ K(২) রাখা হলো। হিপ: [2, 3]।",
      ),
      HeapStepData(
        currentArrayIdx: 3,
        currentNum: 5,
        minHeap: [3, 5],
        poppedVal: 2,
        titleEn: "4. Push num = 5 -> Size(3) > K(2)! Pop Min (2)",
        titleBn: "৪. ৫ পুশ -> সাইজ(৩) > K(২)! পপ মিন (২)",
        explanationEn: "Push 5 -> Heap size 3! Pop minimum root 2. Heap retains 2 largest elements so far: [3, 5].",
        explanationBn: "৫ পুশ করে সাইজ ৩ হলে সর্বনিম্ন ২ পপ করা হলো। বর্তমানে ২ টি বৃহত্তম মান জমা রয়েছে: [3, 5]।",
      ),
      HeapStepData(
        currentArrayIdx: 4,
        currentNum: 6,
        minHeap: [5, 6],
        poppedVal: 3,
        titleEn: "5. Push num = 6 -> Size(3) > K(2)! Pop Min (3)",
        titleBn: "৫. ৬ পুশ -> সাইজ(৩) > K(২)! পপ মিন (৩)",
        explanationEn: "Push 6 -> Heap size 3! Pop minimum root 3. Heap retains [5, 6].",
        explanationBn: "৬ পুশ করে সর্বনিম্ন ৩ পপ করা হলো। হিপ জমা রেখেছে: [5, 6]।",
      ),
      HeapStepData(
        currentArrayIdx: 5,
        currentNum: 4,
        minHeap: [5, 6],
        poppedVal: 4,
        titleEn: "6. Push num = 4 -> Pop Min (4) -> Kth Largest = Top(5)! 🎉",
        titleBn: "৬. ৪ পুশ -> পপ (৪) -> K-তম বৃহত্তম উপাদান = Top(5)! 🎉",
        explanationEn: "Push 4 -> Pop min 4! Loop ends! Min-Heap root `[0]` = 5 is the Kth Largest Element! 🎉",
        explanationBn: "৪ পুশ করার পর পপ করে হিপের টপ মান minHeap[0] = 5 পাওয়া গেল, যা ২-তম বৃহত্তম উপাদান! 🎉",
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
              const Icon(Icons.unfold_more_double, color: Color(0xFF84CC16), size: 24),
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

        // Visual Display of Input Array and Min Heap Storage
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
                  const Text("Input Array Nums:", style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                  Text("Target K = $_k", style: const TextStyle(color: AppTheme.accentNeonCyan, fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
                ],
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(_nums.length, (idx) {
                    final isCurrent = idx == step.currentArrayIdx;
                    return Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: isCurrent ? const Color(0xFF84CC16).withOpacity(0.3) : AppTheme.surfaceDark,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: isCurrent ? const Color(0xFF84CC16) : const Color(0xFF334155), width: isCurrent ? 2 : 1),
                      ),
                      child: Text(
                        "${_nums[idx]}",
                        style: TextStyle(
                          color: isCurrent ? const Color(0xFF84CC16) : Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'monospace',
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 20),

              // Min Heap Representation
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Min-Heap Storage (Size <= K):", style: TextStyle(color: Color(0xFF84CC16), fontSize: 13, fontWeight: FontWeight.bold)),
                  if (step.poppedVal != null)
                    Text("Popped Min: ${step.poppedVal}", style: const TextStyle(color: Colors.redAccent, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
                ],
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(step.minHeap.length, (hIdx) {
                    final isRoot = hIdx == 0;
                    return Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: isRoot ? AppTheme.accentGreen.withOpacity(0.2) : const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: isRoot ? AppTheme.accentGreen : const Color(0xFF334155), width: isRoot ? 2 : 1),
                      ),
                      child: Column(
                        children: [
                          Text("idx [$hIdx]", style: TextStyle(color: isRoot ? AppTheme.accentGreen : Colors.white54, fontSize: 10, fontFamily: 'monospace')),
                          const SizedBox(height: 4),
                          Text(
                            "${step.minHeap[hIdx]}",
                            style: TextStyle(
                              color: isRoot ? AppTheme.accentGreen : Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontFamily: 'monospace',
                            ),
                          ),
                          if (isRoot)
                            const Text("MIN ROOT", style: TextStyle(color: AppTheme.accentGreen, fontSize: 9, fontWeight: FontWeight.bold)),
                        ],
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
            style: const TextStyle(color: Color(0xFF84CC16), fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
