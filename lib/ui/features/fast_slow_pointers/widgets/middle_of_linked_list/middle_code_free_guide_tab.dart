import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class MiddleCodeFreeGuideTab extends StatefulWidget {
  final bool isEnglish;

  const MiddleCodeFreeGuideTab({
    super.key,
    required this.isEnglish,
  });

  @override
  State<MiddleCodeFreeGuideTab> createState() => _MiddleCodeFreeGuideTabState();
}

class _MiddleCodeFreeGuideTabState extends State<MiddleCodeFreeGuideTab> {
  // 0: Example 1 (Odd: [1, 2, 3, 4, 5]), 1: Example 2 (Even: [1, 2, 3, 4, 5, 6])
  int _simExample = 0;

  int _animStep = 0;
  bool _isPlaying = false;
  Timer? _animTimer;

  // Example datasets (HelloInterview / LeetCode #876)
  final List<int> _example1Nodes = [1, 2, 3, 4, 5];
  final int _example1MiddleIdx = 2; // Node val 3

  final List<int> _example2Nodes = [1, 2, 3, 4, 5, 6];
  final int _example2MiddleIdx = 3; // Node val 4

  @override
  void dispose() {
    _animTimer?.cancel();
    super.dispose();
  }

  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;
    });

    int maxSteps = _simExample == 0 ? 3 : 4;
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

    // Compute pointer positions and step text
    int slowIdx = 0;
    int fastIdx = 0;
    String stepTextEn = "";
    String stepTextBn = "";
    bool isFinished = false;

    if (_simExample == 0) {
      // Example 1: Odd length [1, 2, 3, 4, 5]
      if (_animStep == 0) {
        slowIdx = 0;
        fastIdx = 0;
        stepTextEn = "Start: Both Slow (🐢) and Fast (🐇) start at Head (Node index 0 [val: 1]).";
        stepTextBn = "শুরু: Slow (🐢) এবং Fast (🐇) দুজনই হেডে (ইনডেক্স ০, মান ১) অবস্থান করছে।";
      } else if (_animStep == 1) {
        slowIdx = 1;
        fastIdx = 2;
        stepTextEn = "Step 1: Slow moves 1 step → Node [2]. Fast moves 2 steps → Node [3].";
        stepTextBn = "ধাপ ১: Slow ১ ধাপ হেঁটে নোড [2] এ। Fast ২ ধাপ হেঁটে নোড [3] এ।";
      } else if (_animStep == 2) {
        slowIdx = 2;
        fastIdx = 4;
        stepTextEn = "Step 2: Slow moves 1 step → Node [3]. Fast moves 2 steps → Tail Node [5].";
        stepTextBn = "ধাপ ২: Slow ১ ধাপ হেঁটে নোড [3] এ। Fast ২ ধাপ হেঁটে টেল নোড [5] এ।";
      } else {
        slowIdx = 2;
        fastIdx = 4;
        isFinished = true;
        stepTextEn = "🎉 FINISHED! Fast reached the last node [5] (Fast.next is null). Slow points EXACTLY to Middle Node [3]! Output: [3, 4, 5].";
        stepTextBn = "🎉 শেষ! Fast শেষ নোডে [5] পৌঁছেছে। Slow সরাসরি মাঝের নোড [3] এ থামল! আউটপুট: [3, 4, 5]।";
      }
    } else {
      // Example 2: Even length [1, 2, 3, 4, 5, 6]
      if (_animStep == 0) {
        slowIdx = 0;
        fastIdx = 0;
        stepTextEn = "Start: Both Slow (🐢) and Fast (🐇) start at Head (Node index 0 [val: 1]).";
        stepTextBn = "শুরু: Slow (🐢) এবং Fast (🐇) দুজনই হেডে (ইনডেক্স ০, মান ১) অবস্থান করছে।";
      } else if (_animStep == 1) {
        slowIdx = 1;
        fastIdx = 2;
        stepTextEn = "Step 1: Slow moves 1 step → Node [2]. Fast moves 2 steps → Node [3].";
        stepTextBn = "ধাপ ১: Slow ১ ধাপ হেঁটে নোড [2] এ। Fast ২ ধাপ হেঁটে নোড [3] এ।";
      } else if (_animStep == 2) {
        slowIdx = 2;
        fastIdx = 4;
        stepTextEn = "Step 2: Slow moves 1 step → Node [3]. Fast moves 2 steps → Node [5].";
        stepTextBn = "ধাপ ২: Slow ১ ধাপ হেঁটে নোড [3] এ। Fast ২ ধাপ হেঁটে নোড [5] এ।";
      } else if (_animStep == 3) {
        slowIdx = 3;
        fastIdx = 6; // Fast reaches null
        stepTextEn = "Step 3: Slow moves 1 step → Node [4]. Fast moves 2 steps → reaches null.";
        stepTextBn = "ধাপ ৩: Slow ১ ধাপ হেঁটে নোড [4] এ। Fast ২ ধাপ হেঁটে null এ পৌঁছেছে।";
      } else {
        slowIdx = 3;
        fastIdx = 6;
        isFinished = true;
        stepTextEn = "🎉 FINISHED! Fast reached null. Since list length is even, Slow points to the SECOND Middle Node [4]! Output: [4, 5, 6].";
        stepTextBn = "🎉 শেষ! Fast null এ পৌছেছে। লিস্ট জোড় হওয়ায় Slow অবস্থান করছে ২য় মাঝের নোড [4] এ! আউটপুট: [4, 5, 6]।";
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
                  widget.isEnglish ? "Middle of Linked List Concept Guide" : "মিডল অফ দ্য লিঙ্কড লিস্ট কনসেপ্ট গাইড",
                  style: TextStyle(
                    fontSize: Responsive.sp(context, 18),
                    fontWeight: FontWeight.bold,
                    color: AppTheme.accentNeonCyan,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.isEnglish
                      ? "Find the middle node of a linked list using Fast (🐇 2 steps) and Slow (🐢 1 step) pointers. When Fast reaches the end, Slow is guaranteed to be at the Middle!"
                      : "Fast (🐇 ২ ধাপ) এবং Slow (🐢 ১ ধাপ) পয়েন্টার দিয়ে লিঙ্কড লিস্টের মাঝের নোড চিহ্নিত করুন। Fast প্রান্তে পৌঁছালে Slow ঠিক মাঝখানে অবস্থান করে!",
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

            // EXAMPLE 1 CARD (Odd Length)
            _buildExampleDiagramCard(
              context: context,
              title: "Example 1: Odd Length Linked List",
              titleBn: "উদাহরণ ১: বিজোড় দৈর্ঘ্যের লিঙ্কড লিস্ট",
              inputDesc: "head = [1, 2, 3, 4, 5]",
              inputDescBn: "head = [1, 2, 3, 4, 5]",
              outputResult: "[3, 4, 5]",
              middleVal: 3,
              middleIdx: _example1MiddleIdx,
              nodes: _example1Nodes,
              explanationEn: "Output: [3, 4, 5] — The middle node of the list is node 3 with value 3.",
              explanationBn: "আউটপুট: [3, 4, 5] — লিঙ্কড লিস্টের একমাত্র মাঝের নোডটি হলো মান 3 এর নোড।",
            ),
            const SizedBox(height: 20),

            // EXAMPLE 2 CARD (Even Length)
            _buildExampleDiagramCard(
              context: context,
              title: "Example 2: Even Length Linked List",
              titleBn: "উদাহরণ ২: জোড় দৈর্ঘ্যের লিঙ্কড লিস্ট",
              inputDesc: "head = [1, 2, 3, 4, 5, 6]",
              inputDescBn: "head = [1, 2, 3, 4, 5, 6]",
              outputResult: "[4, 5, 6]",
              middleVal: 4,
              middleIdx: _example2MiddleIdx,
              nodes: _example2Nodes,
              explanationEn: "Output: [4, 5, 6] — Since the list has two middle nodes (values 3 and 4), we return the second middle node with value 4.",
              explanationBn: "আউটপুট: [4, 5, 6] — জোড় দৈর্ঘ্যে দুটি মাঝের নোড (3 এবং 4) থাকায় নিয়ম অনুযায়ী ২য় মাঝের নোড 4 রিটার্ন করা হয়।",
            ),
            const SizedBox(height: 28),

            // INTERACTIVE SIMULATION SECTION
            Container(
              padding: EdgeInsets.all(Responsive.sp(context, 18)),
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isFinished ? AppTheme.accentGreen : const Color(0xFF334155),
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
                    "Step ${_animStep + 1} / ${_simExample == 0 ? 4 : 5}",
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
                          label: Text("Example 1 (Odd: 5 Nodes)", style: TextStyle(fontSize: Responsive.sp(context, 12))),
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
                          label: Text("Example 2 (Even: 6 Nodes)", style: TextStyle(fontSize: Responsive.sp(context, 12))),
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
                    child: MiddleLinkedListDiagram(
                      nodes: _simExample == 0 ? _example1Nodes : _example2Nodes,
                      middleIdx: _simExample == 0 ? _example1MiddleIdx : _example2MiddleIdx,
                      slowIdx: slowIdx,
                      fastIdx: fastIdx,
                      showPointers: true,
                      isFinished: isFinished,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Step description card
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isFinished ? AppTheme.accentGreen.withOpacity(0.15) : AppTheme.primaryDark,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isFinished ? AppTheme.accentGreen : const Color(0xFF334155),
                      ),
                    ),
                    child: Text(
                      widget.isEnglish ? stepTextEn : stepTextBn,
                      style: TextStyle(
                        color: isFinished ? AppTheme.accentGreen : Colors.white,
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
                        onPressed: _animStep < (_simExample == 0 ? 3 : 4)
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
    required int middleVal,
    required int middleIdx,
    required List<int> nodes,
    required String explanationEn,
    required String explanationBn,
  }) {
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
              color: AppTheme.accentGreen,
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
            child: MiddleLinkedListDiagram(
              nodes: nodes,
              middleIdx: middleIdx,
              showPointers: false,
              highlightMiddle: true,
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
// head pointer badge, pointers, and middle node highlight.
class MiddleLinkedListDiagram extends StatelessWidget {
  final List<int> nodes;
  final int middleIdx;
  final int? slowIdx;
  final int? fastIdx;
  final bool showPointers;
  final bool isFinished;
  final bool highlightMiddle;

  const MiddleLinkedListDiagram({
    super.key,
    required this.nodes,
    required this.middleIdx,
    this.slowIdx,
    this.fastIdx,
    this.showPointers = false,
    this.isFinished = false,
    this.highlightMiddle = false,
  });

  @override
  Widget build(BuildContext context) {
    const double nodeW = 52.0;
    const double nodeGap = 34.0;
    const double topSpace = 40.0;
    const double nodeH = 52.0;

    final double totalW = (nodes.length + 1) * (nodeW + nodeGap) + 20.0;
    final double totalH = topSpace + nodeH + 28.0;

    return SizedBox(
      width: math.max(totalW, 440.0),
      height: totalH,
      child: Stack(
        children: [
          // Next Arrows using CustomPainter
          Positioned.fill(
            child: CustomPaint(
              painter: MiddleLinkedListPainter(
                nodeCount: nodes.length,
                nodeWidth: nodeW,
                nodeGap: nodeGap,
                topSpace: topSpace,
                nodeHeight: nodeH,
              ),
            ),
          ),

          // Nodes Rendering
          ...List.generate(nodes.length, (idx) {
            final double leftPos = 16.0 + idx * (nodeW + nodeGap);
            final int val = nodes[idx];

            final bool isSlow = showPointers && slowIdx == idx;
            final bool isFast = showPointers && fastIdx == idx;
            final bool isMiddle = (highlightMiddle && idx == middleIdx) || (isFinished && idx == middleIdx);

            Color boxBg = AppTheme.primaryDark;
            Color borderColor = const Color(0xFF334155);

            if (isMiddle) {
              boxBg = AppTheme.accentGreen.withOpacity(0.35);
              borderColor = AppTheme.accentGreen;
            } else if (isSlow && isFast) {
              boxBg = AppTheme.accentAmber.withOpacity(0.35);
              borderColor = AppTheme.accentAmber;
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
                          if (isMiddle)
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
                            color: isMiddle ? AppTheme.accentGreen : Colors.white,
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

          // Highlight Middle Badge in static example card
          if (highlightMiddle)
            Positioned(
              left: 16.0 + middleIdx * (nodeW + nodeGap) - 4,
              top: topSpace + nodeH + 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.accentGreen,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text("Middle Node", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 9)),
              ),
            ),

          // Pointers (Slow / Fast) Top Indicators during simulation
          if (showPointers) ...[
            if (slowIdx != null && slowIdx! >= 0 && slowIdx! < nodes.length)
              Positioned(
                left: 16.0 + slowIdx! * (nodeW + nodeGap) - (slowIdx == fastIdx ? 8 : 0),
                top: 6.0,
                child: isFinished && slowIdx == middleIdx
                    ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.accentGreen,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text("🐢 Middle!", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 10)),
                      )
                    : (slowIdx == fastIdx
                        ? Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.accentAmber,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text("🐢🐇 Start", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 10)),
                          )
                        : Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.accentNeonCyan,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text("🐢 Slow", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 10)),
                          )),
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
              else if (fastIdx! >= nodes.length) // Fast reached null
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

          // Render 'null' box at end of list
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

// Custom Painter for drawing horizontal next arrows
class MiddleLinkedListPainter extends CustomPainter {
  final int nodeCount;
  final double nodeWidth;
  final double nodeGap;
  final double topSpace;
  final double nodeHeight;

  MiddleLinkedListPainter({
    required this.nodeCount,
    required this.nodeWidth,
    required this.nodeGap,
    required this.topSpace,
    required this.nodeHeight,
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

    // Draw horizontal arrows between node i and node i+1 (including null)
    for (int i = 0; i < nodeCount; i++) {
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
  }

  @override
  bool shouldRepaint(covariant MiddleLinkedListPainter oldDelegate) {
    return oldDelegate.nodeCount != nodeCount;
  }
}

