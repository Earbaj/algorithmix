import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'sub_widgets/opposite_direction_visualizer.dart';
import 'sub_widgets/same_direction_visualizer.dart';
import 'sub_widgets/fixed_two_pointers_visualizer.dart';

class TwoPointersVisualizer extends StatefulWidget {
  final bool isEnglish;

  const TwoPointersVisualizer({super.key, required this.isEnglish});

  @override
  State<TwoPointersVisualizer> createState() => _TwoPointersVisualizerState();
}

class _TwoPointersVisualizerState extends State<TwoPointersVisualizer> {
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
              _buildTemplateChip(0, widget.isEnglish ? "Opposite Direction (Two Sum II)" : "বিপরীত দিক (Two Sum II)"),
              _buildTemplateChip(1, widget.isEnglish ? "Same Direction (Move Zeroes)" : "একই দিক (Move Zeroes)"),
              _buildTemplateChip(2, widget.isEnglish ? "Fixed + Two Pointer (3Sum)" : "ফিক্সড + টু পয়েন্টার (3Sum)"),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Sub-visualizers
        IndexedStack(
          index: _selectedTemplateIndex,
          children: [
            OppositeDirectionVisualizer(isEnglish: widget.isEnglish),
            SameDirectionVisualizer(isEnglish: widget.isEnglish),
            FixedTwoPointersVisualizer(isEnglish: widget.isEnglish),
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
