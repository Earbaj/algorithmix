import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class DeleteNodeStepData {
  final List<int> currentNodes;
  final int targetIndex;
  final String actionEn;
  final String actionBn;
  final String reasonEn;
  final String reasonBn;
  final bool isCompleted;

  const DeleteNodeStepData({
    required this.currentNodes,
    required this.targetIndex,
    required this.actionEn,
    required this.actionBn,
    required this.reasonEn,
    required this.reasonBn,
    this.isCompleted = false,
  });
}

class DeleteNodeDynamicVisualizerTab extends StatefulWidget {
  final bool isEnglish;

  const DeleteNodeDynamicVisualizerTab({
    super.key,
    required this.isEnglish,
  });

  @override
  State<DeleteNodeDynamicVisualizerTab> createState() => _DeleteNodeDynamicVisualizerTabState();
}

class _DeleteNodeDynamicVisualizerTabState extends State<DeleteNodeDynamicVisualizerTab> {
  final TextEditingController _nodesController =
      TextEditingController(text: "4, 5, 1, 9");
  final TextEditingController _targetValController =
      TextEditingController(text: "5");

  List<int> _initialNodes = [4, 5, 1, 9];
  int _targetVal = 5;
  List<DeleteNodeStepData> _steps = [];

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
    _targetValController.dispose();
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
      if (parsed.length < 2) parsed = [4, 5, 1, 9];
      _initialNodes = parsed;
      _targetVal = int.parse(_targetValController.text.trim());
    } catch (_) {
      _initialNodes = [4, 5, 1, 9];
      _targetVal = 5;
    }

    _steps = _generateSteps(_initialNodes, _targetVal);
    setState(() {});
  }

  List<DeleteNodeStepData> _generateSteps(List<int> nodes, int targetVal) {
    List<DeleteNodeStepData> steps = [];
    List<int> state = List.from(nodes);
    int targetIdx = state.indexOf(targetVal);

    if (targetIdx == -1 || targetIdx >= state.length - 1) {
      targetIdx = 1; // fallback to index 1 if invalid or tail
    }

    steps.add(DeleteNodeStepData(
      currentNodes: List.from(state),
      targetIndex: targetIdx,
      actionEn: "Target node given: idx $targetIdx (val: ${state[targetIdx]})",
      actionBn: "ডিলেট করার জন্য নোড প্রদান করা হয়েছে: ইনডেক্স $targetIdx (মান: ${state[targetIdx]})",
      reasonEn: "Node pointer is set directly at target node.",
      reasonBn: "টার্গেট নোডে সরাসরি পয়েন্টার বসানো হলো।",
    ));

    int nextVal = state[targetIdx + 1];
    state[targetIdx] = nextVal;

    steps.add(DeleteNodeStepData(
      currentNodes: List.from(state),
      targetIndex: targetIdx,
      actionEn: "Copy next node value $nextVal into target node (node.val = node.next.val)",
      actionBn: "পরের নোডের মান $nextVal টার্গেট নোডে কপি করা হলো (node.val = node.next.val)",
      reasonEn: "Overwrites current value with next value.",
      reasonBn: "বর্তমান মান পরিবর্তন করে পরের নোডের মান বসানো হলো।",
    ));

    state.removeAt(targetIdx + 1);

    steps.add(DeleteNodeStepData(
      currentNodes: List.from(state),
      targetIndex: targetIdx,
      actionEn: "🎉 Bypass duplicate next node (node.next = node.next.next) → Result: $state",
      actionBn: "🎉 পরের নোড বাইপাস (node.next = node.next.next) → ফলাফল: $state",
      reasonEn: "Node successfully deleted in O(1) time and O(1) space!",
      reasonBn: "মাত্র O(1) সময় ও ও মেমোরিতে নোড ডিলেশন সম্পন্ন!",
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

  void _loadPreset(List<int> nodes, int target) {
    _nodesController.text = nodes.join(', ');
    _targetValController.text = target.toString();
    _rebuildSteps();
  }

  @override
  Widget build(BuildContext context) {
    final hPadding = Responsive.horizontalPadding(context);
    final step = _steps.isEmpty
        ? DeleteNodeStepData(currentNodes: _initialNodes, targetIndex: 1, actionEn: "", actionBn: "", reasonEn: "", reasonBn: "")
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
                          controller: _nodesController,
                          style: TextStyle(color: Colors.white, fontFamily: 'monospace', fontSize: Responsive.sp(context, 13)),
                          decoration: InputDecoration(labelText: widget.isEnglish ? 'Nodes' : 'নোডসমূহ', hintText: '4, 5, 1, 9'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 110,
                        child: TextField(
                          controller: _targetValController,
                          keyboardType: TextInputType.number,
                          style: TextStyle(color: Colors.white, fontFamily: 'monospace', fontSize: Responsive.sp(context, 13)),
                          decoration: InputDecoration(labelText: widget.isEnglish ? 'Target Val' : 'ডিলেট নোড', hintText: '5'),
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
                        _buildPresetChip('[4, 5, 1, 9], del 5', [4, 5, 1, 9], 5),
                        _buildPresetChip('[4, 5, 1, 9], del 1', [4, 5, 1, 9], 1),
                        _buildPresetChip('[1, 2, 3, 4], del 2', [1, 2, 3, 4], 2),
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

  Widget _buildNodeVisualizationBox(DeleteNodeStepData step) {
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
              Text("Linked List View", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: Responsive.sp(context, 14))),
              if (step.isCompleted)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: AppTheme.accentGreen.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                  child: const Text("🎉 NODE DELETED IN O(1)", style: TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
            ],
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(nodes.length, (idx) {
                final val = nodes[idx];
                final isTarget = step.targetIndex == idx;
                final isCompleted = step.isCompleted;

                Color boxBg = AppTheme.primaryDark;
                Color borderColor = const Color(0xFF334155);

                if (isCompleted) {
                  boxBg = AppTheme.accentGreen.withOpacity(0.35);
                  borderColor = AppTheme.accentGreen;
                } else if (isTarget) {
                  boxBg = AppTheme.accentPink.withOpacity(0.25);
                  borderColor = AppTheme.accentPink;
                }

                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: EdgeInsets.symmetric(horizontal: Responsive.sp(context, 14), vertical: Responsive.sp(context, 10)),
                  decoration: BoxDecoration(color: boxBg, borderRadius: BorderRadius.circular(10), border: Border.all(color: borderColor, width: 2)),
                  child: Column(
                    children: [
                      if (isTarget && !isCompleted)
                        Text('Target 🎯', style: TextStyle(fontSize: Responsive.sp(context, 10), color: AppTheme.accentPink, fontWeight: FontWeight.bold))
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

  Widget _buildPresetChip(String label, List<int> nodes, int target) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ActionChip(
        label: Text(label, style: TextStyle(fontSize: Responsive.sp(context, 11), color: Colors.white)),
        backgroundColor: AppTheme.primaryDark,
        onPressed: () => _loadPreset(nodes, target),
      ),
    );
  }
}
