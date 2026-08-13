import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';

class DetectCycleGraphAnimatedVisualizer extends StatefulWidget {
  final bool isEnglish;

  const DetectCycleGraphAnimatedVisualizer({
    super.key,
    required this.isEnglish,
  });

  @override
  State<DetectCycleGraphAnimatedVisualizer> createState() =>
      _DetectCycleGraphAnimatedVisualizerState();
}

class CycleStepData {
  final int currentNode;
  final int parentNode;
  final bool hasCycle;
  final String titleEn;
  final String titleBn;
  final String explanationEn;
  final String explanationBn;

  const CycleStepData({
    required this.currentNode,
    required this.parentNode,
    required this.hasCycle,
    required this.titleEn,
    required this.titleBn,
    required this.explanationEn,
    required this.explanationBn,
  });
}

class _DetectCycleGraphAnimatedVisualizerState
    extends State<DetectCycleGraphAnimatedVisualizer> {
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  late final List<CycleStepData> _steps;

  @override
  void initState() {
    super.initState();
    _steps = const [
      CycleStepData(
        currentNode: 0,
        parentNode: -1,
        hasCycle: false,
        titleEn: "1. Start DFS at Node 0 (parent = -1)",
        titleBn: "১. নোড 0 থেকে DFS শুরু (প্যারেন্ট = -1)",
        explanationEn: "Start DFS cycle check at Node 0. Mark Visited[0] = true.",
        explanationBn: "নোড 0 থেকে সাইকেল ডিটেকশন শুরু। Visited[0] = true।",
      ),
      CycleStepData(
        currentNode: 1,
        parentNode: 0,
        hasCycle: false,
        titleEn: "2. Recurse to Neighbor Node 1 (parent = 0)",
        titleBn: "২. প্রতিবেশী নোড 1 এ রিকার্সন (প্যারেন্ট = 0)",
        explanationEn: "Visit neighbor Node 1 with parent = 0.",
        explanationBn: "নোড 1 ভিসিট, প্যারেন্ট নোড 0।",
      ),
      CycleStepData(
        currentNode: 2,
        parentNode: 1,
        hasCycle: false,
        titleEn: "3. Recurse to Neighbor Node 2 (parent = 1)",
        titleBn: "৩. প্রতিবেশী নোড 2 এ রিকার্সন (প্যারেন্ট = 1)",
        explanationEn: "Visit neighbor Node 2 with parent = 1.",
        explanationBn: "নোড 2 ভিসিট, প্যারেন্ট নোড 1।",
      ),
      CycleStepData(
        currentNode: 2,
        parentNode: 1,
        hasCycle: true,
        titleEn: "4. Neighbor 0 is Visited & 0 != parent(1) -> CYCLE DETECTED! ⚠️",
        titleBn: "৪. প্রতিবেশী 0 ভিসিটেড ও 0 != প্যারেন্ট(1) -> সাইকেল সনাক্ত! ⚠️",
        explanationEn: "From Node 2, neighbor Node 0 is ALREADY VISITED AND Node 0 != parent(1)! A back-edge cycle (0-1-2-0) exists in graph! Return true! ⚠️",
        explanationBn: "নোড 2 থেকে প্রতিবেশী 0 আগেই ভিজিটেড এবং 0 != প্যারেন্ট 1! ব্যাক-এজ সাইকেল (0-1-2-0) বিদ্যমান! return true! ⚠️",
      ),
    ];
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _togglePlay() {
    setState(() => _isPlaying = !_isPlaying);
    if (_isPlaying) {
      _timer = Timer.periodic(const Duration(milliseconds: 1500), (timer) {
        if (_currentStepIndex < _steps.length - 1) {
          setState(() => _currentStepIndex++);
        } else {
          _timer?.cancel();
          setState(() => _isPlaying = false);
        }
      });
    } else {
      _timer?.cancel();
    }
  }

  void _nextStep() {
    if (_currentStepIndex < _steps.length - 1) {
      setState(() => _currentStepIndex++);
    }
  }

  void _prevStep() {
    if (_currentStepIndex > 0) {
      setState(() => _currentStepIndex--);
    }
  }

  void _reset() {
    _timer?.cancel();
    setState(() {
      _isPlaying = false;
      _currentStepIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final step = _steps[_currentStepIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: step.hasCycle ? Colors.redAccent.withOpacity(0.2) : AppTheme.accentNeonCyan.withOpacity(0.12),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: step.hasCycle ? Colors.redAccent : AppTheme.accentNeonCyan.withOpacity(0.5)),
          ),
          child: Row(
            children: [
              Icon(step.hasCycle ? Icons.warning_amber : Icons.loop, color: step.hasCycle ? Colors.redAccent : AppTheme.accentNeonCyan, size: 24),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.isEnglish ? step.titleEn : step.titleBn,
                      style: TextStyle(color: step.hasCycle ? Colors.redAccent : AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.isEnglish ? step.explanationEn : step.explanationBn,
                      style: const TextStyle(color: Colors.white, fontSize: 12, height: 1.3),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Visual Display of Parent Tracking State
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFF090D16),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: step.hasCycle ? Colors.redAccent : const Color(0xFF1E293B)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Undirected Graph Parent Tracking:", style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: step.hasCycle ? Colors.redAccent.withOpacity(0.2) : AppTheme.accentGreen.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: step.hasCycle ? Colors.redAccent : AppTheme.accentGreen),
                    ),
                    child: Text(
                      step.hasCycle ? "CYCLE DETECTED = TRUE" : "NO CYCLE YET",
                      style: TextStyle(
                        color: step.hasCycle ? Colors.redAccent : AppTheme.accentGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildNodeBox(node: step.currentNode, label: "Active Node"),
                  const SizedBox(width: 20),
                  const Icon(Icons.arrow_back, color: AppTheme.accentNeonCyan),
                  const SizedBox(width: 20),
                  _buildNodeBox(node: step.parentNode, label: "Parent Node"),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        _buildControls(),
      ],
    );
  }

  Widget _buildNodeBox({required int node, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.accentNeonCyan),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 10)),
          const SizedBox(height: 4),
          Text(
            node == -1 ? "NULL (-1)" : "Node $node",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14, fontFamily: 'monospace'),
          ),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.replay, color: Colors.white70),
            onPressed: _reset,
            tooltip: widget.isEnglish ? "Reset" : "রিসেট",
          ),
          IconButton(
            icon: const Icon(Icons.skip_previous, color: Colors.white),
            onPressed: _currentStepIndex > 0 ? _prevStep : null,
            tooltip: widget.isEnglish ? "Previous Step" : "আগের স্টেপ",
          ),
          ElevatedButton.icon(
            onPressed: _togglePlay,
            icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
            label: Text(_isPlaying
                ? (widget.isEnglish ? "Pause" : "পজ করুন")
                : (widget.isEnglish ? "Auto Play" : "অটো প্লে")),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentNeonCyan,
              foregroundColor: AppTheme.primaryDark,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.skip_next, color: Colors.white),
            onPressed: _currentStepIndex < _steps.length - 1 ? _nextStep : null,
            tooltip: widget.isEnglish ? "Next Step" : "পরের স্টেপ",
          ),
          Text(
            "${_currentStepIndex + 1}/${_steps.length}",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
