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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.14.1.12569/pendo-ios-sdk-xcframework.3.14.1.12569.zip",
            checksum: "555e34aeaf134eba031cac3cf39cf560a733bced0fe9ad3afc5f96aba2e71add"
        ),
    ]
)
