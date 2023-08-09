/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
An extension to donut to represent the topping.
*/

import SwiftUI

public extension Donut {
    struct Topping: Ingredient {
        public var name: String
        public var imageAssetName: String
        public var flavors: FlavorProfile
        
        public static let imageAssetPrefix = "topping"
    }
}

public extension Donut.Topping {
    static var all: [Donut.Topping] {
        other + lattices + lines + drizzles
    }
    
    static let other = [powderedSugar, sprinkles, starSprinkles]
    
    static let powderedSugar = Donut.Topping(
        name: String(localized: "Powdered Sugar", bundle: .module, comment: "Finely ground sugar to decorate or add texture."),
        imageAssetName: "powdersugar",
        flavors: FlavorProfile(salty: 1, sweet: 4)
    )
    
    static let sprinkles = Donut.Topping(
        name: String(localized: "Sprinkles", bundle: .module, comment: "Small pieces of confectionery to decorate or add texture."),
        imageAssetName: "sprinkles",
        flavors: FlavorProfile(sweet: 3, savory: 2)
    )
    
    static let starSprinkles = Donut.Topping(
        name: String(localized: "Star Sprinkles", bundle: .module, comment: "Star-shaped pieces of confectionery to decorate or add texture."),
        imageAssetName: "sprinkles-stars",
        flavors: FlavorProfile(sweet: 3, savory: 2)
    )
}

// MARK: - Lattice
public extension Donut.Topping {
    static let lattices = [blueberryLattice, chocolateLattice, sourAppleLattice, spicySauceLattice, strawberryLattice, sugarLattice, lemonLattice]
    
    static let blueberryLattice = Donut.Topping(
        name: String(localized: "Blueberry Lattice", bundle: .module, comment: "Blueberry-flavored icing in a criss-cross pattern."),
        imageAssetName: "crisscross-blue",
        flavors: FlavorProfile(salty: 1, sweet: 2, bitter: 1, sour: -1, savory: 2)
    )
    
    static let chocolateLattice = Donut.Topping(
        name: String(localized: "Chocolate Lattice", bundle: .module, comment: "Chocolate-flavored icing in a criss-cross pattern."),
        imageAssetName: "crisscross-brown",
        flavors: FlavorProfile(salty: 2, sweet: 1, bitter: 2)
    )
    
    static let sourAppleLattice = Donut.Topping(
        name: String(localized: "Sour Apple Lattice", bundle: .module, comment: "Sour-apple-flavored icing in a criss-cross pattern."),
        imageAssetName: "crisscross-green",
        flavors: FlavorProfile(sweet: 1, sour: 3, savory: -1, spicy: 2)
    )
    
    static let spicySauceLattice = Donut.Topping(
        name: String(localized: "Spicy Sauce Lattice", bundle: .module, comment: "Spicy-sauce-flavored icing in a criss-cross pattern."),
        imageAssetName: "crisscross-orange",
        flavors: FlavorProfile(salty: 1, savory: 1, spicy: 3)
    )
    
    static let strawberryLattice = Donut.Topping(
        name: String(localized: "Strawberry Lattice", bundle: .module, comment: "Strawberry-flavored icing in a criss-cross pattern."),
        imageAssetName: "crisscross-pink",
        flavors: FlavorProfile(salty: 1, sweet: 2, savory: 2)
    )
    
    static let sugarLattice = Donut.Topping(
        name: String(localized: "Sugar Lattice", bundle: .module, comment: "Sugar-flavored icing in a criss-cross pattern."),
        imageAssetName: "crisscross-white",
        flavors: FlavorProfile(salty: 2, sweet: 3)
    )
    
    static let lemonLattice = Donut.Topping(
        name: String(localized: "Lemon Lattice", bundle: .module, comment: "Lemon-flavored icing in a criss-cross pattern."),
        imageAssetName: "crisscross-yellow",
        flavors: FlavorProfile(bitter: 2, sour: 2, spicy: 1)
    )
}

// MARK: - Lines
public extension Donut.Topping {
    static let lines = [blueberryLines, chocolateLines, sourAppleLines, spicySauceLines, strawberryLines, sugarLines, lemonLines]
    
    static let blueberryLines = Donut.Topping(
        name: String(localized: "Blueberry Lines", bundle: .module, comment: "Blueberry-flavored icing in parallel lines."),
        imageAssetName: "crisscross-blue",
        flavors: FlavorProfile(salty: 1, sweet: 2, bitter: 1, sour: -1, savory: 2)
    )
    
