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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.11.2.11111/pendo-ios-sdk-xcframework.3.11.2.11111.zip",
            checksum: "75ad9c332035a0035239ea59036f5a5a43c05afb64edf807c1cf735c4c0ea579"
        ),
    ]
)
