import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';

class GraphVisualizerWidget extends StatefulWidget {
  final bool isEnglish;

  const GraphVisualizerWidget({super.key, required this.isEnglish});

  @override
  State<GraphVisualizerWidget> createState() => _GraphVisualizerWidgetState();
}

class _GraphVisualizerStep {
  final int currentNode;
  final List<int> visitedNodes;
  final List<int> containerState; // Queue or Stack state
  final String description;

  _GraphVisualizerStep({
    required this.currentNode,
    required this.visitedNodes,
    required this.containerState,
    required this.description,
  });
}

class _GraphVisualizerWidgetState extends State<GraphVisualizerWidget> {
  int _selectedTypeMode = 0; // 0 = Network Canvas, 1 = Adjacency List, 2 = 2D Matrix Grid

  final TextEditingController _uController = TextEditingController(text: "0");
  final TextEditingController _vController = TextEditingController(text: "3");

  final int _vCount = 5;
  late Map<int, List<int>> _adjList;
  late List<List<int>> _adjMatrix;

  // Step-by-Step Animation state
  bool _isAnimating = false;
  bool _isBfsMode = true; // true = BFS (Queue), false = DFS (Stack)
  int _currentAnimatedNode = -1;
  List<int> _animatedVisitedNodes = [];
  List<int> _animatedContainerItems = [];
  String _statusMessage = "";

  @override
  void initState() {
    super.initState();
    _resetGraph();
  }

  void _resetGraph() {
    _isAnimating = false;
    _adjList = {
      0: [1, 2],
      1: [0, 3, 4],
      2: [0, 4],
      3: [1],
      4: [1, 2],
    };
    _updateMatrixFromList();

    _currentAnimatedNode = -1;
    _animatedVisitedNodes.clear();
    _animatedContainerItems.clear();
    _statusMessage = widget.isEnglish
        ? "Graph Network Ready! Click 'Run BFS' or 'Run DFS' to see node-by-node animation."
        : "গ্রাফ নেটওয়ার্ক প্রস্তুত! নোড-বাই-নোড অ্যানিমেশন দেখতে 'Run BFS' বা 'Run DFS' এ চাপ দিন।";
  }

  void _updateMatrixFromList() {
    _adjMatrix = List.generate(_vCount, (_) => List.filled(_vCount, 0));
    for (int u = 0; u < _vCount; u++) {
      for (int v in _adjList[u] ?? []) {
        if (v < _vCount) {
          _adjMatrix[u][v] = 1;
        }
      }
    }
  }

  @override
  void dispose() {
    _uController.dispose();
    _vController.dispose();
    super.dispose();
  }

  void _handleAddEdge() {
    if (_isAnimating) return;
    final u = int.tryParse(_uController.text.trim()) ?? 0;
    final v = int.tryParse(_vController.text.trim()) ?? 3;

    if (u < 0 || u >= _vCount || v < 0 || v >= _vCount) {
      setState(() {
        _statusMessage = widget.isEnglish ? "⚠️ Invalid Node index! Must be 0 to ${_vCount - 1}" : "⚠️ ইনভ্যালিড নোড ইন্ডেক্স!";
      });
      return;
    }

    setState(() {
      if (!(_adjList[u] ?? []).contains(v)) {
        _adjList[u]?.add(v);
        _adjList[v]?.add(u);
        _updateMatrixFromList();
        _statusMessage = widget.isEnglish
            ? "Added Undirected Edge ($u ⟷ $v)! Graph updated."
            : "নতুন এজ ($u ⟷ $v) যুক্ত করা হলো!";
      }
    });
  }

