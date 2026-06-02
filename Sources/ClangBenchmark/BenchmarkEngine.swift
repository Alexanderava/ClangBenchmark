import Foundation

class BenchmarkEngine: ObservableObject {
    // System info — auto-detected
    @Published var cpuName: String = ""
    @Published var cpuCores: Int = 0
    @Published var gpuCores: Int = 0
    @Published var memorySize: String = ""
    @Published var macOSVersion: String = ""
    @Published var clangVersion: String = ""
    @Published var clangShortVersion: String = ""
    @Published var xcodeVersion: String = ""

    init() {
        fetchSystemInfo()
    }

    private func fetchSystemInfo() {
        // Clang version
        let clangTask = Process()
        clangTask.executableURL = URL(fileURLWithPath: "/usr/bin/clang++")
        clangTask.arguments = ["--version"]
        let clangPipe = Pipe()
        clangTask.standardOutput = clangPipe
        clangTask.standardError = clangPipe
        // Use async read to prevent pipe deadlock
        var clangData = Data()
        clangPipe.fileHandleForReading.readabilityHandler = { h in
            let d = h.availableData; if d.isEmpty { return }; clangData.append(d)
        }
        try? clangTask.run()
        clangTask.waitUntilExit()
        clangPipe.fileHandleForReading.readabilityHandler = nil
        let full = String(data: clangData, encoding: .utf8) ?? ""
        clangVersion = full.components(separatedBy: "\n").first ?? "Unknown"
        if let match = try? NSRegularExpression(pattern: "clang-(\\d+\\.\\d+)").firstMatch(in: full, range: NSRange(full.startIndex..., in: full)) {
            clangShortVersion = "Clang " + String(full[Range(match.range(at: 1), in: full)!])
        } else {
            clangShortVersion = "Apple Clang"
        }

        // macOS version
        let osVersion = ProcessInfo.processInfo.operatingSystemVersion
        macOSVersion = "macOS \(osVersion.majorVersion).\(osVersion.minorVersion)"

        // Xcode version
        let xcTask = Process()
        xcTask.executableURL = URL(fileURLWithPath: "/usr/bin/xcodebuild")
        xcTask.arguments = ["-version"]
        let xcPipe = Pipe()
        xcTask.standardOutput = xcPipe
        xcTask.standardError = xcPipe
        var xcData = Data()
        xcPipe.fileHandleForReading.readabilityHandler = { h in
            let d = h.availableData; if d.isEmpty { return }; xcData.append(d)
        }
        try? xcTask.run()
        xcTask.waitUntilExit()
        xcPipe.fileHandleForReading.readabilityHandler = nil
        if let xcStr = String(data: xcData, encoding: .utf8) {
            xcodeVersion = xcStr.components(separatedBy: "\n").first ?? ""
        }

        // CPU name
        var size = 0
        sysctlbyname("machdep.cpu.brand_string", nil, &size, nil, 0)
        var cpu = [CChar](repeating: 0, count: size)
        sysctlbyname("machdep.cpu.brand_string", &cpu, &size, nil, 0)
        cpuName = String(cString: cpu)

        // CPU cores
        var ncpu: Int32 = 0
        var ncpuLen = MemoryLayout<Int32>.size
        sysctlbyname("hw.ncpu", &ncpu, &ncpuLen, nil, 0)
        cpuCores = Int(ncpu)

        // GPU cores
        let gpuTask = Process()
        gpuTask.executableURL = URL(fileURLWithPath: "/usr/sbin/ioreg")
        gpuTask.arguments = ["-c", "IOAccelerator", "-r"]
        let gpuPipe = Pipe()
        gpuTask.standardOutput = gpuPipe
        gpuTask.standardError = gpuPipe
        var gpuData = Data()
        gpuPipe.fileHandleForReading.readabilityHandler = { h in
            let d = h.availableData; if d.isEmpty { return }; gpuData.append(d)
        }
        try? gpuTask.run()
        gpuTask.waitUntilExit()
        gpuPipe.fileHandleForReading.readabilityHandler = nil
        if let gpuStr = String(data: gpuData, encoding: .utf8) {
            for line in gpuStr.components(separatedBy: "\n") {
                if line.contains("\"gpu-core-count\"") {
                    let num = line.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
                    gpuCores = Int(num) ?? 0
                    break
                }
            }
        }

        // Memory
        var memSize: UInt64 = 0
        var memLen = MemoryLayout<UInt64>.size
        sysctlbyname("hw.memsize", &memSize, &memLen, nil, 0)
        memorySize = String(format: "%.0f GB", Double(memSize) / 1_073_741_824.0)
    }
}
