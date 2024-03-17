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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.1.2.8257/pendo-ios-sdk-xcframework.3.1.2.8257.zip",
            checksum: "5ddfbe201894e84a7eeace5fcc8f16d41abb84fedd15659d0508eb9dc8d80fc3"
        ),
    ]
)
