/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The order summary model.
*/

import Foundation

public struct OrderSummary {
    public var sales: [Donut.ID: Int]
    public var totalSales: Int
    
    public init(sales: [Donut.ID: Int]) {
        self.sales = sales
        self.totalSales = sales.map(\.value).reduce(0, +)
    }
    
    public func union(_ other: OrderSummary) -> Self {
        var copy = self
        for donutID in Set(copy.sales.keys).union(Set(other.sales.keys)) {
            copy.sales[donutID, default: 0] += other.sales[donutID, default: 0]
        }
        copy.totalSales += other.totalSales
        return copy
    }
    
    public mutating func formUnion(_ other: OrderSummary) {
        self = union(other)
    }
    
    public func union(_ order: Order) -> Self {
        var copy = self
        for donutID in Set(copy.sales.keys).union(Set(order.sales.keys)) {
            copy.sales[donutID, default: 0] += order.sales[donutID, default: 0]
        }
        copy.totalSales += order.totalSales
        return copy
    }
    
    public mutating func formUnion(_ order: Order) {
        self = union(order)
    }
    
    public static let empty = OrderSummary(sales: [:])
}
