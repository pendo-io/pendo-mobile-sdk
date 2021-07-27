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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/2.9.2.3835/pendo-ios-sdk-xcframework.2.9.2.3835.zip",
            checksum: "1494a9869503d1d72eb9dc4dc4372558efcae314292dfc3b0131c222928ccbcc"
        ),
    ]
)
