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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/2.12.2.4643/pendo-ios-sdk-xcframework.2.12.2.4643.zip",
            checksum: "18d7039c5a906a6c030d83f3c0e10266a011195d6a693d629205950440e0c391"
        ),
    ]
)
