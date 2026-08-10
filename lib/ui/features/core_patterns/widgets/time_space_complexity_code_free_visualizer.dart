/*
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
*/

import 'dart:math' as math;
import 'package:flutter/material.dart';
// আপনার প্রজেক্টের পাথ অনুযায়ী নিচের ইমপোর্টগুলো ঠিক রাখবেন
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
  final String analogyEn; // নতুন: বাস্তব জীবনের উপমা
  final String analogyBn;
  final double Function(double n) calcOps;

  const ComplexityClassInfo({
    required this.name,
    required this.notation,
    required this.color,
    required this.descriptionEn,
    required this.descriptionBn,
    required this.exampleEn,
    required this.exampleBn,
    required this.analogyEn,
    required this.analogyBn,
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
      analogyEn: "Going directly to a specific page number in a book.",
      analogyBn: "বইয়ের একটি নির্দিষ্ট পৃষ্ঠায় সরাসরি চলে যাওয়া।",
      calcOps: (n) => 1.0,
    ),
    ComplexityClassInfo(
      name: "Logarithmic",
      notation: "O(log N)",
      color: const Color(0xFF06B6D4), // Cyan
      descriptionEn: "Input size is halved in each step. Extremely fast scaling.",
      descriptionBn: "প্রতিটি ধাপে ইনপুট সাইজ অর্ধেক করা হয়। অত্যন্ত দ্রুত ও দক্ষ।",
      exampleEn: "Binary Search, Balanced BST search",
      exampleBn: "বাইনারি সার্চ, ব্যালেন্সড BST সার্চ",
      analogyEn: "Searching a word in a dictionary by repeatedly halving the book.",
      analogyBn: "ডিকশনারি বারবার অর্ধেক করে কোনো শব্দ খোঁজা।",
      calcOps: (n) => math.max(1.0, math.log(n) / math.log(2)),
    ),
    ComplexityClassInfo(
      name: "Linear",
      notation: "O(N)",
      color: const Color(0xFF3B82F6), // Blue
      descriptionEn: "Execution time grows proportionally 1-to-1 with input size N.",
      descriptionBn: "ইনপুট সাইজ N বাড়ার সাথে সাথে এক্সিকিউশন টাইম সমানুপাতিকভাবে বাড়ে।",
      exampleEn: "Single loop traversal, Linear Search, Array max/min",
      exampleBn: "একক লুপ ট্রাভার্সাল, লিনিয়ার সার্চ, অ্যারে সর্বোচ্চ মান বের করা",
      analogyEn: "Reading every single page of a book one by one.",
      analogyBn: "বইয়ের প্রতিটি পৃষ্ঠা একে একে পড়া।",
      calcOps: (n) => n,
    ),
    ComplexityClassInfo(
      name: "Linearithmic",
      notation: "O(N log N)",
      color: const Color(0xFF8B5CF6), // Purple
      descriptionEn: "Common in efficient divide-and-conquer sorting algorithms.",
      descriptionBn: "দক্ষ ডিভাইড-অ্যান্ড-কনকার সর্টিং অ্যালগরিদমে ব্যবহৃত হয়।",
      exampleEn: "Merge Sort, Quick Sort (average), Heap Sort",
      exampleBn: "মার্জ সর্ট, কুইক সর্ট (গড়), হিপ সর্ট",
      analogyEn: "Sorting a deck of cards by splitting them into halves and merging.",
      analogyBn: "তাসের প্যাকেট বারবার অর্ধেক করে ভাগ করা এবং মিলিয়ে সাজানো।",
      calcOps: (n) => n * (math.log(n) / math.log(2)),
    ),
    ComplexityClassInfo(
      name: "Quadratic",
      notation: "O(N²)",
      color: const Color(0xFFF59E0B), // Amber
      descriptionEn: "Time grows quadratically with nested loops over input N.",
      descriptionBn: "নেসটেড লুপের কারণে সময় N এর বর্গের অনুপাতে বাড়ে।",
      exampleEn: "Nested loops, Bubble Sort, Selection Sort, 2D Grid scan",
      exampleBn: "নেসটেড লুপ, বাবল সর্ট, সিলেকশন সর্ট, ২ডি গ্রিড স্ক্যান",
      analogyEn: "Comparing every single page of a book with every other page.",
      analogyBn: "বইয়ের প্রতিটি পৃষ্ঠার সাথে অন্য সব পৃষ্ঠার একে একে তুলনা করা।",
      calcOps: (n) => n * n,
    ),
    ComplexityClassInfo(
      name: "Exponential",
      notation: "O(2ᴺ)",
      color: const Color(0xFFEF4444), // Red
      descriptionEn: "Operations double with each addition to N. Avoid for large N!",
      descriptionBn: "N এর মান ১ বাড়লেই অপারেশন দ্বিগুণ হয়ে যায়। বড় N এর জন্য পরিহারযোগ্য!",
      exampleEn: "All subsets generation, Naive Recursive Fibonacci",
      exampleBn: "সকল সাবসেট জেনারেশন, সাধারণ রিকার্সিভ ফিবোনাচ্চি",
      analogyEn: "Trying every possible combination of a padlock password.",
      analogyBn: "তালার পাসওয়ার্ড খোলার জন্য সকল সম্ভাব্য কম্বিনেশন চেষ্টা করা।",
      calcOps: (n) => math.pow(2.0, math.min(n, 25)).toDouble(), // Capped for performance
    ),
  ];

  // ম্যাথ ব্রেকডাউন তৈরি করার ফাংশন
  String _getMathBreakdown(String notation, double n) {
    int nVal = n.toInt();
    if (notation == "O(1)") return "1 Operation (Constant)";
    if (notation == "O(log N)") {
      return "log₂($nVal) ≈ ${(math.log(n) / math.log(2)).toStringAsFixed(1)} Ops";
    }
    if (notation == "O(N)") return "$nVal Operations";
    if (notation == "O(N log N)") {
      return "$nVal × log₂($nVal) ≈ ${(n * (math.log(n) / math.log(2))).toStringAsFixed(1)} Ops";
    }
    if (notation == "O(N²)") return "$nVal × $nVal = ${nVal * nVal} Ops";
    if (notation == "O(2ᴺ)") {
      if (nVal > 25) return "2^$nVal ≈ Infinity (Too Large!)";
      return "2^$nVal = ${math.pow(2, nVal).toInt()} Ops";
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    final isEng = widget.isEnglish;
    final isMobile = Responsive.isMobile(context);

    final selectedClass = _complexities.firstWhere(
          (c) => c.notation == _selectedNotation,
      orElse: () => _complexities[2],
    );

    // এক্সপোনেনশিয়াল বা অনেক বড় অপারেশনের জন্য ওয়ার্নিং চেকার
    final bool isDanger = selectedClass.notation == "O(2ᴺ)" && _inputN > 20;

    return SingleChildScrollView(
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
            child: Text(
              isEng
                  ? 'Adjust input size N and observe how operation counts scale across different Big O time complexities!'
                  : 'ইনপুট সাইজ N পরিবর্তন করে দেখুন কীভাবে বিভিন্ন বিগ ও টাইম কমপ্লেক্সিটিতে অপারেশনের সংখ্যা বৃদ্ধি পায়!',
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: Responsive.sp(context, 12),
                height: 1.35,
              ),
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
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
                        style: TextStyle(color: AppTheme.textMuted, fontSize: Responsive.sp(context, 11))),
                    Text("N = 32",
                        style: TextStyle(color: AppTheme.textMuted, fontSize: Responsive.sp(context, 11))),
                    Text("N = 64",
                        style: TextStyle(color: AppTheme.textMuted, fontSize: Responsive.sp(context, 11))),
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
                  color: isSelected ? item.color.withOpacity(0.15) : AppTheme.surfaceDark,
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
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
                          item.notation == "O(2ᴺ)" && _inputN > 25
                              ? "Huge! ⚠️"
                              : "~ ${ops.toInt()} ops",
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

          // Detailed Under The Hood Card
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(Responsive.sp(context, 16)),
            decoration: BoxDecoration(
              color: isDanger ? const Color(0xFF451A1A) : AppTheme.surfaceDark, // ডেঞ্জার জোন হলে ডার্ক রেড ব্যাকগ্রাউন্ড
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: selectedClass.color, width: 1.8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                        isDanger ? Icons.warning_rounded : Icons.info_rounded,
                        color: selectedClass.color,
                        size: 24
                    ),
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

                // গাণিতিক ব্রেকডাউন (Under the hood math)
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryDark.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: selectedClass.color.withOpacity(0.5), style: BorderStyle.solid),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calculate_outlined, color: selectedClass.color, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isEng ? "Math Breakdown (N = ${_inputN.toInt()}):" : "গাণিতিক হিসাব (N = ${_inputN.toInt()}):",
                              style: TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: Responsive.sp(context, 11),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _getMathBreakdown(selectedClass.notation, _inputN),
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'monospace',
                                fontWeight: FontWeight.bold,
                                fontSize: Responsive.sp(context, 13),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // সহজ উপমা (Analogy)
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryDark,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.textMuted.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.lightbulb_outline, color: Colors.yellow.shade600, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          isEng
                              ? "Analogy: ${selectedClass.analogyEn}"
                              : "সহজ উপমা: ${selectedClass.analogyBn}",
                          style: TextStyle(
                            color: Colors.white70,
                            fontStyle: FontStyle.italic,
                            fontSize: Responsive.sp(context, 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // কোড উদাহরণ
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.code, color: selectedClass.color, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        isEng
                            ? "Examples: ${selectedClass.exampleEn}"
                            : "উদাহরণ: ${selectedClass.exampleBn}",
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: Responsive.sp(context, 12),
                        ),
                      ),
                    ),
                  ],
                ),

                // ডেঞ্জার জোন ওয়ার্নিং
                if (isDanger) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.redAccent),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.warning, color: Colors.redAccent, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            isEng
                                ? "Danger! For N=${_inputN.toInt()}, operations are massive. Real algorithms might freeze your device!"
                                : "সতর্কতা! N=${_inputN.toInt()} এর জন্য অপারেশনের সংখ্যা বিশাল। বাস্তব অ্যালগরিদমে আপনার ডিভাইস হ্যাং করতে পারে!",
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: Responsive.sp(context, 11.5),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }
}
