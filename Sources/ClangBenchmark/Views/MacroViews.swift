import SwiftUI

struct MacroBenchmarkView: View {
    @EnvironmentObject var macroEngine: RealWorldEngine
    let onComplete: () -> Void
    let onCancel: () -> Void
    @State private var cancelHovering = false

    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 12)

            VStack(spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(L10n.v("build_test"))
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundColor(.black.opacity(0.75))
                        Text(macroEngine.currentRound == 0 ? L10n.v("warmup") : L10n.f("round_of", macroEngine.currentRound, macroEngine.totalMeasuredRounds))
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.black.opacity(0.4))
                    }

                    Spacer()

                    Button(action: {
                        macroEngine.cancelBuild()
                        onCancel()
                    }) {
                        HStack(spacing: 5) {
                            Image(systemName: "xmark").font(.system(size: 11, weight: .bold))
                            Text(L10n.v("cancel")).font(.system(size: 13, weight: .medium))
                        }
                        .foregroundColor(.black.opacity(0.5))
                        .padding(.horizontal, 14).padding(.vertical, 7)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.white.opacity(cancelHovering ? 0.5 : 0.25))
                                .background(.ultraThinMaterial).clipShape(RoundedRectangle(cornerRadius: 10))
                        )
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(.white.opacity(0.5), lineWidth: 0.8))
                    }
                    .buttonStyle(.plain)
                    .onHover { cancelHovering = $0 }
                }

                // Progress bar
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 5).fill(.white.opacity(0.3)).frame(height: 8)
                        RoundedRectangle(cornerRadius: 5)
                            .fill(LinearGradient(colors: [Color.accentBlue, Color.deepBlue], startPoint: .leading, endPoint: .trailing))
                            .frame(width: geo.size.width * macroEngine.progress, height: 8)
                            .animation(.easeInOut(duration: 0.5), value: macroEngine.progress)
                    }
                }
                .frame(height: 8)
            }
            .padding(.horizontal, 32).padding(.vertical, 20)
            .glassCard(padding: 0, cornerRadius: 22)
            .padding(.horizontal, 28)

            Spacer().frame(height: 20)

            // Build phases overview
            VStack(spacing: 12) {
                BuildStepView(
                    icon: "square.stack.3d.down.right",
                    title: "musl libc 1.2.5 + Lua 5.4.7",
                    subtitle: "1 预热 + \(macroEngine.totalMeasuredRounds) 轮实测取最优",
                    status: macroEngine.isRunning ? .running : .pending
                )

                // Round scores as they come in
                if !macroEngine.roundScores.isEmpty {
                    Divider().padding(.horizontal, 28).opacity(0.3)
                    Text("各轮得分")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.black.opacity(0.4))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 28)

                    ForEach(Array(macroEngine.roundScores.enumerated()), id: \.offset) { i, score in
                        HStack(spacing: 12) {
                            Circle()
                                .fill(score == macroEngine.bestKlinesPerSec ? Color.green : Color.black.opacity(0.15))
                                .frame(width: 8, height: 8)
                            Text("第 \(i + 1) 轮")
                                .font(.system(size: 13))
                                .foregroundColor(.black.opacity(0.55))
                            Spacer()
                            Text(String(format: "%.1f Klines/s", score))
                                .font(.system(size: 13, weight: .medium, design: .monospaced))
                                .foregroundColor(score == macroEngine.bestKlinesPerSec ? .green : .black.opacity(0.5))
                            if score == macroEngine.bestKlinesPerSec {
                                Text("🏆").font(.system(size: 12))
                            }
                        }
                        .padding(.horizontal, 28)
                    }
                }
            }
            .padding(24)
            .glassCard(padding: 0, cornerRadius: 18)
            .padding(.horizontal, 28)

            Spacer().frame(height: 12)

            // Log output
            if !macroEngine.logLines.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    ScrollViewReader { proxy in
                        ScrollView(showsIndicators: false) {
                            VStack(alignment: .leading, spacing: 2) {
                                ForEach(Array(macroEngine.logLines.enumerated()), id: \.offset) { _, msg in
                                    Text(msg)
                                        .font(.system(size: 11, design: .monospaced))
                                        .foregroundColor(.black.opacity(0.5))
                                }
                            }
                            .padding(10)
                        }
                        .frame(height: 140)
                        .glassCard(padding: 0, cornerRadius: 14)
                        .onChange(of: macroEngine.logLines.count) { _, _ in
                            if let last = macroEngine.logLines.last {
                                withAnimation { proxy.scrollTo(last, anchor: .bottom) }
                            }
                        }
                    }
                }
                .padding(.horizontal, 28)
            }

            Spacer()
        }
        .onChange(of: macroEngine.isRunning) { _, running in
            if !running && macroEngine.progress >= 1.0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { onComplete() }
            }
        }
    }
}

enum StepStatus {
    case pending, running, complete
}

struct BuildStepView: View {
    let icon: String
    let title: String
    let subtitle: String
    let status: StepStatus

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(statusColor.opacity(0.15))
                    .frame(width: 36, height: 36)

                Group {
                    switch status {
                    case .pending:
                        Image(systemName: icon).font(.system(size: 15)).foregroundColor(.black.opacity(0.25))
                    case .running:
                        ProgressView().scaleEffect(0.7)
                    case .complete:
                        Image(systemName: "checkmark").font(.system(size: 13, weight: .bold)).foregroundColor(.green)
                    }
                }
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.system(size: 14, weight: .semibold)).foregroundColor(.black.opacity(0.7))
                Text(subtitle).font(.system(size: 12)).foregroundColor(.black.opacity(0.4))
            }
            Spacer()
        }
        .padding(.horizontal, 28)
    }

    var statusColor: Color {
        switch status {
        case .pending: return .gray
        case .running: return .accentBlue
        case .complete: return .green
        }
    }
}

