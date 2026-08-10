class KWayMergeProblem {
  final String title;
  final String difficulty; // Easy, Medium, Hard
  final List<String> companyTags;
  final String keyIdeaEn;
  final String keyIdeaBn;
  final bool isPopular;

  const KWayMergeProblem({
    required this.title,
    required this.difficulty,
    required this.companyTags,
    required this.keyIdeaEn,
    required this.keyIdeaBn,
    this.isPopular = false,
  });
}

class KWayMergeData {
  static Map<String, String> getConceptIntro(bool isEnglish) {
    if (isEnglish) {
      return {
        "title": "K-Way Merge Pattern — Complete Deep Dive (C++ & FAANG Focus)",
        "summary": "The K-Way Merge pattern uses a Min-Heap (or Priority Queue) of size K to merge K sorted arrays, linked lists, or matrix rows into a single sorted sequence in O(N log K) time and O(K) space (where N is total elements across all K inputs).",
        "whenToUseTitle": "When to Use K-Way Merge?",
        "whenToUse1": "Merging K Sorted Linked Lists or Arrays (LeetCode 23).",
        "whenToUse2": "Finding the K-th Smallest Element in a Sorted Matrix (LeetCode 378).",
        "whenToUse3": "Finding the Smallest Range Covering Elements from K Lists (LeetCode 632).",
        "whenToUse4": "Finding K Pairs with Smallest Sums (LeetCode 373).",
        "whenToUse5": "Merging K sorted data streams in external sorting or log file aggregation.",
        "typesTitle": "3 Main K-Way Merge Patterns",
        "type1Title": "1. Merge K Sorted Lists / Arrays",
        "type1Desc": "Initialize Min-Heap with head nodes of all K lists. Pop min node, append to result list, and push min->next into Min-Heap until empty.",
        "type2Title": "2. Kth Smallest Element in a Sorted Matrix",
        "type2Desc": "Push first column of all N rows into Min-Heap. Pop minimum K times to find Kth smallest element.",
        "type3Title": "3. Smallest Range Covering Elements from K Lists",
        "type3Desc": "Push 1st element of all K lists into Min-Heap while tracking currentMax. Squeeze range [minVal, currentMax] by popping min and pushing next element.",
      };
    } else {
      return {
        "title": "K-Way Merge Pattern — সম্পূর্ণ গাইড (C++ ও FAANG ফোকাস)",
        "summary": "K-Way Merge প্যাটার্ন K সাইজের একটি Min-Heap ব্যবহার করে K সংখ্যক সর্টেড লিঙ্কড লিস্ট বা ম্যাট্রিক্সকে মাত্র O(N log K) টাইম ও O(K) মেমোরিতে একটি একক সর্টেড ক্রমানুসারে মার্জ করে।",
        "whenToUseTitle": "কখন বুঝবা K-Way Merge লাগবে?",
        "whenToUse1": "K সংখ্যক সর্টেড লিঙ্কড লিস্ট বা অ্যারে মার্জ করে ১টি সর্টেড লিস্ট করতে বললে (LeetCode 23)।",
        "whenToUse2": "সর্টেড ম্যাট্রিক্সের K-তম ক্ষুদ্রতম সংখ্যা বের করতে বললে (LeetCode 378)।",
        "whenToUse3": "K টি সর্টেড লিস্টের সবকটি থেকে অন্তত ১টি সংখ্যা ধারণকারী ক্ষুদ্রতম রেঞ্জ বের করতে (LeetCode 632)।",
        "whenToUse4": "ক্ষুদ্রতম যোগফলের K টি পেয়ার বের করতে (LeetCode 373)।",
        "whenToUse5": "এক্সটার্নাল সর্টিং বা বড় লগ ফাইলের K টি সর্টেড ডাটা স্ট্রিম মার্জ করতে।",
        "typesTitle": "Main Types (৩ ধরনের pattern)",
        "type1Title": "১. Merge K Sorted Lists (K টি লিস্ট মার্জ)",
        "type1Desc": "K টি লিস্টের প্রথম নোডগুলো Min-Heap এ পুশ করো। টপ পপ করো, রেজাল্টে যোগ করো এবং `min->next` হিপে যোগ করো।",
        "type2Title": "২. Kth Smallest Element in Matrix (ম্যাট্রিক্সে K-তম সংখ্যা)",
        "type2Desc": "ম্যাট্রিক্সের ১ম কলামের সব উপাদান Min-Heap এ নাও। K বার পপ করে K-তম ক্ষুদ্রতম উপাদান পাও।",
        "type3Title": "৩. Smallest Range Covering K Lists (ক্ষুদ্রতম কভারিং রেঞ্জ)",
        "type3Desc": "Min-Heap এ K টি উপাদান রেখে `currentMax` ট্র্যাক করো। প্রতিবার মিনিমাম পপ করে `[minVal, currentMax]` রেঞ্জ আপডেট করো।",
      };
    }
  }

