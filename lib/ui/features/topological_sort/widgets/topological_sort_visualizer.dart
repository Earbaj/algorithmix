import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'sub_widgets/kahns_algorithm_visualizer.dart';
import 'sub_widgets/cycle_detection_visualizer.dart';
import 'sub_widgets/alien_dictionary_visualizer.dart';

class TopologicalSortVisualizer extends StatefulWidget {
  final bool isEnglish;

  const TopologicalSortVisualizer({super.key, required this.isEnglish});

  @override
  State<TopologicalSortVisualizer> createState() => _TopologicalSortVisualizerState();
}

class _TopologicalSortVisualizerState extends State<TopologicalSortVisualizer> {
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
              _buildTemplateChip(0, widget.isEnglish ? "Kahn's Algorithm (BFS)" : "Kahn's Algorithm (ইন-ডিগ্রি ক্যু)"),
              _buildTemplateChip(1, widget.isEnglish ? "Cycle Detection in DAG" : "ডিরেক্টেড গ্রাফে সাইকেল ডিটেকশন"),
              _buildTemplateChip(2, widget.isEnglish ? "Alien Dictionary Sorting" : "অ্যালিয়েন বর্ণমালা সর্টিং"),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Sub-visualizers
        IndexedStack(
          index: _selectedTemplateIndex,
          children: [
            KahnsAlgorithmVisualizer(isEnglish: widget.isEnglish),
            CycleDetectionVisualizer(isEnglish: widget.isEnglish),
            AlienDictionaryVisualizer(isEnglish: widget.isEnglish),
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
