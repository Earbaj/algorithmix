import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';

class TwoSumAnimatedVisualizer extends StatefulWidget {
  final bool isEnglish;

  const TwoSumAnimatedVisualizer({
    super.key,
    required this.isEnglish,
  });

  @override
  State<TwoSumAnimatedVisualizer> createState() =>
      _TwoSumAnimatedVisualizerState();
}

class TwoSumStepData {
  final int currentIndex;
  final int currentNum;
  final int complement;
  final Map<int, int> hashMap; // num -> index
  final List<int>? resultIndices;
  final String titleEn;
  final String titleBn;
  final String explanationEn;
  final String explanationBn;

  const TwoSumStepData({
    required this.currentIndex,
    required this.currentNum,
    required this.complement,
    required this.hashMap,
    this.resultIndices,
    required this.titleEn,
    required this.titleBn,
    required this.explanationEn,
    required this.explanationBn,
  });
}

class _TwoSumAnimatedVisualizerState extends State<TwoSumAnimatedVisualizer> {
  final List<int> _nums = const [2, 7, 11, 15];
  final int _target = 9;

  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  late final List<TwoSumStepData> _steps;

  @override
  void initState() {
    super.initState();
    _steps = const [
      TwoSumStepData(
        currentIndex: -1,
        currentNum: 0,
        complement: 0,
        hashMap: {},
        resultIndices: null,
        titleEn: "1. Initialization (Target = 9)",
        titleBn: "১. সূচনা (টার্গেট = 9)",
        explanationEn: "Array = [2, 7, 11, 15], Target = 9. Initialize empty Hash Map `mp` (num -> index).",
        explanationBn: "অ্যারে = [2, 7, 11, 15], টার্গেট = 9। ফাঁকা হ্যাশ ম্যাপ সূচনা করি।",
      ),
      TwoSumStepData(
        currentIndex: 0,
        currentNum: 2,
        complement: 7,
        hashMap: {2: 0},
        resultIndices: null,
        titleEn: "2. i = 0 (num = 2) -> Complement 7 not found",
        titleBn: "২. i = 0 (সংখ্যা = 2) -> পরিপূরক 7 পাওয়া যায়নি",
        explanationEn: "Target 9 - 2 = 7. Search 7 in Hash Map: NOT FOUND! Store `mp[2] = 0`.",
        explanationBn: "টার্গেট 9 - 2 = 7। হ্যাশ ম্যাপে 7 পাওয়া যায়নি! `mp[2] = 0` সেভ করি।",
      ),
      TwoSumStepData(
        currentIndex: 1,
        currentNum: 7,
        complement: 2,
        hashMap: {2: 0},
        resultIndices: [0, 1],
        titleEn: "3. i = 1 (num = 7) -> Complement 2 FOUND in Hash Map! 🎉",
        titleBn: "৩. i = 1 (সংখ্যা = 7) -> পরিপূরক 2 হ্যাশ ম্যাপে পাওয়া গেছে! 🎉",
        explanationEn: "Target 9 - 7 = 2. Search 2 in Hash Map: FOUND at index 0! Return Pair Indices [0, 1] in O(N) time! 🎉",
        explanationBn: "টার্গেট 9 - 7 = 2। হ্যাশ ম্যাপে 2 ইনডেক্স ০ তে পাওয়া গেছে! ইনডেক্স জোড়া [0, 1] রিটার্ন (O(N))! 🎉",
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
            color: AppTheme.accentPink.withOpacity(0.12),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.accentPink.withOpacity(0.5)),
          ),
          child: Row(
            children: [
              const Icon(Icons.grid_view_outlined, color: AppTheme.accentPink, size: 24),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.isEnglish ? step.titleEn : step.titleBn,
                      style: const TextStyle(color: AppTheme.accentPink, fontWeight: FontWeight.bold, fontSize: 14),
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

        // Array & Hash Map Visual Canvas
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
              Text(
                widget.isEnglish ? "Input Array (nums):" : "ইনপুট অ্যারে (nums):",
                style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // Array elements row
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(_nums.length, (idx) {
                    final isCurrent = step.currentIndex == idx;
                    final isFoundResult = step.resultIndices != null && step.resultIndices!.contains(idx);

                    return Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isFoundResult
                            ? AppTheme.accentGreen.withOpacity(0.3)
                            : (isCurrent ? AppTheme.accentPink.withOpacity(0.3) : AppTheme.surfaceDark),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isFoundResult
                              ? AppTheme.accentGreen
                              : (isCurrent ? AppTheme.accentPink : const Color(0xFF334155)),
                          width: isFoundResult || isCurrent ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text("idx $idx", style: const TextStyle(color: AppTheme.textMuted, fontSize: 10)),
                          const SizedBox(height: 4),
                          Text("${_nums[idx]}", style: TextStyle(color: isFoundResult ? AppTheme.accentGreen : Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                        ],
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 20),

              // Hash Map Key-Value Bucket Table
              Text(
                widget.isEnglish ? "Hash Map Store (num -> index):" : "হ্যাশ ম্যাপ স্টোর (সংখ্যা -> ইনডেক্স):",
                style: const TextStyle(color: AppTheme.accentPink, fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.accentPink.withOpacity(0.4)),
                ),
                child: step.hashMap.isEmpty
                    ? Text(widget.isEnglish ? "[ Hash Map is Empty ]" : "[ হ্যাশ ম্যাপ খালি ]", style: const TextStyle(color: AppTheme.textMuted, fontSize: 11, fontStyle: FontStyle.italic))
                    : Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: step.hashMap.entries.map((entry) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppTheme.accentPink.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppTheme.accentPink),
                            ),
                            child: Text(
                              "key: ${entry.key} => index: ${entry.value}",
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12, fontFamily: 'monospace'),
                            ),
                          );
                        }).toList(),
                      ),
              ),
              const SizedBox(height: 14),

              if (step.resultIndices != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppTheme.accentGreen.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppTheme.accentGreen),
                  ),
                  child: Text(
                    "Result Pair Indices = ${step.resultIndices} (values: ${_nums[step.resultIndices![0]]} + ${_nums[step.resultIndices![1]]} = 9)",
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
              backgroundColor: AppTheme.accentPink,
              foregroundColor: Colors.white,
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
            style: const TextStyle(color: AppTheme.accentPink, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
