import SwiftUI

/// Batteries-included container: search bar + results.
/// For full control, use `AutocompleteSearchBar` + `AutocompleteResultsView` separately.
public struct AutocompleteView<RowContent: View>: View {
    @State private var viewModel: AutocompleteViewModel
    private let strings: AutocompleteStrings
    private let onSelect: ((AutocompleteItem) -> Void)?
    private let rowContent: ((AutocompleteItem) -> RowContent)?


    public init(
        searchProvider: @escaping AutocompleteViewModel.SearchProvider,
        configuration: AutocompleteConfiguration = AutocompleteConfiguration(),
        strings: AutocompleteStrings = AutocompleteStrings(),
        onSelect: ((AutocompleteItem) -> Void)? = nil
    ) where RowContent == DefaultAutocompleteRow {
        _viewModel = State(wrappedValue: AutocompleteViewModel(
            configuration: configuration,
            searchProvider: searchProvider
        ))
        self.strings = strings
        self.onSelect = onSelect
        self.rowContent = nil
    }


    public init(
        searchProvider: @escaping AutocompleteViewModel.SearchProvider,
        configuration: AutocompleteConfiguration = AutocompleteConfiguration(),
        strings: AutocompleteStrings = AutocompleteStrings(),
        @ViewBuilder rowContent: @escaping (AutocompleteItem) -> RowContent,
        onSelect: ((AutocompleteItem) -> Void)? = nil
    ) {
        _viewModel = State(wrappedValue: AutocompleteViewModel(
            configuration: configuration,
            searchProvider: searchProvider
        ))
        self.strings = strings
        self.onSelect = onSelect
        self.rowContent = rowContent
    }

    public var body: some View {
        VStack(spacing: 0) {
            AutocompleteSearchBar(text: $viewModel.query, strings: strings)
            if let rowContent {
                AutocompleteResultsView(viewModel: viewModel, strings: strings, rowContent: rowContent, onSelect: onSelect)
            } else {
                AutocompleteResultsView(viewModel: viewModel, strings: strings, onSelect: onSelect)
            }
        }
    }
}
