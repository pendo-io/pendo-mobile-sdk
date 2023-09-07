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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/2.22.4.7656/pendo-ios-sdk-xcframework.2.22.4.7656.zip",
            checksum: "d6046f449fcd3bbefa88dfafe2cfe9e353111b459e6d58aa110fddc854333d62"
        ),
    ]
)
