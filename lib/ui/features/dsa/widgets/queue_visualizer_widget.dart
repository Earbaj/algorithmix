import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';

class QueueVisualizerWidget extends StatefulWidget {
  final bool isEnglish;

  const QueueVisualizerWidget({super.key, required this.isEnglish});

  @override
  State<QueueVisualizerWidget> createState() => _QueueVisualizerWidgetState();
}

class _QueueVisualizerWidgetState extends State<QueueVisualizerWidget> {
  int _selectedTypeMode = 0; // 0 = Queue (FIFO), 1 = Deque (Double-Ended), 2 = Circular Queue

  final TextEditingController _valController = TextEditingController(text: "50");
  List<int> _queueElements = [10, 20, 30, 40];
  int _highlightedIndex = -1;
  String _statusMessage = "";

  // Circular Queue specific state (capacity = 5)
  final int _circularCapacity = 5;
  int _circHead = 0;
  int _circTail = 3;
  int _circSize = 4;
  late List<int?> _circBuffer;

  @override
  void initState() {
    super.initState();
    _circBuffer = [10, 20, 30, 40, null];
    _statusMessage = widget.isEnglish
        ? "FIFO Queue Ready! FRONT = 10 (index 0), REAR = 40 (index 3)"
        : "FIFO কিউ প্রস্তুত! FRONT = 10 (ইন্ডেক্স 0), REAR = 40 (ইন্ডেক্স ৩)";
  }

  @override
  void dispose() {
    _valController.dispose();
    super.dispose();
  }

  // FIFO & Deque Handlers
  void _enqueueRear() {
    final val = int.tryParse(_valController.text.trim()) ?? 99;
    if (_selectedTypeMode == 2) {
      // Circular Queue Mode
      if (_circSize >= _circularCapacity) {
        setState(() {
          _statusMessage = widget.isEnglish
              ? "⚠️ Circular Queue Overflow! Cannot enqueue."
              : "⚠️ সার্কুলার কিউ ওভারফ্লো! ইনসার্ট করা সম্ভব নয়।";
        });
        return;
      }
      setState(() {
        _circTail = (_circTail + 1) % _circularCapacity;
        _circBuffer[_circTail] = val;
        _circSize++;
        _statusMessage = widget.isEnglish
            ? "Circular Enqueue $val at REAR (index $_circTail = ($_circTail) % $_circularCapacity)"
            : "সার্কুলার Enqueue $val REAR এ (ইন্ডেক্স $_circTail = ($_circTail) % $_circularCapacity)";
      });
      return;
    }

    setState(() {
      _queueElements.add(val);
      _highlightedIndex = _queueElements.length - 1;
      _statusMessage = widget.isEnglish
          ? "Enqueued $val at REAR in O(1) time."
          : "REAR (পেছনে) $val যোগ করা হলো (O(1))।";
    });
  }

  void _dequeueFront() {
    if (_selectedTypeMode == 2) {
      if (_circSize == 0) {
        setState(() {
          _statusMessage = widget.isEnglish
              ? "⚠️ Circular Queue Underflow! Queue is empty."
              : "⚠️ সার্কুলার কিউ খালি (আন্ডারফ্লো)।";
        });
        return;
      }
      setState(() {
        final val = _circBuffer[_circHead];
        _circBuffer[_circHead] = null;
        _circHead = (_circHead + 1) % _circularCapacity;
        _circSize--;
        _statusMessage = widget.isEnglish
            ? "Circular Dequeued $val from FRONT. FRONT moved to index $_circHead."
            : "সার্কুলার Dequeued $val FRONT থেকে। FRONT এখন ইন্ডেক্স $_circHead।";
      });
      return;
    }

    if (_queueElements.isEmpty) {
      setState(() {
        _statusMessage = widget.isEnglish
            ? "⚠️ Queue Underflow! Cannot dequeue empty queue."
            : "⚠️ কিউ খালি! ডিকেল করা সম্ভব নয়।";
      });
      return;
    }

    setState(() {
      final dequeued = _queueElements.removeAt(0);
      _highlightedIndex = -1;
      _statusMessage = widget.isEnglish
          ? "Dequeued $dequeued from FRONT in O(1) time. Next item is new FRONT."
          : "FRONT (সামনে) থেকে $dequeued সরিয়ে ফেলা হলো (O(1))।";
    });
  }

  void _pushFrontDeque() {
    final val = int.tryParse(_valController.text.trim()) ?? 99;
    setState(() {
      _queueElements.insert(0, val);
      _highlightedIndex = 0;
      _statusMessage = widget.isEnglish
          ? "Deque: Pushed $val at FRONT in O(1) time."
          : "Deque: FRONT এ $val পুশ করা হলো (O(1))।";
    });
  }

  void _popRearDeque() {
    if (_queueElements.isEmpty) return;
    setState(() {
      final popped = _queueElements.removeLast();
      _highlightedIndex = -1;
      _statusMessage = widget.isEnglish
          ? "Deque: Popped $popped from REAR in O(1) time."
          : "Deque: REAR থেকে $popped পপ করা হলো (O(1))।";
    });
  }

