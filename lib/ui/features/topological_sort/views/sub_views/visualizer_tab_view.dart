import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import '../../widgets/topological_sort_visualizer.dart';

class TopologicalVisualizerTabView extends StatelessWidget {
  final bool isEnglish;

  const TopologicalVisualizerTabView({super.key, required this.isEnglish});

  @override
  Widget build(BuildContext context) {
    final hPadding = Responsive.horizontalPadding(context);

    return ResponsiveCenter(
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: TopologicalSortVisualizer(isEnglish: isEnglish),
      ),
    );
  }
}
