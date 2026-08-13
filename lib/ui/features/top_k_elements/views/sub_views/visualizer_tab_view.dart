import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import '../../widgets/top_k_elements_visualizer.dart';

class TopKElementsVisualizerTabView extends StatelessWidget {
  final bool isEnglish;

  const TopKElementsVisualizerTabView({super.key, required this.isEnglish});

  @override
  Widget build(BuildContext context) {
    final hPadding = Responsive.horizontalPadding(context);

    return ResponsiveCenter(
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: TopKElementsVisualizer(isEnglish: isEnglish),
      ),
    );
  }
}
