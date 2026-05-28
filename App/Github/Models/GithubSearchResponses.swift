import Foundation

struct GithubUserSearchResponse: Decodable {
    let items: [GithubUser]
}

struct GithubRepoSearchResponse: Decodable {
    let items: [GithubRepo]
}
