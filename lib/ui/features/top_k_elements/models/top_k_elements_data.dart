class TopKElementsProblem {
  final String title;
  final String difficulty; // Easy, Medium, Hard
  final List<String> companyTags;
  final String keyIdeaEn;
  final String keyIdeaBn;
  final bool isPopular;

  const TopKElementsProblem({
    required this.title,
    required this.difficulty,
    required this.companyTags,
    required this.keyIdeaEn,
    required this.keyIdeaBn,
    this.isPopular = false,
  });
}

class TopKElementsData {
  static Map<String, String> getConceptIntro(bool isEnglish) {
    if (isEnglish) {
      return {
        "title": "Top K Elements Pattern — Complete Deep Dive (C++ & FAANG Focus)",
        "summary": "The Top K Elements pattern uses a Min-Heap (or Max-Heap) of size K to track the K largest (or K smallest) elements from a dataset of size N. Instead of sorting the entire array in O(N log N) time, a Min-Heap of size K allows us to solve the problem in O(N log K) time and O(K) space.",
        "whenToUseTitle": "When to Use Top K Elements?",
        "whenToUse1": "Finding the K-th largest or smallest element in an array (LeetCode 215).",
        "whenToUse2": "Finding the Top K Most Frequent Elements (LeetCode 347).",
        "whenToUse3": "Finding K Closest Points to Origin (LeetCode 973) or K Closest Numbers (LeetCode 658).",
        "whenToUse4": "Reorganizing strings or scheduling tasks based on frequencies (LeetCode 767, 621).",
        "whenToUse5": "Top K frequent words in a text corpus (LeetCode 692).",
        "typesTitle": "3 Main Top K Elements Patterns",
        "type1Title": "1. Kth Largest / Smallest Element (Min-Heap Strategy)",
        "type1Desc": "Maintain a Min-Heap of fixed size K. Push elements into Min-Heap. If minHeap.size() > K, pop the top (minHeap.pop()). Top element minHeap.top() gives the Kth largest in O(N log K).",
        "type2Title": "2. Top K Frequent Elements",
        "type2Desc": "Count frequencies with unordered_map<int, int>. Push pair <frequency, element> to Min-Heap of size K. Pop when size exceeds K.",
        "type3Title": "3. K Closest Points / Distances",
        "type3Desc": "Calculate distances and store pair <distance, point> in a Max-Heap of size K. Squeeze heap size by popping farthest points.",
      };
    } else {
      return {
        "title": "Top K Elements Pattern — সম্পূর্ণ গাইড (C++ ও FAANG ফোকাস)",
        "summary": "Top K Elements প্যাটার্ন K সাইজের একটি Min-Heap (বা Max-Heap) ব্যবহার করে N সাইজের বিশাল অ্যারে থেকে সেরা K টি উপাদান বের করে। পুরো অ্যারে সর্ট করতে যেখানে O(N log N) লাগে, সেখানে K সাইজের Min-Heap ব্যবহারে মাত্র O(N log K) টাইম ও O(K) মেমোরিতে প্রবলেম সমাধান করা যায়।",
        "whenToUseTitle": "কখন বুঝবা Top K Elements লাগবে?",
        "whenToUse1": "অ্যারে থেকে K-তম বৃহত্তম বা ক্ষুদ্রতম সংখ্যা বের করতে বললে (LeetCode 215)।",
        "whenToUse2": "সবচেয়ে বেশি ফ্রিকোয়েন্সির Top K টি উপাদান বের করতে বললে (LeetCode 347)।",
        "whenToUse3": "মূলবিন্দু থেকে সবচেয়ে কাছের K টি পয়েন্ট বের করতে বললে (LeetCode 973)।",
        "whenToUse4": "ফ্রিকোয়েন্সির ওপর ভিত্তি করে স্ট্রিং নতুন করে সাজাতে বা টাস্ক শিডিউল করতে (LeetCode 767, 621)।",
        "whenToUse5": "টেক্সট থেকে সর্বোচ্চ ব্যবহৃত K টি শব্দ বের করতে (LeetCode 692)।",
        "typesTitle": "Main Types (৩ ধরনের pattern)",
        "type1Title": "১. Kth Largest / Smallest Element (Min-Heap স্ট্র্যাটেজি)",
        "type1Desc": "K সাইজের Min-Heap মেইনটেইন করো। এলিমেন্ট পুশ করো, সাইজ K ছাড়িয়ে গেলে ছোট উপাদানটি বাদ দাও (`minHeap.pop()`)। শেষে `minHeap.top()` ই K-তম বৃহত্তম মান।",
        "type2Title": "২. Top K Frequent Elements (ফ্রিকোয়েন্সি ম্যাপ + হিপ)",
        "type2Desc": "unordered_map দিয়ে ফ্রিকোয়েন্সি মাপো। `<frequency, val>` জোড়া Min-Heap এ পুশ করো। সাইজ K এর বেশি হলে পপ করো।",
        "type3Title": "৩. K Closest Points / Distances (দূরত্ব ভিত্তিক হিপ)",
        "type3Desc": "পয়েন্টের দূরত্ব হিসেব করে Max-Heap এ `<distance, point>` রাখো। K এর বেশি হলে দূরতম পয়েন্ট বাদ দাও।",
      };
    }
  }