  static List<KWayMergeProblem> getEasyProblems() {
    return const [
      KWayMergeProblem(
        title: "Merge Two Sorted Lists",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta", "Google", "Microsoft"],
        keyIdeaEn: "2-way merge comparison using iteration or recursion.",
        keyIdeaBn: "ইটেরেশন বা রিকার্শন দিয়ে ২টি সর্টেড লিস্ট মার্জ করুন।",
        isPopular: true,
      ),
      KWayMergeProblem(
        title: "Merge Sorted Array",
        difficulty: "Easy",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft"],
        keyIdeaEn: "2-way merge filling elements from back of nums1.",
        keyIdeaBn: "nums1 এর পিছন দিক থেকে টু পয়েন্টার মার্জ ফিল করুন।",
        isPopular: true,
      ),
      KWayMergeProblem(
        title: "Intersection of Two Arrays II",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta", "Google"],
        keyIdeaEn: "2-way pointer merge on sorted arrays.",
        keyIdeaBn: "সর্টেড অ্যারেতে টু পয়েন্টার মার্জ চালিয়ে ইন্টারসেকশন নিন।",
      ),
      KWayMergeProblem(
        title: "Squares of a Sorted Array",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta", "Google"],
        keyIdeaEn: "2-way merge from left and right boundaries towards center.",
        keyIdeaBn: "দুই পাশ থেকে স্কয়ার মান কম্পেয়ার করে পিছন থেকে ফিল করুন।",
      ),
      KWayMergeProblem(
        title: "Sort Array by Increasing Frequency",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta"],
        keyIdeaEn: "Frequency map sort with custom priority queue.",
        keyIdeaBn: "ফ্রিকোয়েন্সি ম্যাপ দিয়ে কাস্টম সর্ট করুন।",
      ),
      KWayMergeProblem(
        title: "Keep Multiplying Found Values by Two",
        difficulty: "Easy",
        companyTags: ["Google", "Amazon"],
        keyIdeaEn: "Iterative search or sort merge lookup.",
        keyIdeaBn: "লুকআপ বা সর্ট করে মান দ্বিগুণ করতে থাকুন।",
      ),
      KWayMergeProblem(
        title: "Merge Similar Items",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta"],
        keyIdeaEn: "Map aggregation + sorted merge list.",
        keyIdeaBn: "ম্যাপে যোগ করে সর্টেড লিস্টে রূপান্তর করুন।",
      ),
      KWayMergeProblem(
        title: "Take Gifts From the Richest Pile",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta"],
        keyIdeaEn: "Max-Heap popping richest pile K times.",
        keyIdeaBn: "Max-Heap দিয়ে সর্বোচ্চ দানবীয় উপহার স্কয়ার রুট করুন।",
      ),
    ];
  }

