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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.14.11.13443/pendo-ios-sdk-xcframework.3.14.11.13443.zip",
            checksum: "4a8d8d9e2802f1817f34254a81437956d7d65b0eb8b20026c12e6d27b6e2b5ea"
        ),
    ]
)
