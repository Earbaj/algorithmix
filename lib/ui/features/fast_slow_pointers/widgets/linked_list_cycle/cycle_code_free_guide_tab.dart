import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class CycleCodeFreeGuideTab extends StatefulWidget {
  final bool isEnglish;

  const CycleCodeFreeGuideTab({
    super.key,
    required this.isEnglish,
  });

  @override
  State<CycleCodeFreeGuideTab> createState() => _CycleCodeFreeGuideTabState();
}

class _CycleCodeFreeGuideTabState extends State<CycleCodeFreeGuideTab> {
  // 0: Example 1 (Cycle), 1: Example 2 (No Cycle)
  int _simExample = 0;

  int _animStep = 0;
  bool _isPlaying = false;
  Timer? _animTimer;

  // Nodes for examples (HelloInterview setup)
  final List<int> _example1Nodes = [5, 4, 3, 2, 0];
  final int _example1CyclePos = 2; // Target node value 3 (index 2)

  final List<int> _example2Nodes = [5, 4, 3, 2, 0];

  @override
  void dispose() {
    _animTimer?.cancel();
    super.dispose();
  }

  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;
    });

    if (_isPlaying) {
      _animTimer = Timer.periodic(const Duration(milliseconds: 1800), (timer) {
        if (_animStep < 3) {
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

    // Compute pointer indices for interactive animation
    int slowIdx = 0;
    int fastIdx = 0;
    String stepTextEn = "";
    String stepTextBn = "";

    if (_simExample == 0) {
      // Example 1: Has Cycle
      if (_animStep == 0) {
        slowIdx = 0;
        fastIdx = 0;
        stepTextEn = "Start: Both Slow (🐢) and Fast (🐇) start at Head (Node index 0 [val: 5]).";
        stepTextBn = "শুরু: Slow (🐢) এবং Fast (🐇) দুজনই হেডে (ইনডেক্স ০, মান ৫) অবস্থান করছে।";
      } else if (_animStep == 1) {
        slowIdx = 1;
        fastIdx = 2;
        stepTextEn = "Step 1: Slow moves 1 step → Node [4]. Fast moves 2 steps → Node [3].";
        stepTextBn = "ধাপ ১: Slow ১ ধাপ হেঁটে নোড [4] এ। Fast ২ ধাপ হেঁটে নোড [3] এ।";
      } else if (_animStep == 2) {
        slowIdx = 2;
        fastIdx = 4;
        stepTextEn = "Step 2: Slow moves 1 step → Node [3]. Fast moves 2 steps → Tail Node [0].";
        stepTextBn = "ধাপ ২: Slow ১ ধাপ হেঁটে নোড [3] এ। Fast ২ ধাপ হেঁটে টেল নোড [0] এ।";
      } else {
        slowIdx = 3;
        fastIdx = 3; // Fast wraps back from 0 -> 3 (val 3) -> 2 (val 2)
        stepTextEn = "🎉 COLLISION DETECTED! Both meet at Node index 3 [val: 2] inside the cycle! Return true!";
        stepTextBn = "🎉 সাইকেলে মিলন ঘটেছে! সাইকেলের ভেতর উভয় পয়েন্টার ইনডেক্স ৩ [মান: 2] এ মিলিত হয়েছে! Return true!";
      }
    } else {
      // Example 2: No Cycle
      if (_animStep == 0) {
        slowIdx = 0;
        fastIdx = 0;
        stepTextEn = "Start: Both Slow (🐢) and Fast (🐇) start at Head (Node index 0 [val: 5]).";
        stepTextBn = "শুরু: Slow (🐢) এবং Fast (🐇) দুজনই হেডে (ইনডেক্স ০, মান ৫) অবস্থান করছে।";
      } else if (_animStep == 1) {
        slowIdx = 1;
        fastIdx = 2;
        stepTextEn = "Step 1: Slow moves 1 step → Node [4]. Fast moves 2 steps → Node [3].";
        stepTextBn = "ধাপ ১: Slow ১ ধাপ হেঁটে নোড [4] এ। Fast ২ ধাপ হেঁটে নোড [3] এ।";
      } else if (_animStep == 2) {
        slowIdx = 2;
        fastIdx = 4;
        stepTextEn = "Step 2: Slow moves 1 step → Node [3]. Fast moves 2 steps → Tail Node [0].";
        stepTextBn = "ধাপ ২: Slow ১ ধাপ হেঁটে নোড [3] এ। Fast ২ ধাপ হেঁটে নোড [0] এ।";
      } else {
        slowIdx = 3;
        fastIdx = -1; // Fast reaches null
        stepTextEn = "🛑 END OF LIST REACHED! Fast.next is null! No cycle in linked list. Return false!";
        stepTextBn = "🛑 লিঙ্কড লিস্টের শেষ প্রান্তর! Fast.next null এ পৌছেছে! কোনো সাইকেল নেই। Return false!";
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
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.accentNeonCyan.withOpacity(0.4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.isEnglish ? "Linked List Cycle Concept Guide" : "লিঙ্কড লিস্ট সাইকেল কনসেপ্ট গাইড",
                    style: TextStyle(
                      fontSize: Responsive.sp(context, 18),
                      fontWeight: FontWeight.bold,
                      color: AppTheme.accentNeonCyan,
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.isEnglish
                        ? "Hello Interview Guide Examples: Detect linked list cycles using Floyd's Tortoise & Hare Algorithm. Fast pointer moves 2 steps while Slow pointer moves 1 step."
                        : "Hello Interview গাইড উদাহরণসমূহ: ফ্লয়েডের Tortoise & Hare অ্যালগরিদম ব্যবহার করে লিঙ্কড লিস্ট সাইকেল চিহ্নিত করুন। Fast পয়েন্টার ২ ধাপ এবং Slow পয়েন্টার ১ ধাপ অগ্রসর হয়।",
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: Responsive.sp(context, 13.5),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Section Title
            Row(
              children: [
                const Icon(Icons.palette_outlined, color: AppTheme.accentPurple, size: 22),
                const SizedBox(width: 8),
                Text(
                  widget.isEnglish ? "Hello Interview Examples" : "Hello Interview উদাহরণসমূহ",
                  style: TextStyle(
                    fontSize: Responsive.sp(context, 18),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // EXAMPLE 1 CARD
            _buildExampleDiagramCard(
              context: context,
              title: "Example 1: Linked List with Cycle",
              titleBn: "উদাহরণ ১: সাইকেল যুক্ত লিঙ্কড লিস্ট",
              inputDesc: "head = [5, 4, 3, 2, 0], pos = 2 (Tail node 0 points back to node 3)",
              inputDescBn: "head = [5, 4, 3, 2, 0], pos = 2 (টেল নোড 0 ইনডেক্স 2 [মান 3] এ যুক্ত)",
              outputResult: "true",
              isCycle: true,
              nodes: _example1Nodes,
              cycleTargetIdx: _example1CyclePos,
              explanationEn: "Output: true — There is a cycle in the linked list because node 0 points back to node 3.",
              explanationBn: "আউটপুট: true — লিঙ্কড লিস্টে নোড 0 পুনরায় নোড 3 কে পয়েন্ট করায় একটি সাইকেল তৈরি হয়েছে।",
            ),
            const SizedBox(height: 20),

            // EXAMPLE 2 CARD
            _buildExampleDiagramCard(
              context: context,
              title: "Example 2: Linked List without Cycle",
              titleBn: "উদাহরণ ২: সাইকেল বিহীন লিঙ্কড লিস্ট",
              inputDesc: "head = [5, 4, 3, 2, 0], pos = -1 (Tail node 0 points to null)",
              inputDescBn: "head = [5, 4, 3, 2, 0], pos = -1 (টেল নোড 0 null কে পয়েন্ট করে)",
              outputResult: "false",
              isCycle: false,
              nodes: _example2Nodes,
              cycleTargetIdx: null,
              explanationEn: "Output: false — There is no cycle in the linked list as it terminates at null.",
              explanationBn: "আউটপুট: false — লিঙ্কড লিস্টের শেষে null থাকায় কোনো সাইকেল বিদ্যমান নেই।",
            ),
            const SizedBox(height: 28),

            // INTERACTIVE SIMULATION SECTION
            Container(
              padding: EdgeInsets.all(Responsive.sp(context, 18)),
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _animStep == 3
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
                  Text(
                    "Step ${_animStep + 1} / 4",
                    style: const TextStyle(
                      color: AppTheme.accentNeonCyan,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 14),

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
                          label: Text("Example 1 (Cycle)", style: TextStyle(fontSize: Responsive.sp(context, 12))),
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
                          label: Text("Example 2 (No Cycle)", style: TextStyle(fontSize: Responsive.sp(context, 12))),
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
                    child: LinkedListDiagram(
                      nodes: _simExample == 0 ? _example1Nodes : _example2Nodes,
                      cycleTargetIdx: _simExample == 0 ? _example1CyclePos : null,
                      slowIdx: slowIdx,
                      fastIdx: fastIdx,
                      showPointers: true,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Step description card
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: _animStep == 3
                          ? (_simExample == 0 ? AppTheme.accentGreen.withOpacity(0.15) : AppTheme.accentPink.withOpacity(0.15))
                          : AppTheme.primaryDark,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _animStep == 3
                            ? (_simExample == 0 ? AppTheme.accentGreen : AppTheme.accentPink)
                            : const Color(0xFF334155),
                      ),
                    ),
                    child: Text(
                      widget.isEnglish ? stepTextEn : stepTextBn,
                      style: TextStyle(
                        color: _animStep == 3
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        onPressed: _animStep < 3 ? () => setState(() => _animStep++) : null,
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
    required bool isCycle,
    required List<int> nodes,
    required int? cycleTargetIdx,
    required String explanationEn,
    required String explanationBn,
  }) {
    final statusColor = isCycle ? AppTheme.accentGreen : AppTheme.accentPink;

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
            child: LinkedListDiagram(
              nodes: nodes,
              cycleTargetIdx: cycleTargetIdx,
              showPointers: false,
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

// Custom Widget for rendering Linked List nodes, horizontal next arrows,
// head pointer badge, pointers, and cycle loop-back curve.
class LinkedListDiagram extends StatelessWidget {
  final List<int> nodes;
  final int? cycleTargetIdx; // Index where tail points to, null if no cycle
  final int? slowIdx;
  final int? fastIdx;
  final bool showPointers;

  const LinkedListDiagram({
    super.key,
    required this.nodes,
    this.cycleTargetIdx,
    this.slowIdx,
    this.fastIdx,
    this.showPointers = false,
  });

  @override
  Widget build(BuildContext context) {
    const double nodeW = 52.0;
    const double nodeGap = 34.0;
    const double topSpace = 40.0;
    const double nodeH = 52.0;
    const double bottomSpace = 44.0;

    final bool hasCycle = cycleTargetIdx != null;
    final int extraBoxCount = hasCycle ? 0 : 1; // Extra 'null' box if no cycle
    final double totalW = (nodes.length + extraBoxCount) * (nodeW + nodeGap) + 20.0;
    final double totalH = topSpace + nodeH + (hasCycle ? bottomSpace : 24.0);

    return SizedBox(
      width: math.max(totalW, 440.0),
      height: totalH,
      child: Stack(
        children: [
          // Arrows & Cycle Loop Lines using CustomPainter
          Positioned.fill(
            child: CustomPaint(
              painter: LinkedListPainter(
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

            Color boxBg = AppTheme.primaryDark;
            Color borderColor = const Color(0xFF334155);

            if (isMeet) {
              boxBg = AppTheme.accentGreen.withOpacity(0.35);
              borderColor = AppTheme.accentGreen;
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
                          if (isMeet)
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
                            fontSize: Responsive.sp(context, 18),
                            fontWeight: FontWeight.bold,
                            color: isMeet ? AppTheme.accentGreen : Colors.white,
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
                  Text("head", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 10)),
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
                          color: AppTheme.accentGreen,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text("🐢🐇 Meet!", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 10)),
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
            if (fastIdx != null && fastIdx != slowIdx) ...[
              if (fastIdx! >= 0 && fastIdx! < nodes.length)
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
                )
              else if (fastIdx == -1) // Fast reached null
                Positioned(
                  left: 16.0 + nodes.length * (nodeW + nodeGap),
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

          // Render 'null' box if no cycle
          if (!hasCycle)
            Positioned(
              left: 16.0 + nodes.length * (nodeW + nodeGap),
              top: topSpace + 10.0,
              child: Container(
                width: 48,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.redAccent.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.redAccent.withOpacity(0.5)),
                ),
                child: const Center(
                  child: Text(
                    "null",
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// Custom Painter for drawing horizontal next arrows and cycle loop-back curved line
class LinkedListPainter extends CustomPainter {
  final int nodeCount;
  final double nodeWidth;
  final double nodeGap;
  final double topSpace;
  final double nodeHeight;
  final int? cycleTargetIdx;

  LinkedListPainter({
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
    int totalNextArrows = cycleTargetIdx != null ? nodeCount - 1 : nodeCount;
    for (int i = 0; i < totalNextArrows; i++) {
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

    // Draw Cycle Loop-back curved arrow for Example 1
    if (cycleTargetIdx != null) {
      final cyclePaint = Paint()
        ..color = AppTheme.accentNeonCyan
        ..strokeWidth = 3.0
        ..style = PaintingStyle.stroke;

      final cycleFill = Paint()
        ..color = AppTheme.accentNeonCyan
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
  bool shouldRepaint(covariant LinkedListPainter oldDelegate) {
    return oldDelegate.nodeCount != nodeCount || oldDelegate.cycleTargetIdx != cycleTargetIdx;
  }
}

