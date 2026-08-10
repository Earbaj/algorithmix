import 'package:flutter/material.dart';

class DsaProblem {
  final String id;
  final String title;
  final String category; // e.g. "Heap Basic", "Priority Queue Pattern"
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
  final Map<String, Map<String, String>> multiDimCodeTemplates; // Variant (Min Heap, Max Heap, Custom Heapify) -> (Language -> Code)
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
        descriptionEn: "A Queue is a linear pipeline operating under the strict First-In, First-Out (FIFO) discipline.",
        descriptionBn: "কিউ হলো একটি ফার্স্ট-ইন, ফার্স্ট-আউট (FIFO) লিনিয়ার পাইপলাইন।",
        keyConceptsEn: ["FIFO Discipline", "Circular Queue", "Deque"],
        keyConceptsBn: ["FIFO নীতি", "সার্কুলার কিউ", "Deque"],
        multiDimCodeTemplates: {
          "Queue (FIFO)": {
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

      // 5. HASH TABLE & HASH MAP
      DsaTopic(
        id: 205,
        title: "Hash Table & Hash Map",
        category: "Associative Dictionary",
        timeComplexity: "Lookup O(1) avg | Insert O(1) avg | Delete O(1) avg",
        spaceComplexity: "O(N)",
        icon: Icons.grid_view_outlined,
        themeColor: const Color(0xFFEC4899),
        descriptionEn: "A Hash Table is an associative dictionary mapping keys to array indices using a Hash Function.",
        descriptionBn: "হ্যাশ টেবিল হলো একটি কী-ভ্যালু ডিকশনারি যা হ্যাশ ফাংশন দিয়ে ইনডেক্সিং করে।",
        keyConceptsEn: ["O(1) Average Lookup", "Collision Handling"],
        keyConceptsBn: ["O(1) গড়ে সমাধান", "কলিশন হ্যান্ডলিং"],
        multiDimCodeTemplates: {
          "Hash Map (Key-Value)": {
            "C++": "unordered_map<string, int> mp;",
            "Java": "Map<String, Integer> map = new HashMap<>();",
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

      // 6. BINARY SEARCH TREE (BST)
      DsaTopic(
        id: 206,
        title: "Binary Search Tree (BST)",
        category: "Hierarchical Tree Structure",
        timeComplexity: "Search O(log N) avg | Insert O(log N) avg | Delete O(log N) avg",
        spaceComplexity: "O(N)",
        icon: Icons.account_tree_outlined,
        themeColor: const Color(0xFF06B6D4),
        descriptionEn: "A BST is a node-based binary tree maintaining the invariant Left Subtree < Root < Right Subtree.",
        descriptionBn: "বাইনারি সার্চ ট্রি হলো নোড-ভিত্তিক গাছ যা বাম সাবট্রি < রুট < ডান সাবট্রি নিয়ম মানে।",
        keyConceptsEn: ["BST Invariant", "Inorder Sorted Traversal"],
        keyConceptsBn: ["BST নিয়ম", "Inorder সর্টেড ট্রাভার্সাল"],
        multiDimCodeTemplates: {
          "Standard BST": {
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

      // 7. MIN & MAX HEAP (PRIORITY QUEUE)
      DsaTopic(
        id: 207,
        title: "Min & Max Heap (Priority Queue)",
        category: "Priority Tree & Array Structure",
        timeComplexity: "Peek O(1) | Push O(log N) | Extract Top O(log N) | Build Heap O(N)",
        spaceComplexity: "O(N)",
        icon: Icons.unfold_more_double_outlined,
        themeColor: const Color(0xFF84CC16),
        descriptionEn:
            "A Binary Heap (Min Heap or Max Heap) is a Complete Binary Tree mapped directly onto a 1D Array without pointers (`parent(i) = (i-1)/2`, `left = 2i+1`, `right = 2i+2`). In a Min Heap, every parent node is smaller than or equal to its children (`parent <= child`), guaranteeing the overall minimum element is at the root `arr[0]` in O(1) time. In a Max Heap, every parent is larger than its children. Priority Queues, HeapSort, Dijkstra's algorithm, and Top-K problems rely heavily on Binary Heaps.",
        descriptionBn:
            "বাইনারি হিপ (Min Heap বা Max Heap) হলো একটি সম্পূর্ণ বাইনারি ট্রি (Complete Binary Tree) যা পয়েন্টার ছাড়াই মেমোরিতে ১D অ্যারেতে সাজানো থাকে (`parent(i) = (i-1)/2`, `left = 2i+1`, `right = 2i+2`)। Min Heap এ প্রতিটি প্যারেন্ট নোড তার চাইল্ডের চেয়ে ছোট বা সমান হয় (`parent <= child`), যা রুটে `arr[0]` সর্বনিম্ন মানটি O(1) সময়ে নিশ্চিত করে। Max Heap এ প্যারেন্ট নোড চাইল্ডের চেয়ে বড় হয়। প্রাইওরিটি কিউ (Priority Queue), HeapSort, ডাইকস্ট্রা অ্যালগরিদম এবং Top-K প্রবলেমে হিপ ব্যবহৃত হয়।",
        keyConceptsEn: [
          "Heap Invariant Property: Min Heap root `arr[0]` is smallest element (`parent <= child`); Max Heap root `arr[0]` is largest element (`parent >= child`).",
          "Complete Binary Tree Array Mapping: Parent index = `(i - 1) / 2`, Left child = `2i + 1`, Right child = `2i + 2` without memory pointer overhead.",
          "Bubble Up (Percolate Up): Inserting a new element at array end `arr[N-1]` and swapping upwards until heap property holds.",
          "Bubble Down (Percolate Down): Extracting root element, replacing root with `arr[N-1]`, and swapping downwards with smallest/largest child.",
          "Build Heap in O(N) Time: Bottom-up heapify starting from the last non-leaf node `(N/2 - 1)` constructs a heap in linear O(N) time."
        ],
        keyConceptsBn: [
          "হিপ ইনভেরিয়েন্ট নিয়ম: Min Heap এর রুট `arr[0]` সর্বদা সর্বনিম্ন মান (`parent <= child`); Max Heap এর রুট `arr[0]` সর্বদা সর্বোচ্চ মান (`parent >= child`)।",
          "কমপ্লিট বাইনারি ট্রি অ্যারে ম্যাপিং: পয়েন্টার ছাড়াই ১D অ্যারেতে Parent = `(i - 1) / 2`, Left = `2i + 1`, Right = `2i + 2` মেমোরি ইমেজিং।",
          "Bubble Up (পার্কোলেট আপ): নতুন মান অ্যারের শেষে পুশ করে ওপরের প্যারেন্টের সাথে তুলনা করে উপরে নিয়ে যাওয়া (O(log N))।",
          "Bubble Down (পার্কোলেট ডাউন): রুটের মান এক্সট্র্যাক্ট করে শেষের এলিমেন্ট দিয়ে রিপ্লেস করা এবং চাইল্ডের সাথে তুলনা করে নিচে নামানো (O(log N))।",
          "O(N) সময়ে Build Heap: শেষ নন-লিফ নোড `(N/2 - 1)` থেকে নিচ থেকে উপরে হিপ তৈরি করা O(N) সময়ে সম্পন্ন হয়।"
        ],
        multiDimCodeTemplates: {
          "Min Heap & Priority Queue": {
            "C++": """
#include <iostream>
#include <queue>
#include <vector>
using namespace std;

int main() {
    // Min Heap Priority Queue (smallest item on top O(1))
    priority_queue<int, vector<int>, greater<int>> minHeap;
    
    // O(log N) Push
    minHeap.push(30);
    minHeap.push(10);
    minHeap.push(20);
    
    // O(1) Peek Top
    cout << "Min Element: " << minHeap.top() << endl; // 10
    
    // O(log N) Pop Top
    minHeap.pop();
    cout << "Next Min: " << minHeap.top() << endl; // 20
    return 0;
}""",
            "Java": """
import java.util.PriorityQueue;

public class MinHeapDemo {
    public static void main(String[] args) {
        // Min Heap by default in Java PriorityQueue
        PriorityQueue<Integer> minHeap = new PriorityQueue<>();
        
        minHeap.add(30);
        minHeap.add(10);
        minHeap.add(20);
        
        System.out.println("Min Element: " + minHeap.peek()); // 10
        minHeap.poll(); // Removes 10
        System.out.println("Next Min: " + minHeap.peek()); // 20
    }
}""",
            "Python": """
import heapq

# Python heapq module provides Min Heap operations on standard list
min_heap = []

# O(log N) Push
heapq.heappush(min_heap, 30)
heapq.heappush(min_heap, 10)
heapq.heappush(min_heap, 20)

# O(1) Peek Top
print("Min Element:", min_heap[0]) # 10

# O(log N) Pop Top
popped = heapq.heappop(min_heap)
print("Dequeued Min:", popped) # 10
print("Next Min:", min_heap[0]) # 20""",
            "JavaScript": """
class MinHeap {
    constructor() { this.heap = []; }
    
    push(val) {
        this.heap.push(val);
        this._bubbleUp(this.heap.length - 1);
    }
    pop() {
        if (this.heap.length === 0) return null;
        const top = this.heap[0];
        const bottom = this.heap.pop();
        if (this.heap.length > 0) {
            this.heap[0] = bottom;
            this.bubbleDown(0);
        }
        return top;
    }
    peek() { return this.heap[0]; }
    
    _bubbleUp(i) {
        while (i > 0) {
            let parent = Math.floor((i - 1) / 2);
            if (this.heap[i] < this.heap[parent]) {
                [this.heap[i], this.heap[parent]] = [this.heap[parent], this.heap[i]];
                i = parent;
            } else break;
        }
    }
    bubbleDown(i) {
        const n = this.heap.length;
        while (2 * i + 1 < n) {
            let left = 2 * i + 1, right = 2 * i + 2, smallest = i;
            if (this.heap[left] < this.heap[smallest]) smallest = left;
            if (right < n && this.heap[right] < this.heap[smallest]) smallest = right;
            if (smallest !== i) {
                [this.heap[i], this.heap[smallest]] = [this.heap[smallest], this.heap[i]];
                i = smallest;
            } else break;
        }
    }
}"""
          },
          "Max Heap & Priority Queue": {
            "C++": """
#include <iostream>
#include <queue>
using namespace std;

int main() {
    // Max Heap Priority Queue (largest item on top O(1))
    priority_queue<int> maxHeap;
    
    maxHeap.push(10);
    maxHeap.push(50);
    maxHeap.push(30);
    
    cout << "Max Element: " << maxHeap.top() << endl; // 50
    maxHeap.pop();
    cout << "Next Max: " << maxHeap.top() << endl; // 30
    return 0;
}""",
            "Java": """
import java.util.Collections;
import java.util.PriorityQueue;

public class MaxHeapDemo {
    public static void main(String[] args) {
        // Reverse Comparator for Max Heap
        PriorityQueue<Integer> maxHeap = new PriorityQueue<>(Collections.reverseOrder());
        
        maxHeap.add(10);
        maxHeap.add(50);
        maxHeap.add(30);
        
        System.out.println("Max Element: " + maxHeap.peek()); // 50
        maxHeap.poll();
        System.out.println("Next Max: " + maxHeap.peek()); // 30
    }
}""",
            "Python": """
import heapq

# Invert signs to implement Max Heap using Python heapq
max_heap = []

def push(val):
    heapq.heappush(max_heap, -val)

def pop():
    return -heapq.heappop(max_heap)

def peek():
    return -max_heap[0]

push(10); push(50); push(30)
print("Max Element:", peek()) # 50
pop()
print("Next Max:", peek()) # 30""",
            "JavaScript": """
class MaxHeap {
    constructor() { this.heap = []; }
    push(val) {
        this.heap.push(val);
        this._bubbleUp(this.heap.length - 1);
    }
    pop() {
        if (this.heap.length === 0) return null;
        const top = this.heap[0];
        const bottom = this.heap.pop();
        if (this.heap.length > 0) {
            this.heap[0] = bottom;
            this._bubbleDown(0);
        }
        return top;
    }
    peek() { return this.heap[0]; }
    _bubbleUp(i) {
        while (i > 0) {
            let p = Math.floor((i - 1) / 2);
            if (this.heap[i] > this.heap[p]) {
                [this.heap[i], this.heap[p]] = [this.heap[p], this.heap[i]];
                i = p;
            } else break;
        }
    }
    _bubbleDown(i) {
        const n = this.heap.length;
        while (2 * i + 1 < n) {
            let l = 2 * i + 1, r = 2 * i + 2, largest = i;
            if (this.heap[l] > this.heap[largest]) largest = l;
            if (r < n && this.heap[r] > this.heap[largest]) largest = r;
            if (largest !== i) {
                [this.heap[i], this.heap[largest]] = [this.heap[largest], this.heap[i]];
                i = largest;
            } else break;
        }
    }
}"""
          },
          "Build Heap O(N) Algorithm": {
            "C++": """
// Bottom-up Heapify Build Heap in O(N) time
void heapify(vector<int>& arr, int n, int i) {
    int smallest = i;
    int l = 2 * i + 1;
    int r = 2 * i + 2;
    if (l < n && arr[l] < arr[smallest]) smallest = l;
    if (r < n && arr[r] < arr[smallest]) smallest = r;
    if (smallest != i) {
        swap(arr[i], arr[smallest]);
        heapify(arr, n, smallest);
    }
}

void buildMinHeap(vector<int>& arr) {
    int n = arr.size();
    // Start from last non-leaf node down to root
    for (int i = n / 2 - 1; i >= 0; i--) {
        heapify(arr, n, i);
    }
}""",
            "Java": """
public static void buildMinHeap(int[] arr) {
    int n = arr.length;
    for (int i = n / 2 - 1; i >= 0; i--) {
        heapify(arr, n, i);
    }
}
private static void heapify(int[] arr, int n, int i) {
    int smallest = i, l = 2 * i + 1, r = 2 * i + 2;
    if (l < n && arr[l] < arr[smallest]) smallest = l;
    if (r < n && arr[r] < arr[smallest]) smallest = r;
    if (smallest != i) {
        int temp = arr[i]; arr[i] = arr[smallest]; arr[smallest] = temp;
        heapify(arr, n, smallest);
    }
}""",
            "Python": """
import heapq

# heapq.heapify converts list to heap in-place in O(N) time
arr = [40, 10, 30, 50, 20]
heapq.heapify(arr) # O(N) time
print("Min Heap:", arr)""",
            "JavaScript": """
function buildMinHeap(arr) {
    const n = arr.length;
    for (let i = Math.floor(n / 2) - 1; i >= 0; i--) {
        heapifyDown(arr, n, i);
    }
}
function heapifyDown(arr, n, i) {
    let smallest = i, l = 2 * i + 1, r = 2 * i + 2;
    if (l < n && arr[l] < arr[smallest]) smallest = l;
    if (r < n && arr[r] < arr[smallest]) smallest = r;
    if (smallest !== i) {
        [arr[i], arr[smallest]] = [arr[smallest], arr[i]];
        heapifyDown(arr, n, smallest);
    }
}"""
          }
        },
        basicProblems: [
          DsaProblem(
            id: "hp-1",
            title: "1. K-th Largest Element in an Array (LeetCode #215)",
            category: "Heap Basic",
            keyIdeaEn: "Maintain a Min Heap of size `k`. Push elements and pop when size exceeds `k`. The top element is the K-th largest in O(N log k) time.",
            keyIdeaBn: "সাইজ `k` এর একটি Min Heap রাখুন। উপাদান পুশ করুন এবং সাইজ `k` ছাড়ালে পপ করুন। রুটে K-তম বৃহত্তম উপাদান পাওয়া যাবে (O(N log k))।",
            codeCpp: """
int findKthLargest(vector<int>& nums, int k) {
    priority_queue<int, vector<int>, greater<int>> minHeap;
    for (int n : nums) {
        minHeap.push(n);
        if (minHeap.size() > k) minHeap.pop();
    }
    return minHeap.top();
}""",
            codeJava: """
public static int findKthLargest(int[] nums, int k) {
    PriorityQueue<Integer> minHeap = new PriorityQueue<>();
    for (int n : nums) {
        minHeap.add(n);
        if (minHeap.size() > k) minHeap.poll();
    }
    return minHeap.peek();
}""",
            codePython: """
import heapq

def findKthLargest(nums, k):
    return heapq.nlargest(k, nums)[-1]""",
            codeJs: """
function findKthLargest(nums, k) {
    nums.sort((a, b) => b - a);
    return nums[k - 1];
}""",
            descriptionEn: "Find the `k`-th largest element in an unsorted integer array.",
            descriptionBn: "আনসর্টেড পূর্ণসংখ্যার অ্যারে থেকে `k`-তম বৃহত্তম উপাদানটি খুঁজুন।",
            sampleInputs: ["nums = [3,2,1,5,6,4], k = 2"],
            sampleOutputs: ["5"],
          ),
          DsaProblem(
            id: "hp-2",
            title: "2. Top K Frequent Elements (LeetCode #347)",
            category: "Priority Queue Pattern",
            keyIdeaEn: "Count frequencies in a HashMap, then push `(freq, num)` pairs into a Min Heap of size `k`.",
            keyIdeaBn: "হ্যাশ ম্যাপে ফ্রিকোয়েন্সি গুনে সাইজ `k` এর Min Heap এ `(freq, num)` পেয়ার পুশ ও পপ করুন।",
            codeCpp: """
vector<int> topKFrequent(vector<int>& nums, int k) {
    unordered_map<int, int> freq;
    for (int n : nums) freq[n]++;
    priority_queue<pair<int, int>, vector<pair<int, int>>, greater<pair<int, int>>> minHeap;
    for (auto p : freq) {
        minHeap.push({p.second, p.first});
        if (minHeap.size() > k) minHeap.pop();
    }
    vector<int> res;
    while (!minHeap.empty()) {
        res.push_back(minHeap.top().second);
        minHeap.pop();
    }
    return res;
}""",
            codeJava: """
public static int[] topKFrequent(int[] nums, int k) {
    Map<Integer, Integer> freq = new HashMap<>();
    for (int n : nums) freq.put(n, freq.getOrDefault(n, 0) + 1);
    PriorityQueue<Map.Entry<Integer, Integer>> minHeap =
        new PriorityQueue<>((a, b) -> a.getValue() - b.getValue());
    for (var entry : freq.entrySet()) {
        minHeap.add(entry);
        if (minHeap.size() > k) minHeap.poll();
    }
    return minHeap.stream().mapToInt(Map.Entry::getKey).toArray();
}""",
            codePython: """
from collections import Counter
import heapq

def topKFrequent(nums, k):
    count = Counter(nums)
    return heapq.nlargest(k, count.keys(), key=count.get)""",
            codeJs: """
function topKFrequent(nums, k) {
    const freq = {};
    for (let n of nums) freq[n] = (freq[n] || 0) + 1;
    return Object.keys(freq).sort((a, b) => freq[b] - freq[a]).slice(0, k).map(Number);
}""",
            descriptionEn: "Given an integer array `nums` and an integer `k`, return the `k` most frequent elements.",
            descriptionBn: "পূর্ণসংখ্যার অ্যারে `nums` থেকে সর্বাধিক উপস্থিত হওয়া `k` টি উপাদান বের করুন।",
            sampleInputs: ["nums = [1,1,1,2,2,3], k = 2"],
            sampleOutputs: ["[1, 2]"],
          ),
          DsaProblem(
            id: "hp-3",
            title: "3. Find Median from Data Stream (LeetCode #295)",
            category: "Dual Heap Pattern",
            keyIdeaEn: "Maintain two heaps: a Max Heap for lower half numbers, and a Min Heap for upper half numbers. Balance sizes within 1 element difference.",
            keyIdeaBn: "দুটি হিপ রাখুন: ছোট অর্ধেক উপাদানের জন্য Max Heap এবং বড় অর্ধেকের জন্য Min Heap। উভয়ের সাইজ সামঞ্জস্য রেখে O(1) সময়ে মধ্যমা (Median) বের করুন।",
            codeCpp: """
class MedianFinder {
    priority_queue<int> maxHeap; // Lower half
    priority_queue<int, vector<int>, greater<int>> minHeap; // Upper half
public:
    void addNum(int num) {
        maxHeap.push(num);
        minHeap.push(maxHeap.top());
        maxHeap.pop();
        if (minHeap.size() > maxHeap.size()) {
            maxHeap.push(minHeap.top());
            minHeap.pop();
        }
    }
    double findMedian() {
        if (maxHeap.size() > minHeap.size()) return maxHeap.top();
        return (maxHeap.top() + minHeap.top()) / 2.0;
    }
};""",
            codeJava: """
class MedianFinder {
    private PriorityQueue<Integer> maxHeap = new PriorityQueue<>((a,b)->b-a);
    private PriorityQueue<Integer> minHeap = new PriorityQueue<>();
    
    public void addNum(int num) {
        maxHeap.add(num);
        minHeap.add(maxHeap.poll());
        if (minHeap.size() > maxHeap.size()) {
            maxHeap.add(minHeap.poll());
        }
    }
    public double findMedian() {
        if (maxHeap.size() > minHeap.size()) return maxHeap.peek();
        return (maxHeap.peek() + minHeap.peek()) / 2.0;
    }
}""",
            codePython: """
import heapq

class MedianFinder:
    def __init__(self):
        self.small = [] # Max Heap (negated)
        self.large = [] # Min Heap
        
    def addNum(self, num: int) -> None:
        heapq.heappush(self.small, -num)
        heapq.heappush(self.large, -heapq.heappop(self.small))
        if len(self.large) > len(self.small):
            heapq.heappush(self.small, -heapq.heappop(self.large))
            
    def findMedian(self) -> float:
        if len(self.small) > len(self.large):
            return -self.small[0]
        return (-self.small[0] + self.large[0]) / 2.0""",
            codeJs: """
class MedianFinder {
    constructor() {
        this.nums = [];
    }
    addNum(num) {
        let low = 0, high = this.nums.length;
        while (low < high) {
            let mid = (low + high) >> 1;
            if (this.nums[mid] < num) low = mid + 1;
            else high = mid;
        }
        this.nums.splice(low, 0, num);
    }
    findMedian() {
        const n = this.nums.length;
        if (n % 2 === 1) return this.nums[Math.floor(n / 2)];
        return (this.nums[n / 2 - 1] + this.nums[n / 2]) / 2;
    }
}""",
            descriptionEn: "Design a data structure that receives a data stream of numbers and computes the median in O(1) time.",
            descriptionBn: "একটি ডেটা স্ট্রাকচার ডিজাইন করুন যা স্ট্রিম থেকে সংখ্যা গ্রহণ করে O(1) সময়ে মধ্যমা (Median) বের করে।",
            sampleInputs: ["addNum(1), addNum(2), findMedian(), addNum(3), findMedian()"],
            sampleOutputs: ["findMedian(): 1.5, findMedian(): 2.0"],
          ),
        ],
        commonMistakesEn: [
          {
            "title": "1. Building Heap via N Insertions (O(N log N))",
            "desc": "Calling `push()` N times takes O(N log N) time, whereas bottom-up `heapify()` builds heap in optimal linear O(N) time."
          },
          {
            "title": "2. Confusing Min Heap vs Max Heap for Top-K Problems",
            "desc": "Using a Max Heap for K-th largest problem forces storing all N elements. Use a Min Heap of size K to retain the top K elements."
          },
          {
            "title": "3. 0-based vs 1-based Index Array Math Bug",
            "desc": "Swapping 0-based index formula `(2i + 1, 2i + 2)` with 1-based formula `(2i, 2i + 1)` causes array index out-of-bounds."
          },
          {
            "title": "4. Out of Bounds Error during Bubble Down",
            "desc": "Failing to check `rightChild < arrayLength` before accessing `arr[rightChild]` during Heapify Down."
          }
        ],
        commonMistakesBn: [
          {
            "title": "১. N ইনসারশনে হিপ বানিয়ে সময় নষ্ট (O(N log N))",
            "desc": "লুপে `push()` ডেকে হিপ বানাতে O(N log N) সময় লাগে; অথচ নিচ থেকে `heapify()` করলে O(N) টাইমে হিপ তৈরি হয়।"
          },
          {
            "title": "২. Top-K প্রবলেমে ভুল হিপ চয়েস",
            "desc": "K-তম বৃহত্তম উপাদান বের করার জন্য Max Heap বেছে নিলে সব N এলিমেন্ট সেভ করতে হয়। সাইজ K এর Min Heap ব্যবহার করুন।"
          },
          {
            "title": "৩. ০-ইনডেক্স ও ১-ইনডেক্স সূত্রের ভুল",
            "desc": "০-ভিত্তিক সূত্রের `(2i + 1, 2i + 2)` সাথে ১-ভিত্তিক সূত্রের `(2i, 2i + 1)` গুলিয়ে ফেললে ইন্ডেক্স আউট অফ বাউন্ডস ঘটে।"
          },
          {
            "title": "৪. Bubble Down এ অ্যারে বাউন্ড মিস করা",
            "desc": "Bubble Down করার সময় `rightChild < arrayLength` চেক না করে সরাসরি `arr[rightChild]` পড়তে গেলে রানটাইম এরর হয়।"
          }
        ],
        roadmapStepsEn: [
          {
            "step": "Step 1",
            "title": "Understand Complete Binary Tree & 1D Array Mapping",
            "desc": "Master 0-based array index math: parent = (i-1)/2, left = 2i+1, right = 2i+2."
          },
          {
            "step": "Step 2",
            "title": "Master Bubble Up & Bubble Down Algorithms",
            "desc": "Implement push (Bubble Up) and extract top (Bubble Down) in O(log N) time."
          },
          {
            "step": "Step 3",
            "title": "Master O(N) Bottom-Up Build Heap",
            "desc": "Understand linear O(N) heap construction starting from last non-leaf node (N/2 - 1)."
          },
          {
            "step": "Step 4",
            "title": "Solve Top-K & Priority Queue Pattern Problems",
            "desc": "Solve K-th largest, Top-K frequent elements using fixed size K Min Heap."
          },
          {
            "step": "Step 5",
            "title": "Master Dual Heap & Graph Algorithms",
            "desc": "Solve Data Stream Median using Dual Heaps and apply Priority Queue in Dijkstra's shortest path."
          }
        ],
        roadmapStepsBn: [
          {
            "step": "ধাপ ১",
            "title": "কমপ্লিট বাইনারি ট্রি ও ১D অ্যারে ম্যাপিং",
            "desc": "০-ভিত্তিক সূত্রের parent = (i-1)/2, left = 2i+1, right = 2i+2 ইনডেক্সিং আয়ত্ত করুন।"
          },
          {
            "step": "ধাপ ২",
            "title": "Bubble Up ও Bubble Down অ্যালগরিদম",
            "desc": "O(log N) সময়ে ইনসার্ট (Bubble Up) এবং টপ বাদ দেওয়ার (Bubble Down) কোড লিখুন।"
          },
          {
            "step": "ধাপ ৩",
            "title": "O(N) টাইমে লিনিয়ার Build Heap",
            "desc": "শেষ নন-লিফ নোড (N/2 - 1) থেকে নিচ থেকে উপরে O(N) সময়ে হিপ বানানোর কৌশল।"
          },
          {
            "step": "ধাপ ৪",
            "title": "Top-K ও প্রাইওরিটি কিউ প্যাটার্ন প্রবলেমস",
            "desc": "সাইজ K এর Min Heap ব্যবহার করে K-তম বৃহত্তম উপাদান ও সর্বাধিক উপস্থিত উপাদান সলভ করুন।"
          },
          {
            "step": "ধাপ ৫",
            "title": "Dual Heap ও গ্রাফে Priority Queue প্রয়োগ",
            "desc": "Dual Heap দিয়ে ডেটা স্ট্রিমের মধ্যমা (Median) বের করা এবং ডাইকস্ট্রা শর্টেস্ট পাথে প্রাইওরিটি কিউ ব্যবহার।"
          }
        ],
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
