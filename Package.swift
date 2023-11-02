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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/2.22.5.7748/pendo-ios-sdk-xcframework.2.22.5.7748.zip",
            checksum: "7404c2f53315db98344391a4881eedf9b9e91d4a5c0d20613b0581d92666bdbd"
        ),
    ]
)
