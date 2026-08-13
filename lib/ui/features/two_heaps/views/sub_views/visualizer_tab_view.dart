import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import '../../widgets/two_heaps_visualizer.dart';

class TwoHeapsVisualizerTabView extends StatelessWidget {
  final bool isEnglish;

  const TwoHeapsVisualizerTabView({super.key, required this.isEnglish});

  @override
  Widget build(BuildContext context) {
    final hPadding = Responsive.horizontalPadding(context);

    return ResponsiveCenter(
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: TwoHeapsVisualizer(isEnglish: isEnglish),
      ),
    );
  }
}
