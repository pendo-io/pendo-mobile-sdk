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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.11.3.11172/pendo-ios-sdk-xcframework.3.11.3.11172.zip",
            checksum: "d370783f08840a1d2f155a4f8ce210b49be1ba948ea1ddaef4cc9e9aed156000"
        ),
    ]
)
