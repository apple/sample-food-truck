/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The ingredient model object.
*/

import SwiftUI

public protocol Ingredient: Identifiable, Hashable {
    var id: String { get }
    var name: String { get }
    var flavors: FlavorProfile { get }
    var imageAssetName: String { get }
    static var imageAssetPrefix: String { get }
}

public extension Ingredient {
    var id: String { "\(Self.imageAssetPrefix)/\(name)" }
}

public extension Ingredient {
    func image(thumbnail: Bool) -> Image {
        Image("\(Self.imageAssetPrefix)/\(imageAssetName)-\(thumbnail ? "thumb" : "full")", bundle: .module)
    }
}
