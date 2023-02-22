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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/swiftui/2.20.0.6885/pendo-ios-sdk-xcframework.2.20.0.6885.zip",
            checksum: "9a39f5f3753f8252974996854207fa963f42fd147e431409144d67fce3a1611b"
        ),
    ]
)
