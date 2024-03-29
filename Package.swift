// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "KantanNetworking",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
    ],
    products: [
        .library(
            name: "KantanNetworking",
            targets: ["KantanNetworking"]
        ),
    ],
    targets: [
        .target(
            name: "KantanNetworking",
            dependencies: [],
            path: "Sources"
        ),
        .testTarget(
            name: "KantanNetworkingTests",
            dependencies: ["KantanNetworking"],
            path: "Tests"
        ),
    ]
)
