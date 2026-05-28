import SwiftUI
import GitHubAutocomplete

struct DetailSheet: View {
    @Environment(\.dismiss) private var dismiss
    let item: AutocompleteItem

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                if let imageURL = item.imageURL {
                    AsyncImage(url: imageURL) { phase in
                        switch phase {
                        case .success(let image):
                            image.resizable().scaledToFill()
                        default:
                            Color.gray.opacity(0.3)
                        }
                    }
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                }

                Text(item.title)
                    .font(.title2.bold())

                Text(item.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
        .presentationDetents([.medium])
    }
}
