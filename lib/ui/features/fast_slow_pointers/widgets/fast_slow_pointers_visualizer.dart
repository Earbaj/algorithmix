import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'sub_widgets/cycle_detection_visualizer.dart';
import 'sub_widgets/middle_node_visualizer.dart';
import 'sub_widgets/cycle_entry_visualizer.dart';

class FastSlowPointersVisualizer extends StatefulWidget {
  final bool isEnglish;

  const FastSlowPointersVisualizer({super.key, required this.isEnglish});

  @override
  State<FastSlowPointersVisualizer> createState() => _FastSlowPointersVisualizerState();
}

class _FastSlowPointersVisualizerState extends State<FastSlowPointersVisualizer> {
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
              _buildTemplateChip(0, widget.isEnglish ? "Cycle Detection (Floyd)" : "সাইকেল ডিটেকশন"),
              _buildTemplateChip(1, widget.isEnglish ? "Middle of Linked List" : "মিডল নোড নির্ণয়"),
              _buildTemplateChip(2, widget.isEnglish ? "Find Cycle Entry Node" : "সাইকেল শুরুর নোড"),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Sub-visualizers
        IndexedStack(
          index: _selectedTemplateIndex,
          children: [
            CycleDetectionVisualizer(isEnglish: widget.isEnglish),
            MiddleNodeVisualizer(isEnglish: widget.isEnglish),
            CycleEntryVisualizer(isEnglish: widget.isEnglish),
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
        selectedColor: AppTheme.accentPink,
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
