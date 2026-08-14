import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'sub_widgets/standard_trie_visualizer.dart';
import 'sub_widgets/wildcard_search_visualizer.dart';
import 'sub_widgets/maximum_xor_visualizer.dart';

class TrieVisualizer extends StatefulWidget {
  final bool isEnglish;

  const TrieVisualizer({super.key, required this.isEnglish});

  @override
  State<TrieVisualizer> createState() => _TrieVisualizerState();
}

class _TrieVisualizerState extends State<TrieVisualizer> {
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
              _buildTemplateChip(0, widget.isEnglish ? "Standard Trie (Insert / StartsWith)" : "স্ট্যান্ডার্ড ট্রাই (Insert / StartsWith)"),
              _buildTemplateChip(1, widget.isEnglish ? "Wildcard Search ('.')" : "ওয়াইল্ডকার্ড সার্চ ('.')"),
              _buildTemplateChip(2, widget.isEnglish ? "Maximum XOR (Binary Trie)" : "ম্যাক্সিমাম XOR (বাইনারি ট্রাই)"),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Sub-visualizers
        IndexedStack(
          index: _selectedTemplateIndex,
          children: [
            StandardTrieVisualizer(isEnglish: widget.isEnglish),
            WildcardSearchVisualizer(isEnglish: widget.isEnglish),
            MaximumXORVisualizer(isEnglish: widget.isEnglish),
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
