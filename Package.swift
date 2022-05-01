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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/2.15.1.5414/pendo-ios-sdk-xcframework.2.15.1.5414.zip",
            checksum: "601b22136669a6aca7f84eb9904b256d4a3b1592bca95d6917e57b2fa71d95f5"
        ),
    ]
)
