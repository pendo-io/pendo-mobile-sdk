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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-beta/2.16.1.5941/pendo-ios-sdk-xcframework.2.16.1.5941.beta.zip",
            checksum: "ba3a40941054c98751f39bc487904fd21ebff4eb61122f7f11b2a91ae0c835b0"
        ),
    ]
)
