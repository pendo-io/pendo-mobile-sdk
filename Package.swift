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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/2.11.2.4221/pendo-ios-sdk-xcframework.2.11.2.4221.zip",
            checksum: "a0443facd6490c70e2d30f8bc28409e87bf7853a1169d9f1756c878825bbe48f"
        ),
    ]
)
