import Testing
@testable import GitHubAutocomplete

@Suite("AutocompleteStrings")
struct AutocompleteStringsTests {

    @Test("Defaults provide English strings")
    func defaults() {
        // Given / When
        let strings = AutocompleteStrings()

        // Then
        #expect(strings.searchPlaceholder == "Search…")
        #expect(strings.idleTitle == "Search")
        #expect(strings.searching == "Searching…")
        #expect(strings.errorTitle == "Something went wrong")
        #expect(strings.retry == "Retry")
        #expect(strings.clearSearch == "Clear search")
    }

    @Test("idleDescription interpolates minimum characters")
    func idleDescriptionInterpolation() {
        // Given
        let strings = AutocompleteStrings()

        // When / Then
        #expect(strings.idleDescription(3) == "Type at least 3 characters to search.")
        #expect(strings.idleDescription(5) == "Type at least 5 characters to search.")
    }

    @Test("Custom strings override defaults")
    func customStrings() {
        // Given / When
        let strings = AutocompleteStrings(
            searchPlaceholder: "Szukaj…",
            idleTitle: "Wyszukiwarka",
            idleDescription: { "Wpisz co najmniej \($0) znaki." },
            searching: "Szukam…",
            errorTitle: "Błąd",
            retry: "Ponów",
            clearSearch: "Wyczyść"
        )

        // Then
        #expect(strings.searchPlaceholder == "Szukaj…")
        #expect(strings.idleTitle == "Wyszukiwarka")
        #expect(strings.idleDescription(3) == "Wpisz co najmniej 3 znaki.")
        #expect(strings.searching == "Szukam…")
        #expect(strings.errorTitle == "Błąd")
        #expect(strings.retry == "Ponów")
        #expect(strings.clearSearch == "Wyczyść")
    }
}
