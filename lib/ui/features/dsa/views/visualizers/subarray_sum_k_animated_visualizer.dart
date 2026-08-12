import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';

class SubarraySumKAnimatedVisualizer extends StatefulWidget {
  final bool isEnglish;

  const SubarraySumKAnimatedVisualizer({
    super.key,
    required this.isEnglish,
  });

  @override
  State<SubarraySumKAnimatedVisualizer> createState() =>
      _SubarraySumKAnimatedVisualizerState();
}

class SubarrayStepData {
  final int currentIndex;
  final int currentNum;
  final int runningSum;
  final int matchNeeded;
  final int count;
  final Map<int, int> prefixMap;
  final String titleEn;
  final String titleBn;
  final String explanationEn;
  final String explanationBn;

  const SubarrayStepData({
    required this.currentIndex,
    required this.currentNum,
    required this.runningSum,
    required this.matchNeeded,
    required this.count,
    required this.prefixMap,
    required this.titleEn,
    required this.titleBn,
    required this.explanationEn,
    required this.explanationBn,
  });
}

class _SubarraySumKAnimatedVisualizerState
    extends State<SubarraySumKAnimatedVisualizer> {
  final List<int> _nums = const [1, 1, 1];
  final int _k = 2;

  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  late final List<SubarrayStepData> _steps;

  @override
  void initState() {
    super.initState();
    _steps = const [
      SubarrayStepData(
        currentIndex: -1,
        currentNum: 0,
        runningSum: 0,
        matchNeeded: 0,
        count: 0,
        prefixMap: {0: 1},
        titleEn: "1. Initialization (K = 2)",
        titleBn: "১. সূচনা (K = 2)",
        explanationEn: "Array = [1, 1, 1], K = 2. Initialize prefix sum map `mp = {0: 1}`, `sum = 0`, `count = 0`.",
        explanationBn: "অ্যারে = [1, 1, 1], K = 2। প্রেফিক্স সাম ম্যাপ `mp = {0: 1}`, `sum = 0`, `count = 0` সূচনা করি।",
      ),
      SubarrayStepData(
        currentIndex: 0,
        currentNum: 1,
        runningSum: 1,
        matchNeeded: -1,
        count: 0,
        prefixMap: {0: 1, 1: 1},
        titleEn: "2. Index 0 (num = 1) -> runningSum = 1",
        titleBn: "২. ইনডেক্স ০ (সংখ্যা = 1) -> রানিং সাম = 1",
        explanationEn: "sum = 1. Look for `sum - K` = 1 - 2 = -1 in map: Not found. Store `mp[1] = 1`.",
        explanationBn: "সাম = 1। ম্যাপে `sum - K` = 1 - 2 = -1 খোঁজা হলো: পাওয়া যায়নি। `mp[1] = 1` সেভ করি।",
      ),
      SubarrayStepData(
        currentIndex: 1,
        currentNum: 1,
        runningSum: 2,
        matchNeeded: 0,
        count: 1,
        prefixMap: {0: 1, 1: 1, 2: 1},
        titleEn: "3. Index 1 (num = 1) -> runningSum = 2 (Found Subarray! count=1)",
        titleBn: "৩. ইনডেক্স ১ (সংখ্যা = 1) -> রানিং সাম = 2 (সাবঅ্যারে মিলল! count=1)",
        explanationEn: "sum = 2. Look for `sum - K` = 2 - 2 = 0 in map: FOUND (freq 1)! Add to count -> count = 1.",
        explanationBn: "সাম = 2। ম্যাপে `sum - K` = 0 পাওয়া গেছে! count += 1 -> মোট সাবঅ্যারে = 1।",
      ),
      SubarrayStepData(
        currentIndex: 2,
        currentNum: 1,
        runningSum: 3,
        matchNeeded: 1,
        count: 2,
        prefixMap: {0: 1, 1: 1, 2: 1, 3: 1},
        titleEn: "4. Index 2 (num = 1) -> runningSum = 3 (Found Subarray! count=2) 🎉",
        titleBn: "৪. ইনডেক্স ২ (সংখ্যা = 1) -> রানিং সাম = 3 (দ্বিতীয় সাবঅ্যারে মিলল! count=2) 🎉",
        explanationEn: "sum = 3. Look for `sum - K` = 3 - 2 = 1 in map: FOUND (freq 1)! Add to count -> Total = 2 Subarrays! 🎉",
        explanationBn: "সাম = 3। ম্যাপে `sum - K` = 1 পাওয়া গেছে! count += 1 -> সর্বমোট ২ টি সাবঅ্যারে (Target K=2)! 🎉",
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
              const Icon(Icons.calculate_outlined, color: AppTheme.accentPink, size: 24),
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

        // Array & Prefix Sum Map Canvas
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
                  Text("nums = $_nums", style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 13, fontFamily: 'monospace')),
                  Text("Target K = $_k", style: const TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 13, fontFamily: 'monospace')),
                ],
              ),
              const SizedBox(height: 16),

              // Running stats row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatBadge("runningSum", "${step.runningSum}", AppTheme.accentNeonCyan),
                  _buildStatBadge("sum - K", "${step.matchNeeded}", AppTheme.accentAmber),
                  _buildStatBadge("count", "${step.count}", AppTheme.accentGreen),
                ],
              ),
              const SizedBox(height: 18),

              Text(
                widget.isEnglish ? "Prefix Sum Frequency Map (prefixSum -> freq):" : "প্রেফিক্স সাম ফ্রিকোয়েন্সি ম্যাপ:",
                style: const TextStyle(color: AppTheme.accentPink, fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: step.prefixMap.entries.map((entry) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.accentPink.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.accentPink),
                    ),
                    child: Text(
                      "sum ${entry.key} => freq: ${entry.value}",
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12, fontFamily: 'monospace'),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        _buildControls(),
      ],
    );
  }

  Widget _buildStatBadge(String label, String val, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color),
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(val, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
        ],
      ),
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
