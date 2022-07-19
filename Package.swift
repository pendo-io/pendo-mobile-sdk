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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-beta/2.16.1.5935/pendo-ios-sdk-xcframework.2.16.1.5935.beta.zip",
            checksum: "1feb7e018cb40f16b329f942ea9d7e89ebf4a91f58289ad2469cfa464851c028"
        ),
    ]
)
