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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.2.2.8490/pendo-ios-sdk-xcframework.3.2.2.8490.zip",
            checksum: "401ae290bf5dc5fe1da954bb4aa53cbb86428fa446a0594ca5c9446ffcf965d0"
        ),
    ]
)

