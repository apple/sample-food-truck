/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The sales history view.
*/

import SwiftUI
import FoodTruckKit

struct SalesHistoryView: View {
    @ObservedObject var model: FoodTruckModel
    @ObservedObject private var storeController = StoreActor.shared.productController
    
    @SceneStorage("historyTimeframe") private var timeframe: Timeframe = .week
    
    var annualHistoryIsUnlocked: Bool {
        storeController.isEntitled
    }
    
    var hideChartContent: Bool {
        timeframe != .week && !annualHistoryIsUnlocked
    }
    
    var body: some View {
        ScrollView {
            VStack {
                VStack(alignment: .leading) {
                    Picker("Timeframe", selection: $timeframe) {
                        Label("2 Weeks", systemImage: "calendar")
                            .tag(Timeframe.week)
                        
                        Label("Month", systemImage: annualHistoryIsUnlocked ? "calendar" : "lock")
                            .tag(Timeframe.month)
                        
                        Label("Year", systemImage: annualHistoryIsUnlocked ? "calendar" : "lock")
                            .tag(Timeframe.year)
                    }
                    .pickerStyle(.segmented)
                    .padding(.bottom, 10)
                    
                    Text("Total Sales")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text("\(totalSales.formatted()) Donuts")
                        .font(.headline)
                    
                    SalesHistoryChart(salesByCity: sales, hideChartContent: hideChartContent)
                        .chartPlotStyle { content in
                            content.chartOverlay { proxy in
                                if hideChartContent {
                                    HStack {
                                        Image(systemName: "lock")
                                        Text("Premium Feature")
                                    }
                                    .foregroundColor(.secondary)
                                    .padding(20)
                                    .background(.background.shadow(.drop(color: .black.opacity(0.15), radius: 6, y: 2)), in: Capsule())
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .background(.quaternary)
                                }
                            }
                        }
                        .frame(minHeight: 300)
                }
                .padding()
                UnlockFeatureView(controller: storeController)
            }
        }
        .navigationTitle("Sales History")
        .background()
    }
    
    var totalSales: Int {
        sales.flatMap(\.entries).reduce(into: 0) { (partialResult, entry) in
            partialResult += entry.sales
        }
    }
    
    var sales: [SalesByCity] {
        func dateComponents(_ offset: Int) -> DateComponents {
            switch timeframe {
            case .today:
                fatalError("Today timeframe is not supported.")
            case .week:
                return DateComponents(day: offset)
            case .month:
                return DateComponents(day: offset)
            case .year:
                return DateComponents(month: offset)
            }
        }
        return City.all.map { city in
            let summaries: [OrderSummary]
            switch timeframe {
            case .today:
                fatalError()
                
            case .week:
                summaries = Array(model.dailyOrderSummaries(cityID: city.id).prefix(14))
                
            case .month:
                summaries = Array(model.dailyOrderSummaries(cityID: city.id).prefix(30))
                
            case .year:
                summaries = model.monthlyOrderSummaries(cityID: city.id)
            }
            let entries = summaries
                .enumerated()
                .map { (offset, summary) in
                    let startDate: Date
                    if timeframe == .month || timeframe == .year {
                        let components = Calendar.current.dateComponents([.year, .month], from: .now)
                        startDate = Calendar.current.date(from: components)!
                    } else {
                        let components = Calendar.current.dateComponents([.year, .month, .day], from: .now)
                        startDate = Calendar.current.date(from: components)!
                    }
                    
                    let date = Calendar.current.date(byAdding: dateComponents(-offset), to: startDate)!
                    return SalesByCity.Entry(date: date, sales: summary.totalSales)
                }
            
            return SalesByCity(city: city, entries: entries)
        }
    }
}

struct StatisticsView_Previews: PreviewProvider {
    
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
