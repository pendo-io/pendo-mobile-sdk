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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.9.0.10333/pendo-ios-sdk-xcframework.3.9.0.10333.zip",
            checksum: "da21feff8a74161f577bb4b089c77865978180bf82083f42f3746cbfd67e724a"
        ),
    ]
)
