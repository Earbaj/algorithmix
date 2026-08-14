import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import '../../widgets/two_pointers_visualizer.dart';

class TwoPointersVisualizerTabView extends StatelessWidget {
  final bool isEnglish;

  const TwoPointersVisualizerTabView({super.key, required this.isEnglish});

  @override
  Widget build(BuildContext context) {
    final hPadding = Responsive.horizontalPadding(context);

    return ResponsiveCenter(
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: TwoPointersVisualizer(isEnglish: isEnglish),
      ),
    );
  }
}
