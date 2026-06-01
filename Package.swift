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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.13.2.11805/pendo-ios-sdk-xcframework.3.13.2.11805.zip",
            checksum: "d814b0ae7003621f1b18005d0709ae9462e3ddf231ddb4f07e225a105f59f2d4"
        ),
    ]
)
