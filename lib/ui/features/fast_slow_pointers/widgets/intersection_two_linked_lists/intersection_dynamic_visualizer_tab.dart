import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class IntersectionStepData {
  final String pAVal;
  final String pBVal;
  final String actionEn;
  final String actionBn;
  final String reasonEn;
  final String reasonBn;
  final bool isIntersected;
  final bool isNoIntersect;

  const IntersectionStepData({
    required this.pAVal,
    required this.pBVal,
    required this.actionEn,
    required this.actionBn,
    required this.reasonEn,
    required this.reasonBn,
    this.isIntersected = false,
    this.isNoIntersect = false,
  });
}

class IntersectionDynamicVisualizerTab extends StatefulWidget {
  final bool isEnglish;

  const IntersectionDynamicVisualizerTab({
    super.key,
    required this.isEnglish,
  });

  @override
  State<IntersectionDynamicVisualizerTab> createState() => _IntersectionDynamicVisualizerTabState();
}

class _IntersectionDynamicVisualizerTabState extends State<IntersectionDynamicVisualizerTab> {
  final TextEditingController _listAController = TextEditingController(text: "4, 1");
  final TextEditingController _listBController = TextEditingController(text: "5, 6, 1");
  final TextEditingController _commonController = TextEditingController(text: "8, 4, 5");

