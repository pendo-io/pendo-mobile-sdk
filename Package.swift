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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.7.4.9536/pendo-ios-sdk-xcframework.3.7.4.9536.zip",
            checksum: "a213a100caa2082053b0a8c16b3a6b64b39586b1d509b4bb308d697787f74113"
        ),
    ]
)
