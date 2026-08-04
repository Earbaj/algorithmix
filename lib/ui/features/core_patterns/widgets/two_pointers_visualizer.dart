import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class DebugVisualizerStep {
  final int left;
  final int right;
  final int? fixed;
  final int activeLineIndex;
  final List<int> arrayState;
  final String explanationEn;
  final String explanationBn;
  final bool isMatch;

  const DebugVisualizerStep({
    required this.left,
    required this.right,
    this.fixed,
    required this.activeLineIndex,
    required this.arrayState,
    required this.explanationEn,
    required this.explanationBn,
    this.isMatch = false,
  });
}

class TwoPointersVisualizer extends StatefulWidget {
  final bool isEnglish;

  const TwoPointersVisualizer({super.key, required this.isEnglish});

  @override
  State<TwoPointersVisualizer> createState() => _TwoPointersVisualizerState();
}

class _TwoPointersVisualizerState extends State<TwoPointersVisualizer> {
  int _selectedTemplateIndex = 0;
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  // Code snippets split into exact lines for 100% granular line-by-line debugging
  final List<List<String>> _codeTemplates = const [
    // Template 1: Opposite Direction (Two Sum II)
    [
      "vector<int> twoSum(vector<int>& arr, int target) {",
      "    int left = 0, right = arr.size() - 1;",
      "    while (left < right) {",
      "        int curr_sum = arr[left] + arr[right];",
      "        if (curr_sum == target) return {left, right};",
      "        else if (curr_sum < target) left++;",
      "        else right--;",
      "    }",
      "    return {-1, -1};",
      "}",
    ],
    // Template 2: Same Direction (Move Zeroes)
    [
      "void moveZeroes(vector<int>& nums) {",
      "    int slow = 0;",
      "    for (int fast = 0; fast < nums.size(); fast++) {",
      "        if (nums[fast] != 0) {",
      "            swap(nums[slow], nums[fast]);",
      "            slow++;",
      "        }",
      "    }",
      "}",
    ],
    // Template 3: Fixed + Two Pointer (3Sum)
    [
      "vector<vector<int>> threeSum(vector<int>& nums) {",
      "    sort(nums.begin(), nums.end());",
      "    for (int i = 0; i < n - 2; i++) {",
      "        if (i > 0 && nums[i] == nums[i-1]) continue;",
      "        int left = i + 1, right = n - 1;",
      "        while (left < right) {",
      "            int sum = nums[i] + nums[left] + nums[right];",
      "            if (sum == 0) return {nums[i], nums[left], nums[right]};",
      "            else if (sum < 0) left++;",
      "            else right--;",
      "        }",
      "    }",
      "}",
    ],
  ];

