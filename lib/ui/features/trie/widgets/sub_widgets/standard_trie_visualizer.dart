import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class TrieStep {
  final String activeChar;
  final int activeLineIndex;
  final List<String> triePath;
  final bool isEnd;
  final String explanationEn;
  final String explanationBn;

  const TrieStep({
    required this.activeChar,
    required this.activeLineIndex,
    required this.triePath,
    required this.isEnd,
    required this.explanationEn,
    required this.explanationBn,
  });
}

class StandardTrieVisualizer extends StatefulWidget {
  final bool isEnglish;

  const StandardTrieVisualizer({super.key, required this.isEnglish});

  @override
  State<StandardTrieVisualizer> createState() => _StandardTrieVisualizerState();
}

class _StandardTrieVisualizerState extends State<StandardTrieVisualizer> {
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  final List<String> _codeLines = const [
    "void insert(string word) {",
    "    TrieNode* curr = root;",
    "    for (char c : word) {",
    "        int idx = c - 'a';",
    "        if (!curr->children[idx]) curr->children[idx] = new TrieNode();",
    "        curr = curr->children[idx]; // Move to child node",
    "    }",
    "    curr->isEnd = true; // Mark end of word!",
    "}",
    "bool startsWith(string prefix) {",
    "    TrieNode* curr = root;",
    "    for (char c : prefix) { if (!curr->children[c - 'a']) return false; }",
    "    return true; // Valid Prefix Found!",
    "}",
  ];

  final List<TrieStep> _steps = const [
    TrieStep(
      activeChar: "a",
      activeLineIndex: 4,
      triePath: ["root", "a"],
      isEnd: false,
      explanationEn: "Line 5: Insert char 'a': Allocated new child node at index 0 ('a').",
      explanationBn: "লাইন ৫: ক্যারেক্টার 'a' ইনসার্ট: ইনডেক্স ০ ('a') এ নতুন চাইল্ড নোড তৈরি।",
    ),
    TrieStep(
      activeChar: "p",
      activeLineIndex: 4,
      triePath: ["root", "a", "p"],
      isEnd: false,
      explanationEn: "Line 5: Insert char 'p': Allocated new child node at index 15 ('p').",
      explanationBn: "লাইন ৫: ক্যারেক্টার 'p' ইনসার্ট: ইনডেক্স ১৫ ('p') এ নতুন চাইল্ড নোড তৈরি।",
    ),
    TrieStep(
      activeChar: "p",
      activeLineIndex: 7,
      triePath: ["root", "a", "p", "p"],
      isEnd: true,
      explanationEn: "Line 8: Insert char 'p': Mark node as isEnd = true! Word 'app' inserted.",
      explanationBn: "লাইন ৮: ক্যারেক্টার 'p' ইনসার্ট: নোডে isEnd = true সেট করা হলো! শব্দ 'app' সংরক্ষণ সম্পন্ন।",
    ),
    TrieStep(
      activeChar: "l",
      activeLineIndex: 4,
      triePath: ["root", "a", "p", "p", "l"],
      isEnd: false,
      explanationEn: "Line 5: Insert char 'l': Allocated new child node at index 11 ('l').",
      explanationBn: "লাইন ৫: ক্যারেক্টার 'l' ইনসার্ট: ইনডেক্স ১১ ('l') এ নতুন চাইল্ড নোড তৈরি।",
    ),
    TrieStep(
      activeChar: "e",
      activeLineIndex: 12,
      triePath: ["root", "a", "p", "p", "l", "e"],
      isEnd: true,
      explanationEn: "🎉 Line 13: startsWith('app') -> true! Word 'apple' fully stored in Trie!",
      explanationBn: "🎉 লাইন ১৩: startsWith('app') -> true! শব্দ 'apple' সফলভাবে Trie তে সংরক্ষিত!",
    ),
  ];

