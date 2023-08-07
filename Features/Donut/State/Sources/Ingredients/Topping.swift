/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
An extension to donut to represent the topping.
*/

public extension Donut {
    struct Topping: Ingredient {
        public var id: String { name }
        public var name: String
        public var imageAssetName: String
        public var flavors: FlavorProfile
        
        public static let imageAssetPrefix = "topping"

        public init(name: String, imageAssetName: String, flavors: FlavorProfile) {
            self.name = name
            self.imageAssetName = imageAssetName
            self.flavors = flavors
        }
    }
}
