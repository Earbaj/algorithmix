import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';

class InsertBstAnimatedVisualizer extends StatefulWidget {
  final bool isEnglish;

  const InsertBstAnimatedVisualizer({
    super.key,
    required this.isEnglish,
  });

  @override
  State<InsertBstAnimatedVisualizer> createState() =>
      _InsertBstAnimatedVisualizerState();
}

class InsertBstStepData {
  final int currentNodeVal;
  final int insertVal;
  final List<int> currentPath;
  final bool isInserted;
  final String titleEn;
  final String titleBn;
  final String explanationEn;
  final String explanationBn;

  const InsertBstStepData({
    required this.currentNodeVal,
    required this.insertVal,
    required this.currentPath,
    required this.isInserted,
    required this.titleEn,
    required this.titleBn,
    required this.explanationEn,
    required this.explanationBn,
  });
}

class _InsertBstAnimatedVisualizerState
    extends State<InsertBstAnimatedVisualizer> {
  final int _insertVal = 5;

  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  late final List<InsertBstStepData> _steps;

  @override
  void initState() {
    super.initState();
    _steps = const [
      InsertBstStepData(
        currentNodeVal: 4,
        insertVal: 5,
        currentPath: [4],
        isInserted: false,
        titleEn: "1. Compare with Root (4)",
        titleBn: "১. রুট নোড (4) এর সাথে তুলনা",
        explanationEn: "Insert val 5: Compare 5 with Root 4. Since 5 > 4, branch RIGHT into node 7.",
        explanationBn: "5 ইনসার্ট করতে: 5 > 4 হওয়ায় ডানে নোড 7 এ প্রবেশ করি।",
      ),
      InsertBstStepData(
        currentNodeVal: 7,
        insertVal: 5,
        currentPath: [4, 7],
        isInserted: false,
        titleEn: "2. Move Right to Node (7)",
        titleBn: "২. ডানে নোড (7) এ গমন",
        explanationEn: "Compare 5 with Node 7. Since 5 < 7, move to LEFT child. Left spot is `nullptr`!",
        explanationBn: "5 < 7 হওয়ায় বামে যাই। বামের স্থানটি খালি বা `nullptr`!",
      ),
      InsertBstStepData(
        currentNodeVal: 5,
        insertVal: 5,
        currentPath: [4, 7, 5],
        isInserted: true,
        titleEn: "3. Attach New TreeNode(5) as 7->left! 🎉",
        titleBn: "৩. 7->left হিসেবে নতুন নোড 5 যুক্ত হলো! 🎉",
        explanationEn: "Create and attach `new TreeNode(5)` as left child of 7. BST Property Preserved in O(log N)! 🎉",
        explanationBn: "নতুন `TreeNode(5)` নোড 7 এর বামে যুক্ত হলো। BST রুল সম্পূর্ণ সঠিক! 🎉",
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
              const Icon(Icons.add_chart, color: AppTheme.accentNeonCyan, size: 24),
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
                  Text("Inserting val = $_insertVal", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13, fontFamily: 'monospace')),
                  Text("Path: ${step.currentPath.join(' ➔ ')}", style: const TextStyle(color: Colors.white70, fontSize: 12, fontFamily: 'monospace')),
                ],
              ),
              const SizedBox(height: 20),

              // Visual Tree Layout with Newly Inserted Node
              Column(
                children: [
                  // Level 0: Root 4
                  _buildNodeCircle(4, step.currentPath.contains(4), step.currentNodeVal == 4),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.south_west, color: Colors.white.withOpacity(0.2), size: 20),
                      const SizedBox(width: 50),
                      const Icon(Icons.south_east, color: AppTheme.accentNeonCyan, size: 20),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Level 1: Left 2, Right 7
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildNodeCircle(2, false, false),
                      const SizedBox(width: 45),
                      _buildNodeCircle(7, step.currentPath.contains(7), step.currentNodeVal == 7),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 45),
                      if (step.isInserted)
                        const Icon(Icons.south_west, color: AppTheme.accentGreen, size: 20)
                      else
                        Icon(Icons.south_west, color: Colors.white.withOpacity(0.2), size: 16),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Level 2: Newly inserted 5
                  if (step.isInserted)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 25),
                        _buildNodeCircle(5, true, true, isNewInserted: true),
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

  Widget _buildNodeCircle(int val, bool isInPath, bool isCurrent, {bool isNewInserted = false, double size = 44}) {
    Color bg = const Color(0xFF1E293B);
    Color border = const Color(0xFF334155);
    Color textCol = Colors.white70;

    if (isNewInserted) {
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
        border: Border.all(color: border, width: isCurrent || isNewInserted ? 2.5 : 1.5),
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
