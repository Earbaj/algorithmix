import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';

class EvaluateRpnAnimatedVisualizer extends StatefulWidget {
  final bool isEnglish;

  const EvaluateRpnAnimatedVisualizer({
    super.key,
    required this.isEnglish,
  });

  @override
  State<EvaluateRpnAnimatedVisualizer> createState() => _EvaluateRpnAnimatedVisualizerState();
}

class RpnStepData {
  final String currentToken;
  final String action;
  final List<int> stackItems;
  final String titleEn;
  final String titleBn;
  final String explanationEn;
  final String explanationBn;

  const RpnStepData({
    required this.currentToken,
    required this.action,
    required this.stackItems,
    required this.titleEn,
    required this.titleBn,
    required this.explanationEn,
    required this.explanationBn,
  });
}

class _EvaluateRpnAnimatedVisualizerState extends State<EvaluateRpnAnimatedVisualizer> {
  final List<String> _tokens = const ["2", "1", "+", "3", "*"];

  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  late final List<RpnStepData> _steps;

  @override
  void initState() {
    super.initState();
    _steps = const [
      RpnStepData(
        currentToken: "-",
        action: "INIT",
        stackItems: [],
        titleEn: "1. Initialization",
        titleBn: "১. সূচনা (Initialization)",
        explanationEn: "Tokens = [\"2\", \"1\", \"+\", \"3\", \"*\"]. Initialize empty Stack.",
        explanationBn: "টোকেনস = [\"2\", \"1\", \"+\", \"3\", \"*\"|। ফাঁকা স্ট্যাক সূচনা করা হলো।",
      ),
      RpnStepData(
        currentToken: "2",
        action: "PUSH",
        stackItems: [2],
        titleEn: "2. Push 2",
        titleBn: "২. পুশ 2",
        explanationEn: "Token is number \"2\". Push 2 onto Top of Stack.",
        explanationBn: "টোকেন সংখ্যা \"2\"। 2 কে স্ট্যাকের টপে পুশ করি।",
      ),
      RpnStepData(
        currentToken: "1",
        action: "PUSH",
        stackItems: [2, 1],
        titleEn: "3. Push 1",
        titleBn: "৩. পুশ 1",
        explanationEn: "Token is number \"1\". Push 1 onto Top of Stack.",
        explanationBn: "টোকেন সংখ্যা \"1\"। 1 কে স্ট্যাকের টপে পুশ করি।",
      ),
      RpnStepData(
        currentToken: "+",
        action: "EVAL (+)",
        stackItems: [3],
        titleEn: "4. Operator '+': Pop 1 & 2 -> (2 + 1 = 3) -> Push 3",
        titleBn: "৪. অপারেটর '+': 1 ও 2 পপ -> (2 + 1 = 3) -> 3 পুশ",
        explanationEn: "Token is '+'. Pop b=1, a=2. Evaluate a+b = 2+1 = 3. Push 3 onto Stack.",
        explanationBn: "অপারেটর '+'। b=1 ও a=2 পপ করা হলো। 2+1 = 3 মান স্ট্যাকে পুশ হলো।",
      ),
      RpnStepData(
        currentToken: "3",
        action: "PUSH",
        stackItems: [3, 3],
        titleEn: "5. Push 3",
        titleBn: "৫. পুশ 3",
        explanationEn: "Token is number \"3\". Push 3 onto Top of Stack.",
        explanationBn: "টোকেন সংখ্যা \"3\"। 3 কে স্ট্যাকের টপে পুশ করি।",
      ),
      RpnStepData(
        currentToken: "*",
        action: "EVAL (*)",
        stackItems: [9],
        titleEn: "6. Operator '*': Pop 3 & 3 -> (3 * 3 = 9) -> Push 9 🎉",
        titleBn: "৬. অপারেটর '*': 3 ও 3 পপ -> (3 * 3 = 9) -> 9 পুশ 🎉",
        explanationEn: "Token is '*'. Pop b=3, a=3. Evaluate a*b = 3*3 = 9. Final Answer = 9!",
        explanationBn: "অপারেটর '*'। b=3 ও a=3 পপ হলো। 3*3 = 9 স্ট্যাকে পুশ। চূড়ান্ত উত্তর = 9!",
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
              const Icon(Icons.calculate_outlined, color: AppTheme.accentNeonCyan, size: 24),
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

        // Vertical LIFO Stack Container Canvas
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
              // Token Row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.isEnglish ? "Postfix Tokens: " : "পোস্টফিক্স টোকেনস: ",
                    style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: List.generate(_tokens.length, (idx) {
                      final t = _tokens[idx];
                      final isCurrent = step.currentToken == t;

                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isCurrent ? AppTheme.accentNeonCyan.withOpacity(0.3) : const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: isCurrent ? AppTheme.accentNeonCyan : const Color(0xFF334155)),
                        ),
                        child: Text(
                          t,
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isCurrent ? AppTheme.accentNeonCyan : Colors.white70,
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Vertical Stack Bucket
              Container(
                width: 130,
                height: 180,
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(14), bottomRight: Radius.circular(14)),
                  border: Border(
                    left: BorderSide(color: AppTheme.accentGreen, width: 3),
                    right: BorderSide(color: AppTheme.accentGreen, width: 3),
                    bottom: BorderSide(color: AppTheme.accentGreen, width: 4),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      color: AppTheme.accentGreen.withOpacity(0.15),
                      child: const Text("TOP ⬆️", textAlign: TextAlign.center, style: TextStyle(color: AppTheme.accentGreen, fontSize: 9, fontWeight: FontWeight.bold)),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: SingleChildScrollView(
                          reverse: true,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (step.stackItems.isEmpty)
                                const Padding(padding: EdgeInsets.only(bottom: 20), child: Text("EMPTY", style: TextStyle(color: AppTheme.textMuted, fontSize: 10)))
                              else
                                ...List.generate(step.stackItems.length, (idx) {
                                  final itemIdx = step.stackItems.length - 1 - idx;
                                  final val = step.stackItems[itemIdx];
                                  final isTop = itemIdx == step.stackItems.length - 1;

                                  return Container(
                                    margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                                    padding: const EdgeInsets.symmetric(vertical: 6),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: isTop ? AppTheme.accentGreen.withOpacity(0.3) : AppTheme.surfaceDark,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: isTop ? AppTheme.accentGreen : const Color(0xFF334155)),
                                    ),
                                    child: Text(
                                      "$val",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontFamily: 'monospace', color: isTop ? AppTheme.accentGreen : Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
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
              const SizedBox(height: 14),
              Text(
                widget.isEnglish ? "Operands pushed onto LIFO stack; Operators pop 2 top values and evaluate" : "সংখ্যাগুলো LIFO স্ট্যাকে পুশ করা হয়; অপারেটর ২ টি মান পপ করে হিশাব সম্পন্ন করে",
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
