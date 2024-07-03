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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.3.0.8585/pendo-ios-sdk-xcframework.3.3.0.8585.zip",
            checksum: "bf192055c1f0d9f51d07d744e5a47b1af07468d24a886f017abacde9a251e0ab"
        ),
    ]
)
