import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'sub_widgets/find_median_stream_visualizer.dart';
import 'sub_widgets/ipo_capital_visualizer.dart';
import 'sub_widgets/sliding_window_median_visualizer.dart';

class TwoHeapsVisualizer extends StatefulWidget {
  final bool isEnglish;

  const TwoHeapsVisualizer({super.key, required this.isEnglish});

  @override
  State<TwoHeapsVisualizer> createState() => _TwoHeapsVisualizerState();
}

class _TwoHeapsVisualizerState extends State<TwoHeapsVisualizer> {
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
              _buildTemplateChip(0, widget.isEnglish ? "Find Median from Data Stream" : "ডাটা স্ট্রিম মিডিয়ান"),
              _buildTemplateChip(1, widget.isEnglish ? "IPO / Maximize Capital" : "IPO ক্যাপিটাল ম্যাক্সিমাইজ"),
              _buildTemplateChip(2, widget.isEnglish ? "Sliding Window Median" : "স্লাইডিং উইন্ডো মিডিয়ান"),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Sub-visualizers
        IndexedStack(
          index: _selectedTemplateIndex,
          children: [
            FindMedianStreamVisualizer(isEnglish: widget.isEnglish),
            IpoCapitalVisualizer(isEnglish: widget.isEnglish),
            SlidingWindowMedianVisualizer(isEnglish: widget.isEnglish),
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
