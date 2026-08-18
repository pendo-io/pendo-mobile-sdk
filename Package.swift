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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.11.4.12512/pendo-ios-sdk-xcframework.3.11.4.12512.zip",
            checksum: "89da8caac7671a8277b836c275a5ca1a6846ab6a8280134b9ba9b2ae0fe0a823"
        ),
    ]
)
