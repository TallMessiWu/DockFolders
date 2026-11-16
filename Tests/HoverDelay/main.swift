import AppKit

// Isolate the actual FolderPrefs implementation from the app's event monitors and Dock.
final class FolderHover { static let shared = FolderHover(); func update() {} }
enum DockGeometry {
    static let tileSize: CGFloat? = nil
    static let dockMagnifies = false
    static let defaultFolderGrowth: CGFloat = 0.1
}

let defaults = UserDefaults.standard
let previousArguments = defaults.volatileDomain(forName: UserDefaults.argumentDomain)
defer { defaults.setVolatileDomain(previousArguments, forName: UserDefaults.argumentDomain) }

func checkStored(_ value: Any, expected: Double) {
    // An in-memory domain avoids changing the user's preferences during tests.
    defaults.setVolatileDomain(["hoverDelay": value], forName: UserDefaults.argumentDomain)
    let actual = FolderPrefs.hoverDelay
    precondition(abs(actual - expected) < 0.000001, "Stored \(value): expected \(expected), got \(actual)")
}

checkStored("invalid", expected: 0.3)
checkStored(0.3, expected: 0.3)
checkStored(0.0, expected: 0) // Zero must not be mistaken for an unset preference.
checkStored(0.17, expected: 0.17) // Typed values need not match the slider's 0.05 step.
checkStored(-1.0, expected: 0)
checkStored(20.0, expected: 2)
checkStored(Double.nan, expected: 0.3)
checkStored(Double.infinity, expected: 0.3)
print("PASS: hover delay default, zero, typed precision, bounds and invalid stored values")
