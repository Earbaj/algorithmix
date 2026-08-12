import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';

class FirstNonRepeatingAnimatedVisualizer extends StatefulWidget {
  final bool isEnglish;

  const FirstNonRepeatingAnimatedVisualizer({
    super.key,
    required this.isEnglish,
  });

  @override
  State<FirstNonRepeatingAnimatedVisualizer> createState() =>
      _FirstNonRepeatingAnimatedVisualizerState();
}

class StreamStepData {
  final String charArrived;
  final List<String> queueItems; // Front to Rear
  final String firstNonRepeating;
  final String titleEn;
  final String titleBn;
  final String explanationEn;
  final String explanationBn;

  const StreamStepData({
    required this.charArrived,
    required this.queueItems,
    required this.firstNonRepeating,
    required this.titleEn,
    required this.titleBn,
    required this.explanationEn,
    required this.explanationBn,
  });
}

class _FirstNonRepeatingAnimatedVisualizerState
    extends State<FirstNonRepeatingAnimatedVisualizer> {
  final String _streamInput = "aabccxb";

  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  late final List<StreamStepData> _steps;

  @override
  void initState() {
    super.initState();
    _steps = const [
      StreamStepData(
        charArrived: "-",
        queueItems: [],
        firstNonRepeating: "-",
        titleEn: "1. Initialization",
        titleBn: "১. সূচনা (Initialization)",
        explanationEn: "Stream = \"aabccxb\". Initialize empty FIFO Queue and Frequency Map.",
        explanationBn: "স্ট্রিম = \"aabccxb\"। ফাঁকা FIFO কিউ ও ফ্রিকোয়েন্সি ম্যাপ তৈরি করি।",
      ),
      StreamStepData(
        charArrived: "a",
        queueItems: ["a"],
        firstNonRepeating: "a",
        titleEn: "2. Char 'a' arrives (freq['a'] = 1)",
        titleBn: "২. বর্ণ 'a' এসেছে (freq['a'] = 1)",
        explanationEn: "'a' frequency is 1. Push 'a' onto Queue. Front is 'a'!",
        explanationBn: "'a' এর ফ্রিকোয়েন্সি ১। 'a' কিউতে এনকিউ হয়। ফ্রন্ট মান = 'a'!",
      ),
      StreamStepData(
        charArrived: "a",
        queueItems: [],
        firstNonRepeating: "#",
        titleEn: "3. Char 'a' arrives (freq['a'] = 2) -> Pop duplicates!",
        titleBn: "৩. বর্ণ 'a' এসেছে (freq['a'] = 2) -> ডুপ্লিকেট পপ!",
        explanationEn: "'a' frequency becomes 2 (duplicate). Pop 'a' from Queue. Queue empty -> Result = '#'.",
        explanationBn: "'a' এর ফ্রিকোয়েন্সি ২ (অনাবৃত্ত নয়)। কিউ থেকে 'a' পপ হয়। কিউ ফাঁকা -> ফলাফল = '#'।",
      ),
      StreamStepData(
        charArrived: "b",
        queueItems: ["b"],
        firstNonRepeating: "b",
        titleEn: "4. Char 'b' arrives (freq['b'] = 1)",
        titleBn: "৪. বর্ণ 'b' এসেছে (freq['b'] = 1)",
        explanationEn: "'b' frequency is 1. Push 'b' onto Queue. Front is 'b'!",
        explanationBn: "'b' এর ফ্রিকোয়েন্সি ১। 'b' কিউতে এনকিউ হয়। ফ্রন্ট মান = 'b'!",
      ),
      StreamStepData(
        charArrived: "c",
        queueItems: ["b", "c"],
        firstNonRepeating: "b",
        titleEn: "5. Char 'c' arrives (freq['c'] = 1)",
        titleBn: "৫. বর্ণ 'c' এসেছে (freq['c'] = 1)",
        explanationEn: "'c' frequency is 1. Push 'c' onto Queue. Front remains 'b'!",
        explanationBn: "'c' এর ফ্রিকোয়েন্সি ১। 'c' কিউতে এনকিউ হয়। ফ্রন্ট এখনও 'b'!",
      ),
      StreamStepData(
        charArrived: "x",
        queueItems: ["b", "c", "x"],
        firstNonRepeating: "b",
        titleEn: "6. Char 'x' arrives (freq['x'] = 1)",
        titleBn: "৬. বর্ণ 'x' এসেছে (freq['x'] = 1)",
        explanationEn: "'x' frequency is 1. Push 'x' onto Queue. Front remains 'b'!",
        explanationBn: "'x' এর ফ্রিকোয়েন্সি ১। 'x' কিউতে এনকিউ হয়। ফ্রন্ট এখনও 'b'!",
      ),
      StreamStepData(
        charArrived: "b",
        queueItems: ["x"],
        firstNonRepeating: "x",
        titleEn: "7. Char 'b' arrives (freq['b'] = 2) -> Evict 'b' & 'c' -> Front is 'x'! 🎉",
        titleBn: "৭. বর্ণ 'b' এসেছে (freq['b'] = 2) -> 'b' ও 'c' বাতিল -> ফ্রন্ট 'x'! 🎉",
        explanationEn: "'b' frequency becomes 2. Pop duplicated 'b' and duplicated 'c' from Queue. Front becomes 'x'! 🎉",
        explanationBn: "'b' এর ফ্রিকোয়েন্সি ২ হয়। কিউ থেকে ডুপ্লিকেট 'b' ও 'c' পপ হয়ে ফ্রন্টে 'x' উন্মুক্ত হলো! 🎉",
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
              const Icon(Icons.record_voice_over, color: AppTheme.accentAmber, size: 24),
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

        // Horizontal Queue Stream Pipe Canvas
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
              // Stream input row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.isEnglish ? "Character Stream: " : "বর্ণের স্ট্রিম: ",
                    style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: List.generate(_streamInput.length, (idx) {
                      final c = _streamInput[idx];
                      final isCurrent = step.charArrived == c;

                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isCurrent ? AppTheme.accentAmber.withOpacity(0.3) : const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: isCurrent ? AppTheme.accentAmber : const Color(0xFF334155)),
                        ),
                        child: Text(
                          c,
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isCurrent ? AppTheme.accentAmber : Colors.white70,
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // HORIZONTAL QUEUE PIPE
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTheme.accentAmber, width: 2),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildBadge("FRONT (Exit)", AppTheme.accentGreen),
                        _buildBadge("REAR (Entry ⬅️)", AppTheme.accentAmber),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          if (step.queueItems.isEmpty)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                              child: Text("[ QUEUE EMPTY -> Output '#' ]", style: TextStyle(color: AppTheme.textMuted, fontSize: 11, fontStyle: FontStyle.italic)),
                            )
                          else
                            ...List.generate(step.queueItems.length, (idx) {
                              final item = step.queueItems[idx];
                              final isFront = idx == 0;

                              return Container(
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                decoration: BoxDecoration(
                                  color: isFront ? AppTheme.accentGreen.withOpacity(0.3) : AppTheme.surfaceDark,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: isFront ? AppTheme.accentGreen : const Color(0xFF334155), width: isFront ? 2 : 1),
                                ),
                                child: Text(
                                  item,
                                  style: TextStyle(fontFamily: 'monospace', fontSize: 16, fontWeight: FontWeight.bold, color: isFront ? AppTheme.accentGreen : Colors.white),
                                ),
                              );
                            }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Result Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.accentGreen.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.accentGreen),
                ),
                child: Text(
                  "1st Non-Repeating Char = '${step.firstNonRepeating}'",
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

  Widget _buildBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(4), border: Border.all(color: color)),
      child: Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
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
