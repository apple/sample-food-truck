/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The header view for the cards in the Truck view.
*/

import SwiftUI

struct CardNavigationHeader<Label: View>: View {
    var panel: Panel
    var navigation: TruckCardHeaderNavigation
    @ViewBuilder var label: Label
    
    var body: some View {
        HStack {
            switch navigation {
            case .navigationLink:
                NavigationLink(value: panel) {
                    label
                }
            case .selection(let selection):
                Button {
                    selection.wrappedValue = panel
                } label: {
                    label
                }
            }
            
            Spacer()
        }
        .buttonStyle(.borderless)
        .labelStyle(.cardNavigationHeader)
    }
}

struct CardNavigationHeader_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CardNavigationHeader(panel: .orders, navigation: .navigationLink) {
                Label("Orders", systemImage: "shippingbox")
            }
            .padding()
        }
    }
}
