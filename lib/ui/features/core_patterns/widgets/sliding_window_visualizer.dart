import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class SlidingWindowStep {
  final int left;
  final int right;
  final int activeLineIndex;
  final List<int> arrayState;
  final int currentMetric; // Current Sum or Length
  final int bestMetric;    // Max Sum or Min Length
  final String explanationEn;
  final String explanationBn;

  const SlidingWindowStep({
    required this.left,
    required this.right,
    required this.activeLineIndex,
    required this.arrayState,
    required this.currentMetric,
    required this.bestMetric,
    required this.explanationEn,
    required this.explanationBn,
  });
}

class SlidingWindowVisualizer extends StatefulWidget {
  final bool isEnglish;

  const SlidingWindowVisualizer({super.key, required this.isEnglish});

  @override
  State<SlidingWindowVisualizer> createState() => _SlidingWindowVisualizerState();
}

class _SlidingWindowVisualizerState extends State<SlidingWindowVisualizer> {
  int _selectedTemplateIndex = 0;
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  final List<List<String>> _codeTemplates = const [
    // Template 1: Fixed Size Window K (Max Sum Subarray of Size K)
    [
      "int maxSubarraySum(vector<int>& arr, int k) {",
      "    int curr_sum = 0;",
      "    for (int i = 0; i < k; i++) curr_sum += arr[i];",
      "    int max_sum = curr_sum;",
      "    for (int right = k; right < arr.size(); right++) {",
      "        curr_sum += arr[right] - arr[right - k];",
      "        max_sum = max(max_sum, curr_sum);",
      "    }",
      "    return max_sum;",
      "}",
    ],
    // Template 2: Dynamic Max Window (Longest Substring Without Repeating Chars)
    [
      "int lengthOfLongestSubstring(string s) {",
      "    unordered_map<char, int> mp;",
      "    int left = 0, max_len = 0;",
      "    for (int right = 0; right < s.length(); right++) {",
      "        if (mp.count(s[right])) left = max(left, mp[s[right]] + 1);",
      "        mp[s[right]] = right;",
      "        max_len = max(max_len, right - left + 1);",
      "    }",
      "    return max_len;",
      "}",
    ],
    // Template 3: Dynamic Min Window (Minimum Size Subarray Sum >= Target)
    [
      "int minSubArrayLen(int target, vector<int>& nums) {",
      "    int left = 0, curr_sum = 0, min_len = INT_MAX;",
      "    for (int right = 0; right < nums.size(); right++) {",
      "        curr_sum += nums[right];",
      "        while (curr_sum >= target) {",
      "            min_len = min(min_len, right - left + 1);",
      "            curr_sum -= nums[left++];",
      "        }",
      "    }",
      "    return min_len;",
      "}",
    ],
  ];

  final List<SlidingWindowStep> _template1Steps = const [
    SlidingWindowStep(
      left: 0,
      right: 2,
      activeLineIndex: 1,
      arrayState: [2, 1, 5, 1, 3, 2],
      currentMetric: 0,
      bestMetric: 0,
      explanationEn: "Line 2: Initialize curr_sum = 0. Fixed Window size K = 3. Input = [2, 1, 5, 1, 3, 2].",
      explanationBn: "লাইন ২: curr_sum = 0 সূচনা। ফিক্সড উইন্ডো K = 3। ইনপুট = [2, 1, 5, 1, 3, 2]।",
    ),
    SlidingWindowStep(
      left: 0,
      right: 2,
      activeLineIndex: 2,
      arrayState: [2, 1, 5, 1, 3, 2],
      currentMetric: 8,
      bestMetric: 8,
      explanationEn: "Line 3: First K=3 elements window [2, 1, 5] -> curr_sum = 2 + 1 + 5 = 8.",
      explanationBn: "লাইন ৩: প্রথম K=3 উইন্ডো [2, 1, 5] -> curr_sum = 8।",
    ),
    SlidingWindowStep(
      left: 0,
      right: 2,
      activeLineIndex: 3,
      arrayState: [2, 1, 5, 1, 3, 2],
      currentMetric: 8,
      bestMetric: 8,
      explanationEn: "Line 4: Set max_sum = 8.",
      explanationBn: "লাইন ৪: max_sum = 8 সেট করা হলো।",
    ),
    SlidingWindowStep(
      left: 1,
      right: 3,
      activeLineIndex: 5,
      arrayState: [2, 1, 5, 1, 3, 2],
      currentMetric: 7,
      bestMetric: 8,
      explanationEn: "Line 6: Slide Window to [1, 5, 1]! Add right (1) and subtract left (2) -> curr_sum = 8 + 1 - 2 = 7.",
      explanationBn: "লাইন ৬: স্লাইড উইন্ডো [1, 5, 1]! ডান (1) যোগ এবং বাম (2) বিয়োগ -> curr_sum = 7।",
    ),
    SlidingWindowStep(
      left: 2,
      right: 4,
      activeLineIndex: 5,
      arrayState: [2, 1, 5, 1, 3, 2],
      currentMetric: 9,
      bestMetric: 9,
      explanationEn: "Line 6: Slide Window to [5, 1, 3]! Add right (3) and subtract left (1) -> curr_sum = 7 + 3 - 1 = 9.",
      explanationBn: "লাইন ৬: স্লাইড উইন্ডো [5, 1, 3]! ডান (3) যোগ এবং বাম (1) বিয়োগ -> curr_sum = 9।",
    ),
    SlidingWindowStep(
      left: 2,
      right: 4,
      activeLineIndex: 6,
      arrayState: [2, 1, 5, 1, 3, 2],
      currentMetric: 9,
      bestMetric: 9,
      explanationEn: "Line 7: Update max_sum = max(8, 9) = 9!",
      explanationBn: "লাইন ৭: max_sum আপডেট হয়ে 9 হলো!",
    ),
    SlidingWindowStep(
      left: 3,
      right: 5,
      activeLineIndex: 5,
      arrayState: [2, 1, 5, 1, 3, 2],
      currentMetric: 6,
      bestMetric: 9,
      explanationEn: "Line 6: Slide Window to [1, 3, 2]! Add right (2) and subtract left (5) -> curr_sum = 9 + 2 - 5 = 6.",
      explanationBn: "লাইন ৬: স্লাইড উইন্ডো [1, 3, 2]! ডান (2) যোগ এবং বাম (5) বিয়োগ -> curr_sum = 6।",
    ),
    SlidingWindowStep(
      activeLineIndex: 8,
      left: 2,
      right: 4,
      arrayState: [2, 1, 5, 1, 3, 2],
      currentMetric: 9,
      bestMetric: 9,
      explanationEn: "🎉 Line 9: Sliding Window Complete! Maximum Sum of Subarray of size K=3 is 9!",
      explanationBn: "🎉 লাইন ৯: স্লাইডিং উইন্ডো সম্পন্ন! K=3 সাইজের সর্বোচ্চ যোগফল = 9!",
    ),
  ];

