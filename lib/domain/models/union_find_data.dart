class UnionFindProblem {
  final String title;
  final String difficulty; // Easy, Medium, Hard
  final List<String> companyTags;
  final String keyIdeaEn;
  final String keyIdeaBn;
  final bool isPopular;

  const UnionFindProblem({
    required this.title,
    required this.difficulty,
    required this.companyTags,
    required this.keyIdeaEn,
    required this.keyIdeaBn,
    this.isPopular = false,
  });
}

class UnionFindData {
  static Map<String, String> getConceptIntro(bool isEnglish) {
    if (isEnglish) {
      return {
        "title": "Union Find (Disjoint Set Union - DSU) Pattern — Complete Deep Dive (C++ & FAANG Focus)",
        "summary": "Union Find (Disjoint Set Union - DSU) efficiently tracks elements partitioned into dynamic disjoint sets. With two key optimizations—1) Path Compression in find(i) and 2) Union by Rank/Size in unite(u, v)—operations run in near O(1) amortized time (O(α(N)) using inverse Ackermann function).",
        "whenToUseTitle": "When to Use Union Find?",
        "whenToUse1": "Finding Connected Components count in a graph or 2D grid (Number of Islands LeetCode 200, Number of Provinces LeetCode 547).",
        "whenToUse2": "Cycle detection in an Undirected Graph (Redundant Connection LeetCode 684).",
        "whenToUse3": "Minimum Spanning Tree (Kruskal's Algorithm).",
        "whenToUse4": "Dynamic connectivity queries (Accounts Merge LeetCode 721, Most Stones Removed LeetCode 947).",
        "whenToUse5": "Lexicographically smallest equivalent string or sentence similarity (LeetCode 1061, 737).",
        "typesTitle": "3 Main Union Find Patterns",
        "type1Title": "1. Standard DSU (Path Compression & Union by Rank)",
        "type1Desc": "find(i) applies path compression: parent[i] = find(parent[i]). unite(u, v) merges root of smaller rank into larger rank.",
        "type2Title": "2. Connected Components Counter",
        "type2Desc": "Initialize count = N. Every time unite(u, v) successfully merges two disjoint roots, decrement count--.",
        "type3Title": "3. 2D Grid DSU (Matrix Index Mapping)",
        "type3Desc": "Map 2D cell (r, c) to 1D ID (r * C + c). Unite adjacent land cells to count connected islands dynamically.",
      };
    } else {
      return {
        "title": "Union Find (Disjoint Set Union - DSU) Pattern — সম্পূর্ণ গাইড (C++ ও FAANG ফোকাস)",
        "summary": "Union Find (Disjoint Set Union - DSU) একটি ডাইনামিক ডিসজয়েন্ট সেট ডাটা স্ট্রাকচার যা দ্রুততম সময়ে উপাদান সংযোগ পর্যবেক্ষণ করে। ২টি মূল অপটিমাইজেশন—১) Path Compression (find এ) এবং ২) Union by Rank/Size (unite এ)—ব্যবহারে প্রতিটি অপারেশন প্রায় O(1) বা O(α(N)) সময়ে সম্পন্ন হয়।",
        "whenToUseTitle": "কখন বুঝবা Union Find (DSU) লাগবে?",
        "whenToUse1": "গ্রাফ বা ২D গ্রিডে কানেক্টেড কম্পোনেন্ট বা দ্বীপের সংখ্যা বের করতে (Number of Provinces LeetCode 547)।",
        "whenToUse2": "আনডিরেক্টেড গ্রাফে সাইকেল ডিটেকশন বা অপ্রয়োজনীয় এজ খুঁজে বের করতে (Redundant Connection LeetCode 684)।",
        "whenToUse3": "মিনিমাম স্প্যানিং ট্রি বা Kruskal's Algorithm বাস্তবায়ন করতে।",
        "whenToUse4": "ডাইনামিক কানেক্টিভিটি কোয়েরি বা ইমেইল একাউন্ট মার্জিং প্রবলেমে (Accounts Merge LeetCode 721)।",
        "whenToUse5": "স্ট্রিংয়ের অক্ষর সমতুল্যতা বা বাক্যের সাদৃশ্যতা পরিমাপে (LeetCode 1061)।",
        "typesTitle": "Main Types (৩ ধরনের pattern)",
        "type1Title": "১. Standard DSU (পাথ কম্প্রেশন ও র‍্যাংক মার্জ)",
        "type1Desc": "`find(i)` এ পাথ কম্প্রেশন লাগাও: `parent[i] = find(parent[i])`। `unite(u, v)` এ ছোট র‍্যাংকের রুটকে বড় র‍্যাংকের রুটের সাথে মার্জ করো।",
        "type2Title": "২. Connected Components Counter (কম্পোনেন্ট কাউন্টার)",
        "type2Desc": "শুরুতে `count = N` ধরো। প্রতিবার `unite(u, v)` সফলভাবে দুটি ভিন্ন রুট মার্জ করলে `count--` করো।",
        "type3Title": "৩. 2D Grid DSU (ম্যাট্রিক্স ১D ম্যাপিং)",
        "type3Desc": "২D ঘরের ইনডেক্সকে ১D আইডি `r * C + c` এ রূপান্তর করো। পাশের ভূমির সাথে `unite` চালিয়ে ডাইনামিক দ্বীপ গণনা করো।",
      };
    }
  }

