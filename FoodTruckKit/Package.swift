// swift-tools-version: 5.7

/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The FoodTruckKit package.
*/

import PackageDescription

let package = Package(
    name: "FoodTruckKit",
    defaultLocalization: "en",
    platforms: [
        .macOS("13.1"),
        .iOS("16.2"),
        .macCatalyst("16.2")
    ],
    products: [
        .library(
            name: "FoodTruckKit",
            targets: ["FoodTruckKit"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "FoodTruckKit",
            dependencies: [],
            path: "Sources"
        )
    ]
)