  static List<TopKElementsProblem> getEasyProblems() {
    return const [
      TopKElementsProblem(
        title: "Kth Largest Element in a Stream",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta", "Google"],
        keyIdeaEn: "Min-Heap of size K. Top element always gives Kth largest element in stream.",
        keyIdeaBn: "K সাইজের Min-Heap। টপ উপাদানটিই সর্বদা K-তম বৃহত্তম সংখ্যা নির্দেশ করে।",
        isPopular: true,
      ),
      TopKElementsProblem(
        title: "Last Stone Weight",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta"],
        keyIdeaEn: "Max-Heap popping two heaviest stones and pushing difference until 1 or 0 left.",
        keyIdeaBn: "Max-Heap থেকে ভারী দুটি পাথর বের করে বিয়োগফল আবার হিপে যোগ করুন।",
        isPopular: true,
      ),
      TopKElementsProblem(
        title: "Relative Ranks",
        difficulty: "Easy",
        companyTags: ["Google", "Amazon"],
        keyIdeaEn: "Max-Heap storing pair (score, originalIndex) to assign Gold, Silver, Bronze.",
        keyIdeaBn: "Max-Heap এ স্কোর ও ইনডেক্স জোড়া রেখে র‍্যাংক প্রদান করুন।",
      ),
      TopKElementsProblem(
        title: "Take Gifts From the Richest Pile",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta"],
        keyIdeaEn: "Max-Heap popping maximum gift pile, pushing floor(sqrt(val)) K times.",
        keyIdeaBn: "Max-Heap দিয়ে সর্বোচ্চ মান বের করে বর্গমূল যোগ করুন K বার।",
      ),
      TopKElementsProblem(
        title: "Maximum Product of Two Elements in an Array",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta"],
        keyIdeaEn: "Find top 2 max elements using Min-Heap or single pass.",
        keyIdeaBn: "হিপ দিয়ে সেরা ২ বৃহত্তম সংখ্যা বের করে গুণফল পান।",
      ),
      TopKElementsProblem(
        title: "Find Target Indices After Sorting Array",
        difficulty: "Easy",
        companyTags: ["Google", "Amazon"],
        keyIdeaEn: "Sort or count elements less than target.",
        keyIdeaBn: "টার্গেটের ছোট সংখ্যার হিসেব করে সর্টেড ইনডেক্স বের করুন।",
      ),
      TopKElementsProblem(
        title: "Sort Array by Increasing Frequency",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta"],
        keyIdeaEn: "Priority queue with custom comparator sorting by frequency ascending.",
        keyIdeaBn: "ফ্রিকোয়েন্সি অনুযায়ী ছোট থেকে বড় সর্ট করুন।",
      ),
      TopKElementsProblem(
        title: "Make Array Zero by Subtracting Equal Amounts",
        difficulty: "Easy",
        companyTags: ["Google", "Amazon"],
        keyIdeaEn: "Min-Heap or Hash Set tracking unique positive elements.",
        keyIdeaBn: "ইউনিক ধনাত্মক উপাদানের সংখ্যা গণনা করুন।",
      ),
    ];
  }

