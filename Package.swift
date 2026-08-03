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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.13.9.12418/pendo-ios-sdk-xcframework.3.13.9.12418.zip",
            checksum: "06bad14354f91c21d3e8d266a49705decad2087dcfae0cacbb14e1aecfdb9558"
        ),
    ]
)
