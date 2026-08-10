class TreeBfsProblem {
  final String title;
  final String difficulty; // Easy, Medium, Hard
  final List<String> companyTags;
  final String keyIdeaEn;
  final String keyIdeaBn;
  final bool isPopular;

  const TreeBfsProblem({
    required this.title,
    required this.difficulty,
    required this.companyTags,
    required this.keyIdeaEn,
    required this.keyIdeaBn,
    this.isPopular = false,
  });
}

class TreeBfsData {
  static Map<String, String> getConceptIntro(bool isEnglish) {
    if (isEnglish) {
      return {
        "title": "Tree BFS (Level Order Traversal) — Complete Deep Dive (C++ & FAANG Focus)",
        "summary": "Tree BFS (Breadth-First Search) processes binary tree nodes level-by-level from top to bottom, left to right. It relies on a FIFO Queue (std::queue in C++). The cornerstone technique is snapshotting the queue size at the start of each level loop (int levelSize = q.size()) to isolate current level nodes from newly added children.",
        "whenToUseTitle": "When to Use Tree BFS?",
        "whenToUse1": "Traversing a tree level by level from top to bottom or bottom to top.",
        "whenToUse2": "Finding the shortest path or minimum depth from root to any leaf node.",
        "whenToUse3": "Calculating level averages, maximum level values, or rightmost/leftmost visible nodes.",
        "whenToUse4": "Zigzag or Snake order level traversal.",
        "whenToUse5": "Connecting level order siblings (nextRight pointers in tree nodes).",
        "typesTitle": "3 Main Tree BFS Patterns",
        "type1Title": "1. Standard Level Order Traversal",
        "type1Desc": "Push root to std::queue. While queue is not empty, snapshot levelSize = q.size(). Process levelSize nodes, push non-null children (left and right) to queue.",
        "type2Title": "2. Zigzag / Snake Order Traversal",
        "type2Desc": "Maintain a boolean flag leftToRight. Depending on flag, insert nodes from front or back of level vector, then invert flag (leftToRight = !leftToRight) per level.",
        "type3Title": "3. Right / Left Side View of Binary Tree",
        "type3Desc": "Process level nodes using BFS. For each level loop, capture the value of the last node (i == levelSize - 1) for Right Side View.",
      };
    } else {
      return {
        "title": "Tree BFS (Level Order Traversal) — সম্পূর্ণ গাইড (C++ ও FAANG ফোকাস)",
        "summary": "Tree BFS (Breadth-First Search) হলো বাইনারি ট্রি এর নোডগুলোকে উপর থেকে নিচে, লেভেল বাই লেভেল ট্রাভার্স করা। এটি একটি FIFO Queue (std::queue) ব্যবহার করে কাজ করে। প্রতিটি লেভেল লুপের শুরুতে ক্যু এর সাইজ (`int levelSize = q.size()`) স্ন্যাপশট নিয়ে বর্তমান লেভেলের নোড আলাদা করা এর মূল কৌশল।",
        "whenToUseTitle": "কখন বুঝবা Tree BFS লাগবে?",
        "whenToUse1": "ট্রি এর নোডগুলোকে লেভেল অনুযায়ী উপর থেকে নিচে ট্রাভার্স করতে হলে।",
        "whenToUse2": "রুট থেকে যেকোনো লিফ নোডের সংক্ষিপ্ততম দূরত্ব (Shortest Path / Min Depth) বের করতে।",
        "whenToUse3": "প্রতিটি লেভেলের গড় মান, সর্বোচ্চ মান বা ডানপাশের অদৃশ্য মান (Right Side View) বের করতে।",
        "whenToUse4": "জিগজ্যাগ (Zigzag / Snake Order) ট্রাভার্সাল করতে।",
        "whenToUse5": "একই লেভেলের নোডগুলোকে কানেক্ট করতে (Populating Next Right Pointers)।",
        "typesTitle": "Main Types (৩ ধরনের pattern)",
        "type1Title": "১. Standard Level Order Traversal (সাধারণ লেভেল অর্ডার)",
        "type1Desc": "রুট ক্যু তে পুশ করো। যতক্ষণ ক্যু খালি নয়, `levelSize = q.size()` ব্যাকআপ নাও। `levelSize` সংখ্যক নোড পপ করে চিলড্রেন (left ও right) ক্যু তে যোগ করো।",
        "type2Title": "২. Zigzag / Snake Order (জিগজ্যাগ লেভেল অর্ডার)",
        "type2Desc": "একটি বুলিয়ান ফ্ল্যাগ `leftToRight` মেইনটেইন করো। ফ্ল্যাগের ওপর ভিত্তি করে বাম বা ডানে নোডের মান যোগ করো এবং প্রতি লেভেলে ফ্ল্যাগ টগল করো।",
        "type3Title": "৩. Right Side View (ডানপাশের দৃশ্যমান নোড)",
        "type3Desc": "BFS দিয়ে প্রতি লেভেলের নোড প্রসেস করো। প্রতি লেভেলের শেষ নোডের মানটির (`i == levelSize - 1`) লিস্টে যোগ করো।",
      };
    }
  }

