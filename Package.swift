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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.1.1.8220/pendo-ios-sdk-xcframework.3.1.1.8220.zip",
            checksum: "d8158d2773b8b1a95caf9abdf3ec0569bc747f382685076f2e81915c0cc69c77"
        ),
    ]
)
