import Foundation

struct BuildStepResult { let phase: BuildPhase; let durationMs: Double; let outputLines: Int }
enum BuildPhase: String { case download="下载", extract="解压", configure="配置", compile="编译" }

struct RealWorldResult {
    let projectName: String; let description: String
    let fileCount: Int; let lineCount: Int
    let buildSteps: [BuildStepResult]
    var compileDurationMs: Double { buildSteps.filter { $0.phase == .compile }.map(\.durationMs).reduce(0, +) }
}

// MARK: - Engine

class RealWorldEngine: ObservableObject {
    @Published var phase = ""; @Published var progress: Double = 0
    @Published var isRunning = false; @Published var logLines: [String] = []

    // Multi-run results
    @Published var bestMusl: RealWorldResult?; @Published var bestLua: RealWorldResult?
    @Published var roundScores: [Double] = []      // Klines/sec per measured round
    @Published var bestKlinesPerSec: Double = 0
    @Published var currentRound = 0; @Published var totalMeasuredRounds = 3
    private var isCancelled = false

    private let cacheDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        .appendingPathComponent("ClangBenchmark/sources")
    private let muslURL = "https://musl.libc.org/releases/musl-1.2.5.tar.gz"
    private let luaURL = "https://www.lua.org/ftp/lua-5.4.7.tar.gz"
    private let muslV = "musl-1.2.5"; private let luaV = "lua-5.4.7"
    private var downloadDone = false

    // Cached source line counts (counted once in warmup)
    private var muslLineCount = 0; private var luaLineCount = 0

