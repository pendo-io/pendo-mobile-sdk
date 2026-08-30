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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.14.3.12602/pendo-ios-sdk-xcframework.3.14.3.12602.zip",
            checksum: "4b601780307654c754c81cddc7ede45d49eae14a6eef2cf7211c270fdf61acf2"
        ),
    ]
)
