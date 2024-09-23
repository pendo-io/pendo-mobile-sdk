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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.4.1.8769/pendo-ios-sdk-xcframework.3.4.1.8769.zip",
            checksum: "4a6000708249a7adc8accfda7388af55d222014ceeac7dd6a4ece5f480d47bdd"
        ),
    ]
)
