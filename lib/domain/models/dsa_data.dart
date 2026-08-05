import 'package:flutter/material.dart';

class DsaProblem {
  final String id;
  final String title;
  final String category; // e.g. "Singly Linked List", "Doubly Linked List"
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
  final Map<String, Map<String, String>> multiDimCodeTemplates; // Variant (Singly, Doubly, Circular) -> (Language -> Code)
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
        descriptionEn:
            "An Array is a contiguous memory allocation storing elements of the same type. It supports 1D Lists, 2D Matrices/Grids, and 3D Cubes/Tensors.",
        descriptionBn:
            "মেমোরিতে পরপর (Contiguous) সাজানো একই ধরনের উপাদানের স্ট্রাকচার। এটি ১D লিনিয়ার লিস্ট, ২D গ্রিড/ম্যাট্রিক্স এবং ৩D কিউব সাপোর্ট করে।",
        keyConceptsEn: [
          "1D Dynamic Array: Direct O(1) indexing Base + (i * size).",
          "2D Matrix: Row-major layout `arr[row][col]`.",
          "3D Cube: Multi-axis tensor layout `arr[depth][row][col]`."
        ],
        keyConceptsBn: [
          "১D ডাইনামিক অ্যারে: ডিরেক্ট O(1) ইন্ডেক্সিং।",
          "২D ম্যাট্রিক্স/গ্রিড: Row-major লেআউট।",
          "৩D কিউব/টেনসর: ৩টি অক্ষ বিশিষ্ট লেয়ার্ড কালেকশন।"
        ],
        multiDimCodeTemplates: {
          "1D Array": {
            "C++": "vector<int> arr = {10, 20, 30}; arr.push_back(40);",
            "Java": "ArrayList<Integer> list = new ArrayList<>(); list.add(10);",
            "Python": "arr = [10, 20, 30]; arr.append(40)",
            "JavaScript": "const arr = [10, 20, 30]; arr.push(40);"
          },
          "2D Array (Matrix)": {
            "C++": "vector<vector<int>> matrix = {{1,2},{3,4}};",
            "Java": "int[][] matrix = {{1,2},{3,4}};",
            "Python": "matrix = [[1,2],[3,4]]",
            "JavaScript": "const matrix = [[1,2],[3,4]];"
          },
          "3D Array (Tensor / Cube)": {
            "C++": "vector<vector<vector<int>>> cube(2, vector<vector<int>>(2, vector<int>(2, 0)));",
            "Java": "int[][][] cube = new int[2][2][2];",
            "Python": "cube = [[[1, 2]], [[3, 4]]]",
            "JavaScript": "const cube = [[[1, 2]], [[3, 4]]];"
          }
        },
        basicProblems: [
          DsaProblem(
            id: "basic-1",
            title: "1. Find Minimum and Maximum in Array",
            category: "1D Array Basic",
            keyIdeaEn: "Iterate array once updating min/max.",
            keyIdeaBn: "অ্যারে লুপ করে min ও max বের করুন।",
            codeCpp: "pair<int, int> findMinMax(vector<int>& arr) { return {arr[0], arr[0]}; }",
            codeJava: "public static int[] findMinMax(int[] arr) { return new int[]{arr[0], arr[0]}; }",
            codePython: "def findMinMax(arr): return min(arr), max(arr)",
            codeJs: "function findMinMax(arr) { return [Math.min(...arr), Math.max(...arr)]; }",
            descriptionEn: "Find smallest & largest values.",
            descriptionBn: "ছোট ও বড় সংখ্যাটি বের করুন।",
            sampleInputs: ["arr = [15, 42, 8, 99, 23]"],
            sampleOutputs: ["Min: 8, Max: 99"],
          )
        ],
        commonMistakesEn: [{"title": "Off-by-one", "desc": "Accessing index N instead of N-1."}],
        commonMistakesBn: [{"title": "Off-by-one", "desc": "অ্যারের শেষ ইনডেক্স N-1 এর বদলে N পড়া।"}],
        roadmapStepsEn: [{"step": "Step 1", "title": "Base Address Math", "desc": "Learn O(1) index access."}],
        roadmapStepsBn: [{"step": "ধাপ ১", "title": "বেস এড্রেস সূত্র", "desc": "O(1) ইন্ডেক্সিং বুঝুন।"}],
      ),

      // 2. SINGLY & DOUBLY LINKED LIST
      DsaTopic(
        id: 202,
        title: "Singly & Doubly Linked List",
        category: "Dynamic Pointer Structure",
        timeComplexity: "Head Insert/Delete: O(1) | Search/Access: O(N)",
        spaceComplexity: "O(N)",
        icon: Icons.link_outlined,
        themeColor: const Color(0xFF8B5CF6),
        descriptionEn:
            "A Linked List is a linear data structure of heap-allocated Node objects connected via pointers. Unlike contiguous Arrays, Linked List nodes are scattered across non-contiguous memory locations. A Singly Linked List node holds `data` and a `next` pointer; a Doubly Linked List node holds `prev`, `data`, and `next` pointers enabling bidirectional traversal and instant O(1) deletion when a node reference is given.",
        descriptionBn:
            "লিঙ্কড লিস্ট হলো হিপ মেমোরিতে পয়েন্টার দ্বারা সংযুক্ত নোড অবজেক্টের লিনিয়ার সিকোয়েন্স। কনটিগুয়াস অ্যারের মতো না হয়ে লিঙ্কড লিস্টের নোডগুলো মেমোরিতে ছড়ানো থাকে। Singly Linked List নোডে `data` ও `next` পয়েন্টার থাকে; Doubly Linked List নোডে `prev`, `data` ও `next` দিয়ে উভয় দিকে ট্রাভার্স এবং পয়েন্টার দেওয়া থাকলে O(1) ডিলিট করা যায়।",
        keyConceptsEn: [
          "Singly Linked List: Forward-only traversal `curr = curr->next`. Node structure `{int val; Node* next;}`.",
          "Doubly Linked List: Bidirectional traversal (`next` and `prev` pointers). Allows O(1) deletion of node if node reference is known.",
          "Circular Linked List: Tail node's `next` points back to `head` forming a endless loop structure.",
          "No Shifting Required: Inserting or removing nodes only alters pointer references (`prev->next = node->next`), avoiding array shifting overhead.",
          "Dynamic Allocation: No fixed capacity limit; nodes are allocated on heap memory on-demand using `new` / dynamic allocation."
        ],
        keyConceptsBn: [
          "Singly Linked List: শুধু সামনের দিকে ট্রাভার্সাল `curr = curr->next`। নোড স্ট্রাকচার `{int val; Node* next;}`।",
          "Doubly Linked List: দ্বিমুখী ট্রাভার্সাল (`next` ও `prev` পয়েন্টার)। পয়েন্টার জানা থাকলে O(1) সময়ে নোড ডিলেট সম্ভব।",
          "Circular Linked List: শেষ নোডের `next` পয়েন্টার হেড নোডকে পয়েন্ট করে একটি লুপ তৈরি করে।",
          "কোনো Shift লাগে না: মেমোরি পয়েন্টার লিঙ্ক আপডেট করলেই নোড যোগ/বাদ দেওয়া যায় (`prev->next = node->next`), অ্যারের মতো শিফটিং লাগে না।",
          "ডাইনামিক মেমোরি: আগে থেকে ক্যাপাসিটি ফিক্সড থাকে না; প্রয়োজন অনুযায়ী হিপ মেমোরিতে নোড তৈরি করা যায়।"
        ],
        multiDimCodeTemplates: {
          "Singly Linked List": {
            "C++": """
#include <iostream>
using namespace std;

struct Node {
    int val;
    Node* next;
    Node(int v) : val(v), next(nullptr) {}
};

int main() {
    // Create Nodes: 10 -> 20 -> 30 -> NULL
    Node* head = new Node(10);
    head->next = new Node(20);
    head->next->next = new Node(30);

    // O(1) Insert at Head
    Node* newHead = new Node(5);
    newHead->next = head;
    head = newHead;

    // Traverse List
    Node* curr = head;
    while (curr != nullptr) {
        cout << curr->val << " -> ";
        curr = curr->next;
    }
    cout << "NULL" << endl;
    return 0;
}""",
            "Java": """
class Node {
    int val;
    Node next;
    Node(int val) { this.val = val; }
}

public class SinglyLinkedList {
    public static void main(String[] args) {
        Node head = new Node(10);
        head.next = new Node(20);
        
        // O(1) Insert at Head
        Node newHead = new Node(5);
        newHead.next = head;
        head = newHead;
        
        Node curr = head;
        while (curr != null) {
            System.out.print(curr.val + " -> ");
            curr = curr.next;
        }
        System.out.println("NULL");
    }
}""",
            "Python": """
class Node:
    def __init__(self, val=0, next=None):
        self.val = val
        self.next = next

# Create 10 -> 20 -> 30
head = Node(10)
head.next = Node(20)
head.next.next = Node(30)

# O(1) Insert Head
new_head = Node(5)
new_head.next = head
head = new_head

# Traversal
curr = head
while curr:
    print(f"{curr.val} -> ", end="")
    curr = curr.next
print("None")""",
            "JavaScript": """
class Node {
    constructor(val = 0, next = null) {
        this.val = val;
        this.next = next;
    }
}

let head = new Node(10);
head.next = new Node(20);

// O(1) Insert Head
let newHead = new Node(5);
newHead.next = head;
head = newHead;

let curr = head;
while (curr) {
    console.log(curr.val);
    curr = curr.next;
}"""
          },
          "Doubly Linked List": {
            "C++": """
#include <iostream>
using namespace std;

struct DNode {
    int val;
    DNode* prev;
    DNode* next;
    DNode(int v) : val(v), prev(nullptr), next(nullptr) {}
};

int main() {
    DNode* head = new DNode(10);
    DNode* second = new DNode(20);
    
    // Connect Bidirectional Links
    head->next = second;
    second->prev = head;

    // O(1) Insert at Head
    DNode* newHead = new DNode(5);
    newHead->next = head;
    head->prev = newHead;
    head = newHead;

    // Forward Traversal
    DNode* curr = head;
    while (curr != nullptr) {
        cout << curr->val << " <-> ";
        curr = curr->next;
    }
    cout << "NULL" << endl;
    return 0;
}""",
            "Java": """
class DNode {
    int val;
    DNode prev;
    DNode next;
    DNode(int val) { this.val = val; }
}

public class DoublyLinkedList {
    public static void main(String[] args) {
        DNode head = new DNode(10);
        DNode second = new DNode(20);
        head.next = second;
        second.prev = head;
        
        System.out.println("Head val: " + head.val + ", Second prev val: " + second.prev.val);
    }
}""",
            "Python": """
class DNode:
    def __init__(self, val=0, prev=None, next=None):
        self.val = val
        self.prev = prev
        self.next = next

head = DNode(10)
second = DNode(20)
head.next = second
second.prev = head

# Bidirectional access
print("Forward:", head.next.val)
print("Backward:", second.prev.val)""",
            "JavaScript": """
class DNode {
    constructor(val = 0, prev = null, next = null) {
        this.val = val;
        this.prev = prev;
        this.next = next;
    }
}

let head = new DNode(10);
let second = new DNode(20);
head.next = second;
second.prev = head;"""
          },
          "Circular Linked List": {
            "C++": """
#include <iostream>
using namespace std;

struct Node {
    int val;
    Node* next;
    Node(int v) : val(v), next(nullptr) {}
};

int main() {
    Node* head = new Node(10);
    Node* second = new Node(20);
    head->next = second;
    second->next = head; // Point back to Head forming circle
    
    cout << "Second's next points back to Head: " << second->next->val << endl;
    return 0;
}""",
            "Java": """
class Node {
    int val;
    Node next;
    Node(int val) { this.val = val; }
}

public class CircularList {
    public static void main(String[] args) {
        Node head = new Node(10);
        Node second = new Node(20);
        head.next = second;
        second.next = head; // Circle loop
    }
}""",
            "Python": """
class Node:
    def __init__(self, val=0, next=None):
        self.val = val
        self.next = next

head = Node(10)
second = Node(20)
head.next = second
second.next = head # Points back to head""",
            "JavaScript": """
class Node {
    constructor(val = 0, next = null) {
        this.val = val;
        this.next = next;
    }
}

let head = new Node(10);
let second = new Node(20);
head.next = second;
second.next = head;"""
          }
        },
        basicProblems: [
          DsaProblem(
            id: "ll-1",
            title: "1. Reverse Singly Linked List",
            category: "Singly Linked List",
            keyIdeaEn: "Iterative 3-pointer reversal (prev = null, curr = head, nextTemp). Reverse pointer direction at each step.",
            keyIdeaBn: "৩টি পয়েন্টার (prev, curr, nextTemp) দিয়ে প্রতিটি ধাপে পয়েন্টারের দিক উল্টে দিন।",
            codeCpp: """
Node* reverseList(Node* head) {
    Node *prev = nullptr, *curr = head;
    while (curr != nullptr) {
        Node* nextTemp = curr->next;
        curr->next = prev;
        prev = curr;
        curr = nextTemp;
    }
    return prev;
}""",
            codeJava: """
public static Node reverseList(Node head) {
    Node prev = null, curr = head;
    while (curr != null) {
        Node nextTemp = curr.next;
        curr.next = prev;
        prev = curr;
        curr = nextTemp;
    }
    return prev;
}""",
            codePython: """
def reverseList(head):
    prev, curr = None, head
    while curr:
        nxt = curr.next
        curr.next = prev
        prev = curr
        curr = nxt
    return prev""",
            codeJs: """
function reverseList(head) {
    let prev = null, curr = head;
    while (curr) {
        let nxt = curr.next;
        curr.next = prev;
        prev = curr;
        curr = nxt;
    }
    return prev;
}""",
            descriptionEn: "Reverse a singly linked list so that the original tail becomes the new head.",
            descriptionBn: "একটি Singly Linked List উল্টে দিন যাতে শেষ নোডটি নতুন হেড হয়।",
            sampleInputs: ["head = [1 -> 2 -> 3 -> 4 -> 5]"],
            sampleOutputs: ["5 -> 4 -> 3 -> 2 -> 1 -> NULL"],
          ),
          DsaProblem(
            id: "ll-2",
            title: "2. Detect Cycle in Linked List (Floyd's Algorithm)",
            category: "Singly Linked List",
            keyIdeaEn: "Use Fast & Slow pointers (Tortoise and Hare). If fast and slow meet, a cycle exists.",
            keyIdeaBn: "Fast (২ ঘর) এবং Slow (১ ঘর) পয়েন্টার দিয়ে চেক করুন। তারা মিললে তালিকায় লুপ রয়েছে।",
            codeCpp: """
bool hasCycle(Node* head) {
    Node *slow = head, *fast = head;
    while (fast != nullptr && fast->next != nullptr) {
        slow = slow->next;
        fast = fast->next->next;
        if (slow == fast) return true;
    }
    return false;
}""",
            codeJava: """
public static boolean hasCycle(Node head) {
    Node slow = head, fast = head;
    while (fast != null && fast.next != null) {
        slow = slow.next;
        fast = fast.next.next;
        if (slow == fast) return true;
    }
    return false;
}""",
            codePython: """
def hasCycle(head):
    slow, fast = head, head
    while fast and fast.next:
        slow = slow.next
        fast = fast.next.next
        if slow == fast: return True
    return False""",
            codeJs: """
function hasCycle(head) {
    let slow = head, fast = head;
    while (fast && fast.next) {
        slow = slow.next;
        fast = fast.next.next;
        if (slow === fast) return true;
    }
    return false;
}""",
            descriptionEn: "Determine if a linked list contains a cycle using O(1) auxiliary space.",
            descriptionBn: "লিঙ্কড লিস্টে কোনো সাইকেল বা লুপ আছে কিনা ওয়ান স্পেসে নির্ণয় করুন।",
            sampleInputs: ["head = [3 -> 2 -> 0 -> -4 (points back to 2)]"],
            sampleOutputs: ["Cycle Detected: true"],
          ),
          DsaProblem(
            id: "ll-3",
            title: "3. Find Middle Node of Linked List",
            category: "Singly Linked List",
            keyIdeaEn: "Advance `fast` by 2 steps and `slow` by 1 step. When `fast` reaches end, `slow` is at middle.",
            keyIdeaBn: "fast পয়েন্টার ২ গুণ গতিতে চালিয়ে শেষ মাথায় পৌঁছালে slow পয়েন্টার ঠিক মাঝখানের নোডে থাকবে।",
            codeCpp: """
Node* findMiddle(Node* head) {
    Node *slow = head, *fast = head;
    while (fast != nullptr && fast->next != nullptr) {
        slow = slow->next;
        fast = fast->next->next;
    }
    return slow;
}""",
            codeJava: """
public static Node findMiddle(Node head) {
    Node slow = head, fast = head;
    while (fast != null && fast.next != null) {
        slow = slow.next;
        fast = fast.next.next;
    }
    return slow;
}""",
            codePython: """
def findMiddle(head):
    slow, fast = head, head
    while fast and fast.next:
        slow = slow.next
        fast = fast.next.next
    return slow""",
            codeJs: """
function findMiddle(head) {
    let slow = head, fast = head;
    while (fast && fast.next) {
        slow = slow.next;
        fast = fast.next.next;
    }
    return slow;
}""",
            descriptionEn: "Find the middle node of a singly linked list in a single traversal pass.",
            descriptionBn: "একবার ট্রাভার্সাল করেই লিঙ্কড লিস্টের ঠিক মাঝের নোডটি খুঁজুন।",
            sampleInputs: ["head = [1 -> 2 -> 3 -> 4 -> 5]"],
            sampleOutputs: ["Middle Node: 3"],
          ),
          DsaProblem(
            id: "ll-4",
            title: "4. Insert and Delete Node in Doubly Linked List",
            category: "Doubly Linked List",
            keyIdeaEn: "Update both `next` and `prev` pointers. `node->prev->next = node->next; node->next->prev = node->prev;`",
            keyIdeaBn: "উভয় `next` এবং `prev` লিঙ্ক আপডেট করুন। `node->prev->next = node->next; node->next->prev = node->prev;`",
            codeCpp: """
void deleteNode(DNode* node) {
    if (node->prev != nullptr) node->prev->next = node->next;
    if (node->next != nullptr) node->next->prev = node->prev;
    delete node;
}""",
            codeJava: """
public static void deleteNode(DNode node) {
    if (node.prev != null) node.prev.next = node.next;
    if (node.next != null) node.next.prev = node.prev;
}""",
            codePython: """
def deleteNode(node):
    if node.prev: node.prev.next = node.next
    if node.next: node.next.prev = node.prev""",
            codeJs: """
function deleteNode(node) {
    if (node.prev) node.prev.next = node.next;
    if (node.next) node.next.prev = node.prev;
}""",
            descriptionEn: "Remove a given node reference from a Doubly Linked List in O(1) time.",
            descriptionBn: "Doubly Linked List থেকে পয়েন্টার জানা থাকলে O(1) সময়ে যেকোনো নোড রিমুভ করুন।",
            sampleInputs: ["head = [10 <-> 20 <-> 30], delete node(20)"],
            sampleOutputs: ["Result: [10 <-> 30]"],
          ),
        ],
        commonMistakesEn: [
          {
            "title": "1. Null Pointer Dereference",
            "desc": "Calling `curr.next.val` without validating if `curr` or `curr.next` is null."
          },
          {
            "title": "2. Memory Leaks / Lost References",
            "desc": "Reassigning `head = head.next` before saving node reference in C++ leads to unallocated memory leak."
          },
          {
            "title": "3. Forgetting `prev` pointer updates in Doubly List",
            "desc": "Updating `curr.next` but forgetting `curr.next.prev = curr` breaks backward traversal."
          },
          {
            "title": "4. Infinite Loops in Cyclic Lists",
            "desc": "Traversing a circular linked list with standard `while(curr != null)` condition triggers infinite loop."
          }
        ],
        commonMistakesBn: [
          {
            "title": "১. Null Pointer Dereference",
            "desc": "নোড `curr` বা `curr.next` নাল কিনা চেক না করেই `.val` এক্সেস করার চেষ্টা করা।"
          },
          {
            "title": "২. নোডের মেমোরি রেফারেন্স হারিয়ে ফেলা",
            "desc": "রেফারেন্স সেভ করার আগেই পয়েন্টার আপডেট করে দিলে হিপ মেমোরিতে নোড হারিয়ে যায়।"
          },
          {
            "title": "৩. Doubly লিস্টে `prev` পয়েন্টার আপডেট না করা",
            "desc": "`next` পয়েন্টার সেট করে `prev` পয়েন্টার সেট করতে ভুলে গেলে পেছনের ট্রাভার্সাল নষ্ট হয়ে যায়।"
          },
          {
            "title": "৪. সার্কুলার লিঙ্কড লিস্টে আনলিমিটেড লুপ",
            "desc": "সার্কুলার লিস্টে সাধারণ `while(curr != null)` চালালে লুপ আর শেষ হবে না।"
          }
        ],
        roadmapStepsEn: [
          {
            "step": "Step 1",
            "title": "Understand Node Struct & Pointer References",
            "desc": "Master node construction, heap allocation, head pointer initialization, and `curr = curr.next` traversal."
          },
          {
            "step": "Step 2",
            "title": "Master Singly Linked List Head/Tail Insertion",
            "desc": "Practice O(1) insert at head, insert at tail, and searching elements in a singly linked list."
          },
          {
            "step": "Step 3",
            "title": "Learn Two Pointers: Fast & Slow",
            "desc": "Solve Floyd's cycle detection, finding middle node, and finding kth node from end."
          },
          {
            "step": "Step 4",
            "title": "Master Doubly Linked List & Bidirectional Links",
            "desc": "Implement `prev` & `next` bidirectional links, O(1) node deletion, and LRU Cache node operations."
          },
          {
            "step": "Step 5",
            "title": "Practice Advanced Transformations",
            "desc": "Master iterative 3-pointer list reversal, recursive reversal, merging two sorted lists, and reorder list."
          }
        ],
        roadmapStepsBn: [
          {
            "step": "ধাপ ১",
            "title": "নোড স্ট্রাকচার ও পয়েন্টার রেফারেন্স শিখুন",
            "desc": "নোড তৈরি, হিপ অ্যালোকেশন, হেড পয়েন্টার ইনিশিয়ালাইজেশন এবং `curr = curr.next` ট্রাভার্সাল ক্লিয়ার করুন।"
          },
          {
            "step": "ধাপ ২",
            "title": "Singly Linked List এর ইনসারশন প্র্যাকটিস",
            "desc": "Head এ O(1) ইনসার্ট, Tail এ ইনসার্ট এবং নির্দিষ্ট মান খোঁজার কোড লিখুন।"
          },
          {
            "step": "ধাপ ৩",
            "title": "Fast & Slow পয়েন্টার টেকনিক শিখুন",
            "desc": "ফ্লয়েডের সাইকেল ডিটেকশন, লিঙ্কড লিস্টের মাঝের নোড খোঁজা এবং শেষ থেকে K-তম নোড বের করুন।"
          },
          {
            "step": "ধাপ ৪",
            "title": "Doubly Linked List ও দ্বিমুখী লিঙ্ক আয়ত্ত করুন",
            "desc": "`prev` ও `next` পয়েন্টার হ্যান্ডলিং, O(1) নোড ডিলেশন এবং LRU ক্যালোকেশন বুঝুন।"
          },
          {
            "step": "ধাপ ৫",
            "title": "অ্যাডভান্সড রিভার্সাল ও মার্জিং মাস্টার করুন",
            "desc": "৩-পয়েন্টার রিভার্সাল, রিকার্সিভ রিভার্সাল, ২টি সর্টেড লিঙ্কড লিস্ট মার্জ করা এবং রি-অর্ডার করা প্র্যাকটিস করুন।"
          }
        ],
      ),

      // 3. STACK
      DsaTopic(
        id: 203,
        title: "Stack (LIFO)",
        category: "Linear Data Structure",
        timeComplexity: "Push O(1) | Pop O(1)",
        spaceComplexity: "O(N)",
        icon: Icons.layers_outlined,
        themeColor: const Color(0xFF10B981),
        descriptionEn: "Last-In, First-Out container.",
        descriptionBn: "লাস্ট-ইন, ফার্স্ট-আউট কন্টেইনার।",
        keyConceptsEn: ["LIFO structure"],
        keyConceptsBn: ["LIFO নীতি"],
        multiDimCodeTemplates: {
          "Stack": {
            "C++": "stack<int> st; st.push(10); st.pop();",
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
