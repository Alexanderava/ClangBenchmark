import Foundation

// MARK: - Localization helper — auto-detects system language, loads JSON

struct L10n {
    private static var dict: [String: String] = [:]
    static var currentLang: String = "en"

    static func load() {
        let preferred = Locale.preferredLanguages.first ?? "en"
        let langCode: String

        if preferred.hasPrefix("zh-Hant") || preferred.hasPrefix("zh-HK") || preferred.hasPrefix("zh-TW") {
            langCode = "zh-Hant"
        } else if preferred.hasPrefix("zh") {
            langCode = "zh-Hans"
        } else if preferred.hasPrefix("ja") {
            langCode = "ja"
        } else if preferred.hasPrefix("ko") {
            langCode = "ko"
        } else {
            langCode = "en"
        }

        currentLang = langCode

        // Try Bundle.module first (SPM dev build), then Bundle.main (packaged .app)
        var url: URL?
        url = Bundle.module.url(forResource: langCode, withExtension: "json", subdirectory: "l10n")
        if url == nil {
            url = Bundle.main.url(forResource: langCode, withExtension: "json", subdirectory: "l10n")
        }

        guard let url, let data = try? Data(contentsOf: url),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: String]
        else {
            print("[L10n] failed to load \(langCode), tried module + main bundle")
            return
        }
        dict = json
        print("[L10n] loaded \(langCode) — \(dict.count) keys")
    }

    static func v(_ key: String) -> String {
        dict[key] ?? key
    }

    static func f(_ key: String, _ args: CVarArg...) -> String {
        String(format: v(key), arguments: args)
    }
}
