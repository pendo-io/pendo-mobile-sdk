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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.4.2.8784/pendo-ios-sdk-xcframework.3.4.2.8784.zip",
            checksum: "1358c93526c001b06f693a3404d2191e9fcb61e6b48e950bb3a0d073e695c07f"
        ),
    ]
)
