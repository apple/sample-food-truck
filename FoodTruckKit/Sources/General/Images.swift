/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
Image extension to integrate the custom flavor symbols.
*/

import SwiftUI

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
