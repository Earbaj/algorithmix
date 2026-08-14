import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import '../../widgets/prefix_sum_visualizer.dart';

class PrefixVisualizerTabView extends StatelessWidget {
  final bool isEnglish;

  const PrefixVisualizerTabView({super.key, required this.isEnglish});

  @override
  Widget build(BuildContext context) {
    final hPadding = Responsive.horizontalPadding(context);

    return ResponsiveCenter(
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: PrefixSumVisualizer(isEnglish: isEnglish),
      ),
    );
  }
}
