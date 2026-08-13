import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'sub_widgets/preorder_traversal_visualizer.dart';
import 'sub_widgets/inorder_traversal_visualizer.dart';
import 'sub_widgets/path_sum_visualizer.dart';

class TreeDfsVisualizer extends StatefulWidget {
  final bool isEnglish;

  const TreeDfsVisualizer({super.key, required this.isEnglish});

  @override
  State<TreeDfsVisualizer> createState() => _TreeDfsVisualizerState();
}

class _TreeDfsVisualizerState extends State<TreeDfsVisualizer> {
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
              _buildTemplateChip(0, widget.isEnglish ? "Preorder Traversal (Root->Left->Right)" : "প্রি-অর্ডার ট্রাভার্সাল"),
              _buildTemplateChip(1, widget.isEnglish ? "Inorder Traversal (Left->Root->Right)" : "ইন-অর্ডার ট্রাভার্সাল"),
              _buildTemplateChip(2, widget.isEnglish ? "Postorder / Path Sum Check" : "পোস্ট-অর্ডার / পাথ সাম"),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Sub-visualizers
        IndexedStack(
          index: _selectedTemplateIndex,
          children: [
            PreorderTraversalVisualizer(isEnglish: widget.isEnglish),
            InorderTraversalVisualizer(isEnglish: widget.isEnglish),
            PathSumVisualizer(isEnglish: widget.isEnglish),
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
