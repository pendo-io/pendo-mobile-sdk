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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.12.0.11313/pendo-ios-sdk-xcframework.3.12.0.11313.zip",
            checksum: "59900ae5f72f85c2fa37c52922b31eb3ee76c57379cc8b6e0709312284d01117"
        ),
    ]
)