  // Node-by-Node Animated BFS Simulation
  Future<void> _runAnimatedBfs() async {
    if (_isAnimating) return;

    setState(() {
      _isAnimating = true;
      _isBfsMode = true;
      _currentAnimatedNode = -1;
      _animatedVisitedNodes.clear();
      _animatedContainerItems.clear();
      _statusMessage = widget.isEnglish ? "Starting BFS Node-by-Node Queue Animation..." : "BFS নোড-বাই-নোড অ্যানিমেশন শুরু হচ্ছে...";
    });

    final List<_GraphVisualizerStep> steps = [];
    final List<int> queue = [0];
    final Set<int> visited = {0};

    steps.add(_GraphVisualizerStep(
      currentNode: 0,
      visitedNodes: [0],
      containerState: List.from(queue),
      description: widget.isEnglish ? "Step 1: Start at Node 0 ➔ Enqueued Node 0 in Queue" : "ধাপ ১: নোড 0 এ শুরু ➔ কিউতে নোড 0 পুশ করা হলো",
    ));

    while (queue.isNotEmpty) {
      final u = queue.removeAt(0);

      steps.add(_GraphVisualizerStep(
        currentNode: u,
        visitedNodes: List.from(visited),
        containerState: List.from(queue),
        description: widget.isEnglish ? "Visiting Node $u (Dequeued from Queue Front)" : "নোড $u ভিজিট করা হচ্ছে (কিউয়ের ফ্রন্ট থেকে ডিকেল)",
      ));

      for (int v in (_adjList[u] ?? [])) {
        if (!visited.contains(v)) {
          visited.add(v);
          queue.add(v);

          steps.add(_GraphVisualizerStep(
            currentNode: v,
            visitedNodes: List.from(visited),
            containerState: List.from(queue),
            description: widget.isEnglish ? "Discovered Neighbor Node $v ➔ Enqueued in Queue Rear" : "নতুন প্রতিবেশী নোড $v পাওয়া গেছে ➔ কিউয়ের পেছনে যুক্ত",
          ));
        }
      }
    }

    // Execute step-by-step animation loop with delays
    for (var step in steps) {
      if (!mounted) return;
      setState(() {
        _currentAnimatedNode = step.currentNode;
        _animatedVisitedNodes = step.visitedNodes;
        _animatedContainerItems = step.containerState;
        _statusMessage = step.description;
      });
      await Future.delayed(const Duration(milliseconds: 800));
    }

    if (mounted) {
      setState(() {
        _isAnimating = false;
        _statusMessage = widget.isEnglish
            ? "✅ BFS Animation Complete! Traversal Order: [${_animatedVisitedNodes.join(', ')}]"
            : "✅ BFS অ্যানিমেশন সম্পন্ন! ট্রাভার্সাল ক্রম: [${_animatedVisitedNodes.join(', ')}]";
      });
    }
  }

