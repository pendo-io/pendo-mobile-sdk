// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Pendo",
    platforms: [
        .iOS(.v13)
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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/swiftui/2.21.0.7138/pendo-ios-sdk-xcframework.2.21.0.7138.zip",
            checksum: "3e341139958a3df74897e40a96787fd68a7b620bc5f82ea767b669b279c11651"
        ),
    ]
)
