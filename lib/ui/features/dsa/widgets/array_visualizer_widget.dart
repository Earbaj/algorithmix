import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class ArrayVisualizerWidget extends StatefulWidget {
  final bool isEnglish;

  const ArrayVisualizerWidget({super.key, required this.isEnglish});

  @override
  State<ArrayVisualizerWidget> createState() => _ArrayVisualizerWidgetState();
}

class _ArrayVisualizerWidgetState extends State<ArrayVisualizerWidget> {
  final TextEditingController _valController = TextEditingController(text: "55");
  final TextEditingController _idxController = TextEditingController(text: "1");

  List<int> _elements = [10, 20, 30, 40];
  int _capacity = 4;
  int _highlightedIndex = -1;
  int _shiftingIndex = -1;
  String _logMessage = "";
  bool _isResizing = false;

  @override
  void initState() {
    super.initState();
    _logMessage = widget.isEnglish
        ? "Dynamic Array Initialized! Size = 4, Capacity = 4"
        : "ডাইনামিক অ্যারে তৈরি করা হয়েছে! সাইজ = ৪, ক্যাপাসিটি = ৪";
  }

  @override
  void dispose() {
    _valController.dispose();
    _idxController.dispose();
    super.dispose();
  }

  void _pushElement() {
    final val = int.tryParse(_valController.text.trim()) ?? 99;
    setState(() {
      if (_elements.length >= _capacity) {
        _isResizing = true;
        _capacity *= 2;
        _logMessage = widget.isEnglish
            ? "⚠️ Capacity full (${_elements.length}/$_elements.length)! Resizing array: Capacity doubled to $_capacity (Amortized O(1))."
            : "⚠️ ক্যাপাসিটি ফুল! মেমোরি মেগা-অ্যালোকেশন: ক্যাপাসিটি দ্বিগুণ বেড়ে $_capacity হলো (Amortized O(1))।";
      } else {
        _isResizing = false;
        _logMessage = widget.isEnglish
            ? "Appended $val at index ${_elements.length} in O(1) time."
            : "অ্যারের শেষে index ${_elements.length} এ $val যোগ করা হয়েছে (O(1))।";
      }
      _elements.add(val);
      _highlightedIndex = _elements.length - 1;
      _shiftingIndex = -1;
    });
  }

  void _popElement() {
    if (_elements.isEmpty) return;
    setState(() {
      final removed = _elements.removeLast();
      _highlightedIndex = -1;
      _shiftingIndex = -1;
      _isResizing = false;
      _logMessage = widget.isEnglish
          ? "Popped element $removed from back in O(1) time."
          : "অ্যারের শেষ থেকে $removed পপ করা হয়েছে (O(1))।";
    });
  }

  void _insertAtIndex() {
    final val = int.tryParse(_valController.text.trim()) ?? 99;
    int idx = int.tryParse(_idxController.text.trim()) ?? 0;
    if (idx < 0) idx = 0;
    if (idx > _elements.length) idx = _elements.length;

    setState(() {
      if (_elements.length >= _capacity) {
        _capacity *= 2;
        _isResizing = true;
      } else {
        _isResizing = false;
      }
      _elements.insert(idx, val);
      _highlightedIndex = idx;
      _shiftingIndex = idx;
      _logMessage = widget.isEnglish
          ? "Inserted $val at index $idx. Shifted elements right from index $idx to ${_elements.length - 1} in O(N) time!"
          : "index $idx এ $val যোগ করা হয়েছে। বাকি সব উপাদান ডানে Shift করা হয়েছে O(N) সময়ে!";
    });
  }

  void _deleteAtIndex() {
    int idx = int.tryParse(_idxController.text.trim()) ?? 0;
    if (_elements.isEmpty || idx < 0 || idx >= _elements.length) return;

    setState(() {
      final removed = _elements.removeAt(idx);
      _highlightedIndex = -1;
      _shiftingIndex = idx;
      _isResizing = false;
      _logMessage = widget.isEnglish
          ? "Deleted element $removed at index $idx. Shifted remaining elements left in O(N) time!"
          : "index $idx থেকে $removed মুছে বাকি সব উপাদান বামে Shift করা হয়েছে O(N) সময়ে!";
    });
  }

  void _accessIndex() {
    int idx = int.tryParse(_idxController.text.trim()) ?? 0;
    if (idx < 0 || idx >= _elements.length) return;

    setState(() {
      _highlightedIndex = idx;
      _shiftingIndex = -1;
      _isResizing = false;
      final val = _elements[idx];
      final address = "0x7FF${(1000 + idx * 4).toRadixString(16).toUpperCase()}";
      _logMessage = widget.isEnglish
          ? "O(1) Direct Access! Address = Base + ($idx * 4) = $address -> Value = $val"
          : "O(1) সরাসরি অ্যাক্সেস! মেমোরি এড্রেস $address এ পাওয়া মান = $val";
    });
  }

