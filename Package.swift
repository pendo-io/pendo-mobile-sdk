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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.15.0.13880/pendo-ios-sdk-xcframework.3.15.0.13880.zip",
            checksum: "912cead4a7c8db4918b68c0f9a0ce3b041c597c8b9f8326202d226fdaa6c461a"
        ),
    ]
)
