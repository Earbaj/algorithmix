import 'debug_array_step.dart';

// ─── ARRAYS: CODE LINES ───────────────────────────────────────────────────────

const List<String> arr1CodeLines = [
  "pair<int, int> findMinMax(vector<int>& arr) {",
  "    int minVal = arr[0], maxVal = arr[0];",
  "    for (int i = 1; i < arr.size(); i++) {",
  "        if (arr[i] < minVal) minVal = arr[i];",
  "        if (arr[i] > maxVal) maxVal = arr[i];",
  "    }",
  "    return {minVal, maxVal};",
  "}",
];

const List<String> arr2CodeLines = [
  "void reverseArray(vector<int>& arr) {",
  "    int left = 0, right = arr.size() - 1;",
  "    while (left < right) {",
  "        swap(arr[left], arr[right]);",
  "        left++; right--;",
  "    }",
  "}",
];

const List<String> arr3CodeLines = [
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

const List<String> arr4CodeLines = [
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

// ─── ARRAYS: STEPS ────────────────────────────────────────────────────────────

const List<DebugArrayStep> arr1Steps = [
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
    explanationBn: "লাইন ৫: শর্ত 42 > 15 সত্য! maxVal আপডেট হয়ে 42 হলো।",
  ),
  DebugArrayStep(
    activeLineIndex: 3,
    pointer1: 2,
    minVal: 8,
    maxVal: 42,
    array1D: [15, 42, 8, 99, 23],
    explanationEn: "Line 4: Check 8 < 15 (TRUE) -> Update minVal = 8.",
    explanationBn: "লাইন ৪: শর্ত 8 < 15 সত্য! minVal আপডেট হয়ে 8 হলো।",
  ),
  DebugArrayStep(
    activeLineIndex: 4,
    pointer1: 3,
    minVal: 8,
    maxVal: 99,
    array1D: [15, 42, 8, 99, 23],
    explanationEn: "Line 5: Check 99 > 42 (TRUE) -> Update maxVal = 99.",
    explanationBn: "লাইন ৫: শর্ত 99 > 42 সত্য! maxVal আপডেট হয়ে 99 হলো।",
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
    explanationBn: "🎉 লাইন ৭: ট্রাভার্সাল সম্পন্ন! চূড়ান্ত Min = 8, Max = 99।",
  ),
];

const List<DebugArrayStep> arr2Steps = [
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
    explanationBn: "লাইন ৫: পয়েন্টার কমানো/বাড়ানো: left = 1, right = 3।",
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
    explanationBn: "লাইন ৫: পয়েন্টার কমানো/বাড়ানো: left = 2, right = 2।",
  ),
  DebugArrayStep(
    activeLineIndex: 2,
    pointer1: 2,
    pointer2: 2,
    array1D: [5, 4, 3, 2, 1],
    explanationEn: "🎉 Line 3: Check while (left < right) -> (2 < 2) is FALSE. Reversal Complete!",
    explanationBn: "🎉 লাইন ৩: (2 < 2) মিথ্যা! পয়েন্টার দুটো মাঝখানে মিলিত হয়ে সম্পূর্ণ রিভার্সড।",
  ),
];

const List<DebugArrayStep> arr3Steps = [
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

const List<DebugArrayStep> arr4Steps = [
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
    explanationBn: "লাইন ৬: ডেপথ লেয়ার 0 উপাদান যোগ -> সমষ্টি = 10।",
  ),
  DebugArrayStep(
    activeLineIndex: 5,
    pointer1: 1,
    minVal: 36,
    explanationEn: "Line 6: Depth Layer 1: Summing elements [[5,6],[7,8]] -> total = 10 + 26 = 36.",
    explanationBn: "লাইন ৬: ডেপথ লেয়ার 1 উপাদান যোগ -> মোট সমষ্টি = 36।",
  ),
  DebugArrayStep(
    activeLineIndex: 9,
    pointer1: 1,
    minVal: 36,
    explanationEn: "🎉 Line 10: 3D Tensor Volume Sum Complete! Return total = 36.",
    explanationBn: "🎉 লাইন ১০: ৩D টেনসর যোগফল সম্পন্ন! মোট সমষ্টি = 36।",
  ),
];

// ─── GETTERS ──────────────────────────────────────────────────────────────────

List<String> getArrayCodeLines(String id) {
  if (id == "arr-2" || id.contains("2")) return arr2CodeLines;
  if (id == "arr-3" || id.contains("3")) return arr3CodeLines;
  if (id == "arr-4" || id.contains("4")) return arr4CodeLines;
  return arr1CodeLines;
}

List<DebugArrayStep> getArraySteps(String id) {
  if (id == "arr-2" || id.contains("2")) return arr2Steps;
  if (id == "arr-3" || id.contains("3")) return arr3Steps;
  if (id == "arr-4" || id.contains("4")) return arr4Steps;
  return arr1Steps;
}
