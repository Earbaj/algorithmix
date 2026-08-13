import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';

class ValidateBstAnimatedVisualizer extends StatefulWidget {
  final bool isEnglish;

  const ValidateBstAnimatedVisualizer({
    super.key,
    required this.isEnglish,
  });

  @override
  State<ValidateBstAnimatedVisualizer> createState() =>
      _ValidateBstAnimatedVisualizerState();
}

class ValidateBstStepData {
  final int currentNodeVal;
  final String minBoundStr;
  final String maxBoundStr;
  final bool isValid;
  final String titleEn;
  final String titleBn;
  final String explanationEn;
  final String explanationBn;

  const ValidateBstStepData({
    required this.currentNodeVal,
    required this.minBoundStr,
    required this.maxBoundStr,
    required this.isValid,
    required this.titleEn,
    required this.titleBn,
    required this.explanationEn,
    required this.explanationBn,
  });
}

class _ValidateBstAnimatedVisualizerState
    extends State<ValidateBstAnimatedVisualizer> {
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  late final List<ValidateBstStepData> _steps;

  @override
  void initState() {
    super.initState();
    _steps = const [
      ValidateBstStepData(
        currentNodeVal: 5,
        minBoundStr: "-INF",
        maxBoundStr: "+INF",
        isValid: true,
        titleEn: "1. Validate Root Node (5) [-INF < 5 < +INF]",
        titleBn: "১. রুট নোড (5) ভ্যালিডেশন [-INF < 5 < +INF]",
        explanationEn: "Root 5 is within bounds (-INF < 5 < +INF). Recurse left with maxBound=5, right with minBound=5.",
        explanationBn: "রুট 5 সীমানার ভেতরে (-INF < 5 < +INF)। বামে রিকার্সনে max=5 ও ডানে min=5 নেওয়া হলো।",
      ),
      ValidateBstStepData(
        currentNodeVal: 1,
        minBoundStr: "-INF",
        maxBoundStr: "5",
        isValid: true,
        titleEn: "2. Validate Left Child (1) [-INF < 1 < 5]",
        titleBn: "২. বাম নোড (1) ভ্যালিডেশন [-INF < 1 < 5]",
        explanationEn: "Node 1 is strictly smaller than parent 5 (-INF < 1 < 5). VALID!",
        explanationBn: "নোড 1 অভিভাবক 5 এর চেয়ে ছোট (-INF < 1 < 5)। ভ্যালিড!",
      ),
      ValidateBstStepData(
        currentNodeVal: 4,
        minBoundStr: "5",
        maxBoundStr: "+INF",
        isValid: false,
        titleEn: "3. Validate Right Child (4) [5 < 4 < +INF] -> VIOLATION! ❌",
        titleBn: "৩. ডান নোড (4) ভ্যালিডেশন [5 < 4 < +INF] -> লঙ্ঘন! ❌",
        explanationEn: "Node 4 in Right Subtree fails condition `4 > 5`! Return FALSE (INVALID BST)! ❌",
        explanationBn: "ডান নোড 4 শর্তের লঙ্ঘন `4 > 5` করেছে! রিটার্ন FALSE (অকার্যকর BST)! ❌",
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
            color: step.isValid ? AppTheme.accentNeonCyan.withOpacity(0.12) : Colors.redAccent.withOpacity(0.15),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: step.isValid ? AppTheme.accentNeonCyan.withOpacity(0.5) : Colors.redAccent),
          ),
          child: Row(
            children: [
              Icon(step.isValid ? Icons.verified_user_outlined : Icons.cancel_outlined, color: step.isValid ? AppTheme.accentNeonCyan : Colors.redAccent, size: 24),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.isEnglish ? step.titleEn : step.titleBn,
                      style: TextStyle(color: step.isValid ? AppTheme.accentNeonCyan : Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 14),
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

        // BST Validation Bounds Canvas
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFF090D16),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF1E293B)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Node: ${step.currentNodeVal}", style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 13, fontFamily: 'monospace')),
                  Text("Valid Bounds: (${step.minBoundStr} < val < ${step.maxBoundStr})", style: TextStyle(color: step.isValid ? AppTheme.accentGreen : Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 12, fontFamily: 'monospace')),
                ],
              ),
              const SizedBox(height: 20),

              // Visual Tree Layout
              Column(
                children: [
                  // Level 0: Root 5
                  _buildNodeCircle(5, step.currentNodeVal == 5, isValid: true),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.south_west, color: step.currentNodeVal == 1 ? AppTheme.accentNeonCyan : Colors.white.withOpacity(0.2), size: 20),
                      const SizedBox(width: 50),
                      Icon(Icons.south_east, color: step.currentNodeVal == 4 ? Colors.redAccent : Colors.white.withOpacity(0.2), size: 20),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Level 1: Left 1, Right 4
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildNodeCircle(1, step.currentNodeVal == 1, isValid: true),
                      const SizedBox(width: 45),
                      _buildNodeCircle(4, step.currentNodeVal == 4, isValid: false),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        _buildControls(),
      ],
    );
  }

  Widget _buildNodeCircle(int val, bool isCurrent, {required bool isValid, double size = 44}) {
    Color bg = const Color(0xFF1E293B);
    Color border = const Color(0xFF334155);
    Color textCol = Colors.white70;

    if (isCurrent) {
      if (isValid) {
        bg = AppTheme.accentNeonCyan.withOpacity(0.3);
        border = AppTheme.accentNeonCyan;
        textCol = AppTheme.accentNeonCyan;
      } else {
        bg = Colors.redAccent.withOpacity(0.3);
        border = Colors.redAccent;
        textCol = Colors.redAccent;
      }
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
        border: Border.all(color: border, width: isCurrent ? 2.5 : 1.5),
      ),
      child: Center(
        child: Text(
          "$val",
          style: TextStyle(color: textCol, fontWeight: FontWeight.bold, fontSize: size * 0.35, fontFamily: 'monospace'),
        ),
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
