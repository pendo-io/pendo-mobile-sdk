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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.6.2.9095/pendo-ios-sdk-xcframework.3.6.2.9095.zip",
            checksum: "3d47bc04f1775454c66433a8967084f82bf0b7ae5adfcf11c6338de776767b1e"
        ),
    ]
)
