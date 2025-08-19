// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "MMFormat",
    platforms: [
        .iOS(.v18), .macOS(.v12)
    ],
    products: [
        .library(
            name: "MMFormat",
            targets: ["MMFormat"]),
    ],
    targets: [
        .target(
            name: "MMFormat",
            dependencies: []),
        .testTarget(
            name: "MMFormatTests",
            dependencies: ["MMFormat"]),
    ]
)
