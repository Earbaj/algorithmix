import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import '../../widgets/merge_intervals_visualizer.dart';

class MergeIntervalsVisualizerTabView extends StatelessWidget {
  final bool isEnglish;

  const MergeIntervalsVisualizerTabView({super.key, required this.isEnglish});

  @override
  Widget build(BuildContext context) {
    final hPadding = Responsive.horizontalPadding(context);

    return ResponsiveCenter(
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: MergeIntervalsVisualizer(isEnglish: isEnglish),
      ),
    );
  }
}
