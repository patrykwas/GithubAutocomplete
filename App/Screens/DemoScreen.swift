import SwiftUI
import GitHubAutocomplete

struct DemoScreen: View {
    @State private var selectedItem: AutocompleteItem?

    private let strings = AutocompleteStrings(
        searchPlaceholder: "Search Github users & repos…",
        idleTitle: "Search Github"
    )

    var body: some View {
        NavigationStack {
            AutocompleteView(
                searchProvider: GithubSearchProvider.searchProvider(),
                strings: strings
            ) { item in
                selectedItem = item
            }
            .navigationTitle("Github Search")
            .sheet(item: $selectedItem) { item in
                DetailSheet(item: item)
            }
        }
    }
}
