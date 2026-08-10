class MergeIntervalsProblem {
  final String title;
  final String difficulty; // Easy, Medium, Hard
  final List<String> companyTags;
  final String keyIdeaEn;
  final String keyIdeaBn;
  final bool isPopular;

  const MergeIntervalsProblem({
    required this.title,
    required this.difficulty,
    required this.companyTags,
    required this.keyIdeaEn,
    required this.keyIdeaBn,
    this.isPopular = false,
  });
}

class MergeIntervalsData {
  static Map<String, String> getConceptIntro(bool isEnglish) {
    if (isEnglish) {
      return {
        "title": "Merge Intervals — Complete Deep Dive (C++ & FAANG Focus)",
        "summary": "Merge Intervals deals with contiguous or overlapping time ranges [start, end]. The golden rule of interval problems is sorting intervals by their Start Time (a[0] < b[0]). Once sorted, overlapping intervals can be merged or identified in a single O(N) linear scan.",
        "whenToUseTitle": "When to Use Merge Intervals?",
        "whenToUse1": "Overlapping schedule/calendar events, meeting rooms, or resource allocation.",
        "whenToUse2": "Merging contiguous ranges [a, b] and [c, d] when c <= b.",
        "whenToUse3": "Inserting a new interval into a pre-sorted list of non-overlapping intervals.",
        "whenToUse4": "Finding the intersection (overlapping region) of two lists of intervals.",
        "whenToUse5": "Finding minimum meeting rooms required (Sweep Line / Min Heap).",
        "typesTitle": "3 Main Interval Patterns",
        "type1Title": "1. Merge Overlapping Intervals",
        "type1Desc": "Sort by start time. Compare curr[0] with lastMerged[1]. If curr[0] <= lastMerged[1], merge by lastMerged[1] = max(lastMerged[1], curr[1]). Otherwise, append curr.",
        "type2Title": "2. Insert Interval (3-Phase Pattern)",
        "type2Desc": "1. Add all intervals ending before newInterval[0]. 2. Merge all overlapping intervals with newInterval. 3. Add remaining intervals starting after newInterval[1].",
        "type3Title": "3. Interval Intersections & Two Pointers",
        "type3Desc": "Compare two sorted lists. Overlap exists if max(a[0], b[0]) <= min(a[1], b[1]). Intersection is [max(a[0], b[0]), min(a[1], b[1])]. Advance the pointer with earlier end time.",
      };
    } else {
      return {
        "title": "Merge Intervals — সম্পূর্ণ গাইড (C++ ও FAANG ফোকাস)",
        "summary": "Merge Intervals হলো সমাপতিত (Overlapping) সময় বা রেঞ্জ [start, end] একত্রিত করা। এর প্রধান স্বর্ণালী নিয়ম হলো সবসময় শুরু (Start Time) দিয়ে সর্ট করা। সর্ট করার পর একটি লিনিয়ার পাসে ওভারল্যাপিং ইন্টারভাল মার্জ বা ফিল্টার করা যায়।",
        "whenToUseTitle": "কখন বুঝবা Merge Intervals লাগবে?",
        "whenToUse1": "ক্যালেন্ডার ইভেন্ট, মিটিং রুম, বা সময়ের ওভারল্যাপিং প্রবলেমে।",
        "whenToUse2": "দুটি ওভারল্যাপিং রেঞ্জ [a, b] এবং [c, d] (যেখানে c <= b) মার্জ করতে।",
        "whenToUse3": "সর্টেড ইন্টারভাল লিস্টের মধ্যে নতুন ইন্টারভাল যুক্ত করতে।",
        "whenToUse4": "দুটি ইন্টারভাল লিস্টের ওভারল্যাপিং ক্ষেত্রফল (Intersection) বের করতে।",
        "whenToUse5": "সর্বনিম্ন কতটি মিটিং রুম লাগবে বের করতে (Sweep Line / Min Heap)।",
        "typesTitle": "Main Types (৩ ধরনের pattern)",
        "type1Title": "১. Merge Overlapping Intervals (ইন্টারভাল মার্জ)",
        "type1Desc": "Start Time অনুযায়ী সর্ট করো। `curr[0] <= lastMerged[1]` হলে `lastMerged[1] = max(lastMerged[1], curr[1])` দিয়ে মার্জ করো।",
        "type2Title": "২. Insert Interval (৩-ধাপের প্যাটার্ন)",
        "type2Desc": "১. newInterval এর আগে শেষ হওয়া সব যোগ করো। ২. ওভারল্যাপ হওয়াগুলো newInterval এ মার্জ করো। ৩. বাকি সব শেষে যোগ করো।",
        "type3Title": "৩. Interval Intersections (ছেদাংশ নির্ণয়)",
        "type3Desc": "দুটি সর্টেড লিস্টের ওভারল্যাপ ক্ষেত্রফল `[max(a[0], b[0]), min(a[1], b[1])]` বের করো। যেটির এন্ড টাইম ছোট তার পয়েন্টার বাড়াও।",
      };
    }
  }

