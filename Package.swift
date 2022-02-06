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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/2.13.1.5118/pendo-ios-sdk-xcframework.2.13.1.5118.zip",
            checksum: "7cd1b2379073f61e01764cc569b8697201a09cd9d409de7f45d018a27ddd856f"
        ),
    ]
)
