/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A donut view.
*/

import SwiftUI

public let donutThumbnailSize: Double = 128

public struct DonutView: View {
    var donut: Donut
    var visibleLayers: DonutLayer = .all

    public init(donut: Donut, visibleLayers: DonutLayer = .all) {
        self.donut = donut
        self.visibleLayers = visibleLayers
    }
    
    public var body: some View {
        GeometryReader { proxy in
            let useThumbnail = min(proxy.size.width, proxy.size.height) <= donutThumbnailSize

            ZStack {
                if visibleLayers.contains(.dough) {
                    donut.dough.image(thumbnail: useThumbnail)
                        .resizable()
                        .interpolation(.medium)
                        .scaledToFit()
                        .id(donut.dough.id)
                }

                if let glaze = donut.glaze, visibleLayers.contains(.glaze) {
                    glaze.image(thumbnail: useThumbnail)
                        .resizable()
                        .interpolation(.medium)
                        .scaledToFit()
                        .id(glaze.id)
                }

                if let topping = donut.topping, visibleLayers.contains(.topping) {
                    topping.image(thumbnail: useThumbnail)
                        .resizable()
                        .interpolation(.medium)
                        .scaledToFit()
                        .id(topping.id)
                }
            }
            .aspectRatio(1, contentMode: .fit)
            .compositingGroup()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

public struct DonutLayer: OptionSet {
    public var rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public static let dough = DonutLayer(rawValue: 1 << 1)
    public static let glaze = DonutLayer(rawValue: 1 << 2)
    public static let topping = DonutLayer(rawValue: 1 << 3)
    
    public static let all: DonutLayer = [dough, glaze, topping]
}

struct DonutCanvas_Previews: PreviewProvider {
    static var previews: some View {
        DonutView(donut: .preview)
    }
}
