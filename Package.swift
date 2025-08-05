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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.8.0.9901/pendo-ios-sdk-xcframework.3.8.0.9901.zip",
            checksum: "5b7476b568e4ed5b5ff175dc73133e52f9efb9ff0331048383b307a832a59590"
        ),
    ]
)
