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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/swiftui/2.20.0.6599/pendo-ios-sdk-xcframework.2.20.0.6599.zip",
            checksum: "de08237862a635e6a2f26033f9455560af87a266aace45905a6c710c606b9ec4"
        ),
    ]
)
