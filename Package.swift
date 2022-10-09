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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/2.18.2.6401/pendo-ios-sdk-xcframework.2.18.2.6401.zip",
            checksum: "ac2b7d9e531ebedee7c1f7c7de8082b5138975032e55e601ad6812293596ee97"
        ),
    ]
)
