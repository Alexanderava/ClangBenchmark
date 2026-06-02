import SwiftUI

enum AppPhase {
    case welcome
    case benchmarking
    case results
    case leaderboard
}

struct ContentView: View {
    @EnvironmentObject var engine: BenchmarkEngine
    @StateObject private var realEngine = RealWorldEngine()
    @State private var phase: AppPhase = .welcome

    var body: some View {
        ZStack {
            GlassBackground()

            VStack(spacing: 0) {
                switch phase {
                case .welcome:
                    WelcomeView {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                            phase = .benchmarking
                            realEngine.startBuild()
                        }
                    } onLeaderboard: {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                            phase = .leaderboard
                        }
                    }

                case .benchmarking:
                    TitleBar(phase: phase) {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                            phase = .welcome
                        }
                    }
                    MacroBenchmarkView {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                            phase = .results
                        }
                    } onCancel: {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                            phase = .welcome
                        }
                    }
                    .environmentObject(realEngine)

                case .results:
                    ResultView {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                            phase = .benchmarking
                            realEngine.startBuild()
                        }
                    } onHome: {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                            phase = .welcome
                        }
                    }
                    .environmentObject(engine)
                    .environmentObject(realEngine)

                case .leaderboard:
                    LeaderboardView {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                            phase = .welcome
                        }
                    }
                    .environmentObject(engine)
                    .environmentObject(realEngine)
                }
            }
            .transition(.opacity.combined(with: .scale(scale: 0.96)))
        }
    }
}

struct TitleBar: View {
    let phase: AppPhase
    let onHome: () -> Void

    var body: some View {
        HStack {
            if phase != .welcome {
                Button(action: onHome) {
                    Image(systemName: "house.fill")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.blue.opacity(0.7))
                        .frame(width: 28, height: 28)
                        .background(.white.opacity(0.4))
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
                .padding(.leading, 16)
            } else {
                Spacer().frame(width: 44)
            }

            Spacer()

            Text("Clang Benchmark")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.black.opacity(0.55))

            Spacer()
            Spacer().frame(width: 44)
        }
        .frame(height: 44)
    }
}

struct GlassBackground: View {
    var body: some View {
        ZStack {
            LinearGradient(
                stops: [
                    .init(color: Color(red: 0.91, green: 0.96, blue: 1.0), location: 0),
                    .init(color: Color(red: 0.82, green: 0.92, blue: 0.99), location: 0.3),
                    .init(color: Color(red: 0.75, green: 0.88, blue: 0.98), location: 0.6),
                    .init(color: Color(red: 0.80, green: 0.94, blue: 1.0), location: 1),
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            Circle()
                .fill(RadialGradient(colors: [.white.opacity(0.6), .clear], center: .center, startRadius: 0, endRadius: 180))
                .frame(width: 360, height: 360).offset(x: -200, y: -100).blur(radius: 30)

            Circle()
                .fill(RadialGradient(colors: [Color.blue.opacity(0.15), .clear], center: .center, startRadius: 0, endRadius: 200))
                .frame(width: 400, height: 400).offset(x: 250, y: 200).blur(radius: 40)

            GlassGrid().opacity(0.03)
        }
        .ignoresSafeArea()
    }
}

struct GlassGrid: View {
    var body: some View {
        Canvas { context, size in
            let step: CGFloat = 40
            var x: CGFloat = 0
            while x < size.width {
                var path = Path()
                path.move(to: CGPoint(x: x, y: 0))
                path.addLine(to: CGPoint(x: x, y: size.height))
                context.stroke(path, with: .color(.black), lineWidth: 0.5)
                x += step
            }
            var y: CGFloat = 0
            while y < size.height {
                var path = Path()
                path.move(to: CGPoint(x: 0, y: y))
                path.addLine(to: CGPoint(x: size.width, y: y))
                context.stroke(path, with: .color(.black), lineWidth: 0.5)
                y += step
            }
        }
    }
}