  static List<UnionFindProblem> getEasyProblems() {
    return const [
      UnionFindProblem(
        title: "Find Center of Star Graph",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta", "Google"],
        keyIdeaEn: "Find node connected to all other nodes using edge counts.",
        keyIdeaBn: "এডজ গণনায় কেন্দ্র নোড চিহ্নিত করুন।",
        isPopular: true,
      ),
      UnionFindProblem(
        title: "Find if Path Exists in Graph",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta", "Google"],
        keyIdeaEn: "Check if find(source) == find(destination) after uniting all edges.",
        keyIdeaBn: "এডজ মার্জ করে find(source) == find(destination) চেক করুন।",
        isPopular: true,
      ),
      UnionFindProblem(
        title: "Lexicographically Smallest Equivalent String",
        difficulty: "Easy",
        companyTags: ["Google", "Amazon"],
        keyIdeaEn: "DSU uniting equivalent characters, setting root to smaller alphabet char.",
        keyIdeaBn: "বর্ণমালার ছোট অক্ষরকে রুট বানিয়ে ক্যারেক্টার মার্জ করুন।",
        isPopular: true,
      ),
      UnionFindProblem(
        title: "Sentence Similarity",
        difficulty: "Easy",
        companyTags: ["Google", "Amazon"],
        keyIdeaEn: "DSU mapping word equivalences.",
        keyIdeaBn: "শব্দের সমতুল্যতা DSU দিয়ে টেস্ট করুন।",
      ),
      UnionFindProblem(
        title: "Friend Circles (Easy Variant)",
        difficulty: "Easy",
        companyTags: ["Meta", "Amazon"],
        keyIdeaEn: "DSU finding connected friend components.",
        keyIdeaBn: "বন্ধুদের কানেক্টেড কম্পোনেন্ট গণনা।",
      ),
      UnionFindProblem(
        title: "Maximum Connected Components Count",
        difficulty: "Easy",
        companyTags: ["Google", "Amazon"],
        keyIdeaEn: "Track max component size in DSU.",
        keyIdeaBn: "DSU তে সর্বোচ্চ কম্পোনেন্ট সাইজ ট্র্যাক করুন।",
      ),
      UnionFindProblem(
        title: "Number of Connected Components in Graph (Easy)",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta"],
        keyIdeaEn: "Count distinct DSU roots.",
        keyIdeaBn: "DSU রুট গণনা করে কম্পোনেন্ট সংখ্যা পান।",
      ),
      UnionFindProblem(
        title: "Merge Accounts Simple",
        difficulty: "Easy",
        companyTags: ["Google", "Amazon"],
        keyIdeaEn: "DSU parent grouping.",
        keyIdeaBn: "DSU প্যারেন্ট দিয়ে গ্রুপ তৈরি করুন।",
      ),
    ];
  }

