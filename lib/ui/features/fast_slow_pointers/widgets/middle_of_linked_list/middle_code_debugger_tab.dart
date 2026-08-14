import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class MiddleDebuggerStep {
  final int slowIndex;
  final int fastIndex;
  final int activeLine;
  final String actionEn;
  final String actionBn;
  final String reasonEn;
  final String reasonBn;
  final bool isMiddleReached;

  const MiddleDebuggerStep({
    required this.slowIndex,
    required this.fastIndex,
    required this.activeLine,
    required this.actionEn,
    required this.actionBn,
    required this.reasonEn,
    required this.reasonBn,
    this.isMiddleReached = false,
  });
}

class MiddleCodeDebuggerTab extends StatefulWidget {
  final bool isEnglish;

  const MiddleCodeDebuggerTab({
    super.key,
    required this.isEnglish,
  });

  @override
  State<MiddleCodeDebuggerTab> createState() => _MiddleCodeDebuggerTabState();
}

class _MiddleCodeDebuggerTabState extends State<MiddleCodeDebuggerTab> {
  final List<int> _nodes = [1, 2, 3, 4, 5];
  List<MiddleDebuggerStep> _steps = [];

  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _steps = _generateSteps(_nodes);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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

  List<MiddleDebuggerStep> _generateSteps(List<int> nodes) {
    List<MiddleDebuggerStep> steps = [];
    int n = nodes.length;
    if (n == 0) return steps;

    int slow = 0;
    int fast = 0;

    steps.add(MiddleDebuggerStep(
      slowIndex: slow,
      fastIndex: fast,
      activeLine: 2,
      actionEn: "Line 2: ListNode* slow = head; (idx 0, val: ${nodes[0]})",
      actionBn: "লাইন ২: ListNode* slow = head; সূচনা (ইনডেক্স 0, মান: ${nodes[0]})",
      reasonEn: "Slow pointer starts at head node.",
      reasonBn: "Slow পয়েন্টার শুরুর নোডে বসানো হলো।",
    ));

    steps.add(MiddleDebuggerStep(
      slowIndex: slow,
      fastIndex: fast,
      activeLine: 3,
      actionEn: "Line 3: ListNode* fast = head; (idx 0, val: ${nodes[0]})",
      actionBn: "লাইন ৩: ListNode* fast = head; সূচনা (ইনডেক্স 0, মান: ${nodes[0]})",
      reasonEn: "Fast pointer also starts at head node.",
      reasonBn: "Fast পয়েন্টারও শুরুর নোডে বসানো হলো।",
    ));

    while (fast < n && fast + 1 < n) {
      steps.add(MiddleDebuggerStep(
        slowIndex: slow,
        fastIndex: fast,
        activeLine: 4,
        actionEn: "Line 4: check while (fast != nullptr && fast->next != nullptr) → TRUE",
        actionBn: "লাইন ৪: চেক while (fast != nullptr && fast->next != nullptr) → সত্য",
        reasonEn: "Fast pointer has nodes ahead to advance.",
        reasonBn: "Fast পয়েন্টারের সামনে আরও ২ টি নোড আছে।",
      ));

      slow += 1;
      steps.add(MiddleDebuggerStep(
        slowIndex: slow,
        fastIndex: fast,
        activeLine: 5,
        actionEn: "Line 5: slow = slow->next; → slow moves to idx $slow (val: ${nodes[slow]})",
        actionBn: "লাইন ৫: slow = slow->next; → slow ইনডেক্স $slow এ (মান: ${nodes[slow]})",
        reasonEn: "Slow pointer advances 1 step forward.",
        reasonBn: "Slow point ১ ধাপ সামনে অগ্রসর হলো।",
      ));

      fast += 2;
      steps.add(MiddleDebuggerStep(
        slowIndex: slow,
        fastIndex: fast < n ? fast : n - 1,
        activeLine: 6,
        actionEn: "Line 6: fast = fast->next->next; → fast moves to idx ${fast < n ? fast : 'end'}",
        actionBn: "লাইন ৬: fast = fast->next->next; → fast ইনডেক্স ${fast < n ? fast : 'শেষে'} এ",
        reasonEn: "Fast pointer advances 2 steps forward.",
        reasonBn: "Fast point ২ ধাপ সামনে অগ্রসর হলো।",
      ));
    }

    steps.add(MiddleDebuggerStep(
      slowIndex: slow,
      fastIndex: fast < n ? fast : n - 1,
      activeLine: 4,
      actionEn: "Line 4: check while (fast != nullptr && fast->next != nullptr) → FALSE",
      actionBn: "লাইন ৪: চেক while (fast != nullptr && fast->next != nullptr) → মিথ্যা",
      reasonEn: "Fast reached end of list. Loop terminates.",
      reasonBn: "Fast লিস্টের শেষ প্রান্তে পৌঁছে গেছে। লুপ সমাপ্ত।",
    ));

    steps.add(MiddleDebuggerStep(
      slowIndex: slow,
      fastIndex: fast < n ? fast : n - 1,
      activeLine: 8,
      actionEn: "Line 8: 🎉 return slow; → Middle Node at idx $slow (val: ${nodes[slow]})",
      actionBn: "লাইন ৮: 🎉 return slow; → মিডল নোড ইনডেক্স $slow এ (মান: ${nodes[slow]})",
      reasonEn: "Slow points directly to the middle node!",
      reasonBn: "Slow ঠিক মাঝের নোডকে পয়েন্ট করে!",
      isMiddleReached: true,
    ));

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
        ? const MiddleDebuggerStep(slowIndex: 0, fastIndex: 0, activeLine: 0, actionEn: "", actionBn: "", reasonEn: "", reasonBn: "")
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

            // Visual Nodes View
            _buildNodeVisualizationBox(step),
            const SizedBox(height: 16),

            // Real-Time C++ Code Line Highlight Debugger
            _buildCodeTraceWidget(step.activeLine),
            const SizedBox(height: 16),

            // Playback Controls
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

  Widget _buildNodeVisualizationBox(MiddleDebuggerStep step) {
    final n = _nodes.length;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Responsive.sp(context, 16)),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: step.isMiddleReached ? AppTheme.accentGreen : const Color(0xFF334155), width: step.isMiddleReached ? 2.0 : 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Execution State View: [1, 2, 3, 4, 5]", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: Responsive.sp(context, 14))),
              if (step.isMiddleReached)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: AppTheme.accentGreen.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                  child: Text("🎉 MIDDLE NODE: ${_nodes[step.slowIndex]}", style: const TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
            ],
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(n, (idx) {
                final val = _nodes[idx];
                final isSlow = step.slowIndex == idx;
                final isFast = step.fastIndex == idx;
                final isMiddle = step.isMiddleReached && isSlow;

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

                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: EdgeInsets.symmetric(horizontal: Responsive.sp(context, 12), vertical: Responsive.sp(context, 8)),
                  decoration: BoxDecoration(color: boxBg, borderRadius: BorderRadius.circular(10), border: Border.all(color: borderColor, width: 2)),
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
                      const SizedBox(height: 4),
                      Text('$val', style: TextStyle(fontSize: Responsive.sp(context, 16), fontWeight: FontWeight.bold, color: isMiddle ? AppTheme.accentGreen : Colors.white)),
                      const SizedBox(height: 4),
                      Text('idx $idx', style: TextStyle(fontSize: Responsive.sp(context, 9), color: AppTheme.textMuted)),
                    ],
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(Responsive.sp(context, 12)),
            decoration: BoxDecoration(
              color: step.isMiddleReached ? AppTheme.accentGreen.withOpacity(0.15) : AppTheme.primaryDark,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: step.isMiddleReached ? AppTheme.accentGreen : const Color(0xFF334155)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.isEnglish ? step.actionEn : step.actionBn, style: TextStyle(fontWeight: FontWeight.bold, color: step.isMiddleReached ? AppTheme.accentGreen : Colors.white, fontSize: Responsive.sp(context, 13))),
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
      "ListNode* middleNode(ListNode* head) {",
      "    ListNode* slow = head;",
      "    ListNode* fast = head;",
      "    while (fast != nullptr && fast->next != nullptr) {",
      "        slow = slow->next;        // Move 1 step",
      "        fast = fast->next->next;  // Move 2 steps",
      "    }",
      "    return slow;                 // Middle Node",
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
