import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class VisualizerStep {
  final int left;
  final int right;
  final int? fixed;
  final List<int> arrayState;
  final String explanationEn;
  final String explanationBn;
  final bool isMatch;

  const VisualizerStep({
    required this.left,
    required this.right,
    this.fixed,
    required this.arrayState,
    required this.explanationEn,
    required this.explanationBn,
    this.isMatch = false,
  });
}

class TwoPointersVisualizer extends StatefulWidget {
  final bool isEnglish;

  const TwoPointersVisualizer({super.key, required this.isEnglish});

  @override
  State<TwoPointersVisualizer> createState() => _TwoPointersVisualizerState();
}

class _TwoPointersVisualizerState extends State<TwoPointersVisualizer> {
  int _selectedTemplateIndex = 0;
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  // Template 1 Data (Two Sum II: target = 10)
  final List<VisualizerStep> _template1Steps = const [
    VisualizerStep(
      left: 0,
      right: 6,
      arrayState: [1, 2, 4, 6, 8, 11, 15],
      explanationEn: "Start: left=0 (1), right=6 (15). Sum = 1 + 15 = 16 > 10. Sum is too large, move right--",
      explanationBn: "শুরু: left=0 (1), right=6 (15)। Sum = 1 + 15 = 16 > 10। Sum বড়, তাই right-- করতে হবে।",
    ),
    VisualizerStep(
      left: 0,
      right: 5,
      arrayState: [1, 2, 4, 6, 8, 11, 15],
      explanationEn: "left=0 (1), right=5 (11). Sum = 1 + 11 = 12 > 10. Still too large, move right--",
      explanationBn: "left=0 (1), right=5 (11)। Sum = 1 + 11 = 12 > 10। এখনও বড়, তাই right-- করুন।",
    ),
    VisualizerStep(
      left: 0,
      right: 4,
      arrayState: [1, 2, 4, 6, 8, 11, 15],
      explanationEn: "left=0 (1), right=4 (8). Sum = 1 + 8 = 9 < 10. Sum is too small, move left++",
      explanationBn: "left=0 (1), right=4 (8)। Sum = 1 + 8 = 9 < 10। Sum ছোট, তাই left++ করতে হবে।",
    ),
    VisualizerStep(
      left: 1,
      right: 4,
      arrayState: [1, 2, 4, 6, 8, 11, 15],
      explanationEn: "🎉 TARGET FOUND! left=1 (2), right=4 (8). Sum = 2 + 8 = 10 == Target 10!",
      explanationBn: "🎉 টার্গেট পাওয়া গেছে! left=1 (2), right=4 (8)। Sum = 2 + 8 = 10 == Target 10!",
      isMatch: true,
    ),
  ];

  // Template 2 Data (Move Zeroes)
  final List<VisualizerStep> _template2Steps = const [
    VisualizerStep(
      left: 0,
      right: 0,
      arrayState: [0, 1, 0, 3, 12],
      explanationEn: "Start: slow=0 (val 0), fast=0 (val 0). Element is 0, fast moves ahead.",
      explanationBn: "শুরু: slow=0, fast=0। মান 0, তাই fast আগাবে।",
    ),
    VisualizerStep(
      left: 0,
      right: 1,
      arrayState: [0, 1, 0, 3, 12],
      explanationEn: "fast=1 (val 1 != 0). Swap arr[slow] and arr[fast], then slow++",
      explanationBn: "fast=1 (মান 1 != 0)। slow ও fast এর মান swap করুন, slow++ করুন।",
    ),
    VisualizerStep(
      left: 1,
      right: 2,
      arrayState: [1, 0, 0, 3, 12],
      explanationEn: "fast=2 (val 0). Is zero, fast moves ahead.",
      explanationBn: "fast=2 (মান 0)। zero পাওয়া গেছে, fast আগাবে।",
    ),
    VisualizerStep(
      left: 1,
      right: 3,
      arrayState: [1, 0, 0, 3, 12],
      explanationEn: "fast=3 (val 3 != 0). Swap arr[1] and arr[3], then slow++",
      explanationBn: "fast=3 (মান 3 != 0)। arr[1] ও arr[3] swap করুন, slow++ করুন।",
    ),
    VisualizerStep(
      left: 2,
      right: 4,
      arrayState: [1, 3, 0, 0, 12],
      explanationEn: "fast=4 (val 12 != 0). Swap arr[2] and arr[4], then slow++",
      explanationBn: "fast=4 (মান 12 != 0)। arr[2] ও arr[4] swap করুন, slow++ করুন।",
    ),
    VisualizerStep(
      left: 3,
      right: 4,
      arrayState: [1, 3, 12, 0, 0],
      explanationEn: "🎉 DONE! All non-zero elements moved to front: [1, 3, 12, 0, 0]",
      explanationBn: "🎉 কাজ শেষ! সব non-zero মান সামনে চলে এসেছে: [1, 3, 12, 0, 0]",
      isMatch: true,
    ),
  ];

  List<VisualizerStep> get _currentSteps {
    return _selectedTemplateIndex == 0 ? _template1Steps : _template2Steps;
  }

