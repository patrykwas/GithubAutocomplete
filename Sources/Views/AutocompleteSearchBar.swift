import SwiftUI

/// Default search bar — replaceable with any input bound to `viewModel.query`.
public struct AutocompleteSearchBar: View {
    @Binding var text: String
    private let strings: AutocompleteStrings

    public init(text: Binding<String>, strings: AutocompleteStrings = AutocompleteStrings()) {
        _text = text
        self.strings = strings
    }

    public var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
            TextField(strings.searchPlaceholder, text: $text)
                .textFieldStyle(.plain)
                .autocorrectionDisabled()
                #if os(iOS)
                .textInputAutocapitalization(.never)
                #endif
            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(strings.clearSearch)
            }
        }
        .padding(12)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}
