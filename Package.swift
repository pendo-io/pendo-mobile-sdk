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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.13.4.11866/pendo-ios-sdk-xcframework.3.13.4.11866.zip",
            checksum: "519e56ae5752875c8a366ae72473167b508b259e63e699dfb17501642ba44dc5"
        ),
    ]
)
