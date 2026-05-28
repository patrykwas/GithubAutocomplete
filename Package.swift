// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "GitHubAutocomplete",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(
            name: "GitHubAutocomplete",
            targets: ["GitHubAutocomplete"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-async-algorithms", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "GitHubAutocomplete",
            dependencies: [
                .product(name: "AsyncAlgorithms", package: "swift-async-algorithms"),
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "GitHubAutocompleteTests",
            dependencies: ["GitHubAutocomplete"],
            path: "Tests"
        ),
    ]
)
