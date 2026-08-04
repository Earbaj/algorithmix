import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class AmortizedStep {
  final int elementCount;
  final int capacity;
  final int totalCopies;
  final String statusType;
  final String titleEn;
  final String titleBn;
  final String descriptionEn;
  final String descriptionBn;

  const AmortizedStep({
    required this.elementCount,
    required this.capacity,
    required this.totalCopies,
    required this.statusType,
    required this.titleEn,
    required this.titleBn,
    required this.descriptionEn,
    required this.descriptionBn,
  });
}

class AmortizedComplexityCodeFreeVisualizer extends StatefulWidget {
  final bool isEnglish;

  const AmortizedComplexityCodeFreeVisualizer({
    super.key,
    required this.isEnglish,
  });

  @override
  State<AmortizedComplexityCodeFreeVisualizer> createState() =>
      _AmortizedComplexityCodeFreeVisualizerState();
}

class _AmortizedComplexityCodeFreeVisualizerState
    extends State<AmortizedComplexityCodeFreeVisualizer> {
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  List<AmortizedStep> _steps = [];

  @override
  void initState() {
    super.initState();
    _generateSteps();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _generateSteps() {
    _steps = const [
      AmortizedStep(
        elementCount: 1,
        capacity: 1,
        totalCopies: 0,
        statusType: "insert",
        titleEn: "Step 1: Insert 1st Element → Capacity = 1",
        titleBn: "ধাপ ১: ১ম এলিমেন্ট ইনসার্ট → ক্যাপাসিটি = ১",
        descriptionEn: "Array created with initial capacity 1. Instant insertion.",
        descriptionBn: "১ম প্রাথমিক ক্যাপাসিটি নিয়ে অ্যারে তৈরি।",
      ),
      AmortizedStep(
        elementCount: 2,
        capacity: 2,
        totalCopies: 1,
        statusType: "double",
        titleEn: "Step 2: Insert 2nd Element → Array Full! Double Capacity to 2",
        titleBn: "ধাপ ২: ২য় এলিমেন্ট ইনসার্ট → অ্যারে ফুল! ক্যাপাসিটি ডাবল করে ২",
        descriptionEn: "Array doubled to capacity 2. 1 copy operation performed.",
        descriptionBn: "ক্যাপাসিটি দ্বিগুণ করা হলো। ১টি উপাদান কপি করা হলো।",
      ),
      AmortizedStep(
        elementCount: 3,
        capacity: 4,
        totalCopies: 3,
        statusType: "double",
        titleEn: "Step 3: Insert 3rd Element → Array Full! Double Capacity to 4",
        titleBn: "ধাপ ৩: ৩য় এলিমেন্ট ইনসার্ট → অ্যারে ফুল! ক্যাপাসিটি ডাবল করে ৪",
        descriptionEn: "Array doubled to capacity 4. 2 extra copy operations. Total copies = 3.",
        descriptionBn: "ক্যাপাসিটি ৪ করা হলো। মোট ৩টি কপি সম্পন্ন।",
      ),
      AmortizedStep(
        elementCount: 5,
        capacity: 8,
        totalCopies: 7,
        statusType: "double",
        titleEn: "Step 4: Insert 5th Element → Double Capacity to 8",
        titleBn: "ধাপ ৪: ৫ম এলিমেন্ট ইনসার্ট → ক্যাপাসিটি ডাবল করে ৮",
        descriptionEn: "Array doubled to capacity 8. Total copies over 5 elements = 7 operations.",
        descriptionBn: "ক্যাপাসিটি ৮ করা হলো। ৫টি উপাদানে মোট ৭টি কপি।",
      ),
      AmortizedStep(
        elementCount: 8,
        capacity: 8,
        totalCopies: 7,
        statusType: "finish",
        titleEn: "🎉 Result: Total Copies (7) < 2 * N (16) → Amortized O(1)",
        titleBn: "🎉 ফলাফল: মোট কপি (৭) < ২ * N (১৬) → অ্যামোরটাইজড O(1)",
        descriptionEn: "Average cost per push = Total Operations / N = O(1) constant time!",
        descriptionBn: "প্রতি পুশ অপারেশনের গড় সময় = O(1) কনস্ট্যান্ট!",
      ),
    ];
  }

  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;
    });

    if (_isPlaying) {
      _timer = Timer.periodic(const Duration(milliseconds: 1800), (timer) {
        if (_currentStepIndex < _steps.length - 1) {
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

  @override
  Widget build(BuildContext context) {
    final isEng = widget.isEnglish;
    final isMobile = Responsive.isMobile(context);
    final step = _steps[_currentStepIndex];

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        vertical: Responsive.verticalPadding(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(isMobile ? 12 : 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.accentPurple.withOpacity(0.25),
                  AppTheme.accentNeonCyan.withOpacity(0.15),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.accentNeonCyan.withOpacity(0.4)),
            ),
            child: Row(
              children: [
                Icon(Icons.trending_down_rounded,
                    color: AppTheme.accentNeonCyan, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isEng
                            ? 'Amortized Capacity Doubling Visualizer'
                            : 'অ্যামোরটাইজড ক্যাপাসিটি ডাবলিং ভিজ্যুয়ালাইজার',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: Responsive.sp(context, 16),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        isEng
                            ? 'Watch dynamic vector memory allocation double to achieve amortized O(1) time!'
                            : 'ডায়নামিক ভেক্টরের মেমোরি দ্বিগুণ হওয়ার মাধ্যমে অ্যামোরটাইজড O(1) দেখুন!',
                        style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: Responsive.sp(context, 12)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Vector Slots Graphic
          Container(
            width: double.infinity,
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
                      "Dynamic Array Memory Slots:",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: Responsive.sp(context, 13)),
                    ),
                    Text(
                      "Capacity: ${step.capacity} | Used: ${step.elementCount}",
                      style: TextStyle(
                          color: AppTheme.accentNeonCyan,
                          fontWeight: FontWeight.bold,
                          fontSize: Responsive.sp(context, 12)),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(step.capacity, (idx) {
                      bool isFilled = idx < step.elementCount;
                      return Container(
                        margin: const EdgeInsets.only(right: 6),
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: isFilled
                              ? AppTheme.accentPurple.withOpacity(0.3)
                              : AppTheme.primaryDark,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: isFilled
                                  ? AppTheme.accentPurple
                                  : const Color(0xFF334155)),
                        ),
                        child: Center(
                          child: Text(
                            isFilled ? "${idx + 1}" : "",
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.skip_previous,
                        color: Colors.white, size: Responsive.sp(context, 20)),
                    onPressed: _currentStepIndex > 0
                        ? () => setState(() => _currentStepIndex--)
                        : null,
                  ),
                  IconButton(
                    icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow,
                        color: AppTheme.accentNeonCyan,
                        size: Responsive.sp(context, 24)),
                    onPressed: _togglePlay,
                  ),
                  IconButton(
                    icon: Icon(Icons.skip_next,
                        color: Colors.white, size: Responsive.sp(context, 20)),
                    onPressed: _currentStepIndex < _steps.length - 1
                        ? () => setState(() => _currentStepIndex++)
                        : null,
                  ),
                ],
              ),
              Text(
                "Step ${_currentStepIndex + 1} / ${_steps.length}",
                style: TextStyle(
                    color: AppTheme.accentNeonCyan,
                    fontWeight: FontWeight.bold,
                    fontSize: Responsive.sp(context, 12)),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: Text(
              isEng ? step.descriptionEn : step.descriptionBn,
              style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: Responsive.sp(context, 12.5)),
            ),
          ),
        ],
      ),
    );
  }
}
