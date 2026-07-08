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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.13.8.12148/pendo-ios-sdk-xcframework.3.13.8.12148.zip",
            checksum: "926c51481d2c2b15bc518b800dfe37d8771bfe3ea77bd7c47c50bd0372625df1"
        ),
    ]
)