  void _togglePlay() {
    setState(() => _isPlaying = !_isPlaying);
    if (_isPlaying) {
      _timer = Timer.periodic(const Duration(milliseconds: 1400), (timer) {
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
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final step = _steps[_currentStepIndex];
    final isMobile = Responsive.isMobile(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: step.activeLineIndex == 12 ? AppTheme.accentGreen.withOpacity(0.15) : AppTheme.accentNeonCyan.withOpacity(0.15),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: step.activeLineIndex == 12 ? AppTheme.accentGreen : AppTheme.accentNeonCyan),
          ),
          child: Text(
            widget.isEnglish ? step.explanationEn : step.explanationBn,
            style: TextStyle(
              color: step.activeLineIndex == 12 ? AppTheme.accentGreen : AppTheme.accentNeonCyan,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(height: 16),

        if (isMobile)
          Column(
            children: [
              _buildCodeSnippetWithHighlight(_codeLines, step.activeLineIndex),
              const SizedBox(height: 16),
              _buildCanvas(step),
            ],
          )
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildCodeSnippetWithHighlight(_codeLines, step.activeLineIndex)),
              const SizedBox(width: 16),
              Expanded(child: _buildCanvas(step)),
            ],
          ),

        const SizedBox(height: 20),
        _buildControlBar(),
      ],
    );
  }

  Widget _buildCodeSnippetWithHighlight(List<String> codeLines, int activeIndex) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF090D16),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(codeLines.length, (idx) {
          final isHighlighted = idx == activeIndex;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            margin: const EdgeInsets.symmetric(vertical: 1),
            decoration: BoxDecoration(
              color: isHighlighted ? AppTheme.accentPurple.withOpacity(0.25) : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: isHighlighted ? Border.all(color: AppTheme.accentPurple) : null,
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 24,
                  child: Text(
                    "${idx + 1}",
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                      color: isHighlighted ? AppTheme.accentNeonCyan : const Color(0xFF64748B),
                      fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
                if (isHighlighted)
                  const Padding(
                    padding: EdgeInsets.only(right: 6),
                    child: Icon(Icons.arrow_right_alt, color: AppTheme.accentNeonCyan, size: 14),
                  )
                else
                  const SizedBox(width: 20),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      codeLines[idx],
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        color: isHighlighted ? Colors.white : const Color(0xFF38BDF8),
                        fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCanvas(TrieStep step) {
    return Container(
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
              Text("Active Char: '${step.activeChar}'", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13)),
              Text("isEnd: ${step.isEnd}", style: const TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 16),
          const Text("Trie Path Hierarchy:", style: TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(step.triePath.length, (idx) {
                final isLast = idx == step.triePath.length - 1;
                return Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: isLast ? (step.isEnd ? AppTheme.accentGreen.withOpacity(0.3) : AppTheme.accentPurple.withOpacity(0.3)) : AppTheme.surfaceDark,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: isLast ? (step.isEnd ? AppTheme.accentGreen : AppTheme.accentPurple) : const Color(0xFF334155)),
                      ),
                      child: Text(
                        step.triePath[idx],
                        style: TextStyle(
                          color: isLast ? Colors.white : AppTheme.textSecondary,
                          fontWeight: isLast ? FontWeight.bold : FontWeight.normal,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    if (!isLast)
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(Icons.arrow_right_alt, color: AppTheme.textMuted, size: 16),
                      ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.primaryDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.textMuted.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.skip_previous, color: Colors.white),
                onPressed: _currentStepIndex > 0 ? _prevStep : null,
              ),
              IconButton(
                icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, color: AppTheme.accentNeonCyan),
                onPressed: _togglePlay,
              ),
              IconButton(
                icon: const Icon(Icons.skip_next, color: Colors.white),
                onPressed: _currentStepIndex < _steps.length - 1 ? _nextStep : null,
              ),
              IconButton(
                icon: const Icon(Icons.refresh, color: AppTheme.accentNeonCyan),
                onPressed: _reset,
              ),
            ],
          ),
          Text(
            widget.isEnglish
                ? "Step ${_currentStepIndex + 1} of ${_steps.length}"
                : "ধাপ ${_currentStepIndex + 1} / ${_steps.length}",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