    func startBuild() {
        guard !isRunning else { return }
        isRunning = true; bestMusl = nil; bestLua = nil
        roundScores = []; bestKlinesPerSec = 0; logLines = []; progress = 0
        downloadDone = false; currentRound = 0; isCancelled = false

        log("🚀 Clang 编译基准 · 1 预热 + \(totalMeasuredRounds) 轮实测")
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in self?.runAllRounds() }
    }

    func cancelBuild() {
        isCancelled = true
        isRunning = false
        phase = "已取消"
        log("⏹ 用户取消")
    }

    private func runAllRounds() {
        // ── Round 0: Warmup ──
        updatePhase("预热", 0.02); currentRound = 0
        log("\n🔥 预热轮 (不计分)")

        let warmDir = makeWorkDir()
        let (wMusl, wLua) = buildAll(workDir: warmDir, logDetails: false)
        if let m = wMusl, let l = wLua { muslLineCount = m.lineCount; luaLineCount = l.lineCount }
        try? FileManager.default.removeItem(at: warmDir)
        downloadDone = true
        guard !isCancelled else { finishCancelled(); return }
        log("   ✅ 预热完成")

        // ── Measured rounds ──
        var bestKL = 0.0; var bestMuslR: RealWorldResult?; var bestLuaR: RealWorldResult?
        roundScores = []

        for r in 1...totalMeasuredRounds {
            guard !isCancelled else { break }
            currentRound = r
            updatePhase("第 \(r)/\(totalMeasuredRounds) 轮", Double(r)/Double(totalMeasuredRounds+1) * 0.9 + 0.1)
            log("\n📊 第 \(r)/\(totalMeasuredRounds) 轮")

            let workDir = makeWorkDir()
            let (muslR, luaR) = buildAll(workDir: workDir, logDetails: true)

            if let m = muslR, let l = luaR {
                let totalMs = m.compileDurationMs + l.compileDurationMs
                let totalLines = m.lineCount + l.lineCount
                let kls = totalMs > 0 ? Double(totalLines) / totalMs : 0
                roundScores.append(kls)

                log(String(format: "   ⏱ 编译耗时: %.0f ms · %.1f Klines/s", totalMs, kls))

                if kls > bestKL {
                    bestKL = kls; bestMuslR = m; bestLuaR = l
                    log("   🏆 新最优!")
                }
            } else {
                roundScores.append(0)
            }

            try? FileManager.default.removeItem(at: workDir)
        }

        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            if self.isCancelled { self.finishCancelled(); return }
            self.bestMusl = bestMuslR; self.bestLua = bestLuaR
            self.bestKlinesPerSec = bestKL
            self.phase = "完成"; self.progress = 1.0; self.isRunning = false
            self.log("\n✅ 基准测试完成 · 最优: \(String(format: "%.1f", bestKL)) Klines/s")
        }
    }

    private func finishCancelled() {
        isRunning = false; phase = "已取消"
        if bestKlinesPerSec == 0 { progress = 0 }
    }

    private func buildAll(workDir: URL, logDetails: Bool) -> (RealWorldResult?, RealWorldResult?) {
        updatePhase("musl libc", progress + 0.05)
        if logDetails { log("\n═══ musl libc ═══") }
        let installDir = workDir.appendingPathComponent("musl-install")
        let m = buildMusl(workDir: workDir, installDir: installDir, logDetails: logDetails)

        updatePhase("Lua + musl", progress + 0.3)
        if logDetails { log("\n═══ Lua 5.4.7 + musl ═══") }
        let l = buildLua(workDir: workDir, muslInstallDir: installDir, logDetails: logDetails)

        return (m, l)
    }

    private func buildMusl(workDir: URL, installDir: URL, logDetails: Bool) -> RealWorldResult? {
        var steps: [BuildStepResult] = []
        let muslSrc = workDir.appendingPathComponent(muslV)
        var compileFailed = false

        // Download (only first time)
        if !downloadDone {
            updatePhase("下载 musl…", progress)
            if logDetails { log("📥 下载 musl...") }
            let (ms, _) = downloadIfNeeded(url: muslURL, filename: "musl-1.2.5.tar.gz")
            steps.append(BuildStepResult(phase: .download, durationMs: ms, outputLines: 0))
            if logDetails { log(String(format: "   ✅ %.0f ms", ms)) }
        } else {
            steps.append(BuildStepResult(phase: .download, durationMs: 0, outputLines: 0))
        }

        // Always extract from cache to fresh workDir
        updatePhase("解压 musl…", progress)
        let (_, tarball) = downloadIfNeeded(url: muslURL, filename: "musl-1.2.5.tar.gz")
        if logDetails { log("📦 解压...") }
        let exMs = timeBlock { run("tar", "xzf", tarball.path, "-C", workDir.path) }
        steps.append(BuildStepResult(phase: .extract, durationMs: exMs, outputLines: 0))
        if logDetails { log(String(format: "   ✅ %.0f ms", exMs)) }

        // Configure
        updatePhase("配置 musl…", progress)
        if logDetails { log("⚙️  configure...") }
        let cfgMs = timeBlock { run("sh", "./configure", "--prefix=\(installDir.path)", "--disable-shared", currentDir: muslSrc.path) }
        steps.append(BuildStepResult(phase: .configure, durationMs: cfgMs, outputLines: 0))
        if !FileManager.default.fileExists(atPath: muslSrc.appendingPathComponent("config.mak").path) {
            compileFailed = true
            if logDetails { log("   ❌ configure 失败") }
        } else if logDetails { log(String(format: "   ✅ %.0f ms", cfgMs)) }

        // Build
        let cpu = ProcessInfo.processInfo.activeProcessorCount
        updatePhase("编译 musl (make -j\(cpu))…", progress)
        if logDetails { log("🔨 make -j\(cpu)...") }
        let cmpMs = compileFailed ? 0 : timeBlock { run("make", "-j\(cpu)", currentDir: muslSrc.path) }
        steps.append(BuildStepResult(phase: .compile, durationMs: cmpMs, outputLines: 0))
        if compileFailed {
            if logDetails { log("   ⚠️ 跳过(configure 失败)") }
        } else {
            run("make", "install", currentDir: muslSrc.path)
            if logDetails { log(String(format: "   ✅ %.0f ms", cmpMs)) }
        }

        let fc = countCFiles(in: muslSrc)
        let lc = downloadDone ? muslLineCount : countLines(in: muslSrc)
        if !downloadDone { muslLineCount = lc }
        if logDetails { log("   📊 \(fc) 文件 · \(lc) 行") }

        return RealWorldResult(projectName: "musl libc 1.2.5", description: "轻量级 C 标准库", fileCount: fc, lineCount: lc, buildSteps: steps)
    }

    private func buildLua(workDir: URL, muslInstallDir: URL, logDetails: Bool) -> RealWorldResult? {
        var steps: [BuildStepResult] = []
        let luaSrc = workDir.appendingPathComponent(luaV)

        // Download (only first time)
        if !downloadDone {
            updatePhase("下载 Lua…", progress)
            if logDetails { log("📥 下载 Lua...") }
            let (ms, _) = downloadIfNeeded(url: luaURL, filename: "lua-5.4.7.tar.gz")
            steps.append(BuildStepResult(phase: .download, durationMs: ms, outputLines: 0))
            if logDetails { log(String(format: "   ✅ %.0f ms", ms)) }
        } else {
            steps.append(BuildStepResult(phase: .download, durationMs: 0, outputLines: 0))
        }

        // Always extract from cache to fresh workDir
        updatePhase("解压 Lua…", progress)
        let (_, tarball) = downloadIfNeeded(url: luaURL, filename: "lua-5.4.7.tar.gz")
        let exMs = timeBlock { run("tar", "xzf", tarball.path, "-C", workDir.path) }
        steps.append(BuildStepResult(phase: .extract, durationMs: exMs, outputLines: 0))
        if logDetails { log(String(format: "   ✅ %.0f ms", exMs)) }

        let cpu = ProcessInfo.processInfo.activeProcessorCount
        updatePhase("编译 Lua (make -j\(cpu))…", progress)
        let inc = "\(muslInstallDir.path)/include"; let lib = "\(muslInstallDir.path)/lib"
        if logDetails { log("🔨 make linux (CC=clang + musl)...") }
        let cmpMs = timeBlock {
            runEnv(["CC":"clang -static -I\(inc)", "MYLIBS":"-L\(lib)"], "make", "linux", "-j\(cpu)", currentDir: luaSrc.path)
        }
        steps.append(BuildStepResult(phase: .compile, durationMs: cmpMs, outputLines: 0))
        if logDetails { log(String(format: "   ✅ %.0f ms", cmpMs)) }

        let fc = countCFiles(in: luaSrc)
        let lc = downloadDone ? luaLineCount : countLines(in: luaSrc)
        if !downloadDone { luaLineCount = lc }
        if logDetails { log("   📊 \(fc) 文件 · \(lc) 行") }

        return RealWorldResult(projectName: "Lua 5.4.7 + musl", description: "静态链接 musl libc", fileCount: fc, lineCount: lc, buildSteps: steps)
    }

    // MARK: - Helpers

    private func makeWorkDir() -> URL {
        let d = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("CB_\(UUID().uuidString.prefix(6))")
        try? FileManager.default.createDirectory(at: d, withIntermediateDirectories: true)
        return d
    }

    private func downloadIfNeeded(url: String, filename: String) -> (Double, URL) {
        try? FileManager.default.createDirectory(at: cacheDir, withIntermediateDirectories: true)
        let cached = cacheDir.appendingPathComponent(filename)
        if FileManager.default.fileExists(atPath: cached.path) { return (0, cached) }
        let start = CFAbsoluteTimeGetCurrent()
        run("curl", "-sL", "--connect-timeout", "15", "--max-time", "120", "-o", cached.path, url, timeout: 130)
        return ((CFAbsoluteTimeGetCurrent()-start)*1000, cached)
    }

    private func countCFiles(in dir: URL) -> Int {
        guard let e = FileManager.default.enumerator(at: dir, includingPropertiesForKeys: nil) else { return 0 }
        var c = 0; for case let f as URL in e { if f.pathExtension=="c"||f.pathExtension=="h" { c+=1 } }; return c
    }

    private func countLines(in dir: URL) -> Int {
        guard let e = FileManager.default.enumerator(at: dir, includingPropertiesForKeys: nil) else { return 0 }
        var t = 0; for case let f as URL in e {
            let ext = f.pathExtension
            if ext=="c"||ext=="h"||ext=="cpp"||ext=="hpp" {
                if let s = try? String(contentsOf: f, encoding: .utf8) { t += s.components(separatedBy:"\n").count }
            }
        }; return t
    }

    private func run(_ args: String..., currentDir: String? = nil, timeout: TimeInterval = 300) -> String {
        let p = Process(); p.executableURL = URL(fileURLWithPath: "/usr/bin/env"); p.arguments = args
        if let d = currentDir { p.currentDirectoryURL = URL(fileURLWithPath: d) }
        let pipe = Pipe(); p.standardOutput = pipe; p.standardError = pipe
        try? p.run()
        let deadline = DispatchTime.now() + timeout
        let semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.global().async { p.waitUntilExit(); semaphore.signal() }
        if semaphore.wait(timeout: deadline) == .timedOut {
            p.terminate()
            DispatchQueue.main.async { [weak self] in self?.logLines.append("⚠️ 超时: \(args.joined(separator: " "))") }
        }
        return String(data: pipe.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8) ?? ""
    }

    private func runEnv(_ env: [String:String], _ args: String..., currentDir: String?, timeout: TimeInterval = 300) -> String {
        let p = Process(); p.executableURL = URL(fileURLWithPath: "/usr/bin/env"); p.arguments = args
        p.environment = { var e = ProcessInfo.processInfo.environment; for (k,v) in env { e[k]=v }; return e }()
        if let d = currentDir { p.currentDirectoryURL = URL(fileURLWithPath: d) }
        let pipe = Pipe(); p.standardOutput = pipe; p.standardError = pipe
        try? p.run()
        let deadline = DispatchTime.now() + timeout
        let semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.global().async { p.waitUntilExit(); semaphore.signal() }
        if semaphore.wait(timeout: deadline) == .timedOut {
            p.terminate()
            DispatchQueue.main.async { [weak self] in self?.logLines.append("⚠️ 超时: make") }
        }
        return String(data: pipe.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8) ?? ""
    }

    private func timeBlock(_ block: () -> Void) -> Double {
        let s = CFAbsoluteTimeGetCurrent(); block(); return (CFAbsoluteTimeGetCurrent()-s)*1000
    }

    private func updatePhase(_ p: String, _ prog: Double) {
        DispatchQueue.main.async { [weak self] in self?.phase = p; self?.progress = prog }
    }

    private func log(_ msg: String) {
        DispatchQueue.main.async { [weak self] in self?.logLines.append(msg) }
    }
}