    static let chocolateLines = Donut.Topping(
        name: String(localized: "Chocolate Lines", bundle: .module, comment: "Chocolate-flavored icing in parallel lines."),
        imageAssetName: "straight-brown",
        flavors: FlavorProfile(salty: 2, sweet: 1, bitter: 2)
    )
    
    static let sourAppleLines = Donut.Topping(
        name: String(localized: "Sour Apple Lines", bundle: .module, comment: "Sour-apple-flavored icing in parallel lines."),
        imageAssetName: "straight-green",
        flavors: FlavorProfile(sweet: 1, sour: 3, savory: -1, spicy: 2)
    )
    
    static let spicySauceLines = Donut.Topping(
        name: String(localized: "Spicy Sauce Lines", bundle: .module, comment: "Spicy-sauce-flavored icing in parallel lines."),
        imageAssetName: "straight-orange",
        flavors: FlavorProfile(salty: 1, savory: 1, spicy: 3)
    )
    
    static let strawberryLines = Donut.Topping(
        name: String(localized: "Strawberry Lines", bundle: .module, comment: "Strawberry-flavored icing in parallel lines."),
        imageAssetName: "straight-pink",
        flavors: FlavorProfile(salty: 1, sweet: 2, savory: 2)
    )
    
    static let sugarLines = Donut.Topping(
        name: String(localized: "Sugar Lines", bundle: .module, comment: "Sugar-flavored icing in parallel lines."),
        imageAssetName: "straight-white",
        flavors: FlavorProfile(salty: 2, sweet: 3)
    )
    
    static let lemonLines = Donut.Topping(
        name: String(localized: "Lemon Lines", bundle: .module, comment: "Lemon-flavored icing in parallel lines."),
        imageAssetName: "straight-yellow",
        flavors: FlavorProfile(bitter: 2, sour: 2, spicy: 1)
    )
}

// MARK: - Drizzle
public extension Donut.Topping {
    static let drizzles = [blueberryDrizzle, chocolateDrizzle, sourAppleDrizzle, spicySauceDrizzle, strawberryDrizzle, sugarDrizzle, lemonDrizzle]
    static let blueberryDrizzle = Donut.Topping(
        name: String(localized: "Blueberry Drizzle", bundle: .module, comment: "Blueberry-flavored icing drizzled over the donut."),
        imageAssetName: "zigzag-blue",
        flavors: FlavorProfile(salty: 1, sweet: 2, bitter: 1, sour: -1, savory: 2)
    )
    
    static let chocolateDrizzle = Donut.Topping(
        name: String(localized: "Chocolate Drizzle", bundle: .module, comment: "Chocolate-flavored icing drizzled over the donut."),
        imageAssetName: "zigzag-brown",
        flavors: FlavorProfile(salty: 2, sweet: 1, bitter: 2)
    )
    
    static let sourAppleDrizzle = Donut.Topping(
        name: String(localized: "Sour Apple Drizzle", bundle: .module, comment: "Sour-apple-flavored icing drizzled over the donut."),
        imageAssetName: "zigzag-green",
        flavors: FlavorProfile(sweet: 1, sour: 3, savory: -1, spicy: 2)
    )
    
    static let spicySauceDrizzle = Donut.Topping(
        name: String(localized: "Spicy Sauce Drizzle", bundle: .module, comment: "Spicy-sauce-flavored icing drizzled over the donut."),
        imageAssetName: "zigzag-orange",
        flavors: FlavorProfile(salty: 1, savory: 1, spicy: 3)
    )
    
    static let strawberryDrizzle = Donut.Topping(
        name: String(localized: "Strawberry Drizzle", bundle: .module, comment: "Strawberry-flavored icing drizzled over the donut."),
        imageAssetName: "zigzag-pink",
        flavors: FlavorProfile(salty: 1, sweet: 2, savory: 2)
    )
    
    static let sugarDrizzle = Donut.Topping(
        name: String(localized: "Sugar Drizzle", bundle: .module, comment: "Sugar-flavored icing drizzled over the donut."),
        imageAssetName: "zigzag-white",
        flavors: FlavorProfile(salty: 2, sweet: 3)
    )
    
    static let lemonDrizzle = Donut.Topping(
        name: String(localized: "Lemon Drizzle", bundle: .module, comment: "Lemon-flavored icing drizzled over the donut."),
        imageAssetName: "zigzag-yellow",
        flavors: FlavorProfile(bitter: 2, sour: 2, spicy: 1)
    )
}
