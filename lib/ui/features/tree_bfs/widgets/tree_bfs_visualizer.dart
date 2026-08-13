import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'sub_widgets/standard_level_order_visualizer.dart';
import 'sub_widgets/zigzag_level_order_visualizer.dart';
import 'sub_widgets/right_side_view_visualizer.dart';

class TreeBfsVisualizer extends StatefulWidget {
  final bool isEnglish;

  const TreeBfsVisualizer({super.key, required this.isEnglish});

  @override
  State<TreeBfsVisualizer> createState() => _TreeBfsVisualizerState();
}

class _TreeBfsVisualizerState extends State<TreeBfsVisualizer> {
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
              _buildTemplateChip(0, widget.isEnglish ? "Standard Level Order Traversal" : "সাধারণ লেভেল অর্ডার"),
              _buildTemplateChip(1, widget.isEnglish ? "Zigzag / Snake Order Traversal" : "জিগজ্যাগ লেভেল অর্ডার"),
              _buildTemplateChip(2, widget.isEnglish ? "Binary Tree Right Side View" : "ডানপাশের দৃশ্যমান নোড"),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Sub-visualizers
        IndexedStack(
          index: _selectedTemplateIndex,
          children: [
            StandardLevelOrderVisualizer(isEnglish: widget.isEnglish),
            ZigzagLevelOrderVisualizer(isEnglish: widget.isEnglish),
            RightSideViewVisualizer(isEnglish: widget.isEnglish),
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
