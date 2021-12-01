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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/2.12.1.4572/pendo-ios-sdk-xcframework.2.12.1.4572.zip",
            checksum: "0cea45b36f71ce7fb9f4da420ee0f28e64d12a6f1c4a96fcb3c1dc5e8efdd210"
        ),
    ]
)
