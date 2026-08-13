import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';

class DfsGraphAnimatedVisualizer extends StatefulWidget {
  final bool isEnglish;

  const DfsGraphAnimatedVisualizer({
    super.key,
    required this.isEnglish,
  });

  @override
  State<DfsGraphAnimatedVisualizer> createState() =>
      _DfsGraphAnimatedVisualizerState();
}

class DfsStepData {
  final int currentNode;
  final List<int> stackState;
  final List<int> visitedNodes;
  final String titleEn;
  final String titleBn;
  final String explanationEn;
  final String explanationBn;

  const DfsStepData({
    required this.currentNode,
    required this.stackState,
    required this.visitedNodes,
    required this.titleEn,
    required this.titleBn,
    required this.explanationEn,
    required this.explanationBn,
  });
}

class _DfsGraphAnimatedVisualizerState
    extends State<DfsGraphAnimatedVisualizer> {
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  late final List<DfsStepData> _steps;

  @override
  void initState() {
    super.initState();
    _steps = const [
      DfsStepData(
        currentNode: 0,
        stackState: [0],
        visitedNodes: [0],
        titleEn: "1. Start DFS at Node 0 -> Push to Call Stack",
        titleBn: "১. নোড 0 থেকে DFS শুরু -> কল স্ট্যাকে পুশ",
        explanationEn: "Start DFS at Node 0. Push 0 into Call Stack and mark Visited[0] = true.",
        explanationBn: "নোড 0 থেকে রিকার্সিভ DFS ট্রাভার্সাল শুরু।",
      ),
      DfsStepData(
        currentNode: 1,
        stackState: [0, 1],
        visitedNodes: [0, 1],
        titleEn: "2. Recurse Deep to Neighbor Node 1",
        titleBn: "২. প্রতিবেশী নোড 1 এ গভীরে রিকার্সন",
        explanationEn: "Go deep into first unvisited neighbor of 0: Node 1. Push 1 to Call Stack.",
        explanationBn: "নোড 0 এর প্রথম নোড 1 এ গভীরে প্রবেশ। কল স্ট্যাকে 1 পুশ।",
      ),
      DfsStepData(
        currentNode: 3,
        stackState: [0, 1, 3],
        visitedNodes: [0, 1, 3],
        titleEn: "3. Recurse Deep to Neighbor Node 3",
        titleBn: "৩. প্রতিবেশী নোড 3 এ গভীরে রিকার্সন",
        explanationEn: "Go deep into neighbor of 1: Node 3. Push 3 to Call Stack.",
        explanationBn: "নোড 1 এর প্রতিবেশী 3 এ গভীরে রিকার্সন।",
      ),
      DfsStepData(
        currentNode: 0,
        stackState: [0],
        visitedNodes: [0, 1, 3],
        titleEn: "4. Dead End at Node 3 -> Backtrack to Node 0",
        titleBn: "৪. নোড 3 এ শেষ সীমানা -> ব্যাকট্র্যাক করে নোড 0 এ ফেরত",
        explanationEn: "Node 3 has no further unvisited neighbors. Pop stack, backtrack to Node 0.",
        explanationBn: "নোড 3 এর কোনো প্রতিবেশী নেই। ব্যাকট্র্যাক করে নোড 0 এ ফেরা হলো।",
      ),
      DfsStepData(
        currentNode: 2,
        stackState: [0, 2],
        visitedNodes: [0, 1, 3, 2],
        titleEn: "5. Recurse Deep to Neighbor Node 2",
        titleBn: "৫. প্রতিবেশী নোড 2 এ রিকার্সন",
        explanationEn: "From Node 0, visit next unvisited neighbor: Node 2.",
        explanationBn: "নোড 0 থেকে পরবর্তী অপাঠক প্রতিবেশী 2 এ রিকার্সন।",
      ),
      DfsStepData(
        currentNode: 4,
        stackState: [0, 2, 4],
        visitedNodes: [0, 1, 3, 2, 4],
        titleEn: "6. Recurse Deep to Node 4 -> DFS Complete! 🎉",
        titleBn: "৬. নোড 4 এ রিকার্সন -> DFS ট্রাভার্সাল সম্পূর্ণ! 🎉",
        explanationEn: "Visit Node 4. All V nodes visited! Deep-Path DFS Order: [0, 1, 3, 2, 4]! 🎉",
        explanationBn: "নোড 4 ভিসিট সম্পন্ন! গভীরের পথ DFS ট্রাভার্সাল অর্ডার: [0, 1, 3, 2, 4]! 🎉",
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
            color: AppTheme.accentNeonCyan.withOpacity(0.12),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.accentNeonCyan.withOpacity(0.5)),
          ),
          child: Row(
            children: [
              const Icon(Icons.account_tree_outlined, color: AppTheme.accentNeonCyan, size: 24),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.isEnglish ? step.titleEn : step.titleBn,
                      style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
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

        // Visual Representation of DFS Call Stack & Visited Order
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF090D16),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF1E293B)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("1. Recursive Call Stack State (Top ➔ Bottom):", style: TextStyle(color: AppTheme.accentPurple, fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: step.stackState.isEmpty
                      ? [const Text("Call Stack is Empty", style: TextStyle(color: Colors.white54, fontSize: 12))]
                      : List.generate(step.stackState.length, (idx) {
                          final isTop = idx == step.stackState.length - 1;
                          return Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: isTop ? AppTheme.accentPurple.withOpacity(0.3) : AppTheme.surfaceDark,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: isTop ? AppTheme.accentPurple : const Color(0xFF334155)),
                            ),
                            child: Text(
                              "Node ${step.stackState[idx]}",
                              style: TextStyle(
                                color: isTop ? AppTheme.accentPurple : Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'monospace',
                              ),
                            ),
                          );
                        }),
                ),
              ),
              const SizedBox(height: 20),

              // Visited Nodes Array
              const Text("2. DFS Deep Path Visited Order:", style: TextStyle(color: AppTheme.accentGreen, fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(step.visitedNodes.length, (idx) {
                    return Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppTheme.accentGreen.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppTheme.accentGreen),
                      ),
                      child: Text(
                        "Node ${step.visitedNodes[idx]}",
                        style: const TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontFamily: 'monospace'),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        _buildControls(),
      ],
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
