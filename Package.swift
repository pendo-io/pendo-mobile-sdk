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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/2.12.3.4708/pendo-ios-sdk-xcframework.2.12.3.4708.zip",
            checksum: "daac53cd4109559b547906f013c91776ae5de4f4577f984eab9e4c67c580eb6f"
        ),
    ]
)
