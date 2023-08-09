/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A donut stack view using a layout.
*/

import SwiftUI

public struct DonutStackView: View {
    var donuts: [Donut]
    var includeOverflowCount: Bool
    
    public init(donuts: [Donut], includeOverflowCount: Bool = false) {
        self.donuts = donuts
        self.includeOverflowCount = includeOverflowCount
    }

    public var body: some View {
        DiagonalDonutStackLayout {
            ForEach(donuts.prefix(3)) { donut in
                DonutView(donut: donut)
            }
        }
        .overlay(alignment: .bottomTrailing) {
            let extra = donuts.count - 3
            if extra > 0 && includeOverflowCount {
                Text("+\(extra)")
                    .foregroundStyle(.secondary)
                    .font(.caption2)
                    .padding(4)
                    #if !os(watchOS)
                    .background(.thinMaterial, in: Capsule())
                    #else
                    .background(in: Capsule())
                    #endif
                    .padding(4)
            }
        }
    }
}

struct DonutStackView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Group {
                DonutStackView(donuts: [.classic])
                DonutStackView(donuts: [.classic, .cosmos])
                DonutStackView(donuts: [.classic, .cosmos, .rainbow])
                DonutStackView(donuts: [.classic, .cosmos, .rainbow, .classic, .classic, .classic], includeOverflowCount: true)
            }
            .frame(width: 120, height: 120)
            .border(.quaternary)
        }
        .padding()
    }
}