  static List<TreeBfsProblem> getEasyProblems() {
    return const [
      TreeBfsProblem(
        title: "Average of Levels in Binary Tree",
        difficulty: "Easy",
        companyTags: ["Meta", "Amazon", "Google"],
        keyIdeaEn: "BFS level order. Compute sum of level nodes divided by levelSize.",
        keyIdeaBn: "BFS লেভেল অর্ডারে প্রতি লেভেলের যোগফলকে levelSize দিয়ে ভাগ করে গড় বের করুন।",
        isPopular: true,
      ),
      TreeBfsProblem(
        title: "Minimum Depth of Binary Tree",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta", "Microsoft"],
        keyIdeaEn: "BFS level order. Return current depth immediately when first leaf node (no left & right) is popped.",
        keyIdeaBn: "BFS দিয়ে ১ম লিফ নোড (যার left ও right নাল) পাওয়া মাত্রই লেভেল গভীরতা রিটার্ন করুন।",
        isPopular: true,
      ),
      TreeBfsProblem(
        title: "Binary Tree Level Order Traversal II",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta", "Google"],
        keyIdeaEn: "Standard BFS level order, then reverse result list (bottom-up level order).",
        keyIdeaBn: "স্ট্যান্ডার্ড BFS শেষে রেজাল্ট ভেক্টর রিভার্স (নিচ থেকে উপরে) করুন।",
      ),
      TreeBfsProblem(
        title: "Same Tree",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta"],
        keyIdeaEn: "Dual queue BFS comparing node values level by level.",
        keyIdeaBn: "জোড়া ক্যু BFS দিয়ে লেভেল বাই লেভেল মান মেলান।",
      ),
      TreeBfsProblem(
        title: "Symmetric Tree",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta", "Microsoft"],
        keyIdeaEn: "Queue BFS pushing pairs (left->left, right->right) and (left->right, right->left).",
        keyIdeaBn: "ক্যু তে বিপরীত সাব-ট্রি জোড়ায় পুশ করে মিরর চেক করুন।",
      ),
      TreeBfsProblem(
        title: "Maximum Depth of N-ary Tree",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta"],
        keyIdeaEn: "N-ary tree BFS queue pushing all children vector elements.",
        keyIdeaBn: "N-ary ট্রি এর চিলড্রেন ক্যু তে পুশ করে লেভেল গুনুন।",
      ),
      TreeBfsProblem(
        title: "Univalued Binary Tree",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta"],
        keyIdeaEn: "BFS traversal verifying all node values equal root value.",
        keyIdeaBn: "BFS দিয়ে সব নোডের মান রুটের সমান কিনা চেক করুন।",
      ),
      TreeBfsProblem(
        title: "Evaluate Boolean Binary Tree",
        difficulty: "Easy",
        companyTags: ["Google", "Amazon"],
        keyIdeaEn: "Post-order or BFS evaluation of boolean leaf operators.",
        keyIdeaBn: "বুলিয়ান অপারেটর মেলানোর ট্রাভার্সাল।",
      ),
    ];
  }