  static List<MergeIntervalsProblem> getEasyProblems() {
    return const [
      MergeIntervalsProblem(
        title: "Meeting Rooms",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta", "Microsoft", "Google"],
        keyIdeaEn: "Sort intervals by start time. Check if any intervals[i][0] < intervals[i-1][1]. Return false if overlap found.",
        keyIdeaBn: "Start time দিয়ে সর্ট করে আগের এন্ড টাইম থেকে পরের স্টার্ট টাইম ছোট কিনা চেক করুন।",
        isPopular: true,
      ),
      MergeIntervalsProblem(
        title: "Summary Ranges",
        difficulty: "Easy",
        companyTags: ["Google", "Amazon"],
        keyIdeaEn: "Scan sorted array, merge contiguous numbers (nums[i] == nums[i-1] + 1) into ranges.",
        keyIdeaBn: "পর পর থাকা সংখ্যাগুলোকে একসাথে কানেক্ট করে স্ট্রিং রেঞ্জ গঠন করুন।",
      ),
      MergeIntervalsProblem(
        title: "Teemo Attacking",
        difficulty: "Easy",
        companyTags: ["Meta", "Amazon"],
        keyIdeaEn: "Calculate total poison duration by merging overlapping time windows.",
        keyIdeaBn: "ওভারল্যাপিং সময় বিয়োগ করে মোট বিষাক্ত থাকার সময় যোগ করুন।",
      ),
      MergeIntervalsProblem(
        title: "Check if All Integers in a Range Are Covered",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta"],
        keyIdeaEn: "Merge overlapping intervals or mark boolean array for covered target range.",
        keyIdeaBn: "টার্গেট রেঞ্জের সব সংখ্যা কভার হয়েছে কিনা চেক করুন।",
      ),
      MergeIntervalsProblem(
        title: "Maximum Population Year",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta", "Google"],
        keyIdeaEn: "Sweep line difference array (+1 on birth year, -1 on death year). Find prefix sum max.",
        keyIdeaBn: "সুইপ লাইন ডিফারেন্স অ্যারে দিয়ে সর্বোচ্চ জনসংখ্যার বছর বের করুন।",
      ),
      MergeIntervalsProblem(
        title: "Determine if Two Events Have Conflict",
        difficulty: "Easy",
        companyTags: ["Google", "Amazon"],
        keyIdeaEn: "Check string time conflict condition: max(event1[0], event2[0]) <= min(event1[1], event2[1]).",
        keyIdeaBn: "দুটি ইভেন্টের সময় সংঘাত ওভারল্যাপ শর্ত মেলান।",
      ),
      MergeIntervalsProblem(
        title: "Merge Similar Items",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta"],
        keyIdeaEn: "Group items by value weight sum and return sorted key-value pairs.",
        keyIdeaBn: "ওয়েট ভ্যালু গ্রুপ করে সর্টেড রেজাল্ট রিটার্ন করুন।",
      ),
      MergeIntervalsProblem(
        title: "Find Missing Ranges",
        difficulty: "Easy",
        companyTags: ["Meta", "Google"],
        keyIdeaEn: "Find gaps between adjacent numbers in sorted array bounded by lower and upper.",
        keyIdeaBn: "সর্টেড অ্যারের গ্যাপগুলো রেঞ্জ হিসেবে গঠন করুন।",
      ),
    ];
  }

