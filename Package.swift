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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/2.9.1.3792/pendo-ios-sdk-xcframework.2.9.1.3792.zip",
            checksum: "4cab3b75660c06dbd7793a56125c267258d4de98c59ba089ff141a8c070a4a3e"
        ),
    ]
)
