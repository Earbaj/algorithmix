import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class HappyCodeFreeGuideTab extends StatefulWidget {
  final bool isEnglish;

  const HappyCodeFreeGuideTab({
    super.key,
    required this.isEnglish,
  });

  @override
  State<HappyCodeFreeGuideTab> createState() => _HappyCodeFreeGuideTabState();
}

class _HappyCodeFreeGuideTabState extends State<HappyCodeFreeGuideTab> {
  // 0: Example 1 (Happy: n=19), 1: Example 2 (Unhappy: n=2)
  int _simExample = 0;

  int _animStep = 0;
  bool _isPlaying = false;
  Timer? _animTimer;

  // Example datasets (LeetCode #202 / HelloInterview)
  final List<int> _example1Nodes = [19, 82, 68, 100, 1];

  final List<int> _example2Nodes = [2, 4, 16, 37, 58, 89, 145, 42, 20];
  final int _example2CycleTargetIdx = 1; // Tail 20 points back to node 4 (index 1)

  @override
  void dispose() {
    _animTimer?.cancel();
    super.dispose();
  }

  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;
    });

    int maxSteps = _simExample == 0 ? 4 : 5;
    if (_isPlaying) {
      _animTimer = Timer.periodic(const Duration(milliseconds: 1800), (timer) {
        if (_animStep < maxSteps) {
          setState(() {
            _animStep++;
          });
        } else {
          _animTimer?.cancel();
          setState(() {
            _isPlaying = false;
          });
        }
      });
    } else {
      _animTimer?.cancel();
    }
  }

  void _resetAnimation() {
    _animTimer?.cancel();
    setState(() {
      _isPlaying = false;
      _animStep = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final hPadding = Responsive.horizontalPadding(context);

    // Compute pointer indices and step text
    int slowIdx = 0;
    int fastIdx = 0;
    String stepTextEn = "";
    String stepTextBn = "";
    bool isFinished = false;

    if (_simExample == 0) {
      // Example 1: Happy Number n = 19
      if (_animStep == 0) {
        slowIdx = 0;
        fastIdx = 0;
        stepTextEn = "Start: Both Slow (🐢) and Fast (🐇) start at number 19.";
        stepTextBn = "শুরু: Slow (🐢) এবং Fast (🐇) দুজনই ১৯ সংখ্যাটি নির্দেশ করছে।";
      } else if (_animStep == 1) {
        slowIdx = 1; // 82
        fastIdx = 2; // 68
        stepTextEn = "Step 1: Slow transforms 1x → 82 (1²+9²). Fast transforms 2x → 68 (19->82->68).";
        stepTextBn = "ধাপ ১: Slow ১ ধাপ হেঁটে ৮২ (1²+9²)। Fast ২ ধাপ হেঁটে ৬৮ (19->82->68)।";
      } else if (_animStep == 2) {
        slowIdx = 2; // 68
        fastIdx = 4; // 1
        stepTextEn = "Step 2: Slow transforms 1x → 68. Fast transforms 2x → 1 (68->100->1). Fast reached 1!";
        stepTextBn = "ধাপ ২: Slow ১ ধাপ হেঁটে ৬৮। Fast ২ ধাপ হেঁটে ১ (68->100->1)। Fast ১ এ পৌঁছেছে!";
      } else if (_animStep == 3) {
        slowIdx = 3; // 100
        fastIdx = 4; // 1
        stepTextEn = "Step 3: Slow transforms 1x → 100. Fast remains at 1 (1²+0²=1).";
        stepTextBn = "ধাপ ৩: Slow ১ ধাপ হেঁটে ১০০। Fast ১ এ স্থির আছে।";
      } else {
        slowIdx = 4; // 1
        fastIdx = 4; // 1
        isFinished = true;
        stepTextEn = "🎉 HAPPY NUMBER FOUND! Both Slow and Fast landed on 1! Output: true.";
        stepTextBn = "🎉 হ্যাপি নাম্বার পাওয়া গেছে! Slow এবং Fast উভয়ই ১ এ পৌঁছেছে! আউটপুট: true।";
      }
    } else {
      // Example 2: Unhappy Number n = 2
      if (_animStep == 0) {
        slowIdx = 0; // 2
        fastIdx = 0; // 2
        stepTextEn = "Start: Both Slow (🐢) and Fast (🐇) start at number 2.";
        stepTextBn = "শুরু: Slow (🐢) এবং Fast (🐇) দুজনই ২ নির্দেশ করছে।";
      } else if (_animStep == 1) {
        slowIdx = 1; // 4
        fastIdx = 2; // 16
        stepTextEn = "Step 1: Slow transforms 1x → 4 (2²). Fast transforms 2x → 16 (2->4->16).";
        stepTextBn = "ধাপ ১: Slow ১ ধাপ হেঁটে ৪। Fast ২ ধাপ হেঁটে ১৬।";
      } else if (_animStep == 2) {
        slowIdx = 2; // 16
        fastIdx = 4; // 58
        stepTextEn = "Step 2: Slow moves to 16. Fast moves 2x → 58 (16->37->58).";
        stepTextBn = "ধাপ ২: Slow হেঁটে ১৬ তে। Fast ২ ধাপ হেঁটে ৫৮ তে।";
      } else if (_animStep == 3) {
        slowIdx = 3; // 37
        fastIdx = 6; // 145
        stepTextEn = "Step 3: Slow moves to 37. Fast moves 2x → 145 (58->89->145).";
        stepTextBn = "ধাপ ৩: Slow হেঁটে ৩৭ এ। Fast ২ ধাপ হেঁটে ১৪৫ এ।";
      } else if (_animStep == 4) {
        slowIdx = 4; // 58
        fastIdx = 8; // 20
        stepTextEn = "Step 4: Slow moves to 58. Fast moves 2x → 20 (145->42->20, at end of cycle chain).";
        stepTextBn = "ধাপ ৪: Slow হেঁটে ৫৮ তে। Fast ২ ধাপ হেঁটে ২০ এ।";
      } else {
        slowIdx = 1; // 4
        fastIdx = 1; // 4 (Fast wrapped cycle 20->4->16->... and caught Slow at 4!)
        isFinished = true;
        stepTextEn = "🛑 CYCLE DETECTED! Both meet at number 4 inside the loop! Will never reach 1. Output: false.";
        stepTextBn = "🛑 সাইকেল ধরা পড়েছে! পয়েন্টার দুটি লুপের ভেতর ৪ সংখ্যায় মিলিত হয়েছে! কখনো ১ এ পৌঁছাবে না। আউটপুট: false।";
      }
    }

    return ResponsiveCenter(
      maxWidth: 1280.0,
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Container
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.isEnglish ? "Happy Number Concept Guide" : "হ্যাপি নাম্বার কনসেপ্ট গাইড",
                  style: TextStyle(
                    fontSize: Responsive.sp(context, 18),
                    fontWeight: FontWeight.bold,
                    color: AppTheme.accentNeonCyan,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.isEnglish
                      ? "Determine if digit square sum sequence reaches 1 (Happy) or gets trapped in a cycle (Unhappy) using Fast & Slow pointers!"
                      : "ডিজিটের বর্গের যোগফলের ধারা ১ এ পৌঁছায় (হ্যাপি) নাকি লুপের ভেতর আটকে যায় (আনহ্যাপি) তা পয়েন্টার দিয়ে পরীক্ষা করুন!",
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: Responsive.sp(context, 13.5),
                    height: 1.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Section Title
            Row(
              children: [
                Text(
                  widget.isEnglish ? "Examples" : "উদাহরণসমূহ",
                  style: TextStyle(
                    fontSize: Responsive.sp(context, 18),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // EXAMPLE 1 CARD (Happy Number n=19)
            _buildExampleDiagramCard(
              context: context,
              title: "Example 1: Happy Number (n = 19)",
              titleBn: "উদাহরণ ১: হ্যাপি নাম্বার (n = 19)",
              inputDesc: "n = 19 (19 -> 82 -> 68 -> 100 -> 1)",
              inputDescBn: "n = 19 (19 -> 82 -> 68 -> 100 -> 1)",
              outputResult: "true",
              isHappy: true,
              nodes: _example1Nodes,
              cycleTargetIdx: null,
              explanationEn: "Output: true — Sequence ends in 1 (19 -> 82 -> 68 -> 100 -> 1).",
              explanationBn: "আউটপুট: true — অংকগুলোর বর্গের যোগফল অবশেষে ১ এ গিয়ে পৌছেছে।",
            ),
            const SizedBox(height: 20),

            // EXAMPLE 2 CARD (Unhappy Number n=2)
            _buildExampleDiagramCard(
              context: context,
              title: "Example 2: Unhappy Number / Cycle (n = 2)",
              titleBn: "উদাহরণ ২: লুপ সাইকেল যুক্ত আনহ্যাপি নাম্বার (n = 2)",
              inputDesc: "n = 2 (2 -> 4 -> 16 -> 37 -> 58 -> 89 -> 145 -> 42 -> 20 -> 4)",
              inputDescBn: "n = 2 (2 -> 4 -> 16 -> 37 -> 58 -> 89 -> 145 -> 42 -> 20 -> 4)",
              outputResult: "false",
              isHappy: false,
              nodes: _example2Nodes,
              cycleTargetIdx: _example2CycleTargetIdx,
              explanationEn: "Output: false — Sequence enters an infinite cycle containing 4 (4 -> 16 -> 37 -> ... -> 20 -> 4).",
              explanationBn: "আউটপুট: false — ধারাটি ১ এ না পৌঁছে ৪ সহ একটি অনন্ত চক্রে অসীমভাবে ঘুরতে থাকে।",
            ),
            const SizedBox(height: 28),

            // INTERACTIVE SIMULATION SECTION
            Container(
              padding: EdgeInsets.all(Responsive.sp(context, 18)),
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isFinished
                      ? (_simExample == 0 ? AppTheme.accentGreen : AppTheme.accentPink)
                      : const Color(0xFF334155),
                  width: 2,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.isEnglish ? "Interactive Algorithm Step Visualizer" : "ইন্টারঅ্যাক্টিভ অ্যালগরিদম স্টেপ ভিজ্যুয়ালাইজার",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: Responsive.sp(context, 15),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Step ${_animStep + 1} / ${_simExample == 0 ? 5 : 6}",
                    style: const TextStyle(
                      color: AppTheme.accentNeonCyan,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Example selector toggle
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Text(
                          widget.isEnglish ? "Select Case: " : "কেস সিলেক্ট করুন: ",
                          style: TextStyle(color: AppTheme.textSecondary, fontSize: Responsive.sp(context, 13)),
                        ),
                        const SizedBox(width: 8),
                        ChoiceChip(
                          label: Text("Example 1 (Happy: n=19)", style: TextStyle(fontSize: Responsive.sp(context, 12))),
                          selected: _simExample == 0,
                          selectedColor: AppTheme.accentNeonCyan.withOpacity(0.3),
                          labelStyle: TextStyle(
                            color: _simExample == 0 ? AppTheme.accentNeonCyan : Colors.white70,
                            fontWeight: FontWeight.bold,
                          ),
                          onSelected: (val) {
                            if (val) {
                              setState(() {
                                _simExample = 0;
                                _resetAnimation();
                              });
                            }
                          },
                        ),
                        const SizedBox(width: 8),
                        ChoiceChip(
                          label: Text("Example 2 (Unhappy: n=2)", style: TextStyle(fontSize: Responsive.sp(context, 12))),
                          selected: _simExample == 1,
                          selectedColor: AppTheme.accentPurple.withOpacity(0.3),
                          labelStyle: TextStyle(
                            color: _simExample == 1 ? AppTheme.accentPurple : Colors.white70,
                            fontWeight: FontWeight.bold,
                          ),
                          onSelected: (val) {
                            if (val) {
                              setState(() {
                                _simExample = 1;
                                _resetAnimation();
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Visualizer Diagram Widget with Pointers
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: HappyLinkedListDiagram(
                      nodes: _simExample == 0 ? _example1Nodes : _example2Nodes,
                      cycleTargetIdx: _simExample == 1 ? _example2CycleTargetIdx : null,
                      slowIdx: slowIdx,
                      fastIdx: fastIdx,
                      showPointers: true,
                      isFinished: isFinished,
                      isHappy: _simExample == 0,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Step description card
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isFinished
                          ? (_simExample == 0 ? AppTheme.accentGreen.withOpacity(0.15) : AppTheme.accentPink.withOpacity(0.15))
                          : AppTheme.primaryDark,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isFinished
                            ? (_simExample == 0 ? AppTheme.accentGreen : AppTheme.accentPink)
                            : const Color(0xFF334155),
                      ),
                    ),
                    child: Text(
                      widget.isEnglish ? stepTextEn : stepTextBn,
                      style: TextStyle(
                        color: isFinished
                            ? (_simExample == 0 ? AppTheme.accentGreen : AppTheme.accentPink)
                            : Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: Responsive.sp(context, 13.5),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Animation Controls Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.skip_previous, color: Colors.white, size: Responsive.sp(context, 20)),
                        onPressed: _animStep > 0 ? () => setState(() => _animStep--) : null,
                      ),
                      IconButton(
                        icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, color: AppTheme.accentNeonCyan, size: Responsive.sp(context, 24)),
                        onPressed: _togglePlay,
                      ),
                      IconButton(
                        icon: Icon(Icons.skip_next, color: Colors.white, size: Responsive.sp(context, 20)),
                        onPressed: _animStep < (_simExample == 0 ? 4 : 5)
                            ? () => setState(() => _animStep++)
                            : null,
                      ),
                      IconButton(
                        icon: Icon(Icons.refresh, color: AppTheme.textMuted, size: Responsive.sp(context, 20)),
                        onPressed: _resetAnimation,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildExampleDiagramCard({
    required BuildContext context,
    required String title,
    required String titleBn,
    required String inputDesc,
    required String inputDescBn,
    required String outputResult,
    required bool isHappy,
    required List<int> nodes,
    required int? cycleTargetIdx,
    required String explanationEn,
    required String explanationBn,
  }) {
    final statusColor = isHappy ? AppTheme.accentGreen : AppTheme.accentPink;

    return Container(
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
          Text(
            widget.isEnglish ? title : titleBn,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppTheme.accentNeonCyan,
              fontSize: Responsive.sp(context, 14.5),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Output: $outputResult",
            style: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.bold,
              fontSize: Responsive.sp(context, 12),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            widget.isEnglish ? inputDesc : inputDescBn,
            style: TextStyle(
              fontFamily: 'monospace',
              color: AppTheme.textSecondary,
              fontSize: Responsive.sp(context, 12.5),
            ),
          ),
          const SizedBox(height: 16),

          // Visual Diagram
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: HappyLinkedListDiagram(
              nodes: nodes,
              cycleTargetIdx: cycleTargetIdx,
              showPointers: false,
              highlightHappyTarget: isHappy,
            ),
          ),
          const SizedBox(height: 12),

          Text(
            widget.isEnglish ? explanationEn : explanationBn,
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: Responsive.sp(context, 13),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Widget for rendering Happy Number Sequence nodes, horizontal next arrows,
// head pointer badge, pointers, and cycle loop-back curve.
class HappyLinkedListDiagram extends StatelessWidget {
  final List<int> nodes;
  final int? cycleTargetIdx; // Index where tail points to, null if happy
  final int? slowIdx;
  final int? fastIdx;
  final bool showPointers;
  final bool isFinished;
  final bool isHappy;
  final bool highlightHappyTarget;

  const HappyLinkedListDiagram({
    super.key,
    required this.nodes,
    this.cycleTargetIdx,
    this.slowIdx,
    this.fastIdx,
    this.showPointers = false,
    this.isFinished = false,
    this.isHappy = true,
    this.highlightHappyTarget = false,
  });

  @override
  Widget build(BuildContext context) {
    const double nodeW = 54.0;
    const double nodeGap = 34.0;
    const double topSpace = 40.0;
    const double nodeH = 52.0;
    const double bottomSpace = 44.0;

    final bool hasCycle = cycleTargetIdx != null;
    final double totalW = nodes.length * (nodeW + nodeGap) + 20.0;
    final double totalH = topSpace + nodeH + (hasCycle ? bottomSpace : 24.0);

    return SizedBox(
      width: math.max(totalW, 440.0),
      height: totalH,
      child: Stack(
        children: [
          // Next Arrows & Cycle Line using CustomPainter
          Positioned.fill(
            child: CustomPaint(
              painter: HappyLinkedListPainter(
                nodeCount: nodes.length,
                nodeWidth: nodeW,
                nodeGap: nodeGap,
                topSpace: topSpace,
                nodeHeight: nodeH,
                cycleTargetIdx: cycleTargetIdx,
              ),
            ),
          ),

          // Nodes Rendering
          ...List.generate(nodes.length, (idx) {
            final double leftPos = 16.0 + idx * (nodeW + nodeGap);
            final int val = nodes[idx];

            final bool isSlow = showPointers && slowIdx == idx;
            final bool isFast = showPointers && fastIdx == idx;
            final bool isMeet = isSlow && isFast;
            final bool isTargetOne = val == 1 && (highlightHappyTarget || (isFinished && isHappy));

            Color boxBg = AppTheme.primaryDark;
            Color borderColor = const Color(0xFF334155);

            if (isTargetOne) {
              boxBg = AppTheme.accentGreen.withOpacity(0.35);
              borderColor = AppTheme.accentGreen;
            } else if (isMeet) {
              boxBg = isHappy ? AppTheme.accentGreen.withOpacity(0.35) : AppTheme.accentPink.withOpacity(0.35);
              borderColor = isHappy ? AppTheme.accentGreen : AppTheme.accentPink;
            } else if (isSlow) {
              boxBg = AppTheme.accentNeonCyan.withOpacity(0.25);
              borderColor = AppTheme.accentNeonCyan;
            } else if (isFast) {
              boxBg = AppTheme.accentPurple.withOpacity(0.25);
              borderColor = AppTheme.accentPurple;
            }

            return Positioned(
              left: leftPos,
              top: topSpace,
              child: SizedBox(
                width: nodeW,
                child: Column(
                  children: [
                    Container(
                      width: nodeW,
                      height: nodeH,
                      decoration: BoxDecoration(
                        color: boxBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: borderColor, width: 2),
                        boxShadow: [
                          if (isTargetOne)
                            BoxShadow(color: AppTheme.accentGreen.withOpacity(0.4), blurRadius: 10)
                          else if (isSlow)
                            BoxShadow(color: AppTheme.accentNeonCyan.withOpacity(0.3), blurRadius: 8)
                          else if (isFast)
                            BoxShadow(color: AppTheme.accentPurple.withOpacity(0.3), blurRadius: 8)
                        ],
                      ),
                      child: Center(
                        child: Text(
                          '$val',
                          style: TextStyle(
                            fontSize: Responsive.sp(context, 16),
                            fontWeight: FontWeight.bold,
                            color: isTargetOne ? AppTheme.accentGreen : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),

          // Head Badge above node 0
          Positioned(
            left: 16.0,
            top: 6.0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppTheme.accentNeonCyan,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text("start", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 10)),
                  SizedBox(width: 2),
                  Icon(Icons.arrow_downward, color: Colors.black, size: 10),
                ],
              ),
            ),
          ),

          // Pointers (Slow / Fast) Top Indicators during simulation
          if (showPointers) ...[
            if (slowIdx != null && slowIdx! >= 0 && slowIdx! < nodes.length)
              Positioned(
                left: 16.0 + slowIdx! * (nodeW + nodeGap) - (slowIdx == fastIdx ? 8 : 0),
                top: 6.0,
                child: slowIdx == fastIdx
                    ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isHappy ? AppTheme.accentGreen : AppTheme.accentPink,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          isHappy ? "🎉 1 Found!" : "🛑 Cycle!",
                          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 10),
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.accentNeonCyan,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text("🐢 Slow", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 10)),
                      ),
              ),
            if (fastIdx != null && fastIdx != slowIdx && fastIdx! >= 0 && fastIdx! < nodes.length)
              Positioned(
                left: 16.0 + fastIdx! * (nodeW + nodeGap),
                top: 6.0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.accentPurple,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text("🐇 Fast", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10)),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

// Custom Painter for drawing horizontal next arrows and cycle loop-back curved line
class HappyLinkedListPainter extends CustomPainter {
  final int nodeCount;
  final double nodeWidth;
  final double nodeGap;
  final double topSpace;
  final double nodeHeight;
  final int? cycleTargetIdx;

  HappyLinkedListPainter({
    required this.nodeCount,
    required this.nodeWidth,
    required this.nodeGap,
    required this.topSpace,
    required this.nodeHeight,
    this.cycleTargetIdx,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final arrowPaint = Paint()
      ..color = const Color(0xFF59B9B0)
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = const Color(0xFF227D70)
      ..style = PaintingStyle.fill;

    final double yCenter = topSpace + nodeHeight / 2;

    // Draw horizontal arrows between node i and node i+1
    for (int i = 0; i < nodeCount - 1; i++) {
      double x1 = 16.0 + i * (nodeWidth + nodeGap) + nodeWidth;
      double x2 = 16.0 + (i + 1) * (nodeWidth + nodeGap);

      canvas.drawLine(Offset(x1, yCenter), Offset(x2, yCenter), arrowPaint);

      // Draw Arrowhead pointing right
      Path tipPath = Path();
      tipPath.moveTo(x2, yCenter);
      tipPath.lineTo(x2 - 8, yCenter - 5);
      tipPath.lineTo(x2 - 8, yCenter + 5);
      tipPath.close();
      canvas.drawPath(tipPath, fillPaint);
    }

    // Draw Cycle Loop-back curved arrow for Unhappy Number Example 2
    if (cycleTargetIdx != null) {
      final cyclePaint = Paint()
        ..color = AppTheme.accentPink
        ..strokeWidth = 3.0
        ..style = PaintingStyle.stroke;

      final cycleFill = Paint()
        ..color = AppTheme.accentPink
        ..style = PaintingStyle.fill;

      int tailIdx = nodeCount - 1;
      double xTail = 16.0 + tailIdx * (nodeWidth + nodeGap) + nodeWidth / 2;
      double xTarget = 16.0 + cycleTargetIdx! * (nodeWidth + nodeGap) + nodeWidth / 2;

      double yTailBottom = topSpace + nodeHeight;
      double yLoopBottom = yTailBottom + 30.0;

      Path cyclePath = Path();
      cyclePath.moveTo(xTail, yTailBottom);
      cyclePath.lineTo(xTail, yLoopBottom - 6);
      cyclePath.quadraticBezierTo(xTail, yLoopBottom, xTail - 6, yLoopBottom);
      cyclePath.lineTo(xTarget + 6, yLoopBottom);
      cyclePath.quadraticBezierTo(xTarget, yLoopBottom, xTarget, yLoopBottom - 6);
      cyclePath.lineTo(xTarget, yTailBottom + 8);

      canvas.drawPath(cyclePath, cyclePaint);

      // Draw Arrowhead pointing UP into target node bottom
      Path upArrow = Path();
      upArrow.moveTo(xTarget, yTailBottom + 2);
      upArrow.lineTo(xTarget - 5, yTailBottom + 10);
      upArrow.lineTo(xTarget + 5, yTailBottom + 10);
      upArrow.close();
      canvas.drawPath(upArrow, cycleFill);
    }
  }

  @override
  bool shouldRepaint(covariant HappyLinkedListPainter oldDelegate) {
    return oldDelegate.nodeCount != nodeCount || oldDelegate.cycleTargetIdx != cycleTargetIdx;
  }
}

