// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ClangBenchmark",
    platforms: [.macOS(.v14)],
    targets: [
        .executableTarget(
            name: "ClangBenchmark",
            path: "Sources/ClangBenchmark",
            resources: [
                .copy("TestSources"),
                .copy("l10n")
            ]
        )
    ]
)
