// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Pendo",
    platforms: [
        .iOS(.v13)
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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/swiftui/2.21.1.7346/pendo-ios-sdk-xcframework.2.21.1.7346.zip",
            checksum: "1f1575d07a34702ddc76cc68bed324c4acea8f3a9c611dab58e0d7c9116cf170"
        ),
    ]
)
