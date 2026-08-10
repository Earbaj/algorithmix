class TreeDfsProblem {
  final String title;
  final String difficulty; // Easy, Medium, Hard
  final List<String> companyTags;
  final String keyIdeaEn;
  final String keyIdeaBn;
  final bool isPopular;

  const TreeDfsProblem({
    required this.title,
    required this.difficulty,
    required this.companyTags,
    required this.keyIdeaEn,
    required this.keyIdeaBn,
    this.isPopular = false,
  });
}

class TreeDfsData {
  static Map<String, String> getConceptIntro(bool isEnglish) {
    if (isEnglish) {
      return {
        "title": "Tree DFS (Preorder/Inorder/Postorder) — Complete Deep Dive (C++ & FAANG Focus)",
        "summary": "Tree DFS (Depth-First Search) explores as deep as possible along each branch before backtracking. It relies on the Call Stack (recursion) or an explicit std::stack. The 3 classical orders determine when the current node is processed relative to its left and right subtrees.",
        "whenToUseTitle": "When to Use Tree DFS?",
        "whenToUse1": "Searching for root-to-leaf paths that equal a target sum (LeetCode 112, 113).",
        "whenToUse2": "In-order traversal of Binary Search Trees (BST) to obtain values in strictly sorted order.",
        "whenToUse3": "Bottom-up subtree calculations (e.g. Tree Height, Diameter, Lowest Common Ancestor LCA).",
        "whenToUse4": "Tree serialization or cloning (Preorder traversal).",
        "whenToUse5": "Deleting tree nodes or evaluating mathematical expression trees (Postorder traversal).",
        "typesTitle": "3 Main Tree DFS Traversal Patterns",
        "type1Title": "1. Preorder Traversal (Root -> Left -> Right)",
        "type1Desc": "Process current root node first, then recursively visit left subtree, then right subtree. Ideal for tree structure serialization and deep copying.",
        "type2Title": "2. Inorder Traversal (Left -> Root -> Right)",
        "type2Desc": "Recursively visit left subtree, process current root node, then visit right subtree. For Binary Search Trees (BST), this outputs node values in ascending sorted order!",
        "type3Title": "3. Postorder Traversal (Left -> Right -> Root)",
        "type3Desc": "Recursively visit left subtree, visit right subtree, then process current root node last. Essential for bottom-up property calculation (Height, Max Path Sum, LCA).",
      };
    } else {
      return {
        "title": "Tree DFS (Preorder/Inorder/Postorder) — সম্পূর্ণ গাইড (C++ ও FAANG ফোকাস)",
        "summary": "Tree DFS (Depth-First Search) হলো ট্রি এর প্রতিটি ব্রাঞ্চের গভীরে আগে প্রবেশ করা এবং তারপর ব্যাকট্র্যাক করা। এটি কল স্ট্যাক (রিকার্শন) বা ম্যানুয়াল স্ট্যাক দিয়ে কাজ করে। ৩টি প্রধান ট্রাভার্সাল ক্রম রুট নোড কখন প্রসেস হবে তা নির্ধারণ করে।",
        "whenToUseTitle": "কখন বুঝবা Tree DFS লাগবে?",
        "whenToUse1": "রুট থেকে লিফ পর্যন্ত নির্দিষ্ট যোগফলের পথ (Path Sum) খুঁজে বের করতে।",
        "whenToUse2": "বাইনারি সার্চ ট্রি (BST) এর নোডগুলোকে সর্টেড ক্রমে পেতে (Inorder)।",
        "whenToUse3": "নিচ থেকে উপরে (Bottom-up) সাব-ট্রি গণনা করতে (যেমন: ট্রি হাইট, ডায়ামিটার, LCA)।",
        "whenToUse4": "ট্রি স্ট্রাকচার কপি বা সিরিয়ালাইজ করতে (Preorder)।",
        "whenToUse5": "নোড ডিলিট করা বা গাণিতিক এক্সপ্রেশন ট্রি মান বের করতে (Postorder)।",
        "typesTitle": "Main Types (৩ ধরনের pattern)",
        "type1Title": "১. Preorder Traversal (Root -> Left -> Right)",
        "type1Desc": "প্রথমে রুট নোড প্রসেস করো, তারপর বাম সাব-ট্রি এবং সবশেষে ডান সাব-ট্রিতে যাও। ট্রি কপি করার জন্য সেরা।",
        "type2Title": "২. Inorder Traversal (Left -> Root -> Right)",
        "type2Desc": "প্রথমে বাম সাব-ট্রি, তারপর রুট নোড এবং সবশেষে ডান সাব-ট্রি। BST এর ক্ষেত্রে এটি সর্টেড অর্ডার দেয়!",
        "type3Title": "৩. Postorder Traversal (Left -> Right -> Root)",
        "type3Desc": "প্রথমে বাম ও ডান সাব-ট্রি প্রসেস করো, সবশেষে রুট নোড প্রসেস করো। Bottom-up গণনার জন্য আবশ্যক।",
      };
    }
  }

