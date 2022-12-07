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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/swiftui/2.20.0.6594/pendo-ios-sdk-xcframework.2.20.0.6594.zip",
            checksum: "985161f0d2d8a298eb4c4288d8a2d23fca6fae7b935d476c4941d5c56536c50d"
        ),
    ]
)
