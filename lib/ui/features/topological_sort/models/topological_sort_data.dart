class TopologicalSortProblem {
  final String title;
  final String difficulty; // Easy, Medium, Hard
  final List<String> companyTags;
  final String keyIdeaEn;
  final String keyIdeaBn;
  final bool isPopular;

  const TopologicalSortProblem({
    required this.title,
    required this.difficulty,
    required this.companyTags,
    required this.keyIdeaEn,
    required this.keyIdeaBn,
    this.isPopular = false,
  });
}

class TopologicalSortData {
  static Map<String, String> getConceptIntro(bool isEnglish) {
    if (isEnglish) {
      return {
        "title": "Topological Sort (Graph) Pattern — Complete Deep Dive (C++ & FAANG Focus)",
        "summary": "Topological Sort provides a linear ordering of vertices in a Directed Acyclic Graph (DAG) such that for every directed edge u -> v, vertex u comes before v in the ordering. Topological sort can be implemented using Kahn's Algorithm (BFS with In-Degree Queue) or Post-Order DFS with a Stack, running in O(V + E) time and O(V + E) space.",
        "whenToUseTitle": "When to Use Topological Sort?",
        "whenToUse1": "Prerequisites / Course Scheduling problems (LeetCode 207, 210).",
        "whenToUse2": "Ordering characters in alien alphabets (Alien Dictionary LeetCode 269).",
        "whenToUse3": "Build system compilation order or task dependency resolution.",
        "whenToUse4": "Cycle detection in a Directed Graph (If topological sort returns fewer vertices than total V, a cycle exists!).",
        "whenToUse5": "Sequence Reconstruction or Minimum Height Trees (LeetCode 444, 310).",
        "typesTitle": "3 Main Topological Sort Patterns",
        "type1Title": "1. Kahn's Algorithm (BFS In-Degree Queue)",
        "type1Desc": "Compute inDegree[u] for all nodes. Push nodes with inDegree == 0 to Queue. Pop node u, append to result, decrement inDegree of all neighbors v. If inDegree[v] == 0, push to Queue.",
        "type2Title": "2. DFS 3-State Color Tagging (0=Unvisited, 1=Visiting, 2=Visited)",
        "type2Desc": "Detect cycles in directed graph. If DFS encounters state 1 (Visiting), a cycle exists! Otherwise, push node to Stack on post-order exit.",
        "type3Title": "3. Alien Alphabet / Lexicographical Ordering",
        "type3Desc": "Construct directed graph from character comparisons. Use Min-Heap instead of Queue in Kahn's Algorithm to get lexicographically smallest topological order.",
      };
    } else {
      return {
        "title": "Topological Sort (Graph) Pattern — সম্পূর্ণ গাইড (C++ ও FAANG ফোকাস)",
        "summary": "Topological Sort হলো একটি Directed Acyclic Graph (DAG) এর নোডগুলোর এমন একটি লিনিয়ার অনুক্রম তৈরি করা যাতে প্রতিটি ডিরেক্ট এডজ u -> v এর জন্য নোড u সর্বদা নোড v এর পূর্বে অবস্থান করে। এটি Kahn's Algorithm (BFS In-Degree Queue) বা DFS স্ট্যাক দিয়ে O(V + E) টাইম ও ও(V + E) স্পেসে সমাধান করা যায়।",
        "whenToUseTitle": "কখন বুঝবা Topological Sort লাগবে?",
        "whenToUse1": "পূর্বশর্ত বা কোর্স শিডিউলিং প্রবলেমে (Course Schedule LeetCode 207, 210)।",
        "whenToUse2": "ভিনগ্রহের ভাষা বা অ্যালিয়েন বর্ণমালার অক্ষরের ক্রম বের করতে (Alien Dictionary LeetCode 269)।",
        "whenToUse3": "বিল্ড সিস্টেম টাস্ক নির্ভরতা বা সফটওয়্যার ডিপেন্ডেন্সি সলভ করতে।",
        "whenToUse4": "ডিরেক্টেড গ্রাফে সাইকেল (Cycle Detection) আছে কিনা তা পরীক্ষা করতে।",
        "whenToUse5": "মিনিমাম হাইট ট্রি বা সিকোয়েন্স রিকনস্ট্রাকশনে (LeetCode 310, 444)।",
        "typesTitle": "Main Types (৩ ধরনের pattern)",
        "type1Title": "১. Kahn's Algorithm (BFS In-Degree ক্যু)",
        "type1Desc": "সব নোডের `inDegree` মেপে ইন-ডিগ্রি ০ যুক্ত নোডগুলো ক্যু-তে নাও। ক্যু থেকে নোড পপ করে রেজাল্টে যোগ করো এবং প্রতিবেশীর `inDegree` ১ কমাও। ০ হলে ক্যু-তে যোগ করো।",
        "type2Title": "২. DFS 3-State কালার ট্যাগের সাইকেল ডিটেকশন (0=Unvisited, 1=Visiting, 2=Visited)",
        "type2Desc": "ডিরেক্টেড গ্রাফে সাইকেল খুঁজতে ৩টি স্টেট মেইনটেইন করো। রিকার্শনে থাকা অবস্থায় স্টেট ১ (Visiting) নোডে পুনরায় পৌঁছালে সাইকেল বিদ্যমান।",
        "type3Title": "৩. Alien Alphabet / লেক্সিকোগ্রাফিকাল সর্ট",
        "type3Desc": "পার্শ্ববর্তী শব্দের ক্যারেক্টার তুলনা করে গ্রাফ বানাও। সাধারণ ক্যু এর বদলে Min-Heap ব্যবহার করে বর্ণমালার ক্রমানুসারে সর্ট করো।",
      };
    }
  }

