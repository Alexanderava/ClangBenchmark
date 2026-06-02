import SwiftUI

struct LeaderboardView: View {
    @EnvironmentObject var engine: BenchmarkEngine
    @EnvironmentObject var macroEngine: RealWorldEngine
    @StateObject private var api = LeaderboardAPI.shared
    let onHome: () -> Void
    @State private var appear = false
    @State private var homeHover = false

    var body: some View {
        GeometryReader { geo in
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            HStack(spacing: 8) {
                                Text(L10n.v("leaderboard_title"))
                                    .font(.system(size: 26, weight: .bold, design: .rounded))
                                    .foregroundColor(.black.opacity(0.75))
                                // Refresh button
                                Button(action: { withAnimation { api.fetchLeaderboard() } }) {
                                    Image(systemName: "arrow.clockwise")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.black.opacity(0.4))
                                }
                                .buttonStyle(.plain)
                                .scaleEffect(api.isLoading ? 0.8 : 1)
                                .animation(api.isLoading ? Animation.easeInOut(duration: 0.3).repeatForever(autoreverses: true) : .default, value: api.isLoading)
                            }
                            Text(L10n.v("app_subtitle"))
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.black.opacity(0.4))
                        }
                        Spacer()
                        Button(action: onHome) {
                            HStack(spacing: 6) {
                                Image(systemName: "house.fill").font(.system(size: 12))
                                Text(L10n.v("home")).font(.system(size: 13, weight: .medium))
                            }
                            .foregroundColor(.black.opacity(0.5))
                            .padding(.horizontal, 14).padding(.vertical, 7)
                            .background(RoundedRectangle(cornerRadius: 10)
                                .fill(.white.opacity(homeHover ? 0.5 : 0.25))
                                .background(.ultraThinMaterial).clipShape(RoundedRectangle(cornerRadius: 10)))
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(.white.opacity(0.5), lineWidth: 0.8))
                        }
                        .buttonStyle(.plain)
                        .onHover { homeHover = $0 }
                    }
                    .padding(.horizontal, 28).padding(.top, 20)

                    // Submit current result
                    if let _ = macroEngine.bestMusl, macroEngine.bestKlinesPerSec > 0 {
                        Spacer().frame(height: 16)
                        submitCard
                            .padding(.horizontal, 28)
                    }

                    Spacer().frame(height: 20)

                    // System info
                    HStack(spacing: 12) {
                        miniBadge(icon: "cpu", text: "\(engine.cpuName.components(separatedBy: "@").first?.trimmingCharacters(in: .whitespaces) ?? "")")
                        miniBadge(icon: "memorychip", text: engine.memorySize)
                        miniBadge(icon: "apple.logo", text: engine.macOSVersion)
                    }
                    .padding(.horizontal, 28)

                    Spacer().frame(height: 20)

                    // Leaderboard list
                    if api.isLoading && api.entries.isEmpty {
                        ProgressView().padding(40)
                    } else if api.entries.isEmpty {
                        emptyView
                            .padding(.horizontal, 28)
                    } else {
                        leaderboardList
                            .padding(.horizontal, 20)
                    }

                    Spacer().frame(height: 30)
                }
                .frame(minWidth: geo.size.width, minHeight: geo.size.height)
            }
        }
        .opacity(appear ? 1 : 0)
        .onAppear {
            withAnimation(.easeOut(duration: 0.4)) { appear = true }
            api.fetchLeaderboard()
        }
    }

    // MARK: Subviews

    var submitCard: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 3) {
                Text(String(format: "%.1f Klines/s · %.0f %@", macroEngine.bestKlinesPerSec,
                            macroEngine.bestKlinesPerSec * 203.04, L10n.v("score_unit")))
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(.black.opacity(0.7))
                Text(api.submitStatus.isEmpty ? "提交本次结果到排行榜" : api.submitStatus)
                    .font(.system(size: 11))
                    .foregroundColor(api.submitStatus == L10n.v("leaderboard_submitted") ? .green : .black.opacity(0.4))
            }
            Spacer()
            if api.submitStatus.isEmpty || api.submitStatus == L10n.v("leaderboard_failed") {
                Button(action: {
                    api.submitCurrentResult(engine: engine, macroEngine: macroEngine)
                }) {
                    Image(systemName: "paperplane.fill").font(.system(size: 14))
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Circle().fill(Color.accentBlue))
                }
                .buttonStyle(.plain)
            } else {
                Circle().fill(api.submitStatus == L10n.v("leaderboard_submitted") ? Color.green : Color.gray)
                    .frame(width: 28, height: 28)
                    .overlay(Image(systemName: api.submitStatus == L10n.v("leaderboard_submitted") ? "checkmark" : "ellipsis")
                        .font(.system(size: 12, weight: .bold)).foregroundColor(.white))
            }
        }
        .padding(16)
        .glassCard(padding: 0, cornerRadius: 14)
    }

    var emptyView: some View {
        VStack(spacing: 16) {
            Image(systemName: "trophy.fill").font(.system(size: 40)).foregroundColor(.gray.opacity(0.3))
            Text(L10n.v("leaderboard_empty"))
                .font(.system(size: 15))
                .foregroundColor(.black.opacity(0.35))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 50)
        .glassCard(padding: 0, cornerRadius: 18)
    }

    var leaderboardList: some View {
        VStack(spacing: 10) {
            // Header
            HStack(spacing: 0) {
                Text(L10n.v("leaderboard_rank")).frame(width: 40, alignment: .leading)
                Text("CPU").frame(maxWidth: .infinity, alignment: .leading)
                Text("CORES").frame(width: 48, alignment: .center)
                Text("SCORE").frame(width: 66, alignment: .trailing)
                Text("SPEED").frame(width: 68, alignment: .trailing)
            }
            .font(.system(size: 10, weight: .bold))
            .foregroundColor(.black.opacity(0.25))
            .padding(.horizontal, 14).padding(.vertical, 6)

            ForEach(api.entries) { entry in
                LeaderboardRow(entry: entry)
            }
        }
    }

    func miniBadge(icon: String, text: String) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon).font(.system(size: 10))
            Text(text).font(.system(size: 11, weight: .medium))
        }
        .foregroundColor(.black.opacity(0.45))
        .padding(.horizontal, 10).padding(.vertical, 6)
        .background(Capsule().fill(.white.opacity(0.3)).background(.ultraThinMaterial).clipShape(Capsule()))
        .overlay(Capsule().stroke(.white.opacity(0.4), lineWidth: 0.8))
    }
}

