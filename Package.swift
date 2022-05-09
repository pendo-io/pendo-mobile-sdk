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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/2.15.2.5470/pendo-ios-sdk-xcframework.2.15.2.5470.zip",
            checksum: "ab83e150a959410e0e1da17f11157130e6b518d38602ff4357c32ba28fe24180"
        ),
    ]
)
