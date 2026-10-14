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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.14.8.13296/pendo-ios-sdk-xcframework.3.14.8.13296.zip",
            checksum: "7abbfced6aae651b5816910b721fc9bf5e8126d25ce9e4263c1c3c902afad0c0"
        ),
    ]
)
