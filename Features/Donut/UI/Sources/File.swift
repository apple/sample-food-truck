//
//  File.swift
//  
//
//  Created by Maxim Bazarov on 07.08.23.
//

import Foundation
import DonutState
import SwiftUI

public extension Flavor {
    var name: String {
        switch self {
        case .salty:
            return String(localized: "Salty", bundle: .module, comment: "The main flavor-profile of a donut.")
        case .sweet:
            return String(localized: "Sweet", bundle: .module, comment: "The main flavor-profile of a donut.")
        case .bitter:
            return String(localized: "Bitter", bundle: .module, comment: "The main flavor-profile of a donut.")
        case .sour:
            return String(localized: "Sour", bundle: .module, comment: "The main flavor-profile of a donut.")
        case .savory:
            return String(localized: "Savory", bundle: .module, comment: "The main flavor-profile of a donut.")
        case .spicy:
            return String(localized: "Spicy", bundle: .module, comment: "The main flavor-profile of a donut.")
        }
    }

    public var image: Image {
        Image.flavorSymbol(self)
    }
}

public extension Image {
    static var donutSymbol: Image {
        Image("donut", bundle: .module)
    }

    static func flavorSymbol(_ flavor: Flavor) -> Image {
        switch flavor {
        case .salty:
            return Image("salty", bundle: .module)
        case .sweet:
            return Image("sweet", bundle: .module)
        case .bitter:
            return Image("bitter", bundle: .module)
        case .sour:
            return Image("sour", bundle: .module)
        case .savory:
            return Image(systemName: "face.smiling")
        case .spicy:
            return Image("spicy", bundle: .module)
        }
    }
}

public extension Ingredient {
    var id: String { "\(Self.imageAssetPrefix)/\(name)" }
}

public extension Ingredient {
    func image(thumbnail: Bool) -> Image {
        Image("\(Self.imageAssetPrefix)/\(imageAssetName)-\(thumbnail ? "thumb" : "full")", bundle: .module)
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


public extension Donut.Dough {
    public var backgroundColor: Color {
        Color("\(Self.imageAssetPrefix)/\(imageAssetName)-bg", bundle: .module)
    }
}

public extension Donut {
    static let classic = Donut(
        id: 0,
        name: String(localized: "The Classic", bundle: .module, comment: "A donut-flavor name."),
        dough: .plain,
        glaze: .chocolate,
        topping: .sprinkles
    )

    static let blueberryFrosted = Donut(
        id: 1,
        name: String(localized: "Blueberry Frosted", bundle: .module, comment: "A donut-flavor name."),
        dough: .blueberry,
        glaze: .blueberry,
        topping: .sugarLattice
    )

    static let strawberryDrizzle = Donut(
        id: 2,
        name: String(localized: "Strawberry Drizzle", bundle: .module, comment: "A donut-flavor name."),
        dough: .strawberry,
        glaze: .strawberry,
        topping: .sugarDrizzle
    )

    static let cosmos = Donut(
        id: 3,
        name: String(localized: "Cosmos", bundle: .module, comment: "A donut-flavor name."),
        dough: .chocolate,
        glaze: .chocolate,
        topping: .starSprinkles
    )

    static let strawberrySprinkles = Donut(
        id: 4,
        name: String(localized: "Strawberry Sprinkles", bundle: .module, comment: "A donut-flavor name."),
        dough: .plain,
        glaze: .strawberry,
        topping: .starSprinkles
    )

    static let lemonChocolate = Donut(
        id: 5,
        name: String(localized: "Lemon Chocolate", bundle: .module, comment: "A donut-flavor name."),
        dough: .plain,
        glaze: .chocolate,
        topping: .lemonLines
    )

    static let rainbow = Donut(
        id: 6,
        name: String(localized: "Rainbow", bundle: .module, comment: "A donut-flavor name."),
        dough: .plain,
        glaze: .rainbow
    )

    static let picnicBasket = Donut(
        id: 7,
        name: String(localized: "Picnic Basket", bundle: .module, comment: "A donut-flavor name."),
        dough: .chocolate,
        glaze: .strawberry,
        topping: .blueberryLattice
    )

    static let figureSkater = Donut(
        id: 8,
        name: String(localized: "Figure Skater", bundle: .module, comment: "A donut-flavor name."),
        dough: .plain,
        glaze: .blueberry,
        topping: .sugarDrizzle
    )

    static let powderedChocolate = Donut(
        id: 9,
        name: String(localized: "Powdered Chocolate", bundle: .module, comment: "A donut-flavor name."),
        dough: .chocolate,
        topping: .powderedSugar
    )

    static let powderedStrawberry = Donut(
        id: 10,
        name: String(localized: "Powdered Strawberry", bundle: .module, comment: "A donut-flavor name."),
        dough: .strawberry,
        topping: .powderedSugar
    )

    static let custard = Donut(
        id: 11,
        name: String(localized: "Custard", bundle: .module, comment: "A donut-flavor name."),
        dough: .lemonade,
        glaze: .spicy,
        topping: .lemonLines
    )

    static let superLemon = Donut(
        id: 12,
        name: String(localized: "Super Lemon", bundle: .module, comment: "A donut-flavor name."),
        dough: .lemonade,
        glaze: .lemon,
        topping: .sprinkles
    )

    static let fireZest = Donut(
        id: 13,
        name: String(localized: "Fire Zest", bundle: .module, comment: "A donut-flavor name."),
        dough: .lemonade,
        glaze: .spicy,
        topping: .spicySauceDrizzle
    )

    static let blackRaspberry = Donut(
        id: 14,
        name: String(localized: "Black Raspberry", bundle: .module, comment: "A donut-flavor name."),
        dough: .plain,
        glaze: .chocolate,
        topping: .blueberryDrizzle
    )

    static let daytime = Donut(
        id: 15,
        name: String(localized: "Daytime", bundle: .module, comment: "A donut-flavor name."),
        dough: .lemonade,
        glaze: .rainbow
    )

    static let nighttime = Donut(
        id: 16,
        name: String(localized: "Nighttime", bundle: .module, comment: "A donut-flavor name."),
        dough: .chocolate,
        glaze: .chocolate,
        topping: .chocolateDrizzle
    )

    static let all = [
        classic, blueberryFrosted, strawberryDrizzle, cosmos, strawberrySprinkles, lemonChocolate, rainbow, picnicBasket, figureSkater,
        powderedChocolate, powderedStrawberry, custard, superLemon, fireZest, blackRaspberry, daytime, nighttime
    ]

    static var preview: Donut { .classic }
}

public extension DonutSales {
    static var previewArray: [DonutSales] = [
        .init(donut: .classic, sales: 5),
        .init(donut: .picnicBasket, sales: 3),
        .init(donut: .strawberrySprinkles, sales: 10),
        .init(donut: .nighttime, sales: 4),
        .init(donut: .blackRaspberry, sales: 12)
    ]
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
