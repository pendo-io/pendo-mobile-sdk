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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.12.2.11520/pendo-ios-sdk-xcframework.3.12.2.11520.zip",
            checksum: "f110b57b679d3bd2d9c23b773fc640925736d1924f508fd4320585038286d06c"
        ),
    ]
)
