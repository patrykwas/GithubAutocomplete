import Foundation

struct GithubRepo: Decodable, Hashable, Sendable {
    let name: String
    let fullName: String
    let owner: GithubUser
    let description: String?
    let htmlUrl: String
    let stargazersCount: Int

    enum CodingKeys: String, CodingKey {
        case name
        case fullName = "full_name"
        case owner
        case description
        case htmlUrl = "html_url"
        case stargazersCount = "stargazers_count"
    }
}