  // Template 1 Granular Line-by-Line Debugging Steps (Two Sum II)
  final List<DebugVisualizerStep> _template1Steps = const [
    DebugVisualizerStep(
      left: 0,
      right: 6,
      activeLineIndex: 1,
      arrayState: [1, 2, 4, 6, 8, 11, 15],
      explanationEn: "Line 2: Initialize variables -> left = 0 (val 1), right = 6 (val 15). Target = 10.",
      explanationBn: "লাইন ২: ভ্যারিয়েবল ডিক্লেয়ার -> left = 0 (মান 1), right = 6 (মান 15)। Target = 10।",
    ),
    DebugVisualizerStep(
      left: 0,
      right: 6,
      activeLineIndex: 2,
      arrayState: [1, 2, 4, 6, 8, 11, 15],
      explanationEn: "Line 3: Check while (left < right) -> (0 < 6) is TRUE. Enter loop.",
      explanationBn: "লাইন ৩: শর্ত চেক while (left < right) -> (0 < 6) সত্য! লুপে প্রবেশ করুন।",
    ),
    DebugVisualizerStep(
      left: 0,
      right: 6,
      activeLineIndex: 3,
      arrayState: [1, 2, 4, 6, 8, 11, 15],
      explanationEn: "Line 4: Calculate curr_sum = arr[0] + arr[6] = 1 + 15 = 16.",
      explanationBn: "লাইন ৪: হিসাব করুন curr_sum = arr[0] + arr[6] = 1 + 15 = 16।",
    ),
    DebugVisualizerStep(
      left: 0,
      right: 6,
      activeLineIndex: 4,
      arrayState: [1, 2, 4, 6, 8, 11, 15],
      explanationEn: "Line 5: Check if (curr_sum == target) -> (16 == 10) is FALSE.",
      explanationBn: "লাইন ৫: চেক if (curr_sum == target) -> (16 == 10) মিথ্যা।",
    ),
    DebugVisualizerStep(
      left: 0,
      right: 6,
      activeLineIndex: 5,
      arrayState: [1, 2, 4, 6, 8, 11, 15],
      explanationEn: "Line 6: Check else if (curr_sum < target) -> (16 < 10) is FALSE.",
      explanationBn: "লাইন ৬: চেক else if (curr_sum < target) -> (16 < 10) মিথ্যা।",
    ),
    DebugVisualizerStep(
      left: 0,
      right: 5,
      activeLineIndex: 6,
      arrayState: [1, 2, 4, 6, 8, 11, 15],
      explanationEn: "Line 7: Execute else right-- -> right decreases from 6 to 5.",
      explanationBn: "লাইন ৭: else এক্সিকিউট right-- -> right কমে 6 থেকে 5 হলো।",
    ),
    DebugVisualizerStep(
      left: 0,
      right: 5,
      activeLineIndex: 2,
      arrayState: [1, 2, 4, 6, 8, 11, 15],
      explanationEn: "Line 3: Check while (left < right) -> (0 < 5) is TRUE. Continue loop.",
      explanationBn: "লাইন ৩: শর্ত চেক while (left < right) -> (0 < 5) সত্য! লুপ চলবে।",
    ),
    DebugVisualizerStep(
      left: 0,
      right: 5,
      activeLineIndex: 3,
      arrayState: [1, 2, 4, 6, 8, 11, 15],
      explanationEn: "Line 4: Calculate curr_sum = arr[0] + arr[5] = 1 + 11 = 12.",
      explanationBn: "লাইন ৪: হিসাব করুন curr_sum = arr[0] + arr[5] = 1 + 11 = 12।",
    ),
    DebugVisualizerStep(
      left: 0,
      right: 5,
      activeLineIndex: 4,
      arrayState: [1, 2, 4, 6, 8, 11, 15],
      explanationEn: "Line 5: Check if (curr_sum == target) -> (12 == 10) is FALSE.",
      explanationBn: "লাইন ৫: চেক if (curr_sum == target) -> (12 == 10) মিথ্যা।",
    ),
    DebugVisualizerStep(
      left: 0,
      right: 5,
      activeLineIndex: 5,
      arrayState: [1, 2, 4, 6, 8, 11, 15],
      explanationEn: "Line 6: Check else if (curr_sum < target) -> (12 < 10) is FALSE.",
      explanationBn: "লাইন ৬: চেক else if (curr_sum < target) -> (12 < 10) মিথ্যা।",
    ),
    DebugVisualizerStep(
      left: 0,
      right: 4,
      activeLineIndex: 6,
      arrayState: [1, 2, 4, 6, 8, 11, 15],
      explanationEn: "Line 7: Execute else right-- -> right decreases from 5 to 4.",
      explanationBn: "লাইন ৭: else এক্সিকিউট right-- -> right কমে 5 থেকে 4 হলো।",
    ),
    DebugVisualizerStep(
      left: 0,
      right: 4,
      activeLineIndex: 2,
      arrayState: [1, 2, 4, 6, 8, 11, 15],
      explanationEn: "Line 3: Check while (left < right) -> (0 < 4) is TRUE.",
      explanationBn: "লাইন ৩: শর্ত চেক while (left < right) -> (0 < 4) সত্য।",
    ),
    DebugVisualizerStep(
      left: 0,
      right: 4,
      activeLineIndex: 3,
      arrayState: [1, 2, 4, 6, 8, 11, 15],
      explanationEn: "Line 4: Calculate curr_sum = arr[0] + arr[4] = 1 + 8 = 9.",
      explanationBn: "লাইন ৪: হিসাব করুন curr_sum = arr[0] + arr[4] = 1 + 8 = 9।",
    ),
    DebugVisualizerStep(
      left: 0,
      right: 4,
      activeLineIndex: 4,
      arrayState: [1, 2, 4, 6, 8, 11, 15],
      explanationEn: "Line 5: Check if (curr_sum == target) -> (9 == 10) is FALSE.",
      explanationBn: "লাইন ৫: চেক if (curr_sum == target) -> (9 == 10) মিথ্যা।",
    ),
    DebugVisualizerStep(
      left: 0,
      right: 4,
      activeLineIndex: 5,
      arrayState: [1, 2, 4, 6, 8, 11, 15],
      explanationEn: "Line 6: Check else if (curr_sum < target) -> (9 < 10) is TRUE! Execute left++.",
      explanationBn: "লাইন ৬: চেক else if (curr_sum < target) -> (9 < 10) সত্য! left++ চালান।",
    ),
    DebugVisualizerStep(
      left: 1,
      right: 4,
      activeLineIndex: 5,
      arrayState: [1, 2, 4, 6, 8, 11, 15],
      explanationEn: "Line 6: left++ executed -> left is now 1 (val 2).",
      explanationBn: "লাইন ৬: left++ সফল হলো -> left এখন 1 (মান 2)।",
    ),
    DebugVisualizerStep(
      left: 1,
      right: 4,
      activeLineIndex: 2,
      arrayState: [1, 2, 4, 6, 8, 11, 15],
      explanationEn: "Line 3: Check while (left < right) -> (1 < 4) is TRUE.",
      explanationBn: "লাইন ৩: শর্ত চেক while (left < right) -> (1 < 4) সত্য।",
    ),
    DebugVisualizerStep(
      left: 1,
      right: 4,
      activeLineIndex: 3,
      arrayState: [1, 2, 4, 6, 8, 11, 15],
      explanationEn: "Line 4: Calculate curr_sum = arr[1] + arr[4] = 2 + 8 = 10.",
      explanationBn: "লাইন ৪: হিসাব করুন curr_sum = arr[1] + arr[4] = 2 + 8 = 10।",
    ),
    DebugVisualizerStep(
      left: 1,
      right: 4,
      activeLineIndex: 4,
      arrayState: [1, 2, 4, 6, 8, 11, 15],
      explanationEn: "🎉 Line 5: MATCH FOUND! (10 == 10) is TRUE! Return {1, 4}!",
      explanationBn: "🎉 লাইন ৫: ম্যাচ পাওয়া গেছে! (10 == 10) সত্য! Return {1, 4}!",
      isMatch: true,
    ),
  ];

