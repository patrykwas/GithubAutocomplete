@testable import GitHubAutocomplete

extension AutocompleteItem {
    static func stub(
        id: String? = nil,
        title: String = "stub",
        subtitle: String = "subtitle",
        systemImage: String? = nil
    ) -> AutocompleteItem {
        AutocompleteItem(
            id: id ?? title,
            title: title,
            subtitle: subtitle,
            systemImage: systemImage
        )
    }
}
