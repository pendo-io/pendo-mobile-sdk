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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.5.0.8949/pendo-ios-sdk-xcframework.3.5.0.8949.zip",
            checksum: "f6cdad09dd54a7bc86fc9f7b7f21632c2613385db1569c9795ae33631c9c4770"
        ),
    ]
)
