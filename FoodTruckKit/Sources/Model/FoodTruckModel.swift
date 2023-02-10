/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The food truck model.
*/

import SwiftUI
import Combine

@MainActor
public class FoodTruckModel: ObservableObject {
    @Published public var truck = Truck()
    
    @Published public var orders: [Order] = []
    @Published public var donuts = Donut.all
    @Published public var newDonut: Donut
        
    var dailyOrderSummaries: [City.ID: [OrderSummary]] = [:]
    var monthlyOrderSummaries: [City.ID: [OrderSummary]] = [:]

    public init() {
        newDonut = Donut(
            id: Donut.all.count,
            name: String(localized: "New Donut", comment: "New donut-placeholder name."),
            dough: .plain,
            glaze: .chocolate,
            topping: .sprinkles
        )
        
        let orderGenerator = OrderGenerator(knownDonuts: donuts)
        orders = orderGenerator.todaysOrders()
        dailyOrderSummaries = Dictionary(uniqueKeysWithValues: City.all.map { city in
            (key: city.id, value: orderGenerator.historicalDailyOrders(since: .now, cityID: city.id))
        })
        monthlyOrderSummaries = Dictionary(uniqueKeysWithValues: City.all.map { city in
            (key: city.id, orderGenerator.historicalMonthlyOrders(since: .now, cityID: city.id))
        })
        Task(priority: .background) {
            var generator = OrderGenerator.SeededRandomGenerator(seed: 5)
            for _ in 0..<20 {
                try? await Task.sleep(nanoseconds: .secondsToNanoseconds(.random(in: 3 ... 8, using: &generator)))
                Task { @MainActor in
                    withAnimation(.spring(response: 0.4, dampingFraction: 1)) {
                        self.orders.append(orderGenerator.generateOrder(number: orders.count + 1, date: .now, generator: &generator))
                    }
                }
            }
        }
    }
    
    public func dailyOrderSummaries(cityID: City.ID) -> [OrderSummary] {
        guard let result = dailyOrderSummaries[cityID] else {
            fatalError("Unknown City ID or daily order summaries were not found for: \(cityID).")
        }
        return result
    }
    
    public func monthlyOrderSummaries(cityID: City.ID) -> [OrderSummary] {
        guard let result = monthlyOrderSummaries[cityID] else {
            fatalError("Unknown City ID or monthly order summaries were not found for: \(cityID).")
        }
        return result
    }
    
    public func donuts<S: Sequence>(fromIDs ids: S) -> [Donut] where S.Element == Donut.ID {
        ids.map { donut(id: $0) }
    }
    
    public func donutSales(timeframe: Timeframe) -> [DonutSales] {
        combinedOrderSummary(timeframe: timeframe).sales.map { (id, count) in
            DonutSales(donut: donut(id: id), sales: count)
        }
            
    }
    
    public func donuts(sortedBy sort: DonutSortOrder = .popularity(.month)) -> [Donut] {
        switch sort {
        case .popularity(let timeframe):
            return donutsSortedByPopularity(timeframe: timeframe)
        case .name:
            return donuts.sorted { $0.name.localizedCompare($1.name) == .orderedAscending }
        case .flavor(let flavor):
            return donuts.sorted {
                $0.flavors[flavor] > $1.flavors[flavor]
            }
        }
    }
    
    public func orderBinding(for id: Order.ID) -> Binding<Order> {
        Binding<Order> {
            guard let index = self.orders.firstIndex(where: { $0.id == id }) else {
                fatalError()
            }
            return self.orders[index]
        } set: { newValue in
            guard let index = self.orders.firstIndex(where: { $0.id == id }) else {
                fatalError()
            }
            return self.orders[index] = newValue
        }
    }
    
    public func orderSummaries(for cityID: City.ID, timeframe: Timeframe) -> [OrderSummary] {
        switch timeframe {
        case .today:
            return orders.map { OrderSummary(sales: $0.sales) }
            
        case .week:
            return Array(dailyOrderSummaries(cityID: cityID).prefix(7))
            
        case .month:
            return Array(dailyOrderSummaries(cityID: cityID).prefix(30))
            
        case .year:
            return monthlyOrderSummaries(cityID: cityID)
        }
    }
    
    public func combinedOrderSummary(timeframe: Timeframe) -> OrderSummary {
        switch timeframe {
        case .today:
            return orders.reduce(into: .empty) { partialResult, order in
                partialResult.formUnion(order)
            }
            
        case .week:
            return dailyOrderSummaries.values.reduce(into: .empty) { partialResult, summaries in
                summaries.prefix(7).forEach { day in
                    partialResult.formUnion(day)
                }
            }
            
        case .month:
            return dailyOrderSummaries.values.reduce(into: .empty) { partialResult, summaries in
                summaries.prefix(30).forEach { day in
                    partialResult.formUnion(day)
                }
            }
            
        case .year:
            return monthlyOrderSummaries.values.reduce(into: .empty) { partialResult, summaries in
                summaries.forEach { month in
                    partialResult.formUnion(month)
                }
            }
        }
    }
    
    func donutsSortedByPopularity(timeframe: Timeframe) -> [Donut] {
        let result = combinedOrderSummary(timeframe: timeframe).sales
            .sorted {
                if $0.value > $1.value {
                    return true
                } else if $0.value == $1.value {
                    return $0.key < $1.key
                } else {
                    return false
                }
            }
            .map {
                donut(id: $0.key)
            }
        return result
    }
    
    public func donut(id: Donut.ID) -> Donut {
        donuts[id]
    }
    
    public func donutBinding(id: Donut.ID) -> Binding<Donut> {
        Binding<Donut> {
            self.donuts[id]
        } set: { newValue in
            self.donuts[id] = newValue
        }
    }
    
    public func updateDonut(id: Donut.ID, to newValue: Donut) {
        donutBinding(id: id).wrappedValue = newValue
    }
    
    public func markOrderAsCompleted(id: Order.ID) {
        guard let index = orders.firstIndex(where: { $0.id == id }) else {
            return
        }
        orders[index].status = .completed
    }
    
    public var incompleteOrders: [Order] {
        orders.filter { $0.status != .completed }
    }
}

public enum DonutSortOrder: Hashable {
    case popularity(Timeframe)
    case name
    case flavor(Flavor)
}

public enum Timeframe: String, Hashable, CaseIterable, Sendable {
    case today
    case week
    case month
    case year
}

public extension FoodTruckModel {
    static let preview = FoodTruckModel()
}
