import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'sub_widgets/xor_single_number_visualizer.dart';
import 'sub_widgets/kernighan_1bits_visualizer.dart';
import 'sub_widgets/reverse_bits_visualizer.dart';

class BitManipulationVisualizer extends StatefulWidget {
  final bool isEnglish;

  const BitManipulationVisualizer({super.key, required this.isEnglish});

  @override
  State<BitManipulationVisualizer> createState() => _BitManipulationVisualizerState();
}

class _BitManipulationVisualizerState extends State<BitManipulationVisualizer> {
  int _selectedTemplateIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Pattern Selection Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildTemplateChip(0, widget.isEnglish ? "Single Number (XOR Cancellation)" : "সিঙ্গেল নম্বর (XOR ক্যানসেলেশন)"),
              _buildTemplateChip(1, widget.isEnglish ? "1-Bits Count (Kernighan n & n-1)" : "১-বিট কাউন্ট (Kernighan n & n-1)"),
              _buildTemplateChip(2, widget.isEnglish ? "Reverse Bits (32-Bit Shift)" : "রিভার্স বিটস (৩২-বিট শিফট)"),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Sub-visualizers
        IndexedStack(
          index: _selectedTemplateIndex,
          children: [
            XORSingleNumberVisualizer(isEnglish: widget.isEnglish),
            Kernighan1BitsVisualizer(isEnglish: widget.isEnglish),
            ReverseBitsVisualizer(isEnglish: widget.isEnglish),
          ],
        ),
      ],
    );
  }

  Widget _buildTemplateChip(int index, String label) {
    final isSelected = _selectedTemplateIndex == index;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        selectedColor: AppTheme.accentPurple,
        backgroundColor: AppTheme.surfaceDark,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : AppTheme.textSecondary,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        onSelected: (selected) {
          if (selected) {
            setState(() {
              _selectedTemplateIndex = index;
            });
          }
        },
      ),
    );
  }
}
