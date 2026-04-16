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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.12.3.11548/pendo-ios-sdk-xcframework.3.12.3.11548.zip",
            checksum: "23f4f87759e4311edab9e4c6889c076315c9c83b5b3e109eb7dfaed50d1d9056"
        ),
    ]
)
