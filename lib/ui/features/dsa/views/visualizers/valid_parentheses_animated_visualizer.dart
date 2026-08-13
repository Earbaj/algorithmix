import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';

class ValidParenthesesAnimatedVisualizer extends StatefulWidget {
  final bool isEnglish;

  const ValidParenthesesAnimatedVisualizer({
    super.key,
    required this.isEnglish,
  });

  @override
  State<ValidParenthesesAnimatedVisualizer> createState() =>
      _ValidParenthesesAnimatedVisualizerState();
}

class StackStepData {
  final String charHandled;
  final String action; // PUSH, POP_MATCH, ERROR, DONE
  final List<String> stackItems; // bottom to top
  final String titleEn;
  final String titleBn;
  final String explanationEn;
  final String explanationBn;

  const StackStepData({
    required this.charHandled,
    required this.action,
    required this.stackItems,
    required this.titleEn,
    required this.titleBn,
    required this.explanationEn,
    required this.explanationBn,
  });
}

class _ValidParenthesesAnimatedVisualizerState
    extends State<ValidParenthesesAnimatedVisualizer> {
  final String _inputString = "([{}])";

  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  late final List<StackStepData> _steps;

  @override
  void initState() {
    super.initState();
    _steps = const [
      StackStepData(
        charHandled: "-",
        action: "INIT",
        stackItems: [],
        titleEn: "1. Initialization",
        titleBn: "১. সূচনা (Initialization)",
        explanationEn: "Initialize empty Stack container. Input string s = \"([{}])\".",
        explanationBn: "ফাঁকা স্ট্যাক সূচনা করি। ইনপুট স্ট্রিং s = \"([{}])\"।",
      ),
      StackStepData(
        charHandled: "(",
        action: "PUSH",
        stackItems: ["("],
        titleEn: "2. Push '(' onto Stack",
        titleBn: "২. '(' স্ট্যাকে পুশ (PUSH)",
        explanationEn: "Encountered opening bracket '('. Push '(' onto Top of Stack.",
        explanationBn: "ওপেনিং ব্র্যাকেট '(' পাওয়া গেছে। '(' কে স্ট্যাকের টপে পুশ করি।",
      ),
      StackStepData(
        charHandled: "[",
        action: "PUSH",
        stackItems: ["(", "["],
        titleEn: "3. Push '[' onto Stack",
        titleBn: "৩. '[' স্ট্যাকে পুশ (PUSH)",
        explanationEn: "Encountered opening bracket '['. Push '[' onto Top of Stack.",
        explanationBn: "ওপেনিং ব্র্যাকেট '[' পাওয়া গেছে। '[' কে স্ট্যাকের টপে পুশ করি।",
      ),
      StackStepData(
        charHandled: "{",
        action: "PUSH",
        stackItems: ["(", "[", "{"],
        titleEn: "4. Push '{' onto Stack",
        titleBn: "৪. '{' স্ট্যাকে পুশ (PUSH)",
        explanationEn: "Encountered opening bracket '{'. Push '{' onto Top of Stack.",
        explanationBn: "ওপেনিং ব্র্যাকেট '{' পাওয়া গেছে। '{' কে স্ট্যাকের টপে পুশ করি।",
      ),
      StackStepData(
        charHandled: "}",
        action: "POP_MATCH",
        stackItems: ["(", "["],
        titleEn: "5. Match '}' with Top '{' -> Pop!",
        titleBn: "৫. '}' এর সাথে টপ '{' ম্যাচ -> পপ (POP)",
        explanationEn: "Encountered closing bracket '}'. Top of stack is '{'. Match succeeded! Pop '{' off the stack.",
        explanationBn: "ক্লোজিং ব্র্যাকেট '}' পাওয়া গেছে। টপে থাকা '{' এর সাথে ম্যাচ হওয়ায় স্ট্যাক থেকে '{' পপ করি।",
      ),
      StackStepData(
        charHandled: "]",
        action: "POP_MATCH",
        stackItems: ["("],
        titleEn: "6. Match ']' with Top '[' -> Pop!",
        titleBn: "৬. ']' এর সাথে টপ '[' ম্যাচ -> পপ (POP)",
        explanationEn: "Encountered closing bracket ']'. Top of stack is '['. Match succeeded! Pop '[' off the stack.",
        explanationBn: "ক্লোজিং ব্র্যাকেট ']' পাওয়া গেছে। টপে থাকা '[' এর সাথে ম্যাচ হওয়ায় স্ট্যাক থেকে '[' পপ করি।",
      ),
      StackStepData(
        charHandled: ")",
        action: "POP_MATCH",
        stackItems: [],
        titleEn: "7. Match ')' with Top '(' -> Pop!",
        titleBn: "৭. ')' এর সাথে টপ '(' ম্যাচ -> পপ (POP)",
        explanationEn: "Encountered closing bracket ')'. Top of stack is '('. Match succeeded! Pop '(' off the stack.",
        explanationBn: "ক্লোজিং ব্র্যাকেট ')' পাওয়া গেছে। টপে থাকা '(' এর সাথে ম্যাচ হওয়ায় স্ট্যাক থেকে '(' পপ করি।",
      ),
      StackStepData(
        charHandled: "-",
        action: "DONE",
        stackItems: [],
        titleEn: "8. String Fully Processed & Stack Empty 🎉",
        titleBn: "৮. প্রসেসিং শেষ ও স্ট্যাক খালি! 🎉",
        explanationEn: "All characters processed and Stack is empty! String \"([{}])\" is VALID (Balanced)!",
        explanationBn: "সমস্ত ক্যারেক্টার শেষ এবং স্ট্যাক সম্পূর্ণ খালি! স্ট্রিংটি সঠিকভাবে ব্যালেন্সড! রিটার্ন TRUE!",
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
              const Icon(Icons.layers_outlined, color: AppTheme.accentNeonCyan, size: 24),
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

        // Visual Vertical Stack Bucket Canvas
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
              // Input string tokens
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.isEnglish ? "Input String: " : "ইনপুট স্ট্রিং: ",
                    style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: List.generate(_inputString.length, (idx) {
                      final char = _inputString[idx];
                      final isCurrentChar = step.charHandled == char;

                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isCurrentChar ? AppTheme.accentNeonCyan.withOpacity(0.3) : const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: isCurrentChar ? AppTheme.accentNeonCyan : const Color(0xFF334155),
                          ),
                        ),
                        child: Text(
                          char,
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isCurrentChar ? AppTheme.accentNeonCyan : Colors.white70,
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // VERTICAL STACK BUCKET
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Vertical Tube Frame
                  Container(
                    width: 140,
                    height: 220,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                      border: Border(
                        left: BorderSide(color: AppTheme.accentGreen, width: 3),
                        right: BorderSide(color: AppTheme.accentGreen, width: 3),
                        bottom: BorderSide(color: AppTheme.accentGreen, width: 4),
                        top: BorderSide.none, // OPEN TOP
                      ),
                    ),
                    child: Column(
                      children: [
                        // OPEN TOP HEADER
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.accentGreen.withOpacity(0.15),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.north, color: AppTheme.accentGreen, size: 14),
                              SizedBox(width: 4),
                              Text("OPEN TOP ⬆️", style: TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 10)),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: SingleChildScrollView(
                              reverse: true, // bottom up
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  if (step.stackItems.isEmpty)
                                    const Padding(
                                      padding: EdgeInsets.only(bottom: 20),
                                      child: Text(
                                        "[ STACK EMPTY ]",
                                        style: TextStyle(color: AppTheme.textMuted, fontSize: 10, fontStyle: FontStyle.italic),
                                      ),
                                    )
                                  else
                                    ...List.generate(step.stackItems.length, (idx) {
                                      // Render top item at the top of column
                                      final itemIndexFromTop = step.stackItems.length - 1 - idx;
                                      final item = step.stackItems[itemIndexFromTop];
                                      final isTop = itemIndexFromTop == step.stackItems.length - 1;

                                      return AnimatedContainer(
                                        duration: const Duration(milliseconds: 250),
                                        margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                                        width: double.infinity,
                                        height: 38,
                                        decoration: BoxDecoration(
                                          color: isTop
                                              ? AppTheme.accentGreen.withOpacity(0.3)
                                              : AppTheme.surfaceDark,
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                            color: isTop ? AppTheme.accentGreen : const Color(0xFF334155),
                                            width: isTop ? 2 : 1,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              item,
                                              style: TextStyle(
                                                fontFamily: 'monospace',
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: isTop ? AppTheme.accentGreen : Colors.white,
                                              ),
                                            ),
                                            if (isTop) ...[
                                              const SizedBox(width: 8),
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: AppTheme.accentGreen,
                                                  borderRadius: BorderRadius.circular(4),
                                                ),
                                                child: const Text("TOP", style: TextStyle(color: AppTheme.primaryDark, fontSize: 9, fontWeight: FontWeight.bold)),
                                              ),
                                            ],
                                          ],
                                        ),
                                      );
                                    }),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                widget.isEnglish
                    ? "LIFO Container: Last element PUSHED on Top is the First element POPPED!"
                    : "LIFO কনটেইনার: সবার শেষে টপে PUSH হওয়া উপাদানটি সবার আগে POP হয়!",
                style: const TextStyle(color: AppTheme.textMuted, fontSize: 11, fontStyle: FontStyle.italic),
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
