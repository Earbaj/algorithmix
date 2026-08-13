import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';

class AddSearchWordsAnimatedVisualizer extends StatefulWidget {
  final bool isEnglish;

  const AddSearchWordsAnimatedVisualizer({
    super.key,
    required this.isEnglish,
  });

  @override
  State<AddSearchWordsAnimatedVisualizer> createState() =>
      _AddSearchWordsAnimatedVisualizerState();
}

class WildcardStepData {
  final String query;
  final List<String> branchesExplored;
  final bool isMatch;
  final String titleEn;
  final String titleBn;
  final String explanationEn;
  final String explanationBn;

  const WildcardStepData({
    required this.query,
    required this.branchesExplored,
    required this.isMatch,
    required this.titleEn,
    required this.titleBn,
    required this.explanationEn,
    required this.explanationBn,
  });
}

class _AddSearchWordsAnimatedVisualizerState
    extends State<AddSearchWordsAnimatedVisualizer> {
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  late final List<WildcardStepData> _steps;

  @override
  void initState() {
    super.initState();
    _steps = const [
      WildcardStepData(
        query: "addWord(\"bad\"), addWord(\"dad\"), addWord(\"mad\")",
        branchesExplored: ["'b'->'a'->'d'", "'d'->'a'->'d'", "'m'->'a'->'d'"],
        isMatch: true,
        titleEn: "1. Add Words [\"bad\", \"dad\", \"mad\"] into Trie",
        titleBn: "১. ডিকশনারিতে [\"bad\", \"dad\", \"mad\"] ইনসার্ট",
        explanationEn: "Words are inserted into Trie creating 3 branches from root for 'b', 'd', and 'm'.",
        explanationBn: "ট্রাইতে 'b', 'd', 'm' থেকে ৩টি আলাদা ক্যারেক্টার ব্রাঞ্চ তৈরি করা হলো।",
      ),
      WildcardStepData(
        query: "search(\".ad\")",
        branchesExplored: ["'.' matches 'b' -> 'a' -> 'd'"],
        isMatch: true,
        titleEn: "2. search(\".ad\") -> Wildcard '.' Matches Any Character! 🎉",
        titleBn: "২. search(\".ad\") -> ডট '.' যেকোনো অক্ষরের সাথে ম্যাচ করে! 🎉",
        explanationEn: "Wildcard '.' expands and branches to 'b'. Following 'a' -> 'd' completes valid word 'bad'! Returns true!",
        explanationBn: "ওয়াইল্ডকার্ড '.' ক্যারেক্টার 'b' কে ম্যাচ করায় 'b'->'a'->'d' সম্পূর্ণ শব্দ নির্দেশ করে! return true!",
      ),
      WildcardStepData(
        query: "search(\"b..\")",
        branchesExplored: ["'b' -> '.' matches 'a' -> '.' matches 'd'"],
        isMatch: true,
        titleEn: "3. search(\"b..\") -> Double Wildcard Matches 'bad'! 🎉",
        titleBn: "৩. search(\"b..\") -> ডবল ওয়াইল্ডকার্ড 'bad' কে ম্যাচ করে! 🎉",
        explanationEn: "Starts at 'b', then two '.' wildcards recursively match 'a' and 'd'. Returns true!",
        explanationBn: "'b' থেকে শুরু হয়ে দুটি ডট '.' ক্যারেক্টার 'a' ও 'd' কে ম্যাচ করে! return true!",
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
              const Icon(Icons.saved_search, color: AppTheme.accentNeonCyan, size: 24),
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

        // Visual Display of Wildcard DFS Branches
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Query: ${step.query}", style: const TextStyle(color: AppTheme.accentPurple, fontSize: 13, fontWeight: FontWeight.bold)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.accentGreen.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.accentGreen),
                    ),
                    child: const Text(
                      "MATCH = TRUE",
                      style: TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 11, fontFamily: 'monospace'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              const Text("DFS Wildcard Branching Paths:", style: TextStyle(color: Colors.white70, fontSize: 12)),
              const SizedBox(height: 10),
              Column(
                children: List.generate(step.branchesExplored.length, (idx) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceDark,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppTheme.accentNeonCyan.withOpacity(0.5)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.subdirectory_arrow_right, color: AppTheme.accentNeonCyan, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          step.branchesExplored[idx],
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'monospace', fontSize: 13),
                        ),
                      ],
                    ),
                  );
                }),
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
