import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'sub_widgets/standard_cyclic_sort_visualizer.dart';
import 'sub_widgets/missing_number_visualizer.dart';
import 'sub_widgets/find_duplicate_visualizer.dart';

class CyclicSortVisualizer extends StatefulWidget {
  final bool isEnglish;

  const CyclicSortVisualizer({super.key, required this.isEnglish});

  @override
  State<CyclicSortVisualizer> createState() => _CyclicSortVisualizerState();
}

class _CyclicSortVisualizerState extends State<CyclicSortVisualizer> {
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
              _buildTemplateChip(0, widget.isEnglish ? "Standard 1 to N Cyclic Sort" : "সাধারণ সাইক্লিক সর্ট"),
              _buildTemplateChip(1, widget.isEnglish ? "Find Missing Number (0 to N)" : "হারানো সংখ্যা বের করা"),
              _buildTemplateChip(2, widget.isEnglish ? "Find Duplicate Number" : "ডুপ্লিকেট সংখ্যা বের করা"),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Sub-visualizers
        IndexedStack(
          index: _selectedTemplateIndex,
          children: [
            StandardCyclicSortVisualizer(isEnglish: widget.isEnglish),
            MissingNumberVisualizer(isEnglish: widget.isEnglish),
            FindDuplicateVisualizer(isEnglish: widget.isEnglish),
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
