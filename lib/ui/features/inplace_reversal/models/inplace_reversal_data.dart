class InplaceReversalProblem {
  final String title;
  final String difficulty; // Easy, Medium, Hard
  final List<String> companyTags;
  final String keyIdeaEn;
  final String keyIdeaBn;
  final bool isPopular;

  const InplaceReversalProblem({
    required this.title,
    required this.difficulty,
    required this.companyTags,
    required this.keyIdeaEn,
    required this.keyIdeaBn,
    this.isPopular = false,
  });
}

class InplaceReversalData {
  static Map<String, String> getConceptIntro(bool isEnglish) {
    if (isEnglish) {
      return {
        "title": "In-place Reversal of Linked List — Complete Deep Dive (C++ & FAANG Focus)",
        "summary": "In-place Reversal of a Linked List reverses directional links (next pointers) between nodes in O(N) time and O(1) auxiliary space without creating new node objects or allocating extra array memory. It relies on 3 pointers: prev, curr, and nextTemp.",
        "whenToUseTitle": "When to Use In-place Reversal?",
        "whenToUse1": "Reversing an entire Singly or Doubly Linked List in O(1) auxiliary space.",
        "whenToUse2": "Reversing a sub-list range from position left to right (LeetCode 92).",
        "whenToUse3": "Reversing nodes in groups of K (LeetCode 25 - Reverse Nodes in k-Group).",
        "whenToUse4": "Checking Palindrome Linked Lists (reversing the second half in-place).",
        "whenToUse5": "Reordering lists or alternating node connections (LeetCode 143).",
        "typesTitle": "3 Main Linked List Reversal Patterns",
        "type1Title": "1. Entire List Reversal",
        "type1Desc": "Set prev = nullptr, curr = head. While curr != null, backup nextTemp = curr->next, flip curr->next = prev, advance prev = curr and curr = nextTemp. Return prev.",
        "type2Title": "2. Sub-list Reversal (Positions Left to Right)",
        "type2Desc": "Move to node before left. Use a sub-loop to reverse right - left links, then reconnect sub-list head and tail pointers seamlessly using a dummy node.",
        "type3Title": "3. K-Group Reversal (K-Group Nodes)",
        "type3Desc": "Count K nodes ahead. Reverse K nodes in-place. Recursively or iteratively connect the tail of reversed group to the head of next reversed group.",
      };
    } else {
      return {
        "title": "In-place Reversal of Linked List — সম্পূর্ণ গাইড (C++ ও FAANG ফোকাস)",
        "summary": "In-place Reversal হলো কোনো বাড়তি মেমোরি (O(1) স্পেস) ব্যবহার না করে লিঙ্কড লিস্টের নোডগুলোর পয়েন্টার লিঙ্ক উল্টিয়ে দেওয়া। এটি ৩টি পয়েন্টার: prev, curr, এবং nextTemp ব্যবহার করে সম্পাদন করা হয়।",
        "whenToUseTitle": "কখন বুঝবা In-place Reversal লাগবে?",
        "whenToUse1": "O(1) স্পেসে সম্পূর্ণ লিঙ্কড লিস্ট উল্টাতে বলা হলে।",
        "whenToUse2": "একটি নির্দিষ্ট সীমানা (position left থেকে right) এর ভেতরের নোড উল্টাতে হলে (LeetCode 92)।",
        "whenToUse3": "K টি করে নোডের গ্রুপ বানিয়ে উল্টাতে বলা হলে (LeetCode 25)।",
        "whenToUse4": "প্যালিন্ড্রোম লিঙ্কড লিস্ট চেকিং (২য় অর্ধেক ইন-প্লেস উল্টানো)।",
        "whenToUse5": "লিঙ্কড লিস্ট পুনর্বিন্যাস (Reorder List) বা অল্টারনেট যোগ করতে।",
        "typesTitle": "Main Types (৩ ধরনের pattern)",
        "type1Title": "১. Entire List Reversal (সম্পূর্ণ লিস্ট উল্টানো)",
        "type1Desc": "prev = null, curr = head ধরো। লুপের ভেতর `nextTemp = curr->next` ব্যাকআপ নাও, `curr->next = prev` লিঙ্ক উল্টাও, তারপর `prev` ও `curr` আগাও।",
        "type2Title": "২. Sub-list Reversal (নির্দিষ্ট সীমানার ভেতর উল্টানো)",
        "type2Desc": "left এর আগের নোডে যাও। লুপ চালিয়ে right - left সংখ্যক লিঙ্ক উল্টাও, তারপর ডামি নোডের সাহায্যে আগের ও পরের লিঙ্ক জুড়ে দাও।",
        "type3Title": "৩. K-Group Reversal (K টি করে নোডের গ্রুপ)",
        "type3Desc": "K টি নোড গুনে নাও। K টি নোডের লিঙ্ক ইন-প্লেস উল্টাও। উল্টানো গ্রুপের টেলকে পরবর্তী গ্রুপের হেডের সাথে কানেক্ট করো।",
      };
    }
  }

