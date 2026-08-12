import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';

class ValidAnagramAnimatedVisualizer extends StatefulWidget {
  final bool isEnglish;

  const ValidAnagramAnimatedVisualizer({
    super.key,
    required this.isEnglish,
  });

  @override
  State<ValidAnagramAnimatedVisualizer> createState() =>
      _ValidAnagramAnimatedVisualizerState();
}

class AnagramStepData {
  final String activePhase;
  final String activeChar;
  final Map<String, int> freqMap;
  final bool? isValidAnagram;
  final String titleEn;
  final String titleBn;
  final String explanationEn;
  final String explanationBn;

  const AnagramStepData({
    required this.activePhase,
    required this.activeChar,
    required this.freqMap,
    this.isValidAnagram,
    required this.titleEn,
    required this.titleBn,
    required this.explanationEn,
    required this.explanationBn,
  });
}

class _ValidAnagramAnimatedVisualizerState
    extends State<ValidAnagramAnimatedVisualizer> {
  final String _s = "anagram";
  final String _t = "nagaram";

  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  late final List<AnagramStepData> _steps;

  @override
  void initState() {
    super.initState();
    _steps = const [
      AnagramStepData(
        activePhase: "INIT",
        activeChar: "-",
        freqMap: {},
        isValidAnagram: null,
        titleEn: "1. Initialization",
        titleBn: "১. সূচনা (Initialization)",
        explanationEn: "Compare s = \"anagram\" and t = \"nagaram\". Lengths equal (7 == 7). Initialize Frequency Map.",
        explanationBn: "s = \"anagram\" এবং t = \"nagaram\" তুলনা। দৈর্ঘ্য সমান (৭ == ৭)। ফ্রিকোয়েন্সি ম্যাপ সূচনা করি।",
      ),
      AnagramStepData(
        activePhase: "COUNT_S",
        activeChar: "a,n,g,r,m",
        freqMap: {"a": 3, "n": 1, "g": 1, "r": 1, "m": 1},
        isValidAnagram: null,
        titleEn: "2. Count Frequencies for s = \"anagram\"",
        titleBn: "২. s = \"anagram\" এর ফ্রিকোয়েন্সি গণনা (+1)",
        explanationEn: "Increment frequencies for characters in 's': {'a': 3, 'n': 1, 'g': 1, 'r': 1, 'm': 1}.",
        explanationBn: "'s' এর ক্যারেক্টারের ফ্রিকোয়েন্সি বৃদ্ধি: {'a': 3, 'n': 1, 'g': 1, 'r': 1, 'm': 1}।",
      ),
      AnagramStepData(
        activePhase: "VERIFY_T",
        activeChar: "n,a,g,a,r,a,m",
        freqMap: {"a": 0, "n": 0, "g": 0, "r": 0, "m": 0},
        isValidAnagram: true,
        titleEn: "3. Decrement & Verify for t = \"nagaram\" -> VALID ANAGRAM 🎉",
        titleBn: "৩. t = \"nagaram\" এর ফ্রিকোয়েন্সি হ্রাস (-1) -> সঠিক এনগ্রাম 🎉",
        explanationEn: "Decrement frequencies for all characters in 't'. All frequency counts net to 0! Return True! 🎉",
        explanationBn: "'t' এর প্রতি অক্ষরের ফ্রিকোয়েন্সি হ্রাস। সব ব্যালেন্স ০ হওয়ায় এটি একটি সঠিক এনগ্রাম (True)! 🎉",
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
              const Icon(Icons.compare_arrows, color: AppTheme.accentPink, size: 24),
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

        // Visual Frequency Bucket Canvas
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
                  Text("s = \"$_s\"", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13, fontFamily: 'monospace')),
                  Text("t = \"$_t\"", style: const TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 13, fontFamily: 'monospace')),
                ],
              ),
              const SizedBox(height: 16),

              Text(
                widget.isEnglish ? "Character Frequency Bucket Balancer:" : "ক্যারেক্টার ফ্রিকোয়েন্সি বাকেট ব্যালেন্সার:",
                style: const TextStyle(color: AppTheme.accentPink, fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: step.freqMap.entries.map((entry) {
                    final isZero = entry.value == 0;

                    return Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isZero ? AppTheme.accentGreen.withOpacity(0.2) : AppTheme.surfaceDark,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: isZero ? AppTheme.accentGreen : AppTheme.accentPink),
                      ),
                      child: Column(
                        children: [
                          Text("'${entry.key}'", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                          const SizedBox(height: 4),
                          Text(
                            "count: ${entry.value}",
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 11,
                              color: isZero ? AppTheme.accentGreen : AppTheme.accentPink,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 14),

              if (step.isValidAnagram != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppTheme.accentGreen.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppTheme.accentGreen),
                  ),
                  child: Text(
                    "Result: isAnagram(\"$_s\", \"$_t\") = ${step.isValidAnagram}",
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
