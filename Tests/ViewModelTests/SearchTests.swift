import Testing
@testable import GitHubAutocomplete

@MainActor
@Suite("Search")
struct SearchTests {

    @Test("Returns loaded state on success")
    func searchReturnsLoadedState() async {
        // Given
        let (vm, mock) = makeViewModel()
        mock.itemsToReturn = [.stub(title: "alice")]

        // When
        await vm.search("alice")

        // Then
        if case .loaded(let items) = vm.state {
            #expect(items.count == 1)
            #expect(items.first?.title == "alice")
        } else {
            Issue.record("Expected .loaded state, got \(vm.state)")
        }
    }

    @Test("Preserves provider ordering")
    func resultsPreserveProviderOrdering() async {
        // Given
        let (vm, mock) = makeViewModel()
        mock.itemsToReturn = [
            .stub(title: "alice"),
            .stub(title: "babel"),
            .stub(title: "mongoose"),
            .stub(title: "zara"),
        ]

        // When
        await vm.search("test")

        // Then
        if case .loaded(let items) = vm.state {
            #expect(items.map(\.title) == ["alice", "babel", "mongoose", "zara"])
        } else {
            Issue.record("Expected .loaded state")
        }
    }

    @Test("Empty results produce .empty state")
    func emptyResultsState() async {
        // Given
        let (vm, _) = makeViewModel()

        // When
        await vm.search("xyznonexistent")

        // Then
        #expect(vm.state == .empty)
    }

    @Test("Error propagates message to state")
    func errorStatePropagatesMessage() async {
        // Given
        let (vm, mock) = makeViewModel()
        mock.errorToThrow = TestError.simulated

        // When
        await vm.search("test")

        // Then
        if case .error(let message) = vm.state {
            #expect(message.contains("simulated"))
        } else {
            Issue.record("Expected .error state, got \(vm.state)")
        }
    }

    @Test("Custom search provider is used")
    func customSearchProvider() async {
        // Given
        let vm = AutocompleteViewModel(
            configuration: AutocompleteConfiguration(minimumQueryLength: 1, resultLimit: 10, debounceInterval: 0.0),
            searchProvider: { query in
                [AutocompleteItem(id: query, title: "custom-\(query)", subtitle: "")]
            }
        )

        // When
        await vm.search("x")

        // Then
        if case .loaded(let items) = vm.state {
            #expect(items.first?.title == "custom-x")
        } else {
            Issue.record("Expected .loaded state")
        }
    }
}
