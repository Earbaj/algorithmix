import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import '../../widgets/trie_visualizer.dart';

class TrieVisualizerTabView extends StatelessWidget {
  final bool isEnglish;

  const TrieVisualizerTabView({super.key, required this.isEnglish});

  @override
  Widget build(BuildContext context) {
    final hPadding = Responsive.horizontalPadding(context);

    return ResponsiveCenter(
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: TrieVisualizer(isEnglish: isEnglish),
      ),
    );
  }
}
