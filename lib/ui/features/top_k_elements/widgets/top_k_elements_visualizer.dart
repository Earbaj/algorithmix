import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'sub_widgets/kth_largest_element_visualizer.dart';
import 'sub_widgets/top_k_frequent_visualizer.dart';
import 'sub_widgets/k_closest_points_visualizer.dart';

class TopKElementsVisualizer extends StatefulWidget {
  final bool isEnglish;

  const TopKElementsVisualizer({super.key, required this.isEnglish});

  @override
  State<TopKElementsVisualizer> createState() => _TopKElementsVisualizerState();
}

class _TopKElementsVisualizerState extends State<TopKElementsVisualizer> {
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
              _buildTemplateChip(0, widget.isEnglish ? "Kth Largest Element" : "K-তম বৃহত্তম মান"),
              _buildTemplateChip(1, widget.isEnglish ? "Top K Frequent Elements" : "সবচেয়ে বেশি ফ্রিকোয়েন্সির Top K"),
              _buildTemplateChip(2, widget.isEnglish ? "K Closest Points to Origin" : "মূলবিন্দু থেকে সবচেয়ে কাছের K পয়েন্ট"),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Sub-visualizers
        IndexedStack(
          index: _selectedTemplateIndex,
          children: [
            KthLargestElementVisualizer(isEnglish: widget.isEnglish),
            TopKFrequentVisualizer(isEnglish: widget.isEnglish),
            KClosestPointsVisualizer(isEnglish: widget.isEnglish),
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