  static List<TreeDfsProblem> getEasyProblems() {
    return const [
      TreeDfsProblem(
        title: "Binary Tree Inorder Traversal",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta", "Google", "Microsoft"],
        keyIdeaEn: "Standard recursive or iterative stack Inorder (Left -> Root -> Right).",
        keyIdeaBn: "ইন-অর্ডার (Left -> Root -> Right) ট্রাভার্সাল।",
        isPopular: true,
      ),
      TreeDfsProblem(
        title: "Maximum Depth of Binary Tree",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta", "Google", "Microsoft"],
        keyIdeaEn: "Postorder bottom-up recursion: return 1 + max(maxDepth(left), maxDepth(right)).",
        keyIdeaBn: "পোস্ট-অর্ডার রিকার্শন: `1 + max(leftHeight, rightHeight)` রিটার্ন করুন।",
        isPopular: true,
      ),
      TreeDfsProblem(
        title: "Invert Binary Tree",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta", "Google", "Microsoft", "Apple"],
        keyIdeaEn: "Preorder or Postorder DFS swapping left and right child pointers.",
        keyIdeaBn: "DFS দিয়ে বাম ও ডান চাইল্ড পয়েন্টার সোয়াপ করুন।",
        isPopular: true,
      ),
      TreeDfsProblem(
        title: "Path Sum",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta", "Google", "Microsoft"],
        keyIdeaEn: "Preorder DFS tracking targetSum - node->val down to leaf nodes.",
        keyIdeaBn: "Preorder DFS দিয়ে লিফ নোড পর্যন্ত targetSum বিয়োগ করে মেলান।",
      ),
      TreeDfsProblem(
        title: "Diameter of Binary Tree",
        difficulty: "Easy",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft"],
        keyIdeaEn: "Postorder DFS: diameter = max(leftHeight + rightHeight), return 1 + max(leftHeight, rightHeight).",
        keyIdeaBn: "Postorder DFS: ডায়ামিটার = max(leftHeight + rightHeight)।",
      ),
      TreeDfsProblem(
        title: "Balanced Binary Tree",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta", "Google"],
        keyIdeaEn: "Postorder DFS returning -1 if abs(leftHeight - rightHeight) > 1.",
        keyIdeaBn: "Postorder DFS দিয়ে হাইট ডিফারেন্স ১ এর বেশি হলে -১ রিটার্ন করুন।",
      ),
      TreeDfsProblem(
        title: "Binary Tree Preorder Traversal",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta", "Google"],
        keyIdeaEn: "Standard Preorder (Root -> Left -> Right).",
        keyIdeaBn: "প্রি-অর্ডার (Root -> Left -> Right) ট্রাভার্সাল।",
      ),
      TreeDfsProblem(
        title: "Binary Tree Postorder Traversal",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta", "Google"],
        keyIdeaEn: "Standard Postorder (Left -> Right -> Root).",
        keyIdeaBn: "পোস্ট-অর্ডার (Left -> Right -> Root) ট্রাভার্সাল।",
      ),
    ];
  }

