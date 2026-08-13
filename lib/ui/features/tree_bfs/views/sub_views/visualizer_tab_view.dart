import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import '../../widgets/tree_bfs_visualizer.dart';

class TreeBfsVisualizerTabView extends StatelessWidget {
  final bool isEnglish;

  const TreeBfsVisualizerTabView({super.key, required this.isEnglish});

  @override
  Widget build(BuildContext context) {
    final hPadding = Responsive.horizontalPadding(context);

    return ResponsiveCenter(
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: TreeBfsVisualizer(isEnglish: isEnglish),
      ),
    );
  }
}
