import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import '../../widgets/subsets_backtracking_visualizer.dart';

class SubsetsVisualizerTabView extends StatelessWidget {
  final bool isEnglish;

  const SubsetsVisualizerTabView({super.key, required this.isEnglish});

  @override
  Widget build(BuildContext context) {
    final hPadding = Responsive.horizontalPadding(context);

    return ResponsiveCenter(
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: SubsetsBacktrackingVisualizer(isEnglish: isEnglish),
      ),
    );
  }
}