  void _resetQueue() {
    setState(() {
      _queueElements = [10, 20, 30, 40];
      _circBuffer = [10, 20, 30, 40, null];
      _circHead = 0;
      _circTail = 3;
      _circSize = 4;
      _highlightedIndex = -1;
      _statusMessage = widget.isEnglish
          ? "Queue Reset: FRONT = 10, REAR = 40"
          : "কিউ রিসেট করা হয়েছে: FRONT = 10, REAR = 40";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Mode Switcher: Queue vs Deque vs Circular Queue
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppTheme.surfaceDark,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF334155)),
          ),
          child: Row(
            children: [
              _buildTypeTab(0, "Queue (FIFO)", Icons.swap_horizontal_circle_outlined),
              _buildTypeTab(1, "Deque (<->)", Icons.unfold_more_sharp),
              _buildTypeTab(2, "Circular Queue", Icons.loop),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Status Banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.accentAmber.withOpacity(0.15),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.accentAmber.withOpacity(0.5)),
          ),
          child: Row(
            children: [
              const Icon(Icons.swap_horizontal_circle, color: AppTheme.accentAmber, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _statusMessage,
                  style: const TextStyle(
                    color: AppTheme.accentAmber,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Pipeline Display Canvas
        if (_selectedTypeMode == 2)
          _buildCircularQueueCanvas()
        else
          _buildStandardQueueCanvas(),

        const SizedBox(height: 16),

        // Control Buttons
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
                        labelText: widget.isEnglish ? "Value to Enqueue" : "যোগ করার মান",
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
                    icon: const Icon(Icons.east, size: 16),
                    label: Text(widget.isEnglish ? "Enqueue Rear (O(1))" : "পেছনে যোগ (O(1))"),
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentAmber, foregroundColor: AppTheme.primaryDark),
                    onPressed: _enqueueRear,
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.west, size: 16),
                    label: Text(widget.isEnglish ? "Dequeue Front (O(1))" : "সামনে থেকে মোছা (O(1))"),
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentGreen, foregroundColor: AppTheme.primaryDark),
                    onPressed: _dequeueFront,
                  ),
                  if (_selectedTypeMode == 1) ...[
                    OutlinedButton.icon(
                      icon: const Icon(Icons.input, size: 16),
                      label: Text(widget.isEnglish ? "Push Front (Deque)" : "সামনে পুশ (Deque)"),
                      onPressed: _pushFrontDeque,
                    ),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.output, size: 16),
                      label: Text(widget.isEnglish ? "Pop Rear (Deque)" : "পেছনে পপ (Deque)"),
                      onPressed: _popRearDeque,
                    ),
                  ],
                  OutlinedButton.icon(
                    icon: const Icon(Icons.refresh, size: 16),
                    label: Text(widget.isEnglish ? "Reset" : "রিসেট"),
                    onPressed: _resetQueue,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Standard FIFO & Deque Canvas
  Widget _buildStandardQueueCanvas() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFF090D16), borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFF1E293B))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Queue Size: ${_queueElements.length}", style: const TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 13)),
              const Text("Pipeline: FRONT ➡️ REAR", style: TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 16),

          if (_queueElements.isEmpty)
            Container(height: 80, alignment: Alignment.center, child: Text(widget.isEnglish ? "Queue is Empty (Underflow)" : "কিউ খালি (আন্ডারফ্লো)", style: const TextStyle(color: AppTheme.textMuted)))
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_queueElements.length, (i) {
                  final val = _queueElements[i];
                  final isFront = i == 0;
                  final isRear = i == _queueElements.length - 1;
                  final isHl = i == _highlightedIndex;

                  return Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 78,
                        height: 85,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: isFront
                              ? AppTheme.accentGreen
                              : (isRear ? AppTheme.accentAmber : (isHl ? AppTheme.accentPink : AppTheme.surfaceDark)),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: (isFront || isRear) ? Colors.white : AppTheme.accentAmber.withOpacity(0.5), width: (isFront || isRear) ? 2.5 : 1),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(isFront ? "FRONT" : (isRear ? "REAR" : "[$i]"), style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: (isFront || isRear) ? AppTheme.primaryDark : AppTheme.textMuted)),
                            const SizedBox(height: 4),
                            Text("$val", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: (isFront || isRear) ? AppTheme.primaryDark : Colors.white)),
                          ],
                        ),
                      ),
                      if (!isRear) const Icon(Icons.east, color: AppTheme.accentAmber, size: 16),
                    ],
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }

  // Circular Queue Canvas
  Widget _buildCircularQueueCanvas() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFF090D16), borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFF1E293B))),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Circular Size: $_circSize/$_circularCapacity", style: const TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 13)),
              Text("Head: $_circHead | Tail: $_circTail", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_circularCapacity, (i) {
                final val = _circBuffer[i];
                final isHead = i == _circHead && _circSize > 0;
                final isTail = i == _circTail && _circSize > 0;

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 60,
                  height: 75,
                  decoration: BoxDecoration(
                    color: isHead
                        ? AppTheme.accentGreen
                        : (isTail ? AppTheme.accentAmber : AppTheme.surfaceDark),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: (isHead || isTail) ? Colors.white : AppTheme.textMuted.withOpacity(0.4)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(isHead ? "HEAD" : (isTail ? "TAIL" : "[$i]"), style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: (isHead || isTail) ? AppTheme.primaryDark : AppTheme.textMuted)),
                      const SizedBox(height: 4),
                      Text(val != null ? "$val" : "-", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: (isHead || isTail) ? AppTheme.primaryDark : AppTheme.textMuted)),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
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
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.accentAmber : Colors.transparent,
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
