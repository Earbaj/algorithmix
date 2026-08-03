import 'package:flutter/material.dart';
import 'package:algorithmix/domain/models/pattern_model.dart';
import 'package:algorithmix/domain/models/algorithm_model.dart';
import 'package:algorithmix/domain/models/dsa_model.dart';

class PatternRepository {
  static List<PatternModel> getCorePatterns() {
    return const [
      PatternModel(
        id: 1,
        title: "1. Time & Space Complexity (Big O)",
        category: "Foundations",
        difficulty: PatternDifficulty.beginner,
        icon: Icons.timer_outlined,
        themeColor: Color(0xFF06B6D4),
        description: "Analyze algorithm efficiency using asymptotic notation: O(1), O(log N), O(N), O(N log N), O(N²), O(2ⁿ).",
        timeComplexity: "O(1) to O(2ⁿ)",
        spaceComplexity: "O(1) to O(N)",
        keyConcepts: [
          "Asymptotic upper bound definition",
          "Dominant terms vs constants",
          "Memory overhead on call stack",
          "Best, Average, Worst case analysis"
        ],
        sampleCode: """
// Big O Complexity Comparison
void analyzeComplexity(int n) {
  // Constant Time - O(1)
  int first = n * 2;
  
  // Linear Time - O(N)
  for (int i = 0; i < n; i++) {
    print(i);
  }
  
  // Quadratic Time - O(N^2)
  for (int i = 0; i < n; i++) {
    for (int j = 0; j < n; j++) {
      print("\$i, \$j");
    }
  }
}""",
      ),
      PatternModel(
        id: 2,
        title: "2. Basic Data Structures",
        category: "Foundations",
        difficulty: PatternDifficulty.beginner,
        icon: Icons.dataset_outlined,
        themeColor: Color(0xFF3B82F6),
        description: "Core primitives: Arrays, Fixed Strings, Dynamic Lists, Hash Tables, and Pointers.",
        timeComplexity: "O(1) Access / Search O(N)",
        spaceComplexity: "O(N)",
        keyConcepts: [
          "Contiguous memory layout",
          "Hash functions and collision handling",
          "Index-based O(1) lookup",
          "Dynamic array capacity doubling"
        ],
        sampleCode: """
// HashMap O(1) Lookup
Map<String, int> map = {};
map['apple'] = 5;
map['banana'] = 3;

if (map.containsKey('apple')) {
  print('Count: \${map['apple']}');
}""",
      ),
      PatternModel(
        id: 3,
        title: "3. Recursion & Backtracking Basics",
        category: "Foundations",
        difficulty: PatternDifficulty.intermediate,
        icon: Icons.account_tree_outlined,
        themeColor: Color(0xFF8B5CF6),
        description: "Solving problems by breaking them into smaller subproblems with explicit base cases and call stacks.",
        timeComplexity: "O(2ⁿ) or O(N!)",
        spaceComplexity: "O(N) Recursion Stack",
        keyConcepts: [
          "Base Case requirement",
          "Call stack unwind",
          "State space tree traversal",
          "Pruning invalid branches"
        ],
        sampleCode: """
void solveBacktrack(List<int> nums, List<int> current, int index) {
  if (index == nums.length) {
    print(current);
    return;
  }
  // Include element
  current.add(nums[index]);
  solveBacktrack(nums, current, index + 1);
  
  // Backtrack
  current.removeLast();
  solveBacktrack(nums, current, index + 1);
}""",
      ),
      PatternModel(
        id: 4,
        title: "4. Two Pointers",
        category: "Pointers & Arrays",
        difficulty: PatternDifficulty.beginner,
        icon: Icons.swap_horiz_outlined,
        themeColor: Color(0xFF10B981),
        description: "Two indices moving towards each other or in parallel to search pairs or process sorted arrays in linear time.",
        timeComplexity: "O(N)",
        spaceComplexity: "O(1)",
        keyConcepts: [
          "Sorted array precondition",
          "Opposite directional pointers (Left/Right)",
          "Same direction pointers (Slow/Fast)",
          "Eliminates nested loops"
        ],
        sampleCode: """
bool pairWithTargetSum(List<int> arr, int target) {
  int left = 0, right = arr.length - 1;
  while (left < right) {
    int currentSum = arr[left] + arr[right];
    if (currentSum == target) return true;
    if (currentSum < target) left++;
    else right--;
  }
  return false;
}""",
      ),
      PatternModel(
        id: 5,
        title: "5. Sliding Window",
        category: "Pointers & Arrays",
        difficulty: PatternDifficulty.intermediate,
        icon: Icons.view_sidebar_outlined,
        themeColor: Color(0xFFF59E0B),
        description: "Maintain a contiguous dynamic or fixed range over array/string to calculate subarray statistics in O(N).",
        timeComplexity: "O(N)",
        spaceComplexity: "O(1) or O(K)",
        keyConcepts: [
          "Fixed vs Dynamic window size",
          "Expand right pointer to satisfy criteria",
          "Shrink left pointer to minimize/optimize",
          "Frequency map tracking"
        ],
        sampleCode: """
int maxSubarraySum(List<int> arr, int k) {
  int maxSum = 0, windowSum = 0;
  for (int i = 0; i < arr.length; i++) {
    windowSum += arr[i];
    if (i >= k - 1) {
      if (windowSum > maxSum) maxSum = windowSum;
      windowSum -= arr[i - (k - 1)];
    }
  }
  return maxSum;
}""",
      ),
      PatternModel(
        id: 6,
        title: "6. Fast & Slow Pointers (Floyd's Cycle Detection)",
        category: "Pointers & Arrays",
        difficulty: PatternDifficulty.intermediate,
        icon: Icons.loop_outlined,
        themeColor: Color(0xFFEC4899),
        description: "Two pointers moving at different speeds to detect cycles in linked lists, arrays, or find midpoints.",
        timeComplexity: "O(N)",
        spaceComplexity: "O(1)",
        keyConcepts: [
          "Tortoise and Hare algorithm",
          "Cycle boundary intersection",
          "Middle element of Linked List",
          "Happy number determination"
        ],
        sampleCode: """
bool hasCycle(ListNode? head) {
  ListNode? slow = head, fast = head;
  while (fast != null && fast.next != null) {
    slow = slow?.next;
    fast = fast.next?.next;
    if (slow == fast) return true;
  }
  return false;
}""",
      ),
      PatternModel(
        id: 7,
        title: "7. Merge Intervals",
        category: "Arrays & Intervals",
        difficulty: PatternDifficulty.intermediate,
        icon: Icons.merge_type_outlined,
        themeColor: Color(0xFF6366F1),
        description: "Sort overlapping time intervals and merge or find overlaps cleanly.",
        timeComplexity: "O(N log N)",
        spaceComplexity: "O(N)",
        keyConcepts: [
          "Sort intervals by Start Time",
          "Compare interval.start with prev.end",
          "Update merged interval max end point",
          "Interval insertion & collision"
        ],
        sampleCode: """
List<List<int>> mergeIntervals(List<List<int>> intervals) {
  if (intervals.length <= 1) return intervals;
  intervals.sort((a, b) => a[0].compareTo(b[0]));
  List<List<int>> merged = [intervals[0]];
  for (int i = 1; i < intervals.length; i++) {
    var last = merged.last;
    if (intervals[i][0] <= last[1]) {
      last[1] = last[1] > intervals[i][1] ? last[1] : intervals[i][1];
    } else {
      merged.add(intervals[i]);
    }
  }
  return merged;
}""",
      ),
      PatternModel(
        id: 8,
        title: "8. Cyclic Sort",
        category: "Arrays & Intervals",
        difficulty: PatternDifficulty.intermediate,
        icon: Icons.refresh_outlined,
        themeColor: Color(0xFF14B8A6),
        description: "Iterate through numbers in range 1 to N, placing each element at index `nums[i] - 1` in O(N) time.",
        timeComplexity: "O(N)",
        spaceComplexity: "O(1)",
        keyConcepts: [
          "Array contains numbers in bounded range [1...N]",
          "In-place element swapping",
          "Detect missing or duplicate numbers",
          "Zero-indexed mapping index = val - 1"
        ],
        sampleCode: """
void cyclicSort(List<int> nums) {
  int i = 0;
  while (i < nums.length) {
    int correctIndex = nums[i] - 1;
    if (nums[i] != nums[correctIndex]) {
      int temp = nums[i];
      nums[i] = nums[correctIndex];
      nums[correctIndex] = temp;
    } else {
      i++;
    }
  }
}""",
      ),
      PatternModel(
        id: 9,
        title: "9. In-place Reversal of Linked List",
        category: "Linked List",
        difficulty: PatternDifficulty.intermediate,
        icon: Icons.low_priority_outlined,
        themeColor: Color(0xFFA855F7),
        description: "Reverse pointers between nodes without using extra memory allocation.",
        timeComplexity: "O(N)",
        spaceComplexity: "O(1)",
        keyConcepts: [
          "Three-pointer tracking (Prev, Curr, Next)",
          "Reverse pointer directional reference",
          "Sub-list reversal between index K and M",
          "K-group reversal logic"
        ],
        sampleCode: """
ListNode? reverseList(ListNode? head) {
  ListNode? prev = null;
  ListNode? current = head;
  while (current != null) {
    ListNode? nextTemp = current.next;
    current.next = prev;
    prev = current;
    current = nextTemp;
  }
  return prev;
}""",
      ),
      PatternModel(
        id: 10,
        title: "10. Tree BFS (Level Order Traversal)",
        category: "Trees",
        difficulty: PatternDifficulty.beginner,
        icon: Icons.format_list_bulleted_outlined,
        themeColor: Color(0xFF0EA5E9),
        description: "Traverse tree nodes level-by-level using a FIFO Queue.",
        timeComplexity: "O(N)",
        spaceComplexity: "O(N) Queue size",
        keyConcepts: [
          "FIFO Queue initialization",
          "Level size snapshot (`int levelSize = queue.length`)",
          "Level order node processing",
          "Zigzag traversal & level averages"
        ],
        sampleCode: """
List<List<int>> levelOrder(TreeNode? root) {
  List<List<int>> result = [];
  if (root == null) return result;
  List<TreeNode> queue = [root];
  while (queue.isNotEmpty) {
    int levelSize = queue.length;
    List<int> currentLevel = [];
    for (int i = 0; i < levelSize; i++) {
      TreeNode node = queue.removeAt(0);
      currentLevel.add(node.val);
      if (node.left != null) queue.add(node.left!);
      if (node.right != null) queue.add(node.right!);
    }
    result.add(currentLevel);
  }
  return result;
}""",
      ),
      PatternModel(
        id: 11,
        title: "11. Tree DFS (Preorder/Inorder/Postorder)",
        category: "Trees",
        difficulty: PatternDifficulty.intermediate,
        icon: Icons.account_tree,
        themeColor: Color(0xFFD97706),
        description: "Traverse tree paths deeply before backtracking using call stack or explicit stack.",
        timeComplexity: "O(N)",
        spaceComplexity: "O(H) Height of tree",
        keyConcepts: [
          "Preorder: Root -> Left -> Right",
          "Inorder: Left -> Root -> Right (Sorted in BST)",
          "Postorder: Left -> Right -> Root",
          "Path Sum & Target Path verification"
        ],
        sampleCode: """
void inorderTraversal(TreeNode? node, List<int> result) {
  if (node == null) return;
  inorderTraversal(node.left, result);
  result.add(node.val);
  inorderTraversal(node.right, result);
}""",
      ),
      PatternModel(
        id: 12,
        title: "12. Two Heaps",
        category: "Heaps",
        difficulty: PatternDifficulty.advanced,
        icon: Icons.dynamic_feed_outlined,
        themeColor: Color(0xFFE11D48),
        description: "Maintain a Max-Heap for the smaller half and a Min-Heap for the larger half to find median in O(1).",
        timeComplexity: "Insert O(log N) / Median O(1)",
        spaceComplexity: "O(N)",
        keyConcepts: [
          "Max Heap (Stores smaller numbers)",
          "Min Heap (Stores larger numbers)",
          "Heap rebalancing step",
          "Continuous stream median tracking"
        ],
        sampleCode: """
// Dual Heap Balance
void addNum(int num) {
  // Add to maxHeap or minHeap depending on comparison
  // Rebalance: maxHeap size == minHeap size (+/- 1)
}""",
      ),
      PatternModel(
        id: 13,
        title: "13. Subsets / Backtracking",
        category: "Backtracking",
        difficulty: PatternDifficulty.intermediate,
        icon: Icons.account_tree_sharp,
        themeColor: Color(0xFF0284C7),
        description: "Generate combinations, permutations, and subsets systematically.",
        timeComplexity: "O(2ⁿ) Subsets / O(N!) Permutations",
        spaceComplexity: "O(N)",
        keyConcepts: [
          "Power Set generation",
          "Duplicate element avoidance via sorting",
          "State space tree exploration",
          "Choice / Constraint / Goal template"
        ],
        sampleCode: """
List<List<int>> findSubsets(List<int> nums) {
  List<List<int>> subsets = [[]];
  for (int currentNumber in nums) {
    int n = subsets.length;
    for (int i = 0; i < n; i++) {
      List<int> set = List.from(subsets[i])..add(currentNumber);
      subsets.add(set);
    }
  }
  return subsets;
}""",
      ),
      PatternModel(
        id: 14,
        title: "14. Modified Binary Search",
        category: "Searching",
        difficulty: PatternDifficulty.intermediate,
        icon: Icons.find_in_page_outlined,
        themeColor: Color(0xFF059669),
        description: "Adapt binary search to rotated sorted arrays, unknown length lists, or search spaces.",
        timeComplexity: "O(log N)",
        spaceComplexity: "O(1)",
        keyConcepts: [
          "Calculated mid `low + (high - low) ~/ 2`",
          "Rotated sorted array properties",
          "First / Last occurrence boundary check",
          "Monotonic predicate search spaces"
        ],
        sampleCode: """
int binarySearch(List<int> arr, int target) {
  int low = 0, high = arr.length - 1;
  while (low <= high) {
    int mid = low + (high - low) ~/ 2;
    if (arr[mid] == target) return mid;
    if (arr[mid] < target) low = mid + 1;
    else high = mid - 1;
  }
  return -1;
}""",
      ),
      PatternModel(
        id: 15,
        title: "15. Top K Elements (Heap)",
        category: "Heaps",
        difficulty: PatternDifficulty.intermediate,
        icon: Icons.leaderboard_outlined,
        themeColor: Color(0xFFF97316),
        description: "Use a Min-Heap or Max-Heap to track K smallest or largest elements efficiently.",
        timeComplexity: "O(N log K)",
        spaceComplexity: "O(K)",
        keyConcepts: [
          "Min-Heap size fixed to K for K largest",
          "Pop root when size exceeds K",
          "Frequency map sorting with heaps",
          "Kth largest stream item"
        ],
        sampleCode: """
// Priority Queue / Heap for Top K
// Keeps K largest elements in heap
// If size > K, remove smallest element from Min-Heap""",
      ),
      PatternModel(
        id: 16,
        title: "16. K-way Merge",
        category: "Heaps",
        difficulty: PatternDifficulty.advanced,
        icon: Icons.alt_route_outlined,
        themeColor: Color(0xFF84CC16),
        description: "Merge K sorted lists or arrays using a Min-Heap.",
        timeComplexity: "O(N log K)",
        spaceComplexity: "O(K)",
        keyConcepts: [
          "Min-Heap initialized with first element of K lists",
          "Extract minimum element to result",
          "Insert next element from extracted list into heap",
          "K sorted matrix processing"
        ],
        sampleCode: """
// K-way Merge Algorithm
// Min-Heap stores (val, listIndex, elementIndex)
// Pop minimum, push listIndex[elementIndex + 1]""",
      ),
      PatternModel(
        id: 17,
        title: "17. Greedy Algorithms",
        category: "Greedy & Math",
        difficulty: PatternDifficulty.intermediate,
        icon: Icons.bolt_outlined,
        themeColor: Color(0xFFEAB308),
        description: "Make the locally optimal choice at each step to reach a global optimum.",
        timeComplexity: "O(N) or O(N log N)",
        spaceComplexity: "O(1) or O(N)",
        keyConcepts: [
          "Greedy Choice Property",
          "Optimal Substructure",
          "Interval Scheduling & Activity Selection",
          "Huffman Coding & Fractional Knapsack"
        ],
        sampleCode: """
int maxProfit(List<int> prices) {
  int minPrice = double.maxFinite.toInt();
  int maxProfit = 0;
  for (int price in prices) {
    if (price < minPrice) minPrice = price;
    else if (price - minPrice > maxProfit) maxProfit = price - minPrice;
  }
  return maxProfit;
}""",
      ),
      PatternModel(
        id: 18,
        title: "18. Dynamic Programming (DP) ⭐ Most important & most feared",
        category: "Dynamic Programming",
        difficulty: PatternDifficulty.advanced,
        icon: Icons.stars,
        themeColor: Color(0xFFEC4899),
        isHot: true,
        description: "Solve complex optimization problems by breaking them into overlapping subproblems and caching results.",
        timeComplexity: "O(N) to O(N²)",
        spaceComplexity: "O(N) or O(1) optimized",
        keyConcepts: [
          "Overlapping Subproblems & Optimal Substructure",
          "Top-Down Recursion + Memoization",
          "Bottom-Up Tabulation (DP Table)",
          "State space reduction & 1D array space optimization",
          "Common sub-patterns: 0/1 Knapsack, Unbounded Knapsack, LCS, LIS, Fibonacci"
        ],
        sampleCode: """
// 0/1 Knapsack Bottom-Up DP
int solveKnapsack(List<int> weights, List<int> profits, int capacity) {
  int n = profits.length;
  List<List<int>> dp = List.generate(n, (_) => List.filled(capacity + 1, 0));
  
  for (int c = 0; c <= capacity; c++) {
    if (weights[0] <= c) dp[0][c] = profits[0];
  }
  
  for (int i = 1; i < n; i++) {
    for (int c = 1; c <= capacity; c++) {
      int profit1 = 0, profit2 = 0;
      if (weights[i] <= c) profit1 = profits[i] + dp[i - 1][c - weights[i]];
      profit2 = dp[i - 1][c];
      dp[i][c] = profit1 > profit2 ? profit1 : profit2;
    }
  }
  return dp[n - 1][capacity];
}""",
      ),
      PatternModel(
        id: 19,
        title: "19. Topological Sort (Graph)",
        category: "Graphs",
        difficulty: PatternDifficulty.advanced,
        icon: Icons.account_tree_sharp,
        themeColor: Color(0xFF6366F1),
        description: "Linear ordering of vertices in Directed Acyclic Graphs (DAG) based on dependencies.",
        timeComplexity: "O(V + E)",
        spaceComplexity: "O(V + E)",
        keyConcepts: [
          "Kahn's Algorithm (In-Degree Queue)",
          "DFS with Visiting/Visited states",
          "Cycle detection in directed graph",
          "Course schedule dependency resolution"
        ],
        sampleCode: """
List<int> topologicalSort(int vertices, List<List<int>> edges) {
  List<int> sortedOrder = [];
  Map<int, int> inDegree = {for (var i = 0; i < vertices; i++) i: 0};
  Map<int, List<int>> graph = {for (var i = 0; i < vertices; i++) i: []};
  
  for (var edge in edges) {
    int parent = edge[0], child = edge[1];
    graph[parent]!.add(child);
    inDegree[child] = inDegree[child]! + 1;
  }
  
  List<int> sources = [];
  inDegree.forEach((key, val) { if (val == 0) sources.add(key); });
  
  while (sources.isNotEmpty) {
    int vertex = sources.removeAt(0);
    sortedOrder.add(vertex);
    for (var child in graph[vertex]!) {
      inDegree[child] = inDegree[child]! - 1;
      if (inDegree[child] == 0) sources.add(child);
    }
  }
  return sortedOrder;
}""",
      ),
      PatternModel(
        id: 20,
        title: "20. Union Find (Disjoint Set)",
        category: "Graphs",
        difficulty: PatternDifficulty.intermediate,
        icon: Icons.hub_outlined,
        themeColor: Color(0xFF38BDF8),
        description: "Track elements partitioned into disjoint sets for near O(1) graph connectivity & cycle detection.",
        timeComplexity: "O(α(N)) near O(1)",
        spaceComplexity: "O(N)",
        keyConcepts: [
          "Parent array representation",
          "Path Compression optimization",
          "Union by Rank / Size",
          "Connected components count"
        ],
        sampleCode: """
class UnionFind {
  late List<int> parent;
  UnionFind(int n) {
    parent = List.generate(n, (i) => i);
  }
  
  int find(int i) {
    if (parent[i] == i) return i;
    return parent[i] = find(parent[i]); // Path compression
  }
  
  void union(int i, int j) {
    int rootI = find(i);
    int rootJ = find(j);
    if (rootI != rootJ) parent[rootI] = rootJ;
  }
}""",
      ),
      PatternModel(
        id: 21,
        title: "21. Graph Traversal (BFS/DFS)",
        category: "Graphs",
        difficulty: PatternDifficulty.intermediate,
        icon: Icons.explore_outlined,
        themeColor: Color(0xFF22C55E),
        description: "Systematically visit graph nodes to find connected components, shortest paths, or bipartite states.",
        timeComplexity: "O(V + E)",
        spaceComplexity: "O(V)",
        keyConcepts: [
          "Adjacency List vs Matrix representation",
          "Visited set tracking",
          "BFS for unweighted shortest path",
          "DFS for island counting & path searching"
        ],
        sampleCode: """
void bfsGraph(int start, Map<int, List<int>> graph) {
  Set<int> visited = {start};
  List<int> queue = [start];
  while (queue.isNotEmpty) {
    int node = queue.removeAt(0);
    print(node);
    for (int neighbor in graph[node] ?? []) {
      if (!visited.contains(neighbor)) {
        visited.add(neighbor);
        queue.add(neighbor);
      }
    }
  }
}""",
      ),
      PatternModel(
        id: 22,
        title: "22. Trie (Prefix Tree)",
        category: "Advanced Trees",
        difficulty: PatternDifficulty.intermediate,
        icon: Icons.sort_by_alpha_outlined,
        themeColor: Color(0xFFA855F7),
        description: "Tree structure optimized for prefix lookup and autocomplete in strings.",
        timeComplexity: "O(L) where L is string length",
        spaceComplexity: "O(N * L)",
        keyConcepts: [
          "Character map / 26 child array",
          "isEndOfWord boolean flag",
          "Prefix search vs Exact match",
          "Word Dictionary search with wildcards"
        ],
        sampleCode: """
class TrieNode {
  Map<String, TrieNode> children = {};
  bool isEnd = false;
}

class Trie {
  final TrieNode root = TrieNode();
  
  void insert(String word) {
    TrieNode node = root;
    for (int i = 0; i < word.length; i++) {
      String char = word[i];
      node.children.putIfAbsent(char, () => TrieNode());
      node = node.children[char]!;
    }
    node.isEnd = true;
  }
}""",
      ),
      PatternModel(
        id: 23,
        title: "23. Bit Manipulation",
        category: "Bitwise",
        difficulty: PatternDifficulty.intermediate,
        icon: Icons.memory_outlined,
        themeColor: Color(0xFFF43F5E),
        description: "Manipulate individual bits directly using AND, OR, XOR, NOT, and bit shifts.",
        timeComplexity: "O(1) or O(32)",
        spaceComplexity: "O(1)",
        keyConcepts: [
          "XOR properties: A ^ A = 0, A ^ 0 = A",
          "Clear lowest set bit: n & (n - 1)",
          "Get bit mask: 1 << i",
          "Single Number & Missing Number trick"
        ],
        sampleCode: """
int singleNumber(List<int> nums) {
  int result = 0;
  for (int num in nums) {
    result ^= num; // XOR cancels duplicates
  }
  return result;
}""",
      ),
      PatternModel(
        id: 24,
        title: "24. Monotonic Stack",
        category: "Stack & Queue",
        difficulty: PatternDifficulty.intermediate,
        icon: Icons.stacked_bar_chart_outlined,
        themeColor: Color(0xFF3B82F6),
        description: "Stack maintained in strictly increasing or decreasing order to find Next Greater / Smaller Element.",
        timeComplexity: "O(N)",
        spaceComplexity: "O(N)",
        keyConcepts: [
          "Monotonic Increasing vs Decreasing stack",
          "Next Greater Element problem",
          "Daily Temperatures & Stock Span",
          "Largest Rectangle in Histogram"
        ],
        sampleCode: """
List<int> nextGreaterElement(List<int> nums) {
  List<int> result = List.filled(nums.length, -1);
  List<int> stack = []; // Stores indices
  for (int i = 0; i < nums.length; i++) {
    while (stack.isNotEmpty && nums[i] > nums[stack.last]) {
      int idx = stack.removeLast();
      result[idx] = nums[i];
    }
    stack.add(i);
  }
  return result;
}""",
      ),
      PatternModel(
        id: 25,
        title: "25. Prefix Sum",
        category: "Pointers & Arrays",
        difficulty: PatternDifficulty.beginner,
        icon: Icons.functions_outlined,
        themeColor: Color(0xFF10B981),
        description: "Precompute cumulative sum array to query range sums in O(1) time.",
        timeComplexity: "Precompute O(N) / Query O(1)",
        spaceComplexity: "O(N)",
        keyConcepts: [
          "Prefix sum array: `P[i] = P[i-1] + arr[i]`",
          "Range sum query formula: `Sum(L, R) = P[R] - P[L-1]`",
          "Subarray sum equals K (Prefix Sum + HashMap)",
          "2D Prefix Sum matrix range queries"
        ],
        sampleCode: """
class PrefixSum {
  late List<int> prefix;
  PrefixSum(List<int> nums) {
    prefix = List.filled(nums.length + 1, 0);
    for (int i = 0; i < nums.length; i++) {
      prefix[i + 1] = prefix[i] + nums[i];
    }
  }
  int queryRange(int left, int right) {
    return prefix[right + 1] - prefix[left];
  }
}""",
      ),
    ];
  }

