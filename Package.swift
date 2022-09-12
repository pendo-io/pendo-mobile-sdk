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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/swiftui/2.18.0.6333/pendo-ios-sdk-xcframework.2.18.0.6333.zip",
            checksum: "9f4f54c9152ace103a9055357c1b4aff2272c857ae5af9e5ad6f047bf7a02900"
        ),
    ]
)

