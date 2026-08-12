import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'debug_array_step.dart';

// ─── TRIE: CODE LINES ─────────────────────────────────────────────────────────

const List<String> tr1CodeLines = [
  "void insert(string word) {",
  "    TrieNode* curr = root;",
  "    for (char c : word) {",
  "        int idx = c - 'a';",
  "        if (!curr->children[idx]) curr->children[idx] = new TrieNode();",
  "        curr = curr->children[idx];",
  "    }",
  "    curr->isEndOfWord = true;",
  "}",
];

const List<String> tr2CodeLines = [
  "bool searchHelper(string& word, int idx, TrieNode* node) {",
  "    if (!node) return false;",
  "    if (idx == word.length()) return node->isEndOfWord;",
  "    char c = word[idx];",
  "    if (c == '.') {",
  "        for (int i = 0; i < 26; i++) { if (dfs(i)) return true; }",
  "    } else return dfs(c - 'a');",
  "}",
];

const List<String> tr3CodeLines = [
  "string getShortestRoot(string word) {",
  "    TrieNode* curr = root; string prefix = \"\";",
  "    for (char c : word) {",
  "        if (!curr->children[c - 'a']) break;",
  "        curr = curr->children[c - 'a']; prefix += c;",
  "        if (curr->isEndOfWord) return prefix;",
  "    }",
  "    return word;",
  "}",
];

const List<String> tr4CodeLines = [
  "void dfsGrid(int r, int c, TrieNode* node) {",
  "    if (!node->children[ch - 'a']) return; // Prune!",
  "    node = node->children[ch - 'a'];",
  "    if (!node->word.empty()) res.push_back(node->word);",
  "    board[r][c] = '#';",
  "    for (auto& dir : dirs) dfsGrid(r+dr, c+dc, node);",
  "    board[r][c] = ch;",
  "}",
];

// ─── TRIE: STEPS ──────────────────────────────────────────────────────────────

const List<DebugArrayStep> tr1Steps = [
  DebugArrayStep(
    activeLineIndex: 1,
    queueItems: ["ROOT"],
    explanationEn: "Line 2: Start insert(\"apple\"). curr = root node.",
    explanationBn: "লাইন ২: insert(\"apple\") শুরু। curr = রুট নোড।",
  ),
  DebugArrayStep(
    activeLineIndex: 4,
    queueItems: ["ROOT", "a"],
    explanationEn: "Line 5: Char 'a': Create new TrieNode('a') under root. Move curr -> 'a'.",
    explanationBn: "লাইন ৫: ক্যারেক্টার 'a': রুটের নিচে নতুন TrieNode('a') তৈরি। curr -> 'a'।",
  ),
  DebugArrayStep(
    activeLineIndex: 4,
    queueItems: ["ROOT", "a", "p"],
    explanationEn: "Line 5: Char 'p': Create new TrieNode('p') under 'a'. Move curr -> 'p'.",
    explanationBn: "লাইন ৫: ক্যারেক্টার 'p': 'a' এর নিচে নতুন TrieNode('p') তৈরি। curr -> 'p'।",
  ),
  DebugArrayStep(
    activeLineIndex: 4,
    queueItems: ["ROOT", "a", "p", "p"],
    explanationEn: "Line 5: Char 'p': Create 2nd TrieNode('p') under 1st 'p'. Move curr -> 'p'.",
    explanationBn: "লাইন ৫: ২য় 'p': প্রথম 'p' এর নিচে তৈরি। curr -> 'p'।",
  ),
  DebugArrayStep(
    activeLineIndex: 4,
    queueItems: ["ROOT", "a", "p", "p", "l", "e"],
    minVal: 1,
    explanationEn: "🎉 Line 8: Char 'e': Reached end of word! Mark isEndOfWord = true at node 'e'!",
    explanationBn: "🎉 লাইন ৮: শেষ ক্যারেক্টার 'e': শব্দের সমাপ্তি! নোড 'e' তে isEndOfWord = true ফ্ল্যাগ!",
  ),
];

const List<DebugArrayStep> tr2Steps = [
  DebugArrayStep(
    activeLineIndex: 4,
    queueItems: ["."],
    explanationEn: "Line 5: Wildcard search(\".ad\"): Char 0 is '.' -> Test all non-null children ('b', 'd').",
    explanationBn: "লাইন ৫: ওয়াইল্ডকার্ড সার্চ(\".ad\"): ১ম ক্যারেক্টার '.' -> সব চাইল্ড নোড ('b', 'd') চেক।",
  ),
  DebugArrayStep(
    activeLineIndex: 6,
    queueItems: [".", "a", "d"],
    minVal: 1,
    explanationEn: "🎉 Line 7: Matched path 'b' -> 'a' -> 'd'! isEndOfWord == true! Return TRUE!",
    explanationBn: "🎉 লাইন ৭: প্রিফিক্স পাথ 'b' -> 'a' -> 'd' হুবহু মিলেছে! Return TRUE!",
  ),
];

