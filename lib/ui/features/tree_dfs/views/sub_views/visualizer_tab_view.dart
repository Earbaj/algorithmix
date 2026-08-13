import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import '../../widgets/tree_dfs_visualizer.dart';

class TreeDfsVisualizerTabView extends StatelessWidget {
  final bool isEnglish;

  const TreeDfsVisualizerTabView({super.key, required this.isEnglish});

  @override
  Widget build(BuildContext context) {
    final hPadding = Responsive.horizontalPadding(context);

    return ResponsiveCenter(
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: TreeDfsVisualizer(isEnglish: isEnglish),
      ),
    );
  }
}
