import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import '../../widgets/graph_traversal_visualizer.dart';

class GraphVisualizerTabView extends StatelessWidget {
  final bool isEnglish;

  const GraphVisualizerTabView({super.key, required this.isEnglish});

  @override
  Widget build(BuildContext context) {
    final hPadding = Responsive.horizontalPadding(context);

    return ResponsiveCenter(
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: GraphTraversalVisualizer(isEnglish: isEnglish),
      ),
    );
  }
}
