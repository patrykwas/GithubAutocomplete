# Github Autocomplete

A reusable, domain-agnostic SwiftUI autocomplete component - demonstrated here with the Github Search API. Built with Swift concurrency, Observation framework, and [AsyncAlgorithms](https://github.com/apple/swift-async-algorithms).

## Requirements

- iOS 17+ / macOS 14+
- Swift 5.9+
- Xcode 15+

## Architecture

```
Sources/                                    ← Library (generic, zero Github knowledge)
├── Models/
│   ├── AutocompleteItem.swift              # Domain-agnostic result item
│   ├── AutocompleteState.swift             # idle / loading / loaded / empty / error
│   ├── AutocompleteConfiguration.swift     # Query length, result limit, debounce interval
│   └── AutocompleteStrings.swift           # All user-facing strings (localizable)
├── ViewModels/
│   └── AutocompleteViewModel.swift         # @Observable, AsyncAlgorithms debounce pipeline
└── Views/
    ├── AutocompleteView.swift              # Batteries-included container
    ├── AutocompleteResultsView.swift       # Results only (pair with your own search bar)
    ├── AutocompleteSearchBar.swift         # Default search bar (replaceable)
    └── DefaultAutocompleteRow.swift        # Default row (replaceable)

App/                                        ← Demo app (Github wiring lives here)
├── GitHubAutocompleteApp.swift
├── Screens/
│   ├── DemoScreen.swift
│   └── DetailSheet.swift
└── Github/
    ├── Models/
    │   ├── GithubUser.swift
    │   ├── GithubRepo.swift
    │   └── GithubSearchResponses.swift
    ├── GithubService.swift
    └── GithubSearchProvider.swift

Tests/
├── Helpers/
├── ViewModelTests/
└── ModelTests/
```

**Design decisions:**

- **Domain-agnostic core** - `Sources/` has zero references to Github. The component accepts any `(String) async throws -> [AutocompleteItem]` closure. Github is one wiring, living entirely in `App/`.
- **Composable** - three levels of control:
  1. `AutocompleteView` - container with search bar + results
  2. `AutocompleteSearchBar` + `AutocompleteResultsView` - compose your own layout
  3. `AutocompleteViewModel` - drive fully custom UI
- **`AsyncAlgorithms.debounce`** - standard Apple debounce operator on `AsyncStream`.
- **`@Observable`** - modern iOS 17+ observation, no Combine dependency.
- **Localizable** - all user-facing strings injected via `AutocompleteStrings`.

## Usage

### Batteries included

```swift
AutocompleteView(
    searchProvider: GithubSearchProvider.searchProvider(),
    strings: AutocompleteStrings(
        searchPlaceholder: "Search Github users & repos…",
        idleTitle: "Search Github"
    )
) { item in
    print("Selected: \(item.title)")
}
```

### Custom search bar

```swift
@State private var viewModel = AutocompleteViewModel(
    searchProvider: GithubSearchProvider.searchProvider()
)

var body: some View {
    VStack {
        TextField("Find repos…", text: $viewModel.query)
            .textFieldStyle(.roundedBorder)
            .padding()
        AutocompleteResultsView(viewModel: viewModel) { item in
            print("Selected: \(item.title)")
        }
    }
}
```

### Custom row

```swift
AutocompleteResultsView(viewModel: viewModel) { item in
    HStack {
        Text(item.title)
        Spacer()
        Text(item.subtitle).foregroundStyle(.secondary)
    }
} onSelect: { item in
    print("Selected: \(item.title)")
}
```

### Custom configuration

```swift
AutocompleteView(
    searchProvider: GithubSearchProvider.searchProvider(),
    configuration: AutocompleteConfiguration(
        minimumQueryLength: 2,
        resultLimit: 25,
        debounceInterval: 0.5
    )
) { item in
    print("Selected: \(item.title)")
}
```

### Any data source

```swift
AutocompleteView(
    searchProvider: { query in
        let results = try await myContactsAPI.search(query)
        return results.map {
            AutocompleteItem(id: $0.id, title: $0.name, subtitle: $0.email, systemImage: "person")
        }
    },
    strings: AutocompleteStrings(searchPlaceholder: "Search contacts…", idleTitle: "Contacts")
) { item in
    print("Selected: \(item.title)")
}
```

### Localization

```swift
let polish = AutocompleteStrings(
    searchPlaceholder: "Szukaj…",
    idleTitle: "Wyszukiwarka",
    idleDescription: { "Wpisz co najmniej \($0) znaki." },
    searching: "Szukam…",
    errorTitle: "Coś poszło nie tak",
    retry: "Ponów",
    clearSearch: "Wyczyść"
)
```

## Running the Demo App

```bash
brew install xcodegen    # if not installed
xcodegen generate
open GitHubAutocomplete.xcodeproj
```

Select the **GitHubAutocompleteApp** scheme, pick an iOS Simulator, and Cmd+R.

## Testing

```bash
swift test
```

In Xcode: select the **GitHubAutocomplete** framework scheme and Cmd+U.

## Building (library only)

```bash
swift build
```
