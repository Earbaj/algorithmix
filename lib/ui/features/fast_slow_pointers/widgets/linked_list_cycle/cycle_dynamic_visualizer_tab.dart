import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class CycleStepData {
  final int slowIndex;
  final int fastIndex;
  final String actionEn;
  final String actionBn;
  final String reasonEn;
  final String reasonBn;
  final bool isCollision;

  const CycleStepData({
    required this.slowIndex,
    required this.fastIndex,
    required this.actionEn,
    required this.actionBn,
    required this.reasonEn,
    required this.reasonBn,
    this.isCollision = false,
  });
}

class CycleDynamicVisualizerTab extends StatefulWidget {
  final bool isEnglish;

  const CycleDynamicVisualizerTab({
    super.key,
    required this.isEnglish,
  });

  @override
  State<CycleDynamicVisualizerTab> createState() => _CycleDynamicVisualizerTabState();
}

class _CycleDynamicVisualizerTabState extends State<CycleDynamicVisualizerTab> {
  final TextEditingController _nodesController =
      TextEditingController(text: "3, 2, 0, -4");
  final TextEditingController _posController =
      TextEditingController(text: "1");

  List<int> _currentNodes = [3, 2, 0, -4];
  int _cyclePos = 1;
  List<CycleStepData> _steps = [];

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
    _posController.dispose();
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
      if (parsed.isEmpty) parsed = [3, 2, 0, -4];
      _currentNodes = parsed;
    } catch (_) {
      _currentNodes = [3, 2, 0, -4];
    }

    try {
      _cyclePos = int.parse(_posController.text.trim());
      if (_cyclePos >= _currentNodes.length) {
        _cyclePos = _currentNodes.length - 1;
      }
    } catch (_) {
      _cyclePos = 1;
    }

    _steps = _generateSteps(_currentNodes, _cyclePos);
    setState(() {});
  }

  List<CycleStepData> _generateSteps(List<int> nodes, int pos) {
    List<CycleStepData> steps = [];
    int n = nodes.length;
    if (n == 0) return steps;

    int slow = 0;
    int fast = 0;

    steps.add(CycleStepData(
      slowIndex: slow,
      fastIndex: fast,
      actionEn: "Initialize slow = head, fast = head (idx 0, val: ${nodes[0]})",
      actionBn: "slow = head, fast = head সূচনা (ইনডেক্স 0, মান: ${nodes[0]})",
      reasonEn: "Both pointers start at head node.",
      reasonBn: "উভয় পয়েন্টার শুরুর নোডে বসানো হলো।",
    ));

    int maxIterations = 15;
    int iterations = 0;

    while (iterations < maxIterations) {
      iterations++;

      if (pos < 0 && (fast >= n || fast + 1 >= n)) {
        steps.add(CycleStepData(
          slowIndex: slow,
          fastIndex: fast >= n ? n - 1 : fast,
          actionEn: "fast reached null → return false ❌ (No Cycle)",
          actionBn: "fast লিঙ্কড লিস্টের শেষে নাল পেয়েছে → return false ❌ (সাইকেল নেই)",
          reasonEn: "Fast reached end of list without cycle.",
          reasonBn: "Fast পয়েন্টার নাল পেয়েছে, অর্থাৎ লুপ নেই।",
        ));
        break;
      }

      if (pos >= 0 && slow >= pos) {
        slow = (slow + 1 >= n) ? pos : slow + 1;
      } else {
        slow = slow + 1;
      }

      int prevFast = fast;
      if (pos >= 0) {
        int step1 = (prevFast + 1 >= n) ? pos : prevFast + 1;
        fast = (step1 + 1 >= n) ? pos : step1 + 1;
      } else {
        fast = fast + 2;
        if (fast >= n) {
          steps.add(CycleStepData(
            slowIndex: slow,
            fastIndex: n - 1,
            actionEn: "fast reached end of list → return false ❌",
            actionBn: "fast লিস্টের শেষে নাল পেয়েছে → return false ❌",
            reasonEn: "Fast reached null. No cycle exists.",
            reasonBn: "Fast নাল পেয়েছে, অর্থাৎ সাইকেল নেই।",
          ));
          break;
        }
      }

      bool isMatch = slow == fast;

      steps.add(CycleStepData(
        slowIndex: slow,
        fastIndex: fast % n,
        actionEn: isMatch
            ? "🎉 COLLISION MATCH! slow == fast at idx $slow (val: ${nodes[slow % n]})"
            : "Slow moves to idx $slow, Fast moves 2 steps to idx $fast",
        actionBn: isMatch
            ? "🎉 মিলন ঘটেছে! slow == fast ইনডেক্স $slow এ (মান: ${nodes[slow % n]})"
            : "Slow ইনডেক্স $slow এ, Fast ২ ধাপ এগিয়ে ইনডেক্স $fast এ",
        reasonEn: isMatch
            ? "Fast caught up with Slow inside the cycle! Return true."
            : "Fast moves at twice the speed of Slow.",
        reasonBn: isMatch
            ? "সাইকেলের ভেতর Fast ঘুরে এসে Slow কে ধরে ফেলেছে!"
            : "Fast পয়েন্টারের গতি Slow এর চেয়ে দ্বিগুণ।",
        isCollision: isMatch,
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

  void _loadPreset(List<int> nodes, int pos) {
    _nodesController.text = nodes.join(', ');
    _posController.text = pos.toString();
    _rebuildSteps();
  }

  @override
  Widget build(BuildContext context) {
    final hPadding = Responsive.horizontalPadding(context);
    final isMobile = Responsive.isMobile(context);
    final step = _steps.isEmpty
        ? const CycleStepData(slowIndex: 0, fastIndex: 0, actionEn: "", actionBn: "", reasonEn: "", reasonBn: "")
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
                    widget.isEnglish ? 'Dynamic Custom Input Generator' : 'ডায়নামিক ইনপুট ও টেস্ট কেস',
                    style: TextStyle(fontSize: Responsive.sp(context, 16), fontWeight: FontWeight.bold, color: AppTheme.accentNeonCyan),
                  ),
                  const SizedBox(height: 12),
                  if (isMobile)
                    Column(
                      children: [
                        TextField(
                          controller: _nodesController,
                          style: TextStyle(color: Colors.white, fontFamily: 'monospace', fontSize: Responsive.sp(context, 13)),
                          decoration: InputDecoration(labelText: widget.isEnglish ? 'Nodes (comma separated)' : 'নোডের মানসমূহ', hintText: '3, 2, 0, -4'),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _posController,
                          keyboardType: TextInputType.number,
                          style: TextStyle(color: Colors.white, fontFamily: 'monospace', fontSize: Responsive.sp(context, 13)),
                          decoration: InputDecoration(labelText: widget.isEnglish ? 'Cycle Pos (-1 for no cycle)' : 'সাইকেল ইনডেক্স (-1 মানে সাইকেল নেই)', hintText: '1'),
                        ),
                      ],
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextField(
                            controller: _nodesController,
                            style: TextStyle(color: Colors.white, fontFamily: 'monospace', fontSize: Responsive.sp(context, 13)),
                            decoration: InputDecoration(labelText: widget.isEnglish ? 'Nodes (comma separated)' : 'নোডের মানসমূহ', hintText: '3, 2, 0, -4'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 1,
                          child: TextField(
                            controller: _posController,
                            keyboardType: TextInputType.number,
                            style: TextStyle(color: Colors.white, fontFamily: 'monospace', fontSize: Responsive.sp(context, 13)),
                            decoration: InputDecoration(labelText: widget.isEnglish ? 'Cycle Pos (-1 = none)' : 'সাইকেল ইনডেক্স (-1 = নেই)', hintText: '1'),
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
                        _buildPresetChip('[3, 2, 0, -4] (pos=1)', [3, 2, 0, -4], 1),
                        _buildPresetChip('[1, 2] (pos=0)', [1, 2], 0),
                        _buildPresetChip('[1, 2, 3, 4, 5] (No cycle)', [1, 2, 3, 4, 5], -1),
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

  Widget _buildNodeVisualizationBox(CycleStepData step) {
    final n = _currentNodes.length;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Responsive.sp(context, 16)),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: step.isCollision ? AppTheme.accentGreen : const Color(0xFF334155), width: step.isCollision ? 2.0 : 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Linked List View (pos: $_cyclePos)", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: Responsive.sp(context, 14))),
            ],
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(n, (idx) {
                final val = _currentNodes[idx];
                final isSlow = (step.slowIndex % n) == idx;
                final isFast = (step.fastIndex % n) == idx;
                final isCollision = step.isCollision && isSlow && isFast;

                Color boxBg = AppTheme.primaryDark;
                Color borderColor = const Color(0xFF334155);

                if (isCollision) {
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
                      Text('$val', style: TextStyle(fontSize: Responsive.sp(context, 16), fontWeight: FontWeight.bold, color: Colors.white)),
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
              color: step.isCollision ? AppTheme.accentGreen.withOpacity(0.15) : AppTheme.primaryDark,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: step.isCollision ? AppTheme.accentGreen : const Color(0xFF334155)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.isEnglish ? step.actionEn : step.actionBn, style: TextStyle(fontWeight: FontWeight.bold, color: step.isCollision ? AppTheme.accentGreen : Colors.white, fontSize: Responsive.sp(context, 13))),
                const SizedBox(height: 4),
                Text(widget.isEnglish ? step.reasonEn : step.reasonBn, style: TextStyle(color: AppTheme.textSecondary, fontSize: Responsive.sp(context, 12), height: 1.3)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPresetChip(String label, List<int> nodes, int pos) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ActionChip(
        label: Text(label, style: TextStyle(fontSize: Responsive.sp(context, 11), color: Colors.white)),
        backgroundColor: AppTheme.primaryDark,
        onPressed: () => _loadPreset(nodes, pos),
      ),
    );
  }
}
