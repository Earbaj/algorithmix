import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import '../../widgets/fast_slow_pointers_visualizer.dart';

class FastSlowVisualizerTabView extends StatelessWidget {
  final bool isEnglish;

  const FastSlowVisualizerTabView({super.key, required this.isEnglish});

  @override
  Widget build(BuildContext context) {
    final hPadding = Responsive.horizontalPadding(context);

    return ResponsiveCenter(
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: FastSlowPointersVisualizer(isEnglish: isEnglish),
      ),
    );
  }
}
