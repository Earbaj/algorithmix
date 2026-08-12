import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'debug_array_step.dart';

// ─── BST: CODE LINES ──────────────────────────────────────────────────────────

const List<String> bst1CodeLines = [
  "TreeNode* searchBST(TreeNode* root, int val) {",
  "    if (!root || root->val == val) return root;",
  "    if (val < root->val) return searchBST(root->left, val);",
  "    return searchBST(root->right, val);",
  "}",
];

const List<String> bst2CodeLines = [
  "TreeNode* insertIntoBST(TreeNode* root, int val) {",
  "    if (!root) return new TreeNode(val);",
  "    if (val < root->val) root->left = insertIntoBST(root->left, val);",
  "    else root->right = insertIntoBST(root->right, val);",
  "    return root;",
  "}",
];

const List<String> bst3CodeLines = [
  "bool validate(TreeNode* node, long minBound, long maxBound) {",
  "    if (!node) return true;",
  "    if (node->val <= minBound || node->val >= maxBound) return false;",
  "    return validate(node->left, minBound, node->val) &&",
  "           validate(node->right, node->val, maxBound);",
  "}",
];

const List<String> bst4CodeLines = [
  "TreeNode* lowestCommonAncestor(TreeNode* root, TreeNode* p, TreeNode* q) {",
  "    if (p->val < root->val && q->val < root->val)",
  "        return lowestCommonAncestor(root->left, p, q);",
  "    if (p->val > root->val && q->val > root->val)",
  "        return lowestCommonAncestor(root->right, p, q);",
  "    return root;",
  "}",
];

// ─── BST: STEPS ───────────────────────────────────────────────────────────────

const List<DebugArrayStep> bst1Steps = [
  DebugArrayStep(
    activeLineIndex: 0,
    pointer1: 4,
    minVal: 2,
    explanationEn: "Line 1: Enter searchBST(root, val = 2). Active Root Node = 4.",
    explanationBn: "লাইন ১: searchBST(root, val = 2) এ প্রবেশ। সক্রিয় রুট নোড = 4।",
  ),
  DebugArrayStep(
    activeLineIndex: 1,
    pointer1: 4,
    minVal: 2,
    explanationEn: "Line 2: Check (!root || root->val == val) -> (!null || 4 == 2) is FALSE.",
    explanationBn: "লাইন ২: শর্ত চেক (!root || 4 == 2) মিথ্যা। পরবর্তী লাইনে যান।",
  ),
  DebugArrayStep(
    activeLineIndex: 2,
    pointer1: 4,
    minVal: 2,
    explanationEn: "Line 3: Check (val < root->val) -> (2 < 4) is TRUE! Branch LEFT to root->left.",
    explanationBn: "লাইন ৩: শর্ত (2 < 4) সত্য! বাম সাবট্রি root->left এ যান।",
  ),
  DebugArrayStep(
    activeLineIndex: 0,
    pointer1: 2,
    minVal: 2,
    explanationEn: "Line 1: Recurse into searchBST(Node 2, val = 2). Active Node = 2.",
    explanationBn: "লাইন ১: searchBST(Node 2, val = 2) এ রিকার্সিভ কল। সক্রিয় নোড = 2।",
  ),
  DebugArrayStep(
    activeLineIndex: 1,
    pointer1: 2,
    minVal: 2,
    explanationEn: "🎉 Line 2: Check (!root || 2 == 2) -> MATCH FOUND! Return subtree rooted at Node 2!",
    explanationBn: "🎉 লাইন ২: শর্ত (2 == 2) মিল পাওয়া গেছে! Node 2 এর সাবট্রি রিটার্ন করা হলো!",
  ),
];

