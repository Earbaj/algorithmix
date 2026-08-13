import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';

class SearchBstAnimatedVisualizer extends StatefulWidget {
  final bool isEnglish;

  const SearchBstAnimatedVisualizer({
    super.key,
    required this.isEnglish,
  });

  @override
  State<SearchBstAnimatedVisualizer> createState() =>
      _SearchBstAnimatedVisualizerState();
}

class SearchBstStepData {
  final int currentNodeVal;
  final int targetVal;
  final List<int> currentPath;
  final bool? isFound;
  final String titleEn;
  final String titleBn;
  final String explanationEn;
  final String explanationBn;

  const SearchBstStepData({
    required this.currentNodeVal,
    required this.targetVal,
    required this.currentPath,
    this.isFound,
    required this.titleEn,
    required this.titleBn,
    required this.explanationEn,
    required this.explanationBn,
  });
}

class _SearchBstAnimatedVisualizerState
    extends State<SearchBstAnimatedVisualizer> {
  final int _targetVal = 2;

  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  late final List<SearchBstStepData> _steps;

  @override
  void initState() {
    super.initState();
    _steps = const [
      SearchBstStepData(
        currentNodeVal: 4,
        targetVal: 2,
        currentPath: [4],
        isFound: null,
        titleEn: "1. Start at Root Node (4)",
        titleBn: "১. রুট নোড (4) থেকে শুরু",
        explanationEn: "Compare target 2 with Root 4: Since 2 < 4, target must lie in the LEFT Subtree!",
        explanationBn: "টার্গেট 2 রুটের সাথে তুলনা: 2 < 4 হওয়ায় বাম সাবট্রিতে সার্চ করব!",
      ),
      SearchBstStepData(
        currentNodeVal: 2,
        targetVal: 2,
        currentPath: [4, 2],
        isFound: true,
        titleEn: "2. Move Left to Node (2) -> Target FOUND! 🎉",
        titleBn: "২. বামে নোড (2) এ গমন -> টার্গেট পাওয়া গেছে! 🎉",
        explanationEn: "Compare target 2 with Node 2: 2 == 2 MATCH! Return Subtree rooted at Node 2 in O(log N) time! 🎉",
        explanationBn: "নোড 2 == 2 ম্যাচ করেছে! নোড 2 ভিত্তিক সাবট্রি রিটার্ন করা হলো (O(log N))! 🎉",
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
              const Icon(Icons.account_tree_outlined, color: AppTheme.accentNeonCyan, size: 24),
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

        // BST Tree Graph Canvas
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
                  const Text("Target val = 2", style: TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13, fontFamily: 'monospace')),
                  Text("Search Path: ${step.currentPath.join(' ➔ ')}", style: const TextStyle(color: Colors.white70, fontSize: 12, fontFamily: 'monospace')),
                ],
              ),
              const SizedBox(height: 20),

              // Visual Tree Layout
              Column(
                children: [
                  // Level 0: Root 4
                  _buildNodeCircle(4, step.currentPath.contains(4), step.currentNodeVal == 4),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.south_west, color: AppTheme.accentNeonCyan, size: 20),
                      const SizedBox(width: 50),
                      Icon(Icons.south_east, color: Colors.white.withOpacity(0.2), size: 20),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Level 1: Left 2, Right 7
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildNodeCircle(2, step.currentPath.contains(2), step.currentNodeVal == 2, isMatch: step.isFound == true),
                      const SizedBox(width: 45),
                      _buildNodeCircle(7, step.currentPath.contains(7), step.currentNodeVal == 7),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.south_west, color: Colors.white.withOpacity(0.2), size: 16),
                          const SizedBox(width: 12),
                          Icon(Icons.south_east, color: Colors.white.withOpacity(0.2), size: 16),
                        ],
                      ),
                      const SizedBox(width: 55),
                      const SizedBox(width: 32),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Level 2: Left-Left 1, Left-Right 3
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildNodeCircle(1, false, false, size: 36),
                      const SizedBox(width: 14),
                      _buildNodeCircle(3, false, false, size: 36),
                      const SizedBox(width: 60),
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

  Widget _buildNodeCircle(int val, bool isInPath, bool isCurrent, {bool isMatch = false, double size = 44}) {
    Color bg = const Color(0xFF1E293B);
    Color border = const Color(0xFF334155);
    Color textCol = Colors.white70;

    if (isMatch) {
      bg = AppTheme.accentGreen.withOpacity(0.3);
      border = AppTheme.accentGreen;
      textCol = AppTheme.accentGreen;
    } else if (isCurrent) {
      bg = AppTheme.accentNeonCyan.withOpacity(0.3);
      border = AppTheme.accentNeonCyan;
      textCol = AppTheme.accentNeonCyan;
    } else if (isInPath) {
      bg = AppTheme.accentNeonCyan.withOpacity(0.15);
      border = AppTheme.accentNeonCyan.withOpacity(0.6);
      textCol = Colors.white;
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
        border: Border.all(color: border, width: isCurrent || isMatch ? 2.5 : 1.5),
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
