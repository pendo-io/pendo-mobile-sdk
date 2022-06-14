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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/2.16.0.5665/pendo-ios-sdk-xcframework.2.16.0.5665.zip",
            checksum: "e95767825667fc3784333438e1425afbe93edf3d1ed94f8c1ba608be11115d51"
        ),
    ]
)
