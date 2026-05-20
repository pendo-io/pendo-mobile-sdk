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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.13.1.11743/pendo-ios-sdk-xcframework.3.13.1.11743.zip",
            checksum: "24ed9a7aea9ff04b071c3e479567ddd0452138326e64ea141121e63263afa314"
        ),
    ]
)
