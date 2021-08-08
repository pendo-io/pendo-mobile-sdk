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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/2.10.0.3867/pendo-ios-sdk-xcframework.2.10.0.3867.zip",
            checksum: "a3b784143670e0be4d46e9d5d1e4804fec23c70a302dfbfebfefe99ddaa065ec"
        ),
    ]
)
