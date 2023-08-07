/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The donut model object.
*/

import UniformTypeIdentifiers

public struct Donut: Identifiable, Hashable {
    public var id: Int
    public var name: String
    
    public var dough: Dough
    public var glaze: Glaze?
    public var topping: Topping?
    
    public init(id: Int, name: String, dough: Donut.Dough, glaze: Donut.Glaze? = nil, topping: Donut.Topping? = nil) {
        self.id = id
        self.name = name
        self.dough = dough
        self.glaze = glaze
        self.topping = topping
    }
    
    public var ingredients: [any Ingredient] {
        var result: [any Ingredient] = []
        result.append(dough)
        if let glaze = glaze {
            result.append(glaze)
        }
        if let topping = topping {
            result.append(topping)
        }
        return result
    }

    public var flavors: FlavorProfile {
        ingredients
            .map(\.flavors)
            .reduce(into: FlavorProfile()) { partialResult, next in
                partialResult.formUnion(with: next)
            }
    }
    
    public func matches(searchText: String) -> Bool {
        if searchText.isEmpty {
            return true
        }
        
        if name.localizedCaseInsensitiveContains(searchText) {
            return true
        }
        
        return ingredients.contains { ingredient in
            ingredient.name.localizedCaseInsensitiveContains(searchText)
        }
    }
}

public extension UTType {
    static let donut = UTType(exportedAs: "com.example.apple-samplecode.donut")
}
