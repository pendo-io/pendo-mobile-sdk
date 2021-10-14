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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/2.11.3.4256/pendo-ios-sdk-xcframework.2.11.3.4256.zip",
            checksum: "4751253ebd4f93051b1285fc3eab8e9392569f894cb68d7d040dd60946aa0ac3"
        ),
    ]
)
