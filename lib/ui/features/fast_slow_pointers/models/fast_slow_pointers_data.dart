class FastSlowPointersProblem {
  final String title;
  final String difficulty; // Easy, Medium, Hard
  final List<String> companyTags;
  final String keyIdeaEn;
  final String keyIdeaBn;
  final bool isPopular;

  const FastSlowPointersProblem({
    required this.title,
    required this.difficulty,
    required this.companyTags,
    required this.keyIdeaEn,
    required this.keyIdeaBn,
    this.isPopular = false,
  });
}

class FastSlowPointersData {
  static Map<String, String> getConceptIntro(bool isEnglish) {
    if (isEnglish) {
      return {
        "title": "Fast & Slow Pointers (Floyd's Cycle Detection) — Complete Deep Dive (C++ & FAANG Focus)",
        "summary": "Fast and Slow Pointers (also known as the Tortoise and Hare algorithm) uses two pointers moving through a Linked List or Array at different speeds — slow moves 1 step while fast moves 2 steps. If a cycle exists, the fast pointer will eventually catch up and collide with slow in O(N) time and O(1) space.",
        "whenToUseTitle": "When to Use Fast & Slow Pointers?",
        "whenToUse1": "Detecting cycles in Linked Lists or Arrays without extra Hash Set memory (O(1) space).",
        "whenToUse2": "Finding the entry node where a cycle begins in a Linked List.",
        "whenToUse3": "Finding the middle node of a Linked List in a single pass.",
        "whenToUse4": "Determining if a number is a Happy Number (detecting sum-of-squares cycles).",
        "whenToUse5": "Finding duplicate numbers in an array of N+1 integers (LeetCode 287).",
        "typesTitle": "3 Main Fast & Slow Pointer Patterns",
        "type1Title": "1. Cycle Detection (Floyd's Tortoise & Hare)",
        "type1Desc": "Move slow = slow->next (1 step) and fast = fast->next->next (2 steps). If slow == fast, a cycle exists.",
        "type2Title": "2. Cycle Entry Node Discovery",
        "type2Desc": "After collision (slow == fast), reset slow = head. Advance both slow and fast 1 step at a time. They will meet at the cycle entry node.",
        "type3Title": "3. Midpoint & Partitioning",
        "type3Desc": "Move slow 1 step and fast 2 steps. When fast reaches null or fast->next is null, slow is pointing to the exact middle node.",
      };
    } else {
      return {
        "title": "Fast & Slow Pointers — সম্পূর্ণ গাইড (C++ ও FAANG ফোকাস)",
        "summary": "Fast and Slow Pointers (কচ্ছপ ও খরগোশ অ্যালগরিদম) হলো দুটি পয়েন্টার ভিন্ন গতিতে (slow ১ ধাপ, fast ২ ধাপ) লিঙ্কড লিস্ট বা অ্যারেতে চালনা করা। চক্র (Cycle) থাকলে fast পয়েন্টার ঘুরে এসে slow এর সাথে মিলিত (Collide) হবে।",
        "whenToUseTitle": "কখন বুঝবা Fast & Slow Pointers লাগবে?",
        "whenToUse1": "মেমোরি সেভ করে (O(1) স্পেস) লিঙ্কড লিস্ট বা অ্যারেতে সাইকেল শনাক্ত করা।",
        "whenToUse2": "লিঙ্কড লিস্টের কোন নোড থেকে সাইকেল শুরু হয়েছে (Cycle Entry) বের করা।",
        "whenToUse3": "এক পাসে লিঙ্কড লিস্টের ঠিক মাঝামাঝি নোড (Middle Node) খুঁজে পাওয়া।",
        "whenToUse4": "Happy Number সমস্যা সমাধান (সংখ্যার বর্গসমূহের যোগফলে চক্র ধরা)।",
        "whenToUse5": "N+1 উপাদানের অ্যারেতে ডুপ্লিকেট সংখ্যা খুঁজে বের করা (LeetCode 287)।",
        "typesTitle": "Main Types (৩ ধরনের pattern)",
        "type1Title": "১. Cycle Detection (সাইকেল ডিটেকশন)",
        "type1Desc": "slow = slow->next (১ ধাপ) এবং fast = fast->next->next (২ ধাপ)। slow == fast হলে সাইকেল নিশ্চিত।",
        "type2Title": "২. Cycle Entry Node (সাইকেল শুরুর নোড)",
        "type2Desc": "মিলিত হওয়ার পর slow = head রিসেট করে slow এবং fast দুটিকেই ১ ধাপ করে চালালে সাইকেলের শুরুতে দেখা হবে।",
        "type3Title": "৩. Midpoint Finder (মিডল নোড নির্ণয়)",
        "type3Desc": "slow ১ ধাপ এবং fast ২ ধাপ চালাও। fast শেষে পৌঁছালে slow ঠিক মাঝের নোডটি নির্দেশ করবে।",
      };
    }
  }

