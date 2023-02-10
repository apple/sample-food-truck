/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The order generator that simulates order coming in.
*/

import Foundation

// A value closer to 1.0 dramatically reduces how many sales the next donut sells when sorted by popularity.
private let exponentialDonutCountFalloff: Double = 0.15
private let mostPopularDonutCountPerDayCount = 80.0 ... 120.0

struct OrderGenerator {
    var knownDonuts: [Donut]
    
    struct RandomInfo {
        var multiplier: Double
        var seed: Int
    }
    
    var seeds: [City.ID: RandomInfo] = [
        City.cupertino.id: RandomInfo(multiplier: 0.5, seed: 1),
        City.sanFrancisco.id: RandomInfo(multiplier: 1, seed: 2),
        City.london.id: RandomInfo(multiplier: 0.75, seed: 3)
    ]
    
    func todaysOrders() -> [Order] {
        // Generate current orders for today
        let startingDate = Date.now
        var generator = SeededRandomGenerator(seed: 1)
        var previousOrderTime = startingDate.addingTimeInterval(-60 * 4)
        let totalOrders = 24
        return (0 ..< totalOrders).map { index in
            previousOrderTime -= .random(in: 60 ..< 180, using: &generator)
            
            var order = generateOrder(number: totalOrders - index, date: previousOrderTime, generator: &generator)
            let isReady = index > 8
            order.status = isReady ? .ready : .placed
            order.completionDate = isReady ? min(previousOrderTime + (14 * 60), Date.now) : nil
            return order
        }
    }
    
    func generateOrder(number: Int, date: Date) -> Order {
        var generator = SystemRandomNumberGenerator()
        return generateOrder(number: number, date: date, generator: &generator)
    }
    
    func generateOrder(number: Int, date: Date, generator: inout some RandomNumberGenerator) -> Order {
        let donuts = knownDonuts.shuffled(using: &generator).prefix(.random(in: 1 ... 5, using: &generator))
        let sales: [Donut.ID: Int] = Dictionary(uniqueKeysWithValues: donuts.map {
            (key: $0.id, value: Int.random(in: 1 ... 5, using: &generator))
        })
        let totalSales = sales.map(\.value).reduce(0, +)
        return Order(
            id: String(localized: "Order") + String(localized: ("#\(12)\(number, specifier: "%02d")")),
            status: .placed,
            donuts: Array(donuts),
            sales: sales,
            grandTotal: Decimal(totalSales) * 5.78,
            city: City.cupertino.id,
            parkingSpot: City.cupertino.parkingSpots[0].id,
            creationDate: date,
            completionDate: nil,
            temperature: .init(value: 72, unit: .fahrenheit),
            wasRaining: false
        )
    }
    
    func historicalDailyOrders(since date: Date, cityID: City.ID) -> [OrderSummary] {
        guard let randomInfo = seeds[cityID] else {
            fatalError("No random info found for City ID \(cityID)")
        }
        var generator = SeededRandomGenerator(seed: randomInfo.seed)
        var previousSales: [Donut.ID: Int]?
        let donuts = knownDonuts.shuffled(using: &generator)
        return Array((1...60).reversed().map { (daysAgo: Int) in
            let startDate = Calendar.current.startOfDay(for: .now)
            let day = Calendar.current.date(byAdding: DateComponents(day: -daysAgo), to: startDate)!
            let dayMultiplier = Calendar.current.isDateInWeekend(day) ? 1.25 : 1
            let orderCount = Double.random(in: mostPopularDonutCountPerDayCount, using: &generator)
            let maxDonutCount = orderCount * .random(in: 0.75 ... 1.1, using: &generator)
            var sales: [Donut.ID: Int] = Dictionary(uniqueKeysWithValues: donuts.enumerated().map {
                offset, donut in
                // This value starts at 1 for the most popular donut and dramatically decreases towards 0 by the time
                // we reach the least popular donut.
                let percent: Double = 1 - pow(Double(offset) / Double(knownDonuts.count), exponentialDonutCountFalloff)
                // To make the data more interesting, we throw in a bit of randomness to make it not perfectly match an
                // exponential falloff.
                let variance: Double = .random(in: 0.9...1.0, using: &generator)
                let result = Int(maxDonutCount * percent * variance * randomInfo.multiplier * dayMultiplier)
                return (key: donut.id, value: max(result, 0))
            })
            if let previousSales = previousSales {
                for (donutID, count) in sales {
                    if let previousSaleCount = previousSales[donutID] {
                        sales[donutID] = Int(Double(count).interpolate(to: Double(previousSaleCount), percent: 0.5))
                    }
                }
            }
            previousSales = sales
            return OrderSummary(sales: sales)
        })
    }
    
    func historicalMonthlyOrders(since date: Date, cityID: City.ID) -> [OrderSummary] {
        guard let randomInfo = seeds[cityID] else {
            fatalError("No random info found for City ID \(cityID)")
        }
        var generator = SeededRandomGenerator(seed: randomInfo.seed)
        var previousSales: [Donut.ID: Int]?
        let donuts = knownDonuts.shuffled(using: &generator)
        return Array((0...12).reversed().map { monthsAgo in
            let orderCount = Double.random(in: mostPopularDonutCountPerDayCount, using: &generator) * 30
            let maxDonutCount = orderCount * .random(in: 0.75 ... 1.1, using: &generator)
            var sales: [Donut.ID: Int] = Dictionary(uniqueKeysWithValues: donuts.enumerated().map { offset, donut in
                // This value starts at 1 for the most popular donut and quickly decreases towards 0 by the time we reach the least popular donut.
                let percent: Double = 1 - pow(Double(offset) / Double(knownDonuts.count), exponentialDonutCountFalloff)
                // To make the data more interesting, we throw in a bit of randomness to make it not perfectly match an exponential falloff.
                let variance: Double = .random(in: 0.9...1.0, using: &generator)
                let result = Int(maxDonutCount * percent * variance * randomInfo.multiplier)
                return (key: donut.id, value: max(result, 0))
            })
            if let previousSales = previousSales {
                for (donutID, count) in sales {
                    if let previousSaleCount = previousSales[donutID] {
                        sales[donutID] = Int(Double(count).interpolate(to: Double(previousSaleCount), percent: 0.25))
                    }
                }
            }
            previousSales = sales
            return OrderSummary(sales: sales)
        })
    }
    
    struct SeededRandomGenerator: RandomNumberGenerator {
        init(seed: Int) {
            srand48(seed)
        }
        
        func next() -> UInt64 {
            UInt64(drand48() * Double(UInt64.max))
        }
    }
}
