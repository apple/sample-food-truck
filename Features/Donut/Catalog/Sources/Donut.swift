/*
 See the LICENSE.txt file for this sample’s licensing information.

 Abstract:
 The donut model object.
 */

import Decide
import Foundation

public final class Donut: KeyedState<Donut.ID> {
    public typealias ID = UUID

    @Property public var name: String = "Donut hole"
    @Property public var dough: Ingridient.ID?
    @Property public var glaze: Ingridient.ID?
    @Property public var topping: Ingridient.ID?

    // Computed: ingridients
    //        public var ingredients: [any Ingredient] {
    //            var result: [any Ingredient] = []
    //            result.append(dough)
    //            if let glaze = glaze {
    //                result.append(glaze)
    //            }
    //            if let topping = topping {
    //                result.append(topping)
    //            }
    //            return result
    //        }
    // Computed: flavors
    //        public var flavors: FlavorProfile {
    //            ingredients
    //                .map(\.flavors)
    //                .reduce(into: FlavorProfile()) { partialResult, next in
    //                    partialResult.formUnion(with: next)
    //                }
    //        }


    // Computed: searchResults:
    //        public func matches(searchText: String) -> Bool {
    //            if searchText.isEmpty {
    //                return true
    //            }
    //
    //            if name.localizedCaseInsensitiveContains(searchText) {
    //                return true
    //            }
    //
    //            return ingredients.contains { ingredient in
    //                ingredient.name.localizedCaseInsensitiveContains(searchText)
    //            }
    //        }
}