  static List<TopologicalSortProblem> getEasyProblems() {
    return const [
      TopologicalSortProblem(
        title: "Find the Town Judge",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta", "Google"],
        keyIdeaEn: "Check in-degree equals N-1 and out-degree equals 0.",
        keyIdeaBn: "ইন-ডিগ্রি N-1 এবং আউট-ডিগ্রি 0 বিশিষ্ট নোড ফিল্টার করুন।",
        isPopular: true,
      ),
      TopologicalSortProblem(
        title: "Find Center of Star Graph",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta"],
        keyIdeaEn: "Find node appearing in both first two edges.",
        keyIdeaBn: "প্রথম দুটি এডজের সাধারণ নোডটিই স্টার গ্রাফের সেন্টার।",
        isPopular: true,
      ),
      TopologicalSortProblem(
        title: "Destination City",
        difficulty: "Easy",
        companyTags: ["Amazon", "Google"],
        keyIdeaEn: "Find city node with out-degree equal to 0.",
        keyIdeaBn: "আউট-ডিগ্রি 0 সহ গন্তব্য শহর চিহ্নিত করুন।",
      ),
      TopologicalSortProblem(
        title: "Find if Path Exists in Graph",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta", "Google"],
        keyIdeaEn: "BFS or DFS graph traversal check.",
        keyIdeaBn: "গ্রাফে উৎস থেকে গন্তব্যের পথ চেক করুন।",
      ),
      TopologicalSortProblem(
        title: "Check if Move is Legal",
        difficulty: "Easy",
        companyTags: ["Google", "Amazon"],
        keyIdeaEn: "Directional graph ray search.",
        keyIdeaBn: "ডিরেকশনাল গ্রাফে চালের ভ্যালিডিটি চেক করুন।",
      ),
      TopologicalSortProblem(
        title: "Evaluate Boolean Binary Tree",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta"],
        keyIdeaEn: "Post-order tree evaluation.",
        keyIdeaBn: "পোস্ট-অর্ডার রিকার্শনে বুলিয়ান মান হিসেব করুন।",
      ),
      TopologicalSortProblem(
        title: "Find Champion I",
        difficulty: "Easy",
        companyTags: ["Google", "Amazon"],
        keyIdeaEn: "Find node with in-degree 0 in directed matrix graph.",
        keyIdeaBn: "ইন-ডিগ্রি ০ বিশিষ্ট চ্যাম্পিয়ন নোড বের করুন।",
      ),
      TopologicalSortProblem(
        title: "Maximum In-Degree Node",
        difficulty: "Easy",
        companyTags: ["Google", "Amazon"],
        keyIdeaEn: "In-degree array maximum element lookup.",
        keyIdeaBn: "সর্বোচ্চ ইন-ডিগ্রির নোড খুঁজুন।",
      ),
    ];
  }