  static List<AlgorithmModel> getAlgorithms() {
    return const [
      AlgorithmModel(
        id: 101,
        title: "Quick Sort",
        category: "Sorting",
        complexity: "O(N log N)",
        description: "Divide-and-conquer algorithm using pivot partitioning.",
        icon: Icons.sort_outlined,
        color: Color(0xFF8B5CF6),
      ),
      AlgorithmModel(
        id: 102,
        title: "Merge Sort",
        category: "Sorting",
        complexity: "O(N log N)",
        description: "Stable divide-and-conquer sorting algorithm.",
        icon: Icons.call_split_outlined,
        color: Color(0xFF06B6D4),
      ),
      AlgorithmModel(
        id: 103,
        title: "Dijkstra's Shortest Path",
        category: "Graph",
        complexity: "O((V + E) log V)",
        description: "Single-source shortest path algorithm for non-negative weighted graphs.",
        icon: Icons.alt_route,
        color: Color(0xFF10B981),
      ),
      AlgorithmModel(
        id: 104,
        title: "KMP String Matching",
        category: "Strings",
        complexity: "O(N + M)",
        description: "Pattern matching using longest prefix-suffix table.",
        icon: Icons.search_outlined,
        color: Color(0xFFF59E0B),
      ),
    ];
  }

