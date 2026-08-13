import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';

class FloydsCycleCanvasWidget extends StatelessWidget {
  final bool isEnglish;
  final List<int> nodes;
  final int slowVal;
  final int fastVal;
  final bool isCycleDetected;

  const FloydsCycleCanvasWidget({
    super.key,
    required this.isEnglish,
    required this.nodes,
    required this.slowVal,
    required this.fastVal,
    required this.isCycleDetected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF090D16),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem("slow (+1)", AppTheme.accentGreen),
              const SizedBox(width: 20),
              _buildLegendItem("fast (+2)", Colors.purpleAccent),
            ],
          ),
          const SizedBox(height: 20),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(nodes.length, (idx) {
                final val = nodes[idx];
                final isSlow = slowVal == val;
                final isFast = fastVal == val;
                final isCollision = isCycleDetected && isSlow && isFast;

                return Row(
                  children: [
                    Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isSlow) _buildBadge("slow", AppTheme.accentGreen),
                            if (isFast) _buildBadge("fast", Colors.purpleAccent),
                          ],
                        ),
                        const SizedBox(height: 6),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: isCollision
                                ? Colors.redAccent.withOpacity(0.35)
                                : (isSlow
                                    ? AppTheme.accentGreen.withOpacity(0.2)
                                    : (isFast ? Colors.purpleAccent.withOpacity(0.2) : const Color(0xFF1E293B))),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isCollision
                                  ? Colors.redAccent
                                  : (isSlow ? AppTheme.accentGreen : (isFast ? Colors.purpleAccent : const Color(0xFF334155))),
                              width: isCollision ? 3 : (isSlow || isFast ? 2 : 1),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "$val",
                              style: TextStyle(
                                color: isCollision ? Colors.redAccent : Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text("Node $val", style: const TextStyle(color: AppTheme.textMuted, fontSize: 10)),
                      ],
                    ),
                    if (idx < nodes.length - 1)
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Icon(Icons.arrow_forward, color: AppTheme.accentNeonCyan, size: 20),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.only(left: 6),
                        child: const Row(
                          children: [
                            Icon(Icons.replay_circle_filled_outlined, color: Colors.redAccent, size: 24),
                            SizedBox(width: 4),
                            Text("Cycle to Node 2", style: TextStyle(color: Colors.redAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                  ],
                );
              }),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            isEnglish ? "Floyd's Cycle Detection: Fast & Slow pointers meet inside loop" : "ফ্লয়েডের সাইকেল ডিটেকশন: লুপের ভেতরে ফাস্ট ও স্লো পয়েন্টারের মিলন",
            style: const TextStyle(color: AppTheme.textMuted, fontSize: 11, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(6), border: Border.all(color: color)),
      child: Text(label, style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.bold)),
    );
  }
}
