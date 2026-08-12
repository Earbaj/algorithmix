import 'package:flutter/material.dart';

class TreeBranchPainter extends CustomPainter {
  final Color color;
  TreeBranchPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final startX = size.width / 2;
    final startY = 0.0;

    final leftEndX = size.width * 0.22;
    final leftEndY = size.height;
    canvas.drawLine(Offset(startX, startY), Offset(leftEndX, leftEndY), paint);

    final rightEndX = size.width * 0.78;
    final rightEndY = size.height;
    canvas.drawLine(Offset(startX, startY), Offset(rightEndX, rightEndY), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DebugArrayStep {
  final int activeLineIndex;
  final List<int>? array1D;
  final List<List<int>>? matrix2D;
  final List<String>? stackItems;
  final List<String>? queueItems;
  final Map<String, String>? hashMapItems;
  final int? pointer1;
  final int? pointer2;
  final int? minVal;
  final int? maxVal;
  final String explanationEn;
  final String explanationBn;

  const DebugArrayStep({
    required this.activeLineIndex,
    this.array1D,
    this.matrix2D,
    this.stackItems,
    this.queueItems,
    this.hashMapItems,
    this.pointer1,
    this.pointer2,
    this.minVal,
    this.maxVal,
    required this.explanationEn,
    required this.explanationBn,
  });
}
