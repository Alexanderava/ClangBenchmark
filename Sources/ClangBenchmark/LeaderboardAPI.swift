import Foundation

// MARK: - Leaderboard Models

struct LeaderboardEntry: Identifiable, Codable {
    var id: String { UUID().uuidString }
    let name: String; let cpu: String; let cpuCores: Int; let gpuCores: Int
    let score: Double; let klinesPerSec: Double; let osVersion: String
    let clangVersion: String; let timestamp: String; var rank: Int = 0
}

// MARK: - GitHub-backed Leaderboard

class LeaderboardAPI: ObservableObject {
    @Published var entries: [LeaderboardEntry] = []
    @Published var isLoading = false
    @Published var submitStatus: String = ""

    static let shared = LeaderboardAPI()

    // Embedded token — write-only access to clangbench-api repo
    private let defaultToken = ""

    private let readURL  = "https://raw.githubusercontent.com/Alexanderava/clangbench-api/main/leaderboard_data.json"
    private let writeURL = "https://api.github.com/repos/Alexanderava/clangbench-api/contents/leaderboard_data.json"

    private var token: String {
        UserDefaults.standard.string(forKey: "github_pat") ?? defaultToken
    }

    private let cacheURL: URL = {
        let dir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        return dir.appendingPathComponent("ClangBenchmark/leaderboard_cache.json")
    }()

    private var bundledSeedURL: URL? {
        Bundle.main.url(forResource: "leaderboard_seed", withExtension: "json", subdirectory: "Resources")
    }

    // MARK: - Fetch

    func fetchLeaderboard() {
        // Seed cache from bundled data on first launch
        seedCacheIfNeeded()
        // Show cached data immediately, then refresh from network
        loadCache()
        isLoading = true
        // Cache-bust with timestamp to bypass GitHub CDN cache
        let url = URL(string: readURL + "?t=\(Int(Date().timeIntervalSince1970))")!
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                guard let data, error == nil,
                      let decoded = try? JSONDecoder().decode([LeaderboardEntry].self, from: data) else {
                    // Network failed — keep showing cached data, no change needed
                    return
                }
                let ranked = decoded.enumerated().map { i, e in var e = e; e.rank = i + 1; return e }
                self?.entries = ranked
                self?.saveCache(data)
            }
        }.resume()
    }

    // MARK: - Submit

    func submitResult(name: String, cpu: String, cpuCores: Int, gpuCores: Int,
                      score: Double, klinesPerSec: Double, osVersion: String,
                      clangVersion: String) {
        guard !token.isEmpty else {
            submitStatus = "请先设置 GitHub Token"
            return
        }

        submitStatus = L10n.v("leaderboard_submitting")

        // 1. Read current file (get SHA)
        var req = URLRequest(url: URL(string: writeURL)!)
        req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        req.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        req.setValue("2022-11-28", forHTTPHeaderField: "X-GitHub-Api-Version")

        URLSession.shared.dataTask(with: req) { [weak self] data, _, error in
            guard let self, let data,
                  let fileInfo = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let sha = fileInfo["sha"] as? String,
                  let contentB64 = fileInfo["content"] as? String,
                  let content = Data(base64Encoded: contentB64.replacingOccurrences(of: "\n", with: "")),
                  var list = try? JSONDecoder().decode([LeaderboardEntry].self, from: content)
            else {
                DispatchQueue.main.async { self?.submitStatus = L10n.v("leaderboard_failed") }
                return
            }

            // 2. Append + sort + trim
            let entry = LeaderboardEntry(
                name: name, cpu: cpu, cpuCores: cpuCores, gpuCores: gpuCores,
                score: score, klinesPerSec: klinesPerSec, osVersion: osVersion,
                clangVersion: clangVersion, timestamp: ISO8601DateFormatter().string(from: Date())
            )
            list.append(entry)
            list.sort { $0.score > $1.score }
            list = Array(list.prefix(100))

            guard let newData = try? JSONEncoder().encode(list) else {
                DispatchQueue.main.async { self.submitStatus = L10n.v("leaderboard_failed") }
                return
            }
            let b64 = newData.base64EncodedString()

            // 3. PUT updated file
            var putReq = URLRequest(url: URL(string: self.writeURL)!)
            putReq.httpMethod = "PUT"
            putReq.setValue("Bearer \(self.token)", forHTTPHeaderField: "Authorization")
            putReq.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
            putReq.setValue("2022-11-28", forHTTPHeaderField: "X-GitHub-Api-Version")

            let body: [String: Any] = [
                "message": "Add benchmark: \(cpu) - \(String(format: "%.0f", score)) pts",
                "content": b64,
                "sha": sha
            ]
            putReq.httpBody = try? JSONSerialization.data(withJSONObject: body)

            URLSession.shared.dataTask(with: putReq) { [weak self] _, resp, error in
                DispatchQueue.main.async {
                    if let r = resp as? HTTPURLResponse, r.statusCode == 200 || r.statusCode == 201 {
                        self?.submitStatus = L10n.v("leaderboard_submitted")
                        self?.fetchLeaderboard()
                    } else {
                        self?.submitStatus = L10n.v("leaderboard_failed")
                    }
                }
            }.resume()
        }.resume()
    }

    // MARK: - Convenience

    func submitCurrentResult(engine: BenchmarkEngine, macroEngine: RealWorldEngine) {
        let cpuName = engine.cpuName.components(separatedBy: "@").first?.trimmingCharacters(in: .whitespaces) ?? "Unknown"
        submitResult(
            name: cpuName, cpu: cpuName,
            cpuCores: engine.cpuCores, gpuCores: engine.gpuCores,
            score: macroEngine.bestKlinesPerSec * 203.04,
            klinesPerSec: macroEngine.bestKlinesPerSec,
            osVersion: engine.macOSVersion,
            clangVersion: engine.clangShortVersion
        )
    }

    // MARK: - Cache

    private func seedCacheIfNeeded() {
        // If cache file doesn't exist, copy from bundled seed
        guard let seedURL = bundledSeedURL,
              !FileManager.default.fileExists(atPath: cacheURL.path) else { return }
        try? FileManager.default.createDirectory(at: cacheURL.deletingLastPathComponent(), withIntermediateDirectories: true)
        try? FileManager.default.copyItem(at: seedURL, to: cacheURL)
    }

    private func saveCache(_ data: Data) {
        try? FileManager.default.createDirectory(at: cacheURL.deletingLastPathComponent(), withIntermediateDirectories: true)
        try? data.write(to: cacheURL)
    }

    private func loadCache() {
        guard let data = try? Data(contentsOf: cacheURL),
              let decoded = try? JSONDecoder().decode([LeaderboardEntry].self, from: data) else { return }
        entries = decoded.enumerated().map { i, e in var e = e; e.rank = i + 1; return e }
    }
}
