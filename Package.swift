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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.11.1.11068/pendo-ios-sdk-xcframework.3.11.1.11068.zip",
            checksum: "8342839c52358958114dd600c812f3b2ac94a7dfd437f3fc250f7605766f4f90"
        ),
    ]
)
