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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.12.4.11671/pendo-ios-sdk-xcframework.3.12.4.11671.zip",
            checksum: "5b650d0394e7a28619c1ba8b8b8320e05ab6bd1ffd8e42819e6d46267db35716"
        ),
    ]
)
