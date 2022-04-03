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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/2.15.0.5328/pendo-ios-sdk-xcframework.2.15.0.5328.zip",
            checksum: "37e3490bec55a520b82092f8bcc53d8e3639c433acba0bc8137e9675888c9189"
        ),
    ]
)
