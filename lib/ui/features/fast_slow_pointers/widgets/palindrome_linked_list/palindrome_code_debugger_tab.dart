import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class PalindromeDebuggerStep {
  final List<int> nodes;
  final int p1Index;
  final int p2Index;
  final int activeLine;
  final String actionEn;
  final String actionBn;
  final String reasonEn;
  final String reasonBn;
  final bool isPalindrome;

  const PalindromeDebuggerStep({
    required this.nodes,
    required this.p1Index,
    required this.p2Index,
    required this.activeLine,
    required this.actionEn,
    required this.actionBn,
    required this.reasonEn,
    required this.reasonBn,
    this.isPalindrome = false,
  });
}

class PalindromeCodeDebuggerTab extends StatefulWidget {
  final bool isEnglish;

  const PalindromeCodeDebuggerTab({
    super.key,
    required this.isEnglish,
  });

  @override
  State<PalindromeCodeDebuggerTab> createState() => _PalindromeCodeDebuggerTabState();
}

class _PalindromeCodeDebuggerTabState extends State<PalindromeCodeDebuggerTab> {
  final List<int> _nodes = [1, 2, 2, 1];
  List<PalindromeDebuggerStep> _steps = [];

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

  List<PalindromeDebuggerStep> _generateSteps(List<int> nodes) {
    List<PalindromeDebuggerStep> steps = [];
    int n = nodes.length;

    steps.add(PalindromeDebuggerStep(
      nodes: nodes,
      p1Index: 0,
      p2Index: 0,
      activeLine: 2,
      actionEn: "Line 2: ListNode* slow = getMiddle(head);",
      actionBn: "লাইন ২: ListNode* slow = getMiddle(head); (মিডল নির্ণয়)",
      reasonEn: "Locate middle node using Fast & Slow pointers.",
      reasonBn: "Fast ও Slow পয়েন্টার দিয়ে মাঝের নোডটি বের করা হলো।",
    ));

    steps.add(PalindromeDebuggerStep(
      nodes: nodes,
      p1Index: 0,
      p2Index: n - 1,
      activeLine: 3,
      actionEn: "Line 3: ListNode* secondHalf = reverseList(slow);",
      actionBn: "লাইন ৩: ListNode* secondHalf = reverseList(slow); (২য় অর্ধাংশ উল্টানো)",
      reasonEn: "Reverse 2nd half of linked list in-place.",
      reasonBn: "২য় অর্ধাংশের নোডগুলো In-Place রিভার্স করা হলো।",
    ));

    steps.add(PalindromeDebuggerStep(
      nodes: nodes,
      p1Index: 0,
      p2Index: 3,
      activeLine: 5,
      actionEn: "Line 5: p1 (val 1) == p2 (val 1) → MATCH!",
      actionBn: "লাইন ৫: p1 (মান ১) == p2 (মান ১) → মিল পাওয়া গেছে!",
      reasonEn: "Check front and reversed back values.",
      reasonBn: "সামনের ও উল্টানো পেছনের মানগুলো তুলনা করা হচ্ছে।",
    ));

    steps.add(PalindromeDebuggerStep(
      nodes: nodes,
      p1Index: 1,
      p2Index: 2,
      activeLine: 6,
      actionEn: "Line 6: p1 = p1->next; p2 = p2->next; → p1 (val 2) == p2 (val 2)",
      actionBn: "লাইন ৬: p1 = p1->next; p2 = p2->next; → p1 (মান ২) == p2 (মান ২)",
      reasonEn: "Advance both pointers.",
      reasonBn: "উভয় পয়েন্টার সামনে নেয়া হলো।",
    ));

    steps.add(PalindromeDebuggerStep(
      nodes: nodes,
      p1Index: 1,
      p2Index: 2,
      activeLine: 9,
      actionEn: "Line 9: 🎉 return true; → IS PALINDROME",
      actionBn: "লাইন ৯: 🎉 return true; → প্যালিনড্রোম লিঙ্কড লিস্ট!",
      reasonEn: "All pairs matched successfully. Return true.",
      reasonBn: "সকল নোড জোড়া মিলে গেছে। true রিটার্ন করা হলো।",
      isPalindrome: true,
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
        ? PalindromeDebuggerStep(nodes: _nodes, p1Index: 0, p2Index: 0, activeLine: 0, actionEn: "", actionBn: "", reasonEn: "", reasonBn: "")
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

            _buildNodeVisualizationBox(step),
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

  Widget _buildNodeVisualizationBox(PalindromeDebuggerStep step) {
    final nodes = step.nodes;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Responsive.sp(context, 16)),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: step.isPalindrome ? AppTheme.accentGreen : const Color(0xFF334155), width: step.isPalindrome ? 2.0 : 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Execution State View: [1, 2, 2, 1]", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: Responsive.sp(context, 14))),
              if (step.isPalindrome)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: AppTheme.accentGreen.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                  child: const Text("🎉 PALINDROME MATCH!", style: TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
            ],
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(nodes.length, (idx) {
                final val = nodes[idx];
                final isP1 = step.p1Index == idx;
                final isP2 = step.p2Index == idx;
                final isPalindrome = step.isPalindrome;

                Color boxBg = AppTheme.primaryDark;
                Color borderColor = const Color(0xFF334155);

                if (isPalindrome) {
                  boxBg = AppTheme.accentGreen.withOpacity(0.35);
                  borderColor = AppTheme.accentGreen;
                } else if (isP1 && isP2) {
                  boxBg = AppTheme.accentAmber.withOpacity(0.35);
                  borderColor = AppTheme.accentAmber;
                } else if (isP1) {
                  boxBg = AppTheme.accentNeonCyan.withOpacity(0.25);
                  borderColor = AppTheme.accentNeonCyan;
                } else if (isP2) {
                  boxBg = AppTheme.accentPurple.withOpacity(0.25);
                  borderColor = AppTheme.accentPurple;
                }

                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: EdgeInsets.symmetric(horizontal: Responsive.sp(context, 14), vertical: Responsive.sp(context, 10)),
                  decoration: BoxDecoration(color: boxBg, borderRadius: BorderRadius.circular(10), border: Border.all(color: borderColor, width: 2)),
                  child: Column(
                    children: [
                      if (isP1 && isP2)
                        Text('P1 & P2', style: TextStyle(fontSize: Responsive.sp(context, 10), color: AppTheme.accentAmber, fontWeight: FontWeight.bold))
                      else if (isP1)
                        Text('P1 📍', style: TextStyle(fontSize: Responsive.sp(context, 10), color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold))
                      else if (isP2)
                        Text('P2 📍', style: TextStyle(fontSize: Responsive.sp(context, 10), color: AppTheme.accentPurple, fontWeight: FontWeight.bold))
                      else
                        Text(' ', style: TextStyle(fontSize: Responsive.sp(context, 10))),
                      const SizedBox(height: 4),
                      Text('$val', style: TextStyle(fontSize: Responsive.sp(context, 16), fontWeight: FontWeight.bold, color: isPalindrome ? AppTheme.accentGreen : Colors.white)),
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
              color: step.isPalindrome ? AppTheme.accentGreen.withOpacity(0.15) : AppTheme.primaryDark,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: step.isPalindrome ? AppTheme.accentGreen : const Color(0xFF334155)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.isEnglish ? step.actionEn : step.actionBn, style: TextStyle(fontWeight: FontWeight.bold, color: step.isPalindrome ? AppTheme.accentGreen : Colors.white, fontSize: Responsive.sp(context, 13))),
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
      "bool isPalindrome(ListNode* head) {",
      "    ListNode* slow = getMiddle(head);",
      "    ListNode* p2 = reverseList(slow);",
      "    ListNode* p1 = head;",
      "    while (p2 != nullptr) {",
      "        if (p1->val != p2->val) return false;",
      "        p1 = p1->next; p2 = p2->next;",
      "    }",
      "    return true;",
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