  static List<TopologicalSortProblem> getMediumProblems() {
    return const [
      TopologicalSortProblem(
        title: "Course Schedule",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft", "Bloomberg"],
        keyIdeaEn: "Kahn's Algorithm BFS or 3-State DFS cycle detection. Return true if res.size() == numCourses.",
        keyIdeaBn: "Kahn's BFS বা ৩-স্টেট DFS দিয়ে সাইকেল চেক করে কোর্স সমাপ্তির যোগ্যতা টেস্ট করুন।",
        isPopular: true,
      ),
      TopologicalSortProblem(
        title: "Course Schedule II",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft", "Bloomberg"],
        keyIdeaEn: "Kahn's Algorithm returning topological order array of courses.",
        keyIdeaBn: "কোর্সের সঠিক ক্রমসূচি পেতে Kahn's Algorithm টোপোলজিক্যাল অর্ডার রিটার্ন করুন।",
        isPopular: true,
      ),
      TopologicalSortProblem(
        title: "Minimum Height Trees",
        difficulty: "Medium",
        companyTags: ["Google", "Amazon", "Meta", "Microsoft"],
        keyIdeaEn: "Topological BFS trimming leaves (nodes with degree 1) inwards until 1 or 2 centroid roots remain.",
        keyIdeaBn: "ডিগ্রি ১ বিশিষ্ট নোড ছেঁটে ভেতরের সেনট্রয়েড নোড বের করুন।",
        isPopular: true,
      ),
      TopologicalSortProblem(
        title: "Course Schedule IV",
        difficulty: "Medium",
        companyTags: ["Google", "Amazon", "Meta"],
        keyIdeaEn: "Topological BFS + Bitset / Transitive closure matrix for prerequisite queries.",
        keyIdeaBn: "টোপোলজিক্যাল বিটসেট দিয়ে পূর্বশর্তের কোয়েরি সমাধান করুন।",
      ),
      TopologicalSortProblem(
        title: "Find Eventual Safe States",
        difficulty: "Medium",
        companyTags: ["Google", "Amazon", "Meta"],
        keyIdeaEn: "Reverse graph topological sort or 3-state DFS identifying terminal nodes.",
        keyIdeaBn: "রিভার্স গ্রাফে টোপোলজিক্যাল সর্ট করে সেফ নোড বের করুন।",
      ),
      TopologicalSortProblem(
        title: "Sequence Reconstruction",
        difficulty: "Medium",
        companyTags: ["Google", "Amazon"],
        keyIdeaEn: "Kahn's BFS verifying queue size is strictly 1 at every step for unique topological order.",
        keyIdeaBn: "প্রতি ধাপে ক্যু সাইজ ১ কিনা মেপে ইউনিক টোপোলজিক্যাল সর্ট পরীক্ষা করুন।",
      ),
      TopologicalSortProblem(
        title: "Sort Items by Groups Respecting Dependencies",
        difficulty: "Medium",
        companyTags: ["Google", "Amazon"],
        keyIdeaEn: "Dual-level Topological Sort: one on groups and one on items within each group.",
        keyIdeaBn: "গ্রুপ ও আইটেমের জোড়া টোপোলজিক্যাল সর্ট।",
      ),
      TopologicalSortProblem(
        title: "All Ancestors of a Node in a Directed Graph",
        difficulty: "Medium",
        companyTags: ["Amazon", "Meta", "Google"],
        keyIdeaEn: "Topological BFS propagating set of ancestor nodes.",
        keyIdeaBn: "টোপোলজিক্যাল BFS দিয়ে পূর্বপুরুষ নোড প্রোপাগেট করুন।",
      ),
    ];
  }

