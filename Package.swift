// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Pendo",
    platforms: [
        .iOS(.v9)
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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/2.9.0.3660/pendo-ios-sdk-xcframework.2.9.0.3660.zip",
            checksum: "04765b4de345948bbfa0c53c4d7aaed3eeb9df1b9822f03a74dbd1ba0aa6e129"
        ),
    ]
)
