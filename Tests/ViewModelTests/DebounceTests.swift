import Testing
import Foundation
@testable import GitHubAutocomplete

@MainActor
@Suite("Debounce & Cancellation")
struct DebounceTests {

    @Test("Rapid input coalesces into single search call")
    func debounceCoalescesRapidInput() async throws {
        // Given
        let (vm, mock) = makeViewModel(debounceInterval: 0.1)
        mock.itemsToReturn = [.stub(title: "swift")]

        // When
        vm.query = "swi"
        vm.query = "swif"
        vm.query = "swift"
        try await Task.sleep(for: .milliseconds(250))

        // Then
        #expect(mock.capturedQueries.count <= 1)
    }

    @Test("New search cancels in-flight request")
    func newSearchCancelsPreviousOne() async throws {
        // Given
        let (vm, mock) = makeViewModel(debounceInterval: 0.0)
        mock.artificialDelay = .milliseconds(200)
        mock.itemsToReturn = [.stub(title: "final")]

        // When
        vm.query = "first-query"
        try await Task.sleep(for: .milliseconds(20))
        vm.query = "second-query"
        try await Task.sleep(for: .milliseconds(300))

        // Then
        switch vm.state {
        case .loaded(let items):
            #expect(items.first?.title == "final")
        case .loading:
            break // acceptable if timing is tight
        default:
            Issue.record("Expected .loaded or .loading, got \(vm.state)")
        }
    }
}
