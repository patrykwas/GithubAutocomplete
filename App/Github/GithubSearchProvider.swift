import Foundation
import GitHubAutocomplete

enum GithubSearchProvider {
    static func searchProvider(
        service: GithubServiceProtocol = GithubService(),
        perPage: Int = 50
    ) -> @Sendable (String) async throws -> [AutocompleteItem] {
        return { query in
            async let users = service.searchUsers(query: query, perPage: perPage)
            async let repos = service.searchRepositories(query: query, perPage: perPage)
            let (fetchedUsers, fetchedRepos) = try await (users, repos)

            let userItems = fetchedUsers.map { user in
                AutocompleteItem(
                    id: "user-\(user.login)",
                    title: user.login,
                    subtitle: user.htmlUrl,
                    imageURL: URL(string: user.avatarUrl),
                    systemImage: "person"
                )
            }
            let repoItems = fetchedRepos.map { repo in
                AutocompleteItem(
                    id: "repo-\(repo.fullName)",
                    title: repo.name,
                    subtitle: repo.description ?? repo.fullName,
                    imageURL: URL(string: repo.owner.avatarUrl),
                    systemImage: "book.closed"
                )
            }

            return (userItems + repoItems).sorted { $0.title.lowercased() < $1.title.lowercased() }
        }
    }
}
