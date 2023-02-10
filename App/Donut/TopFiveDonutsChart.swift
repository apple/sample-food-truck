/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A container view for the "Top Five Chart" view.
*/

import SwiftUI
import FoodTruckKit

struct TopFiveDonutsChart: View {
    @ObservedObject var model: FoodTruckModel
    var timeframe: Timeframe
    
    var topSales: [DonutSales] {
        Array(model.donutSales(timeframe: timeframe).sorted().reversed().prefix(5))
    }
    
    var body: some View {
        TopDonutSalesChart(sales: topSales)
    }
}

struct TopFiveDonutsChart_Previews: PreviewProvider {
    struct Preview: View {
        var timeframe: Timeframe
        @StateObject private var model = FoodTruckModel()
        
        var body: some View {
            TopFiveDonutsChart(model: model, timeframe: timeframe)
        }
    }
    static var previews: some View {
        Preview(timeframe: .today)
            .previewDisplayName("Today")
        Preview(timeframe: .week)
            .previewDisplayName("Week")
        Preview(timeframe: .month)
            .previewDisplayName("Month")
        Preview(timeframe: .year)
            .previewDisplayName("Year")
    }
}