  // Template 2 Granular Line-by-Line Debugging Steps (Move Zeroes)
  final List<DebugVisualizerStep> _template2Steps = const [
    DebugVisualizerStep(
      left: 0,
      right: 0,
      activeLineIndex: 1,
      arrayState: [0, 1, 0, 3, 12],
      explanationEn: "Line 2: Initialize slow = 0.",
      explanationBn: "লাইন ২: সূচনা slow = 0।",
    ),
    DebugVisualizerStep(
      left: 0,
      right: 0,
      activeLineIndex: 2,
      arrayState: [0, 1, 0, 3, 12],
      explanationEn: "Line 3: Check for loop: fast = 0 (0 < 5 is TRUE).",
      explanationBn: "লাইন ৩: for লুপ চেক: fast = 0 (0 < 5 সত্য)।",
    ),
    DebugVisualizerStep(
      left: 0,
      right: 0,
      activeLineIndex: 3,
      arrayState: [0, 1, 0, 3, 12],
      explanationEn: "Line 4: Check if (nums[0] != 0) -> (0 != 0) is FALSE. Skip if block.",
      explanationBn: "লাইন ৪: চেক if (nums[0] != 0) -> (0 != 0) মিথ্যা। swap স্কিপ করুন।",
    ),
    DebugVisualizerStep(
      left: 0,
      right: 1,
      activeLineIndex: 2,
      arrayState: [0, 1, 0, 3, 12],
      explanationEn: "Line 3: Loop increment fast++ -> fast is now 1.",
      explanationBn: "লাইন ৩: fast++ ইনক্রিমেন্ট -> fast এখন 1।",
    ),
    DebugVisualizerStep(
      left: 0,
      right: 1,
      activeLineIndex: 3,
      arrayState: [0, 1, 0, 3, 12],
      explanationEn: "Line 4: Check if (nums[1] != 0) -> (1 != 0) is TRUE! Enter if block.",
      explanationBn: "লাইন ৪: চেক if (nums[1] != 0) -> (1 != 0) সত্য! if ব্লকে ঢুকুন।",
    ),
    DebugVisualizerStep(
      left: 0,
      right: 1,
      activeLineIndex: 4,
      arrayState: [1, 0, 0, 3, 12],
      explanationEn: "Line 5: Execute swap(nums[0], nums[1]) -> array: [1, 0, 0, 3, 12].",
      explanationBn: "লাইন ৫: swap(nums[0], nums[1]) চালান -> অ্যারে: [1, 0, 0, 3, 12]।",
    ),
    DebugVisualizerStep(
      left: 1,
      right: 1,
      activeLineIndex: 5,
      arrayState: [1, 0, 0, 3, 12],
      explanationEn: "Line 6: Execute slow++ -> slow is now 1.",
      explanationBn: "লাইন ৬: slow++ চালান -> slow এখন 1।",
    ),
    DebugVisualizerStep(
      left: 1,
      right: 2,
      activeLineIndex: 2,
      arrayState: [1, 0, 0, 3, 12],
      explanationEn: "Line 3: Loop increment fast++ -> fast is now 2.",
      explanationBn: "লাইন ৩: fast++ ইনক্রিমেন্ট -> fast এখন 2।",
    ),
    DebugVisualizerStep(
      left: 1,
      right: 2,
      activeLineIndex: 3,
      arrayState: [1, 0, 0, 3, 12],
      explanationEn: "Line 4: Check if (nums[2] != 0) -> (0 != 0) is FALSE. Skip if block.",
      explanationBn: "লাইন ৪: চেক if (nums[2] != 0) -> (0 != 0) মিথ্যা। swap স্কিপ করুন।",
    ),
    DebugVisualizerStep(
      left: 1,
      right: 3,
      activeLineIndex: 2,
      arrayState: [1, 0, 0, 3, 12],
      explanationEn: "Line 3: Loop increment fast++ -> fast is now 3.",
      explanationBn: "লাইন ৩: fast++ ইনক্রিমেন্ট -> fast এখন 3।",
    ),
    DebugVisualizerStep(
      left: 1,
      right: 3,
      activeLineIndex: 3,
      arrayState: [1, 0, 0, 3, 12],
      explanationEn: "Line 4: Check if (nums[3] != 0) -> (3 != 0) is TRUE!",
      explanationBn: "লাইন ৪: চেক if (nums[3] != 0) -> (3 != 0) সত্য!",
    ),
    DebugVisualizerStep(
      left: 1,
      right: 3,
      activeLineIndex: 4,
      arrayState: [1, 3, 0, 0, 12],
      explanationEn: "Line 5: Execute swap(nums[1], nums[3]) -> array: [1, 3, 0, 0, 12].",
      explanationBn: "লাইন ৫: swap(nums[1], nums[3]) চালান -> অ্যারে: [1, 3, 0, 0, 12]।",
    ),
    DebugVisualizerStep(
      left: 2,
      right: 3,
      activeLineIndex: 5,
      arrayState: [1, 3, 0, 0, 12],
      explanationEn: "Line 6: Execute slow++ -> slow is now 2.",
      explanationBn: "লাইন ৬: slow++ চালান -> slow এখন 2।",
    ),
    DebugVisualizerStep(
      left: 2,
      right: 4,
      activeLineIndex: 2,
      arrayState: [1, 3, 0, 0, 12],
      explanationEn: "Line 3: Loop increment fast++ -> fast is now 4.",
      explanationBn: "লাইন ৩: fast++ ইনক্রিমেন্ট -> fast এখন 4।",
    ),
    DebugVisualizerStep(
      left: 2,
      right: 4,
      activeLineIndex: 3,
      arrayState: [1, 3, 0, 0, 12],
      explanationEn: "Line 4: Check if (nums[4] != 0) -> (12 != 0) is TRUE!",
      explanationBn: "লাইন ৪: চেক if (nums[4] != 0) -> (12 != 0) সত্য!",
    ),
    DebugVisualizerStep(
      left: 2,
      right: 4,
      activeLineIndex: 4,
      arrayState: [1, 3, 12, 0, 0],
      explanationEn: "Line 5: Execute swap(nums[2], nums[4]) -> array: [1, 3, 12, 0, 0].",
      explanationBn: "লাইন ৫: swap(nums[2], nums[4]) চালান -> অ্যারে: [1, 3, 12, 0, 0]।",
    ),
    DebugVisualizerStep(
      left: 3,
      right: 4,
      activeLineIndex: 5,
      arrayState: [1, 3, 12, 0, 0],
      explanationEn: "Line 6: Execute slow++ -> slow is now 3.",
      explanationBn: "লাইন ৬: slow++ চালান -> slow এখন 3।",
    ),
    DebugVisualizerStep(
      left: 3,
      right: 4,
      activeLineIndex: 8,
      arrayState: [1, 3, 12, 0, 0],
      explanationEn: "🎉 Line 9: Loop finished! All zeroes moved to back: [1, 3, 12, 0, 0].",
      explanationBn: "🎉 লাইন ৯: লুপ সম্পন্ন! সব zero পেছনে নিয়ে নেওয়া হয়েছে: [1, 3, 12, 0, 0]।",
      isMatch: true,
    ),
  ];

