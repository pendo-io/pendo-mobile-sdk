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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-beta/2.16.1.6135/pendo-ios-sdk-xcframework.2.16.1.6135.beta.zip",
            checksum: "18f860e35ae81bf708ae249deeda9e391261ca436921f135563062e7983684f2"
        ),
    ]
)
