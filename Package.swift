// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Pendo",
    platforms: [
        .iOS(.v13)
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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/swiftui/2.22.3.7945/pendo-ios-sdk-xcframework.2.22.3.7945.zip",
            checksum: "1fe97caa9e3ceb39e6fe3861c8539144f52e93973d2536575528e8c92b90de85"
        ),
    ]
)
