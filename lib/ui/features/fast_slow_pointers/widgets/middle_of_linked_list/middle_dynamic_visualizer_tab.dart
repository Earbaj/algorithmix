import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class MiddleStepData {
  final int slowIndex;
  final int fastIndex;
  final String actionEn;
  final String actionBn;
  final String reasonEn;
  final String reasonBn;
  final bool isMiddleReached;

  const MiddleStepData({
    required this.slowIndex,
    required this.fastIndex,
    required this.actionEn,
    required this.actionBn,
    required this.reasonEn,
    required this.reasonBn,
    this.isMiddleReached = false,
  });
}

class MiddleDynamicVisualizerTab extends StatefulWidget {
  final bool isEnglish;

  const MiddleDynamicVisualizerTab({
    super.key,
    required this.isEnglish,
  });

  @override
  State<MiddleDynamicVisualizerTab> createState() => _MiddleDynamicVisualizerTabState();
}

class _MiddleDynamicVisualizerTabState extends State<MiddleDynamicVisualizerTab> {
  final TextEditingController _nodesController =
      TextEditingController(text: "1, 2, 3, 4, 5");

  List<int> _currentNodes = [1, 2, 3, 4, 5];
  List<MiddleStepData> _steps = [];

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
      if (parsed.isEmpty) parsed = [1, 2, 3, 4, 5];
      _currentNodes = parsed;
    } catch (_) {
      _currentNodes = [1, 2, 3, 4, 5];
    }

    _steps = _generateSteps(_currentNodes);
    setState(() {});
  }

  List<MiddleStepData> _generateSteps(List<int> nodes) {
    List<MiddleStepData> steps = [];
    int n = nodes.length;
    if (n == 0) return steps;

    int slow = 0;
    int fast = 0;

    steps.add(MiddleStepData(
      slowIndex: slow,
      fastIndex: fast,
      actionEn: "Initialize slow = head, fast = head (idx 0, val: ${nodes[0]})",
      actionBn: "slow = head, fast = head সূচনা (ইনডেক্স 0, মান: ${nodes[0]})",
      reasonEn: "Both pointers start at head node.",
      reasonBn: "উভয় পয়েন্টার শুরুর নোডে বসানো হলো।",
    ));

    while (fast < n && fast + 1 < n) {
      slow += 1;
      fast += 2;

      steps.add(MiddleStepData(
        slowIndex: slow,
        fastIndex: fast < n ? fast : n - 1,
        actionEn: "Slow is at idx $slow (val: ${nodes[slow]}), Fast is at idx ${fast < n ? fast : 'end (null)'}",
        actionBn: "Slow ইনডেক্স $slow এ (মান: ${nodes[slow]}), Fast ইনডেক্স ${fast < n ? fast : 'শেষে (null)'} এ",
        reasonEn: "Slow moved 1 step, Fast moved 2 steps.",
        reasonBn: "Slow ১ ধাপ এবং Fast ২ ধাপ হেঁটেছে।",
      ));
    }

    steps.add(MiddleStepData(
      slowIndex: slow,
      fastIndex: fast < n ? fast : n - 1,
      actionEn: "🎉 RETURN SLOW → Middle Node found at idx $slow (val: ${nodes[slow]})",
      actionBn: "🎉 RETURN SLOW → মিডল নোড ইনডেক্স $slow এ পাওয়া গেছে (মান: ${nodes[slow]})",
      reasonEn: "When fast reaches end, slow is guaranteed to point exactly at the middle node!",
      reasonBn: "Fast যখন শেষে পৌঁছায়, Slow ঠিক মাঝের নোডটিকে পয়েন্ট করে!",
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

  void _loadPreset(List<int> nodes) {
    _nodesController.text = nodes.join(', ');
    _rebuildSteps();
  }

  @override
  Widget build(BuildContext context) {
    final hPadding = Responsive.horizontalPadding(context);
    final step = _steps.isEmpty
        ? const MiddleStepData(slowIndex: 0, fastIndex: 0, actionEn: "", actionBn: "", reasonEn: "", reasonBn: "")
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
                    widget.isEnglish ? 'Dynamic Custom Input & Test Cases' : 'ডায়নামিক ইনপুট ও টেস্ট কেস',
                    style: TextStyle(fontSize: Responsive.sp(context, 16), fontWeight: FontWeight.bold, color: AppTheme.accentNeonCyan),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _nodesController,
                    style: TextStyle(color: Colors.white, fontFamily: 'monospace', fontSize: Responsive.sp(context, 13)),
                    decoration: InputDecoration(labelText: widget.isEnglish ? 'Linked List Nodes (comma separated)' : 'লিঙ্কড লিস্টের নোডসমূহ', hintText: '1, 2, 3, 4, 5'),
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Text('Presets: ', style: TextStyle(color: AppTheme.textMuted, fontSize: Responsive.sp(context, 12))),
                        _buildPresetChip('[1, 2, 3, 4, 5] (Odd)', [1, 2, 3, 4, 5]),
                        _buildPresetChip('[1, 2, 3, 4, 5, 6] (Even)', [1, 2, 3, 4, 5, 6]),
                        _buildPresetChip('[10, 20, 30] (Short)', [10, 20, 30]),
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

            // Pure Node Visualization Box
            _buildNodeVisualizationBox(step),
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

  Widget _buildNodeVisualizationBox(MiddleStepData step) {
    final n = _currentNodes.length;

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
          Text("Linked List Nodes View", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: Responsive.sp(context, 14))),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(n, (idx) {
                final val = _currentNodes[idx];
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
