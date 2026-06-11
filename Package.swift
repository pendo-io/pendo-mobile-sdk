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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.13.6.11930/pendo-ios-sdk-xcframework.3.13.6.11930.zip",
            checksum: "bae41a3b4e37c7f4c6acf50df808a5ac825cd75397d52df531ea6f6dc6e3d0e6"
        ),
    ]
)
