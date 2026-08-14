import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'sub_widgets/subsets_visualizer.dart';
import 'sub_widgets/permutations_visualizer.dart';
import 'sub_widgets/grid_backtracking_visualizer.dart';

class RecursionBacktrackingVisualizer extends StatefulWidget {
  final bool isEnglish;

  const RecursionBacktrackingVisualizer({super.key, required this.isEnglish});

  @override
  State<RecursionBacktrackingVisualizer> createState() => _RecursionBacktrackingVisualizerState();
}

class _RecursionBacktrackingVisualizerState extends State<RecursionBacktrackingVisualizer> {
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
              _buildTemplateChip(0, widget.isEnglish ? "Subsets (Take / Skip)" : "সাবসেট (Take / Skip)"),
              _buildTemplateChip(1, widget.isEnglish ? "Permutations (Swap)" : "পারমিউটেশন (Swap)"),
              _buildTemplateChip(2, widget.isEnglish ? "Grid Backtracking (Visited)" : "গ্রিড ব্যাকট্র্যাকিং (Visited)"),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Sub-visualizers
        IndexedStack(
          index: _selectedTemplateIndex,
          children: [
            SubsetsVisualizer(isEnglish: widget.isEnglish),
            PermutationsVisualizer(isEnglish: widget.isEnglish),
            GridBacktrackingVisualizer(isEnglish: widget.isEnglish),
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
