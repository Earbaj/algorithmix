import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';

class NextGreaterElementAnimatedVisualizer extends StatefulWidget {
  final bool isEnglish;

  const NextGreaterElementAnimatedVisualizer({
    super.key,
    required this.isEnglish,
  });

  @override
  State<NextGreaterElementAnimatedVisualizer> createState() =>
      _NextGreaterElementAnimatedVisualizerState();
}

class NgeStepData {
  final int currIndex;
  final int currVal;
  final List<int> stackItems;
  final Map<int, int> resMap; // index -> NGE
  final String titleEn;
  final String titleBn;
  final String explanationEn;
  final String explanationBn;

  const NgeStepData({
    required this.currIndex,
    required this.currVal,
    required this.stackItems,
    required this.resMap,
    required this.titleEn,
    required this.titleBn,
    required this.explanationEn,
    required this.explanationBn,
  });
}

class _NextGreaterElementAnimatedVisualizerState
    extends State<NextGreaterElementAnimatedVisualizer> {
  final List<int> _arr = const [2, 1, 2, 4, 3];

  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  late final List<NgeStepData> _steps;

  @override
  void initState() {
    super.initState();
    _steps = const [
      NgeStepData(
        currIndex: -1,
        currVal: -1,
        stackItems: [],
        resMap: {},
        titleEn: "1. Initialization",
        titleBn: "১. সূচনা (Initialization)",
        explanationEn: "Array = [2, 1, 2, 4, 3]. Initialize Monotonic Stack. Traverse Right-to-Left.",
        explanationBn: "অ্যারে = [2, 1, 2, 4, 3]। মনোটোনিক স্ট্যাক নিয়ে ডান থেকে বামে ট্রাভার্স করব।",
      ),
      NgeStepData(
        currIndex: 4,
        currVal: 3,
        stackItems: [3],
        resMap: {4: -1},
        titleEn: "2. Index 4 (val = 3)",
        titleBn: "২. ইনডেক্স ৪ (মান = ৩)",
        explanationEn: "Element 3: Stack empty -> NGE for 3 is -1. Push 3 onto Stack.",
        explanationBn: "উপাদান ৩: স্ট্যাক খালি থাকায় ৩ এর NGE = -1। ৩ কে স্ট্যাকে পুশ করি।",
      ),
      NgeStepData(
        currIndex: 3,
        currVal: 4,
        stackItems: [4],
        resMap: {4: -1, 3: -1},
        titleEn: "3. Index 3 (val = 4)",
        titleBn: "৩. ইনডেক্স ৩ (মান = ৪)",
        explanationEn: "Element 4: Pop 3 from Stack (since 3 <= 4). Stack becomes empty -> NGE for 4 is -1. Push 4.",
        explanationBn: "উপাদান ৪: স্ট্যাক থেকে ৩ পপ হলো (কারণ ৩ <= ৪)। স্ট্যাক খালি -> NGE = -1। ৪ পুশ করি।",
      ),
      NgeStepData(
        currIndex: 2,
        currVal: 2,
        stackItems: [4, 2],
        resMap: {4: -1, 3: -1, 2: 4},
        titleEn: "4. Index 2 (val = 2)",
        titleBn: "৪. ইনডেক্স ২ (মান = ২)",
        explanationEn: "Element 2: Stack Top is 4 (4 > 2) -> NGE for 2 is 4! Push 2 onto Stack.",
        explanationBn: "উপাদান ২: স্ট্যাকের টপ ৪ (৪ > ২) -> ২ এর NGE = ৪! ২ কে স্ট্যাকে পুশ করি।",
      ),
      NgeStepData(
        currIndex: 1,
        currVal: 1,
        stackItems: [4, 2, 1],
        resMap: {4: -1, 3: -1, 2: 4, 1: 2},
        titleEn: "5. Index 1 (val = 1)",
        titleBn: "৫. ইনডেক্স ১ (মান = ১)",
        explanationEn: "Element 1: Stack Top is 2 (2 > 1) -> NGE for 1 is 2! Push 1 onto Stack.",
        explanationBn: "উপাদান ১: স্ট্যাকের টপ ২ (২ > ১) -> ১ এর NGE = ২! ১ কে স্ট্যাকে পুশ করি।",
      ),
      NgeStepData(
        currIndex: 0,
        currVal: 2,
        stackItems: [4, 2],
        resMap: {4: -1, 3: -1, 2: 4, 1: 2, 0: 4},
        titleEn: "6. Index 0 (val = 2)",
        titleBn: "৬. ইনডেক্স ০ (মান = ২)",
        explanationEn: "Element 2: Pop 1 (1 <= 2). Top is now 2 (2 <= 2), Pop 2. Top is now 4 (4 > 2) -> NGE for 2 is 4! Push 2. 🎉",
        explanationBn: "উপাদান ২: ছোট মান ১ ও ২ পপ হলো। টপে থাকা ৪ (৪ > ২) ই NGE = ৪! ২ কে স্ট্যাকে পুশ। 🎉",
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
              const Icon(Icons.trending_up, color: AppTheme.accentNeonCyan, size: 24),
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

        // Visual Monotonic Stack & Array Canvas
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
              // Array & NGE Row
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_arr.length, (idx) {
                    final isCurrent = step.currIndex == idx;
                    final ngeVal = step.resMap[idx];

                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isCurrent ? AppTheme.accentNeonCyan.withOpacity(0.2) : const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: isCurrent ? AppTheme.accentNeonCyan : const Color(0xFF334155), width: isCurrent ? 2 : 1),
                      ),
                      child: Column(
                        children: [
                          Text("idx $idx", style: const TextStyle(color: AppTheme.textMuted, fontSize: 10)),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(color: AppTheme.surfaceDark, borderRadius: BorderRadius.circular(6)),
                            child: Text("${_arr[idx]}", style: TextStyle(color: isCurrent ? AppTheme.accentNeonCyan : Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: AppTheme.accentGreen.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
                            child: Text(
                              ngeVal == null ? "NGE = ?" : "NGE = $ngeVal",
                              style: const TextStyle(color: AppTheme.accentGreen, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 20),

              // Vertical Monotonic Stack Bucket
              Container(
                width: 130,
                height: 170,
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(14), bottomRight: Radius.circular(14)),
                  border: Border(
                    left: BorderSide(color: AppTheme.accentGreen, width: 3),
                    right: BorderSide(color: AppTheme.accentGreen, width: 3),
                    bottom: BorderSide(color: AppTheme.accentGreen, width: 4),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      color: AppTheme.accentGreen.withOpacity(0.15),
                      child: const Text("TOP (NGE Candidate)", textAlign: TextAlign.center, style: TextStyle(color: AppTheme.accentGreen, fontSize: 9, fontWeight: FontWeight.bold)),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: SingleChildScrollView(
                          reverse: true,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (step.stackItems.isEmpty)
                                const Padding(padding: EdgeInsets.only(bottom: 20), child: Text("EMPTY", style: TextStyle(color: AppTheme.textMuted, fontSize: 10)))
                              else
                                ...List.generate(step.stackItems.length, (idx) {
                                  final itemIdx = step.stackItems.length - 1 - idx;
                                  final val = step.stackItems[itemIdx];
                                  final isTop = itemIdx == step.stackItems.length - 1;

                                  return Container(
                                    margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                                    padding: const EdgeInsets.symmetric(vertical: 5),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: isTop ? AppTheme.accentGreen.withOpacity(0.3) : AppTheme.surfaceDark,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: isTop ? AppTheme.accentGreen : const Color(0xFF334155)),
                                    ),
                                    child: Text(
                                      "$val",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontFamily: 'monospace', color: isTop ? AppTheme.accentGreen : Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
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
              const SizedBox(height: 14),
              Text(
                widget.isEnglish ? "Monotonic Decreasing Stack: Pops smaller elements, leaving Next Greater Element on top" : "মনোটোনিক স্ট্যাক: ছোট উপাদান পপ করে বড় উপাদানকে টপে সংরক্ষণ করে",
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
              backgroundColor: AppTheme.accentNeonCyan,
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
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
