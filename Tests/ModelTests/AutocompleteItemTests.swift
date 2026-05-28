import Testing
import Foundation
@testable import GitHubAutocomplete

@Suite("AutocompleteItem")
struct AutocompleteItemTests {

    @Test("Initializes with all properties")
    func initWithAllProperties() {
        // Given / When
        let item = AutocompleteItem(
            id: "user-1",
            title: "Alice",
            subtitle: "alice@example.com",
            imageURL: URL(string: "https://example.com/avatar.png"),
            systemImage: "person"
        )

        // Then
        #expect(item.id == "user-1")
        #expect(item.title == "Alice")
        #expect(item.subtitle == "alice@example.com")
        #expect(item.imageURL?.absoluteString == "https://example.com/avatar.png")
        #expect(item.systemImage == "person")
    }

    @Test("Optional fields default to nil")
    func optionalFieldsDefaultToNil() {
        // Given / When
        let item = AutocompleteItem(id: "1", title: "Test", subtitle: "Sub")

        // Then
        #expect(item.imageURL == nil)
        #expect(item.systemImage == nil)
    }

    @Test("Equatable compares all fields")
    func equatableComparesAllFields() {
        // Given
        let a = AutocompleteItem(id: "1", title: "A", subtitle: "sub")
        let b = AutocompleteItem(id: "1", title: "A", subtitle: "sub")
        let c = AutocompleteItem(id: "1", title: "B", subtitle: "sub")

        // Then
        #expect(a == b)
        #expect(a != c)
    }

    @Test("Hashable produces consistent values")
    func hashableConsistency() {
        // Given
        let a = AutocompleteItem(id: "1", title: "A", subtitle: "sub")
        let b = AutocompleteItem(id: "1", title: "A", subtitle: "sub")

        // Then
        #expect(a.hashValue == b.hashValue)
    }
}