  static List<KWayMergeProblem> getMediumProblems() {
    return const [
      KWayMergeProblem(
        title: "Kth Smallest Element in a Sorted Matrix",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft", "Bloomberg"],
        keyIdeaEn: "Min-Heap initialized with first column of all N rows, popping K times in O(K log N).",
        keyIdeaBn: "ম্যাট্রিক্সের ১ম কলাম হিপে রেখে K বার পপ করে K-তম ক্ষুদ্রতম মান নিন।",
        isPopular: true,
      ),
      KWayMergeProblem(
        title: "Find K Pairs with Smallest Sums",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft"],
        keyIdeaEn: "Min-Heap storing pair sums (nums1[i] + nums2[j], i, j). Push (i, j+1) on pop.",
        keyIdeaBn: "Min-Heap এ জোড়ার যোগফল রেখে পপ করে পরবর্তী ইনডেক্স যোগ করুন।",
        isPopular: true,
      ),
      KWayMergeProblem(
        title: "Kth Smallest Prime Fraction",
        difficulty: "Medium",
        companyTags: ["Google", "Amazon", "Meta"],
        keyIdeaEn: "Min-Heap storing prime fractions arr[i] / arr[j].",
        keyIdeaBn: "প্রাইম ফ্র্যাকশনের জন্য Min-Heap দিয়ে K-তম মান ফিল্টার করুন।",
        isPopular: true,
      ),
      KWayMergeProblem(
        title: "Super Ugly Number",
        difficulty: "Medium",
        companyTags: ["Google", "Amazon"],
        keyIdeaEn: "K-Way merge of prime multiples using Min-Heap.",
        keyIdeaBn: "প্রাইম গুণিতকগুলোর K-Way মার্জ করে সুপার আগলি নাম্বার তৈরি করুন।",
      ),
      KWayMergeProblem(
        title: "Sort List",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft"],
        keyIdeaEn: "Merge Sort on linked list dividing into 2 halves.",
        keyIdeaBn: "লিঙ্কড লিস্টের ডিভাইড অ্যান্ড কনকার মার্জ সর্ট।",
      ),
      KWayMergeProblem(
        title: "Find Right Interval",
        difficulty: "Medium",
        companyTags: ["Google", "Amazon"],
        keyIdeaEn: "Merge sorting interval start points and binary search.",
        keyIdeaBn: "ইনটারভাল স্টার্ট পয়েন্ট সর্ট করে ডান ইনডেক্স মেলান।",
      ),
      KWayMergeProblem(
        title: "Single-Threaded CPU",
        difficulty: "Medium",
        companyTags: ["Amazon", "Meta", "Google"],
        keyIdeaEn: "K-way heap processing tasks sorted by enqueue time and processing time.",
        keyIdeaBn: "সিপিইউ টাস্ক প্রসেসিং টাইম হিপে দিয়ে সর্ট করুন।",
      ),
      KWayMergeProblem(
        title: "Task Scheduler",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft"],
        keyIdeaEn: "Max-Heap tracking task frequencies with idle cooling periods.",
        keyIdeaBn: "Max-Heap ও কুলডাউন ক্যু দিয়ে টাস্ক শিডিউল করুন।",
      ),
    ];
  }

  static List<KWayMergeProblem> getHardProblems() {
    return const [
      KWayMergeProblem(
        title: "Merge k Sorted Lists",
        difficulty: "Hard",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft", "Bloomberg", "Apple"],
        keyIdeaEn: "Min-Heap of size K storing node pointers. Pop min node and push node->next in O(N log K).",
        keyIdeaBn: "K সাইজের Min-Heap এ পয়েন্টার রেখে O(N log K) সময়ে সব লিস্ট মার্জ করুন।",
        isPopular: true,
      ),
      KWayMergeProblem(
        title: "Smallest Range Covering Elements from K Lists",
        difficulty: "Hard",
        companyTags: ["Google", "Amazon", "Meta", "Microsoft"],
        keyIdeaEn: "Min-Heap tracking minimum across K lists + currentMax variable squeezing window [minVal, maxVal].",
        keyIdeaBn: "Min-Heap ও currentMax মেইনটেইন করে ক্ষুদ্রতম কভারিং রেঞ্জ বের করুন।",
        isPopular: true,
      ),
      KWayMergeProblem(
        title: "Find the Kth Smallest Sum of a Matrix With Sorted Rows",
        difficulty: "Hard",
        companyTags: ["Google", "Amazon"],
        keyIdeaEn: "Row by row K-way merge using Min-Heap keeping top K smallest sums.",
        keyIdeaBn: "সারি অনুযায়ী K-way মার্জ চালিয়ে K-তম ক্ষুদ্রতম যোগফল পান।",
      ),
    ];
  }