  static List<InplaceReversalProblem> getEasyProblems() {
    return const [
      InplaceReversalProblem(
        title: "Reverse Linked List",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta", "Google", "Microsoft", "Apple"],
        keyIdeaEn: "Iterative 3-pointer link flipping (prev, curr, nextTemp). Returns new head prev.",
        keyIdeaBn: "৩-পয়েন্টার দিয়ে পয়েন্টার লিঙ্ক রিভার্স করুন। নতুন হেড prev রিটার্ন করুন।",
        isPopular: true,
      ),
      InplaceReversalProblem(
        title: "Palindrome Linked List",
        difficulty: "Easy",
        companyTags: ["Meta", "Amazon", "Microsoft"],
        keyIdeaEn: "Find middle node with fast-slow, reverse second half in-place, compare values.",
        keyIdeaBn: "fast-slow দিয়ে মিডল খুঁজে ২য় অর্ধেক ইন-প্লেস রিভার্স করে ১ম অর্ধেকের সাথে মেলান।",
        isPopular: true,
      ),
      InplaceReversalProblem(
        title: "Delete Node in a Linked List",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta", "Apple"],
        keyIdeaEn: "Copy next node value into current node and update next pointer.",
        keyIdeaBn: "পরবর্তী নোডের মান চলতি নোডে কপি করে লিঙ্ক স্কিপ করুন।",
      ),
      InplaceReversalProblem(
        title: "Remove Linked List Elements",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta"],
        keyIdeaEn: "Dummy head node with single pointer skipping target val nodes.",
        keyIdeaBn: "ডামি হেড দিয়ে টার্গেট মান সম্বলিত নোড স্কিপ করুন।",
      ),
      InplaceReversalProblem(
        title: "Remove Duplicates from Sorted List",
        difficulty: "Easy",
        companyTags: ["Meta", "Amazon"],
        keyIdeaEn: "Skip duplicate adjacent nodes in sorted list.",
        keyIdeaBn: "সর্টেড তালিকায় পাশাপাশি ডুপ্লিকেট নোড স্কিপ করুন।",
      ),
      InplaceReversalProblem(
        title: "Swapping Nodes in a Linked List",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta"],
        keyIdeaEn: "Find K-th node from start and K-th node from end, swap their values.",
        keyIdeaBn: "শুরু ও শেষের K-তম নোড খুঁজে মান অদলবদল করুন।",
      ),
      InplaceReversalProblem(
        title: "Merge Two Sorted Lists",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta", "Microsoft"],
        keyIdeaEn: "Dummy head + two pointer merge.",
        keyIdeaBn: "ডামি হেড দিয়ে ২ সর্টেড লিঙ্কড লিস্ট মার্জ করুন।",
      ),
      InplaceReversalProblem(
        title: "Convert Binary Number in a Linked List to Integer",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta"],
        keyIdeaEn: "Bitwise left shift or sum traversal across binary nodes.",
        keyIdeaBn: "বাইনারি নোড দিয়ে ডেসিমাল সংখ্যা তৈরি করুন।",
      ),
    ];
  }

