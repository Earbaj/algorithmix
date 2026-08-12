import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'debug_array_step.dart';
import 'bst_visualizer.dart';
import 'heap_visualizer.dart';
import 'graph_visualizer.dart';
import 'trie_visualizer.dart';

// ─── GLOBAL STEP/CODE LINE RESOLVER ──────────────────────────────────────────
// Import all topic visualizers and resolve steps/code lines by problem ID.
import 'array_visualizer.dart';
import 'linked_list_visualizer.dart';
import 'stack_visualizer.dart';
import 'queue_visualizer.dart';
import 'hash_map_visualizer.dart';

List<DebugArrayStep> getStepsForProblem(String id) {
  if (id.startsWith("tr-")) return getTrieSteps(id);
  if (id.startsWith("gr-")) return getGraphSteps(id);
  if (id.startsWith("hp-")) return getHeapSteps(id);
  if (id.startsWith("bst-")) return getBstSteps(id);
  if (id.startsWith("hm-")) return getHashMapSteps(id);
  if (id.startsWith("q-")) return getQueueSteps(id);
  if (id.startsWith("st-")) return getStackSteps(id);
  if (id.startsWith("ll-")) return getLinkedListSteps(id);
  // Arrays (arr-1..4) are the fallback
  return getArraySteps(id);
}

List<String> getCodeLinesForProblem(String id) {
  if (id.startsWith("tr-")) return getTrieCodeLines(id);
  if (id.startsWith("gr-")) return getGraphCodeLines(id);
  if (id.startsWith("hp-")) return getHeapCodeLines(id);
  if (id.startsWith("bst-")) return getBstCodeLines(id);
  if (id.startsWith("hm-")) return getHashMapCodeLines(id);
  if (id.startsWith("q-")) return getQueueCodeLines(id);
  if (id.startsWith("st-")) return getStackCodeLines(id);
  if (id.startsWith("ll-")) return getLinkedListCodeLines(id);
  return getArrayCodeLines(id);
}

// ─── CODE SNIPPET WITH LINE HIGHLIGHT ────────────────────────────────────────

