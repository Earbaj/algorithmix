class TwoHeapsProblem {
  final String title;
  final String difficulty; // Easy, Medium, Hard
  final List<String> companyTags;
  final String keyIdeaEn;
  final String keyIdeaBn;
  final bool isPopular;

  const TwoHeapsProblem({
    required this.title,
    required this.difficulty,
    required this.companyTags,
    required this.keyIdeaEn,
    required this.keyIdeaBn,
    this.isPopular = false,
  });
}

class TwoHeapsData {
  static Map<String, String> getConceptIntro(bool isEnglish) {
    if (isEnglish) {
      return {
        "title": "Two Heaps Pattern — Complete Deep Dive (C++ & FAANG Focus)",
        "summary": "The Two Heaps pattern uses two priority queues simultaneously: a Max-Heap (maxHeap) to store the smaller half of numbers and a Min-Heap (minHeap) to store the larger half. By maintaining the size invariant (maxHeap size equals minHeap size or minHeap size + 1), the median can be calculated in O(1) time while inserting in O(log N) time.",
        "whenToUseTitle": "When to Use Two Heaps?",
        "whenToUse1": "Finding the median of a dynamically growing data stream (LeetCode 295).",
        "whenToUse2": "Finding the median of sliding windows in an array (LeetCode 480).",
        "whenToUse3": "Maximize capital / IPO investment scheduling (Max-Heap for profits, Min-Heap for capital - LeetCode 502).",
        "whenToUse4": "Any problem requiring partition into two halves with fast access to max of small half and min of large half.",
        "whenToUse5": "Scheduling jobs or tasks with competing priority constraints.",
        "typesTitle": "3 Main Two Heaps Patterns",
        "type1Title": "1. Find Median from Data Stream",
        "type1Desc": "Push to maxHeap first, move maxHeap top to minHeap. If minHeap size exceeds maxHeap, move top back. O(1) Median query: return maxHeap.top() or average of both tops.",
        "type2Title": "2. Sliding Window Median",
        "type2Desc": "Maintain dual heaps + lazy removal hash map to remove elements leaving the sliding window of size K.",
        "type3Title": "3. IPO / Maximize Capital Pattern",
        "type3Desc": "Min-Heap for projects sorted by capital required. Max-Heap for affordable projects sorted by profit. Greedily pick top profit projects.",
      };
    } else {
      return {
        "title": "Two Heaps Pattern — সম্পূর্ণ গাইড (C++ ও FAANG ফোকাস)",
        "summary": "Two Heaps প্যাটার্ন দুটি প্রায়োরিটি ক্যু একসাথে ব্যবহার করে: ছোট অর্ধেকের সংখ্যার জন্য Max-Heap এবং বড় অর্ধেকের সংখ্যার জন্য Min-Heap। হিপ দুটির সাইজের ভারসাম্য (maxHeap size == minHeap size অথবা +1) বজায় রেখে ডাইনামিক ডাটা স্ট্রিম থেকে মাত্র O(1) সময়ে মধ্যমা (Median) বের করা যায়।",
        "whenToUseTitle": "কখন বুঝবা Two Heaps লাগবে?",
        "whenToUse1": "চলমান ডাটা স্ট্রিম (Data Stream) থেকে রিয়েল-টাইমে মধ্যমা (Median) বের করতে বললে (LeetCode 295)।",
        "whenToUse2": "স্লাইডিং উইন্ডোর মধ্যমা (Sliding Window Median) বের করতে বললে (LeetCode 480)।",
        "whenToUse3": "সর্বোচ্চ ক্যাপিটাল বা লাভ অর্জন সংক্রান্ত প্রবলেমে (IPO / Maximize Capital - LeetCode 502)।",
        "whenToUse4": "যেকোনো ডেটাকে দুটি অর্ধে বিভক্ত করে একপাশের সর্বোচ্চ ও অন্যপাশের সর্বনিম্ন উপাদান দ্রুত অ্যাক্সেস করতে।",
        "whenToUse5": "দুটি ভিন্ন শর্তে জব বা টাস্ক শিডিউলিং করার প্রবলেমে।",
        "typesTitle": "Main Types (৩ ধরনের pattern)",
        "type1Title": "১. Find Median from Data Stream (মিডিয়ান বের করা)",
        "type1Desc": "প্রথমে maxHeap এ পুশ করো, তারপর maxHeap top কে minHeap এ নাও। minHeap বড় হলে ফেরত আনো। O(1) সময়ে মিডিয়ান = maxHeap.top() অথবা দুই top এর গড়।",
        "type2Title": "২. Sliding Window Median (স্লাইডিং উইন্ডো মিডিয়ান)",
        "type2Desc": "দুইটি হিপের সাথে হ্যাশ ম্যাপ (Lazy Removal) মেইনটেইন করো যাতে উইন্ডো থেকে বের হয়ে যাওয়া উপাদান বাদ দেওয়া যায়।",
        "type3Title": "৩. IPO / Maximize Capital Pattern (ক্যাপিটাল ম্যাক্সিমাইজেশন)",
        "type3Desc": "ক্যাপিটাল দিয়ে সর্ট করতে Min-Heap এবং প্রফিট দিয়ে সর্ট করতে Max-Heap। সামর্থ্যের ভেতর থাকা সর্বোচ্চ প্রফিট প্রোজেক্ট সিলেক্ট করো।",
      };
    }
  }

