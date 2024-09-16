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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.4.0.8750/pendo-ios-sdk-xcframework.3.4.0.8750.zip",
            checksum: "b5e67847f183ab2ad9ead2d419cd0addaf2db4820af7a5d490b6f215e0267fda"
        ),
    ]
)
