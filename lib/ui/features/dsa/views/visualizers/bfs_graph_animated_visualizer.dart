import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';

class BfsGraphAnimatedVisualizer extends StatefulWidget {
  final bool isEnglish;

  const BfsGraphAnimatedVisualizer({
    super.key,
    required this.isEnglish,
  });

  @override
  State<BfsGraphAnimatedVisualizer> createState() =>
      _BfsGraphAnimatedVisualizerState();
}

class BfsStepData {
  final int currentNode;
  final List<int> queueState;
  final List<int> visitedNodes;
  final String titleEn;
  final String titleBn;
  final String explanationEn;
  final String explanationBn;

  const BfsStepData({
    required this.currentNode,
    required this.queueState,
    required this.visitedNodes,
    required this.titleEn,
    required this.titleBn,
    required this.explanationEn,
    required this.explanationBn,
  });
}

class _BfsGraphAnimatedVisualizerState
    extends State<BfsGraphAnimatedVisualizer> {
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  late final List<BfsStepData> _steps;

  @override
  void initState() {
    super.initState();
    _steps = const [
      BfsStepData(
        currentNode: 0,
        queueState: [0],
        visitedNodes: [0],
        titleEn: "1. Start BFS at Node 0 -> Enqueue & Mark Visited",
        titleBn: "১. নোড 0 থেকে BFS শুরু -> কিউতে পুশ ও ভিজিটেড মার্ক",
        explanationEn: "Start BFS at Node 0. Push 0 into FIFO Queue and mark Visited[0] = true.",
        explanationBn: "নোড 0 থেকে BFS ট্রাভার্সাল শুরু। কিউতে 0 পুশ করা হলো।",
      ),
      BfsStepData(
        currentNode: 0,
        queueState: [1, 2],
        visitedNodes: [0, 1, 2],
        titleEn: "2. Dequeue Node 0 -> Enqueue Neighbors 1 & 2",
        titleBn: "২. নোড 0 পপ -> প্রতিবেশী নোড 1 ও 2 কিউতে পুশ",
        explanationEn: "Dequeue Node 0. Discover neighbors of 0: Nodes 1 and 2 are enqueued into FIFO Queue.",
        explanationBn: "নোড 0 পপ করা হলো। নোড 0 এর প্রতিবেশী 1 ও 2 কিউতে পুশ করা হলো।",
      ),
      BfsStepData(
        currentNode: 1,
        queueState: [2, 3, 4],
        visitedNodes: [0, 1, 2, 3, 4],
        titleEn: "3. Dequeue Node 1 -> Enqueue Neighbors 3 & 4",
        titleBn: "৩. নোড 1 পপ -> প্রতিবেশী নোড 3 ও 4 কিউতে পুশ",
        explanationEn: "Dequeue Node 1. Discover unvisited neighbors of 1: Nodes 3 and 4 are enqueued.",
        explanationBn: "নোড 1 পপ। নোড 1 এর অপাঠক প্রতিবেশী 3 ও 4 কিউতে পুশ করা হলো।",
      ),
      BfsStepData(
        currentNode: 2,
        queueState: [3, 4],
        visitedNodes: [0, 1, 2, 3, 4],
        titleEn: "4. Dequeue Node 2 -> Neighbors already visited",
        titleBn: "৪. নোড 2 পপ -> প্রতিবেশীগুলো আগেই ভিজিটেড",
        explanationEn: "Dequeue Node 2. Neighbors 0 and 4 are already visited.",
        explanationBn: "নোড 2 পপ। প্রতিবেশী 0 ও 4 আগে থেকেই ভিজিটেড থাকায় বাদ।",
      ),
      BfsStepData(
        currentNode: 3,
        queueState: [4],
        visitedNodes: [0, 1, 2, 3, 4],
        titleEn: "5. Dequeue Node 3",
        titleBn: "৫. নোড 3 পপ",
        explanationEn: "Dequeue Node 3. All neighbors visited.",
        explanationBn: "নোড 3 পপ। সমস্ত প্রতিবেশী ভিজিটেড।",
      ),
      BfsStepData(
        currentNode: 4,
        queueState: [],
        visitedNodes: [0, 1, 2, 3, 4],
        titleEn: "6. Dequeue Node 4 -> Queue Empty! BFS Complete! 🎉",
        titleBn: "৬. নোড 4 পপ -> কিউ খালি! BFS ট্রাভার্সাল সম্পূর্ণ! 🎉",
        explanationEn: "Queue becomes empty! Level-Order BFS Traversal Order: [0, 1, 2, 3, 4] in O(V + E) time! 🎉",
        explanationBn: "কিউ সম্পূর্ণ খালি! লেভেল-বাই-লেভেল BFS অর্ডার: [0, 1, 2, 3, 4]! 🎉",
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
              const Icon(Icons.hub, color: AppTheme.accentNeonCyan, size: 24),
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

        // Visual Representation of BFS Queue and Visited Traversal
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
              const Text("1. FIFO Queue State (Level Order Front ➔ Rear):", style: TextStyle(color: AppTheme.accentNeonCyan, fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: step.queueState.isEmpty
                      ? [const Text("Queue is Empty", style: TextStyle(color: Colors.white54, fontSize: 12))]
                      : List.generate(step.queueState.length, (idx) {
                          final isFront = idx == 0;
                          return Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: isFront ? AppTheme.accentNeonCyan.withOpacity(0.25) : AppTheme.surfaceDark,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: isFront ? AppTheme.accentNeonCyan : const Color(0xFF334155)),
                            ),
                            child: Text(
                              "Node ${step.queueState[idx]}",
                              style: TextStyle(
                                color: isFront ? AppTheme.accentNeonCyan : Colors.white,
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
              const Text("2. BFS Visited Traversal Order:", style: TextStyle(color: AppTheme.accentGreen, fontSize: 12, fontWeight: FontWeight.bold)),
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
