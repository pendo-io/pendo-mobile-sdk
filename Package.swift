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
            url: "https://software.mobile.pendo.io/artifactory/ios-sdk-release/3.1.3.8266/pendo-ios-sdk-xcframework.3.1.3.8266.zip",
            checksum: "ef10546e8f372412c3c07517c0b8ed556142dc36f25c0a99792f8f037a173317"
        ),
    ]
)
