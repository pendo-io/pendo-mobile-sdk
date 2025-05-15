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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.7.1.9370/pendo-ios-sdk-xcframework.3.7.1.9370.zip",
            checksum: "7e599f54432a754ed5578fb329e617a970cd8e46df5ac9a0967a7c3669645e52"
        ),
    ]
)