  final List<SlidingWindowStep> _template2Steps = const [
    SlidingWindowStep(
      left: 0,
      right: 0,
      activeLineIndex: 2,
      arrayState: [1, 2, 3, 1, 2, 3], // Represents ASCII chars 'a', 'b', 'c', 'a'...
      currentMetric: 1,
      bestMetric: 1,
      explanationEn: "Line 3: Start window at right = 0 ('a'). Window = ['a']. max_len = 1.",
      explanationBn: "লাইন ৩: right = 0 ('a') এ উইন্ডো শুরু। উইন্ডো = ['a']। max_len = 1।",
    ),
    SlidingWindowStep(
      left: 0,
      right: 1,
      activeLineIndex: 5,
      arrayState: [1, 2, 3, 1, 2, 3],
      currentMetric: 2,
      bestMetric: 2,
      explanationEn: "Line 6: Add 'b' -> Window = ['a', 'b']. All unique! max_len = 2.",
      explanationBn: "লাইন ৬: 'b' যোগ -> উইন্ডো = ['a', 'b']। ইউনিক ক্যারেক্টার! max_len = 2।",
    ),
    SlidingWindowStep(
      left: 0,
      right: 2,
      activeLineIndex: 5,
      arrayState: [1, 2, 3, 1, 2, 3],
      currentMetric: 3,
      bestMetric: 3,
      explanationEn: "Line 6: Add 'c' -> Window = ['a', 'b', 'c']. All unique! max_len = 3.",
      explanationBn: "লাইন ৬: 'c' যোগ -> উইন্ডো = ['a', 'b', 'c']। ইউনিক ক্যারেক্টার! max_len = 3।",
    ),
    SlidingWindowStep(
      left: 1,
      right: 3,
      activeLineIndex: 4,
      arrayState: [1, 2, 3, 1, 2, 3],
      currentMetric: 3,
      bestMetric: 3,
      explanationEn: "⚡ Line 5: Duplicate 'a' found at right = 3! Jump left pointer = 1. Window = ['b', 'c', 'a'].",
      explanationBn: "⚡ লাইন ৫: ডুপ্লিকেট 'a' পাওয়া গেছে! left পয়েন্টার সরিয়ে 1 করা হলো। উইন্ডো = ['b', 'c', 'a']।",
    ),
    SlidingWindowStep(
      left: 1,
      right: 3,
      activeLineIndex: 7,
      arrayState: [1, 2, 3, 1, 2, 3],
      currentMetric: 3,
      bestMetric: 3,
      explanationEn: "🎉 Line 8: Longest Substring Without Repeating Characters = 3!",
      explanationBn: "🎉 লাইন ৮: কোনো অক্ষরের পুনরাবৃত্তি ছাড়া সর্বোচ্চ সাবস্ট্রিং দৈর্ঘ্য = 3!",
    ),
  ];

