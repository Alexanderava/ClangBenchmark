import SwiftUI

// MARK: - Result View: CORES / SCORE / COMPILE SPEED

struct ResultView: View {
    @EnvironmentObject var engine: BenchmarkEngine
    @EnvironmentObject var macroEngine: RealWorldEngine
    let onRetry: () -> Void
    let onHome: () -> Void
    @State private var appear = false
    @State private var retryHovering = false
    @State private var homeHovering = false

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                Spacer().frame(height: 16)

                // ── SYSTEM INFO (TOP) ──
                HStack(spacing: 10) {
                    systemChip(icon: "cpu", text: engine.cpuName.components(separatedBy: "@").first?.trimmingCharacters(in: .whitespaces) ?? "")
                    systemChip(icon: "memorychip", text: engine.memorySize)
                    systemChip(icon: "apple.logo", text: engine.macOSVersion)
                    systemChip(icon: "hammer", text: engine.clangShortVersion)
                }
                .padding(.horizontal, 24)
                .opacity(appear ? 1 : 0)

                Spacer().frame(height: 20)

                // ── THREE BIG METRICS ──
                HStack(spacing: 14) {
                    MetricCard(
                        label: L10n.v("cores_label"),
                        value: "\(engine.cpuCores)+\(engine.gpuCores)",
                        unit: L10n.v("cores_unit"),
                        subtitle: String(format: L10n.v("cpu_gpu"), engine.gpuCores) + " · " + cpuLabel,
                        icon: "cpu", color: .purple,
                        progress: min(1.0, Double(engine.cpuCores) / 32.0)
                    )

                    MetricCard(
                        label: L10n.v("score_label"),
                        value: scoreValue,
                        unit: L10n.v("score_unit"),
                        subtitle: scoreLabel,
                        icon: "chart.bar.fill", color: scoreColorValue,
                        progress: scoreProgress
                    )

                    MetricCard(
                        label: L10n.v("speed_label"),
                        value: speedValue,
                        unit: L10n.v("speed_unit"),
                        subtitle: String(format: L10n.v("subtitle_lines"), totalLines / 1000),
                        icon: "bolt.fill", color: .orange,
                        progress: speedProgress
                    )
                }
                .padding(.horizontal, 24)
                .opacity(appear ? 1 : 0)
                .scaleEffect(appear ? 1 : 0.92)

                // ── SCORE FORMULA ──
                Text(L10n.v("score_formula"))
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.black.opacity(0.3))
                    .padding(.top, 8)
                    .opacity(appear ? 1 : 0)

                Spacer().frame(height: 24)

                // ── DETAIL BREAKDOWN ──
                if let musl = macroEngine.bestMusl, let lua = macroEngine.bestLua {
                    VStack(spacing: 10) {
                        ProjectScoreRow(
                            index: 1, name: "musl libc 1.2.5",
                            score: musl.compileDurationMs,
                            maxScore: max(musl.compileDurationMs + lua.compileDurationMs, 1),
                            detail: "\(musl.fileCount) files",
                            subtitle: musl.buildSteps.map {
                                "\($0.phase.rawValue) \(String(format: "%.0f", $0.durationMs))ms"
                            }.joined(separator: " → "),
                            animate: appear
                        ).padding(.horizontal, 28)

                        ProjectScoreRow(
                            index: 2, name: "Lua 5.4.7 + musl",
                            score: lua.compileDurationMs,
                            maxScore: max(musl.compileDurationMs + lua.compileDurationMs, 1),
                            detail: "\(lua.fileCount) files",
                            subtitle: "static musl libc",
                            animate: appear
                        ).padding(.horizontal, 28)
                    }
                    .opacity(appear ? 1 : 0)
                    .offset(y: appear ? 0 : 15)
                }

                Spacer().frame(height: 18)

                // ── ACTIONS ──
                HStack(spacing: 14) {
                    Button(action: onHome) {
                        HStack(spacing: 5) {
                            Image(systemName: "house").font(.system(size: 12))
                            Text(L10n.v("home")).font(.system(size: 13, weight: .medium))
                        }
                        .foregroundColor(.black.opacity(0.55))
                        .padding(.horizontal, 18).padding(.vertical, 9)
                        .background(RoundedRectangle(cornerRadius: 12)
                            .fill(.white.opacity(homeHovering ? 0.45 : 0.25))
                            .background(.ultraThinMaterial).clipShape(RoundedRectangle(cornerRadius: 12)))
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(.white.opacity(0.5), lineWidth: 0.8))
                    }
                    .buttonStyle(.plain).onHover { homeHovering = $0 }

                    Button(action: onRetry) {
                        HStack(spacing: 5) {
                            Image(systemName: "arrow.clockwise").font(.system(size: 12, weight: .semibold))
                            Text(L10n.v("retry")).font(.system(size: 13, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 18).padding(.vertical, 9)
                        .background(RoundedRectangle(cornerRadius: 12)
                            .fill(LinearGradient(colors: [Color.accentBlue, Color.deepBlue], startPoint: .topLeading, endPoint: .bottomTrailing)))
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(.white.opacity(0.4), lineWidth: 0.8))
                        .shadow(color: .blue.opacity(0.2), radius: 8, y: 3)
                    }
                    .buttonStyle(.plain)
                    .scaleEffect(retryHovering ? 1.03 : 1.0)
                    .onHover { h in withAnimation(.easeOut(duration: 0.15)) { retryHovering = h } }
                }
                .opacity(appear ? 1 : 0)

                Spacer().frame(height: 20)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.7, dampingFraction: 0.7).delay(0.1)) { appear = true }
        }
    }

    // MARK: - Subviews

    func systemChip(icon: String, text: String) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon).font(.system(size: 10))
            Text(text).font(.system(size: 11, weight: .medium))
        }
        .foregroundColor(.black.opacity(0.45))
        .padding(.horizontal, 10).padding(.vertical, 6)
        .background(Capsule().fill(.white.opacity(0.25)).background(.ultraThinMaterial).clipShape(Capsule()))
        .overlay(Capsule().stroke(.white.opacity(0.3), lineWidth: 0.8))
    }

    // MARK: - Computed Metrics

    var cpuLabel: String {
        if engine.cpuCores >= 16 { return L10n.v("workstation") }
        if engine.cpuCores >= 8 { return L10n.v("high_perf") }
        return L10n.v("normal")
    }

    var totalLines: Int {
        (macroEngine.bestMusl?.lineCount ?? 0) + (macroEngine.bestLua?.lineCount ?? 0)
    }

    var totalCompileMs: Double {
        (macroEngine.bestMusl?.compileDurationMs ?? 0) + (macroEngine.bestLua?.compileDurationMs ?? 0)
    }

    var klinesPerSec: Double {
        macroEngine.bestKlinesPerSec
    }

    var totalScore: Double { klinesPerSec * 203.04 }

    var scoreValue: String { String(format: "%.0f", totalScore) }
    var scoreUnit: String { L10n.v("score_unit") }

    var scoreLabel: String {
        if totalScore >= 10000 { return L10n.v("flagship") }
        if totalScore >= 5000 { return L10n.v("high_perf") }
        if totalScore >= 2000 { return L10n.v("good") }
        return L10n.v("normal")
    }

    var scoreColorValue: Color {
        if totalScore >= 8000 { return .green }
        if totalScore >= 4000 { return .orange }
        return .red
    }

    var scoreProgress: Double { min(1.0, totalScore / 20000.0) }

    var speedValue: String { String(format: "%.1f", klinesPerSec) }
    var speedUnit: String { L10n.v("speed_unit") }
    var speedProgress: Double { min(1.0, klinesPerSec / 100.0) }
}

