import 'dart:math';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';

class GraphVisualizerWidget extends StatefulWidget {
  final bool isEnglish;

  const GraphVisualizerWidget({super.key, required this.isEnglish});

  @override
  State<GraphVisualizerWidget> createState() => _GraphVisualizerWidgetState();
}

class _GraphVisualizerWidgetState extends State<GraphVisualizerWidget> {
  int _selectedTypeMode = 0; // 0 = Network Canvas, 1 = Adjacency List, 2 = 2D Matrix Grid

  final TextEditingController _uController = TextEditingController(text: "0");
  final TextEditingController _vController = TextEditingController(text: "3");

  final int _vCount = 5;
  late Map<int, List<int>> _adjList;
  late List<List<int>> _adjMatrix;

  List<int> _traversalPath = [];
  int _activeNode = -1;
  String _statusMessage = "";

  @override
  void initState() {
    super.initState();
    _resetGraph();
  }

  void _resetGraph() {
    _adjList = {
      0: [1, 2],
      1: [0, 3, 4],
      2: [0, 4],
      3: [1],
      4: [1, 2],
    };
    _updateMatrixFromList();

    _traversalPath.clear();
    _activeNode = -1;
    _statusMessage = widget.isEnglish
        ? "Graph Network Ready! Vertices V = 5, Edges E = 5 (Adjacency List & Matrix)"
        : "গ্রাফ নেটওয়ার্ক প্রস্তুত! Vertices V = 5, Edges E = 5 (Adjacency List & Matrix)";
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
    final u = int.tryParse(_uController.text.trim()) ?? 0;
    final v = int.tryParse(_vController.text.trim()) ?? 3;

    if (u < 0 || u >= _vCount || v < 0 || v >= _vCount) {
      setState(() {
        _statusMessage = widget.isEnglish ? "⚠️ Invalid Node index! Must be between 0 and ${_vCount - 1}" : "⚠️ ইনভ্যালিড নোড ইন্ডেক্স!";
      });
      return;
    }

    setState(() {
      if (!(_adjList[u] ?? []).contains(v)) {
        _adjList[u]?.add(v);
        _adjList[v]?.add(u);
        _updateMatrixFromList();
        _statusMessage = widget.isEnglish
            ? "Added Undirected Edge ($u ⟷ $v)! Updated Adjacency List & Matrix."
            : "নতুন এজ ($u ⟷ $v) যুক্ত করা হলো!";
      }
    });
  }

  void _runBfs() {
    final List<int> path = [];
    final Set<int> visited = {};
    final List<int> queue = [0];
    visited.add(0);

    while (queue.isNotEmpty) {
      final u = queue.removeAt(0);
      path.add(u);

      for (int v in (_adjList[u] ?? [])) {
        if (!visited.contains(v)) {
          visited.add(v);
          queue.add(v);
        }
      }
    }

    setState(() {
      _traversalPath = path;
      _activeNode = 0;
      _statusMessage = widget.isEnglish
          ? "BFS Traversal (Queue Level-Order): ${path.join(' ➔ ')}"
          : "BFS ট্রাভার্সাল (Queue Level-Order): ${path.join(' ➔ ')}";
    });
  }

  void _runDfs() {
    final List<int> path = [];
    final Set<int> visited = {};

    void dfsHelper(int u) {
      visited.add(u);
      path.add(u);
      for (int v in (_adjList[u] ?? [])) {
        if (!visited.contains(v)) {
          dfsHelper(v);
        }
      }
    }

    dfsHelper(0);

    setState(() {
      _traversalPath = path;
      _activeNode = 0;
      _statusMessage = widget.isEnglish
          ? "DFS Traversal (Stack/Recursive): ${path.join(' ➔ ')}"
          : "DFS ট্রাভার্সাল (Stack/Recursive): ${path.join(' ➔ ')}";
    });
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

        // Status Banner
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
              const Icon(Icons.hub, color: Color(0xFF0284C7), size: 20),
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
                    label: Text(widget.isEnglish ? "Run BFS (Queue)" : "BFS রান করুন"),
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentGreen, foregroundColor: AppTheme.primaryDark),
                    onPressed: _runBfs,
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.alt_route, size: 16),
                    label: Text(widget.isEnglish ? "Run DFS (Stack)" : "DFS রান করুন"),
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentNeonCyan, foregroundColor: AppTheme.primaryDark),
                    onPressed: _runDfs,
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
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(color: AppTheme.surfaceDark, borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFF334155))),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: const Color(0xFF0284C7), borderRadius: BorderRadius.circular(6)),
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
                    return Row(
                      children: [
                        SizedBox(width: 45, height: 40, child: Center(child: Text("N$u", style: const TextStyle(color: Color(0xFF0284C7), fontWeight: FontWeight.bold, fontSize: 12)))),
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
                  traversalPath: _traversalPath,
                ),
              ),
              ...List.generate(_vCount, (i) {
                final pos = nodePositions[i]!;
                final isVisited = _traversalPath.contains(i);

                return Positioned(
                  left: pos.dx - 22,
                  top: pos.dy - 22,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: isVisited ? AppTheme.accentGreen : const Color(0xFF0284C7),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: isVisited ? 2.5 : 1),
                      boxShadow: isVisited ? [BoxShadow(color: AppTheme.accentGreen.withOpacity(0.5), blurRadius: 10)] : [],
                    ),
                    child: Center(
                      child: Text(
                        "N$i",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isVisited ? AppTheme.primaryDark : Colors.white,
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
  final List<int> traversalPath;

  GraphEdgePainter({
    required this.adjList,
    required this.nodePositions,
    required this.traversalPath,
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

    final visitedEdges = <String>{};
    for (int i = 0; i < traversalPath.length - 1; i++) {
      int u = traversalPath[i];
      int v = traversalPath[i + 1];
      visitedEdges.add("$u-$v");
      visitedEdges.add("$v-$u");
    }

    adjList.forEach((u, neighbors) {
      final p1 = nodePositions[u];
      if (p1 == null) return;

      for (int v in neighbors) {
        final p2 = nodePositions[v];
        if (p2 == null || u >= v) continue; // Draw each edge once

        final isVisitedEdge = visitedEdges.contains("$u-$v");
        canvas.drawLine(p1, p2, isVisitedEdge ? visitedPaint : defaultPaint);
      }
    });
  }

  @override
  bool shouldRepaint(covariant GraphEdgePainter oldDelegate) => true;
}
