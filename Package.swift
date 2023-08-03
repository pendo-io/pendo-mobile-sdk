// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Pendo",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "Pendo",
            targets: ["Pendo"])
    ],
    dependencies: [
    ],
    targets: [
        .binaryTarget(
            name: "Pendo",
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/swiftui/2.22.1.7480/pendo-ios-sdk-xcframework.2.22.1.7480.zip",
            checksum: "14c4f5157d551b873fc137d1c283c7f8d53c9c6de68c36a7b577ada74d7aa5b9"
        ),
    ]
)
