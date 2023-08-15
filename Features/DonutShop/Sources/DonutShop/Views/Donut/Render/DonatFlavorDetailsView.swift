//
//  DonatFlavorDetailsView.swift
//  
//
//  Created by Anton Kolchunov on 11.08.23.
//

import Foundation
import SwiftUI

struct DonatFlavorDetailsView: View {

    var mostPotentFlavor: (Flavor, Int)
    var flavors: FlavorProfile

    var body: some View {
        Grid {
            let (topFlavor, topFlavorValue) = mostPotentFlavor
            ForEach(Flavor.allCases) { flavor in
                let isTopFlavor = topFlavor == flavor
                let flavorValue = max(flavors[flavor], 0)
                GridRow {
                    flavor.image
                        .foregroundStyle(isTopFlavor ? .primary : .secondary)

                    Text(flavor.name)
                        .gridCellAnchor(.leading)
                        .foregroundStyle(isTopFlavor ? .primary : .secondary)

                    Gauge(value: Double(flavorValue), in: 0...Double(topFlavorValue)) {
                        EmptyView()
                    }
                    .tint(isTopFlavor ? Color.accentColor : Color.secondary)
                    .labelsHidden()

                    Text(flavorValue.formatted())
                        .gridCellAnchor(.trailing)
                        .foregroundStyle(isTopFlavor ? .primary : .secondary)
                }
            }
        }
    }
}

struct DonutFlavorDetailsPreview: PreviewProvider {
    static var previews: some View {
        Form {
            DonatFlavorDetailsView(
                mostPotentFlavor: (.sweet, 10),
                flavors: FlavorProfile(
                    salty: 1,
                    sweet: 10,
                    bitter: 2,
                    sour: 3,
                    savory: 4,
                    spicy: 5
                )
            )
        }
    }
}