  static List<Map<String, String>> getCommonMistakes(bool isEnglish) {
    if (isEnglish) {
      return [
        {
          "title": "1. Pushing All N Elements into Min-Heap",
          "desc": "Dumping all N elements from all K lists into the heap loses the O(N log K) optimization. Only keep at most K elements in the Min-Heap!"
        },
        {
          "title": "2. Missing Custom Comparator for Min-Heap in C++",
          "desc": "Priority queues of structs/tuples in C++ require a custom comparator struct (`struct compare { bool operator()(ListNode* a, ListNode* b) { return a->val > b->val; } };`)."
        },
        {
          "title": "3. Null Pointer Dereference on List Traversal",
          "desc": "Attempting to push `node->next` without checking `if (node->next != nullptr)` triggers NullPointerDereference crashes when a list finishes."
        },
        {
          "title": "4. Failing to Track Max Element in Range Problem (LeetCode 632)",
          "desc": "Min-Heap gives the minimum element in O(1), but you must manually track `currentMax` whenever a new element is pushed to calculate the range `[minVal, maxVal]`."
        },
        {
          "title": "5. Inefficient Pair Combination Generation",
          "desc": "Pushing all N x M pairs into heap instead of greedily pushing `(i, j+1)` and `(i+1, j)` bounds."
        },
      ];
    } else {
      return [
        {
          "title": "১. সব N উপাদান একসাথে হিপে ঢুকিয়ে দেওয়া",
          "desc": "সব লিস্টের সবকটি সংখ্যা একসাথে হিপে পুশ করলে O(N log N) সময় লেগে যাবে। হিপের সাইজ সর্বদা সর্বোচ্চ K তে সীমিত রাখা বাধ্যতামূলক!"
        },
        {
          "title": "২. C++ এ কাস্টম কম্পারেটর না দেওয়া",
          "desc": "C++ এ পয়েন্টার বা কাস্টম স্ট্রাক্টের জন্য `priority_queue` তৈরি করতে কাস্টম ফানক্টর (`greater` অপারেটর) না দিলে কম্পাইল এরর হবে।"
        },
        {
          "title": "৩. নাল পয়েন্টার চেক না করে `node->next` পুশ করা",
          "desc": "`if (node->next != nullptr)` চেক না করে `node->next` হিপে যোগ করতে গেলে লিঙ্কড লিস্টের শেষে ক্র্যাশ ঘটাবে।"
        },
        {
          "title": "৪. রেঞ্জ প্রবলেমে (LeetCode 632) `currentMax` ট্র্যাকিং বাদ দেওয়া",
          "desc": "Min-Heap শুধু সর্বনিম্ন মান দেয়, কিন্তু রেঞ্জ `[minVal, maxVal]` হিসেব করতে হলে পুশ করার সময় `currentMax` আপডেট করা আবশ্যক।"
        },
        {
          "title": "৫. অহেতুক সব পেয়ার কম্বিনেশন হিপে জমা করা",
          "desc": "LeetCode 373 এ N x M সব পেয়ার না নিয়ে গ্রিডি নিয়মে কেবল পরবর্তী সম্ভাব্য পেয়ার হিপে পুশ করতে হবে।"
        },
      ];
    }
  }
}
