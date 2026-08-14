import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class IntersectionCodeFreeGuideTab extends StatefulWidget {
  final bool isEnglish;

  const IntersectionCodeFreeGuideTab({
    super.key,
    required this.isEnglish,
  });

  @override
  State<IntersectionCodeFreeGuideTab> createState() => _IntersectionCodeFreeGuideTabState();
}

class _IntersectionCodeFreeGuideTabState extends State<IntersectionCodeFreeGuideTab> {
  int _animGuideStep = 0;
  bool _isAnimGuidePlaying = false;
  Timer? _animGuideTimer;

  // List A: [4, 1, 8, 4, 5]
  // List B: [5, 6, 1, 8, 4, 5]
  // Intersection starts at value 8

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

    String pAState = "";
    String pBState = "";
    String stepTextEn = "";
    String stepTextBn = "";

    if (_animGuideStep == 0) {
      pAState = "pA at List A: Node [4]";
      pBState = "pB at List B: Node [5]";
      stepTextEn = "Start: pA starts at headA [4], pB starts at headB [5].";
      stepTextBn = "শুরু: pA নোড [৪] এ এবং pB নোড [৫] এ বসানো হলো।";
    } else if (_animGuideStep == 1) {
      pAState = "pA reached end of List A → Switched to headB [5]";
      pBState = "pB moving in List B → Node [1]";
      stepTextEn = "Switch Pointer: pA finished List A and switched to headB [5]!";
      stepTextBn = "পয়েন্টার সুইচ: pA লিস্ট A শেষ করে headB [৫] এ চলে আসলো!";
    } else if (_animGuideStep == 2) {
      pAState = "pA moving in List B → Node [6]";
      pBState = "pB reached end of List B → Switched to headA [4]";
      stepTextEn = "Switch Pointer: pB finished List B and switched to headA [4]!";
      stepTextBn = "পয়েন্টার সুইচ: pB লিস্ট B শেষ করে headA [৪] এ চলে আসলো!";
    } else {
      pAState = "pA at Node [8]";
      pBState = "pB at Node [8]";
      stepTextEn = "🎉 COLLISION MATCH! Both pA and pB meet at Intersection Node [8]!";
      stepTextBn = "🎉 ইন্টারসেকশন মিল! pA ও pB উভয়ই একই নোড [৮] এ এসে মিলিত হয়েছে!";
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
                        ? "Watch how switching heads at the end neutralizes length difference (lenA + lenB == lenB + lenA), forcing pointers to collide at the intersection node!"
                        : "দেখুন কিভাবে পয়েন্টার শেষে গিয়ে অন্য হেড এ সুইচে লেন্থ এর পার্থক্য নিরপেক্ষ হয়ে (lenA + lenB == lenB + lenA) ইন্টারসেকশন নোডে মিলিত হয়!",
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
                        "Intersection Visualization View",
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

                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppTheme.accentNeonCyan.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppTheme.accentNeonCyan),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Pointer pA', style: TextStyle(fontSize: Responsive.sp(context, 11), color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 6),
                              Text(pAState, style: TextStyle(fontSize: Responsive.sp(context, 13), fontWeight: FontWeight.bold, color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppTheme.accentPurple.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppTheme.accentPurple),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Pointer pB', style: TextStyle(fontSize: Responsive.sp(context, 11), color: AppTheme.accentPurple, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 6),
                              Text(pBState, style: TextStyle(fontSize: Responsive.sp(context, 13), fontWeight: FontWeight.bold, color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                    ],
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
