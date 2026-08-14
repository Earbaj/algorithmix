import 'dart:async';
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
  int _animGuideStep = 0;
  bool _isAnimGuidePlaying = false;
  Timer? _animGuideTimer;
  final List<int> _happySeq = [19, 82, 68, 100, 1];

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

    int slowVal = _happySeq[0];
    int fastVal = _happySeq[0];
    String stepTextEn = "";
    String stepTextBn = "";

    if (_animGuideStep == 0) {
      slowVal = 19;
      fastVal = 19;
      stepTextEn = "Start: Both Slow (🐢) and Fast (🐇) start at number 19.";
      stepTextBn = "শুরু: Slow (🐢) এবং Fast (🐇) দুজনই ১৯ সংখ্যাটি নির্দেশ করছে।";
    } else if (_animGuideStep == 1) {
      slowVal = 82; // 1^2 + 9^2 = 82
      fastVal = 68; // 19 -> 82 -> 68
      stepTextEn = "Step 1: Slow transforms 1x → 82 (1²+9²). Fast transforms 2x → 68 (19->82->68).";
      stepTextBn = "ধাপ ১: Slow ১ ধাপ রুপান্তরিত হয়ে ৮২ (1²+9²)। Fast ২ ধাপ রুপান্তরিত হয়ে ৬৮ (19->82->68)।";
    } else if (_animGuideStep == 2) {
      slowVal = 68; // 8^2 + 2^2 = 68
      fastVal = 1;  // 68 -> 100 -> 1
      stepTextEn = "Step 2: Slow transforms 1x → 68. Fast transforms 2x → 1 (68->100->1).";
      stepTextBn = "ধাপ ২: Slow ১ ধাপ রুপান্তরিত হয়ে ৬৮। Fast ২ ধাপ রুপান্তরিত হয়ে ১ (68->100->1)।";
    } else {
      slowVal = 1;
      fastVal = 1;
      stepTextEn = "🎉 HAPPY NUMBER FOUND! Fast reached 1! Slow also lands on 1! Return true!";
      stepTextBn = "🎉 হ্যাপি নাম্বার প্রাপ্ত! Fast ১ এ পৌঁছে গেছে! Slow ও ১ এ এসে থামলো! Return true!";
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
                        ? "Watch how digit-square transformation flows. Slow pointer transforms digits once per step, while Fast transforms digits twice per step. If the sequence ends in 1, it is a Happy Number!"
                        : "দেখুন কিভাবে অংকগুলোর বর্গের যোগফল রূপান্তর হয়। Slow প্রতি ধাপে ১ বার এবং Fast প্রতি ধাপে ২ বার ডিজিট স্কয়ার ট্রান্সফর্ম করে। ধারাটি ১ এ পৌঁছালে তা হ্যাপি নাম্বার!",
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
                        "Transformation Sequence: 19 -> 82 -> 68 -> 100 -> 1",
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
                      children: List.generate(_happySeq.length, (idx) {
                        final val = _happySeq[idx];
                        final isSlow = slowVal == val;
                        final isFast = fastVal == val;
                        final isHappy = _animGuideStep == 3 && val == 1;

                        Color boxBg = AppTheme.primaryDark;
                        Color borderColor = const Color(0xFF334155);

                        if (isHappy) {
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
                              if (isSlow && isFast)
                                Text('Slow & Fast', style: TextStyle(fontSize: Responsive.sp(context, 10), color: AppTheme.accentAmber, fontWeight: FontWeight.bold))
                              else if (isSlow)
                                Text('Slow (🐢)', style: TextStyle(fontSize: Responsive.sp(context, 10), color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold))
                              else if (isFast)
                                Text('Fast (🐇)', style: TextStyle(fontSize: Responsive.sp(context, 10), color: AppTheme.accentPurple, fontWeight: FontWeight.bold))
                              else
                                Text(' ', style: TextStyle(fontSize: Responsive.sp(context, 10))),
                              const SizedBox(height: 6),
                              Text('$val', style: TextStyle(fontSize: Responsive.sp(context, 18), fontWeight: FontWeight.bold, color: isHappy ? AppTheme.accentGreen : Colors.white)),
                              const SizedBox(height: 4),
                              Text('step $idx', style: TextStyle(fontSize: Responsive.sp(context, 10), color: AppTheme.textMuted)),
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
