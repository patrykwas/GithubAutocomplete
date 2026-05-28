import Foundation
import AsyncAlgorithms

@Observable
@MainActor
public final class AutocompleteViewModel {

    public typealias SearchProvider = @Sendable (String) async throws -> [AutocompleteItem]

    // MARK: Configuration

    public let configuration: AutocompleteConfiguration

    // MARK: State

    public var query: String = "" {
        didSet { queryDidChange() }
    }
    public private(set) var state: AutocompleteState = .idle

    // MARK: Dependencies

    private let searchProvider: SearchProvider
    @ObservationIgnored private var queryContinuation: AsyncStream<String>.Continuation?
    @ObservationIgnored private var pipelineTask: Task<Void, Never>?
    @ObservationIgnored private var searchTask: Task<Void, Never>?

    // MARK: Init

    public init(
        configuration: AutocompleteConfiguration = AutocompleteConfiguration(),
        searchProvider: @escaping SearchProvider
    ) {
        self.configuration = configuration
        self.searchProvider = searchProvider
        startPipeline()
    }

    // MARK: - Public API

    /// Performs a search immediately, bypassing the debounce pipeline.
    public func search(_ query: String) async {
        state = .loading
        do {
            var items = try await searchProvider(query)
            guard !Task.isCancelled else { return }
            if items.count > configuration.resultLimit {
                items = Array(items.prefix(configuration.resultLimit))
            }
            state = items.isEmpty ? .empty : .loaded(items)
        } catch is CancellationError {
            // A newer search replaced this one — do nothing.
        } catch {
            guard !Task.isCancelled else { return }
            state = .error(error.localizedDescription)
        }
    }

    /// Re-runs the search for the current query. No-op if query is below minimum.
    public func retry() {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.count >= configuration.minimumQueryLength else { return }
        performSearch(trimmed)
    }

    // MARK: - Private

    private func startPipeline() {
        let (stream, continuation) = AsyncStream.makeStream(of: String.self)
        self.queryContinuation = continuation

        let interval = configuration.debounceInterval
        pipelineTask = Task { [weak self] in
            for await query in stream.debounce(for: .seconds(interval)) {
                self?.performSearch(query)
            }
        }
    }

    private func queryDidChange() {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.count < configuration.minimumQueryLength {
            searchTask?.cancel()
            state = .idle
        } else {
            queryContinuation?.yield(trimmed)
        }
    }

    private func performSearch(_ query: String) {
        searchTask?.cancel()
        searchTask = Task { [weak self] in
            await self?.search(query)
        }
    }
}
