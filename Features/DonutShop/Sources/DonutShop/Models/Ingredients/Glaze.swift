/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
An extension to donut to represent the glaze.
*/

import SwiftUI

public extension Donut {
    struct Glaze: Ingredient {
        public var name: String
        public var imageAssetName: String
        public var flavors: FlavorProfile

        public static let imageAssetPrefix = "glaze"
    }
}

public extension Donut.Glaze {
    static let blueberry = Donut.Glaze(
        name: String(localized: "Blueberry Spread", bundle: .module, comment: "Blueberry-flavored glaze."),
        imageAssetName: "blue",
        flavors: FlavorProfile(salty: 1, sweet: 3, sour: -1, savory: 2)
    )

    static let chocolate = Donut.Glaze(
        name: String(localized: "Chocolate Glaze", bundle: .module, comment: "Chocolate-flavored glaze."),
        imageAssetName: "brown",
        flavors: FlavorProfile(salty: 1, sweet: 1, bitter: 1, savory: 2)
    )

    static let sourCandy = Donut.Glaze(
        name: String(localized: "Sour Candy Glaze", bundle: .module, comment: "Sour-candy-flavored glaze."),
        imageAssetName: "green",
        flavors: FlavorProfile(bitter: 1, sour: 3, savory: -1, spicy: 2)
    )

    static let spicy = Donut.Glaze(
        name: String(localized: "Spicy Spread", bundle: .module, comment: "Spicy glaze."),
        imageAssetName: "orange",
        flavors: FlavorProfile(salty: 1, sour: 1, spicy: 3)
    )

    static let strawberry = Donut.Glaze(
        name: String(localized: "Strawberry Glaze", bundle: .module, comment: "Strawberry-flavored glaze."),
        imageAssetName: "pink",
        flavors: FlavorProfile(salty: 1, sweet: 2, savory: 2)
    )
    
    static let lemon = Donut.Glaze(
        name: String(localized: "Lemon Spread", bundle: .module, comment: "Lemon-flavored glaze."),
        imageAssetName: "yellow",
        flavors: FlavorProfile(sweet: 1, sour: 3, spicy: 1)
    )

    static let rainbow = Donut.Glaze(
        name: String(localized: "Rainbow Glaze", bundle: .module, comment: "Rainbow-colored glaze."),
        imageAssetName: "rainbow",
        flavors: FlavorProfile(salty: 2, sweet: 2, spicy: 1)
    )

    static let all = [blueberry, chocolate, sourCandy, spicy, strawberry, lemon, rainbow]
}
