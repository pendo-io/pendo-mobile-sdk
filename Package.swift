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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.14.6.13145/pendo-ios-sdk-xcframework.3.14.6.13145.zip",
            checksum: "81970c7b1a3a3ac755464435fec41e5a169fcb9de9c47d9e5bc9d5aa02d22332"
        ),
    ]
)
