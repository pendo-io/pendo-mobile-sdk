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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/2.22.2.7452/pendo-ios-sdk-xcframework.2.22.2.7452.zip",
            checksum: "4f18fa46c4fa4eb9127d2e50c0c3214d576ccf1d539e9fcb8c0fb489012ce3a8"
        ),
    ]
)
