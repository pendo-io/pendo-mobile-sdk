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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.6.0.9017/pendo-ios-sdk-xcframework.3.6.0.9017.zip",
            checksum: "f2c440a2d70e571b31a46eadd7c6cf80d59bf761a364135722a876573ff64ae3"
        ),
    ]
)
