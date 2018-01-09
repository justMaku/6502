// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MOS6502",
    products: [
        .library(
            name: "MOS6502",
            targets: ["MOS6502"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "MOS6502",
            dependencies: []
        ),
        .target(
            name: "TestSuite",
            dependencies: ["MOS6502"]
        )
    ]
)
