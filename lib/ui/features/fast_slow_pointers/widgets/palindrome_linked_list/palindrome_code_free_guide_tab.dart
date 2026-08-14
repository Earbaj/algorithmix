import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class PalindromeCodeFreeGuideTab extends StatefulWidget {
  final bool isEnglish;

  const PalindromeCodeFreeGuideTab({
    super.key,
    required this.isEnglish,
  });

  @override
  State<PalindromeCodeFreeGuideTab> createState() => _PalindromeCodeFreeGuideTabState();
}

class _PalindromeCodeFreeGuideTabState extends State<PalindromeCodeFreeGuideTab> {
  int _animGuideStep = 0;
  bool _isAnimGuidePlaying = false;
  Timer? _animGuideTimer;

  final List<int> _originalNodes = [1, 2, 2, 1];

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

    int p1Idx = 0;
    int p2Idx = 0;
    String stepTextEn = "";
    String stepTextBn = "";

    if (_animGuideStep == 0) {
      p1Idx = 0;
      p2Idx = 3;
      stepTextEn = "Phase 1: Find Middle. Slow reaches idx 2 [val: 2], Fast reaches end.";
      stepTextBn = "ধাপ ১: মিডল নোড খোঁজা। Slow ইনডেক্স ২ [মান: ২] এ এবং Fast শেষে পৌঁছালো।";
    } else if (_animGuideStep == 1) {
      p1Idx = 0;
      p2Idx = 3;
      stepTextEn = "Phase 2: Reverse Second Half [2, 1] → Reversed to [1, 2].";
      stepTextBn = "ধাপ ২: ২য় অর্ধাংশ [২, ১] উল্টে দিয়ে [১, ২] করা হলো।";
    } else if (_animGuideStep == 2) {
      p1Idx = 0;
      p2Idx = 3;
      stepTextEn = "Phase 3: Compare Pointers p1 (idx 0, val: 1) == p2 (idx 3, val: 1) → MATCH!";
      stepTextBn = "ধাপ ৩: পয়েন্টার p1 (মান: ১) ও p2 (মান: ১) তুলনা → সমান পাওয়া গেছে!";
    } else {
      p1Idx = 1;
      p2Idx = 2;
      stepTextEn = "🎉 PALINDROME CONFIRMED! All values matched! Return true!";
      stepTextBn = "🎉 প্যালিনড্রোম নিশ্চিত! সকল নোডের মান মিলে গেছে! Return true!";
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
                        ? "Watch the 3-step process: 1. Find Middle via Fast/Slow, 2. Reverse the 2nd half, 3. Compare pointers moving inwards!"
                        : "৩টি ধাপ দেখুন: ১. Fast/Slow দিয়ে মিডল খোঁজা, ২. ২য় অর্ধাংশ উল্টানো, ৩. উভয় পয়েন্টার সমান কিনা পরীক্ষা করা!",
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
                        "Linked List: [1, 2, 2, 1]",
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
                      children: List.generate(_originalNodes.length, (idx) {
                        final val = _originalNodes[idx];
                        final isP1 = p1Idx == idx;
                        final isP2 = p2Idx == idx;
                        final isComplete = _animGuideStep == 3;

                        Color boxBg = AppTheme.primaryDark;
                        Color borderColor = const Color(0xFF334155);

                        if (isComplete) {
                          boxBg = AppTheme.accentGreen.withOpacity(0.35);
                          borderColor = AppTheme.accentGreen;
                        } else if (isP1) {
                          boxBg = AppTheme.accentNeonCyan.withOpacity(0.25);
                          borderColor = AppTheme.accentNeonCyan;
                        } else if (isP2) {
                          boxBg = AppTheme.accentPurple.withOpacity(0.25);
                          borderColor = AppTheme.accentPurple;
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
                              if (isP1 && isP2)
                                Text('P1 & P2', style: TextStyle(fontSize: Responsive.sp(context, 10), color: AppTheme.accentAmber, fontWeight: FontWeight.bold))
                              else if (isP1)
                                Text('Left (p1)', style: TextStyle(fontSize: Responsive.sp(context, 10), color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold))
                              else if (isP2)
                                Text('Right (p2)', style: TextStyle(fontSize: Responsive.sp(context, 10), color: AppTheme.accentPurple, fontWeight: FontWeight.bold))
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