  List<IntersectionStepData> _steps = [];

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
    _listAController.dispose();
    _listBController.dispose();
    _commonController.dispose();
    super.dispose();
  }

  void _rebuildSteps() {
    _timer?.cancel();
    _isPlaying = false;
    _currentStepIndex = 0;

    List<int> listA = _parseInput(_listAController.text, [4, 1]);
    List<int> listB = _parseInput(_listBController.text, [5, 6, 1]);
    List<int> common = _parseInput(_commonController.text, [8, 4, 5]);

    _steps = _generateSteps(listA, listB, common);
    setState(() {});
  }

  List<int> _parseInput(String text, List<int> fallback) {
    try {
      List<int> parsed = text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .map((e) => int.parse(e))
          .toList();
      return parsed;
    } catch (_) {
      return fallback;
    }
  }

  List<IntersectionStepData> _generateSteps(List<int> listA, List<int> listB, List<int> common) {
    List<IntersectionStepData> steps = [];

    List<int> fullA = [...listA, ...common];
    List<int> fullB = [...listB, ...common];

    steps.add(IntersectionStepData(
      pAVal: fullA.isNotEmpty ? "${fullA[0]}" : "null",
      pBVal: fullB.isNotEmpty ? "${fullB[0]}" : "null",
      actionEn: "Initialize pA at headA [${fullA.isNotEmpty ? fullA[0] : 'null'}], pB at headB [${fullB.isNotEmpty ? fullB[0] : 'null'}]",
      actionBn: "pA কে headA [${fullA.isNotEmpty ? fullA[0] : 'null'}] এবং pB কে headB [${fullB.isNotEmpty ? fullB[0] : 'null'}] সূচনা",
      reasonEn: "Pointers set at initial heads of List A and List B.",
      reasonBn: "উভয় লিস্টের শুরুতে পয়েন্টার দ্বয়কে বসানো হলো।",
    ));

    // Simulate pointer switching
    List<dynamic> pathA = [...fullA, null, ...fullB, null];
    List<dynamic> pathB = [...fullB, null, ...fullA, null];

    int maxSteps = pathA.length < pathB.length ? pathA.length : pathB.length;

    for (int i = 1; i < maxSteps; i++) {
      var valA = pathA[i];
      var valB = pathB[i];

      bool isMatch = (valA != null && valB != null && valA == valB && i >= (fullA.length - common.length));

      steps.add(IntersectionStepData(
        pAVal: valA == null ? "null (End -> Switch Head)" : "$valA",
        pBVal: valB == null ? "null (End -> Switch Head)" : "$valB",
        actionEn: isMatch
            ? "🎉 COLLISION MATCH! Both pointers meet at Intersection Node [$valA]!"
            : "pA is at ${valA ?? 'headB'}, pB is at ${valB ?? 'headA'}",
        actionBn: isMatch
            ? "🎉 ইন্টারসেকশন মিল! pA ও pB উভয়ই একই নোড [$valA] এ এসে মিলিত হয়েছে!"
            : "pA আছে ${valA ?? 'headB'} এ, pB আছে ${valB ?? 'headA'} এ",
        reasonEn: isMatch
            ? "Equal path distance lenA + lenB brings both pointers together!"
            : "Advance 1 step forward (or switch head if null reached).",
        reasonBn: isMatch
            ? "সমান দূরত্বের সমীকরণে উভয় পয়েন্টার ইন্টারসেকশন পয়েন্টে চলে আসলো!"
            : "১ ধাপ সামনে বা শেষে পৌঁছালে অন্য হেডে সুইস করা হচ্ছে।",
        isIntersected: isMatch,
      ));

      if (isMatch) break;
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

  void _loadPreset(String a, String b, String common) {
    _listAController.text = a;
    _listBController.text = b;
    _commonController.text = common;
    _rebuildSteps();
  }

  @override
  Widget build(BuildContext context) {
    final hPadding = Responsive.horizontalPadding(context);
    final step = _steps.isEmpty
        ? const IntersectionStepData(pAVal: "", pBVal: "", actionEn: "", actionBn: "", reasonEn: "", reasonBn: "")
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
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _listAController,
                          style: TextStyle(color: Colors.white, fontFamily: 'monospace', fontSize: Responsive.sp(context, 12)),
                          decoration: const InputDecoration(labelText: 'List A Prefix', hintText: '4, 1'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _listBController,
                          style: TextStyle(color: Colors.white, fontFamily: 'monospace', fontSize: Responsive.sp(context, 12)),
                          decoration: const InputDecoration(labelText: 'List B Prefix', hintText: '5, 6, 1'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _commonController,
                          style: TextStyle(color: Colors.white, fontFamily: 'monospace', fontSize: Responsive.sp(context, 12)),
                          decoration: const InputDecoration(labelText: 'Common Suffix', hintText: '8, 4, 5'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Text('Presets: ', style: TextStyle(color: AppTheme.textMuted, fontSize: Responsive.sp(context, 12))),
                        _buildPresetChip('Intersect at 8 🎉', '4, 1', '5, 6, 1', '8, 4, 5'),
                        _buildPresetChip('Intersect at 2 🎉', '1, 9, 1', '3', '2, 4'),
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

  Widget _buildNodeVisualizationBox(IntersectionStepData step) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Responsive.sp(context, 16)),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: step.isIntersected ? AppTheme.accentGreen : const Color(0xFF334155), width: step.isIntersected ? 2.0 : 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Pointer Track View", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: Responsive.sp(context, 14))),
              if (step.isIntersected)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: AppTheme.accentGreen.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                  child: const Text("🎉 INTERSECTION NODE MATCH!", style: TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 12)),
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
                      Text('Pointer pA', style: TextStyle(fontSize: Responsive.sp(context, 11), color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text(step.pAVal, style: TextStyle(fontSize: Responsive.sp(context, 16), fontWeight: FontWeight.bold, color: Colors.white)),
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
                      Text('Pointer pB', style: TextStyle(fontSize: Responsive.sp(context, 11), color: AppTheme.accentPurple, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text(step.pBVal, style: TextStyle(fontSize: Responsive.sp(context, 16), fontWeight: FontWeight.bold, color: Colors.white)),
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
              color: step.isIntersected ? AppTheme.accentGreen.withOpacity(0.15) : AppTheme.primaryDark,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: step.isIntersected ? AppTheme.accentGreen : const Color(0xFF334155)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.isEnglish ? step.actionEn : step.actionBn, style: TextStyle(fontWeight: FontWeight.bold, color: step.isIntersected ? AppTheme.accentGreen : Colors.white, fontSize: Responsive.sp(context, 13))),
                const SizedBox(height: 4),
                Text(widget.isEnglish ? step.reasonEn : step.reasonBn, style: TextStyle(color: AppTheme.textSecondary, fontSize: Responsive.sp(context, 12), height: 1.3)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPresetChip(String label, String a, String b, String common) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ActionChip(
        label: Text(label, style: TextStyle(fontSize: Responsive.sp(context, 11), color: Colors.white)),
        backgroundColor: AppTheme.primaryDark,
        onPressed: () => _loadPreset(a, b, common),
      ),
    );
  }
}
