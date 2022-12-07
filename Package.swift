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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/2.19.1.6575/pendo-ios-sdk-xcframework.2.19.1.6575.zip",
            checksum: "e7594d48d65bea605f9eb339ced3788cc8746b094cdfb9fcb9be7c186fac962b"
        ),
    ]
)
