import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'debug_array_step.dart';

// ─── GRAPH: CODE LINES ────────────────────────────────────────────────────────

const List<String> gr1CodeLines = [
  "vector<int> bfsOfGraph(int V, vector<vector<int>>& adj) {",
  "    vector<int> bfs; vector<bool> vis(V, false);",
  "    queue<int> q; q.push(0); vis[0] = true;",
  "    while (!q.empty()) {",
  "        int u = q.front(); q.pop(); bfs.push_back(u);",
  "        for (int v : adj[u]) {",
  "            if (!vis[v]) { vis[v] = true; q.push(v); }",
  "        }",
  "    }",
  "    return bfs;",
  "}",
];

const List<String> gr2CodeLines = [
  "void dfs(int u, vector<vector<int>>& adj, vector<bool>& vis, vector<int>& res) {",
  "    vis[u] = true; res.push_back(u);",
  "    for (int v : adj[u]) {",
  "        if (!vis[v]) dfs(v, adj, vis, res);",
  "    }",
  "}",
];

const List<String> gr3CodeLines = [
  "int numIslands(vector<vector<char>>& grid) {",
  "    int count = 0;",
  "    for (int r = 0; r < R; r++) {",
  "        for (int c = 0; c < C; c++) {",
  "            if (grid[r][c] == '1') { count++; sink(r, c); }",
  "        }",
  "    }",
  "    return count;",
  "}",
];

const List<String> gr4CodeLines = [
  "bool isCycleDFS(int u, int parent, vector<vector<int>>& adj, vector<bool>& vis) {",
  "    vis[u] = true;",
  "    for (int v : adj[u]) {",
  "        if (!vis[v]) { if (isCycleDFS(v, u, adj, vis)) return true; }",
  "        else if (v != parent) return true; // Cycle detected!",
  "    }",
  "    return false;",
  "}",
];

// ─── GRAPH: STEPS ─────────────────────────────────────────────────────────────

const List<DebugArrayStep> gr1Steps = [
  DebugArrayStep(
    activeLineIndex: 2,
    queueItems: ["0"],
    array1D: [0],
    minVal: 0,
    explanationEn: "Line 3: Initialize BFS from source Node 0. Push 0 to Queue. Mark vis[0] = true.",
    explanationBn: "লাইন ৩: উৎস নোড 0 থেকে BFS শুরু। 0 কিউতে পুশ এবং vis[0] = true করা হলো।",
  ),
  DebugArrayStep(
    activeLineIndex: 4,
    queueItems: ["1", "2"],
    array1D: [0, 1],
    minVal: 0,
    explanationEn: "Line 5: Pop Node 0 -> Append to BFS order. Push neighbors 1 & 2 to Queue.",
    explanationBn: "লাইন ৫: নোড 0 পপ -> BFS ট্রাভার্সালে যোগ। প্রতিবেশী 1 ও 2 কিউতে পুশ।",
  ),
  DebugArrayStep(
    activeLineIndex: 6,
    queueItems: ["2", "3", "4"],
    array1D: [0, 1, 2],
    minVal: 1,
    explanationEn: "Line 7: Pop Node 1 -> Push unvisited neighbors 3 & 4 into Queue.",
    explanationBn: "লাইন ৭: নোড 1 পপ -> অপ্রকাশিত প্রতিবেশী 3 ও 4 কিউতে পুশ।",
  ),
  DebugArrayStep(
    activeLineIndex: 9,
    queueItems: [],
    array1D: [0, 1, 2, 3, 4],
    minVal: 4,
    explanationEn: "🎉 Line 10: BFS Level Order Traversal Complete! Result = [0, 1, 2, 3, 4]!",
    explanationBn: "🎉 লাইন ১০: লেভেল-বাই-লেভেল BFS ট্রাভার্সাল সম্পন্ন! রেজাল্ট = [0, 1, 2, 3, 4]!",
  ),
];