const List<DebugArrayStep> bst2Steps = [
  DebugArrayStep(
    activeLineIndex: 0,
    pointer1: 4,
    minVal: 5,
    explanationEn: "Step 1 (Line 1): Start insertIntoBST(root, val = 5). Compare target 5 with Root 4.",
    explanationBn: "ধাপ ১ (লাইন ১): insertIntoBST(root, val = 5) শুরু। টার্গেট মান 5 কে রুট নোড 4 এর সাথে তুলনা করুন।",
  ),
  DebugArrayStep(
    activeLineIndex: 1,
    pointer1: 4,
    minVal: 5,
    explanationEn: "Step 2 (Line 2): Check if (!root) -> FALSE (Root 4 is not null).",
    explanationBn: "ধাপ ২ (লাইন ২): শর্ত (!root) চেক -> মিথ্যা (রুট নোড 4 বিদ্যমান)।",
  ),
  DebugArrayStep(
    activeLineIndex: 2,
    pointer1: 4,
    minVal: 5,
    explanationEn: "Step 3 (Line 3): Check if (val < root->val) -> (5 < 4) is FALSE. Target 5 is GREATER than 4!",
    explanationBn: "ধাপ ৩ (লাইন ৩): শর্ত (5 < 4) মিথ্যা। 5 মানটি 4 এর চেয়ে বড়!",
  ),
  DebugArrayStep(
    activeLineIndex: 3,
    pointer1: 4,
    minVal: 5,
    explanationEn: "Step 4 (Line 4): Since 5 > 4, branch RIGHT: root->right = insertIntoBST(Node 7, val = 5).",
    explanationBn: "ধাপ ৪ (লাইন ৪): যেহেতু 5 > 4, তাই ডানে যান: root->right = insertIntoBST(Node 7, val = 5)।",
  ),
  DebugArrayStep(
    activeLineIndex: 0,
    pointer1: 7,
    minVal: 5,
    explanationEn: "Step 5 (Line 1): Enter Node 7. Compare target 5 with Node 7.",
    explanationBn: "ধাপ ৫ (লাইন ১): নোড 7 এ প্রবেশ। টার্গেট মান 5 কে নোড 7 এর সাথে তুলনা করুন।",
  ),
  DebugArrayStep(
    activeLineIndex: 2,
    pointer1: 7,
    minVal: 5,
    explanationEn: "Step 6 (Line 3): Check if (val < root->val) -> (5 < 7) is TRUE! Target 5 is SMALLER than 7!",
    explanationBn: "ধাপ ৬ (লাইন ৩): শর্ত (5 < 7) সত্য! 5 মানটি 7 এর চেয়ে ছোট! বামে আগান -> root->left = insertIntoBST(nullptr, 5)।",
  ),
  DebugArrayStep(
    activeLineIndex: 1,
    pointer1: 5,
    minVal: 5,
    explanationEn: "Step 7 (Line 2): Reached empty nullptr space under Node 7! Create new TreeNode(5).",
    explanationBn: "ধাপ ৭ (লাইন ২): নোড 7 এর বামে খালি নাল স্থান পাওয়া গেছে! নতুন TreeNode(5) তৈরি করা হলো।",
  ),
  DebugArrayStep(
    activeLineIndex: 4,
    pointer1: 5,
    minVal: 5,
    explanationEn: "🎉 Step 8 (Line 5): Attached TreeNode(5) as Left Child of Node 7. BST Insertion Complete!",
    explanationBn: "🎉 ধাপ ৮ (লাইন ৫): নোড 7 এর বাম চাইল্ড হিসেবে TreeNode(5) সফলভাবে যুক্ত করা হলো! BST ইনসার্ট সম্পন্ন!",
  ),
];

