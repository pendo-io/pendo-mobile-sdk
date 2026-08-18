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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.13.10.12533/pendo-ios-sdk-xcframework.3.13.10.12533.zip",
            checksum: "643859d66aae3a81241310101e22b354b1683c5a3d8454529d14cf7ddec783d6"
        ),
    ]
)
