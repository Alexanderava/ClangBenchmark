#include <iostream>
#include <vector>
#include <string>
#include <algorithm>
#include <numeric>
#include <map>
#include <set>
#include <unordered_map>
#include <unordered_set>
#include <functional>
#include <memory>
#include <tuple>
#include <optional>
#include <variant>
#include <any>
#include <string_view>
#include <array>
#include <list>
#include <deque>
#include <forward_list>
#include <queue>
#include <stack>
#include <bitset>
#include <valarray>
#include <complex>
#include <random>
#include <chrono>
#include <thread>
#include <mutex>
#include <atomic>
#include <condition_variable>
#include <future>
#include <type_traits>
#include <typeindex>
#include <typeinfo>
#include <utility>
#include <initializer_list>
#include <iterator>
#include <limits>
#include <climits>
#include <cfloat>
#include <cstdint>
#include <cstdlib>
#include <cstring>
#include <cmath>
#include <new>
#include <exception>
#include <stdexcept>

#define DECLARE_STRUCT(n) \
    struct TestStruct_##n { \
        int field_##n = n; \
        double value_##n = n * 3.14159; \
        std::string name_##n = "struct_" #n; \
        auto get() const { return field_##n + value_##n; } \
    };

DECLARE_STRUCT(1)
DECLARE_STRUCT(2)
DECLARE_STRUCT(3)
DECLARE_STRUCT(4)
DECLARE_STRUCT(5)
DECLARE_STRUCT(6)
DECLARE_STRUCT(7)
DECLARE_STRUCT(8)
DECLARE_STRUCT(9)
DECLARE_STRUCT(10)
DECLARE_STRUCT(11)
DECLARE_STRUCT(12)
DECLARE_STRUCT(13)
DECLARE_STRUCT(14)
DECLARE_STRUCT(15)
DECLARE_STRUCT(16)
DECLARE_STRUCT(17)
DECLARE_STRUCT(18)
DECLARE_STRUCT(19)
DECLARE_STRUCT(20)

#define PRINT_VALUE(n) \
    std::cout << "Value " #n ": " << TestStruct_##n().get() << std::endl;

int main() {
    std::cout << "Header chain benchmark" << std::endl;

    PRINT_VALUE(1)
    PRINT_VALUE(2)
    PRINT_VALUE(3)
    PRINT_VALUE(4)
    PRINT_VALUE(5)
    PRINT_VALUE(6)
    PRINT_VALUE(7)
    PRINT_VALUE(8)
    PRINT_VALUE(9)
    PRINT_VALUE(10)
    PRINT_VALUE(11)
    PRINT_VALUE(12)
    PRINT_VALUE(13)
    PRINT_VALUE(14)
    PRINT_VALUE(15)
    PRINT_VALUE(16)
    PRINT_VALUE(17)
    PRINT_VALUE(18)
    PRINT_VALUE(19)
    PRINT_VALUE(20)

    std::vector<int> v = {1, 2, 3, 4, 5};
    std::map<std::string, double> m;
    std::set<int> s(v.begin(), v.end());
    std::unordered_map<int, std::string> um;
    std::optional<int> opt = 42;
    std::variant<int, double, std::string> var = "hello";
    std::any a = 3.14;

    for (int i = 0; i < 1000; ++i) {
        m["key_" + std::to_string(i)] = i * 1.5;
        um[i] = "val_" + std::to_string(i);
    }

    std::cout << "Map size: " << m.size() << std::endl;
    std::cout << "Unordered map size: " << um.size() << std::endl;
    std::cout << "Optional: " << *opt << std::endl;

    return 0;
}
