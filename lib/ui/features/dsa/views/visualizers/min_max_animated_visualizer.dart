import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';

class MinMaxAnimatedVisualizer extends StatefulWidget {
  final bool isEnglish;

  const MinMaxAnimatedVisualizer({
    super.key,
    required this.isEnglish,
  });

  @override
  State<MinMaxAnimatedVisualizer> createState() => _MinMaxAnimatedVisualizerState();
}

class VisualizerStepData {
  final int pointerIndex;
  final int minVal;
  final int maxVal;
  final String titleEn;
  final String titleBn;
  final String explanationEn;
  final String explanationBn;
  final String actionType; // 'init', 'compare', 'update_min', 'update_max', 'done'

  const VisualizerStepData({
    required this.pointerIndex,
    required this.minVal,
    required this.maxVal,
    required this.titleEn,
    required this.titleBn,
    required this.explanationEn,
    required this.explanationBn,
    required this.actionType,
  });
}

class _MinMaxAnimatedVisualizerState extends State<MinMaxAnimatedVisualizer> {
  final List<int> _array = [15, 42, 8, 99, 23];
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  late final List<VisualizerStepData> _steps;

  @override
  void initState() {
    super.initState();
    _steps = [
      VisualizerStepData(
        pointerIndex: 0,
        minVal: 15,
        maxVal: 15,
        titleEn: "1. Initialization",
        titleBn: "১. সূচনা (Initialization)",
        explanationEn: "Start with element at index 0 (15). Set initial minVal = 15 and maxVal = 15.",
        explanationBn: "ইন্ডেক্স 0 এর উপাদান (15) দিয়ে শুরু করি। প্রথম অবস্থায় minVal = 15 এবং maxVal = 15 ধরি।",
        actionType: 'init',
      ),
      VisualizerStepData(
        pointerIndex: 1,
        minVal: 15,
        maxVal: 42,
        titleEn: "2. Compare Element 42",
        titleBn: "২. উপাদান 42 এর সাথে তুলনা",
        explanationEn: "Inspect 42: 42 is greater than maxVal (15). Update maxVal = 42!",
        explanationBn: "42 উপাদানটি পর্যবেক্ষণ করি: 42 বর্তমান maxVal (15) এর চেয়ে বড়। তাই maxVal আপডেট হয়ে 42 হলো!",
        actionType: 'update_max',
      ),
      VisualizerStepData(
        pointerIndex: 2,
        minVal: 8,
        maxVal: 42,
        titleEn: "3. Compare Element 8",
        titleBn: "৩. উপাদান 8 এর সাথে তুলনা",
        explanationEn: "Inspect 8: 8 is smaller than minVal (15). Update minVal = 8!",
        explanationBn: "8 উপাদানটি পর্যবেক্ষণ করি: 8 বর্তমান minVal (15) এর চেয়ে ছোট। তাই minVal আপডেট হয়ে 8 হলো!",
        actionType: 'update_min',
      ),
      VisualizerStepData(
        pointerIndex: 3,
        minVal: 8,
        maxVal: 99,
        titleEn: "4. Compare Element 99",
        titleBn: "৪. উপাদান 99 এর সাথে তুলনা",
        explanationEn: "Inspect 99: 99 is greater than maxVal (42). Update maxVal = 99!",
        explanationBn: "99 উপাদানটি পর্যবেক্ষণ করি: 99 বর্তমান maxVal (42) এর চেয়ে বড়। তাই maxVal আপডেট হয়ে 99 হলো!",
        actionType: 'update_max',
      ),
      VisualizerStepData(
        pointerIndex: 4,
        minVal: 8,
        maxVal: 99,
        titleEn: "5. Compare Element 23",
        titleBn: "৫. উপাদান 23 এর সাথে তুলনা",
        explanationEn: "Inspect 23: 23 is between minVal (8) and maxVal (99). Bounds remain unchanged.",
        explanationBn: "23 উপাদানটি 8 এবং 99 এর মধ্যে অবস্থিত। তাই minVal বা maxVal পরিবর্তন করার প্রয়োজন নেই।",
        actionType: 'compare',
      ),
      VisualizerStepData(
        pointerIndex: -1,
        minVal: 8,
        maxVal: 99,
        titleEn: "6. Animation Finished 🎉",
        titleBn: "৬. অ্যানিমেশন সমাপ্ত 🎉",
        explanationEn: "Array traversal finished! Found Minimum = 8 and Maximum = 99.",
        explanationBn: "সম্পূর্ণ অ্যারে চেক করা শেষ! সর্বনিম্ন মান = 8 এবং সর্বোচ্চ মান = 99।",
        actionType: 'done',
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
        // Title banner
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
              const Icon(Icons.movie_filter_outlined, color: AppTheme.accentNeonCyan, size: 22),
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

        // Visual Canvas Box
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF090D16),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF1E293B)),
          ),
          child: Column(
            children: [
              // Dynamic Tracker Badges (Min & Max)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildTrackerCard(
                    title: widget.isEnglish ? "MIN VALUE" : "সর্বনিম্ন মান (MIN)",
                    value: step.minVal,
                    color: AppTheme.accentGreen,
                    icon: Icons.arrow_downward,
                    isUpdated: step.actionType == 'update_min' || step.actionType == 'init',
                  ),
                  _buildTrackerCard(
                    title: widget.isEnglish ? "MAX VALUE" : "সর্বোচ্চ মান (MAX)",
                    value: step.maxVal,
                    color: AppTheme.accentAmber,
                    icon: Icons.arrow_upward,
                    isUpdated: step.actionType == 'update_max' || step.actionType == 'init',
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Animated Array Elements
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_array.length, (idx) {
                    final isCurrent = idx == step.pointerIndex;
                    final val = _array[idx];
                    final isMin = val == step.minVal;
                    final isMax = val == step.maxVal;

                    Color borderColor = const Color(0xFF334155);
                    Color bgColor = const Color(0xFF1E293B);
                    if (isCurrent) {
                      borderColor = AppTheme.accentNeonCyan;
                      bgColor = AppTheme.accentNeonCyan.withOpacity(0.2);
                    } else if (isMin) {
                      borderColor = AppTheme.accentGreen;
                      bgColor = AppTheme.accentGreen.withOpacity(0.15);
                    } else if (isMax) {
                      borderColor = AppTheme.accentAmber;
                      bgColor = AppTheme.accentAmber.withOpacity(0.15);
                    }

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 350),
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      width: 58,
                      height: 72,
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: borderColor, width: isCurrent ? 2.5 : 1.5),
                        boxShadow: isCurrent
                            ? [BoxShadow(color: AppTheme.accentNeonCyan.withOpacity(0.3), blurRadius: 10, spreadRadius: 1)]
                            : [],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "[$idx]",
                            style: TextStyle(
                              fontSize: 10,
                              color: isCurrent ? AppTheme.accentNeonCyan : AppTheme.textSecondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "$val",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isCurrent
                                  ? Colors.white
                                  : isMin
                                      ? AppTheme.accentGreen
                                      : isMax
                                          ? AppTheme.accentAmber
                                          : Colors.white70,
                            ),
                          ),
                          if (isCurrent)
                            const Icon(Icons.keyboard_arrow_up, color: AppTheme.accentNeonCyan, size: 14),
                        ],
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.isEnglish ? "Interactive Animated Array State" : "ইন্টারেক্টিভ অ্যারে ভিজ্যুয়ালাইজেশন",
                style: const TextStyle(color: AppTheme.textMuted, fontSize: 11, fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Controls
        _buildControls(),
      ],
    );
  }

  Widget _buildTrackerCard({
    required String title,
    required int value,
    required Color color,
    required IconData icon,
    required bool isUpdated,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: isUpdated ? 2 : 1),
        boxShadow: isUpdated ? [BoxShadow(color: color.withOpacity(0.3), blurRadius: 8)] : [],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 14),
              const SizedBox(width: 4),
              Text(title, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            "$value",
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
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
