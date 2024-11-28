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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.4.4.8910/pendo-ios-sdk-xcframework.3.4.4.8910.zip",
            checksum: "fa8c9736fad4714f672c29d24ad87e19ac046b04aea26ffc208667a8bb4f3f8d"
        ),
    ]
)