  void _resetArray() {
    setState(() {
      _elements = [10, 20, 30, 40];
      _capacity = 4;
      _highlightedIndex = -1;
      _shiftingIndex = -1;
      _isResizing = false;
      _logMessage = widget.isEnglish
          ? "Array Reset: Size = 4, Capacity = 4"
          : "অ্যারে রিসেট করা হয়েছে: সাইজ = ৪, ক্যাপাসিটি = ৪";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Status Log Banner
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: _isResizing ? AppTheme.accentAmber.withOpacity(0.15) : AppTheme.accentNeonCyan.withOpacity(0.12),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _isResizing ? AppTheme.accentAmber : AppTheme.accentNeonCyan.withOpacity(0.5)),
          ),
          child: Row(
            children: [
              Icon(_isResizing ? Icons.warning_amber_rounded : Icons.info_outline, color: _isResizing ? AppTheme.accentAmber : AppTheme.accentNeonCyan, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _logMessage,
                  style: TextStyle(
                    color: _isResizing ? AppTheme.accentAmber : AppTheme.accentNeonCyan,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Array Memory Visualization Canvas
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF090D16),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFF1E293B)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Capacity Header Indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text("Allocated Size: ", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                      Text("${_elements.length}", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 15)),
                    ],
                  ),
                  Row(
                    children: [
                      const Text("Total Capacity: ", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                      Text("$_capacity", style: const TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 15)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Capacity Progress Bar
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: _capacity > 0 ? _elements.length / _capacity : 0,
                  backgroundColor: AppTheme.surfaceDark,
                  color: _elements.length == _capacity ? AppTheme.accentAmber : AppTheme.accentNeonCyan,
                  minHeight: 8,
                ),
              ),
              const SizedBox(height: 20),

              // Contiguous Array Cell Memory Blocks
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(_capacity, (i) {
                    final isAllocated = i < _elements.length;
                    final isHl = i == _highlightedIndex;
                    final isShift = i == _shiftingIndex;
                    final hexAddr = "0x7FF${(1000 + i * 4).toRadixString(16).toUpperCase()}";

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 350),
                      margin: const EdgeInsets.only(right: 10),
                      width: 68,
                      height: 88,
                      decoration: BoxDecoration(
                        color: !isAllocated
                            ? Colors.transparent
                            : (isHl
                                ? AppTheme.accentAmber
                                : (isShift ? AppTheme.accentPink.withOpacity(0.3) : AppTheme.surfaceDark)),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: !isAllocated
                              ? AppTheme.textMuted.withOpacity(0.4)
                              : (isHl ? Colors.white : AppTheme.accentNeonCyan.withOpacity(0.6)),
                          width: isHl ? 2.5 : (isAllocated ? 1.5 : 1),
                        ),
                        boxShadow: isHl
                            ? [BoxShadow(color: AppTheme.accentAmber.withOpacity(0.5), blurRadius: 12)]
                            : [],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Memory Hex Address
                          Text(
                            hexAddr,
                            style: TextStyle(
                              fontSize: 9,
                              color: isHl ? AppTheme.primaryDark : AppTheme.textMuted,
                              fontFamily: 'monospace',
                            ),
                          ),
                          const SizedBox(height: 6),

                          // Element Value or Empty
                          Text(
                            isAllocated ? "${_elements[i]}" : "-",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: !isAllocated
                                  ? AppTheme.textMuted
                                  : (isHl ? AppTheme.primaryDark : Colors.white),
                            ),
                          ),
                          const SizedBox(height: 6),

                          // Index Badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: isHl ? Colors.black26 : AppTheme.primaryDark,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              "[$i]",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: isHl ? Colors.white : AppTheme.accentNeonCyan,
                              ),
                            ),
                          ),
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
              // Value and Index Inputs
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _valController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: widget.isEnglish ? "Value" : "মান",
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
                      controller: _idxController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: widget.isEnglish ? "Index [i]" : "ইন্ডেক্স [i]",
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

              // Action Buttons
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add_circle, size: 16),
                    label: Text(widget.isEnglish ? "Push Back (O(1))" : "শেষে যোগ (O(1))"),
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentNeonCyan, foregroundColor: AppTheme.primaryDark),
                    onPressed: _pushElement,
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.remove_circle, size: 16),
                    label: Text(widget.isEnglish ? "Pop Back (O(1))" : "শেষ বাদ (O(1))"),
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentAmber, foregroundColor: AppTheme.primaryDark),
                    onPressed: _popElement,
                  ),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.input_rounded, size: 16),
                    label: Text(widget.isEnglish ? "Insert [i] (O(N))" : "ইন্ডেক্সে ইনসার্ট (O(N))"),
                    onPressed: _insertAtIndex,
                  ),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.delete_sweep, size: 16),
                    label: Text(widget.isEnglish ? "Delete [i] (O(N))" : "ইন্ডেক্সে মোছা (O(N))"),
                    onPressed: _deleteAtIndex,
                  ),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.ads_click_rounded, size: 16),
                    label: Text(widget.isEnglish ? "Access [i] (O(1))" : "সরাসরি রিড (O(1))"),
                    onPressed: _accessIndex,
                  ),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.refresh, size: 16),
                    label: Text(widget.isEnglish ? "Reset" : "রিসেট"),
                    onPressed: _resetArray,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
