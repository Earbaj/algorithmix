import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class CyclicStep {
  final int activeIndex;
  final int correctIndex;
  final int activeLineIndex;
  final List<int> arrayState;
  final bool isSwapping;
  final String explanationEn;
  final String explanationBn;

  const CyclicStep({
    required this.activeIndex,
    required this.correctIndex,
    required this.activeLineIndex,
    required this.arrayState,
    this.isSwapping = false,
    required this.explanationEn,
    required this.explanationBn,
  });
}

class CyclicSortVisualizer extends StatefulWidget {
  final bool isEnglish;

  const CyclicSortVisualizer({super.key, required this.isEnglish});

  @override
  State<CyclicSortVisualizer> createState() => _CyclicSortVisualizerState();
}

class _CyclicSortVisualizerState extends State<CyclicSortVisualizer> {
  int _selectedTemplateIndex = 0;
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  final List<List<String>> _codeTemplates = const [
    // Template 1: Standard 1 to N Cyclic Sort
    [
      "void cyclicSort(vector<int>& nums) {",
      "    int i = 0, n = nums.size();",
      "    while (i < n) {",
      "        int correctIdx = nums[i] - 1;",
      "        if (nums[i] != nums[correctIdx]) {",
      "            swap(nums[i], nums[correctIdx]); // SWAP to correct spot!",
      "        } else {",
      "            i++; // Already in correct spot",
      "        }",
      "    }",
      "}",
    ],
    // Template 2: Find Missing Number (0 to N Range)
    [
      "int missingNumber(vector<int>& nums) {",
      "    int i = 0, n = nums.size();",
      "    while (i < n) {",
      "        if (nums[i] < n && nums[i] != nums[nums[i]]) {",
      "            swap(nums[i], nums[nums[i]]);",
      "        } else i++;",
      "    }",
      "    for (int j = 0; j < n; j++) {",
      "        if (nums[j] != j) return j; // MISSING NUMBER FOUND!",
      "    }",
      "    return n;",
      "}",
    ],
    // Template 3: Find Duplicate Number (LeetCode 287)
    [
      "int findDuplicate(vector<int>& nums) {",
      "    int i = 0, n = nums.size();",
      "    while (i < n) {",
      "        if (nums[i] != i + 1) {",
      "            int correctIdx = nums[i] - 1;",
      "            if (nums[i] != nums[correctIdx]) swap(nums[i], nums[correctIdx]);",
      "            else return nums[i]; // DUPLICATE FOUND!",
      "        } else i++;",
      "    }",
      "    return -1;",
      "}",
    ],
  ];

