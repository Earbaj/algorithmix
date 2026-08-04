import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class ComplexityClassInfo {
  final String name;
  final String notation;
  final Color color;
  final String descriptionEn;
  final String descriptionBn;
  final String exampleEn;
  final String exampleBn;
  final double Function(double n) calcOps;

  const ComplexityClassInfo({
    required this.name,
    required this.notation,
    required this.color,
    required this.descriptionEn,
    required this.descriptionBn,
    required this.exampleEn,
    required this.exampleBn,
    required this.calcOps,
  });
}

class TimeSpaceComplexityCodeFreeVisualizer extends StatefulWidget {
  final bool isEnglish;

  const TimeSpaceComplexityCodeFreeVisualizer({
    super.key,
    required this.isEnglish,
  });

  @override
  State<TimeSpaceComplexityCodeFreeVisualizer> createState() =>
      _TimeSpaceComplexityCodeFreeVisualizerState();
}

class _TimeSpaceComplexityCodeFreeVisualizerState
    extends State<TimeSpaceComplexityCodeFreeVisualizer> {
  double _inputN = 16.0;
  String _selectedNotation = "O(N)";

  final List<ComplexityClassInfo> _complexities = [
    ComplexityClassInfo(
      name: "Constant",
      notation: "O(1)",
      color: const Color(0xFF10B981), // Green
      descriptionEn: "Execution time remains unchanged regardless of input size N.",
      descriptionBn: "ইনপুট সাইজ N যাই হোক না কেন, এক্সিকিউশন টাইম অপরিবর্তিত থাকে।",
      exampleEn: "Array index lookup arr[i], Hash Map get/put",
      exampleBn: "অ্যারে ইনডেক্স অ্যাক্সেস arr[i], হ্যাশ ম্যাপ পঠিত মান",
      calcOps: (n) => 1.0,
    ),
    ComplexityClassInfo(
      name: "Logarithmic",
      notation: "O(log N)",
      color: const Color(0xFF06B6D4), // Cyan
      descriptionEn: "Input size is halved in each step. Extremely fast scaling.",
      descriptionBn: "প্রতিটি ধাপে ইনপুট সাইজ অর্ধেক করা হয়। অত্যন্ত দ্রুত ও দক্ষ।",
      exampleEn: "Binary Search, Balanced BST search",
      exampleBn: "বাইনারি সার্চ, ব্যালেন্সড BST সার্চ",
      calcOps: (n) => math.max(1.0, math.log(n) / math.log(2)),
    ),
    ComplexityClassInfo(
      name: "Linear",
      notation: "O(N)",
      color: const Color(0xFF3B82F6), // Blue
      descriptionEn: "Execution time grows proportionally 1-to-1 with input size N.",
      descriptionBn: "ইনপুট সাইজ N বাড়ার সাথে সাথে এক্সিকিউশন টাইম সমানুপাতিকভাবে বাড়ে।",
      exampleEn: "Single loop traversal, Linear Search, Array max/min",
      exampleBn: "একক লুপ ট্রাভার্সাল, লিনিয়ার সার্চ, অ্যারে সর্বোচ্চ মান বের করা",
      calcOps: (n) => n,
    ),
    ComplexityClassInfo(
      name: "Linearithmic",
      notation: "O(N log N)",
      color: const Color(0xFF8B5CF6), // Purple
      descriptionEn: "Common in efficient divide-and-conquer sorting algorithms.",
      descriptionBn: "দক্ষ ডিভাইড-অ্যান্ড-কনকার সর্টিং অ্যালগরিদমে ব্যবহৃত হয়।",
      exampleEn: "Merge Sort, Quick Sort (average), Heap Sort",
      exampleBn: "মার্জ সর্ট, কুইক সর্ট (গড়), হিপ সর্ট",
      calcOps: (n) => n * (math.log(n) / math.log(2)),
    ),
    ComplexityClassInfo(
      name: "Quadratic",
      notation: "O(N²)",
      color: const Color(0xFFF59E0B), // Amber
      descriptionEn: "Time grows quadratically with nested loops over input N.",
      descriptionBn: "নেসটেড লুপের কারণে সময় N এর বর্গের অনুপাতে বাড়ে।",
      exampleEn: "Nested loops, Bubble Sort, Selection Sort, 2D Grid scan",
      exampleBn: "নেসটেড লুপ, বাবল সর্ট, সিলেকশন সর্ট, ২ডি গ্রিড স্ক্যান",
      calcOps: (n) => n * n,
    ),
    ComplexityClassInfo(
      name: "Exponential",
      notation: "O(2ᴺ)",
      color: const Color(0xFFEF4444), // Red
      descriptionEn: "Operations double with each addition to N. Avoid for large N!",
      descriptionBn: "N এর মান ১ বাড়লেই অপারেশন দ্বিগুণ হয়ে যায়। বড় N এর জন্য পরিহারযোগ্য!",
      exampleEn: "All subsets generation, Naive Recursive Fibonacci",
      exampleBn: "সকল সাবসেট জেনারেশন, সাধারণ রিকার্সিভ ফিবোনাচ্চি",
      calcOps: (n) => math.pow(2.0, math.min(n, 25)).toDouble(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isEng = widget.isEnglish;
    final isMobile = Responsive.isMobile(context);

    final selectedClass = _complexities.firstWhere(
      (c) => c.notation == _selectedNotation,
      orElse: () => _complexities[2],
    );

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        vertical: Responsive.verticalPadding(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(isMobile ? 12 : 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.accentPurple.withOpacity(0.25),
                  AppTheme.accentNeonCyan.withOpacity(0.15),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.accentNeonCyan.withOpacity(0.4)),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(isMobile ? 8 : 12),
                  decoration: BoxDecoration(
                    color: AppTheme.accentNeonCyan.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.speed_rounded,
                    color: AppTheme.accentNeonCyan,
                    size: Responsive.sp(context, isMobile ? 22 : 28),
                  ),
                ),
                SizedBox(width: isMobile ? 10 : 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        children: [
                          Text(
                            isEng
                                ? 'Big O Complexity Growth Visualizer'
                                : 'বিগ ও (Big O) গ্রোথ রেট ভিজ্যুয়ালাইজার',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: Responsive.sp(context, 16),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppTheme.accentGreen.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: AppTheme.accentGreen),
                            ),
                            child: Text(
                              isEng ? '100% Interactive' : '১০০% ইন্টারেক্টিভ',
                              style: TextStyle(
                                color: AppTheme.accentGreen,
                                fontSize: Responsive.sp(context, 10.5),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isEng
                            ? 'Adjust input size N and observe how operation counts scale across different Big O time complexities!'
                            : 'ইনপুট সাইজ N পরিবর্তন করে দেখুন কীভাবে বিভিন্ন বিগ ও টাইম কমপ্লেক্সিটিতে অপারেশনের সংখ্যা বৃদ্ধি পায়!',
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: Responsive.sp(context, 12),
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Input N Slider
          Container(
            padding: EdgeInsets.all(Responsive.sp(context, 16)),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isEng
                          ? 'Input Size (N) Slider:'
                          : 'ইনপুট সাইজ (N) নির্ধারণ স্লাইডার:',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: Responsive.sp(context, 14),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.accentNeonCyan.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppTheme.accentNeonCyan),
                      ),
                      child: Text(
                        "N = ${_inputN.toInt()}",
                        style: TextStyle(
                          color: AppTheme.accentNeonCyan,
                          fontWeight: FontWeight.bold,
                          fontSize: Responsive.sp(context, 13.5),
                        ),
                      ),
                    ),
                  ],
                ),
                Slider(
                  value: _inputN,
                  min: 1.0,
                  max: 64.0,
                  divisions: 63,
                  activeColor: AppTheme.accentNeonCyan,
                  inactiveColor: AppTheme.primaryDark,
                  onChanged: (val) {
                    setState(() {
                      _inputN = val;
                    });
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("N = 1",
                        style: TextStyle(
                            color: AppTheme.textMuted,
                            fontSize: Responsive.sp(context, 11))),
                    Text("N = 32",
                        style: TextStyle(
                            color: AppTheme.textMuted,
                            fontSize: Responsive.sp(context, 11))),
                    Text("N = 64",
                        style: TextStyle(
                            color: AppTheme.textMuted,
                            fontSize: Responsive.sp(context, 11))),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Comparison Bar Chart
          Text(
            isEng ? '📊 Operations Comparison Bar Chart:' : '📊 অপারেশনের তুলনামূলক বার চার্ট:',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: Responsive.sp(context, 14),
            ),
          ),
          const SizedBox(height: 10),
          ..._complexities.map((item) {
            double ops = item.calcOps(_inputN);
            bool isSelected = item.notation == _selectedNotation;

            // Logarithmic visual scaling for progress bar
            double maxVal = _complexities.last.calcOps(_inputN);
            double progress = (math.log(ops + 1) / math.log(maxVal + 1)).clamp(0.02, 1.0);

            return InkWell(
              onTap: () {
                setState(() {
                  _selectedNotation = item.notation;
                });
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: EdgeInsets.all(isMobile ? 10 : 14),
                decoration: BoxDecoration(
                  color: isSelected
                      ? item.color.withOpacity(0.2)
                      : AppTheme.surfaceDark,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? item.color : const Color(0xFF334155),
                    width: isSelected ? 2.0 : 1.0,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: item.color.withOpacity(0.25),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: item.color),
                              ),
                              child: Text(
                                item.notation,
                                style: TextStyle(
                                  color: item.color,
                                  fontWeight: FontWeight.bold,
                                  fontSize: Responsive.sp(context, 12),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              item.name,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: Responsive.sp(context, 13),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "~ ${ops.toInt()} ops",
                          style: TextStyle(
                            color: item.color,
                            fontWeight: FontWeight.bold,
                            fontSize: Responsive.sp(context, 13),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 10,
                        backgroundColor: AppTheme.primaryDark,
                        valueColor: AlwaysStoppedAnimation<Color>(item.color),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
          const SizedBox(height: 16),

          // Selected Class Detailed Card
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(Responsive.sp(context, 16)),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: selectedClass.color, width: 1.8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info_rounded, color: selectedClass.color, size: 22),
                    const SizedBox(width: 8),
                    Text(
                      "${selectedClass.notation} - ${selectedClass.name} Complexity",
                      style: TextStyle(
                        color: selectedClass.color,
                        fontWeight: FontWeight.bold,
                        fontSize: Responsive.sp(context, 15),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  isEng ? selectedClass.descriptionEn : selectedClass.descriptionBn,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Responsive.sp(context, 13),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryDark,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: selectedClass.color.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.code, color: selectedClass.color, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          isEng
                              ? "Real World Examples: ${selectedClass.exampleEn}"
                              : "বাস্তব উদাহরণ: ${selectedClass.exampleBn}",
                          style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: Responsive.sp(context, 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
