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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.6.3.9228/pendo-ios-sdk-xcframework.3.6.3.9228.zip",
            checksum: "97cfdb938ef1f765c820c4610098f25ca2ae678746e8ee1a37d4f4d4935693ff"
        ),
    ]
)
