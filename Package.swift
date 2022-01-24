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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/2.12.4.5050/pendo-ios-sdk-xcframework.2.12.4.5050.zip",
            checksum: "084bb3cd5b68bb9c6041ee271e9e675e2c7b3e1818ce35da4f70361ab1d8c598"
        ),
    ]
)
