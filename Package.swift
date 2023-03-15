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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/2.20.2.6938/pendo-ios-sdk-xcframework.2.20.2.6938.zip",
            checksum: "b0a0d287d9c0268dcab88a0dc421caaa63e60571ccfe479eb7f21df6e16f2f30"
        ),
    ]
)
