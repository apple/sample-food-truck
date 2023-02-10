/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The "Show Top Donuts Intent" view.
*/

import SwiftUI
import FoodTruckKit

struct ShowTopDonutsIntentView: View {
    var timeframe: Timeframe
    @StateObject private var model = FoodTruckModel()
    
    var body: some View {
        TopFiveDonutsChart(model: model, timeframe: timeframe)
            .padding()
    }
}

struct TopFiveDonutsIntentView_Previews: PreviewProvider {
    static var previews: some View {
        ShowTopDonutsIntentView(timeframe: .week)
    }
}
