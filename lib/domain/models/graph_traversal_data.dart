class GraphTraversalProblem {
  final String title;
  final String difficulty; // Easy, Medium, Hard
  final List<String> companyTags;
  final String keyIdeaEn;
  final String keyIdeaBn;
  final bool isPopular;

  const GraphTraversalProblem({
    required this.title,
    required this.difficulty,
    required this.companyTags,
    required this.keyIdeaEn,
    required this.keyIdeaBn,
    this.isPopular = false,
  });
}

class GraphTraversalData {
  static Map<String, String> getConceptIntro(bool isEnglish) {
    if (isEnglish) {
      return {
        "title": "Graph Traversal (BFS/DFS) Pattern — Complete Deep Dive (C++ & FAANG Focus)",
        "summary": "Graph Traversal involves systematically visiting all vertices and edges in a graph. Breadth-First Search (BFS) explores level-by-level using a Queue and guarantees the shortest path in unweighted graphs. Depth-First Search (DFS) explores as deep as possible along each branch using a Recursion Call Stack, ideal for connected components, Flood Fill, and cycle detection.",
        "whenToUseTitle": "When to Use Graph Traversal (BFS/DFS)?",
        "whenToUse1": "Finding shortest path / min steps in unweighted graph or grid (Word Ladder LeetCode 127, Shortest Path in Binary Matrix LeetCode 1091).",
        "whenToUse2": "Island counting, Flood Fill, or matrix region traversal (Number of Islands LeetCode 200, Flood Fill LeetCode 733, Max Area of Island LeetCode 695).",
        "whenToUse3": "Graph cloning and deep copy (Clone Graph LeetCode 133).",
        "whenToUse4": "Bipartite graph 2-coloring (Is Graph Bipartite? LeetCode 785).",
        "whenToUse5": "Finding connected components in undirected graph (Number of Connected Components LeetCode 323).",
        "typesTitle": "3 Main Graph Traversal Patterns",
        "type1Title": "1. BFS Queue Traversal (Shortest Path Level-by-Level)",
        "type1Desc": "Mark start node visited and push to queue. Loop while queue non-empty: pop node, visit unvisited neighbors, mark visited, push to queue.",
        "type2Title": "2. DFS Recursive Grid Traversal (Flood Fill)",
        "type2Desc": "Check boundaries & water ('0'). Mark visited, recursively call DFS in 4 directions: UP, DOWN, LEFT, RIGHT.",
        "type3Title": "3. Graph 2-Coloring (Bipartite Graph Check)",
        "type3Desc": "Use 2 colors (1 and -1). Assign start node color 1. If neighbor uncolored, assign -color and recurse; if same color, not bipartite!",
      };
    } else {
      return {
        "title": "Graph Traversal (BFS/DFS) Pattern — সম্পূর্ণ গাইড (C++ ও FAANG ফোকাস)",
        "summary": "গ্রাফ ট্রাভার্সাল বলতে সিস্টেমেটিকভাবে গ্রাফের সমস্ত নোড ও এজ ভিজিট করা বোঝায়। Breadth-First Search (BFS) ক্যু (Queue) ব্যবহার করে লেভেল-বাই-লেভেল এক্সপ্লোর করে এবং আনওয়েটেড গ্রাফে সর্বনিম্ন পথ (Shortest Path) নিশ্চিত করে। Depth-First Search (DFS) রিকার্শন স্ট্যাক দিয়ে গভীরে এক্সপ্লোর করে যা আইল্যান্ড কাউন্টিং, ফ্লাড ফিল ও সাইকেল ডিটেকশনে সেরা।",
        "whenToUseTitle": "কখন বুঝবা Graph Traversal (BFS/DFS) লাগবে?",
        "whenToUse1": "আনওয়েটেড গ্রাফে সর্বনিম্ন ধাপ বা শর্টেস্ট পাথ বের করতে (Word Ladder LeetCode 127, Shortest Path Matrix LeetCode 1091)।",
        "whenToUse2": "২D গ্রিডে দ্বীপের সংখ্যা বা এলাকা বের করতে (Number of Islands LeetCode 200, Flood Fill LeetCode 733)।",
        "whenToUse3": "গ্রাফের ডুপ্লিকেট বা ক্লোন কপি বানাতে (Clone Graph LeetCode 133)।",
        "whenToUse4": "বাইপারটাইট গ্রাফের ২-কালারিং ডিটেকশনে (Is Graph Bipartite? LeetCode 785)।",
        "whenToUse5": "গ্রাফের সংযোগ উপাদান বা কানেক্টেড কম্পোনেন্ট গণনায় (Number of Connected Components LeetCode 323)।",
        "typesTitle": "Main Types (৩ ধরনের pattern)",
        "type1Title": "১. BFS ক্যু ট্রাভার্সাল (শর্টেস্ট পাথ লেভেল-বাই-লেভেল)",
        "type1Desc": "স্টার্টিং নোড ভিজিটেড মার্ক করে ক্যু-তে যোগ করো। ক্যু থেকে নোড পপ করে প্রতিবেশীদের ভিজিটেড বানিয়ে ক্যু-তে পুশ করো।",
        "type2Title": "২. DFS রিকার্সিভ গ্রিড ট্রাভার্সাল (ফ্লাড ফিল)",
        "type2Desc": "বাউন্ডারি ও পানি ('0') চেক করো। নোড ভিজিটেড করে ৪ দিকে (উপরে, নিচে, বামে, ডানে) রিকার্সিভ DFS চালাও।",
        "type3Title": "৩. গ্রাফ ২-কালারিং (বাইপারটাইট গ্রাফ টেস্ট)",
        "type3Desc": "২টি রঙ (১ ও -১) ব্যবহার করো। প্রতিবেশীকে বিপরীত রঙ দাও। প্রতিবেশীর রঙ একই হলে গ্রাফ বাইপারটাইট নয়।",
      };
    }
  }

