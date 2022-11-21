// swift-tools-version:5.7

import PackageDescription

let package = Package(
  name: "KantanNetworking",
  platforms: [
    .iOS(.v13),
    .macOS(.v10_15)
  ],
  products: [
    .library(
      name: "KantanNetworking",
      targets: ["KantanNetworking"]),
  ],
  dependencies: [],
  targets: [
    .target(
      name: "KantanNetworking",
      dependencies: []),
    .testTarget(
      name: "KantanNetworkingTests",
      dependencies: ["KantanNetworking"]),
  ]
)
