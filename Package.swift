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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/2.22.6.8014/pendo-ios-sdk-xcframework.2.22.6.8014.zip",
            checksum: "f8df43f2dbd049c7b12cd6cfcd3ec1ea0d87739759966e19f57e737c4755bae3"
        ),
    ]
)
