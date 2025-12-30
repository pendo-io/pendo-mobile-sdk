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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.10.0.10883/pendo-ios-sdk-xcframework.3.10.0.10883.zip",
            checksum: "f562833e59d9974261b84c790301ae7f99468ee83769cf48a42429dede3ceaa0"
        ),
    ]
)
