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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/2.12.0.4373/pendo-ios-sdk-xcframework.2.12.0.4373.zip",
            checksum: "4c89361549548961a070814231b12d96592a0252e6696442fc8d1c8027d9364d"
        ),
    ]
)
