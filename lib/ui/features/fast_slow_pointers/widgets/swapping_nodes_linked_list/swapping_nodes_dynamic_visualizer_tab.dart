import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class SwappingNodesStepData {
  final List<int> currentNodes;
  final int firstIndex;
  final int secondIndex;
  final String actionEn;
  final String actionBn;
  final String reasonEn;
  final String reasonBn;
  final bool isCompleted;

  const SwappingNodesStepData({
    required this.currentNodes,
    required this.firstIndex,
    required this.secondIndex,
    required this.actionEn,
    required this.actionBn,
    required this.reasonEn,
    required this.reasonBn,
    this.isCompleted = false,
  });
}

class SwappingNodesDynamicVisualizerTab extends StatefulWidget {
  final bool isEnglish;

  const SwappingNodesDynamicVisualizerTab({
    super.key,
    required this.isEnglish,
  });

  @override
  State<SwappingNodesDynamicVisualizerTab> createState() => _SwappingNodesDynamicVisualizerTabState();
}

class _SwappingNodesDynamicVisualizerTabState extends State<SwappingNodesDynamicVisualizerTab> {
  final TextEditingController _nodesController =
      TextEditingController(text: "1, 2, 3, 4, 5");
  final TextEditingController _kController =
      TextEditingController(text: "2");