  static List<TwoHeapsProblem> getEasyProblems() {
    return const [
      TwoHeapsProblem(
        title: "Kth Largest Element in a Stream",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta", "Google"],
        keyIdeaEn: "Min-Heap of size K. Top element always gives Kth largest element in stream.",
        keyIdeaBn: "K সাইজের Min-Heap। টপ উপাদানটিই সর্বদা K-তম বৃহত্তম সংখ্যা নির্দেশ করে।",
        isPopular: true,
      ),
      TwoHeapsProblem(
        title: "Last Stone Weight",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta"],
        keyIdeaEn: "Max-Heap popping two heaviest stones and pushing difference until 1 or 0 left.",
        keyIdeaBn: "Max-Heap থেকে ভারী দুটি পাথর বের করে বিয়োগফল আবার হিপে যোগ করুন।",
        isPopular: true,
      ),
      TwoHeapsProblem(
        title: "Relative Ranks",
        difficulty: "Easy",
        companyTags: ["Google", "Amazon"],
        keyIdeaEn: "Max-Heap storing pair (score, originalIndex) to assign Gold, Silver, Bronze.",
        keyIdeaBn: "Max-Heap এ স্কোর ও ইনডেক্স জোড়া রেখে র‍্যাংক প্রদান করুন।",
      ),
      TwoHeapsProblem(
        title: "Take Gifts From the Richest Pile",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta"],
        keyIdeaEn: "Max-Heap popping maximum gift pile, pushing floor(sqrt(val)) K times.",
        keyIdeaBn: "Max-Heap দিয়ে সর্বোচ্চ মান বের করে বর্গমূল যোগ করুন K বার।",
      ),
      TwoHeapsProblem(
        title: "Minimum Amount of Time to Fill Cups",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta"],
        keyIdeaEn: "Max-Heap greedy pairing of two largest cup demands.",
        keyIdeaBn: "Max-Heap দিয়ে সেরা দুটি পানির চাহিদা একসাথে পূরণ করুন।",
      ),
      TwoHeapsProblem(
        title: "Maximum Number of Integers to Choose From a Range I",
        difficulty: "Easy",
        companyTags: ["Google", "Amazon"],
        keyIdeaEn: "Greedy selection using hash set or min-heap.",
        keyIdeaBn: "গ্রিডি নিয়মে ছোট সংখ্যা বাছাই করুন।",
      ),
      TwoHeapsProblem(
        title: "Sort Array by Increasing Frequency",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta"],
        keyIdeaEn: "Custom priority queue sorting by frequency ascending, then value descending.",
        keyIdeaBn: "ফ্রিকোয়েন্সি অনুযায়ী ছোট থেকে বড় সর্ট করুন।",
      ),
      TwoHeapsProblem(
        title: "Make Array Zero by Subtracting Equal Amounts",
        difficulty: "Easy",
        companyTags: ["Google", "Amazon"],
        keyIdeaEn: "Count distinct non-zero elements using Hash Set or Min-Heap.",
        keyIdeaBn: "অসংলগ্ন ধনাত্মক সংখ্যার সংখ্যা গণনা করুন।",
      ),
    ];
  }

