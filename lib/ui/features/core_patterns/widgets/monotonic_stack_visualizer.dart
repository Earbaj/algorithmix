import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class MonotonicStep {
  final int activeIndex;
  final int activeLineIndex;
  final List<int> stackIndices;
  final List<int> ansArray;
  final String explanationEn;
  final String explanationBn;

  const MonotonicStep({
    required this.activeIndex,
    required this.activeLineIndex,
    required this.stackIndices,
    required this.ansArray,
    required this.explanationEn,
    required this.explanationBn,
  });
}

class MonotonicStackVisualizer extends StatefulWidget {
  final bool isEnglish;

  const MonotonicStackVisualizer({super.key, required this.isEnglish});

  @override
  State<MonotonicStackVisualizer> createState() => _MonotonicStackVisualizerState();
}

class _MonotonicStackVisualizerState extends State<MonotonicStackVisualizer> {
  int _selectedTemplateIndex = 0;
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  final List<List<String>> _codeTemplates = const [
    // Template 1: Daily Temperatures
    [
      "vector<int> dailyTemperatures(vector<int>& temp) {",
      "    int n = temp.size(); vector<int> ans(n, 0); stack<int> st;",
      "    for (int i = 0; i < n; i++) {",
      "        while (!st.empty() && temp[i] > temp[st.top()]) {",
      "            int prevIdx = st.top(); st.pop();",
      "            ans[prevIdx] = i - prevIdx; // Calculate wait days!",
      "        }",
      "        st.push(i);",
      "    }",
      "    return ans;",
      "}",
    ],
    // Template 2: Next Greater Element I
    [
      "vector<int> nextGreaterElement(vector<int>& nums1, vector<int>& nums2) {",
      "    unordered_map<int, int> nextGreater; stack<int> st;",
      "    for (int num : nums2) {",
      "        while (!st.empty() && num > st.top()) {",
      "            nextGreater[st.top()] = num; st.pop();",
      "        }",
      "        st.push(num);",
      "    }",
      "    vector<int> ans; for (int x : nums1) ans.push_back(nextGreater.count(x) ? nextGreater[x] : -1);",
      "    return ans;",
      "}",
    ],
    // Template 3: Largest Rectangle in Histogram
    [
      "int largestRectangleArea(vector<int>& heights) {",
      "    heights.push_back(0); int maxArea = 0; stack<int> st;",
      "    for (int i = 0; i < heights.size(); i++) {",
      "        while (!st.empty() && heights[i] < heights[st.top()]) {",
      "            int h = heights[st.top()]; st.pop();",
      "            int w = st.empty() ? i : i - st.top() - 1;",
      "            maxArea = max(maxArea, h * w); // Max area update!",
      "        }",
      "        st.push(i);",
      "    }",
      "    return maxArea;",
      "}",
    ],
  ];

  final List<MonotonicStep> _template1Steps = const [
    MonotonicStep(
      activeIndex: 0,
      activeLineIndex: 7,
      stackIndices: [0],
      ansArray: [0, 0, 0, 0],
      explanationEn: "Line 8: i=0 (T=73). Stack empty -> Push index 0 (T=73). Stack = [0].",
      explanationBn: "লাইন ৮: i=0 (T=73)। স্ট্যাক খালি -> ইনডেক্স ০ পুশ। Stack = [0]।",
    ),
    MonotonicStep(
      activeIndex: 1,
      activeLineIndex: 5,
      stackIndices: [1],
      ansArray: [1, 0, 0, 0],
      explanationEn: "Line 6: i=1 (T=74) > T[0] (73)! Pop 0: ans[0] = 1 - 0 = 1 day. Push index 1.",
      explanationBn: "লাইন ৬: i=1 (T=74) > T[0] (73)! ইনডেক্স 0 পপ: ans[0] = 1 - 0 = 1 দিন। ইনডেক্স 1 পুশ।",
    ),
    MonotonicStep(
      activeIndex: 2,
      activeLineIndex: 7,
      stackIndices: [1, 2],
      ansArray: [1, 0, 0, 0],
      explanationEn: "Line 8: i=2 (T=71) < T[1] (74). Push index 2. Stack = [1, 2].",
      explanationBn: "লাইন ৮: i=2 (T=71) < T[1] (74)। ইনডেক্স 2 পুশ। Stack = [1, 2]।",
    ),
    MonotonicStep(
      activeIndex: 3,
      activeLineIndex: 5,
      stackIndices: [3],
      ansArray: [1, 1, 1, 0],
      explanationEn: "Line 6: i=3 (T=75) > T[2](71) & T[1](74)! Pop 2 (ans[2]=1), Pop 1 (ans[1]=2). Push index 3.",
      explanationBn: "লাইন ৬: i=3 (T=75) > T[2] ও T[1]! ২ ও ১ পপ: ans[2]=1, ans[1]=2 দিন। ইনডেক্স 3 পুশ।",
    ),
    MonotonicStep(
      activeIndex: 3,
      activeLineIndex: 9,
      stackIndices: [3],
      ansArray: [1, 2, 1, 0],
      explanationEn: "🎉 Line 10: Daily Temperatures Completed! Answer array = [1, 2, 1, 0]!",
      explanationBn: "🎉 লাইন ১০: ডেইলি টেম্পারেচার্স সম্পন্ন! উত্তর এরে = [1, 2, 1, 0]!",
    ),
  ];

