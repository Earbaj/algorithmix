import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class GreedyStep {
  final int activeIndex;
  final int activeLineIndex;
  final int stateVal; // e.g. maxReach, count, startStation
  final List<int> arrayState;
  final bool isSuccess;
  final String explanationEn;
  final String explanationBn;

  const GreedyStep({
    required this.activeIndex,
    required this.activeLineIndex,
    required this.stateVal,
    required this.arrayState,
    this.isSuccess = true,
    required this.explanationEn,
    required this.explanationBn,
  });
}

class GreedyAlgorithmVisualizer extends StatefulWidget {
  final bool isEnglish;

  const GreedyAlgorithmVisualizer({super.key, required this.isEnglish});

  @override
  State<GreedyAlgorithmVisualizer> createState() => _GreedyAlgorithmVisualizerState();
}

class _GreedyAlgorithmVisualizerState extends State<GreedyAlgorithmVisualizer> {
  int _selectedTemplateIndex = 0;
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  final List<List<String>> _codeTemplates = const [
    // Template 1: Jump Game
    [
      "bool canJump(vector<int>& nums) {",
      "    int maxReach = 0;",
      "    for (int i = 0; i < nums.size(); i++) {",
      "        if (i > maxReach) return false;          // Unreachable!",
      "        maxReach = max(maxReach, i + nums[i]);   // Greedily update max reach",
      "        if (maxReach >= nums.size() - 1) return true; // Goal reached!",
      "    }",
      "    return true;",
      "}",
    ],
    // Template 2: Non-overlapping Intervals
    [
      "int eraseOverlapIntervals(vector<vector<int>>& intervals) {",
      "    sort(intervals.begin(), intervals.end(), [](auto& a, auto& b) { return a[1] < b[1]; });",
      "    int count = 0, prevEnd = intervals[0][1];",
      "    for (int i = 1; i < intervals.size(); i++) {",
      "        if (intervals[i][0] < prevEnd) count++; // Overlap detected!",
      "        else prevEnd = intervals[i][1];",
      "    }",
      "    return count;",
      "}",
    ],
    // Template 3: Gas Station
    [
      "int canCompleteCircuit(vector<int>& gas, vector<int>& cost) {",
      "    int totalTank = 0, currentTank = 0, startStation = 0;",
      "    for (int i = 0; i < gas.size(); i++) {",
      "        totalTank += gas[i] - cost[i]; currentTank += gas[i] - cost[i];",
      "        if (currentTank < 0) { startStation = i + 1; currentTank = 0; }",
      "    }",
      "    return totalTank >= 0 ? startStation : -1;",
      "}",
    ],
  ];

  final List<GreedyStep> _template1Steps = const [
    GreedyStep(
      activeIndex: 0,
      activeLineIndex: 4,
      stateVal: 2,
      arrayState: [2, 3, 1, 1, 4],
      explanationEn: "Line 5: i = 0 (val 2). Greedily update maxReach = max(0, 0 + 2) = 2.",
      explanationBn: "লাইন ৫: i = 0 (মান 2)। maxReach = max(0, 0 + 2) = 2 এ আপডেট।",
    ),
    GreedyStep(
      activeIndex: 1,
      activeLineIndex: 4,
      stateVal: 4,
      arrayState: [2, 3, 1, 1, 4],
      explanationEn: "Line 5: i = 1 (val 3). Greedily update maxReach = max(2, 1 + 3) = 4.",
      explanationBn: "লাইন ৫: i = 1 (মান 3)। maxReach = max(2, 1 + 3) = 4 এ আপডেট।",
    ),
    GreedyStep(
      activeIndex: 1,
      activeLineIndex: 5,
      stateVal: 4,
      arrayState: [2, 3, 1, 1, 4],
      explanationEn: "🎉 Line 6: maxReach (4) >= N - 1 (4). Destination is Reachable in O(N)!",
      explanationBn: "🎉 লাইন ৬: maxReach (4) >= N - 1 (4)। ও(N) সময়ে গন্তব্যে পৌঁছানো সম্ভব!",
    ),
  ];

