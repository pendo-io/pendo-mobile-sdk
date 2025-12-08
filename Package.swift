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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.9.2.10806/pendo-ios-sdk-xcframework.3.9.2.10806.zip",
            checksum: "753fdb244c26f9c7ea84635e0a03853f06677bb98d6f7d1a2c322ed7db196907"
        ),
    ]
)
