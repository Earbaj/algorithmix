import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class RemoveDuplicatesDebuggerStep {
  final List<int> currentNodes;
  final int currIndex;
  final int activeLine;
  final String actionEn;
  final String actionBn;
  final String reasonEn;
  final String reasonBn;
  final bool isCompleted;

  const RemoveDuplicatesDebuggerStep({
    required this.currentNodes,
    required this.currIndex,
    required this.activeLine,
    required this.actionEn,
    required this.actionBn,
    required this.reasonEn,
    required this.reasonBn,
    this.isCompleted = false,
  });
}

class RemoveDuplicatesCodeDebuggerTab extends StatefulWidget {
  final bool isEnglish;

  const RemoveDuplicatesCodeDebuggerTab({
    super.key,
    required this.isEnglish,
  });

  @override
  State<RemoveDuplicatesCodeDebuggerTab> createState() => _RemoveDuplicatesCodeDebuggerTabState();
}

class _RemoveDuplicatesCodeDebuggerTabState extends State<RemoveDuplicatesCodeDebuggerTab> {
  final List<int> _nodes = [1, 1, 2, 3, 3];
  List<RemoveDuplicatesDebuggerStep> _steps = [];

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

  List<RemoveDuplicatesDebuggerStep> _generateSteps(List<int> nodes) {
    List<RemoveDuplicatesDebuggerStep> steps = [];
    List<int> state = List.from(nodes);
    if (state.isEmpty) return steps;

    int idx = 0;

    steps.add(RemoveDuplicatesDebuggerStep(
      currentNodes: List.from(state),
      currIndex: idx,
      activeLine: 2,
      actionEn: "Line 2: ListNode* curr = head; (idx 0, val: ${state[0]})",
      actionBn: "লাইন ২: ListNode* curr = head; (ইনডেক্স 0, মান: ${state[0]})",
      reasonEn: "Pointer starts at head node.",
      reasonBn: "পয়েন্টার হেডে বসানো হলো।",
    ));

    while (idx < state.length - 1) {
      steps.add(RemoveDuplicatesDebuggerStep(
        currentNodes: List.from(state),
        currIndex: idx,
        activeLine: 3,
        actionEn: "Line 3: while (curr != nullptr && curr->next != nullptr) → TRUE",
        actionBn: "লাইন ৩: while (curr != nullptr && curr->next != nullptr) → সত্য",
        reasonEn: "List has nodes ahead to check.",
        reasonBn: "পরের নোড ট্রাভার্স করা বাকি রয়েছে।",
      ));

      steps.add(RemoveDuplicatesDebuggerStep(
        currentNodes: List.from(state),
        currIndex: idx,
        activeLine: 4,
        actionEn: "Line 4: if (curr->val == curr->next->val) → ${state[idx] == state[idx + 1]}",
        actionBn: "লাইন ৪: if (curr->val == curr->next->val) → ${state[idx] == state[idx + 1]}",
        reasonEn: "Compare current value with next value.",
        reasonBn: "বর্তমান মান ও পরের নোডের মান তুলনা করা হলো।",
      ));

      if (state[idx] == state[idx + 1]) {
        int dupVal = state[idx + 1];
        state.removeAt(idx + 1);

        steps.add(RemoveDuplicatesDebuggerStep(
          currentNodes: List.from(state),
          currIndex: idx,
          activeLine: 5,
          actionEn: "Line 5: curr->next = curr->next->next; → Bypass duplicate $dupVal",
          actionBn: "লাইন ৫: curr->next = curr->next->next; → ডুপ্লিকেট $dupVal বাইপাসড",
          reasonEn: "Bypass duplicate node pointer.",
          reasonBn: "ডুপ্লিকেট পয়েন্টারটি রিমুভ করা হলো।",
        ));
      } else {
        idx++;
        steps.add(RemoveDuplicatesDebuggerStep(
          currentNodes: List.from(state),
          currIndex: idx,
          activeLine: 7,
          actionEn: "Line 7: curr = curr->next; → curr moves to idx $idx (val: ${state[idx]})",
          actionBn: "লাইন ৭: curr = curr->next; → curr ইনডেক্স $idx এ এগিয়ে গেলো",
          reasonEn: "Advance pointer forward.",
          reasonBn: "পয়েন্টার পরের অনন্য নোডে নেয়া হলো।",
        ));
      }
    }

    steps.add(RemoveDuplicatesDebuggerStep(
      currentNodes: List.from(state),
      currIndex: idx,
      activeLine: 10,
      actionEn: "Line 10: 🎉 return head; → List: $state",
      actionBn: "লাইন ১০: 🎉 return head; → লিস্ট: $state",
      reasonEn: "Return head of modified unique linked list.",
      reasonBn: "ডুপ্লিকেট মুক্ত সর্টেড লিঙ্কড লিস্ট রিটার্ন করা হলো।",
      isCompleted: true,
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
        ? RemoveDuplicatesDebuggerStep(currentNodes: _nodes, currIndex: 0, activeLine: 0, actionEn: "", actionBn: "", reasonEn: "", reasonBn: "")
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

  Widget _buildNodeVisualizationBox(RemoveDuplicatesDebuggerStep step) {
    final nodes = step.currentNodes;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Responsive.sp(context, 16)),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: step.isCompleted ? AppTheme.accentGreen : const Color(0xFF334155), width: step.isCompleted ? 2.0 : 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Execution State View", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: Responsive.sp(context, 14))),
              if (step.isCompleted)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: AppTheme.accentGreen.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                  child: const Text("🎉 REMOVAL COMPLETED", style: TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
            ],
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(nodes.length, (idx) {
                final val = nodes[idx];
                final isCurr = step.currIndex == idx;
                final isCompleted = step.isCompleted;

                Color boxBg = AppTheme.primaryDark;
                Color borderColor = const Color(0xFF334155);

                if (isCompleted) {
                  boxBg = AppTheme.accentGreen.withOpacity(0.35);
                  borderColor = AppTheme.accentGreen;
                } else if (isCurr) {
                  boxBg = AppTheme.accentNeonCyan.withOpacity(0.25);
                  borderColor = AppTheme.accentNeonCyan;
                }

                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: EdgeInsets.symmetric(horizontal: Responsive.sp(context, 14), vertical: Responsive.sp(context, 10)),
                  decoration: BoxDecoration(color: boxBg, borderRadius: BorderRadius.circular(10), border: Border.all(color: borderColor, width: 2)),
                  child: Column(
                    children: [
                      if (isCurr)
                        Text('curr 📍', style: TextStyle(fontSize: Responsive.sp(context, 10), color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold))
                      else
                        Text(' ', style: TextStyle(fontSize: Responsive.sp(context, 10))),
                      const SizedBox(height: 4),
                      Text('$val', style: TextStyle(fontSize: Responsive.sp(context, 16), fontWeight: FontWeight.bold, color: isCompleted ? AppTheme.accentGreen : Colors.white)),
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
              color: step.isCompleted ? AppTheme.accentGreen.withOpacity(0.15) : AppTheme.primaryDark,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: step.isCompleted ? AppTheme.accentGreen : const Color(0xFF334155)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.isEnglish ? step.actionEn : step.actionBn, style: TextStyle(fontWeight: FontWeight.bold, color: step.isCompleted ? AppTheme.accentGreen : Colors.white, fontSize: Responsive.sp(context, 13))),
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
      "ListNode* deleteDuplicates(ListNode* head) {",
      "    ListNode* curr = head;",
      "    while (curr != nullptr && curr->next != nullptr) {",
      "        if (curr->val == curr->next->val) {",
      "            curr->next = curr->next->next; // Bypass duplicate",
      "        } else {",
      "            curr = curr->next;             // Advance pointer",
      "        }",
      "    }",
      "    return head;",
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
