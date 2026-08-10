import 'dart:math';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';

class HeapVisualizerWidget extends StatefulWidget {
  final bool isEnglish;

  const HeapVisualizerWidget({super.key, required this.isEnglish});

  @override
  State<HeapVisualizerWidget> createState() => _HeapVisualizerWidgetState();
}

class _HeapVisualizerWidgetState extends State<HeapVisualizerWidget> {
  bool _isMinHeap = true; // true = Min Heap (Root = Min), false = Max Heap (Root = Max)

  final TextEditingController _valController = TextEditingController(text: "15");
  List<int> _heapArray = [10, 20, 30, 40, 50, 60, 70];
  int _highlightedIndex = -1;
  String _statusMessage = "";

  @override
  void initState() {
    super.initState();
    _resetHeap();
  }

  void _resetHeap() {
    setState(() {
      if (_isMinHeap) {
        _heapArray = [10, 20, 30, 40, 50, 60, 70];
        _statusMessage = widget.isEnglish
            ? "Min Heap Ready! Root arr[0] = 10 (Minimum Element, Parent <= Children)"
            : "Min Heap প্রস্তুত! Root arr[0] = 10 (সর্বনিম্ন মান, Parent <= Children)";
      } else {
        _heapArray = [70, 60, 50, 40, 30, 20, 10];
        _statusMessage = widget.isEnglish
            ? "Max Heap Ready! Root arr[0] = 70 (Maximum Element, Parent >= Children)"
            : "Max Heap প্রস্তুত! Root arr[0] = 70 (সর্বোচ্চ মান, Parent >= Children)";
      }
      _highlightedIndex = -1;
    });
  }

  @override
  void dispose() {
    _valController.dispose();
    super.dispose();
  }

  void _bubbleUp(int i) {
    while (i > 0) {
      int parent = (i - 1) ~/ 2;
      bool shouldSwap = _isMinHeap ? (_heapArray[i] < _heapArray[parent]) : (_heapArray[i] > _heapArray[parent]);
      if (shouldSwap) {
        int temp = _heapArray[i];
        _heapArray[i] = _heapArray[parent];
        _heapArray[parent] = temp;
        i = parent;
      } else {
        break;
      }
    }
  }

  void _bubbleDown(int i) {
    int n = _heapArray.length;
    while (2 * i + 1 < n) {
      int left = 2 * i + 1;
      int right = 2 * i + 2;
      int target = i;

      if (_isMinHeap) {
        if (_heapArray[left] < _heapArray[target]) target = left;
        if (right < n && _heapArray[right] < _heapArray[target]) target = right;
      } else {
        if (_heapArray[left] > _heapArray[target]) target = left;
        if (right < n && _heapArray[right] > _heapArray[target]) target = right;
      }

      if (target != i) {
        int temp = _heapArray[i];
        _heapArray[i] = _heapArray[target];
        _heapArray[target] = temp;
        i = target;
      } else {
        break;
      }
    }
  }

  void _handleInsert() {
    final val = int.tryParse(_valController.text.trim()) ?? 15;
    setState(() {
      _heapArray.add(val);
      _bubbleUp(_heapArray.length - 1);
      _highlightedIndex = 0; // Root becomes updated
      _statusMessage = _isMinHeap
          ? (widget.isEnglish ? "Inserted $val! Bubble Up restored Min Heap property (root = ${_heapArray[0]})" : "ইনসার্ট $val! Bubble Up করে Min Heap রুল বজায় রাখা হলো।")
          : (widget.isEnglish ? "Inserted $val! Bubble Up restored Max Heap property (root = ${_heapArray[0]})" : "ইনসার্ট $val! Bubble Up করে Max Heap রুল বজায় রাখা হলো।");
    });
  }

