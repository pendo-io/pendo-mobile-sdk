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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.8.3.10170/pendo-ios-sdk-xcframework.3.8.3.10170.zip",
            checksum: "543885ded7db0c99ead30fe563a4a7b9d55bff5564eddb5b6ccfafd377246ed1"
        ),
    ]
)
