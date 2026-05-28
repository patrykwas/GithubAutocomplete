import Foundation

public struct AutocompleteConfiguration: Sendable {
    public var minimumQueryLength: Int
    public var resultLimit: Int
    public var debounceInterval: TimeInterval

    public init(
        minimumQueryLength: Int = 3,
        resultLimit: Int = 50,
        debounceInterval: TimeInterval = 0.3
    ) {
        self.minimumQueryLength = minimumQueryLength
        self.resultLimit = resultLimit
        self.debounceInterval = debounceInterval
    }
}
