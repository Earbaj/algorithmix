import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class RemoveDuplicatesStepData {
  final List<int> currentNodes;
  final int currIndex;
  final String actionEn;
  final String actionBn;
  final String reasonEn;
  final String reasonBn;
  final bool isCompleted;

  const RemoveDuplicatesStepData({
    required this.currentNodes,
    required this.currIndex,
    required this.actionEn,
    required this.actionBn,
    required this.reasonEn,
    required this.reasonBn,
    this.isCompleted = false,
  });
}

class RemoveDuplicatesDynamicVisualizerTab extends StatefulWidget {
  final bool isEnglish;

  const RemoveDuplicatesDynamicVisualizerTab({
    super.key,
    required this.isEnglish,
  });

  @override
  State<RemoveDuplicatesDynamicVisualizerTab> createState() => _RemoveDuplicatesDynamicVisualizerTabState();
}

class _RemoveDuplicatesDynamicVisualizerTabState extends State<RemoveDuplicatesDynamicVisualizerTab> {
  final TextEditingController _nodesController =
      TextEditingController(text: "1, 1, 2, 3, 3");

  List<int> _initialNodes = [1, 1, 2, 3, 3];
  List<RemoveDuplicatesStepData> _steps = [];

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
      if (parsed.isEmpty) parsed = [1, 1, 2, 3, 3];
      _initialNodes = parsed;
    } catch (_) {
      _initialNodes = [1, 1, 2, 3, 3];
    }

    _steps = _generateSteps(_initialNodes);
    setState(() {});
  }

  List<RemoveDuplicatesStepData> _generateSteps(List<int> nodes) {
    List<RemoveDuplicatesStepData> steps = [];
    List<int> state = List.from(nodes);
    if (state.isEmpty) return steps;

    int idx = 0;

    steps.add(RemoveDuplicatesStepData(
      currentNodes: List.from(state),
      currIndex: idx,
      actionEn: "Initialize curr = head (idx 0, val: ${state[0]})",
      actionBn: "curr = head সূচনা (ইনডেক্স 0, মান: ${state[0]})",
      reasonEn: "Pointer starts at head node of list.",
      reasonBn: "পয়েন্টার শুরুর নোডে বসানো হলো।",
    ));

    while (idx < state.length - 1) {
      if (state[idx] == state[idx + 1]) {
        int dupVal = state[idx + 1];
        state.removeAt(idx + 1);

        steps.add(RemoveDuplicatesStepData(
          currentNodes: List.from(state),
          currIndex: idx,
          actionEn: "Bypass duplicate node with value $dupVal (curr.next = curr.next.next)",
          actionBn: "মান $dupVal বিশিষ্ট ডুপ্লিকেট নোড বাইপাস করা হলো (curr.next = curr.next.next)",
          reasonEn: "Adjacent node values match! Duplicate node removed.",
          reasonBn: "পাশের নোডের মান সমান! ডুপ্লিকেট নোড রিমুভ করা হয়েছে।",
        ));
      } else {
        idx++;
        steps.add(RemoveDuplicatesStepData(
          currentNodes: List.from(state),
          currIndex: idx,
          actionEn: "Advance curr pointer to idx $idx (val: ${state[idx]})",
          actionBn: "curr পয়েন্টার ইনডেক্স $idx এ এগিয়ে নেয়া হলো (মান: ${state[idx]})",
          reasonEn: "Adjacent node values are distinct. Advance to next node.",
          reasonBn: "পাশের নোডের মান ভিন্ন। পরের নোডে যাওয়া হলো।",
        ));
      }
    }

    steps.add(RemoveDuplicatesStepData(
      currentNodes: List.from(state),
      currIndex: idx,
      actionEn: "🎉 Finished! Sorted linked list with unique elements: $state",
      actionBn: "🎉 সমাপ্ত! ডুপ্লিকেটমুক্ত সর্টেড লিঙ্কড লিস্ট: $state",
      reasonEn: "End of list reached. All duplicates successfully removed!",
      reasonBn: "লিস্টের শেষ প্রান্তে পৌঁছে গেছে। সফলভাবে সকল ডুপ্লিকেট রিমুভ করা হয়েছে!",
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

  void _loadPreset(List<int> nodes) {
    _nodesController.text = nodes.join(', ');
    _rebuildSteps();
  }

  @override
  Widget build(BuildContext context) {
    final hPadding = Responsive.horizontalPadding(context);
    final step = _steps.isEmpty
        ? RemoveDuplicatesStepData(currentNodes: _initialNodes, currIndex: 0, actionEn: "", actionBn: "", reasonEn: "", reasonBn: "")
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
                    decoration: InputDecoration(labelText: widget.isEnglish ? 'Sorted Nodes (comma separated)' : 'সর্টেড নোডসমূহ (কমা দিয়ে পৃথকীকৃত)', hintText: '1, 1, 2, 3, 3'),
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Text('Presets: ', style: TextStyle(color: AppTheme.textMuted, fontSize: Responsive.sp(context, 12))),
                        _buildPresetChip('[1, 1, 2]', [1, 1, 2]),
                        _buildPresetChip('[1, 1, 2, 3, 3]', [1, 1, 2, 3, 3]),
                        _buildPresetChip('[1, 1, 1, 1]', [1, 1, 1, 1]),
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

  Widget _buildNodeVisualizationBox(RemoveDuplicatesStepData step) {
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
                  child: const Text("🎉 ALL DUPLICATES REMOVED!", style: TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 12)),
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
