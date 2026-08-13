import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import '../../widgets/cyclic_sort_visualizer.dart';

class CyclicSortVisualizerTabView extends StatelessWidget {
  final bool isEnglish;

  const CyclicSortVisualizerTabView({super.key, required this.isEnglish});

  @override
  Widget build(BuildContext context) {
    final hPadding = Responsive.horizontalPadding(context);

    return ResponsiveCenter(
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: CyclicSortVisualizer(isEnglish: isEnglish),
      ),
    );
  }
}
