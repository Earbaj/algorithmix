import 'dart:async';
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
  int _animGuideStep = 0;
  bool _isAnimGuidePlaying = false;
  Timer? _animGuideTimer;

  // Track nodes at each step
  final List<List<int>> _nodesPerStep = [
    [1, 1, 2, 3, 3], // Step 0: init curr at 0 (val: 1)
    [1, 2, 3, 3],    // Step 1: bypass duplicate 1 (curr.next = curr.next.next)
    [1, 2, 3, 3],    // Step 2: curr moves to idx 1 (val: 2)
    [1, 2, 3],       // Step 3: bypass duplicate 3 (curr.next = curr.next.next)
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
        if (_animGuideStep < 3) {
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

    int currIdx = 0;
    String stepTextEn = "";
    String stepTextBn = "";

    if (_animGuideStep == 0) {
      currIdx = 0;
      stepTextEn = "Start: curr pointer at Node 0 [val: 1]. Next node is also 1 (Duplicate!).";
      stepTextBn = "শুরু: curr পয়েন্টার নোড ০ [মান: ১] এ। পরের নোডও ১ (ডুপ্লিকেট!)।";
    } else if (_animGuideStep == 1) {
      currIdx = 0;
      stepTextEn = "Bypass Duplicate: curr.val == curr.next.val (1 == 1) → Skip duplicate 1 node! List becomes [1, 2, 3, 3].";
      stepTextBn = "ডুপ্লিকেট বাইপাস: 1 == 1 মেলায় ২য় ১ নোডটি স্কিপ করা হলো! লিঙ্কড লিস্ট দাঁড়িয়েছে [১, ২, ৩, ৩]।";
    } else if (_animGuideStep == 2) {
      currIdx = 1;
      stepTextEn = "Advance Pointer: curr.val != curr.next.val (1 != 2) → Move curr forward to Node [val: 2].";
      stepTextBn = "পয়েন্টার অগ্রসর: 1 != 2 মেলায় ডুপ্লিকেট নেই → curr ১ ঘর সামনে বাড়িয়ে মান ২ এ আনা হলো।";
    } else {
      currIdx = 2;
      stepTextEn = "🎉 Finished! Duplicate 3 bypassed. Result: [1, 2, 3] with unique elements only!";
      stepTextBn = "🎉 শেষ! ডুপ্লিকেট ৩ বাইপাসড। ফলাফল: অনন্য মানসম্পন্ন লিঙ্কড লিস্ট [১, ২, ৩]!";
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
                        ? "Watch how adjacent node values are compared. If curr.val == curr.next.val, the next pointer bypasses the duplicate node directly!"
                        : "দেখুন কিভাবে পাশাপাশি নোড মান তুলনা করা হয়। curr.val == curr.next.val হলে নেক্সট পয়েন্টার ডুপ্লিকেট নোডটিকে সরাসরি বাইপাস করে!",
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
                border: Border.all(color: _animGuideStep == 3 ? AppTheme.accentGreen : const Color(0xFF334155), width: 2),
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
                        child: Text("Step ${_animGuideStep + 1} / 4", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(currentNodes.length, (idx) {
                        final val = currentNodes[idx];
                        final isCurr = currIdx == idx;
                        final isComplete = _animGuideStep == 3;

                        Color boxBg = AppTheme.primaryDark;
                        Color borderColor = const Color(0xFF334155);

                        if (isComplete) {
                          boxBg = AppTheme.accentGreen.withOpacity(0.35);
                          borderColor = AppTheme.accentGreen;
                        } else if (isCurr) {
                          boxBg = AppTheme.accentNeonCyan.withOpacity(0.25);
                          borderColor = AppTheme.accentNeonCyan;
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
                              if (isCurr)
                                Text('curr 📍', style: TextStyle(fontSize: Responsive.sp(context, 10), color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold))
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
                      color: _animGuideStep == 3 ? AppTheme.accentGreen.withOpacity(0.15) : AppTheme.primaryDark,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _animGuideStep == 3 ? AppTheme.accentGreen : const Color(0xFF334155)),
                    ),
                    child: Text(
                      widget.isEnglish ? stepTextEn : stepTextBn,
                      style: TextStyle(
                        color: _animGuideStep == 3 ? AppTheme.accentGreen : Colors.white,
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
                        onPressed: _animGuideStep < 3 ? () => setState(() => _animGuideStep++) : null,
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
