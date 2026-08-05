import 'package:flutter/material.dart';

class DsaProblem {
  final String id;
  final String title;
  final String category; // e.g. "Queue Basic", "Deque Pattern"
  final String keyIdeaEn;
  final String keyIdeaBn;
  final String codeCpp;
  final String codeJava;
  final String codePython;
  final String codeJs;
  final String descriptionEn;
  final String descriptionBn;
  final List<String> sampleInputs;
  final List<String> sampleOutputs;

  const DsaProblem({
    required this.id,
    required this.title,
    required this.category,
    required this.keyIdeaEn,
    required this.keyIdeaBn,
    required this.codeCpp,
    required this.codeJava,
    required this.codePython,
    required this.codeJs,
    required this.descriptionEn,
    required this.descriptionBn,
    required this.sampleInputs,
    required this.sampleOutputs,
  });
}

class DsaTopic {
  final int id;
  final String title;
  final String category;
  final String timeComplexity;
  final String spaceComplexity;
  final String descriptionEn;
  final String descriptionBn;
  final IconData icon;
  final Color themeColor;
  final List<String> keyConceptsEn;
  final List<String> keyConceptsBn;
  final Map<String, Map<String, String>> multiDimCodeTemplates; // Variant (Queue, Circular Queue, Deque) -> (Language -> Code)
  final List<DsaProblem> basicProblems;
  final List<Map<String, String>> commonMistakesEn;
  final List<Map<String, String>> commonMistakesBn;
  final List<Map<String, String>> roadmapStepsEn;
  final List<Map<String, String>> roadmapStepsBn;

  const DsaTopic({
    required this.id,
    required this.title,
    required this.category,
    required this.timeComplexity,
    required this.spaceComplexity,
    required this.descriptionEn,
    required this.descriptionBn,
    required this.icon,
    required this.themeColor,
    required this.keyConceptsEn,
    required this.keyConceptsBn,
    required this.multiDimCodeTemplates,
    required this.basicProblems,
    required this.commonMistakesEn,
    required this.commonMistakesBn,
    required this.roadmapStepsEn,
    required this.roadmapStepsBn,
  });
}

