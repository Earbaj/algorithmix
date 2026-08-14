import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class PalindromeStepData {
  final int p1Index;
  final int p2Index;
  final String actionEn;
  final String actionBn;
  final String reasonEn;
  final String reasonBn;
  final bool isPalindrome;
  final bool isMismatch;

  const PalindromeStepData({
    required this.p1Index,
    required this.p2Index,
    required this.actionEn,
    required this.actionBn,
    required this.reasonEn,
    required this.reasonBn,
    this.isPalindrome = false,
    this.isMismatch = false,
  });
}

class PalindromeDynamicVisualizerTab extends StatefulWidget {
  final bool isEnglish;

  const PalindromeDynamicVisualizerTab({
    super.key,
    required this.isEnglish,
  });

  @override
  State<PalindromeDynamicVisualizerTab> createState() => _PalindromeDynamicVisualizerTabState();
}

class _PalindromeDynamicVisualizerTabState extends State<PalindromeDynamicVisualizerTab> {
  final TextEditingController _nodesController =
      TextEditingController(text: "1, 2, 2, 1");

  List<int> _currentNodes = [1, 2, 2, 1];
  List<PalindromeStepData> _steps = [];

  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _rebuildSteps();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _nodesController.dispose();
    super.dispose();
  }

  void _rebuildSteps() {
    _timer?.cancel();
    _isPlaying = false;
    _currentStepIndex = 0;

    try {
      List<int> parsed = _nodesController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .map((e) => int.parse(e))
          .toList();
      if (parsed.isEmpty) parsed = [1, 2, 2, 1];
      _currentNodes = parsed;
    } catch (_) {
      _currentNodes = [1, 2, 2, 1];
    }

    _steps = _generateSteps(_currentNodes);
    setState(() {});
  }

  List<PalindromeStepData> _generateSteps(List<int> nodes) {
    List<PalindromeStepData> steps = [];
    int n = nodes.length;
    if (n == 0) return steps;

    int left = 0;
    int right = n - 1;

    steps.add(PalindromeStepData(
      p1Index: left,
      p2Index: right,
      actionEn: "Initialize p1 = head (idx 0, val: ${nodes[0]}), p2 = reversed 2nd half head (idx $right, val: ${nodes[right]})",
      actionBn: "p1 = head (ইনডেক্স 0, মান: ${nodes[0]}), p2 = উল্টানো ২য় অর্ধাংশের হেড (ইনডেক্স $right, মান: ${nodes[right]}) সূচনা",
      reasonEn: "Prepare pointers at start of 1st half and reversed 2nd half.",
      reasonBn: "১ম ও উল্টানো ২য় অর্ধাংশের শুরুতে পয়েন্টার বসানো হলো।",
    ));

    bool isPalin = true;

    while (left < right) {
      if (nodes[left] != nodes[right]) {
        isPalin = false;
        steps.add(PalindromeStepData(
          p1Index: left,
          p2Index: right,
          actionEn: "❌ MISMATCH! p1 (val: ${nodes[left]}) != p2 (val: ${nodes[right]}) → NOT PALINDROME",
          actionBn: "❌ অমিল! p1 (মান: ${nodes[left]}) != p2 (মান: ${nodes[right]}) → প্যালিনড্রোম নয়",
          reasonEn: "Corresponding node values do not match. Return false.",
          reasonBn: "অনুরূপ নোডের মান সমান নয়। false রিটার্ন করা হলো।",
          isMismatch: true,
        ));
        break;
      }

      steps.add(PalindromeStepData(
        p1Index: left,
        p2Index: right,
        actionEn: "MATCH! p1 (val: ${nodes[left]}) == p2 (val: ${nodes[right]})",
        actionBn: "মিল পাওয়া গেছে! p1 (মান: ${nodes[left]}) == p2 (মান: ${nodes[right]})",
        reasonEn: "Values match! Advance p1 forward and p2 backward.",
        reasonBn: "মান দুটি সমান! p1 কে সামনে এবং p2 কে পেছনে অগ্রসর করুন।",
      ));

      left++;
      right--;
    }

    if (isPalin) {
      steps.add(PalindromeStepData(
        p1Index: left,
        p2Index: right,
        actionEn: "🎉 PALINDROME CONFIRMED! All elements matched! Return true!",
        actionBn: "🎉 প্যালিনড্রোম নিশ্চিত! সকল উপাদানের মান মিলেছে! Return true!",
        reasonEn: "Reached middle with zero mismatches.",
        reasonBn: "কোনো অমিল ছাড়াই সম্পূর্ণ লিস্ট যাচাই করা শেষ।",
        isPalindrome: true,
      ));
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

  void _loadPreset(List<int> nodes) {
    _nodesController.text = nodes.join(', ');
    _rebuildSteps();
  }

  @override
  Widget build(BuildContext context) {
    final hPadding = Responsive.horizontalPadding(context);
    final step = _steps.isEmpty
        ? PalindromeStepData(p1Index: 0, p2Index: 0, actionEn: "", actionBn: "", reasonEn: "", reasonBn: "")
        : _steps[_currentStepIndex];

    return ResponsiveCenter(
      maxWidth: 1280.0,
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(Responsive.sp(context, 16)),
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.accentNeonCyan.withOpacity(0.4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.isEnglish ? '⚙️ Dynamic Custom Input & Test Cases' : '⚙️ ডায়নামিক ইনপুট ও টেস্ট কেস',
                    style: TextStyle(fontSize: Responsive.sp(context, 16), fontWeight: FontWeight.bold, color: AppTheme.accentNeonCyan),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _nodesController,
                    style: TextStyle(color: Colors.white, fontFamily: 'monospace', fontSize: Responsive.sp(context, 13)),
                    decoration: InputDecoration(labelText: widget.isEnglish ? 'Nodes (comma separated)' : 'নোডসমূহ (কমা দিয়ে পৃথকীকৃত)', hintText: '1, 2, 2, 1'),
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Text('Presets: ', style: TextStyle(color: AppTheme.textMuted, fontSize: Responsive.sp(context, 12))),
                        _buildPresetChip('[1, 2, 2, 1] (Palindrome 🎉)', [1, 2, 2, 1]),
                        _buildPresetChip('[1, 2, 3, 2, 1] (Odd Palindrome 🎉)', [1, 2, 3, 2, 1]),
                        _buildPresetChip('[1, 2, 3] (Not Palindrome ❌)', [1, 2, 3]),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: _rebuildSteps,
                    icon: Icon(Icons.bolt, color: Colors.white, size: Responsive.sp(context, 18)),
                    label: Text(widget.isEnglish ? 'Run Dynamic Visualizer' : 'ভিজ্যুয়ালাইজার রান করুন', style: TextStyle(fontSize: Responsive.sp(context, 14), fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentPurple),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            _buildNodeVisualizationBox(step),
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

  Widget _buildNodeVisualizationBox(PalindromeStepData step) {
    final nodes = _currentNodes;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Responsive.sp(context, 16)),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: step.isPalindrome ? AppTheme.accentGreen : (step.isMismatch ? AppTheme.accentPink : const Color(0xFF334155)),
          width: (step.isPalindrome || step.isMismatch) ? 2.0 : 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Linked List View", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: Responsive.sp(context, 14))),
              if (step.isPalindrome)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: AppTheme.accentGreen.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                  child: const Text("🎉 IS PALINDROME", style: TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 12)),
                )
              else if (step.isMismatch)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: AppTheme.accentPink.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                  child: const Text("❌ NOT PALINDROME", style: TextStyle(color: AppTheme.accentPink, fontWeight: FontWeight.bold, fontSize: 12)),
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
              color: step.isPalindrome ? AppTheme.accentGreen.withOpacity(0.15) : (step.isMismatch ? AppTheme.accentPink.withOpacity(0.15) : AppTheme.primaryDark),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: step.isPalindrome ? AppTheme.accentGreen : (step.isMismatch ? AppTheme.accentPink : const Color(0xFF334155))),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.isEnglish ? step.actionEn : step.actionBn, style: TextStyle(fontWeight: FontWeight.bold, color: step.isPalindrome ? AppTheme.accentGreen : (step.isMismatch ? AppTheme.accentPink : Colors.white), fontSize: Responsive.sp(context, 13))),
                const SizedBox(height: 4),
                Text(widget.isEnglish ? step.reasonEn : step.reasonBn, style: TextStyle(color: AppTheme.textSecondary, fontSize: Responsive.sp(context, 12), height: 1.3)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPresetChip(String label, List<int> nodes) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ActionChip(
        label: Text(label, style: TextStyle(fontSize: Responsive.sp(context, 11), color: Colors.white)),
        backgroundColor: AppTheme.primaryDark,
        onPressed: () => _loadPreset(nodes),
      ),
    );
  }
}
