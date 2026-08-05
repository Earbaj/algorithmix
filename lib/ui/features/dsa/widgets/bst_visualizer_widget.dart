import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';

class BstNode {
  int val;
  BstNode? left;
  BstNode? right;
  BstNode(this.val, {this.left, this.right});
}

class BstVisualizerWidget extends StatefulWidget {
  final bool isEnglish;

  const BstVisualizerWidget({super.key, required this.isEnglish});

  @override
  State<BstVisualizerWidget> createState() => _BstVisualizerWidgetState();
}

class _BstVisualizerWidgetState extends State<BstVisualizerWidget> {
  int _selectedTypeMode = 0; // 0 = Standard BST Canvas, 1 = Inorder Traversal Walk

  final TextEditingController _valController = TextEditingController(text: "25");
  BstNode? _root;
  int _highlightedVal = -1;
  String _statusMessage = "";
  List<int> _inorderSequence = [];

  @override
  void initState() {
    super.initState();
    _resetTree();
  }

  void _resetTree() {
    // Initial Tree: 50 -> (30 -> 20, 40), (70 -> 60, 80)
    _root = BstNode(50);
    _insert(_root, 30);
    _insert(_root, 70);
    _insert(_root, 20);
    _insert(_root, 40);
    _insert(_root, 60);
    _insert(_root, 80);

    _highlightedVal = -1;
    _inorderSequence.clear();
    _statusMessage = widget.isEnglish
        ? "Binary Search Tree initialized! Root = 50 (Left < 50 < Right)"
        : "বাইনারি সার্চ ট্রি প্রস্তুত! Root = 50 (Left < 50 < Right)";
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

  void _handleInsert() {
    final val = int.tryParse(_valController.text.trim()) ?? 25;
    setState(() {
      _root = _insert(_root, val);
      _highlightedVal = val;
      _statusMessage = widget.isEnglish
          ? "Inserted $val into BST in O(log N) time! Path updated."
          : "BST তে $val ইনসার্ট করা হলো (O(log N))!";
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
      _statusMessage = found
          ? (widget.isEnglish ? "FOUND $val in BST! Search Path: ${path.join(' -> ')}" : "খুঁজে পাওয়া গেছে! পাথ: ${path.join(' -> ')}")
          : (widget.isEnglish ? "❌ $val Not Found in BST. Search Path: ${path.join(' -> ')}" : "❌ $val পাওয়া যায়নি! পাথ: ${path.join(' -> ')}");
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
          ? "Inorder Traversal (LNR): Sorted Ascending Order = [${res.join(', ')}]"
          : "Inorder Traversal (LNR): সর্টেড অর্ডার = [${res.join(', ')}]";
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
              _buildTypeTab(0, "BST Tree Structure", Icons.account_tree_outlined),
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
            color: AppTheme.accentCyan.withOpacity(0.15),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.accentCyan.withOpacity(0.5)),
          ),
          child: Row(
            children: [
              const Icon(Icons.account_tree, color: AppTheme.accentCyan, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _statusMessage,
                  style: const TextStyle(
                    color: AppTheme.accentCyan,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Tree Visualizer Canvas
        Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF090D16),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFF1E293B)),
          ),
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("BST Diagram (Left < Root < Right)", style: TextStyle(color: AppTheme.accentCyan, fontWeight: FontWeight.bold, fontSize: 13)),
                  Text("Height: O(log N)", style: TextStyle(color: AppTheme.textMuted, fontSize: 11)),
                ],
              ),
              const SizedBox(height: 16),

              if (_selectedTypeMode == 1)
                // Inorder Sorted Result Box
                Column(
                  children: [
                    const Text("Inorder Walk Result (Left -> Root -> Right)", style: TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 12)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _inorderSequence.map((val) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppTheme.accentGreen,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text("$val", style: const TextStyle(color: AppTheme.primaryDark, fontWeight: FontWeight.bold, fontSize: 16)),
                        );
                      }).toList(),
                    ),
                  ],
                )
              else
                // Hierarchical Tree Diagram
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    children: [
                      // Level 0: Root (50)
                      if (_root != null) _buildNodeWidget(_root!, isRoot: true),
                      const SizedBox(height: 16),

                      // Level 1: Left (30) & Right (70)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_root?.left != null) ...[
                            Column(
                              children: [
                                const Text("↙️ Left Subtree (< 50)", style: TextStyle(fontSize: 10, color: AppTheme.accentGreen)),
                                const SizedBox(height: 4),
                                _buildNodeWidget(_root!.left!),
                              ],
                            ),
                          ],
                          const SizedBox(width: 40),
                          if (_root?.right != null) ...[
                            Column(
                              children: [
                                const Text("Right Subtree (> 50) ↘️", style: TextStyle(fontSize: 10, color: AppTheme.accentAmber)),
                                const SizedBox(height: 4),
                                _buildNodeWidget(_root!.right!),
                              ],
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Level 2: Leaves (20, 40) and (60, 80)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_root?.left?.left != null) _buildSmallNode(_root!.left!.left!),
                          const SizedBox(width: 10),
                          if (_root?.left?.right != null) _buildSmallNode(_root!.left!.right!),
                          const SizedBox(width: 30),
                          if (_root?.right?.left != null) _buildSmallNode(_root!.right!.left!),
                          const SizedBox(width: 10),
                          if (_root?.right?.right != null) _buildSmallNode(_root!.right!.right!),
                        ],
                      ),
                    ],
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
                    label: Text(widget.isEnglish ? "Insert BST O(log N)" : "ইনসার্ট (O(log N))"),
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentCyan, foregroundColor: AppTheme.primaryDark),
                    onPressed: _handleInsert,
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.search, size: 16),
                    label: Text(widget.isEnglish ? "Search BST O(log N)" : "সার্চ (O(log N))"),
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentGreen, foregroundColor: AppTheme.primaryDark),
                    onPressed: _handleSearch,
                  ),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.format_list_numbered, size: 16),
                    label: Text(widget.isEnglish ? "Inorder Walk (LNR)" : "Inorder ট্রাভার্সাল"),
                    onPressed: _handleInorderWalk,
                  ),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.refresh, size: 16),
                    label: Text(widget.isEnglish ? "Reset Tree" : "ট্রি রিসেট"),
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

  Widget _buildNodeWidget(BstNode node, {bool isRoot = false}) {
    final isHl = node.val == _highlightedVal;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isRoot ? 65 : 55,
      height: isRoot ? 65 : 55,
      decoration: BoxDecoration(
        color: isHl ? AppTheme.accentPink : (isRoot ? AppTheme.accentPurple : AppTheme.surfaceDark),
        shape: BoxShape.circle,
        border: Border.all(color: isHl ? Colors.white : AppTheme.accentCyan, width: isHl ? 2.5 : 1.5),
        boxShadow: isHl ? [BoxShadow(color: AppTheme.accentPink.withOpacity(0.5), blurRadius: 10)] : [],
      ),
      child: Center(
        child: Text(
          "${node.val}",
          style: TextStyle(
            fontSize: isRoot ? 18 : 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildSmallNode(BstNode node) {
    final isHl = node.val == _highlightedVal;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: isHl ? AppTheme.accentPink : AppTheme.primaryDark,
        shape: BoxShape.circle,
        border: Border.all(color: isHl ? Colors.white : AppTheme.accentCyan.withOpacity(0.6)),
      ),
      child: Center(
        child: Text("${node.val}", style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
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
            color: isSelected ? AppTheme.accentCyan : Colors.transparent,
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
