#include <iostream>
#include <vector>
#include <cmath>
#include <algorithm>
#include <random>
#include <numeric>
#include <chrono>

inline double kernel1(double x, double y) {
    double sum = 0.0;
    for (int i = 0; i < 100; ++i) {
        sum += std::sin(x * (i + 1) * 0.01) * std::cos(y * (i + 1) * 0.01);
        sum += std::exp(-std::abs(x - y) * 0.001) * std::log(std::abs(x + y) + 1);
    }
    return sum;
}

inline double kernel2(const std::vector<double>& a, const std::vector<double>& b) {
    double dot = 0.0;
    for (size_t i = 0; i < a.size(); ++i) {
        dot += a[i] * b[i];
    }
    return dot / static_cast<double>(a.size());
}

inline void matrixMultiply(const std::vector<double>& A,
                            const std::vector<double>& B,
                            std::vector<double>& C, int N) {
    for (int i = 0; i < N; ++i) {
        for (int k = 0; k < N; ++k) {
            double aik = A[i * N + k];
            for (int j = 0; j < N; ++j) {
                C[i * N + j] += aik * B[k * N + j];
            }
        }
    }
}

inline double mandelbrot(double cx, double cy, int maxIter) {
    double x = 0.0, y = 0.0;
    for (int i = 0; i < maxIter; ++i) {
        double x2 = x * x, y2 = y * y;
        if (x2 + y2 > 4.0) return static_cast<double>(i);
        y = 2.0 * x * y + cy;
        x = x2 - y2 + cx;
        if (x2 + y2 > 16.0) break;
    }
    return static_cast<double>(maxIter);
}

inline double monteCarloPi(int samples) {
    std::mt19937 rng(12345);
    std::uniform_real_distribution<double> dist(-1.0, 1.0);
    int inside = 0;
    for (int i = 0; i < samples; ++i) {
        double x = dist(rng), y = dist(rng);
        if (x * x + y * y <= 1.0) inside++;
    }
    return 4.0 * inside / samples;
}

int main() {
    constexpr int N = 200;
    constexpr int SAMPLES = 50000;

    std::vector<double> A(N * N), B(N * N), C(N * N, 0.0);
    std::mt19937 rng(42);
    std::uniform_real_distribution<double> dist(0.0, 1.0);
    for (int i = 0; i < N * N; ++i) {
        A[i] = dist(rng);
        B[i] = dist(rng);
    }
    matrixMultiply(A, B, C, N);

    double ksum = 0.0;
    for (int i = 0; i < 100; ++i) {
        ksum += kernel1(static_cast<double>(i), static_cast<double>(i + 1));
    }

    double msum = 0.0;
    for (int i = 0; i < 50; ++i) {
        for (int j = 0; j < 50; ++j) {
            msum += mandelbrot(-2.0 + i * 0.05, -1.5 + j * 0.05, 200);
        }
    }

    double pi = monteCarloPi(SAMPLES);

    double dot = kernel2(A, B);

    std::cout << "Matrix C[0] = " << C[0] << std::endl;
    std::cout << "Kernel sum = " << ksum << std::endl;
    std::cout << "Mandelbrot sum = " << msum << std::endl;
    std::cout << "Pi estimate = " << pi << std::endl;
    std::cout << "Dot product = " << dot << std::endl;

    return 0;
}