  static List<TreeDfsProblem> getMediumProblems() {
    return const [
      TreeDfsProblem(
        title: "Path Sum II",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft"],
        keyIdeaEn: "Preorder DFS with path vector tracking and backtracking (path.pop_back()).",
        keyIdeaBn: "Preorder DFS + পাথ ভেক্টর ট্র্যাকিং এবং ব্যাকট্র্যাকিং (`path.pop_back()`)।",
        isPopular: true,
      ),
      TreeDfsProblem(
        title: "Lowest Common Ancestor of a Binary Tree",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft", "Apple", "Bloomberg"],
        keyIdeaEn: "Postorder DFS: if root equals p or q, return root. If both left and right return non-null, root is LCA!",
        keyIdeaBn: "Postorder DFS: যদি left ও right দুটিই নাল না হয় তবে চলতি রুটই LCA!",
        isPopular: true,
      ),
      TreeDfsProblem(
        title: "Validate Binary Search Tree",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft", "Bloomberg"],
        keyIdeaEn: "Inorder DFS verifying strictly increasing order, or Preorder checking min/max bounds.",
        keyIdeaBn: "Inorder DFS দিয়ে সর্টেড অর্ডার মেলান অথবা মিন/ম্যাক্স বাউন্ড চেক করুন।",
        isPopular: true,
      ),
      TreeDfsProblem(
        title: "Kth Smallest Element in a BST",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft"],
        keyIdeaEn: "Inorder DFS: decrement K on visiting node. When K == 0, node is answer!",
        keyIdeaBn: "Inorder DFS: K এর মান ১ কমিয়ে K == 0 হলে উত্তর রিটার্ন করুন।",
        isPopular: true,
      ),
      TreeDfsProblem(
        title: "Construct Binary Tree from Preorder and Inorder",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft"],
        keyIdeaEn: "Preorder gives root, search root in Inorder to split left and right subtrees recursively.",
        keyIdeaBn: "Preorder থেকে রুট এবং Inorder থেকে বাম-ডান সাব-ট্রি ভাগ করে গাছ তৈরি করুন।",
      ),
      TreeDfsProblem(
        title: "Flatten Binary Tree to Linked List",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google"],
        keyIdeaEn: "Reverse Postorder DFS (Right -> Left -> Root) maintaining prev pointer.",
        keyIdeaBn: "রিভার্স পোস্ট-অর্ডার (Right -> Left -> Root) দিয়ে লিঙ্কড লিস্টে ফ্ল্যাট করুন।",
      ),
      TreeDfsProblem(
        title: "Count Good Nodes in Binary Tree",
        difficulty: "Medium",
        companyTags: ["Amazon", "Meta", "Google"],
        keyIdeaEn: "Preorder DFS tracking maxVal along path from root.",
        keyIdeaBn: "Preorder DFS দিয়ে রুট থেকে পথের সর্বোচ্চ মান ট্র্যাক করে কাউন্ট বাড়ান।",
      ),
      TreeDfsProblem(
        title: "Path Sum III",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google"],
        keyIdeaEn: "Prefix sum hash map + Preorder DFS to count sub-paths matching target sum.",
        keyIdeaBn: "প্রেফিক্স সাম হ্যাশ ম্যাপ + Preorder DFS দিয়ে সাব-পাথ কাউন্ট করুন।",
      ),
    ];
  }

