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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/2.18.1.6386/pendo-ios-sdk-xcframework.2.18.1.6386.zip",
            checksum: "a6ae6804e5c5fc84715f8d17842e0eab18554acaca0dc94cb23e5f2653429372"
        ),
    ]
)