  static List<GraphTraversalProblem> getEasyProblems() {
    return const [
      GraphTraversalProblem(
        title: "Flood Fill",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta", "Google"],
        keyIdeaEn: "DFS or BFS matrix traversal changing starting pixel color recursively.",
        keyIdeaBn: "রিকার্সিভ DFS দিয়ে ম্যাট্রিক্সের কানেক্টেড পিক্সেল কালার পরিবর্তন করুন।",
        isPopular: true,
      ),
      GraphTraversalProblem(
        title: "Island Perimeter",
        difficulty: "Easy",
        companyTags: ["Amazon", "Google", "Meta"],
        keyIdeaEn: "Iterate grid or DFS counting land cell borders adjacent to water or bounds.",
        keyIdeaBn: "ভূমির ঘরের চারপাশে পানির সীমানা মেপে পরিসীমা গণনা করুন।",
        isPopular: true,
      ),
      GraphTraversalProblem(
        title: "Find Center of Star Graph",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta"],
        keyIdeaEn: "Find common node in first two edges.",
        keyIdeaBn: "প্রথম দুটি এজের সাধারণ নোড চিহ্নিত করুন।",
      ),
      GraphTraversalProblem(
        title: "Find if Path Exists in Graph",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta", "Google"],
        keyIdeaEn: "BFS or DFS graph traversal verifying source to destination connectivity.",
        keyIdeaBn: "BFS/DFS দিয়ে গ্রাফে গন্তব্যে পৌঁছানোর পথ ভেরিফাই করুন।",
      ),
      GraphTraversalProblem(
        title: "Keys and Rooms",
        difficulty: "Easy",
        companyTags: ["Amazon", "Google", "Meta"],
        keyIdeaEn: "BFS or DFS starting at room 0 collecting keys to visit all rooms.",
        keyIdeaBn: "রুম ০ থেকে চাবি দিয়ে সব রুমে ঢোকার সুবিধা পরীক্ষা করুন।",
      ),
      GraphTraversalProblem(
        title: "Same Tree",
        difficulty: "Easy",
        companyTags: ["Google", "Amazon"],
        keyIdeaEn: "DFS tree structure & node value comparison.",
        keyIdeaBn: "DFS দিয়ে ট্রি স্ট্রাকচার ও নোড ভ্যালু সমান কিনা মিলান।",
      ),
      GraphTraversalProblem(
        title: "Max Depth of Binary Tree",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta"],
        keyIdeaEn: "DFS returning 1 + max(depth(left), depth(right)).",
        keyIdeaBn: "রিকার্সিভ DFS দিয়ে সর্বোচ্চ গভীরতা পান।",
      ),
      GraphTraversalProblem(
        title: "Binary Tree Level Order Traversal Simple",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta"],
        keyIdeaEn: "BFS level-by-level queue traversal.",
        keyIdeaBn: "BFS ক্যু দিয়ে লেভেল বাই লেভেল নোড ভিজিট করুন।",
      ),
    ];
  }

