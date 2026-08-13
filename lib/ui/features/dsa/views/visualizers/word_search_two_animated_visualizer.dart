import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';

class WordSearchTwoAnimatedVisualizer extends StatefulWidget {
  final bool isEnglish;

  const WordSearchTwoAnimatedVisualizer({
    super.key,
    required this.isEnglish,
  });

  @override
  State<WordSearchTwoAnimatedVisualizer> createState() =>
      _WordSearchTwoAnimatedVisualizerState();
}

class WordSearchStepData {
  final String activeWordFound;
  final List<String> allWordsFound;
  final String pathStr;
  final String titleEn;
  final String titleBn;
  final String explanationEn;
  final String explanationBn;

  const WordSearchStepData({
    required this.activeWordFound,
    required this.allWordsFound,
    required this.pathStr,
    required this.titleEn,
    required this.titleBn,
    required this.explanationEn,
    required this.explanationBn,
  });
}

class _WordSearchTwoAnimatedVisualizerState
    extends State<WordSearchTwoAnimatedVisualizer> {
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  late final List<WordSearchStepData> _steps;

  @override
  void initState() {
    super.initState();
    _steps = const [
      WordSearchStepData(
        activeWordFound: "",
        allWordsFound: [],
        pathStr: "Insert words [\"oath\", \"pea\", \"eat\", \"rain\"] into Trie",
        titleEn: "1. Build Trie for target dictionary words",
        titleBn: "১. টার্গেট শব্দগুলোর জন্য ট্রাই তৈরি",
        explanationEn: "Words are inserted into Trie so grid DFS can prune paths early if a character is missing.",
        explanationBn: "গ্রিড DFS এর সময় প্রিফিক্স মিসিং থাকলে দ্রুত প্রুন (Prune) করতে ট্রাই বিল্ড করা হলো।",
      ),
      WordSearchStepData(
        activeWordFound: "oath",
        allWordsFound: ["oath"],
        pathStr: "(0,0)'o' ➔ (1,1)'t' ➔ (2,1)'h' ➔ (1,2)'a'",
        titleEn: "2. Grid DFS from (0,0) found word 'oath'! 🎉",
        titleBn: "২. (0,0) থেকে গ্রিড DFS শব্দ 'oath' উদ্ধার করল! 🎉",
        explanationEn: "DFS from (0,0) walks Trie path 'o'->'a'->'t'->'h'. Word 'oath' marked in Trie! Add to results.",
        explanationBn: "(0,0) সেলে শুরু হয়ে 'o'->'a'->'t'->'h' ট্রাই পাথ ধরে 'oath' শব্দ পাওয়া গেল! রেজাল্টে যুক্ত!",
      ),
      WordSearchStepData(
        activeWordFound: "eat",
        allWordsFound: ["oath", "eat"],
        pathStr: "(1,3)'e' ➔ (1,2)'a' ➔ (1,1)'t'",
        titleEn: "3. Grid DFS from (1,3) found word 'eat'! 🎉",
        titleBn: "৩. (1,3) থেকে গ্রিড DFS শব্দ 'eat' উদ্ধার করল! 🎉",
        explanationEn: "DFS from (1,3) walks Trie path 'e'->'a'->'t'. Word 'eat' found! Output = [\"oath\", \"eat\"]! 🎉",
        explanationBn: "(1,3) সেলে শুরু হয়ে 'e'->'a'->'t' ট্রাই পাথ ধরে 'eat' শব্দ পাওয়া গেল! মোট রেজাল্ট = [\"oath\", \"eat\"]! 🎉",
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
              const Icon(Icons.grid_on, color: AppTheme.accentNeonCyan, size: 24),
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

        // Visual Display of 2D Grid & Words Found
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
              Text("DFS Grid Path: ${step.pathStr}", style: const TextStyle(color: AppTheme.accentPurple, fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 14),

              const Text("Words Found in Grid:", style: TextStyle(color: AppTheme.accentGreen, fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: step.allWordsFound.isEmpty
                      ? [const Text("Searching...", style: TextStyle(color: Colors.white38, fontSize: 12))]
                      : List.generate(step.allWordsFound.length, (idx) {
                          return Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppTheme.accentGreen.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppTheme.accentGreen),
                            ),
                            child: Text(
                              "\"${step.allWordsFound[idx]}\"",
                              style: const TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontFamily: 'monospace'),
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
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
