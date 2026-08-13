import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'sub_widgets/dsu_components_visualizer.dart';
import 'sub_widgets/redundant_connection_visualizer.dart';
import 'sub_widgets/stones_removed_visualizer.dart';

class UnionFindVisualizer extends StatefulWidget {
  final bool isEnglish;

  const UnionFindVisualizer({super.key, required this.isEnglish});

  @override
  State<UnionFindVisualizer> createState() => _UnionFindVisualizerState();
}

class _UnionFindVisualizerState extends State<UnionFindVisualizer> {
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
              _buildTemplateChip(0, widget.isEnglish ? "DSU Connected Components" : "DSU কানেক্টেড কম্পোনেন্ট"),
              _buildTemplateChip(1, widget.isEnglish ? "Redundant Connection (Cycle)" : "অপ্রয়োজনীয় এজ (সাইকেল)"),
              _buildTemplateChip(2, widget.isEnglish ? "Most Stones Removed" : "সর্বোচ্চ পাথর অপসারণ"),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Sub-visualizers
        IndexedStack(
          index: _selectedTemplateIndex,
          children: [
            DSUComponentsVisualizer(isEnglish: widget.isEnglish),
            RedundantConnectionVisualizer(isEnglish: widget.isEnglish),
            StonesRemovedVisualizer(isEnglish: widget.isEnglish),
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