const List<DebugArrayStep> bst3Steps = [
  DebugArrayStep(
    activeLineIndex: 0,
    pointer1: 2,
    minVal: -999,
    maxVal: 999,
    explanationEn: "Line 1: Start validate(Root Node 2, minBound = -INF, maxBound = INF).",
    explanationBn: "লাইন ১: validate(Root Node 2, minBound = -INF, maxBound = INF) শুরু।",
  ),
  DebugArrayStep(
    activeLineIndex: 1,
    pointer1: 2,
    minVal: -999,
    maxVal: 999,
    explanationEn: "Line 2: Check if (!node) -> FALSE (Node 2 exists).",
    explanationBn: "লাইন ২: শর্ত (!node) মিথ্যা (নোড 2 বিদ্যমান)।",
  ),
  DebugArrayStep(
    activeLineIndex: 2,
    pointer1: 2,
    minVal: -999,
    maxVal: 999,
    explanationEn: "Line 3: Check bounds: (-INF < 2 < INF) is VALID. Proceed to subtrees.",
    explanationBn: "লাইন ৩: সীমানা চেক: (-INF < 2 < INF) সঠিক। সাবট্রি ভ্যালিডেশনে যান।",
  ),
  DebugArrayStep(
    activeLineIndex: 3,
    pointer1: 1,
    minVal: -999,
    maxVal: 2,
    explanationEn: "Line 4: Recurse Left Child (Node 1) with bounds (-INF, 2) -> VALID!",
    explanationBn: "লাইন ৪: বাম চাইল্ড (1) রিকার্সন সীমানা (-INF, 2) -> সঠিক!",
  ),
  DebugArrayStep(
    activeLineIndex: 4,
    pointer1: 3,
    minVal: 2,
    maxVal: 999,
    explanationEn: "🎉 Line 5: Recurse Right Child (Node 3) with bounds (2, INF) -> VALID! Return TRUE!",
    explanationBn: "🎉 লাইন ৫: ডান চাইল্ড (3) রিকার্সন সীমানা (2, INF) -> সঠিক! Return TRUE!",
  ),
];

const List<DebugArrayStep> bst4Steps = [
  DebugArrayStep(
    activeLineIndex: 0,
    pointer1: 6,
    minVal: 2,
    maxVal: 8,
    explanationEn: "Line 1: Enter LCA(Root Node 6, p = 2, q = 8).",
    explanationBn: "লাইন ১: LCA(Root Node 6, p = 2, q = 8) এ প্রবেশ।",
  ),
  DebugArrayStep(
    activeLineIndex: 1,
    pointer1: 6,
    minVal: 2,
    maxVal: 8,
    explanationEn: "Line 2: Check if both p(2) and q(8) < 6 -> (2 < 6 && 8 < 6) is FALSE.",
    explanationBn: "লাইন ২: শর্ত (2 < 6 && 8 < 6) মিথ্যা।",
  ),
  DebugArrayStep(
    activeLineIndex: 3,
    pointer1: 6,
    minVal: 2,
    maxVal: 8,
    explanationEn: "Line 4: Check if both p(2) and q(8) > 6 -> (2 > 6 && 8 > 6) is FALSE.",
    explanationBn: "লাইন ৪: শর্ত (2 > 6 && 8 > 6) মিথ্যা।",
  ),
  DebugArrayStep(
    activeLineIndex: 5,
    pointer1: 6,
    minVal: 2,
    maxVal: 8,
    explanationEn: "🎉 Line 6: Nodes p=2 and q=8 split into opposite subtrees at Root 6! Lowest Common Ancestor = Node 6!",
    explanationBn: "🎉 লাইন ৬: p=2 এবং q=8 রুট 6 এ দুই দিকে বিভক্ত হয়! Lowest Common Ancestor = Node 6!",
  ),
];

// ─── GETTERS ──────────────────────────────────────────────────────────────────

List<String> getBstCodeLines(String id) {
  if (id == "bst-2") return bst2CodeLines;
  if (id == "bst-3") return bst3CodeLines;
  if (id == "bst-4") return bst4CodeLines;
  return bst1CodeLines;
}

List<DebugArrayStep> getBstSteps(String id) {
  if (id == "bst-2") return bst2Steps;
  if (id == "bst-3") return bst3Steps;
  if (id == "bst-4") return bst4Steps;
  return bst1Steps;
}

// ─── BST CANVAS WIDGETS ───────────────────────────────────────────────────────

