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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/2.17.1.6076/pendo-ios-sdk-xcframework.2.17.1.6076.zip",
            checksum: "6d518aaa361b7fc3a58070ff725ae575474a0422638c57882b8dc7038fdf453f"
        ),
    ]
)
