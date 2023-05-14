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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/2.21.0.7028/pendo-ios-sdk-xcframework.2.21.0.7028.zip",
            checksum: "c7ef643640f35ca344eb2c3d522acdd7809082f28ea7c80ca1ac45df1999b185"
        ),
    ]
)
