/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
Renders donuts into images.
*/

import SwiftUI

public struct DonutRenderer: View {
    static private var thumbnails = [Donut.ID: Image]()

    var donut: Donut
    
    public init(donut: Donut) {
        self.donut = donut
    }

    @State private var imageIsReady = false
    @Environment(\.displayScale) private var displayScale

    public var body: some View {
        ZStack {
            if imageIsReady {
                Self.thumbnails[donut.id]!
                    .resizable()
                    .interpolation(.medium)
                    .antialiased(true)
                    .scaledToFit()
            } else {
                ProgressView()
                    .controlSize(.small)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .onAppear {
            imageIsReady = Self.thumbnails.keys.contains(donut.id)
            guard !imageIsReady else {
                return
            }
            let renderer = ImageRenderer(content: DonutView(donut: donut))
            renderer.proposedSize = ProposedViewSize(width: donutThumbnailSize, height: donutThumbnailSize)
            renderer.scale = displayScale
            if let cgImage = renderer.cgImage {
                let image = Image(cgImage, scale: displayScale, label: Text(donut.name))
                Self.thumbnails[donut.id] = image
                imageIsReady = true
            }
        }
    }
}

struct DonutRenderer_Previews: PreviewProvider {
    static var previews: some View {
        DonutRenderer(donut: .preview)
    }
}