Widget buildBstNodeCircle(int val, {required bool isHighlighted, required String badge}) {
  return Column(
    children: [
      AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: isHighlighted ? AppTheme.accentNeonCyan : AppTheme.surfaceDark,
          shape: BoxShape.circle,
          border: Border.all(color: isHighlighted ? Colors.white : const Color(0xFF06B6D4), width: isHighlighted ? 3 : 1.5),
          boxShadow: isHighlighted ? [BoxShadow(color: AppTheme.accentNeonCyan.withOpacity(0.6), blurRadius: 12)] : [],
        ),
        child: Center(
          child: Text(
            "$val",
            style: TextStyle(color: isHighlighted ? AppTheme.primaryDark : Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ),
      const SizedBox(height: 4),
      Text(badge, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: isHighlighted ? AppTheme.accentNeonCyan : AppTheme.textMuted)),
    ],
  );
}

Widget buildBstInsertCanvas(DebugArrayStep step, int currentStepIndex) {
  final activeVal = step.pointer1;
  final isInserted = currentStepIndex >= 6;

  return Column(
    children: [
      const Text("BST Insertion Step-by-Step Canvas (Target = 5)", style: TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 13)),
      const SizedBox(height: 12),
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF090D16),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.accentGreen, width: 2),
        ),
        child: Column(
          children: [
            buildBstNodeCircle(4, isHighlighted: activeVal == 4, badge: "ROOT (4)"),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildBstNodeCircle(2, isHighlighted: activeVal == 2, badge: "LEFT (2)"),
                buildBstNodeCircle(7, isHighlighted: activeVal == 7, badge: "RIGHT (7)"),
              ],
            ),
            const SizedBox(height: 12),
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isInserted ? AppTheme.accentGreen : (activeVal == 5 ? AppTheme.accentNeonCyan.withOpacity(0.2) : Colors.transparent),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isInserted ? Colors.white : (activeVal == 5 ? AppTheme.accentNeonCyan : AppTheme.textMuted.withOpacity(0.3)),
                  width: isInserted ? 2.5 : 1,
                ),
              ),
              child: Text(
                isInserted
                    ? "🎉 Newly Attached Left Child: TreeNode(5)"
                    : (activeVal == 5 ? "⚡ Reached nullptr spot under Node 7! Creating TreeNode(5)..." : "[ Empty nullptr spot under Node 7 ]"),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: isInserted ? AppTheme.primaryDark : (activeVal == 5 ? AppTheme.accentNeonCyan : AppTheme.textMuted),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget buildBstCanvas(DebugArrayStep step, String problemId) {
  int rootVal = 4;
  int leftVal = 2;
  int rightVal = 7;

  if (problemId == "bst-3") {
    rootVal = 2;
    leftVal = 1;
    rightVal = 3;
  } else if (problemId == "bst-4") {
    rootVal = 6;
    leftVal = 2;
    rightVal = 8;
  }

  return Column(
    children: [
      const Text("Binary Search Tree Hierarchy (Connected Node Canvas)", style: TextStyle(color: Color(0xFF06B6D4), fontWeight: FontWeight.bold, fontSize: 13)),
      const SizedBox(height: 14),
      Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: const Color(0xFF090D16),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF06B6D4), width: 2),
        ),
        child: Column(
          children: [
            buildBstNodeCircle(rootVal, isHighlighted: step.pointer1 == rootVal, badge: "ROOT"),
            const SizedBox(height: 4),
            SizedBox(
              width: 220,
              height: 38,
              child: CustomPaint(
                painter: _TreeBranchPainterLocal(color: AppTheme.accentNeonCyan),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildBstNodeCircle(leftVal, isHighlighted: step.pointer1 == leftVal, badge: "LEFT CHILD"),
                buildBstNodeCircle(rightVal, isHighlighted: step.pointer1 == rightVal, badge: "RIGHT CHILD"),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}

// Local painter to avoid circular imports
class _TreeBranchPainterLocal extends CustomPainter {
  final Color color;
  _TreeBranchPainterLocal({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    final startX = size.width / 2;
    canvas.drawLine(Offset(startX, 0.0), Offset(size.width * 0.22, size.height), paint);
    canvas.drawLine(Offset(startX, 0.0), Offset(size.width * 0.78, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
