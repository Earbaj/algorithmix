import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import '../../widgets/union_find_visualizer.dart';

class UnionFindVisualizerTabView extends StatelessWidget {
  final bool isEnglish;

  const UnionFindVisualizerTabView({super.key, required this.isEnglish});

  @override
  Widget build(BuildContext context) {
    final hPadding = Responsive.horizontalPadding(context);

    return ResponsiveCenter(
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: UnionFindVisualizer(isEnglish: isEnglish),
      ),
    );
  }
}
