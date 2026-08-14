import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import '../../widgets/bit_manipulation_visualizer.dart';

class BitVisualizerTabView extends StatelessWidget {
  final bool isEnglish;

  const BitVisualizerTabView({super.key, required this.isEnglish});

  @override
  Widget build(BuildContext context) {
    final hPadding = Responsive.horizontalPadding(context);

    return ResponsiveCenter(
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: BitManipulationVisualizer(isEnglish: isEnglish),
      ),
    );
  }
}
