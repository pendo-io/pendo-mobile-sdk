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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/2.16.1.5891/pendo-ios-sdk-xcframework.2.16.1.5891.zip",
            checksum: "da455658c060948b3f8f85e1a0c2f9f6218e454375809f8d91d3245437e834b5"
        ),
    ]
)
