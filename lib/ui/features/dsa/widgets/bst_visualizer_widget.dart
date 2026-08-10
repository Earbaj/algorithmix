import 'dart:math';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class BstNode {
  int val;
  BstNode? left;
  BstNode? right;
  double x = 0;
  double y = 0;
  BstNode(this.val, {this.left, this.right});
}

class BstVisualizerWidget extends StatefulWidget {
  final bool isEnglish;

  const BstVisualizerWidget({super.key, required this.isEnglish});

  @override
  State<BstVisualizerWidget> createState() => _BstVisualizerWidgetState();
}

class _BstVisualizerWidgetState extends State<BstVisualizerWidget> {
  int _selectedTypeMode = 0; // 0 = Graphical Tree Canvas, 1 = Inorder Traversal Walk

  final TextEditingController _valController = TextEditingController(text: "25");
  BstNode? _root;
  int _highlightedVal = -1;
  List<int> _searchPath = [];
  List<int> _inorderSequence = [];
  String _statusMessage = "";

  @override
  void initState() {
    super.initState();
    _resetTree();
  }

  void _resetTree() {
    // Initial BST: 50 as root, with balanced children 30, 70, 20, 40, 60, 80
    _root = BstNode(50);
    _insert(_root, 30);
    _insert(_root, 70);
    _insert(_root, 20);
    _insert(_root, 40);
    _insert(_root, 60);
    _insert(_root, 80);

    _highlightedVal = -1;
    _searchPath.clear();
    _inorderSequence.clear();
    _statusMessage = widget.isEnglish
        ? "Graphical BST Canvas ready! Root = 50 (Left Subtree < 50 < Right Subtree)"
        : "গ্রাফিক্যাল BST ক্যানভাস প্রস্তুত! Root = 50 (Left Subtree < 50 < Right Subtree)";
  }

  @override
  void dispose() {
    _valController.dispose();
    super.dispose();
  }

  BstNode _insert(BstNode? node, int val) {
    if (node == null) return BstNode(val);
    if (val < node.val) {
      node.left = _insert(node.left, val);
    } else if (val > node.val) {
      node.right = _insert(node.right, val);
    }
    return node;
  }

  BstNode? _delete(BstNode? node, int val) {
    if (node == null) return null;
    if (val < node.val) {
      node.left = _delete(node.left, val);
    } else if (val > node.val) {
      node.right = _delete(node.right, val);
    } else {
      if (node.left == null) return node.right;
      if (node.right == null) return node.left;
      BstNode minRight = node.right!;
      while (minRight.left != null) {
        minRight = minRight.left!;
      }
      node.val = minRight.val;
      node.right = _delete(node.right, minRight.val);
    }
    return node;
  }

  void _handleInsert() {
    final val = int.tryParse(_valController.text.trim()) ?? 25;
    setState(() {
      _root = _insert(_root, val);
      _highlightedVal = val;
      _searchPath = [val];
      _statusMessage = widget.isEnglish
          ? "Inserted node $val into BST in O(log N) time! Re-rendered tree branches."
          : "BST তে $val ইনসার্ট করা হলো (O(log N))! নতুন ব্রাঞ্চ শাখা যুক্ত হলো।";
    });
  }

  void _handleSearch() {
    final val = int.tryParse(_valController.text.trim()) ?? 30;
    BstNode? curr = _root;
    bool found = false;
    List<int> path = [];

    while (curr != null) {
      path.add(curr.val);
      if (curr.val == val) {
        found = true;
        break;
      } else if (val < curr.val) {
        curr = curr.left;
      } else {
        curr = curr.right;
      }
    }

    setState(() {
      _highlightedVal = found ? val : -1;
      _searchPath = path;
      _statusMessage = found
          ? (widget.isEnglish
              ? "FOUND $val! Search Path: ${path.join(' ➔ ')}"
              : "খুঁজে পাওয়া গেছে! সার্চ পাথ: ${path.join(' ➔ ')}")
          : (widget.isEnglish
              ? "❌ $val Not Found in BST. Search Path: ${path.join(' ➔ ')}"
              : "❌ $val পাওয়া যায়নি! সার্চ পাথ: ${path.join(' ➔ ')}");
    });
  }

