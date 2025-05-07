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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.7.0.9334/pendo-ios-sdk-xcframework.3.7.0.9334.zip",
            checksum: "000c9e1baa742ed1b08ed9b8a54e1d3d58eda867a37ca0d95143c9cd1c9144fb"
        ),
    ]
)
