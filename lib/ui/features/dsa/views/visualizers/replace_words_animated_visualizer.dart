import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';

class ReplaceWordsAnimatedVisualizer extends StatefulWidget {
  final bool isEnglish;

  const ReplaceWordsAnimatedVisualizer({
    super.key,
    required this.isEnglish,
  });

  @override
  State<ReplaceWordsAnimatedVisualizer> createState() =>
      _ReplaceWordsAnimatedVisualizerState();
}

class ReplaceStepData {
  final String originalWord;
  final String replacedWord;
  final String rootFound;
  final String currentSentence;
  final String titleEn;
  final String titleBn;
  final String explanationEn;
  final String explanationBn;

  const ReplaceStepData({
    required this.originalWord,
    required this.replacedWord,
    required this.rootFound,
    required this.currentSentence,
    required this.titleEn,
    required this.titleBn,
    required this.explanationEn,
    required this.explanationBn,
  });
}

class _ReplaceWordsAnimatedVisualizerState
    extends State<ReplaceWordsAnimatedVisualizer> {
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  late final List<ReplaceStepData> _steps;

  @override
  void initState() {
    super.initState();
    _steps = const [
      ReplaceStepData(
        originalWord: "cattle",
        replacedWord: "cat",
        rootFound: "cat",
        currentSentence: "the cat was ratted by the battery",
        titleEn: "1. Word 'cattle' -> Replaced by shortest Trie root 'cat'",
        titleBn: "১. 'cattle' শব্দ -> ট্রাই রুট 'cat' দিয়ে প্রতিস্থাপিত",
        explanationEn: "Walk Trie for 'cattle': 'c'->'a'->'t' (isEndOfWord == true). Shortest root is 'cat'! Replace 'cattle' -> 'cat'.",
        explanationBn: "'cattle' ট্রাভার্স করার সময় 'cat' নোডে isEndOfWord == true পাওয়া গেছে! 'cattle' -> 'cat'।",
      ),
      ReplaceStepData(
        originalWord: "ratted",
        replacedWord: "rat",
        rootFound: "rat",
        currentSentence: "the cat was rat by the battery",
        titleEn: "2. Word 'ratted' -> Replaced by shortest Trie root 'rat'",
        titleBn: "২. 'ratted' শব্দ -> ট্রাই রুট 'rat' দিয়ে প্রতিস্থাপিত",
        explanationEn: "Walk Trie for 'ratted': 'r'->'a'->'t' (isEndOfWord == true). Shortest root is 'rat'! Replace 'ratted' -> 'rat'.",
        explanationBn: "'ratted' ট্রাভার্স করার সময় 'rat' নোডে isEndOfWord == true পাওয়া গেছে! 'ratted' -> 'rat'।",
      ),
      ReplaceStepData(
        originalWord: "battery",
        replacedWord: "bat",
        rootFound: "bat",
        currentSentence: "the cat was rat by the bat",
        titleEn: "3. Word 'battery' -> Replaced by shortest Trie root 'bat' 🎉",
        titleBn: "৩. 'battery' শব্দ -> ট্রাই রুট 'bat' দিয়ে প্রতিস্থাপিত! 🎉",
        explanationEn: "Walk Trie for 'battery': 'b'->'a'->'t' (isEndOfWord == true). Replace 'battery' -> 'bat'. Final sentence generated! 🎉",
        explanationBn: "'battery' ট্রাভার্স করার সময় 'bat' রুট দিয়ে প্রতিস্থাপন সম্পন্ন! চূড়ান্ত সেন্টেন্স তৈরি! 🎉",
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
              const Icon(Icons.find_replace, color: AppTheme.accentNeonCyan, size: 24),
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

        // Visual Display of Replacement
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFF090D16),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF1E293B)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildWordBadge(step.originalWord, "Original Word", Colors.redAccent),
                  const SizedBox(width: 16),
                  const Icon(Icons.arrow_forward, color: AppTheme.accentGreen),
                  const SizedBox(width: 16),
                  _buildWordBadge(step.replacedWord, "Trie Shortest Root", AppTheme.accentGreen),
                ],
              ),
              const SizedBox(height: 20),

              const Text("Transformed Sentence Output:", style: TextStyle(color: AppTheme.accentNeonCyan, fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceDark,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF334155)),
                ),
                child: Text(
                  "\"${step.currentSentence}\"",
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'monospace', fontSize: 13, height: 1.4),
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

  Widget _buildWordBadge(String word, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(
            "\"$word\"",
            style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14, fontFamily: 'monospace'),
          ),
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
