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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-beta/3.13.7.12018/pendo-ios-sdk-xcframework.3.13.7.12018.beta.zip",
            checksum: "37fbad2b7abb2a467f9743a13429ac18f0c9150e1533048cc27459ae5609d65c"
        ),
    ]
)
