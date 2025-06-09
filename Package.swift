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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.7.3.9512/pendo-ios-sdk-xcframework.3.7.3.9512.zip",
            checksum: "bbbac5c3dbf99ca8e052c42537ce8001d99aa330213553f63837151ba43a366f"
        ),
    ]
)