  static List<TwoHeapsProblem> getMediumProblems() {
    return const [
      TwoHeapsProblem(
        title: "IPO (Maximize Capital)",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft"],
        keyIdeaEn: "Min-Heap for capital required, Max-Heap for profit. Push affordable projects to Max-Heap and pick max profit.",
        keyIdeaBn: "ক্যাপিটালের জন্য Min-Heap, প্রফিটের জন্য Max-Heap। সামর্থ্যের ভেতর সেরা প্রফিট বাছুন।",
        isPopular: true,
      ),
      TwoHeapsProblem(
        title: "Task Scheduler",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft"],
        keyIdeaEn: "Max-Heap storing task frequencies + Queue for cooling down period.",
        keyIdeaBn: "Max-Heap এ ফ্রিকোয়েন্সি ও ক্যু তে কুল ডাউন সময় ট্র্যাকিং।",
        isPopular: true,
      ),
      TwoHeapsProblem(
        title: "Reorganize String",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google"],
        keyIdeaEn: "Max-Heap of character frequencies. Pop top 2 characters and append alternately.",
        keyIdeaBn: "Max-Heap থেকে সেরা ২ ফ্রিকোয়েন্সি চরিত্র বের করে একান্তরভাবে বসান।",
        isPopular: true,
      ),
      TwoHeapsProblem(
        title: "K Closest Points to Origin",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft"],
        keyIdeaEn: "Max-Heap of size K storing Euclidean distance pairs.",
        keyIdeaBn: "K সাইজের Max-Heap এ দূরত্বের জোড়া রেখে নিকটতম K পয়েন্ট বের করুন।",
        isPopular: true,
      ),
      TwoHeapsProblem(
        title: "Seat Reservation Manager",
        difficulty: "Medium",
        companyTags: ["Amazon", "Meta"],
        keyIdeaEn: "Min-Heap tracking unreserved seat numbers.",
        keyIdeaBn: "Min-Heap দিয়ে সর্বনিম্ন খালি সীট রিলিজ ও রিজার্ভ করুন।",
      ),
      TwoHeapsProblem(
        title: "Find Right Interval",
        difficulty: "Medium",
        companyTags: ["Google", "Amazon"],
        keyIdeaEn: "Two Heaps (Max-Heap of start times, Max-Heap of end times) or binary search.",
        keyIdeaBn: "টু হিপস দিয়ে ডানদিকের সর্টেড ইনডেক্স মেলান।",
      ),
      TwoHeapsProblem(
        title: "Distant Barcodes",
        difficulty: "Medium",
        companyTags: ["Amazon", "Google"],
        keyIdeaEn: "Max-Heap tracking barcode frequencies, fill adjacent indices safely.",
        keyIdeaBn: "Max-Heap দিয়ে পাশাপাশি একই বারকোড এড়িয়ে সাজান।",
      ),
      TwoHeapsProblem(
        title: "Single-Threaded CPU",
        difficulty: "Medium",
        companyTags: ["Amazon", "Meta", "Google"],
        keyIdeaEn: "Min-Heap for enqueue time, Min-Heap for processing time.",
        keyIdeaBn: "টাইম এরাইভাল ও প্রসেসিং টাইম আলাদা Min-Heap এ রেখে CPU শিডিউল করুন।",
      ),
    ];
  }

