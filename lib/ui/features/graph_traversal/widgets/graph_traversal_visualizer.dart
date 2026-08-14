import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'sub_widgets/island_dfs_visualizer.dart';
import 'sub_widgets/clone_graph_bfs_visualizer.dart';
import 'sub_widgets/bipartite_coloring_visualizer.dart';

class GraphTraversalVisualizer extends StatefulWidget {
  final bool isEnglish;

  const GraphTraversalVisualizer({super.key, required this.isEnglish});

  @override
  State<GraphTraversalVisualizer> createState() => _GraphTraversalVisualizerState();
}

class _GraphTraversalVisualizerState extends State<GraphTraversalVisualizer> {
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
              _buildTemplateChip(0, widget.isEnglish ? "Number of Islands (DFS)" : "দ্বীপের সংখ্যা (DFS)"),
              _buildTemplateChip(1, widget.isEnglish ? "Clone Graph (BFS)" : "গ্রাফ ক্লোনিং (BFS)"),
              _buildTemplateChip(2, widget.isEnglish ? "Is Graph Bipartite? (2-Coloring)" : "বাইপারটাইট টেস্ট (2-Coloring)"),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Sub-visualizers
        IndexedStack(
          index: _selectedTemplateIndex,
          children: [
            IslandDFSVisualizer(isEnglish: widget.isEnglish),
            CloneGraphBFSVisualizer(isEnglish: widget.isEnglish),
            BipartiteColoringVisualizer(isEnglish: widget.isEnglish),
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