  static List<MergeIntervalsProblem> getMediumProblems() {
    return const [
      MergeIntervalsProblem(
        title: "Merge Intervals",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft", "Bloomberg"],
        keyIdeaEn: "Sort intervals by start time. Iterate and merge overlapping ranges into result list.",
        keyIdeaBn: "Start time দিয়ে সর্ট করে পর পর ওভারল্যাপিং ইন্টারভালগুলো রেজাল্ট লিস্টে মার্জ করুন।",
        isPopular: true,
      ),
      MergeIntervalsProblem(
        title: "Insert Interval",
        difficulty: "Medium",
        companyTags: ["Meta", "Google", "Amazon", "Microsoft"],
        keyIdeaEn: "3-Phase insertion: 1. Add non-overlapping left. 2. Merge overlapping with newInterval. 3. Add remaining right.",
        keyIdeaBn: "৩-ধাপের ইনসার্ট: বামের নন-ওভারল্যাপ যোগ -> ওভারল্যাপ মার্জ -> ডানের সব যোগ।",
        isPopular: true,
      ),
      MergeIntervalsProblem(
        title: "Interval List Intersections",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Uber"],
        keyIdeaEn: "Two pointers on 2 sorted lists. Overlap range = [max(a[0], b[0]), min(a[1], b[1])]. Advance pointer with smaller end time.",
        keyIdeaBn: "টু পয়েন্টার। ওভারল্যাপ ক্ষেত্রফল = [max(start), min(end)]। এন্ড টাইম ছোট হলে পয়েন্টার বাড়ান।",
        isPopular: true,
      ),
      MergeIntervalsProblem(
        title: "Meeting Rooms II",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft", "Bloomberg"],
        keyIdeaEn: "Min-Heap or Chronological Start/End Sorting to track minimum required meeting rooms.",
        keyIdeaBn: "মিন-হিপ অথবা ক্রোনোলজিক্যাল স্টার্ট/এন্ড সর্টিং দিয়ে সর্বনিম্ন মিটিং রুম সংখ্যা বের করুন।",
        isPopular: true,
      ),
      MergeIntervalsProblem(
        title: "Non-overlapping Intervals",
        difficulty: "Medium",
        companyTags: ["Amazon", "Meta", "Google"],
        keyIdeaEn: "Greedy algorithm: Sort by End Time! Always keep interval that ends earliest to minimize removals.",
        keyIdeaBn: "গ্রিডি অ্যালগরিদম: End Time দিয়ে সর্ট করো! যেটির এন্ড টাইম ছোট সেটি রাখো।",
        isPopular: true,
      ),
      MergeIntervalsProblem(
        title: "Minimum Number of Arrows to Burst Balloons",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google"],
        keyIdeaEn: "Sort by end time. Shoot arrow at end of current balloon to burst all overlapping balloons.",
        keyIdeaBn: "End time দিয়ে সর্ট করে বেলুন ফুটানোর জন্য তীর সংকেত গণনা করুন।",
      ),
      MergeIntervalsProblem(
        title: "Car Pooling",
        difficulty: "Medium",
        companyTags: ["Amazon", "Meta", "Google"],
        keyIdeaEn: "Difference array / Sweep Line. Add passengers at pick-up location, subtract at drop-off.",
        keyIdeaBn: "পিক-আপে প্যাসেঞ্জার প্লাস এবং ড্রপ-অফে মাইনাস করে গাড়ি ক্যাপাসিটি চেক করুন।",
      ),
      MergeIntervalsProblem(
        title: "Corporate Flight Bookings",
        difficulty: "Medium",
        companyTags: ["Amazon", "Google"],
        keyIdeaEn: "Prefix sum difference array (+seats at first, -seats at last+1).",
        keyIdeaBn: "প্রেফিক্স সাম ডিফারেন্স অ্যারে দিয়ে ফ্লাইট বুকিং গণনা করুন।",
      ),
    ];
  }