  static List<TreeBfsProblem> getMediumProblems() {
    return const [
      TreeBfsProblem(
        title: "Binary Tree Level Order Traversal",
        difficulty: "Medium",
        companyTags: ["Amazon", "Meta", "Google", "Microsoft", "Bloomberg"],
        keyIdeaEn: "FIFO Queue BFS. Snapshot levelSize = q.size(), process nodes per level into 2D vector.",
        keyIdeaBn: "FIFO ক্যু BFS। `levelSize = q.size()` এর স্ন্যাপশট নিয়ে লেভেল অনুযায়ী ২D ভেক্টরে জমান।",
        isPopular: true,
      ),
      TreeBfsProblem(
        title: "Binary Tree Zigzag Level Order Traversal",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft"],
        keyIdeaEn: "BFS level order with boolean flag leftToRight. Flip vector orientation per level.",
        keyIdeaBn: "BFS লেভেল অর্ডার + বুলিয়ান ফ্ল্যাগ দিয়ে প্রতি লেভেলে ডিরেকশন রিভার্স করুন।",
        isPopular: true,
      ),
      TreeBfsProblem(
        title: "Binary Tree Right Side View",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft", "Bloomberg"],
        keyIdeaEn: "BFS level order. Add node value at index i == levelSize - 1 to result.",
        keyIdeaBn: "BFS লেভেল অর্ডারে প্রতি লেভেলের শেষ নোডের মান (i == levelSize - 1) রেজাল্টে যোগ করুন।",
        isPopular: true,
      ),
      TreeBfsProblem(
        title: "Populating Next Right Pointers in Each Node",
        difficulty: "Medium",
        companyTags: ["Amazon", "Meta", "Google"],
        keyIdeaEn: "BFS level order. Connect node->next = (i < levelSize - 1) ? q.front() : nullptr.",
        keyIdeaBn: "BFS লেভেল অর্ডারে একই লেভেলের পাশে থাকা নোডে next পয়েন্টার সেট করুন।",
        isPopular: true,
      ),
      TreeBfsProblem(
        title: "Find Largest Value in Each Tree Row",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon"],
        keyIdeaEn: "BFS level order tracking max element per level loop.",
        keyIdeaBn: "BFS লেভেল অর্ডারে প্রতি লেভেলের সর্বোচ্চ মান মেইনটেইন করুন।",
      ),
      TreeBfsProblem(
        title: "Find Bottom Left Tree Value",
        difficulty: "Medium",
        companyTags: ["Amazon", "Google"],
        keyIdeaEn: "BFS right-to-left push. Last popped node value gives bottom-leftmost node.",
        keyIdeaBn: "ডান থেকে বামে BFS ক্যু তে পুশ করলে শেষ পপ করা নোডটিই বটম-লেফট ভ্যালু।",
      ),
      TreeBfsProblem(
        title: "All Nodes Distance K in Binary Tree",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google"],
        keyIdeaEn: "Build parent graph pointers, then run BFS starting from target node up to depth K.",
        keyIdeaBn: "প্যারেন্ট গ্রাফ তৈরি করে টার্গেট নোড থেকে K লেভেল পর্যন্ত BFS চালান।",
      ),
      TreeBfsProblem(
        title: "N-ary Tree Level Order Traversal",
        difficulty: "Medium",
        companyTags: ["Amazon", "Meta"],
        keyIdeaEn: "Queue BFS iterating over children vector for N-ary tree nodes.",
        keyIdeaBn: "N-ary ট্রি এর চিলড্রেন ভেক্টর লুপ করে ক্যু তে পুশ করুন।",
      ),
    ];
  }