  static List<FastSlowPointersProblem> getEasyProblems() {
    return const [
      FastSlowPointersProblem(
        title: "Linked List Cycle",
        difficulty: "Easy",
        companyTags: ["Meta", "Amazon", "Microsoft", "Apple"],
        keyIdeaEn: "Floyd's Cycle Detection. Move slow 1 step, fast 2 steps. If slow == fast, cycle exists.",
        keyIdeaBn: "ফ্লয়েডের সাইকেল ডিটেকশন। slow ১ ধাপ, fast ২ ধাপ। slow == fast হলে সাইকেল আছে।",
        isPopular: true,
      ),
      FastSlowPointersProblem(
        title: "Middle of the Linked List",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta", "Google"],
        keyIdeaEn: "Slow 1 step, fast 2 steps. When fast reaches end, slow points to middle node.",
        keyIdeaBn: "slow ১ ধাপ, fast ২ ধাপ। fast শেষে পৌঁছালে slow ই হলো মিডল নোড।",
        isPopular: true,
      ),
      FastSlowPointersProblem(
        title: "Happy Number",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta", "Google"],
        keyIdeaEn: "Cycle detection on digit sum of squares. Slow gets sum of digits once, fast twice.",
        keyIdeaBn: "অঙ্কের বর্গের যোগফলের উপর সাইকেল ডিটেকশন।",
        isPopular: true,
      ),
      FastSlowPointersProblem(
        title: "Remove Duplicates from Sorted List",
        difficulty: "Easy",
        companyTags: ["Meta", "Amazon"],
        keyIdeaEn: "Single pointer or slow-fast skip duplicates in sorted linked list.",
        keyIdeaBn: "সর্টেড লিঙ্কড লিস্টে পয়েন্টার দিয়ে ডুপ্লিকেট স্কিপ করুন।",
      ),
      FastSlowPointersProblem(
        title: "Palindrome Linked List",
        difficulty: "Easy",
        companyTags: ["Meta", "Amazon", "Microsoft"],
        keyIdeaEn: "Find middle using fast-slow, reverse second half, compare both halves.",
        keyIdeaBn: "fast-slow দিয়ে মিডল খুঁজে ২য় অর্ধেক রিভার্স করে ১ম অর্ধেকের সাথে মেলান।",
        isPopular: true,
      ),
      FastSlowPointersProblem(
        title: "Delete Node in a Linked List",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta", "Apple"],
        keyIdeaEn: "Copy next node value into current node and update next pointer.",
        keyIdeaBn: "পরবর্তী নোডের মান চলতি নোডে কপি করে লিঙ্ক স্কিপ করুন।",
      ),
      FastSlowPointersProblem(
        title: "Swapping Nodes in a Linked List",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta"],
        keyIdeaEn: "Two pointers separated by K nodes to swap K-th from start and K-th from end.",
        keyIdeaBn: "K ব্যবধানে থাকা পয়েন্টার দিয়ে শুরু ও শেষের K-তম নোড সোয়াপ করুন।",
      ),
      FastSlowPointersProblem(
        title: "Intersection of Two Linked Lists",
        difficulty: "Easy",
        companyTags: ["Meta", "Amazon", "Microsoft"],
        keyIdeaEn: "Two pointers. Switch heads when reaching null until both pointers meet at intersection.",
        keyIdeaBn: "দুইটি পয়েন্টার। নাল পেলে অন্য লিস্টের হেডে সুইচ করে ইন্টারসেকশনে মিট করান।",
      ),
    ];
  }