const List<DebugArrayStep> gr2Steps = [
  DebugArrayStep(
    activeLineIndex: 1,
    stackItems: ["0"],
    array1D: [0],
    minVal: 0,
    explanationEn: "Line 2: Enter dfs(Node 0): Mark vis[0] = true. Call Stack = [0].",
    explanationBn: "লাইন ২: dfs(Node 0) শুরু: vis[0] = true চিহ্নিত। কল স্ট্যাক = [0]।",
  ),
  DebugArrayStep(
    activeLineIndex: 3,
    stackItems: ["0", "1"],
    array1D: [0, 1],
    minVal: 1,
    explanationEn: "Line 4: Deep path -> Recurse into neighbor Node 1: Call Stack = [0, 1].",
    explanationBn: "লাইন ৪: গভীরের পথ -> প্রতিবেশী নোড 1 এ রিকার্সন: কল স্ট্যাক = [0, 1]।",
  ),
  DebugArrayStep(
    activeLineIndex: 3,
    stackItems: ["0", "1", "3"],
    array1D: [0, 1, 3],
    minVal: 3,
    explanationEn: "Line 4: Deep path -> Recurse into neighbor Node 3: Call Stack = [0, 1, 3].",
    explanationBn: "লাইন ৪: গভীরের পথ -> প্রতিবেশী নোড 3 এ রিকার্সন: কল স্ট্যাক = [0, 1, 3]।",
  ),
  DebugArrayStep(
    activeLineIndex: 3,
    stackItems: ["0", "2", "4"],
    array1D: [0, 1, 3, 2, 4],
    minVal: 4,
    explanationEn: "🎉 Line 4: Backtrack & visit remaining nodes 2 and 4! DFS Complete = [0, 1, 3, 2, 4]!",
    explanationBn: "🎉 লাইন ৪: ব্যাকট্র্যাক করে অবশিষ্ট নোড 2 ও 4 ভিসিট সম্পন্ন! DFS = [0, 1, 3, 2, 4]!",
  ),
];

const List<DebugArrayStep> gr3Steps = [
  DebugArrayStep(
    activeLineIndex: 4,
    matrix2D: [[1, 1, 0], [1, 1, 0], [0, 0, 1]],
    minVal: 1,
    explanationEn: "Line 5: Encountered Land '1' at (0, 0) -> Count = 1. Trigger sink() DFS.",
    explanationBn: "লাইন ৫: গ্রিড (0, 0) এ মাটি '1' পাওয়া গেছে -> দ্বীপ গণনা = 1। sink() ট্রাভার্সাল শুরু।",
  ),
  DebugArrayStep(
    activeLineIndex: 4,
    matrix2D: [[0, 0, 0], [0, 0, 0], [0, 0, 1]],
    minVal: 1,
    explanationEn: "Line 5: Sunk all connected land cells of Island 1 ('1' -> '0').",
    explanationBn: "লাইন ৫: প্রথম দ্বীপের সংযুক্ত সব মাটি ডুবিয়ে '0' করা হলো।",
  ),
  DebugArrayStep(
    activeLineIndex: 4,
    matrix2D: [[0, 0, 0], [0, 0, 0], [0, 0, 0]],
    minVal: 2,
    explanationEn: "🎉 Line 5: Encountered Land '1' at (2, 2) -> Count = 2. Sunk Island 2! Total Islands = 2!",
    explanationBn: "🎉 লাইন ৫: গ্রিড (2, 2) এ ২য় মাটি পাওয়া গেছে -> ২য় দ্বীপ ডুবানো শেষ! মোট দ্বীপ = 2!",
  ),
];