  List<int> _initialNodes = [1, 2, 3, 4, 5];
  int _k = 2;
  List<SwappingNodesStepData> _steps = [];

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
    _kController.dispose();
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
      _initialNodes = parsed;
      _k = int.parse(_kController.text.trim());
      if (_k < 1 || _k > _initialNodes.length) _k = 2;
    } catch (_) {
      _initialNodes = [1, 2, 3, 4, 5];
      _k = 2;
    }

    _steps = _generateSteps(_initialNodes, _k);
    setState(() {});
  }

  List<SwappingNodesStepData> _generateSteps(List<int> nodes, int k) {
    List<SwappingNodesStepData> steps = [];
    List<int> state = List.from(nodes);
    int n = state.length;

    int firstIdx = k - 1;
    int secondIdx = n - k;

    steps.add(SwappingNodesStepData(
      currentNodes: List.from(state),
      firstIndex: firstIdx,
      secondIndex: firstIdx,
      actionEn: "Locate $k-th node from start: first = idx $firstIdx (val: ${state[firstIdx]})",
      actionBn: "শুরুর দিক থেকে $k-তম নোড চিহ্নিত: first = ইনডেক্স $firstIdx (মান: ${state[firstIdx]})",
      reasonEn: "Traverse k-1 steps from head.",
      reasonBn: "head থেকে k-1 ধাপ সামনে অগ্রসর হয়ে ১ম পয়েন্টার বসানো হলো।",
    ));

    steps.add(SwappingNodesStepData(
      currentNodes: List.from(state),
      firstIndex: firstIdx,
      secondIndex: secondIdx,
      actionEn: "Locate $k-th node from end: second = idx $secondIdx (val: ${state[secondIdx]})",
      actionBn: "শেষের দিক থেকে $k-তম নোড চিহ্নিত: second = ইনডেক্স $secondIdx (মান: ${state[secondIdx]})",
      reasonEn: "Advance curr to tail while moving second from head.",
      reasonBn: "curr শেষে পৌঁছানো পর্যন্ত second কে সাথে নিয়ে টানা হলো।",
    ));

    // Swap
    int temp = state[firstIdx];
    state[firstIdx] = state[secondIdx];
    state[secondIdx] = temp;

    steps.add(SwappingNodesStepData(
      currentNodes: List.from(state),
      firstIndex: firstIdx,
      secondIndex: secondIdx,
      actionEn: "🎉 Swap values of first and second nodes! Result: $state",
      actionBn: "🎉 first এবং second নোডের মান সওয়াপ করা হলো! ফলাফল: $state",
      reasonEn: "Values swapped successfully in O(N) time and O(1) space!",
      reasonBn: "O(N) সময় এবং O(1) স্পেসে সওয়াপিং সম্পন্ন!",
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

  void _loadPreset(List<int> nodes, int k) {
    _nodesController.text = nodes.join(', ');
    _kController.text = k.toString();
    _rebuildSteps();
  }

  @override
  Widget build(BuildContext context) {
    final hPadding = Responsive.horizontalPadding(context);
    final step = _steps.isEmpty
        ? SwappingNodesStepData(currentNodes: _initialNodes, firstIndex: 1, secondIndex: 3, actionEn: "", actionBn: "", reasonEn: "", reasonBn: "")
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
                          decoration: InputDecoration(labelText: widget.isEnglish ? 'Nodes' : 'নোডসমূহ', hintText: '1, 2, 3, 4, 5'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 100,
                        child: TextField(
                          controller: _kController,
                          keyboardType: TextInputType.number,
                          style: TextStyle(color: Colors.white, fontFamily: 'monospace', fontSize: Responsive.sp(context, 13)),
                          decoration: InputDecoration(labelText: 'k', hintText: '2'),
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
                        _buildPresetChip('[1, 2, 3, 4, 5], k=2', [1, 2, 3, 4, 5], 2),
                        _buildPresetChip('[7, 9, 6, 6, 7, 8, 3, 0, 9, 5], k=5', [7, 9, 6, 6, 7, 8, 3, 0, 9, 5], 5),
                        _buildPresetChip('[1, 2], k=1', [1, 2], 1),
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

  Widget _buildNodeVisualizationBox(SwappingNodesStepData step) {
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
                  child: const Text("🎉 VALUES SWAPPED", style: TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
            ],
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(nodes.length, (idx) {
                final val = nodes[idx];
                final isFirst = step.firstIndex == idx;
                final isSecond = step.secondIndex == idx;
                final isCompleted = step.isCompleted;

                Color boxBg = AppTheme.primaryDark;
                Color borderColor = const Color(0xFF334155);

                if (isCompleted && (isFirst || isSecond)) {
                  boxBg = AppTheme.accentGreen.withOpacity(0.35);
                  borderColor = AppTheme.accentGreen;
                } else if (isFirst) {
                  boxBg = AppTheme.accentNeonCyan.withOpacity(0.25);
                  borderColor = AppTheme.accentNeonCyan;
                } else if (isSecond) {
                  boxBg = AppTheme.accentPurple.withOpacity(0.25);
                  borderColor = AppTheme.accentPurple;
                }

                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: EdgeInsets.symmetric(horizontal: Responsive.sp(context, 14), vertical: Responsive.sp(context, 10)),
                  decoration: BoxDecoration(color: boxBg, borderRadius: BorderRadius.circular(10), border: Border.all(color: borderColor, width: 2)),
                  child: Column(
                    children: [
                      if (isFirst && isSecond)
                        Text('first&second', style: TextStyle(fontSize: Responsive.sp(context, 9), color: AppTheme.accentAmber, fontWeight: FontWeight.bold))
                      else if (isFirst)
                        Text('first 📍', style: TextStyle(fontSize: Responsive.sp(context, 10), color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold))
                      else if (isSecond)
                        Text('second 📍', style: TextStyle(fontSize: Responsive.sp(context, 10), color: AppTheme.accentPurple, fontWeight: FontWeight.bold))
                      else
                        Text(' ', style: TextStyle(fontSize: Responsive.sp(context, 10))),
                      const SizedBox(height: 4),
                      Text('$val', style: TextStyle(fontSize: Responsive.sp(context, 16), fontWeight: FontWeight.bold, color: (isCompleted && (isFirst || isSecond)) ? AppTheme.accentGreen : Colors.white)),
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

  Widget _buildPresetChip(String label, List<int> nodes, int k) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ActionChip(
        label: Text(label, style: TextStyle(fontSize: Responsive.sp(context, 11), color: Colors.white)),
        backgroundColor: AppTheme.primaryDark,
        onPressed: () => _loadPreset(nodes, k),
      ),
    );
  }
}
