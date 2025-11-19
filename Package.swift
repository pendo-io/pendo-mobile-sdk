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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.9.1.10611/pendo-ios-sdk-xcframework.3.9.1.10611.zip",
            checksum: "004a26e17c64e6c6c3c34f8093fbad6add942d7fb6da88801b86ae1d12eaedd0"
        ),
    ]
)