  static List<FastSlowPointersProblem> getMediumProblems() {
    return const [
      FastSlowPointersProblem(
        title: "Linked List Cycle II (Find Cycle Entry Node)",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Microsoft", "Uber"],
        keyIdeaEn: "Detect cycle with fast-slow. Reset slow to head, advance both 1 step to meet at cycle entry.",
        keyIdeaBn: "সাইকেল পাওয়ার পর slow=head রিসেট করে ২টিকেই ১ ধাপ চালালে সাইকেলের শুরুর নোড পাওয়া যাবে।",
        isPopular: true,
      ),
      FastSlowPointersProblem(
        title: "Find the Duplicate Number",
        difficulty: "Medium",
        companyTags: ["Amazon", "Meta", "Google", "Microsoft"],
        keyIdeaEn: "Treat array indices as linked list (nums[i] -> nums[nums[i]]). Floyd's cycle detection finds duplicate!",
        keyIdeaBn: "অ্যারের মানগুলোকে লিঙ্কড লিস্ট নোডের মতো ভেবে ফ্লয়েডের সাইকেল ডিটেকশন প্রয়োগ করুন!",
        isPopular: true,
      ),
      FastSlowPointersProblem(
        title: "Reorder List",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google"],
        keyIdeaEn: "1. Find middle node. 2. Reverse second half. 3. Merge two halves alternating nodes.",
        keyIdeaBn: "১. মিডল খুঁজুন। ২. ২য় অর্ধেক রিভার্স করুন। ৩. একান্তরভাবে জোড়া লাগান।",
        isPopular: true,
      ),
      FastSlowPointersProblem(
        title: "Circular Array Loop",
        difficulty: "Medium",
        companyTags: ["Amazon", "Google"],
        keyIdeaEn: "Fast & slow pointers on index jumping (i + nums[i]) % N. Ensure single-direction movement.",
        keyIdeaBn: "অ্যারে ইনডেক্স জাম্পিংয়ের উপর fast-slow পয়েন্টার। দিক অপরিবর্তিত রাখা আবশ্যক।",
      ),
      FastSlowPointersProblem(
        title: "Split Linked List in Parts",
        difficulty: "Medium",
        companyTags: ["Amazon", "Meta"],
        keyIdeaEn: "Calculate length and partition size. Cut list into K equal sub-lists.",
        keyIdeaBn: "মোট দৈর্ঘ্য হিসেব করে লিস্টকে K টি সমান অংশে ভাগ করুন।",
      ),
      FastSlowPointersProblem(
        title: "Remove Nth Node From End of List",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google"],
        keyIdeaEn: "Advance fast pointer N steps ahead. Then move slow and fast together until fast reaches end.",
        keyIdeaBn: "fast পয়েন্টারকে N ধাপ এগিয়ে দিয়ে তারপর slow ও fast একসাথে চালান।",
        isPopular: true,
      ),
      FastSlowPointersProblem(
        title: "Maximum Twin Sum of a Linked List",
        difficulty: "Medium",
        companyTags: ["Amazon", "Meta"],
        keyIdeaEn: "Find middle node, reverse second half, compute twin pair sums.",
        keyIdeaBn: "মিডল খুঁজে ২য় অর্ধেক রিভার্স করে টুইন যোগফল বের করুন।",
      ),
      FastSlowPointersProblem(
        title: "Sort List (Merge Sort on Linked List)",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google"],
        keyIdeaEn: "Fast-slow pointer to find mid, split list, recursively sort and merge two halves.",
        keyIdeaBn: "fast-slow দিয়ে মাঝখানে কেটে রিকার্সিভ মার্জ সর্ট প্রয়োগ করুন।",
      ),
    ];
  }

