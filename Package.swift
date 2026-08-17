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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.14.0.12522/pendo-ios-sdk-xcframework.3.14.0.12522.zip",
            checksum: "a6b4938ae091078bd07fe593bfcf560eb30ece0560890ef8f87b9279fe4290d6"
        ),
    ]
)
