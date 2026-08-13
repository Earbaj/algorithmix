import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import '../../widgets/kway_merge_visualizer.dart';

class KWayMergeVisualizerTabView extends StatelessWidget {
  final bool isEnglish;

  const KWayMergeVisualizerTabView({super.key, required this.isEnglish});

  @override
  Widget build(BuildContext context) {
    final hPadding = Responsive.horizontalPadding(context);

    return ResponsiveCenter(
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: KWayMergeVisualizer(isEnglish: isEnglish),
      ),
    );
  }
}