  static List<FastSlowPointersProblem> getHardProblems() {
    return const [
      FastSlowPointersProblem(
        title: "Reverse Nodes in k-Group",
        difficulty: "Hard",
        companyTags: ["Amazon", "Meta", "Google", "Microsoft"],
        keyIdeaEn: "Count K nodes ahead. Reverse sub-list of K nodes, recursively reconnect remaining groups.",
        keyIdeaBn: "K টি করে নোড গুনে গুনে রিভার্স করে কানেক্ট করুন।",
        isPopular: true,
      ),
      FastSlowPointersProblem(
        title: "Merge k Sorted Lists",
        difficulty: "Hard",
        companyTags: ["Amazon", "Meta", "Google", "Microsoft"],
        keyIdeaEn: "Divide & Conquer using middle pointer or Priority Queue min-heap.",
        keyIdeaBn: "ডিভাইড অ্যান্ড কনকার অথবা মিন-হিপ দিয়ে K টি সর্টেড লিস্ট মার্জ করুন।",
        isPopular: true,
      ),
      FastSlowPointersProblem(
        title: "LFU Cache",
        difficulty: "Hard",
        companyTags: ["Amazon", "Meta", "Google"],
        keyIdeaEn: "Doubly Linked List + Hash Map to track least frequently used cache items.",
        keyIdeaBn: "ডাবলি লিঙ্কড লিস্ট ও হ্যাশ ম্যাপ দিয়ে LFU ক্যাশ ইমপ্লিমেন্ট করুন।",
      ),
    ];
  }

  static List<Map<String, String>> getCommonMistakes(bool isEnglish) {
    if (isEnglish) {
      return [
        {
          "title": "1. Null Pointer Dereference Crash",
          "desc": "Forgetting `fast != nullptr && fast->next != nullptr` before evaluating `fast->next->next` causes an immediate segmentation fault / runtime crash!"
        },
        {
          "title": "2. Infinite Loops in Non-Cycle Lists",
          "desc": "Advancing pointers inside a `while` loop without proper null checks leads to infinite loop execution."
        },
        {
          "title": "3. Miscalculating Middle Node for Even Lengths",
          "desc": "For even length lists, whether `slow` lands on the 1st middle or 2nd middle depends on whether `fast` starts at `head` or `head->next`."
        },
        {
          "title": "4. Destroying Node Pointers Without Backup",
          "desc": "Reassigning `curr->next = prev` without preserving `nextTemp = curr->next` breaks list connectivity permanently."
        },
        {
          "title": "5. Using Extra Memory O(N)",
          "desc": "Using a Hash Set to track visited nodes when the problem constraints strictly require O(1) auxiliary space."
        },
      ];
    } else {
      return [
        {
          "title": "১. নাল পয়েন্টার ডিরেফারেন্স (Null Pointer Crash)",
          "desc": "`fast->next->next` কল দেওয়ার আগে `fast != null && fast->next != null` চেক করতে ভুলে গেলে অ্যাপ সঙ্গে সঙ্গে ক্র্যাশ করবে!"
        },
        {
          "title": "২. নোড ট্রাভার্সালে অসীম লুপ",
          "desc": "সাইকেল না থাকা লিঙ্কড লিস্টে নাল নোড চেক না করে পয়েন্টার বাড়ালে অসীম লুপে ঝুলবে।"
        },
        {
          "title": "৩. জোড় দৈর্ঘ্যে মিডল নোড নির্ধারণে ভুল",
          "desc": "জোড় সংখ্যক নোড থাকলে slow পয়েন্টার ১ম মিডল নাকি ২য় মিডলে থামবে তা নির্ভর করে fast পয়েন্টার কোথায় শুরু হয়েছে তার ওপর।"
        },
        {
          "title": "৪. ব্যাকআপ না রেখে লিঙ্ক ভেঙে দেওয়া",
          "desc": "`nextTemp = curr->next` ব্যাকআপ না রেখেই `curr->next = prev` করলে পরবর্তী সব নোড হারিয়ে যায়।"
        },
        {
          "title": "৫. O(1) স্পেসের শর্ত ভঙ্গ করে হ্যাশ সেট ব্যবহার",
          "desc": "ইন্টারভিউতে O(1) স্পেসের কথা বললে হ্যাশ সেট বা অ্যারে মেমোরি ব্যবহার না করে fast-slow পয়েন্টার ব্যবহার করতে হবে।"
        },
      ];
    }
  }
}
