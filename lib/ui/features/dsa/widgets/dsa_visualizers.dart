import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'array_visualizer_widget.dart';
import 'linked_list_visualizer_widget.dart';
import 'stack_visualizer_widget.dart';
import 'queue_visualizer_widget.dart';
import 'hash_table_visualizer_widget.dart';
import 'bst_visualizer_widget.dart';
import 'heap_visualizer_widget.dart';

class DsaInteractiveVisualizer extends StatefulWidget {
  final int topicId;
  final bool isEnglish;

  const DsaInteractiveVisualizer({
    super.key,
    required this.topicId,
    required this.isEnglish,
  });

  @override
  State<DsaInteractiveVisualizer> createState() => _DsaInteractiveVisualizerState();
}

class _DsaInteractiveVisualizerState extends State<DsaInteractiveVisualizer> {
  final TextEditingController _inputController = TextEditingController();
  String _statusMessage = "";

  List<int> _linkedListNodes = [12, 28, 45, 70];
  List<int> _stackElements = [15, 30, 45];
  List<int> _queueElements = [10, 20, 30, 40];
  List<MapEntry<String, int>> _hashBuckets = [
    const MapEntry("apple", 5),
    const MapEntry("banana", 12),
  ];
  List<int> _bstNodes = [50, 30, 70, 20, 40, 60];
  List<int> _heapElements = [90, 70, 80, 40, 50];
  List<String> _graphNodes = ["A", "B", "C", "D"];
  List<String> _trieWords = ["cat", "car", "dog"];