  final List<GreedyStep> _template2Steps = const [
    GreedyStep(
      activeIndex: 1,
      activeLineIndex: 4,
      stateVal: 1,
      arrayState: [1, 2, 2, 3, 1, 3],
      explanationEn: "Line 5: Overlap detected! Greedily evict interval. Overlap Count = 1.",
      explanationBn: "লাইন ৫: ওভারল্যাপ ধরা পড়েছে! অপটিমাল নিয়মে বাদ দেওয়া হলো। কাউন্ট = ১।",
    ),
    GreedyStep(
      activeIndex: 2,
      activeLineIndex: 4,
      stateVal: 1,
      arrayState: [1, 2, 2, 3, 1, 3],
      explanationEn: "🎉 Line 5: Processed all intervals. Minimum removals = 1!",
      explanationBn: "🎉 লাইন ৫: সব ইনটারভাল সম্পন্ন। সর্বনিম্ন রিমুভাল সংখ্যা = ১!",
    ),
  ];

  final List<GreedyStep> _template3Steps = const [
    GreedyStep(
      activeIndex: 3,
      activeLineIndex: 4,
      stateVal: 3,
      arrayState: [1, 2, 3, 4, 5],
      explanationEn: "Line 5: Fuel deficit! Greedily reset startStation = 3.",
      explanationBn: "লাইন ৫: জ্বালানি ঘাটতি! স্টার্ট স্টেশন ৩ এ রিসেট করা হলো।",
    ),
    GreedyStep(
      activeIndex: 4,
      activeLineIndex: 6,
      stateVal: 3,
      arrayState: [1, 2, 3, 4, 5],
      explanationEn: "🎉 Line 7: Total Gas >= Total Cost. Valid Start Station = Index 3!",
      explanationBn: "🎉 লাইন ৭: টোটাল গ্যাস >= কস্ট। বৈধ স্টার্ট স্টেশন = ইনডেক্স ৩!",
    ),
  ];

  List<GreedyStep> get _currentSteps {
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
              _buildTemplateChip(0, widget.isEnglish ? "Jump Game (Reach)" : "জাম্প গেম (দূরত্ব)"),
              _buildTemplateChip(1, widget.isEnglish ? "Non-overlapping Intervals" : "ইনটারভাল সর্টিং"),
              _buildTemplateChip(2, widget.isEnglish ? "Gas Station Circuit" : "গ্যাস স্টেশন সার্কিট"),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Status Log Banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.accentPurple.withOpacity(0.15),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.accentPurple),
          ),
          child: Text(
            widget.isEnglish ? step.explanationEn : step.explanationBn,
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
        const SizedBox(height: 16),

        // Code Snippet + Visualizer Box Layout
        if (isMobile)
          Column(
            children: [
              _buildCodeSnippetWithHighlight(_currentCodeLines, step.activeLineIndex),
              const SizedBox(height: 16),
              _buildGreedyCanvas(step),
            ],
          )
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildCodeSnippetWithHighlight(_currentCodeLines, step.activeLineIndex)),
              const SizedBox(width: 16),
              Expanded(child: _buildGreedyCanvas(step)),
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
        selectedColor: AppTheme.accentPurple,
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

  Widget _buildGreedyCanvas(GreedyStep step) {
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
              Text("Active Index i: [${step.activeIndex}]", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13)),
              Text("Greedy Tracker: [${step.stateVal}]", style: const TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 16),

          // Greedy Array Elements & Reach Line Canvas
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(step.arrayState.length, (i) {
                final isActive = i == step.activeIndex;
                final isWithinReach = i <= step.stateVal;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 52,
                  height: 65,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: isActive ? AppTheme.accentNeonCyan : (isWithinReach ? AppTheme.accentPurple.withOpacity(0.3) : AppTheme.surfaceDark),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isActive ? Colors.white : (isWithinReach ? AppTheme.accentPurple : const Color(0xFF1E293B)),
                      width: isActive ? 2.5 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${step.arrayState[i]}",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isActive ? AppTheme.primaryDark : Colors.white),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "[$i]",
                        style: TextStyle(fontSize: 9, color: isActive ? AppTheme.primaryDark : AppTheme.textMuted),
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
