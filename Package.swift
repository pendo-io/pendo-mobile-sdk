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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/2.14.0.5145/pendo-ios-sdk-xcframework.2.14.0.5145.zip",
            checksum: "777d9ebcb243c518668e9dab17cb8c269baa5eb5d1198d4e78657493cfa16b0a"
        ),
    ]
)
