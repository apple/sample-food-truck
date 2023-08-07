/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The ingredient model object.
*/

public protocol Ingredient: Identifiable, Hashable {
    var id: String { get }
    var name: String { get }
    var flavors: FlavorProfile { get }
    var imageAssetName: String { get }
    static var imageAssetPrefix: String { get }
}
