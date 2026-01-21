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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.11.0.11043/pendo-ios-sdk-xcframework.3.11.0.11043.zip",
            checksum: "ed0f5498f4c61c7b6563637394397589c69a3001aa81d2d5a5ec9cab4d430cc7"
        ),
    ]
)
