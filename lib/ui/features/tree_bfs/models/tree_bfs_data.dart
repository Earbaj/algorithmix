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
        keyIdeaEn: "BFS graph level order traversal on word transformation graph.",
        keyIdeaBn: "শব্দ রূপান্তরের গ্রাফে BFS লেভেল অর্ডার চালিয়ে সমাধান।",
        isPopular: true,
      ),
      TreeBfsProblem(
        title: "Minimum Cost to Reach Destination in Time",
        difficulty: "Hard",
        companyTags: ["Google", "Amazon"],
        keyIdeaEn: "Priority queue / BFS with time constraint optimization.",
        keyIdeaBn: "সময় সীমার শর্তে প্রায়োরিটি ক্যু BFS দিয়ে সমাধান।",
      ),
    ];
  }

  static List<Map<String, String>> getCommonMistakes(bool isEnglish) {
    if (isEnglish) {
      return [
        {
          "title": "1. Forgetting to Snapshot Queue Size (`levelSize = q.size()`)",
          "desc": "Calling `q.size()` directly inside the `for` loop condition evaluates dynamically as new children are pushed, mixing different levels together!"
        },
        {
          "title": "2. Pushing `nullptr` Nodes into Queue Without Null Checks",
          "desc": "Pushing `curr->left` or `curr->right` without checking `if (curr->left)` causes null pointer dereference crashes when popping."
        },
        {
          "title": "3. Confusing Tree BFS with Tree DFS Space Complexity",
          "desc": "Tree BFS uses O(W) auxiliary space where W is the maximum width of the tree (up to N/2 leaf nodes in a perfect binary tree), NOT tree height H!"
        },
        {
          "title": "4. Incorrect Flag Toggling in Zigzag Level Order",
          "desc": "Flipping `leftToRight` inside the inner node loop instead of after processing the full level size ruins zigzag order."
        },
        {
          "title": "5. Missing Empty Tree Safeguard (`if (!root) return;`)",
          "desc": "Pushing `nullptr` root into the queue before loop execution leads to unexpected empty level outputs or crashes."
        },
      ];
    } else {
      return [
        {
          "title": "১. লুপের শুরুতে ক্যু এর সাইজ (`levelSize = q.size()`) স্ন্যাপশট না নেওয়া",
          "desc": "`for` লুপের ভেতরের কন্ডিশনে সরাসরি `q.size()` ব্যবহার করলে নতুন চাইল্ড যোগ হওয়ার সাথে সাথে সাইজ বদলে গিয়ে লেভেল মিক্স হয়ে যায়!"
        },
        {
          "title": "২. নাল চেক না করে ক্যু তে `nullptr` পুশ করা",
          "desc": "`if (curr->left)` চেক না করে নোড পুশ করলে নাল পয়েন্টার ডিরিফারেন্স এক্সসেপশন ঘটে।"
        },
        {
          "title": "৩. Tree BFS ও DFS এর মেমোরি জটিলতা গুলিয়ে ফেলা",
          "desc": "Tree BFS এর মেমোরি খরচ O(W) (ট্রি এর সর্বোচ্চ প্রস্থ বা লেভেলের নোড সংখ্যা N/2), উচ্চতা H নয়!"
        },
        {
          "title": "৪. Zigzag এ ভুল স্থানে ফ্ল্যাগ টগল করা",
          "desc": "`leftToRight` ফ্ল্যাগ লেভেলের ভেতর না বদলে সম্পূর্ণ লেভেল প্রসেস করার পর টগল করতে হবে।"
        },
        {
          "title": "৫. খালি ট্রি (`if (!root) return;`) চেক না করা",
          "desc": "রুট নাল হলে ক্যু তে নাল পুশ হয়ে ক্র্যাশ বা খালি ভুল আউটপুট আসবে।"
        },
      ];
    }
  }
}
