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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.12.6.12532/pendo-ios-sdk-xcframework.3.12.6.12532.zip",
            checksum: "8cb7d5eb095b1c8199219427b984ee079ab76ca12936960a8f4b3ffc021ec644"
        ),
    ]
)
