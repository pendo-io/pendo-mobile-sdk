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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.7.0.9285/pendo-ios-sdk-xcframework.3.7.0.9285.zip",
            checksum: "3e255fb17fa2f38107e6e33855a2fc50f54609b27c2b6b56213731d52bac8cfa"
        ),
    ]
)
