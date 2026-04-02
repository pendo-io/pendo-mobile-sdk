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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.12.1.11429/pendo-ios-sdk-xcframework.3.12.1.11429.zip",
            checksum: "7b499e078410d1b1c2d7383ab1f80999c5ed92ece51a89e8c52ea97f7699d9fb"
        ),
    ]
)
