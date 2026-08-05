import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class StackVisualizerWidget extends StatefulWidget {
  final bool isEnglish;

  const StackVisualizerWidget({super.key, required this.isEnglish});

  @override
  State<StackVisualizerWidget> createState() => _StackVisualizerWidgetState();
}

class _StackVisualizerWidgetState extends State<StackVisualizerWidget> {
  int _selectedTypeMode = 0; // 0 = Array-Based Stack, 1 = Linked-List Stack

  final TextEditingController _valController = TextEditingController(text: "50");
  List<int> _stackElements = [10, 20, 30, 40];
  int _highlightedIndex = -1;
  String _statusMessage = "";

  @override
  void initState() {
    super.initState();
    _statusMessage = widget.isEnglish
        ? "Stack (LIFO) Initialized! Size = 4, TOP = 40 (index 3)"
        : "স্ট্যাক (LIFO) প্রস্তুত! সাইজ = ৪, TOP = 40 (ইন্ডেক্স ৩)";
  }

  @override
  void dispose() {
    _valController.dispose();
    super.dispose();
  }

  void _pushElement() {
    final val = int.tryParse(_valController.text.trim()) ?? 99;
    setState(() {
      _stackElements.add(val);
      _highlightedIndex = _stackElements.length - 1;
      _statusMessage = widget.isEnglish
          ? "Pushed $val onto TOP of stack in O(1) time. TOP pointer updated."
          : "স্ট্যাকের উপরে TOP এ $val পুশ করা হলো (O(1))। TOP পয়েন্টার আপডেট হয়েছে।";
    });
  }

  void _popElement() {
    if (_stackElements.isEmpty) {
      setState(() {
        _statusMessage = widget.isEnglish
            ? "⚠️ Stack Underflow! Cannot pop from empty stack."
            : "⚠️ স্ট্যাক আন্ডারফ্লো! খালি স্ট্যাক থেকে পপ করা সম্ভব নয়।";
      });
      return;
    }
    setState(() {
      final popped = _stackElements.removeLast();
      _highlightedIndex = -1;
      _statusMessage = widget.isEnglish
          ? "Popped top element $popped in O(1) time."
          : "TOP থেকে $popped উপাদান পপ করা হয়েছে (O(1))।";
    });
  }

  void _peekElement() {
    if (_stackElements.isEmpty) return;
    setState(() {
      _highlightedIndex = _stackElements.length - 1;
      final val = _stackElements.last;
      _statusMessage = widget.isEnglish
          ? "Peek O(1): TOP element is $val at index ${_stackElements.length - 1}."
          : "Peek O(1): TOP উপাদান হলো $val (ইন্ডেক্স ${_stackElements.length - 1})।";
    });
  }

  void _clearStack() {
    setState(() {
      _stackElements.clear();
      _highlightedIndex = -1;
      _statusMessage = widget.isEnglish
          ? "Stack Cleared! Size = 0"
          : "স্ট্যাক খালি করা হয়েছে! সাইজ = ০";
    });
  }

  void _resetStack() {
    setState(() {
      _stackElements = [10, 20, 30, 40];
      _highlightedIndex = -1;
      _statusMessage = widget.isEnglish
          ? "Stack Reset: Size = 4, TOP = 40"
          : "স্ট্যাক রিসেট করা হয়েছে: সাইজ = ৪, TOP = 40";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Mode Switcher: Array-Based vs Linked-List Stack
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppTheme.surfaceDark,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF334155)),
          ),
          child: Row(
            children: [
              _buildTypeTab(0, "Array-Based Stack", Icons.view_day_outlined),
              _buildTypeTab(1, "Linked-List Stack", Icons.link_outlined),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Status Banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.accentGreen.withOpacity(0.15),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.accentGreen.withOpacity(0.5)),
          ),
          child: Row(
            children: [
              const Icon(Icons.layers_outlined, color: AppTheme.accentGreen, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _statusMessage,
                  style: const TextStyle(
                    color: AppTheme.accentGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Vertical LIFO Stack Container
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Stack Size: ${_stackElements.length}", style: const TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 13)),
                  Text(_stackElements.isNotEmpty ? "TOP: ${_stackElements.last}" : "TOP: NULL", style: const TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
              const SizedBox(height: 16),

              if (_stackElements.isEmpty)
                Container(
                  height: 140,
                  alignment: Alignment.center,
                  child: Text(widget.isEnglish ? "Stack is Empty (Underflow)" : "স্ট্যাক খালি (আন্ডারফ্লো)", style: const TextStyle(color: AppTheme.textMuted)),
                )
              else
                // Render LIFO items stacked top to bottom (reversed rendering)
                Column(
                  children: List.generate(_stackElements.length, (reverseIdx) {
                    final i = _stackElements.length - 1 - reverseIdx;
                    final val = _stackElements[i];
                    final isTop = i == _stackElements.length - 1;
                    final isHl = i == _highlightedIndex;

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.only(bottom: 8),
                      width: Responsive.isMobile(context) ? double.infinity : 320,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: isTop
                            ? AppTheme.accentGreen
                            : (isHl ? AppTheme.accentAmber : AppTheme.surfaceDark),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isTop ? Colors.white : (isHl ? Colors.white : AppTheme.accentGreen.withOpacity(0.5)),
                          width: isTop ? 2.5 : 1,
                        ),
                        boxShadow: isTop ? [BoxShadow(color: AppTheme.accentGreen.withOpacity(0.4), blurRadius: 10)] : [],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text("[$i]", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isTop ? AppTheme.primaryDark : AppTheme.textMuted)),
                              const SizedBox(width: 12),
                              Text("$val", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isTop ? AppTheme.primaryDark : Colors.white)),
                            ],
                          ),
                          if (isTop)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(color: AppTheme.primaryDark, borderRadius: BorderRadius.circular(6)),
                              child: const Text("TOP ⬅️", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                            )
                          else if (_selectedTypeMode == 1)
                            const Text("next ⬇️", style: TextStyle(color: AppTheme.textMuted, fontSize: 10)),
                        ],
                      ),
                    );
                  }),
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
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _valController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: widget.isEnglish ? "Value to Push" : "পুশ করার মান",
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
                    icon: const Icon(Icons.arrow_upward, size: 16),
                    label: Text(widget.isEnglish ? "Push (O(1))" : "পুশ (O(1))"),
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentGreen, foregroundColor: AppTheme.primaryDark),
                    onPressed: _pushElement,
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.arrow_downward, size: 16),
                    label: Text(widget.isEnglish ? "Pop (O(1))" : "পপ (O(1))"),
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentAmber, foregroundColor: AppTheme.primaryDark),
                    onPressed: _popElement,
                  ),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.visibility, size: 16),
                    label: Text(widget.isEnglish ? "Peek / Top (O(1))" : "পিক / টপ (O(1))"),
                    onPressed: _peekElement,
                  ),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.cleaning_services, size: 16),
                    label: Text(widget.isEnglish ? "Clear" : "খালি করুন"),
                    onPressed: _clearStack,
                  ),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.refresh, size: 16),
                    label: Text(widget.isEnglish ? "Reset" : "রিসেট"),
                    onPressed: _resetStack,
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
            color: isSelected ? AppTheme.accentGreen : Colors.transparent,
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
                    fontSize: 12,
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
