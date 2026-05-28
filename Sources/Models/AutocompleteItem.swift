import Foundation

public struct AutocompleteItem: Identifiable, Hashable, Sendable {
    public let id: String
    public let title: String
    public let subtitle: String
    public let imageURL: URL?

    /// SF Symbol name displayed next to the title in the default row.
    public let systemImage: String?

    public init(
        id: String,
        title: String,
        subtitle: String,
        imageURL: URL? = nil,
        systemImage: String? = nil
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.imageURL = imageURL
        self.systemImage = systemImage
    }
}
