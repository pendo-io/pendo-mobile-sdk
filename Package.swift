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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.8.1.9936/pendo-ios-sdk-xcframework.3.8.1.9936.zip",
            checksum: "e889cf6a5cf9ac28fd56d7ac26982e0f961312992d8183df68723b748552f1d2"
        ),
    ]
)
