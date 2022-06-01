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
        .macOS("13.0"),
        .iOS("16.0"),
        .macCatalyst("16.0")
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
