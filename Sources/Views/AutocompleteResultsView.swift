import SwiftUI

/// Results only — does not include a search bar.
/// Pair with `AutocompleteSearchBar` or your own input bound to `viewModel.query`.
public struct AutocompleteResultsView<RowContent: View>: View {
    private let viewModel: AutocompleteViewModel
    private let strings: AutocompleteStrings
    private let onSelect: ((AutocompleteItem) -> Void)?
    private let rowContent: ((AutocompleteItem) -> RowContent)?


    public init(
        viewModel: AutocompleteViewModel,
        strings: AutocompleteStrings = AutocompleteStrings(),
        onSelect: ((AutocompleteItem) -> Void)? = nil
    ) where RowContent == DefaultAutocompleteRow {
        self.viewModel = viewModel
        self.strings = strings
        self.onSelect = onSelect
        self.rowContent = nil
    }


    public init(
        viewModel: AutocompleteViewModel,
        strings: AutocompleteStrings = AutocompleteStrings(),
        @ViewBuilder rowContent: @escaping (AutocompleteItem) -> RowContent,
        onSelect: ((AutocompleteItem) -> Void)? = nil
    ) {
        self.viewModel = viewModel
        self.strings = strings
        self.onSelect = onSelect
        self.rowContent = rowContent
    }

    public var body: some View {
        switch viewModel.state {
        case .idle:
            ContentUnavailableView(
                strings.idleTitle,
                systemImage: "magnifyingglass",
                description: Text(strings.idleDescription(viewModel.configuration.minimumQueryLength))
            )

        case .loading:
            VStack {
                Spacer()
                ProgressView(strings.searching)
                Spacer()
            }

        case .loaded(let items):
            List(items) { item in
                Group {
                    if let rowContent {
                        rowContent(item)
                    } else {
                        DefaultAutocompleteRow(item: item)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
                .onTapGesture { onSelect?(item) }
            }
            .listStyle(.plain)

        case .empty:
            ContentUnavailableView.search(text: viewModel.query)

        case .error(let message):
            ContentUnavailableView {
                Label(strings.errorTitle, systemImage: "exclamationmark.triangle")
            } description: {
                Text(message)
            } actions: {
                Button(strings.retry) {
                    viewModel.retry()
                }
            }
        }
    }
}
