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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.14.9.13356/pendo-ios-sdk-xcframework.3.14.9.13356.zip",
            checksum: "6b2d80b0a391b0b0566696252c88cc43c8e1a37b3bcc2067cf872dc4e70c5d19"
        ),
    ]
)
