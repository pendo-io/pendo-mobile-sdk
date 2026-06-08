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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.13.5.11895/pendo-ios-sdk-xcframework.3.13.5.11895.zip",
            checksum: "66f5a291ef6ab7d82fccf7caa776fcd23bed82b8e82004380c4b863ac6c57837"
        ),
    ]
)
