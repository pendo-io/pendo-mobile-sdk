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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/swiftui/2.21.0.7162/pendo-ios-sdk-xcframework.2.21.0.7162.zip",
            checksum: "7ee675957df07579c437cfb5cf6003343c344bbb104264d9844c2310e1e31a07"
        ),
    ]
)
