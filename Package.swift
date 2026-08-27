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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.14.2.12597/pendo-ios-sdk-xcframework.3.14.2.12597.zip",
            checksum: "1faceb26440984c7d6d2b43b635c73dac53c17ccd0a0c2333e8278cad56ef41c"
        ),
    ]
)
