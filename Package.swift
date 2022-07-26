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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/2.17.0.5970/pendo-ios-sdk-xcframework.2.17.0.5970.zip",
            checksum: "e731e205487213477bbc630d9f7b2ff68e479c6486227e2e33b1b2cdb0a063af"
        ),
    ]
)
