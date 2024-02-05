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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.1.0.8165/pendo-ios-sdk-xcframework.3.1.0.8165.zip",
            checksum: "de92c2d4ad946cef54f6fe453a6df2598d1f528f8c8b7e3193da4de78c2eb422"
        ),
    ]
)
