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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.3.2.8693/pendo-ios-sdk-xcframework.3.3.2.8693.zip",
            checksum: "399cc0957914397e8dc3a1476156358642357b5ccfd589dfdb05beb76f65b17f"
        ),
    ]
)
