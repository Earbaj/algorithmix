import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'sub_widgets/merge_overlapping_visualizer.dart';
import 'sub_widgets/insert_interval_visualizer.dart';
import 'sub_widgets/interval_intersection_visualizer.dart';

class MergeIntervalsVisualizer extends StatefulWidget {
  final bool isEnglish;

  const MergeIntervalsVisualizer({super.key, required this.isEnglish});

  @override
  State<MergeIntervalsVisualizer> createState() => _MergeIntervalsVisualizerState();
}

class _MergeIntervalsVisualizerState extends State<MergeIntervalsVisualizer> {
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
              _buildTemplateChip(0, widget.isEnglish ? "Merge Overlapping Intervals" : "মার্জ ওভারল্যাপিং ইন্টারভালস"),
              _buildTemplateChip(1, widget.isEnglish ? "Insert Interval (3-Phase)" : "ইনসার্ট ইন্টারভাল"),
              _buildTemplateChip(2, widget.isEnglish ? "Interval Intersections" : "ইন্টারভাল ইন্টারসেকশন"),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Sub-visualizers
        IndexedStack(
          index: _selectedTemplateIndex,
          children: [
            MergeOverlappingVisualizer(isEnglish: widget.isEnglish),
            InsertIntervalVisualizer(isEnglish: widget.isEnglish),
            IntervalIntersectionVisualizer(isEnglish: widget.isEnglish),
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