class DsaDataRepository {
  static List<DsaTopic> getTopics() {
    return [
      // 1. ARRAYS & DYNAMIC LISTS
      DsaTopic(
        id: 201,
        title: "Arrays & Dynamic Lists",
        category: "Linear & Multi-Dimensional Structure",
        timeComplexity: "Access O(1) | Search O(N) | Insertion O(N)",
        spaceComplexity: "1D: O(N) | 2D: O(R×C) | 3D: O(D×R×C)",
        icon: Icons.view_column_outlined,
        themeColor: const Color(0xFF3B82F6),
        descriptionEn: "An Array is a contiguous memory allocation storing elements of the same type.",
        descriptionBn: "মেমোরিতে পরপর (Contiguous) সাজানো একই ধরনের উপাদানের স্ট্রাকচার।",
        keyConceptsEn: ["1D Dynamic Array", "2D Matrix", "3D Tensor"],
        keyConceptsBn: ["১D ডাইনামিক অ্যারে", "২D ম্যাট্রিক্স", "৩D টেনসর"],
        multiDimCodeTemplates: {
          "1D Array": {
            "C++": "vector<int> arr = {10, 20};",
            "Java": "ArrayList<Integer> list = new ArrayList<>();",
            "Python": "arr = [10, 20]",
            "JavaScript": "const arr = [10, 20];"
          }
        },
        basicProblems: [],
        commonMistakesEn: [],
        commonMistakesBn: [],
        roadmapStepsEn: [],
        roadmapStepsBn: [],
      ),

      // 2. SINGLY & DOUBLY LINKED LIST
      DsaTopic(
        id: 202,
        title: "Singly & Doubly Linked List",
        category: "Dynamic Pointer Structure",
        timeComplexity: "Head Insert/Delete: O(1) | Search: O(N)",
        spaceComplexity: "O(N)",
        icon: Icons.link_outlined,
        themeColor: const Color(0xFF8B5CF6),
        descriptionEn: "A Linked List is a linear data structure of heap-allocated Node objects connected via pointers.",
        descriptionBn: "লিঙ্কড লিস্ট হলো হিপ মেমোরিতে পয়েন্টার দ্বারা সংযুক্ত নোড অবজেক্টের লিনিয়ার সিকোয়েন্স।",
        keyConceptsEn: ["Singly Linked List", "Doubly Linked List", "Circular Linked List"],
        keyConceptsBn: ["Singly Linked List", "Doubly Linked List", "Circular Linked List"],
        multiDimCodeTemplates: {
          "Singly Linked List": {
            "C++": "struct Node { int val; Node* next; };",
            "Java": "class Node { int val; Node next; }",
            "Python": "class Node: pass",
            "JavaScript": "class Node {}"
          }
        },
        basicProblems: [],
        commonMistakesEn: [],
        commonMistakesBn: [],
        roadmapStepsEn: [],
        roadmapStepsBn: [],
      ),

      // 3. STACK (LIFO)
      DsaTopic(
        id: 203,
        title: "Stack (LIFO)",
        category: "Linear Container Structure",
        timeComplexity: "Push O(1) | Pop O(1) | Top/Peek O(1)",
        spaceComplexity: "O(N)",
        icon: Icons.layers_outlined,
        themeColor: const Color(0xFF10B981),
        descriptionEn: "A Stack is a linear data structure operating under the strict Last-In, First-Out (LIFO) discipline.",
        descriptionBn: "স্ট্যাক হলো একটি লিনিয়ার কন্টেইনার যা লাস্ট-ইন, ফার্স্ট-আউট (LIFO) নীতিতে কাজ করে।",
        keyConceptsEn: ["LIFO Discipline", "O(1) Push/Pop"],
        keyConceptsBn: ["LIFO নীতি", "O(1) পুশ/পপ"],
        multiDimCodeTemplates: {
          "Array-Based Stack": {
            "C++": "vector<int> st; st.push_back(10); st.pop_back();",
            "Java": "Deque<Integer> st = new ArrayDeque<>();",
            "Python": "st = []; st.append(10); st.pop()",
            "JavaScript": "const st = []; st.push(10); st.pop()"
          }
        },
        basicProblems: [],
        commonMistakesEn: [],
        commonMistakesBn: [],
        roadmapStepsEn: [],
        roadmapStepsBn: [],
      ),

      // 4. QUEUE (FIFO) & DEQUE
      DsaTopic(
        id: 204,
        title: "Queue (FIFO) & Deque",
        category: "Linear Pipeline Structure",
        timeComplexity: "Enqueue O(1) | Dequeue O(1) | Front O(1)",
        spaceComplexity: "O(N)",
        icon: Icons.swap_horizontal_circle_outlined,
        themeColor: const Color(0xFFF59E0B),
        descriptionEn:
            "A Queue is a linear pipeline operating under the strict First-In, First-Out (FIFO) discipline. Elements enter at the REAR and exit from the FRONT. A Double-Ended Queue (Deque) extends this by allowing insertions and deletions at BOTH Front and Rear ends in O(1) time. Operating systems use queues for BFS graph traversal, printer queues, and CPU task scheduling.",
        descriptionBn:
            "কিউ হলো একটি ফার্স্ট-ইন, ফার্স্ট-আউট (FIFO) লিনিয়ার পাইপলাইন। যে উপাদান প্রথমে ঢোকে, সে উপাদানই প্রথমে বের হয়। উপাদান যোগ হয় পেছনে (REAR) এবং বের হয় সামনে থেকে (FRONT)। ডাবল-এন্ডেড কিউ (Deque) সামনে ও পেছনে উভয় প্রান্তেই O(1) সময়ে যোগ ও বাদ দেওয়ার সুবিধা দেয়। এটি গ্রাফের BFS ট্রাভার্সাল, প্রিন্টার কিউ এবং CPU টাস্ক সিডিউলিংয়ে ব্যবহৃত হয়।",
        keyConceptsEn: [
          "FIFO Discipline: First item enqueued is the first item dequeued. Insert at REAR, remove from FRONT.",
          "O(1) Operations: `enqueue(val)` / `push_back`, `dequeue()` / `pop_front`, `front()`, `isEmpty()` all run in O(1).",
          "Circular Queue: Reuses array slots with modulo math `index = (rear + 1) % capacity`, eliminating O(N) element shifting.",
          "Double-Ended Queue (Deque): Supports `push_front`, `push_back`, `pop_front`, `pop_back` in O(1) time.",
          "BFS Traversal Engine: Breadth-First Search on trees and graphs uses a Queue to explore level by level."
        ],
        keyConceptsBn: [
          "FIFO নীতি: প্রথম যোগ করা উপাদানটিই প্রথমে বের হবে। ইনসার্ট হয় REAR এ, ডিলেট হয় FRONT থেকে।",
          "O(1) অপারেশন্স: `enqueue(val)` / `push_back`, `dequeue()` / `pop_front`, `front()`, এবং `isEmpty()` O(1) সময়ে সম্পন্ন হয়।",
          "সার্কুলার কিউ (Circular Queue): মডিউলাস সূত্র `index = (rear + 1) % capacity` দিয়ে মেমোরি খালি ঘর পুনর্ব্যবহার করে O(N) শিফটিং দূর করে।",
          "ডাবল-এন্ডেড কিউ (Deque): সামনে ও পেছনে উভয় মুখেই O(1) সময়ে ইনসার্ট ও ডিলেট করার সুবিধা দেয়।",
          "BFS ট্রাভার্সাল: গ্রাফ ও ট্রির লেভেল-বাই-লেভেল BFS সার্চের মূল ড্রাইভার হলো Queue।"
        ],
        multiDimCodeTemplates: {
          "Queue (FIFO)": {
            "C++": """
#include <iostream>
#include <queue>
using namespace std;

int main() {
    queue<int> q;
    
    // Enqueue at Rear O(1)
    q.push(10);
    q.push(20);
    q.push(30);
    
    // Read Front O(1)
    cout << "Front element: " << q.front() << endl; // 10
    
    // Dequeue from Front O(1)
    q.pop();
    cout << "New Front: " << q.front() << endl; // 20
    return 0;
}""",
            "Java": """
import java.util.ArrayDeque;
import java.util.Queue;

public class QueueDemo {
    public static void main(String[] args) {
        // Use ArrayDeque for O(1) FIFO Queue
        Queue<Integer> q = new ArrayDeque<>();
        
        // Enqueue O(1)
        q.offer(10);
        q.offer(20);
        
        // Peek Front O(1)
        System.out.println("Front: " + q.peek()); // 10
        
        // Dequeue Front O(1)
        q.poll();
        System.out.println("New Front: " + q.peek()); // 20
    }
}""",
            "Python": """
from collections import deque

# Python deque provides fast O(1) FIFO operations
q = deque()

# Enqueue Rear O(1)
q.append(10)
q.append(20)

# Peek Front O(1)
print("Front:", q[0]) # 10

# Dequeue Front O(1)
popped = q.popleft()
print("Dequeued:", popped) # 10
print("New Front:", q[0]) # 20""",
            "JavaScript": """
class Queue {
    constructor() {
        this.items = {};
        this.head = 0;
        this.tail = 0;
    }
    enqueue(element) {
        this.items[this.tail] = element;
        this.tail++;
    }
    dequeue() {
        if (this.isEmpty()) return null;
        const item = this.items[this.head];
        delete this.items[this.head];
        this.head++;
        return item;
    }
    front() {
        return this.items[this.head];
    }
    isEmpty() {
        return this.tail - this.head === 0;
    }
}

const q = new Queue();
q.enqueue(10); q.enqueue(20);
console.log("Front:", q.front()); // 10
q.dequeue();"""
          },
          "Circular Queue": {
            "C++": """
#include <iostream>
#include <vector>
using namespace std;

class MyCircularQueue {
    vector<int> data;
    int head, tail, size, capacity;
public:
    MyCircularQueue(int k) {
        capacity = k;
        data.resize(k);
        head = 0; tail = -1; size = 0;
    }
    bool enQueue(int value) {
        if (isFull()) return false;
        tail = (tail + 1) % capacity;
        data[tail] = value;
        size++;
        return true;
    }
    bool deQueue() {
        if (isEmpty()) return false;
        head = (head + 1) % capacity;
        size--;
        return true;
    }
    int Front() { return isEmpty() ? -1 : data[head]; }
    bool isEmpty() { return size == 0; }
    bool isFull() { return size == capacity; }
};""",
            "Java": """
class MyCircularQueue {
    private int[] data;
    private int head = 0, tail = -1, size = 0, capacity;
    
    public MyCircularQueue(int k) {
        capacity = k;
        data = new int[k];
    }
    public boolean enQueue(int value) {
        if (isFull()) return false;
        tail = (tail + 1) % capacity;
        data[tail] = value;
        size++;
        return true;
    }
    public boolean deQueue() {
        if (isEmpty()) return false;
        head = (head + 1) % capacity;
        size--;
        return true;
    }
    public int Front() { return isEmpty() ? -1 : data[head]; }
    public boolean isEmpty() { return size == 0; }
    public boolean isFull() { return size == capacity; }
}""",
            "Python": """
class MyCircularQueue:
    def __init__(self, k: int):
        self.capacity = k
        self.data = [0] * k
        self.head = 0
        self.tail = -1
        self.size = 0
        
    def enQueue(self, value: int) -> bool:
        if self.isFull(): return False
        self.tail = (self.tail + 1) % self.capacity
        self.data[self.tail] = value
        self.size += 1
        return True
        
    def deQueue(self) -> bool:
        if self.isEmpty(): return False
        self.head = (self.head + 1) % self.capacity
        self.size -= 1
        return True
        
    def Front(self) -> int:
        return -1 if self.isEmpty() else self.data[self.head]
        
    def isEmpty(self) -> bool: return self.size == 0
    def isFull(self) -> bool: return self.size == self.capacity""",
            "JavaScript": """
class MyCircularQueue {
    constructor(k) {
        this.capacity = k;
        this.data = new Array(k);
        this.head = 0;
        this.tail = -1;
        this.size = 0;
    }
    enQueue(value) {
        if (this.isFull()) return false;
        this.tail = (this.tail + 1) % this.capacity;
        this.data[this.tail] = value;
        this.size++;
        return true;
    }
    deQueue() {
        if (this.isEmpty()) return false;
        this.head = (this.head + 1) % this.capacity;
        this.size--;
        return true;
    }
    Front() { return this.isEmpty() ? -1 : this.data[this.head]; }
    isEmpty() { return this.size === 0; }
    isFull() { return this.size === this.capacity; }
}"""
          },
          "Double-Ended Queue (Deque)": {
            "C++": """
#include <iostream>
#include <deque>
using namespace std;

int main() {
    deque<int> dq;
    
    // O(1) Insert at both ends
    dq.push_back(20);  // 20
    dq.push_front(10); // 10 <-> 20
    dq.push_back(30);  // 10 <-> 20 <-> 30
    
    cout << "Front: " << dq.front() << ", Back: " << dq.back() << endl;
    
    // O(1) Pop from both ends
    dq.pop_front(); // Removes 10
    dq.pop_back();  // Removes 30
    return 0;
}""",
            "Java": """
import java.util.ArrayDeque;
import java.util.Deque;

public class DequeDemo {
    public static void main(String[] args) {
        Deque<Integer> dq = new ArrayDeque<>();
        
        dq.addFirst(10); // push_front
        dq.addLast(20);  // push_back
        dq.addLast(30);
        
        System.out.println("Front: " + dq.peekFirst() + ", Back: " + dq.peekLast());
        
        dq.removeFirst(); // pop_front
        dq.removeLast();  // pop_back
    }
}""",
            "Python": """
from collections import deque

dq = deque()

# O(1) Push Front & Back
dq.appendleft(10)
dq.append(20)
dq.append(30)

print("Front:", dq[0], "Back:", dq[-1])

# O(1) Pop Front & Back
dq.popleft() # Removes 10
dq.pop()     # Removes 30""",
            "JavaScript": """
// Deque in JS using ArrayDeque simulation
class Deque {
    constructor() {
        this.items = [];
    }
    pushFront(val) { this.items.unshift(val); }
    pushBack(val) { this.items.push(val); }
    popFront() { return this.items.shift(); }
    popBack() { return this.items.pop(); }
    peekFront() { return this.items[0]; }
    peekBack() { return this.items[this.items.length - 1]; }
}

const dq = new Deque();
dq.pushFront(10); dq.pushBack(20);
console.log("Front:", dq.peekFront(), "Back:", dq.peekBack());"""
          }
        },
        basicProblems: [
          DsaProblem(
            id: "q-1",
            title: "1. Implement Queue using 2 Stacks",
            category: "Queue Design",
            keyIdeaEn: "Use inputStack for push, and outputStack for pop. When outputStack is empty, transfer all items from inputStack.",
            keyIdeaBn: "ইনপুটের জন্য inputStack এবং পপের জন্য outputStack ব্যবহার করুন। পপ করার সময় outputStack খালি হলে সব উপাদান রিভার্স ট্রান্সফার করুন।",
            codeCpp: """
class MyQueue {
    stack<int> inSt, outSt;
public:
    void push(int x) { inSt.push(x); }
    int pop() {
        peek();
        int val = outSt.top(); outSt.pop();
        return val;
    }
    int peek() {
        if (outSt.empty()) {
            while (!inSt.empty()) {
                outSt.push(inSt.top());
                inSt.pop();
            }
        }
        return outSt.top();
    }
    bool empty() { return inSt.empty() && outSt.empty(); }
};""",
            codeJava: """
class MyQueue {
    private Deque<Integer> inSt = new ArrayDeque<>();
    private Deque<Integer> outSt = new ArrayDeque<>();
    
    public void push(int x) { inSt.push(x); }
    public int pop() {
        peek();
        return outSt.pop();
    }
    public int peek() {
        if (outSt.isEmpty()) {
            while (!inSt.isEmpty()) {
                outSt.push(inSt.pop());
            }
        }
        return outSt.peek();
    }
    public boolean empty() { return inSt.isEmpty() && outSt.isEmpty(); }
}""",
            codePython: """
class MyQueue:
    def __init__(self):
        self.in_st = []
        self.out_st = []
        
    def push(self, x: int) -> None:
        self.in_st.append(x)
        
    def pop(self) -> int:
        self.peek()
        return self.out_st.pop()
        
    def peek(self) -> int:
        if not self.out_st:
            while self.in_st:
                self.out_st.append(self.in_st.pop())
        return self.out_st[-1]
        
    def empty(self) -> bool:
        return not self.in_st and not self.out_st""",
            codeJs: """
class MyQueue {
    constructor() {
        this.inSt = [];
        this.outSt = [];
    }
    push(x) { this.inSt.push(x); }
    pop() {
        this.peek();
        return this.outSt.pop();
    }
    peek() {
        if (this.outSt.length === 0) {
            while (this.inSt.length > 0) {
                this.outSt.push(this.inSt.pop());
            }
        }
        return this.outSt[this.outSt.length - 1];
    }
    empty() { return this.inSt.length === 0 && this.outSt.length === 0; }
}""",
            descriptionEn: "Implement a First-In, First-Out (FIFO) queue using only two standard LIFO stacks.",
            descriptionBn: "শুধুমাত্র ২টি LIFO স্ট্যাক ব্যবহার করে একটি FIFO কিউ ইমপ্লিমেন্ট করুন।",
            sampleInputs: ["push(1), push(2), peek(), pop(), empty()"],
            sampleOutputs: ["peek(): 1, pop(): 1, empty(): false"],
          ),
          DsaProblem(
            id: "q-2",
            title: "2. First Non-Repeating Character in Stream",
            category: "Queue Basic",
            keyIdeaEn: "Store frequency array and push characters to Queue. Pop queue front while frequency > 1.",
            keyIdeaBn: "ফ্রিকোয়েন্সি অ্যারে এবং কিউ ব্যবহার করুন। কিউয়ের ফ্রন্টের ফ্রিকোয়েন্সি ১ এর বেশি হলে পপ করতে থাকুন।",
            codeCpp: """
string firstNonRepeating(string s) {
    unordered_map<char, int> freq;
    queue<char> q;
    string res = "";
    for (char c : s) {
        freq[c]++;
        q.push(c);
        while (!q.empty() && freq[q.front()] > 1) q.pop();
        if (q.empty()) res += '#';
        else res += q.front();
    }
    return res;
}""",
            codeJava: """
public static String firstNonRepeating(String s) {
    Map<Character, Integer> freq = new HashMap<>();
    Queue<Character> q = new ArrayDeque<>();
    StringBuilder res = new StringBuilder();
    for (char c : s.toCharArray()) {
        freq.put(c, freq.getOrDefault(c, 0) + 1);
        q.offer(c);
        while (!q.isEmpty() && freq.get(q.peek()) > 1) q.poll();
        if (q.isEmpty()) res.append('#');
        else res.append(q.peek());
    }
    return res.toString();
}""",
            codePython: """
from collections import deque, Counter

def firstNonRepeating(s):
    freq = Counter()
    q = deque()
    res = []
    for c in s:
        freq[c] += 1
        q.append(c)
        while q and freq[q[0]] > 1:
            q.popleft()
        res.append(q[0] if q else '#')
    return "".join(res)""",
            codeJs: """
function firstNonRepeating(s) {
    const freq = {};
    const q = [];
    let res = "";
    for (let c of s) {
        freq[c] = (freq[c] || 0) + 1;
        q.push(c);
        while (q.length > 0 && freq[q[0]] > 1) q.shift();
        res += q.length === 0 ? '#' : q[0];
    }
    return res;
}""",
            descriptionEn: "Find the first non-repeating character at each step in a continuous character stream.",
            descriptionBn: "একটি কন্টিনিউয়াস স্ট্রিমে প্রতিটি ধাপে প্রথম রিপিট না হওয়া ক্যারেক্টারটি খুঁজুন।",
            sampleInputs: ["s = \"aabccxb\""],
            sampleOutputs: ["\"a#bbbbx\""],
          ),
          DsaProblem(
            id: "q-3",
            title: "3. Sliding Window Maximum using Deque",
            category: "Deque Pattern",
            keyIdeaEn: "Maintain a monotonically decreasing Deque storing indices. Pop back indices smaller than current item; pop front if outside window.",
            keyIdeaBn: "একটি Monotonic Decreasing Deque বজায় রাখুন। কারেন্ট এলিমেন্টের চেয়ে ছোট ইনডেক্স ব্যাক থেকে এবং উইন্ডোর বাইরের ইনডেক্স ফ্রন্ট থেকে পপ করুন।",
            codeCpp: """
vector<int> maxSlidingWindow(vector<int>& nums, int k) {
    deque<int> dq;
    vector<int> res;
    for (int i = 0; i < nums.size(); i++) {
        if (!dq.empty() && dq.front() == i - k) dq.pop_front();
        while (!dq.empty() && nums[dq.back()] < nums[i]) dq.pop_back();
        dq.push_back(i);
        if (i >= k - 1) res.push_back(nums[dq.front()]);
    }
    return res;
}""",
            codeJava: """
public static int[] maxSlidingWindow(int[] nums, int k) {
    int n = nums.length;
    int[] res = new int[n - k + 1];
    Deque<Integer> dq = new ArrayDeque<>();
    for (int i = 0; i < n; i++) {
        if (!dq.isEmpty() && dq.peekFirst() == i - k) dq.pollFirst();
        while (!dq.isEmpty() && nums[dq.peekLast()] < nums[i]) dq.pollLast();
        dq.offerLast(i);
        if (i >= k - 1) res[i - k + 1] = nums[dq.peekFirst()];
    }
    return res;
}""",
            codePython: """
from collections import deque

def maxSlidingWindow(nums, k):
    dq = deque()
    res = []
    for i, num in enumerate(nums):
        if dq and dq[0] == i - k:
            dq.popleft()
        while dq and nums[dq[-1]] < num:
            dq.pop()
        dq.append(i)
        if i >= k - 1:
            res.append(nums[dq[0]])
    return res""",
            codeJs: """
function maxSlidingWindow(nums, k) {
    const dq = [];
    const res = [];
    for (let i = 0; i < nums.length; i++) {
        if (dq.length > 0 && dq[0] === i - k) dq.shift();
        while (dq.length > 0 && nums[dq[dq.length - 1]] < nums[i]) dq.pop();
        dq.push(i);
        if (i >= k - 1) res.push(nums[dq[0]]);
    }
    return res;
}""",
            descriptionEn: "Find the maximum element in each sliding window of size `k` moving from left to right in O(N) time.",
            descriptionBn: "সাইজ `k` এর স্লাইডিং উইন্ডো ডানে সরানোর সাথে সাথে O(N) সময়ে সর্বোচ্চ উপাদানটি বের করুন।",
            sampleInputs: ["nums = [1,3,-1,-3,5,3,6,7], k = 3"],
            sampleOutputs: ["[3, 3, 5, 5, 6, 7]"],
          ),
        ],
        commonMistakesEn: [
          {
            "title": "1. Inefficient O(N) Array Shifting Dequeue",
            "desc": "Calling `arr.shift()` or `list.remove(0)` inside N loops causes hidden quadratic O(N²) time complexity. Use `ArrayDeque` or `Circular Queue`."
          },
          {
            "title": "2. Queue Underflow Exception",
            "desc": "Calling `dequeue()` or `front()` on an empty queue triggers runtime errors."
          },
          {
            "title": "3. Confusing FRONT and REAR Index Pointers",
            "desc": "Swapping FRONT and REAR pointer assignment in Circular Queue logic distorts item order."
          },
          {
            "title": "4. Missing Window Expiry Check in Deque",
            "desc": "Forgetting to evict stale indices `dq.front() == i - k` in Sliding Window Maximum algorithm."
          }
        ],
        commonMistakesBn: [
          {
            "title": "১. অ্যারের ওয়ান ডিলেশনে O(N²) লুকানো সময় নষ্ট",
            "desc": "লুপের ভেতর `list.remove(0)` বা `shift()` কল করলে প্রতিটি উপাদান বামে সরানোর কারণে O(N²) সময় নষ্ট হয়। `ArrayDeque` ব্যবহার করুন।"
          },
          {
            "title": "২. কিউ আন্ডারফ্লো ভুল",
            "desc": "খালি কিউ থেকে `dequeue()` করতে গেলে রানটাইম এক্সেপশন ঘটে।"
          },
          {
            "title": "৩. FRONT এবং REAR পয়েন্টারে উল্টাপাল্টা",
            "desc": "সার্কুলার কিউ তে FRONT এবং REAR এর পয়েন্টার আপডেট গুলিয়ে ফেললে ডেটার অর্ডার নষ্ট হয়।"
          },
          {
            "title": "৪. স্লাইডিং উইন্ডোতে পুরানো ইনডেক্স সরাতে ভুলে যাওয়া",
            "desc": "স্লাইডিং উইন্ডো মেথডে `dq.front() == i - k` উইন্ডো আউট হওয়া ইনডেক্স না মুছলে ভুল রেজাল্ট আসে।"
          }
        ],
        roadmapStepsEn: [
          {
            "step": "Step 1",
            "title": "Understand FIFO Discipline & Core Operations",
            "desc": "Master enqueue, dequeue, front, rear, and difference between Queue and Stack."
          },
          {
            "step": "Step 2",
            "title": "Master Circular Queue Implementation",
            "desc": "Learn modulo index math `(rear + 1) % capacity` to build memory-efficient circular queue."
          },
          {
            "step": "Step 3",
            "title": "Understand Double-Ended Queue (Deque)",
            "desc": "Master push_front, push_back, pop_front, pop_back operations in O(1) time."
          },
          {
            "step": "Step 4",
            "title": "Implement Queue using 2 Stacks & Stream Buffers",
            "desc": "Solve queue using 2 stacks, stream non-repeating character, and print job queue."
          },
          {
            "step": "Step 5",
            "title": "Master Sliding Window Maximum & Monotonic Deque",
            "desc": "Solve sliding window max using monotonic deque and prepare for BFS graph traversal."
          }
        ],
        roadmapStepsBn: [
          {
            "step": "ধাপ ১",
            "title": "FIFO নীতি ও মূল কিউ অপারেশন শিখুন",
            "desc": "Enqueue, Dequeue, Front, Rear এবং স্ট্যাক ও কিউয়ের পার্থক্য পরিষ্কার করুন।"
          },
          {
            "step": "ধাপ ২",
            "title": "সার্কুলার কিউ (Circular Queue) আয়ত্ত করুন",
            "desc": "মডিউলাস সূত্র `(rear + 1) % capacity` দিয়ে মেমোরি-দক্ষ সার্কুলার কিউ তৈরি করা শিখুন।"
          },
          {
            "step": "ধাপ ৩",
            "title": "ডাবল-এন্ডেড কিউ (Deque) মাস্টার করুন",
            "desc": "সামনে ও পেছনে O(1) ইনসার্ট ও ডিলেশনের `push_front`, `pop_front`, `push_back`, `pop_back` প্রয়োগ।"
          },
          {
            "step": "ধাপ ৪",
            "title": "২টি স্ট্যাক দিয়ে Queue ও স্ট্রিম বাফার সলভ করুন",
            "desc": "২টি স্ট্যাক দিয়ে কিউ ডিজাইন এবং স্ট্রিমে প্রথম নন-রিপিটিং অক্ষর ডিটেক্ট করা প্র্যাকটিস করুন।"
          },
          {
            "step": "ধাপ ৫",
            "title": "স্লাইডিং উইন্ডো ম্যাক্সিমাম ও Monotonic Deque",
            "desc": "Monotonic Deque দিয়ে স্লাইডিং উইন্ডো ম্যাক্সিমাম সলভ করুন এবং BFS গ্রাফ ট্রাভার্সালের জন্য তৈরি হন।"
          }
        ],
      ),

      // 5. HASH TABLE
      DsaTopic(
        id: 205,
        title: "Hash Table & Hash Map",
        category: "Associative Array",
        timeComplexity: "Lookup O(1) avg",
        spaceComplexity: "O(N)",
        icon: Icons.grid_view_outlined,
        themeColor: const Color(0xFFEC4899),
        descriptionEn: "Key-Value lookup table.",
        descriptionBn: "কী-ভ্যালু পেয়ার লুপআপ টেবিল।",
        keyConceptsEn: ["Hash key mapping"],
        keyConceptsBn: ["হ্যাশ কী গণনা"],
        multiDimCodeTemplates: {
          "Hash Table": {
            "C++": "unordered_map<string, int> mp;",
            "Java": "HashMap<String, Integer> map = new HashMap<>();",
            "Python": "mp = {}",
            "JavaScript": "const map = new Map();"
          }
        },
        basicProblems: [],
        commonMistakesEn: [],
        commonMistakesBn: [],
        roadmapStepsEn: [],
        roadmapStepsBn: [],
      ),

      // 6. BST
      DsaTopic(
        id: 206,
        title: "Binary Search Tree (BST)",
        category: "Hierarchical",
        timeComplexity: "Search O(log N)",
        spaceComplexity: "O(N)",
        icon: Icons.account_tree_outlined,
        themeColor: const Color(0xFF06B6D4),
        descriptionEn: "Left < Root < Right tree.",
        descriptionBn: "বাম পাশে ছোট ও ডান পাশে বড় মান।",
        keyConceptsEn: ["Ordered BST"],
        keyConceptsBn: ["সর্টেড বাইনারি ট্রি"],
        multiDimCodeTemplates: {
          "BST": {
            "C++": "struct TreeNode { int val; TreeNode *left, *right; };",
            "Java": "class TreeNode { int val; TreeNode left, right; }",
            "Python": "class TreeNode: pass",
            "JavaScript": "class TreeNode {}"
          }
        },
        basicProblems: [],
        commonMistakesEn: [],
        commonMistakesBn: [],
        roadmapStepsEn: [],
        roadmapStepsBn: [],
      ),

      // 7. HEAP
      DsaTopic(
        id: 207,
        title: "Min & Max Heap (Priority Queue)",
        category: "Priority Structure",
        timeComplexity: "Peek O(1)",
        spaceComplexity: "O(N)",
        icon: Icons.unfold_more_double_outlined,
        themeColor: const Color(0xFF84CC16),
        descriptionEn: "Priority binary tree.",
        descriptionBn: "প্রাইওরিটি কিউ ট্র্যাকিং।",
        keyConceptsEn: ["Heap invariant"],
        keyConceptsBn: ["হিপ ইনভেরিয়েন্ট"],
        multiDimCodeTemplates: {
          "Heap": {
            "C++": "priority_queue<int> maxHeap;",
            "Java": "PriorityQueue<Integer> pq = new PriorityQueue<>();",
            "Python": "import heapq",
            "JavaScript": "class MinHeap {}"
          }
        },
        basicProblems: [],
        commonMistakesEn: [],
        commonMistakesBn: [],
        roadmapStepsEn: [],
        roadmapStepsBn: [],
      ),

      // 8. GRAPH
      DsaTopic(
        id: 208,
        title: "Graph (Adjacency List & Matrix)",
        category: "Non-Linear Network",
        timeComplexity: "BFS/DFS O(V + E)",
        spaceComplexity: "O(V + E)",
        icon: Icons.hub_outlined,
        themeColor: const Color(0xFF0284C7),
        descriptionEn: "Network of vertices and edges.",
        descriptionBn: "নোড এবং এজের গ্রাফ নেটওয়ার্ক।",
        keyConceptsEn: ["Graph BFS/DFS"],
        keyConceptsBn: ["গ্রাফ ট্রাভার্সাল"],
        multiDimCodeTemplates: {
          "Graph": {
            "C++": "vector<vector<int>> adj;",
            "Java": "List<List<Integer>> adj = new ArrayList<>();",
            "Python": "adj = collections.defaultdict(list)",
            "JavaScript": "const adj = {};"
          }
        },
        basicProblems: [],
        commonMistakesEn: [],
        commonMistakesBn: [],
        roadmapStepsEn: [],
        roadmapStepsBn: [],
      ),

      // 9. TRIE
      DsaTopic(
        id: 209,
        title: "Trie (Prefix Tree)",
        category: "Advanced Tree",
        timeComplexity: "Search O(L)",
        spaceComplexity: "O(N * L)",
        icon: Icons.sort_by_alpha_outlined,
        themeColor: const Color(0xFFA855F7),
        descriptionEn: "Character prefix tree.",
        descriptionBn: "অক্ষরভিত্তিক প্রিফিক্স ট্রি।",
        keyConceptsEn: ["Prefix tree branches"],
        keyConceptsBn: ["শব্দ খোঁজার ট্রি"],
        multiDimCodeTemplates: {
          "Trie": {
            "C++": "class TrieNode { unordered_map<char, TrieNode*> children; };",
            "Java": "class TrieNode { TrieNode[] children = new TrieNode[26]; }",
            "Python": "class TrieNode: pass",
            "JavaScript": "class TrieNode {}"
          }
        },
        basicProblems: [],
        commonMistakesEn: [],
        commonMistakesBn: [],
        roadmapStepsEn: [],
        roadmapStepsBn: [],
      ),
    ];
  }
}
