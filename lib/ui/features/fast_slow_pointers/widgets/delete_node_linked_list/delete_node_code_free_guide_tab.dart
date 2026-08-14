import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class DeleteNodeCodeFreeGuideTab extends StatefulWidget {
  final bool isEnglish;

  const DeleteNodeCodeFreeGuideTab({
    super.key,
    required this.isEnglish,
  });

  @override
  State<DeleteNodeCodeFreeGuideTab> createState() => _DeleteNodeCodeFreeGuideTabState();
}

class _DeleteNodeCodeFreeGuideTabState extends State<DeleteNodeCodeFreeGuideTab> {
  int _animGuideStep = 0;
  bool _isAnimGuidePlaying = false;
  Timer? _animGuideTimer;

  final List<List<int>> _nodesPerStep = [
    [4, 5, 1, 9], // Step 0: given target node = 5 (idx 1)
    [4, 1, 1, 9], // Step 1: copy value 1 into node 5 -> becomes 1!
    [4, 1, 9],    // Step 2: bypass duplicate node 1 (node.next = node.next.next)
  ];

  @override
  void dispose() {
    _animGuideTimer?.cancel();
    super.dispose();
  }

  void _toggleAnimGuidePlay() {
    setState(() {
      _isAnimGuidePlaying = !_isAnimGuidePlaying;
    });

    if (_isAnimGuidePlaying) {
      _animGuideTimer = Timer.periodic(const Duration(milliseconds: 1600), (timer) {
        if (_animGuideStep < 2) {
          setState(() {
            _animGuideStep++;
          });
        } else {
          _animGuideTimer?.cancel();
          setState(() {
            _isAnimGuidePlaying = false;
          });
        }
      });
    } else {
      _animGuideTimer?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    final hPadding = Responsive.horizontalPadding(context);
    final currentNodes = _nodesPerStep[_animGuideStep];

    String stepTextEn = "";
    String stepTextBn = "";

    if (_animGuideStep == 0) {
      stepTextEn = "Start: You are given target node [val: 5] to delete. Note: Head is unavailable!";
      stepTextBn = "শুরু: যে নোডটি (মান: ৫) ডিলেট করতে হবে সেটি সরাসরি দেওয়া আছে। লক্ষণীয়: হেডের অ্যাক্সেস নেই!";
    } else if (_animGuideStep == 1) {
      stepTextEn = "Step 1 (Value Copy): Copy next node's value (1) into target node (node.val = node.next.val). Node becomes 1!";
      stepTextBn = "ধাপ ১ (মান কপি): পরের নোডের মান (১) কে বর্তমান নোডে কপি করা হলো। নোডের মান এখন ১!";
    } else {
      stepTextEn = "🎉 Step 2 (Bypass): Bypass next node via node.next = node.next.next! Result: [4, 1, 9] in O(1) time!";
      stepTextBn = "🎉 ধাপ ২ (বাইপাস): পরের নোডটি বাইপাস করা হলো! ফলাফল: [৪, ১, ৯] মাত্র O(1) সময়ে!";
    }

    return ResponsiveCenter(
      maxWidth: 1280.0,
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                  Row(
                    children: [
                      const Icon(Icons.auto_awesome, color: AppTheme.accentNeonCyan, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        widget.isEnglish ? "Interactive Animated Concept Guide" : "ইন্টারঅ্যাক্টিভ অ্যানিমেটেড কনসেপ্ট গাইড",
                        style: TextStyle(fontSize: Responsive.sp(context, 18), fontWeight: FontWeight.bold, color: AppTheme.accentNeonCyan),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.isEnglish
                        ? "Watch the O(1) trick: Since we can't look back to change the previous pointer, we copy the next node's value into the target node and then delete the next node!"
                        : "O(1) ট্রিকটি দেখুন: পেছনের পয়েন্টার চেঞ্জ করার সুযোগ নেই, তাই পরের নোডের মান কারেন্ট নোডে কপি করে নেক্সট নোড ডিলেট করা হয়!",
                    style: TextStyle(color: AppTheme.textSecondary, fontSize: Responsive.sp(context, 13.5), height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding: EdgeInsets.all(Responsive.sp(context, 18)),
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _animGuideStep == 2 ? AppTheme.accentGreen : const Color(0xFF334155), width: 2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Linked List Nodes View",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: Responsive.sp(context, 14)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: AppTheme.accentPurple.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                        child: Text("Step ${_animGuideStep + 1} / 3", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(currentNodes.length, (idx) {
                        final val = currentNodes[idx];
                        final isTarget = (_animGuideStep < 2 && idx == 1) || (_animGuideStep == 2 && idx == 1);
                        final isComplete = _animGuideStep == 2;

                        Color boxBg = AppTheme.primaryDark;
                        Color borderColor = const Color(0xFF334155);

                        if (isComplete) {
                          boxBg = AppTheme.accentGreen.withOpacity(0.35);
                          borderColor = AppTheme.accentGreen;
                        } else if (isTarget) {
                          boxBg = AppTheme.accentPink.withOpacity(0.25);
                          borderColor = AppTheme.accentPink;
                        }

                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 350),
                          margin: const EdgeInsets.only(right: 12),
                          padding: EdgeInsets.symmetric(
                            horizontal: Responsive.sp(context, 16),
                            vertical: Responsive.sp(context, 12),
                          ),
                          decoration: BoxDecoration(
                            color: boxBg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: borderColor, width: 2),
                          ),
                          child: Column(
                            children: [
                              if (isTarget && !isComplete)
                                Text('Target 🎯', style: TextStyle(fontSize: Responsive.sp(context, 10), color: AppTheme.accentPink, fontWeight: FontWeight.bold))
                              else
                                Text(' ', style: TextStyle(fontSize: Responsive.sp(context, 10))),
                              const SizedBox(height: 6),
                              Text('$val', style: TextStyle(fontSize: Responsive.sp(context, 18), fontWeight: FontWeight.bold, color: isComplete ? AppTheme.accentGreen : Colors.white)),
                              const SizedBox(height: 4),
                              Text('idx $idx', style: TextStyle(fontSize: Responsive.sp(context, 10), color: AppTheme.textMuted)),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 18),

                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: _animGuideStep == 2 ? AppTheme.accentGreen.withOpacity(0.15) : AppTheme.primaryDark,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _animGuideStep == 2 ? AppTheme.accentGreen : const Color(0xFF334155)),
                    ),
                    child: Text(
                      widget.isEnglish ? stepTextEn : stepTextBn,
                      style: TextStyle(
                        color: _animGuideStep == 2 ? AppTheme.accentGreen : Colors.white,
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

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(color: AppTheme.surfaceDark, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFF334155))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.skip_previous, color: Colors.white, size: Responsive.sp(context, 20)),
                        onPressed: _animGuideStep > 0 ? () => setState(() => _animGuideStep--) : null,
                      ),
                      IconButton(
                        icon: Icon(_isAnimGuidePlaying ? Icons.pause : Icons.play_arrow, color: AppTheme.accentNeonCyan, size: Responsive.sp(context, 24)),
                        onPressed: _toggleAnimGuidePlay,
                      ),
                      IconButton(
                        icon: Icon(Icons.skip_next, color: Colors.white, size: Responsive.sp(context, 20)),
                        onPressed: _animGuideStep < 2 ? () => setState(() => _animGuideStep++) : null,
                      ),
                      IconButton(
                        icon: Icon(Icons.refresh, color: AppTheme.textMuted, size: Responsive.sp(context, 20)),
                        onPressed: () {
                          _animGuideTimer?.cancel();
                          setState(() {
                            _isAnimGuidePlaying = false;
                            _animGuideStep = 0;
                          });
                        },
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: _toggleAnimGuidePlay,
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentPurple),
                    child: Text(
                      _isAnimGuidePlaying ? (widget.isEnglish ? "Pause Animation" : "পজ করুন") : (widget.isEnglish ? "Auto Play Animation" : "অ্যানিমেশন প্লে করুন"),
                      style: TextStyle(fontSize: Responsive.sp(context, 12), fontWeight: FontWeight.bold),
                    ),
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
}