  static List<TreeBfsProblem> getHardProblems() {
    return const [
      TreeBfsProblem(
        title: "Serialize and Deserialize Binary Tree",
        difficulty: "Hard",
        companyTags: ["Amazon", "Meta", "Google", "Microsoft"],
        keyIdeaEn: "Level-order string serialization with BFS queue including 'null' markers.",
        keyIdeaBn: "নাল মার্কারসহ BFS ক্যু দিয়ে লেভেল-অর্ডার স্ট্রিং তৈরি ও রিকনস্ট্রাক্ট করুন।",
        isPopular: true,
      ),
      TreeBfsProblem(
        title: "Word Ladder",
        difficulty: "Hard",
        companyTags: ["Amazon", "Meta", "Google"],
        keyIdeaEn: "Graph BFS shortest path on string transformations changing one character at a time.",
        keyIdeaBn: "১টি ক্যারেক্টার বদলে শর্টেস্ট পাথ বের করতে গ্রাফ BFS ব্যবহার করুন।",
        isPopular: true,
      ),
      TreeBfsProblem(
        title: "Vertical Order Traversal of a Binary Tree",
        difficulty: "Hard",
        companyTags: ["Meta", "Amazon", "Google"],
        keyIdeaEn: "BFS with coordinate tuples (row, col, node), sort by col then row then value.",
        keyIdeaBn: "স্থানাঙ্ক (row, col) সহ BFS চালিয়ে ডানে-বামে ভার্টিকাল সর্টিং করুন।",
      ),
    ];
  }

  static List<Map<String, String>> getCommonMistakes(bool isEnglish) {
    if (isEnglish) {
      return [
        {
          "title": "1. Not Capturing Level Size Snapshot (`levelSize = q.size()`) First",
          "desc": "Calling `q.size()` directly inside `for (int i = 0; i < q.size(); i++)` causes bug because newly pushed children dynamically expand `q.size()`!"
        },
        {
          "title": "2. Pushing Null Nodes to Queue",
          "desc": "Pushing `node->left` when it is `nullptr` without checking `if (node->left)` triggers NullPointerDereference crashes during `q.front()->val`."
        },
        {
          "title": "3. Choosing DFS when BFS is Mandatory for Minimum Depth",
          "desc": "DFS explores deep subtrees first, wasting time when the closest leaf node is at level 2. BFS guarantees finding the minimum depth immediately!"
        },
        {
          "title": "4. Using LIFO Stack instead of FIFO Queue",
          "desc": "Using a Stack converts the traversal into Depth-First Search (DFS) order instead of Level-Order (BFS)."
        },
        {
          "title": "5. Forgetting to Track Visited Nodes in Graph-like BFS",
          "desc": "When solving parent-connected trees or Graph BFS (e.g. Distance K), failing to track `visited` set causes infinite processing loops."
        },
      ];
    } else {
      return [
        {
          "title": "১. লুপের শুরুতে `levelSize = q.size()` এর ব্যাকআপ না নেওয়া",
          "desc": "`for (int i = 0; i < q.size(); i++)` সরাসরি লিখলে নতুন যোগ হওয়া চিলড্রেনদের কারণে `q.size()` বাড়তে থাকবে এবং লেভেলের হিসেব তালগোল পাকিয়ে যাবে!"
        },
        {
          "title": "২. নাল (`nullptr`) নোড ক্যু তে পুশ করে দেওয়া",
          "desc": "`if (node->left)` চেক না করে নাল পুশ করলে পরবর্তীতে `q.front()->val` রিড করার সময় অ্যাপ ক্র্যাশ করবে।"
        },
        {
          "title": "৩. Minimum Depth এর প্রবলেমে BFS এর জায়গায় DFS ব্যবহার করা",
          "desc": "DFS গভীরে চলে যায়। কিন্তু BFS ব্যবহার করলে প্রথম লিফ নোড পাওয়া মাত্রই সবচেয়ে কম গভীরতা নিয়ে বের হয়ে আসা যায়।"
        },
        {
          "title": "৪. FIFO Queue এর জায়গায় LIFO Stack ব্যবহার করা",
          "desc": "স্ট্যাক ব্যবহার করলে লেভেল-অর্ডারের বদলে ট্রাভার্সাল DFS এ পরিণত হবে।"
        },
        {
          "title": "৫. প্যারেন্ট কানেক্টেড ট্রি বা গ্রাফ BFS এ Visited হ্যাশ সেট ব্যবহার না করা",
          "desc": "Distance K বা গ্রাফ সমস্যায় visited সেট না রাখলে অসীম লুপ তৈরি হবে।"
        },
      ];
    }
  }
}
