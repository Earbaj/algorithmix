import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'debug_array_step.dart';

// ─── HEAP: CODE LINES ─────────────────────────────────────────────────────────

const List<String> hp1CodeLines = [
  "int findKthLargest(vector<int>& nums, int k) {",
  "    priority_queue<int, vector<int>, greater<int>> minHeap;",
  "    for (int num : nums) {",
  "        minHeap.push(num);",
  "        if (minHeap.size() > k) minHeap.pop();",
  "    }",
  "    return minHeap.top();",
  "}",
];

const List<String> hp2CodeLines = [
  "vector<int> topKFrequent(vector<int>& nums, int k) {",
  "    unordered_map<int, int> counts;",
  "    for (int n : nums) counts[n]++;",
  "    priority_queue<pair<int, int>> minHeap;",
  "    for (auto& p : counts) { minHeap.push(p); }",
  "    return getTopK(minHeap, k);",
  "}",
];

const List<String> hp3CodeLines = [
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

const List<String> hp4CodeLines = [
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

// ─── HEAP: STEPS ──────────────────────────────────────────────────────────────

const List<DebugArrayStep> hp1Steps = [
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

const List<DebugArrayStep> hp2Steps = [
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
    explanationBn: "🎉 লাইন ৬: সর্বোচ্চ k=2 টি ফ্রিকোয়েন্ট এলিমেন্ট নেওয়া হলো! রেজাল্ট = [1, 2]!",
  ),
];

const List<DebugArrayStep> hp3Steps = [
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

const List<DebugArrayStep> hp4Steps = [
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

// ─── GETTERS ──────────────────────────────────────────────────────────────────

List<String> getHeapCodeLines(String id) {
  if (id == "hp-2") return hp2CodeLines;
  if (id == "hp-3") return hp3CodeLines;
  if (id == "hp-4") return hp4CodeLines;
  return hp1CodeLines;
}

List<DebugArrayStep> getHeapSteps(String id) {
  if (id == "hp-2") return hp2Steps;
  if (id == "hp-3") return hp3Steps;
  if (id == "hp-4") return hp4Steps;
  return hp1Steps;
}

// ─── HEAP CANVAS WIDGET ───────────────────────────────────────────────────────

Widget buildHeapCanvas(DebugArrayStep step) {
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
            if (heapArray.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(color: const Color(0xFF84CC16), borderRadius: BorderRadius.circular(12)),
                child: Text("ROOT TOP [0]: ${heapArray[0]}", style: const TextStyle(color: AppTheme.primaryDark, fontWeight: FontWeight.bold, fontSize: 14)),
              ),
              const SizedBox(height: 14),
            ],
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
