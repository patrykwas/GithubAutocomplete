import Testing
@testable import GitHubAutocomplete

@MainActor
@Suite("Configuration")
struct ConfigurationTests {

    @Test("Query below minimum does not trigger search")
    func queryBelowMinimumDoesNotSearch() {
        // Given
        let (vm, mock) = makeViewModel()

        // When
        vm.query = "ab" // 2 chars < 3

        // Then
        #expect(vm.state == .idle)
        #expect(mock.capturedQueries.isEmpty)
    }

    @Test("Results capped at configured limit")
    func resultsCappedAtLimit() async {
        // Given
        let (vm, mock) = makeViewModel(resultLimit: 50)
        mock.itemsToReturn = (0..<60).map { .stub(title: "item\($0)") }

        // When
        await vm.search("test")

        // Then
        if case .loaded(let items) = vm.state {
            #expect(items.count == 50)
        } else {
            Issue.record("Expected .loaded state")
        }
    }

    @Test("Clearing query resets to idle")
    func clearingQueryResetsToIdle() async {
        // Given
        let (vm, mock) = makeViewModel()
        mock.itemsToReturn = [.stub(title: "test")]
        await vm.search("test")

        // When
        vm.query = ""

        // Then
        #expect(vm.state == .idle)
    }

    @Test("Retry re-runs search after error")
    func retryReRunsSearchAfterError() async {
        // Given
        let (vm, mock) = makeViewModel()
        mock.errorToThrow = TestError.simulated
        await vm.search("swift")

        // When
        mock.errorToThrow = nil
        mock.itemsToReturn = [.stub(title: "swift")]
        await vm.search("swift")

        // Then
        if case .loaded(let items) = vm.state {
            #expect(items.first?.title == "swift")
        } else {
            Issue.record("Expected .loaded after retry, got \(vm.state)")
        }
    }
}
