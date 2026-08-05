import 'package:flutter/material.dart';

class DsaProblem {
  final String id;
  final String title;
  final String category; // e.g. "BST Basic", "BST Pattern"
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
  final Map<String, Map<String, String>> multiDimCodeTemplates; // Variant (Standard BST, Tree Traversals, Self-Balancing) -> (Language -> Code)
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
        descriptionEn:
            "A Binary Search Tree (BST) is a hierarchical node-based tree structure maintaining the strict BST Invariant: for every node X, all values in its left subtree are strictly smaller than X (`left->val < X->val`), and all values in its right subtree are strictly larger than X (`right->val > X->val`). An Inorder Traversal (Left-Node-Right) on a BST always visits nodes in strictly sorted ascending order.",
        descriptionBn:
            "বাইনারি সার্চ ট্রি (BST) হলো একটি নোড-ভিত্তিক ট্রি স্ট্রাকচার যা BST নিয়ম মেনে চলে: যেকোনো নোড X এর জন্য তার বাম সাবট্রির সব মান X এর চেয়ে ছোট (`left->val < X->val`) এবং ডান সাবট্রির সব মান X এর চেয়ে বড় (`right->val > X->val`) হয়। BST তে Inorder Traversal (Left-Node-Right) করলে সব উপাদান ছোট থেকে বড় (Sorted Order) সাজানো পাওয়া যায়।",
        keyConceptsEn: [
          "BST Invariant Property: Left Subtree < Root Node < Right Subtree for every single node in the tree.",
          "Inorder Traversal Sorted Order: Visiting Left -> Root -> Right outputs elements in strictly ascending sorted order.",
          "O(log N) Average Search & Insert: At each comparison, half of the remaining subtrees are eliminated.",
          "Node Deletion (3 Cases): (1) Leaf Node (remove directly), (2) 1 Child Node (bypass pointer), (3) 2 Children Nodes (replace node with its Inorder Successor / minimum of right subtree).",
          "Balanced vs Skewed BST: A balanced BST has depth O(log N); inserting already sorted elements degenerates a naive BST into a skewed linked list of depth O(N)."
        ],
        keyConceptsBn: [
          "BST মূল বৈশিষ্ট্য: প্রতিটি নোডের জন্য বাম সাবট্রি < নোড < ডান সাবট্রি নিয়ম প্রযোজ্য।",
          "Inorder ট্রাভার্সাল: Left -> Root -> Right ক্রমানুসারে ট্রাভার্স করলে উপাদান সর্টেড অর্ডারে পাওয়া যায়।",
          "O(log N) সময় জটিলতা: প্রতিটি স্টেপে সার্চ স্পেস অর্ধেক হয়ে যায়।",
          "নোড ডিলেশন (৩টি কেস): (১) লিফ নোড (সরাসরি বাদ), (২) ১টি চাইল্ড নোড (পয়েন্টার বাইপাস), (৩) ২টি চাইল্ড নোড (ডান সাবট্রির সর্বনিম্ন Inorder Successor দিয়ে রিপ্লেস)।",
          "ব্যালেন্সড বনাম স্কিউড BST: ব্যালেন্সড গাছের ডেপথ O(log N); সর্টেড ডেটা দিলে সাধারণ BST স্কিউড হয়ে লিঙ্কড লিস্টের মতো O(N) হয়ে যায়।"
        ],
        multiDimCodeTemplates: {
          "Standard BST": {
            "C++": """
#include <iostream>
using namespace std;

struct TreeNode {
    int val;
    TreeNode* left;
    TreeNode* right;
    TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
};

// O(log N) Search
TreeNode* searchBST(TreeNode* root, int val) {
    if (root == nullptr || root->val == val) return root;
    if (val < root->val) return searchBST(root->left, val);
    return searchBST(root->right, val);
}

// O(log N) Insert
TreeNode* insertBST(TreeNode* root, int val) {
    if (root == nullptr) return new TreeNode(val);
    if (val < root->val) root->left = insertBST(root->left, val);
    else if (val > root->val) root->right = insertBST(root->right, val);
    return root;
}

int main() {
    TreeNode* root = new TreeNode(50);
    insertBST(root, 30);
    insertBST(root, 70);
    
    TreeNode* found = searchBST(root, 30);
    if (found) cout << "Found Node: " << found->val << endl;
    return 0;
}""",
            "Java": """
class TreeNode {
    int val;
    TreeNode left;
    TreeNode right;
    TreeNode(int val) { this.val = val; }
}

public class BstDemo {
    public static TreeNode searchBST(TreeNode root, int val) {
        if (root == null || root.val == val) return root;
        return val < root.val ? searchBST(root.left, val) : searchBST(root.right, val);
    }
    
    public static TreeNode insertBST(TreeNode root, int val) {
        if (root == null) return new TreeNode(val);
        if (val < root.val) root.left = insertBST(root.left, val);
        else if (val > root.val) root.right = insertBST(root.right, val);
        return root;
    }
}""",
            "Python": """
class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right

def searchBST(root, val):
    if not root or root.val == val:
        return root
    return searchBST(root.left, val) if val < root.val else searchBST(root.right, val)

def insertBST(root, val):
    if not root:
        return TreeNode(val)
    if val < root.val:
        root.left = insertBST(root.left, val)
    elif val > root.val:
        root.right = insertBST(root.right, val)
    return root""",
            "JavaScript": """
class TreeNode {
    constructor(val = 0, left = null, right = null) {
        this.val = val;
        this.left = left;
        this.right = right;
    }
}

function searchBST(root, val) {
    if (!root || root.val === val) return root;
    return val < root.val ? searchBST(root.left, val) : searchBST(root.right, val);
}

function insertBST(root, val) {
    if (!root) return new TreeNode(val);
    if (val < root.val) root.left = insertBST(root.left, val);
    else if (val > root.val) root.right = insertBST(root.right, val);
    return root;
}"""
          },
          "Tree Traversals": {
            "C++": """
#include <iostream>
using namespace std;

struct TreeNode { int val; TreeNode *left, *right; };

// Inorder Traversal (LNR) -> Sorted Ascending Order
void inorder(TreeNode* root) {
    if (!root) return;
    inorder(root->left);
    cout << root->val << " ";
    inorder(root->right);
}

// Preorder Traversal (NLR)
void preorder(TreeNode* root) {
    if (!root) return;
    cout << root->val << " ";
    preorder(root->left);
    preorder(root->right);
}

// Postorder Traversal (LRN)
void postorder(TreeNode* root) {
    if (!root) return;
    postorder(root->left);
    postorder(root->right);
    cout << root->val << " ";
}""",
            "Java": """
class TreeTraversals {
    // Inorder (Left -> Root -> Right)
    public static void inorder(TreeNode root) {
        if (root == null) return;
        inorder(root.left);
        System.out.print(root.val + " ");
        inorder(root.right);
    }
}""",
            "Python": """
def inorder(root):
    if not root: return []
    return inorder(root.left) + [root.val] + inorder(root.right)""",
            "JavaScript": """
function inorder(root) {
    if (!root) return [];
    return [...inorder(root.left), root.val, ...inorder(root.right)];
}"""
          },
          "BST Deletion": {
            "C++": """
TreeNode* findMin(TreeNode* node) {
    while (node->left != nullptr) node = node->left;
    return node;
}

TreeNode* deleteNode(TreeNode* root, int key) {
    if (!root) return nullptr;
    if (key < root->val) root->left = deleteNode(root->left, key);
    else if (key > root->val) root->right = deleteNode(root->right, key);
    else {
        // Node found
        if (!root->left) { TreeNode* temp = root->right; delete root; return temp; }
        else if (!root->right) { TreeNode* temp = root->left; delete root; return temp; }
        // Case 3: 2 children -> replace with Inorder Successor (min of right subtree)
        TreeNode* temp = findMin(root->right);
        root->val = temp->val;
        root->right = deleteNode(root->right, temp->val);
    }
    return root;
}""",
            "Java": """
public TreeNode deleteNode(TreeNode root, int key) {
    if (root == null) return null;
    if (key < root.val) root.left = deleteNode(root.left, key);
    else if (key > root.val) root.right = deleteNode(root.right, key);
    else {
        if (root.left == null) return root.right;
        if (root.right == null) return root.left;
        TreeNode minNode = findMin(root.right);
        root.val = minNode.val;
        root.right = deleteNode(root.right, minNode.val);
    }
    return root;
}
private TreeNode findMin(TreeNode node) {
    while (node.left != null) node = node.left;
    return node;
}""",
            "Python": """
def deleteNode(root, key):
    if not root: return None
    if key < root.val: root.left = deleteNode(root.left, key)
    elif key > root.val: root.right = deleteNode(root.right, key)
    else:
        if not root.left: return root.right
        if not root.right: return root.left
        temp = root.right
        while temp.left: temp = temp.left
        root.val = temp.val
        root.right = deleteNode(root.right, temp.val)
    return root""",
            "JavaScript": """
function deleteNode(root, key) {
    if (!root) return null;
    if (key < root.val) root.left = deleteNode(root.left, key);
    else if (key > root.val) root.right = deleteNode(root.right, key);
    else {
        if (!root.left) return root.right;
        if (!root.right) return root.left;
        let curr = root.right;
        while (curr.left) curr = curr.left;
        root.val = curr.val;
        root.right = deleteNode(root.right, curr.val);
    }
    return root;
}"""
          }
        },
        basicProblems: [
          DsaProblem(
            id: "bst-1",
            title: "1. Search in a Binary Search Tree (LeetCode #700)",
            category: "BST Basic",
            keyIdeaEn: "Compare `val` with `root.val`. If smaller go left, if larger go right in O(log N) time.",
            keyIdeaBn: "টার্গেট মান ছোট হলে বামে এবং বড় হলে ডানে গিয়ে O(log N) সময়ে খুঁজুন।",
            codeCpp: """
TreeNode* searchBST(TreeNode* root, int val) {
    if (!root || root->val == val) return root;
    return val < root->val ? searchBST(root->left, val) : searchBST(root->right, val);
}""",
            codeJava: """
public static TreeNode searchBST(TreeNode root, int val) {
    if (root == null || root.val == val) return root;
    return val < root.val ? searchBST(root.left, val) : searchBST(root.right, val);
}""",
            codePython: """
def searchBST(root, val):
    if not root or root.val == val: return root
    return searchBST(root.left, val) if val < root.val else searchBST(root.right, val)""",
            codeJs: """
function searchBST(root, val) {
    if (!root || root.val === val) return root;
    return val < root.val ? searchBST(root.left, val) : searchBST(root.right, val);
}""",
            descriptionEn: "Find the node in the BST that has a node's value equal to `val` and return the subtree rooted with that node.",
            descriptionBn: "BST তে যে নোডের মান `val` এর সমান সেটি খুঁজুন এবং সেই নোড যুক্ত সাবট্রি রিটার্ন করুন।",
            sampleInputs: ["root = [4,2,7,1,3], val = 2"],
            sampleOutputs: ["Subtree: [2,1,3]"],
          ),
          DsaProblem(
            id: "bst-2",
            title: "2. Validate Binary Search Tree (LeetCode #98)",
            category: "BST Pattern",
            keyIdeaEn: "Validate each node falls strictly within a valid global range `(minVal, maxVal)`. Recursively update bounds.",
            keyIdeaBn: "প্রতিটি নোডের মান `(minVal, maxVal)` বাউন্ডের মধ্যে রয়েছে কিনা রিকার্সিভলি চেক করুন।",
            codeCpp: """
bool isValidBST(TreeNode* root, long long minVal = LONG_MIN, long long maxVal = LONG_MAX) {
    if (!root) return true;
    if (root->val <= minVal || root->val >= maxVal) return false;
    return isValidBST(root->left, minVal, root->val) && isValidBST(root->right, root->val, maxVal);
}""",
            codeJava: """
public static boolean isValidBST(TreeNode root) {
    return validate(root, Long.MIN_VALUE, Long.MAX_VALUE);
}
private static boolean validate(TreeNode node, long min, long max) {
    if (node == null) return true;
    if (node.val <= min || node.val >= max) return false;
    return validate(node.left, min, node.val) && validate(node.right, node.val, max);
}""",
            codePython: """
def isValidBST(root, min_val=float('-inf'), max_val=float('inf')):
    if not root: return True
    if root.val <= min_val or root.val >= max_val: return False
    return isValidBST(root.left, min_val, root.val) and isValidBST(root.right, root.val, max_val)""",
            codeJs: """
function isValidBST(root, minVal = -Infinity, maxVal = Infinity) {
    if (!root) return true;
    if (root.val <= minVal || root.val >= maxVal) return false;
    return isValidBST(root.left, minVal, root.val) && isValidBST(root.right, root.val, maxVal);
}""",
            descriptionEn: "Determine if a given binary tree is a valid Binary Search Tree satisfying the BST invariant.",
            descriptionBn: "দেওয়া বাইনারি ট্রিটি একটি ভ্যালিড BST কিনা নিরূপণ করুন।",
            sampleInputs: ["root = [2,1,3]", "root = [5,1,4,null,null,3,6]"],
            sampleOutputs: ["true", "false (4 in right subtree is < 5)"],
          ),
          DsaProblem(
            id: "bst-3",
            title: "3. Lowest Common Ancestor of a BST (LeetCode #235)",
            category: "BST Pattern",
            keyIdeaEn: "If both nodes `p` & `q` < root, go left. If both > root, go right. The split point is the LCA!",
            keyIdeaBn: "যদি `p` ও `q` উভয়েই মূল নোডের চেয়ে ছোট হয় তবে বামে যান, বড় হলে ডানে যান। স্প্লিট নোডটিই হলো LCA।",
            codeCpp: """
TreeNode* lowestCommonAncestor(TreeNode* root, TreeNode* p, TreeNode* q) {
    if (p->val < root->val && q->val < root->val)
        return lowestCommonAncestor(root->left, p, q);
    if (p->val > root->val && q->val > root->val)
        return lowestCommonAncestor(root->right, p, q);
    return root;
}""",
            codeJava: """
public static TreeNode lowestCommonAncestor(TreeNode root, TreeNode p, TreeNode q) {
    if (p.val < root.val && q.val < root.val) return lowestCommonAncestor(root.left, p, q);
    if (p.val > root.val && q.val > root.val) return lowestCommonAncestor(root.right, p, q);
    return root;
}""",
            codePython: """
def lowestCommonAncestor(root, p, q):
    if p.val < root.val and q.val < root.val:
        return lowestCommonAncestor(root.left, p, q)
    if p.val > root.val and q.val > root.val:
        return lowestCommonAncestor(root.right, p, q)
    return root""",
            codeJs: """
function lowestCommonAncestor(root, p, q) {
    if (p.val < root.val && q.val < root.val) return lowestCommonAncestor(root.left, p, q);
    if (p.val > root.val && q.val > root.val) return lowestCommonAncestor(root.right, p, q);
    return root;
}""",
            descriptionEn: "Find the Lowest Common Ancestor (LCA) node of two given nodes `p` and `q` in a BST.",
            descriptionBn: "BST তে দুটি নির্দিষ্ট নোড `p` এবং `q` এর সর্বনিম্ন কমন এনসেস্টর (LCA) নোড খুঁজুন।",
            sampleInputs: ["root = [6,2,8,0,4,7,9], p = 2, q = 8"],
            sampleOutputs: ["LCA Node: 6"],
          ),
        ],
        commonMistakesEn: [
          {
            "title": "1. Degeneration to Skewed O(N) Tree",
            "desc": "Inserting already sorted array elements sequentially turns naive BST into a line of depth O(N). Use AVL or Red-Black balance."
          },
          {
            "title": "2. Local BST Validation Bug",
            "desc": "Only checking `node.left < node` locally fails when a deep left node is larger than an ancestor. Always enforce global `(min, max)` range."
          },
          {
            "title": "3. Unlinked Pointer in Node Deletion",
            "desc": "Forgetting to assign the return value of `deleteNode(root.left, val)` back to `root.left` severs parent-child links."
          },
          {
            "title": "4. Duplicate Values Invariant Confusion",
            "desc": "Not defining strict rules for equal key values (`<` vs `<=`). Standard BST requires unique keys."
          }
        ],
        commonMistakesBn: [
          {
            "title": "১. স্কিউড ট্রি হয়ে O(N) সময় লাগা",
            "desc": "সর্টেড ডেটা দিয়ে বিএসটি তৈরি করলে গাছটি একলাইনে হেলে পড়ে O(N) লিঙ্কড লিস্টের মতো হয়ে যায়।"
          },
          {
            "title": "২. লোকাল BST চেক করার ভুল",
            "desc": "শুধু ইমিডিয়েট চাইল্ডের সাথে তুলনা করলে ভেতরের কোনো নোড এন্সেস্টরের চেয়ে বড় হয়ে BST নিয়ম ভেঙে দিতে পারে।"
          },
          {
            "title": "৩. নোড ডিলেশনে পয়েন্টার ফিক্স না করা",
            "desc": "রিকার্সিভ `deleteNode(root.left, val)` এর রিটার্ন মান `root.left` এ ব্যাক-এসাইন করতে ভুলে যাওয়া।"
          },
          {
            "title": "৪. ডুপ্লিকেট মানের ভুলের বিভ্রান্তি",
            "desc": "সমান মানের জন্য নির্দিষ্ট নিয়ম না রাখা। স্ট্যান্ডার্ড BST তে প্রতিটি কী ইউনিক হতে হয়।"
          }
        ],
        roadmapStepsEn: [
          {
            "step": "Step 1",
            "title": "Understand Node Hierarchy & BST Invariant",
            "desc": "Master node struct, left/right pointers, and the rule `Left Subtree < Root < Right Subtree`."
          },
          {
            "step": "Step 2",
            "title": "Master Tree Traversals (Inorder, Preorder, Postorder)",
            "desc": "Learn LNR inorder traversal to obtain sorted elements, and BFS level order traversal."
          },
          {
            "step": "Step 3",
            "title": "Master Search & Insert Operations",
            "desc": "Implement recursive and iterative BST search and insertion in O(log N) time."
          },
          {
            "step": "Step 4",
            "title": "Master Node Deletion (3 Cases)",
            "desc": "Handle leaf deletion, single child bypass, and 2-child Inorder Successor replacement."
          },
          {
            "step": "Step 5",
            "title": "Learn Global BST Validation & LCA",
            "desc": "Solve Validate BST using global range bounds, LCA, and introduction to AVL / Red-Black self-balancing trees."
          }
        ],
        roadmapStepsBn: [
          {
            "step": "ধাপ ১",
            "title": "নোড হায়ারার্কি ও BST মূল নিয়ম শিখুন",
            "desc": "নোড পয়েন্টার এবং `বাম সাবট্রি < নোড < ডান সাবট্রি` ইনভেরিয়েন্ট রুল আয়ত্ত করুন।"
          },
          {
            "step": "ধাপ ২",
            "title": "ট্রি ট্রাভার্সাল (Inorder, Preorder, Postorder)",
            "desc": "LNR Inorder দিয়ে সর্টেড উপাদান পাওয়া এবং লেভেল অর্ডার BFS ট্রাভার্সাল শিখুন।"
          },
          {
            "step": "ধাপ ৩",
            "title": "O(log N) সার্চ ও ইনসার্ট অপারেশন",
            "desc": "রিকার্সিভ এবং ইটারেটিভ নিয়মে BST তে উপাদান খোঁজা ও যোগ করার কোড লিখুন।"
          },
          {
            "step": "ধাপ ৪",
            "title": "নোড ডিলেশনের ৩টি কেস আয়ত্ত করুন",
            "desc": "লিফ নোড বাদ, ১ চাইল্ড বাইপাস এবং ২ চাইল্ডের ক্ষেত্রে Inorder Successor রিপ্লেসমেন্ট শিখুন।"
          },
          {
            "step": "ধাপ ৫",
            "title": "গ্লোবাল BST ভ্যালিডেশন ও LCA প্রবলেম",
            "desc": "গ্লোবাল বাউন্ড রেঞ্জ দিয়ে Validate BST, LCA এবং AVL/Red-Black সেলফ-ব্যালেন্সিং ট্রির ধারণা।"
          }
        ],
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
