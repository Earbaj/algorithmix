import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class BitStep {
  final int activeNumber;
  final int activeLineIndex;
  final String binaryRepresentation;
  final int resultVal;
  final String explanationEn;
  final String explanationBn;

  const BitStep({
    required this.activeNumber,
    required this.activeLineIndex,
    required this.binaryRepresentation,
    required this.resultVal,
    required this.explanationEn,
    required this.explanationBn,
  });
}

class BitManipulationVisualizer extends StatefulWidget {
  final bool isEnglish;

  const BitManipulationVisualizer({super.key, required this.isEnglish});

  @override
  State<BitManipulationVisualizer> createState() => _BitManipulationVisualizerState();
}

class _BitManipulationVisualizerState extends State<BitManipulationVisualizer> {
  int _selectedTemplateIndex = 0;
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  final List<List<String>> _codeTemplates = const [
    // Template 1: Single Number (XOR)
    [
      "int singleNumber(vector<int>& nums) {",
      "    int result = 0;",
      "    for (int num : nums) {",
      "        result ^= num; // XOR cancels duplicate pairs (A ^ A = 0)",
      "    }",
      "    return result; // Unique single element remaining!",
      "}",
    ],
    // Template 2: Number of 1 Bits (Kernighan's Algorithm)
    [
      "int hammingWeight(uint32_t n) {",
      "    int count = 0;",
      "    while (n != 0) {",
      "        n &= (n - 1); // Clears rightmost set 1-bit in O(1)!",
      "        count++;",
      "    }",
      "    return count;",
      "}",
    ],
    // Template 3: Reverse Bits
    [
      "uint32_t reverseBits(uint32_t n) {",
      "    uint32_t res = 0;",
      "    for (int i = 0; i < 32; i++) {",
      "        res = (res << 1) | (n & 1); // Append rightmost bit to res",
      "        n >>= 1;",
      "    }",
      "    return res;",
      "}",
    ],
  ];

  final List<BitStep> _template1Steps = const [
    BitStep(
      activeNumber: 4,
      activeLineIndex: 3,
      binaryRepresentation: "0000 0100",
      resultVal: 4,
      explanationEn: "Line 4: XORing 4: result = 0 ^ 4 = 4. Binary = 0000 0100.",
      explanationBn: "লাইন ৪: 4 এর সাথে XOR: result = 0 ^ 4 = 4। বাইনারি = 0000 0100।",
    ),
    BitStep(
      activeNumber: 1,
      activeLineIndex: 3,
      binaryRepresentation: "0000 0101",
      resultVal: 5,
      explanationEn: "Line 4: XORing 1: result = 4 ^ 1 = 5. Binary = 0000 0101.",
      explanationBn: "লাইন ৪: 1 এর সাথে XOR: result = 4 ^ 1 = 5। বাইনারি = 0000 0101।",
    ),
    BitStep(
      activeNumber: 2,
      activeLineIndex: 3,
      binaryRepresentation: "0000 0111",
      resultVal: 7,
      explanationEn: "Line 4: XORing 2: result = 5 ^ 2 = 7. Binary = 0000 0111.",
      explanationBn: "লাইন ৪: 2 এর সাথে XOR: result = 5 ^ 2 = 7। বাইনারি = 0000 0111।",
    ),
    BitStep(
      activeNumber: 1,
      activeLineIndex: 3,
      binaryRepresentation: "0000 0110",
      resultVal: 6,
      explanationEn: "Line 4: XORing 1 (Duplicate): result = 7 ^ 1 = 6. Pair cancelled!",
      explanationBn: "লাইন ৪: 1 (ডুপ্লিকেট) এর সাথে XOR: result = 7 ^ 1 = 6। জোড়া ডুপ্লিকেট বাতিল!",
    ),
    BitStep(
      activeNumber: 2,
      activeLineIndex: 5,
      binaryRepresentation: "0000 0100",
      resultVal: 4,
      explanationEn: "🎉 Line 6: XORing 2 (Duplicate): result = 6 ^ 2 = 4. Unique Single Number = 4!",
      explanationBn: "🎉 লাইন ৬: 2 (ডুপ্লিকেট) এর সাথে XOR: result = 6 ^ 2 = 4। একমাত্র ইউনিক সংখ্যা = 4!",
    ),
  ];

  final List<BitStep> _template2Steps = const [
    BitStep(
      activeNumber: 11,
      activeLineIndex: 3,
      binaryRepresentation: "0000 1010",
      resultVal: 1,
      explanationEn: "Line 4: Kernighan step 1: n = 11 (0000 1011) & 10 (0000 1010) = 10. Cleared 1-bit!",
      explanationBn: "লাইন ৪: কার্নিগান ধাপ ১: n = 11 & 10 = 10। ডানপাশের ১-বিট রিমুভ করা হলো!",
    ),
    BitStep(
      activeNumber: 10,
      activeLineIndex: 3,
      binaryRepresentation: "0000 1000",
      resultVal: 2,
      explanationEn: "Line 4: Kernighan step 2: n = 10 (0000 1010) & 9 (0000 1001) = 8. Count = 2.",
      explanationBn: "লাইন ৪: কার্নিগান ধাপ ২: n = 10 & 9 = 8। কাউন্ট = ২।",
    ),
    BitStep(
      activeNumber: 8,
      activeLineIndex: 6,
      binaryRepresentation: "0000 0000",
      resultVal: 3,
      explanationEn: "🎉 Line 7: Kernighan step 3: n = 8 & 7 = 0. Total Set 1-Bits = 3!",
      explanationBn: "🎉 লাইন ৭: কার্নিগান ধাপ ৩: n = 8 & 7 = 0। মোট ১-বিটের সংখ্যা = ৩!",
    ),
  ];

  final List<BitStep> _template3Steps = const [
    BitStep(
      activeNumber: 43261596,
      activeLineIndex: 4,
      binaryRepresentation: "0011 1101 0011 1100 0001 0100 0000 0000",
      resultVal: 964176192,
      explanationEn: "🎉 Line 5: 32-Bit Reversal Completed! Reversed Integer = 964176192!",
      explanationBn: "🎉 লাইন ৫: ৩২-বিট বাইনারি রিভার্স সম্পন্ন! উল্টানো ইনটিজার মান = 964176192!",
    ),
  ];

  List<BitStep> get _currentSteps {
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
              _buildTemplateChip(0, widget.isEnglish ? "Single Number (XOR)" : "ইউনিক সংখ্যা (XOR)"),
              _buildTemplateChip(1, widget.isEnglish ? "Kernighan's 1-Bit Count" : "কার্নিগান ১-বিট গণনা"),
              _buildTemplateChip(2, widget.isEnglish ? "Reverse 32 Bits" : "৩২ বিট রিভার্স"),
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
              _buildBitCanvas(step),
            ],
          )
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildCodeSnippetWithHighlight(_currentCodeLines, step.activeLineIndex)),
              const SizedBox(width: 16),
              Expanded(child: _buildBitCanvas(step)),
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

  Widget _buildBitCanvas(BitStep step) {
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
              Text("Active Integer: [${step.activeNumber}]", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13)),
              Text("Result Val: [${step.resultVal}]", style: const TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 16),

          // Binary Bit Inspector Representation
          const Text("Binary Bit Representation Inspector:", style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.accentPurple.withOpacity(0.5)),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                step.binaryRepresentation,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.accentNeonCyan,
                  letterSpacing: 2,
                ),
              ),
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
