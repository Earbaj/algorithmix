import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class HappyDebuggerStep {
  final int slowVal;
  final int fastVal;
  final int activeLine;
  final String actionEn;
  final String actionBn;
  final String reasonEn;
  final String reasonBn;
  final bool isHappy;
  final bool isCycle;

  const HappyDebuggerStep({
    required this.slowVal,
    required this.fastVal,
    required this.activeLine,
    required this.actionEn,
    required this.actionBn,
    required this.reasonEn,
    required this.reasonBn,
    this.isHappy = false,
    this.isCycle = false,
  });
}

class HappyCodeDebuggerTab extends StatefulWidget {
  final bool isEnglish;

  const HappyCodeDebuggerTab({
    super.key,
    required this.isEnglish,
  });

  @override
  State<HappyCodeDebuggerTab> createState() => _HappyCodeDebuggerTabState();
}

class _HappyCodeDebuggerTabState extends State<HappyCodeDebuggerTab> {
  final int _n = 19;
  List<HappyDebuggerStep> _steps = [];

  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _steps = _generateSteps(_n);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  int _getNext(int n) {
    int sum = 0;
    while (n > 0) {
      int d = n % 10;
      sum += d * d;
      n ~/= 10;
    }
    return sum;
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text.trim()));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              widget.isEnglish ? '$label copied!' : '$label কোড কপি হয়েছে!',
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
        backgroundColor: AppTheme.accentGreen,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  List<HappyDebuggerStep> _generateSteps(int n) {
    List<HappyDebuggerStep> steps = [];

    int slow = n;
    int fast = n;

    steps.add(HappyDebuggerStep(
      slowVal: slow,
      fastVal: fast,
      activeLine: 2,
      actionEn: "Line 2: int slow = n; int fast = n; ($n)",
      actionBn: "লাইন ২: int slow = n; int fast = n; ($n)",
      reasonEn: "Slow and Fast start at n.",
      reasonBn: "Slow ও Fast শুরুর সংখ্যা n এ অবস্থান করছে।",
    ));

    int maxIter = 15;
    int iter = 0;

    while (iter < maxIter) {
      iter++;

      steps.add(HappyDebuggerStep(
        slowVal: slow,
        fastVal: fast,
        activeLine: 4,
        actionEn: "Line 4: do-while loop check",
        actionBn: "লাইন ৪: do-while লুপ চেক",
        reasonEn: "Loop continues until slow == fast.",
        reasonBn: "slow == fast না হওয়া পর্যন্ত লুপ চলবে।",
      ));

      slow = _getNext(slow);
      steps.add(HappyDebuggerStep(
        slowVal: slow,
        fastVal: fast,
        activeLine: 5,
        actionEn: "Line 5: slow = getNext(slow); → slow becomes $slow",
        actionBn: "লাইন ৫: slow = getNext(slow); → slow হলো $slow",
        reasonEn: "Slow advances 1 transformation step.",
        reasonBn: "Slow ১ ধাপ স্কয়ার ডিজিট রূপান্তর করলো।",
      ));

      fast = _getNext(_getNext(fast));
      steps.add(HappyDebuggerStep(
        slowVal: slow,
        fastVal: fast,
        activeLine: 6,
        actionEn: "Line 6: fast = getNext(getNext(fast)); → fast becomes $fast",
        actionBn: "লাইন ৬: fast = getNext(getNext(fast)); → fast হলো $fast",
        reasonEn: "Fast advances 2 transformation steps.",
        reasonBn: "Fast ২ ধাপ স্কয়ার ডিজিট রূপান্তর করলো।",
      ));

      bool isMatch = slow == fast;

      if (isMatch) {
        bool isHappy = slow == 1;

        steps.add(HappyDebuggerStep(
          slowVal: slow,
          fastVal: fast,
          activeLine: 8,
          actionEn: isHappy
              ? "Line 8: 🎉 return slow == 1; → TRUE (Happy Number!)"
              : "Line 8: ❌ return slow == 1; → FALSE (Unhappy Cycle!)",
          actionBn: isHappy
              ? "লাইন ৮: 🎉 return slow == 1; → সত্য (হ্যাপি নাম্বার!)"
              : "লাইন ৮: ❌ return slow == 1; → মিথ্যা (সাইকেল রয়েছে!)",
          reasonEn: isHappy ? "Sum reached 1." : "Loop trapped in cycle.",
          reasonBn: isHappy ? "যোগফল ১ পাওয়া গেছে।" : "যোগফল ১ ছাড়া অন্য চক্রে আটকে গেছে।",
          isHappy: isHappy,
          isCycle: !isHappy,
        ));
        break;
      }
    }

    return steps;
  }

  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;
    });

    if (_isPlaying) {
      _timer = Timer.periodic(const Duration(milliseconds: 1400), (timer) {
        if (_currentStepIndex < _steps.length - 1) {
          setState(() {
            _currentStepIndex++;
          });
        } else {
          _timer?.cancel();
          setState(() {
            _isPlaying = false;
          });
        }
      });
    } else {
      _timer?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    final hPadding = Responsive.horizontalPadding(context);
    final step = _steps.isEmpty
        ? const HappyDebuggerStep(slowVal: 0, fastVal: 0, activeLine: 0, actionEn: "", actionBn: "", reasonEn: "", reasonBn: "")
        : _steps[_currentStepIndex];

    return ResponsiveCenter(
      maxWidth: 1280.0,
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.accentNeonCyan.withOpacity(0.4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.bug_report, color: AppTheme.accentNeonCyan, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    widget.isEnglish ? "Interactive Code Execution Debugger" : "ইন্টারঅ্যাক্টিভ কোড এক্সিকিউশন ডিবাগার",
                    style: TextStyle(fontSize: Responsive.sp(context, 16), fontWeight: FontWeight.bold, color: AppTheme.accentNeonCyan),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            _buildVisualizationBox(step),
            const SizedBox(height: 16),

            _buildCodeTraceWidget(step.activeLine),
            const SizedBox(height: 16),

            Container(
              padding: EdgeInsets.symmetric(horizontal: Responsive.sp(context, 16), vertical: 12),
              decoration: BoxDecoration(color: AppTheme.surfaceDark, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFF334155))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(icon: Icon(Icons.skip_previous, color: Colors.white, size: Responsive.sp(context, 20)), onPressed: _currentStepIndex > 0 ? () => setState(() => _currentStepIndex--) : null),
                      IconButton(icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, color: AppTheme.accentNeonCyan, size: Responsive.sp(context, 24)), onPressed: _togglePlay),
                      IconButton(icon: Icon(Icons.skip_next, color: Colors.white, size: Responsive.sp(context, 20)), onPressed: _currentStepIndex < _steps.length - 1 ? () => setState(() => _currentStepIndex++) : null),
                      IconButton(
                        icon: Icon(Icons.refresh, color: AppTheme.textMuted, size: Responsive.sp(context, 20)),
                        onPressed: () {
                          _timer?.cancel();
                          setState(() {
                            _isPlaying = false;
                            _currentStepIndex = 0;
                          });
                        },
                      ),
                    ],
                  ),
                  Text("Step ${_currentStepIndex + 1} / ${_steps.length}", style: TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.bold, fontSize: Responsive.sp(context, 13))),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildVisualizationBox(HappyDebuggerStep step) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Responsive.sp(context, 16)),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: step.isHappy ? AppTheme.accentGreen : (step.isCycle ? AppTheme.accentPink : const Color(0xFF334155)),
          width: (step.isHappy || step.isCycle) ? 2.0 : 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Execution State View (n = 19)", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: Responsive.sp(context, 14))),
              if (step.isHappy)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: AppTheme.accentGreen.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                  child: const Text("🎉 HAPPY NUMBER (Sum=1)", style: TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 12)),
                )
              else if (step.isCycle)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: AppTheme.accentPink.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                  child: const Text("❌ UNHAPPY CYCLE", style: TextStyle(color: AppTheme.accentPink, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.accentNeonCyan.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.accentNeonCyan),
                  ),
                  child: Column(
                    children: [
                      Text('Slow Pointer (1x)', style: TextStyle(fontSize: Responsive.sp(context, 11), color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text('${step.slowVal}', style: TextStyle(fontSize: Responsive.sp(context, 22), fontWeight: FontWeight.bold, color: Colors.white)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.accentPurple.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.accentPurple),
                  ),
                  child: Column(
                    children: [
                      Text('Fast Pointer (2x)', style: TextStyle(fontSize: Responsive.sp(context, 11), color: AppTheme.accentPurple, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text('${step.fastVal}', style: TextStyle(fontSize: Responsive.sp(context, 22), fontWeight: FontWeight.bold, color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(Responsive.sp(context, 12)),
            decoration: BoxDecoration(
              color: step.isHappy ? AppTheme.accentGreen.withOpacity(0.15) : (step.isCycle ? AppTheme.accentPink.withOpacity(0.15) : AppTheme.primaryDark),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: step.isHappy ? AppTheme.accentGreen : (step.isCycle ? AppTheme.accentPink : const Color(0xFF334155))),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.isEnglish ? step.actionEn : step.actionBn, style: TextStyle(fontWeight: FontWeight.bold, color: step.isHappy ? AppTheme.accentGreen : (step.isCycle ? AppTheme.accentPink : Colors.white), fontSize: Responsive.sp(context, 13))),
                const SizedBox(height: 4),
                Text(widget.isEnglish ? step.reasonEn : step.reasonBn, style: TextStyle(color: AppTheme.textSecondary, fontSize: Responsive.sp(context, 12), height: 1.3)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeTraceWidget(int activeLine) {
    const codeLines = [
      "bool isHappy(int n) {",
      "    int slow = n;",
      "    int fast = n;",
      "    do {",
      "        slow = getNext(slow);",
      "        fast = getNext(getNext(fast));",
      "    } while (slow != fast);",
      "    return slow == 1;",
      "}",
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Responsive.sp(context, 14)),
      decoration: BoxDecoration(color: const Color(0xFF090D16), borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFF1E293B), width: 1.5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("C++ Code Line-by-Line Execution Trace", style: TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: Responsive.sp(context, 13.5))),
              InkWell(
                onTap: () => _copyToClipboard(codeLines.join('\n'), "C++ Code"),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(color: AppTheme.accentPurple.withOpacity(0.25), borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    children: [
                      Icon(Icons.copy, size: Responsive.sp(context, 13), color: AppTheme.accentNeonCyan),
                      const SizedBox(width: 4),
                      Text(widget.isEnglish ? "Copy" : "কপি", style: TextStyle(color: Colors.white, fontSize: Responsive.sp(context, 11.5), fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(codeLines.length, (idx) {
                final lineNum = idx + 1;
                final isActive = lineNum == activeLine;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(vertical: 2.5),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(
                    color: isActive ? AppTheme.accentPurple.withOpacity(0.35) : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                    border: isActive ? const Border(left: BorderSide(color: AppTheme.accentNeonCyan, width: 4)) : null,
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 28, child: Text('$lineNum', style: TextStyle(fontFamily: 'monospace', fontSize: Responsive.sp(context, 12), color: isActive ? AppTheme.accentNeonCyan : AppTheme.textMuted, fontWeight: isActive ? FontWeight.bold : FontWeight.normal))),
                      Text(codeLines[idx], style: TextStyle(fontFamily: 'monospace', fontSize: Responsive.sp(context, 13), color: isActive ? Colors.white : const Color(0xFF94A3B8), fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