  static List<InplaceReversalProblem> getMediumProblems() {
    return const [
      InplaceReversalProblem(
        title: "Reverse Linked List II (Sub-list m to n)",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft"],
        keyIdeaEn: "Dummy head + sub-list reversal loop from position left to right. Reconnect boundaries.",
        keyIdeaBn: "ডামি হেড + নির্দিষ্ট সীমানা left থেকে right এর ভেতরের লিঙ্ক উল্টে যুক্ত করুন।",
        isPopular: true,
      ),
      InplaceReversalProblem(
        title: "Reorder List",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google"],
        keyIdeaEn: "1. Find middle with fast-slow. 2. Reverse second half. 3. Merge two halves alternating nodes.",
        keyIdeaBn: "১. মিডল খুঁজুন। ২. ২য় অর্ধেক রিভার্স করুন। ৩. একান্তরভাবে জোড়া লাগান।",
        isPopular: true,
      ),
      InplaceReversalProblem(
        title: "Maximum Twin Sum of a Linked List",
        difficulty: "Medium",
        companyTags: ["Amazon", "Meta"],
        keyIdeaEn: "Find middle, reverse second half, compute maximum twin pair sum.",
        keyIdeaBn: "মিডল খুঁজে ২য় অর্ধেক রিভার্স করে টুইন যোগফল বের করুন।",
      ),
      InplaceReversalProblem(
        title: "Swap Nodes in Pairs",
        difficulty: "Medium",
        companyTags: ["Amazon", "Meta", "Google"],
        keyIdeaEn: "Dummy node + 2-pointer pair swapping logic.",
        keyIdeaBn: "ডামি নোড দিয়ে পর পর ২টি করে নোড সোয়াপ করুন।",
        isPopular: true,
      ),
      InplaceReversalProblem(
        title: "Rotate List",
        difficulty: "Medium",
        companyTags: ["Amazon", "Meta", "Google"],
        keyIdeaEn: "Connect tail to head into circular list, then break at length - (k % length).",
        keyIdeaBn: "লিস্ট রিংয়ে বদলে সঠিক ইনডেক্সে কানেকশন ভেঙে রোটেশন সম্পাদন করুন।",
      ),
      InplaceReversalProblem(
        title: "Add Two Numbers II",
        difficulty: "Medium",
        companyTags: ["Amazon", "Meta", "Microsoft"],
        keyIdeaEn: "Reverse both input lists or use stack, add digit by digit, reverse result list.",
        keyIdeaBn: "দুই লিঙ্কড লিস্ট রিভার্স করে যোগফল তৈরি করে আবার রিভার্স করুন।",
      ),
      InplaceReversalProblem(
        title: "Remove Nth Node From End of List",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google"],
        keyIdeaEn: "Fast-slow pointer gap of N. Remove target node.",
        keyIdeaBn: "N ব্যবধানে পয়েন্টার রেখে শেষের N-তম নোড মুছে ফেলুন।",
      ),
      InplaceReversalProblem(
        title: "Split Linked List in Parts",
        difficulty: "Medium",
        companyTags: ["Amazon", "Meta"],
        keyIdeaEn: "Calculate length and partition sizes, cut list into K sub-lists.",
        keyIdeaBn: "দৈর্ঘ্য মেপে K ভাগে ভাগ করে কাটুন।",
      ),
    ];
  }

