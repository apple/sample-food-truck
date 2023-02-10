/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The "Top Five Sales Chart" view.
*/

import SwiftUI
import Charts
import FoodTruckKit

struct TopDonutSalesChart: View {
    var sales: [DonutSales]
    
    var sortedSales: [DonutSales] {
        sales.sorted()
    }
    
    var totalSales: Int {
        sales.map(\.sales).reduce(0, +)
    }
        
    var body: some View {
        VStack(alignment: .leading) {
            Text("Total Sales")
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text("\(totalSales.formatted()) Donuts")
                .font(.headline)
            
            chart
        }
    }
    
    var chart: some View {
        Chart {
            ForEach(sortedSales) { sale in
                BarMark(
                    x: .value("Donut", sale.donut.name),
                    y: .value("Sales", sale.sales)
                )
                .cornerRadius(6, style: .continuous)
                .foregroundStyle(.linearGradient(colors: [Color("BarBottomColor"), .accentColor], startPoint: .bottom, endPoint: .top))
                .annotation(position: .top, alignment: .top) {
                    Text(sale.sales.formatted())
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .background(.quaternary.opacity(0.5), in: Capsule())
                        .background(in: Capsule())
                        .font(.caption)
                }
            }
        }
        .chartYAxis {
            AxisMarks { value in
                AxisGridLine()
                AxisTick()
                AxisValueLabel(format: IntegerFormatStyle<Int>())
            }
        }
        .chartXAxis {
            AxisMarks { value in
                AxisValueLabel {
                    let donut = donutFromAxisValue(for: value)
                    VStack {
                        DonutView(donut: donut)
                            .frame(height: 35)
                            
                        Text(donut.name)
                            .lineLimit(2, reservesSpace: true)
                            .multilineTextAlignment(.center)
                    }
                    .frame(idealWidth: 80)
                    .padding(.horizontal, 4)
                    
                }
            }
        }
        .frame(height: 300)
        .padding(.top, 20)
    }
    
    func donutFromAxisValue(for value: AxisValue) -> Donut {
        guard let name = value.as(String.self) else {
            fatalError("Could not convert axis value to expected String type")
        }
        guard let result = sales.first(where: { $0.donut.name == name }) else {
            fatalError("No top performing DonutSales with given donut name: \(name)")
        }
        return result.donut
    }
}

struct TopDonutSalesChart_Previews: PreviewProvider {
    static var previews: some View {
        TopDonutSalesChart(sales: Array(DonutSales.previewArray.prefix(5)))
            .padding()
            .previewLayout(.sizeThatFits)
    }
}

