#include <type_traits>
#include <iostream>
#include <cstdint>

template<uint64_t N>
struct Factorial {
    static constexpr uint64_t value = N * Factorial<N - 1>::value;
};
template<>
struct Factorial<0> { static constexpr uint64_t value = 1; };

template<uint64_t N>
struct Fibonacci {
    static constexpr uint64_t value = Fibonacci<N - 1>::value + Fibonacci<N - 2>::value;
};
template<>
struct Fibonacci<0> { static constexpr uint64_t value = 0; };
template<>
struct Fibonacci<1> { static constexpr uint64_t value = 1; };

template<uint64_t Base, uint64_t Exp>
struct Power {
    static constexpr uint64_t value = Base * Power<Base, Exp - 1>::value;
};
template<uint64_t Base>
struct Power<Base, 0> { static constexpr uint64_t value = 1; };

template<typename T>
struct AddConstRef { using type = const T&; };
template<typename T>
struct AddPointer { using type = T*; };
template<typename T>
struct RemoveCV { using type = typename std::remove_cv<T>::type; };

template<typename T>
struct ComplexTransform {
    using step1 = typename AddConstRef<T>::type;
    using step2 = typename AddPointer<step1>::type;
    using step3 = typename RemoveCV<step2>::type;
    using type = step3;
};

template<typename... Args>
struct VariadicSum;
template<typename T, typename... Rest>
struct VariadicSum<T, Rest...> {
    static constexpr int64_t value = T::value + VariadicSum<Rest...>::value;
};
template<>
struct VariadicSum<> { static constexpr int64_t value = 0; };

template<typename T>
struct HasValueType {
    template<typename U> static std::true_type test(typename U::value_type*);
    template<typename U> static std::false_type test(...);
    static constexpr bool value = decltype(test<T>(nullptr))::value;
};

int main() {
    constexpr auto fact20 = Factorial<20>::value;
    constexpr auto fib30 = Fibonacci<30>::value;
    constexpr auto powVal = Power<2, 40>::value;

    std::cout << "Factorial(20) = " << fact20 << std::endl;
    std::cout << "Fibonacci(30) = " << fib30 << std::endl;
    std::cout << "2^40 = " << powVal << std::endl;
    std::cout << "HasValueType<int>: " << HasValueType<int>::value << std::endl;

    return 0;
}
