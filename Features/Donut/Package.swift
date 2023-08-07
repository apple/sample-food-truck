// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DonutState",
    defaultLocalization: "en",
    platforms: [
        .macOS("13.3"),
        .iOS("16.4")
    ],
    products: [
        .library(
            name: "DonutState",
            targets: ["DonutState"]),
        .library(
            name: "DonutUI",
            targets: ["DonutUI"]),
    ],
    targets: [
        .target(
            name: "DonutState",
            path: "State/Sources"
        ),
        .target(
            name: "DonutUI",
            dependencies: ["DonutState"],
            path: "UI/Sources"
        ),
        .testTarget(
            name: "DonutStateTests",
            dependencies: ["DonutState"],
            path: "State/Tests"
        ),
        .testTarget(
            name: "DonutUITests",
            dependencies: ["DonutUI"],
            path: "UI/Tests"
        ),
    ]
)
