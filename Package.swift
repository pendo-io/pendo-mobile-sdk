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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.0.2.8105/pendo-ios-sdk-xcframework.3.0.2.8105.zip",
            checksum: "485e78139a58d24a0e2e40c233bb8ec884f4c5e4b961d95c1ca2e93e9d3880bb"
        ),
    ]
)
