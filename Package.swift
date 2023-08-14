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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/2.22.3.7527/pendo-ios-sdk-xcframework.2.22.3.7527.zip",
            checksum: "14d14967cfef97a9528c234aaa32bf243c63a63ca9e3ad54358185e63e9c2f96"
        ),
    ]
)