  final List<SlidingWindowStep> _template3Steps = const [
    SlidingWindowStep(
      left: 0,
      right: 0,
      activeLineIndex: 1,
      arrayState: [2, 3, 1, 2, 4, 3],
      currentMetric: 2,
      bestMetric: 99,
      explanationEn: "Line 2: Target Sum = 7. Expand right = 0 (val 2) -> curr_sum = 2 (< 7).",
      explanationBn: "লাইন ২: টার্গেট যোগফল = 7। ডান পয়েন্টার বাড়ানো হলো (মান 2) -> যোগফল 2 (< 7)।",
    ),
    SlidingWindowStep(
      left: 0,
      right: 3,
      activeLineIndex: 3,
      arrayState: [2, 3, 1, 2, 4, 3],
      currentMetric: 8,
      bestMetric: 4,
      explanationEn: "Line 4: Expand right = 3 -> curr_sum = 2+3+1+2 = 8 (>= 7). Window len = 4. min_len = 4.",
      explanationBn: "লাইন ৪: ডান বাড়ানো হলো -> যোগফল 8 (>= 7)। উইন্ডোর দৈর্ঘ্য = 4। min_len = 4।",
    ),
    SlidingWindowStep(
      left: 3,
      right: 4,
      activeLineIndex: 5,
      arrayState: [2, 3, 1, 2, 4, 3],
      currentMetric: 6,
      bestMetric: 2,
      explanationEn: "⚡ Line 6: Shrink left to 3! Window [2, 4] -> sum = 6. Recorded Min Window Length = 2!",
      explanationBn: "⚡ লাইন ৬: বাম কমানো হলো! উইন্ডো [2, 4] -> মিনিমাম উইন্ডো দৈর্ঘ্য = 2!",
    ),
    SlidingWindowStep(
      left: 4,
      right: 5,
      activeLineIndex: 5,
      arrayState: [2, 3, 1, 2, 4, 3],
      currentMetric: 7,
      bestMetric: 2,
      explanationEn: "🎉 Line 6: Window [4, 3] -> sum = 7 (>= 7). Min Window Length = 2! Complete!",
      explanationBn: "🎉 লাইন ৬: উইন্ডো [4, 3] -> যোগফল 7। সর্বনিম্ন সাব-অ্যারে দৈর্ঘ্য = 2! সম্পন্ন!",
    ),
  ];

  List<SlidingWindowStep> get _currentSteps {
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
              _buildTemplateChip(0, widget.isEnglish ? "Fixed Window (K)" : "ফিক্সড উইন্ডো (K)"),
              _buildTemplateChip(1, widget.isEnglish ? "Dynamic Max Window" : "ডাইনামিক ম্যাক্স উইন্ডো"),
              _buildTemplateChip(2, widget.isEnglish ? "Dynamic Min Window" : "ডাইনামিক মিন উইন্ডো"),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Status Log Banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.accentPink.withOpacity(0.15),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.accentPink),
          ),
          child: Text(
            widget.isEnglish ? step.explanationEn : step.explanationBn,
            style: const TextStyle(color: AppTheme.accentPink, fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
        const SizedBox(height: 16),

        // Code Snippet + Visualizer Box Layout
        if (isMobile)
          Column(
            children: [
              _buildCodeSnippetWithHighlight(_currentCodeLines, step.activeLineIndex),
              const SizedBox(height: 16),
              _buildWindowCanvas(step),
            ],
          )
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildCodeSnippetWithHighlight(_currentCodeLines, step.activeLineIndex)),
              const SizedBox(width: 16),
              Expanded(child: _buildWindowCanvas(step)),
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
        selectedColor: AppTheme.accentPink,
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
              color: isHighlighted ? AppTheme.accentPink.withOpacity(0.25) : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: isHighlighted ? Border.all(color: AppTheme.accentPink) : null,
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

  Widget _buildWindowCanvas(SlidingWindowStep step) {
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
          // Inspector Metrics
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("Current Metric: ${step.currentMetric}", style: const TextStyle(color: AppTheme.accentPink, fontWeight: FontWeight.bold, fontSize: 13)),
              Text("Best Metric: ${step.bestMetric == 99 ? 'INF' : step.bestMetric}", style: const TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 16),

          // Horizontal Sliding Window Array Container
          const Text("Sliding Window Array Highlight (Left -> Right):", style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(step.arrayState.length, (i) {
                final inWindow = i >= step.left && i <= step.right;
                final isLeft = i == step.left;
                final isRight = i == step.right;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 54,
                  height: 65,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    color: inWindow ? AppTheme.accentPink : AppTheme.surfaceDark,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: (isLeft || isRight) ? Colors.white : (inWindow ? AppTheme.accentPink : const Color(0xFF1E293B)),
                      width: (isLeft || isRight) ? 2.5 : 1,
                    ),
                    boxShadow: inWindow ? [BoxShadow(color: AppTheme.accentPink.withOpacity(0.5), blurRadius: 8)] : [],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("${step.arrayState[i]}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: inWindow ? Colors.white : AppTheme.textMuted)),
                      const SizedBox(height: 4),
                      Text(
                        isLeft && isRight ? "L & R" : (isLeft ? "LEFT" : (isRight ? "RIGHT" : "[$i]")),
                        style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.bold, color: inWindow ? Colors.white70 : AppTheme.textMuted),
                      ),
                    ],
                  ),
                );
              }),
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
