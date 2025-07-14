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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.7.5.9751/pendo-ios-sdk-xcframework.3.7.5.9751.zip",
            checksum: "ae67474b945de29d6e3dc08c486508af96cf1004c2b0c27f9a0f1bb76bc658af"
        ),
    ]
)