  final List<String> _codes = const [
    '''
// Template 1: Opposite Direction (C++ Two Sum II)
vector<int> twoSum(vector<int>& arr, int target) {
    int left = 0, right = arr.size() - 1;
    while (left < right) {
        int curr_sum = arr[left] + arr[right];
        if (curr_sum == target) return {left, right};
        else if (curr_sum < target) left++;
        else right--;
    }
    return {-1, -1};
}''',
    '''
// Template 2: Same Direction (C++ Move Zeroes)
void moveZeroes(vector<int>& nums) {
    int slow = 0;
    for (int fast = 0; fast < nums.size(); fast++) {
        if (nums[fast] != 0) {
            swap(nums[slow], nums[fast]);
            slow++;
        }
    }
}''',
  ];

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;
    });

    if (_isPlaying) {
      _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
        if (_currentStepIndex < _currentSteps.length - 1) {
          setState(() {
            _currentStepIndex++;
          });
        } else {
          _timer?.cancel();
          setState(() {
            _isPlaying = false;
          });
        }
      });
    } else {
      _timer?.cancel();
    }
  }

  void _nextStep() {
    if (_currentStepIndex < _currentSteps.length - 1) {
      setState(() {
        _currentStepIndex++;
      });
    }
  }

  void _prevStep() {
    if (_currentStepIndex > 0) {
      setState(() {
        _currentStepIndex--;
      });
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
    final step = _currentSteps[_currentStepIndex];
    final isMobile = Responsive.isMobile(context);

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.accentPurple.withOpacity(0.4)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Selector & Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.isEnglish ? "C++ Code & Visualizer" : "C++ কোড ও ভিজ্যুয়ালাইজার",
                style: TextStyle(
                  fontSize: Responsive.sp(context, 16),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              DropdownButton<int>(
                value: _selectedTemplateIndex,
                dropdownColor: AppTheme.primaryDark,
                style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold),
                underline: Container(),
                items: [
                  DropdownMenuItem(
                    value: 0,
                    child: Text(widget.isEnglish ? "Opposite Direction (C++)" : "Opposite Direction (C++)"),
                  ),
                  DropdownMenuItem(
                    value: 1,
                    child: Text(widget.isEnglish ? "Same Direction (C++)" : "Same Direction (C++)"),
                  ),
                ],
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedTemplateIndex = val;
                      _reset();
                    });
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Code & Visualizer Container (Responsive Layout)
          if (isMobile)
            Column(
              children: [
                _buildCodeSnippet(_codes[_selectedTemplateIndex]),
                const SizedBox(height: 16),
                _buildVisualizerBox(step),
              ],
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildCodeSnippet(_codes[_selectedTemplateIndex])),
                const SizedBox(width: 16),
                Expanded(child: _buildVisualizerBox(step)),
              ],
            ),

          const SizedBox(height: 16),

          // Controls Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppTheme.primaryDark,
              borderRadius: BorderRadius.circular(14),
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
                      icon: const Icon(Icons.refresh, color: AppTheme.textMuted),
                      onPressed: _reset,
                    ),
                  ],
                ),
                Text(
                  "Step ${_currentStepIndex + 1} / ${_currentSteps.length}",
                  style: const TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeSnippet(String code) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF090D16),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Text(
          code,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 13,
            color: Color(0xFF38BDF8),
            height: 1.4,
          ),
        ),
      ),
    );
  }

  Widget _buildVisualizerBox(VisualizerStep step) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: step.isMatch ? AppTheme.accentGreen : const Color(0xFF334155),
          width: step.isMatch ? 2.0 : 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Visual Array Elements
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(step.arrayState.length, (idx) {
                final isLeft = idx == step.left;
                final isRight = idx == step.right;

                Color boxBg = const Color(0xFF1E293B);
                Color borderColor = const Color(0xFF334155);
                String tag = "";

                if (isLeft && isRight) {
                  boxBg = AppTheme.accentPurple.withOpacity(0.3);
                  borderColor = AppTheme.accentPurple;
                  tag = "L/R";
                } else if (isLeft) {
                  boxBg = AppTheme.accentNeonCyan.withOpacity(0.3);
                  borderColor = AppTheme.accentNeonCyan;
                  tag = _selectedTemplateIndex == 0 ? "L" : "Slow";
                } else if (isRight) {
                  boxBg = AppTheme.accentPink.withOpacity(0.3);
                  borderColor = AppTheme.accentPink;
                  tag = _selectedTemplateIndex == 0 ? "R" : "Fast";
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    children: [
                      Text(
                        tag,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: isLeft
                              ? AppTheme.accentNeonCyan
                              : (isRight ? AppTheme.accentPink : Colors.transparent),
                        ),
                      ),
                      const SizedBox(height: 4),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: boxBg,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: borderColor, width: (isLeft || isRight) ? 2.0 : 1.0),
                        ),
                        child: Center(
                          child: Text(
                            '${step.arrayState[idx]}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '[$idx]',
                        style: const TextStyle(fontSize: 10, color: AppTheme.textMuted),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 16),

          // Explanation Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: step.isMatch
                  ? AppTheme.accentGreen.withOpacity(0.15)
                  : const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              widget.isEnglish ? step.explanationEn : step.explanationBn,
              style: TextStyle(
                fontSize: 13,
                color: step.isMatch ? AppTheme.accentGreen : AppTheme.textPrimary,
                fontWeight: step.isMatch ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
