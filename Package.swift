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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/2.20.1.6837/pendo-ios-sdk-xcframework.2.20.1.6837.zip",
            checksum: "a8f66725b7e1958c5103a36e35b74602e0ed14ce4c56fc55f44aa09bed8abd00"
        ),
    ]
)
