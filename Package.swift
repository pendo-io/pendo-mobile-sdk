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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-beta/2.18.0.6204/pendo-ios-sdk-xcframework.2.18.0.6204.beta.zip",
            checksum: "e6b8a17ef8e1d75c59c80e4121e08fe3031d8dacb19cef6f2d7ce4582775f93b"
        ),
    ]
)
