// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "git-changelog",
    platforms: [
        .macOS(.v10_15)
    ],
    dependencies: [
         .package(url: "https://github.com/vapor/console-kit.git", from: "4.1.0"),
    ],
    targets: [
        .target(name: "git-changelog", dependencies: [
            .product(name: "ConsoleKit", package: "console-kit")
        ]),
        .testTarget(name: "ChangelogTests", dependencies: ["git-changelog"]),
    ]
)
