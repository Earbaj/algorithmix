import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class SearchStep {
  final int low;
  final int mid;
  final int high;
  final int activeLineIndex;
  final List<int> arrayState;
  final int target;
  final String explanationEn;
  final String explanationBn;

  const SearchStep({
    required this.low,
    required this.mid,
    required this.high,
    required this.activeLineIndex,
    required this.arrayState,
    required this.target,
    required this.explanationEn,
    required this.explanationBn,
  });
}

class ModifiedBinarySearchVisualizer extends StatefulWidget {
  final bool isEnglish;

  const ModifiedBinarySearchVisualizer({super.key, required this.isEnglish});

  @override
  State<ModifiedBinarySearchVisualizer> createState() => _ModifiedBinarySearchVisualizerState();
}

class _ModifiedBinarySearchVisualizerState extends State<ModifiedBinarySearchVisualizer> {
  int _selectedTemplateIndex = 0;
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  final List<List<String>> _codeTemplates = const [
    // Template 1: Search in Rotated Sorted Array
    [
      "int search(vector<int>& nums, int target) {",
      "    int low = 0, high = nums.size() - 1;",
      "    while (low <= high) {",
      "        int mid = low + (high - low) / 2;",
      "        if (nums[mid] == target) return mid; // Found!",
      "        if (nums[low] <= nums[mid]) { // Left half is sorted",
      "            if (nums[low] <= target && target < nums[mid]) high = mid - 1;",
      "            else low = mid + 1;",
      "        } else { // Right half is sorted",
      "            if (nums[mid] < target && target <= nums[high]) low = mid + 1;",
      "            else high = mid - 1;",
      "        }",
      "    }",
      "    return -1;",
      "}",
    ],
    // Template 2: Find First and Last Position of Element
    [
      "int findFirst(vector<int>& nums, int target) {",
      "    int low = 0, high = nums.size() - 1, ans = -1;",
      "    while (low <= high) {",
      "        int mid = low + (high - low) / 2;",
      "        if (nums[mid] == target) { ans = mid; high = mid - 1; } // Squeeze Left",
      "        else if (nums[mid] < target) low = mid + 1;",
      "        else high = mid - 1;",
      "    }",
      "    return ans;",
      "}",
    ],
    // Template 3: Find Peak Element
    [
      "int findPeakElement(vector<int>& nums) {",
      "    int low = 0, high = nums.size() - 1;",
      "    while (low < high) {",
      "        int mid = low + (high - low) / 2;",
      "        if (nums[mid] < nums[mid + 1]) low = mid + 1; // Move right",
      "        else high = mid;                              // Move left",
      "    }",
      "    return low; // Peak found!",
      "}",
    ],
  ];

  final List<SearchStep> _template1Steps = const [
    SearchStep(
      low: 0,
      mid: 3,
      high: 6,
      activeLineIndex: 3,
      arrayState: [4, 5, 6, 7, 0, 1, 2],
      target: 0,
      explanationEn: "Line 4: Rotated Array = [4, 5, 6, 7, 0, 1, 2], Target = 0. low = 0 (4), high = 6 (2). mid = 3 (val 7).",
      explanationBn: "লাইন ৪: রোটেটেড অ্যারে = [4, 5, 6, 7, 0, 1, 2], টার্গেট = 0। low = 0, high = 6। mid = 3 (মান 7)।",
    ),
    SearchStep(
      low: 0,
      mid: 3,
      high: 6,
      activeLineIndex: 5,
      arrayState: [4, 5, 6, 7, 0, 1, 2],
      target: 0,
      explanationEn: "Line 6: Check nums[low] (4) <= nums[mid] (7) -> TRUE. Left half [4, 5, 6, 7] is sorted!",
      explanationBn: "লাইন ৬: শর্ত 4 <= 7 সত্য! বাম অর্ধেক [4, 5, 6, 7] সর্টেড।",
    ),
    SearchStep(
      low: 4,
      mid: 3,
      high: 6,
      activeLineIndex: 7,
      arrayState: [4, 5, 6, 7, 0, 1, 2],
      target: 0,
      explanationEn: "Line 8: Target 0 is NOT in [4..7]. Search right half! Set low = mid + 1 = 4.",
      explanationBn: "লাইন ৮: টার্গেট 0 বামের সীমানায় নেই। ডানের অর্ধে সার্চ করুন! low = 4 করা হলো।",
    ),
    SearchStep(
      low: 4,
      mid: 5,
      high: 6,
      activeLineIndex: 3,
      arrayState: [4, 5, 6, 7, 0, 1, 2],
      target: 0,
      explanationEn: "Line 4: low = 4 (0), high = 6 (2). Calculate mid = 4 + (6 - 4) / 2 = 5 (val 1).",
      explanationBn: "লাইন ৪: low = 4, high = 6। mid = 5 (মান 1)।",
    ),
    SearchStep(
      low: 4,
      mid: 4,
      high: 4,
      activeLineIndex: 4,
      arrayState: [4, 5, 6, 7, 0, 1, 2],
      target: 0,
      explanationEn: "🎉 Line 5: Target 0 FOUND at Index 4! Return 4!",
      explanationBn: "🎉 লাইন ৫: টার্গেট 0 ইনডেক্স 4 এ পাওয়া গেছে! রিটার্ন 4!",
    ),
  ];

