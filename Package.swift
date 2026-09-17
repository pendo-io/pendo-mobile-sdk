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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.14.5.12728/pendo-ios-sdk-xcframework.3.14.5.12728.zip",
            checksum: "3d0ff118cfed2be0a5416a8d73173aab9bdb01e9f01e06cf49087d3c3199808e"
        ),
    ]
)
