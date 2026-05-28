import Foundation

enum TestError: Error, LocalizedError {
    case simulated

    var errorDescription: String? { "simulated error" }
}
