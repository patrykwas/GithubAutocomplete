import Foundation

protocol GithubServiceProtocol: Sendable {
    func searchUsers(query: String, perPage: Int) async throws -> [GithubUser]
    func searchRepositories(query: String, perPage: Int) async throws -> [GithubRepo]
}

enum GithubServiceError: Error, LocalizedError {
    case invalidURL
    case unexpectedResponse
    case httpError(statusCode: Int)
    case rateLimited
    case decodingFailed(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid request URL."
        case .unexpectedResponse:
            return "Received an unexpected response from the server."
        case .httpError(let code):
            return "Server returned status \(code)."
        case .rateLimited:
            return "Github API rate limit exceeded. Try again shortly."
        case .decodingFailed:
            return "Failed to parse the response."
        }
    }
}

final class GithubService: GithubServiceProtocol {
    private let session: URLSession
    private let baseURL = "https://api.github.com"

    init(session: URLSession = .shared) {
        self.session = session
    }

    func searchUsers(query: String, perPage: Int) async throws -> [GithubUser] {
        let url = try buildSearchURL(path: "/search/users", query: query, perPage: perPage)
        let data = try await fetch(url)
        do {
            return try JSONDecoder().decode(GithubUserSearchResponse.self, from: data).items
        } catch {
            throw GithubServiceError.decodingFailed(error)
        }
    }

    func searchRepositories(query: String, perPage: Int) async throws -> [GithubRepo] {
        let url = try buildSearchURL(path: "/search/repositories", query: query, perPage: perPage)
        let data = try await fetch(url)
        do {
            return try JSONDecoder().decode(GithubRepoSearchResponse.self, from: data).items
        } catch {
            throw GithubServiceError.decodingFailed(error)
        }
    }

    // MARK: - Helpers

    private func buildSearchURL(path: String, query: String, perPage: Int) throws -> URL {
        guard var components = URLComponents(string: baseURL + path) else {
            throw GithubServiceError.invalidURL
        }
        components.queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "per_page", value: String(perPage))
        ]
        guard let url = components.url else {
            throw GithubServiceError.invalidURL
        }
        return url
    }

    private func fetch(_ url: URL) async throws -> Data {
        var request = URLRequest(url: url)
        request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")

        let (data, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse else {
            throw GithubServiceError.unexpectedResponse
        }
        if http.statusCode == 403 || http.statusCode == 429 {
            throw GithubServiceError.rateLimited
        }
        guard (200..<300).contains(http.statusCode) else {
            throw GithubServiceError.httpError(statusCode: http.statusCode)
        }
        return data
    }
}
