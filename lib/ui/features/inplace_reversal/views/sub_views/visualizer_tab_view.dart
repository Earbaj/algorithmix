import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import '../../widgets/inplace_reversal_visualizer.dart';

class InplaceReversalVisualizerTabView extends StatelessWidget {
  final bool isEnglish;

  const InplaceReversalVisualizerTabView({super.key, required this.isEnglish});

  @override
  Widget build(BuildContext context) {
    final hPadding = Responsive.horizontalPadding(context);

    return ResponsiveCenter(
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: InplaceReversalVisualizer(isEnglish: isEnglish),
      ),
    );
  }
}
