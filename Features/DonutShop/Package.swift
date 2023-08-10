// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DonutShop",
    defaultLocalization: "en",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "DonutShop",
            targets: ["DonutShop"]),
    ],
    dependencies: [
        .package(url: "git@github.com:MaximBazarov/Decide.git", .upToNextMajor(from: "0.1.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "DonutShop",
            dependencies: ["Decide"]),
        .testTarget(
            name: "DonutShopTests",
            dependencies: ["DonutShop"]),
    ]
)
