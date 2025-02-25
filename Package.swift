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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.6.1.9043/pendo-ios-sdk-xcframework.3.6.1.9043.zip",
            checksum: "ca50f00e1e80fa15c45f18883b90e41936b4768f9d8a2268d3323a2b5edcbd24"
        ),
    ]
)