  static List<UnionFindProblem> getMediumProblems() {
    return const [
      UnionFindProblem(
        title: "Number of Provinces",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft", "Bloomberg"],
        keyIdeaEn: "DSU initialized with N components. Iterate adjacency matrix and call unite(i, j). Return count.",
        keyIdeaBn: "N টি উপাদান দিয়ে DSU শুরু করে `unite(i, j)` চালান। বাকি কম্পোনেন্ট সংখ্যা রিটার্ন করুন।",
        isPopular: true,
      ),
      UnionFindProblem(
        title: "Redundant Connection",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft"],
        keyIdeaEn: "Process edges using DSU. The first edge where find(u) == find(v) is the redundant cycle edge!",
        keyIdeaBn: "প্রথমে `find(u) == find(v)` হওয়া এডজটিই অপ্রয়োজনীয় চক্র তৈরি করে।",
        isPopular: true,
      ),
      UnionFindProblem(
        title: "Accounts Merge",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft", "Bloomberg"],
        keyIdeaEn: "Map emails to IDs. Unite emails belonging to same account using DSU. Group by DSU root.",
        keyIdeaBn: "ইমেইলগুলোকে ID ম্যাপিং করে DSU দিয়ে একই রুটে মার্জ করুন।",
        isPopular: true,
      ),
      UnionFindProblem(
        title: "Most Stones Removed with Same Row or Column",
        difficulty: "Medium",
        companyTags: ["Google", "Amazon", "Meta"],
        keyIdeaEn: "Unite row index and column index (col + 10001) in DSU. Total removed = stones - components.",
        keyIdeaBn: "সারি ও কলাম ইনডেক্স DSU তে মার্জ করুন। অপসারণ সংখ্যা = পাথর - কম্পোনেন্ট।",
        isPopular: true,
      ),
      UnionFindProblem(
        title: "Number of Operations to Make Network Connected",
        difficulty: "Medium",
        companyTags: ["Amazon", "Meta", "Google"],
        keyIdeaEn: "Count redundant edges where find(u) == find(v). If redundant >= components - 1, operation possible.",
        keyIdeaBn: "অপ্রয়োজনীয় এডজ সংখ্যা >= কম্পোনেন্ট - ১ হলে নেটওয়ার্ক যুক্ত করা সম্ভব।",
      ),
      UnionFindProblem(
        title: "Satisfiability of Equality Equations",
        difficulty: "Medium",
        companyTags: ["Google", "Amazon", "Meta"],
        keyIdeaEn: "Unite variable pairs for '=='. Then check if find(a) == find(b) for '!=' equations.",
        keyIdeaBn: "সমান সমীকরণের জন্য DSU মার্জ করুন, অসমান সমীকরণের জন্য রুট পরীক্ষা করুন।",
      ),
      UnionFindProblem(
        title: "Evaluate Division",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft"],
        keyIdeaEn: "Weighted DSU tracking node parent and weight ratio parent_ratio[node].",
        keyIdeaBn: "ওয়েটেড DSU দিয়ে রেশিও গুণ হিসেব করুন।",
      ),
      UnionFindProblem(
        title: "Regions Cut By Slashes",
        difficulty: "Medium",
        companyTags: ["Google", "Amazon"],
        keyIdeaEn: "Split each 1x1 grid cell into 4 triangles and unite triangles using DSU.",
        keyIdeaBn: "১x১ ঘরকে ৪টি ত্রিভুজে ভাগ করে DSU তে মার্জ করুন।",
      ),
    ];
  }

