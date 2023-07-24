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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/2.22.1.7434/pendo-ios-sdk-xcframework.2.22.1.7434.zip",
            checksum: "1dab2466e2ce6cf742cd413efeba56706bd621b1f664d3c45aa124e688895a0b"
        ),
    ]
)