  static List<MergeIntervalsProblem> getHardProblems() {
    return const [
      MergeIntervalsProblem(
        title: "Employee Free Time",
        difficulty: "Hard",
        companyTags: ["Amazon", "Meta", "Google"],
        keyIdeaEn: "Merge all employee schedules into one sorted list, then find gaps between merged intervals.",
        keyIdeaBn: "সব এমপ্লয়ীর শিডিউল মার্জ করে মাঝখানের ফ্রী সময়গুলো বের করুন।",
        isPopular: true,
      ),
      MergeIntervalsProblem(
        title: "Data Stream as Disjoint Intervals",
        difficulty: "Hard",
        companyTags: ["Google", "Amazon"],
        keyIdeaEn: "Ordered Map / BST data structure to dynamically insert integers into disjoint intervals.",
        keyIdeaBn: "অর্ডারড ম্যাপ দিয়ে ডাইনামিক স্ট্রিমে ডিসজয়েন্ট ইন্টারভাল মেইনটেইন করুন।",
        isPopular: true,
      ),
      MergeIntervalsProblem(
        title: "My Calendar III",
        difficulty: "Hard",
        companyTags: ["Google", "Amazon"],
        keyIdeaEn: "Sweep Line TreeMap to calculate maximum K-booking overlapping intervals dynamically.",
        keyIdeaBn: "সুইপ লাইন ট্রি-ম্যাপ দিয়ে সর্বোচ্চ ওভারল্যাপিং ইভেন্ট গণনা করুন।",
      ),
    ];
  }

  static List<Map<String, String>> getCommonMistakes(bool isEnglish) {
    if (isEnglish) {
      return [
        {
          "title": "1. Forgetting to Sort Intervals First",
          "desc": "Comparing intervals without sorting by start time (`a[0] < b[0]`) fails on out-of-order input lists like `[[2,6],[1,3]]`."
        },
        {
          "title": "2. Incorrect Overlap Condition (< vs <=)",
          "desc": "Using `<` instead of `<=` fails on touching boundaries. `[1,4]` and `[4,5]` overlap at 4 and must merge into `[1,5]`."
        },
        {
          "title": "3. Updating End Time with `curr[1]` instead of `max(last[1], curr[1])`",
          "desc": "Setting `last[1] = curr[1]` fails when a larger interval completely covers a smaller inner interval like `[1,10]` and `[2,3]`."
        },
        {
          "title": "4. Advancing Both Pointers Simultaneously in Intersections",
          "desc": "In two-list intersections, advancing both `i++` and `j++` together skips potential overlaps. Only advance the pointer whose interval ends first!"
        },
        {
          "title": "5. Sorting by End Time for Merging",
          "desc": "Sorting by End Time works for Non-overlapping / Greedy Selection, but sorting by Start Time is mandatory for Merging Intervals!"
        },
      ];
    } else {
      return [
        {
          "title": "১. Start Time দিয়ে সর্ট করতে ভুলে যাওয়া",
          "desc": "Start Time (`a[0] < b[0]`) দিয়ে সর্ট না করে মার্জ করার চেষ্টা করলে এলেমেলো ইনপুটে (যেমন `[[2,6],[1,3]]`) ভুল উত্তর আসবে।"
        },
        {
          "title": "২. ওভারল্যাপ শর্তে `<` এর বদলে `<=` না দেওয়া",
          "desc": "`[1,4]` এবং `[4,5]` এর সীমানা ৪ এ মিলেছে। `<=` না দিলে এগুলো আলাদা থেকে যাবে, কিন্তু হওয়া উচিত `[1,5]`।"
        },
        {
          "title": "৩. এন্ড টাইম আপডেটে `max()` ব্যবহার না করা",
          "desc": "`last[1] = curr[1]` লিখলে বিপত্তি ঘটবে যদি বড় ইন্টারভাল ছোটটাকে ঢেকে ফেলে (যেমন `[1,10]` ও `[2,3]`)। সবসময় `max(last[1], curr[1])` হবে।"
        },
        {
          "title": "৪. ইন্টারসেকশনে দুটো পয়েন্টার একসাথে বাড়ানো",
          "desc": "ইন্টারসেকশন বের করার সময় যে ইন্টারভালের এন্ড টাইম ছোট শুধুমাত্র তার পয়েন্টার বাড়াতে হবে, দুটো একসাথে নয়।"
        },
        {
          "title": "৫. মার্জিং এর ক্ষেত্রে End Time দিয়ে সর্ট করা",
          "desc": "End Time দিয়ে সর্ট করা প্রবলেম সিলেকশন/অ্যারো স্যুটিং এ দরকার, কিন্তু ইন্টারভাল মার্জ করতে সবসময় Start Time ই লাগবে।"
        },
      ];
    }
  }
}