  static List<TreeDfsProblem> getHardProblems() {
    return const [
      TreeDfsProblem(
        title: "Binary Tree Maximum Path Sum",
        difficulty: "Hard",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft", "Apple"],
        keyIdeaEn: "Postorder DFS: gain = max(0, dfs(child)). maxPath = max(maxPath, val + leftGain + rightGain).",
        keyIdeaBn: "Postorder DFS: গেইন হিসাব করে গ্লোবাল সর্বোচ্চ পাথ সাম আপডেট করুন।",
        isPopular: true,
      ),
      TreeDfsProblem(
        title: "Serialize and Deserialize Binary Tree",
        difficulty: "Hard",
        companyTags: ["Amazon", "Meta", "Google", "Microsoft"],
        keyIdeaEn: "Preorder DFS string encoding with '#' for null nodes.",
        keyIdeaBn: "Preorder DFS স্ট্রিং এনকোডিং ও রিকনস্ট্রাকশন।",
        isPopular: true,
      ),
      TreeDfsProblem(
        title: "Binary Tree Cameras",
        difficulty: "Hard",
        companyTags: ["Meta", "Amazon", "Google"],
        keyIdeaEn: "Postorder Greedy DFS returning state (0: uncovered, 1: covered with camera, 2: covered without camera).",
        keyIdeaBn: "Postorder গ্রিডি DFS দিয়ে নোড স্টেট রিপ্রেজেন্ট করে ক্যাামেরা বসান।",
      ),
    ];
  }

  static List<Map<String, String>> getCommonMistakes(bool isEnglish) {
    if (isEnglish) {
      return [
        {
          "title": "1. Missing Base Case (`if (root == nullptr) return;`)",
          "desc": "Failing to check for null pointers causes immediate call stack overflow or NullPointerDereference crashes."
        },
        {
          "title": "2. Re-calculating Subtree Properties ($O(N^2)$ Time)",
          "desc": "Computing height inside recursive calls at every node without passing results bottom-up converts $O(N)$ solution to $O(N^2)$."
        },
        {
          "title": "3. Modifying Passed Path Vector Without Backtracking",
          "desc": "Passing path vectors by reference without popping the back element (`path.pop_back()`) after returning pollutes path state across branches."
        },
        {
          "title": "4. Using Inorder Traversal for Structural Tree Serialization",
          "desc": "Inorder traversal alone cannot uniquely identify tree structure without another traversal (Preorder/Postorder) or null markers."
        },
        {
          "title": "5. Stack Overflow on Skewed Trees",
          "desc": "Skewed linked-list-like trees trigger call stack overflow ($O(N)$ call stack depth) if stack depth limits are exceeded."
        },
      ];
    } else {
      return [
        {
          "title": "১. বেস কেস (`if (root == nullptr) return;`) বাদ দেওয়া",
          "desc": "নাল চেক না করলে স্ট্যাক ওভারফ্লো বা নাল পয়েন্টার ডিরিফারেন্স ক্র্যাশ ঘটবে।"
        },
        {
          "title": "২. নিচ থেকে হিসাব না করে বারবার সাব-ট্রি হাইট বের করা ($O(N^2)$)",
          "desc": "প্রতি নোডে গিয়ে আবার নিচ পর্যন্ত লুপ চালালে অ্যালগরিদমের টাইম কমপ্লেক্সিটি $O(N)$ থেকে $O(N^2)$ হয়ে যাবে।"
        },
        {
          "title": "৩. ব্যাকট্র্যাকিং না করে পাথ ভেক্টর পাস করা",
          "desc": "কল শেষে `path.pop_back()` না করলে এক ব্রাঞ্চের ডাটা অন্য ব্রাঞ্চের পাথে ঢুকে রেজাল্ট ভুল করে দেবে।"
        },
        {
          "title": "৪. শুধু Inorder দিয়ে ট্রি পুনর্গঠন করার চেষ্টা",
          "desc": "একমাত্র Inorder দিয়ে ট্রি এর শেপ বোঝা সম্ভব নয়, সাথে Preorder/Postorder বা নাল মার্কার লাগবে।"
        },
        {
          "title": "৫. Skewed ট্রি তে স্ট্যাক ওভারফ্লো এড়িয়ে যাওয়া",
          "desc": "একপাশে বাঁকা লিঙ্কড লিস্ট মার্কা ট্রি হলে রিকার্শন স্ট্যাক মেমোরি শেষ করে অ্যাপ ক্র্যাশ করতে পারে।"
        },
      ];
    }
  }
}
