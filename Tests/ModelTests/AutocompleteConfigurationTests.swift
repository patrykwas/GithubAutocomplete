import Testing
@testable import GitHubAutocomplete

@Suite("AutocompleteConfiguration")
struct AutocompleteConfigurationTests {

    @Test("Defaults match expected values")
    func defaults() {
        // Given / When
        let config = AutocompleteConfiguration()

        // Then
        #expect(config.minimumQueryLength == 3)
        #expect(config.resultLimit == 50)
        #expect(config.debounceInterval == 0.3)
    }

    @Test("Custom values are preserved")
    func customValues() {
        // Given / When
        let config = AutocompleteConfiguration(
            minimumQueryLength: 1,
            resultLimit: 25,
            debounceInterval: 0.5
        )

        // Then
        #expect(config.minimumQueryLength == 1)
        #expect(config.resultLimit == 25)
        #expect(config.debounceInterval == 0.5)
    }
}
