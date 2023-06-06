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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/2.21.2.7297/pendo-ios-sdk-xcframework.2.21.2.7297.zip",
            checksum: "6d796f40a72010731ca028a08f7023fda4ee612a9a6647a05d40327365538dc1"
        ),
    ]
)
