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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.3.1.8661/pendo-ios-sdk-xcframework.3.3.1.8661.zip",
            checksum: "fbb86f6e04729369e24a9479df9ddfe84defc02d26906978eaa7950c82e6c5a1"
        ),
    ]
)