  final List<SearchStep> _template2Steps = const [
    SearchStep(
      low: 0,
      mid: 2,
      high: 5,
      activeLineIndex: 3,
      arrayState: [5, 7, 7, 8, 8, 10],
      target: 8,
      explanationEn: "Line 4: Array = [5, 7, 7, 8, 8, 10], Target = 8. mid = 2 (val 7 < 8).",
      explanationBn: "লাইন ৪: mid = 2 (মান 7 < 8)।",
    ),
    SearchStep(
      low: 3,
      mid: 4,
      high: 5,
      activeLineIndex: 4,
      arrayState: [5, 7, 7, 8, 8, 10],
      target: 8,
      explanationEn: "Line 5: nums[4] = 8 == Target. Save ans = 4, continue searching left (high = 3) for First occurrence!",
      explanationBn: "লাইন ৫: nums[4] = 8 পাওয়া গেছে। ans = 4 সেভ করে ১ম ইনডেক্স খুঁজতে বামে গুটিয়ে আনুন।",
    ),
    SearchStep(
      low: 3,
      mid: 3,
      high: 3,
      activeLineIndex: 4,
      arrayState: [5, 7, 7, 8, 8, 10],
      target: 8,
      explanationEn: "🎉 Line 5: First occurrence of 8 FOUND at Index 3!",
      explanationBn: "🎉 লাইন ৫: টার্গেট 8 এর প্রথম উপস্থিতি ইনডেক্স 3 এ পাওয়া গেছে!",
    ),
  ];

  final List<SearchStep> _template3Steps = const [
    SearchStep(
      low: 0,
      mid: 1,
      high: 3,
      activeLineIndex: 3,
      arrayState: [1, 2, 1, 3, 5, 6, 4],
      target: 0,
      explanationEn: "Line 4: Mountain Peak Search. mid = 1 (val 2), nums[mid+1] = 1. Peak is in left half!",
      explanationBn: "লাইন ৪: মাউন্টেন পিক সার্চ। mid = 1 (মান 2)। পিক বাম অর্ধে অবস্থিত।",
    ),
    SearchStep(
      low: 4,
      mid: 5,
      high: 6,
      activeLineIndex: 6,
      arrayState: [1, 2, 1, 3, 5, 6, 4],
      target: 0,
      explanationEn: "🎉 Line 7: Peak element 6 FOUND at Index 5!",
      explanationBn: "🎉 লাইন ৭: পিক এলিমেন্ট 6 ইনডেক্স 5 এ পাওয়া গেছে!",
    ),
  ];

  List<SearchStep> get _currentSteps {
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
              _buildTemplateChip(0, widget.isEnglish ? "Search Rotated Sorted" : "রোটেটেড অ্যারে সার্চ"),
              _buildTemplateChip(1, widget.isEnglish ? "First & Last Position" : "প্রথমে ও শেষ ইনডেক্স"),
              _buildTemplateChip(2, widget.isEnglish ? "Find Peak Element" : "পিক নোড বের করা"),
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
              _buildBinarySearchCanvas(step),
            ],
          )
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildCodeSnippetWithHighlight(_currentCodeLines, step.activeLineIndex)),
              const SizedBox(width: 16),
              Expanded(child: _buildBinarySearchCanvas(step)),
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

  Widget _buildBinarySearchCanvas(SearchStep step) {
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
              Text("LOW: [${step.low}]", style: const TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 13)),
              Text("MID: [${step.mid}]", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13)),
              Text("HIGH: [${step.high}]", style: const TextStyle(color: AppTheme.accentPink, fontWeight: FontWeight.bold, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 16),

          // Binary Search Array Pointer Canvas
          const Text("Modified Binary Search Array Pointers Canvas:", style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(step.arrayState.length, (i) {
                final isLow = i == step.low;
                final isMid = i == step.mid;
                final isHigh = i == step.high;
                final inRange = i >= step.low && i <= step.high;

                final Color color = isMid
                    ? AppTheme.accentNeonCyan
                    : (isLow ? AppTheme.accentGreen : (isHigh ? AppTheme.accentPink : (inRange ? AppTheme.surfaceDark : AppTheme.primaryDark)));

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 52,
                  height: 65,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: (isMid || isLow || isHigh) ? Colors.white : const Color(0xFF1E293B),
                      width: (isMid || isLow || isHigh) ? 2.5 : 1,
                    ),
                    boxShadow: (isMid || isLow || isHigh) ? [BoxShadow(color: color.withOpacity(0.5), blurRadius: 8)] : [],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${step.arrayState[i]}",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: (isMid || isLow || isHigh) ? AppTheme.primaryDark : (inRange ? Colors.white : AppTheme.textMuted)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isMid ? "MID" : (isLow ? "LOW" : (isHigh ? "HIGH" : "[$i]")),
                        style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.bold, color: (isMid || isLow || isHigh) ? AppTheme.primaryDark : AppTheme.textMuted),
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