  final List<MonotonicStep> _template2Steps = const [
    MonotonicStep(
      activeIndex: 0,
      activeLineIndex: 3,
      stackIndices: [4],
      ansArray: [-1],
      explanationEn: "Line 4: Push num 4 to stack.",
      explanationBn: "লাইন ৪: স্ট্যাকে 4 পুশ করা হলো।",
    ),
    MonotonicStep(
      activeIndex: 1,
      activeLineIndex: 4,
      stackIndices: [2],
      ansArray: [2],
      explanationEn: "🎉 Line 5: 2 > 1. Next Greater for 1 = 2!",
      explanationBn: "🎉 লাইন ৫: 2 > 1। 1 এর Next Greater = 2!",
    ),
  ];

  final List<MonotonicStep> _template3Steps = const [
    MonotonicStep(
      activeIndex: 0,
      activeLineIndex: 6,
      stackIndices: [0],
      ansArray: [10],
      explanationEn: "🎉 Line 7: Max Rectangle Area in Histogram = 10!",
      explanationBn: "🎉 লাইন ৭: হিস্টোগ্রামে সর্বোচ্চ আয়তক্ষেত্রের ক্ষেত্রফল = 10!",
    ),
  ];

  List<MonotonicStep> get _currentSteps {
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
              _buildTemplateChip(0, widget.isEnglish ? "Daily Temperatures (NGE)" : "ডেইলি টেম্পারেচার্স"),
              _buildTemplateChip(1, widget.isEnglish ? "Next Greater Element I" : "পরবর্তী বড় মান"),
              _buildTemplateChip(2, widget.isEnglish ? "Largest Rectangle Histogram" : "হিস্টোগ্রাম এরিয়া"),
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
              _buildStackCanvas(step),
            ],
          )
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildCodeSnippetWithHighlight(_currentCodeLines, step.activeLineIndex)),
              const SizedBox(width: 16),
              Expanded(child: _buildStackCanvas(step)),
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

  Widget _buildStackCanvas(MonotonicStep step) {
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
              Text("Active Index: [${step.activeIndex}]", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13)),
              Text("Stack: ${step.stackIndices.toString()}", style: const TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 16),

          // Monotonic Stack Visual Box
          const Text("Monotonic Stack (Indices / Values):", style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          const SizedBox(height: 8),
          Container(
            height: 70,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.accentPurple.withOpacity(0.5)),
            ),
            child: step.stackIndices.isEmpty
                ? const Center(child: Text("[ Stack Empty ]", style: TextStyle(color: AppTheme.textMuted, fontSize: 11)))
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: step.stackIndices.length,
                    itemBuilder: (context, i) {
                      final val = step.stackIndices[i];
                      return Container(
                        margin: const EdgeInsets.only(right: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppTheme.accentPurple,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppTheme.accentNeonCyan),
                        ),
                        child: Center(
                          child: Text(
                            "$val",
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 16),

          // Answer Array Inspector
          const Text("Computed Answer Array State:", style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(step.ansArray.length, (i) {
                return Container(
                  width: 48,
                  height: 55,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    color: step.ansArray[i] > 0 ? AppTheme.accentGreen : AppTheme.surfaceDark,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: step.ansArray[i] > 0 ? AppTheme.accentGreen : const Color(0xFF1E293B)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${step.ansArray[i]}",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: step.ansArray[i] > 0 ? AppTheme.primaryDark : Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text("ans[$i]", style: TextStyle(fontSize: 8, color: step.ansArray[i] > 0 ? AppTheme.primaryDark : AppTheme.textMuted)),
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
