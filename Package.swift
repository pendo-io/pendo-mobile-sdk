// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
​
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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.0.1.8049/pendo-ios-sdk-xcframework.3.0.1.8049.zip",
            checksum: "6b6ce7f1cfec61b873d1ff324766c6bc7c9a01b3a873fd6098bc26488032a68f"
        ),
    ]
)