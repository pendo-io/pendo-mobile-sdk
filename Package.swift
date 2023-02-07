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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/swiftui/2.20.0.6858/pendo-ios-sdk-xcframework.2.20.0.6858.zip",
            checksum: "945e6c866a5c0c19df296bca3086215e17d25bf4378679bb32ce98034a1ac993"
        ),
    ]
)
