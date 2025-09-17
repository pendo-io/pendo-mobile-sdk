// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Pendo",
    platforms: [
        .iOS(.v11)
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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.8.2.10145/pendo-ios-sdk-xcframework.3.8.2.10145.zip",
            checksum: "05f3566358698e87eea4ab6d7380e3f17938757d4ed90655689d78c4eeefc315"
        ),
    ]
)
