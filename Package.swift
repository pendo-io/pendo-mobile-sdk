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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.5.2.8997/pendo-ios-sdk-xcframework.3.5.2.8997.zip",
            checksum: "83ae144ad4d05785a4253c2fef3aa2755800be109ac1ec774401909cd22c28d6"
        ),
    ]
)