  static List<UnionFindProblem> getHardProblems() {
    return const [
      UnionFindProblem(
        title: "Number of Islands II (Online DSU)",
        difficulty: "Hard",
        companyTags: ["Google", "Amazon", "Meta", "Microsoft"],
        keyIdeaEn: "Online DSU dynamically adding land positions and uniting 4-directional neighbors.",
        keyIdeaBn: "অনলাইন DSU দিয়ে প্রতি পজিশনে জমি যোগ করে ৪ পাশের প্রতিবেশীর সাথে মার্জ করুন।",
        isPopular: true,
      ),
      UnionFindProblem(
        title: "Making A Large Island",
        difficulty: "Hard",
        companyTags: ["Meta", "Google", "Amazon", "Microsoft"],
        keyIdeaEn: "Label island components using DSU/DFS, then flip 0 to 1 combining unique neighbor component sizes.",
        keyIdeaBn: "DSU দিয়ে দ্বীপ সাইজ মেপে ০ কে ১ এ রূপান্তর করে সর্বোচ্চ দ্বীপ তৈরি করুন।",
        isPopular: true,
      ),
      UnionFindProblem(
        title: "Remove Max Number of Edges to Keep Graph Fully Traversable",
        difficulty: "Hard",
        companyTags: ["Google", "Amazon", "Meta"],
        keyIdeaEn: "Dual DSU instances for Alice and Bob processing Type 3 edges first greedily.",
        keyIdeaBn: "এলিস ও ববের জন্য ২টি DSU বানিয়ে টাইপ ৩ এডজ আগে মার্জ করুন।",
      ),
    ];
  }

  static List<Map<String, String>> getCommonMistakes(bool isEnglish) {
    if (isEnglish) {
      return [
        {
          "title": "1. Forgetting Path Compression in `find()`",
          "desc": "Writing `int find(int i) { return parent[i] == i ? i : find(parent[i]); }` without assignment (`parent[i] = find(parent[i])`) degrades lookup performance from O(α(N)) to O(N) skew tree!"
        },
        {
          "title": "2. Uniting Without Finding Root Reps First",
          "desc": "Doing `parent[u] = v` instead of `parent[find(u)] = find(v)` causes invalid tree structures and broken component counts!"
        },
        {
          "title": "3. Using 0-Based vs 1-Based Node Indexing Inconsistently",
          "desc": "Allocating DSU array of size N when nodes are 1-indexed (1..N) leads to index out of bounds crashes. Always allocate size N + 1!"
        },
        {
          "title": "4. Failing to Initialize Parent Array",
          "desc": "Forgetting `parent[i] = i` in DSU constructor leaves parent array as 0, making all nodes belong to set 0."
        },
        {
          "title": "5. Inconsistent Component Count Decrementing",
          "desc": "Decrementing component count before checking if `rootU == rootV`. Only decrement when `rootU != rootV`!"
        },
      ];
    } else {
      return [
        {
          "title": "১. `find()` ফানে অ্যাসাইনমেন্ট বা পাথ কম্প্রেশন না করা",
          "desc": "`parent[i] = find(parent[i])` না লিখে কেবল `find(parent[i])` রিটার্ন করলে পারফরম্যান্স O(α(N)) থেকে ধসে O(N) হয়ে যাবে!"
        },
        {
          "title": "২. রুট বের না করে সরাসরি মার্জ করে ফেলা",
          "desc": "`parent[find(u)] = find(v)` এর জায়গায় `parent[u] = v` দিলে ভুল ট্রি তৈরি হবে এবং কম্পোনেন্ট সংখ্যা ভুল আসবে।"
        },
        {
          "title": "৩. ১-বেসড ইনডেক্সিংয়ে সাইজ N ধরা",
          "desc": "নোড ১ থেকে N পর্যন্ত হলে DSU অ্যারের সাইজ অবশ্যই `N + 1` ধরতে হবে, অন্যথায় ইনডেক্স আউট অফ বাউন্ডস ক্র্যাশ করবে।"
        },
        {
          "title": "৪. প্যারেন্ট এরে ইনিশিয়ালাইজ না করা",
          "desc": "কনস্ট্রাক্টরে `parent[i] = i` না দিলে সব নোডের রুট 0 হয়ে সব উপাদান ১টি সেটে ঢুকে যাবে।"
        },
        {
          "title": "৫. রুট চেক না করেই কম্পোনেন্ট কাউন্ট কমানো",
          "desc": "`rootU == rootV` হলে (ইতিমধ্যে যুক্ত) কম্পোনেন্ট কাউন্ট কমানো যাবে না। কেবল `rootU != rootV` হলেই কমানো যাবে।"
        },
      ];
    }
  }
}
