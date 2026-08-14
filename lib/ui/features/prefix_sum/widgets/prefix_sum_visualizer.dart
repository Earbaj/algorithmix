import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'sub_widgets/subarray_sum_k_visualizer.dart';
import 'sub_widgets/range_sum_query_visualizer.dart';
import 'sub_widgets/product_except_self_visualizer.dart';

class PrefixSumVisualizer extends StatefulWidget {
  final bool isEnglish;

  const PrefixSumVisualizer({super.key, required this.isEnglish});

  @override
  State<PrefixSumVisualizer> createState() => _PrefixSumVisualizerState();
}

class _PrefixSumVisualizerState extends State<PrefixSumVisualizer> {
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
              _buildTemplateChip(0, widget.isEnglish ? "Subarray Sum Equals K (HashMap)" : "Subarray Sum Equals K (HashMap)"),
              _buildTemplateChip(1, widget.isEnglish ? "Range Sum Query (1D Array)" : "রেঞ্জ সাম কোয়েরি (১D এরে)"),
              _buildTemplateChip(2, widget.isEnglish ? "Product Except Self (Prefix/Suffix)" : "প্রোডাক্ট এক্সসেপ্ট সেলফ (প্রিফিক্স/সাফিক্স)"),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Sub-visualizers
        IndexedStack(
          index: _selectedTemplateIndex,
          children: [
            SubarraySumKVisualizer(isEnglish: widget.isEnglish),
            RangeSumQueryVisualizer(isEnglish: widget.isEnglish),
            ProductExceptSelfVisualizer(isEnglish: widget.isEnglish),
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
