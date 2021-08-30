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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/2.11.1.4010/pendo-ios-sdk-xcframework.2.11.1.4010.zip",
            checksum: "8ba03d8d25a974b5893df2a75c3ca33bdc77802fbb5b440bd09bc8d3fffaa4db"
        ),
    ]
)