  // Node-by-Node Animated DFS Simulation
  Future<void> _runAnimatedDfs() async {
    if (_isAnimating) return;

    setState(() {
      _isAnimating = true;
      _isBfsMode = false;
      _currentAnimatedNode = -1;
      _animatedVisitedNodes.clear();
      _animatedContainerItems.clear();
      _statusMessage = widget.isEnglish ? "Starting DFS Node-by-Node Stack Animation..." : "DFS নোড-বাই-নোড অ্যানিমেশন শুরু হচ্ছে...";
    });

    final List<_GraphVisualizerStep> steps = [];
    final List<int> stack = [];
    final Set<int> visited = {};

    void dfsRecursive(int u) {
      visited.add(u);
      stack.add(u);

      steps.add(_GraphVisualizerStep(
        currentNode: u,
        visitedNodes: List.from(visited),
        containerState: List.from(stack),
        description: widget.isEnglish ? "Visiting Node $u ➔ Pushed to Call Stack" : "নোড $u ভিজিট করা হচ্ছে ➔ স্ট্যাকে পুশ করা হলো",
      ));

      for (int v in (_adjList[u] ?? [])) {
        if (!visited.contains(v)) {
          dfsRecursive(v);
        }
      }

      stack.removeLast();
      if (stack.isNotEmpty) {
        steps.add(_GraphVisualizerStep(
          currentNode: stack.last,
          visitedNodes: List.from(visited),
          containerState: List.from(stack),
          description: widget.isEnglish ? "Backtracking from Node $u ➔ Returned to Node ${stack.last}" : "নোড $u থেকে ব্যাকট্র্যাক ➔ নোড ${stack.last} এ ফিরে আসা হলো",
        ));
      }
    }

    dfsRecursive(0);

    // Execute step-by-step animation loop with delays
    for (var step in steps) {
      if (!mounted) return;
      setState(() {
        _currentAnimatedNode = step.currentNode;
        _animatedVisitedNodes = step.visitedNodes;
        _animatedContainerItems = step.containerState;
        _statusMessage = step.description;
      });
      await Future.delayed(const Duration(milliseconds: 850));
    }

    if (mounted) {
      setState(() {
        _isAnimating = false;
        _statusMessage = widget.isEnglish
            ? "✅ DFS Animation Complete! Traversal Order: [${_animatedVisitedNodes.join(', ')}]"
            : "✅ DFS অ্যানিমেশন সম্পন্ন! ট্রাভার্সাল ক্রম: [${_animatedVisitedNodes.join(', ')}]";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Mode Switcher
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppTheme.surfaceDark,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF334155)),
          ),
          child: Row(
            children: [
              _buildTypeTab(0, "Network Graph", Icons.hub_outlined),
              _buildTypeTab(1, "Adjacency List", Icons.format_list_bulleted),
              _buildTypeTab(2, "2D Matrix Grid", Icons.grid_on),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Animated Status Banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF0284C7).withOpacity(0.15),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF0284C7).withOpacity(0.5)),
          ),
          child: Row(
            children: [
              Icon(
                _isAnimating ? Icons.sync : Icons.hub,
                color: const Color(0xFF0284C7),
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _statusMessage,
                  style: const TextStyle(
                    color: Color(0xFF0284C7),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Display Canvas
        Container(
          height: 320,
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF090D16),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFF1E293B)),
          ),
          child: _buildCanvasContent(),
        ),
        const SizedBox(height: 16),

        // Live Queue / Stack Container Display
        Container(
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppTheme.surfaceDark,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFF334155)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _isBfsMode ? "Live Queue State (FIFO - Enqueue Rear / Dequeue Front)" : "Live Stack State (LIFO - Push / Pop Top)",
                    style: TextStyle(
                      color: _isBfsMode ? AppTheme.accentGreen : AppTheme.accentNeonCyan,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    _isBfsMode ? "Front ➔ Rear" : "Bottom ➔ Top",
                    style: const TextStyle(color: AppTheme.textMuted, fontSize: 10, fontFamily: 'monospace'),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              if (_animatedContainerItems.isEmpty)
                Text(
                  widget.isEnglish ? "Queue / Stack is empty" : "কিউ / স্ট্যাক খালি",
                  style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
                )
              else
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _animatedContainerItems.map((nodeVal) {
                      final isCurrent = nodeVal == _currentAnimatedNode;
                      return Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: isCurrent
                              ? AppTheme.accentPink
                              : (_isBfsMode ? AppTheme.accentGreen : AppTheme.accentNeonCyan),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: isCurrent ? Colors.white : Colors.transparent),
                        ),
                        child: Text(
                          "Node $nodeVal",
                          style: TextStyle(
                            color: isCurrent ? Colors.white : AppTheme.primaryDark,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Controls
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surfaceDark,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFF334155)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _uController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: widget.isEnglish ? "Node U" : "নোড U",
                        labelStyle: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                        filled: true,
                        fillColor: AppTheme.primaryDark,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _vController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: widget.isEnglish ? "Node V" : "নোড V",
                        labelStyle: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                        filled: true,
                        fillColor: AppTheme.primaryDark,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add_link, size: 16),
                    label: Text(widget.isEnglish ? "Add Edge(U, V)" : "এজ যোগ করুন"),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0284C7), foregroundColor: Colors.white),
                    onPressed: _handleAddEdge,
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.play_arrow, size: 16),
                    label: Text(widget.isEnglish ? "Node-by-Node BFS (Queue)" : "অ্যানিমেটেড BFS"),
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentGreen, foregroundColor: AppTheme.primaryDark),
                    onPressed: _isAnimating ? null : _runAnimatedBfs,
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.alt_route, size: 16),
                    label: Text(widget.isEnglish ? "Node-by-Node DFS (Stack)" : "অ্যানিমেটেড DFS"),
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentNeonCyan, foregroundColor: AppTheme.primaryDark),
                    onPressed: _isAnimating ? null : _runAnimatedDfs,
                  ),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.refresh, size: 16),
                    label: Text(widget.isEnglish ? "Reset Graph" : "রিসেট"),
                    onPressed: () {
                      setState(() {
                        _resetGraph();
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCanvasContent() {
    if (_selectedTypeMode == 1) {
      // Adjacency List View
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Adjacency List Representation O(V + E)", style: TextStyle(color: Color(0xFF0284C7), fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 12),
            ...List.generate(_vCount, (u) {
              final neighbors = _adjList[u] ?? [];
              final isCurrent = u == _currentAnimatedNode;
              final isVisited = _animatedVisitedNodes.contains(u);

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isCurrent ? AppTheme.accentPink.withOpacity(0.2) : AppTheme.surfaceDark,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: isCurrent ? AppTheme.accentPink : (isVisited ? AppTheme.accentGreen : const Color(0xFF334155))),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: isCurrent ? AppTheme.accentPink : const Color(0xFF0284C7), borderRadius: BorderRadius.circular(6)),
                      child: Text("Node $u", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.east, color: AppTheme.textMuted, size: 16),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Wrap(
                        spacing: 6,
                        children: neighbors.map((v) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(color: AppTheme.primaryDark, borderRadius: BorderRadius.circular(6), border: Border.all(color: AppTheme.accentGreen.withOpacity(0.5))),
                            child: Text("Node $v", style: const TextStyle(color: AppTheme.accentGreen, fontSize: 12)),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      );
    } else if (_selectedTypeMode == 2) {
      // 2D Adjacency Matrix Grid View
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("2D Adjacency Matrix Grid O(V²)", style: TextStyle(color: Color(0xFF0284C7), fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 12),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                children: [
                  // Matrix Header
                  Row(
                    children: [
                      const SizedBox(width: 45, height: 35, child: Center(child: Text("U\\V", style: TextStyle(color: AppTheme.textMuted, fontSize: 11)))),
                      ...List.generate(_vCount, (v) => SizedBox(width: 45, height: 35, child: Center(child: Text("N$v", style: const TextStyle(color: Color(0xFF0284C7), fontWeight: FontWeight.bold, fontSize: 12))))),
                    ],
                  ),
                  // Matrix Rows
                  ...List.generate(_vCount, (u) {
                    final isCurrent = u == _currentAnimatedNode;
                    return Row(
                      children: [
                        SizedBox(width: 45, height: 40, child: Center(child: Text("N$u", style: TextStyle(color: isCurrent ? AppTheme.accentPink : const Color(0xFF0284C7), fontWeight: FontWeight.bold, fontSize: 12)))),
                        ...List.generate(_vCount, (v) {
                          final hasEdge = _adjMatrix[u][v] == 1;
                          return Container(
                            width: 42,
                            height: 38,
                            margin: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: hasEdge ? AppTheme.accentGreen : AppTheme.surfaceDark,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Center(
                              child: Text(
                                "${_adjMatrix[u][v]}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: hasEdge ? AppTheme.primaryDark : AppTheme.textMuted,
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      );
    } else {
      // Network Graph Canvas
      return LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;
          final center = Offset(width / 2, height / 2);
          final radius = min(width, height) / 2 - 35;

          final Map<int, Offset> nodePositions = {};
          for (int i = 0; i < _vCount; i++) {
            final angle = (2 * pi * i / _vCount) - (pi / 2);
            nodePositions[i] = Offset(center.dx + radius * cos(angle), center.dy + radius * sin(angle));
          }

          return Stack(
            children: [
              CustomPaint(
                size: Size(width, height),
                painter: GraphEdgePainter(
                  adjList: _adjList,
                  nodePositions: nodePositions,
                  visitedNodes: _animatedVisitedNodes,
                  currentNode: _currentAnimatedNode,
                ),
              ),
              ...List.generate(_vCount, (i) {
                final pos = nodePositions[i]!;
                final isCurrent = i == _currentAnimatedNode;
                final isVisited = _animatedVisitedNodes.contains(i);

                return Positioned(
                  left: pos.dx - 22,
                  top: pos.dy - 22,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: isCurrent
                          ? AppTheme.accentPink
                          : (isVisited
                              ? (_isBfsMode ? AppTheme.accentGreen : AppTheme.accentNeonCyan)
                              : const Color(0xFF0284C7)),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: (isCurrent || isVisited) ? Colors.white : const Color(0xFF0284C7),
                        width: (isCurrent || isVisited) ? 2.5 : 1,
                      ),
                      boxShadow: isCurrent
                          ? [BoxShadow(color: AppTheme.accentPink.withOpacity(0.6), blurRadius: 12)]
                          : (isVisited ? [BoxShadow(color: AppTheme.accentGreen.withOpacity(0.5), blurRadius: 10)] : []),
                    ),
                    child: Center(
                      child: Text(
                        "N$i",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: (isCurrent || isVisited) ? AppTheme.primaryDark : Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          );
        },
      );
    }
  }

  Widget _buildTypeTab(int modeIndex, String title, IconData icon) {
    final isSelected = _selectedTypeMode == modeIndex;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedTypeMode = modeIndex;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF0284C7) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: isSelected ? Colors.white : AppTheme.textSecondary),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? Colors.white : AppTheme.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// CustomPainter to draw edge lines connecting graph nodes
class GraphEdgePainter extends CustomPainter {
  final Map<int, List<int>> adjList;
  final Map<int, Offset> nodePositions;
  final List<int> visitedNodes;
  final int currentNode;

  GraphEdgePainter({
    required this.adjList,
    required this.nodePositions,
    required this.visitedNodes,
    required this.currentNode,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final defaultPaint = Paint()
      ..color = const Color(0xFF334155)
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke;

    final visitedPaint = Paint()
      ..color = AppTheme.accentGreen
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    final activePaint = Paint()
      ..color = AppTheme.accentPink
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke;

    adjList.forEach((u, neighbors) {
      final p1 = nodePositions[u];
      if (p1 == null) return;

      for (int v in neighbors) {
        final p2 = nodePositions[v];
        if (p2 == null || u >= v) continue; // Draw each edge once

        final isCurrentEdge = (u == currentNode && visitedNodes.contains(v)) || (v == currentNode && visitedNodes.contains(u));
        final isVisitedEdge = visitedNodes.contains(u) && visitedNodes.contains(v);

        if (isCurrentEdge) {
          canvas.drawLine(p1, p2, activePaint);
        } else if (isVisitedEdge) {
          canvas.drawLine(p1, p2, visitedPaint);
        } else {
          canvas.drawLine(p1, p2, defaultPaint);
        }
      }
    });
  }

  @override
  bool shouldRepaint(covariant GraphEdgePainter oldDelegate) => true;
}
