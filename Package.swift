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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.4.3.8833/pendo-ios-sdk-xcframework.3.4.3.8833.zip",
            checksum: "2caf565f3e519deaea6cf9a80d377ff2b2c0c62cc31f459086890a55091203c9"
        ),
    ]
)
