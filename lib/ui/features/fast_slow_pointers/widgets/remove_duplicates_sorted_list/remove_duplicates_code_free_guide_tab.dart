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
      _animTimer = Timer.periodic(const Duration(milliseconds: 1900), (timer) {
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

    // Compute pointer states, skipped nodes, and step text
    List<int> simNodes = _simExample == 0 ? _example1Nodes : _example2Nodes;
    int currIdx = 0;
    List<int> skippedIndices = [];
    int? bypassFromIdx;
    int? bypassToIdx;
    String compareBadgeText = "";
    Color compareBadgeColor = Colors.white;
    String stepTextEn = "";
    String stepTextBn = "";
    bool isFinished = false;

    if (_simExample == 0) {
      // Example 1: [1, 1, 2]
      if (_animStep == 0) {
        currIdx = 0;
        skippedIndices = [];
        bypassFromIdx = null;
        bypassToIdx = null;
        compareBadgeText = "1 == 1 ➔ Duplicate Detected! ✂️";
        compareBadgeColor = AppTheme.accentPink;
        stepTextEn = "Start: curr pointer at Node 0 [val: 1]. Next node is also 1 (Duplicate!).";
        stepTextBn = "শুরু: curr পয়েন্টার নোড ০ [মান: ১] এ। পরের নোডও ১ (ডুপ্লিকেট!)।";
      } else if (_animStep == 1) {
        currIdx = 0;
        skippedIndices = [1];
        bypassFromIdx = 0;
        bypassToIdx = 2;
        compareBadgeText = "curr.next = curr.next.next ➔ Node [1] ❌ SKIPPED";
        compareBadgeColor = AppTheme.accentNeonCyan;
        stepTextEn = "Bypass Duplicate: Set curr.next directly to Node 2 [val: 2]. Node 1 is ❌ SKIPPED!";
        stepTextBn = "ডুপ্লিকেট বাইপাস: curr.next সরাসরি নোড ২ [মান: ২] এ যুক্ত করা হলো। নোড ১ ❌ স্কিপ করা হয়েছে!";
      } else if (_animStep == 2) {
        currIdx = 2; // move curr to node 2
        skippedIndices = [1];
        bypassFromIdx = null;
        bypassToIdx = null;
        compareBadgeText = "1 != 2 ➔ Unique! Advance curr 📍";
        compareBadgeColor = AppTheme.accentPurple;
        stepTextEn = "Advance Pointer: Move curr to Node 2 [val: 2]. curr.next is null → End of list!";
        stepTextBn = "পয়েন্টার অগ্রসর: curr নোড ২ [মান: ২] এ এল। curr.next null → ট্রাভার্সাল শেষ!";
      } else {
        currIdx = 2;
        skippedIndices = [1];
        bypassFromIdx = null;
        bypassToIdx = null;
        isFinished = true;
        compareBadgeText = "🎉 Output: [1, 2]";
        compareBadgeColor = AppTheme.accentGreen;
        stepTextEn = "🎉 FINISHED! Duplicate node 1 removed. Clean result list: [1, 2].";
        stepTextBn = "🎉 শেষ! ডুপ্লিকেট নোড ১ রিমুভ করা হয়েছে। চূড়ান্ত লিঙ্কড লিস্ট: [১, ২]।";
      }
    } else {
      // Example 2: [1, 1, 2, 3, 3]
      if (_animStep == 0) {
        currIdx = 0;
        skippedIndices = [];
        bypassFromIdx = null;
        bypassToIdx = null;
        compareBadgeText = "1 == 1 ➔ Duplicate Detected! ✂️";
        compareBadgeColor = AppTheme.accentPink;
        stepTextEn = "Start: curr pointer at Node 0 [val: 1]. Next node is also 1 (Duplicate!).";
        stepTextBn = "শুরু: curr পয়েন্টার নোড ০ [মান: ১] এ। পরের নোডও ১ (ডুপ্লিকেট!)।";
      } else if (_animStep == 1) {
        currIdx = 0;
        skippedIndices = [1];
        bypassFromIdx = 0;
        bypassToIdx = 2;
        compareBadgeText = "curr.next = curr.next.next ➔ Node 1 ❌ SKIPPED";
        compareBadgeColor = AppTheme.accentNeonCyan;
        stepTextEn = "Bypass First Duplicate: Set curr.next to Node 2 [val: 2]. Node 1 is ❌ SKIPPED!";
        stepTextBn = "প্রথম ডুপ্লিকেট বাইপাস: curr.next নোড ২ [মান: ২] এ যুক্ত হলো। নোড ১ ❌ স্কিপড!";
      } else if (_animStep == 2) {
        currIdx = 2;
        skippedIndices = [1];
        bypassFromIdx = null;
        bypassToIdx = null;
        compareBadgeText = "1 != 2 ➔ Unique Node! Advance curr 📍";
        compareBadgeColor = AppTheme.accentPurple;
        stepTextEn = "Advance Pointer: Move curr to Node 2 [val: 2]. Next is Node 3 [val: 3] (2 != 3).";
        stepTextBn = "পয়েন্টার অগ্রসর: curr নোড ২ [মান: ২] এ এল। পরেরটি নোড ৩ (2 != 3)।";
      } else if (_animStep == 3) {
        currIdx = 3;
        skippedIndices = [1];
        bypassFromIdx = null;
        bypassToIdx = null;
        compareBadgeText = "3 == 3 ➔ Duplicate Detected! ✂️";
        compareBadgeColor = AppTheme.accentPink;
        stepTextEn = "Advance Pointer: Move curr to Node 3 [val: 3]. Next node is also 3 (Duplicate!).";
        stepTextBn = "পয়েন্টার অগ্রসর: curr নোড ৩ [মান: ৩] এ এল। পরের নোডও ৩ (ডুপ্লিকেট!)।";
      } else if (_animStep == 4) {
        currIdx = 3;
        skippedIndices = [1, 4];
        bypassFromIdx = 3;
        bypassToIdx = 5; // points to null (index 5)
        compareBadgeText = "curr.next = curr.next.next ➔ Node 4 ❌ SKIPPED";
        compareBadgeColor = AppTheme.accentNeonCyan;
        stepTextEn = "Bypass Second Duplicate: Set curr.next to null! Node 4 is ❌ SKIPPED!";
        stepTextBn = "দ্বিতীয় ডুপ্লিকেট বাইপাস: curr.next null এ সেট হলো! নোড ৪ ❌ স্কিপড!";
      } else {
        currIdx = 3;
        skippedIndices = [1, 4];
        bypassFromIdx = null;
        bypassToIdx = null;
        isFinished = true;
        compareBadgeText = "🎉 Output: [1, 2, 3]";
        compareBadgeColor = AppTheme.accentGreen;
        stepTextEn = "🎉 FINISHED! Both duplicate 1 and duplicate 3 removed. Clean result list: [1, 2, 3].";
        stepTextBn = "🎉 শেষ! উভয় ডুপ্লিকেট ১ এবং ৩ রিমুভ করা হয়েছে। চূড়ান্ত লিঙ্কড লিস্ট: [১, ২, ৩]।";
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
                      ? "Examples: Remove duplicate elements from a sorted linked list in O(N) time and O(1) space. If curr.val == curr.next.val, change pointer: curr.next = curr.next.next to skip the duplicate!"
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
              bypasses: [
                _BypassInfo(fromIdx: 0, toIdx: 2, label: "curr.next = 2"),
              ],
              skippedIndices: [1],
              explanationEn: "Output: [1, 2] — Node 1's next pointer is updated to skip duplicate node 1 (❌) and link directly to node 2.",
              explanationBn: "আউটপুট: [1, 2] — ১ম নোড ১ এর পয়েন্টার ২য় নোড ১ (❌) কে স্কিপ করে সরাসরি নোড ২ এ যুক্ত হয়েছে।",
            ),
            const SizedBox(height: 20),

            // EXAMPLE 2 CARD (Enhanced with clear skipped cross marks & pointer updates)
            _buildExampleDiagramCard(
              context: context,
              title: "Example 2: Multiple Duplicate Pairs",
              titleBn: "উদাহরণ ২: একাধিক ডুপ্লিকেট জোড়া",
              inputDesc: "head = [1, 1, 2, 3, 3]",
              inputDescBn: "head = [1, 1, 2, 3, 3]",
              outputResult: "[1, 2, 3]",
              nodes: [1, 1, 2, 3, 3],
              bypasses: [
                _BypassInfo(fromIdx: 0, toIdx: 2, label: "curr.next = 2"),
                _BypassInfo(fromIdx: 3, toIdx: 5, label: "curr.next = null"),
              ],
              skippedIndices: [1, 4],
              explanationEn: "Output: [1, 2, 3] — Both duplicate node 1 (index 1 ❌) and duplicate node 3 (index 4 ❌) are bypassed cleanly by setting next pointers directly to target nodes.",
              explanationBn: "আউটপুট: [1, 2, 3] — ১ম ডুপ্লিকেট নোড ১ (ইন্ডেক্স ১ ❌) এবং ২য় ডুপ্লিকেট নোড ৩ (ইন্ডেক্স ৪ ❌) সরাসরি পয়েন্টার আপডেট করে বাইপাস করা হয়েছে।",
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
                  const SizedBox(height: 16),

                  // Status / Comparison Chip Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: compareBadgeColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: compareBadgeColor),
                    ),
                    child: Text(
                      compareBadgeText,
                      style: TextStyle(
                        color: compareBadgeColor,
                        fontWeight: FontWeight.bold,
                        fontSize: Responsive.sp(context, 13),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Visualizer Diagram Widget with Pointer & Cross Marks
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: RemoveDuplicatesLinkedListDiagram(
                      nodes: simNodes,
                      currIdx: currIdx,
                      skippedIndices: skippedIndices,
                      showPointer: true,
                      isFinished: isFinished,
                      bypasses: (bypassFromIdx != null && bypassToIdx != null)
                          ? [_BypassInfo(fromIdx: bypassFromIdx!, toIdx: bypassToIdx!, label: "curr.next ➔")]
                          : [],
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
    required List<_BypassInfo> bypasses,
    required List<int> skippedIndices,
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
              skippedIndices: skippedIndices,
              showPointer: false,
              bypasses: bypasses,
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

class _BypassInfo {
  final int fromIdx;
  final int toIdx;
  final String label;

  _BypassInfo({
    required this.fromIdx,
    required this.toIdx,
    required this.label,
  });
}

// Custom Widget for rendering Linked List nodes, horizontal next arrows,
// head pointer badge, curr pointer, cross marks (❌) for skipped nodes, and null box.
class RemoveDuplicatesLinkedListDiagram extends StatelessWidget {
  final List<int> nodes;
  final int? currIdx;
  final List<int> skippedIndices;
  final bool showPointer;
  final bool isFinished;
  final List<_BypassInfo> bypasses;

  const RemoveDuplicatesLinkedListDiagram({
    super.key,
    required this.nodes,
    this.currIdx,
    this.skippedIndices = const [],
    this.showPointer = false,
    this.isFinished = false,
    this.bypasses = const [],
  });

  @override
  Widget build(BuildContext context) {
    const double nodeW = 54.0;
    const double nodeGap = 34.0;
    const double topSpace = 44.0;
    const double nodeH = 54.0;

    final double totalW = (nodes.length + 1) * (nodeW + nodeGap) + 20.0;
    final double totalH = topSpace + nodeH + 38.0;

    return SizedBox(
      width: math.max(totalW, 460.0),
      height: totalH,
      child: Stack(
        children: [
          // Arrows & Bypass Curved Lines using CustomPainter
          Positioned.fill(
            child: CustomPaint(
              painter: RemoveDuplicatesPainter(
                nodeCount: nodes.length,
                nodeWidth: nodeW,
                nodeGap: nodeGap,
                topSpace: topSpace,
                nodeHeight: nodeH,
                bypasses: bypasses,
                skippedIndices: skippedIndices,
              ),
            ),
          ),

          // Nodes Rendering
          ...List.generate(nodes.length, (idx) {
            final double leftPos = 16.0 + idx * (nodeW + nodeGap);
            final int val = nodes[idx];

            final bool isCurr = showPointer && currIdx == idx;
            final bool isSkipped = skippedIndices.contains(idx);

            Color boxBg = AppTheme.primaryDark;
            Color borderColor = const Color(0xFF334155);

            if (isSkipped) {
              boxBg = AppTheme.accentPink.withOpacity(0.15);
              borderColor = AppTheme.accentPink.withOpacity(0.6);
            } else if (isFinished) {
              boxBg = AppTheme.accentGreen.withOpacity(0.35);
              borderColor = AppTheme.accentGreen;
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
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: nodeW,
                          height: nodeH,
                          decoration: BoxDecoration(
                            color: boxBg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: borderColor, width: 2),
                            boxShadow: [
                              if (isFinished && !isSkipped)
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
                                color: isSkipped
                                    ? AppTheme.accentPink
                                    : (isFinished ? AppTheme.accentGreen : Colors.white),
                                decoration: isSkipped ? TextDecoration.lineThrough : null,
                              ),
                            ),
                          ),
                        ),

                        // Prominent Red Cross Overlay Badge if Skipped
                        if (isSkipped)
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.black87,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppTheme.accentPink, width: 1.5),
                            ),
                            child: const Icon(
                              Icons.close,
                              color: AppTheme.accentPink,
                              size: 20,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Label under node
                    if (isSkipped)
                      Text(
                        "❌ SKIPPED",
                        style: TextStyle(
                          fontSize: Responsive.sp(context, 9.5),
                          color: AppTheme.accentPink,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    else
                      Text(
                        "idx $idx",
                        style: TextStyle(
                          fontSize: Responsive.sp(context, 9.5),
                          color: AppTheme.textMuted,
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
            top: 10.0,
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
              top: topSpace + nodeH + 20.0,
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
              height: 34,
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

// Custom Painter for drawing horizontal next arrows and overhead bypass curves with target labels
class RemoveDuplicatesPainter extends CustomPainter {
  final int nodeCount;
  final double nodeWidth;
  final double nodeGap;
  final double topSpace;
  final double nodeHeight;
  final List<_BypassInfo> bypasses;
  final List<int> skippedIndices;

  RemoveDuplicatesPainter({
    required this.nodeCount,
    required this.nodeWidth,
    required this.nodeGap,
    required this.topSpace,
    required this.nodeHeight,
    required this.bypasses,
    required this.skippedIndices,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final normalArrowPaint = Paint()
      ..color = const Color(0xFF59B9B0)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final skippedArrowPaint = Paint()
      ..color = AppTheme.accentPink.withOpacity(0.5)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = const Color(0xFF227D70)
      ..style = PaintingStyle.fill;

    final double yCenter = topSpace + nodeHeight / 2;

    // Draw horizontal arrows between node i and node i+1 (including null)
    for (int i = 0; i < nodeCount; i++) {
      double x1 = 16.0 + i * (nodeWidth + nodeGap) + nodeWidth;
      double x2 = 16.0 + (i + 1) * (nodeWidth + nodeGap);

      bool isLinkCut = skippedIndices.contains(i + 1) || skippedIndices.contains(i);

      if (isLinkCut) {
        // Draw dashed pink line representing cut link
        _drawDashedLine(canvas, Offset(x1, yCenter), Offset(x2, yCenter), skippedArrowPaint);
      } else {
        canvas.drawLine(Offset(x1, yCenter), Offset(x2, yCenter), normalArrowPaint);
        // Draw Arrowhead pointing right
        Path tipPath = Path();
        tipPath.moveTo(x2, yCenter);
        tipPath.lineTo(x2 - 7, yCenter - 4);
        tipPath.lineTo(x2 - 7, yCenter + 4);
        tipPath.close();
        canvas.drawPath(tipPath, fillPaint);
      }
    }

    // Draw Overhead Bypass Curved Arrows for each bypass action
    for (final bypass in bypasses) {
      final bypassPaint = Paint()
        ..color = AppTheme.accentNeonCyan
        ..strokeWidth = 3.0
        ..style = PaintingStyle.stroke;

      final bypassFill = Paint()
        ..color = AppTheme.accentNeonCyan
        ..style = PaintingStyle.fill;

      double xStart = 16.0 + bypass.fromIdx * (nodeWidth + nodeGap) + nodeWidth / 2;
      double xEnd = 16.0 + bypass.toIdx * (nodeWidth + nodeGap) + (bypass.toIdx >= nodeCount ? 24.0 : nodeWidth / 2);

      double yTopStart = topSpace;
      double yCurveTop = yTopStart - 26.0;

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

      // Draw label badge on top of curve
      TextSpan span = TextSpan(
        text: bypass.label,
        style: const TextStyle(
          color: AppTheme.accentNeonCyan,
          fontWeight: FontWeight.bold,
          fontSize: 10,
          backgroundColor: Colors.black87,
        ),
      );
      TextPainter tp = TextPainter(
        text: span,
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      double labelX = (xStart + xEnd) / 2 - tp.width / 2;
      tp.paint(canvas, Offset(labelX, yCurveTop - 12));
    }
  }

  void _drawDashedLine(Canvas canvas, Offset p1, Offset p2, Paint paint) {
    const double dashWidth = 5.0;
    const double dashSpace = 4.0;
    double distance = (p2 - p1).distance;
    double dx = (p2.dx - p1.dx) / distance;
    double dy = (p2.dy - p1.dy) / distance;

    double currentDist = 0.0;
    while (currentDist < distance) {
      canvas.drawLine(
        Offset(p1.dx + dx * currentDist, p1.dy + dy * currentDist),
        Offset(p1.dx + dx * math.min(currentDist + dashWidth, distance), p1.dy + dy * math.min(currentDist + dashWidth, distance)),
        paint,
      );
      currentDist += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant RemoveDuplicatesPainter oldDelegate) {
    return oldDelegate.nodeCount != nodeCount ||
        oldDelegate.bypasses != bypasses ||
        oldDelegate.skippedIndices != skippedIndices;
  }
}


