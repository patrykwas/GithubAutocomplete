import SwiftUI

public struct DefaultAutocompleteRow: View {
    let item: AutocompleteItem

    public init(item: AutocompleteItem) {
        self.item = item
    }

    public var body: some View {
        HStack(spacing: 12) {
            if let imageURL = item.imageURL {
                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().scaledToFill()
                    default:
                        Color.gray.opacity(0.3)
                    }
                }
                .frame(width: 40, height: 40)
                .clipShape(Circle())
            }

            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    if let systemImage = item.systemImage {
                        Image(systemName: systemImage)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Text(item.title)
                        .font(.body.weight(.medium))
                        .lineLimit(1)
                }
                Text(item.subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            Spacer()
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(item.title)
    }
}
