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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/2.8.3.3612/pendo-ios-sdk-xcframework.2.8.3.3612.zip",
            checksum: "7d7e2b564631155838ba3fa0b9ec401707128478416faf523cf772f6fb589d65"
        ),
    ]
)
