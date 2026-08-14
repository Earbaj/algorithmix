import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class HappyStepData {
  final int slowVal;
  final int fastVal;
  final String actionEn;
  final String actionBn;
  final String reasonEn;
  final String reasonBn;
  final bool isHappy;
  final bool isCycle;

  const HappyStepData({
    required this.slowVal,
    required this.fastVal,
    required this.actionEn,
    required this.actionBn,
    required this.reasonEn,
    required this.reasonBn,
    this.isHappy = false,
    this.isCycle = false,
  });
}

class HappyDynamicVisualizerTab extends StatefulWidget {
  final bool isEnglish;

  const HappyDynamicVisualizerTab({
    super.key,
    required this.isEnglish,
  });

  @override
  State<HappyDynamicVisualizerTab> createState() => _HappyDynamicVisualizerTabState();
}

class _HappyDynamicVisualizerTabState extends State<HappyDynamicVisualizerTab> {
  final TextEditingController _numberController =
      TextEditingController(text: "19");

  int _inputN = 19;
  List<HappyStepData> _steps = [];

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
    _numberController.dispose();
    super.dispose();
  }

  int _getNext(int n) {
    int sum = 0;
    while (n > 0) {
      int d = n % 10;
      sum += d * d;
      n ~/= 10;
    }
    return sum;
  }

  void _rebuildSteps() {
    _timer?.cancel();
    _isPlaying = false;
    _currentStepIndex = 0;

    try {
      _inputN = int.parse(_numberController.text.trim());
      if (_inputN <= 0) _inputN = 19;
    } catch (_) {
      _inputN = 19;
    }

    _steps = _generateSteps(_inputN);
    setState(() {});
  }

  List<HappyStepData> _generateSteps(int n) {
    List<HappyStepData> steps = [];

    int slow = n;
    int fast = n;

    steps.add(HappyStepData(
      slowVal: slow,
      fastVal: fast,
      actionEn: "Initialize slow = $n, fast = $n",
      actionBn: "slow = $n, fast = $n সূচনা",
      reasonEn: "Both pointers start at initial number n.",
      reasonBn: "উভয় পয়েন্টার ইনপুট সংখ্যা n এ বসানো হলো।",
    ));

    int maxIter = 15;
    int iter = 0;

    while (iter < maxIter) {
      iter++;
      slow = _getNext(slow);
      fast = _getNext(_getNext(fast));

      bool isHappy = (slow == 1 || fast == 1);
      bool isMatch = (slow == fast && slow != 1);

      steps.add(HappyStepData(
        slowVal: slow,
        fastVal: fast,
        actionEn: isHappy
            ? "🎉 Fast/Slow reached 1 → HAPPY NUMBER!"
            : isMatch
                ? "❌ COLLISION MATCH! slow == fast ($slow) → UNHAPPY CYCLE!"
                : "Slow transforms to $slow, Fast transforms 2x to $fast",
        actionBn: isHappy
            ? "🎉 ১ পাওয়া গেছে → হ্যাপি নাম্বার!"
            : isMatch
                ? "❌ পয়েন্টার মিলিত হয়েছে ($slow) → হ্যাপি নাম্বার নয় (সাইকেল)!"
                : "Slow এর নতুন মান $slow, Fast এর নতুন মান $fast",
        reasonEn: isHappy
            ? "Sum of digit squares reached 1."
            : isMatch
                ? "Fast caught up with Slow inside a non-1 loop."
                : "Slow moved 1 transformation step, Fast moved 2 transformation steps.",
        reasonBn: isHappy
            ? "অংকগুলোর বর্গের যোগফল ১ এ পৌঁছেছে।"
            : isMatch
                ? "১ ছাড়াও অন্য সংখ্যার লুপে Fast ও Slow এর মিলন ঘটেছে।"
                : "Slow ১ টি ও Fast ২ টি স্কয়ার ডিজিট রূপান্তর সম্পন্ন করেছে।",
        isHappy: isHappy,
        isCycle: isMatch,
      ));

      if (isHappy || isMatch) break;
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

  void _loadPreset(int n) {
    _numberController.text = n.toString();
    _rebuildSteps();
  }

  @override
  Widget build(BuildContext context) {
    final hPadding = Responsive.horizontalPadding(context);
    final step = _steps.isEmpty
        ? const HappyStepData(slowVal: 0, fastVal: 0, actionEn: "", actionBn: "", reasonEn: "", reasonBn: "")
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
                    controller: _numberController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: Colors.white, fontFamily: 'monospace', fontSize: Responsive.sp(context, 13)),
                    decoration: InputDecoration(labelText: widget.isEnglish ? 'Enter positive integer (n)' : 'পজিটিভ সংখ্যা ইনপুট দিন (n)', hintText: '19'),
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Text('Presets: ', style: TextStyle(color: AppTheme.textMuted, fontSize: Responsive.sp(context, 12))),
                        _buildPresetChip('n = 19 (Happy 🎉)', 19),
                        _buildPresetChip('n = 7 (Happy 🎉)', 7),
                        _buildPresetChip('n = 2 (Unhappy ❌)', 2),
                        _buildPresetChip('n = 4 (Unhappy ❌)', 4),
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

            _buildVisualizationBox(step),
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

  Widget _buildVisualizationBox(HappyStepData step) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Responsive.sp(context, 16)),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: step.isHappy ? AppTheme.accentGreen : (step.isCycle ? AppTheme.accentPink : const Color(0xFF334155)),
          width: (step.isHappy || step.isCycle) ? 2.0 : 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Transformation State View", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: Responsive.sp(context, 14))),
              if (step.isHappy)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: AppTheme.accentGreen.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                  child: const Text("🎉 HAPPY NUMBER (Sum=1)", style: TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 12)),
                )
              else if (step.isCycle)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: AppTheme.accentPink.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                  child: const Text("❌ UNHAPPY CYCLE", style: TextStyle(color: AppTheme.accentPink, fontWeight: FontWeight.bold, fontSize: 12)),
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
                      Text('Slow Pointer (1x)', style: TextStyle(fontSize: Responsive.sp(context, 11), color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text('${step.slowVal}', style: TextStyle(fontSize: Responsive.sp(context, 22), fontWeight: FontWeight.bold, color: Colors.white)),
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
                      Text('Fast Pointer (2x)', style: TextStyle(fontSize: Responsive.sp(context, 11), color: AppTheme.accentPurple, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text('${step.fastVal}', style: TextStyle(fontSize: Responsive.sp(context, 22), fontWeight: FontWeight.bold, color: Colors.white)),
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
              color: step.isHappy ? AppTheme.accentGreen.withOpacity(0.15) : (step.isCycle ? AppTheme.accentPink.withOpacity(0.15) : AppTheme.primaryDark),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: step.isHappy ? AppTheme.accentGreen : (step.isCycle ? AppTheme.accentPink : const Color(0xFF334155))),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.isEnglish ? step.actionEn : step.actionBn, style: TextStyle(fontWeight: FontWeight.bold, color: step.isHappy ? AppTheme.accentGreen : (step.isCycle ? AppTheme.accentPink : Colors.white), fontSize: Responsive.sp(context, 13))),
                const SizedBox(height: 4),
                Text(widget.isEnglish ? step.reasonEn : step.reasonBn, style: TextStyle(color: AppTheme.textSecondary, fontSize: Responsive.sp(context, 12), height: 1.3)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPresetChip(String label, int n) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ActionChip(
        label: Text(label, style: TextStyle(fontSize: Responsive.sp(context, 11), color: Colors.white)),
        backgroundColor: AppTheme.primaryDark,
        onPressed: () => _loadPreset(n),
      ),
    );
  }
}
