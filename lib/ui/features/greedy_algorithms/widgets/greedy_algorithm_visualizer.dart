import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'sub_widgets/jump_game_visualizer.dart';
import 'sub_widgets/non_overlapping_intervals_visualizer.dart';
import 'sub_widgets/gas_station_visualizer.dart';

class GreedyAlgorithmVisualizer extends StatefulWidget {
  final bool isEnglish;

  const GreedyAlgorithmVisualizer({super.key, required this.isEnglish});

  @override
  State<GreedyAlgorithmVisualizer> createState() => _GreedyAlgorithmVisualizerState();
}

class _GreedyAlgorithmVisualizerState extends State<GreedyAlgorithmVisualizer> {
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
              _buildTemplateChip(0, widget.isEnglish ? "Jump Game (Reachability)" : "জাম্প গেম (সর্বোচ্চ দূরত্ব)"),
              _buildTemplateChip(1, widget.isEnglish ? "Non-overlapping Intervals" : "ওভারল্যাপ ছাড়া ইনটারভাল"),
              _buildTemplateChip(2, widget.isEnglish ? "Gas Station (Circular Trip)" : "গ্যাস স্টেশন চক্রাকার ট্রিপ"),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Sub-visualizers
        IndexedStack(
          index: _selectedTemplateIndex,
          children: [
            JumpGameVisualizer(isEnglish: widget.isEnglish),
            NonOverlappingIntervalsVisualizer(isEnglish: widget.isEnglish),
            GasStationVisualizer(isEnglish: widget.isEnglish),
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