  // Template 3 Granular Line-by-Line Debugging Steps (3Sum Triplets)
  final List<DebugVisualizerStep> _template3Steps = const [
    DebugVisualizerStep(
      left: 1,
      right: 5,
      fixed: 0,
      activeLineIndex: 1,
      arrayState: [-4, -1, -1, 0, 1, 2],
      explanationEn: "Line 2: Sort input array: [-4, -1, -1, 0, 1, 2].",
      explanationBn: "লাইন ২: ইনপুট অ্যারে সর্ট করুন: [-4, -1, -1, 0, 1, 2]।",
    ),
    DebugVisualizerStep(
      left: 1,
      right: 5,
      fixed: 0,
      activeLineIndex: 2,
      arrayState: [-4, -1, -1, 0, 1, 2],
      explanationEn: "Line 3: Start outer loop i = 0 (nums[0] = -4).",
      explanationBn: "লাইন ৩: আউটার লুপ শুরু i = 0 (nums[0] = -4)।",
    ),
    DebugVisualizerStep(
      left: 1,
      right: 5,
      fixed: 0,
      activeLineIndex: 3,
      arrayState: [-4, -1, -1, 0, 1, 2],
      explanationEn: "Line 4: Check duplicate (i > 0 && nums[i] == nums[i-1]) -> (0 > 0 is FALSE).",
      explanationBn: "লাইন ৪: ডুপ্লিকেট চেক (i > 0 && nums[i] == nums[i-1]) -> (0 > 0 মিথ্যা)।",
    ),
    DebugVisualizerStep(
      left: 1,
      right: 5,
      fixed: 0,
      activeLineIndex: 4,
      arrayState: [-4, -1, -1, 0, 1, 2],
      explanationEn: "Line 5: Set left = i+1 = 1 (val -1) and right = n-1 = 5 (val 2).",
      explanationBn: "লাইন ৫: সেট করুন left = 1 (মান -1) এবং right = 5 (মান 2)।",
    ),
    DebugVisualizerStep(
      left: 1,
      right: 5,
      fixed: 0,
      activeLineIndex: 5,
      arrayState: [-4, -1, -1, 0, 1, 2],
      explanationEn: "Line 6: Check while (left < right) -> (1 < 5) is TRUE. Enter inner loop.",
      explanationBn: "লাইন ৬: শর্ত চেক while (left < right) -> (1 < 5) সত্য! ইনার লুপে প্রবেশ।",
    ),
    DebugVisualizerStep(
      left: 1,
      right: 5,
      fixed: 0,
      activeLineIndex: 6,
      arrayState: [-4, -1, -1, 0, 1, 2],
      explanationEn: "Line 7: Calculate sum = nums[0] + nums[1] + nums[5] = -4 + (-1) + 2 = -3.",
      explanationBn: "লাইন ৭: হিসাব করুন sum = nums[0] + nums[1] + nums[5] = -4 + (-1) + 2 = -3।",
    ),
    DebugVisualizerStep(
      left: 1,
      right: 5,
      fixed: 0,
      activeLineIndex: 7,
      arrayState: [-4, -1, -1, 0, 1, 2],
      explanationEn: "Line 8: Check if (sum == 0) -> (-3 == 0) is FALSE.",
      explanationBn: "লাইন ৮: চেক if (sum == 0) -> (-3 == 0) মিথ্যা।",
    ),
    DebugVisualizerStep(
      left: 1,
      right: 5,
      fixed: 0,
      activeLineIndex: 8,
      arrayState: [-4, -1, -1, 0, 1, 2],
      explanationEn: "Line 9: Check else if (sum < 0) -> (-3 < 0) is TRUE! Execute left++.",
      explanationBn: "লাইন ৯: চেক else if (sum < 0) -> (-3 < 0) সত্য! left++ বলুন।",
    ),
    DebugVisualizerStep(
      left: 2,
      right: 5,
      fixed: 0,
      activeLineIndex: 8,
      arrayState: [-4, -1, -1, 0, 1, 2],
      explanationEn: "Line 9: left++ executed -> left is now 2 (val -1).",
      explanationBn: "লাইন ৯: left++ সম্পাদন করা হলো -> left এখন 2 (মান -1)।",
    ),
    DebugVisualizerStep(
      left: 2,
      right: 5,
      fixed: 1,
      activeLineIndex: 2,
      arrayState: [-4, -1, -1, 0, 1, 2],
      explanationEn: "Line 3: Outer loop advances i = 1 (nums[1] = -1).",
      explanationBn: "লাইন ৩: আউটার লুপ পরিবর্তন i = 1 (nums[1] = -1)।",
    ),
    DebugVisualizerStep(
      left: 2,
      right: 5,
      fixed: 1,
      activeLineIndex: 3,
      arrayState: [-4, -1, -1, 0, 1, 2],
      explanationEn: "Line 4: Check duplicate (1 > 0 && nums[1] == nums[0]) -> (-1 == -4 is FALSE).",
      explanationBn: "লাইন ৪: ডুপ্লিকেট চেক (-1 == -4 মিথ্যা)।",
    ),
    DebugVisualizerStep(
      left: 2,
      right: 5,
      fixed: 1,
      activeLineIndex: 4,
      arrayState: [-4, -1, -1, 0, 1, 2],
      explanationEn: "Line 5: Set left = i+1 = 2 (val -1) and right = n-1 = 5 (val 2).",
      explanationBn: "লাইন ৫: সেট করুন left = 2 (মান -1) এবং right = 5 (মান 2)।",
    ),
    DebugVisualizerStep(
      left: 2,
      right: 5,
      fixed: 1,
      activeLineIndex: 5,
      arrayState: [-4, -1, -1, 0, 1, 2],
      explanationEn: "Line 6: Check while (left < right) -> (2 < 5) is TRUE.",
      explanationBn: "লাইন ৬: শর্ত চেক while (left < right) -> (2 < 5) সত্য।",
    ),
    DebugVisualizerStep(
      left: 2,
      right: 5,
      fixed: 1,
      activeLineIndex: 6,
      arrayState: [-4, -1, -1, 0, 1, 2],
      explanationEn: "Line 7: Calculate sum = nums[1] + nums[2] + nums[5] = -1 + (-1) + 2 = 0.",
      explanationBn: "লাইন ৭: হিসাব করুন sum = nums[1] + nums[2] + nums[5] = -1 + (-1) + 2 = 0।",
    ),
    DebugVisualizerStep(
      left: 2,
      right: 5,
      fixed: 1,
      activeLineIndex: 7,
      arrayState: [-4, -1, -1, 0, 1, 2],
      explanationEn: "🎉 Line 8: TRIPLET MATCH FOUND! (0 == 0) is TRUE! Return {-1, -1, 2}!",
      explanationBn: "🎉 লাইন ৮: ট্রিপলেট ম্যাচ পাওয়া গেছে! (0 == 0) সত্য! Return {-1, -1, 2}!",
      isMatch: true,
    ),
  ];

