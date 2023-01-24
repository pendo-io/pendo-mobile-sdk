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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/2.20.0.6765/pendo-ios-sdk-xcframework.2.20.0.6765.zip",
            checksum: "47c0f274a4ea94a4532636210a746d4464cbda20516706bf3cbadad0d0defeca"
        ),
    ]
)
