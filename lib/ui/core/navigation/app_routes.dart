import 'package:flutter/material.dart';
import 'package:algorithmix/ui/features/splash/views/splash_screen.dart';
import 'package:algorithmix/ui/features/auth/views/login_screen.dart';
import 'package:algorithmix/ui/features/auth/views/register_screen.dart';
import 'package:algorithmix/ui/features/dashboard/views/dashboard_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/core_patterns_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/two_pointers_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/two_sum_ii_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/valid_palindrome_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/reverse_string_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/move_zeroes_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/remove_duplicates_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/squares_sorted_array_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/merge_sorted_array_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/is_subsequence_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/three_sum_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/three_sum_closest_detail_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/views/container_with_most_water_detail_screen.dart';
import 'package:algorithmix/ui/features/algorithms/views/algorithms_screen.dart';
import 'package:algorithmix/ui/features/dsa/views/dsa_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String dashboard = '/dashboard';
  static const String corePatterns = '/core-patterns';
  static const String twoPointersDetail = '/two-pointers-detail';
  static const String twoSumII = '/two-sum-ii';
  static const String validPalindrome = '/valid-palindrome';
  static const String reverseString = '/reverse-string';
  static const String moveZeroes = '/move-zeroes';
  static const String removeDuplicates = '/remove-duplicates';
  static const String squaresSortedArray = '/squares-sorted-array';
  static const String mergeSortedArray = '/merge-sorted-array';
  static const String isSubsequence = '/is-subsequence';
  static const String threeSum = '/three-sum';
  static const String threeSumClosest = '/three-sum-closest';
  static const String containerWithMostWater = '/container-with-most-water';
  static const String algorithms = '/algorithms';
  static const String dsa = '/dsa';

  static Map<String, WidgetBuilder> get routes {
    return {
      splash: (context) => const SplashScreen(),
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
      dashboard: (context) => const DashboardScreen(),
      corePatterns: (context) => const CorePatternsScreen(),
      twoPointersDetail: (context) => const TwoPointersDetailScreen(),
      twoSumII: (context) => const TwoSumIIDetailScreen(),
      validPalindrome: (context) => const ValidPalindromeDetailScreen(),
      reverseString: (context) => const ReverseStringDetailScreen(),
      moveZeroes: (context) => const MoveZeroesDetailScreen(),
      removeDuplicates: (context) => const RemoveDuplicatesDetailScreen(),
      squaresSortedArray: (context) => const SquaresSortedArrayDetailScreen(),
      mergeSortedArray: (context) => const MergeSortedArrayDetailScreen(),
      isSubsequence: (context) => const IsSubsequenceDetailScreen(),
      threeSum: (context) => const ThreeSumDetailScreen(),
      threeSumClosest: (context) => const ThreeSumClosestDetailScreen(),
      containerWithMostWater: (context) => const ContainerWithMostWaterDetailScreen(),
      algorithms: (context) => const AlgorithmsScreen(),
      dsa: (context) => const DsaScreen(),
    };
  }
}

