import Foundation

/// Localization example:
/// ```swift
/// let strings = AutocompleteStrings(
///     searchPlaceholder: "Szukaj…",
///     idleTitle: "Wyszukiwarka",
///     searching: "Szukam…",
///     retry: "Ponów"
/// )
/// ```
public struct AutocompleteStrings: Sendable {
    public var searchPlaceholder: String
    public var idleTitle: String
    public var idleDescription: @Sendable (_ minimumCharacters: Int) -> String
    public var searching: String
    public var errorTitle: String
    public var retry: String
    public var clearSearch: String

    public init(
        searchPlaceholder: String = "Search…",
        idleTitle: String = "Search",
        idleDescription: @Sendable @escaping (_ minimumCharacters: Int) -> String = { "Type at least \($0) characters to search." },
        searching: String = "Searching…",
        errorTitle: String = "Something went wrong",
        retry: String = "Retry",
        clearSearch: String = "Clear search"
    ) {
        self.searchPlaceholder = searchPlaceholder
        self.idleTitle = idleTitle
        self.idleDescription = idleDescription
        self.searching = searching
        self.errorTitle = errorTitle
        self.retry = retry
        self.clearSearch = clearSearch
    }
}
