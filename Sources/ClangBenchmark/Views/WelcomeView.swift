import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var engine: BenchmarkEngine
    let onStart: () -> Void
    let onLeaderboard: () -> Void
    @State private var isHovering = false
    @State private var lbHovering = false
    @State private var appear = false

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                Spacer()

                ZStack {
                    Circle()
                        .fill(LinearGradient(
                            colors: [Color(red: 0.35, green: 0.60, blue: 0.90),
                                     Color(red: 0.20, green: 0.40, blue: 0.75)],
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        ))
                        .frame(width: 80, height: 80)
                        .shadow(color: .blue.opacity(0.25), radius: 20, y: 8)

                    Image(systemName: "building.2.fill")
                        .font(.system(size: 30, weight: .medium))
                        .foregroundColor(.white)
                }
                .scaleEffect(appear ? 1 : 0.5)
                .opacity(appear ? 1 : 0)

                Spacer().frame(height: 24)

                VStack(spacing: 6) {
                    Text(L10n.v("app_title"))
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundStyle(LinearGradient(
                            colors: [Color(red: 0.15, green: 0.30, blue: 0.55),
                                     Color(red: 0.25, green: 0.50, blue: 0.75)],
                            startPoint: .leading, endPoint: .trailing
                        ))

                    Text(L10n.v("app_subtitle"))
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.black.opacity(0.45))
                }
                .opacity(appear ? 1 : 0)
                .offset(y: appear ? 0 : 10)

                Spacer().frame(height: 36)

                // System info cards
                HStack(spacing: 16) {
                    InfoCard(icon: "cpu", title: L10n.v("processor"), value: cpuShortName, unit: "\(engine.cpuCores)+\(engine.gpuCores) \(L10n.v("cores_unit"))")
                    InfoCard(icon: "memorychip", title: L10n.v("memory"), value: engine.memorySize, unit: "")
                    InfoCard(icon: "hammer", title: L10n.v("toolchain"), value: engine.clangShortVersion, unit: engine.xcodeVersion)
                }
                .opacity(appear ? 1 : 0)
                .offset(y: appear ? 0 : 15)

                Spacer().frame(height: 30)

                // Start button
                Button(action: {
                    NSHapticFeedbackManager.defaultPerformer.perform(.alignment, performanceTime: .now)
                    onStart()
                }) {
                    HStack(spacing: 10) {
                        Image(systemName: "play.fill").font(.system(size: 16, weight: .semibold))
                        Text(L10n.v("start_test")).font(.system(size: 17, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 36).padding(.vertical, 14)
                    .background(
                        ZStack {
                            RoundedRectangle(cornerRadius: 18)
                                .fill(LinearGradient(
                                    colors: [Color(red: 0.35, green: 0.60, blue: 0.90),
                                             Color(red: 0.22, green: 0.45, blue: 0.80)],
                                    startPoint: .topLeading, endPoint: .bottomTrailing
                                ))
                            RoundedRectangle(cornerRadius: 18).fill(.white.opacity(isHovering ? 0.2 : 0))
                        }
                    )
                    .overlay(RoundedRectangle(cornerRadius: 18).stroke(.white.opacity(0.4), lineWidth: 1))
                    .shadow(color: .blue.opacity(0.3), radius: 12, y: 5)
                }
                .buttonStyle(.plain)
                .scaleEffect(isHovering ? 1.03 : 1.0)
                .onHover { hovering in withAnimation(.easeOut(duration: 0.2)) { isHovering = hovering } }
                .opacity(appear ? 1 : 0)
                .offset(y: appear ? 0 : 20)

                // Leaderboard button
                Button(action: onLeaderboard) {
                    HStack(spacing: 6) {
                        Image(systemName: "trophy.fill").font(.system(size: 12))
                        Text(L10n.v("leaderboard")).font(.system(size: 13, weight: .medium))
                    }
                    .foregroundColor(.black.opacity(lbHovering ? 0.6 : 0.4))
                    .padding(.horizontal, 20).padding(.vertical, 10)
                    .background(RoundedRectangle(cornerRadius: 14)
                        .fill(.white.opacity(lbHovering ? 0.4 : 0.2))
                        .background(.ultraThinMaterial).clipShape(RoundedRectangle(cornerRadius: 14)))
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(.white.opacity(0.4), lineWidth: 0.8))
                }
                .buttonStyle(.plain)
                .onHover { lbHovering = $0 }
                .opacity(appear ? 1 : 0)
                .offset(y: appear ? 0 : 25)
                .padding(.top, 16)

                Spacer()
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .padding(.vertical, 30)
        }
        .onAppear {
            withAnimation(.spring(response: 0.7, dampingFraction: 0.7).delay(0.1)) { appear = true }
        }
    }

    var cpuShortName: String {
        let name = engine.cpuName
        if name.contains("M2") { return "M2 Max" }
        if name.contains("M3") { return "M3" }
        if name.contains("M1") { return "M1" }
        if name.contains("M4") { return "M4" }
        return name.components(separatedBy: "@").first?.trimmingCharacters(in: .whitespaces) ?? name
    }
}

struct InfoCard: View {
    let icon: String
    let title: String
    let value: String
    let unit: String

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.accentBlue)
                .frame(width: 36, height: 36)
                .background(Circle().fill(.white.opacity(0.4)).background(.ultraThinMaterial).clipShape(Circle()))
                .overlay(Circle().stroke(.white.opacity(0.6), lineWidth: 1))

            Text(title)
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.black.opacity(0.35))
                .tracking(1.5)

            Text(value)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(.black.opacity(0.7))

            Text(unit)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.black.opacity(0.35))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .smallGlassCard()
    }
}
