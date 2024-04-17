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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.2.0.8353/pendo-ios-sdk-xcframework.3.2.0.8353.zip",
            checksum: "9b4d316b7f8a26ec3c15caeb65feabec86f049692322bd4c9fb355e1db42e4c1"
        ),
    ]
)

