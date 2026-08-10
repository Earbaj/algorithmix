import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:algorithmix/domain/models/dsa_data.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

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

class DsaProblemDetailScreen extends StatefulWidget {
  final DsaProblem problem;
  final bool initialLanguageIsEnglish;

  const DsaProblemDetailScreen({
    super.key,
    required this.problem,
    this.initialLanguageIsEnglish = true,
  });

  @override
  State<DsaProblemDetailScreen> createState() => _DsaProblemDetailScreenState();
}

class _DsaProblemDetailScreenState extends State<DsaProblemDetailScreen>
    with SingleTickerProviderStateMixin {
  late bool _isEnglish;
  late TabController _tabController;
  String _selectedCodeLang = "C++";

  // Step Visualizer State (Following Two Pointers Feature Architecture)
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  // ARRAYS CODE LINES & STEPS
  final List<String> _arr1CodeLines = [
    "pair<int, int> findMinMax(vector<int>& arr) {",
    "    int minVal = arr[0], maxVal = arr[0];",
    "    for (int i = 1; i < arr.size(); i++) {",
    "        if (arr[i] < minVal) minVal = arr[i];",
    "        if (arr[i] > maxVal) maxVal = arr[i];",
    "    }",
    "    return {minVal, maxVal};",
    "}",
  ];

  final List<DebugArrayStep> _arr1Steps = const [
    DebugArrayStep(
      activeLineIndex: 1,
      pointer1: 0,
      minVal: 15,
      maxVal: 15,
      array1D: [15, 42, 8, 99, 23],
      explanationEn: "Line 2: Initialize minVal = arr[0] (15) and maxVal = arr[0] (15).",
      explanationBn: "লাইন ২: minVal = 15 এবং maxVal = 15 সেট করে শুরু করা হলো।",
    ),
    DebugArrayStep(
      activeLineIndex: 2,
      pointer1: 1,
      minVal: 15,
      maxVal: 15,
      array1D: [15, 42, 8, 99, 23],
      explanationEn: "Line 3: Loop iteration i = 1 (val 42). Condition 1 < 5 is TRUE.",
      explanationBn: "লাইন ৩: লুপ i = 1 (মান 42)। শর্ত 1 < 5 সত্য।",
    ),
    DebugArrayStep(
      activeLineIndex: 4,
      pointer1: 1,
      minVal: 15,
      maxVal: 42,
      array1D: [15, 42, 8, 99, 23],
      explanationEn: "Line 5: Check 42 > 15 (TRUE) -> Update maxVal = 42.",
      explanationBn: "লাইন ৫: শর্ত 42 > 15 সত্য! maxVal আপডেট হয়ে 42 হলো।",
    ),
    DebugArrayStep(
      activeLineIndex: 3,
      pointer1: 2,
      minVal: 8,
      maxVal: 42,
      array1D: [15, 42, 8, 99, 23],
      explanationEn: "Line 4: Check 8 < 15 (TRUE) -> Update minVal = 8.",
      explanationBn: "লাইন ৪: শর্ত 8 < 15 সত্য! minVal আপডেট হয়ে 8 হলো।",
    ),
    DebugArrayStep(
      activeLineIndex: 4,
      pointer1: 3,
      minVal: 8,
      maxVal: 99,
      array1D: [15, 42, 8, 99, 23],
      explanationEn: "Line 5: Check 99 > 42 (TRUE) -> Update maxVal = 99.",
      explanationBn: "লাইন ৫: শর্ত 99 > 42 সত্য! maxVal আপডেট হয়ে 99 হলো।",
    ),
    DebugArrayStep(
      activeLineIndex: 3,
      pointer1: 4,
      minVal: 8,
      maxVal: 99,
      array1D: [15, 42, 8, 99, 23],
      explanationEn: "Line 4: Check arr[4] = 23. 23 < 8 (FALSE) & 23 > 99 (FALSE). Bounds unchanged.",
      explanationBn: "লাইন ৪: arr[4] = 23 চেক করা হলো। মান অপরিবর্তিত রইল।",
    ),
    DebugArrayStep(
      activeLineIndex: 6,
      pointer1: 4,
      minVal: 8,
      maxVal: 99,
      array1D: [15, 42, 8, 99, 23],
      explanationEn: "🎉 Line 7: Traversal complete! Final Min = 8, Max = 99.",
      explanationBn: "🎉 লাইন ৭: ট্রাভার্সাল সম্পন্ন! চূড়ান্ত Min = 8, Max = 99।",
    ),
  ];

  final List<String> _arr2CodeLines = [
    "void reverseArray(vector<int>& arr) {",
    "    int left = 0, right = arr.size() - 1;",
    "    while (left < right) {",
    "        swap(arr[left], arr[right]);",
    "        left++; right--;",
    "    }",
    "}",
  ];

  final List<DebugArrayStep> _arr2Steps = const [
    DebugArrayStep(
      activeLineIndex: 1,
      pointer1: 0,
      pointer2: 4,
      array1D: [1, 2, 3, 4, 5],
      explanationEn: "Line 2: Set left = 0 (val 1) and right = 4 (val 5).",
      explanationBn: "লাইন ২: left = 0 (মান 1) এবং right = 4 (মান 5) সেট করা হলো।",
    ),
    DebugArrayStep(
      activeLineIndex: 2,
      pointer1: 0,
      pointer2: 4,
      array1D: [1, 2, 3, 4, 5],
      explanationEn: "Line 3: Check while (left < right) -> (0 < 4) is TRUE. Enter loop.",
      explanationBn: "লাইন ৩: লুপ শর্ত (0 < 4) সত্য! লুপে প্রবেশ করুন।",
    ),
    DebugArrayStep(
      activeLineIndex: 3,
      pointer1: 0,
      pointer2: 4,
      array1D: [5, 2, 3, 4, 1],
      explanationEn: "Line 4: Swapped arr[0] (1) with arr[4] (5) in-place!",
      explanationBn: "লাইন ৪: arr[0] (1) এবং arr[4] (5) মেমোরিতে সোয়াপ করা হলো!",
    ),
    DebugArrayStep(
      activeLineIndex: 4,
      pointer1: 1,
      pointer2: 3,
      array1D: [5, 2, 3, 4, 1],
      explanationEn: "Line 5: Advance left++ (1) and decrement right-- (3).",
      explanationBn: "লাইন ৫: পয়েন্টার কমানো/বাড়ানো: left = 1, right = 3।",
    ),
    DebugArrayStep(
      activeLineIndex: 3,
      pointer1: 1,
      pointer2: 3,
      array1D: [5, 4, 3, 2, 1],
      explanationEn: "Line 4: Swapped arr[1] (2) with arr[3] (4) in-place!",
      explanationBn: "লাইন ৪: arr[1] (2) এবং arr[3] (4) মেমোরিতে সোয়াপ করা হলো!",
    ),
    DebugArrayStep(
      activeLineIndex: 4,
      pointer1: 2,
      pointer2: 2,
      array1D: [5, 4, 3, 2, 1],
      explanationEn: "Line 5: Advance left++ (2) and right-- (2).",
      explanationBn: "লাইন ৫: পয়েন্টার কমানো/বাড়ানো: left = 2, right = 2।",
    ),
    DebugArrayStep(
      activeLineIndex: 2,
      pointer1: 2,
      pointer2: 2,
      array1D: [5, 4, 3, 2, 1],
      explanationEn: "🎉 Line 3: Check while (left < right) -> (2 < 2) is FALSE. Reversal Complete!",
      explanationBn: "🎉 লাইন ৩: (2 < 2) মিথ্যা! পয়েন্টার দুটো মাঝখানে মিলিত হয়ে সম্পূর্ণ রিভার্সড।",
    ),
  ];

  final List<String> _arr3CodeLines = [
    "vector<vector<int>> transposeMatrix(vector<vector<int>>& matrix) {",
    "    int R = matrix.size(), C = matrix[0].size();",
    "    vector<vector<int>> res(C, vector<int>(R));",
    "    for (int r = 0; r < R; r++) {",
    "        for (int c = 0; c < C; c++) {",
    "            res[c][r] = matrix[r][c];",
    "        }",
    "    }",
    "    return res;",
    "}",
  ];

  final List<DebugArrayStep> _arr3Steps = const [
    DebugArrayStep(
      activeLineIndex: 2,
      pointer1: 0,
      pointer2: 0,
      matrix2D: [[0, 0], [0, 0], [0, 0]],
      explanationEn: "Line 3: Initialize result matrix of size 3x2 with zeroes.",
      explanationBn: "লাইন ৩: ৩x২ সাইজের রেজাল্ট ম্যাট্রিক্স তৈরি।",
    ),
    DebugArrayStep(
      activeLineIndex: 5,
      pointer1: 0,
      pointer2: 0,
      matrix2D: [[1, 0], [0, 0], [0, 0]],
      explanationEn: "Line 6: Transposed matrix[0][0] = 1 -> result[0][0] = 1",
      explanationBn: "লাইন ৬: matrix[0][0] = 1 -> result[0][0] = 1",
    ),
    DebugArrayStep(
      activeLineIndex: 5,
      pointer1: 0,
      pointer2: 1,
      matrix2D: [[1, 0], [2, 0], [0, 0]],
      explanationEn: "Line 6: Transposed matrix[0][1] = 2 -> result[1][0] = 2",
      explanationBn: "লাইন ৬: matrix[0][1] = 2 -> result[1][0] = 2",
    ),
    DebugArrayStep(
      activeLineIndex: 5,
      pointer1: 0,
      pointer2: 2,
      matrix2D: [[1, 0], [2, 0], [3, 0]],
      explanationEn: "Line 6: Transposed matrix[0][2] = 3 -> result[2][0] = 3",
      explanationBn: "লাইন ৬: matrix[0][2] = 3 -> result[2][0] = 3",
    ),
    DebugArrayStep(
      activeLineIndex: 5,
      pointer1: 1,
      pointer2: 0,
      matrix2D: [[1, 4], [2, 0], [3, 0]],
      explanationEn: "Line 6: Transposed matrix[1][0] = 4 -> result[0][1] = 4",
      explanationBn: "লাইন ৬: matrix[1][0] = 4 -> result[0][1] = 4",
    ),
    DebugArrayStep(
      activeLineIndex: 5,
      pointer1: 1,
      pointer2: 1,
      matrix2D: [[1, 4], [2, 5], [3, 0]],
      explanationEn: "Line 6: Transposed matrix[1][1] = 5 -> result[1][1] = 5",
      explanationBn: "লাইন ৬: matrix[1][1] = 5 -> result[1][1] = 5",
    ),
    DebugArrayStep(
      activeLineIndex: 5,
      pointer1: 1,
      pointer2: 2,
      matrix2D: [[1, 4], [2, 5], [3, 6]],
      explanationEn: "Line 6: Transposed matrix[1][2] = 6 -> result[2][1] = 6",
      explanationBn: "লাইন ৬: matrix[1][2] = 6 -> result[2][1] = 6",
    ),
    DebugArrayStep(
      activeLineIndex: 8,
      pointer1: 1,
      pointer2: 2,
      matrix2D: [[1, 4], [2, 5], [3, 6]],
      explanationEn: "🎉 Line 9: 2D Matrix Transpose Complete! Return result matrix.",
      explanationBn: "🎉 লাইন ৯: ২D ম্যাট্রিক্স ট্রান্সপোজ সম্পন্ন! রেজাল্ট ম্যাট্রিক্স রিটার্ন করা হলো।",
    ),
  ];

  final List<String> _arr4CodeLines = [
    "int tensorSum(vector<vector<vector<int>>>& tensor) {",
    "    int total = 0;",
    "    for (int d = 0; d < tensor.size(); d++) {",
    "        for (int r = 0; r < tensor[0].size(); r++) {",
    "            for (int c = 0; c < tensor[0][0].size(); c++) {",
    "                total += tensor[d][r][c];",
    "            }",
    "        }",
    "    }",
    "    return total;",
    "}",
  ];

  final List<DebugArrayStep> _arr4Steps = const [
    DebugArrayStep(
      activeLineIndex: 1,
      pointer1: 0,
      minVal: 0,
      explanationEn: "Line 2: Initialize total sum = 0.",
      explanationBn: "লাইন ২: মোট সমষ্টি total = 0 সূচনা করা হলো।",
    ),
    DebugArrayStep(
      activeLineIndex: 5,
      pointer1: 0,
      minVal: 10,
      explanationEn: "Line 6: Depth Layer 0: Summing elements [[1,2],[3,4]] -> total = 10.",
      explanationBn: "লাইন ৬: ডেপথ লেয়ার 0 উপাদান যোগ -> সমষ্টি = 10।",
    ),
    DebugArrayStep(
      activeLineIndex: 5,
      pointer1: 1,
      minVal: 36,
      explanationEn: "Line 6: Depth Layer 1: Summing elements [[5,6],[7,8]] -> total = 10 + 26 = 36.",
      explanationBn: "লাইন ৬: ডেপথ লেয়ার 1 উপাদান যোগ -> মোট সমষ্টি = 36।",
    ),
    DebugArrayStep(
      activeLineIndex: 9,
      pointer1: 1,
      minVal: 36,
      explanationEn: "🎉 Line 10: 3D Tensor Volume Sum Complete! Return total = 36.",
      explanationBn: "🎉 লাইন ১০: ৩D টেনসর যোগফল সম্পন্ন! মোট সমষ্টি = 36।",
    ),
  ];

  // LINKED LIST CODE LINES & STEPS
  final List<String> _ll1CodeLines = [
    "ListNode* reverseList(ListNode* head) {",
    "    ListNode *prev = nullptr, *curr = head;",
    "    while (curr != nullptr) {",
    "        ListNode* nextTemp = curr->next;",
    "        curr->next = prev;",
    "        prev = curr;",
    "        curr = nextTemp;",
    "    }",
    "    return prev;",
    "}",
  ];

  final List<DebugArrayStep> _ll1Steps = const [
    DebugArrayStep(
      activeLineIndex: 1,
      pointer1: 0,
      pointer2: -1,
      array1D: [1, 2, 3, 4, 5],
      explanationEn: "Line 2: Set prev = null, curr = head (node val 1).",
      explanationBn: "লাইন ২: prev = null এবং curr = head (নোড মান 1) সূচনা।",
    ),
    DebugArrayStep(
      activeLineIndex: 2,
      pointer1: 0,
      pointer2: -1,
      array1D: [1, 2, 3, 4, 5],
      explanationEn: "Line 3: Check while (curr != null) -> (curr val 1) is TRUE. Enter loop.",
      explanationBn: "লাইন ৩: শর্ত চেক (curr != null) সত্য! লুপে প্রবেশ করুন।",
    ),
    DebugArrayStep(
      activeLineIndex: 3,
      pointer1: 0,
      pointer2: -1,
      array1D: [1, 2, 3, 4, 5],
      explanationEn: "Line 4: Backup next reference -> nextTemp = node (val 2).",
      explanationBn: "লাইন ৪: পরবর্তী নোডের ব্যাকআপ: nextTemp = node 2।",
    ),
    DebugArrayStep(
      activeLineIndex: 4,
      pointer1: 0,
      pointer2: -1,
      array1D: [1, 2, 3, 4, 5],
      explanationEn: "Line 5: Flip link! Node 1 next now points to prev (null).",
      explanationBn: "লাইন ৫: লিঙ্ক উল্টানো! নোড 1 এর পয়েন্টার এখন prev (null) কে দেখাচ্ছে।",
    ),
    DebugArrayStep(
      activeLineIndex: 5,
      pointer1: 1,
      pointer2: 0,
      array1D: [1, 2, 3, 4, 5],
      explanationEn: "Line 6: Advance pointers -> prev = node 1, curr = node 2.",
      explanationBn: "লাইন ৬: পয়েন্টার আগানো: prev = node 1, curr = node 2।",
    ),
    DebugArrayStep(
      activeLineIndex: 4,
      pointer1: 1,
      pointer2: 0,
      array1D: [2, 1, 3, 4, 5],
      explanationEn: "Line 5: Flip link! Node 2 next now points back to Node 1.",
      explanationBn: "লাইন ৫: লিঙ্ক উল্টানো! নোড 2 এখন নোড 1 কে পয়েন্ট করছে।",
    ),
    DebugArrayStep(
      activeLineIndex: 8,
      pointer1: 4,
      pointer2: 4,
      array1D: [5, 4, 3, 2, 1],
      explanationEn: "🎉 Line 9: List reversed! Return new head prev (val 5).",
      explanationBn: "🎉 লাইন ৯: লিঙ্কড লিস্ট উল্টানো সম্পন্ন! নতুন হেড prev (মান 5)।",
    ),
  ];

  final List<String> _ll2CodeLines = [
    "ListNode* middleNode(ListNode* head) {",
    "    ListNode *slow = head, *fast = head;",
    "    while (fast != nullptr && fast->next != nullptr) {",
    "        slow = slow->next;",
    "        fast = fast->next->next;",
    "    }",
    "    return slow;",
    "}",
  ];

  final List<DebugArrayStep> _ll2Steps = const [
    DebugArrayStep(
      activeLineIndex: 1,
      pointer1: 0,
      pointer2: 0,
      array1D: [1, 2, 3, 4, 5],
      explanationEn: "Line 2: Set slow = head (val 1) and fast = head (val 1).",
      explanationBn: "লাইন ২: slow = 1 এবং fast = 1 সেট করে সূচনা।",
    ),
    DebugArrayStep(
      activeLineIndex: 2,
      pointer1: 0,
      pointer2: 0,
      array1D: [1, 2, 3, 4, 5],
      explanationEn: "Line 3: Check while (fast != null) -> (fast val 1) is TRUE.",
      explanationBn: "লাইন ৩: শর্ত চেক (fast != null) সত্য!",
    ),
    DebugArrayStep(
      activeLineIndex: 3,
      pointer1: 1,
      pointer2: 0,
      array1D: [1, 2, 3, 4, 5],
      explanationEn: "Line 4: Advance slow 1 step -> slow = node 2 (val 2).",
      explanationBn: "লাইন ৪: slow ১ ধাপ এগুলো -> slow = 2।",
    ),
    DebugArrayStep(
      activeLineIndex: 4,
      pointer1: 1,
      pointer2: 2,
      array1D: [1, 2, 3, 4, 5],
      explanationEn: "Line 5: Advance fast 2 steps -> fast = node 3 (val 3).",
      explanationBn: "লাইন ৫: fast ২ ধাপ এগুলো -> fast = 3।",
    ),
    DebugArrayStep(
      activeLineIndex: 3,
      pointer1: 2,
      pointer2: 4,
      array1D: [1, 2, 3, 4, 5],
      explanationEn: "Line 4: Advance slow 1 step -> slow = node 3 (val 3).",
      explanationBn: "লাইন ৪: slow ১ ধাপ এগুলো -> slow = 3।",
    ),
    DebugArrayStep(
      activeLineIndex: 6,
      pointer1: 2,
      pointer2: 4,
      array1D: [1, 2, 3, 4, 5],
      explanationEn: "🎉 Line 7: Fast reached tail! Middle Node = slow (val 3).",
      explanationBn: "🎉 লাইন ৭: fast শেষ নোডে পৌঁছেছে! মিডল নোড = 3 (slow)।",
    ),
  ];

  final List<String> _ll3CodeLines = [
    "Node* reverseDLL(Node* head) {",
    "    Node *temp = nullptr, *curr = head;",
    "    while (curr != nullptr) {",
    "        temp = curr->prev;",
    "        curr->prev = curr->next;",
    "        curr->next = temp;",
    "        curr = curr->prev;",
    "    }",
    "    return temp ? temp->prev : head;",
    "}",
  ];

  final List<DebugArrayStep> _ll3Steps = const [
    DebugArrayStep(
      activeLineIndex: 1,
      pointer1: 0,
      array1D: [1, 2, 3, 4],
      explanationEn: "Line 2: Set temp = null, curr = head (Node 1).",
      explanationBn: "লাইন ২: temp = null এবং curr = head (নোড 1)।",
    ),
    DebugArrayStep(
      activeLineIndex: 4,
      pointer1: 0,
      array1D: [1, 2, 3, 4],
      explanationEn: "Line 5: Swapped prev and next pointers of Node 1.",
      explanationBn: "লাইন ৫: নোড 1 এর prev ও next পয়েন্টার অদলবদল করা হলো।",
    ),
    DebugArrayStep(
      activeLineIndex: 6,
      pointer1: 1,
      array1D: [1, 2, 3, 4],
      explanationEn: "Line 7: Move to next node (Node 2).",
      explanationBn: "লাইন ৭: পরবর্তী নোড 2 এ আগানো হলো।",
    ),
    DebugArrayStep(
      activeLineIndex: 4,
      pointer1: 1,
      array1D: [1, 2, 3, 4],
      explanationEn: "Line 5: Swapped prev and next pointers of Node 2.",
      explanationBn: "লাইন ৫: নোড 2 এর prev ও next পয়েন্টার অদলবদল করা হলো।",
    ),
    DebugArrayStep(
      activeLineIndex: 8,
      pointer1: 3,
      array1D: [4, 3, 2, 1],
      explanationEn: "🎉 Line 9: Doubly Linked List Reversal Complete! Return new head (val 4).",
      explanationBn: "🎉 লাইন ৯: Doubly Linked List উল্টানো সম্পন্ন! নতুন হেড 4।",
    ),
  ];

  final List<String> _ll4CodeLines = [
    "bool hasCycle(ListNode *head) {",
    "    ListNode *slow = head, *fast = head;",
    "    while (fast != nullptr && fast->next != nullptr) {",
    "        slow = slow->next;",
    "        fast = fast->next->next;",
    "        if (slow == fast) return true;",
    "    }",
    "    return false;",
    "}",
  ];

  final List<DebugArrayStep> _ll4Steps = const [
    DebugArrayStep(
      activeLineIndex: 1,
      pointer1: 0,
      pointer2: 0,
      array1D: [3, 2, 0, -4],
      explanationEn: "Line 2: Set slow = head (3), fast = head (3). Cycle exists: -4 -> 2.",
      explanationBn: "লাইন ২: slow = 3 এবং fast = 3 সেট। লিঙ্কড লিস্টে ৩->২->০->-৪->২ চক্র রয়েছে।",
    ),
    DebugArrayStep(
      activeLineIndex: 3,
      pointer1: 1,
      pointer2: 2,
      array1D: [3, 2, 0, -4],
      explanationEn: "Line 4: Advance slow = 2, fast = 0.",
      explanationBn: "লাইন ৪: slow = 2, fast = 0 এ এগুলো।",
    ),
    DebugArrayStep(
      activeLineIndex: 4,
      pointer1: 2,
      pointer2: 1,
      array1D: [3, 2, 0, -4],
      explanationEn: "Line 5: Advance slow = 0, fast = 2 (entering cycle).",
      explanationBn: "লাইন ৫: slow = 0, fast = 2 (চক্রের ভেতর)।",
    ),
    DebugArrayStep(
      activeLineIndex: 5,
      pointer1: 1,
      pointer2: 1,
      array1D: [3, 2, 0, -4],
      explanationEn: "🎉 Line 6: CYCLE DETECTED! slow == fast at Node 2! Return TRUE!",
      explanationBn: "🎉 লাইন ৬: চক্র শনাক্ত করা হয়েছে! Node 2 এ slow == fast! Return TRUE!",
    ),
  ];

  // STACK (LIFO) CODE LINES & STEPS
  final List<String> _st1CodeLines = [
    "bool isValid(string s) {",
    "    stack<char> st;",
    "    for (char c : s) {",
    "        if (c == '(' || c == '[' || c == '{') st.push(c);",
    "        else {",
    "            if (st.empty()) return false;",
    "            char top = st.top(); st.pop();",
    "            if (mismatch) return false;",
    "        }",
    "    }",
    "    return st.empty();",
    "}",
  ];

  final List<DebugArrayStep> _st1Steps = const [
    DebugArrayStep(
      activeLineIndex: 1,
      stackItems: [],
      explanationEn: "Line 2: Initialize empty char stack st = []. Input string s = '({[]})'.",
      explanationBn: "লাইন ২: খালি স্ট্যাক st = [] ডিক্লেয়ার। ইনপুট স্ট্রিং s = '({[]})'।",
    ),
    DebugArrayStep(
      activeLineIndex: 3,
      stackItems: ["("],
      explanationEn: "Line 4: Encountered opening bracket '('. Push '(' onto stack. Stack = ['('].",
      explanationBn: "লাইন ৪: ওপেনিং ব্র্যাকেট '(' পাওয়া গেল। স্ট্যাকে পুশ করুন। স্ট্যাক = ['(']।",
    ),
    DebugArrayStep(
      activeLineIndex: 3,
      stackItems: ["(", "{"],
      explanationEn: "Line 4: Encountered opening bracket '{'. Push '{' onto stack. Stack = ['(', '{'].",
      explanationBn: "লাইন ৪: ওপেনিং ব্র্যাকেট '{' পাওয়া গেল। স্ট্যাকে পুশ করুন। স্ট্যাক = ['(', '{']।",
    ),
    DebugArrayStep(
      activeLineIndex: 3,
      stackItems: ["(", "{", "["],
      explanationEn: "Line 4: Encountered opening bracket '['. Push '[' onto stack. Stack = ['(', '{', '['].",
      explanationBn: "লাইন ৪: ওপেনিং ব্র্যাকেট '[' পাওয়া গেল। স্ট্যাকে পুশ করুন। স্ট্যাক = ['(', '{', '[']।",
    ),
    DebugArrayStep(
      activeLineIndex: 6,
      stackItems: ["(", "{\""],
      explanationEn: "Line 7: Encountered closing bracket ']'. Pop top '[' and verify match. Match OK!",
      explanationBn: "লাইন ৭: ক্লোজিং ব্র্যাকেট ']' পাওয়া গেল। টপ '[' পপ করে ম্যাচ ভেরিফাই করা হলো।",
    ),
    DebugArrayStep(
      activeLineIndex: 6,
      stackItems: ["("],
      explanationEn: "Line 7: Encountered closing bracket '}'. Pop top '{' and verify match. Match OK!",
      explanationBn: "লাইন ৭: ক্লোজিং ব্র্যাকেট '}' পাওয়া গেল। টপ '{' পপ করে ম্যাচ ভেরিফাই করা হলো।",
    ),
    DebugArrayStep(
      activeLineIndex: 10,
      stackItems: [],
      explanationEn: "🎉 Line 11: All brackets matched! Stack is empty. Return TRUE!",
      explanationBn: "🎉 লাইন ১১: সমস্ত ব্র্যাকেট সঠিকভাবে ম্যাচ করেছে! স্ট্যাক খালি। Return TRUE!",
    ),
  ];

  final List<String> _st2CodeLines = [
    "class MinStack {",
    "    stack<int> st, minSt;",
    "public:",
    "    void push(int val) {",
    "        st.push(val);",
    "        int minVal = minSt.empty() ? val : min(val, minSt.top());",
    "        minSt.push(minVal);",
    "    }",
    "    int getMin() { return minSt.top(); }",
    "};",
  ];

  final List<DebugArrayStep> _st2Steps = const [
    DebugArrayStep(
      activeLineIndex: 1,
      stackItems: [],
      minVal: 0,
      explanationEn: "Line 2: Initialize main stack `st` and auxiliary `minSt` for O(1) min queries.",
      explanationBn: "লাইন ২: মূল স্ট্যাক `st` এবং O(1) মিনিমাম কুয়েরির জন্য auxiliary `minSt` ডিক্লেয়ার।",
    ),
    DebugArrayStep(
      activeLineIndex: 4,
      stackItems: ["-2"],
      minVal: -2,
      explanationEn: "Line 5: Push (-2) -> st = [-2], minSt = [-2]. Minimum = -2.",
      explanationBn: "লাইন ৫: পুশ (-2) -> st = [-2], minSt = [-2]। মিনিমাম = -2।",
    ),
    DebugArrayStep(
      activeLineIndex: 4,
      stackItems: ["-2", "0"],
      minVal: -2,
      explanationEn: "Line 5: Push (0) -> st = [-2, 0], minSt = [-2, -2]. Minimum = -2.",
      explanationBn: "লাইন ৫: পুশ (0) -> st = [-2, 0], minSt = [-2, -2]। মিনিমাম = -2।",
    ),
    DebugArrayStep(
      activeLineIndex: 6,
      stackItems: ["-2", "0", "-3"],
      minVal: -3,
      explanationEn: "Line 7: Push (-3) -> min(-3, -2) = -3. st = [-2, 0, -3], minSt = [-2, -2, -3]. Minimum = -3.",
      explanationBn: "লাইন ৭: পুশ (-3) -> মিনিমাম আপডেট হয়ে -3 হলো। minSt = [-2, -2, -3]।",
    ),
    DebugArrayStep(
      activeLineIndex: 8,
      stackItems: ["-2", "0", "-3"],
      minVal: -3,
      explanationEn: "🎉 Line 9: Call getMin() -> Query minSt.top() = -3 in O(1) constant time!",
      explanationBn: "🎉 লাইন ৯: getMin() কল -> O(1) টাইমে minSt.top() = -3 রিটার্ন!",
    ),
  ];

  final List<String> _st3CodeLines = [
    "int evalRPN(vector<string>& tokens) {",
    "    stack<int> st;",
    "    for (string& t : tokens) {",
    "        if (isOperator(t)) {",
    "            int b = st.top(); st.pop();",
    "            int a = st.top(); st.pop();",
    "            st.push(eval(a, b, t));",
    "        } else st.push(stoi(t));",
    "    }",
    "    return st.top();",
    "}",
  ];

  final List<DebugArrayStep> _st3Steps = const [
    DebugArrayStep(
      activeLineIndex: 1,
      stackItems: [],
      explanationEn: "Line 2: Evaluate Postfix RPN = ['2', '1', '+', '3', '*']. Initialize st = [].",
      explanationBn: "লাইন ২: পোস্টফিক্স RPN = ['2', '1', '+', '3', '*'] মূল্যায়ন শুরু।",
    ),
    DebugArrayStep(
      activeLineIndex: 7,
      stackItems: ["2", "1"],
      explanationEn: "Line 8: Push operands 2 and 1 onto stack. Stack = [2, 1].",
      explanationBn: "লাইন ৮: সংখ্যা ২ এবং ১ স্ট্যাকে পুশ করা হলো। স্ট্যাক = [2, 1]।",
    ),
    DebugArrayStep(
      activeLineIndex: 6,
      stackItems: ["3"],
      explanationEn: "Line 7: Operator '+' -> Pop 1 and 2. Evaluate (2 + 1 = 3). Push 3. Stack = [3].",
      explanationBn: "লাইন ৭: '+' পেয়ে পপ (1, 2)। হিসাব (2 + 1 = 3)। পুশ 3। স্ট্যাক = [3]।",
    ),
    DebugArrayStep(
      activeLineIndex: 7,
      stackItems: ["3", "3"],
      explanationEn: "Line 8: Push operand 3 onto stack. Stack = [3, 3].",
      explanationBn: "লাইন ৮: সংখ্যা ৩ স্ট্যাকে পুশ করা হলো। স্ট্যাক = [3, 3]।",
    ),
    DebugArrayStep(
      activeLineIndex: 9,
      stackItems: ["9"],
      explanationEn: "🎉 Line 10: Operator '*' -> Pop 3 and 3. Evaluate (3 * 3 = 9). Final Result = 9!",
      explanationBn: "🎉 লাইন ১০: '*' পেয়ে পপ (3, 3)। হিসাব (3 * 3 = 9)। চূড়ান্ত ফলাফল = 9!",
    ),
  ];

  final List<String> _st4CodeLines = [
    "vector<int> nextGreaterElement(vector<int>& arr) {",
    "    int n = arr.size();",
    "    vector<int> res(n, -1); stack<int> st;",
    "    for (int i = n - 1; i >= 0; i--) {",
    "        while (!st.empty() && st.top() <= arr[i]) st.pop();",
    "        if (!st.empty()) res[i] = st.top();",
    "        st.push(arr[i]);",
    "    }",
    "    return res;",
    "}",
  ];

  final List<DebugArrayStep> _st4Steps = const [
    DebugArrayStep(
      activeLineIndex: 2,
      stackItems: [],
      array1D: [4, 5, 2, 25],
      explanationEn: "Line 3: Array arr = [4, 5, 2, 25]. Traverse right-to-left using Monotonic Stack.",
      explanationBn: "লাইন ৩: অ্যারে arr = [4, 5, 2, 25]। মনোটোনিক স্ট্যাক দিয়ে ডান থেকে বামে ট্রাভার্স।",
    ),
    DebugArrayStep(
      activeLineIndex: 6,
      stackItems: ["25"],
      array1D: [4, 5, 2, 25],
      minVal: -1,
      explanationEn: "Line 7: Index 3 (val 25): Stack empty -> Next Greater = -1. Push 25.",
      explanationBn: "লাইন ৭: ইনডেক্স 3 (মান 25): স্ট্যাক খালি -> Next Greater = -1। পুশ 25।",
    ),
    DebugArrayStep(
      activeLineIndex: 5,
      stackItems: ["25", "2"],
      array1D: [4, 5, 2, 25],
      minVal: 25,
      explanationEn: "Line 6: Index 2 (val 2): Top (25) > 2 -> Next Greater = 25. Push 2.",
      explanationBn: "লাইন ৬: ইনডেক্স 2 (মান 2): টপ (25) > 2 -> Next Greater = 25। পুশ 2।",
    ),
    DebugArrayStep(
      activeLineIndex: 5,
      stackItems: ["25", "5"],
      array1D: [4, 5, 2, 25],
      minVal: 25,
      explanationEn: "Line 6: Index 1 (val 5): Pop 2 (5 >= 2). Top (25) > 5 -> Next Greater = 25. Push 5.",
      explanationBn: "লাইন ৬: ইনডেক্স 1 (মান 5): পপ 2 (5 >= 2)। টপ (25) > 5 -> Next Greater = 25। পুশ 5।",
    ),
    DebugArrayStep(
      activeLineIndex: 8,
      stackItems: ["25", "5", "4"],
      array1D: [4, 5, 2, 25],
      minVal: 5,
      explanationEn: "🎉 Line 9: Index 0 (val 4): Top (5) > 4 -> Next Greater = 5. Result = [5, 25, 25, -1]!",
      explanationBn: "🎉 লাইন ৯: ইনডেক্স 0 (মান 4): টপ (5) > 4 -> Next Greater = 5। রেজাল্ট = [5, 25, 25, -1]!",
    ),
  ];

  // QUEUE (FIFO) CODE LINES & STEPS
  final List<String> _q1CodeLines = [
    "class MyQueue {",
    "    stack<int> stIn, stOut;",
    "    void transfer() {",
    "        if (stOut.empty()) {",
    "            while (!stIn.empty()) {",
    "                stOut.push(stIn.top()); stIn.pop();",
    "            }",
    "        }",
    "    }",
    "public:",
    "    void push(int x) { stIn.push(x); }",
    "    int pop() { transfer(); int v = stOut.top(); stOut.pop(); return v; }",
    "    int peek() { transfer(); return stOut.top(); }",
    "};",
  ];

  final List<DebugArrayStep> _q1Steps = const [
    DebugArrayStep(
      activeLineIndex: 10,
      queueItems: ["1"],
      explanationEn: "Line 11: Push 1 to stIn. Queue Pipeline = [1].",
      explanationBn: "লাইন ১১: stIn এ 1 পুশ করা হলো। কিউ পাইপলাইন = [1]।",
    ),
    DebugArrayStep(
      activeLineIndex: 10,
      queueItems: ["1", "2"],
      explanationEn: "Line 11: Push 2 to stIn. Queue Pipeline = [1, 2].",
      explanationBn: "লাইন ১১: stIn এ 2 পুশ করা হলো। কিউ পাইপলাইন = [1, 2]।",
    ),
    DebugArrayStep(
      activeLineIndex: 4,
      queueItems: ["1", "2"],
      explanationEn: "Line 5: Call peek() -> Transfer elements to stOut. Front element = 1.",
      explanationBn: "লাইন ৫: peek() কল -> stOut এ স্থানান্তরের মাধ্যমে ফ্রন্ট উপাদান = 1।",
    ),
    DebugArrayStep(
      activeLineIndex: 11,
      queueItems: ["2"],
      explanationEn: "🎉 Line 12: Call pop() -> Dequeued Front element = 1. Remaining Queue = [2].",
      explanationBn: "🎉 লাইন ১২: pop() কল -> ডিকিউড ফ্রন্ট উপাদান = 1। অবশিষ্ট কিউ = [2]।",
    ),
  ];

  final List<String> _q2CodeLines = [
    "class MyCircularQueue {",
    "    vector<int> arr; int front = 0, rear = -1, size = 0, cap;",
    "public:",
    "    bool enQueue(int val) {",
    "        if (isFull()) return false;",
    "        rear = (rear + 1) % cap;",
    "        arr[rear] = val; size++; return true;",
    "    }",
    "    bool deQueue() {",
    "        if (isEmpty()) return false;",
    "        front = (front + 1) % cap; size--; return true;",
    "    }",
    "};",
  ];

  final List<DebugArrayStep> _q2Steps = const [
    DebugArrayStep(
      activeLineIndex: 5,
      queueItems: ["1"],
      explanationEn: "Line 6: enQueue(1): rear = (0) % 3 = 0. Queue Ring = [1].",
      explanationBn: "লাইন ৬: enQueue(1): rear = 0। সার্কুলার রিং = [1]।",
    ),
    DebugArrayStep(
      activeLineIndex: 5,
      queueItems: ["1", "2"],
      explanationEn: "Line 6: enQueue(2): rear = (1) % 3 = 1. Queue Ring = [1, 2].",
      explanationBn: "লাইন ৬: enQueue(2): rear = 1। সার্কুলার রিং = [1, 2]।",
    ),
    DebugArrayStep(
      activeLineIndex: 5,
      queueItems: ["1", "2", "3"],
      explanationEn: "Line 6: enQueue(3): rear = (2) % 3 = 2. Queue Ring Full = [1, 2, 3].",
      explanationBn: "লাইন ৬: enQueue(3): rear = 2। সার্কুলার কিউ ফুল = [1, 2, 3]।",
    ),
    DebugArrayStep(
      activeLineIndex: 9,
      queueItems: ["2", "3"],
      explanationEn: "Line 10: deQueue(): front = (0 + 1) % 3 = 1. Freed Slot 0!",
      explanationBn: "লাইন ১০: deQueue(): front = 1। স্লট 0 খালি করা হলো!",
    ),
    DebugArrayStep(
      activeLineIndex: 5,
      queueItems: ["2", "3", "4"],
      explanationEn: "🎉 Line 6: enQueue(4): rear = (2 + 1) % 3 = 0 (Wrapped around)! Ring = [2, 3, 4]!",
      explanationBn: "🎉 লাইন ৬: enQueue(4): rear = 0 (মডিউলো র্যাপ)। সার্কুলার রিং = [2, 3, 4]!",
    ),
  ];

  final List<String> _q3CodeLines = [
    "string firstNonRepeating(string s) {",
    "    unordered_map<char, int> freq; queue<char> q; string res = \"\";",
    "    for (char c : s) {",
    "        freq[c]++; q.push(c);",
    "        while (!q.empty() && freq[q.front()] > 1) q.pop();",
    "        res += q.empty() ? '#' : q.front();",
    "    }",
    "    return res;",
    "}",
  ];

  final List<DebugArrayStep> _q3Steps = const [
    DebugArrayStep(
      activeLineIndex: 3,
      queueItems: ["a"],
      explanationEn: "Line 4: Process char 'a': freq['a']=1. Queue = ['a']. First Non-Repeating = 'a'.",
      explanationBn: "লাইন ৪: ক্যারেক্টার 'a': freq=1। কিউ = ['a']। প্রথম অনাবৃত্ত ক্যারেক্টার = 'a'।",
    ),
    DebugArrayStep(
      activeLineIndex: 4,
      queueItems: [],
      explanationEn: "Line 5: Process char 'a': freq['a']=2. Pop 'a'. Queue = []. Output '#'.",
      explanationBn: "লাইন ৫: ক্যারেক্টার 'a': freq=2। পপ 'a'। ডুপ্লিকেট পাওয়ায় আউটপুট '#'।",
    ),
    DebugArrayStep(
      activeLineIndex: 3,
      queueItems: ["b"],
      explanationEn: "Line 4: Process char 'b': freq['b']=1. Queue = ['b']. First Non-Repeating = 'b'.",
      explanationBn: "লাইন ৪: ক্যারেক্টার 'b': freq=1। কিউ = ['b']। প্রথম অনাবৃত্ত ক্যারেক্টার = 'b'।",
    ),
    DebugArrayStep(
      activeLineIndex: 5,
      queueItems: ["b"],
      explanationEn: "🎉 Line 6: Stream processed! Result string = \"a#bccxb\".",
      explanationBn: "🎉 লাইন ৬: ক্যারেক্টার স্ট্রিম প্রসেস সম্পন্ন! ফলাফল = \"a#bccxb\"।",
    ),
  ];

  final List<String> _q4CodeLines = [
    "vector<int> maxSlidingWindow(vector<int>& nums, int k) {",
    "    deque<int> dq; vector<int> res;",
    "    for (int i = 0; i < nums.size(); i++) {",
    "        if (!dq.empty() && dq.front() == i - k) dq.pop_front();",
    "        while (!dq.empty() && nums[dq.back()] < nums[i]) dq.pop_back();",
    "        dq.push_back(i);",
    "        if (i >= k - 1) res.push_back(nums[dq.front()]);",
    "    }",
    "    return res;",
    "}",
  ];

  final List<DebugArrayStep> _q4Steps = const [
    DebugArrayStep(
      activeLineIndex: 5,
      queueItems: ["3"],
      explanationEn: "Line 6: Window [1, 3, -1]: Deque stores max val 3. Max = 3.",
      explanationBn: "লাইন ৬: উইন্ডো [1, 3, -1]: Monotonic Deque টপ মান 3। উইন্ডো ম্যাক্স = 3।",
    ),
    DebugArrayStep(
      activeLineIndex: 5,
      queueItems: ["3", "-3"],
      explanationEn: "Line 6: Window [3, -1, -3]: Deque stores [3, -3]. Max = 3.",
      explanationBn: "লাইন ৬: উইন্ডো [3, -1, -3]: Deque = [3, -3]। উইন্ডো ম্যাক্স = 3।",
    ),
    DebugArrayStep(
      activeLineIndex: 5,
      queueItems: ["5"],
      explanationEn: "Line 6: Window [-1, -3, 5]: 5 > 3 & -3 -> Pop all smaller! Deque = [5]. Max = 5.",
      explanationBn: "লাইন ৬: উইন্ডো [-1, -3, 5]: 5 বড় থাকায় সব ছোট মান পপ! Deque = [5]। ম্যাক্স = 5।",
    ),
    DebugArrayStep(
      activeLineIndex: 6,
      queueItems: ["7"],
      explanationEn: "🎉 Line 7: Sliding Window Max Complete! Result = [3, 3, 5, 5, 6, 7]!",
      explanationBn: "🎉 লাইন ৭: স্লাইডিং উইন্ডো সর্বোচ্চ মান নির্ণয় সম্পন্ন! রেজাল্ট = [3, 3, 5, 5, 6, 7]!",
    ),
  ];

  // HASH TABLE & HASH MAP CODE LINES & STEPS
  final List<String> _hm1CodeLines = [
    "vector<int> twoSum(vector<int>& nums, int target) {",
    "    unordered_map<int, int> mp;",
    "    for (int i = 0; i < nums.size(); i++) {",
    "        int complement = target - nums[i];",
    "        if (mp.count(complement)) return {mp[complement], i};",
    "        mp[nums[i]] = i;",
    "    }",
    "    return {};",
    "}",
  ];

  final List<DebugArrayStep> _hm1Steps = const [
    DebugArrayStep(
      activeLineIndex: 1,
      hashMapItems: {},
      array1D: [2, 7, 11, 15],
      explanationEn: "Line 2: Initialize empty Hash Map mp = {}. Target = 9.",
      explanationBn: "লাইন ২: খালি হ্যাশ ম্যাপ mp = {} সূচনা। টার্গেট = 9।",
    ),
    DebugArrayStep(
      activeLineIndex: 5,
      hashMapItems: {"2": "0"},
      array1D: [2, 7, 11, 15],
      pointer1: 0,
      explanationEn: "Line 6: i = 0 (val 2): complement (9 - 2 = 7) not in map -> Store mp[2] = 0.",
      explanationBn: "লাইন ৬: i = 0 (মান 2): কমপ্লিমেন্ট (9 - 2 = 7) ম্যাপে নেই -> mp[2] = 0 সেভ।",
    ),
    DebugArrayStep(
      activeLineIndex: 4,
      hashMapItems: {"2": "0"},
      array1D: [2, 7, 11, 15],
      pointer1: 1,
      explanationEn: "🎉 Line 5: i = 1 (val 7): complement (9 - 7 = 2) MATCH FOUND at mp[2] = 0! Return {0, 1}!",
      explanationBn: "🎉 লাইন ৫: i = 1 (মান 7): কমপ্লিমেন্ট (9 - 7 = 2) ম্যাপে পাওয়া গেছে! Return {0, 1}!",
    ),
  ];

  final List<String> _hm2CodeLines = [
    "bool isAnagram(string s, string t) {",
    "    if (s.length() != t.length()) return false;",
    "    unordered_map<char, int> freq;",
    "    for (char c : s) freq[c]++;",
    "    for (char c : t) { if (--freq[c] < 0) return false; }",
    "    return true;",
    "}",
  ];

  final List<DebugArrayStep> _hm2Steps = const [
    DebugArrayStep(
      activeLineIndex: 3,
      hashMapItems: {"a": "3", "n": "1", "g": "1", "r": "1", "m": "1"},
      explanationEn: "Line 4: Count s = 'anagram' char frequencies -> {a:3, n:1, g:1, r:1, m:1}.",
      explanationBn: "লাইন ৪: s = 'anagram' ক্যারেক্টার কাউন্ট -> {a:3, n:1, g:1, r:1, m:1}।",
    ),
    DebugArrayStep(
      activeLineIndex: 4,
      hashMapItems: {"a": "0", "n": "0", "g": "0", "r": "0", "m": "0"},
      explanationEn: "Line 5: Decrement counts for t = 'nagaram' -> All frequencies decremented to 0.",
      explanationBn: "লাইন ৫: t = 'nagaram' ক্যারেক্টার বিয়োগ -> সব ফ্রিকোয়েন্সি কমে ০ হলো।",
    ),
    DebugArrayStep(
      activeLineIndex: 5,
      hashMapItems: {"a": "0", "n": "0", "g": "0", "r": "0", "m": "0"},
      explanationEn: "🎉 Line 6: All character counts match perfectly! Return TRUE!",
      explanationBn: "🎉 লাইন ৬: সমস্ত অক্ষরের গণনাসংখ্যা হুবহু মিলেছে! Return TRUE!",
    ),
  ];

  final List<String> _hm3CodeLines = [
    "vector<vector<string>> groupAnagrams(vector<string>& strs) {",
    "    unordered_map<string, vector<string>> mp;",
    "    for (string& s : strs) {",
    "        string key = s; sort(key.begin(), key.end());",
    "        mp[key].push_back(s);",
    "    }",
    "    return getValues(mp);",
    "}",
  ];

  final List<DebugArrayStep> _hm3Steps = const [
    DebugArrayStep(
      activeLineIndex: 4,
      hashMapItems: {"aet": "[\"eat\", \"tea\", \"ate\"]"},
      explanationEn: "Line 5: Grouped sorted key 'aet' -> [eat, tea, ate].",
      explanationBn: "লাইন ৫: সর্টেড কী 'aet' দিয়ে গ্রুপ -> [eat, tea, ate]।",
    ),
    DebugArrayStep(
      activeLineIndex: 4,
      hashMapItems: {"aet": "[\"eat\", \"tea\", \"ate\"]", "ant": "[\"tan\", \"nat\"]", "abt": "[\"bat\"]"},
      explanationEn: "Line 5: Grouped sorted keys 'ant' -> [tan, nat] and 'abt' -> [bat].",
      explanationBn: "লাইন ৫: সর্টেড কী 'ant' -> [tan, nat] এবং 'abt' -> [bat] গ্রুপ।",
    ),
    DebugArrayStep(
      activeLineIndex: 6,
      hashMapItems: {"aet": "[\"eat\", \"tea\", \"ate\"]", "ant": "[\"tan\", \"nat\"]", "abt": "[\"bat\"]"},
      explanationEn: "🎉 Line 7: Group Anagrams Complete! Return 3 grouped anagram buckets.",
      explanationBn: "🎉 লাইন ৭: অ্যানাগ্রাম গ্রুপিং সম্পন্ন! ৩টি অ্যানাগ্রাম বাকেট রিটার্ন করা হলো।",
    ),
  ];

  final List<String> _hm4CodeLines = [
    "int subarraySum(vector<int>& nums, int k) {",
    "    unordered_map<int, int> mp; mp[0] = 1;",
    "    int sum = 0, count = 0;",
    "    for (int num : nums) {",
    "        sum += num;",
    "        if (mp.count(sum - k)) count += mp[sum - k];",
    "        mp[sum]++;",
    "    }",
    "    return count;",
    "}",
  ];

  final List<DebugArrayStep> _hm4Steps = const [
    DebugArrayStep(
      activeLineIndex: 1,
      hashMapItems: {"0": "1"},
      array1D: [1, 1, 1],
      explanationEn: "Line 2: Set mp[0] = 1 (base prefix sum 0), k = 2.",
      explanationBn: "লাইন ২: বেস প্রেফিক্স সাম mp[0] = 1 সেট, k = 2।",
    ),
    DebugArrayStep(
      activeLineIndex: 5,
      hashMapItems: {"0": "1", "1": "1"},
      array1D: [1, 1, 1],
      pointer1: 0,
      explanationEn: "Line 6: i = 0 (val 1): sum = 1. sum - k = -1 not in map. Store mp[1] = 1.",
      explanationBn: "লাইন ৬: i = 0 (মান 1): sum = 1। (1 - 2 = -1) ম্যাপে নেই -> mp[1] = 1 সেভ।",
    ),
    DebugArrayStep(
      activeLineIndex: 5,
      hashMapItems: {"0": "1", "1": "1", "2": "1"},
      array1D: [1, 1, 1],
      pointer1: 1,
      minVal: 1,
      explanationEn: "Line 6: i = 1 (val 1): sum = 2. sum - k = 0 (FOUND in mp). count = 1. Store mp[2] = 1.",
      explanationBn: "লাইন ৬: i = 1 (মান 1): sum = 2। (2 - 2 = 0) ম্যাপে পাওয়া গেছে! count = 1।",
    ),
    DebugArrayStep(
      activeLineIndex: 8,
      hashMapItems: {"0": "1", "1": "1", "2": "1", "3": "1"},
      array1D: [1, 1, 1],
      pointer1: 2,
      minVal: 2,
      explanationEn: "🎉 Line 9: i = 2 (val 1): sum = 3. sum - k = 1 (FOUND in mp). Final Subarray Count = 2!",
      explanationBn: "🎉 লাইন ৯: i = 2 (মান 1): sum = 3। (3 - 2 = 1) ম্যাপে পাওয়া গেছে! চূড়ান্ত গণনা = 2!",
    ),
  ];

  // BINARY SEARCH TREE (BST) CODE LINES & STEPS - GRANULAR LINE-BY-LINE COVERAGE
  final List<String> _bst1CodeLines = [
    "TreeNode* searchBST(TreeNode* root, int val) {",
    "    if (!root || root->val == val) return root;",
    "    if (val < root->val) return searchBST(root->left, val);",
    "    return searchBST(root->right, val);",
    "}",
  ];

  final List<DebugArrayStep> _bst1Steps = const [
    DebugArrayStep(
      activeLineIndex: 0,
      pointer1: 4,
      minVal: 2,
      explanationEn: "Line 1: Enter searchBST(root, val = 2). Active Root Node = 4.",
      explanationBn: "লাইন ১: searchBST(root, val = 2) এ প্রবেশ। সক্রিয় রুট নোড = 4।",
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
      explanationBn: "লাইন ১: searchBST(Node 2, val = 2) এ রিকার্সিভ কল। সক্রিয় নোড = 2।",
    ),
    DebugArrayStep(
      activeLineIndex: 1,
      pointer1: 2,
      minVal: 2,
      explanationEn: "🎉 Line 2: Check (!root || 2 == 2) -> MATCH FOUND! Return subtree rooted at Node 2!",
      explanationBn: "🎉 লাইন ২: শর্ত (2 == 2) মিল পাওয়া গেছে! Node 2 এর সাবট্রি রিটার্ন করা হলো!",
    ),
  ];

  final List<String> _bst2CodeLines = [
    "TreeNode* insertIntoBST(TreeNode* root, int val) {",
    "    if (!root) return new TreeNode(val);",
    "    if (val < root->val) root->left = insertIntoBST(root->left, val);",
    "    else root->right = insertIntoBST(root->right, val);",
    "    return root;",
    "}",
  ];

  final List<DebugArrayStep> _bst2Steps = const [
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
      explanationBn: "ধাপ ৩ (লাইন ৩): শর্ত (5 < 4) মিথ্যা। 5 মানটি 4 এর চেয়ে বড়!",
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
      explanationBn: "ধাপ ৬ (লাইন ৩): শর্ত (5 < 7) সত্য! 5 মানটি 7 এর চেয়ে ছোট! বামে আগান -> root->left = insertIntoBST(nullptr, 5)।",
    ),
    DebugArrayStep(
      activeLineIndex: 1,
      pointer1: 5,
      minVal: 5,
      explanationEn: "Step 7 (Line 2): Reached empty nullptr space under Node 7! Create new TreeNode(5).",
      explanationBn: "ধাপ ৭ (লাইন ২): নোড 7 এর বামে খালি নাল স্থান পাওয়া গেছে! নতুন TreeNode(5) তৈরি করা হলো।",
    ),
    DebugArrayStep(
      activeLineIndex: 4,
      pointer1: 5,
      minVal: 5,
      explanationEn: "🎉 Step 8 (Line 5): Attached TreeNode(5) as Left Child of Node 7. BST Insertion Complete!",
      explanationBn: "🎉 ধাপ ৮ (লাইন ৫): নোড 7 এর বাম চাইল্ড হিসেবে TreeNode(5) সফলভাবে যুক্ত করা হলো! BST ইনসার্ট সম্পন্ন!",
    ),
  ];

  final List<String> _bst3CodeLines = [
    "bool validate(TreeNode* node, long minBound, long maxBound) {",
    "    if (!node) return true;",
    "    if (node->val <= minBound || node->val >= maxBound) return false;",
    "    return validate(node->left, minBound, node->val) &&",
    "           validate(node->right, node->val, maxBound);",
    "}",
  ];

  final List<DebugArrayStep> _bst3Steps = const [
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

  final List<String> _bst4CodeLines = [
    "TreeNode* lowestCommonAncestor(TreeNode* root, TreeNode* p, TreeNode* q) {",
    "    if (p->val < root->val && q->val < root->val)",
    "        return lowestCommonAncestor(root->left, p, q);",
    "    if (p->val > root->val && q->val > root->val)",
    "        return lowestCommonAncestor(root->right, p, q);",
    "    return root;",
    "}",
  ];

  final List<DebugArrayStep> _bst4Steps = const [
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
      explanationBn: "🎉 লাইন ৬: p=2 এবং q=8 রুট 6 এ দুই দিকে বিভক্ত হয়! Lowest Common Ancestor = Node 6!",
    ),
  ];

  // MIN & MAX HEAP CODE LINES & STEPS
  final List<String> _hp1CodeLines = [
    "int findKthLargest(vector<int>& nums, int k) {",
    "    priority_queue<int, vector<int>, greater<int>> minHeap;",
    "    for (int num : nums) {",
    "        minHeap.push(num);",
    "        if (minHeap.size() > k) minHeap.pop();",
    "    }",
    "    return minHeap.top();",
    "}",
  ];

  final List<DebugArrayStep> _hp1Steps = const [
    DebugArrayStep(
      activeLineIndex: 1,
      array1D: [],
      minVal: 2,
      explanationEn: "Line 2: Initialize empty Min-Heap for k = 2 largest elements. nums = [3, 2, 1, 5, 6, 4].",
      explanationBn: "লাইন ২: k = 2 টি বৃহত্তম উপাদান রাখতে খালি Min-Heap তৈরি। ইনপুট = [3, 2, 1, 5, 6, 4]।",
    ),
    DebugArrayStep(
      activeLineIndex: 3,
      array1D: [3, 2],
      minVal: 2,
      explanationEn: "Line 4: Push 3 & 2 -> Min-Heap = [2, 3]. Heap size = 2 (<= k). Root = 2 (Minimum).",
      explanationBn: "লাইন ৪: পুশ 3 ও 2 -> Min-Heap = [2, 3]। সাইজ ২। রুট = 2 (সর্বনিম্ন)।",
    ),
    DebugArrayStep(
      activeLineIndex: 4,
      array1D: [2, 3],
      minVal: 2,
      explanationEn: "Line 5: Push 1 -> Min-Heap = [1, 3, 2]. Size 3 > k(2) -> Pop Min Root (1). Heap = [2, 3].",
      explanationBn: "লাইন ৫: পুশ 1 -> Min-Heap = [1, 3, 2]। সাইজ ৩ > ২ -> পপ রুট 1। অবশিষ্ট হিপ = [2, 3]।",
    ),
    DebugArrayStep(
      activeLineIndex: 4,
      array1D: [3, 5],
      minVal: 3,
      explanationEn: "Line 5: Push 5 -> Min-Heap = [2, 3, 5]. Size 3 > k(2) -> Pop Min Root (2). Heap = [3, 5].",
      explanationBn: "লাইন ৫: পুশ 5 -> Min-Heap = [2, 3, 5]। সাইজ ৩ > ২ -> পপ রুট 2। অবশিষ্ট হিপ = [3, 5]।",
    ),
    DebugArrayStep(
      activeLineIndex: 4,
      array1D: [5, 6],
      minVal: 5,
      explanationEn: "Line 5: Push 6 -> Min-Heap = [3, 5, 6]. Size 3 > k(2) -> Pop Min Root (3). Heap = [5, 6].",
      explanationBn: "লাইন ৫: পুশ 6 -> Min-Heap = [3, 5, 6]। সাইজ ৩ > ২ -> পপ রুট 3। অবশিষ্ট হিপ = [5, 6]।",
    ),
    DebugArrayStep(
      activeLineIndex: 6,
      array1D: [5, 6],
      minVal: 5,
      explanationEn: "🎉 Line 7: Array traversal complete! Return Min-Heap top: Kth Largest = 5!",
      explanationBn: "🎉 লাইন ৭: ট্রাভার্সাল সম্পন্ন! Min-Heap টপ মান 5 ই হলো K-তম বৃহত্তম উপাদান!",
    ),
  ];

  final List<String> _hp2CodeLines = [
    "vector<int> topKFrequent(vector<int>& nums, int k) {",
    "    unordered_map<int, int> counts;",
    "    for (int n : nums) counts[n]++;",
    "    priority_queue<pair<int, int>> minHeap;",
    "    for (auto& p : counts) { minHeap.push(p); }",
    "    return getTopK(minHeap, k);",
    "}",
  ];

  final List<DebugArrayStep> _hp2Steps = const [
    DebugArrayStep(
      activeLineIndex: 2,
      hashMapItems: {"1": "3", "2": "2", "3": "1"},
      explanationEn: "Line 3: Count frequencies of nums = [1, 1, 1, 2, 2, 3] -> {1:3, 2:2, 3:1}.",
      explanationBn: "লাইন ৩: স্যাম্পল অ্যারের অক্ষরের ফ্রিকোয়েন্সি কাউন্ট -> {1:3, 2:2, 3:1}।",
    ),
    DebugArrayStep(
      activeLineIndex: 4,
      array1D: [1, 2],
      minVal: 2,
      explanationEn: "Line 5: Push frequency pairs to Min-Heap of size k=2 -> Heap stores top items (1, 2).",
      explanationBn: "লাইন ৫: সাইজ k=2 এর Min-Heap এ পুশ -> হিপে সর্বোচ্চ ফ্রিকোয়েন্সির (1, 2) জমা।",
    ),
    DebugArrayStep(
      activeLineIndex: 5,
      array1D: [1, 2],
      minVal: 2,
      explanationEn: "🎉 Line 6: Extracted top k=2 frequent items! Result = [1, 2]!",
      explanationBn: "🎉 লাইন ৬: সর্বোচ্চ k=2 টি ফ্রিকোয়েন্ট এলিমেন্ট নেওয়া হলো! রেজাল্ট = [1, 2]!",
    ),
  ];

  final List<String> _hp3CodeLines = [
    "ListNode* mergeKLists(vector<ListNode*>& lists) {",
    "    priority_queue<ListNode*> minHeap;",
    "    for (auto l : lists) if (l) minHeap.push(l);",
    "    while (!minHeap.empty()) {",
    "        ListNode* topNode = minHeap.top(); minHeap.pop();",
    "        if (topNode->next) minHeap.push(topNode->next);",
    "    }",
    "    return dummy.next;",
    "}",
  ];

  final List<DebugArrayStep> _hp3Steps = const [
    DebugArrayStep(
      activeLineIndex: 2,
      array1D: [1, 1, 2],
      explanationEn: "Line 3: Push heads of K=3 lists [1, 4, 5], [1, 3, 4], [2, 6] into Min-Heap.",
      explanationBn: "লাইন ৩: K=3 সর্টেড লিস্টের রুট নোড (1, 1, 2) Min-Heap এ রাখা হলো।",
    ),
    DebugArrayStep(
      activeLineIndex: 4,
      array1D: [1, 1, 2, 3, 4, 4, 5, 6],
      minVal: 1,
      explanationEn: "🎉 Line 5: Pop min nodes repeatedly and append to result list -> [1, 1, 2, 3, 4, 4, 5, 6]!",
      explanationBn: "🎉 লাইন ৫: পর পর সর্বনিম্ন নোড পপ করে মার্জড লিঙ্কড লিস্ট তৈরি -> [1, 1, 2, 3, 4, 4, 5, 6]!",
    ),
  ];

  final List<String> _hp4CodeLines = [
    "class MedianFinder {",
    "    priority_queue<int> maxHeap; // Lower half",
    "    priority_queue<int, greater<int>> minHeap; // Upper half",
    "public:",
    "    void addNum(int num) {",
    "        maxHeap.push(num); minHeap.push(maxHeap.top()); maxHeap.pop();",
    "        if (minHeap.size() > maxHeap.size()) balance();",
    "    }",
    "    double findMedian() { return (maxHeap.top() + minHeap.top()) / 2.0; }",
    "};",
  ];

  final List<DebugArrayStep> _hp4Steps = const [
    DebugArrayStep(
      activeLineIndex: 5,
      array1D: [2],
      minVal: 2,
      explanationEn: "Line 6: Add 2: maxHeap = [2], minHeap = []. Stream = [2]. Median = 2.0.",
      explanationBn: "লাইন ৬: ইনপুট 2 যোগ: maxHeap = [2], minHeap = []। মিডিয়ান = 2.0।",
    ),
    DebugArrayStep(
      activeLineIndex: 5,
      array1D: [2, 3],
      minVal: 2,
      explanationEn: "Line 6: Add 3: maxHeap = [2], minHeap = [3]. Stream = [2, 3]. Median = (2+3)/2 = 2.5.",
      explanationBn: "লাইন ৬: ইনপুট 3 যোগ: maxHeap = [2], minHeap = [3]। মিডিয়ান = (2+3)/2 = 2.5।",
    ),
    DebugArrayStep(
      activeLineIndex: 8,
      array1D: [2, 3, 4],
      minVal: 3,
      explanationEn: "🎉 Line 9: Add 4: maxHeap = [3, 2], minHeap = [4]. Stream = [2, 3, 4]. Median = maxHeap.top() = 3.0!",
      explanationBn: "🎉 লাইন ৯: ইনপুট 4 যোগ: maxHeap = [3, 2], minHeap = [4]। মিডিয়ান = maxHeap.top() = 3.0!",
    ),
  ];

  String _getMinValHeaderLabel(DebugArrayStep step) {
    if (step.minVal == null) return "";
    final pid = widget.problem.id;
    if (pid.startsWith("hp-")) return "Heap Top / Minimum: ${step.minVal}";
    if (pid.startsWith("ll-")) return "Result / Pointer: ${step.minVal}";
    if (pid.startsWith("st-")) return "Min Val: ${step.minVal}";
    if (pid.startsWith("hm-")) return "Count / Sum: ${step.minVal}";
    if (pid.startsWith("bst-")) return "Insertion Target: ${step.minVal}";
    return "Min: ${step.minVal}";
  }

  List<DebugArrayStep> get _currentSteps {
    if (widget.problem.id == "hp-1") return _hp1Steps;
    if (widget.problem.id == "hp-2") return _hp2Steps;
    if (widget.problem.id == "hp-3") return _hp3Steps;
    if (widget.problem.id == "hp-4") return _hp4Steps;
    if (widget.problem.id == "bst-1") return _bst1Steps;
    if (widget.problem.id == "bst-2") return _bst2Steps;
    if (widget.problem.id == "bst-3") return _bst3Steps;
    if (widget.problem.id == "bst-4") return _bst4Steps;
    if (widget.problem.id == "hm-1") return _hm1Steps;
    if (widget.problem.id == "hm-2") return _hm2Steps;
    if (widget.problem.id == "hm-3") return _hm3Steps;
    if (widget.problem.id == "hm-4") return _hm4Steps;
    if (widget.problem.id == "q-1") return _q1Steps;
    if (widget.problem.id == "q-2") return _q2Steps;
    if (widget.problem.id == "q-3") return _q3Steps;
    if (widget.problem.id == "q-4") return _q4Steps;
    if (widget.problem.id == "st-1") return _st1Steps;
    if (widget.problem.id == "st-2") return _st2Steps;
    if (widget.problem.id == "st-3") return _st3Steps;
    if (widget.problem.id == "st-4") return _st4Steps;
    if (widget.problem.id == "ll-1") return _ll1Steps;
    if (widget.problem.id == "ll-2") return _ll2Steps;
    if (widget.problem.id == "ll-3") return _ll3Steps;
    if (widget.problem.id == "ll-4") return _ll4Steps;
    if (widget.problem.id.contains("2") || widget.problem.id == "arr-2") return _arr2Steps;
    if (widget.problem.id.contains("3") || widget.problem.id == "arr-3") return _arr3Steps;
    if (widget.problem.id.contains("4") || widget.problem.id == "arr-4") return _arr4Steps;
    return _arr1Steps;
  }

  List<String> get _currentCodeLines {
    if (widget.problem.id == "hp-1") return _hp1CodeLines;
    if (widget.problem.id == "hp-2") return _hp2CodeLines;
    if (widget.problem.id == "hp-3") return _hp3CodeLines;
    if (widget.problem.id == "hp-4") return _hp4CodeLines;
    if (widget.problem.id == "bst-1") return _bst1CodeLines;
    if (widget.problem.id == "bst-2") return _bst2CodeLines;
    if (widget.problem.id == "bst-3") return _bst3CodeLines;
    if (widget.problem.id == "bst-4") return _bst4CodeLines;
    if (widget.problem.id == "hm-1") return _hm1CodeLines;
    if (widget.problem.id == "hm-2") return _hm2CodeLines;
    if (widget.problem.id == "hm-3") return _hm3CodeLines;
    if (widget.problem.id == "hm-4") return _hm4CodeLines;
    if (widget.problem.id == "q-1") return _q1CodeLines;
    if (widget.problem.id == "q-2") return _q2CodeLines;
    if (widget.problem.id == "q-3") return _q3CodeLines;
    if (widget.problem.id == "q-4") return _q4CodeLines;
    if (widget.problem.id == "st-1") return _st1CodeLines;
    if (widget.problem.id == "st-2") return _st2CodeLines;
    if (widget.problem.id == "st-3") return _st3CodeLines;
    if (widget.problem.id == "st-4") return _st4CodeLines;
    if (widget.problem.id == "ll-1") return _ll1CodeLines;
    if (widget.problem.id == "ll-2") return _ll2CodeLines;
    if (widget.problem.id == "ll-3") return _ll3CodeLines;
    if (widget.problem.id == "ll-4") return _ll4CodeLines;
    if (widget.problem.id.contains("2") || widget.problem.id == "arr-2") return _arr2CodeLines;
    if (widget.problem.id.contains("3") || widget.problem.id == "arr-3") return _arr3CodeLines;
    if (widget.problem.id.contains("4") || widget.problem.id == "arr-4") return _arr4CodeLines;
    return _arr1CodeLines;
  }

  @override
  void initState() {
    super.initState();
    _isEnglish = widget.initialLanguageIsEnglish;
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;
    });

    if (_isPlaying) {
      _timer = Timer.periodic(const Duration(milliseconds: 1400), (timer) {
        if (_currentStepIndex < _currentSteps.length - 1) {
          setState(() {
            _currentStepIndex++;
          });
        } else {
          _timer?.cancel();
          setState(() {
            _isPlaying = false;
          });
        }
      });
    } else {
      _timer?.cancel();
    }
  }

  void _nextStep() {
    if (_currentStepIndex < _currentSteps.length - 1) {
      setState(() {
        _currentStepIndex++;
      });
    }
  }

  void _prevStep() {
    if (_currentStepIndex > 0) {
      setState(() {
        _currentStepIndex--;
      });
    }
  }

  void _reset() {
    _timer?.cancel();
    setState(() {
      _isPlaying = false;
      _currentStepIndex = 0;
    });
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(_isEnglish ? "Code copied to clipboard!" : "কোড ক্লিপবোর্ডে কপি হয়েছে!", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: AppTheme.accentGreen,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String _getCodeForSelectedLanguage() {
    switch (_selectedCodeLang) {
      case "C++":
        return widget.problem.codeCpp;
      case "Java":
        return widget.problem.codeJava;
      case "Python":
        return widget.problem.codePython;
      case "JavaScript":
        return widget.problem.codeJs;
      default:
        return widget.problem.codeCpp;
    }
  }

  @override
  Widget build(BuildContext context) {
    final hPadding = Responsive.horizontalPadding(context);

    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      appBar: AppBar(
        title: Text(widget.problem.title, style: TextStyle(fontSize: Responsive.sp(context, 16), fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: TextButton.icon(
              style: TextButton.styleFrom(
                backgroundColor: AppTheme.accentPurple.withOpacity(0.2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              icon: Icon(Icons.language, color: _isEnglish ? AppTheme.accentNeonCyan : AppTheme.accentPink, size: 18),
              label: Text(_isEnglish ? 'EN' : 'BN', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              onPressed: () {
                setState(() => _isEnglish = !_isEnglish);
              },
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.accentNeonCyan,
          labelColor: AppTheme.accentNeonCyan,
          unselectedLabelColor: AppTheme.textSecondary,
          isScrollable: true,
          tabs: [
            Tab(text: _isEnglish ? '📘 Problem Description' : '📘 সমস্যা বিবরণী'),
            Tab(text: _isEnglish ? '⚡ Step Visualizer' : '⚡ স্টেপ ভিজ্যুয়ালাইজার'),
            Tab(text: _isEnglish ? '💻 Multi-Language Code' : '💻 সমাধান কোড'),
            Tab(text: _isEnglish ? '💡 Practice & Test' : '💡 প্র্যাকটিস ও টেস্ট'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDescriptionTab(hPadding),
          _buildVisualizerTab(hPadding),
          _buildCodeTab(hPadding),
          _buildPracticeTab(hPadding),
        ],
      ),
    );
  }

  // TAB 1: Problem Description
  Widget _buildDescriptionTab(double hPadding) {
    return ResponsiveCenter(
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.accentPurple.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.accentPurple),
              ),
              child: Text(widget.problem.category, style: const TextStyle(color: AppTheme.accentPurple, fontWeight: FontWeight.bold, fontSize: 12)),
            ),
            const SizedBox(height: 12),
            Text(widget.problem.title, style: TextStyle(fontSize: Responsive.sp(context, 22), fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(color: AppTheme.surfaceDark, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFF334155))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_isEnglish ? "Problem Statement" : "সমস্যার বিবরণ", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.accentNeonCyan)),
                  const SizedBox(height: 8),
                  Text(_isEnglish ? widget.problem.descriptionEn : widget.problem.descriptionBn, style: const TextStyle(color: AppTheme.textSecondary, height: 1.5, fontSize: 14)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Key Idea Intuition Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.accentNeonCyan.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.accentNeonCyan.withOpacity(0.4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.lightbulb_outline, color: AppTheme.accentNeonCyan, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(_isEnglish ? widget.problem.keyIdeaEn : widget.problem.keyIdeaBn, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 13, height: 1.4)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Text(_isEnglish ? "Sample Test Cases" : "স্যাম্পল টেস্ট কেস", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 10),
            ...List.generate(widget.problem.sampleInputs.length, (i) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: const Color(0xFF090D16), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFF1E293B))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Input: ${widget.problem.sampleInputs[i]}", style: const TextStyle(color: AppTheme.accentNeonCyan, fontFamily: 'monospace', fontSize: 13)),
                    const SizedBox(height: 4),
                    Text("Output: ${widget.problem.sampleOutputs[i]}", style: const TextStyle(color: AppTheme.accentGreen, fontFamily: 'monospace', fontWeight: FontWeight.bold, fontSize: 13)),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  // TAB 2: Step Visualizer Following Two Pointers Feature Architecture
  Widget _buildVisualizerTab(double hPadding) {
    final step = _currentSteps[_currentStepIndex];
    final isMobile = Responsive.isMobile(context);

    return ResponsiveCenter(
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Log Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.accentNeonCyan.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.accentNeonCyan.withOpacity(0.5)),
              ),
              child: Text(
                _isEnglish ? step.explanationEn : step.explanationBn,
                style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
            const SizedBox(height: 16),

            // Responsive Debugger Layout (Code Snippet + Visualizer Box)
            if (isMobile)
              Column(
                children: [
                  _buildCodeSnippetWithHighlight(_currentCodeLines, step.activeLineIndex),
                  const SizedBox(height: 16),
                  _buildVisualizerBox(step),
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildCodeSnippetWithHighlight(_currentCodeLines, step.activeLineIndex)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildVisualizerBox(step)),
                ],
              ),

            const SizedBox(height: 20),

            // Controls Bar with Step Counter
            _buildControlBar(),
          ],
        ),
      ),
    );
  }

  // TAB 3: Multi-Language Code with Embedded Two-Pointer Style Debugger
  Widget _buildCodeTab(double hPadding) {
    final step = _currentSteps[_currentStepIndex];

    return ResponsiveCenter(
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_isEnglish ? "Solution Code" : "সমাধান কোড", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                DropdownButton<String>(
                  value: _selectedCodeLang,
                  dropdownColor: AppTheme.surfaceDark,
                  style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold),
                  underline: Container(),
                  items: ["C++", "Java", "Python", "JavaScript"].map((lang) => DropdownMenuItem(value: lang, child: Text(lang))).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedCodeLang = val);
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Selected Language Code Block with Copy
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: const Color(0xFF090D16), borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFF1E293B))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.copy, color: AppTheme.accentNeonCyan, size: 18),
                    onPressed: () => _copyToClipboard(_getCodeForSelectedLanguage()),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(_getCodeForSelectedLanguage(), style: const TextStyle(fontFamily: 'monospace', fontSize: 12, color: Color(0xFF38BDF8), height: 1.4)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Granular Line-by-Line Debugger & Visualizer Canvas inside Solution Code Tab
            Text(_isEnglish ? "Line-by-Line Execution Debugger & Canvas" : "লাইন-বাই-লাইন এক্সিকিউশন ডিবাগার ও ক্যানভাস", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.accentNeonCyan)),
            const SizedBox(height: 10),

            // Status Log Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.accentNeonCyan.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.accentNeonCyan.withOpacity(0.4)),
              ),
              child: Text(
                _isEnglish ? step.explanationEn : step.explanationBn,
                style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
            const SizedBox(height: 12),

            _buildCodeSnippetWithHighlight(_currentCodeLines, step.activeLineIndex),
            const SizedBox(height: 14),

            _buildVisualizerBox(step),
            const SizedBox(height: 16),

            _buildControlBar(),
          ],
        ),
      ),
    );
  }

  // TAB 4: Practice & Test Runner
  Widget _buildPracticeTab(double hPadding) {
    return ResponsiveCenter(
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppTheme.surfaceDark, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.accentGreen.withOpacity(0.4))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_isEnglish ? "Interactive Practice & Test Runner" : "ইনটারেক্টিভ প্র্যাকটিস টেস্ট রানার", style: const TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  Text(_isEnglish ? "Test your code against sample inputs and verify correct outputs." : "স্যাম্পল ইনপুট দিয়ে আপনার সমাধান কোড টেস্ট ও ভেরিফাই করুন।", style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(_isEnglish ? "Running tests... All 5 test cases PASSED! 🎉" : "টেস্ট রান হচ্ছে... ৫টি টেস্ট কেস সম্পূর্ণ সফল! 🎉"), backgroundColor: AppTheme.accentGreen),
                      );
                    },
                    icon: const Icon(Icons.play_arrow),
                    label: Text(_isEnglish ? "Run All Test Cases" : "সব টেস্ট কেস রান করুন"),
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentGreen, foregroundColor: AppTheme.primaryDark),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // CODE SNIPPET WITH HIGHLIGHT (Matching TwoPointersVisualizer)
  Widget _buildCodeSnippetWithHighlight(List<String> codeLines, int activeIndex) {
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

  // VISUALIZER BOX (Matching TwoPointersVisualizer)
  Widget _buildVisualizerBox(DebugArrayStep step) {
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
          // Inspector Header Info
          if (step.minVal != null || step.maxVal != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (step.minVal != null)
                  Text(
                    _getMinValHeaderLabel(step),
                    style: const TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                if (step.maxVal != null)
                  Text(
                    "Max Bound: ${step.maxVal}",
                    style: const TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
              ],
            ),
            const SizedBox(height: 16),
          ],

          // Dedicated Min & Max Heap Binary Tree & Array Canvas (hp-1, hp-2, hp-3, hp-4)
          if (widget.problem.id.startsWith("hp-")) ...[
            _buildHeapCanvas(step),
            const SizedBox(height: 16),
          ],

          // Dedicated Arrow-Free Clean Insertion Canvas for BST Insert (bst-2)
          if (widget.problem.id == "bst-2") ...[
            _buildBstInsertCanvas(step),
            const SizedBox(height: 16),
          ]
          // Standard Hierarchy Canvas for bst-1, bst-3, bst-4
          else if (widget.problem.id.startsWith("bst-")) ...[
            _buildBstCanvas(step),
            const SizedBox(height: 16),
          ],

          // Hash Map Key-Value Bucket Inspector
          if (widget.problem.id.startsWith("hm-") && step.hashMapItems != null) ...[
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
                      ? Center(child: Text(_isEnglish ? "[Hash Map Empty]" : "[হ্যাশ ম্যাপ খালি]", style: const TextStyle(color: AppTheme.textMuted, fontSize: 12)))
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

          // Queue FIFO Pipeline Visualizer Container
          if (widget.problem.id.startsWith("q-") && step.queueItems != null) ...[
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
                      ? Center(child: Text(_isEnglish ? "[Queue Empty]" : "[কিউ খালি]", style: const TextStyle(color: AppTheme.textMuted, fontSize: 12)))
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
                                    Text(
                                      item,
                                      style: TextStyle(color: (isFront || isRear) ? AppTheme.primaryDark : Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                                    ),
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

          // Stack LIFO Visualizer Container
          if (widget.problem.id.startsWith("st-") && step.stackItems != null) ...[
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
                      ? Center(child: Text(_isEnglish ? "[Stack Empty]" : "[স্ট্যাক খালি]", style: const TextStyle(color: AppTheme.textMuted, fontSize: 12)))
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
          if (step.array1D != null && !widget.problem.id.startsWith("bst-") && !widget.problem.id.startsWith("hp-")) ...[
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(step.array1D!.length, (i) {
                  final isP1 = step.pointer1 == i;
                  final isP2 = step.pointer2 == i;
                  final color = isP1 ? AppTheme.accentNeonCyan : (isP2 ? AppTheme.accentPink : AppTheme.surfaceDark);
                  final isLinkedList = widget.problem.id.startsWith("ll-");
                  final isDoubly = widget.problem.id == "ll-3";

                  String badge1 = "curr [$i]";
                  String badge2 = "prev [$i]";
                  if (widget.problem.id == "ll-2" || widget.problem.id == "ll-4") {
                    badge1 = "slow [$i]";
                    badge2 = "fast [$i]";
                  } else if (widget.problem.id.startsWith("hm-")) {
                    badge1 = "i [$i]";
                  }

                  return Row(
                    children: [
                      Container(
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
          if (step.matrix2D != null) ...[
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

  // MIN & MAX HEAP VISUALIZER CANVAS (hp-1, hp-2, hp-3, hp-4)
  Widget _buildHeapCanvas(DebugArrayStep step) {
    final heapArray = step.array1D ?? [];

    return Column(
      children: [
        const Text("Min/Max Heap Priority Queue (Root [0] = Top Minimum)", style: TextStyle(color: Color(0xFF84CC16), fontWeight: FontWeight.bold, fontSize: 13)),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF090D16),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF84CC16), width: 2),
          ),
          child: Column(
            children: [
              // Heap Root Priority Badge
              if (heapArray.isNotEmpty) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF84CC16),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "ROOT TOP [0]: ${heapArray[0]}",
                    style: const TextStyle(color: AppTheme.primaryDark, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                const SizedBox(height: 14),
              ],
              // Heap 1D Array Representation Cards
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(heapArray.length, (idx) {
                    final isRoot = idx == 0;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: isRoot ? const Color(0xFF84CC16) : AppTheme.surfaceDark,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: isRoot ? Colors.white : const Color(0xFF84CC16).withOpacity(0.5)),
                      ),
                      child: Column(
                        children: [
                          Text("${heapArray[idx]}", style: TextStyle(color: isRoot ? AppTheme.primaryDark : Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                          const SizedBox(height: 2),
                          Text("[$idx]", style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: isRoot ? AppTheme.primaryDark : AppTheme.textMuted)),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // DEDICATED ARROW-FREE CLEAN BST INSERTION CANVAS FOR BST INSERT (bst-2)
  Widget _buildBstInsertCanvas(DebugArrayStep step) {
    final activeVal = step.pointer1;
    final isInserted = _currentStepIndex >= 6;

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
              // Level 1: Root Node (4)
              _buildBstNodeCircle(4, isHighlighted: activeVal == 4, badge: "ROOT (4)"),
              const SizedBox(height: 12),
              // Level 2: Left Child (2) & Right Child (7)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildBstNodeCircle(2, isHighlighted: activeVal == 2, badge: "LEFT (2)"),
                  _buildBstNodeCircle(7, isHighlighted: activeVal == 7, badge: "RIGHT (7)"),
                ],
              ),
              const SizedBox(height: 12),
              // Level 3: Newly Inserted Node under 7's Left Child!
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

  // STANDARD BST HIERARCHY CANVAS FOR bst-1, bst-3, bst-4
  Widget _buildBstCanvas(DebugArrayStep step) {
    int rootVal = 4;
    int leftVal = 2;
    int rightVal = 7;

    if (widget.problem.id == "bst-3") {
      rootVal = 2;
      leftVal = 1;
      rightVal = 3;
    } else if (widget.problem.id == "bst-4") {
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
              // Level 1: Root Node
              _buildBstNodeCircle(rootVal, isHighlighted: step.pointer1 == rootVal, badge: "ROOT"),
              const SizedBox(height: 4),
              // Branch Connecting Lines Custom Painter
              SizedBox(
                width: 220,
                height: 38,
                child: CustomPaint(
                  painter: TreeBranchPainter(color: AppTheme.accentNeonCyan),
                ),
              ),
              const SizedBox(height: 4),
              // Level 2: Left & Right Children Nodes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildBstNodeCircle(leftVal, isHighlighted: step.pointer1 == leftVal, badge: "LEFT CHILD"),
                  _buildBstNodeCircle(rightVal, isHighlighted: step.pointer1 == rightVal, badge: "RIGHT CHILD"),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBstNodeCircle(int val, {required bool isHighlighted, required String badge}) {
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

  // CONTROL BAR WITH STEP COUNTER (Matching TwoPointersVisualizer)
  Widget _buildControlBar() {
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
                onPressed: _currentStepIndex > 0 ? _prevStep : null,
              ),
              IconButton(
                icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, color: AppTheme.accentNeonCyan),
                onPressed: _togglePlay,
              ),
              IconButton(
                icon: const Icon(Icons.skip_next, color: Colors.white),
                onPressed: _currentStepIndex < _currentSteps.length - 1 ? _nextStep : null,
              ),
              IconButton(
                icon: const Icon(Icons.refresh, color: AppTheme.accentNeonCyan),
                onPressed: _reset,
              ),
            ],
          ),
          Text(
            _isEnglish
                ? "Step ${_currentStepIndex + 1} of ${_currentSteps.length}"
                : "ধাপ ${_currentStepIndex + 1} / ${_currentSteps.length}",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
