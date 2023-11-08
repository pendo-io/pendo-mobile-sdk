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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/swiftui/2.22.2.7920/pendo-ios-sdk-xcframework.2.22.2.7920.zip",
            checksum: "24133288131090d7cdffb9265a780be6143dd6e81c6b7fa1f900b52199d1d3e8"
        ),
    ]
)