// MARK: - Metric Card

struct MetricCard: View {
    let label: String; let value: String; let unit: String
    let subtitle: String; let icon: String; let color: Color; let progress: Double
    @State private var animProgress: Double = 0

    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 5) {
                Image(systemName: icon).font(.system(size: 11, weight: .semibold)).foregroundColor(color)
                Text(label).font(.system(size: 10, weight: .bold)).foregroundColor(.black.opacity(0.35)).tracking(1.2)
            }
            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text(value).font(.system(size: 28, weight: .bold, design: .rounded)).foregroundColor(.black.opacity(0.75))
                Text(unit).font(.system(size: 12, weight: .medium)).foregroundColor(.black.opacity(0.3))
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(.black.opacity(0.06)).frame(height: 4)
                    Capsule()
                        .fill(LinearGradient(colors: [color.opacity(0.8), color], startPoint: .leading, endPoint: .trailing))
                        .frame(width: geo.size.width * animProgress, height: 4)
                        .animation(.easeOut(duration: 1.2).delay(0.4), value: animProgress)
                }
            }
            .frame(height: 4).padding(.horizontal, 2)
            Text(subtitle).font(.system(size: 10, weight: .medium)).foregroundColor(.black.opacity(0.35)).lineLimit(1)
        }
        .padding(.vertical, 16).padding(.horizontal, 12)
        .frame(maxWidth: .infinity)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 18).fill(.white.opacity(0.25))
                RoundedRectangle(cornerRadius: 18).fill(.ultraThinMaterial)
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay(RoundedRectangle(cornerRadius: 18)
            .stroke(LinearGradient(colors: [.white.opacity(0.7), color.opacity(0.12)], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1)
        )
        .shadow(color: color.opacity(0.06), radius: 8, y: 3)
        .onAppear { animProgress = progress }
    }
}

// MARK: - Project Score Row

struct ProjectScoreRow: View {
    let index: Int; let name: String; let score: Double
    let maxScore: Double; let detail: String; let subtitle: String; let animate: Bool

    var body: some View {
        VStack(spacing: 6) {
            HStack {
                Text("\(index)").font(.system(size: 11, weight: .bold, design: .monospaced))
                    .foregroundColor(.black.opacity(0.25)).frame(width: 16)
                VStack(alignment: .leading, spacing: 1) {
                    Text(name).font(.system(size: 13, weight: .semibold)).foregroundColor(.black.opacity(0.65))
                    Text(subtitle).font(.system(size: 10)).foregroundColor(.black.opacity(0.3)).lineLimit(1)
                }
                Spacer()
                Text(String(format: "%.0f ms", score))
                    .font(.system(size: 15, weight: .bold, design: .monospaced)).foregroundColor(.black.opacity(0.7))
                Text(detail)
                    .font(.system(size: 10, weight: .medium, design: .monospaced)).foregroundColor(.black.opacity(0.3))
                    .frame(width: 50, alignment: .trailing)
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(.black.opacity(0.05)).frame(height: 6)
                    Capsule()
                        .fill(barColor)
                        .frame(width: max(3, geo.size.width * (animate ? score / maxScore : 0)), height: 6)
                        .animation(.easeOut(duration: 1.0).delay(0.3 + Double(index) * 0.15), value: animate)
                }
            }
            .frame(height: 6)
        }
        .padding(.vertical, 8).padding(.horizontal, 14)
        .background(RoundedRectangle(cornerRadius: 12).fill(.white.opacity(0.1))
            .background(.ultraThinMaterial.opacity(0.4)).clipShape(RoundedRectangle(cornerRadius: 12)))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(.white.opacity(0.3), lineWidth: 0.5))
    }

    var barColor: Color {
        let ratio = score / maxScore
        if ratio < 0.3 { return .green }; if ratio < 0.7 { return .orange }; return .accentBlue
    }
}
