import 'debug_array_step.dart';

// ─── LINKED LIST: CODE LINES ──────────────────────────────────────────────────

const List<String> ll1CodeLines = [
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

const List<String> ll2CodeLines = [
  "ListNode* middleNode(ListNode* head) {",
  "    ListNode *slow = head, *fast = head;",
  "    while (fast != nullptr && fast->next != nullptr) {",
  "        slow = slow->next;",
  "        fast = fast->next->next;",
  "    }",
  "    return slow;",
  "}",
];

const List<String> ll3CodeLines = [
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

const List<String> ll4CodeLines = [
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

// ─── LINKED LIST: STEPS ───────────────────────────────────────────────────────

const List<DebugArrayStep> ll1Steps = [
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
    explanationBn: "লাইন ৫: লিঙ্ক উল্টানো! নোড 1 এর পয়েন্টার এখন prev (null) কে দেখাচ্ছে।",
  ),
  DebugArrayStep(
    activeLineIndex: 5,
    pointer1: 1,
    pointer2: 0,
    array1D: [1, 2, 3, 4, 5],
    explanationEn: "Line 6: Advance pointers -> prev = node 1, curr = node 2.",
    explanationBn: "লাইন ৬: পয়েন্টার আগানো: prev = node 1, curr = node 2।",
  ),
  DebugArrayStep(
    activeLineIndex: 4,
    pointer1: 1,
    pointer2: 0,
    array1D: [2, 1, 3, 4, 5],
    explanationEn: "Line 5: Flip link! Node 2 next now points back to Node 1.",
    explanationBn: "লাইন ৫: লিঙ্ক উল্টানো! নোড 2 এখন নোড 1 কে পয়েন্ট করছে।",
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

const List<DebugArrayStep> ll2Steps = [
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

const List<DebugArrayStep> ll3Steps = [
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
    explanationBn: "লাইন ৫: নোড 1 এর prev ও next পয়েন্টার অদলবদল করা হলো।",
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
    explanationBn: "লাইন ৫: নোড 2 এর prev ও next পয়েন্টার অদলবদল করা হলো।",
  ),
  DebugArrayStep(
    activeLineIndex: 8,
    pointer1: 3,
    array1D: [4, 3, 2, 1],
    explanationEn: "🎉 Line 9: Doubly Linked List Reversal Complete! Return new head (val 4).",
    explanationBn: "🎉 লাইন ৯: Doubly Linked List উল্টানো সম্পন্ন! নতুন হেড 4।",
  ),
];

const List<DebugArrayStep> ll4Steps = [
  DebugArrayStep(
    activeLineIndex: 1,
    pointer1: 0,
    pointer2: 0,
    array1D: [3, 2, 0, -4],
    explanationEn: "Line 2: Set slow = head (3), fast = head (3). Cycle exists: -4 -> 2.",
    explanationBn: "লাইন ২: slow = 3 এবং fast = 3 সেট। লিঙ্কড লিস্টে ৩->২->০->-৪->২ চক্র রয়েছে।",
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
    explanationBn: "🎉 লাইন ৬: চক্র শনাক্ত করা হয়েছে! Node 2 এ slow == fast! Return TRUE!",
  ),
];

// ─── GETTERS ──────────────────────────────────────────────────────────────────

List<String> getLinkedListCodeLines(String id) {
  if (id == "ll-2") return ll2CodeLines;
  if (id == "ll-3") return ll3CodeLines;
  if (id == "ll-4") return ll4CodeLines;
  return ll1CodeLines;
}

List<DebugArrayStep> getLinkedListSteps(String id) {
  if (id == "ll-2") return ll2Steps;
  if (id == "ll-3") return ll3Steps;
  if (id == "ll-4") return ll4Steps;
  return ll1Steps;
}
