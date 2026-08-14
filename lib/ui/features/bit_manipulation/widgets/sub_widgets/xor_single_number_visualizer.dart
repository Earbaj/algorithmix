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

class XORSingleNumberVisualizer extends StatefulWidget {
  final bool isEnglish;

  const XORSingleNumberVisualizer({super.key, required this.isEnglish});

  @override
  State<XORSingleNumberVisualizer> createState() => _XORSingleNumberVisualizerState();
}

class _XORSingleNumberVisualizerState extends State<XORSingleNumberVisualizer> {
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  final List<String> _codeLines = const [
    "int singleNumber(vector<int>& nums) {",
    "    int result = 0;",
    "    for (int num : nums) {",
    "        result ^= num; // XOR cancels duplicate pairs (A ^ A = 0)",
    "    }",
    "    return result; // Unique single element remaining!",
    "}",
  ];

  final List<BitStep> _steps = const [
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
            color: step.activeLineIndex == 5 ? AppTheme.accentGreen.withOpacity(0.15) : AppTheme.accentNeonCyan.withOpacity(0.15),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: step.activeLineIndex == 5 ? AppTheme.accentGreen : AppTheme.accentNeonCyan),
          ),
          child: Text(
            widget.isEnglish ? step.explanationEn : step.explanationBn,
            style: TextStyle(
              color: step.activeLineIndex == 5 ? AppTheme.accentGreen : AppTheme.accentNeonCyan,
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

  Widget _buildCanvas(BitStep step) {
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
              Text("Active Num: ${step.activeNumber}", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13)),
              Text("Result: ${step.resultVal}", style: const TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.accentPurple.withOpacity(0.5)),
            ),
            child: Column(
              children: [
                const Text("Accumulated XOR Binary:", style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                const SizedBox(height: 8),
                Text(step.binaryRepresentation, style: const TextStyle(fontFamily: 'monospace', color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 16)),
              ],
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
