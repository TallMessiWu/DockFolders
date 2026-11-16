import Foundation

/// Time spent outside the folder, its Dock tile and the path between them. Re-entering any
/// protected area cancels the pending close; zero delay closes on the first outside sample.
struct FolderLeaveTimer {
    private var awaySince: Date?

    mutating func shouldClose(protected: Bool, delay: TimeInterval, now: Date = Date()) -> Bool {
        if protected {
            awaySince = nil
            return false
        }
        let start = awaySince ?? now
        awaySince = start
        return now.timeIntervalSince(start) >= delay
    }
}
