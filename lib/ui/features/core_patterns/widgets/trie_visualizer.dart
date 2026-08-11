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

class TrieVisualizer extends StatefulWidget {
  final bool isEnglish;

  const TrieVisualizer({super.key, required this.isEnglish});

  @override
  State<TrieVisualizer> createState() => _TrieVisualizerState();
}

class _TrieVisualizerState extends State<TrieVisualizer> {
  int _selectedTemplateIndex = 0;
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  final List<List<String>> _codeTemplates = const [
    // Template 1: Implement Trie
    [
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
    ],
    // Template 2: Design Add & Search Words (Wildcard)
    [
      "bool searchHelp(string& word, int idx, TrieNode* curr) {",
      "    if (!curr) return false;",
      "    if (idx == word.size()) return curr->isEnd;",
      "    if (word[idx] != '.') {",
      "        return searchHelp(word, idx + 1, curr->children[word[idx] - 'a']);",
      "    }",
      "    for (int i = 0; i < 26; i++) { // Wildcard '.': try all children!",
      "        if (curr->children[i] && searchHelp(word, idx + 1, curr->children[i])) return true;",
      "    }",
      "    return false;",
      "}",
    ],
    // Template 3: Maximum XOR of Two Numbers
    [
      "int findMaximumXOR(vector<int>& nums) {",
      "    int maxXor = 0;",
      "    for (int num : nums) {",
      "        TrieNode* curr = root; int currXor = 0;",
      "        for (int i = 31; i >= 0; i--) {",
      "            int bit = (num >> i) & 1;",
      "            if (curr->children[1 - bit]) { // Greedily pick opposite bit!",
      "                currXor |= (1 << i); curr = curr->children[1 - bit];",
      "            } else curr = curr->children[bit];",
      "        }",
      "        maxXor = max(maxXor, currXor);",
      "    }",
      "    return maxXor;",
      "}",
    ],
  ];

  final List<TrieStep> _template1Steps = const [
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

  final List<TrieStep> _template2Steps = const [
    TrieStep(
      activeChar: ".",
      activeLineIndex: 6,
      triePath: ["root", "a", "."],
      isEnd: false,
      explanationEn: "Line 7: Wildcard '.' encountered. DFS checking all 26 child branches.",
      explanationBn: "লাইন ৭: ওয়াইল্ডকার্ড '.' ক্যারেক্টার পাওয়া গেছে। সবকটি চাইল্ড নোডে DFS পরীক্ষা চলছে।",
    ),
    TrieStep(
      activeChar: "b",
      activeLineIndex: 7,
      triePath: ["root", "a", "b"],
      isEnd: true,
      explanationEn: "🎉 Line 8: Wildcard search 'a.b' matched! Result = true!",
      explanationBn: "🎉 লাইন ৮: ওয়াইল্ডকার্ড সার্চ 'a.b' মিলে গেছে! রেজাল্ট = true!",
    ),
  ];

  final List<TrieStep> _template3Steps = const [
    TrieStep(
      activeChar: "1",
      activeLineIndex: 6,
      triePath: ["root", "1", "0", "1"],
      isEnd: true,
      explanationEn: "🎉 Line 10: Greedily picked opposite bit (1 - bit). Max XOR = 28!",
      explanationBn: "🎉 লাইন ১০: গ্রিডি কৌশলে বিপরীত বিট বাছাই সম্পন্ন। ম্যাক্সিমাম XOR = 28!",
    ),
  ];

  List<TrieStep> get _currentSteps {
    if (_selectedTemplateIndex == 1) return _template2Steps;
    if (_selectedTemplateIndex == 2) return _template3Steps;
    return _template1Steps;
  }

  List<String> get _currentCodeLines {
    return _codeTemplates[_selectedTemplateIndex];
  }

  void _togglePlay() {
    setState(() => _isPlaying = !_isPlaying);
    if (_isPlaying) {
      _timer = Timer.periodic(const Duration(milliseconds: 1400), (timer) {
        if (_currentStepIndex < _currentSteps.length - 1) {
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
    if (_currentStepIndex < _currentSteps.length - 1) {
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
    final step = _currentSteps[_currentStepIndex];
    final isMobile = Responsive.isMobile(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Template Selector Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildTemplateChip(0, widget.isEnglish ? "Implement Trie Insert/Search" : "Trie ইনসার্ট ও সার্চ"),
              _buildTemplateChip(1, widget.isEnglish ? "Wildcard Search ('.')" : "ওয়াইল্ডকার্ড ওয়ার্ড সার্চ"),
              _buildTemplateChip(2, widget.isEnglish ? "Bitwise Maximum XOR" : "বিটওয়াইজ ম্যাক্স XOR"),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Status Log Banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.accentPurple.withOpacity(0.15),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.accentPurple),
          ),
          child: Text(
            widget.isEnglish ? step.explanationEn : step.explanationBn,
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
        const SizedBox(height: 16),

        // Code Snippet + Visualizer Box Layout
        if (isMobile)
          Column(
            children: [
              _buildCodeSnippetWithHighlight(_currentCodeLines, step.activeLineIndex),
              const SizedBox(height: 16),
              _buildTrieCanvas(step),
            ],
          )
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildCodeSnippetWithHighlight(_currentCodeLines, step.activeLineIndex)),
              const SizedBox(width: 16),
              Expanded(child: _buildTrieCanvas(step)),
            ],
          ),

        const SizedBox(height: 20),

        // Controls Bar
        _buildControlBar(),
      ],
    );
  }

  Widget _buildTemplateChip(int index, String label) {
    final isSelected = _selectedTemplateIndex == index;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        selectedColor: AppTheme.accentPurple,
        backgroundColor: AppTheme.surfaceDark,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : AppTheme.textSecondary,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        onSelected: (selected) {
          if (selected) {
            _timer?.cancel();
            setState(() {
              _selectedTemplateIndex = index;
              _currentStepIndex = 0;
              _isPlaying = false;
            });
          }
        },
      ),
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

  Widget _buildTrieCanvas(TrieStep step) {
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
              Text("isEnd Flag: ${step.isEnd}", style: TextStyle(color: step.isEnd ? AppTheme.accentGreen : AppTheme.accentPink, fontWeight: FontWeight.bold, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 16),

          // Trie Node Chain Inspector
          const Text("Trie Tree Character Path Inspector:", style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(step.triePath.length, (i) {
                final isLast = i == step.triePath.length - 1;

                return Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: isLast ? AppTheme.accentPurple : AppTheme.surfaceDark,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isLast ? AppTheme.accentNeonCyan : const Color(0xFF1E293B),
                          width: isLast ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            step.triePath[i],
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          if (isLast && step.isEnd)
                            Container(
                              margin: const EdgeInsets.only(top: 4),
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(color: AppTheme.accentGreen, borderRadius: BorderRadius.circular(4)),
                              child: const Text("END", style: TextStyle(fontSize: 8, color: AppTheme.primaryDark, fontWeight: FontWeight.bold)),
                            ),
                        ],
                      ),
                    ),
                    if (i < step.triePath.length - 1)
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(Icons.arrow_forward, color: AppTheme.accentNeonCyan, size: 16),
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
                onPressed: _currentStepIndex < _currentSteps.length - 1 ? _nextStep : null,
              ),
              IconButton(
                icon: const Icon(Icons.refresh, color: AppTheme.accentNeonCyan),
                onPressed: _reset,
              ),
            ],
          ),
          Text(
            widget.isEnglish
                ? "Step ${_currentStepIndex + 1} of ${_currentSteps.length}"
                : "ধাপ ${_currentStepIndex + 1} / ${_currentSteps.length}",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