  final List<CyclicStep> _template1Steps = const [
    CyclicStep(
      activeIndex: 0,
      correctIndex: 2,
      activeLineIndex: 3,
      arrayState: [3, 5, 2, 1, 4],
      explanationEn: "Line 4: i = 0: nums[0] = 3. Correct Index = 3 - 1 = 2.",
      explanationBn: "লাইন ৪: i = 0: nums[0] = 3। সঠিক ইনডেক্স = 3 - 1 = 2।",
    ),
    CyclicStep(
      activeIndex: 0,
      correctIndex: 2,
      activeLineIndex: 4,
      arrayState: [3, 5, 2, 1, 4],
      isSwapping: true,
      explanationEn: "Line 5: Check nums[0] (3) != nums[2] (2) -> TRUE. Swapping nums[0] with nums[2]!",
      explanationBn: "লাইন ৫: শর্ত (3 != 2) সত্য! nums[0] (3) এর সাথে nums[2] (2) সোয়াপ করা হচ্ছে!",
    ),
    CyclicStep(
      activeIndex: 0,
      correctIndex: 1,
      activeLineIndex: 5,
      arrayState: [2, 5, 3, 1, 4],
      isSwapping: true,
      explanationEn: "Line 6: Swapped! Array becomes [2, 5, 3, 1, 4]. Note: 3 is now at correct index 2!",
      explanationBn: "লাইন ৬: সোয়াপ সম্পন্ন! অ্যারে = [2, 5, 3, 1, 4]। ৩ তার সঠিক ইনডেক্স ২ এ বসেছে!",
    ),
    CyclicStep(
      activeIndex: 0,
      correctIndex: 1,
      activeLineIndex: 4,
      arrayState: [2, 5, 3, 1, 4],
      isSwapping: true,
      explanationEn: "Line 5: i is still 0. nums[0] = 2. Swapping nums[0] (2) with nums[1] (5)!",
      explanationBn: "লাইন ৫: i এখনো 0। nums[0] = 2। nums[0] (2) এর সাথে nums[1] (5) সোয়াপ করা হচ্ছে!",
    ),
    CyclicStep(
      activeIndex: 0,
      correctIndex: 4,
      activeLineIndex: 5,
      arrayState: [5, 2, 3, 1, 4],
      isSwapping: true,
      explanationEn: "Line 6: Swapped! Array = [5, 2, 3, 1, 4]. 2 is now at correct index 1!",
      explanationBn: "লাইন ৬: সোয়াপ সম্পন্ন! ২ তার সঠিক ইনডেক্স ১ এ বসেছে!",
    ),
    CyclicStep(
      activeIndex: 0,
      correctIndex: 3,
      activeLineIndex: 5,
      arrayState: [1, 2, 3, 5, 4],
      isSwapping: true,
      explanationEn: "Line 6: Swapping nums[0] (5) with nums[4] (4) -> Array = [4, 2, 3, 5, 1]. Swapping 4 -> [1, 2, 3, 5, 4]!",
      explanationBn: "লাইন ৬: সোয়াপ করে ১ কে সঠিক ইনডেক্স 0 তে বসানো হলো!",
    ),
    CyclicStep(
      activeIndex: 0,
      correctIndex: 0,
      activeLineIndex: 7,
      arrayState: [1, 2, 3, 5, 4],
      explanationEn: "Line 8: nums[0] = 1 is already at correct index 0! Advance i++ to 1.",
      explanationBn: "লাইন ৮: nums[0] = 1 তার সঠিক স্থান ০ তে আছে! i++ বাড়িয়ে ১ করা হলো।",
    ),
    CyclicStep(
      activeIndex: 3,
      correctIndex: 4,
      activeLineIndex: 5,
      arrayState: [1, 2, 3, 4, 5],
      isSwapping: true,
      explanationEn: "Line 6: Swapping nums[3] (5) with nums[4] (4) -> Array becomes [1, 2, 3, 4, 5]!",
      explanationBn: "লাইন ৬: 5 ও 4 সোয়াপ সম্পন্ন! অ্যারে = [1, 2, 3, 4, 5]!",
    ),
    CyclicStep(
      activeIndex: 4,
      correctIndex: 4,
      activeLineIndex: 9,
      arrayState: [1, 2, 3, 4, 5],
      explanationEn: "🎉 Line 10: Cyclic Sort Complete! All elements placed at correct indices in O(N) time and O(1) space!",
      explanationBn: "🎉 লাইন ১০: সাইক্লিক সর্ট সম্পন্ন! O(N) টাইম ও O(1) স্পেসে সব উপাদান সঠিক স্থানে বসানো শেষ!",
    ),
  ];

  final List<CyclicStep> _template2Steps = const [
    CyclicStep(
      activeIndex: 0,
      correctIndex: 3,
      activeLineIndex: 2,
      arrayState: [3, 0, 1], // N = 3, Missing 2
      explanationEn: "Line 3: Cyclic Sort [3, 0, 1] (range 0 to N=3). nums[0] = 3 (out of bounds 3 == N), advance i++.",
      explanationBn: "লাইন ৩: সাইক্লিক সর্ট [3, 0, 1]। nums[0] = 3 (সীমানার বাইরে), i++ আগানো হলো।",
    ),
    CyclicStep(
      activeIndex: 1,
      correctIndex: 0,
      activeLineIndex: 4,
      arrayState: [0, 3, 1],
      isSwapping: true,
      explanationEn: "Line 5: Swap nums[1] (0) with nums[0] (3) -> Array = [0, 3, 1]. 0 is now at index 0!",
      explanationBn: "লাইন ৫: 0 কে তার সঠিক স্থান 0 তে সোয়াপ করা হলো! অ্যারে = [0, 3, 1]।",
    ),
    CyclicStep(
      activeIndex: 2,
      correctIndex: 1,
      activeLineIndex: 4,
      arrayState: [0, 1, 3],
      isSwapping: true,
      explanationEn: "Line 5: Swap nums[2] (1) with nums[1] (3) -> Array = [0, 1, 3]. 1 is now at index 1!",
      explanationBn: "লাইন ৫: 1 কে তার সঠিক স্থান 1 এ সোয়াপ করা হলো! অ্যারে = [0, 1, 3]।",
    ),
    CyclicStep(
      activeIndex: 2,
      correctIndex: 2,
      activeLineIndex: 8,
      arrayState: [0, 1, 3],
      explanationEn: "🎉 Line 9: Scan array: Index 2 has nums[2] = 3 != 2. MISSING NUMBER IS 2!",
      explanationBn: "🎉 লাইন ৯: ট্রাভার্সাল: ইনডেক্স ২ এ মান ৩ != ২! হারানো সংখ্যা (Missing Number) = 2!",
    ),
  ];

