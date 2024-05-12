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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.2.1.8473/pendo-ios-sdk-xcframework.3.2.1.8473.zip",
            checksum: "cfd68a6a67bbed2294f0263e5d473b7091725f955aad7909ab9863afabed4cb5"
        ),
    ]
)

