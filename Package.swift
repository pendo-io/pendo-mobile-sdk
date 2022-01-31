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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/2.13.0.5077/pendo-ios-sdk-xcframework.2.13.0.5077.zip",
            checksum: "7fe5f769b7243c1943a25daeb317ab8802268bd8a5a6f84eabdd21d513c795cd"
        ),
    ]
)