const List<DebugArrayStep> gr4Steps = [
  DebugArrayStep(
    activeLineIndex: 1,
    array1D: [0, 1, 2, 3],
    pointer1: 0,
    pointer2: -1,
    explanationEn: "Line 2: Start cycle detection from Node 0 (parent = -1). Edges: 0-1, 1-2, 2-3, 3-0.",
    explanationBn: "লাইন ২: নোড 0 থেকে সাইকেল ডিটেকশন শুরু (parent = -1)।",
  ),
  DebugArrayStep(
    activeLineIndex: 3,
    array1D: [0, 1, 2, 3],
    pointer1: 3,
    pointer2: 2,
    explanationEn: "Line 4: Traverse along path 0 -> 1 -> 2 -> 3.",
    explanationBn: "লাইন ৪: পথ ধরে ট্রাভার্সাল 0 -> 1 -> 2 -> 3।",
  ),
  DebugArrayStep(
    activeLineIndex: 4,
    array1D: [0, 1, 2, 3],
    pointer1: 0,
    pointer2: 3,
    explanationEn: "🎉 Line 5: Node 3 neighbor Node 0 is already VISITED and 0 != parent(2)! CYCLE DETECTED! Return TRUE!",
    explanationBn: "🎉 লাইন ৫: নোড 3 এর প্রতিবেশী 0 আগে থেকেই ভিজিটেড এবং 0 != parent(2)! গ্রাফে সাইকেল শনাক্ত! Return TRUE!",
  ),
];

// ─── GETTERS ──────────────────────────────────────────────────────────────────

List<String> getGraphCodeLines(String id) {
  if (id == "gr-2") return gr2CodeLines;
  if (id == "gr-3") return gr3CodeLines;
  if (id == "gr-4") return gr4CodeLines;
  return gr1CodeLines;
}

List<DebugArrayStep> getGraphSteps(String id) {
  if (id == "gr-2") return gr2Steps;
  if (id == "gr-3") return gr3Steps;
  if (id == "gr-4") return gr4Steps;
  return gr1Steps;
}

// ─── GRAPH CANVAS WIDGET ──────────────────────────────────────────────────────

Widget buildGraphCanvas(DebugArrayStep step, String problemId) {
  if (problemId == "gr-3" && step.matrix2D != null) {
    return Column(
      children: [
        const Text("2D Grid Island Map (1 = Land, 0 = Water/Sunk)", style: TextStyle(color: Color(0xFF0284C7), fontWeight: FontWeight.bold, fontSize: 13)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF090D16),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF0284C7), width: 2),
          ),
          child: Column(
            children: List.generate(step.matrix2D!.length, (r) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(step.matrix2D![0].length, (c) {
                  final val = step.matrix2D![r][c];
                  final isLand = val == 1;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 55,
                    height: 55,
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: isLand ? const Color(0xFF0284C7) : AppTheme.surfaceDark,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: isLand ? Colors.white : const Color(0xFF1E293B)),
                      boxShadow: isLand ? [BoxShadow(color: const Color(0xFF0284C7).withOpacity(0.6), blurRadius: 8)] : [],
                    ),
                    child: Center(
                      child: Text(
                        isLand ? "🌴 1" : "🌊 0",
                        style: TextStyle(color: isLand ? Colors.white : AppTheme.textMuted, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                  );
                }),
              );
            }),
          ),
        ),
      ],
    );
  }

  final nodes = step.array1D ?? [0, 1, 2, 3, 4];
  return Column(
    children: [
      const Text("Graph Vertices & Traversal Tracker", style: TextStyle(color: Color(0xFF0284C7), fontWeight: FontWeight.bold, fontSize: 13)),
      const SizedBox(height: 12),
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF090D16),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF0284C7), width: 2),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(nodes.length, (idx) {
              final nodeVal = nodes[idx];
              final isActive = step.pointer1 == nodeVal;
              final isParent = step.pointer2 == nodeVal;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 5),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isActive ? AppTheme.accentNeonCyan : (isParent ? AppTheme.accentPink : const Color(0xFF0284C7)),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: (isActive || isParent) ? Colors.white : Colors.transparent, width: 2),
                ),
                child: Column(
                  children: [
                    Text("Node $nodeVal", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 2),
                    Text(
                      isActive ? "ACTIVE" : (isParent ? "PARENT" : "VISITED"),
                      style: const TextStyle(fontSize: 8.5, fontWeight: FontWeight.bold, color: Colors.white70),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    ],
  );
}
