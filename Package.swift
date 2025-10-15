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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.8.4.10241/pendo-ios-sdk-xcframework.3.8.4.10241.zip",
            checksum: "c06ede902bbc5a98229dea14c667c834092d690358d2ac321b9ecb73fcbf45bb"
        ),
    ]
)
