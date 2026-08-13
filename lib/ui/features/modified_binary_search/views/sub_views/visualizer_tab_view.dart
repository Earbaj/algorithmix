import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import '../../widgets/modified_binary_search_visualizer.dart';

class ModifiedBinarySearchVisualizerTabView extends StatelessWidget {
  final bool isEnglish;

  const ModifiedBinarySearchVisualizerTabView({super.key, required this.isEnglish});

  @override
  Widget build(BuildContext context) {
    final hPadding = Responsive.horizontalPadding(context);

    return ResponsiveCenter(
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: ModifiedBinarySearchVisualizer(isEnglish: isEnglish),
      ),
    );
  }
}