  @override
  void initState() {
    super.initState();
    _statusMessage = widget.isEnglish
        ? "Interactive Visualizer Ready!"
        : "ইন্টারেক্টিভ ভিজ্যুয়ালাইজার প্রস্তুত!";
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _setStatus(String en, String bn) {
    setState(() {
      _statusMessage = widget.isEnglish ? en : bn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.topicId == 201) {
      return ArrayVisualizerWidget(isEnglish: widget.isEnglish);
    }
    switch (widget.topicId) {
      case 202:
        return LinkedListVisualizerWidget(isEnglish: widget.isEnglish);
      case 203:
        return StackVisualizerWidget(isEnglish: widget.isEnglish);
      case 204:
        return QueueVisualizerWidget(isEnglish: widget.isEnglish);
      case 205:
        return HashTableVisualizerWidget(isEnglish: widget.isEnglish);
      case 206:
        return BstVisualizerWidget(isEnglish: widget.isEnglish);
      case 207:
        return HeapVisualizerWidget(isEnglish: widget.isEnglish);
      case 208:
        return _buildGraphVisualizer();
      case 209:
        return _buildTrieVisualizer();
      default:
        return ArrayVisualizerWidget(isEnglish: widget.isEnglish);
    }
  }

  Widget _buildStatusBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.accentNeonCyan.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.accentNeonCyan.withOpacity(0.4)),
      ),
      child: Text(_statusMessage, style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13)),
    );
  }

  Widget _buildControlCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }

  // 2. LINKED LIST
  Widget _buildLinkedListVisualizer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStatusBanner(),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: const Color(0xFF090D16), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFF1E293B))),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const Text("HEAD -> ", style: TextStyle(color: AppTheme.accentPurple, fontWeight: FontWeight.bold)),
                ..._linkedListNodes.map((n) => Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: AppTheme.surfaceDark, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppTheme.accentPurple)),
                          child: Text("$n", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                        const Icon(Icons.arrow_forward, color: AppTheme.accentNeonCyan, size: 18),
                      ],
                    )),
                const Text("NULL", style: TextStyle(color: AppTheme.textMuted, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildControlCard([
          ElevatedButton(
            onPressed: () {
              setState(() => _linkedListNodes.insert(0, 99));
              _setStatus("Pushed 99 to Head in O(1)!", "Head এ ৯৯ যোগ করা হয়েছে (O(1))!");
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentPurple),
            child: const Text("Push Head (O(1))"),
          )
        ]),
      ],
    );
  }

  // 3. STACK
  Widget _buildStackVisualizer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStatusBanner(),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: const Color(0xFF090D16), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFF1E293B))),
          child: Column(
            children: _stackElements.reversed.map((n) => Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.symmetric(vertical: 10),
              width: 120,
              decoration: BoxDecoration(color: n == _stackElements.last ? AppTheme.accentGreen : AppTheme.surfaceDark, borderRadius: BorderRadius.circular(8)),
              child: Center(child: Text("$n", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
            )).toList(),
          ),
        ),
        const SizedBox(height: 16),
        _buildControlCard([
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() => _stackElements.add(50));
                  _setStatus("Pushed 50 onto top!", "স্ট্যাকের ওপরে ৫০ পুশ করা হয়েছে!");
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentGreen),
                child: const Text("Push"),
              ),
              const SizedBox(width: 10),
              OutlinedButton(
                onPressed: _stackElements.isEmpty ? null : () {
                  final pop = _stackElements.removeLast();
                  setState(() {});
                  _setStatus("Popped $pop from top!", "$pop পপ করা হয়েছে!");
                },
                child: const Text("Pop"),
              ),
            ],
          )
        ]),
      ],
    );
  }

  // 4. QUEUE
  Widget _buildQueueVisualizer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStatusBanner(),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: const Color(0xFF090D16), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFF1E293B))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _queueElements.map((n) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppTheme.surfaceDark, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppTheme.accentAmber)),
              child: Text("$n", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            )).toList(),
          ),
        ),
        const SizedBox(height: 16),
        _buildControlCard([
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() => _queueElements.add(50));
                  _setStatus("Enqueued 50 at rear!", "৫০ এনকিউ করা হয়েছে!");
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentAmber),
                child: const Text("Enqueue"),
              ),
              const SizedBox(width: 10),
              OutlinedButton(
                onPressed: _queueElements.isEmpty ? null : () {
                  final deq = _queueElements.removeAt(0);
                  setState(() {});
                  _setStatus("Dequeued $deq from front!", "$deq ডিকেল করা হয়েছে!");
                },
                child: const Text("Dequeue"),
              ),
            ],
          )
        ]),
      ],
    );
  }

  // 5. HASH TABLE
  Widget _buildHashTableVisualizer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStatusBanner(),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: const Color(0xFF090D16), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFF1E293B))),
          child: Column(
            children: _hashBuckets.map((e) => Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: AppTheme.surfaceDark, borderRadius: BorderRadius.circular(8)),
              child: Row(children: [Text("${e.key}: ${e.value}", style: const TextStyle(color: AppTheme.accentPink, fontWeight: FontWeight.bold))]),
            )).toList(),
          ),
        ),
        const SizedBox(height: 16),
        _buildControlCard([
          ElevatedButton(
            onPressed: () {
              setState(() => _hashBuckets.add(const MapEntry("cherry", 20)));
              _setStatus("Put (cherry: 20) in O(1)!", "(cherry: 20) ওয়ান সেটে যোগ হলো!");
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentPink),
            child: const Text("Put (Key: Val)"),
          )
        ]),
      ],
    );
  }

  // 6. BST
  Widget _buildBstVisualizer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStatusBanner(),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: const Color(0xFF090D16), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFF1E293B))),
          child: Wrap(
            spacing: 8,
            children: _bstNodes.map((n) => CircleAvatar(backgroundColor: AppTheme.accentNeonCyan, child: Text("$n", style: const TextStyle(color: AppTheme.primaryDark, fontWeight: FontWeight.bold)))).toList(),
          ),
        ),
        const SizedBox(height: 16),
        _buildControlCard([
          ElevatedButton(
            onPressed: () {
              setState(() => _bstNodes.add(25));
              _setStatus("Inserted 25 into BST in O(log N)!", "BST তে ২৫ ইনসার্ট হলো O(log N)!");
            },
            child: const Text("Insert BST Node"),
          )
        ]),
      ],
    );
  }

  // 7. HEAP
  Widget _buildHeapVisualizer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStatusBanner(),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: const Color(0xFF090D16), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFF1E293B))),
          child: Row(
            children: _heapElements.map((n) => Container(
              margin: const EdgeInsets.only(right: 6),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: AppTheme.surfaceDark, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppTheme.accentGreen)),
              child: Text("$n", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            )).toList(),
          ),
        ),
        const SizedBox(height: 16),
        _buildControlCard([
          ElevatedButton(
            onPressed: () {
              setState(() {
                _heapElements.add(95);
                _heapElements.sort((a, b) => b.compareTo(a));
              });
              _setStatus("Inserted 95 into Max-Heap!", "৯৫ হিপে যোগ হলো!");
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentGreen),
            child: const Text("Insert Max-Heap"),
          )
        ]),
      ],
    );
  }

  // 8. GRAPH
  Widget _buildGraphVisualizer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStatusBanner(),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: const Color(0xFF090D16), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFF1E293B))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _graphNodes.map((n) => CircleAvatar(backgroundColor: AppTheme.accentPurple, child: Text(n, style: const TextStyle(color: Colors.white)))).toList(),
          ),
        ),
        const SizedBox(height: 16),
        _buildControlCard([
          ElevatedButton(
            onPressed: () => _setStatus("BFS Traversal: A -> B -> C -> D", "গ্রাফ BFS ট্রাভার্সাল সম্পন্ন!"),
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentPurple),
            child: const Text("Run Graph BFS"),
          )
        ]),
      ],
    );
  }

  // 9. TRIE
  Widget _buildTrieVisualizer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStatusBanner(),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: const Color(0xFF090D16), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFF1E293B))),
          child: Wrap(
            spacing: 8,
            children: _trieWords.map((w) => Chip(backgroundColor: AppTheme.accentPink, label: Text(w, style: const TextStyle(color: Colors.white)))).toList(),
          ),
        ),
        const SizedBox(height: 16),
        _buildControlCard([
          ElevatedButton(
            onPressed: () {
              setState(() => _trieWords.add("cart"));
              _setStatus("Inserted 'cart' into Trie!", "ট্রাইতে 'cart' ইনসার্ট করা হলো!");
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentPink),
            child: const Text("Insert Word"),
          )
        ]),
      ],
    );
  }
}
