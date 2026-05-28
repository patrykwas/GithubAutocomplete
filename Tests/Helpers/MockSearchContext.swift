import Foundation
@testable import GitHubAutocomplete

final class MockSearchContext: @unchecked Sendable {
    var itemsToReturn: [AutocompleteItem] = []
    var errorToThrow: Error?
    var artificialDelay: Duration?
    private(set) var capturedQueries: [String] = []
    private let lock = NSLock()

    var searchProvider: AutocompleteViewModel.SearchProvider {
        { [self] query in
            lock.withLock { capturedQueries.append(query) }
            if let delay = artificialDelay {
                try await Task.sleep(for: delay)
            }
            if let error = errorToThrow { throw error }
            return itemsToReturn
        }
    }
}
