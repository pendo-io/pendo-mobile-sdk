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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-beta/2.18.0.6285/pendo-ios-sdk-xcframework.2.18.0.6285.beta.zip",
            checksum: "591e15160aea5225c67286669bcc953d6a5d10a6a8e23d9ddf68808ccbb4bc50"
        ),
    ]
)
