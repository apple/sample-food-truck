/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
An extension to donut to represent the dough.
*/

import SwiftUI

public extension Donut {
    struct Dough: Ingredient {
        public var name: String
        public var imageAssetName: String
        public var flavors: FlavorProfile
        
        public var backgroundColor: Color {
            Color("\(Self.imageAssetPrefix)/\(imageAssetName)-bg", bundle: .module)
        }

        public static let imageAssetPrefix = "dough"
    }
}

public extension Donut.Dough {
    static let blueberry = Donut.Dough(
        name: String(localized: "Blueberry Dough", bundle: .module, comment: "Blueberry-flavored dough."),
        imageAssetName: "blue",
        flavors: FlavorProfile(salty: 1, sweet: 2, savory: 2)
    )

    static let chocolate = Donut.Dough(
        name: String(localized: "Chocolate Dough", bundle: .module, comment: "Chocolate-flavored dough."),
        imageAssetName: "brown",
        flavors: FlavorProfile(salty: 1, sweet: 3, bitter: 1, sour: -1, savory: 1)
    )
    
    static let sourCandy = Donut.Dough(
        name: String(localized: "Sour Candy", bundle: .module, comment: "Sour-candy-flavored dough."),
        imageAssetName: "green",
        flavors: FlavorProfile(salty: 1, sweet: 2, sour: 3, savory: -1)
    )

    static let strawberry = Donut.Dough(
        name: String(localized: "Strawberry Dough", bundle: .module, comment: "Strawberry-flavored dough."),
        imageAssetName: "pink",
        flavors: FlavorProfile(sweet: 3, savory: 2)
    )

    static let plain = Donut.Dough(
        name: String(localized: "Plain", bundle: .module, comment: "Plain donut dough."),
        imageAssetName: "plain",
        flavors: FlavorProfile(salty: 1, sweet: 1, bitter: 1, savory: 2)
    )

    static let powdered = Donut.Dough(
        name: String(localized: "Powdered Dough", bundle: .module, comment: "Powdered donut dough."),
        imageAssetName: "white",
        flavors: FlavorProfile(salty: -1, sweet: 4, savory: 1)
    )

    static let lemonade = Donut.Dough(
        name: String(localized: "Lemonade", bundle: .module, comment: "Lemonade-flavored dough."),
        imageAssetName: "yellow",
        flavors: FlavorProfile(salty: 1, sweet: 1, sour: 3)
    )
    
    static let all = [blueberry, chocolate, sourCandy, strawberry, plain, powdered, lemonade]
}
