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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.13.0.11707/pendo-ios-sdk-xcframework.3.13.0.11707.zip",
            checksum: "cf5d973e150a04eebbcbf8efd7dca8962e862ed8a45f4b7019e3bfa9ce718a96"
        ),
    ]
)