const List<DebugArrayStep> tr3Steps = [
  DebugArrayStep(
    activeLineIndex: 4,
    queueItems: ["c", "a", "t"],
    minVal: 1,
    explanationEn: "Line 5: Word \"cattle\": Walk Trie 'c' -> 'a' -> 't'. Node 't' has isEndOfWord = true!",
    explanationBn: "লাইন ৫: শব্দ \"cattle\": ট্রাই দিয়ে হেটে 'c' -> 'a' -> 't'। নোড 't' এ ইমপ্লিসিট রুটের সমাপ্তি!",
  ),
  DebugArrayStep(
    activeLineIndex: 5,
    queueItems: ["c", "a", "t"],
    minVal: 1,
    explanationEn: "🎉 Line 6: Found shortest matching dictionary root \"cat\"! Replace \"cattle\" -> \"cat\"!",
    explanationBn: "🎉 লাইন ৬: ডিকশনারির সর্বনিম্ন রুট \"cat\" পাওয়া গেছে! \"cattle\" এর বদলে \"cat\" বসানো হলো!",
  ),
];

const List<DebugArrayStep> tr4Steps = [
  DebugArrayStep(
    activeLineIndex: 1,
    matrix2D: [[1, 1, 1, 1], [0, 1, 0, 1], [0, 1, 0, 1]],
    queueItems: ["o", "a", "t", "h"],
    minVal: 1,
    explanationEn: "Line 2: Word Search II: 4-directional DFS on board cell (0,0) 'o' -> Matches Trie path \"oath\"!",
    explanationBn: "লাইন ২: Word Search II: গ্রিড সেল (0,0) 'o' থেকে ৪-দিকমুখী DFS -> ট্রাই পাথ \"oath\" এর সাথে মিলেছে!",
  ),
  DebugArrayStep(
    activeLineIndex: 3,
    matrix2D: [[1, 1, 1, 1], [0, 1, 0, 1], [0, 1, 0, 1]],
    queueItems: ["o", "a", "t", "h"],
    minVal: 1,
    explanationEn: "🎉 Line 4: Reached end of word node! Added target word \"oath\" to result list!",
    explanationBn: "🎉 লাইন ৪: টার্গেট শব্দের সমাপ্তি নোডে পৌঁছেছে! \"oath\" রেজাল্ট লিস্টে যুক্ত করা হলো!",
  ),
];

// ─── GETTERS ──────────────────────────────────────────────────────────────────

List<String> getTrieCodeLines(String id) {
  if (id == "tr-2") return tr2CodeLines;
  if (id == "tr-3") return tr3CodeLines;
  if (id == "tr-4") return tr4CodeLines;
  return tr1CodeLines;
}

List<DebugArrayStep> getTrieSteps(String id) {
  if (id == "tr-2") return tr2Steps;
  if (id == "tr-3") return tr3Steps;
  if (id == "tr-4") return tr4Steps;
  return tr1Steps;
}

// ─── TRIE CANVAS WIDGET ───────────────────────────────────────────────────────

Widget buildTrieCanvas(DebugArrayStep step) {
  final pathChars = step.queueItems ?? ["ROOT"];

  return Column(
    children: [
      const Text("Trie Node Character Branch Path (N-ary Tree)", style: TextStyle(color: Color(0xFFA855F7), fontWeight: FontWeight.bold, fontSize: 13)),
      const SizedBox(height: 12),
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF090D16),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFA855F7), width: 2),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(pathChars.length, (idx) {
              final ch = pathChars[idx];
              final isEnd = idx == pathChars.length - 1;

              return Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isEnd ? const Color(0xFFA855F7) : AppTheme.surfaceDark,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: isEnd ? Colors.white : const Color(0xFFA855F7).withOpacity(0.5), width: isEnd ? 2 : 1),
                      boxShadow: isEnd ? [BoxShadow(color: const Color(0xFFA855F7).withOpacity(0.6), blurRadius: 10)] : [],
                    ),
                    child: Column(
                      children: [
                        Text(ch, style: TextStyle(color: isEnd ? Colors.white : AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 2),
                        Text(
                          isEnd && step.minVal == 1 ? "isEnd=true" : "[$idx]",
                          style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.bold, color: isEnd ? Colors.white70 : AppTheme.textMuted),
                        ),
                      ],
                    ),
                  ),
                  if (idx < pathChars.length - 1)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(Icons.arrow_right_alt, color: Color(0xFFA855F7), size: 20),
                    ),
                ],
              );
            }),
          ),
        ),
      ),
    ],
  );
}
