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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/2.18.0.6298/pendo-ios-sdk-xcframework.2.18.0.6298.zip",
            checksum: "51c7c4c39512ff98066479ea4daa9307597d139e2172bd22fb1f67858dfe54b6"
        ),
    ]
)
