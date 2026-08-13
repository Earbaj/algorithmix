import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class LinkedListVisualizerWidget extends StatefulWidget {
  final bool isEnglish;

  const LinkedListVisualizerWidget({super.key, required this.isEnglish});

  @override
  State<LinkedListVisualizerWidget> createState() => _LinkedListVisualizerWidgetState();
}

class _LinkedListVisualizerWidgetState extends State<LinkedListVisualizerWidget> {
  int _selectedTypeMode = 0; // 0 = Singly Linked List, 1 = Doubly Linked List

  final TextEditingController _valController = TextEditingController(text: "99");
  List<int> _nodes = [10, 20, 30, 40];
  int _highlightedIndex = -1;
  String _statusMessage = "";
  bool _isReversed = false;

  @override
  void initState() {
    super.initState();
    _statusMessage = widget.isEnglish
        ? "Singly Linked List initialized: HEAD -> 10 -> 20 -> 30 -> 40 -> NULL"
        : "Singly Linked List তৈরি করা হয়েছে: HEAD -> 10 -> 20 -> 30 -> 40 -> NULL";
  }

  @override
  void dispose() {
    _valController.dispose();
    super.dispose();
  }

  void _pushHead() {
    final val = int.tryParse(_valController.text.trim()) ?? 99;
    setState(() {
      _nodes.insert(0, val);
      _highlightedIndex = 0;
      _statusMessage = widget.isEnglish
          ? "Inserted node $val at HEAD in O(1) time. New HEAD points to old HEAD."
          : "HEAD এ নোড $val যোগ করা হয়েছে (O(1))। নতুন HEAD পুরনো HEAD কে পয়েন্ট করছে।";
    });
  }

  void _pushTail() {
    final val = int.tryParse(_valController.text.trim()) ?? 99;
    setState(() {
      _nodes.add(val);
      _highlightedIndex = _nodes.length - 1;
      _statusMessage = widget.isEnglish
          ? "Inserted node $val at TAIL in O(1) time."
          : "TAIL এ নোড $val যোগ করা হয়েছে (O(1))।";
    });
  }

  void _popHead() {
    if (_nodes.isEmpty) return;
    setState(() {
      final removed = _nodes.removeAt(0);
      _highlightedIndex = -1;
      _statusMessage = widget.isEnglish
          ? "Removed HEAD node $removed in O(1) time. HEAD pointer updated to next node."
          : "HEAD নোড $removed মুছে ফেলা হয়েছে (O(1))। HEAD পয়েন্টার আপডেট করা হয়েছে।";
    });
  }

  void _popTail() {
    if (_nodes.isEmpty) return;
    setState(() {
      final removed = _nodes.removeLast();
      _highlightedIndex = -1;
      _statusMessage = widget.isEnglish
          ? "Removed TAIL node $removed."
          : "TAIL নোড $removed রিমুভ করা হয়েছে।";
    });
  }

  void _reverseList() {
    if (_nodes.isEmpty) return;
    setState(() {
      _nodes = _nodes.reversed.toList();
      _isReversed = !_isReversed;
      _highlightedIndex = -1;
      _statusMessage = widget.isEnglish
          ? "🎉 Reversed Linked List! Pointer directions flipped in O(N) time."
          : "🎉 লিঙ্কড লিস্ট উল্টানো সম্পন্ন! পয়েন্টারের দিক ঘোরানো হয়েছে O(N) সময়ে।";
    });
  }

