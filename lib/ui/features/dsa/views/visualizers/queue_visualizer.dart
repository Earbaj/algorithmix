import 'debug_array_step.dart';

// ─── QUEUE: CODE LINES ────────────────────────────────────────────────────────

const List<String> q1CodeLines = [
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

const List<String> q2CodeLines = [
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

const List<String> q3CodeLines = [
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

const List<String> q4CodeLines = [
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

// ─── QUEUE: STEPS ─────────────────────────────────────────────────────────────

const List<DebugArrayStep> q1Steps = [
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

const List<DebugArrayStep> q2Steps = [
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

const List<DebugArrayStep> q3Steps = [
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
    explanationBn: "লাইন ৫: ক্যারেক্টার 'a': freq=2। পপ 'a'। ডুপ্লিকেট পাওয়ায় আউটপুট '#'।",
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

const List<DebugArrayStep> q4Steps = [
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
    explanationBn: "লাইন ৬: উইন্ডো [-1, -3, 5]: 5 বড় থাকায় সব ছোট মান পপ! Deque = [5]। ম্যাক্স = 5।",
  ),
  DebugArrayStep(
    activeLineIndex: 6,
    queueItems: ["7"],
    explanationEn: "🎉 Line 7: Sliding Window Max Complete! Result = [3, 3, 5, 5, 6, 7]!",
    explanationBn: "🎉 লাইন ৭: স্লাইডিং উইন্ডো সর্বোচ্চ মান নির্ণয় সম্পন্ন! রেজাল্ট = [3, 3, 5, 5, 6, 7]!",
  ),
];

// ─── GETTERS ──────────────────────────────────────────────────────────────────

List<String> getQueueCodeLines(String id) {
  if (id == "q-2") return q2CodeLines;
  if (id == "q-3") return q3CodeLines;
  if (id == "q-4") return q4CodeLines;
  return q1CodeLines;
}

List<DebugArrayStep> getQueueSteps(String id) {
  if (id == "q-2") return q2Steps;
  if (id == "q-3") return q3Steps;
  if (id == "q-4") return q4Steps;
  return q1Steps;
}
