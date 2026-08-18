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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-beta/3.14.0.12548/pendo-ios-sdk-xcframework.3.14.0.12548.beta.zip",
            checksum: "2286639ff16905a6d978767eec511be81f07951e9bd6895a230400092a8ee89c"
        ),
    ]
)
