import 'dart:async';
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
  int _animGuideStep = 0;
  bool _isAnimGuidePlaying = false;
  Timer? _animGuideTimer;
  final List<int> _animGuideNodes = [10, 20, 30, 40, 50];

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

    int slowIdx = 0;
    int fastIdx = 0;
    String stepTextEn = "";
    String stepTextBn = "";

    if (_animGuideStep == 0) {
      slowIdx = 0;
      fastIdx = 0;
      stepTextEn = "Start: Both Slow (🐢) and Fast (🐇) start at Node 0 [val: 10].";
      stepTextBn = "শুরু: Slow (🐢) এবং Fast (🐇) দুজনই ১ম নোড [১০] এ আছে।";
    } else if (_animGuideStep == 1) {
      slowIdx = 1;
      fastIdx = 2;
      stepTextEn = "Step 1: Slow moves 1 step → Node 1 [val: 20]. Fast moves 2 steps → Node 2 [val: 30].";
      stepTextBn = "ধাপ ১: Slow ১ ধাপ হেঁটে নোড ১ [২০] এ। Fast ২ ধাপ হেঁটে নোড ২ [৩০] এ।";
    } else if (_animGuideStep == 2) {
      slowIdx = 2;
      fastIdx = 4;
      stepTextEn = "Step 2: Slow moves 1 step → Node 2 [val: 30]. Fast moves 2 steps → Node 4 (End) [val: 50].";
      stepTextBn = "ধাপ ২: Slow ১ ধাপ হেঁটে নোড ২ [৩০] এ। Fast ২ ধাপ হেঁটে নোড ৪ (শেষ নোড) [৫০] এ।";
    } else {
      slowIdx = 2;
      fastIdx = 4;
      stepTextEn = "🎉 Finished! Fast reached the end of the list. Slow is pointing EXACTLY at the Middle Node [val: 30]!";
      stepTextBn = "🎉 শেষ! Fast লিস্টের শেষ প্রান্তে পৌঁছে গেছে। Slow ঠিক মাঝের নোড [৩০] এ অবস্থান করছে!";
    }

    return ResponsiveCenter(
      maxWidth: 1280.0,
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.isEnglish ? "Interactive Animated Concept Guide" : "ইন্টারঅ্যাক্টিভ অ্যানিমেটেড কনসেপ্ট গাইড",
                  style: TextStyle(fontSize: Responsive.sp(context, 18), fontWeight: FontWeight.bold, color: AppTheme.accentNeonCyan),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.isEnglish
                      ? "Watch how Slow (🐢 1 step/sec) and Fast (🐇 2 steps/sec) move across the linked list. Since Fast moves at twice the speed of Slow, when Fast reaches the end, Slow naturally lands on the Middle Node!"
                      : "দেখুন কিভাবে Slow (🐢 ১ ধাপ) এবং Fast (🐇 ২ ধাপ) পয়েন্টার লিঙ্কড লিস্ট দিয়ে যাচ্ছে। Fast এর গতি দ্বিগুণ হওয়ায়, Fast শেষে পৌঁছানো মাত্রই Slow সরাসরি মাঝের নোডে গিয়ে থামে!",
                  style: TextStyle(color: AppTheme.textPrimary, fontSize: Responsive.sp(context, 13.5), height: 1.5),
                ),
              ],
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
                  Text(
                    "Linked List Track: [10, 20, 30, 40, 50]",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: Responsive.sp(context, 14)),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Step ${_animGuideStep + 1} / 4",
                    style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  const SizedBox(height: 20),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(_animGuideNodes.length, (idx) {
                        final val = _animGuideNodes[idx];
                        final isSlow = slowIdx == idx;
                        final isFast = fastIdx == idx;
                        final isMiddleNode = _animGuideStep == 3 && idx == 2;

                        Color boxBg = AppTheme.primaryDark;
                        Color borderColor = const Color(0xFF334155);

                        if (isMiddleNode) {
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

                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 350),
                          margin: const EdgeInsets.only(right: 12),
                          padding: EdgeInsets.symmetric(
                            horizontal: Responsive.sp(context, 14),
                            vertical: Responsive.sp(context, 10),
                          ),
                          decoration: BoxDecoration(
                            color: boxBg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: borderColor, width: 2),
                          ),
                          child: Column(
                            children: [
                              if (isSlow && isFast)
                                Text('Slow & Fast', style: TextStyle(fontSize: Responsive.sp(context, 10), color: AppTheme.accentAmber, fontWeight: FontWeight.bold))
                              else if (isSlow)
                                Text('Slow (🐢)', style: TextStyle(fontSize: Responsive.sp(context, 10), color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold))
                              else if (isFast)
                                Text('Fast (🐇)', style: TextStyle(fontSize: Responsive.sp(context, 10), color: AppTheme.accentPurple, fontWeight: FontWeight.bold))
                              else
                                Text(' ', style: TextStyle(fontSize: Responsive.sp(context, 10))),
                              const SizedBox(height: 6),
                              Text(
                                '$val',
                                style: TextStyle(
                                  fontSize: Responsive.sp(context, 18),
                                  fontWeight: FontWeight.bold,
                                  color: isMiddleNode ? AppTheme.accentGreen : Colors.white,
                                ),
                              ),
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