  static List<GraphTraversalProblem> getMediumProblems() {
    return const [
      GraphTraversalProblem(
        title: "Number of Islands",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft", "Bloomberg"],
        keyIdeaEn: "Traverse grid. On land cell '1', increment island count and trigger DFS/BFS to sink all connected '1's to '0'.",
        keyIdeaBn: "'১' পেলেই দ্বীপ গণনা ১ বাড়াও এবং DFS দিয়ে সব যুক্ত '১' কে '০' বানিয়ে দাও।",
        isPopular: true,
      ),
      GraphTraversalProblem(
        title: "Clone Graph",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft", "Bloomberg"],
        keyIdeaEn: "DFS or BFS using HashMap<Node*, Node*> to map original nodes to their cloned deep copies.",
        keyIdeaBn: "হ্যাশম্যাপ দিয়ে অরিজিনাল নোডের বিপরীতে ক্লোন নোড ম্যাপ করে DFS চালান।",
        isPopular: true,
      ),
      GraphTraversalProblem(
        title: "Max Area of Island",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft"],
        keyIdeaEn: "DFS on grid returning 1 + sum of areas in 4 directions. Track maximum area.",
        keyIdeaBn: "DFS দিয়ে দ্বীপের ক্ষেত্রফল ১ + ৪ দিকের যোগফল হিসেবে সর্বোচ্চ মান নিন।",
        isPopular: true,
      ),
      GraphTraversalProblem(
        title: "Surrounded Regions",
        difficulty: "Medium",
        companyTags: ["Google", "Amazon", "Meta", "Microsoft"],
        keyIdeaEn: "Run DFS from boundary 'O' cells marking them safe, then flip remaining 'O' to 'X'.",
        keyIdeaBn: "সীমানার 'O' থেকে DFS চালিয়ে নিরাপদ চিহ্নিত করে বাকি 'O' কে 'X' বানিয়ে দিন।",
      ),
      GraphTraversalProblem(
        title: "Rotting Oranges",
        difficulty: "Medium",
        companyTags: ["Amazon", "Meta", "Google", "Microsoft", "Bloomberg"],
        keyIdeaEn: "Multi-Source BFS initializing queue with all rotten oranges (val 2) and expanding level by level.",
        keyIdeaBn: "মাল্টি-সোর্স BFS দিয়ে পচা কমলাগুলো ক্যু-তে যোগ করে লেভেল বাই লেভেল ছড়ান।",
        isPopular: true,
      ),
      GraphTraversalProblem(
        title: "Is Graph Bipartite?",
        difficulty: "Medium",
        companyTags: ["Meta", "Google", "Amazon", "Microsoft"],
        keyIdeaEn: "2-Coloring BFS or DFS checking if adjacent nodes have different colors.",
        keyIdeaBn: "২-কালারিং DFS দিয়ে চেক করুন প্রতিবেশীদের আলাদা রঙ দেয়া সম্ভব কিনা।",
      ),
      GraphTraversalProblem(
        title: "Word Ladder",
        difficulty: "Medium",
        companyTags: ["Amazon", "Meta", "Google", "Microsoft"],
        keyIdeaEn: "BFS level-order traversal on word graph finding shortest transformation sequence length.",
        keyIdeaBn: "শব্দ রূপান্তরের সবচেয়ে ছোট সিকোয়েন্স পেতে BFS চালান।",
      ),
      GraphTraversalProblem(
        title: "Shortest Path in Binary Matrix",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft"],
        keyIdeaEn: "8-directional BFS in binary matrix finding shortest path from (0,0) to (N-1,N-1).",
        keyIdeaBn: "৮-দিকমুখী BFS চালিয়ে শর্টেস্ট ক্লিয়ার পাথ খুঁজুন।",
      ),
    ];
  }