  void _handleDelete() {
    final val = int.tryParse(_valController.text.trim()) ?? 30;
    setState(() {
      _root = _delete(_root, val);
      _highlightedVal = -1;
      _searchPath.clear();
      _statusMessage = widget.isEnglish
          ? "Deleted node $val from BST in O(log N) time! Restructured tree subtrees."
          : "BST থেকে $val নোড ডিলেট করা হলো (O(log N))!";
    });
  }

  void _collectInorder(BstNode? node, List<int> res) {
    if (node == null) return;
    _collectInorder(node.left, res);
    res.add(node.val);
    _collectInorder(node.right, res);
  }

  void _handleInorderWalk() {
    final List<int> res = [];
    _collectInorder(_root, res);
    setState(() {
      _inorderSequence = res;
      _statusMessage = widget.isEnglish
          ? "Inorder Traversal (Left ➔ Root ➔ Right): Sorted Ascending Order = [${res.join(', ')}]"
          : "Inorder Traversal (LNR): সর্টেড মান = [${res.join(', ')}]";
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
              _buildTypeTab(0, "Graphical Tree Canvas", Icons.account_tree_outlined),
              _buildTypeTab(1, "Inorder (Sorted Output)", Icons.format_list_numbered),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Status Banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.accentNeonCyan.withOpacity(0.15),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.accentNeonCyan.withOpacity(0.5)),
          ),
          child: Row(
            children: [
              const Icon(Icons.account_tree, color: AppTheme.accentNeonCyan, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _statusMessage,
                  style: const TextStyle(
                    color: AppTheme.accentNeonCyan,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // True Graphical Tree Canvas
        Container(
          height: 380,
          padding: const EdgeInsets.all(12),
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF090D16),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFF1E293B)),
          ),
          child: _selectedTypeMode == 1
              ? _buildInorderSortedOutputView()
              : LayoutBuilder(
                  builder: (context, constraints) {
                    final canvasWidth = max(constraints.maxWidth, 600.0);
                    final canvasHeight = constraints.maxHeight;

                    // Calculate positions for all nodes
                    _calculateNodePositions(_root, canvasWidth / 2, 45, canvasWidth / 4, 75);

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
                              painter: BstTreeBranchPainter(
                                root: _root,
                                searchPath: _searchPath,
                              ),
                            ),
                            // 2. Interactive Circular Nodes
                            ..._buildNodeWidgetsList(_root),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
        const SizedBox(height: 16),

        // Control Actions
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
                        labelText: widget.isEnglish ? "Node Value" : "নোড ভ্যালু",
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
                    label: Text(widget.isEnglish ? "Insert Node O(log N)" : "ইনসার্ট (O(log N))"),
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentNeonCyan, foregroundColor: AppTheme.primaryDark),
                    onPressed: _handleInsert,
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.search, size: 16),
                    label: Text(widget.isEnglish ? "Search Path O(log N)" : "সার্চ (O(log N))"),
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentGreen, foregroundColor: AppTheme.primaryDark),
                    onPressed: _handleSearch,
                  ),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.delete_outline, size: 16),
                    label: Text(widget.isEnglish ? "Delete Node" : "ডিলেট নোড"),
                    onPressed: _handleDelete,
                  ),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.format_list_numbered, size: 16),
                    label: Text(widget.isEnglish ? "Inorder Walk (LNR)" : "Inorder ট্রাভার্সাল"),
                    onPressed: _handleInorderWalk,
                  ),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.refresh, size: 16),
                    label: Text(widget.isEnglish ? "Reset Tree" : "রিসেট"),
                    onPressed: _resetTree,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInorderSortedOutputView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.isEnglish
              ? "Inorder Traversal Walk (Left ➔ Root ➔ Right)"
              : "Inorder ট্রাভার্সাল রেজাল্ট (Left ➔ Root ➔ Right)",
          style: const TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 8),
        Text(
          widget.isEnglish
              ? "Note: Inorder Traversal on a BST ALWAYS visits nodes in sorted order!"
              : "নোট: BST তে Inorder ট্রাভার্সাল করলে উপাদানগুলো সর্বদা ছোট থেকে বড় সর্টেড পাওয়া যায়!",
          style: const TextStyle(color: AppTheme.textMuted, fontSize: 11),
        ),
        const SizedBox(height: 20),

        if (_inorderSequence.isEmpty)
          ElevatedButton(
            onPressed: _handleInorderWalk,
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentGreen, foregroundColor: AppTheme.primaryDark),
            child: Text(widget.isEnglish ? "Run Inorder Walk" : "Inorder ট্রাভার্সাল রান করুন"),
          )
        else
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: _inorderSequence.map((val) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppTheme.accentGreen,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: AppTheme.accentGreen.withOpacity(0.4), blurRadius: 8)],
                ),
                child: Text(
                  "$val",
                  style: const TextStyle(color: AppTheme.primaryDark, fontWeight: FontWeight.bold, fontSize: 18),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  // Calculate coordinates (x, y) for nodes recursively
  void _calculateNodePositions(BstNode? node, double x, double y, double dx, double dy) {
    if (node == null) return;
    node.x = x;
    node.y = y;

    if (node.left != null) {
      _calculateNodePositions(node.left, x - dx, y + dy, dx * 0.52, dy);
    }
    if (node.right != null) {
      _calculateNodePositions(node.right, x + dx, y + dy, dx * 0.52, dy);
    }
  }

  // Generate interactive positioned circular widgets for tree nodes
  List<Widget> _buildNodeWidgetsList(BstNode? node) {
    if (node == null) return [];

    final isSearched = node.val == _highlightedVal;
    final isPath = _searchPath.contains(node.val);
    final isRoot = _root?.val == node.val;

    final nodeWidget = Positioned(
      left: node.x - 25,
      top: node.y - 25,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: isSearched
              ? AppTheme.accentPink
              : (isPath
                  ? AppTheme.accentNeonCyan
                  : (isRoot ? AppTheme.accentPurple : AppTheme.surfaceDark)),
          shape: BoxShape.circle,
          border: Border.all(
            color: (isSearched || isPath) ? Colors.white : AppTheme.accentNeonCyan.withOpacity(0.6),
            width: (isSearched || isPath) ? 2.5 : 1.5,
          ),
          boxShadow: isSearched
              ? [BoxShadow(color: AppTheme.accentPink.withOpacity(0.6), blurRadius: 14)]
              : (isPath ? [BoxShadow(color: AppTheme.accentNeonCyan.withOpacity(0.5), blurRadius: 10)] : []),
        ),
        child: Center(
          child: Text(
            "${node.val}",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: (isSearched || isPath) ? AppTheme.primaryDark : Colors.white,
            ),
          ),
        ),
      ),
    );

    return [
      nodeWidget,
      ..._buildNodeWidgetsList(node.left),
      ..._buildNodeWidgetsList(node.right),
    ];
  }

  Widget _buildTypeTab(int modeIndex, String title, IconData icon) {
    final isSelected = _selectedTypeMode == modeIndex;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedTypeMode = modeIndex;
            if (modeIndex == 1) _handleInorderWalk();
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.accentNeonCyan : Colors.transparent,
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

// CustomPainter to draw neon lines connecting parent and child tree nodes
class BstTreeBranchPainter extends CustomPainter {
  final BstNode? root;
  final List<int> searchPath;

  BstTreeBranchPainter({required this.root, required this.searchPath});

  @override
  void paint(Canvas canvas, Size size) {
    if (root == null) return;
    _drawBranches(canvas, root);
  }

  void _drawBranches(Canvas canvas, BstNode node) {
    if (node.left != null) {
      final isPath = searchPath.contains(node.val) && searchPath.contains(node.left!.val);
      final paint = Paint()
        ..color = isPath ? AppTheme.accentNeonCyan : const Color(0xFF334155)
        ..strokeWidth = isPath ? 3.0 : 1.8
        ..style = PaintingStyle.stroke;

      canvas.drawLine(
        Offset(node.x, node.y),
        Offset(node.left!.x, node.left!.y),
        paint,
      );
      _drawBranches(canvas, node.left!);
    }

    if (node.right != null) {
      final isPath = searchPath.contains(node.val) && searchPath.contains(node.right!.val);
      final paint = Paint()
        ..color = isPath ? AppTheme.accentNeonCyan : const Color(0xFF334155)
        ..strokeWidth = isPath ? 3.0 : 1.8
        ..style = PaintingStyle.stroke;

      canvas.drawLine(
        Offset(node.x, node.y),
        Offset(node.right!.x, node.right!.y),
        paint,
      );
      _drawBranches(canvas, node.right!);
    }
  }

  @override
  bool shouldRepaint(covariant BstTreeBranchPainter oldDelegate) {
    return true;
  }
}
