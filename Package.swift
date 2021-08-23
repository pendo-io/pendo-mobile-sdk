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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/2.11.0.3965/pendo-ios-sdk-xcframework.2.11.0.3965.zip",
            checksum: "e45b66f71ad29ff812ae1a9a2cda316795c882833173d38f975fb1edda546fab"
        ),
    ]
)
