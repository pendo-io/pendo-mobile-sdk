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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/swiftui/2.22.0.7469/pendo-ios-sdk-xcframework.2.22.0.7469.zip",
            checksum: "ecbc705f434152a41829f425c3528c2499407fcc717a888cf5acb70b952d0b06"
        ),
    ]
)
