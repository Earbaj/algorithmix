import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'sub_widgets/rotated_array_search_visualizer.dart';
import 'sub_widgets/first_last_position_visualizer.dart';
import 'sub_widgets/find_peak_element_visualizer.dart';

class ModifiedBinarySearchVisualizer extends StatefulWidget {
  final bool isEnglish;

  const ModifiedBinarySearchVisualizer({super.key, required this.isEnglish});

  @override
  State<ModifiedBinarySearchVisualizer> createState() => _ModifiedBinarySearchVisualizerState();
}

class _ModifiedBinarySearchVisualizerState extends State<ModifiedBinarySearchVisualizer> {
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
              _buildTemplateChip(0, widget.isEnglish ? "Search in Rotated Sorted Array" : "রোটেটেড অ্যারে সার্চ"),
              _buildTemplateChip(1, widget.isEnglish ? "First & Last Boundary Position" : "১ম ও শেষ সীমানা ইনডেক্স"),
              _buildTemplateChip(2, widget.isEnglish ? "Find Peak Element" : "পিক এলিমেন্ট নির্ণয়"),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Sub-visualizers
        IndexedStack(
          index: _selectedTemplateIndex,
          children: [
            RotatedArraySearchVisualizer(isEnglish: widget.isEnglish),
            FirstLastPositionVisualizer(isEnglish: widget.isEnglish),
            FindPeakElementVisualizer(isEnglish: widget.isEnglish),
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
