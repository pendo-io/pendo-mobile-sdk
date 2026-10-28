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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.14.10.13395/pendo-ios-sdk-xcframework.3.14.10.13395.zip",
            checksum: "e93167a38053293c250d8b3db0fe69a56ddc1909a18a0e3852a1570e53da35c2"
        ),
    ]
)
