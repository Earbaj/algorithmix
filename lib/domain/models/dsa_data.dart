import 'package:flutter/material.dart';

class DsaProblem {
  final String id;
  final String title;
  final String category; // e.g. "Hash Map Basic", "Hash Set Pattern"
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
  final Map<String, Map<String, String>> multiDimCodeTemplates; // Variant (Hash Map, Hash Set, Custom Chaining) -> (Language -> Code)
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
        descriptionEn:
            "A Hash Table (or Hash Map) is an associative key-value dictionary that maps keys to memory array indices using a Hash Function (`hash(key) % capacity`). It delivers average O(1) constant time complexity for insertion, lookup, and deletion. Collisions (when multiple keys produce the same hash index) are resolved using Separate Chaining (bucket linked lists) or Open Addressing (linear probing).",
        descriptionBn:
            "হ্যাশ টেবিল (বা হ্যাশ ম্যাপ) হলো একটি কী-ভ্যালু ডিকশনারি যা হ্যাশ ফাংশন (`hash(key) % capacity`) ব্যবহার করে কী-কে মেমোরি অ্যারের ইনডেক্সে রূপান্তর করে। এটি গড়ে O(1) কনস্ট্যান্ট টাইমে ইনসার্ট, লুকআপ ও ডিলেশন সাপোর্ট করে। কলিশন (একাধিক কী এর একই ইনডেক্স পাওয়া) দূর করতে সেপারেট চেইনিং (লিঙ্কড লিস্ট বাকেট) বা ওপেন এড্রেসিং (লিনিয়ার প্রোবিং) ব্যবহৃত হয়।",
        keyConceptsEn: [
          "O(1) Average Time Complexity: Direct Key-to-Value lookup without searching through arrays sequentially.",
          "Hash Function: Maps arbitrary key objects (Strings, Integers, Custom Objects) to integer array bucket indices.",
          "Collision Resolution: Separate Chaining attaches LinkedList nodes at bucket index; Linear Probing searches next available slot.",
          "Load Factor & Dynamic Rehashing: Load Factor α = N / Capacity. When α exceeds 0.75, table capacity doubles and keys are rehashed.",
          "Hash Map vs Hash Set: Hash Map stores `Key -> Value` associations; Hash Set stores unique `Key` elements only."
        ],
        keyConceptsBn: [
          "O(1) গড় সময় জটিলতা: অ্যারেতে লিনিয়ার সার্চ না করেই সরাসরি কী দিয়ে মান বের করা যায়।",
          "হ্যাশ ফাংশন: যেকোনো ডেটা কী-কে ইনটিজার অ্যারে ইনডেক্সে রূপান্তর করে।",
          "কলিশন হ্যান্ডলিং: সেপারেট চেইনিং নোডগুলোকে বাকেটের সাথে লিঙ্ক করে; লিনিয়ার প্রোবিং খালি স্লট না পাওয়া পর্যন্ত ডানে খোঁজে।",
          "লোড ফ্যাক্টর ও রিহ্যাশিং: লোড ফ্যাক্টর α = N / Capacity। α এর মান ০.৭৫ এর বেশি হলে ক্যাপাসিটি ডাবল হয়ে রিহ্যাশিং ঘটে।",
          "হ্যাশ ম্যাপ বনাম হ্যাশ সেট: হ্যাশ ম্যাপ `Key -> Value` পেয়ার রাখে; হ্যাশ সেট কেবল ইউনিক `Key` কালেকশন রাখে।"
        ],
        multiDimCodeTemplates: {
          "Hash Map (Key-Value)": {
            "C++": """
#include <iostream>
#include <unordered_map>
#include <string>
using namespace std;

int main() {
    unordered_map<string, int> ageMap;
    
    // O(1) Put
    ageMap["Alice"] = 25;
    ageMap["Bob"] = 30;
    
    // O(1) Lookup
    if (ageMap.count("Alice")) {
        cout << "Alice's Age: " << ageMap["Alice"] << endl;
    }
    
    // O(1) Erase
    ageMap.erase("Bob");
    return 0;
}""",
            "Java": """
import java.util.HashMap;
import java.util.Map;

public class HashMapDemo {
    public static void main(String[] args) {
        Map<String, Integer> ageMap = new HashMap<>();
        
        // O(1) Put
        ageMap.put("Alice", 25);
        ageMap.put("Bob", 30);
        
        // O(1) Get
        System.out.println("Alice's Age: " + ageMap.get("Alice"));
        
        // O(1) ContainsKey
        if (ageMap.containsKey("Bob")) {
            ageMap.remove("Bob");
        }
    }
}""",
            "Python": """
# Python dict is a highly optimized Hash Map
age_map = {}

# O(1) Put
age_map["Alice"] = 25
age_map["Bob"] = 30

# O(1) Get
print("Alice's Age:", age_map.get("Alice"))

# O(1) Key check & Delete
if "Bob" in age_map:
    del age_map["Bob"]""",
            "JavaScript": """
const ageMap = new Map();

// O(1) Set
ageMap.set("Alice", 25);
ageMap.set("Bob", 30);

// O(1) Get
console.log("Alice's Age:", ageMap.get("Alice"));

// O(1) Has & Delete
if (ageMap.has("Bob")) {
    ageMap.delete("Bob");
}"""
          },
          "Hash Set (Unique Keys)": {
            "C++": """
#include <iostream>
#include <unordered_set>
using namespace std;

int main() {
    unordered_set<int> uniqueSet;
    
    uniqueSet.insert(10);
    uniqueSet.insert(20);
    uniqueSet.insert(10); // Duplicate ignored
    
    cout << "Set Size: " << uniqueSet.size() << endl; // 2
    return 0;
}""",
            "Java": """
import java.util.HashSet;
import java.util.Set;

public class HashSetDemo {
    public static void main(String[] args) {
        Set<Integer> uniqueSet = new HashSet<>();
        uniqueSet.add(10);
        uniqueSet.add(20);
        uniqueSet.add(10); // Duplicate ignored
        
        System.out.println("Set Size: " + uniqueSet.size()); // 2
    }
}""",
            "Python": """
unique_set = set()
unique_set.add(10)
unique_set.add(20)
unique_set.add(10) # Duplicate ignored

print("Set Size:", len(unique_set)) # 2""",
            "JavaScript": """
const uniqueSet = new Set();
uniqueSet.add(10);
uniqueSet.add(20);
uniqueSet.add(10); // Duplicate ignored

console.log("Set Size:", uniqueSet.size); // 2"""
          },
          "Custom Chaining Hash Table": {
            "C++": """
#include <iostream>
#include <vector>
#include <list>
using namespace std;

class HashTable {
    int capacity;
    vector<list<pair<string, int>>> buckets;
    
    int hashFunc(string key) {
        int sum = 0;
        for (char c : key) sum += c;
        return sum % capacity;
    }
public:
    HashTable(int cap = 5) : capacity(cap), buckets(cap) {}
    
    void put(string key, int val) {
        int idx = hashFunc(key);
        for (auto& p : buckets[idx]) {
            if (p.first == key) { p.second = val; return; }
        }
        buckets[idx].push_back({key, val});
    }
    
    int get(string key) {
        int idx = hashFunc(key);
        for (auto& p : buckets[idx]) {
            if (p.first == key) return p.second;
        }
        return -1;
    }
};""",
            "Java": """
import java.util.LinkedList;

class HashTable {
    class Entry {
        String key; int val;
        Entry(String k, int v) { key = k; val = v; }
    }
    private int capacity = 5;
    private LinkedList<Entry>[] buckets = new LinkedList[capacity];
    
    public HashTable() {
        for (int i = 0; i < capacity; i++) buckets[i] = new LinkedList<>();
    }
    private int hashFunc(String key) {
        return Math.abs(key.hashCode()) % capacity;
    }
    public void put(String key, int val) {
        int idx = hashFunc(key);
        for (Entry e : buckets[idx]) {
            if (e.key.equals(key)) { e.val = val; return; }
        }
        buckets[idx].add(new Entry(key, val));
    }
}""",
            "Python": """
class CustomHashTable:
    def __init__(self, capacity=5):
        self.capacity = capacity
        self.buckets = [[] for _ in range(capacity)]
        
    def _hash(self, key):
        return sum(ord(c) for c in key) % self.capacity
        
    def put(self, key, val):
        idx = self._hash(key)
        for i, (k, v) in enumerate(self.buckets[idx]):
            if k == key:
                self.buckets[idx][i] = (key, val)
                return
        self.buckets[idx].append((key, val))
        
    def get(self, key):
        idx = self._hash(key)
        for k, v in self.buckets[idx]:
            if k == key: return v
        return None""",
            "JavaScript": """
class CustomHashTable {
    constructor(capacity = 5) {
        this.capacity = capacity;
        this.buckets = Array.from({length: capacity}, () => []);
    }
    hash(key) {
        let sum = 0;
        for (let i = 0; i < key.length; i++) sum += key.charCodeAt(i);
        return sum % this.capacity;
    }
    put(key, val) {
        const idx = this.hash(key);
        const chain = this.buckets[idx];
        for (let entry of chain) {
            if (entry.key === key) { entry.val = val; return; }
        }
        chain.push({key, val});
    }
}"""
          }
        },
        basicProblems: [
          DsaProblem(
            id: "hm-1",
            title: "1. Intersection of Two Arrays (LeetCode #349)",
            category: "Hash Set Basic",
            keyIdeaEn: "Insert elements of first array into a HashSet, then filter second array elements present in set.",
            keyIdeaBn: "প্রথম অ্যারের উপাদানগুলোকে সেটে রাখুন, তারপর দ্বিতীয় অ্যারের কোনো উপাদান সেটে থাকলে যুক্ত করুন।",
            codeCpp: """
vector<int> intersection(vector<int>& nums1, vector<int>& nums2) {
    unordered_set<int> s(nums1.begin(), nums1.end());
    vector<int> res;
    for (int n : nums2) {
        if (s.count(n)) {
            res.push_back(n);
            s.erase(n); // Remove to prevent duplicates
        }
    }
    return res;
}""",
            codeJava: """
public static int[] intersection(int[] nums1, int[] nums2) {
    Set<Integer> set1 = new HashSet<>();
    for (int n : nums1) set1.add(n);
    Set<Integer> resSet = new HashSet<>();
    for (int n : nums2) {
        if (set1.contains(n)) resSet.add(n);
    }
    return resSet.stream().mapToInt(i -> i).toArray();
}""",
            codePython: """
def intersection(nums1, nums2):
    return list(set(nums1) & set(nums2))""",
            codeJs: """
function intersection(nums1, nums2) {
    const set1 = new Set(nums1);
    return [...new Set(nums2.filter(n => set1.has(n)))];
}""",
            descriptionEn: "Given two integer arrays `nums1` and `nums2`, return an array of their unique intersection elements.",
            descriptionBn: "দুটি পূর্ণসংখ্যার অ্যারে `nums1` এবং `nums2` থেকে তাদের অনন্য (Unique) সাধারণ উপাদানগুলোর অ্যারে তৈরি করুন।",
            sampleInputs: ["nums1 = [1,2,2,1], nums2 = [2,2]"],
            sampleOutputs: ["[2]"],
          ),
          DsaProblem(
            id: "hm-2",
            title: "2. Group Anagrams (LeetCode #49)",
            category: "Hash Map Pattern",
            keyIdeaEn: "Sort characters of each string to form a canonical key, then group original strings in a HashMap under key.",
            keyIdeaBn: "প্রতিটি স্ট্রিংয়ের ক্যারেক্টার সর্ট করে একই কী গঠন করুন এবং হ্যাশ ম্যাপে গ্রুপিং করুন।",
            codeCpp: """
vector<vector<string>> groupAnagrams(vector<string>& strs) {
    unordered_map<string, vector<string>> mp;
    for (string s : strs) {
        string key = s;
        sort(key.begin(), key.end());
        mp[key].push_back(s);
    }
    vector<vector<string>> res;
    for (auto p : mp) res.push_back(p.second);
    return res;
}""",
            codeJava: """
public static List<List<String>> groupAnagrams(String[] strs) {
    Map<String, List<String>> map = new HashMap<>();
    for (String s : strs) {
        char[] ca = s.toCharArray();
        Arrays.sort(ca);
        String key = String.valueOf(ca);
        map.putIfAbsent(key, new ArrayList<>());
        map.get(key).add(s);
    }
    return new ArrayList<>(map.values());
}""",
            codePython: """
from collections import defaultdict

def groupAnagrams(strs):
    mp = defaultdict(list)
    for s in strs:
        key = "".join(sorted(s))
        mp[key].append(s)
    return list(mp.values())""",
            codeJs: """
function groupAnagrams(strs) {
    const map = new Map();
    for (let s of strs) {
        let key = s.split('').sort().join('');
        if (!map.has(key)) map.set(key, []);
        map.get(key).push(s);
    }
    return Array.from(map.values());
}""",
            descriptionEn: "Group an array of strings together if they are anagrams of each other.",
            descriptionBn: "স্ট্রিংগুলোর অ্যারে থেকে একই বর্ণ দ্বারা গঠিত শব্দসমূহ (Anagrams) হ্যাশ ম্যাপ দিয়ে গ্রুপিং করুন।",
            sampleInputs: ["strs = [\"eat\",\"tea\",\"tan\",\"ate\",\"nat\",\"bat\"]"],
            sampleOutputs: "[[\"bat\"], [\"nat\",\"tan\"], [\"ate\",\"eat\",\"tea\"]]",
          ),
          DsaProblem(
            id: "hm-3",
            title: "3. First Unique Character in a String",
            category: "Hash Map Basic",
            keyIdeaEn: "First pass: store character frequencies in HashMap. Second pass: return first index where frequency == 1.",
            keyIdeaBn: "প্রথম ধাপে ক্যারেক্টার ফ্রিকোয়েন্সি ম্যাপে সেভ করুন। দ্বিতীয় ধাপে প্রথম যার ফ্রিকোয়েন্সি ১ পাওয়া যাবে তার ইনডেক্স রিটার্ন করুন।",
            codeCpp: """
int firstUniqChar(string s) {
    unordered_map<char, int> freq;
    for (char c : s) freq[c]++;
    for (int i = 0; i < s.length(); i++) {
        if (freq[s[i]] == 1) return i;
    }
    return -1;
}""",
            codeJava: """
public static int firstUniqChar(String s) {
    Map<Character, Integer> freq = new HashMap<>();
    for (char c : s.toCharArray()) freq.put(c, freq.getOrDefault(c, 0) + 1);
    for (int i = 0; i < s.length(); i++) {
        if (freq.get(s.charAt(i)) == 1) return i;
    }
    return -1;
}""",
            codePython: """
from collections import Counter

def firstUniqChar(s):
    freq = Counter(s)
    for i, c in enumerate(s):
        if freq[c] == 1: return i
    return -1""",
            codeJs: """
function firstUniqChar(s) {
    const freq = {};
    for (let c of s) freq[c] = (freq[c] || 0) + 1;
    for (let i = 0; i < s.length; i++) {
        if (freq[s[i]] === 1) return i;
    }
    return -1;
}""",
            descriptionEn: "Find the first non-repeating character in a string and return its index.",
            descriptionBn: "স্ট্রিংয়ের প্রথম ইউনিক (অনন্য) অক্ষরটির ইনডেক্স বের করুন।",
            sampleInputs: ["s = \"leetcode\"", "s = \"loveleetcode\""],
            sampleOutputs: ["0 ('l')", "2 ('v')"],
          ),
        ],
        commonMistakesEn: [
          {
            "title": "1. Modifying Mutable Key Objects",
            "desc": "Modifying an object after inserting it as a key in HashMap alters its hashCode, making the key unfindable."
          },
          {
            "title": "2. High Load Factor Performance Degradation",
            "desc": "Setting a fixed capacity without dynamic rehashing causes bucket chains to grow, degrading O(1) to linear O(N) lookup."
          },
          {
            "title": "3. Confusing Hash Map with Ordered TreeMap",
            "desc": "Expecting keys in HashMap to remain sorted by insertion or alphabetical order. Use TreeMap or LinkedHashMap for order."
          },
          {
            "title": "4. Missing Custom `equals()` & `hashCode()`",
            "desc": "Using custom class objects as HashMap keys in Java/C++ without overriding both `equals()` and `hashCode()`."
          }
        ],
        commonMistakesBn: [
          {
            "title": "১. হ্যাশ ম্যাপে কী অবজেক্ট মিউটেট করা",
            "desc": "ম্যাপে কী যোগ করার পর সেই অবজেক্টের মান পরিবর্তন করলে হ্যাশকোড চেঞ্জ হয়ে কী আর খুঁজে পাওয়া যায় না।"
          },
          {
            "title": "২. অতিরিক্ত লোড ফ্যাক্টরে ধীরগতি",
            "desc": "টেবিলের সাইজ না বাড়িয়ে শত শত উপাদান ঢোকালে বাকেটের দৈর্ঘ্য বাড়ে এবং ওয়ান স্পিড নষ্ট হয়ে O(N) হয়ে যায়।"
          },
          {
            "title": "৩. সর্টেড অর্ডারের আশা করা",
            "desc": "সাধারণ HashMap কাস্টম অর্ডারে সাজানো থাকে না। সর্টেড অর্ডার পেতে TreeMap বা LinkedHashMap ব্যবহার করুন।"
          },
          {
            "title": "৪. কাস্টম ক্লাসে `hashCode()` না লেখা",
            "desc": "Java বা C++ এ কাস্টম অবজেক্ট কী হিসেবে ব্যবহার করার সময় `equals()` ও `hashCode()` ওভাররাইড না করা।"
          }
        ],
        roadmapStepsEn: [
          {
            "step": "Step 1",
            "title": "Understand Hash Functions & Index Math",
            "desc": "Master key hashing, `hash(key) % capacity`, and direct O(1) bucket index mapping."
          },
          {
            "step": "Step 2",
            "title": "Learn Collision Resolution Techniques",
            "desc": "Understand Separate Chaining (LinkedList buckets) and Open Addressing (Linear Probing)."
          },
          {
            "step": "Step 3",
            "title": "Master Frequency Counting & Sets",
            "desc": "Solve character counting, subarray sum, two sum, and unique elements with HashSet."
          },
          {
            "step": "Step 4",
            "title": "Learn Anagram & Canonical Key Grouping",
            "desc": "Group strings by sorted character key, word frequency vectors, and isomorphism."
          },
          {
            "step": "Step 5",
            "title": "Design Custom HashMap & LRU Cache",
            "desc": "Build a custom HashMap with chaining and integrate with Doubly LinkedList for O(1) LRU Cache."
          }
        ],
        roadmapStepsBn: [
          {
            "step": "ধাপ ১",
            "title": "হ্যাশ ফাংশন ও ইন্ডেক্স সূত্র শিখুন",
            "desc": "কী হ্যাশিং, `hash(key) % capacity` এবং ডিরেক্ট O(1) বাকেট ইন্ডেক্সিং পরিষ্কার করুন।"
          },
          {
            "step": "ধাপ ২",
            "title": "কলিশন হ্যান্ডলিং টেকনিক আয়ত্ত করুন",
            "desc": "সেপারেট চেইনিং (লিঙ্কড লিস্ট বাকেট) এবং ওপেন এড্রেসিং (লিনিয়ার প্রোবিং) টেকনিক শিখুন।"
          },
          {
            "step": "ধাপ ৩",
            "title": "ফ্রিকোয়েন্সি কাউন্টিং ও সেটের ব্যবহার",
            "desc": "ক্যারেক্টার ফ্রিকোয়েন্সি, টু সাম, সাবঅ্যারে সাম এবং ইউনিক এলিমেন্ট ডিটেকশন সলভ করুন।"
          },
          {
            "step": "ধাপ ৪",
            "title": "অ্যানাগ্রাম ও ক্যানোনিকাল কী গ্রুপিং",
            "desc": "সর্টেড অক্ষর ক্যানোনিকাল কী এবং ওয়ার্ড ফ্রিকোয়েন্সি ভেক্টর দিয়ে গ্রুপিং মাস্টার করুন।"
          },
          {
            "step": "ধাপ ৫",
            "title": "কাস্টম হ্যাশম্যাপ ও LRU ক্যাশ ডিজাইন",
            "desc": "নিজে চেইনিং হ্যাশম্যাপ বানান এবং Doubly LinkedList সমন্বয়ে O(1) LRU ক্যাশ ডিজাইন করুন।"
          }
        ],
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