  void _handleExtractTop() {
    if (_heapArray.isEmpty) return;

    setState(() {
      final topVal = _heapArray[0];
      if (_heapArray.length == 1) {
        _heapArray.clear();
      } else {
        _heapArray[0] = _heapArray.removeLast();
        _bubbleDown(0);
      }
      _highlightedIndex = -1;
      _statusMessage = _isMinHeap
          ? (widget.isEnglish ? "Extracted Min Top = $topVal in O(log N)! New Min Root = ${_heapArray.isNotEmpty ? _heapArray[0] : 'None'}" : "Extracted Min Top = $topVal (O(log N))! নতুন রুট = ${_heapArray.isNotEmpty ? _heapArray[0] : 'খালি'}")
          : (widget.isEnglish ? "Extracted Max Top = $topVal in O(log N)! New Max Root = ${_heapArray.isNotEmpty ? _heapArray[0] : 'None'}" : "Extracted Max Top = $topVal (O(log N))! নতুন রুট = ${_heapArray.isNotEmpty ? _heapArray[0] : 'খালি'}");
    });
  }

  void _handlePeekTop() {
    if (_heapArray.isEmpty) return;
    setState(() {
      _highlightedIndex = 0;
      _statusMessage = _isMinHeap
          ? (widget.isEnglish ? "Peek Top (O(1)): Minimum Element arr[0] = ${_heapArray[0]}" : "Peek Top (O(1)): সর্বনিম্ন উপাদান arr[0] = ${_heapArray[0]}")
          : (widget.isEnglish ? "Peek Top (O(1)): Maximum Element arr[0] = ${_heapArray[0]}" : "Peek Top (O(1)): সর্বোচ্চ উপাদান arr[0] = ${_heapArray[0]}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Mode Switcher: Min Heap vs Max Heap
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppTheme.surfaceDark,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF334155)),
          ),
          child: Row(
            children: [
              _buildTypeTab(true, "Min Heap (Root = Min)", Icons.unfold_less),
              _buildTypeTab(false, "Max Heap (Root = Max)", Icons.unfold_more),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Status Banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF84CC16).withOpacity(0.15),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF84CC16).withOpacity(0.5)),
          ),
          child: Row(
            children: [
              const Icon(Icons.unfold_more_double, color: Color(0xFF84CC16), size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _statusMessage,
                  style: const TextStyle(
                    color: Color(0xFF84CC16),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Binary Tree Canvas Container
        Container(
          height: 320,
          padding: const EdgeInsets.all(12),
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF090D16),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFF1E293B)),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final canvasWidth = max(constraints.maxWidth, 550.0);
              final canvasHeight = constraints.maxHeight;

              final Map<int, Offset> nodePositions = _calculateHeapNodePositions(canvasWidth, 35, canvasWidth / 4, 65);

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: canvasWidth,
                  height: canvasHeight,
                  child: Stack(
                    children: [
                      // 1. Branch Lines CustomPainter
                      CustomPaint(
                        size: Size(canvasWidth, canvasHeight),
                        painter: HeapTreeBranchPainter(
                          heapArray: _heapArray,
                          nodePositions: nodePositions,
                        ),
                      ),
                      // 2. Positioned Tree Nodes
                      ..._buildHeapNodeWidgets(nodePositions),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),

        // 1D Array Storage Mirror Display
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
                  const Text("1D Array Memory Storage Mirror", style: TextStyle(color: Color(0xFF84CC16), fontWeight: FontWeight.bold, fontSize: 13)),
                  Text("Parent(i)=(i-1)/2 | Left=2i+1 | Right=2i+2", style: TextStyle(color: AppTheme.textMuted, fontSize: 10, fontFamily: 'monospace')),
                ],
              ),
              const SizedBox(height: 14),

              if (_heapArray.isEmpty)
                const Text("Heap is Empty", style: TextStyle(color: AppTheme.textMuted, fontSize: 12))
              else
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(_heapArray.length, (i) {
                      final val = _heapArray[i];
                      final isRoot = i == 0;
                      final isHl = i == _highlightedIndex;

                      return Container(
                        margin: const EdgeInsets.only(right: 6),
                        width: 55,
                        height: 65,
                        decoration: BoxDecoration(
                          color: isRoot
                              ? const Color(0xFF84CC16)
                              : (isHl ? AppTheme.accentPink : const Color(0xFF090D16)),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: isRoot ? Colors.white : const Color(0xFF334155)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("[$i]", style: TextStyle(fontSize: 9, color: isRoot ? AppTheme.primaryDark : AppTheme.textMuted)),
                            const SizedBox(height: 2),
                            Text("$val", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isRoot ? AppTheme.primaryDark : Colors.white)),
                          ],
                        ),
                      );
                    }),
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
                      controller: _valController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: widget.isEnglish ? "Value to Insert" : "যোগ করার মান",
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
                    icon: const Icon(Icons.add, size: 16),
                    label: Text(widget.isEnglish ? "Insert Node (O(log N))" : "ইনসার্ট (Bubble Up)"),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF84CC16), foregroundColor: AppTheme.primaryDark),
                    onPressed: _handleInsert,
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.output, size: 16),
                    label: Text(widget.isEnglish ? "Extract Top (O(log N))" : "টপ এক্সট্র্যাক্ট (Bubble Down)"),
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentPink, foregroundColor: Colors.white),
                    onPressed: _handleExtractTop,
                  ),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.visibility, size: 16),
                    label: Text(widget.isEnglish ? "Peek Top (O(1))" : "টপ দেখা (O(1))"),
                    onPressed: _handlePeekTop,
                  ),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.refresh, size: 16),
                    label: Text(widget.isEnglish ? "Reset Heap" : "রিসেট"),
                    onPressed: _resetHeap,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Calculate coordinates (x, y) for array elements mapped to a complete binary tree
  Map<int, Offset> _calculateHeapNodePositions(double width, double startY, double dx, double dy) {
    final Map<int, Offset> pos = {};
    if (_heapArray.isEmpty) return pos;

    pos[0] = Offset(width / 2, startY);

    for (int i = 0; i < _heapArray.length; i++) {
      final p = pos[i];
      if (p == null) continue;

      int depth = (log(i + 1) / log(2)).floor();
      double currentDx = dx / pow(1.8, depth);

      int left = 2 * i + 1;
      int right = 2 * i + 2;

      if (left < _heapArray.length) {
        pos[left] = Offset(p.dx - currentDx, p.dy + dy);
      }
      if (right < _heapArray.length) {
        pos[right] = Offset(p.dx + currentDx, p.dy + dy);
      }
    }
    return pos;
  }

  List<Widget> _buildHeapNodeWidgets(Map<int, Offset> pos) {
    final List<Widget> widgets = [];
    for (int i = 0; i < _heapArray.length; i++) {
      final p = pos[i];
      if (p == null) continue;

      final isRoot = i == 0;
      final isHl = i == _highlightedIndex;
      final val = _heapArray[i];

      widgets.add(
        Positioned(
          left: p.dx - 22,
          top: p.dy - 22,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isRoot
                  ? const Color(0xFF84CC16)
                  : (isHl ? AppTheme.accentPink : AppTheme.surfaceDark),
              shape: BoxShape.circle,
              border: Border.all(
                color: isRoot ? Colors.white : const Color(0xFF84CC16).withOpacity(0.6),
                width: isRoot ? 2.5 : 1.5,
              ),
              boxShadow: isRoot ? [BoxShadow(color: const Color(0xFF84CC16).withOpacity(0.5), blurRadius: 10)] : [],
            ),
            child: Center(
              child: Text(
                "$val",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: isRoot ? AppTheme.primaryDark : Colors.white,
                ),
              ),
            ),
          ),
        ),
      );
    }
    return widgets;
  }

  Widget _buildTypeTab(bool isMinMode, String title, IconData icon) {
    final isSelected = _isMinHeap == isMinMode;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _isMinHeap = isMinMode;
            _resetHeap();
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF84CC16) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: isSelected ? AppTheme.primaryDark : AppTheme.textSecondary),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? AppTheme.primaryDark : AppTheme.textSecondary,
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

// CustomPainter to draw branch lines connecting parent array index to child array indices
class HeapTreeBranchPainter extends CustomPainter {
  final List<int> heapArray;
  final Map<int, Offset> nodePositions;

  HeapTreeBranchPainter({required this.heapArray, required this.nodePositions});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF334155)
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < heapArray.length; i++) {
      final pPos = nodePositions[i];
      if (pPos == null) continue;

      int left = 2 * i + 1;
      int right = 2 * i + 2;

      if (left < heapArray.length && nodePositions[left] != null) {
        canvas.drawLine(pPos, nodePositions[left]!, paint);
      }
      if (right < heapArray.length && nodePositions[right] != null) {
        canvas.drawLine(pPos, nodePositions[right]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant HeapTreeBranchPainter oldDelegate) => true;
}
