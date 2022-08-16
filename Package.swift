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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-beta/2.16.1.6136/pendo-ios-sdk-xcframework.2.16.1.6136.beta.zip",
            checksum: "0a7b7bbb83bb7f6b12d9a7443858ccbaf20f73c576b870c9b36314b1e62533c4"
        ),
    ]
)