  static List<GraphTraversalProblem> getHardProblems() {
    return const [
      GraphTraversalProblem(
        title: "Word Ladder II",
        difficulty: "Hard",
        companyTags: ["Amazon", "Google", "Meta", "Microsoft"],
        keyIdeaEn: "BFS to build parent graph of shortest paths + DFS backtracking to reconstruct all transformation paths.",
        keyIdeaBn: "BFS দিয়ে শর্টেস্ট প্যারেন্ট গ্রাফ বানিয়ে DFS ব্যাকট্র্যাকিংয়ে সব পাথ রিটার্ন করুন।",
        isPopular: true,
      ),
      GraphTraversalProblem(
        title: "Shortest Path in a Grid with Obstacles Elimination",
        difficulty: "Hard",
        companyTags: ["Google", "Amazon", "Meta"],
        keyIdeaEn: "3D State BFS tracking (row, col, remaining_k_eliminations).",
        keyIdeaBn: "৩D স্টেট (row, col, k) ক্যু-তে রেখে শর্টেস্ট পাথ BFS চালান।",
        isPopular: true,
      ),
      GraphTraversalProblem(
        title: "Reconstruct Itinerary",
        difficulty: "Hard",
        companyTags: ["Google", "Amazon", "Meta", "Microsoft"],
        keyIdeaEn: "Eulerian Path Hierholzer's Algorithm using Min-Heap adjacency list DFS.",
        keyIdeaBn: "ইউলেরিয়ান পাথ ও Min-Heap ব্যবহার করে ফ্লাইটের ট্রাভেল অর্ডার বের করুন।",
      ),
    ];
  }

  static List<Map<String, String>> getCommonMistakes(bool isEnglish) {
    if (isEnglish) {
      return [
        {
          "title": "1. Marking Node as Visited When Popping Instead of Pushing",
          "desc": "In BFS, adding node to visited set ONLY when popped from queue causes DUPLICATE insertions into queue, spiking space complexity from O(V) to O(E) and causing Time Limit Exceeded (TLE)!"
        },
        {
          "title": "2. Missing Boundary & Base Case Checks in Matrix Grid DFS",
          "desc": "Forgetting to check `r < 0 || r >= rows || c < 0 || c >= cols` causes Array Index Out of Bounds exception."
        },
        {
          "title": "3. Infinite Recursion Due to Unmarked Visited State in Undirected Graph",
          "desc": "Cycles in undirected graphs cause infinite recursive DFS loops if visited nodes are not tracked or marked."
        },
        {
          "title": "4. Incorrect Level-Size Step Tracking in Multi-Source BFS",
          "desc": "Forgetting to capture `int levelSize = q.size()` at the start of each BFS level loop causes wrong shortest path step counts."
        },
        {
          "title": "5. Stack Overflow on Very Deep Graphs",
          "desc": "Deep graph paths can cause StackOverflowError in recursive DFS. Use explicit iterative stack or BFS for deep graphs."
        },
      ];
    } else {
      return [
        {
          "title": "১. ক্যু থেকে পপ করার সময় ভিজিটেড মার্ক করা (ইনসার্ট করার সময় না করা)",
          "desc": "BFS এ ক্যু-তে ঢোকানোর সময় ভিজিটেড মার্ক না করে পপ করার সময় করলে একই নোড বারবার ক্যু-তে ঢুকে মেমোরি এবং টাইম লিমিট অতিরিক্ত বাড়িয়ে (TLE) ফেলে!"
        },
        {
          "title": "২. ম্যাট্রিক্স গ্রিড DFS এ বাউন্ডারি চেক না করা",
          "desc": "`r < 0 || r >= rows || c < 0 || c >= cols` চেক করতে ভুলে গেলে এরে ইনডেক্স আউট অফ বাউন্ডস এক্সসেপশন ঘটে।"
        },
        {
          "title": "৩. আনডিরেক্টেড গ্রাফে ভিজিটেড স্টেট মার্ক না করায় ইনফিনিট রিকার্শন",
          "desc": "আনডিরেক্টেড গ্রাফে ভিজিটেড সেট না রাখলে DFS রিকার্শন অনবরত ঘুরে ক্র্যাশ করবে।"
        },
        {
          "title": "৪. মাল্টি-সোর্স BFS এ লেভেল সাইজ ক্যাপচার না করা",
          "desc": "লেভেল অনুযায়ী ধাপ গণনার জন্য `int levelSize = q.size()` ফিক্স না করলে শর্টেস্ট পাথের সঠিক সময় আসবে না।"
        },
        {
          "title": "৫. অতিরিক্ত গভীর গ্রাফে রিকার্সিভ DFS চালানোয় স্ট্যাক ওভারফ্লো",
          "desc": "অত্যধিক বড় গ্রাফে রিকার্সিভ DFS দিলে StackOverflowError হতে পারে। তখন ক্যু ভিত্তিক BFS বা ইটারেটিভ DFS ব্যবহার করুন।"
        },
      ];
    }
  }
}
