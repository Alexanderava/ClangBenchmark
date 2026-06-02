import SwiftUI

@main
struct ClangBenchmarkApp: App {
    @StateObject private var engine = BenchmarkEngine()

    init() {
        L10n.load()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(engine)
                .frame(minWidth: 760, idealWidth: 900, minHeight: 560, idealHeight: 700)
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentMinSize)
        .defaultSize(width: 900, height: 700)
    }
}
