import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';

class FloydsCycleControlsWidget extends StatelessWidget {
  final bool isEnglish;
  final int currentStepIndex;
  final int totalSteps;
  final bool isPlaying;
  final VoidCallback onReset;
  final VoidCallback? onPrev;
  final VoidCallback onTogglePlay;
  final VoidCallback? onNext;

  const FloydsCycleControlsWidget({
    super.key,
    required this.isEnglish,
    required this.currentStepIndex,
    required this.totalSteps,
    required this.isPlaying,
    required this.onReset,
    required this.onPrev,
    required this.onTogglePlay,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
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
            onPressed: onReset,
            tooltip: isEnglish ? "Reset" : "রিসেট",
          ),
          IconButton(
            icon: const Icon(Icons.skip_previous, color: Colors.white),
            onPressed: onPrev,
            tooltip: isEnglish ? "Previous Step" : "আগের স্টেপ",
          ),
          ElevatedButton.icon(
            onPressed: onTogglePlay,
            icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
            label: Text(isPlaying
                ? (isEnglish ? "Pause" : "পজ করুন")
                : (isEnglish ? "Auto Play" : "অটো প্লে")),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentNeonCyan,
              foregroundColor: AppTheme.primaryDark,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.skip_next, color: Colors.white),
            onPressed: onNext,
            tooltip: isEnglish ? "Next Step" : "পরের স্টেপ",
          ),
          Text(
            "${currentStepIndex + 1}/$totalSteps",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
