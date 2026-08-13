import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'sub_widgets/merge_k_sorted_lists_visualizer.dart';
import 'sub_widgets/kth_smallest_matrix_visualizer.dart';
import 'sub_widgets/smallest_range_k_lists_visualizer.dart';

class KWayMergeVisualizer extends StatefulWidget {
  final bool isEnglish;

  const KWayMergeVisualizer({super.key, required this.isEnglish});

  @override
  State<KWayMergeVisualizer> createState() => _KWayMergeVisualizerState();
}

class _KWayMergeVisualizerState extends State<KWayMergeVisualizer> {
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
              _buildTemplateChip(0, widget.isEnglish ? "Merge K Sorted Lists" : "K টি সর্টেড লিঙ্কড লিস্ট মার্জ"),
              _buildTemplateChip(1, widget.isEnglish ? "Kth Smallest Element in Matrix" : "ম্যাট্রিক্সের K-তম ক্ষুদ্রতম উপাদান"),
              _buildTemplateChip(2, widget.isEnglish ? "Smallest Range Covering K Lists" : "K টি লিস্ট কভারিং ক্ষুদ্রতম রেঞ্জ"),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Sub-visualizers
        IndexedStack(
          index: _selectedTemplateIndex,
          children: [
            MergeKSortedListsVisualizer(isEnglish: widget.isEnglish),
            KthSmallestMatrixVisualizer(isEnglish: widget.isEnglish),
            SmallestRangeKListsVisualizer(isEnglish: widget.isEnglish),
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
