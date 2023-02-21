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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/swiftui/2.20.0.6868/pendo-ios-sdk-xcframework.2.20.0.6868.zip",
            checksum: "5301840040a44ea305a4de44ed7c798300b4cb02c32b540ad59329d4009ec7f5"
        ),
    ]
)