  List<DebugVisualizerStep> get _currentSteps {
    if (_selectedTemplateIndex == 0) return _template1Steps;
    if (_selectedTemplateIndex == 1) return _template2Steps;
    return _template3Steps;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;
    });

    if (_isPlaying) {
      _timer = Timer.periodic(const Duration(milliseconds: 1800), (timer) {
        if (_currentStepIndex < _currentSteps.length - 1) {
          setState(() {
            _currentStepIndex++;
          });
        } else {
          _timer?.cancel();
          setState(() {
            _isPlaying = false;
          });
        }
      });
    } else {
      _timer?.cancel();
    }
  }

  void _nextStep() {
    if (_currentStepIndex < _currentSteps.length - 1) {
      setState(() {
        _currentStepIndex++;
      });
    }
  }

  void _prevStep() {
    if (_currentStepIndex > 0) {
      setState(() {
        _currentStepIndex--;
      });
    }
  }

  void _reset() {
    _timer?.cancel();
    setState(() {
      _isPlaying = false;
      _currentStepIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final step = _currentSteps[_currentStepIndex];
    final codeLines = _codeTemplates[_selectedTemplateIndex];
    final isMobile = Responsive.isMobile(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Selector & Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                widget.isEnglish
                    ? isMobile ? "Debugger":"Line-by-Line Debugger"
                    : isMobile ? "ডিবাগার":"লাইন-বাই-লাইন ডিবাগার",
                style: TextStyle(
                  fontSize: Responsive.sp(context, 16),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            DropdownButton<int>(
              value: _selectedTemplateIndex,
              dropdownColor: AppTheme.primaryDark,
              style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12),
              underline: Container(),
              items: [
                DropdownMenuItem(
                  value: 0,
                  child: Text(widget.isEnglish ? "1. Opposite Direction" : "১. বিপরীত দিক (Opposite)"),
                ),
                DropdownMenuItem(
                  value: 1,
                  child: Text(widget.isEnglish ? "2. Same Direction" : "২. একই দিক (Same Dir)"),
                ),
                DropdownMenuItem(
                  value: 2,
                  child: Text(widget.isEnglish ? "3. Fixed + 2 Pointers" : "৩. Fixed + Two Pointers"),
                ),
              ],
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _selectedTemplateIndex = val;
                    _reset();
                  });
                }
              },
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Code & Visualizer Container (Responsive Layout)
        if (isMobile)
          Column(
            children: [
              _buildCodeSnippetWithHighlight(codeLines, step.activeLineIndex),
              const SizedBox(height: 16),
              _buildVisualizerBox(step),
            ],
          )
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildCodeSnippetWithHighlight(codeLines, step.activeLineIndex)),
              const SizedBox(width: 16),
              Expanded(child: _buildVisualizerBox(step)),
            ],
          ),

        const SizedBox(height: 16),

        // Controls Bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: AppTheme.primaryDark,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.textMuted)
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.skip_previous, color: Colors.white),
                    onPressed: _currentStepIndex > 0 ? _prevStep : null,
                  ),
                  IconButton(
                    icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, color: AppTheme.accentNeonCyan),
                    onPressed: _togglePlay,
                  ),
                  IconButton(
                    icon: const Icon(Icons.skip_next, color: Colors.white),
                    onPressed: _currentStepIndex < _currentSteps.length - 1 ? _nextStep : null,
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, color: AppTheme.textMuted),
                    onPressed: _reset,
                  ),
                  Text(
                    "Step ${_currentStepIndex + 1} / ${_currentSteps.length}",
                    style: const TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Highlight active line during execution
  Widget _buildCodeSnippetWithHighlight(List<String> codeLines, int activeLineIndex) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF090D16),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(codeLines.length, (idx) {
          final isActive = idx == activeLineIndex;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(vertical: 2),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            decoration: BoxDecoration(
              color: isActive ? AppTheme.accentPurple.withOpacity(0.35) : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: isActive
                  ? const Border(left: BorderSide(color: AppTheme.accentNeonCyan, width: 4))
                  : null,
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 24,
                  child: Text(
                    '${idx + 1}',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                      color: isActive ? AppTheme.accentNeonCyan : AppTheme.textMuted,
                      fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      codeLines[idx],
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        color: isActive ? Colors.white : const Color(0xFF94A3B8),
                        fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildVisualizerBox(DebugVisualizerStep step) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: step.isMatch ? AppTheme.accentGreen : const Color(0xFF334155),
          width: step.isMatch ? 2.0 : 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pointer Variables Badge Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (step.fixed != null) ...[
                _buildPointerBadge('i (fixed)', AppTheme.accentAmber, step.fixed!),
                const SizedBox(width: 8),
              ],
              _buildPointerBadge(
                _selectedTemplateIndex == 1 ? 'slow' : 'left',
                AppTheme.accentNeonCyan,
                step.left,
              ),
              const SizedBox(width: 8),
              _buildPointerBadge(
                _selectedTemplateIndex == 1 ? 'fast' : 'right',
                AppTheme.accentPink,
                step.right,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Visual Array Elements
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(step.arrayState.length, (idx) {
                final isFixed = step.fixed == idx;
                final isLeft = idx == step.left;
                final isRight = idx == step.right;

                Color boxBg = const Color(0xFF1E293B);
                Color borderColor = const Color(0xFF334155);

                if (isFixed) {
                  boxBg = AppTheme.accentAmber.withOpacity(0.3);
                  borderColor = AppTheme.accentAmber;
                } else if (isLeft && isRight) {
                  boxBg = AppTheme.accentPurple.withOpacity(0.3);
                  borderColor = AppTheme.accentPurple;
                } else if (isLeft) {
                  boxBg = AppTheme.accentNeonCyan.withOpacity(0.3);
                  borderColor = AppTheme.accentNeonCyan;
                } else if (isRight) {
                  boxBg = AppTheme.accentPink.withOpacity(0.3);
                  borderColor = AppTheme.accentPink;
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: boxBg,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: borderColor,
                            width: (isLeft || isRight || isFixed) ? 2.0 : 1.0,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '${step.arrayState[idx]}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '[$idx]',
                        style: const TextStyle(fontSize: 10, color: AppTheme.textMuted),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 16),

          // Detailed Explanation Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: step.isMatch
                  ? AppTheme.accentGreen.withOpacity(0.15)
                  : const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              widget.isEnglish ? step.explanationEn : step.explanationBn,
              style: TextStyle(
                fontSize: 13,
                color: step.isMatch ? AppTheme.accentGreen : AppTheme.textPrimary,
                fontWeight: step.isMatch ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPointerBadge(String label, Color color, int value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        '$label = $value',
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }
}
