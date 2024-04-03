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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.1.5.8335/pendo-ios-sdk-xcframework.3.1.5.8335.zip",
            checksum: "aa48408716df35e98e53277d61bc3908401335884b016e6d891a59c97519c2fc"
        ),
    ]
)
