import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import '../../widgets/dp_visualizer.dart';

class DPVisualizerTabView extends StatelessWidget {
  final bool isEnglish;

  const DPVisualizerTabView({super.key, required this.isEnglish});

  @override
  Widget build(BuildContext context) {
    final hPadding = Responsive.horizontalPadding(context);

    return ResponsiveCenter(
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: DPVisualizer(isEnglish: isEnglish),
      ),
    );
  }
}
