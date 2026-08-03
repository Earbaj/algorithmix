# Algorithmix 🚀
> **The Ultimate Interactive Data Structures, Algorithms & 25 Core Patterns Platform for FAANG Interviews**

Algorithmix is a modern, high-performance Flutter application designed to help developers master Data Structures, Algorithms, and the **25 Core Algorithmic Patterns** required to crack technical interviews at top-tech companies like Google, Meta, Amazon, and Microsoft.

Featuring an **interactive line-by-line C++ debugger visualizer**, **bilingual support (English & Bangla)**, dynamic dark-cyber aesthetics, and responsive cross-platform layout scaling.

---

## ✨ Key Features

### 🧠 1. Interactive C++ Line-by-Line Debugger Visualizer
- **Granular Execution Stepping**: Step forward/backward through every line of code including `while` loop conditions, `if-else` branch evaluations, and variable mutations.
- **Real-Time Pointer Tracking**: Dynamic visual array representation highlighting pointer indices (`left`, `right`, `slow`, `fast`, `i (fixed)`) with live color-coded indicators.
- **Multiple Pattern Templates**: Pre-loaded interactive visualizations for:
  1. *Opposite Direction Pointers* (e.g. Two Sum II)
  2. *Same Direction Pointers* (e.g. Move Zeroes in-place swap)
  3. *Fixed + Two Pointers* (e.g. 3Sum Triplets)

### 📚 2. 25 Core Algorithmic Patterns Catalog
Comprehensive coverage of all 25 fundamental coding interview patterns:
1. Time & Space Complexity (Big-O Notation)
2. Basic Data Structures (Arrays, Linked Lists, Hash Tables)
3. Recursion & Backtracking Basics
4. Two Pointers (Deep Dive & Visualizer)
5. Sliding Window
6. Fast & Slow Pointers (Floyd's Cycle Detection)
7. Merge Intervals
8. Cyclic Sort
9. In-place Reversal of Linked List
10. Tree BFS (Level Order Traversal)
11. Tree DFS (Preorder/Inorder/Postorder)
12. Two Heaps
13. Subsets / Backtracking
14. Modified Binary Search
15. Top K Elements (Heap)
16. K-way Merge
17. Greedy Algorithms
18. Dynamic Programming (DP ⭐ Most Important & Feared)
19. Topological Sort (Graph)
20. Union Find (Disjoint Set)
21. Graph Traversal (BFS/DFS)
22. Trie (Prefix Tree)
23. Bit Manipulation
24. Monotonic Stack
25. Prefix Sum

### 🌐 3. Bilingual Concept Explanation (English 🇬🇧 & Bangla 🇧🇩)
- Seamless one-tap language switching across conceptual summaries, standard C++ boilerplate templates, common interview pitfalls, and practice roadmaps.

### 🏢 4. Categorized FAANG Interview Problem Bank
Problems categorized into 🟢 **Easy**, 🟡 **Medium**, and 🔴 **Hard** tiers featuring:
- Target company tags (Meta, Google, Amazon, Microsoft, Apple, Bloomberg, Uber).
- Key intuitive approach summaries in both English & Bangla.
- ⭐ Highlighted high-frequency interview questions (e.g., *Trapping Rain Water*, *3Sum*, *Container With Most Water*).

### 🎨 5. Multi-Device Cyber Dark UI & Responsiveness
- Scalable typography and dynamic padding calculated via viewport-relative utilities (`Responsive.sp`, `Responsive.horizontalPadding`).
- Adaptive multi-column grid layouts (`SliverGridDelegateWithMaxCrossAxisExtent`) for desktop and tablet displays, seamlessly adapting to a single-column layout on mobile devices.

---

## 🛠️ Tech Stack & Architecture

- **Framework**: [Flutter SDK](https://flutter.dev) (Dart 3.x)
- **Architecture**: Clean Feature-First Layered Architecture (`domain/`, `data/`, `ui/core/`, `ui/features/`)
- **Design System**: Custom Cyber Dark Theme tokens (`AppTheme`) with glassmorphism effects and neon accent palettes.

```
lib/
├── data/
│   └── repositories/      # Seeded pattern and DSA data sources
├── domain/
│   └── models/            # Core entities (PatternModel, TwoPointersData, etc.)
├── main.dart              # Application entrypoint
└── ui/
    ├── core/
    │   ├── navigation/    # AppRoutes central registry
    │   ├── theme/         # Cyber Dark theme tokens and styling
    │   └── utils/         # Responsive breakpoint utilities
    └── features/
        ├── auth/          # Login & Register views
        ├── core_patterns/ # Core 25 Patterns grid, detail modals & C++ Visualizer
        ├── dashboard/     # Main dashboard with category navigation
        ├── splash/        # Animated initial landing screen
        ├── algorithms/    # Algorithms catalog
        └── dsa/           # Data Structures catalog
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (v3.19.0 or higher)
- Dart SDK (v3.3.0 or higher)

### Setup & Run
```bash
# Clone repository
git clone https://github.com/username/algorithmix.git

# Navigate into project directory
cd algorithmix

# Install dependencies
flutter pub get

# Run on available device or web browser
flutter run
```

---

## 💡 Code Example (C++ Two Pointers Template)

```cpp
// Template 1: Opposite Direction Two Pointers (C++)
#include <vector>
using namespace std;

vector<int> twoSum(vector<int>& arr, int target) {
    int left = 0, right = arr.size() - 1;
    while (left < right) {
        int curr_sum = arr[left] + arr[right];
        if (curr_sum == target) {
            return {left, right}; // Match found
        } else if (curr_sum < target) {
            left++;   // Increase total sum
        } else {
            right--;  // Decrease total sum
        }
    }
    return {-1, -1};
}
```

---

## 📝 License

Distributed under the MIT License. See `LICENSE` for more information.
