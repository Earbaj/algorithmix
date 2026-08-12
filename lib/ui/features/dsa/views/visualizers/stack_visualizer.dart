import 'debug_array_step.dart';

// ─── STACK: CODE LINES ────────────────────────────────────────────────────────

const List<String> st1CodeLines = [
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

const List<String> st2CodeLines = [
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

const List<String> st3CodeLines = [
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

const List<String> st4CodeLines = [
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

// ─── STACK: STEPS ─────────────────────────────────────────────────────────────

const List<DebugArrayStep> st1Steps = [
  DebugArrayStep(
    activeLineIndex: 1,
    stackItems: [],
    explanationEn: "Line 2: Initialize empty char stack st = []. Input string s = '({[]})'.",
    explanationBn: "লাইন ২: খালি স্ট্যাক st = [] ডিক্লেয়ার। ইনপুট স্ট্রিং s = '({[]})'।",
  ),
  DebugArrayStep(
    activeLineIndex: 3,
    stackItems: ["("],
    explanationEn: "Line 4: Encountered opening bracket '('. Push '(' onto stack. Stack = ['('].",
    explanationBn: "লাইন ৪: ওপেনিং ব্র্যাকেট '(' পাওয়া গেল। স্ট্যাকে পুশ করুন। স্ট্যাক = ['(']।",
  ),
  DebugArrayStep(
    activeLineIndex: 3,
    stackItems: ["(", "{"],
    explanationEn: "Line 4: Encountered opening bracket '{'. Push '{' onto stack. Stack = ['(', '{'].",
    explanationBn: "লাইন ৪: ওপেনিং ব্র্যাকেট '{' পাওয়া গেল। স্ট্যাকে পুশ করুন। স্ট্যাক = ['(', '{']।",
  ),
  DebugArrayStep(
    activeLineIndex: 3,
    stackItems: ["(", "{", "["],
    explanationEn: "Line 4: Encountered opening bracket '['. Push '[' onto stack. Stack = ['(', '{', '['].",
    explanationBn: "লাইন ৪: ওপেনিং ব্র্যাকেট '[' পাওয়া গেল। স্ট্যাকে পুশ করুন। স্ট্যাক = ['(', '{', '[']।",
  ),
  DebugArrayStep(
    activeLineIndex: 6,
    stackItems: ["(", "{\"]"],
    explanationEn: "Line 7: Encountered closing bracket ']'. Pop top '[' and verify match. Match OK!",
    explanationBn: "লাইন ৭: ক্লোজিং ব্র্যাকেট ']' পাওয়া গেল। টপ '[' পপ করে ম্যাচ ভেরিফাই করা হলো।",
  ),
  DebugArrayStep(
    activeLineIndex: 6,
    stackItems: ["("],
    explanationEn: "Line 7: Encountered closing bracket '}'. Pop top '{' and verify match. Match OK!",
    explanationBn: "লাইন ৭: ক্লোজিং ব্র্যাকেট '}' পাওয়া গেল। টপ '{' পপ করে ম্যাচ ভেরিফাই করা হলো।",
  ),
  DebugArrayStep(
    activeLineIndex: 10,
    stackItems: [],
    explanationEn: "🎉 Line 11: All brackets matched! Stack is empty. Return TRUE!",
    explanationBn: "🎉 লাইন ১১: সমস্ত ব্র্যাকেট সঠিকভাবে ম্যাচ করেছে! স্ট্যাক খালি। Return TRUE!",
  ),
];

const List<DebugArrayStep> st2Steps = [
  DebugArrayStep(
    activeLineIndex: 1,
    stackItems: [],
    minVal: 0,
    explanationEn: "Line 2: Initialize main stack `st` and auxiliary `minSt` for O(1) min queries.",
    explanationBn: "লাইন ২: মূল স্ট্যাক `st` এবং O(1) মিনিমাম কুয়েরির জন্য auxiliary `minSt` ডিক্লেয়ার।",
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
    explanationBn: "লাইন ৭: পুশ (-3) -> মিনিমাম আপডেট হয়ে -3 হলো। minSt = [-2, -2, -3]।",
  ),
  DebugArrayStep(
    activeLineIndex: 8,
    stackItems: ["-2", "0", "-3"],
    minVal: -3,
    explanationEn: "🎉 Line 9: Call getMin() -> Query minSt.top() = -3 in O(1) constant time!",
    explanationBn: "🎉 লাইন ৯: getMin() কল -> O(1) টাইমে minSt.top() = -3 রিটার্ন!",
  ),
];

const List<DebugArrayStep> st3Steps = [
  DebugArrayStep(
    activeLineIndex: 1,
    stackItems: [],
    explanationEn: "Line 2: Evaluate Postfix RPN = ['2', '1', '+', '3', '*']. Initialize st = [].",
    explanationBn: "লাইন ২: পোস্টফিক্স RPN = ['2', '1', '+', '3', '*'] মূল্যায়ন শুরু।",
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
    explanationBn: "লাইন ৭: '+' পেয়ে পপ (1, 2)। হিসাব (2 + 1 = 3)। পুশ 3। স্ট্যাক = [3]।",
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
    explanationBn: "🎉 লাইন ১০: '*' পেয়ে পপ (3, 3)। হিসাব (3 * 3 = 9)। চূড়ান্ত ফলাফল = 9!",
  ),
];

const List<DebugArrayStep> st4Steps = [
  DebugArrayStep(
    activeLineIndex: 2,
    stackItems: [],
    array1D: [4, 5, 2, 25],
    explanationEn: "Line 3: Array arr = [4, 5, 2, 25]. Traverse right-to-left using Monotonic Stack.",
    explanationBn: "লাইন ৩: অ্যারে arr = [4, 5, 2, 25]। মনোটোনিক স্ট্যাক দিয়ে ডান থেকে বামে ট্রাভার্স।",
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

// ─── GETTERS ──────────────────────────────────────────────────────────────────

List<String> getStackCodeLines(String id) {
  if (id == "st-2") return st2CodeLines;
  if (id == "st-3") return st3CodeLines;
  if (id == "st-4") return st4CodeLines;
  return st1CodeLines;
}

List<DebugArrayStep> getStackSteps(String id) {
  if (id == "st-2") return st2Steps;
  if (id == "st-3") return st3Steps;
  if (id == "st-4") return st4Steps;
  return st1Steps;
}
