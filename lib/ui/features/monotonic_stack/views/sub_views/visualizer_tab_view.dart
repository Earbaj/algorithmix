import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import '../../widgets/monotonic_stack_visualizer.dart';

class MonotonicVisualizerTabView extends StatelessWidget {
  final bool isEnglish;

  const MonotonicVisualizerTabView({super.key, required this.isEnglish});

  @override
  Widget build(BuildContext context) {
    final hPadding = Responsive.horizontalPadding(context);

    return ResponsiveCenter(
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: MonotonicStackVisualizer(isEnglish: isEnglish),
      ),
    );
  }
}
