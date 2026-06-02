#include <iostream>
#include <vector>
#include <map>
#include <set>
#include <unordered_map>
#include <algorithm>
#include <numeric>
#include <string>
#include <random>
#include <functional>
#include <iterator>
#include <list>
#include <deque>
#include <queue>
#include <memory>
#include <chrono>
#include <iomanip>
#include <cmath>
#include <tuple>

struct DataPoint {
    int64_t id;
    double value;
    std::string label;
    std::vector<double> features;

    bool operator<(const DataPoint& other) const { return id < other.id; }
};

int main() {
    constexpr int N = 50000;
    std::mt19937 rng(42);
    std::uniform_real_distribution<double> dist(0.0, 1000.0);

    std::vector<DataPoint> data;
    data.reserve(N);
    for (int i = 0; i < N; ++i) {
        data.push_back({i, dist(rng), "point_" + std::to_string(i), {dist(rng), dist(rng), dist(rng)}});
    }

    std::sort(data.begin(), data.end(), [](const auto& a, const auto& b) {
        return a.value > b.value;
    });

    std::map<int64_t, double> valueMap;
    for (const auto& d : data) {
        valueMap[d.id] = d.value;
    }

    std::unordered_map<std::string, int64_t> labelIndex;
    for (const auto& d : data) {
        labelIndex[d.label] = d.id;
    }

    std::set<int64_t> idSet;
    for (const auto& d : data) {
        idSet.insert(d.id);
    }
    auto lower = idSet.lower_bound(N / 2);
    auto upper = idSet.upper_bound(N * 3 / 4);

    std::vector<double> transformed;
    transformed.reserve(N);
    std::transform(data.begin(), data.end(), std::back_inserter(transformed),
        [](const auto& d) { return std::sqrt(d.value) * std::log(d.value + 1); });

    double sum = std::accumulate(transformed.begin(), transformed.end(), 0.0);
    double avg = sum / transformed.size();

    std::priority_queue<std::pair<double, int64_t>> pq;
    for (const auto& d : data) {
        pq.push({d.value, d.id});
    }

    auto found = std::find_if(data.begin(), data.end(),
        [](const auto& d) { return d.value > 999.0; });

    auto count = std::count_if(data.begin(), data.end(),
        [avg](const auto& d) { return d.value > avg; });

    std::partial_sort(data.begin(), data.begin() + 100, data.end(),
        [](const auto& a, const auto& b) { return a.value < b.value; });

    std::cout << "Sum: " << sum << std::endl;
    std::cout << "Average: " << avg << std::endl;
    std::cout << "Count above avg: " << count << std::endl;
    std::cout << "Top PQ: " << pq.top().first << std::endl;

    return 0;
}
