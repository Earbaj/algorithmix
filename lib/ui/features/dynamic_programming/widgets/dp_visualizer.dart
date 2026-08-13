import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'sub_widgets/house_robber_visualizer.dart';
import 'sub_widgets/knapsack_01_visualizer.dart';
import 'sub_widgets/lcs_visualizer.dart';

class DPVisualizer extends StatefulWidget {
  final bool isEnglish;

  const DPVisualizer({super.key, required this.isEnglish});

  @override
  State<DPVisualizer> createState() => _DPVisualizerState();
}

class _DPVisualizerState extends State<DPVisualizer> {
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
              _buildTemplateChip(0, widget.isEnglish ? "1D DP (House Robber)" : "১D DP (হাউস রবার)"),
              _buildTemplateChip(1, widget.isEnglish ? "0/1 Knapsack (Subset Sum)" : "০/১ ক্যানপস্যাক (সাবসেট সাম)"),
              _buildTemplateChip(2, widget.isEnglish ? "2D DP (Longest Common Subsequence)" : "২D DP (LCS)"),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Sub-visualizers
        IndexedStack(
          index: _selectedTemplateIndex,
          children: [
            HouseRobberVisualizer(isEnglish: widget.isEnglish),
            Knapsack01Visualizer(isEnglish: widget.isEnglish),
            LCSVisualizer(isEnglish: widget.isEnglish),
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
