/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The "Top Five Donuts" view.
*/

import Charts
import SwiftUI
import FoodTruckKit
import AppIntents

struct TopFiveDonutsView: View {
    @ObservedObject var model: FoodTruckModel
    @State private var timeframe: Timeframe = .week
    
    let today = Calendar.current.startOfDay(for: .now)
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Picker("Timeframe", selection: $timeframe) {
                    Text("Day")
                        .tag(Timeframe.today)
                    Text("Week")
                        .tag(Timeframe.week)
                    Text("Month")
                        .tag(Timeframe.month)
                    Text("Year")
                        .tag(Timeframe.year)
                }
                .pickerStyle(.segmented)
                .padding(.bottom, 10)
                
                TopFiveDonutsChart(model: model, timeframe: timeframe)
                
                #if os(iOS)
                SiriTipView(intent: ShowTopDonutsIntent(timeframe: timeframe))
                    .padding(.top, 20)
                #endif
            }
            .padding()
        }
        .navigationTitle("Top 5 Donuts")
        .background()
    }
}

struct TopFiveDonutsView_Previews: PreviewProvider {
    struct Preview: View {
        @StateObject private var model = FoodTruckModel()
        var body: some View {
            TopFiveDonutsView(model: model)
        }
    }
    static var previews: some View {
        NavigationStack {
            Preview()
        }
    }
}

