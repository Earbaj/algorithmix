import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import '../../widgets/recursion_backtracking_visualizer.dart';

class RecursionVisualizerTabView extends StatelessWidget {
  final bool isEnglish;

  const RecursionVisualizerTabView({super.key, required this.isEnglish});

  @override
  Widget build(BuildContext context) {
    final hPadding = Responsive.horizontalPadding(context);

    return ResponsiveCenter(
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: RecursionBacktrackingVisualizer(isEnglish: isEnglish),
      ),
    );
  }
}
