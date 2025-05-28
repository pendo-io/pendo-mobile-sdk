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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.7.2.9435/pendo-ios-sdk-xcframework.3.7.2.9435.zip",
            checksum: "f84ee9895e38441099d82f9b1602d32325a4d49f898a750534f5f014e1d5e577"
        ),
    ]
)
