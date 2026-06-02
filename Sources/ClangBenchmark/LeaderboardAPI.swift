import Foundation

// MARK: - Leaderboard Models

struct LeaderboardEntry: Identifiable, Codable {
    var id: String { UUID().uuidString }
    let name: String; let cpu: String; let cpuCores: Int; let gpuCores: Int
    let score: Double; let klinesPerSec: Double; let osVersion: String
    let clangVersion: String; let timestamp: String; var rank: Int = 0
}

// MARK: - GitHub-backed Leaderboard (SSH write, HTTP/CDN read)

class LeaderboardAPI: ObservableObject {
    @Published var entries: [LeaderboardEntry] = []
    @Published var isLoading = false
    @Published var submitStatus: String = ""

    static let shared = LeaderboardAPI()

    private let repoURL = "git@github.com:Alexanderava/clangbench-api.git"
    private let readURL  = "https://raw.githubusercontent.com/Alexanderava/clangbench-api/main/leaderboard_data.json"

    private let cacheURL: URL = {
        let dir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        return dir.appendingPathComponent("ClangBenchmark/leaderboard_cache.json")
    }()

    private let gitDir: URL = {
        let dir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        return dir.appendingPathComponent("ClangBenchmark/clangbench-api")
    }()

    private var bundledSeedURL: URL? {
        if let url = Bundle.main.url(forResource: "leaderboard_seed", withExtension: "json", subdirectory: "Resources") {
            return url
        }
        return Bundle.module.url(forResource: "leaderboard_seed", withExtension: "json")
    }

    // MARK: - Fetch (HTTP CDN + SSH git fallback)

    func fetchLeaderboard() {
        seedCacheIfNeeded()
        loadCache()
        isLoading = true

        // Try HTTP CDN first (fast, no auth)
        let url = URL(string: readURL + "?t=\(Int(Date().timeIntervalSince1970))")!
        var req = URLRequest(url: url, timeoutInterval: 8)
        req.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData

        URLSession.shared.dataTask(with: req) { [weak self] data, _, error in
            if let data, error == nil,
               let decoded = try? JSONDecoder().decode([LeaderboardEntry].self, from: data) {
                DispatchQueue.main.async {
                    self?.isLoading = false
                    let ranked = decoded.enumerated().map { i, e in var e = e; e.rank = i + 1; return e }
                    self?.entries = ranked
                    self?.saveCache(data)
                }
                return
            }
            // HTTP failed → try git clone via SSH
            self?.fetchViaGit()
        }.resume()
    }

    private func fetchViaGit() {
        DispatchQueue.global(qos: .utility).async { [weak self] in
            let (ok, _) = self?.runGit("clone", "--depth", "1", self?.repoURL ?? "", self?.gitDir.path ?? "") ?? (false, "")
            if !ok {
                // Already cloned? Try pull
                _ = self?.runGit("-C", self?.gitDir.path ?? "", "pull", "--depth", "1")
            }
            // Read JSON from cloned repo
            let jsonPath = self?.gitDir.appendingPathComponent("leaderboard_data.json")
            if let path = jsonPath,
               let data = try? Data(contentsOf: path),
               let decoded = try? JSONDecoder().decode([LeaderboardEntry].self, from: data) {
                DispatchQueue.main.async {
                    self?.isLoading = false
                    let ranked = decoded.enumerated().map { i, e in var e = e; e.rank = i + 1; return e }
                    self?.entries = ranked
                    self?.saveCache(data)
                }
            } else {
                DispatchQueue.main.async { self?.isLoading = false }
            }
        }
    }

    // MARK: - Submit (via git push over SSH)

    func submitResult(name: String, cpu: String, cpuCores: Int, gpuCores: Int,
                      score: Double, klinesPerSec: Double, osVersion: String,
                      clangVersion: String) {
        submitStatus = L10n.v("leaderboard_submitting")

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self else { return }

            // 1. Clone or pull latest
            let cloned: Bool
            if FileManager.default.fileExists(atPath: self.gitDir.appendingPathComponent(".git").path) {
                let (ok, _) = self.runGit("-C", self.gitDir.path, "pull", "--depth", "1")
                cloned = ok
            } else {
                let (ok, _) = self.runGit("clone", "--depth", "1", self.repoURL, self.gitDir.path)
                cloned = ok
            }

            guard cloned else {
                DispatchQueue.main.async { self.submitStatus = "上传失败: 网络不通" }
                return
            }

            // 2. Read + update JSON
            let jsonPath = self.gitDir.appendingPathComponent("leaderboard_data.json")
            guard let data = try? Data(contentsOf: jsonPath),
                  var list = try? JSONDecoder().decode([LeaderboardEntry].self, from: data) else {
                DispatchQueue.main.async { self.submitStatus = L10n.v("leaderboard_failed") }
                return
            }

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
            try? newData.write(to: jsonPath)

            // 3. Commit + push
            let msg = "Add benchmark: \(cpu) - \(String(format: "%.0f", score)) pts"
            let (ok1, _) = self.runGit("-C", self.gitDir.path, "add", "leaderboard_data.json")
            let (ok2, _) = self.runGit("-C", self.gitDir.path, "commit", "-m", msg)
            // Commit may fail if no changes (duplicate score) — that's OK
            let (ok3, out3) = self.runGit("-C", self.gitDir.path, "push", "origin", "main")

            DispatchQueue.main.async {
                if ok3 || ok1 {
                    self.submitStatus = L10n.v("leaderboard_submitted")
                    self.fetchLeaderboard()
                } else {
                    self.submitStatus = "上传失败: \(out3.prefix(60))"
                }
            }
        }
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

    // MARK: - Git helper (SSH)

    @discardableResult
    private func runGit(_ args: String...) -> (Bool, String) {
        let p = Process()
        p.executableURL = URL(fileURLWithPath: "/usr/bin/git")
        p.arguments = args
        // Force SSH and suppress prompts
        p.environment = ["GIT_SSH_COMMAND": "ssh -o StrictHostKeyChecking=accept-new -o ConnectTimeout=10",
                         "GIT_TERMINAL_PROMPT": "0"]
        let outPipe = Pipe(); let errPipe = Pipe()
        p.standardOutput = outPipe; p.standardError = errPipe
        var output = Data()
        outPipe.fileHandleForReading.readabilityHandler = { h in
            let d = h.availableData; if d.isEmpty { return }; output.append(d)
        }
        errPipe.fileHandleForReading.readabilityHandler = { h in
            let d = h.availableData; if d.isEmpty { return }; output.append(d)
        }
        try? p.run()
        p.waitUntilExit()
        outPipe.fileHandleForReading.readabilityHandler = nil
        errPipe.fileHandleForReading.readabilityHandler = nil
        let ok = p.terminationStatus == 0
        let text = String(data: output, encoding: .utf8) ?? ""
        return (ok, text)
    }

    // MARK: - Cache

    private func seedCacheIfNeeded() {
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
