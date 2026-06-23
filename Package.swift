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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.13.7.12022/pendo-ios-sdk-xcframework.3.13.7.12022.zip",
            checksum: "c21ceeb78a666215cf5943205ea9cc4f5621a2a7aedface519e2256834fe3a5e"
        ),
    ]
)