  final List<CyclicStep> _template3Steps = const [
    CyclicStep(
      activeIndex: 0,
      correctIndex: 0,
      activeLineIndex: 4,
      arrayState: [1, 3, 4, 2, 2],
      explanationEn: "Line 5: Cyclic Sort [1, 3, 4, 2, 2]. nums[0] = 1 is at index 0. Advance i++.",
      explanationBn: "লাইন ৫: nums[0] = 1 তার সঠিক স্থান 0 তে আছে। i++ আগান।",
    ),
    CyclicStep(
      activeIndex: 3,
      correctIndex: 1,
      activeLineIndex: 5,
      arrayState: [1, 2, 3, 4, 2],
      isSwapping: true,
      explanationEn: "Line 6: Swapped 3 and 4 -> Array = [1, 2, 3, 4, 2].",
      explanationBn: "লাইন ৬: সোয়াপ সম্পন্ন -> অ্যারে = [1, 2, 3, 4, 2]।",
    ),
    CyclicStep(
      activeIndex: 4,
      correctIndex: 1,
      activeLineIndex: 6,
      arrayState: [1, 2, 3, 4, 2],
      isSwapping: true,
      explanationEn: "🎉 Line 7: Index 4 has nums[4] = 2. nums[2-1] = nums[1] is ALREADY 2! DUPLICATE FOUND = 2!",
      explanationBn: "🎉 লাইন ৭: ইনডেক্স ৪ এ মান ২। কিন্তু সঠিক স্থান ১ এ আগে থেকেই ২ বিদ্যমান! ডুপ্লিকেট সংখ্যা = 2!",
    ),
  ];

  List<CyclicStep> get _currentSteps {
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
              _buildTemplateChip(0, widget.isEnglish ? "1 to N Cyclic Sort" : "১ থেকে N সর্ট"),
              _buildTemplateChip(1, widget.isEnglish ? "Find Missing Number" : "মিসিং সংখ্যা নির্ণয়"),
              _buildTemplateChip(2, widget.isEnglish ? "Find Duplicate Number" : "ডুপ্লিকেট সংখ্যা নির্ণয়"),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Status Log Banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: step.isSwapping ? AppTheme.accentGreen.withOpacity(0.15) : AppTheme.accentPurple.withOpacity(0.15),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: step.isSwapping ? AppTheme.accentGreen : AppTheme.accentPurple),
          ),
          child: Text(
            widget.isEnglish ? step.explanationEn : step.explanationBn,
            style: TextStyle(
              color: step.isSwapping ? AppTheme.accentGreen : AppTheme.accentNeonCyan,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Code Snippet + Visualizer Box Layout
        if (isMobile)
          Column(
            children: [
              _buildCodeSnippetWithHighlight(_currentCodeLines, step.activeLineIndex),
              const SizedBox(height: 16),
              _buildCyclicCanvas(step),
            ],
          )
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildCodeSnippetWithHighlight(_currentCodeLines, step.activeLineIndex)),
              const SizedBox(width: 16),
              Expanded(child: _buildCyclicCanvas(step)),
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

  Widget _buildCyclicCanvas(CyclicStep step) {
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
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("Active Index i: [${step.activeIndex}]", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13)),
              Text("Target Correct Index: [${step.correctIndex}]", style: const TextStyle(color: AppTheme.accentPink, fontWeight: FontWeight.bold, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 16),

          // Horizontal Array Canvas
          const Text("Cyclic Array In-Place Swap Canvas:", style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(step.arrayState.length, (i) {
                final isActive = i == step.activeIndex;
                final isCorrectTarget = i == step.correctIndex;
                final isMatched = step.arrayState[i] == i + 1 || (_selectedTemplateIndex == 1 && step.arrayState[i] == i);

                final Color color = isActive
                    ? AppTheme.accentNeonCyan
                    : (isCorrectTarget ? AppTheme.accentPink : (isMatched ? AppTheme.accentGreen : AppTheme.surfaceDark));

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 54,
                  height: 65,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: (isActive || isCorrectTarget) ? Colors.white : const Color(0xFF1E293B),
                      width: (isActive || isCorrectTarget) ? 2.5 : 1,
                    ),
                    boxShadow: (isActive || isCorrectTarget) ? [BoxShadow(color: color.withOpacity(0.5), blurRadius: 8)] : [],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${step.arrayState[i]}",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: (isActive || isCorrectTarget || isMatched) ? AppTheme.primaryDark : Colors.white),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isActive ? "i=[$i]" : (isCorrectTarget ? "TARGET" : "[$i]"),
                        style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.bold, color: (isActive || isCorrectTarget || isMatched) ? AppTheme.primaryDark : AppTheme.textMuted),
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
