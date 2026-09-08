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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.14.4.12685/pendo-ios-sdk-xcframework.3.14.4.12685.zip",
            checksum: "8b557459c4f6beb26dac257870bad06c3a88009b9cd2ca82e23b78a3de307ccf"
        ),
    ]
)
