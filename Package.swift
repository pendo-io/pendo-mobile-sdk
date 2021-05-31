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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/2.8.2.3545/pendo-ios-sdk-xcframework.2.8.2.3545.zip",
            checksum: "ecffbbad0ad79546f1fb28e18f3038f6ef606a292c108d1a21035e88799e9991"
        ),
    ]
)
