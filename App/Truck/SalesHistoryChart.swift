/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The sales history chart view.
*/

import SwiftUI
import Charts
import FoodTruckKit

struct SalesHistoryChart: View {
    var salesByCity: [SalesByCity]
    
    var hideChartContent: Bool = false
    
    var body: some View {
        Chart {
            ForEach(salesByCity) { citySales in
                ForEach(citySales.entries) { entry in
                    LineMark(
                        x: .value("Day", entry.date),
                        y: .value("Sales", entry.sales)
                    )
                    .foregroundStyle(by: .value("Location", citySales.city.name))
                    .interpolationMethod(.cardinal)
                    .symbol(by: .value("Location", citySales.city.name))
                    .opacity(hideChartContent ? 0 : 1)
                }
                .lineStyle(StrokeStyle(lineWidth: 2))
            }
        }
        .chartLegend(position: .top)
        .chartYScale(domain: .automatic(includesZero: false))
        .chartXAxis {
            AxisMarks(values: .automatic(roundLowerBound: false, roundUpperBound: false)) { value in
                if value.index < value.count - 1 {
                    AxisValueLabel()
                }
                AxisTick()
                AxisGridLine()
            }
        }
    }
}

struct SalesByCity: Identifiable {
    var id: String { city.id }
    var city: City
    var entries: [Entry]
    
    struct Entry: Identifiable {
        var id: Date { date }
        var date: Date
        var sales: Int
    }
}

struct SalesHistoryChart_Previews: PreviewProvider {
    struct Preview: View {
        @StateObject private var model = FoodTruckModel()
        var body: some View {
            SalesHistoryView(model: model)
        }
    }
    static var previews: some View {
        NavigationStack {
            Preview()
        }
    }
}
