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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/2.21.1.7258/pendo-ios-sdk-xcframework.2.21.1.7258.zip",
            checksum: "181aabc47fc0975c87e961c3bd51f867c45d2891314983de7ce5d8aa765b5814"
        ),
    ]
)