  static List<TwoHeapsProblem> getHardProblems() {
    return const [
      TwoHeapsProblem(
        title: "Find Median from Data Stream",
        difficulty: "Hard",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft", "Bloomberg"],
        keyIdeaEn: "Max-Heap for small half, Min-Heap for large half. Balance sizes within difference 1. O(1) median query.",
        keyIdeaBn: "ছোট অর্ধেকের Max-Heap, বড় অর্ধেকের Min-Heap। সাইজ ব্যালেন্স করে O(1) মিডিয়ান প্রদান।",
        isPopular: true,
      ),
      TwoHeapsProblem(
        title: "Sliding Window Median",
        difficulty: "Hard",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft"],
        keyIdeaEn: "Dual Heaps (Max/Min) + Hash Map lazy removal to update median over window K.",
        keyIdeaBn: "টু হিপস + ল্যাজি রিমুভাল হ্যাশ ম্যাপ দিয়ে K সাইজ উইন্ডোর মিডিয়ান ট্র্যাক করুন।",
        isPopular: true,
      ),
      TwoHeapsProblem(
        title: "Find the Kth Smallest Sum of a Matrix With Sorted Rows",
        difficulty: "Hard",
        companyTags: ["Google", "Amazon"],
        keyIdeaEn: "Min-Heap row sum combination tracker for K smallest matrix sums.",
        keyIdeaBn: "Min-Heap দিয়ে সর্টেড ম্যাট্রিক্স সারির K-তম ক্ষুদ্রতম যোগফল বের করুন।",
      ),
    ];
  }

  static List<Map<String, String>> getCommonMistakes(bool isEnglish) {
    if (isEnglish) {
      return [
        {
          "title": "1. Unbalanced Heap Sizes",
          "desc": "Allowing size difference to exceed 1 (`maxHeap.size() > minHeap.size() + 1`) breaks median calculation. Rebalance on every insertion!"
        },
        {
          "title": "2. Integer Overflow in Median Calculation",
          "desc": "Doing `(maxHeap.top() + minHeap.top()) / 2.0` with 32-bit integers can overflow before division. Use double casting: `((double)maxHeap.top() + minHeap.top()) / 2.0`."
        },
        {
          "title": "3. Inconsistent Heap Ordering in C++",
          "desc": "In C++, `priority_queue<int>` is a Max-Heap by default, whereas Min-Heap requires `priority_queue<int, vector<int>, greater<int>>`. Mixing them up breaks logic!"
        },
        {
          "title": "4. Failing to Handle Lazy Deletion in Sliding Window",
          "desc": "In Sliding Window Median, trying to erase directly from C++ `std::priority_queue` (which doesn't support random deletion) causes compiler errors."
        },
        {
          "title": "5. Wrong Capital/Profit Heap Assignment in IPO",
          "desc": "Putting `profit` into Min-Heap instead of Max-Heap, or `capital` into Max-Heap instead of Min-Heap."
        },
      ];
    } else {
      return [
        {
          "title": "১. হিপের সাইজ আনব্যালেন্সড রাখা",
          "desc": "দুটি হিপের সাইজের পার্থক্য ১ এর বেশি হতে দিলে মিডিয়ানের হিসেব ভুল আসবে। প্রতি ইনসারশনে ব্যালেন্স করা আবশ্যক!"
        },
        {
          "title": "২. মিডিয়ান গণনায় ইনটিজার ওভারফ্লো",
          "desc": "`maxHeap.top() + minHeap.top()` বড় ইনটিজার হলে ভাগ করার আগেই ওভারফ্লো হতে পারে। ডাবল কাস্টিং `((double)a + b) / 2.0` ব্যবহার করুন।"
        },
        {
          "title": "৩. C++ এ হিপের ক্যাটাগরি গুলে ফেলা",
          "desc": "C++ এ `priority_queue<int>` হলো Max-Heap, আর Min-Heap লিখতে `greater<int>` ফানক্টর লাগে। এটি উল্টে গেলে লজিক ভুল আসবে।"
        },
        {
          "title": "৪. স্লাইডিং উইন্ডোতে ল্যাজি রিমুভাল না রাখা",
          "desc": "C++ এর `priority_queue` থেকে সরাসরি মাঝখানের উপাদান ডিলিট করা যায় না। এর জন্য ল্যাজি রিমুভাল হ্যাশ ম্যাপ ব্যবহার করা বাধ্যতামূলক।"
        },
        {
          "title": "৫. IPO প্রবলেমে ক্যাপিটাল ও প্রফিট হিপ ওলটপালট করা",
          "desc": "প্রফিটের জন্য Max-Heap এবং ক্যাপিটালের জন্য Min-Heap লাগলেও ভুলবশত বিপরীতটি অ্যাসাইন করে ফেলা।"
        },
      ];
    }
  }
}
