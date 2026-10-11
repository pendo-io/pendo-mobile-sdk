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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.14.7.13250/pendo-ios-sdk-xcframework.3.14.7.13250.zip",
            checksum: "bc02ba99010a29f4e61e341a7f5b09be2e006290b734d5084cb091baef44b33f"
        ),
    ]
)
