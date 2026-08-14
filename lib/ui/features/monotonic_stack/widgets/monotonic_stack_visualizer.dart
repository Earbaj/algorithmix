import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'sub_widgets/daily_temperatures_visualizer.dart';
import 'sub_widgets/next_greater_element_visualizer.dart';
import 'sub_widgets/histogram_rectangle_visualizer.dart';

class MonotonicStackVisualizer extends StatefulWidget {
  final bool isEnglish;

  const MonotonicStackVisualizer({super.key, required this.isEnglish});

  @override
  State<MonotonicStackVisualizer> createState() => _MonotonicStackVisualizerState();
}

class _MonotonicStackVisualizerState extends State<MonotonicStackVisualizer> {
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
              _buildTemplateChip(0, widget.isEnglish ? "Daily Temperatures (Decreasing Stack)" : "ডেইলি টেম্পারেচার্স (Decreasing Stack)"),
              _buildTemplateChip(1, widget.isEnglish ? "Next Greater Element I (HashMap)" : "Next Greater Element I (HashMap)"),
              _buildTemplateChip(2, widget.isEnglish ? "Histogram Area (Increasing Stack)" : "হিস্টোগ্রাম এরিয়া (Increasing Stack)"),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Sub-visualizers
        IndexedStack(
          index: _selectedTemplateIndex,
          children: [
            DailyTemperaturesVisualizer(isEnglish: widget.isEnglish),
            NextGreaterElementVisualizer(isEnglish: widget.isEnglish),
            HistogramRectangleVisualizer(isEnglish: widget.isEnglish),
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