  static List<TopKElementsProblem> getMediumProblems() {
    return const [
      TopKElementsProblem(
        title: "Kth Largest Element in an Array",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft", "Bloomberg"],
        keyIdeaEn: "Min-Heap of size K processing N elements in O(N log K) time and O(K) space.",
        keyIdeaBn: "K সাইজের Min-Heap দিয়ে O(N log K) সময়ে K-তম বড় সংখ্যাটি পান।",
        isPopular: true,
      ),
      TopKElementsProblem(
        title: "Top K Frequent Elements",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft", "Bloomberg"],
        keyIdeaEn: "Hash Map for frequency counting + Min-Heap of size K holding pair (freq, num).",
        keyIdeaBn: "ফ্রিকোয়েন্সি ম্যাপ + K সাইজের Min-Heap দিয়ে সেরা K টি ঘনসংখ্যা পান।",
        isPopular: true,
      ),
      TopKElementsProblem(
        title: "K Closest Points to Origin",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft"],
        keyIdeaEn: "Max-Heap of size K holding pairs of (Euclidean distance, point).",
        keyIdeaBn: "K সাইজের Max-Heap এ দূরত্বের জোড়া রেখে নিকটতম K পয়েন্ট বের করুন।",
        isPopular: true,
      ),
      TopKElementsProblem(
        title: "Top K Frequent Words",
        difficulty: "Medium",
        companyTags: ["Amazon", "Meta", "Google", "Microsoft"],
        keyIdeaEn: "Min-Heap of size K with custom comparator sorting by frequency asc, word desc.",
        keyIdeaBn: "ফ্রিকোয়েন্সি ও অ্যালফাবেটিকাল অর্ডারে টপ K টি শব্দ ফিল্টার করুন।",
        isPopular: true,
      ),
      TopKElementsProblem(
        title: "Find K Closest Elements",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft"],
        keyIdeaEn: "Max-Heap of size K holding pair (abs(x - num), num) or two pointers.",
        keyIdeaBn: "পার্থক্য দিয়ে Max-Heap বা টু পয়েন্টার ব্যবহার করে K টি নিকটের মান পান।",
      ),
      TopKElementsProblem(
        title: "Sort Characters By Frequency",
        difficulty: "Medium",
        companyTags: ["Amazon", "Meta", "Google"],
        keyIdeaEn: "Max-Heap holding pair (frequency, char) to build result string.",
        keyIdeaBn: "Max-Heap এ ফ্রিকোয়েন্সি রেখে বড় থেকে ছোট সাজান।",
      ),
      TopKElementsProblem(
        title: "Task Scheduler",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft"],
        keyIdeaEn: "Max-Heap tracking task frequencies + Queue for cooling period.",
        keyIdeaBn: "Max-Heap এ ফ্রিকোয়েন্সি ও ক্যু তে কুল ডাউন সময় ট্র্যাকিং।",
      ),
      TopKElementsProblem(
        title: "Reorganize String",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google"],
        keyIdeaEn: "Max-Heap of character frequencies. Pop top 2 characters alternately.",
        keyIdeaBn: "Max-Heap থেকে সেরা ২ ফ্রিকোয়েন্সি চরিত্র বের করে একান্তরভাবে বসান।",
      ),
    ];
  }

