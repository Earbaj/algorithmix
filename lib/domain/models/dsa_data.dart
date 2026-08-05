import 'package:flutter/material.dart';

class DsaProblem {
  final String id;
  final String title;
  final String difficulty; // Easy, Medium, Hard
  final List<String> companyTags;
  final String keyIdeaEn;
  final String keyIdeaBn;
  final bool isPopular;
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
    required this.difficulty,
    required this.companyTags,
    required this.keyIdeaEn,
    required this.keyIdeaBn,
    this.isPopular = false,
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
  final Map<String, String> codeTemplates;
  final List<DsaProblem> easyProblems;
  final List<DsaProblem> mediumProblems;
  final List<DsaProblem> hardProblems;
  final List<Map<String, String>> commonMistakesEn;
  final List<Map<String, String>> commonMistakesBn;

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
    required this.codeTemplates,
    required this.easyProblems,
    required this.mediumProblems,
    required this.hardProblems,
    required this.commonMistakesEn,
    required this.commonMistakesBn,
  });
}

class DsaDataRepository {
  static List<DsaTopic> getTopics() {
    return [
      // 1. ARRAYS & DYNAMIC LISTS
      DsaTopic(
        id: 201,
        title: "Arrays & Dynamic Lists",
        category: "Linear Data Structure",
        timeComplexity: "Access O(1) | Search O(N) | Shift O(N)",
        spaceComplexity: "O(N)",
        icon: Icons.view_column_outlined,
        themeColor: const Color(0xFF3B82F6),
        descriptionEn:
            "A contiguous block of memory storing elements of the same data type. Dynamic Arrays (std::vector, ArrayList) automatically double their capacity when full, maintaining amortized O(1) insertion at the back while supporting instant O(1) index access using base address math: Address(i) = Base + (i * size).",
        descriptionBn:
            "মেমোরিতে পরপর (Contiguous) সাজানো এলিমেন্টের সিকোয়েন্স। ডাইনামিক অ্যারে (যেমন std::vector, ArrayList) ফুল হয়ে গেলে স্বয়ংক্রিয়ভাবে মেমোরি ক্যাপাসিটি দ্বিগুণ করে। বেস এড্রেস সুত্র Address(i) = Base + (i * size) ব্যবহার করে যেকোনো ইন্ডেক্সে সরাসরি O(1) সময়ে অ্যাক্সেস করা যায়।",
        keyConceptsEn: [
          "O(1) Direct Index Access using pointer arithmetic Base + (i * elementSize)",
          "Dynamic Resizing: Capacity doubles (1 -> 2 -> 4 -> 8 -> 16) when size == capacity",
          "Amortized O(1) Push Back (n insertions take total 2n steps = avg 2 steps per push)",
          "O(N) Element Shifting required for middle index insertions & deletions",
          "L1/L2 Cache Locality: Contiguous memory bytes fetched together into CPU cache lines"
        ],
        keyConceptsBn: [
          "পয়েন্টার অ্যারিথমেটিক দিয়ে যেকোনো ইন্ডেক্সে মুহূর্তেই O(1) ডিরেক্ট অ্যাক্সেস",
          "ডাইনামিক রিসাইজিং: সাইজ ক্যাপাসিটির সমান হলে মেমোরি সাইজ দ্বিগুণ (৪ -> ৮ -> ১৬) হয়",
          "Amortized O(1) Push Back: N টি উপাদানের জন্য মোট ২N অপারেশন লাগে, যা গড়ে O(1)",
          "মাঝখানে এলিমেন্ট যোগ বা ডিলেট করলে বাকি সব উপাদান ডানে/বামে Shift করতে হয় O(N)",
          "ক্যাশ লোকালিটি: কনটিগুয়াস ব্লক মেমোরি হওয়ার কারণে CPU L1/L2 ক্যাশে দ্রুত লোড হয়"
        ],
        codeTemplates: {
          "C++": """
#include <iostream>
#include <vector>
using namespace std;

int main() {
    vector<int> arr = {10, 20, 30, 40};
    cout << "Element at index 2: " << arr[2] << endl;
    arr.push_back(50);
    arr.insert(arr.begin() + 1, 15);
    arr.erase(arr.begin() + 2);
    for (int val : arr) cout << val << " ";
    return 0;
}""",
          "Java": """
import java.util.ArrayList;

public class ArrayDemo {
    public static void main(String[] args) {
        ArrayList<Integer> list = new ArrayList<>();
        list.add(10); list.add(20); list.add(30);
        int val = list.get(1);
        list.add(1, 15);
        list.remove(2);
    }
}""",
          "Python": """
arr = [10, 20, 30, 40]
print("Index 2:", arr[2])
arr.append(50)
arr.insert(1, 15)
arr.pop(2)""",
          "JavaScript": """
const arr = [10, 20, 30, 40];
console.log("Index 2:", arr[2]);
arr.push(50);
arr.splice(1, 0, 15);
arr.splice(2, 1);"""
        },
        easyProblems: [
          DsaProblem(
            id: "arr-1",
            title: "Two Sum",
            difficulty: "Easy",
            companyTags: ["Google", "Meta", "Amazon", "Apple", "Microsoft"],
            keyIdeaEn: "Iterate array while storing (target - current_val) inside Hash Map.",
            keyIdeaBn: "অ্যারে লুপ করার সময় ম্যাপে (target - current) রয়েছে কিনা চেক করুন।",
            isPopular: true,
            codeCpp: """
vector<int> twoSum(vector<int>& nums, int target) {
    unordered_map<int, int> mp;
    for (int i = 0; i < nums.size(); i++) {
        int complement = target - nums[i];
        if (mp.count(complement)) return {mp[complement], i};
        mp[nums[i]] = i;
    }
    return {};
}""",
            codeJava: """
public int[] twoSum(int[] nums, int target) {
    Map<Integer, Integer> map = new HashMap<>();
    for (int i = 0; i < nums.length; i++) {
        int complement = target - nums[i];
        if (map.containsKey(complement)) return new int[] { map.get(complement), i };
        map.put(nums[i], i);
    }
    return new int[] {};
}""",
            codePython: """
def twoSum(nums, target):
    mp = {}
    for i, num in enumerate(nums):
        diff = target - num
        if diff in mp: return [mp[diff], i]
        mp[num] = i
    return []""",
            codeJs: """
function twoSum(nums, target) {
    const map = new Map();
    for (let i = 0; i < nums.length; i++) {
        let diff = target - nums[i];
        if (map.has(diff)) return [map.get(diff), i];
        map.set(nums[i], i);
    }
    return [];
}""",
            descriptionEn: "Return indices of two numbers that add up to target.",
            descriptionBn: "যোগফল target এর সমান এমন দুটি সংখ্যার ইন্ডেক্স রিটার্ন করুন।",
            sampleInputs: ["nums = [2,7,11,15], target = 9"],
            sampleOutputs: ["[0, 1]"],
          ),
          DsaProblem(
            id: "arr-2",
            title: "Contains Duplicate",
            difficulty: "Easy",
            companyTags: ["Amazon", "Apple"],
            keyIdeaEn: "Insert elements into Hash Set. If duplicate exists, return true.",
            keyIdeaBn: "হ্যাশ সেটে উপাদান জমা করে ডুপ্লিকেট চেক করুন।",
            codeCpp: """
bool containsDuplicate(vector<int>& nums) {
    unordered_set<int> s(nums.begin(), nums.end());
    return s.size() < nums.size();
}""",
            codeJava: """
public boolean containsDuplicate(int[] nums) {
    Set<Integer> set = new HashSet<>();
    for (int num : nums) {
        if (set.contains(num)) return true;
        set.add(num);
    }
    return false;
}""",
            codePython: """
def containsDuplicate(nums):
    return len(set(nums)) < len(nums)""",
            codeJs: """
function containsDuplicate(nums) {
    return new Set(nums).size < nums.length;
}""",
            descriptionEn: "Return true if any value appears at least twice.",
            descriptionBn: "অ্যারেতে যেকোনো মান ২ বার থাকলে true রিটার্ন করুন।",
            sampleInputs: ["nums = [1,2,3,1]"],
            sampleOutputs: ["true"],
          ),
        ],
        mediumProblems: [
          DsaProblem(
            id: "arr-3",
            title: "Subarray Sum Equals K",
            difficulty: "Medium",
            companyTags: ["Meta", "Google", "Amazon"],
            keyIdeaEn: "Cumulative prefix sum + Hash Map frequency counting.",
            keyIdeaBn: "প্রিফিক্স সাম এবং হ্যাশ ম্যাপ দিয়ে (sum - k) ফ্রিকোয়েন্সি ট্র্যাক করুন।",
            isPopular: true,
            codeCpp: """
int subarraySum(vector<int>& nums, int k) {
    unordered_map<int, int> mp;
    mp[0] = 1;
    int sum = 0, count = 0;
    for (int n : nums) {
        sum += n;
        if (mp.count(sum - k)) count += mp[sum - k];
        mp[sum]++;
    }
    return count;
}""",
            codeJava: """
public int subarraySum(int[] nums, int k) {
    Map<Integer, Integer> map = new HashMap<>();
    map.put(0, 1);
    int sum = 0, count = 0;
    for (int n : nums) {
        sum += n;
        if (map.containsKey(sum - k)) count += map.get(sum - k);
        map.put(sum, map.getOrDefault(sum, 0) + 1);
    }
    return count;
}""",
            codePython: """
def subarraySum(nums, k):
    mp = {0: 1}
    sum_val, count = 0, 0
    for n in nums:
        sum_val += n
        if (sum_val - k) in mp: count += mp[sum_val - k]
        mp[sum_val] = mp.get(sum_val, 0) + 1
    return count""",
            codeJs: """
function subarraySum(nums, k) {
    const map = new Map([[0, 1]]);
    let sum = 0, count = 0;
    for (let n of nums) {
        sum += n;
        if (map.has(sum - k)) count += map.get(sum - k);
        map.set(sum, (map.get(sum) || 0) + 1);
    }
    return count;
}""",
            descriptionEn: "Return total number of subarrays whose sum equals k.",
            descriptionBn: "যোগফল k এর সমান মোট সাবঅ্যারে সংখ্যা বের করুন।",
            sampleInputs: ["nums = [1,1,1], k = 2"],
            sampleOutputs: ["2"],
          ),
        ],
        hardProblems: [
          DsaProblem(
            id: "arr-4",
            title: "First Missing Positive",
            difficulty: "Hard",
            companyTags: ["Amazon", "Google", "Meta"],
            keyIdeaEn: "Cyclic sort placing element x at index x - 1 in O(N) time and O(1) space.",
            keyIdeaBn: "ইন-প্লেস Cyclic Sort করে প্রথম মিসিং পজিটিভ সংখ্যাটি খুঁজুন।",
            isPopular: true,
            codeCpp: """
int firstMissingPositive(vector<int>& nums) {
    int n = nums.size();
    for (int i = 0; i < n; i++) {
        while (nums[i] > 0 && nums[i] <= n && nums[nums[i] - 1] != nums[i]) {
            swap(nums[i], nums[nums[i] - 1]);
        }
    }
    for (int i = 0; i < n; i++) {
        if (nums[i] != i + 1) return i + 1;
    }
    return n + 1;
}""",
            codeJava: """
public int firstMissingPositive(int[] nums) {
    int n = nums.length;
    for (int i = 0; i < n; i++) {
        while (nums[i] > 0 && nums[i] <= n && nums[nums[i] - 1] != nums[i]) {
            int temp = nums[nums[i] - 1];
            nums[nums[i] - 1] = nums[i];
            nums[i] = temp;
        }
    }
    for (int i = 0; i < n; i++) {
        if (nums[i] != i + 1) return i + 1;
    }
    return n + 1;
}""",
            codePython: """
def firstMissingPositive(nums):
    n = len(nums)
    for i in range(n):
        while 1 <= nums[i] <= n and nums[nums[i] - 1] != nums[i]:
            idx = nums[i] - 1
            nums[i], nums[idx] = nums[idx], nums[i]
    for i in range(n):
        if nums[i] != i + 1: return i + 1
    return n + 1""",
            codeJs: """
function firstMissingPositive(nums) {
    const n = nums.length;
    for (let i = 0; i < n; i++) {
        while (nums[i] > 0 && nums[i] <= n && nums[nums[i] - 1] !== nums[i]) {
            let idx = nums[i] - 1;
            [nums[i], nums[idx]] = [nums[idx], nums[i]];
        }
    }
    for (let i = 0; i < n; i++) {
        if (nums[i] !== i + 1) return i + 1;
    }
    return n + 1;
}""",
            descriptionEn: "Return smallest missing positive integer in O(N) time and O(1) space.",
            descriptionBn: "ক্ষুদ্রতম মিসিং পজিটিভ সংখ্যাটি O(N) টাইম ও O(1) স্পেসে বের করুন।",
            sampleInputs: ["nums = [1,2,0]"],
            sampleOutputs: ["3"],
          )
        ],
        commonMistakesEn: [
          {
            "title": "1. Off-by-One Boundary Errors",
            "desc": "Accessing index N instead of N-1 triggers Out of Bounds crash."
          },
          {
            "title": "2. Inefficient Shifting in Loop",
            "desc": "Inserting or deleting at index 0 inside N loop iterations causes hidden O(N²) time."
          }
        ],
        commonMistakesBn: [
          {
            "title": "১. Off-by-One বাউন্ডারি ভুল",
            "desc": "অ্যারের শেষ ইন্ডেক্স N-1 এর বদলে N দিয়ে মান পড়তে গেলে প্রোগ্রাম ক্র্যাশ করে।"
          },
          {
            "title": "২. লুপের ভেতর Shift করা",
            "desc": "লুপের মধ্যে insert(0) বা remove(0) করলে মেমোরি Shift এর কারণে O(N²) সময় নষ্ট হয়।"
          }
        ],
      ),

      // 2. LINKED LIST
      DsaTopic(
        id: 202,
        title: "Singly & Doubly Linked List",
        category: "Linear Data Structure",
        timeComplexity: "Insert/Delete: O(1) | Access: O(N)",
        spaceComplexity: "O(N)",
        icon: Icons.link_outlined,
        themeColor: const Color(0xFF8B5CF6),
        descriptionEn: "Linear sequence of node objects where each node stores a data payload and pointer to next (and previous) node.",
        descriptionBn: "নোড অবজেক্টের লিনিয়ার সিকোয়েন্স, যেখানে প্রতিটি নোডে ডেটা এবং পরবর্তী (ও আগের) নোডের পয়েন্টার থাকে।",
        keyConceptsEn: [
          "Node pointer reference traversal (head to tail)",
          "O(1) Insertion & Deletion when pointer reference is given",
          "Doubly Linked List allows bidirectional traversal (prev & next)"
        ],
        keyConceptsBn: [
          "হেড থেকে টেইল পর্যন্ত পয়েন্টার দিয়ে ট্রাভার্সাল",
          "পয়েন্টার থাকলে O(1) ইনসারশন ও ডিলিট করা সম্ভব",
          "Doubly Linked List এ দুদিকে যাওয়া যায় (prev ও next)"
        ],
        codeTemplates: {
          "C++": """
struct ListNode {
    int val;
    ListNode* next;
    ListNode(int x) : val(x), next(nullptr) {}
};""",
          "Java": """
class ListNode {
    int val;
    ListNode next;
    ListNode(int val) { this.val = val; }
}""",
          "Python": """
class ListNode:
    def __init__(self, val=0, next=None):
        self.val = val
        self.next = next""",
          "JavaScript": """
class ListNode {
    constructor(val = 0, next = null) {
        this.val = val;
        this.next = next;
    }
}"""
        },
        easyProblems: [
          DsaProblem(
            id: "ll-1",
            title: "Reverse Linked List",
            difficulty: "Easy",
            companyTags: ["Meta", "Amazon", "Apple", "Google"],
            keyIdeaEn: "Iterative 3-pointer reversal (prev, curr, nextTemp).",
            keyIdeaBn: "৩টি পয়েন্টার দিয়ে সংযোগের দিক ঘুরিয়ে দিন।",
            isPopular: true,
            codeCpp: """
ListNode* reverseList(ListNode* head) {
    ListNode *prev = nullptr, *curr = head;
    while(curr != nullptr) {
        ListNode* nextTemp = curr->next;
        curr->next = prev;
        prev = curr;
        curr = nextTemp;
    }
    return prev;
}""",
            codeJava: """
public ListNode reverseList(ListNode head) {
    ListNode prev = null, curr = head;
    while (curr != null) {
        ListNode nextTemp = curr.next;
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
            descriptionEn: "Reverse a singly linked list.",
            descriptionBn: "একটি লিঙ্কড লিস্ট উল্টিয়ে নতুন Head রিটার্ন করুন।",
            sampleInputs: ["head = [1,2,3,4,5]"],
            sampleOutputs: ["[5,4,3,2,1]"],
          ),
        ],
        mediumProblems: [],
        hardProblems: [],
        commonMistakesEn: [
          {
            "title": "1. Null Pointer Dereference",
            "desc": "Calling curr.next.val without checking if curr.next is null."
          }
        ],
        commonMistakesBn: [
          {
            "title": "১. নাল পয়েন্টার ভুল",
            "desc": "নাল নোডের ওপর .next কল করার আগে পয়েন্টার নাল কিনা চেক না করা।"
          }
        ],
      ),

      // 3. STACK
      DsaTopic(
        id: 203,
        title: "Stack (LIFO)",
        category: "Linear Data Structure",
        timeComplexity: "Push O(1) | Pop O(1) | Top O(1)",
        spaceComplexity: "O(N)",
        icon: Icons.layers_outlined,
        themeColor: const Color(0xFF10B981),
        descriptionEn: "Last-In, First-Out (LIFO) container where elements are added and removed strictly from top.",
        descriptionBn: "লাস্ট-ইন, ফার্স্ট-আউট (LIFO) ডেটা স্ট্রাকচার, যেখানে উপাদান শুধু একদম ওপর থেকে যোগ ও বাদ দেওয়া যায়।",
        keyConceptsEn: ["LIFO structure", "O(1) push, pop, top peek", "Function call stack & recursion"],
        keyConceptsBn: ["LIFO নিয়ম", "Push, Pop এবং Peek O(1) সময়ে সম্পন্ন হয়", "ফাংশন কল স্ট্যাক ও রিকার্সন"],
        codeTemplates: {"C++": "stack<int> st; st.push(10); st.pop();"},
        easyProblems: [],
        mediumProblems: [],
        hardProblems: [],
        commonMistakesEn: [],
        commonMistakesBn: [],
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
        descriptionEn: "First-In, First-Out (FIFO) pipeline. Enqueue adds items at rear, Dequeue removes from front.",
        descriptionBn: "ফার্স্ট-ইন, ফার্স্ট-আউট (FIFO) পাইপলাইন। পেছনের দিকে যোগ (Enqueue) এবং সামনে থেকে বাদ (Dequeue) দেওয়া হয়।",
        keyConceptsEn: ["FIFO discipline", "BFS graph & tree level traversal"],
        keyConceptsBn: ["FIFO নীতি", "গ্রাফ ও ট্রির BFS ট্রাভার্সাল"],
        codeTemplates: {"C++": "queue<int> q; q.push(10); q.pop();"},
        easyProblems: [],
        mediumProblems: [],
        hardProblems: [],
        commonMistakesEn: [],
        commonMistakesBn: [],
      ),

      // 5. HASH TABLE
      DsaTopic(
        id: 205,
        title: "Hash Table & Hash Map",
        category: "Associative Array",
        timeComplexity: "Lookup O(1) avg | Insert O(1) avg",
        spaceComplexity: "O(N)",
        icon: Icons.grid_view_outlined,
        themeColor: const Color(0xFFEC4899),
        descriptionEn: "Key-Value lookup table mapping keys to bucket indices using hash function.",
        descriptionBn: "কী-ভ্যালু পেয়ার ডেটা স্ট্রাকচার যা হ্যাশ ফাংশন দিয়ে সরাসরি O(1) এক্সেস দেয়।",
        keyConceptsEn: ["Hash function key-to-index mapping", "Collision resolution (Chaining)"],
        keyConceptsBn: ["হ্যাশ ফাংশন দিয়ে ইন্ডেক্স গণনা", "কলিশন হ্যান্ডলিং"],
        codeTemplates: {"C++": "unordered_map<string, int> mp; mp[\"apple\"] = 5;"},
        easyProblems: [],
        mediumProblems: [],
        hardProblems: [],
        commonMistakesEn: [],
        commonMistakesBn: [],
      ),

      // 6. BST
      DsaTopic(
        id: 206,
        title: "Binary Search Tree (BST)",
        category: "Hierarchical",
        timeComplexity: "Search O(log N) | Insert O(log N)",
        spaceComplexity: "O(N)",
        icon: Icons.account_tree_outlined,
        themeColor: const Color(0xFF06B6D4),
        descriptionEn: "Binary tree maintaining Left < Root < Right invariant.",
        descriptionBn: "বাইনারি ট্রি যেখানে বাম পাশে ছোট এবং ডান পাশে বড় মান থাকে।",
        keyConceptsEn: ["Left < Root < Right property", "Inorder traversal gives sorted order"],
        keyConceptsBn: ["Left < Root < Right বৈশিষ্ট্য", "Inorder ট্রাভার্সাল সর্টেড অর্ডার দেয়"],
        codeTemplates: {"C++": "struct TreeNode { int val; TreeNode *left, *right; };"},
        easyProblems: [],
        mediumProblems: [],
        hardProblems: [],
        commonMistakesEn: [],
        commonMistakesBn: [],
      ),

      // 7. HEAP
      DsaTopic(
        id: 207,
        title: "Min & Max Heap (Priority Queue)",
        category: "Priority Structure",
        timeComplexity: "Peek O(1) | Push/Pop O(log N)",
        spaceComplexity: "O(N)",
        icon: Icons.unfold_more_double_outlined,
        themeColor: const Color(0xFF84CC16),
        descriptionEn: "Complete binary tree satisfying heap invariant for fast min/max access.",
        descriptionBn: "কমপ্লিট বাইনারি ট্রি যা সর্বোচ্চ/সর্বনিম্ন প্রাইওরিটি ডেটা দ্রুত এক্সেস দেয়।",
        keyConceptsEn: ["Heap property arr[i] children at 2i+1 and 2i+2", "Top K elements tracking"],
        keyConceptsBn: ["প্যারেন্ট-চাইল্ড হিপ ইন্ডেক্সিং", "Top K Elements ট্র্যাকিং"],
        codeTemplates: {"C++": "priority_queue<int> maxHeap;"},
        easyProblems: [],
        mediumProblems: [],
        hardProblems: [],
        commonMistakesEn: [],
        commonMistakesBn: [],
      ),

      // 8. GRAPH
      DsaTopic(
        id: 208,
        title: "Graph (Adjacency List & Matrix)",
        category: "Non-Linear Network",
        timeComplexity: "BFS/DFS: O(V + E)",
        spaceComplexity: "O(V + E)",
        icon: Icons.hub_outlined,
        themeColor: const Color(0xFF0284C7),
        descriptionEn: "Network of vertices connected by edges.",
        descriptionBn: "ভার্টেক্স (নোড) ও এজের নেটওয়ার্ক।",
        keyConceptsEn: ["Adjacency list representation", "BFS for shortest path, DFS for components"],
        keyConceptsBn: ["Adjacency List রিপ্রেজেন্টেশন", "BFS ও DFS ট্রাভার্সাল"],
        codeTemplates: {"C++": "vector<vector<int>> adj;"},
        easyProblems: [],
        mediumProblems: [],
        hardProblems: [],
        commonMistakesEn: [],
        commonMistakesBn: [],
      ),

      // 9. TRIE
      DsaTopic(
        id: 209,
        title: "Trie (Prefix Tree)",
        category: "Advanced Tree",
        timeComplexity: "Search/Insert: O(L)",
        spaceComplexity: "O(N * L)",
        icon: Icons.sort_by_alpha_outlined,
        themeColor: const Color(0xFFA855F7),
        descriptionEn: "Tree structure optimized for word search & autocomplete.",
        descriptionBn: "অক্ষরভিত্তিক ট্রি যা শব্দ খোঁজা ও অটো-কমপ্লিটে কাজ করে।",
        keyConceptsEn: ["Character node branches", "isEnd word marker flag"],
        keyConceptsBn: ["অক্ষরভিত্তিক ব্রাঞ্চিং", "isEnd মান দিয়ে শব্দ ট্র্যাকিং"],
        codeTemplates: {"C++": "class TrieNode { unordered_map<char, TrieNode*> children; bool isEnd; };"},
        easyProblems: [],
        mediumProblems: [],
        hardProblems: [],
        commonMistakesEn: [],
        commonMistakesBn: [],
      ),
    ];
  }
}
