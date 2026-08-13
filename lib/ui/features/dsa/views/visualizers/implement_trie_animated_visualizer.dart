import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';

class ImplementTrieAnimatedVisualizer extends StatefulWidget {
  final bool isEnglish;

  const ImplementTrieAnimatedVisualizer({
    super.key,
    required this.isEnglish,
  });

  @override
  State<ImplementTrieAnimatedVisualizer> createState() =>
      _ImplementTrieAnimatedVisualizerState();
}

class TrieOpStepData {
  final String operation;
  final String word;
  final List<String> activePath;
  final bool? result;
  final String titleEn;
  final String titleBn;
  final String explanationEn;
  final String explanationBn;

  const TrieOpStepData({
    required this.operation,
    required this.word,
    required this.activePath,
    this.result,
    required this.titleEn,
    required this.titleBn,
    required this.explanationEn,
    required this.explanationBn,
  });
}

class _ImplementTrieAnimatedVisualizerState
    extends State<ImplementTrieAnimatedVisualizer> {
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  late final List<TrieOpStepData> _steps;

  @override
  void initState() {
    super.initState();
    _steps = const [
      TrieOpStepData(
        operation: "insert",
        word: "apple",
        activePath: ["a", "p", "p", "l", "e"],
        titleEn: "1. insert(\"apple\") in O(L) time",
        titleBn: "১. insert(\"apple\") ওয়ান O(L) সময়ে",
        explanationEn: "Traverse characters 'a' -> 'p' -> 'p' -> 'l' -> 'e'. Create TrieNodes and mark isEndOfWord = true at node 'e'.",
        explanationBn: "ট্রাইতে 'a' -> 'p' -> 'p' -> 'l' -> 'e' পাথ তৈরি করে 'e' নোডে isEndOfWord = true চিহ্নিত করা হলো।",
      ),
      TrieOpStepData(
        operation: "search",
        word: "apple",
        activePath: ["a", "p", "p", "l", "e"],
        result: true,
        titleEn: "2. search(\"apple\") -> Returns TRUE 🎉",
        titleBn: "২. search(\"apple\") -> সত্য (TRUE) ফেরত! 🎉",
        explanationEn: "Walk Trie path 'a'->'p'->'p'->'l'->'e'. Node 'e' has isEndOfWord == true! Return true!",
        explanationBn: "'a'->'p'->'p'->'l'->'e' পথ শেষে 'e' নোডে isEndOfWord == true! return true!",
      ),
      TrieOpStepData(
        operation: "search",
        word: "app",
        activePath: ["a", "p", "p"],
        result: false,
        titleEn: "3. search(\"app\") -> Returns FALSE (Not a standalone word yet)",
        titleBn: "৩. search(\"app\") -> মিথ্যে (FALSE) ফেরত",
        explanationEn: "Walk Trie path 'a'->'p'->'p'. Prefix exists, BUT node 'p' has isEndOfWord == false! Return false!",
        explanationBn: "প্রিফিক্স 'app' বিদ্যমান, কিন্তু 'p' নোডে isEndOfWord == false! return false!",
      ),
      TrieOpStepData(
        operation: "startsWith",
        word: "app",
        activePath: ["a", "p", "p"],
        result: true,
        titleEn: "4. startsWith(\"app\") -> Returns TRUE 🎉",
        titleBn: "৪. startsWith(\"app\") -> সত্য (TRUE) ফেরত! 🎉",
        explanationEn: "Walk Trie path 'a'->'p'->'p'. All prefix nodes exist! Return true!",
        explanationBn: "প্রিফিক্স 'app' নোড পর্যন্ত সব অক্ষরের চাইল্ড বিদ্যমান! return true!",
      ),
      TrieOpStepData(
        operation: "insert",
        word: "app",
        activePath: ["a", "p", "p"],
        titleEn: "5. insert(\"app\") -> Sets isEndOfWord = true at node 'p'",
        titleBn: "৫. insert(\"app\") -> 'p' নোডে isEndOfWord = true সেট করা হলো",
        explanationEn: "Walk existing prefix path 'a'->'p'->'p'. Mark node 'p' with isEndOfWord = true!",
        explanationBn: "বিদ্যমান 'app' ব্র্যাঞ্চে যেয়ে নোড 'p' তে isEndOfWord = true ফ্ল্যাগ যোগ করা হলো!",
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
              const Icon(Icons.sort_by_alpha, color: AppTheme.accentNeonCyan, size: 24),
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

        // Visual Display of Trie Path & Result
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
                  Text("Trie Branch Path for '${step.word}':", style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                  if (step.result != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: step.result! ? AppTheme.accentGreen.withOpacity(0.2) : Colors.redAccent.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: step.result! ? AppTheme.accentGreen : Colors.redAccent),
                      ),
                      child: Text(
                        step.result! ? "RESULT: TRUE" : "RESULT: FALSE",
                        style: TextStyle(
                          color: step.result! ? AppTheme.accentGreen : Colors.redAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppTheme.accentPurple.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppTheme.accentPurple),
                      ),
                      child: const Text("root (*)", style: TextStyle(color: AppTheme.accentPurple, fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                    ...List.generate(step.activePath.length, (idx) {
                      final c = step.activePath[idx];
                      final isLast = idx == step.activePath.length - 1;
                      return Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6),
                            child: Icon(Icons.arrow_forward, color: AppTheme.accentNeonCyan, size: 16),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: isLast ? AppTheme.accentGreen.withOpacity(0.25) : AppTheme.surfaceDark,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: isLast ? AppTheme.accentGreen : const Color(0xFF334155)),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  "'$c'",
                                  style: TextStyle(
                                    color: isLast ? AppTheme.accentGreen : Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                                if (isLast && (step.operation == "insert" || (step.result == true && step.operation == "search")))
                                  const Text("isEnd=T", style: TextStyle(color: AppTheme.accentGreen, fontSize: 9, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
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
