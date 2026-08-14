import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class RemoveDuplicatesCodeFreeGuideTab extends StatefulWidget {
  final bool isEnglish;

  const RemoveDuplicatesCodeFreeGuideTab({
    super.key,
    required this.isEnglish,
  });

  @override
  State<RemoveDuplicatesCodeFreeGuideTab> createState() => _RemoveDuplicatesCodeFreeGuideTabState();
}

class _RemoveDuplicatesCodeFreeGuideTabState extends State<RemoveDuplicatesCodeFreeGuideTab> {
  // 0: Example 1 ([1, 1, 2]), 1: Example 2 ([1, 1, 2, 3, 3])
  int _simExample = 0;

  int _animStep = 0;
  bool _isPlaying = false;
  Timer? _animTimer;

  // Datasets for examples
  final List<int> _example1Nodes = [1, 1, 2];
  final List<int> _example2Nodes = [1, 1, 2, 3, 3];

  @override
  void dispose() {
    _animTimer?.cancel();
    super.dispose();
  }

  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;
    });

    int maxSteps = _simExample == 0 ? 3 : 5;
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

    // Compute pointer states and current list state for step visualizer
    List<int> currentNodes = [];
    int currIdx = 0;
    int? bypassedIdx;
    String stepTextEn = "";
    String stepTextBn = "";
    bool isFinished = false;

    if (_simExample == 0) {
      // Example 1: [1, 1, 2]
      if (_animStep == 0) {
        currentNodes = [1, 1, 2];
        currIdx = 0;
        bypassedIdx = null;
        stepTextEn = "Start: curr pointer at Node 0 [val: 1]. Next node is also 1 (Duplicate! 1 == 1).";
        stepTextBn = "শুরু: curr পয়েন্টার নোড ০ [মান: ১] এ। পরের নোডও ১ (ডুপ্লিকেট! 1 == 1)।";
      } else if (_animStep == 1) {
        currentNodes = [1, 2];
        currIdx = 0;
        bypassedIdx = 1;
        stepTextEn = "Bypass Duplicate: curr.next = curr.next.next → Skipped duplicate Node [1]! List becomes [1, 2].";
        stepTextBn = "ডুপ্লিকেট বাইপাস: curr.next = curr.next.next → ডুপ্লিকেট নোড ১ বাদ দেওয়া হলো! লিস্ট হলো [১, ২]।";
      } else if (_animStep == 2) {
        currentNodes = [1, 2];
        currIdx = 1;
        bypassedIdx = null;
        stepTextEn = "Advance Pointer: 1 != 2 → Move curr forward to Node [val: 2]. curr.next is null!";
        stepTextBn = "পয়েন্টার অগ্রসর: 1 != 2 → curr ১ ধাপ এগিয়ে নোড [২] এ আসল। curr.next null!";
      } else {
        currentNodes = [1, 2];
        currIdx = 1;
        bypassedIdx = null;
        isFinished = true;
        stepTextEn = "🎉 FINISHED! Duplicates removed. Output: [1, 2].";
        stepTextBn = "🎉 শেষ! সকল ডুপ্লিকেট বাদ দেওয়া হয়েছে। আউটপুট: [১, ২]।";
      }
    } else {
      // Example 2: [1, 1, 2, 3, 3]
      if (_animStep == 0) {
        currentNodes = [1, 1, 2, 3, 3];
        currIdx = 0;
        bypassedIdx = null;
        stepTextEn = "Start: curr pointer at Node 0 [val: 1]. Next node is also 1 (Duplicate!).";
        stepTextBn = "শুরু: curr পয়েন্টার নোড ০ [মান: ১] এ। পরের নোডও ১ (ডুপ্লিকেট!)।";
      } else if (_animStep == 1) {
        currentNodes = [1, 2, 3, 3];
        currIdx = 0;
        bypassedIdx = 1;
        stepTextEn = "Bypass First Duplicate: Skipped duplicate 1 node! List becomes [1, 2, 3, 3].";
        stepTextBn = "প্রথম ডুপ্লিকেট বাইপাস: ২য় ১ নোড স্কিপ করা হলো! লিস্ট হলো [১, ২, ৩, ৩]।";
      } else if (_animStep == 2) {
        currentNodes = [1, 2, 3, 3];
        currIdx = 1;
        bypassedIdx = null;
        stepTextEn = "Advance Pointer: 1 != 2 → Move curr to Node [val: 2]. Next is 3 (2 != 3).";
        stepTextBn = "পয়েন্টার অগ্রসর: 1 != 2 → curr নোড [২] এ আসল। পরেরটি ৩ (2 != 3)।";
      } else if (_animStep == 3) {
        currentNodes = [1, 2, 3, 3];
        currIdx = 2;
        bypassedIdx = null;
        stepTextEn = "Advance Pointer: 2 != 3 → Move curr to Node [val: 3]. Next node is 3 (Duplicate!).";
        stepTextBn = "পয়েন্টার অগ্রসর: 2 != 3 → curr নোড [৩] এ আসল। পরের নোডও ৩ (ডুপ্লিকেট!)।";
      } else if (_animStep == 4) {
        currentNodes = [1, 2, 3];
        currIdx = 2;
        bypassedIdx = 3;
        stepTextEn = "Bypass Second Duplicate: curr.next = curr.next.next → Skipped duplicate 3 node!";
        stepTextBn = "দ্বিতীয় ডুপ্লিকেট বাইপাস: ২য় ৩ নোড স্কিপ করা হলো! লিস্ট দাঁড়ালো [১, ২, ৩]।";
      } else {
        currentNodes = [1, 2, 3];
        currIdx = 2;
        bypassedIdx = null;
        isFinished = true;
        stepTextEn = "🎉 FINISHED! All duplicates removed cleanly. Output: [1, 2, 3].";
        stepTextBn = "🎉 শেষ! সকল ডুপ্লিকেট সফলভাবে রিমুভ করা হয়েছে। আউটপুট: [১, ২, ৩]।";
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
                  widget.isEnglish ? "Remove Duplicates Concept Guide" : "রিমুভ ডুপ্লিকেটস কনসেপ্ট গাইড",
                  style: TextStyle(
                    fontSize: Responsive.sp(context, 18),
                    fontWeight: FontWeight.bold,
                    color: AppTheme.accentNeonCyan,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.isEnglish
                      ? "Examples: Remove duplicate elements from a sorted linked list in O(N) time and O(1) space. If curr.val == curr.next.val, change pointer: curr.next = curr.next.next!"
                      : "উদাহরণসমূহ: সর্টেড লিঙ্কড লিস্ট থেকে ডুপ্লিকেট নোড রিমুভ করুন। curr.val == curr.next.val হলে সরাসরি পরবর্তী নোড বাইপাস করুন (curr.next = curr.next.next)!",
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

            // EXAMPLE 1 CARD
            _buildExampleDiagramCard(
              context: context,
              title: "Example 1: Single Duplicate Pair",
              titleBn: "উদাহরণ ১: একটি ডুপ্লিকেট জোড়া",
              inputDesc: "head = [1, 1, 2]",
              inputDescBn: "head = [1, 1, 2]",
              outputResult: "[1, 2]",
              nodes: [1, 1, 2],
              bypassFromIdx: 0,
              bypassToIdx: 2,
              explanationEn: "Output: [1, 2] — Node 1's next pointer is updated to skip duplicate node 1 and link directly to node 2.",
              explanationBn: "আউটপুট: [1, 2] — ১ম নোড ১ এর পয়েন্টার ২য় নোড ১ কে স্কিপ করে সরাসরি নোড ২ এ যুক্ত হয়েছে।",
            ),
            const SizedBox(height: 20),

            // EXAMPLE 2 CARD
            _buildExampleDiagramCard(
              context: context,
              title: "Example 2: Multiple Duplicate Pairs",
              titleBn: "উদাহরণ ২: একাধিক ডুপ্লিকেট জোড়া",
              inputDesc: "head = [1, 1, 2, 3, 3]",
              inputDescBn: "head = [1, 1, 2, 3, 3]",
              outputResult: "[1, 2, 3]",
              nodes: [1, 1, 2, 3, 3],
              bypassFromIdx: 0,
              bypassToIdx: 2,
              explanationEn: "Output: [1, 2, 3] — Both duplicate node 1 and duplicate node 3 are bypassed cleanly.",
              explanationBn: "আউটপুট: [1, 2, 3] — উভয় ডুপ্লিকেট নোড ১ এবং ডুপ্লিকেট নোড ৩ সফলভাবে বাইপাস করা হয়েছে।",
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
                    "Step ${_animStep + 1} / ${_simExample == 0 ? 4 : 6}",
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
                          label: Text("Example 1 ([1, 1, 2])", style: TextStyle(fontSize: Responsive.sp(context, 12))),
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
                          label: Text("Example 2 ([1, 1, 2, 3, 3])", style: TextStyle(fontSize: Responsive.sp(context, 12))),
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

                  // Visualizer Diagram Widget with Pointer
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: RemoveDuplicatesLinkedListDiagram(
                      nodes: currentNodes,
                      currIdx: currIdx,
                      bypassedIdx: bypassedIdx,
                      showPointer: true,
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
                        onPressed: _animStep < (_simExample == 0 ? 3 : 5)
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
    required List<int> nodes,
    required int bypassFromIdx,
    required int bypassToIdx,
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
            child: RemoveDuplicatesLinkedListDiagram(
              nodes: nodes,
              currIdx: null,
              showPointer: false,
              highlightBypassFromIdx: bypassFromIdx,
              highlightBypassToIdx: bypassToIdx,
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
// head pointer badge, curr pointer, overhead bypass curves, and null box.
class RemoveDuplicatesLinkedListDiagram extends StatelessWidget {
  final List<int> nodes;
  final int? currIdx;
  final int? bypassedIdx;
  final bool showPointer;
  final bool isFinished;
  final int? highlightBypassFromIdx;
  final int? highlightBypassToIdx;

  const RemoveDuplicatesLinkedListDiagram({
    super.key,
    required this.nodes,
    this.currIdx,
    this.bypassedIdx,
    this.showPointer = false,
    this.isFinished = false,
    this.highlightBypassFromIdx,
    this.highlightBypassToIdx,
  });

  @override
  Widget build(BuildContext context) {
    const double nodeW = 52.0;
    const double nodeGap = 34.0;
    const double topSpace = 40.0;
    const double nodeH = 52.0;

    final double totalW = (nodes.length + 1) * (nodeW + nodeGap) + 20.0;
    final double totalH = topSpace + nodeH + 34.0;

    return SizedBox(
      width: math.max(totalW, 440.0),
      height: totalH,
      child: Stack(
        children: [
          // Arrows & Bypass Curved Line using CustomPainter
          Positioned.fill(
            child: CustomPaint(
              painter: RemoveDuplicatesPainter(
                nodeCount: nodes.length,
                nodeWidth: nodeW,
                nodeGap: nodeGap,
                topSpace: topSpace,
                nodeHeight: nodeH,
                bypassFromIdx: highlightBypassFromIdx ?? (bypassedIdx != null ? currIdx : null),
                bypassToIdx: highlightBypassToIdx ?? (bypassedIdx != null ? bypassedIdx! + 1 : null),
              ),
            ),
          ),

          // Nodes Rendering
          ...List.generate(nodes.length, (idx) {
            final double leftPos = 16.0 + idx * (nodeW + nodeGap);
            final int val = nodes[idx];

            final bool isCurr = showPointer && currIdx == idx;
            final bool isBypassed = bypassedIdx == idx;

            Color boxBg = AppTheme.primaryDark;
            Color borderColor = const Color(0xFF334155);

            if (isFinished) {
              boxBg = AppTheme.accentGreen.withOpacity(0.35);
              borderColor = AppTheme.accentGreen;
            } else if (isBypassed) {
              boxBg = AppTheme.accentPink.withOpacity(0.25);
              borderColor = AppTheme.accentPink;
            } else if (isCurr) {
              boxBg = AppTheme.accentNeonCyan.withOpacity(0.25);
              borderColor = AppTheme.accentNeonCyan;
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
                          if (isFinished)
                            BoxShadow(color: AppTheme.accentGreen.withOpacity(0.4), blurRadius: 10)
                          else if (isCurr)
                            BoxShadow(color: AppTheme.accentNeonCyan.withOpacity(0.3), blurRadius: 8)
                        ],
                      ),
                      child: Center(
                        child: Text(
                          '$val',
                          style: TextStyle(
                            fontSize: Responsive.sp(context, 18),
                            fontWeight: FontWeight.bold,
                            color: isFinished
                                ? AppTheme.accentGreen
                                : (isBypassed ? AppTheme.accentPink : Colors.white),
                            decoration: isBypassed ? TextDecoration.lineThrough : null,
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

          // Curr Pointer Indicator during simulation
          if (showPointer && currIdx != null && currIdx! < nodes.length)
            Positioned(
              left: 16.0 + currIdx! * (nodeW + nodeGap),
              top: topSpace + nodeH + 4.0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isFinished ? AppTheme.accentGreen : AppTheme.accentNeonCyan,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isFinished ? "done 🎉" : "curr 📍",
                      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 10),
                    ),
                  ],
                ),
              ),
            ),

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

// Custom Painter for drawing horizontal next arrows and overhead bypass curve line
class RemoveDuplicatesPainter extends CustomPainter {
  final int nodeCount;
  final double nodeWidth;
  final double nodeGap;
  final double topSpace;
  final double nodeHeight;
  final int? bypassFromIdx;
  final int? bypassToIdx;

  RemoveDuplicatesPainter({
    required this.nodeCount,
    required this.nodeWidth,
    required this.nodeGap,
    required this.topSpace,
    required this.nodeHeight,
    this.bypassFromIdx,
    this.bypassToIdx,
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

    // Draw Overhead Bypass Curved Arrow if duplicate is being bypassed
    if (bypassFromIdx != null && bypassToIdx != null && bypassToIdx! <= nodeCount) {
      final bypassPaint = Paint()
        ..color = AppTheme.accentNeonCyan
        ..strokeWidth = 3.0
        ..style = PaintingStyle.stroke;

      final bypassFill = Paint()
        ..color = AppTheme.accentNeonCyan
        ..style = PaintingStyle.fill;

      double xStart = 16.0 + bypassFromIdx! * (nodeWidth + nodeGap) + nodeWidth / 2;
      double xEnd = 16.0 + bypassToIdx! * (nodeWidth + nodeGap) + nodeWidth / 2;

      double yTopStart = topSpace;
      double yCurveTop = yTopStart - 24.0;

      Path bypassPath = Path();
      bypassPath.moveTo(xStart, yTopStart);
      bypassPath.lineTo(xStart, yCurveTop + 6);
      bypassPath.quadraticBezierTo(xStart, yCurveTop, xStart + 6, yCurveTop);
      bypassPath.lineTo(xEnd - 6, yCurveTop);
      bypassPath.quadraticBezierTo(xEnd, yCurveTop, xEnd, yCurveTop + 6);
      bypassPath.lineTo(xEnd, yTopStart - 4);

      canvas.drawPath(bypassPath, bypassPaint);

      // Arrowhead pointing DOWN into destination node top
      Path downArrow = Path();
      downArrow.moveTo(xEnd, yTopStart - 2);
      downArrow.lineTo(xEnd - 5, yTopStart - 10);
      downArrow.lineTo(xEnd + 5, yTopStart - 10);
      downArrow.close();
      canvas.drawPath(downArrow, bypassFill);
    }
  }

  @override
  bool shouldRepaint(covariant RemoveDuplicatesPainter oldDelegate) {
    return oldDelegate.nodeCount != nodeCount ||
        oldDelegate.bypassFromIdx != bypassFromIdx ||
        oldDelegate.bypassToIdx != bypassToIdx;
  }
}

