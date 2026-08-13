import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import '../../widgets/greedy_algorithm_visualizer.dart';

class GreedyVisualizerTabView extends StatelessWidget {
  final bool isEnglish;

  const GreedyVisualizerTabView({super.key, required this.isEnglish});

  @override
  Widget build(BuildContext context) {
    final hPadding = Responsive.horizontalPadding(context);

    return ResponsiveCenter(
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: GreedyAlgorithmVisualizer(isEnglish: isEnglish),
      ),
    );
  }
}
