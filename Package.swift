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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.5.1.8972/pendo-ios-sdk-xcframework.3.5.1.8972.zip",
            checksum: "89677a41146779546649a01b0eb2da4bfd2b607fa80df1dc2df32b0d4e6aef78"
        ),
    ]
)
