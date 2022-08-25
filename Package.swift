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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-beta/2.18.0.6204/pendo-ios-sdk-xcframework.2.18.0.6204.beta.zip",
            checksum: "0fb88216a38b3288a51fcfaf7604567637e81d25667f7d6cf8e1b41f2fdb59dc"
        ),
    ]
)