  static List<InplaceReversalProblem> getHardProblems() {
    return const [
      InplaceReversalProblem(
        title: "Reverse Nodes in k-Group",
        difficulty: "Hard",
        companyTags: ["Amazon", "Meta", "Google", "Microsoft", "Bloomberg"],
        keyIdeaEn: "Check if K nodes exist. Reverse K nodes in-place, recursively call for remaining list, attach head.",
        keyIdeaBn: "K টি করে নোড থাকলে রিভার্স করে পরের গ্রুপের সাথে রিকার্সিভলি যুক্ত করুন।",
        isPopular: true,
      ),
      InplaceReversalProblem(
        title: "Merge k Sorted Lists",
        difficulty: "Hard",
        companyTags: ["Amazon", "Meta", "Google", "Microsoft"],
        keyIdeaEn: "Divide & Conquer using middle pointer or Priority Queue min-heap.",
        keyIdeaBn: "ডিভাইড অ্যান্ড কনকার বা মিন-হিপ দিয়ে K টি সর্টেড লিস্ট মার্জ করুন।",
        isPopular: true,
      ),
      InplaceReversalProblem(
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
          "title": "1. Losing Next Pointer Reference",
          "desc": "Reassigning `curr->next = prev` before saving `nextTemp = curr->next` permanently breaks list connectivity and loses access to remaining nodes!"
        },
        {
          "title": "2. Returning `curr` instead of `prev`",
          "desc": "At reversal completion, `curr` becomes `nullptr`. Returning `curr` causes null pointer exceptions. Always return `prev` as the new head!"
        },
        {
          "title": "3. Sub-list Reversal Boundary Reconnection Errors",
          "desc": "Disconnecting `leftPrev` without reconnecting `leftPrev->next = prev` and `subTail->next = curr` leaves unlinked node segments."
        },
        {
          "title": "4. Not Using a Dummy Head Node",
          "desc": "Failing to use `DummyNode(0)` when `left = 1` leads to complex null checks and head reference crashes."
        },
        {
          "title": "5. Reversing Incomplete Group (< K) in K-Group",
          "desc": "In Reverse Nodes in k-Group, reversing the remaining elements when count < K violates the problem specification."
        },
      ];
    } else {
      return [
        {
          "title": "১. পরবর্তী নোডের ব্যাকআপ না রেখে লিঙ্ক উল্টানো",
          "desc": "`nextTemp = curr->next` ব্যাকআপ না রেখে `curr->next = prev` করলে পরবর্তী সব নোড স্থায়ীভাবে হারিয়ে যায়!"
        },
        {
          "title": "২. `prev` এর বদলে `curr` রিটার্ন করা",
          "desc": "লুপ শেষে `curr` মান নাল (`nullptr`) হয়ে যায়। `curr` রিটার্ন করলে অ্যাপ ক্র্যাশ করবে। নতুন হেড হিসেবে সবসময় `prev` রিটার্ন করতে হবে।"
        },
        {
          "title": "৩. নির্দিষ্ট সীমানায় উল্টানোর পর বাউন্ডারি জোড়া না দেওয়া",
          "desc": "Sub-list রিভার্স করার পর `leftPrev->next = prev` এবং `subTail->next = curr` জোড়া না দিলে লিঙ্কড লিস্ট বিচ্ছিন্ন হয়ে যাবে।"
        },
        {
          "title": "৪. ডামি হেড নোড (Dummy Head) ব্যবহার না করা",
          "desc": "হেড নোড নিজেই বদলে যেতে পারে এমন ক্ষেত্রে (যেমন `left = 1`) ডামি হেড ব্যবহার না করলে নাল পয়েন্টার ক্র্যাশ ঘটে।"
        },
        {
          "title": "৫. K-Group এ অবশিষ্ট কম নোড রিভার্স করে ফেলা",
          "desc": "Reverse Nodes in k-Group এ শেষে K এর চেয়ে কম নোড থাকলে সেগুলো উল্টানো যাবে না, অপরিবর্তিত রাখতে হবে।"
        },
      ];
    }
  }
}