  void _resetList() {
    setState(() {
      _nodes = [10, 20, 30, 40];
      _highlightedIndex = -1;
      _isReversed = false;
      _statusMessage = widget.isEnglish
          ? "Reset Linked List: HEAD -> 10 -> 20 -> 30 -> 40 -> NULL"
          : "লিঙ্কড লিস্ট রিসেট করা হয়েছে: HEAD -> 10 -> 20 -> 30 -> 40 -> NULL";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Mode Switcher: Singly Linked List vs Doubly Linked List
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppTheme.surfaceDark,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF334155)),
          ),
          child: Row(
            children: [
              _buildTypeTab(0, "Singly Linked List (->)", Icons.arrow_forward_rounded),
              _buildTypeTab(1, "Doubly Linked List (<->)", Icons.compare_arrows_rounded),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Status Banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.accentPurple.withOpacity(0.15),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.accentPurple.withOpacity(0.5)),
          ),
          child: Row(
            children: [
              const Icon(Icons.link, color: AppTheme.accentPurple, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _statusMessage,
                  style: const TextStyle(
                    color: AppTheme.accentPurple,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Linked List Nodes Canvas
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF090D16),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFF1E293B)),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // HEAD Pointer Label
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.accentPurple.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.accentPurple),
                  ),
                  child: const Text("HEAD", style: TextStyle(color: AppTheme.accentPurple, fontWeight: FontWeight.bold, fontSize: 11)),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward, color: AppTheme.accentPurple, size: 18),
                const SizedBox(width: 8),

                // Nodes
                ...List.generate(_nodes.length, (i) {
                  final val = _nodes[i];
                  final isHl = i == _highlightedIndex;
                  final isLast = i == _nodes.length - 1;

                  return Row(
                    children: [
                      // Node Card
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 75,
                        height: 55,
                        decoration: BoxDecoration(
                          color: isHl ? AppTheme.accentAmber : AppTheme.surfaceDark,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isHl ? Colors.white : AppTheme.accentPurple.withOpacity(0.6),
                            width: isHl ? 2.5 : 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            // Data Compartment
                            Expanded(
                              flex: 2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("data", style: TextStyle(fontSize: 9, color: isHl ? AppTheme.primaryDark : AppTheme.textMuted)),
                                  Text("$val", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isHl ? AppTheme.primaryDark : Colors.white)),
                                ],
                              ),
                            ),
                            const VerticalDivider(width: 1, color: Color(0xFF334155)),
                            // Pointer Compartment
                            Expanded(
                              flex: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(_selectedTypeMode == 1 ? "prev/next" : "next", style: TextStyle(fontSize: 8, color: isHl ? AppTheme.primaryDark : AppTheme.accentNeonCyan)),
                                  Icon(_selectedTypeMode == 1 ? Icons.swap_horiz : Icons.east, size: 14, color: isHl ? AppTheme.primaryDark : AppTheme.accentNeonCyan),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Pointer Link Arrow
                      if (!isLast) ...[
                        Icon(
                          _selectedTypeMode == 1 ? Icons.compare_arrows_rounded : Icons.arrow_forward_rounded,
                          color: AppTheme.accentNeonCyan,
                          size: 22,
                        ),
                        const SizedBox(width: 8),
                      ] else ...[
                        const Icon(Icons.arrow_forward_rounded, color: AppTheme.textMuted, size: 18),
                        const SizedBox(width: 6),
                        const Text("NULL", style: TextStyle(color: AppTheme.textMuted, fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Operation Control Panel
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surfaceDark,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFF334155)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    icon: const Icon(Icons.first_page, size: 16),
                    label: Text(widget.isEnglish ? "Push Head (O(1))" : "হেডে যোগ (O(1))"),
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentPurple, foregroundColor: Colors.white),
                    onPressed: _pushHead,
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.last_page, size: 16),
                    label: Text(widget.isEnglish ? "Push Tail (O(1))" : "টেইলে যোগ (O(1))"),
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentNeonCyan, foregroundColor: AppTheme.primaryDark),
                    onPressed: _pushTail,
                  ),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.remove_circle_outline, size: 16),
                    label: Text(widget.isEnglish ? "Pop Head (O(1))" : "হেড মুছুন (O(1))"),
                    onPressed: _popHead,
                  ),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.delete_outline, size: 16),
                    label: Text(widget.isEnglish ? "Pop Tail" : "টেইল মুছুন"),
                    onPressed: _popTail,
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.swap_calls, size: 16),
                    label: Text(widget.isEnglish ? "Reverse List (O(N))" : "লিস্ট রিভার্স (O(N))"),
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentPink, foregroundColor: Colors.white),
                    onPressed: _reverseList,
                  ),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.refresh, size: 16),
                    label: Text(widget.isEnglish ? "Reset" : "রিসেট"),
                    onPressed: _resetList,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
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
            color: isSelected ? AppTheme.accentPurple : Colors.transparent,
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
                    fontSize: 12,
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
