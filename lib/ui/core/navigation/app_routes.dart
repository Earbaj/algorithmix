import 'package:flutter/material.dart';
import 'package:algorithmix/ui/features/splash/views/splash_screen.dart';
import 'package:algorithmix/ui/features/auth/views/login_screen.dart';
import 'package:algorithmix/ui/features/auth/views/register_screen.dart';
import 'package:algorithmix/ui/features/dashboard/views/dashboard_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/core_patterns_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/two_pointers_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/recursion_backtracking_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/sliding_window_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/fast_slow_pointers_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/merge_intervals_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/cyclic_sort_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/inplace_reversal_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/tree_bfs_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/tree_dfs_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/two_heaps_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/subsets_backtracking_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/modified_binary_search_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/top_k_elements_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/kway_merge_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/greedy_algorithm_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/dp_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/topological_sort_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/union_find_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/graph_traversal_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/trie_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/bit_manipulation_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/monotonic_stack_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/prefix_sum_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/subsets_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/combination_sum_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/generate_parentheses_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/letter_combinations_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/permutations_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/binary_tree_paths_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/word_search_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/subsets_ii_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/permutations_ii_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/combination_sum_ii_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/palindrome_partitioning_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/letter_case_permutation_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/n_queens_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/sudoku_solver_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/target_sum_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/restore_ip_addresses_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/remove_invalid_parentheses_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/max_average_subarray_i_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/contains_duplicate_ii_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/defuse_the_bomb_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/minimum_recolors_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/time_space_complexity_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/asymptotic_notations_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/complexity_classes_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/space_complexity_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/big_o_rules_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/amortized_complexity_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/best_worst_case_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/two_sum_ii_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/valid_palindrome_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/reverse_string_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/move_zeroes_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/remove_duplicates_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/remove_duplicates_ii_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/squares_sorted_array_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/merge_sorted_array_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/is_subsequence_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/three_sum_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/three_sum_closest_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/four_sum_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/container_with_most_water_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/sort_colors_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/boats_to_save_people_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/partition_labels_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/trapping_rain_water_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/min_window_substring_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/median_two_sorted_arrays_detail_screen.dart';
import 'package:algorithmix/ui/features/algorithms/views/algorithms_screen.dart';
import 'package:algorithmix/ui/features/dsa/views/dsa_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String dashboard = '/dashboard';
  static const String corePatterns = '/core-patterns';
  static const String timeSpaceComplexityDetail = '/time-space-complexity-detail';
  static const String asymptoticNotations = '/asymptotic-notations';
  static const String complexityClasses = '/complexity-classes';
  static const String spaceComplexity = '/space-complexity';
  static const String bigORules = '/big-o-rules';
  static const String amortizedComplexity = '/amortized-complexity';
  static const String bestWorstCase = '/best-worst-case';
  static const String twoPointersDetail = '/two-pointers-detail';
  static const String recursionBacktrackingDetail = '/recursion-backtracking-detail';
  static const String slidingWindowDetail = '/sliding-window-detail';
  static const String fastSlowPointersDetail = '/fast-slow-pointers-detail';
  static const String mergeIntervalsDetail = '/merge-intervals-detail';
  static const String cyclicSortDetail = '/cyclic-sort-detail';
  static const String inplaceReversalDetail = '/inplace-reversal-detail';
  static const String treeBfsDetail = '/tree-bfs-detail';
  static const String treeDfsDetail = '/tree-dfs-detail';
  static const String twoHeapsDetail = '/two-heaps-detail';
  static const String subsetsBacktrackingDetail = '/subsets-backtracking-detail';
  static const String modifiedBinarySearchDetail = '/modified-binary-search-detail';
  static const String topKElementsDetail = '/top-k-elements-detail';
  static const String kwayMergeDetail = '/kway-merge-detail';
  static const String greedyAlgorithmDetail = '/greedy-algorithm-detail';
  static const String dpDetail = '/dp-detail';
  static const String topologicalSortDetail = '/topological-sort-detail';
  static const String unionFindDetail = '/union-find-detail';
  static const String graphTraversalDetail = '/graph-traversal-detail';
  static const String trieDetail = '/trie-detail';
  static const String bitManipulationDetail = '/bit-manipulation-detail';
  static const String monotonicStackDetail = '/monotonic-stack-detail';
  static const String prefixSumDetail = '/prefix-sum-detail';
  static const String subsetsDetail = '/subsets-detail';
  static const String combinationSumDetail = '/combination-sum-detail';
  static const String generateParenthesesDetail = '/generate-parentheses-detail';
  static const String letterCombinationsDetail = '/letter-combinations-detail';
  static const String permutationsDetail = '/permutations-detail';
  static const String binaryTreePathsDetail = '/binary-tree-paths-detail';
  static const String wordSearchDetail = '/word-search-detail';
  static const String subsetsIIDetail = '/subsets-ii-detail';
  static const String permutationsIIDetail = '/permutations-ii-detail';
  static const String combinationSumIIDetail = '/combination-sum-ii-detail';
  static const String palindromePartitioningDetail = '/palindrome-partitioning-detail';
  static const String letterCasePermutationDetail = '/letter-case-permutation-detail';
  static const String nQueensDetail = '/n-queens-detail';
  static const String sudokuSolverDetail = '/sudoku-solver-detail';
  static const String targetSumDetail = '/target-sum-detail';
  static const String restoreIPAddressesDetail = '/restore-ip-addresses-detail';
  static const String removeInvalidParenthesesDetail = '/remove-invalid-parentheses-detail';
  static const String maxAverageSubarrayIDetail = '/max-average-subarray-i-detail';
  static const String containsDuplicateIIDetail = '/contains-duplicate-ii-detail';
  static const String defuseTheBombDetail = '/defuse-the-bomb-detail';
  static const String minimumRecolorsDetail = '/minimum-recolors-detail';
  static const String twoSumII = '/two-sum-ii';
  static const String validPalindrome = '/valid-palindrome';
  static const String reverseString = '/reverse-string';
  static const String moveZeroes = '/move-zeroes';
  static const String removeDuplicates = '/remove-duplicates';
  static const String removeDuplicatesII = '/remove-duplicates-ii';
  static const String squaresSortedArray = '/squares-sorted-array';
  static const String mergeSortedArray = '/merge-sorted-array';
  static const String isSubsequence = '/is-subsequence';
  static const String threeSum = '/three-sum';
  static const String threeSumClosest = '/three-sum-closest';
  static const String fourSum = '/four-sum';
  static const String containerWithMostWater = '/container-with-most-water';
  static const String sortColors = '/sort-colors';
  static const String boatsToSavePeople = '/boats-to-save-people';
  static const String partitionLabels = '/partition-labels';
  static const String trappingRainWater = '/trapping-rain-water';
  static const String minWindowSubstring = '/min-window-substring';
  static const String medianTwoSortedArrays = '/median-two-sorted-arrays';
  static const String algorithms = '/algorithms';
  static const String dsa = '/dsa';

  static Map<String, WidgetBuilder> get routes {
    return {
      splash: (context) => const SplashScreen(),
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
      dashboard: (context) => const DashboardScreen(),
      corePatterns: (context) => const CorePatternsScreen(),
      timeSpaceComplexityDetail: (context) => const TimeSpaceComplexityDetailScreen(),
      asymptoticNotations: (context) => const AsymptoticNotationsDetailScreen(),
      complexityClasses: (context) => const ComplexityClassesDetailScreen(),
      spaceComplexity: (context) => const SpaceComplexityDetailScreen(),
      bigORules: (context) => const BigORulesDetailScreen(),
      amortizedComplexity: (context) => const AmortizedComplexityDetailScreen(),
      bestWorstCase: (context) => const BestWorstCaseDetailScreen(),
      twoPointersDetail: (context) => const TwoPointersDetailScreen(),
      recursionBacktrackingDetail: (context) => const RecursionBacktrackingDetailScreen(),
      slidingWindowDetail: (context) => const SlidingWindowDetailScreen(),
      fastSlowPointersDetail: (context) => const FastSlowPointersDetailScreen(),
      mergeIntervalsDetail: (context) => const MergeIntervalsDetailScreen(),
      cyclicSortDetail: (context) => const CyclicSortDetailScreen(),
      inplaceReversalDetail: (context) => const InplaceReversalDetailScreen(),
      treeBfsDetail: (context) => const TreeBfsDetailScreen(),
      treeDfsDetail: (context) => const TreeDfsDetailScreen(),
      twoHeapsDetail: (context) => const TwoHeapsDetailScreen(),
      subsetsBacktrackingDetail: (context) => const SubsetsBacktrackingDetailScreen(),
      modifiedBinarySearchDetail: (context) => const ModifiedBinarySearchDetailScreen(),
      topKElementsDetail: (context) => const TopKElementsDetailScreen(),
      kwayMergeDetail: (context) => const KWayMergeDetailScreen(),
      greedyAlgorithmDetail: (context) => const GreedyAlgorithmDetailScreen(),
      dpDetail: (context) => const DPDetailScreen(),
      topologicalSortDetail: (context) => const TopologicalSortDetailScreen(),
      unionFindDetail: (context) => const UnionFindDetailScreen(),
      graphTraversalDetail: (context) => const GraphTraversalDetailScreen(),
      trieDetail: (context) => const TrieDetailScreen(),
      bitManipulationDetail: (context) => const BitManipulationDetailScreen(),
      monotonicStackDetail: (context) => const MonotonicStackDetailScreen(),
      prefixSumDetail: (context) => const PrefixSumDetailScreen(),
      subsetsDetail: (context) => const SubsetsDetailScreen(),
      combinationSumDetail: (context) => const CombinationSumDetailScreen(),
      generateParenthesesDetail: (context) => const GenerateParenthesesDetailScreen(),
      letterCombinationsDetail: (context) => const LetterCombinationsDetailScreen(),
      permutationsDetail: (context) => const PermutationsDetailScreen(),
      binaryTreePathsDetail: (context) => const BinaryTreePathsDetailScreen(),
      wordSearchDetail: (context) => const WordSearchDetailScreen(),
      subsetsIIDetail: (context) => const SubsetsIIDetailScreen(),
      permutationsIIDetail: (context) => const PermutationsIIDetailScreen(),
      combinationSumIIDetail: (context) => const CombinationSumIIDetailScreen(),
      palindromePartitioningDetail: (context) => const PalindromePartitioningDetailScreen(),
      letterCasePermutationDetail: (context) => const LetterCasePermutationDetailScreen(),
      nQueensDetail: (context) => const NQueensDetailScreen(),
      sudokuSolverDetail: (context) => const SudokuSolverDetailScreen(),
      targetSumDetail: (context) => const TargetSumDetailScreen(),
      restoreIPAddressesDetail: (context) => const RestoreIPAddressesDetailScreen(),
      removeInvalidParenthesesDetail: (context) => const RemoveInvalidParenthesesDetailScreen(),
      maxAverageSubarrayIDetail: (context) => const MaxAverageSubarrayIDetailScreen(),
      containsDuplicateIIDetail: (context) => const ContainsDuplicateIIDetailScreen(),
      defuseTheBombDetail: (context) => const DefuseTheBombDetailScreen(),
      minimumRecolorsDetail: (context) => const MinimumRecolorsDetailScreen(),
      twoSumII: (context) => const TwoSumIIDetailScreen(),
      validPalindrome: (context) => const ValidPalindromeDetailScreen(),
      reverseString: (context) => const ReverseStringDetailScreen(),
      moveZeroes: (context) => const MoveZeroesDetailScreen(),
      removeDuplicates: (context) => const RemoveDuplicatesDetailScreen(),
      removeDuplicatesII: (context) => const RemoveDuplicatesIIDetailScreen(),
      squaresSortedArray: (context) => const SquaresSortedArrayDetailScreen(),
      mergeSortedArray: (context) => const MergeSortedArrayDetailScreen(),
      isSubsequence: (context) => const IsSubsequenceDetailScreen(),
      threeSum: (context) => const ThreeSumDetailScreen(),
      threeSumClosest: (context) => const ThreeSumClosestDetailScreen(),
      fourSum: (context) => const FourSumDetailScreen(),
      containerWithMostWater: (context) => const ContainerWithMostWaterDetailScreen(),
      sortColors: (context) => const SortColorsDetailScreen(),
      boatsToSavePeople: (context) => const BoatsToSavePeopleDetailScreen(),
      partitionLabels: (context) => const PartitionLabelsDetailScreen(),
      trappingRainWater: (context) => const TrappingRainWaterDetailScreen(),
      minWindowSubstring: (context) => const MinWindowSubstringDetailScreen(),
      medianTwoSortedArrays: (context) => const MedianTwoSortedArraysDetailScreen(),
      algorithms: (context) => const AlgorithmsScreen(),
      dsa: (context) => const DsaScreen(),
    };
  }
}
