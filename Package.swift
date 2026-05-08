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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.12.5.11704/pendo-ios-sdk-xcframework.3.12.5.11704.zip",
            checksum: "9b75c4be2a9731146c1ba79dfaca6617c2c1c20c0b82cbaba093f0d842c0d232"
        ),
    ]
)