  static List<TopologicalSortProblem> getHardProblems() {
    return const [
      TopologicalSortProblem(
        title: "Alien Dictionary",
        difficulty: "Hard",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft", "Bloomberg", "Apple"],
        keyIdeaEn: "Build directed character graph from adjacent words comparison, then run Kahn's BFS or DFS for topological order.",
        keyIdeaBn: "শব্দের তুলনা থেকে ডিরেক্টেড ক্যারেক্টার গ্রাফ বানিয়ে অ্যালিয়েন বর্ণমালার টোপোলজিক্যাল অর্ডার পান।",
        isPopular: true,
      ),
      TopologicalSortProblem(
        title: "Longest Increasing Path in a Matrix",
        difficulty: "Hard",
        companyTags: ["Google", "Amazon", "Meta", "Microsoft"],
        keyIdeaEn: "Out-degree BFS Topological Sort or Memoized DFS on DAG grid.",
        keyIdeaBn: "গ্রিড DAG এ আউট-ডিগ্রি টোপোলজিক্যাল সর্ট বা মেমোইজড DFS।",
        isPopular: true,
      ),
      TopologicalSortProblem(
        title: "Parallel Courses III",
        difficulty: "Hard",
        companyTags: ["Google", "Amazon", "Meta"],
        keyIdeaEn: "Topological BFS tracking max completion time maxTime[v] = max(maxTime[v], maxTime[u] + time[v]).",
        keyIdeaBn: "টোপোলজিক্যাল BFS দিয়ে সমান্তরাল কোর্সের সর্বোচ্চ সময় ট্র্যাক করুন।",
      ),
    ];
  }

  static List<Map<String, String>> getCommonMistakes(bool isEnglish) {
    if (isEnglish) {
      return [
        {
          "title": "1. Attempting Topological Sort on Graphs with Cycles",
          "desc": "Topological sort ONLY works on Directed ACYCLIC Graphs (DAG). Running Kahn's algorithm on a graph with cycles results in incomplete ordering (`res.size() < V`). Always check `res.size() == V`!"
        },
        {
          "title": "2. Incorrect In-Degree Edge Direction",
          "desc": "Decrementing `inDegree` of parent instead of child (edge `u -> v` means `v` depends on `u`, so `inDegree[v]++`)."
        },
        {
          "title": "3. Using 2-State Visited Array in DFS for Directed Graphs",
          "desc": "In directed graphs, simple boolean `visited` array cannot distinguish between cross edges and back edges (cycles). You MUST use 3 states: `0 = Unvisited`, `1 = Visiting` (in current stack), `2 = Visited`."
        },
        {
          "title": "4. Forgetting Reverse Order in DFS Stack",
          "desc": "In DFS-based topological sort, elements must be popped from the post-order stack (or reversed) to get valid dependency order."
        },
        {
          "title": "5. Disconnected Graph Components Loss",
          "desc": "Failing to initialize the queue with all zero in-degree nodes across DISCONNECTED graph components."
        },
      ];
    } else {
      return [
        {
          "title": "১. সাইকেল থাকা ডিরেক্টেড গ্রাফে টোপোলজিক্যাল সর্ট চালানোর চেষ্টা",
          "desc": "Topological Sort কেবল DAG (Directed Acyclic Graph) এ কাজ করে। সাইকেল থাকলে `res.size() < V` হবে। সবসময় `res.size() == V` চেক করতে হবে!"
        },
        {
          "title": "২. ইন-ডিগ্রি হিসাবের সময় এজের ডিরেকশন উল্টে ফেলা",
          "desc": "`u -> v` এজের ক্ষেত্রে `v` নির্ভর করে `u` এর ওপর। তাই `inDegree[v]++` হবে, `inDegree[u]` নয়।"
        },
        {
          "title": "৩. DFS এ কেবল ২-স্টেট বুলিয়ান ভিজিটেড ব্যবহার করা",
          "desc": "ডিরেক্টেড গ্রাফে সাইকেল চিনতে ২-স্টেট বুলিয়ান যথেষ্ট নয়। অবশ্যই ৩-স্টেট ব্যবহার করতে হবে: `০ = Unvisited`, `১ = Visiting` (চলতি রিকার্শন), `২ = Visited`।"
        },
        {
          "title": "৪. DFS স্ট্যাক উল্টাতে ভুলে যাওয়া",
          "desc": "DFS ভিত্তিক টোপোলজিক্যাল সর্টে পোস্ট-অর্ডার স্ট্যাক থেকে রিভার্স করে মান না নিলে ডিপেন্ডেন্সি অর্ডার উল্টে যাবে।"
        },
        {
          "title": "৫. ডিসকানেক্টেড গ্রাফ কম্পোনেন্ট মিস করা",
          "desc": "গ্রাফের একাধিক বিচ্ছিন্ন অংশ থাকলে সব ইন-ডিগ্রি ০ নোড শুরুতে ক্যু-তে যোগ করতে ভুলে যাওয়া।"
        },
      ];
    }
  }
}