  static List<DsaModel> getDsaItems() {
    return const [
      DsaModel(
        id: 201,
        title: "Arrays & Dynamic Lists",
        category: "Linear Data Structure",
        timeComplexity: "Access O(1) | Search O(N)",
        description: "Contiguous memory sequence of elements with fast indexing.",
        icon: Icons.view_column_outlined,
        color: Color(0xFF3B82F6),
      ),
      DsaModel(
        id: 202,
        title: "Singly & Doubly Linked List",
        category: "Linear Data Structure",
        timeComplexity: "Insertion O(1) | Access O(N)",
        description: "Nodes containing value and pointers to next/previous nodes.",
        icon: Icons.link_outlined,
        color: Color(0xFF8B5CF6),
      ),
      DsaModel(
        id: 203,
        title: "Binary Search Tree & AVL Tree",
        category: "Hierarchical",
        timeComplexity: "Search O(log N) | Insert O(log N)",
        description: "Self-balancing tree maintaining sorted data structure.",
        icon: Icons.account_tree_outlined,
        color: Color(0xFF10B981),
      ),
      DsaModel(
        id: 204,
        title: "Min & Max Heap",
        category: "Priority Structure",
        timeComplexity: "Peek O(1) | Insert/Pop O(log N)",
        description: "Complete binary tree satisfying heap invariant for priority processing.",
        icon: Icons.layers_outlined,
        color: Color(0xFFEC4899),
      ),
    ];
  }
}
