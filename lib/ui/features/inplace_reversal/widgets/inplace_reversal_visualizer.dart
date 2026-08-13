import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'sub_widgets/reverse_entire_list_visualizer.dart';
import 'sub_widgets/reverse_sublist_visualizer.dart';
import 'sub_widgets/reverse_kgroup_visualizer.dart';

class InplaceReversalVisualizer extends StatefulWidget {
  final bool isEnglish;

  const InplaceReversalVisualizer({super.key, required this.isEnglish});

  @override
  State<InplaceReversalVisualizer> createState() => _InplaceReversalVisualizerState();
}

class _InplaceReversalVisualizerState extends State<InplaceReversalVisualizer> {
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
              _buildTemplateChip(0, widget.isEnglish ? "1. Reverse Entire List" : "১. সম্পূর্ণ লিস্ট রিভার্স"),
              _buildTemplateChip(1, widget.isEnglish ? "2. Reverse Sub-list (m to n)" : "২. নির্দিষ্ট সীমানায় রিভার্স"),
              _buildTemplateChip(2, widget.isEnglish ? "3. Reverse Nodes in k-Group" : "৩. K-Group নোড রিভার্স"),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Sub-visualizers
        IndexedStack(
          index: _selectedTemplateIndex,
          children: [
            ReverseEntireListVisualizer(isEnglish: widget.isEnglish),
            ReverseSublistVisualizer(isEnglish: widget.isEnglish),
            ReverseKGroupVisualizer(isEnglish: widget.isEnglish),
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
