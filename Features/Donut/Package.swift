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
            name: "DonutCatalog",
            targets: ["DonutCatalog"]),
        .library(
            name: "DonutSales",
            targets: ["DonutSales"]),
        .library(
            name: "DonutUI",
            targets: ["DonutUI"]),
    ],
    dependencies: [
        .package(url: "git@github.com:MaximBazarov/Decide.git", .upToNextMajor(from: "0.0.1"))
    ],
    targets: [
        .target(
            name: "DonutCatalog",
            dependencies: ["Decide"],
            path: "Catalog/Sources"
        ),
        .target(
            name: "DonutSales",
            dependencies: ["Decide"],
            path: "Sales/Sources"
        ),
        .target(
            name: "DonutUI",
            dependencies: ["DonutCatalog"],
            path: "UI/Sources"
        ),
        .testTarget(
            name: "DonutCatalog-Tests",
            dependencies: ["DonutCatalog"],
            path: "Catalog/Tests"
        ),
        .testTarget(
            name: "DonutUITests",
            dependencies: ["DonutUI"],
            path: "UI/Tests"
        ),
    ]
)
