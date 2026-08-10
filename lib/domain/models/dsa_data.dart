import 'package:flutter/material.dart';

class DsaProblem {
  final String id;
  final String title;
  final String category; // e.g. "Trie Basic", "Trie Pattern"
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
  final Map<String, Map<String, String>> multiDimCodeTemplates; // Variant (Standard Trie, Autocomplete, Wildcard Search) -> (Language -> Code)
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

      // 7. MIN & MAX HEAP
      DsaTopic(
        id: 207,
        title: "Min & Max Heap (Priority Queue)",
        category: "Priority Tree & Array Structure",
        timeComplexity: "Peek O(1) | Push O(log N) | Extract Top O(log N)",
        spaceComplexity: "O(N)",
        icon: Icons.unfold_more_double_outlined,
        themeColor: const Color(0xFF84CC16),
        descriptionEn: "A Binary Heap is a complete binary tree mapped onto a 1D array.",
        descriptionBn: "বাইনারি হিপ হলো ১D অ্যারেতে সাজানো কমপ্লিট বাইনারি ট্রি।",
        keyConceptsEn: ["Heap Invariant", "Bubble Up & Down"],
        keyConceptsBn: ["হিপ ইনভেরিয়েন্ট", "বাবল আপ ও বাবল ডাউন"],
        multiDimCodeTemplates: {
          "Min Heap": {
            "C++": "priority_queue<int, vector<int>, greater<int>> minHeap;",
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
        category: "Non-Linear Network Structure",
        timeComplexity: "BFS O(V + E) | DFS O(V + E)",
        spaceComplexity: "Adj List: O(V + E) | Matrix: O(V²)",
        icon: Icons.hub_outlined,
        themeColor: const Color(0xFF0284C7),
        descriptionEn: "A Graph is a non-linear network of Vertices and Edges.",
        descriptionBn: "গ্রাফ হলো নোড ও এজের নন-লিনিয়ার নেটওয়ার্ক।",
        keyConceptsEn: ["Adj List & Matrix", "BFS & DFS"],
        keyConceptsBn: ["অ্যাডজাসেন্সি লিস্ট ও ম্যাট্রিক্স", "BFS ও DFS"],
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

      // 9. TRIE (PREFIX TREE)
      DsaTopic(
        id: 209,
        title: "Trie (Prefix Tree)",
        category: "Advanced Character Tree",
        timeComplexity: "Insert O(L) | Search O(L) | StartsWith O(L)",
        spaceComplexity: "O(N × L)",
        icon: Icons.sort_by_alpha_outlined,
        themeColor: const Color(0xFFA855F7),
        descriptionEn:
            "A Trie (pronounced 'try', short for Retrieval Tree) or Prefix Tree is a specialized N-ary tree data structure used for fast string matching and prefix searches. Nodes store character references (`unordered_map<char, TrieNode*>` or `TrieNode[26]`) and a boolean flag `isEndOfWord`. Operations like `insert(word)`, `search(word)`, and `startsWith(prefix)` run in O(L) time where L is the length of the target string — independent of the total number of words stored! Modern search engine autocomplete, spell-checking, and IP routing tables use Tries extensively.",
        descriptionBn:
            "ট্রাই (Trie или Prefix Tree) হলো একটি বিশেষায়িত N-ary ক্যারেক্টার ট্রি স্ট্রাকচার যা দ্রুত স্ট্রিং ম্যাচিং এবং প্রিফিক্স সার্চের জন্য ব্যবহৃত হয়। প্রতিটি নোডে অক্ষর সংযোগ (`unordered_map<char, TrieNode*>` বা `TrieNode[26]`) এবং একটি বুলিয়ান ফ্ল্যাগ `isEndOfWord` থাকে। `insert(word)`, `search(word)`, এবং `startsWith(prefix)` অপারেশনগুলো মাত্র O(L) টাইমে সম্পন্ন হয় (যেখানে L হলো শব্দটির দৈর্ঘ্য)। এতে অভিধানে যত লক্ষ শব্দই থাক না কেন সময়কাল সর্বদা O(L)! সার্চ ইঞ্জিন অটো-কমপ্লিট, স্পেল চেকার এবং IP রাউটিংয়ে ট্রাই ব্যবহৃত হয়।",
        keyConceptsEn: [
          "O(L) Fast Lookup: Operations depend ONLY on string length L, completely independent of the dictionary size N.",
          "Character Branch Sharing: Words with common prefixes (e.g., 'app', 'apple', 'application') share identical prefix tree branches.",
          "Trie Node Anatomy: Contains a child map/array `children[c]` and a boolean flag `isEndOfWord` marking word endings.",
          "Autocomplete Engine: Navigating to the prefix node `startsWith('app')` and running DFS yields all matching suggested words.",
          "Wildcard Matching: Supports pattern searches (e.g. `b.d` matching `bad`, `bed`, `bid`) via recursive DFS branching."
        ],
        keyConceptsBn: [
          "O(L) সুপারফাস্ট লুকআপ: সার্চ স্পিড কেবল শব্দের দৈর্ঘ্য L এর ওপর নির্ভর করে; অভিধানে মোট শব্দের সংখ্যা N এর ওপর নয়।",
          "প্রিফিক্স শেয়ারিং: একই প্রিফিক্স যুক্ত শব্দসমূহ (যেমন: 'app', 'apple', 'application') মেমোরিতে একই ব্রাঞ্চ শেয়ার করে।",
          "ট্রাই নোড স্ট্রাকচার: নোডে চাইল্ড ম্যাপ `children[c]` এবং শব্দ সমাপ্তি চিহ্নিত করার বুলিয়ান ফ্ল্যাগ `isEndOfWord` থাকে।",
          "অটো-কমপ্লিট ইঞ্জিন: প্রিফিক্স নোডে `startsWith('app')` গিয়ে DFS চালালে সকল প্রস্তাবিত শব্দ সাজেস্ট করা সম্ভব।",
          "ওয়াইল্ডকার্ড প্যাটার্ন সার্চ: রিকার্সিভ DFS দিয়ে `b.d` টাইপের প্যাটার্ন সার্চ করে `bad`, `bed`, `bid` ম্যাচিং করা।"
        ],
        multiDimCodeTemplates: {
          "Standard Trie": {
            "C++": """
#include <iostream>
#include <unordered_map>
#include <string>
using namespace std;

class TrieNode {
public:
    unordered_map<char, TrieNode*> children;
    bool isEndOfWord;
    TrieNode() : isEndOfWord(false) {}
};

class Trie {
    TrieNode* root;
public:
    Trie() { root = new TrieNode(); }
    
    // O(L) Insert
    void insert(string word) {
        TrieNode* curr = root;
        for (char c : word) {
            if (!curr->children.count(c)) {
                curr->children[c] = new TrieNode();
            }
            curr = curr->children[c];
        }
        curr->isEndOfWord = true;
    }
    
    // O(L) Search Exact Word
    bool search(string word) {
        TrieNode* curr = root;
        for (char c : word) {
            if (!curr->children.count(c)) return false;
            curr = curr->children[c];
        }
        return curr->isEndOfWord;
    }
    
    // O(L) StartsWith Prefix
    bool startsWith(string prefix) {
        TrieNode* curr = root;
        for (char c : prefix) {
            if (!curr->children.count(c)) return false;
            curr = curr->children[c];
        }
        return true;
    }
};""",
            "Java": """
class TrieNode {
    TrieNode[] children = new TrieNode[26];
    boolean isEndOfWord = false;
}

public class Trie {
    private TrieNode root;
    public Trie() { root = new TrieNode(); }
    
    public void insert(String word) {
        TrieNode curr = root;
        for (char c : word.toCharArray()) {
            int idx = c - 'a';
            if (curr.children[idx] == null) {
                curr.children[idx] = new TrieNode();
            }
            curr = curr.children[idx];
        }
        curr.isEndOfWord = true;
    }
    
    public boolean search(String word) {
        TrieNode curr = root;
        for (char c : word.toCharArray()) {
            int idx = c - 'a';
            if (curr.children[idx] == null) return false;
            curr = curr.children[idx];
        }
        return curr.isEndOfWord;
    }
    
    public boolean startsWith(String prefix) {
        TrieNode curr = root;
        for (char c : prefix.toCharArray()) {
            int idx = c - 'a';
            if (curr.children[idx] == null) return false;
            curr = curr.children[idx];
        }
        return true;
    }
}""",
            "Python": """
class TrieNode:
    def __init__(self):
        self.children = {}
        self.is_end_of_word = False

class Trie:
    def __init__(self):
        self.root = TrieNode()
        
    def insert(self, word: str) -> None:
        curr = self.root
        for c in word:
            if c not in curr.children:
                curr.children[c] = TrieNode()
            curr = curr.children[c]
        curr.is_end_of_word = True
        
    def search(self, word: str) -> bool:
        curr = self.root
        for c in word:
            if c not in curr.children:
                return False
            curr = curr.children[c]
        return curr.is_end_of_word
        
    def startsWith(self, prefix: str) -> bool:
        curr = self.root
        for c in prefix:
            if c not in curr.children:
                return False
            curr = curr.children[c]
        return True""",
            "JavaScript": """
class TrieNode {
    constructor() {
        this.children = {};
        this.isEndOfWord = false;
    }
}

class Trie {
    constructor() {
        this.root = new TrieNode();
    }
    insert(word) {
        let curr = this.root;
        for (let c of word) {
            if (!curr.children[c]) {
                curr.children[c] = new TrieNode();
            }
            curr = curr.children[c];
        }
        curr.isEndOfWord = true;
    }
    search(word) {
        let curr = this.root;
        for (let c of word) {
            if (!curr.children[c]) return false;
            curr = curr.children[c];
        }
        return curr.isEndOfWord;
    }
    startsWith(prefix) {
        let curr = this.root;
        for (let c of prefix) {
            if (!curr.children[c]) return false;
            curr = curr.children[c];
        }
        return true;
    }
}"""
          },
          "Autocomplete Engine": {
            "C++": """
#include <iostream>
#include <vector>
#include <unordered_map>
using namespace std;

class AutocompleteTrie {
    struct Node {
        unordered_map<char, Node*> children;
        bool isEnd = false;
    };
    Node* root = new Node();
    
    void dfs(Node* curr, string currentWord, vector<string>& results) {
        if (curr->isEnd) results.push_back(currentWord);
        for (auto& p : curr->children) {
            dfs(p.second, currentWord + p.first, results);
        }
    }
public:
    void insert(string word) {
        Node* curr = root;
        for (char c : word) {
            if (!curr->children.count(c)) curr->children[c] = new Node();
            curr = curr->children[c];
        }
        curr->isEnd = true;
    }
    
    vector<string> autocomplete(string prefix) {
        Node* curr = root;
        vector<string> results;
        for (char c : prefix) {
            if (!curr->children.count(c)) return results;
            curr = curr->children[c];
        }
        dfs(curr, prefix, results);
        return results;
    }
};""",
            "Java": """
import java.util.*;

public class AutocompleteTrie {
    static class Node {
        Map<Character, Node> children = new HashMap<>();
        boolean isEnd = false;
    }
    private Node root = new Node();
    
    public void insert(String word) {
        Node curr = root;
        for (char c : word.toCharArray()) {
            curr.children.putIfAbsent(c, new Node());
            curr = curr.children.get(c);
        }
        curr.isEnd = true;
    }
    
    public List<String> getSuggestions(String prefix) {
        Node curr = root;
        List<String> results = new ArrayList<>();
        for (char c : prefix.toCharArray()) {
            if (!curr.children.containsKey(c)) return results;
            curr = curr.children.get(c);
        }
        dfs(curr, new StringBuilder(prefix), results);
        return results;
    }
    private void dfs(Node node, StringBuilder sb, List<String> res) {
        if (node.isEnd) res.add(sb.toString());
        for (char c : node.children.keySet()) {
            sb.append(c);
            dfs(node.children.get(c), sb, res);
            sb.setLength(sb.length() - 1);
        }
    }
}""",
            "Python": """
class AutocompleteTrie:
    def __init__(self):
        self.root = {}
        
    def insert(self, word):
        curr = self.root
        for c in word:
            if c not in curr: curr[c] = {}
            curr = curr[c]
        curr['#'] = True # Word end marker
        
    def autocomplete(self, prefix):
        curr = self.root
        for c in prefix:
            if c not in curr: return []
            curr = curr[c]
            
        res = []
        def dfs(node, path):
            if '#' in node: res.append(path)
            for k in node:
                if k != '#': dfs(node[k], path + k)
                
        dfs(curr, prefix)
        return res""",
            "JavaScript": """
class AutocompleteTrie {
    constructor() { this.root = {}; }
    insert(word) {
        let curr = this.root;
        for (let c of word) {
            if (!curr[c]) curr[c] = {};
            curr = curr[c];
        }
        curr['#'] = true;
    }
    autocomplete(prefix) {
        let curr = this.root;
        for (let c of prefix) {
            if (!curr[c]) return [];
            curr = curr[c];
        }
        const res = [];
        const dfs = (node, path) => {
            if (node['#']) res.push(path);
            for (let k in node) {
                if (k !== '#') dfs(node[k], path + k);
            }
        };
        dfs(curr, prefix);
        return res;
    }
}"""
          }
        },
        basicProblems: [
          DsaProblem(
            id: "tr-1",
            title: "1. Implement Trie - Prefix Tree (LeetCode #208)",
            category: "Trie Basic",
            keyIdeaEn: "Build Trie class with `insert(word)`, `search(word)`, and `startsWith(prefix)` methods in O(L) time.",
            keyIdeaBn: "O(L) সময়ে `insert(word)`, `search(word)`, এবং `startsWith(prefix)` মেথড বিশিষ্ট Trie ক্লাস তৈরি করুন।",
            codeCpp: """
class Trie {
    struct Node {
        unordered_map<char, Node*> children;
        bool isEnd = false;
    } *root;
public:
    Trie() { root = new Node(); }
    void insert(string word) {
        Node* curr = root;
        for (char c : word) {
            if (!curr->children.count(c)) curr->children[c] = new Node();
            curr = curr->children[c];
        }
        curr->isEnd = true;
    }
    bool search(string word) {
        Node* curr = root;
        for (char c : word) {
            if (!curr->children.count(c)) return false;
            curr = curr->children[c];
        }
        return curr->isEnd;
    }
    bool startsWith(string prefix) {
        Node* curr = root;
        for (char c : prefix) {
            if (!curr->children.count(c)) return false;
            curr = curr->children[c];
        }
        return true;
    }
};""",
            codeJava: """
class Trie {
    static class Node {
        Node[] children = new Node[26];
        boolean isEnd = false;
    }
    private Node root = new Node();
    public void insert(String word) {
        Node curr = root;
        for (char c : word.toCharArray()) {
            int idx = c - 'a';
            if (curr.children[idx] == null) curr.children[idx] = new Node();
            curr = curr.children[idx];
        }
        curr.isEnd = true;
    }
    public boolean search(String word) {
        Node curr = root;
        for (char c : word.toCharArray()) {
            int idx = c - 'a';
            if (curr.children[idx] == null) return false;
            curr = curr.children[idx];
        }
        return curr.isEnd;
    }
    public boolean startsWith(String prefix) {
        Node curr = root;
        for (char c : prefix.toCharArray()) {
            int idx = c - 'a';
            if (curr.children[idx] == null) return false;
            curr = curr.children[idx];
        }
        return true;
    }
}""",
            codePython: """
class Trie:
    def __init__(self): self.root = {}
    def insert(self, word: str) -> None:
        curr = self.root
        for c in word:
            if c not in curr: curr[c] = {}
            curr = curr[c]
        curr['#'] = True
    def search(self, word: str) -> bool:
        curr = self.root
        for c in word:
            if c not in curr: return False
            curr = curr[c]
        return '#' in curr
    def startsWith(self, prefix: str) -> bool:
        curr = self.root
        for c in prefix:
            if c not in curr: return False
            curr = curr[c]
        return True""",
            codeJs: """
class Trie {
    constructor() { this.root = {}; }
    insert(word) {
        let curr = this.root;
        for (let c of word) {
            if (!curr[c]) curr[c] = {};
            curr = curr[c];
        }
        curr['#'] = true;
    }
    search(word) {
        let curr = this.root;
        for (let c of word) {
            if (!curr[c]) return false;
            curr = curr[c];
        }
        return !!curr['#'];
    }
    startsWith(prefix) {
        let curr = this.root;
        for (let c of prefix) {
            if (!curr[c]) return false;
            curr = curr[c];
        }
        return true;
    }
}""",
            descriptionEn: "Implement a Trie (Prefix Tree) supporting `insert`, `search`, and `startsWith` operations.",
            descriptionBn: "`insert`, `search`, এবং `startsWith` সাপোর্ট করে এমন একটি Trie (প্রিফিক্স ট্রি) ইমপ্লিমেন্ট করুন।",
            sampleInputs: ["insert(\"apple\"), search(\"apple\"), search(\"app\"), startsWith(\"app\"), insert(\"app\"), search(\"app\")"],
            sampleOutputs: ["search(\"apple\"): true, search(\"app\"): false, startsWith(\"app\"): true, search(\"app\"): true"],
          ),
          DsaProblem(
            id: "tr-2",
            title: "2. Design Add and Search Words Data Structure (LeetCode #211)",
            category: "Trie Pattern",
            keyIdeaEn: "Build a Trie supporting '.' wildcard matching. When encountering '.', recursively search all 26 children.",
            keyIdeaBn: "ওয়াইল্ডকার্ড '.' ম্যাচিং সাপোর্ট করে এমন Trie ডিজাইন করুন। '.' পেলে রিকার্সিভলি সব চাইল্ড নোডে খুঁজুন।",
            codeCpp: """
class WordDictionary {
    struct Node {
        unordered_map<char, Node*> children;
        bool isEnd = false;
    } *root;
    
    bool dfs(string& word, int idx, Node* curr) {
        if (!curr) return false;
        if (idx == word.length()) return curr->isEnd;
        char c = word[idx];
        if (c == '.') {
            for (auto& p : curr->children) {
                if (dfs(word, idx + 1, p.second)) return true;
            }
            return false;
        } else {
            if (!curr->children.count(c)) return false;
            return dfs(word, idx + 1, curr->children[c]);
        }
    }
public:
    WordDictionary() { root = new Node(); }
    void addWord(string word) {
        Node* curr = root;
        for (char c : word) {
            if (!curr->children.count(c)) curr->children[c] = new Node();
            curr = curr->children[c];
        }
        curr->isEnd = true;
    }
    bool search(string word) { return dfs(word, 0, root); }
};""",
            codeJava: """
class WordDictionary {
    static class Node {
        Node[] children = new Node[26];
        boolean isEnd = false;
    }
    private Node root = new Node();
    public void addWord(String word) {
        Node curr = root;
        for (char c : word.toCharArray()) {
            int idx = c - 'a';
            if (curr.children[idx] == null) curr.children[idx] = new Node();
            curr = curr.children[idx];
        }
        curr.isEnd = true;
    }
    public boolean search(String word) { return dfs(word.toCharArray(), 0, root); }
    private boolean dfs(char[] word, int idx, Node curr) {
        if (curr == null) return false;
        if (idx == word.length) return curr.isEnd;
        char c = word[idx];
        if (c == '.') {
            for (Node child : curr.children) {
                if (child != null && dfs(word, idx + 1, child)) return true;
            }
            return false;
        } else {
            int i = c - 'a';
            return dfs(word, idx + 1, curr.children[i]);
        }
    }
}""",
            codePython: """
class WordDictionary:
    def __init__(self): self.root = {}
    def addWord(self, word: str) -> None:
        curr = self.root
        for c in word:
            if c not in curr: curr[c] = {}
            curr = curr[c]
        curr['#'] = True
        
    def search(self, word: str) -> bool:
        def dfs(idx, curr):
            if idx == len(word): return '#' in curr
            c = word[idx]
            if c == '.':
                return any(dfs(idx + 1, curr[k]) for k in curr if k != '#')
            if c not in curr: return False
            return dfs(idx + 1, curr[c])
        return dfs(0, self.root)""",
            codeJs: """
class WordDictionary {
    constructor() { this.root = {}; }
    addWord(word) {
        let curr = this.root;
        for (let c of word) {
            if (!curr[c]) curr[c] = {};
            curr = curr[c];
        }
        curr['#'] = true;
    }
    search(word) {
        const dfs = (idx, curr) => {
            if (idx === word.length) return !!curr['#'];
            let c = word[idx];
            if (c === '.') {
                for (let k in curr) {
                    if (k !== '#' && dfs(idx + 1, curr[k])) return true;
                }
                return false;
            }
            if (!curr[c]) return false;
            return dfs(idx + 1, curr[c]);
        };
        return dfs(0, this.root);
    }
}""",
            descriptionEn: "Design a data structure that supports adding new words and finding if a string matches any previously added string with '.' wildcard.",
            descriptionBn: "নতুন শব্দ যোগ করা এবং ওয়াইল্ডকার্ড '.' দিয়ে পূর্বে যোগ করা শব্দের মিল খোঁজার ডেটা স্ট্রাকচার তৈরি করুন।",
            sampleInputs: ["addWord(\"bad\"), addWord(\"dad\"), search(\"pad\"), search(\"bad\"), search(\".ad\"), search(\"b..\")"],
            sampleOutputs: ["search(\"pad\"): false, search(\"bad\"): true, search(\".ad\"): true, search(\"b..\"): true"],
          ),
        ],
        commonMistakesEn: [
          {
            "title": "1. Forgetting `isEndOfWord = true` Flag",
            "desc": "Failing to mark the final node when inserting a word breaks exact word search functionality (e.g. `search('app')` when 'apple' exists)."
          },
          {
            "title": "2. Confusing Exact Word `search()` vs `startsWith()`",
            "desc": "Using `search()` when checking prefix existence. `search()` requires `isEndOfWord == true`, while `startsWith()` only checks node path."
          },
          {
            "title": "3. Off-by-one ASCII Array Math Bug",
            "desc": "Using `c - 'A'` instead of `c - 'a'` for lowercase characters causes index out-of-bounds error in fixed 26-element array."
          },
          {
            "title": "4. Memory Leak in C++ Trie Deletion",
            "desc": "Failing to recursively delete allocated TrieNode heap objects when resetting or clearing the dictionary."
          }
        ],
        commonMistakesBn: [
          {
            "title": "১. `isEndOfWord = true` ফ্ল্যাগ দিতে ভুলে যাওয়া",
            "desc": "শব্দের শেষ নোডে ফ্ল্যাগ না দিলে 'apple' থাকলেও 'app' শব্দটি পৃথক শব্দ হিসেবে খুঁজে পাওয়া যাবে না।"
          },
          {
            "title": "২. `search()` এবং `startsWith()` গুলিয়ে ফেলা",
            "desc": "প্রিফিক্স চেক করতে `search()` ব্যবহার করা। `search()` এর জন্য শব্দের শেষ ফ্ল্যাগ সত্য হতে হয়, কিন্তু `startsWith()` কেবল নোড লিংক চেক করে।"
          },
          {
            "title": "৩. ASCII ইন্ডেক্স সূত্রের ভুল",
            "desc": "ছোট হাতের অক্ষরের জন্য `c - 'a'` এর জায়গায় `c - 'A'` লিখলে ২৬-সাইজের অ্যারেতে আউট অফ বাউন্ডস ঘটে।"
          },
          {
            "title": "৪. C++ হিপ নোড ডিলিট না করায় মেমোরি লিক",
            "desc": "ট্রি রিসেট করার সময় রিকার্সিভলি `delete` না করলে মেমোরি লিক হয়।"
          }
        ],
        roadmapStepsEn: [
          {
            "step": "Step 1",
            "title": "Understand N-ary Character Tree Anatomy",
            "desc": "Master TrieNode struct, child map/array `children[26]`, and `isEndOfWord` boolean flag."
          },
          {
            "step": "Step 2",
            "title": "Master O(L) Insert, Search & StartsWith",
            "desc": "Implement insert, search exact word, and startsWith prefix methods in O(L) time."
          },
          {
            "step": "Step 3",
            "title": "Build Autocomplete Search Engine",
            "desc": "Navigate to prefix node and run DFS to collect all suggested matching words."
          },
          {
            "step": "Step 4",
            "title": "Solve Wildcard '.' Pattern Search",
            "desc": "Implement recursive DFS branching to search wildcard patterns like `b.d`."
          },
          {
            "step": "Step 5",
            "title": "Solve Advanced Word Search II & Suffix Trees",
            "desc": "Combine Trie with 2D Grid DFS for Word Search II and introduce Compressed Tries (Radix Tree)."
          }
        ],
        roadmapStepsBn: [
          {
            "step": "ধাপ ১",
            "title": "N-ary ক্যারেক্টার ট্রি নোড স্ট্রাকচার শিখুন",
            "desc": "TrieNode স্ট্রাকচার, চাইল্ড ম্যাপ `children[26]`, এবং `isEndOfWord` ফ্ল্যাগ আয়ত্ত করুন।"
          },
          {
            "step": "ধাপ ২",
            "title": "O(L) ইনসার্ট, সার্চ ও প্রিফিক্স ম্যাচিং",
            "desc": "শব্দ যোগ, হুবহু শব্দ খোঁজা এবং প্রিফিক্স ম্যাচিং মেথড O(L) সময়ে কোড করুন।"
          },
          {
            "step": "ধাপ ৩",
            "title": "অটো-কমপ্লিট সার্চ ইঞ্জিন তৈরি করুন",
            "desc": "প্রিফিক্স নোডে গিয়ে DFS চালিয়ে সমস্ত প্রস্তাবিত শব্দ সাজেস্ট করা শিখুন।"
          },
          {
            "step": "ধাপ ৪",
            "title": "ওয়াইল্ডকার্ড '.' প্যাটার্ন সার্চ প্রবলেম",
            "desc": "রিকার্সিভ DFS দিয়ে `b.d` টাইপের ওয়াইল্ডকার্ড শব্দ ম্যাচিং সলভ করুন।"
          },
          {
            "step": "ধাপ ৫",
            "title": "Word Search II ও সাফিক্স ট্রি",
            "desc": "২D গ্রিডের সাথে Trie মিলিয়ে Word Search II এবং কম্প্রেসড ট্রাই (Radix Tree) ধারণা।"
          }
        ],
      ),
    ];
  }
}
