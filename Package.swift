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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-beta/3.13.7.12016/pendo-ios-sdk-xcframework.3.13.7.12016.beta.zip",
            checksum: "5c83cfdb026cf4dba41878db72c0a427a905a30bd63f12fd7f76b942476d1e84"
        ),
    ]
)