Widget buildCodeSnippetWithHighlight(List<String> codeLines, int activeIndex) {
  return Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: const Color(0xFF090D16),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: const Color(0xFF1E293B)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(codeLines.length, (idx) {
        final isHighlighted = idx == activeIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          margin: const EdgeInsets.symmetric(vertical: 1),
          decoration: BoxDecoration(
            color: isHighlighted ? AppTheme.accentNeonCyan.withOpacity(0.2) : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            border: isHighlighted ? Border.all(color: AppTheme.accentNeonCyan.withOpacity(0.6)) : null,
          ),
          child: Row(
            children: [
              SizedBox(
                width: 24,
                child: Text(
                  "${idx + 1}",
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 11,
                    color: isHighlighted ? AppTheme.accentNeonCyan : const Color(0xFF64748B),
                    fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
              if (isHighlighted)
                const Padding(
                  padding: EdgeInsets.only(right: 6),
                  child: Icon(Icons.arrow_right_alt, color: AppTheme.accentNeonCyan, size: 14),
                )
              else
                const SizedBox(width: 20),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    codeLines[idx],
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      color: isHighlighted ? Colors.white : const Color(0xFF38BDF8),
                      fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    ),
  );
}

// ─── VISUALIZER BOX ───────────────────────────────────────────────────────────

Widget buildVisualizerBox({
  required DebugArrayStep step,
  required String problemId,
  required bool isEnglish,
  required int currentStepIndex,
  required String Function(DebugArrayStep) getMinValHeaderLabel,
}) {
  return Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: const Color(0xFF090D16),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: const Color(0xFF1E293B)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Inspector Header
        if (step.minVal != null || step.maxVal != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (step.minVal != null)
                Text(
                  getMinValHeaderLabel(step),
                  style: const TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 14),
                ),
              if (step.maxVal != null)
                Text(
                  "Max Bound: ${step.maxVal}",
                  style: const TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 14),
                ),
            ],
          ),
          const SizedBox(height: 10),
        ],

        // Trie Canvas
        if (problemId.startsWith("tr-")) ...[
          buildTrieCanvas(step),
          const SizedBox(height: 16),
        ],

        // Graph Canvas
        if (problemId.startsWith("gr-")) ...[
          buildGraphCanvas(step, problemId),
          const SizedBox(height: 16),
        ],

        // Heap Canvas
        if (problemId.startsWith("hp-")) ...[
          buildHeapCanvas(step),
          const SizedBox(height: 16),
        ],

        // BST Canvases
        if (problemId == "bst-2") ...[
          buildBstInsertCanvas(step, currentStepIndex),
          const SizedBox(height: 16),
        ] else if (problemId.startsWith("bst-")) ...[
          buildBstCanvas(step, problemId),
          const SizedBox(height: 16),
        ],

        // Hash Map Bucket Inspector
        if (problemId.startsWith("hm-") && step.hashMapItems != null) ...[
          Column(
            children: [
              const Text("Hash Map Bucket Container (Key -> Value)", style: TextStyle(color: AppTheme.accentPink, fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF090D16),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTheme.accentPink, width: 2),
                ),
                child: step.hashMapItems!.isEmpty
                    ? Center(child: Text(isEnglish ? "[Hash Map Empty]" : "[হ্যাশ ম্যাপ খালি]", style: const TextStyle(color: AppTheme.textMuted, fontSize: 12)))
                    : Column(
                        children: step.hashMapItems!.entries.map((entry) {
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceDark,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppTheme.accentPink.withOpacity(0.5)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("KEY: ${entry.key}", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13)),
                                const Icon(Icons.arrow_right_alt, color: AppTheme.accentPink, size: 18),
                                Text("VAL: ${entry.value}", style: const TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 13)),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],

        // Queue FIFO Pipeline
        if (problemId.startsWith("q-") && step.queueItems != null && !problemId.startsWith("tr-")) ...[
          Column(
            children: [
              const Text("Horizontal Queue FIFO Pipeline (Front -> Rear)", style: TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                height: 75,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF090D16),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.accentAmber, width: 2),
                ),
                child: step.queueItems!.isEmpty
                    ? Center(child: Text(isEnglish ? "[Queue Empty]" : "[কিউ খালি]", style: const TextStyle(color: AppTheme.textMuted, fontSize: 12)))
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(step.queueItems!.length, (idx) {
                            final item = step.queueItems![idx];
                            final isFront = idx == 0;
                            final isRear = idx == step.queueItems!.length - 1;
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: isFront ? AppTheme.accentAmber : (isRear ? AppTheme.accentNeonCyan : AppTheme.surfaceDark),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.white, width: (isFront || isRear) ? 2 : 1),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(item, style: TextStyle(color: (isFront || isRear) ? AppTheme.primaryDark : Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                                  Text(
                                    isFront ? "FRONT" : (isRear ? "REAR" : "[$idx]"),
                                    style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.bold, color: (isFront || isRear) ? AppTheme.primaryDark : AppTheme.textMuted),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                      ),
              ),
            ],
          ),
        ],

        // Stack LIFO Visualizer
        if (problemId.startsWith("st-") && step.stackItems != null) ...[
          Column(
            children: [
              const Text("Vertical Stack LIFO Container (Top)", style: TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 12),
              Container(
                width: 180,
                height: 170,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF090D16),
                  borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
                  border: Border.all(color: AppTheme.accentGreen, width: 2),
                ),
                child: step.stackItems!.isEmpty
                    ? Center(child: Text(isEnglish ? "[Stack Empty]" : "[স্ট্যাক খালি]", style: const TextStyle(color: AppTheme.textMuted, fontSize: 12)))
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: List.generate(step.stackItems!.length, (idx) {
                          final reverseIdx = step.stackItems!.length - 1 - idx;
                          final item = step.stackItems![reverseIdx];
                          final isTop = reverseIdx == step.stackItems!.length - 1;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(vertical: 3),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: isTop ? AppTheme.accentGreen : AppTheme.surfaceDark,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: isTop ? Colors.white : AppTheme.accentGreen.withOpacity(0.4)),
                            ),
                            child: Center(
                              child: Text(
                                isTop ? "TOP: $item" : item,
                                style: TextStyle(color: isTop ? AppTheme.primaryDark : Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                            ),
                          );
                        }),
                      ),
              ),
            ],
          ),
        ],

        // 1D Array or Linked List Canvas
        if (step.array1D != null &&
            !problemId.startsWith("bst-") &&
            !problemId.startsWith("hp-") &&
            !problemId.startsWith("gr-") &&
            !problemId.startsWith("tr-")) ...[
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(step.array1D!.length, (i) {
                final isP1 = step.pointer1 == i;
                final isP2 = step.pointer2 == i;
                final color = isP1 ? AppTheme.accentNeonCyan : (isP2 ? AppTheme.accentPink : AppTheme.surfaceDark);
                final isLinkedList = problemId.startsWith("ll-");
                final isDoubly = problemId == "ll-3";

                String badge1 = "curr [$i]";
                String badge2 = "prev [$i]";
                if (problemId == "ll-2" || problemId == "ll-4") {
                  badge1 = "slow [$i]";
                  badge2 = "fast [$i]";
                } else if (problemId.startsWith("hm-")) {
                  badge1 = "i [$i]";
                }

                return Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      width: isLinkedList ? 58 : 52,
                      height: 65,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(isLinkedList ? 30 : 12),
                        border: Border.all(color: (isP1 || isP2) ? Colors.white : AppTheme.textMuted.withOpacity(0.3), width: (isP1 || isP2) ? 2.5 : 1),
                        boxShadow: (isP1 || isP2) ? [BoxShadow(color: color.withOpacity(0.5), blurRadius: 8)] : [],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("${step.array1D![i]}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: (isP1 || isP2) ? AppTheme.primaryDark : Colors.white)),
                          const SizedBox(height: 4),
                          Text(isP1 ? badge1 : (isP2 ? badge2 : "[$i]"), style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.bold, color: (isP1 || isP2) ? AppTheme.primaryDark : AppTheme.textMuted)),
                        ],
                      ),
                    ),
                    if (isLinkedList && i < step.array1D!.length - 1)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(isDoubly ? Icons.swap_horiz : Icons.arrow_right_alt, color: AppTheme.accentNeonCyan, size: 20),
                      ),
                  ],
                );
              }),
            ),
          ),
        ],

        // 2D Matrix Canvas
        if (step.matrix2D != null && problemId != "gr-3" && problemId != "tr-4") ...[
          Column(
            children: [
              const Text("Transposed Result Grid (3x2)", style: TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 12),
              ...List.generate(step.matrix2D!.length, (r) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(step.matrix2D![0].length, (c) {
                    final val = step.matrix2D![r][c];
                    final isFilled = val != 0;
                    return Container(
                      width: 44,
                      height: 44,
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: isFilled ? AppTheme.accentGreen : AppTheme.surfaceDark,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text("$val", style: TextStyle(color: isFilled ? AppTheme.primaryDark : AppTheme.textMuted, fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                    );
                  }),
                );
              }),
            ],
          ),
        ],
      ],
    ),
  );
}

// ─── CONTROL BAR ──────────────────────────────────────────────────────────────

Widget buildControlBar({
  required int currentStepIndex,
  required int totalSteps,
  required bool isPlaying,
  required bool isEnglish,
  required VoidCallback onPrev,
  required VoidCallback onPlay,
  required VoidCallback onNext,
  required VoidCallback onReset,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    decoration: BoxDecoration(
      color: AppTheme.primaryDark,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppTheme.textMuted.withOpacity(0.4)),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.skip_previous, color: Colors.white),
              onPressed: currentStepIndex > 0 ? onPrev : null,
            ),
            IconButton(
              icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow, color: AppTheme.accentNeonCyan),
              onPressed: onPlay,
            ),
            IconButton(
              icon: const Icon(Icons.skip_next, color: Colors.white),
              onPressed: currentStepIndex < totalSteps - 1 ? onNext : null,
            ),
            IconButton(
              icon: const Icon(Icons.refresh, color: AppTheme.accentNeonCyan),
              onPressed: onReset,
            ),
          ],
        ),
        Text(
          isEnglish
              ? "Step ${currentStepIndex + 1} of $totalSteps"
              : "ধাপ ${currentStepIndex + 1} / $totalSteps",
          style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ],
    ),
  );
}