  static List<TopKElementsProblem> getHardProblems() {
    return const [
      TopKElementsProblem(
        title: "Find Median from Data Stream",
        difficulty: "Hard",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft", "Bloomberg"],
        keyIdeaEn: "Max-Heap for small half, Min-Heap for large half. Balance sizes within difference 1.",
        keyIdeaBn: "ছোট অর্ধেকের Max-Heap, বড় অর্ধেকের Min-Heap। সাইজ ব্যালেন্স করে O(1) মিডিয়ান প্রদান।",
        isPopular: true,
      ),
      TopKElementsProblem(
        title: "Sliding Window Maximum",
        difficulty: "Hard",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft"],
        keyIdeaEn: "Monotonic Deque or Max-Heap with lazy deletion over sliding window K.",
        keyIdeaBn: "স্লাইডিং উইন্ডো K তে মনোটোনিক ডিক্যু বা ম্যাক্স হিপ ব্যবহার করুন।",
        isPopular: true,
      ),
      TopKElementsProblem(
        title: "Smallest Range Covering Elements from K Lists",
        difficulty: "Hard",
        companyTags: ["Google", "Amazon", "Meta"],
        keyIdeaEn: "Min-Heap tracking minimum elements from each of K sorted lists.",
        keyIdeaBn: "K টি সর্টেড লিস্ট থেকে Min-Heap দিয়ে ক্ষুদ্রতম রেঞ্জ বের করুন।",
      ),
    ];
  }

  static List<Map<String, String>> getCommonMistakes(bool isEnglish) {
    if (isEnglish) {
      return [
        {
          "title": "1. Using Max-Heap Instead of Min-Heap for K Largest",
          "desc": "Using a Max-Heap requires storing ALL N elements in heap (O(N log N) time and O(N) space). Using a Min-Heap of size K reduces space to O(K) and time to O(N log K)!"
        },
        {
          "title": "2. Incorrect C++ Min-Heap Priority Queue Syntax",
          "desc": "In C++, `priority_queue<int>` is a Max-Heap! To make a Min-Heap, you MUST write `priority_queue<int, vector<int>, greater<int>>`."
        },
        {
          "title": "3. Wrong Pair Ordering in Priority Queue",
          "desc": "For Top K Frequent, pair should be `<frequency, element>` so priority queue sorts by frequency automatically! Putting element first sorts by element value instead."
        },
        {
          "title": "4. Popping Min-Heap Root Too Early",
          "desc": "Checking `size() == K` and popping before pushing current element can miss elements larger than the current root. Always push first, then check `size() > K`!"
        },
        {
          "title": "5. Not Preserving Stable Order in Tie Breakers",
          "desc": "In Top K Frequent Words, when frequencies are equal, failing to sort words lexicographically breaks output correctness."
        },
      ];
    } else {
      return [
        {
          "title": "১. K-তম বৃহত্তমের জন্য Min-Heap এর বদলে Max-Heap ব্যবহার",
          "desc": "Max-Heap ব্যবহার করলে N টি উপাদান হিপে রাখতে হয় (O(N log N) টাইম ও O(N) স্পেস)। K সাইজের Min-Heap ব্যবহার করলে মেমোরি O(K) এবং টাইম O(N log K) হয়ে যায়!"
        },
        {
          "title": "২. C++ এ Min-Heap এর ভুল সিনট্যাক্স",
          "desc": "C++ এ `priority_queue<int>` হলো Max-Heap! Min-Heap তৈরি করতে অবশ্যই `priority_queue<int, vector<int>, greater<int>>` লিখতে হবে।"
        },
        {
          "title": "৩. কাস্টম পেয়ার অর্ডার উল্টে ফেলা",
          "desc": "Top K Frequent এর জন্য পেয়ার `<frequency, val>` হওয়া উচিত। `<val, frequency>` দিলে ফ্রিকোয়েন্সি অনুযায়ী সর্ট না হয়ে মান অনুযায়ী সর্ট হয়ে যাবে।"
        },
        {
          "title": "৪. পুশ করার আগেই হিপ টপ পপ করা",
          "desc": "হিপে উপাদান পুশ করার আগে পপ করলে নতুন আসা বড় মান মিস হতে পারে। সবসময় আগে `push()` করো, তারপর `size() > K` হলে `pop()` করো!"
        },
        {
          "title": "৫. ফ্রিকোয়েন্সি সমান হলে টাই-ব্রেকার মিস করা",
          "desc": "Top K Frequent Words এ ফ্রিকোয়েন্সি সমান হলে বর্ণমালার ক্রমানুসারে (Lexicographically) সর্ট করার লজিক না রাখা।"
        },
      ];
    }
  }
}
