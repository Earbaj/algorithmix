import 'package:flutter/material.dart';

class DsaProblem {
  final String id;
  final String title;
  final String category; // e.g. "Graph Basic", "Graph Traversal"
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
  final Map<String, Map<String, String>> multiDimCodeTemplates; // Variant (Adj List, Adj Matrix, BFS/DFS) -> (Language -> Code)
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

      // 8. GRAPH (ADJACENCY LIST & MATRIX)
      DsaTopic(
        id: 208,
        title: "Graph (Adjacency List & Matrix)",
        category: "Non-Linear Network Structure",
        timeComplexity: "BFS O(V + E) | DFS O(V + E) | Edge Lookup O(1) Matrix",
        spaceComplexity: "Adj List: O(V + E) | Adj Matrix: O(V²)",
        icon: Icons.hub_outlined,
        themeColor: const Color(0xFF0284C7),
        descriptionEn:
            "A Graph is a non-linear network structure composed of Vertices (nodes) connected by Edges (links). Graphs are categorized as Directed vs Undirected and Weighted vs Unweighted. In memory, graphs are represented via an Adjacency List (dynamic array of neighbors per node, O(V + E) space) or an Adjacency Matrix (V×V 2D grid, O(V²) space for O(1) edge checks). Graph algorithms include Breadth-First Search (BFS using Queue for shortest path in unweighted graphs) and Depth-First Search (DFS using Stack/Recursion for deep exploration).",
        descriptionBn:
            "গ্রাফ হলো একটি নন-লিনিয়ার নেটওয়ার্ক স্ট্রাকচার যা ভার্টেক্স বা নোড (Vertices) এবং এজ বা সংযোগকারী লাইন (Edges) নিয়ে গঠিত। গ্রাফকে ডাইরেক্টেড (Directed) বনাম আনডাইরেক্টেড (Undirected) এবং ওয়েটেড (Weighted) বনাম আনওয়েটেড (Unweighted) হিসেবে ভাগ করা হয়। মেমোরিতে গ্রাফ সংরক্ষণের ২টি মূল উপায়: অ্যাডজাসেন্সি লিস্ট (Adjacency List, O(V + E) স্পেস) এবং অ্যাডজাসেন্সি ম্যাট্রিক্স (Adjacency Matrix, V×V 2D গ্রিড, O(1) এজ চেকিং)। গ্রাফ অ্যালগরিদমের মূল ভিত্তি হলো BFS (কিউ দিয়ে লেভেল-বাই-লেভেল শর্টেস্ট পাথ) এবং DFS (স্ট্যাক/রিকার্শন দিয়ে ডিপ ট্রাভার্সাল)।",
        keyConceptsEn: [
          "Vertices & Edges: V represents nodes/entities; E represents connections between node pairs.",
          "Adjacency List Representation: Dynamic array `adj[u] = [v1, v2]` taking memory-efficient O(V + E) space.",
          "Adjacency Matrix Representation: 2D Grid `matrix[u][v] = 1` taking O(V²) space allowing O(1) instant edge verification.",
          "Breadth-First Search (BFS): Level-by-level traversal using Queue guaranteeing Shortest Path in unweighted graphs.",
          "Depth-First Search (DFS): Deep branch exploration using Stack/Recursion used in Topological Sort and Cycle Detection."
        ],
        keyConceptsBn: [
          "ভার্টেক্স ও এজ: V হলো নোড বা শহরের তালিকা; E হলো নোডসমূহের মধ্যকার সংযোগকারী রাস্তা।",
          "অ্যাডজাসেন্সি লিস্ট: ডাইনামিক অ্যারে `adj[u] = [v1, v2]` যা মেমোরি-দক্ষ O(V + E) স্পেস নেয়।",
          "অ্যাডজাসেন্সি ম্যাট্রিক্স: V×V 2D গ্রিড `matrix[u][v] = 1` যা O(V²) স্পেস নিলেও O(1) সময়ে এজ আছে কিনা চেক করে।",
          "Breadth-First Search (BFS): কিউ দিয়ে লেভেল-বাই-লেভেল ট্রাভার্সাল যা আনওয়েটেড গ্রাফে শর্টেস্ট পাথ গ্যারান্টি দেয়।",
          "Depth-First Search (DFS): স্ট্যাক বা রিকার্শন দিয়ে ডিপ ব্রাঞ্চ সার্চ যা সাইকেল ডিটেকশন ও টপোলজিক্যাল সর্টে ব্যবহৃত হয়।"
        ],
        multiDimCodeTemplates: {
          "Adjacency List (O(V+E))": {
            "C++": """
#include <iostream>
#include <vector>
using namespace std;

class Graph {
    int V;
    vector<vector<int>> adj;
public:
    Graph(int v) : V(v), adj(v) {}
    
    // Undirected Edge O(1)
    void addEdge(int u, int v) {
        adj[u].push_back(v);
        adj[v].push_back(u);
    }
    
    void printAdjList() {
        for (int i = 0; i < V; i++) {
            cout << "Node " << i << " -> ";
            for (int neighbor : adj[i]) cout << neighbor << " ";
            cout << endl;
        }
    }
};

int main() {
    Graph g(4);
    g.addEdge(0, 1); g.addEdge(0, 2); g.addEdge(1, 3);
    g.printAdjList();
    return 0;
}""",
            "Java": """
import java.util.ArrayList;
import java.util.List;

public class GraphAdjList {
    private int V;
    private List<List<Integer>> adj;
    
    public GraphAdjList(int v) {
        this.V = v;
        adj = new ArrayList<>();
        for (int i = 0; i < v; i++) adj.add(new ArrayList<>());
    }
    public void addEdge(int u, int v) {
        adj.get(u).add(v);
        adj.get(v).add(u);
    }
}""",
            "Python": """
from collections import defaultdict

class GraphAdjList:
    def __init__(self):
        self.adj = defaultdict(list)
        
    def add_edge(self, u, v, directed=False):
        self.adj[u].append(v)
        if not directed:
            self.adj[v].append(u)

g = GraphAdjList()
g.add_edge(0, 1); g.add_edge(0, 2); g.add_edge(1, 3)
print("Graph Adj List:", dict(g.adj))""",
            "JavaScript": """
class GraphAdjList {
    constructor() {
        this.adj = new Map();
    }
    addNode(node) {
        if (!this.adj.has(node)) this.adj.set(node, []);
    }
    addEdge(u, v) {
        this.addNode(u); this.addNode(v);
        this.adj.get(u).push(v);
        this.adj.get(v).push(u);
    }
}

const g = new GraphAdjList();
g.addEdge(0, 1); g.addEdge(0, 2);"""
          },
          "Adjacency Matrix (O(V²))": {
            "C++": """
#include <iostream>
#include <vector>
using namespace std;

class GraphMatrix {
    int V;
    vector<vector<int>> matrix;
public:
    GraphMatrix(int v) : V(v), matrix(v, vector<int>(v, 0)) {}
    
    void addEdge(int u, int v) {
        matrix[u][v] = 1;
        matrix[v][u] = 1;
    }
    
    bool hasEdge(int u, int v) {
        return matrix[u][v] == 1; // O(1) Edge Lookup
    }
};""",
            "Java": """
public class GraphMatrix {
    private int V;
    private int[][] matrix;
    
    public GraphMatrix(int v) {
        this.V = v;
        matrix = new int[v][v];
    }
    public void addEdge(int u, int v) {
        matrix[u][v] = 1;
        matrix[v][u] = 1;
    }
    public boolean hasEdge(int u, int v) {
        return matrix[u][v] == 1;
    }
}""",
            "Python": """
class GraphMatrix:
    def __init__(self, v):
        self.V = v
        self.matrix = [[0] * v for _ in range(v)]
        
    def add_edge(self, u, v):
        self.matrix[u][v] = 1
        self.matrix[v][u] = 1
        
    def has_edge(self, u, v):
        return self.matrix[u][v] == 1""",
            "JavaScript": """
class GraphMatrix {
    constructor(v) {
        this.V = v;
        this.matrix = Array.from({length: v}, () => new Array(v).fill(0));
    }
    addEdge(u, v) {
        this.matrix[u][v] = 1;
        this.matrix[v][u] = 1;
    }
}"""
          },
          "BFS & DFS Traversals": {
            "C++": """
#include <iostream>
#include <vector>
#include <queue>
using namespace std;

// BFS Traversal using Queue O(V + E)
void bfs(int startNode, vector<vector<int>>& adj, int V) {
    vector<bool> visited(V, false);
    queue<int> q;
    
    visited[startNode] = true;
    q.push(startNode);
    
    while (!q.empty()) {
        int u = q.front(); q.pop();
        cout << u << " ";
        
        for (int v : adj[u]) {
            if (!visited[v]) {
                visited[v] = true;
                q.push(v);
            }
        }
    }
}

// DFS Recursive Traversal O(V + E)
void dfs(int u, vector<vector<int>>& adj, vector<bool>& visited) {
    visited[u] = true;
    cout << u << " ";
    for (int v : adj[u]) {
        if (!visited[v]) dfs(v, adj, visited);
    }
}""",
            "Java": """
public static void bfs(int start, List<List<Integer>> adj, int V) {
    boolean[] visited = new boolean[V];
    Queue<Integer> q = new ArrayDeque<>();
    visited[start] = true;
    q.offer(start);
    while (!q.isEmpty()) {
        int u = q.poll();
        System.out.print(u + " ");
        for (int v : adj.get(u)) {
            if (!visited[v]) {
                visited[v] = true;
                q.offer(v);
            }
        }
    }
}""",
            "Python": """
from collections import deque

def bfs(start, adj):
    visited = set([start])
    q = deque([start])
    res = []
    while q:
        u = q.popleft()
        res.append(u)
        for v in adj[u]:
            if v not in visited:
                visited.add(v)
                q.append(v)
    return res""",
            "JavaScript": """
function bfs(start, adj) {
    const visited = new Set([start]);
    const q = [start];
    const res = [];
    while (q.length > 0) {
        const u = q.shift();
        res.push(u);
        for (let v of (adj.get(u) || [])) {
            if (!visited.has(v)) {
                visited.add(v);
                q.push(v);
            }
        }
    }
    return res;
}"""
          }
        },
        basicProblems: [
          DsaProblem(
            id: "gr-1",
            title: "1. Number of Islands (LeetCode #200)",
            category: "Graph Basic",
            keyIdeaEn: "Iterate over 2D grid matrix. When finding '1', increment island count and run BFS/DFS to sink connected land cells to '0'.",
            keyIdeaBn: "২D গ্রিড ম্যাট্রিক্স ট্রাভার্স করুন। '1' পেলে আইল্যান্ড কাউন্ট বাড়ান এবং BFS/DFS চালিয়ে সংলগ্ন সব '1' কে '0' বানিয়ে দিন।",
            codeCpp: """
void dfs(vector<vector<char>>& grid, int r, int c) {
    int R = grid.size(), C = grid[0].size();
    if (r < 0 || r >= R || c < 0 || c >= C || grid[r][c] == '0') return;
    grid[r][c] = '0'; // Sink land
    dfs(grid, r+1, c); dfs(grid, r-1, c);
    dfs(grid, r, c+1); dfs(grid, r, c-1);
}
int numIslands(vector<vector<char>>& grid) {
    int count = 0;
    for (int r = 0; r < grid.size(); r++) {
        for (int c = 0; c < grid[0].size(); c++) {
            if (grid[r][c] == '1') {
                count++;
                dfs(grid, r, c);
            }
        }
    }
    return count;
}""",
            codeJava: """
public static int numIslands(char[][] grid) {
    int count = 0;
    for (int r = 0; r < grid.length; r++) {
        for (int c = 0; c < grid[0].length; c++) {
            if (grid[r][c] == '1') {
                count++;
                dfs(grid, r, c);
            }
        }
    }
    return count;
}
private static void dfs(char[][] grid, int r, int c) {
    if (r < 0 || r >= grid.length || c < 0 || c >= grid[0].length || grid[r][c] == '0') return;
    grid[r][c] = '0';
    dfs(grid, r + 1, c); dfs(grid, r - 1, c);
    dfs(grid, r, c + 1); dfs(grid, r, c - 1);
}""",
            codePython: """
def numIslands(grid):
    if not grid: return 0
    R, C = len(grid), len(grid[0])
    count = 0
    
    def dfs(r, c):
        if r < 0 or r >= R or c < 0 or c >= C or grid[r][c] == '0':
            return
        grid[r][c] = '0'
        dfs(r+1, c); dfs(r-1, c); dfs(r, c+1); dfs(r, c-1)
        
    for r in range(R):
        for c in range(C):
            if grid[r][c] == '1':
                count += 1
                dfs(r, c)
    return count""",
            codeJs: """
function numIslands(grid) {
    let count = 0;
    const R = grid.length, C = grid[0].length;
    function dfs(r, c) {
        if (r < 0 || r >= R || c < 0 || c >= C || grid[r][c] === '0') return;
        grid[r][c] = '0';
        dfs(r+1, c); dfs(r-1, c); dfs(r, c+1); dfs(r, c-1);
    }
    for (let r = 0; r < R; r++) {
        for (let c = 0; c < C; c++) {
            if (grid[r][c] === '1') {
                count++;
                dfs(r, c);
            }
        }
    }
    return count;
}""",
            descriptionEn: "Given an `m x n` 2D binary grid representing a map of '1's (land) and '0's (water), return the total number of islands.",
            descriptionBn: "'1' (ডাঙা) এবং '0' (পানি) সমৃদ্ধ `m x n` ২D বাইনারি গ্রিড থেকে মোট দ্বীপের সংখ্যা (Islands) গণনা করুন।",
            sampleInputs: ["grid = [[\"1\",\"1\",\"0\",\"0\"],[\"1\",\"1\",\"0\",\"0\"],[\"0\",\"0\",\"1\",\"0\"],[\"0\",\"0\",\"0\",\"1\"]]"],
            sampleOutputs: ["3 Islands"],
          ),
          DsaProblem(
            id: "gr-2",
            title: "2. Course Schedule - Cycle Detection (LeetCode #207)",
            category: "Graph Pattern",
            keyIdeaEn: "Build directed graph and calculate in-degree of all nodes. Run BFS (Kahn's Algorithm). If processed nodes count == V, course schedule is possible!",
            keyIdeaBn: "ডাইরেক্টেড গ্রাফ তৈরি করে প্রতিটি নোডের In-degree হিসেব করুন। Kahn's BFS অ্যালগরিদম রান করে সাইকেল আছে কিনা চেক করুন।",
            codeCpp: """
bool canFinish(int numCourses, vector<vector<int>>& prerequisites) {
    vector<vector<int>> adj(numCourses);
    vector<int> inDegree(numCourses, 0);
    for (auto& p : prerequisites) {
        adj[p[1]].push_back(p[0]);
        inDegree[p[0]]++;
    }
    queue<int> q;
    for (int i = 0; i < numCourses; i++) {
        if (inDegree[i] == 0) q.push(i);
    }
    int count = 0;
    while (!q.empty()) {
        int u = q.front(); q.pop();
        count++;
        for (int v : adj[u]) {
            if (--inDegree[v] == 0) q.push(v);
        }
    }
    return count == numCourses;
}""",
            codeJava: """
public static boolean canFinish(int numCourses, int[][] prerequisites) {
    List<List<Integer>> adj = new ArrayList<>();
    int[] inDegree = new int[numCourses];
    for (int i = 0; i < numCourses; i++) adj.add(new ArrayList<>());
    for (int[] p : prerequisites) {
        adj.get(p[1]).add(p[0]);
        inDegree[p[0]]++;
    }
    Queue<Integer> q = new ArrayDeque<>();
    for (int i = 0; i < numCourses; i++) {
        if (inDegree[i] == 0) q.offer(i);
    }
    int count = 0;
    while (!q.isEmpty()) {
        int u = q.poll();
        count++;
        for (int v : adj.get(u)) {
            if (--inDegree[v] == 0) q.offer(v);
        }
    }
    return count == numCourses;
}""",
            codePython: """
from collections import defaultdict, deque

def canFinish(numCourses, prerequisites):
    adj = defaultdict(list)
    in_degree = [0] * numCourses
    for dest, src in prerequisites:
        adj[src].append(dest)
        in_degree[dest] += 1
        
    q = deque([i for i in range(numCourses) if in_degree[i] == 0])
    count = 0
    while q:
        u = q.popleft()
        count += 1
        for v in adj[u]:
            in_degree[v] -= 1
            if in_degree[v] == 0:
                q.append(v)
    return count == numCourses""",
            codeJs: """
function canFinish(numCourses, prerequisites) {
    const adj = Array.from({length: numCourses}, () => []);
    const inDegree = new Array(numCourses).fill(0);
    for (let [dest, src] of prerequisites) {
        adj[src].push(dest);
        inDegree[dest]++;
    }
    const q = [];
    for (let i = 0; i < numCourses; i++) {
        if (inDegree[i] === 0) q.push(i);
    }
    let count = 0;
    while (q.length > 0) {
        const u = q.shift();
        count++;
        for (let v of adj[u]) {
            inDegree[v]--;
            if (inDegree[v] === 0) q.push(v);
        }
    }
    return count === numCourses;
}""",
            descriptionEn: "Determine if it is possible to complete all `numCourses` given a list of prerequisite course pairs.",
            descriptionBn: "কোর্স পূর্বশর্তের (Prerequisites) তালিকা থেকে সাইকেল চেক করে সব কোর্স সম্পন্ন করা সম্ভব কিনা নিরূপণ করুন।",
            sampleInputs: ["numCourses = 2, prerequisites = [[1,0]]"],
            sampleOutputs: ["true (Take course 0 then course 1)"],
          ),
        ],
        commonMistakesEn: [
          {
            "title": "1. Missing `visited[]` Set causing Infinite Loop",
            "desc": "Traversing a cyclic graph without marking visited nodes causes infinite recursive recursion or queue overflow."
          },
          {
            "title": "2. Using Adjacency Matrix for Sparse Graphs",
            "desc": "Using a V×V matrix when E is small wastes O(V²) memory space. Use an Adjacency List instead."
          },
          {
            "title": "3. Confusing Directed vs Undirected Edge Insertions",
            "desc": "Forgetting `adj[v].push_back(u)` when adding an undirected edge breaks two-way navigation."
          },
          {
            "title": "4. StackOverflowError in Deep DFS Recursion",
            "desc": "Running recursive DFS on deep linear graphs exceeds system call stack limit. Use iterative DFS with Stack."
          }
        ],
        commonMistakesBn: [
          {
            "title": "১. `visited[]` সেট ব্যবহার করতে ভুলে যাওয়া",
            "desc": "সাইক্লিক গ্রাফে ভিজিটেড নোড ট্র্যাক না করলে রিকার্শন বা কিউ অসীম লুপে পড়ে অ্যাপ ক্র্যাশ করে।"
          },
          {
            "title": "২. ছোট গ্রাফে অ্যাডজাসেন্সি ম্যাট্রিক্স ব্যবহার",
            "desc": "এজের সংখ্যা কম থাকলে V×V ম্যাট্রিক্স বিশাল O(V²) মেমোরি অপচয় করে। অ্যাডজাসেন্সি লিস্ট ব্যবহার করুন।"
          },
          {
            "title": "৩. ডাইরেক্টেড ও আনডাইরেক্টেড এজের পজিশন গুলিয়ে ফেলা",
            "desc": "আনডাইরেক্টেড এজে `adj[v].push_back(u)` বাদ দিলে দুইমুখী পথ বন্ধ হয়ে যায়।"
          },
          {
            "title": "৪. গভীর DFS রিকার্শনে StackOverflowError",
            "desc": "গভীর গ্রাফে রিকার্সিভ DFS চালালে সিস্টেমের কল স্ট্যাক সীমা পার হয়ে যায়। ইটারেটিভ DFS ব্যবহার করুন।"
          }
        ],
        roadmapStepsEn: [
          {
            "step": "Step 1",
            "title": "Understand Graph Components (Vertices & Edges)",
            "desc": "Master Directed vs Undirected, Weighted vs Unweighted graphs and memory representations."
          },
          {
            "step": "Step 2",
            "title": "Master Adjacency List & Adjacency Matrix",
            "desc": "Build Adjacency List O(V+E) and 2D Matrix O(V²) representation classes in code."
          },
          {
            "step": "Step 3",
            "title": "Master Breadth-First Search (BFS)",
            "desc": "Implement Queue-based BFS for level order traversal and unweighted Shortest Path."
          },
          {
            "step": "Step 4",
            "title": "Master Depth-First Search (DFS) & 2D Grid Search",
            "desc": "Solve Number of Islands, Flood Fill, and connected components using DFS."
          },
          {
            "step": "Step 5",
            "title": "Learn Cycle Detection & Topological Sort",
            "desc": "Master Kahn's algorithm for Course Schedule, Topological Sort, and Dijkstra's algorithm."
          }
        ],
        roadmapStepsBn: [
          {
            "step": "ধাপ ১",
            "title": "গ্রাফের মূল উপাদান (ভার্টেক্স ও এজ) শিখুন",
            "desc": "ডাইরেক্টেড বনাম আনডাইরেক্টেড, ওয়েটেড বনাম আনওয়েটেড গ্রাফের কনসেপ্ট পরিষ্কার করুন।"
          },
          {
            "step": "ধাপ ২",
            "title": "অ্যাডজাসেন্সি লিস্ট ও অ্যাডজাসেন্সি ম্যাট্রিক্স",
            "desc": "কোডে O(V+E) অ্যাডজাসেন্সি লিস্ট এবং O(V²) ২D ম্যাট্রিক্স ক্লাস ইমপ্লিমেন্ট করুন।"
          },
          {
            "step": "ধাপ ৩",
            "title": "Breadth-First Search (BFS) মাস্টার করুন",
            "desc": "কিউ নির্ভর BFS দিয়ে লেভেল অর্ডার ট্রাভার্সাল এবং শর্টেস্ট পাথ বের করা শিখুন।"
          },
          {
            "step": "ধাপ ৪",
            "title": "Depth-First Search (DFS) ও ২D গ্রিড সার্চ",
            "desc": "DFS দিয়ে Number of Islands, Flood Fill এবং কানেক্টেড কম্পোনেন্ট প্রবলেমস সলভ করুন।"
          },
          {
            "step": "ধাপ ৫",
            "title": "সাইকেল ডিটেকশন ও টপোলজিক্যাল সর্ট",
            "desc": "Kahn's algorithm দিয়ে কোর্স সিডিউল, টপোলজিক্যাল সর্ট এবং ডাইকস্ট্রা শর্টেস্ট পাথ।"
          }
        ],
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
