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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.1.4.8310/pendo-ios-sdk-xcframework.3.1.4.8310.zip",
            checksum: "e128c4ed2945cbd7ffbef4681a38bb2b5b0088a3689fdb12856708b2a8fbbe11"
        ),
    ]
)