struct LeaderboardRow: View {
    let entry: LeaderboardEntry

    var body: some View {
        HStack(spacing: 0) {
            // Rank
            ZStack {
                if entry.rank <= 3 {
                    Circle().fill(rankColor).frame(width: 24, height: 24)
                    Text("\(entry.rank)").font(.system(size: 11, weight: .bold)).foregroundColor(.white)
                } else {
                    Text("\(entry.rank)").font(.system(size: 11, weight: .medium, design: .monospaced))
                        .foregroundColor(.black.opacity(0.3))
                }
            }
            .frame(width: 44, alignment: .leading)

            // CPU
            VStack(alignment: .leading, spacing: 1) {
                Text(entry.cpu).font(.system(size: 13, weight: .semibold)).foregroundColor(.black.opacity(0.7)).lineLimit(1)
                Text(entry.osVersion).font(.system(size: 9)).foregroundColor(.black.opacity(0.25))
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            // CORES
            Text("\(entry.cpuCores)+\(entry.gpuCores)")
                .font(.system(size: 11, weight: .medium, design: .rounded))
                .foregroundColor(.purple.opacity(0.7))
                .frame(width: 48, alignment: .center)

            // SCORE
            Text(entry.score >= 10000 ? String(format: "%.0fK", entry.score / 1000) : String(format: "%.0f", entry.score))
                .font(.system(size: 13, weight: .bold, design: .rounded))
                .foregroundColor(.black.opacity(0.7))
                .frame(width: 66, alignment: .trailing)

            // SPEED
            Text(String(format: "%.1f", entry.klinesPerSec))
                .font(.system(size: 10, weight: .medium, design: .monospaced))
                .foregroundColor(.black.opacity(0.4))
                .frame(width: 68, alignment: .trailing)
        }
        .padding(.horizontal, 14).padding(.vertical, 10)
        .background(RoundedRectangle(cornerRadius: 10)
            .fill(.white.opacity(entry.rank <= 3 ? 0.22 : 0.08))
            .background(.ultraThinMaterial.opacity(0.5)).clipShape(RoundedRectangle(cornerRadius: 10)))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(.white.opacity(0.25), lineWidth: 0.6))
    }

    var rankColor: Color {
        switch entry.rank {
        case 1: return Color(red: 1, green: 0.75, blue: 0.1)   // gold
        case 2: return Color(red: 0.7, green: 0.7, blue: 0.75)  // silver
        case 3: return Color(red: 0.8, green: 0.5, blue: 0.3)   // bronze
        default: return .gray
        }
    }
}
