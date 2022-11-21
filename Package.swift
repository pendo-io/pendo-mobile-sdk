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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/2.19.0.6541/pendo-ios-sdk-xcframework.2.19.0.6541.zip",
            checksum: "52616f0e69732a51e1770a09097100604f43315bf4e380ac7b85ed0a1167f4d2"
        ),
    ]
)
