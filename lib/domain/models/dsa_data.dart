import 'package:flutter/material.dart';

class DsaProblem {
  final String id;
  final String title;
  final String category; // e.g. "Stack Basic", "Monotonic Stack"
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
  final Map<String, Map<String, String>> multiDimCodeTemplates; // Variant (Array-Based, Linked-List-Based, Monotonic) -> (Language -> Code)
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
        descriptionEn:
            "A Stack is a linear data structure operating under the strict Last-In, First-Out (LIFO) discipline. Elements can only be inserted (push) or removed (pop) from one end called the TOP. Runtimes and operating systems rely heavily on the execution Call Stack to manage function calls, local variables, and recursion frame allocation.",
        descriptionBn:
            "স্ট্যাক হলো একটি লিনিয়ার কন্টেইনার যা লাস্ট-ইন, ফার্স্ট-আউট (LIFO) নীতিতে কাজ করে। সব উপাদান যোগ (push) এবং অপসারণ (pop) কেবল এর উপরের প্রান্ত (TOP) দিয়ে হয়। অপারেটিং সিস্টেম ও ল্যাঙ্গুয়েজ রানটাইম ফাংশন কল, লোকাল ভ্যারিয়েবল এবং রিকার্সন ফ্রেম ট্র্যাকিংয়ের জন্য Execution Call Stack ব্যবহার করে।",
        keyConceptsEn: [
          "LIFO Discipline: The last element pushed onto the stack is the first element popped out.",
          "O(1) Constant Operations: `push(val)`, `pop()`, `top()` / `peek()`, and `isEmpty()` all execute in O(1) time.",
          "Call Stack & Recursion: Function invocation frames are pushed onto the system stack and popped when returning.",
          "Stack Overflow vs Underflow: Overflow occurs when exceeding maximum stack depth limit; Underflow happens when popping an empty stack.",
          "Array vs Linked List Stack: Array implementation offers cache locality; Linked List implementation guarantees unbounded dynamic growth."
        ],
        keyConceptsBn: [
          "LIFO নীতি: সর্বশেষ যে উপাদানটি যোগ করা হয়, সেটিই প্রথমে বের হয়ে আসে।",
          "O(1) সময়ে কাজ: `push(val)`, `pop()`, `top()` / `peek()`, এবং `isEmpty()` অপারেশনগুলো মুহূর্তেই O(1) সময়ে শেষ হয়।",
          "কল স্ট্যাক ও রিকার্সন: ফাংশন ইনভোকেশন ফ্রেম সিস্টেম স্ট্যাকে পুশ হয় এবং ফাংশন শেষ হলে পপ হয়।",
          "স্ট্যাক ওভারফ্লো বনাম আন্ডারফ্লো: অতিরিক্ত ডেটায় লিমিট পার হলে Overflow এবং খালি স্ট্যাক থেকে পপ করতে গেলে Underflow ঘটে।",
          "অ্যারে বনাম লিঙ্কড লিস্ট স্ট্যাক: অ্যারে ভিত্তিক স্ট্যাক ক্যাশ লোকালিটি দেয়; লিঙ্কড লিস্ট ভিত্তিক স্ট্যাক স্বাধীন ডায়নামিক বৃদ্ধি নিশ্চিত করে।"
        ],
        multiDimCodeTemplates: {
          "Array-Based Stack": {
            "C++": """
#include <iostream>
#include <vector>
using namespace std;

class Stack {
    vector<int> arr;
public:
    void push(int val) {
        arr.push_back(val); // O(1)
    }
    void pop() {
        if (!isEmpty()) arr.pop_back(); // O(1)
    }
    int top() {
        if (!isEmpty()) return arr.back();
        return -1;
    }
    bool isEmpty() {
        return arr.empty();
    }
};

int main() {
    Stack st;
    st.push(10);
    st.push(20);
    cout << "Top: " << st.top() << endl; // 20
    st.pop();
    cout << "Top after pop: " << st.top() << endl; // 10
    return 0;
}""",
            "Java": """
import java.util.ArrayDeque;
import java.util.Deque;

public class StackDemo {
    public static void main(String[] args) {
        // Recommended in Java instead of legacy Stack class
        Deque<Integer> stack = new ArrayDeque<>();
        
        // Push O(1)
        stack.push(10);
        stack.push(20);
        
        // Peek O(1)
        System.out.println("Top: " + stack.peek()); // 20
        
        // Pop O(1)
        stack.pop();
        System.out.println("Top after pop: " + stack.peek()); // 10
    }
}""",
            "Python": """
# Python list used as LIFO Stack
stack = []

# Push O(1)
stack.append(10)
stack.append(20)

# Peek O(1)
print("Top:", stack[-1]) # 20

# Pop O(1)
top_item = stack.pop()
print("Popped:", top_item) # 20
print("Top after pop:", stack[-1]) # 10""",
            "JavaScript": """
class Stack {
    constructor() {
        this.items = [];
    }
    push(element) {
        this.items.push(element); // O(1)
    }
    pop() {
        if (this.isEmpty()) return "Underflow";
        return this.items.pop(); // O(1)
    }
    peek() {
        return this.items[this.items.length - 1];
    }
    isEmpty() {
        return this.items.length === 0;
    }
}

const st = new Stack();
st.push(10); st.push(20);
console.log("Top:", st.peek()); // 20
st.pop();"""
          },
          "Linked-List Stack": {
            "C++": """
#include <iostream>
using namespace std;

struct Node {
    int val;
    Node* next;
    Node(int v) : val(v), next(nullptr) {}
};

class LinkedListStack {
    Node* topNode = nullptr;
public:
    void push(int val) {
        Node* newNode = new Node(val);
        newNode->next = topNode;
        topNode = newNode; // O(1) Insert at Head
    }
    void pop() {
        if (topNode == nullptr) return;
        Node* temp = topNode;
        topNode = topNode->next;
        delete temp; // O(1) Remove Head
    }
    int peek() {
        return topNode ? topNode->val : -1;
    }
};""",
            "Java": """
class Node {
    int val;
    Node next;
    Node(int val) { this.val = val; }
}

public class LLStack {
    private Node topNode = null;
    
    public void push(int val) {
        Node newNode = new Node(val);
        newNode.next = topNode;
        topNode = newNode;
    }
    
    public int pop() {
        if (topNode == null) return -1;
        int val = topNode.val;
        topNode = topNode.next;
        return val;
    }
}""",
            "Python": """
class Node:
    def __init__(self, val=0, next=None):
        self.val = val
        self.next = next

class LLStack:
    def __init__(self):
        self.top_node = None
        
    def push(self, val):
        new_node = Node(val, self.top_node)
        self.top_node = new_node
        
    def pop(self):
        if not self.top_node: return None
        val = self.top_node.val
        self.top_node = self.top_node.next
        return val""",
            "JavaScript": """
class Node {
    constructor(val = 0, next = null) {
        this.val = val;
        this.next = next;
    }
}

class LLStack {
    constructor() {
        this.topNode = null;
    }
    push(val) {
        this.topNode = new Node(val, this.topNode);
    }
    pop() {
        if (!this.topNode) return null;
        let val = this.topNode.val;
        this.topNode = this.topNode.next;
        return val;
    }
}"""
          },
          "Monotonic Stack": {
            "C++": """
// Monotonic Increasing Stack Example
#include <iostream>
#include <vector>
#include <stack>
using namespace std;

vector<int> nextGreaterElement(vector<int>& nums) {
    int n = nums.size();
    vector<int> res(n, -1);
    stack<int> st; // Stores indices
    
    for (int i = 0; i < n; i++) {
        while (!st.empty() && nums[st.top()] < nums[i]) {
            res[st.top()] = nums[i];
            st.pop();
        }
        st.push(i);
    }
    return res;
}""",
            "Java": """
import java.util.*;

public class MonotonicStack {
    public static int[] nextGreaterElement(int[] nums) {
        int n = nums.length;
        int[] res = new int[n];
        Arrays.fill(res, -1);
        Deque<Integer> st = new ArrayDeque<>();
        
        for (int i = 0; i < n; i++) {
            while (!st.isEmpty() && nums[st.peek()] < nums[i]) {
                res[st.pop()] = nums[i];
            }
            st.push(i);
        }
        return res;
    }
}""",
            "Python": """
def nextGreaterElement(nums):
    res = [-1] * len(nums)
    st = [] # stores indices
    for i, num in enumerate(nums):
        while st and nums[st[-1]] < num:
            res[st.pop()] = num
        st.append(i)
    return res""",
            "JavaScript": """
function nextGreaterElement(nums) {
    const res = new Array(nums.length).fill(-1);
    const st = [];
    for (let i = 0; i < nums.length; i++) {
        while (st.length > 0 && nums[st[st.length - 1]] < nums[i]) {
            res[st.pop()] = nums[i];
        }
        st.push(i);
    }
    return res;
}"""
          }
        },
        basicProblems: [
          DsaProblem(
            id: "st-1",
            title: "1. Valid Parentheses (Balanced Brackets)",
            category: "Stack Basic",
            keyIdeaEn: "Push opening brackets `(`, `{`, `[` onto Stack. On closing bracket, pop and check matching bracket.",
            keyIdeaBn: "ওপেনিং ব্র্যাকেট হলে স্ট্যাকে পুশ করুন। ক্লোজিং ব্র্যাকেটে পপ করে জোড়া মিলান।",
            codeCpp: """
bool isValid(string s) {
    stack<char> st;
    for (char c : s) {
        if (c == '(' || c == '{' || c == '[') {
            st.push(c);
        } else {
            if (st.empty()) return false;
            char top = st.top(); st.pop();
            if ((c == ')' && top != '(') || 
                (c == '}' && top != '{') || 
                (c == ']' && top != '[')) return false;
        }
    }
    return st.empty();
}""",
            codeJava: """
public static boolean isValid(String s) {
    Deque<Character> st = new ArrayDeque<>();
    for (char c : s.toCharArray()) {
        if (c == '(' || c == '{' || c == '[') st.push(c);
        else {
            if (st.isEmpty()) return false;
            char top = st.pop();
            if ((c == ')' && top != '(') || 
                (c == '}' && top != '{') || 
                (c == ']' && top != '[')) return false;
        }
    }
    return st.isEmpty();
}""",
            codePython: """
def isValid(s):
    st = []
    mapping = {')': '(', '}': '{', ']': '['}
    for char in s:
        if char in mapping.values():
            st.append(char)
        elif char in mapping:
            if not st or st.pop() != mapping[char]:
                return False
    return len(st) == 0""",
            codeJs: """
function isValid(s) {
    const st = [];
    const map = {')': '(', '}': '{', ']': '['};
    for (let c of s) {
        if (c === '(' || c === '{' || c === '[') st.push(c);
        else {
            if (st.length === 0 || st.pop() !== map[c]) return false;
        }
    }
    return st.length === 0;
}""",
            descriptionEn: "Given a string `s` containing brackets `()`, `{}`, `[]`, determine if input string is valid.",
            descriptionBn: "ব্র্যাকেট সংবলিত একটি স্ট্রিং `s` ব্যালেন্সড ও ভ্যালিড কিনা স্ট্যাক দিয়ে পরীক্ষা করুন।",
            sampleInputs: ["s = \"()[]{}\"", "s = \"(]\""],
            sampleOutputs: ["true", "false"],
          ),
          DsaProblem(
            id: "st-2",
            title: "2. Reverse String / Array using Stack",
            category: "Stack Basic",
            keyIdeaEn: "Push all characters onto Stack sequentially, then pop elements out to construct reversed string.",
            keyIdeaBn: "সব ক্যারেক্টার স্ট্যাকে পুশ করুন, তারপর পরপর পপ করে রিভার্স স্ট্রিং তৈরি করুন।",
            codeCpp: """
string reverseString(string s) {
    stack<char> st;
    for (char c : s) st.push(c);
    string reversed = "";
    while (!st.empty()) {
        reversed += st.top();
        st.pop();
    }
    return reversed;
}""",
            codeJava: """
public static String reverseString(String s) {
    Deque<Character> st = new ArrayDeque<>();
    for (char c : s.toCharArray()) st.push(c);
    StringBuilder sb = new StringBuilder();
    while (!st.isEmpty()) sb.append(st.pop());
    return sb.toString();
}""",
            codePython: """
def reverseString(s):
    st = list(s)
    res = []
    while st:
        res.append(st.pop())
    return "".join(res)""",
            codeJs: """
function reverseString(s) {
    const st = s.split('');
    let res = "";
    while (st.length > 0) {
        res += st.pop();
    }
    return res;
}""",
            descriptionEn: "Reverse characters of a string utilizing the LIFO property of a Stack.",
            descriptionBn: "স্ট্যাকের LIFO ধর্ম ব্যবহার করে একটি স্ট্রিংয়ের ক্যারেক্টার উল্টিয়ে ফেলুন।",
            sampleInputs: ["s = \"algorithmix\""],
            sampleOutputs: ["\"ximrohtigla\""],
          ),
          DsaProblem(
            id: "st-3",
            title: "3. Evaluate Reverse Polish Notation (Postfix)",
            category: "Stack Basic",
            keyIdeaEn: "Push numbers onto Stack. When encountering an operator `+ - * /`, pop 2 numbers, apply operation, and push result.",
            keyIdeaBn: "সংখ্যা হলে স্ট্যাকে পুশ করুন। অপারেটর (+ - * /) আসলে ২টি সংখ্যা পপ করে হিসাব করে রেজাল্ট পুশ করুন।",
            codeCpp: """
int evalRPN(vector<string>& tokens) {
    stack<int> st;
    for (string& t : tokens) {
        if (t == "+" || t == "-" || t == "*" || t == "/") {
            int b = st.top(); st.pop();
            int a = st.top(); st.pop();
            if (t == "+") st.push(a + b);
            else if (t == "-") st.push(a - b);
            else if (t == "*") st.push(a * b);
            else if (t == "/") st.push(a / b);
        } else {
            st.push(stoi(t));
        }
    }
    return st.top();
}""",
            codeJava: """
public static int evalRPN(String[] tokens) {
    Deque<Integer> st = new ArrayDeque<>();
    for (String t : tokens) {
        if (t.equals("+") || t.equals("-") || t.equals("*") || t.equals("/")) {
            int b = st.pop();
            int a = st.pop();
            if (t.equals("+")) st.push(a + b);
            else if (t.equals("-")) st.push(a - b);
            else if (t.equals("*")) st.push(a * b);
            else if (t.equals("/")) st.push(a / b);
        } else st.push(Integer.parseInt(t));
    }
    return st.peek();
}""",
            codePython: """
def evalRPN(tokens):
    st = []
    for t in tokens:
        if t in "+-*/":
            b, a = st.pop(), st.pop()
            if t == '+': st.append(a + b)
            elif t == '-': st.append(a - b)
            elif t == '*': st.append(a * b)
            elif t == '/': st.append(int(a / b))
        else:
            st.append(int(t))
    return st[0]""",
            codeJs: """
function evalRPN(tokens) {
    const st = [];
    for (let t of tokens) {
        if (["+", "-", "*", "/"].includes(t)) {
            let b = st.pop();
            let a = st.pop();
            if (t === "+") st.push(a + b);
            else if (t === "-") st.push(a - b);
            else if (t === "*") st.push(a * b);
            else if (t === "/") st.push(Math.trunc(a / b));
        } else {
            st.push(Number(t));
        }
    }
    return st[0];
}""",
            descriptionEn: "Evaluate arithmetic value of an expression in Reverse Polish Notation (Postfix).",
            descriptionBn: "রিভার্স পোলিশ নোটেশন (পোস্টফিক্স) গাণিতিক এক্সপ্রেশনের ফলাফল স্ট্যাক দিয়ে মান নির্ণয় করুন।",
            sampleInputs: ["tokens = [\"2\",\"1\",\"+\",\"3\",\"*\"]"],
            sampleOutputs: ["9 ((2 + 1) * 3)"],
          ),
          DsaProblem(
            id: "st-4",
            title: "4. Min Stack (O(1) Min Element Access)",
            category: "Stack Design",
            keyIdeaEn: "Maintain an auxiliary `minStack` alongside main stack to track minimum element at each level in O(1) time.",
            keyIdeaBn: "মূল স্ট্যাকের সাথে একটি সহায়ক `minStack` রাখুন যা প্রতিটি লেভেলে সর্বনিম্ন মান O(1) সময়ে ট্র্যাক করে।",
            codeCpp: """
class MinStack {
    stack<int> mainSt, minSt;
public:
    void push(int val) {
        mainSt.push(val);
        if (minSt.empty() || val <= minSt.top()) minSt.push(val);
    }
    void pop() {
        if (mainSt.top() == minSt.top()) minSt.pop();
        mainSt.pop();
    }
    int top() { return mainSt.top(); }
    int getMin() { return minSt.top(); } // O(1)
};""",
            codeJava: """
class MinStack {
    private Deque<Integer> mainSt = new ArrayDeque<>();
    private Deque<Integer> minSt = new ArrayDeque<>();
    
    public void push(int val) {
        mainSt.push(val);
        if (minSt.isEmpty() || val <= minSt.peek()) minSt.push(val);
    }
    public void pop() {
        if (mainSt.peek().equals(minSt.peek())) minSt.pop();
        mainSt.pop();
    }
    public int top() { return mainSt.peek(); }
    public int getMin() { return minSt.peek(); }
}""",
            codePython: """
class MinStack:
    def __init__(self):
        self.st = []
        self.min_st = []
        
    def push(self, val: int) -> None:
        self.st.append(val)
        if not self.min_st or val <= self.min_st[-1]:
            self.min_st.append(val)
            
    def pop(self) -> None:
        if self.st[-1] == self.min_st[-1]:
            self.min_st.pop()
        self.st.pop()
        
    def top(self) -> int:
        return self.st[-1]
        
    def getMin(self) -> int:
        return self.min_st[-1]""",
            codeJs: """
class MinStack {
    constructor() {
        this.st = [];
        this.minSt = [];
    }
    push(val) {
        this.st.push(val);
        if (this.minSt.length === 0 || val <= this.minSt[this.minSt.length - 1]) {
            this.minSt.push(val);
        }
    }
    pop() {
        if (this.st[this.st.length - 1] === this.minSt[this.minSt.length - 1]) {
            this.minSt.pop();
        }
        this.st.pop();
    }
    top() { return this.st[this.st.length - 1]; }
    getMin() { return this.minSt[this.minSt.length - 1]; }
}"""
          ),
        ],
        commonMistakesEn: [
          {
            "title": "1. Stack Underflow Error",
            "desc": "Calling `pop()` or `top()` on an empty stack triggers runtime exceptions (EmptyStackException)."
          },
          {
            "title": "2. Infinite Recursion Stack Overflow",
            "desc": "Recursive function calls without base cases exceed OS call stack limit causing StackOverflowError."
          },
          {
            "title": "3. Misinterpreting Stack Top Element",
            "desc": "Forgetting that `pop()` removes element while `top()` / `peek()` reads without removing."
          },
          {
            "title": "4. Confusing Stack (LIFO) with Queue (FIFO)",
            "desc": "Using Stack when elements must be processed in original insertion order."
          }
        ],
        commonMistakesBn: [
          {
            "title": "১. স্ট্যাক আন্ডারফ্লো ভুল",
            "desc": "খালি স্ট্যাক থেকে `pop()` বা `top()` করতে গেলে ক্র্যাশ করে (EmptyStackException)।"
          },
          {
            "title": "২. আনলিমিটেড রিকার্সন স্ট্যাক ওভারফ্লো",
            "desc": "বেস কেস ছাড়া রিকার্সিভ কল দিলে ওএস সিস্টেম কল স্ট্যাক ফুল হয়ে StackOverflowError হয়।"
          },
          {
            "title": "৩. `pop()` ও `top()` গুলিয়ে ফেলা",
            "desc": "মনে রাখবেন `pop()` এলিমেন্ট বাদ দিয়ে দেয়, কিন্তু `top()` শুধু মান পড়ে বাদ দেয় না।"
          },
          {
            "title": "৪. স্ট্যাক (LIFO) এবং কিউ (FIFO) ভুল করা",
            "desc": "যেখানে আসার ক্রমানুসারে প্রসেস করা দরকার সেখানে স্ট্যাক ব্যবহার করা।"
          }
        ],
        roadmapStepsEn: [
          {
            "step": "Step 1",
            "title": "Understand LIFO Discipline & Core Operations",
            "desc": "Master push, pop, top, isEmpty, and array vs linked list stack implementations."
          },
          {
            "step": "Step 2",
            "title": "Solve Matching Brackets & String Reversals",
            "desc": "Practice valid parentheses matching, string reversal, and undo-redo stack mechanics."
          },
          {
            "step": "Step 3",
            "title": "Learn Expression Evaluation & Postfix RPN",
            "desc": "Evaluate postfix expressions, infix to postfix conversion, and calculator evaluation."
          },
          {
            "step": "Step 4",
            "title": "Master Monotonic Stack Pattern",
            "desc": "Learn Monotonic Increasing/Decreasing stack to solve Next Greater Element and Stock Span."
          },
          {
            "step": "Step 5",
            "title": "Design O(1) Min Stack & Specialized Containers",
            "desc": "Build Min Stack, Max Stack, and Implement Queue using 2 Stacks."
          }
        ],
        roadmapStepsBn: [
          {
            "step": "ধাপ ১",
            "title": "LIFO নীতি ও মূল অপারেশন শিখুন",
            "desc": "Push, Pop, Top, IsEmpty এবং অ্যারে বনাম লিঙ্কড লিস্ট স্ট্যাক ইমপ্লিমেন্টেশন আয়ত্ত করুন।"
          },
          {
            "step": "ধাপ ২",
            "title": "ব্র্যাকেট ম্যাচিং ও স্ট্রিং রিভার্সাল প্র্যাকটিস",
            "desc": "ভ্যালিড প্যারেন্থেসিস, স্ট্রিং রিভার্স এবং Undo-Redo মেকানিজম কোড করুন।"
          },
          {
            "step": "ধাপ ৩",
            "title": "পোস্টফিক্স (RPN) এক্সপ্রেশন মূল্যায়ন শিখুন",
            "desc": "পোস্টফিক্স গাণিতিক হিসাব, ইনফিক্স থেকে পোস্টফিক্স রূপান্তর এবং ক্যালকুলেটর পার্সিং।"
          },
          {
            "step": "ধাপ ৪",
            "title": "Monotonic Stack প্যাটার্ন আয়ত্ত করুন",
            "desc": "Next Greater Element এবং স্টক স্প্যান প্রবলেম সলভ করতে Monotonic Stack ব্যবহার করুন।"
          },
          {
            "step": "ধাপ ৫",
            "title": "O(1) Min Stack ও স্পেশালাইজড স্ট্রাকচার ডিজাইন",
            "desc": "Min Stack, Max Stack এবং ২টি স্ট্যাক দিয়ে Queue তৈরির প্রবলেম সলভ করুন।"
          }
        ],
      ),

      // 4. QUEUE
      DsaTopic(
        id: 204,
        title: "Queue (FIFO) & Deque",
        category: "Linear Data Structure",
        timeComplexity: "Enqueue O(1) | Dequeue O(1)",
        spaceComplexity: "O(N)",
        icon: Icons.swap_horizontal_circle_outlined,
        themeColor: const Color(0xFFF59E0B),
        descriptionEn: "First-In, First-Out pipeline.",
        descriptionBn: "ফার্স্ট-ইন, ফার্স্ট-আউট পাইপলাইন।",
        keyConceptsEn: ["FIFO discipline"],
        keyConceptsBn: ["FIFO নীতি"],
        multiDimCodeTemplates: {
          "Queue": {
            "C++": "queue<int> q; q.push(10); q.pop();",
            "Java": "Queue<Integer> q = new ArrayDeque<>();",
            "Python": "q = deque(); q.append(10); q.popleft()",
            "JavaScript": "const q = []; q.push(10); q.shift()"
          }
        },
        basicProblems: [],
        commonMistakesEn: [],
        commonMistakesBn: [],
        roadmapStepsEn: [],
        roadmapStepsBn: [],
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
