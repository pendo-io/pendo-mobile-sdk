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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.13.3.11820/pendo-ios-sdk-xcframework.3.13.3.11820.zip",
            checksum: "3b6b01b69700d265e33ba6086ec17acdb47f0fe491b2478f365b12ff8df8678b"
        ),
    ]
)
