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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.4.3.8824/pendo-ios-sdk-xcframework.3.4.3.8824.zip",
            checksum: "84cbdc1ce088348001e9d9476ac205bc821df462015a84f625ad03c7738458cf"
        ),
    ]
)
