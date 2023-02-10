/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
Defines the live activity attributes.
*/

#if canImport(ActivityKit)
import Foundation
import ActivityKit
import FoodTruckKit

struct TruckActivityAttributes: ActivityAttributes {
    public typealias MyActivityStatus = ContentState
    
    public struct ContentState: Codable, Hashable {
        var timerRange: ClosedRange<Date>
    }
    
    var orderID: String
    var order: [Donut.ID]
    var sales: [Donut.ID: Int]
    var activityName: String
}
#endif
