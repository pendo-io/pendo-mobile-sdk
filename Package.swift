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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/2.22.0.7382/pendo-ios-sdk-xcframework.2.22.0.7382.zip",
            checksum: "edc9a641e2fb042f5468996e30c032887e60f66afd8a6e2c20b4a304d827a729"
        ),
    ]
)
