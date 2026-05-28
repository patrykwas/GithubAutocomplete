import Foundation
@testable import GitHubAutocomplete

@MainActor
func makeViewModel(
    mock: MockSearchContext = MockSearchContext(),
    minimumQueryLength: Int = 3,
    resultLimit: Int = 50,
    debounceInterval: TimeInterval = 0.0
) -> (AutocompleteViewModel, MockSearchContext) {
    let config = AutocompleteConfiguration(
        minimumQueryLength: minimumQueryLength,
        resultLimit: resultLimit,
        debounceInterval: debounceInterval
    )
    let vm = AutocompleteViewModel(
        configuration: config,
        searchProvider: mock.searchProvider
    )
    return (vm, mock)
}
